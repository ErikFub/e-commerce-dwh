DO
$$
DECLARE
i record;
BEGIN
FOR i in 1..2000 LOOP

WITH
    customer AS (SELECT * FROM raw.application__customer ORDER BY random() LIMIT 1),
    article AS (SELECT reducedprice, originalprice, a.id FROM raw.application__customer c, raw.application__articles a JOIN raw.application__products p ON a.productid = p.id WHERE
    p.gender = c.gender ORDER BY random() LIMIT (floor(random() * 10 / 2) + 1)),
    order_ts AS (SELECT NOW() - random() * ('2 YEARS' :: interval) as ts),
    sum AS (SELECT sum(coalesce(article.reducedprice, article.originalprice)) as total FROM article),
    order_insert AS (INSERT INTO raw.application__order (customerId, ordertimestamp, shippingaddressid, total, shippingcost)
                     SELECT customer.id, order_ts.ts, customer.currentaddressid, sum.total, 3.9
                     FROM customer, order_ts, sum RETURNING raw.application__order.id as new_order_id)

  INSERT INTO raw.application__order_positions (orderid, articleid, amount, price)
  SELECT
    new_order_id,
    article.id,
    1                                     as amount,
    coalesce(reducedprice, originalprice) as paid_price
  FROM article, order_insert;

END LOOP;
END;
$$