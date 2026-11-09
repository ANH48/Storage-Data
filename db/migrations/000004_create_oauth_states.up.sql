CREATE TABLE oauth_states (
    state      text        PRIMARY KEY,
    user_id    bigint      NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    expires_at timestamptz NOT NULL
);

-- Lets the reconciler delete expired states.
CREATE INDEX oauth_states_expires_at_idx ON oauth_states (expires_at);
