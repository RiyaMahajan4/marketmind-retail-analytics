-- =====================================
-- MarketMind Retail Intelligence Platform
-- Module 1 : Executive KPIs
-- =====================================
SELECT
    ROUND(SUM(payment_value), 2) AS total_revenue
FROM ORDER_PAYMENTS;
SELECT
    COUNT(*) AS total_orders
FROM ORDERS;
SELECT
    COUNT(DISTINCT customer_unique_id) AS total_customers
FROM CUSTOMERS;
SELECT
    COUNT(*) AS total_products_sold
FROM ORDER_ITEMS;
SELECT
    COUNT(*) AS total_sellers
FROM SELLERS;
SELECT
    COUNT(*) AS total_products
FROM PRODUCTS;
SELECT
    ROUND(
        SUM(payment_value) / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM ORDER_PAYMENTS;
SELECT
    ROUND(AVG(review_score), 2) AS average_review_score
FROM ORDER_REVIEWS;
-- Module 2 : Sales Analysis
--Monthly Revenue Trend
SELECT
    TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS month,
    ROUND(SUM(op.payment_value), 2) AS monthly_revenue
FROM ORDERS o
JOIN ORDER_PAYMENTS op
ON o.order_id = op.order_id
GROUP BY TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM')
ORDER BY month;
--Monthly Order Trend
SELECT
    TO_CHAR(order_purchase_timestamp, 'YYYY-MM') AS month,
    COUNT(*) AS total_orders
FROM ORDERS
GROUP BY TO_CHAR(order_purchase_timestamp, 'YYYY-MM')
ORDER BY month;
--Yearly Revenue Trend
SELECT
    TO_CHAR(o.order_purchase_timestamp, 'YYYY') AS year,
    ROUND(SUM(op.payment_value), 2) AS yearly_revenue
FROM ORDERS o
JOIN ORDER_PAYMENTS op
ON o.order_id = op.order_id
GROUP BY TO_CHAR(o.order_purchase_timestamp, 'YYYY')
ORDER BY year;
--Yearly Order Trend
SELECT
    TO_CHAR(order_purchase_timestamp, 'YYYY') AS year,
    COUNT(*) AS total_orders
FROM ORDERS
GROUP BY TO_CHAR(order_purchase_timestamp, 'YYYY')
ORDER BY year;
--Top 10 Revenue Months
SELECT
    TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS month,
    ROUND(SUM(op.payment_value), 2) AS revenue
FROM ORDERS o
JOIN ORDER_PAYMENTS op
ON o.order_id = op.order_id
GROUP BY TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM')
ORDER BY revenue DESC
LIMIT 10;
--Lowest 10 Revenue Months
SELECT
    TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS month,
    ROUND(SUM(op.payment_value), 2) AS revenue
FROM ORDERS o
JOIN ORDER_PAYMENTS op
ON o.order_id = op.order_id
GROUP BY TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM')
ORDER BY revenue ASC
LIMIT 10;
--Average Monthly Revenue
SELECT
    ROUND(AVG(monthly_revenue), 2) AS average_monthly_revenue
FROM (
    SELECT
        TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM') AS month,
        SUM(op.payment_value) AS monthly_revenue
    FROM ORDERS o
    JOIN ORDER_PAYMENTS op
    ON o.order_id = op.order_id
    GROUP BY TO_CHAR(o.order_purchase_timestamp, 'YYYY-MM')
) t;
--Revenue by Order Status
SELECT
    o.order_status,
    ROUND(SUM(op.payment_value), 2) AS revenue
FROM ORDERS o
JOIN ORDER_PAYMENTS op
ON o.order_id = op.order_id
GROUP BY o.order_status
ORDER BY revenue DESC;
--Module 3: Customer Analysis
--Customers by State
SELECT
    customer_state,
    COUNT(customer_id) AS total_customers
FROM CUSTOMERS
GROUP BY customer_state
ORDER BY total_customers DESC;
--Top 10 States by Revenue
SELECT
    c.customer_state,
    ROUND(SUM(op.payment_value),2) AS revenue
FROM CUSTOMERS c
JOIN ORDERS o
ON c.customer_id = o.customer_id
JOIN ORDER_PAYMENTS op
ON o.order_id = op.order_id
GROUP BY c.customer_state
ORDER BY revenue DESC
LIMIT 10;
--Top 10 Cities by Revenue
SELECT
    c.customer_city,
    ROUND(SUM(op.payment_value),2) AS revenue
FROM CUSTOMERS c
JOIN ORDERS o
ON c.customer_id = o.customer_id
JOIN ORDER_PAYMENTS op
ON o.order_id = op.order_id
GROUP BY c.customer_city
ORDER BY revenue DESC
LIMIT 10;
--Average Revenue per Customer
SELECT
ROUND(
SUM(payment_value)/COUNT(DISTINCT o.customer_id),
2
) AS average_revenue_per_customer
FROM ORDERS o
JOIN ORDER_PAYMENTS op
ON o.order_id=op.order_id;
--Repeat vs Unique Customers
SELECT
COUNT(*) AS repeat_customers
FROM (
    SELECT c.customer_unique_id
    FROM ORDERS o
    JOIN CUSTOMERS c
    ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
    HAVING COUNT(o.order_id) > 1
) t;
--Top 10 Customers by Spending
SELECT
o.customer_id,
ROUND(SUM(op.payment_value),2) AS total_spent
FROM ORDERS o
JOIN ORDER_PAYMENTS op
ON o.order_id=op.order_id
GROUP BY o.customer_id
ORDER BY total_spent DESC
LIMIT 10;
--Review Score Distribution
SELECT
review_score,
COUNT(*) AS total_reviews
FROM ORDER_REVIEWS
GROUP BY review_score
ORDER BY review_score;
--Module 4: Product Analysis
--Top 10 Product Categories by Revenue
SELECT
    pct.product_category_name_english AS category,
    ROUND(SUM(op.payment_value),2) AS revenue
FROM PRODUCTS p
JOIN PRODUCT_CATEGORY_TRANSLATION pct
ON p.product_category_name = pct.product_category_name
JOIN ORDER_ITEMS oi
ON p.product_id = oi.product_id
JOIN ORDER_PAYMENTS op
ON oi.order_id = op.order_id
GROUP BY pct.product_category_name_english
ORDER BY revenue DESC
LIMIT 10;
--Top 10 Product Categories by Orders
SELECT
    pct.product_category_name_english AS category,
    COUNT(oi.order_id) AS total_orders
FROM PRODUCTS p
JOIN PRODUCT_CATEGORY_TRANSLATION pct
ON p.product_category_name = pct.product_category_name
JOIN ORDER_ITEMS oi
ON p.product_id = oi.product_id
GROUP BY pct.product_category_name_english
ORDER BY total_orders DESC
LIMIT 10;
--Average Product Price
SELECT
ROUND(AVG(price),2) AS average_product_price
FROM ORDER_ITEMS;
--Top 10 Sellers by Revenue
SELECT
seller_id,
ROUND(SUM(price),2) AS revenue
FROM ORDER_ITEMS
GROUP BY seller_id
ORDER BY revenue DESC
LIMIT 10;
--Average Freight Cost
SELECT
ROUND(AVG(freight_value),2) AS average_freight_cost
FROM ORDER_ITEMS;
--Revenue Contribution by Product Category
SELECT
    pct.product_category_name_english AS category,
    ROUND(SUM(op.payment_value),2) AS revenue
FROM PRODUCTS p
JOIN PRODUCT_CATEGORY_TRANSLATION pct
ON p.product_category_name = pct.product_category_name
JOIN ORDER_ITEMS oi
ON p.product_id = oi.product_id
JOIN ORDER_PAYMENTS op
ON oi.order_id = op.order_id
GROUP BY pct.product_category_name_english
ORDER BY revenue DESC;
--Top 10 Most Expensive Products
SELECT
product_id,
MAX(price) AS highest_price
FROM ORDER_ITEMS
GROUP BY product_id
ORDER BY highest_price DESC
LIMIT 10;
--: Product Price Distribution
SELECT
CASE
WHEN price < 50 THEN 'Below 50'
WHEN price BETWEEN 50 AND 100 THEN '50-100'
WHEN price BETWEEN 101 AND 500 THEN '101-500'
ELSE 'Above 500'
END AS price_range,
COUNT(*) AS total_products
FROM ORDER_ITEMS
GROUP BY price_range
ORDER BY total_products DESC;
--Module 5: Delivery & Logistics Analysis
-- Average Delivery Time
SELECT
ROUND(
AVG(
DATEDIFF(day,
order_purchase_timestamp,
order_delivered_customer_date)
),2) AS average_delivery_days
FROM ORDERS
WHERE order_delivered_customer_date IS NOT NULL;
--Average Delay Beyond Estimated Delivery
SELECT
ROUND(
AVG(
DATEDIFF(day,
order_estimated_delivery_date,
order_delivered_customer_date)
),2) AS average_delay_days
FROM ORDERS
WHERE order_delivered_customer_date IS NOT NULL
AND order_estimated_delivery_date IS NOT NULL;
--On-time vs Late Deliveries
SELECT
CASE
WHEN order_delivered_customer_date <= order_estimated_delivery_date
THEN 'On Time'
ELSE 'Late'
END AS delivery_status,
COUNT(*) AS total_orders
FROM ORDERS
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY delivery_status;
--Average Delivery Time by State
SELECT
c.customer_state,
ROUND(
AVG(
DATEDIFF(day,
o.order_purchase_timestamp,
o.order_delivered_customer_date)
),2) AS average_delivery_days
FROM ORDERS o
JOIN CUSTOMERS c
ON o.customer_id = c.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY average_delivery_days DESC;
--Orders by Order Status
SELECT
order_status,
COUNT(*) AS total_orders
FROM ORDERS
GROUP BY order_status
ORDER BY total_orders DESC;
--Average Carrier Pickup Time
SELECT
ROUND(
AVG(
DATEDIFF(day,
order_purchase_timestamp,
order_delivered_carrier_date)
),2) AS average_carrier_pickup_days
FROM ORDERS
WHERE order_delivered_carrier_date IS NOT NULL;
--Orders Delivered Early
SELECT
COUNT(*) AS early_deliveries
FROM ORDERS
WHERE order_delivered_customer_date < order_estimated_delivery_date;
--Average Approval Time
SELECT
ROUND(
AVG(
DATEDIFF(hour,
order_purchase_timestamp,
order_approved_at)
),2) AS average_approval_hours
FROM ORDERS
WHERE order_approved_at IS NOT NULL;
--Module 6: Payment Analysis
-- Payment Method Distribution
SELECT
    payment_type,
    COUNT(*) AS total_transactions
FROM ORDER_PAYMENTS
GROUP BY payment_type
ORDER BY total_transactions DESC;
--Revenue by Payment Method
SELECT
    payment_type,
    ROUND(SUM(payment_value),2) AS revenue
FROM ORDER_PAYMENTS
GROUP BY payment_type
ORDER BY revenue DESC;
--Average Payment Value by Payment Method
SELECT
    payment_type,
    ROUND(AVG(payment_value),2) AS average_payment
FROM ORDER_PAYMENTS
GROUP BY payment_type
ORDER BY average_payment DESC;
--Average Number of Installments
SELECT
ROUND(AVG(payment_installments),2) AS average_installments
FROM ORDER_PAYMENTS;
--Installments Distribution
SELECT
    payment_installments,
    COUNT(*) AS total_orders
FROM ORDER_PAYMENTS
GROUP BY payment_installments
ORDER BY payment_installments;
--Highest Single Payment
SELECT
ROUND(MAX(payment_value),2) AS highest_payment
FROM ORDER_PAYMENTS;
--Orders with Multiple Payments
SELECT
COUNT(*) AS orders_with_multiple_payments
FROM (
    SELECT
        order_id
    FROM ORDER_PAYMENTS
    GROUP BY order_id
    HAVING COUNT(*) > 1
) t;
--Average Payment per Order
SELECT
ROUND(AVG(payment_value),2) AS average_payment_per_order
FROM ORDER_PAYMENTS;


































































