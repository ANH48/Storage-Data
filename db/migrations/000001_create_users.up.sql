CREATE TABLE users (
    id                     bigserial PRIMARY KEY,
    email                  text        NOT NULL UNIQUE CHECK (email = lower(email)),
    password_hash          text        NOT NULL,
    -- Round-robin pointer. The foreign key is added in 000002 because
    -- linked_accounts does not exist yet.
    last_linked_account_id bigint,
    created_at             timestamptz NOT NULL DEFAULT now()
);
