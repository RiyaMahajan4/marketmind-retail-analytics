-- Step 1: Create a named stage for loading data
CREATE STAGE IF NOT EXISTS MARKETMIND_DB.RETAIL.ORDERS_STAGE
    FILE_FORMAT = (
        TYPE=CSV,
        SKIP_HEADER=1,
        FIELD_DELIMITER=',',
        TRIM_SPACE=TRUE,
        FIELD_OPTIONALLY_ENCLOSED_BY='"',
        REPLACE_INVALID_CHARACTERS=TRUE,
        DATE_FORMAT='DD-MM-YYYY',
        TIME_FORMAT='HH24:MI',
        TIMESTAMP_FORMAT='DD-MM-YYYY HH24:MI'
    );

-- Step 2: Upload the file (run this from SnowSQL or the Snowsight upload UI on the stage)
-- PUT file:///path/to/olist_orders_dataset.csv @MARKETMIND_DB.RETAIL.ORDERS_STAGE;

-- Step 3: Load data from the stage into the table
COPY INTO MARKETMIND_DB.RETAIL.ORDERS
FROM @MARKETMIND_DB.RETAIL.ORDERS_STAGE/olist_orders_dataset.csv
ON_ERROR=ABORT_STATEMENT;

LIST @ORDERS_STAGE;

COPY INTO MARKETMIND_DB.RETAIL.ORDERS
FROM @MARKETMIND_DB.RETAIL.ORDERS_STAGE
FILES = ('olist_orders_dataset.csv')
ON_ERROR = ABORT_STATEMENT;

SELECT COUNT(*) AS total_orders
FROM ORDERS;

SELECT *
FROM ORDERS
LIMIT 10;