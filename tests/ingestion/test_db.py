import pytest
from unittest.mock import patch, MagicMock
import psycopg2
from ingestion.db import get_postgres_connection

class TestGetPostgresConnection:
    @patch('ingestion.db.psycopg2.connect')
    def test_returns_connection_on_first_try(self, mock_connect):
        mock_conn = MagicMock()
        mock_connect.return_value = mock_conn

        conn = get_postgres_connection(retries=1, delay=0)

        assert conn == mock_conn 
        mock_connect.assert_called_once_with(
            host='localhost',
            port='5432',
            dbname='test_db',
            user='test_user',
            password='test_pass'
        )

    @patch('ingestion.db.psycopg2.connect', side_effect=psycopg2.OperationalError)
    @patch('ingestion.db.time.sleep', return_value=None)
    def test_retries_and_raises_when_exhausted(self, mock_sleep, mock_connect):
        with pytest.raises(Exception, match='Could not connect'):
            get_postgres_connection(retries=3, delay=0)
        assert mock_connect.call_count == 3
    
    @patch('ingestion.db.get_postgres_connection')
    def test_execute_sql_file(self, mock_get_conn):
        mock_conn = MagicMock()
        mock_cursor = MagicMock()
        mock_conn.cursor.return_value = mock_cursor
        mock_get_conn.return_value = mock_conn

        # Mock the file read
        sql_content = "CREATE TABLE IF NOT EXISTS bronze.customers(...);"
        with patch('builtins.open', create=True) as mock_open:
            mock_open.return_value.__enter__.return_value.read.return_value = sql_content

            from ingestion.db import execute_sql_file
            execute_sql_file('dummy/path.sql')

            mock_open.assert_called_once_with('dummy/path.sql', 'r')
            mock_cursor.execute.assert_called_once_with(sql_content)
            mock_conn.commit.assert_called_once()
            mock_cursor.close.assert_called_once()
            mock_conn.close.assert_called_once()