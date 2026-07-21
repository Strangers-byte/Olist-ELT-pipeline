# tests/ingestion/test_upload_data.py
import pytest
from unittest.mock import patch, MagicMock
from pathlib import Path
from ingestion.load_data import upload_data_to_pgdb

class TestUploadData:
    @patch('ingestion.load_data.get_postgres_connection')
    @patch.object(Path, 'glob')
    @patch('builtins.open')
    @patch('csv.reader')
    def test_correct_table_names_and_copy_calls(
        self, mock_csv_reader, mock_open, mock_glob, mock_get_conn
    ):
        # Setup mock database
        mock_conn = MagicMock()
        mock_cursor = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_get_conn.return_value = mock_conn

        # Simulate one CSV file
        mock_file_path = MagicMock()
        mock_file_path.stem = 'orders'
        mock_glob.return_value = [mock_file_path]

        # csv.reader must return an iterator, not a list
        mock_csv_reader.return_value = iter([['order_id', 'customer_id']])

        # Execute the function
        upload_data_to_pgdb()

        # Verify truncate was called with correct table name
        mock_cursor.execute.assert_any_call('TRUNCATE TABLE bronze.orders;')

        # Verify copy_expert was called once with the correct COPY command and file handle
        mock_cursor.copy_expert.assert_called_once()
        copy_call_args = mock_cursor.copy_expert.call_args[0]
        sql = copy_call_args[0]
        file_handle = copy_call_args[1]
        assert 'COPY bronze.orders (order_id,customer_id) FROM STDIN WITH CSV HEADER' == sql
        # The file handle should be the mock's return value from the second open call
        # (the first open is for reading headers, the second for COPY)
        assert file_handle == mock_open.return_value.__enter__.return_value

        mock_conn.commit.assert_called()