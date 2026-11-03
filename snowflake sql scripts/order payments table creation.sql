CREATE OR REPLACE TABLE ORDER_PAYMENTS (
    order_id STRING,
    payment_sequential NUMBER,
    payment_type STRING,
    payment_installments NUMBER,
    payment_value NUMBER(10,2)
);

SELECT COUNT(*) AS total_payments
FROM ORDER_PAYMENTS;

SELECT *
FROM ORDER_PAYMENTS
LIMIT 10;