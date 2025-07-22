# Supply-Chain-Analysis-using-SQL
This project explores real-world supply chain data using SQL to answer key business questions related to orders, cancellations, and customer trends. It demonstrates my ability to work with structured datasets, write effective queries, and derive actionable insights from transactional data.

## Project Structure

- `supplychain.db` – SQLite database with imported supply chain data  
- `supply_chain.sql` – SQL queries for data analysis  
- `data/` – Raw CSV files (`sales_test.csv` and `canceled_test.csv`)  
- `README.md` – Project overview and documentation

## Data Overview

The analysis is based on two datasets:

1. **sales_test.csv** – Contains successful customer orders  
   - Columns: `ORDER_NO`, `DATE`, `LINE`, `CUSTOMER_NO`, `ITEM`, `NS_ORDER`, `NS_SHIP`

2. **canceled_test.csv** – Contains cancelled or unfulfilled orders  
   - Columns: `ORDER_NO`, `DATE`, `LINE`, `CUSTOMER_NO`, `ITEM`, `NC_ORDER`, `NC_SHIP`

Both datasets span **January–March 2017** and include customer-level order line data.

##  Key Questions Explored

This project dives into supply chain data to uncover valuable insights, including:

- **How busy was January 2017?** Counting all orders placed.  
- **February’s volume:** Total units ordered — did demand rise or fall?  
- **Who’s canceling?** Tracking canceled orders by customer.  
- **Customer count:** How many unique buyers shaped the story?  
- **Order insights:** Average items per order and top 5 best-selling products.  
- **VIP customers:** How did our key customers perform in January?  


### Diving Deeper

- **Order vs. cancellation:** Which items shine and which stumble?  
- **Order sizes:** Grouping orders into High, Medium, and Low volumes.  
- **Shipping success:** What percentage of orders actually shipped per customer?  
- **Top cancelers:** Who’s leading the cancellation leaderboard?  
- **Order champions:** Biggest customers and biggest orders in January.  


###  Advanced Analytics

- **Customer journey:** Tracking order totals over time with a running tally.  
- **Cancellation-sales showdown:** Top canceled customers and their sales impact.  
- **Sales power players:** Who drives the lion’s share of revenue?  
- **ABC inventory magic:** Classifying products into A, B, and C categories — the 80/20 rule in action.  


## Tools Used

- SQL (SQLite dialect)
- SQLite Explorer Extension (VS Code)
- VS Code for query execution and scripting

## What I learnt

- Designing and querying relational datasets
- Performing SQL-based EDA (Exploratory Data Analysis)
- Using SQLite with VS Code for lightweight data projects
- Structuring SQL projects for clarity and reproducibility

## Next Steps

Looking ahead, I plan to expand this project by:

- Integrating time-series analysis to forecast demand and cancellations.  
- Building interactive dashboards for visual insights using Power BI or Tableau.  
- Enhancing data quality with automated cleaning and anomaly detection.  
- Exploring machine learning models to predict order cancellations and customer churn.
