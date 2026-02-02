-- Generated with the help of claude
-- Requires sqlite3. Run with
-- Unix: sqlite3 < trigger_invariants.sql
-- Windows: get-content .\trigger_invariants.sql | sqlite3

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS dep_employees;
DROP TABLE IF EXISTS dep_manager;

CREATE TABLE employees (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT,
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

-- We want the invariant "employees can only manage a department after they were hired"
-- The dual of this is the QUERY "dep_managers with a start_at before the employee's hired_at" being empty.
-- We can check this via a trigger on both row insertion and row update.
-- Note in *this particular case* there's a more elegant way, see the update trigger
CREATE TRIGGER check_time_travel_on_insert
AFTER INSERT ON dep_managers -- AFTER INSERT checks after the row is inserted, when the invariant would be violated
FOR EACH ROW
BEGIN
    SELECT CASE
        WHEN (
          -- NoTimeTravel holds if this finds 0 rows
          SELECT COUNT(*) FROM employees as e
            INNER JOIN dep_managers as dm
            ON e.id = dm.emp_id
            AND dm.start_at < e.hired_at
        )
        THEN RAISE(ROLLBACK, '[INSERT] Employee must be hired before they manage a department')
    END;
END;

-- We also need to check this on row updates.
-- "Query the negation" is a general technique for checking invariants
-- But often there are more elegant ways. Here, we know which record we're updating
-- So we can directly query for the corresponding employee.
-- This would work in the previous trigger, too.
CREATE TRIGGER check_time_travel_on_update
BEFORE UPDATE ON dep_managers
FOR EACH ROW WHEN NEW.start_at <> OLD.start_at OR NEW.emp_id <> OLD.emp_id
BEGIN
    SELECT CASE
        WHEN NEW.start_at < (SELECT hired_at FROM employees WHERE id = NEW.emp_id)
        THEN RAISE(ROLLBACK, '[UPDATE] Employee must be hired before they manage a department')
    END;
END;


-- Insert some sample data
INSERT INTO departments (name) VALUES 
    ('HR'),
    ('Engineering');


INSERT INTO employees (name, hired_at) VALUES 
    ('alice', 5);

INSERT INTO dep_managers (emp_id, dep_id, start_at, end_at) VALUES
  (1, 1, 5, 10);



-- This will fail because of the INSERT trigger
INSERT INTO dep_managers (emp_id, dep_id, start_at, end_at) VALUES
  (1, 2, 0, 10);

-- This will fail because of the UPDATE trigger
UPDATE dep_managers SET start_at = 4 WHERE id = 1;

-- This will succeed despite violating our invariants
-- Because there's no trigger on updating employees
UPDATE employees SET hired_at = 20 WHERE  id = 1;

-- Prove the invalid insertions and updates (on *dep_managers*) are prevented
Select * from dep_managers INNER JOIN employees on dep_managers.emp_id = employees.id;


-- State change constraint for `e.email != NULL => e.email' != NULL
-- Notice that the `=>` is implemented as a condition for when the check the trigger
CREATE TRIGGER no_null_email_after_set
BEFORE UPDATE ON employees
FOR EACH ROW WHEN OLD.email IS NOT NULL
BEGIN
    SELECT CASE
        WHEN NEW.email IS NULL
        THEN RAISE(ROLLBACK, '[UPDATE] cannot set non-null email to NULL')
    END;
END;

-- valid
UPDATE employees SET email = 'alice@example.com' WHERE id = 1;

-- This will fail because of the UPDATE trigger
UPDATE employees SET email = NULL WHERE id = 1;

-- Prove first update went through
SELECT * from employees;

