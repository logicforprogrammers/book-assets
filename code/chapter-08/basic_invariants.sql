-- Generated with Claude 3.7
-- Requires sqlite3. Run with
-- Unix: sqlite3 < basic_invariants.sql
-- Windows: get-content .\basic_invariants.sql | sqlite3

DROP TABLE IF EXISTS user_groups;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS groups;

CREATE TABLE groups (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT NOT NULL UNIQUE, -- `all u1, u2 in users: u1.email != u2.email`
    balance REAL NOT NULL CHECK (balance >= 0) -- `all u in users: u.balance >= 0`
);

CREATE TABLE user_groups (
    user_id INTEGER,
    group_id INTEGER,
    PRIMARY KEY (user_id, group_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE, -- all ug in user_groups: some u in users: u.id = ug.user_id
    FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE CASCADE
);

-- Insert some sample data
INSERT INTO groups (name) VALUES 
    ('Administrators'),
    ('Users'),
    ('Developers');

    
INSERT INTO users (email, balance) VALUES 
    ('admin@example.com', 1000.00);

-- Will fail saying UNIQUE constraint failed
INSERT INTO users (email, balance) VALUES ('admin@example.com', 100);

-- Will fail saying CHECK constraint failed
INSERT INTO users (email, balance) VALUES
    ('alice@example.com', -1);
