CREATE TABLE albums (
    id         bigserial PRIMARY KEY,
    user_id    bigint      NOT NULL REFERENCES users (id) ON DELETE RESTRICT,
    name       text        NOT NULL CHECK (name <> ''),
    created_at timestamptz NOT NULL DEFAULT now(),
    -- Also serves listing a user's albums.
    CONSTRAINT albums_user_name_key UNIQUE (user_id, name)
);

-- Many-to-many: a photo can be in several albums.
CREATE TABLE album_photos (
    album_id bigint      NOT NULL REFERENCES albums (id) ON DELETE CASCADE,
    photo_id bigint      NOT NULL REFERENCES photos (id) ON DELETE CASCADE,
    added_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (album_id, photo_id)
);

-- Finds the albums a photo belongs to.
CREATE INDEX album_photos_photo_idx ON album_photos (photo_id);
