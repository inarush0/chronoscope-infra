CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE IF NOT EXISTS datasets (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  slug        TEXT        UNIQUE NOT NULL,
  name        TEXT        NOT NULL,
  description TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS events (
  id          TEXT    NOT NULL,
  dataset_id  UUID    NOT NULL REFERENCES datasets(id) ON DELETE CASCADE,
  start_time  BIGINT  NOT NULL,
  end_time    BIGINT,
  title       TEXT    NOT NULL,
  book        TEXT,
  category    TEXT,
  lane        TEXT,
  meta        JSONB,
  PRIMARY KEY (id, dataset_id)
);

CREATE INDEX IF NOT EXISTS idx_events_dataset_start ON events (dataset_id, start_time);
CREATE INDEX IF NOT EXISTS idx_events_dataset_book  ON events (dataset_id, book);
