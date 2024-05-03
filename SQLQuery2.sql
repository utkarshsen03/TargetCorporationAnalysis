-- Customers

-- Total purchases
SELECT COUNT(*) AS [TOTAL PURCHASES]
FROM TargetCorporation..customers;

-- Total customers
SELECT COUNT(DISTINCT customer_unique_id) AS [TOTAL CUSTOMERS]
FROM TargetCorporation..customers;

-- Customer count by city
SELECT customer_city,
COUNT(customer_city) AS customers 
FROM TargetCorporation..customers
GROUP BY customer_city;

-- Unique zipcodes of customers
SELECT  customer_zip_code_prefix AS zip_code_prefix,COUNT(customer_zip_code_prefix) AS zip_count
FROM TargetCorporation..customers
GROUP BY customer_zip_code_prefix;

--Total zip codes used
SELECT COUNT(DISTINCT customer_zip_code_prefix) AS total_zip_codes
FROM TargetCorporation..customers;


-- Sellers

-- Total Sellers
SELECT COUNT(*) AS [TOTAL SELLERS]
FROM TargetCorporation..sellers;

-- Sellers in different cities
SELECT seller_state,
COUNT(seller_state) AS sellers
FROM TargetCorporation..sellers
GROUP BY seller_state;


-- Order Items

-- Table view of Order Items
SELECT *
FROM TargetCorporation..order_items;

-- Total items ordered
SELECT COUNT(order_item_id) AS [TOTAL ORDERS]
FROM TargetCorporation..order_items;

-- Profit
SELECT SUM(price) AS revenue, SUM(freight_value) AS cost, 
		((SUM(price)-SUM(freight_value))/SUM(price)) * 100 AS profit
FROM TargetCorporation..order_items;

--Maximum Price and Freight Price group by	shipping limit
SELECT shipping_limit_date, MAX(price) AS maximum_price, MAX(freight_value) AS maximum_freight_value
FROM TargetCorporation..order_items
GROUP BY shipping_limit_date
ORDER BY shipping_limit_date;

-- Total price and total freight value by shipping_limit_time
SELECT shipping_limit_date, SUM(price) AS total_price, SUM(freight_value) AS total_freight_value
FROM TargetCorporation..order_items
GROUP BY shipping_limit_date
ORDER BY shipping_limit_date;

-- Payments

-- Different methods of payment used
SELECT payment_type,COUNT(payment_type) AS USERS
FROM TargetCorporation..payments
GROUP BY payment_type;

-- price paid and installments used for different orders
SELECT DISTINCT order_id, MAX(payment_sequential) AS time_taken, 
		SUM(payment_installments) AS installments,
		SUM(payment_value) AS price_paid
FROM TargetCorporation..payments
GROUP BY order_id
HAVING SUM(payment_installments) > 1
ORDER BY installments;

-- Expected Payment per installment
SELECT order_id, (payment_value/payment_installments) AS expected_payment_per_installment
FROM TargetCorporation..payments
WHERE payment_installments != 0 AND (payment_value/payment_installments) !=0
ORDER BY expected_payment_per_installment DESC;


-- Orders

-- Group By Order Status
SELECT order_status, COUNT(order_status)  AS value_count
FROM TargetCorporation..orders
GROUP BY order_status
ORDER BY value_count DESC;

--Time taken to deliver order from purchase date
SELECT customer_id, (CAST(order_delivered_customer_date - order_purchase_timestamp AS int)) AS [TIME TAKEN (in days)],
		CAST(order_estimated_delivery_date - order_purchase_timestamp AS int) AS [EXPECTED TIME (in days)]
FROM TargetCorporation..orders
WHERE order_status = 'delivered';


-- Order Reviews


--Average review_score for each product
SELECT order_id, AVG(review_score) AS average_score
FROM TargetCorporation..order_reviews
GROUP BY order_id;


-- Products

SELECT *
FROM TargetCorporation..products
ORDER BY 2;

SELECT [product category], product_name_length,
product_description_length,product_photos_qty,
product_weight_g,product_length_cm,product_length_cm
FROM TargetCorporation..products
ORDER BY 2;

-- Products in different category
SELECT [product category], COUNT([product category]) AS value_count
FROM TargetCorporation..products
GROUP BY [product category]
ORDER BY 2 DESC;

-- Calculating Product Volume
SELECT [product category],product_name_length,
	product_weight_g, (product_length_cm * product_length_cm * product_height_cm) AS poduct_area_cm
FROM TargetCorporation..products;

-- Checking the maximum weights for each product category
SELECT [product category],MAX(product_weight_g) as maximum_weight_g
FROM TargetCorporation..products
GROUP BY [product category];




-- Order Items and Orders

-- Creating View for later analysis
CREATE VIEW shipment_data AS
SELECT order_items.order_id,order_items.shipping_limit_date, orders.order_status, orders.order_delivered_customer_date
FROM TargetCorporation..order_items
FULL JOIN TargetCorporation..orders
ON order_items.order_id = orders.order_id;
