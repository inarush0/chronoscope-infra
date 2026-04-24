# chronoscope-infra

Infrastructure repository for the Chronoscope project.

## Contents

- `compose.yml` — Docker Compose configuration for the development environment (Postgres + app)
- `postgres/migrations/` — SQL migration files, applied automatically on first Postgres container start
- `scripts/seed.ts` — Operator script for loading dataset JSON files into the database

## Development setup

1. Copy `.env.example` to `.env` and adjust as needed (or rely on the defaults in `compose.yml`)
2. Start the environment:
   ```
   podman compose up
   ```
3. Seed a dataset:
   ```
   DATABASE_URL=postgresql://chronoscope:chronoscope@localhost:5432/chronoscope \
     bun scripts/seed.ts ../chronoscope/src/lib/data/genesis.json bible "The Bible" "Genesis"
   ```

## Scripts

### `scripts/seed.ts`

Upserts a dataset and its events from a JSON file matching the Chronoscope event schema.

```
bun scripts/seed.ts <json-file> <dataset-slug> <dataset-name> <book-name> [description]
```

Run `bun install` in this directory before running scripts.

---

## Copyright

Copyright © 2026 Andrew Rush. All rights reserved.
