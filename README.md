# 🇧🇷 Brazilian E‑Commerce ELT Pipeline (Olist)

[![CI](https://github.com/YOUR_USER/brazil-ecom/actions/workflows/ci.yml/badge.svg)](https://github.com/YOUR_USER/brazil-ecom/actions/workflows/ci.yml)
[![dbt tests](https://img.shields.io/badge/dbt%20tests-90%20passed-brightgreen)](https://github.com/YOUR_USER/brazil-ecom/tree/main/brazil_ecom/tests)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> A fully containerised, orchestrated ELT pipeline that transforms the **Brazilian Olist e‑commerce dataset** into a **star‑schema data warehouse** using PostgreSQL, dbt, DuckDB, and a Makefile.

## 📊 What this project delivers
- **90 automated data quality tests** – every gold table is trustworthy.
- **Star schema ready for BI** – single `fct_sales` table powers 80% of dashboard queries.
- **One‑command pipeline** – `make all` ingests, transforms, tests, and documents the data.

## 🧱 Architecture
```mermaid
flowchart LR
    A[CSV Files] --> B[Python Ingestion]
    B --> C[PostgreSQL \n (source)]
    C --> D[dbt + DuckDB \n (transformation)]
    D --> E[DuckDB File \n (star schema)]
    E --> F[Power BI]

    style A fill:#f9f,stroke:#333
    style C fill:#ccf,stroke:#333
    style D fill:#cfc,stroke:#333
    style E fill:#cfc,stroke:#333
    style F fill:#ffc,stroke:#333
```

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
(Add 3‑5 findings from your dashboard here.)

## 🧪 Testing Strategy
- `pytest` unit tests for ingestion scripts.
- dbt generic tests (unique, not_null, relationships).
- Custom dbt tests (row‑count reconciliation, business rules).

## 📄 Project Structure
(Show your folder tree.)

## 🤝 Connect
(Your LinkedIn, email, etc.)