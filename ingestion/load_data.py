import kagglehub
import csv
import shutil
import logging

from pathlib import Path

from .db import get_postgres_connection

logger = logging.getLogger(__name__)

def download_data():    
    """
        Downloads the data from kaggle.
        Returns the path to the data
    """
    data_dir = Path(__file__).parent

    if any(data_dir.glob('*.csv')):
        logger.info("Data already exists in %s, skipping download.", data_dir)
        # print(f"Data already exists in {data_dir}, skipping download.")
        return
    
    print("Downloading dataset")
    logger.info("Downloading dataset from kaggle")


    # Download latest version
    path = kagglehub.dataset_download("olistbr/brazilian-ecommerce")
    move_data(path)


def move_data(path):
    """
        Takes the path to the data.
        Move the data files to the ingestion folder
    """
    data_dir = Path(__file__).parent # Ingestion dir path

    for csv_file in Path(path).glob('*.csv'):
        shutil.copy(csv_file, data_dir / csv_file.name)
    logger.info("Data moved")


def list_data_files():
    """
        Scans the parent folder of the file containing this function for csv files.
        Logs the csv file names.
    """
    path = Path(__file__).parent

    for file in path.glob('*.csv'):
        logger.info("File %s", Path(path)/file)
        # print(Path(path)/file) Join the file path with the file name to print the exact filepath. Can also be done os.path.join(path, filename) 
    
def upload_data_to_pgdb():
    """
        Uses the get_postgres_connection to connect to postgres DB. Takes CSV files from path and uploads the data to Postgres DB in the bronze schema.
    """
    conn = get_postgres_connection()
    cur = conn.cursor()

    data_path = Path(__file__).parent 

    for file in Path(data_path).glob('*.csv'):
        tablename = f"bronze.{file.stem}"
        file_path = Path(data_path) / file

        with open(file_path, 'r') as f:
            reader = csv.reader(f)
            headers = next(reader)
            logger.info(headers)
            # print(headers)
        
        columns = ",".join(headers)



        cur.execute(f"TRUNCATE TABLE {tablename};") # Remove the already existing data in the tables. 
        logger.info("Truncated %s", tablename)
        # print(f"Truncated {tablename}")

        with open(file_path, 'r', encoding='latin-1') as f:
            cur.copy_expert(f"COPY {tablename} ({columns}) FROM STDIN WITH CSV HEADER", f)
        conn.commit()
        logger.info("Uploaded %s", file)
        # print(f"Uploaded {file}")

