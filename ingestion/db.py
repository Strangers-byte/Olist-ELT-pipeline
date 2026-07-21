import psycopg2
import os
import time
import logging_config
import logging

from dotenv import load_dotenv, find_dotenv

logger = logging.getLogger(__name__)

load_dotenv(find_dotenv())

def get_postgres_connection(retries=10, delay=3):
    """
        For Local run: takes Host, Port, Database, User and Password from env file to connect to Postgres DB
        For Docker run: takes Host, Port, Database, User and Password from variables declared in ternimal to connect to Postgres DB
    """
    for attempts in range(retries):
        try:
            conn = psycopg2.connect(
                host=os.getenv("PG_HOST", "postgresDB"),
                port=os.getenv('PG_PORT', '5432'),
                dbname=os.getenv("POSTGRES_DB", "pg_db"),
                user=os.getenv("POSTGRES_USER", "pg_user"),
                password=os.getenv("POSTGRES_PASSWORD", "pg_password")
            )
            logger.info("Connected to Postgres on attempt %d", attempts + 1)
            return conn
        except psycopg2.OperationalError as e:
            logger.warning("Attempt %d%d failed: %s", attempts + 1, retries, e)
            # print(f"Database not ready (attempt {attempts+1}/{retries}): {e}")
            time.sleep(delay)
    logger.error("Could not connect after %d attempts", retries)
    raise Exception("Could not connect after several retires")

def execute_sql_file(filepath):
    """Reads a .sql and executes it. """
    logger.info("File path recieved: %s", filepath)
    conn = get_postgres_connection()
    cur = conn.cursor()
    with open(filepath, 'r') as f:
        sql= f.read()
    cur.execute(sql)
    logger.info("SQL files executed")
    conn.commit()
    cur.close()
    conn.close()
    logger.info("Postgres connection closed")
    # print("Schema file executed")

