import logging

from ingestion.load_data import upload_data_to_pgdb, download_data, move_data, list_data_files
from ingestion.db import execute_sql_file

logger = logging.getLogger(__name__)

if __name__ == "__main__":
    # print("Downloading data")
    logger.info("Downloading data")
    path = download_data()

    logger.info("Creating schema in Postgres")
    # print("Creating schema in Postgres")
    execute_sql_file("./ingestion/schemas.sql")

    logger.info("Files loaded into ingestion folder")
    # print("Files loaded")
    list_data_files()

    logger.info("Uploading data from csv files to Postgres")
    # print("Uploadind data from file to Postgres")
    upload_data_to_pgdb()
     