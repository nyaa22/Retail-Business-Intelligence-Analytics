# E-Commerce Sales Analytics

500 orders. Five payment methods. Eighteen states. One question driving all of it: where is this business actually making money, and where is it just moving volume.

This project follows the data through three stages of a normal analytics pipeline — a relational database built in SQL, exploratory analysis in Python, and a decision-ready dashboard in Power BI — rather than jumping straight from raw CSV to chart.
<img width="958" height="539" alt="image" src="https://github.com/user-attachments/assets/f1134f58-106e-4139-a45a-605734b82ab1" />


## What this answers

- Which states and cities are actually driving revenue, versus just noise
- Is profit tracking with sales, or are some categories quietly dragging margin down
- How concentrated is the customer base — are a handful of buyers carrying the business
- What payment methods dominate, and does that matter for cash flow
- Is there a seasonal pattern worth planning inventory or marketing around

## The pipeline

```
Raw CSVs (Orders, Customers)
        |
        v
   MySQL  (sql/)        -- schema design, joins, aggregate queries
        |
        v
   Python (python/)     -- merge, clean, distributions, correlation, EDA
        |
        v
   Power BI (powerbi/)  -- interactive dashboard for exploration and reporting
```

## Key metrics (KPIs)

| Metric | Value |
|---|---|
| Total Sales | 438K |
| Total Profit | 37K |
| Total Orders | 500 |
| Total Quantity | 6K |
| Average Order Value (AOV) | 875.54 |

## Dashboard features

- **Filters** — Order Date range, Category (Clothing, Electronics, Furniture, and more), State (multi-select checklist)
- **Total Sales by State** — Maharashtra and Madhya Pradesh lead by a wide margin
- **Total Sales by Month** — visual read on seasonal peaks and dips
- **Total Sales by Category** — Electronics, Clothing, and Furniture compared side by side
- **Total Sales by CustomerName** — top individual buyers by revenue contribution
- **Total Orders by PaymentMode** — COD (36.03 percent), UPI (23.26 percent), Debit Card (16.41 percent), Credit Card (13.29 percent), EMI (11.01 percent)
- **Total Profit by Category** — profit compared directly against sales volume by category

## SQL layer

The database is modeled as two related tables — `Orders` (transaction-level financials) and `Customers` (order date, buyer, and location) — joined on `Order_ID`. The query set in `sql/ecommerce_analytics_queries.sql` covers:

- Headline metrics: total sales, profit, orders, quantity, AOV, profit margin
- Sales and profit by state, top 10 cities by sales
- Category-level performance (sales, profit, quantity)
- Top 10 customers by revenue
- Payment mode distribution
- Monthly sales trend using `STR_TO_DATE` to parse the raw date format

## Python EDA

`python/ecommerce_analytics_eda.ipynb` picks up after the SQL layer and digs into distributions and relationships the dashboard summarizes:

- Merges Orders and Customers, checks shape, nulls, and data types
- Parses order dates and derives Month and Quarter
- Plots the distribution of order Amount and Profit
- Builds a correlation matrix across Amount, Profit, and Quantity
- Measures customer concentration — what share of revenue the top 5 customers actually hold
- Plots the monthly sales trend and revenue/profit by category

### Findings from the notebook

- Revenue showed seasonality, with peaks around January and March.
- Customer revenue was well distributed — the top 5 customers contributed only about 9 percent of total sales, so the business is not overly dependent on a small buyer base.
- Profit correlated weakly with quantity sold (roughly 0.06), meaning profitability comes more from product mix and pricing than from moving more units.

## Business insights and recommendations

Numbers on their own don't say much, so here is what they mean in practice.

**Margins are thinner than the topline suggests.** Total sales of 438K produced only 37K in profit, a margin of roughly 8.4 percent. A business can look healthy on revenue while quietly struggling on the line that actually matters. This is worth investigating at the cost or discounting level, not just the sales level.

**Two states carry a disproportionate share of the business.** Maharashtra and Madhya Pradesh together account for close to 43 percent of total sales, while several other states barely register. This cuts both ways: it shows where marketing spend is already working, but it also means a slowdown in either state would hit the topline hard. Worth asking whether other states are underserved or genuinely lower-potential.

**Electronics sells the most, but Clothing earns the most.** Sales ranking and profit ranking by category don't match — Electronics leads on revenue, but Clothing leads on profit. That gap usually points to thin margins on Electronics (price competition, higher cost of goods, or heavier discounting) rather than a demand problem. A pricing or supplier-cost review on Electronics specifically could recover margin without needing more sales volume.

**Cash on Delivery is the largest single payment mode at 36 percent.** COD delays when cash actually reaches the business and carries a higher risk of returns or failed deliveries compared to prepaid digital modes. A small incentive (discount or cashback) for switching to UPI could improve cash flow without much added cost.

**No single customer segment can make or break this business.** The top 5 customers contribute only about 9 percent of revenue, which is a sign of a healthy, broad customer base rather than dependency on a few large accounts. The flip side is that there is currently no clearly defined high-value segment to build a loyalty or retention program around — that could be worth creating rather than assuming it already exists.

**Demand is not flat across the year.** Sales peak around January and March, which should inform inventory build-up and staffing decisions ahead of those months rather than treating every month the same.

## Tools used

- MySQL — schema design and analytical queries
- Python (pandas, numpy, matplotlib, seaborn) — data merging, cleaning, and EDA
- Power BI Desktop — dashboard design and DAX measures


## How to use

1. Clone or download this repository
2. Run `sql/ecommerce_analytics_queries.sql` in MySQL to build the schema and explore the aggregate queries
3. Run `python/ecommerce_analytics_eda.ipynb` to reproduce the EDA and plots
4. Open `powerbi/Ecommerce_Sales_Dashboard.pbix` in Power BI Desktop and refresh the data source if prompted

