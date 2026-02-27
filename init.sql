-- =============================================================================
-- Trust Graph Engine — PostgreSQL schema
-- Ajetaan automaattisesti ensimmäisellä docker-compose up -komennolla
-- =============================================================================

-- Palvelimet
CREATE TABLE IF NOT EXISTS mcp_servers (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name        TEXT NOT NULL UNIQUE,
    transport   TEXT NOT NULL CHECK (transport IN ('sse', 'stdio', 'docker', 'http')),
    url         TEXT,
    image       TEXT,
    command     TEXT,
    args        JSONB DEFAULT '[]',
    created_at  TIMESTAMPTZ DEFAULT NOW(),
    updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- Luottamuspisteet palvelimille
CREATE TABLE IF NOT EXISTS trust_scores (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    server_id   UUID NOT NULL REFERENCES mcp_servers(id) ON DELETE CASCADE,
    score       NUMERIC(4,3) NOT NULL DEFAULT 1.000 CHECK (score BETWEEN 0 AND 1),
    calls_total INTEGER NOT NULL DEFAULT 0,
    calls_ok    INTEGER NOT NULL DEFAULT 0,
    calls_fail  INTEGER NOT NULL DEFAULT 0,
    avg_ms      INTEGER NOT NULL DEFAULT 0,
    updated_at  TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(server_id)
);

-- Yksittäiset työkutsujen tulokset (attestaatiot)
CREATE TABLE IF NOT EXISTS tool_attestations (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    server_id   UUID NOT NULL REFERENCES mcp_servers(id) ON DELETE CASCADE,
    tool_name   TEXT NOT NULL,
    success     BOOLEAN NOT NULL,
    duration_ms INTEGER NOT NULL,
    error_code  TEXT,
    created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- Sessiot
CREATE TABLE IF NOT EXISTS sessions (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    data        JSONB NOT NULL DEFAULT '{}',
    servers     JSONB NOT NULL DEFAULT '[]',
    created_at  TIMESTAMPTZ DEFAULT NOW(),
    expires_at  TIMESTAMPTZ DEFAULT NOW() + INTERVAL '30 days'
);

-- Indeksit
CREATE INDEX IF NOT EXISTS idx_attestations_server ON tool_attestations(server_id);
CREATE INDEX IF NOT EXISTS idx_attestations_created ON tool_attestations(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_sessions_expires ON sessions(expires_at);

-- Päivitä trust score automaattisesti kun uusi attestaatio lisätään
CREATE OR REPLACE FUNCTION update_trust_score()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO trust_scores (server_id, calls_total, calls_ok, calls_fail, score, avg_ms)
    SELECT
        NEW.server_id,
        COUNT(*),
        COUNT(*) FILTER (WHERE success),
        COUNT(*) FILTER (WHERE NOT success),
        -- Pistytys: onnistumisprosentti * nopeusbonuus
        ROUND(
            (COUNT(*) FILTER (WHERE success)::NUMERIC / NULLIF(COUNT(*), 0))
            * CASE WHEN AVG(duration_ms) < 500 THEN 1.0
                   WHEN AVG(duration_ms) < 2000 THEN 0.95
                   ELSE 0.85 END,
            3
        ),
        AVG(duration_ms)::INTEGER
    FROM tool_attestations
    WHERE server_id = NEW.server_id
    ON CONFLICT (server_id) DO UPDATE SET
        calls_total = EXCLUDED.calls_total,
        calls_ok    = EXCLUDED.calls_ok,
        calls_fail  = EXCLUDED.calls_fail,
        score       = EXCLUDED.score,
        avg_ms      = EXCLUDED.avg_ms,
        updated_at  = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_update_trust
AFTER INSERT ON tool_attestations
FOR EACH ROW EXECUTE FUNCTION update_trust_score();

-- Siivoa vanhentuneet sessiot (voidaan ajaa cronilla)
CREATE OR REPLACE FUNCTION cleanup_expired_sessions()
RETURNS INTEGER AS $$
DECLARE deleted INTEGER;
BEGIN
    DELETE FROM sessions WHERE expires_at < NOW();
    GET DIAGNOSTICS deleted = ROW_COUNT;
    RETURN deleted;
END;
$$ LANGUAGE plpgsql;
