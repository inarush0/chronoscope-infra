# chronoscope-infra

Data and infrastructure repository for the Chronoscope project.

The dataset is a **static, read-only SQLite file** built from authored JSON. There
is no database server to run: the app either opens the file directly or fetches
it once from object storage.

## Contents

- `data/events/` — authored event files, one per book. **Source of truth.**
- `data/books.json` — extraction coverage manifest (which books are in scope)
- `data/chronoscope.sqlite` — build artifact, not in version control
- `scripts/build-db.ts` — builds the SQLite file from `data/events/`
- `scripts/validate.ts` — checks the event files without building
- `scripts/lib/` — the authored date format and event-file validation
- `docs/extraction.md` — how events are extracted from the book texts
- `compose.yml` — runs the app against the built dataset

## Development setup

```
bun install
bun run build-db     # data/events/*.json -> data/chronoscope.sqlite
docker compose up    # app on http://localhost:3000
```

To run the app outside a container, point it at the built file:

```
DATABASE_FILE=../chronoscope-infra/data/chronoscope.sqlite bun run dev
```

## Adding events

Events are written by Claude reading the book texts in `../bible/books/` during
a Claude Code session — see `docs/extraction.md` for the format, the id and
category conventions, and the shared chronology. The loop is:

```
bun run validate     # schema, dates, duplicate ids, coverage
bun run build-db     # regenerate the dataset
```

`compose.yml` sets `DATASET_RELOAD=1`, so the running app re-opens the database
when the file changes: rebuild and refresh the browser, no restart needed. Set
`DATASET_RELOAD=0` to turn it off. It is off by default when the variable is
unset, so a deployed instance never pays for the check.

Authored dates are human-readable (`"1446-04-15 BC"`, `"57 AD"`) and converted to
epoch milliseconds at build time, so nobody hand-computes offsets.

## Deployment

`build-db` produces a single self-contained file. Upload it to a bucket and set
`DATABASE_URL` on the app instead of `DATABASE_FILE`:

```
bun run build-db
aws s3 cp data/chronoscope.sqlite s3://your-bucket/chronoscope.sqlite
```

The app downloads it once on the first request, caches it on local disk
(`DATASET_CACHE_DIR`, default `$TMPDIR/chronoscope`), and opens it read-only.
The fetch is a plain unauthenticated GET, so the object must be publicly
readable or fronted by a signed URL or CDN. Publishing a new dataset means
uploading a new file and restarting the app.

---

## Copyright

Copyright © 2026 Andrew Rush. All rights reserved.
