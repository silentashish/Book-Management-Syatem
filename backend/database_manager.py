"""Module for managing database operations."""

import sqlite3


class DatabaseManager:
    """Class for handling database management tasks."""

    def __init__(self, db_name="book_management.db"):
        """Initialize the DatabaseManager."""
        self.connection = sqlite3.connect(db_name)
        self.cursor = self.connection.cursor()
        self.create_tables()

    def create_tables(self):
        """Create users and books tables."""
        # Create users and books tables
        self.cursor.execute(
            """
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT UNIQUE,
                password TEXT
            )
        """
        )
        self.cursor.execute(
            """
            CREATE TABLE IF NOT EXISTS books (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT,
                author TEXT,
                year INTEGER
            )
        """
        )
        self.connection.commit()

    def close_connection(self):
        """Close the database connection."""
        self.connection.close()
