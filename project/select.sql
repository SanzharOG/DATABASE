SELECT purchases.prod_id, purchases.store, sum(purchases.amount), product.p_name
FROM purchases, product where store = 1 and purchases.prod_id = product.p_id
group BY purchases.prod_id, product.p_id, purchases.store
ORDER by sum(purchases.amount) desc
limit 20;
SELECT purchases.prod_id, purchases.store, sum(purchases.amount), product.p_name
FROM purchases, product where store = 2 and purchases.prod_id = product.p_id
group BY purchases.prod_id, product.p_id, purchases.store
ORDER by sum(purchases.amount) desc
limit 20;
SELECT purchases.prod_id, purchases.store, sum(purchases.amount), product.p_name
FROM purchases, product where store = 3 and purchases.prod_id = product.p_id
group BY purchases.prod_id, product.p_id, purchases.store
ORDER by sum(purchases.amount) desc
limit 20;
SELECT purchases.prod_id, purchases.store, sum(purchases.amount), product.p_name
FROM purchases, product where store = 4 and purchases.prod_id = product.p_id
group BY purchases.prod_id, product.p_id, purchases.store
ORDER by sum(purchases.amount) desc
limit 20;
SELECT purchases.prod_id, purchases.store, sum(purchases.amount), product.p_name
FROM purchases, product where store = 5 and purchases.prod_id = product.p_id
group BY purchases.prod_id, product.p_id, purchases.store
ORDER by sum(purchases.amount) desc
limit 20;
SELECT purchases.prod_id, purchases.store, sum(purchases.amount), product.p_name
FROM purchases, product where store = 6 and purchases.prod_id = product.p_id
group BY purchases.prod_id, product.p_id, purchases.store
ORDER by sum(purchases.amount) desc
limit 20;
SELECT purchases.prod_id, purchases.store, sum(purchases.amount), product.p_name
FROM purchases, product where store = 7 and purchases.prod_id = product.p_id
group BY purchases.prod_id, product.p_id, purchases.store
ORDER by sum(purchases.amount) desc
limit 20;
SELECT purchases.prod_id, purchases.store, sum(purchases.amount), product.p_name
FROM purchases, product where store = 8 and purchases.prod_id = product.p_id
group BY purchases.prod_id, product.p_id, purchases.store
ORDER by sum(purchases.amount) desc
limit 20;
SELECT purchases.prod_id, purchases.store, sum(purchases.amount), product.p_name
FROM purchases, product where store = 9 and purchases.prod_id = product.p_id
group BY purchases.prod_id, product.p_id, purchases.store
ORDER by sum(purchases.amount) desc
limit 20;
SELECT purchases.prod_id, purchases.store, sum(purchases.amount), product.p_name
FROM purchases, product where store = 10 and purchases.prod_id = product.p_id
group BY purchases.prod_id, product.p_id, purchases.store
ORDER by sum(purchases.amount) desc
limit 20;



select purchases.store, sum(purchases.amount)
from purchases
group by purchases.store
order by sum(purchases.amount) desc
limit 5;

SELECT product_type.type_id
FROM product_type
WHERE product_type.type_id in (SELECT product_type.type_id FROM product_type
                                INNER JOIN prod_typee
                                    ON prod_typee.p_id = product_type.type_id
                                INNER JOIN purchases
                                    ON purchases.id = prod_typee.p_id
                              WHERE product_type.type_id != 2
)
LIMIT 3