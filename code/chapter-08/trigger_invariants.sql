-- Generated with the help of claude
-- Requires sqlite3. Run with
-- Unix: sqlite3 < trigger_invariants.sql
-- Windows: get-content .\trigger_invariants.sql | sqlite3

DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS authors;

CREATE TABLE authors (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    birthday DATE NOT NULL
);

CREATE TABLE books (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    author_id INTEGER NOT NULL,
    published_on DATE NOT NULL,
    FOREIGN KEY (author_id) REFERENCES authors(id) ON DELETE CASCADE
);

-- We want the invariant "all books have authors are born before the publication date"
-- The dual of this is the QUERY "some book with author born after the publication date" being empty.
-- We can check this via a trigger on both row insertion and row update.
-- Note in *this particular case* there's a more elegant way, see the update trigger
CREATE TRIGGER check_published_on
AFTER INSERT ON books -- AFTER INSERT checks after the row is inserted, when the invariant would be violated
FOR EACH ROW
BEGIN
    SELECT CASE
        WHEN (
          SELECT COUNT(*) FROM books as b 
            INNER JOIN authors as a
            ON b.author_id = a.id
            AND b.published_on <= a.birthday
        )
        THEN RAISE(ROLLBACK, 'Book publication date must be after author birth date')
    END;
END;

-- We also need to check this on row updates.
-- "Query the negation" is a general technique for checking invariants
-- But often there are more elegant ways. Here, we know which book we're updating
-- So we can directly query for the corresponding author.
-- This would work in the previous trigger, too.
CREATE TRIGGER check_published_on_update
BEFORE UPDATE ON books
FOR EACH ROW WHEN NEW.published_on <> OLD.published_on OR NEW.author_id <> OLD.author_id
BEGIN
    SELECT CASE
        WHEN NEW.published_on <= (SELECT birthday FROM authors WHERE id = NEW.author_id)
        THEN RAISE(ROLLBACK, 'Book publication date must be after author birth date')
    END;
END;

-- Author and books chosen by Claude 3.7
INSERT INTO authors (name, birthday) VALUES ('Ernest Hemingway', '1899-07-21');
INSERT INTO books (title, author_id, published_on) VALUES 
  ('The Old Man and the Sea', 1, '1952-09-01'),
  ('For Whom the Bell Tolls', 1, '1940-10-21');


-- This will fail because of the INSERT trigger
INSERT INTO books (title, author_id, published_on) VALUES ('A Confederacy of Dunces', 1, '1850-01-01');

-- This will fail because of the UPDATE trigger
UPDATE books SET published_on = '1850-01-01' WHERE id = 1;

-- This will succeed despite violating our invariants
-- Because there's no trigger on updating authors
-- UPDATE authors SET birthday = '2025-01-01' WHERE  id = 1;

-- Prove the invalid insertions and updates (on *books*) are prevented
Select * from authors INNER JOIN books on authors.id = books.author_id;
