# chronoscope-infra (archived)

**This repository has been merged into [`inarush0/chronoscope`](https://github.com/inarush0/chronoscope).**

It was created when the plan was a Postgres server for events. That plan was
replaced by a static SQLite dataset, after which nothing here was infrastructure:
just the authored events and the script that compiled them. Both now live
alongside the app that renders them, under `dataset/` — with this repository's
commit history preserved, so `git log` on the event files still works there.

- Authored events, build scripts and the dataset: `dataset/` in the app repo
- Extraction format and shared chronology: `docs/extraction.md` in the app repo

See [inarush0/chronoscope#9](https://github.com/inarush0/chronoscope/pull/9) for
the migration.

---

## Copyright

Copyright © 2026 Andrew Rush. All rights reserved.
