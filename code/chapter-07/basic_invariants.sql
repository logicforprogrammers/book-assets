-- Requires sqlite3. Run with
-- Unix: sqlite3 < basic_invariants.sql
-- Windows: get-content .\basic_invariants.sql | sqlite3

-- SQLite doesn't enforce foreign key constraints by default
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS dep_employees;
DROP TABLE IF EXISTS dep_manager;

CREATE TABLE employees (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    hired_at DATE NOT NULL
);

CREATE TABLE departments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE
);

CREATE TABLE dep_managers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    dep_id INTEGER NOT NULL,
    emp_id INTEGER NOT NULL,
    start_at DATE NOT NULL,
    end_at DATE NOT NULL,
    check (start_at <= end_at),
    FOREIGN KEY (emp_id) REFERENCES employees(id) ON DELETE CASCADE, 
    FOREIGN KEY (dep_id) REFERENCES departments(id) ON DELETE CASCADE 
);

-- Insert some sample data
INSERT INTO departments (name) VALUES 
    ('HR'),
    ('Engineering'),
    ('Sales');


INSERT INTO employees (name, hired_at) VALUES 
    ('alice', 0);

INSERT INTO dep_managers (emp_id, dep_id, start_at, end_at) VALUES
  (1, 1, 0, 10);

-- Will fail saying UNIQUE constraint failed
INSERT INTO departments (name) VALUES ('HR');

-- Will fail saying CHECK constraint failed
INSERT INTO dep_managers (emp_id, dep_id, start_at, end_at) VALUES
  (1, 1, 11, 10);

-- Will fail saying FOREIGN KEY constraint failed
INSERT INTO dep_managers (emp_id, dep_id, start_at, end_at) VALUES
  (12, 19, 1, 10);
