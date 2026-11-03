CREATE OR REPLACE TABLE PRODUCTS (
    product_id STRING,
    product_category_name STRING,
    product_name_lenght NUMBER,
    product_description_lenght NUMBER,
    product_photos_qty NUMBER,
    product_weight_g NUMBER,
    product_length_cm NUMBER,
    product_height_cm NUMBER,
    product_width_cm NUMBER
);

SELECT COUNT(*) AS total_products
FROM PRODUCTS;

SELECT * FROM PRODUCTS
LIMIT 10;

CREATE OR REPLACE TABLE SELLERS (
    seller_id STRING,
    seller_zip_code_prefix NUMBER,
    seller_city STRING,
    seller_state STRING
);

SELECT COUNT(*) AS total_sellers
FROM SELLERS;