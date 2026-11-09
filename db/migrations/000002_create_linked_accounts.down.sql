ALTER TABLE users DROP CONSTRAINT IF EXISTS users_last_linked_account_fk;
DROP TABLE IF EXISTS linked_accounts;
