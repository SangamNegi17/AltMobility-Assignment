SELECT * FROM altmobility.order;
select * from altmobility.payments;
use altmobility;

#  1. Order and Sales Analysis

-- 1.1 Order status distribution
SELECT 
    order_status,
    COUNT(*) AS order_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage,
    SUM(order_amount) AS total_revenue
FROM altmobility.order
GROUP BY order_status
ORDER BY order_count DESC;


-- 1.2 Monthly order and sales trend
SELECT 
    DATE_FORMAT(order_date, '%Y-%m-01') AS month_start,
    COUNT(*) AS total_orders,
    round(SUM(order_amount) ,2) AS total_revenue,
    round(AVG(order_amount) ,2) AS average_order_value
FROM altmobility.order
GROUP BY month_start
ORDER BY month_start;


-- 1.3 Order fulfillment timeline (days from order to payment)
SELECT 
    o.order_status,
    AVG(DATEDIFF(p.payment_date, o.order_date)) AS avg_days_to_payment,
    COUNT(*) AS order_count
FROM altmobility.order o
JOIN altmobility.payments p ON o.order_id = p.order_id
GROUP BY o.order_status;





# Task 2: Customer Analysis

-- 2.1 Repeat customers
SELECT customer_id, COUNT(order_id) AS total_orders
FROM altmobility.order
GROUP BY customer_id
HAVING COUNT(order_id) > 1;


-- 2.2 Customer ordering frequency
SELECT 
    customer_id,
    COUNT(*) AS order_count,
    SUM(order_amount) AS total_spend,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(MAX(order_date), MIN(order_date)) AS customer_lifetime_days
FROM altmobility.order
GROUP BY customer_id
ORDER BY order_count DESC;


-- 2.3 Customer segmentation by spend
WITH customer_stats AS (
    SELECT 
        customer_id,
        COUNT(*) AS order_count,
        SUM(order_amount) AS total_spend
    FROM altmobility.order
    GROUP BY customer_id
)
SELECT 
    CASE 
        WHEN total_spend >= 1000 THEN 'High Value'
        WHEN total_spend >= 500 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment,
    COUNT(*) AS customer_count,
    round(SUM(total_spend) , 2) AS segment_revenue,
    round(AVG(total_spend) ,2) AS avg_spend
FROM customer_stats
GROUP BY customer_segment
ORDER BY segment_revenue DESC;




-- 2.4 Repeat customer rate
WITH customer_order_counts AS (
    SELECT 
        customer_id,
        COUNT(*) AS order_count
    FROM altmobility.order
    GROUP BY customer_id
)
SELECT 
    SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS repeat_customer_rate
FROM customer_order_counts;



-- 2.5 New vs Returning Customers per month
WITH customer_first_order AS (
  SELECT customer_id, MIN(order_date) AS first_order_date
  FROM altmobility.order
  GROUP BY customer_id
)
SELECT 
  DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
  COUNT(DISTINCT CASE WHEN o.order_date = c.first_order_date THEN o.customer_id END) AS new_customers,
  COUNT(DISTINCT CASE WHEN o.order_date > c.first_order_date THEN o.customer_id END) AS returning_customers
FROM altmobility.`order` o
JOIN customer_first_order c ON o.customer_id = c.customer_id
GROUP BY order_month
ORDER BY order_month;



# Task 3: Payment Status Analysis


-- 3.1 Payment status distribution
SELECT 
    payment_status,
    COUNT(*) AS payment_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage,
    ROUND(SUM(payment_amount) ,0) AS total_amount
FROM altmobility.payments
GROUP BY payment_status
ORDER BY payment_count DESC;


-- 3.2 Monthly failed vs successful payments
SELECT 
  DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
  SUM(CASE WHEN payment_status = 'completed' THEN 1 ELSE 0 END) AS Successful_Payment,
  SUM(CASE WHEN payment_status != 'completed' THEN 1 ELSE 0 END) AS Pending_or_Failed
FROM altmobility.payments
GROUP BY payment_month
ORDER BY payment_month;


-- 3.3 Payment method analysis
SELECT 
    payment_method,
    COUNT(*) AS payment_count,
    ROUND(SUM(payment_amount), 2) AS total_amount,
    ROUND(AVG(payment_amount), 2) AS average_payment,
    ROUND(SUM(CASE WHEN payment_status = 'failed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate
FROM altmobility.payments
GROUP BY payment_method
ORDER BY total_amount DESC;



-- 3.4 Payment failure trends over time
SELECT 
    DATE_FORMAT(payment_date, '%Y-%m-01') AS month_start,
    COUNT(*) AS total_payments,
    SUM(CASE WHEN payment_status = 'failed' THEN 1 ELSE 0 END) AS failed_payments,
    ROUND(SUM(CASE WHEN payment_status = 'failed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_perc_rate
FROM altmobility.payments
GROUP BY month_start
ORDER BY month_start;



# 4. Order Details Report
-- 4.1
SELECT 
  o.order_id,
  o.customer_id,
  o.order_date,
  o.order_status,
  o.order_amount,
  p.payment_id,
  p.payment_date,
  p.payment_method,
  p.payment_amount,
  p.payment_status
FROM altmobility.order o
LEFT JOIN payments p ON o.order_id = p.order_id;

 
 -- 4.2 Key metrics summary

-- Creating a temporary table for customer first orders
CREATE TEMPORARY TABLE customer_first_orders AS
SELECT 
    customer_id,
    DATE_FORMAT(MIN(order_date), '%Y-%m-01') AS first_order_month
FROM altmobility.order
GROUP BY customer_id;


SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m-01') AS month,
    COUNT(DISTINCT o.customer_id) AS active_customers,
    COUNT(*) AS total_orders,
    ROUND(SUM(o.order_amount),2 ) AS gross_revenue,
    ROUND(SUM(CASE WHEN p.payment_status = 'completed' THEN o.order_amount ELSE 0 END), 2) AS realized_revenue,
    COUNT(DISTINCT CASE WHEN cfo.first_order_month < DATE_FORMAT(o.order_date, '%Y-%m-01') 
          THEN o.customer_id END) AS repeat_customers,
    ROUND(COUNT(DISTINCT CASE WHEN cfo.first_order_month < DATE_FORMAT(o.order_date, '%Y-%m-01') 
          THEN o.customer_id END) * 100.0 / 
          NULLIF(COUNT(DISTINCT o.customer_id), 0), 2) AS repeat_customer_rate,
    ROUND(SUM(CASE WHEN p.payment_status = 'completed' THEN o.order_amount ELSE 0 END) / 
          NULLIF(COUNT(DISTINCT o.customer_id), 0), 2) AS revenue_per_customer,
    ROUND(COUNT(*) / NULLIF(COUNT(DISTINCT o.customer_id), 0), 2) AS orders_per_customer
FROM altmobility.order o
LEFT JOIN altmobility.payments p ON o.order_id = p.order_id
LEFT JOIN customer_first_orders cfo ON o.customer_id = cfo.customer_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m-01')
ORDER BY month;

-- Clean up Temp Table
DROP TEMPORARY TABLE IF EXISTS customer_first_orders;




 