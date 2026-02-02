-- Demonstrating compatibility of database schemas with SQL views
-- May be renamed in copyediting.
-- Requires sqlite3. Run with
-- Unix: sqlite3 < view.sql
-- Windows: get-content .\view.sql | sqlite3


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
    name TEXT UNIQUE -- `all d1, d2 in departments: d1.name != d2.name`
);

CREATE TABLE dep_managers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    dep_id INTEGER NOT NULL,
    emp_id INTEGER NOT NULL,
    start_at DATE NOT NULL,
    end_at DATE NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES employees(id) ON DELETE CASCADE, 
    FOREIGN KEY (dep_id) REFERENCES departments(id) ON DELETE CASCADE 
);

-- Insert some sample data
INSERT INTO departments (name) VALUES 
    ('HR'),
    ('Engineering'),
    ('Sales');


INSERT INTO employees (name, hired_at) VALUES 
    ('alice', 6),
    ('bob', 7),
    ('carol', 9),
    ('dave', 12),
    ('eve', 15),
    ('frank', 19);

Select ''; select 'Base Table'; select '';
Select * FROM employees;

-- First compatibility/refinement
DROP table employees;

CREATE TABLE new_employees (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
);

CREATE TABLE hirings (
    emp_id INTEGER, -- missing unique, so not truly compatible
    at DATE
);


INSERT INTO new_employees (name) VALUES 
    ('alice'),
    ('bob'),
    ('carol'),
    ('dave'),
    ('eve'),
    ('frank');

INSERT INTO hirings (emp_id, at) VALUES
(1, 6),
(2, 7),
(3, 9),
(4, 12),
(5, 15),
(6, 19);

Select ''; select 'Abstraction Function (as view)'; select '';
CREATE VIEW employees (id, name, hired_at) AS
  SELECT e.id, e.name, h.at 
    FROM new_employees AS e
    INNER JOIN hirings AS h
      ON h.emp_id == e.id;
  
SELECT * FROM employees; -- same things!
-- Note this is as-is compatible, 
-- because it does not preserve all type invariants as



DROP TABLE hirings;

CREATE TABLE new_hirings (
  emp_id INTEGER,
  at1 DATE,
  at2 DATE
);

INSERT INTO new_hirings (emp_id, at1, at2) VALUES
(1, 2, 4),
(2, 1, 6),
(3, 9, 0),
(4, 6, 6),
(5, 1, 14),
(6, 8, 11);

Select ''; select 'Second abstraction function (as view)'; select '';


CREATE VIEW hirings (emp_id, at) AS
  SELECT emp_id, at1 + at2
    FROM new_hirings as h;

SELECT * FROM employees
