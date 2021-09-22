-- EX 1

-- DDL:
-- DDL is Data Definition Language which is used to define data structures.
-- For example: create table, alter table are instructions in SQL.

-- DML:
-- DML is Data Manipulation Language which is used to manipulate data itself.
-- For example: insert, update, delete are instructions in SQL.

-- Difference between DDL and DML:

-- DDL:
-- It is used to create database schema and can be used to define some constraints as well.
-- It basically defines the column (Attributes) of the table.
-- Basic command present in DDL are CREATE, DROP, RENAME etc.
-- DDL does not use WHERE clause in its statement.

-- DML:
-- It is used to add, retrieve or update the data.
-- It add or update the row of the table.
-- BASIC command present in DML are UPDATE, INSERT, DELETE, MERGE etc.
-- DML uses WHERE clause in its statement.


-- EX 2

CREATE TABLE customers
(
    id               INTEGER PRIMARY KEY,
    full_name        VARCHAR(50) NOT NULL,
    timestamp        TIMESTAMP   NOT NULL,
    delivery_address text        NOT NULL
);

CREATE TABLE products
(
    id          VARCHAR PRIMARY KEY,
    name        VARCHAR UNIQUE   NOT NULL,
    description TEXT,
    price       DOUBLE PRECISION NOT NULL CHECK (price > 0)
);


CREATE TABLE orders
(
    code        INTEGER PRIMARY KEY,
    customer_id INTEGER,
    FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE,
    total_sum   DOUBLE PRECISION NOT NULL CHECK (total_sum > 0),
    is_paid     BOOLEAN          NOT NULL
);

CREATE TABLE order_items
(
    order_code INTEGER UNIQUE NOT NULL,
    product_id VARCHAR UNIQUE NOT NULL,
    FOREIGN KEY (order_code) REFERENCES orders (code) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE,
    quantity   INTEGER        NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (order_code, product_id)
);



-- EX 3

CREATE TABLE genders
(
    id           SERIAL PRIMARY KEY,
    gender_title VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE students
(
    id                SERIAL PRIMARY KEY,
    last_name         VARCHAR(255)     NOT NULL,
    first_name        VARCHAR(255)     NOT NULL,
    age               INTEGER          NOT NULL CHECK (age > 15),
    birth_date        DATE             NOT NULL,
    gender            VARCHAR(31)      NOT NULL,
    FOREIGN KEY (gender) REFERENCES genders (gender_title) ON DELETE CASCADE,
    gpa               DOUBLE PRECISION NOT NULL CHECK (0 < gpa AND gpa <= 4.0),
    self_info         TEXT             NOT NULL,
    need_in_dormitory BOOLEAN          NOT NULL,
    additional_info   TEXT

);

CREATE TABLE instructors
(
    id             SERIAL PRIMARY KEY,
    last_name      VARCHAR(255) NOT NULL,
    first_name     VARCHAR(255) NOT NULL,
    languages      VARCHAR(255) NOT NULL,
    works          VARCHAR(255) NOT NULL,
    remote_lessons BOOLEAN      NOT NULL
);

CREATE TABLE instructor_language
(
    instructor_id INTEGER NOT NULL,
    language_id   INTEGER NOT NULL,
    PRIMARY KEY (language_id, instructor_id),
    FOREIGN KEY (instructor_id) REFERENCES instructors (id) ON DELETE CASCADE,
    FOREIGN KEY (language_id) REFERENCES languages (id) ON DELETE CASCADE
);

CREATE TABLE instructor_workPlaces
(
    instructor_id INTEGER NOT NULL,
    work_id       INTEGER NOT NULL,
    PRIMARY KEY (work_id, instructor_id),
    FOREIGN KEY (instructor_id) REFERENCES instructors (id) ON DELETE CASCADE,
    FOREIGN KEY (work_id) REFERENCES work_places (id) ON DELETE CASCADE
);

CREATE TABLE languages
(
    id             SERIAL PRIMARY KEY,
    language_title VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE work_places
(
    id         SERIAL PRIMARY KEY,
    work_title VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE lesson
(
    id                     SERIAL PRIMARY KEY,
    lesson_title           VARCHAR(255)   NOT NULL UNIQUE,
    instructor_id          INTEGER        NOT NULL UNIQUE,
    instructor_lastName    VARCHAR(255)   NOT NULL,
    instructor_name        VARCHAR(255)   NOT NULL,
    students_ids           INTEGER UNIQUE NOT NULL,
    room                   INTEGER        NOT NULL UNIQUE CHECK (room >= 1)
);

CREATE TABLE student_class
(
    student_id INTEGER NOT NULL,
    lesson_id  INTEGER NOT NULL,
    PRIMARY KEY (student_id, lesson_id),
    FOREIGN KEY (student_id) REFERENCES students (id) ON DELETE CASCADE,
    FOREIGN KEY (lesson_id) REFERENCES lesson (id) ON DELETE CASCADE
);

INSERT INTO genders(gender_title)
VALUES ('Male');
INSERT INTO genders(gender_title)
VALUES ('Female');

INSERT INTO students
VALUES (228, 'Sanzhar', 'Kipshakbaev', '19', '12.05.2002', 'Male', 3.4, '192, Baykonur, Russia', True);
INSERT INTO students
VALUES (132, 'Peter', 'Brown', '18', '18.11.2002', 'Male', 2, '182, London, England', False);
INSERT INTO students
VALUES (556, 'Mustafa', 'Elbalaha', '19', '11.03.2002', 'Male', 3.1, '162, Samarkand, Uzbekistan', True);
INSERT INTO students
VALUES (147, 'Kamshat', 'Serikgalieva', '17', '11.10.2003', 'Female', 3.9, '169, Kostanay, Kazakhstan', False);

INSERT INTO work_places(work_title)
VALUES ('Google');
INSERT INTO work_places(work_title)
VALUES ('Yandex');
INSERT INTO work_places(work_title)
VALUES ('KazGaz');

INSERT INTO languages(language_title)
VALUES ('English');
INSERT INTO languages(language_title)
VALUES ('Kazakh');
INSERT INTO languages(language_title)
VALUES ('Russian');

INSERT INTO instructors
VALUES (11, 'Kuralbaev', 'Aibek', 'English', 'Google', true);

INSERT INTO instructors
VALUES (17, 'Kozlov', 'Sergey', 'Russia', 'Yandex', true);

INSERT INTO instructors
VALUES (14, 'Nurtas', 'Kayrat', 'Kazakh', 'KazGaz', false);


INSERT INTO instructor_language
VALUES (11, 3);
INSERT INTO instructor_language
VALUES (17, 1);
INSERT INTO instructor_language
VALUES (14, 2);

SELECT * from instructor_language;

INSERT INTO instructor_workPlaces
VALUES (11, 3);

INSERT INTO instructor_workPlaces
VALUES (17, 1);

INSERT INTO instructor_workPlaces
VALUES (14, 2);

SELECT instructors.last_name, language_title
FROM languages,
     instructor_language,
     instructors
WHERE (instructors.id = instructor_language.instructor_id and instructor_language.language_id = languages.id);


INSERT INTO lesson
VALUES (1, 'Database', 11, 'Kuralbaev', 'Aibek', 228, 111);

INSERT INTO lesson
VALUES (2, 'Geology', 14, 'Nurtas', 'Kayrat', 556, 336);

INSERT INTO lesson
VALUES (3, 'ALGO', 17, 'Kozlov', 'Sergey', 147, 330);

INSERT INTO student_class
VALUES (228, 1);

INSERT INTO student_class
VALUES (556, 2);

INSERT INTO student_class
VALUES (147, 3);


SELECT students.last_name, lesson.lesson_title
FROM lesson,
     student_class,
     students
WHERE (students.id = student_class.student_id and lesson.id = student_class.lesson_id);


-- EX 4

INSERT INTO customers
VALUES (1, 'Kipshakbaev Sanzhar', current_timestamp, 'Turgut Ozala 80');
INSERT INTO customers
VALUES (2, 'Putin Vladimir', current_timestamp, 'Kreml');
INSERT INTO products
VALUES ('TEL', 'Televizor', 'SAMSUNG', 19500);
INSERT INTO products
VALUES ('SMA', 'Smartphone', 'Xiaomi', 42000);

INSERT INTO orders
VALUES (1, 2, 19500, TRUE);
INSERT INTO orders
VALUES (2, 1, 42000 * 10, TRUE);

UPDATE orders
SET total_sum = 42000 * 20
WHERE code = 2;
UPDATE orders
SET is_paid = FALSE
WHERE code = 2;

INSERT INTO order_items
VALUES (1, 'TEL', 1);
INSERT INTO order_items
VALUES (2, 'SMA', 20);

DELETE
FROM orders
WHERE customer_id = 2;