CREATE TABLE linked_accounts (
    id                bigserial PRIMARY KEY,
    user_id           bigint      NOT NULL REFERENCES users (id) ON DELETE RESTRICT,
    provider          text        NOT NULL DEFAULT 'google_drive',
    provider_user_id  text        NOT NULL,
    email             text        NOT NULL,
    refresh_token_enc bytea       NOT NULL,
    root_folder_id    text,
    quota_limit       bigint      NOT NULL DEFAULT 0 CHECK (quota_limit >= 0),
    quota_used        bigint      NOT NULL DEFAULT 0 CHECK (quota_used >= 0),
    quota_synced_at   timestamptz,
    status            text        NOT NULL DEFAULT 'active'
                                  CHECK (status IN ('active', 'near_full', 'revoked')),
    created_at        timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT linked_accounts_provider_user_key UNIQUE (provider, provider_user_id)
);

-- Lists a user's accounts in rotation order.
CREATE INDEX linked_accounts_rotation_idx ON linked_accounts (user_id, status, id);

ALTER TABLE users
    ADD CONSTRAINT users_last_linked_account_fk
    FOREIGN KEY (last_linked_account_id) REFERENCES linked_accounts (id) ON DELETE SET NULL;
