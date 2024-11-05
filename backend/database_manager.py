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
        """Create the necessary tables if they don't exist."""
        # Users table (without is_author field)
        self.cursor.execute(
            """
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT UNIQUE NOT NULL,
                password BLOB NOT NULL,
                firstname TEXT NOT NULL,
                lastname TEXT NOT NULL,
                email TEXT NOT NULL
            )
        """
        )

        # Authors table
        self.cursor.execute(
            """
            CREATE TABLE IF NOT EXISTS authors (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                birth_year INTEGER,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """
        )

        # Books table
        self.cursor.execute(
            """
            CREATE TABLE IF NOT EXISTS books (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                isbn TEXT UNIQUE,
                published_year INTEGER,
                cover_image BLOB,
                author_id INTEGER,
                added_by INTEGER,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (author_id) REFERENCES authors (id),
                FOREIGN KEY (added_by) REFERENCES users (id)
            )
        """
        )

        self.connection.commit()

    def close_connection(self):
        """Close the database connection."""
        self.connection.close()
