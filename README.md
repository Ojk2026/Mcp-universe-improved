# 🌌 MCP UNIVERSE

> Maailman yksinkertaisin tapa yhdistää tekoäly kaikkiin MCP-palvelimiin.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![npm version](https://img.shields.io/npm/v/mcp-universe.svg)](https://www.npmjs.com/package/mcp-universe)
[![Docker](https://img.shields.io/badge/Docker-ready-2496ED?logo=docker)](docker-compose.yml)
[![CI](https://github.com/OJKotkaLKP/MCP-UNIVERSE-/actions/workflows/ci.yml/badge.svg)](https://github.com/OJKotkaLKP/MCP-UNIVERSE-/actions)

---

## Miksi MCP UNIVERSE?

| Ominaisuus | MCP UNIVERSE | MetaMCP | Smithery | Magg |
|---|---|---|---|---|
| JS SDK — 3 riviä | ✅ | ❌ | ❌ | ❌ |
| Yksi `docker-compose up` | ✅ | ⚠️ | ❌ | ❌ |
| Self-hosted | ✅ | ✅ | ❌ | ✅ |
| Visuaalinen playground | ✅ | ⚠️ | ✅ | ❌ |
| Luottamuspistytys | ✅ | ❌ | ❌ | ❌ |
| Sessioiden jako URL:lla | ✅ | ❌ | ❌ | ❌ |
| Ilmainen & avoin | ✅ | ✅ | ❌ | ✅ |

---

## ⚡ Quick Start — 60 sekuntia

### Vaihtoehto 1: JavaScript SDK

```bash
npm install mcp-universe
```

```javascript
import { MCPUniverse } from 'mcp-universe';

const universe = new MCPUniverse({ gateway: 'http://localhost:3000' });
const result = await universe.run('hae säätiedot Helsingistä');
console.log(result);
```

**Siinä kaikki.** Universe löytää oikeat työkalut automaattisesti.

---

### Vaihtoehto 2: Docker (koko järjestelmä)

```bash
git clone https://github.com/OJKotkaLKP/MCP-UNIVERSE-.git
cd MCP-UNIVERSE-
cp .env.example .env
docker-compose up -d
open http://localhost:8080
```

---

## 📦 JS SDK — kaikki ominaisuudet

### Asennus

```bash
npm install mcp-universe   # tai yarn / pnpm
```

### Perusyhteys

```javascript
import { MCPUniverse } from 'mcp-universe';

const universe = new MCPUniverse({
  gateway: 'http://localhost:3000',
  apiKey: 'optional-api-key',
});
```

### Lisää MCP-palvelin

```javascript
// SSE-palvelin
await universe.connect({ name: 'my-tools', transport: 'sse',
  url: 'https://my-server.com/sse' });

// STDIO (lokaalisti)
await universe.connect({ name: 'files', transport: 'stdio',
  command: 'npx', args: ['-y', '@modelcontextprotocol/server-filesystem', '/tmp'] });

// Docker
await universe.connect({ name: 'browser', transport: 'docker',
  image: 'mcp/playwright:latest' });
```

### Käyttö

```javascript
// Listaa kaikki saatavilla olevat työkalut luottamuspisteineen
const tools = await universe.tools();
// [{ name: 'read_file', server: 'files', trust: 0.98 }, ...]

// Aja työkalu suoraan
const result = await universe.call('read_file', { path: '/tmp/hello.txt' });

// Luonnollisella kielellä — Universe valitsee työkalut itse
const answer = await universe.run('lue /tmp/hello.txt ja tiivistä');

// Jaa sessio URL:lla
const { url } = await universe.session.save();
// https://your-instance/s/abc123
```

### TypeScript

```typescript
import { MCPUniverse, Tool, Session } from 'mcp-universe';
// Täysi tyyppituki automaattisesti
```

---

## 🏗️ Arkkitehtuuri

```
Internet  →  Frontend :8080 (ainoa julkinen portti)
                │
        ┌───────┴────────┐
        ▼                ▼
  Nexus Gateway    Session Manager
     (Rust)           (Flask)
        │                │
        └───────┬─────────┘
                │
        ┌───────┴────────┐
        ▼                ▼
    PostgreSQL          Redis
   (Trust Graph)     (Sessions)
```

---

## 🔒 Tietoturva

- Ei-root-käyttäjät kaikissa konteissa
- PostgreSQL ja Redis eivät julkisesti saatavilla
- Rate limiting kaikissa endpointeissa
- JWT-autentikointi gateway:ssa
- CSP, HSTS ja muut HTTP-tietoturvaheaderit

---

## 🤝 Osallistuminen

1. Fork → feature-branch → PR
2. Katso [CONTRIBUTING.md](CONTRIBUTING.md)

---

## 📄 Lisenssi

MIT — © ojkotka
