# 🇧🇷 Brazilian E‑Commerce ELT Pipeline (Olist)

[![dbt tests](https://img.shields.io/badge/dbt%20tests-90%20passed-brightgreen)](https://github.com/YOUR_USER/brazil-ecom/tree/main/brazil_ecom/tests)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> A fully containerised, orchestrated ELT pipeline that transforms the **Brazilian Olist e‑commerce dataset** into a **star‑schema data warehouse** using PostgreSQL, dbt, DuckDB, and a Makefile.

## 📊 What this project delivers
- **90 automated data quality tests** – every gold table is trustworthy.
- **Star schema ready for BI** – single `fct_sales` table powers 80% of dashboard queries.
- **One‑command pipeline** – `make all` ingests, transforms, tests, and documents the data.

## 🧱 Architecture

[CSV Files] -> [Python Ingestion] -> [PostgreSQL (source)] -> [dbt + DuckDB (transformation)] -> [DuckDB File (star schema)] -> [Power BI]

## 🚀 Quick Start
1. Install Docker and Python 3.12.
2. Clone this repo.
3. Run `make all`.
4. Connect Power BI to `duckdb_data/dev.duckdb`.

## 🔍 Key Design Decisions
- **Why DuckDB?** Embedded OLAP, zero‑infrastructure, fast analytical queries.
- **Why a Makefile instead of Airflow?** The dataset is static – a lightweight orchestrator was the right choice.
- **How the customer dimension works:** Built on `customer_unique_id` (business key), not order‑level `customer_id`, ensuring correct aggregations.

## 📈 Business Insights
1. **Credit cards dominate revenue, but boleto punches above its weight.**  
   - Credit cards account for **76 % of total revenue** (R$ 15.5 M) and 78 % of all orders.  
   - Boleto has a nearly identical average ticket (R$ 177.54 vs. R$ 179.71 for credit cards) despite being used in only 19 % of orders.  
   - Debit cards and vouchers together contribute less than 2 % of revenue.

2. **Steady growth, with a sharp cut‑off in late 2018.**  
   - Monthly revenue climbed from R$ 57 k (Oct 2016) to over R$ 1 M throughout 2018.  
   - The dataset ends abruptly in September 2018 with a single order (R$ 166.46). All analysis is constrained to orders up to August 2018.

3. **Delivery performance varies dramatically by state.**  
   - **São Paulo** leads with an average delivery time of **8.7 days** and an on‑time rate of **94 %**.  
   - Northern and northeastern states (AP, RR, AM) experience the longest delays—**over 28 days** on average.  
   - Logistics improvements in those regions could yield the highest customer‑experience gains.

4. **Health & Beauty and Watches & Gifts are the top‑selling categories.**  
   - Together they generate **R$ 2.7 M** in revenue, followed closely by Bed & Bath and Sports & Leisure.  
   - These four categories account for over 50 % of all sales.

5. **Repeat customers are rare but valuable.**  
   - Only **3 % of customers** (2,913) made more than one purchase.  
   - Repeat customers spend on average **R$ 310.49**—nearly **double** the one‑time customer average (R$ 161.49).  
   - A targeted retention campaign could significantly boost revenue.

## 🧪 Testing Strategy
- dbt generic tests (unique, not_null, relationships).
- Custom dbt tests (row‑count reconciliation, business rules).
