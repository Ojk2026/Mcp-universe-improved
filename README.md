# 🌌 MCP UNIVERSE

# 🌌 MCP Universe

> The fastest self-hosted way to connect AI agents to MCP servers — with a unified gateway, trust-aware tool discovery, session sharing, and zero vendor lock-in.

[![License: MIT](LICENSE)](LICENSE)

MCP Universe is a developer-first platform for discovering, connecting, governing, and running MCP tools through one self-hosted control plane.

It is designed for teams who want:
- one place to connect multiple MCP servers
- a clean developer experience
- secure, policy-aware tool execution
- a visual playground for testing
- a self-hosted alternative to vendor-locked MCP platforms

---

## Why MCP Universe?

Most MCP workflows today are fragmented:
- one tool for discovery
- another for gatewaying
- another for auth
- another for testing
- another for session sharing

**MCP Universe** aims to unify that into one product:

- **Unified MCP Gateway** — connect many MCP servers behind one endpoint
- **Trust-Aware Tool Discovery** — rank and expose tools with confidence metadata
- **Session Sharing** — save and share reproducible tool sessions by URL
- **Visual Playground** — inspect tools, run them, and validate behavior
- **Self-Hosted by Default** — own your stack, credentials, logs, and policies
- **Zero Vendor Lock-In** — open architecture, standard MCP integration model

---

## Current Status

MCP Universe is under active development.

### Working focus
- Self-hosted deployment
- Unified gateway architecture
- Multi-service platform foundation
- Contributor-friendly roadmap
- Security-first MCP aggregation

### In progress
- Verified end-to-end quickstart
- SDK/package publishing
- Trust scoring UX
- Session sharing UX
- Observability and audit trails

### Planned
- Registry/discovery layer
- Policy engine for tool-level authorization
- Advanced auth flows
- Production-grade metrics and dashboards

If you want to help shape the roadmap, see [Contributing](CONTRIBUTING.md).

---

## Core Product Vision

MCP Universe is being built around five product pillars:

### 1. One gateway for many MCP servers
Connect remote, local, containerized, and hosted MCP servers through a single control plane.

### 2. Developer experience that actually feels simple
The promise is not “more infrastructure.”
The promise is: **less friction between idea and working tool call**.

### 3. Security by default
A real MCP gateway must do more than proxy traffic.
It must enforce authentication, validate requests, limit risk, and make tool use observable.

### 4. Trust-aware execution
Not all tools are equally reliable.
MCP Universe aims to help agents and developers understand which tools are safer, more stable, and more trustworthy.

### 5. Shareable, reproducible sessions
If a tool workflow works once, you should be able to save it, inspect it, and share it.

---

## Quick Start

> Goal: get MCP Universe running locally and validate one successful tool flow.

### Prerequisites
- Docker
- Docker Compose
- Git

### Setup

```bash
git clone https://github.com/Ojk2026/Mcp-universe-improved.git
cd Mcp-universe-improved

cp .env.example .env
docker compose up -d --build


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
