# Osallistuminen MCP UNIVERSEen

Tervetuloa! Jokainen kontribuutio on tervetullut.

## Nopea aloitus

```bash
git clone https://github.com/OJKotkaLKP/MCP-UNIVERSE-.git
cd MCP-UNIVERSE-

# SDK kehitys
cd sdk
pnpm install
pnpm test:watch   # testit live-tilassa

# Koko järjestelmä
cd ..
cp .env.example .env
docker-compose up -d
```

## Pull Request -prosessi

1. Fork → feature-branch (`feat/oma-ominaisuus`)
2. Tee muutokset
3. Varmista testit: `pnpm test`
4. Avaa PR `main`-haaraan — kuvaa mitä muutit ja miksi

## Koodityyli

- TypeScript: strict mode, ei `any`
- Rust: `cargo clippy` ei saa varoittaa
- Python: `ruff` linting
- Kommentit suomeksi tai englanniksi — molemmat ok

## Bug reports

Avaa Issue ja lisää:
- Mitä teit
- Mitä odotit tapahtuvan
- Mitä tapahtui
- `docker-compose logs` tai virheilmoitus
