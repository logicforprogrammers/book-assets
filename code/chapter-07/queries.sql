-- All of the queries used in the book with a sample database.
-- Requires sqlite3. Run with
-- Unix: sqlite3 < queries.sql
-- Windows: get-content .\queries.sql | sqlite3

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
    ('alice', 0),
    ('bob', 0),
    ('carol', 1),
    ('dave', 3),
    ('eve', 5),
    ('frank', 8);

INSERT INTO dep_managers (emp_id, dep_id, start_at, end_at) VALUES
  (1, 1, 0, 10),
  (1, 2, 0, 5),
  (1, 3, 0, 999), -- into the future!
  (2, 1, 11, 999),
  (3, 2, 8, 999),
  (4, 2, 9, 999)
  ;

-- existence query
-- In SQL, true == 1 and false == 0
SELECT 1 -- `some`
FROM dep_managers AS dm -- dm in dep_managers:
  WHERE dm.emp_id = 1 
    AND dm.dep_id = 3
    AND 6 BETWEEN dm.start_at AND dm.end_at;

-- values query
SELECT dm.emp_id, dm.dep_id FROM dep_managers AS dm 
  WHERE 6 BETWEEN start_at AND end_at;

SELECT '';SELECT 'inner joins';SELECT '';

-- inner join query
SELECT e.name, d.name
  from employees as e
  INNER JOIN departments as d
  INNER JOIN dep_managers as dm
    ON  dm.emp_id = e.id
    AND dm.dep_id = d.id
  WHERE 6 BETWEEN start_at AND end_at;


SELECT '';SELECT 'employees who are not managers';SELECT '';

-- left join query
SELECT e.* FROM employees AS e
  LEFT JOIN dep_managers AS dm
    ON dm.emp_id = e.id
  WHERE dm.id IS NULL;

-- end
-- subqueries

SELECT * FROM employees AS e
  WHERE NOT EXISTS (SELECT 1 FROM dep_managers 
                             WHERE emp_id = e.id);

-- views as helper predicates

CREATE VIEW never_manager AS
  SELECT e FROM employees AS e
    WHERE NOT EXISTS 
      (SELECT 1 FROM dep_managers where e_id = e.id);

-- common table expressions as helper predicates
