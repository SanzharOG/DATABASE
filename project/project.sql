CREATE TYPE size1 as (
    p_scope varchar (55),
    p_weight varchar (55)
);
CREATE TABLE product(
    p_id integer primary key,
    p_name varchar (55) NOT NULL,
    p_size size1,
    p_packing varchar (55)
);
CREATE TABLE product_type(
    type_id integer PRIMARY KEY,
    type_name prod_type
);
CREATE TABLE prod_typee(
    p_id integer,
    t_id integer,
    FOREIGN KEY (p_id) REFERENCES product(p_id) ON DELETE CASCADE,
    FOREIGN KEY (t_id) REFERENCES product_type(type_id) ON DELETE CASCADE
);
CREATE type prod_type as(
    t_name varchar(55),
    t_classification varchar(55),
    type_subspecies varchar(55)
);
CREATE TABLE brand(
    b_id integer primary key,
    brand_name varchar(55)
);

CREATE TABLE sub_brand(
    sub_id integer primary key ,
    brand_id integer,
    FOREIGN KEY (brand_id) REFERENCES brand(b_id) ON DELETE CASCADE,
    s_name varchar(55)
);
CREATE TABLE sub_prod(
    p_id integer PRIMARY KEY,
    s_id integer,
    FOREIGN KEY (p_id) REFERENCES product(p_id) ON DELETE CASCADE,
    FOREIGN KEY (s_id) REFERENCES sub_brand(sub_id) ON DELETE CASCADE
);

CREATE TYPE adress1 as (
    country varchar (55),
    city varchar (55),
    street varchar (55),
    building varchar (55)
);
CREATE TYPE time1 as (
    open_time time,
    closed_time time
);
CREATE TABLE store(
    s_id integer primary key,
    s_name varchar (55) NOT NULL,
    adress adress1,
    work_schedule time1

);
CREATE TABLE prod_in_store(
    prod_id integer NOT NULL,
    store_id integer NOT NULL,
    amount integer NOT NULL,
    price integer NOT NULL,
    FOREIGN KEY (prod_id) REFERENCES product(p_id),
    FOREIGN KEY (store_id) REFERENCES store(s_id)
);

CREATE TYPE full_name as(
    f_name varchar (55) ,
    l_name varchar (55)
);
CREATE TABLE vendor(
    v_id integer primary key,
    name full_name,
    date_of_birth date NOT NULL,
    age integer
);
CREATE TABLE vendor_prod(
    ven_id integer,
    prod_id integer,
    amount integer,
    FOREIGN KEY (ven_id) REFERENCES vendor(v_id) ON DELETE CASCADE,
    FOREIGN KEY (prod_id) REFERENCES product(p_id) ON DELETE CASCADE
);

CREATE TABLE online_customers(
    c_id integer PRIMARY KEY ,
    login VARCHAR (20) UNIQUE,
    password VARCHAR (20) NOT NULL,
    nickname VARCHAR (20) NOT NULL,
    payment_card varchar(30) UNIQUE,
    date_of_birth date NOT NULL,
    age integer
);
CREATE FUNCTION age2() RETURNS TRIGGER
AS $$
    BEGIN
        UPDATE online_customers
        SET age = floor((current_date-new.date_of_birth)/365.25)
        WHERE c_id = new.c_id;
        RETURN new;
    end;
    $$ LANGUAGE plpgsql;
CREATE TRIGGER tr_age2 AFTER INSERT ON online_customers
    FOR EACH ROW EXECUTE PROCEDURE age2();
DROP TRIGGER tr_age ON online_customers;
DROP FUNCTION age;
CREATE FUNCTION age1() RETURNS TRIGGER
AS $$
    BEGIN
        UPDATE vendor
        SET age = floor((current_date-new.date_of_birth)/365.25)
        WHERE v_id = new.v_id;
        RETURN new;
    end;
    $$ LANGUAGE plpgsql;
CREATE TRIGGER tr_age1 AFTER INSERT ON vendor
    FOR EACH ROW EXECUTE PROCEDURE age1();

CREATE TABLE phone_number(
    ph_id integer primary key,
    id integer,
    FOREIGN KEY (id) REFERENCES online_customers(c_id) ON DELETE CASCADE,
    phone_number varchar(55)
);

CREATE TABLE check1(
    pur_id integer primary key NOT NULL,
    date date DEFAULT current_date,
    total_sum integer default 0
);
DROP TABLE check1;
DROP TABLE purchases;
insert  into check1 values (1);
CREATE TABLE purchases(
    id integer,
    prod_id integer,
    store integer,
    amount integer,
    pur_id integer,
    FOREIGN KEY (id) REFERENCES online_customers(c_id) ON DELETE CASCADE,
    FOREIGN KEY (prod_id) REFERENCES product(p_id) ON DELETE CASCADE,
    FOREIGN KEY (store) REFERENCES store(s_id) ON DELETE CASCADE,
    FOREIGN KEY (pur_id) REFERENCES check1(pur_id) ON DELETE CASCADE
);

CREATE INDEX ez on prod_in_store (prod_id, store_id, amount, price);
CREATE INDEX help on vendor_prod (ven_id, prod_id, amount);

DO
$$
    begin
        update vendor_prod
        SET amount = amount - 50
        WHERE
        prod_id = 5 and ven_id = 1;
        update prod_in_store
        SET amount = amount + 50
        WHERE
        store_id = 1 and prod_id = 5;
    end;
    $$;


DO
$$
    begin
        INSERT INTO check1 VALUES (10);
        INSERT INTO purchases VALUES (10, 10, 7, 5, 10);
        UPDATE prod_in_store
        set amount = amount - 5
        WHERE store_id = 7 and prod_id = 10;
        UPDATE check1
            set total_sum = total_sum + 399 * 5
        WHERE pur_id = 10;
    end;
    $$;
CREATE FUNCTION store() RETURNS TRIGGER
    AS $$
    BEGIN
        UPDATE prod_in_store
        SET amount = amount - 5
        WHERE prod_id = new.prod_id;
        RETURN new;
    end;
    $$ LANGUAGE plpgsql;
CREATE TRIGGER ez AFTER INSERT ON purchases
    FOR EACH ROW EXECUTE PROCEDURE store();
