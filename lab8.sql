-- Task 1
--a)
--DROP FUNCTION INCREASE;
CREATE FUNCTION INCREASE(a integer) RETURNS integer AS $$
BEGIN
RETURN a + 1;
END; $$
LANGUAGE PLPGSQL;

SELECT INCREASE (20);

--b)
--DROP FUNCTION SUM;
CREATE FUNCTION SUM(a numeric, b numeric) RETURNS numeric AS $$
BEGIN
RETURN a + b;
END; $$
LANGUAGE plpgsql;

SELECT SUM(10, 20);

--c)
--DROP FUNCTION DIVISIBLE;
CREATE FUNCTION DIVISIBLE(a integer)RETURNS bool AS $$
BEGIN
    IF a % 2=0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    end if;
end;
    $$
LANGUAGE plpgsql;

SELECT DIVISIBLE(13);
--d)
--DROP FUNCTION PASSWORD;
CREATE FUNCTION PASSWORD(s varchar) RETURNS bool as $$
    BEGIN
        IF LENGTH(s) >= 8  THEN
                RETURN TRUE;
            ELSE
                RETURN FALSE;
        end if;
        end;
    $$
LANGUAGE plpgsql;
SELECT PASSWORD('sasaa');

--e)
--DROP FUNCTION OUTPUT;
CREATE OR REPLACE FUNCTION OUTPUT(a numeric, OUT square numeric, OUT cub numeric) RETURNS record as $$
    BEGIN
        square := a * a;
        cub := a * a * a;
    end;
    $$
LANGUAGE plpgsql;
SELECT OUTPUT(10);

-- Task 2
DROP table age_person;
create table age_person (
    id integer primary key,
    name varchar(255),
    birth_date date,
    date date DEFAULT now(),
    age integer
);
--a)
--DROP FUNCTION timestamp1;
--DROP TRIGGER date_now ON age_person;
CREATE FUNCTION timestamp1() RETURNS TRIGGER AS
    $$
        BEGIN
            if (old.name!=new.name) then new.date = current_date;
            end if;
            return new;
        END;
    $$
LANGUAGE 'plpgsql';
CREATE TRIGGER date_now
BEFORE UPDATE
    ON age_person
    FOR EACH ROW
    EXECUTE PROCEDURE timestamp1();

INSERT INTO age_person VALUES (6, 'Tamerlan', '2003-02-05');
UPDATE age_person SET name = 'Temirlan' WHERE name = 'Tamerlan';
--b)

INSERT INTO age_person VALUES (1, 'Sanzhar', '2002-05-12');
INSERT INTO age_person VALUES (2, 'Arthur', '2002-11-13');
INSERT INTO age_person VALUES (3, 'Pavel', '2002-09-12');
INSERT INTO age_person VALUES (4, 'Yernar', '2003-02-05');
INSERT INTO age_person VALUES (5, 'Akezhan', '2002-11-23');
SELECT * FROM age_person;
DROP FUNCTION new_person;
DROP TRIGGER tr_age ON age_person;
CREATE FUNCTION new_person() RETURNS TRIGGER
AS $$
    BEGIN
        UPDATE age_person
        SET age = floor((current_date-new.birth_date)/365.25)
        WHERE id = new.id;
        RETURN new;
    end;
    $$ LANGUAGE plpgsql;
CREATE TRIGGER tr_age AFTER INSERT ON age_person
    FOR EACH ROW EXECUTE PROCEDURE new_person();
--c)
-- DROP TABLE products;
CREATE TABLE products(
    barcode integer primary key,
    product_name varchar(55),
    price float
);
-- DROP FUNCTION tax;
-- DROP TRIGGER new_price;
CREATE FUNCTION tax() RETURNS TRIGGER as $emp_stamp$
    BEGIN
        update products
        set price=price+0.12*price
        where barcode = new.barcode;
        return new;
    end;
    $emp_stamp$
LANGUAGE plpgsql;
CREATE TRIGGER new_price AFTER INSERT ON products
    FOR EACH ROW EXECUTE PROCEDURE tax();
INSERT INTO products VALUES (213124124, 'Pepsi', 120);
INSERT INTO products VALUES (213124125, 'Milk', 320);
SELECT * FROM products;

--d)
-- DROP FUNCTION no_deletion;
--DROP TRIGGER delete;
CREATE FUNCTION no_deletion() RETURNS TRIGGER as $emp_stamp$
    BEGIN
        INSERT INTO products(barcode,product_name,price) VALUES(old.barcode,old.product_name,old.price);
        RETURN old;
    end;
    $emp_stamp$
LANGUAGE plpgsql;
CREATE TRIGGER delete
    AFTER DELETE
    ON products
    FOR EACH ROW
    EXECUTE PROCEDURE no_deletion();
DELETE FROM products WHERE product_name = 'Pepsi';
SELECT * FROM products;
--e)
DROP TABLE FUNCT;
DROP TRIGGER launch ON FUNCT;
DROP FUNCTION find1;
CREATE TABLE FUNCT(
    passw varchar(55),
    num numeric,
    correct_pasw bool,
    ans_num numeric
);
CREATE FUNCTION find1() RETURNS TRIGGER AS $emp_stamp$
    BEGIN
        INSERT INTO FUNCT (correct_pasw) VALUES (PASSWORD(new.passw));
    end;
    $emp_stamp$ LANGUAGE plpgsql;
CREATE TRIGGER launch AFTER INSERT ON FUNCT
    FOR EACH ROW EXECUTE PROCEDURE find1();
INSERT INTO FUNCT VALUES ('asadadass');
DELETE FROM FUNCT WHERE passw = 'asadadass';
SELECT * FROM FUNCT;

-- Task 3
--A function returns a value and a procedure just executes commands.
--The name function comes from math. It is used to calculate a value based on input.
--A procedure is a set of commands which can be executed in order.
--In most programming languages, even functions can have a set of commands. Hence the difference is only returning a value.

-- Task 4
CREATE TABLE work(
    id integer primary key,
    name varchar(255),
    date_of_birth date,
    age integer,
    salary integer,
    workexperince integer,
    discount integer
);
INSERT INTO work VALUES (1, 'Sanzhar', '2002-05-12', 19, 1000000, 6, 5);
INSERT INTO work VALUES (2, 'Arthur', '2002-11-13', 19, 234231, 2, 10);
INSERT INTO work VALUES (3, 'Tamerlan', '2003-02-05', 18, 1000, 10, 25);
INSERT INTO work VALUES (4, 'Aslan', '2003-06-24', 18, 34544, 5, 30);
INSERT INTO work VALUES (5, 'Osas', '2004-05-12', 17, 10000, 6, 10);
SELECT * FROM work;
--a)
CREATE OR REPLACE PROCEDURE new_salary() as
$$
    BEGIN
        UPDATE work
        SET salary = (workexperince/2)*0.1*salary+salary,
            discount = (workexperince/2)*0.1*discount + discount,
            discount = (workexperince/5)*0.01 *discount + discount;
        COMMIT;
    END;
    $$
LANGUAGE plpgsql;
--b)
CREATE OR REPLACE PROCEDURE new_salary1() as
    $$
        BEGIN
            UPDATE work
            SET salary = salary*1.15
            WHERE age >= 40;
            UPDATE work
            SET salary = salary*1.15*(workexperince/8);
            UPDATE work
            SET discount = 20 WHERE workexperince >= 8;
            COMMIT;
        END;
    $$
LANGUAGE plpgsql;

-- Task 5

create table members(
    memid integer,
    surname varchar(200),
    firstname varchar(200),
    address varchar(300),
    zipcode integer,
    telephone varchar(20),
    recommendedby integer,
    joindate timestamp
);
create table bookings(
    facid integer,
    memid integer,
    starttime timestamp,
    slots integer
);
create table facilities(
    facid integer,
    name varchar(200),
    membercost numeric,
    guestcost numeric,
    initialoutlay numeric,
    monthlymaintenance numeric
);
with recursive recommenders(recommender, member) as (
	select recommendedby, memid
		from members
	union all
	select mems.recommendedby, recs.member
		from recommenders recs
		inner join members mems
			on mems.memid = recs.recommender
)
select recs.member member, recs.recommender, mems.firstname, mems.surname
	from recommenders recs
	inner join members mems
		on recs.recommender = mems.memid
	where recs.member = 22 or recs.member = 12
order by recs.member asc, recs.recommender desc