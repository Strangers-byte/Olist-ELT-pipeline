import pytest
import os

@pytest.fixture(autouse=True)
def mock_env_vars(monkeypatch):
    monkeypatch.setenv('PG_HOST', 'localhost')
    monkeypatch.setenv('PG_PORT', '5432')
    monkeypatch.setenv('POSTGRES_DB', 'test_db')
    monkeypatch.setenv('POSTGRES_USER', 'test_user')
    monkeypatch.setenv('POSTGRES_PASSWORD', 'test_pass')
    monkeypatch.setenv('DUCKDB', 'path_to_duckdb')