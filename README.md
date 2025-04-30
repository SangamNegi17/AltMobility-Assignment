# AltMobility-Assignment

Overview :
This project analyzes order and payment data for Alt Mobility using SQL. It covers four key business areas:

1. Order & Sales Analysis
2. Customer Behavior
3. Payment Success/Failure
4. Comprehensive Order Reporting

Dataset Description:
order.csv – Contains order-level information (order ID, customer ID, order date, amount, status, etc.)
payments.csv – Contains payment-level details (payment ID, order ID, payment status, method, date, and amount).

Task-Wise Approach

1. Order and Sales Analysis
Objective: Understand order fulfillment patterns and revenue trends.
a. Monthly sales performance (orders, revenue, AOV)
b. Order status distribution
c. Fulfillment timeline analysis
Methodology:
- Grouped order data by month and order status.
- Calculated conversion rates between order stages
- Analyzed time gaps between order and payment events
- Analyzed cancellation trends and revenue fluctuations.
  

2. Customer Behavior Analysis

Objective: Identify purchasing patterns and customer value.
a. Repeat purchase rate
b. Order frequency trends
c. Customer segmentation by spend
Methodology:
- Calculated first/last order dates for cohort analysis
- Tracked customer retention 
- New vs Returning Customers per month

3. Payment Status Analysis
Objective: Evaluate payment processing effectiveness
KPI-
a. Payment method success rates
b. Failure trends over time
c. Revenue realization rates
Methodology:
- Compared payment status across methods
- Calculated failure rates by time periods
- Analyzed correlation between order value and payment success

4. Comprehensive Order Reporting
Objective: Create unified operational view
Key Features:
a. Combined order and payment details
b.Calculated realized revenue
c. Days-to-payment metrics
