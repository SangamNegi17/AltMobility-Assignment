Key Insights:
Order Fulfillment Patterns:
1. Order status is evenly distributed (33% pending, 34% delivered, 33% shipped)
2. Delivered orders are fulfilled in ~1.7 days, indicating efficient processing.
3. Negative days-to-payment for shipped orders (-7.3 days) suggests payment recording before shipment or prepaid or early payments, or data inconsistency.
4. Pending orders take 28.5 days on average for payment completion, suggesting delays or issues in confirmation or follow-through.
5. Total revenue from delivered orders is the highest: ₹12.8L+.

 
Customer Behavior:
1. Healthy 60% repeat customer rate — a strong indicator of satisfaction and loyalty.
2. Low-value customers form the majority (4230), showing an opportunity to upsell.
3. Medium-value customers (₹500–₹999) make up the largest revenue share: 2,404 customers generating ₹17.17L.
4. High-value customers (12-17% of total) generate 31% of revenue
5. Average order value ranges ₹245-272, peaking in June 2024 (₹272.69).
6. Recent months (2024–2025) show 2.5x more returning customers than new ones, signaling customer stickiness but also indicating slowing new customer acquisition.



Payment Performance:
1. 33% payment failure rate (equal distribution across statuses)
2. Bank transfers have highest failure rate (34.4%) despite being most used (revenue ₹13L+)
3. Failure rates fluctuate between 29-41% monthly with no clear improvement trend
4. ₹12.7L+ is locked in pending payments — a major cash flow issue


Operational Metrics:
1. 1.3-1.5 orders per active customer monthly
2. Repeat customer rate increased from 2.5% (Feb 2020) to 82% (April 2025)
3. New customer acquisition declined by 80% since 2020



Key Findings
Initial Retention Rates: The first month (Cohort Index 1) consistently shows the highest retention rates, as it includes all customers making their initial purchase means they are new customers . Subsequent months exhibit an irregular decline in retention, which is typical in customer behavior patterns.​

Variation Across Cohorts: Retention rates vary across different cohorts, suggesting that external factors such as marketing campaigns, seasonality, or changes in customer experience may influence customer loyalty.​

Segment-Specific Insights: Filtering by customer attributes reveals that certain segments, such as those using specific payment methods or from particular regions, have higher retention rates. This indicates opportunities for targeted retention strategies.​

Trend Analysis: The line graph indicates whether retention is improving or declining over time, providing insights into the long-term effectiveness of customer engagement initiatives.

Codes of custom column:

1. Cohort_Index =
DATEDIFF(
    Merged_table[First_Order_Date],
    Merged_table[order_date],
    MONTH
) + 1


2. Cohort_Month = FORMAT(Merged_table[First_Order_Date], "YYYY-MM")


3. First_Order_Date =
CALCULATE(
    MIN(Merged_table[order_date]),
    ALLEXCEPT(Merged_table, Merged_table[customer_id])
)


4. Order_Month = FORMAT(Merged_table[order_date], "YYYY-MM")

