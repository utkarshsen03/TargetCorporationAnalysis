/*

Data Cleaning using SQL Queries

*/


-- View Data

SELECT *
FROM TargetCorporation.dbo.order_reviews;


-- Standardize Date Format

-- Check how conversion would look
SELECT review_answer_timestamp, CONVERT(datetime,review_answer_timestamp,5)
FROM TargetCorporation.dbo.order_reviews;

-- Create new column for converted date
ALTER TABLE TargetCorporation.dbo.order_reviews
ADD review_answer_timestamp_converted Date;

-- Update the values in the new column
UPDATE TargetCorporation.dbo.order_reviews
SET review_answer_timestamp_converted = CONVERT(varchar,review_answer_timestamp,5);


-- Handling Null Values

UPDATE TargetCorporation.dbo.order_reviews
SET review_comment_title = ISNULL(review_comment_title,'NO REVIEW')
FROM TargetCorporation.dbo.order_reviews;


-- Creating new column for payment method

-- Distinct payment types
select distinct(payment_type), COUNT(payment_type)
from TargetCorporation.dbo.payments
GROUP BY payment_type
ORDER BY 2;

-- Create new column for payment method
ALTER TABLE TargetCorporation.dbo.payments
ADD payment_method NVARCHAR(15);

-- Update the table to include payment method
UPDATE TargetCorporation.dbo.payments
SET payment_method = CASE WHEN payment_type = 'debit_card' THEN 'card'
	 WHEN payment_type = 'credit_card' THEN 'card'
	 WHEN payment_type = 'UPI' THEN 'online'
	 ELSE ISNULL(payment_method,'others')
	 END;

-- Show payment method
select distinct(payment_method), COUNT(payment_method)
from TargetCorporation.dbo.payments
GROUP BY payment_method
ORDER BY 2;


-- Checking Duplicates


WITH check_duplicateCTE AS(
SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY customer_id,
				 order_purchase_timestamp,
				 order_approved_at,
				 order_status
				 ORDER BY
				 order_id) row_num
FROM TargetCorporation.dbo.orders
)
SELECT *
FROM check_duplicateCTE
WHERE row_num > 1;


-- Deleting Column

ALTER TABLE TargetCorporation.dbo.order_reviews
DROP COLUMN review_answer_timestamp;

SELECT * 
FROM TargetCorporation.dbo.order_reviews;