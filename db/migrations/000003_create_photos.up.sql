CREATE TABLE photos (
    id                bigserial PRIMARY KEY,
    user_id           bigint      NOT NULL REFERENCES users (id) ON DELETE RESTRICT,
    -- NULL while pending, before an account has accepted the file.
    linked_account_id bigint      REFERENCES linked_accounts (id) ON DELETE RESTRICT,
    object_key        text,
    name              text        NOT NULL,
    content_type      text        NOT NULL
                                  CHECK (content_type IN ('image/jpeg', 'image/png', 'image/webp')),
    size              bigint      NOT NULL CHECK (size > 0),
    sha256            text        NOT NULL,
    status            text        NOT NULL DEFAULT 'pending'
                                  CHECK (status IN ('pending', 'active', 'failed')),
    created_at        timestamptz NOT NULL DEFAULT now(),
    updated_at        timestamptz NOT NULL DEFAULT now(),
    -- An active photo must know where its file lives.
    CONSTRAINT photos_active_has_location CHECK (
        status <> 'active' OR (linked_account_id IS NOT NULL AND object_key IS NOT NULL)
    )
);

-- Gallery: newest first, id breaks ties for cursor pagination.
CREATE INDEX photos_gallery_idx ON photos (user_id, status, created_at DESC, id DESC);
-- Reconciler: finds photos stuck in pending.
CREATE INDEX photos_reconcile_idx ON photos (status, updated_at);
