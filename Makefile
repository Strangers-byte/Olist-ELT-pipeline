.PHONY: all up down ingest dbt-debug dbt-run dbt-test dbt-docs clean

include .env
export

all: up ingest dbt-debug dbt-run dbt-test dbt-docs
	@echo "Pipeline complete. DuckDB file ready at duckdb_data/dev.duckdb"

up:
	docker compose up -d postgresDB
	@echo "Waiting for PostgreSQL..."
	@until docker compose exec -T postgresDB pg_isready -U $(POSTGRES_USER) -d $(POSTGRES_DB); do sleep 2; done

down:
	docker compose down

ingest:
	brazil_env/Scripts/python.exe main.py

dbt-debug:
	cd brazil_ecom && ../brazil_env/Scripts/dbt.exe debug --profiles-dir .

dbt-run:
	cd brazil_ecom && ../brazil_env/Scripts/dbt.exe run --profiles-dir .

dbt-test:
	cd brazil_ecom && ../brazil_env/Scripts/dbt.exe test --profiles-dir .

dbt-docs:
	cd brazil_ecom && ../brazil_env/Scripts/dbt.exe docs generate --profiles-dir .

clean:
	docker compose down -v
	rm -rf duckdb_data/dev.duckdb
	cd brazil_ecom && ../brazil_env/Scripts/dbt.exe clean