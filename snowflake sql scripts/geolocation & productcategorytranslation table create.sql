CREATE OR REPLACE TABLE GEOLOCATION (
    geolocation_zip_code_prefix NUMBER,
    geolocation_lat NUMBER(10,8),
    geolocation_lng NUMBER(11,8),
    geolocation_city STRING,
    geolocation_state STRING
);

SELECT COUNT(*) AS total_geolocations
FROM GEOLOCATION;

CREATE OR REPLACE TABLE PRODUCT_CATEGORY_TRANSLATION (
    product_category_name STRING,
    product_category_name_english STRING
);

SELECT COUNT(*) AS total_categories
FROM PRODUCT_CATEGORY_TRANSLATION;