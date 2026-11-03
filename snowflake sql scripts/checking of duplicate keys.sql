//Check Primary key duplicates
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customer_ids
FROM CUSTOMERS;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_order_ids
FROM ORDERS;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_product_ids
FROM PRODUCTS;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT seller_id) AS unique_seller_ids
FROM SELLERS;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT review_id) AS unique_review_ids
FROM ORDER_REVIEWS;

--Composite keys
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id || '-' || order_item_id) AS unique_order_items
FROM ORDER_ITEMS;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id || '-' || payment_sequential) AS unique_payments
FROM ORDER_PAYMENTS;

//Check Foreign key Relationships
SELECT COUNT(*)
FROM ORDERS o
LEFT JOIN CUSTOMERS c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

//Missing records
SELECT
    COUNT(*) AS total_products,
    COUNT(*) - COUNT(product_category_name) AS missing_category,
    COUNT(*) - COUNT(product_name_lenght) AS missing_name_length,
    COUNT(*) - COUNT(product_description_lenght) AS missing_description_length,
    COUNT(*) - COUNT(product_photos_qty) AS missing_photos
FROM PRODUCTS;

SELECT
    COUNT(*) AS total_reviews,
    COUNT(*) - COUNT(review_comment_title) AS missing_review_titles,
    COUNT(*) - COUNT(review_comment_message) AS missing_review_messages
FROM ORDER_REVIEWS;
