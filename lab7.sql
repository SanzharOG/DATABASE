create table customers (
    id integer primary key,
    name varchar(255),
    birth_date date
);

create table accounts(
    account_id varchar(40) primary key ,
    customer_id integer references customers(id),
    currency varchar(3),
    balance float,
    "limit" float
);

create table transactions (
    id serial primary key ,
    date timestamp,
    src_account varchar(40) references accounts(account_id),
    dst_account varchar(40) references accounts(account_id),
    amount float,
    status varchar(20)
);

INSERT INTO customers VALUES (201, 'John', '2021-11-05');
INSERT INTO customers VALUES (202, 'Anny', '2021-11-02');
INSERT INTO customers VALUES (203, 'Rick', '2021-11-24');

INSERT INTO accounts VALUES ('NT10204', 201, 'KZT', 1000, null);
INSERT INTO accounts VALUES ('AB10203', 202, 'USD', 100, 0);
INSERT INTO accounts VALUES ('DK12000', 203, 'EUR', 500, 200);
INSERT INTO accounts VALUES ('NK90123', 201, 'USD', 400, 0);
INSERT INTO accounts VALUES ('RS88012', 203, 'KZT', 5000, -100);

INSERT INTO transactions VALUES (1, '2021-11-05 18:00:34.000000', 'NT10204', 'RS88012', 1000, 'commited');
INSERT INTO transactions VALUES (2, '2021-11-05 18:01:19.000000', 'NK90123', 'AB10203', 500, 'rollback');
INSERT INTO transactions VALUES (3, '2021-06-05 18:02:45.000000', 'RS88012', 'NT10204', 400, 'init');

-- Task 1
--You can use large object data types to store audio, video, images, and other files that are larger than 32 KB.
-- The VARCHAR, VARGRAPHIC, and VARBINARY data types have a storage limit of 32 KB.
-- However, applications often need to store large text documents or additional data types such as audio,
-- video, drawings, images, and a combination of text and graphics.
--For data objects that are larger than 32 KB, you can use the corresponding
--large object (LOB) data types to store these objects.


--Task 2

CREATE ROLE accountant WITH PASSWORD 'asd45';
CREATE USER Sergey LOGIN;
GRANT accountant TO Sergey;
GRANT select, insert, update, delete ON accounts TO accountant;
CREATE ROLE administrator WITH CREATEROLE PASSWORD 'adb123';
CREATE USER Sanzhar LOGIN ;
GRANT administrator TO Sanzhar;
GRANT select, insert, update, delete ON customers TO administrator;
CREATE ROLE support WITH PASSWORD 'dcd890';
CREATE USER Yernar LOGIN;
CREATE USER Pavel LOGIN;
GRANT support TO Yernar;
GRANT support TO Pavel;
GRANT select, insert, update, delete ON transactions TO support;
REVOKE Yernar FROM support;

-- Task 3_2

ALTER TABLE customers
    ALTER COLUMN name SET NOT NULL;
ALTER TABLE customers
    ALTER COLUMN birth_date SET NOT NULL;

ALTER TABLE accounts
    ALTER COLUMN currency SET NOT NULL;

ALTER TABLE transactions
    ALTER COLUMN date SET NOT NULL;
ALTER TABLE transactions
    ALTER COLUMN amount SET NOT NULL;
ALTER TABLE transactions
    ALTER COLUMN status SET NOT NULL;

-- Task 5

CREATE UNIQUE INDEX one_to_one ON accounts (customer_id, currency);

CREATE INDEX searsh ON accounts (currency, balance);


-- Task 6


DO
$$
    DECLARE
        bal INT;
        lim INT;
    BEGIN
        UPDATE accounts
        SET balance = balance - 400
        WHERE account_id = 'RS88012';
        UPDATE accounts
        SET balance = balance + 400
        WHERE account_id = 'NT10204';
        SELECT balance INTO bal FROM accounts WHERE account_id = 'RS88012';
        SELECT accounts.limit INTO lim FROM accounts WHERE account_id = 'RS88012';
        IF bal < lim THEN
            UPDATE transactions SET status = 'rollback' WHERE id = 1;
        ELSE
            COMMIT;
            UPDATE transactions SET status = 'commited' WHERE id = 1;
        END IF;
    END;
$$;
