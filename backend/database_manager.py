"""
Module for managing database operations.
Provides core database functionality including connection management and table creation.
"""

import sqlite3
import logging


class DatabaseManager:
    """
    Core database management class that handles connections and table creation.

    Attributes:
        db_path (str): Path to the SQLite database file
        connection (sqlite3.Connection): SQLite database connection
        cursor (sqlite3.Cursor): Database cursor for executing queries
    """

    def __init__(self, db_path: str = "book_management.db") -> None:
        """
        Initialize database connection and create required tables.

        Args:
            db_path (str): Path to the SQLite database file

        Raises:
            sqlite3.Error: If database connection fails
        """
        try:
            self.db_path = db_path
            logging.info(f"Attempting to connect to database at {self.db_path}")
            self.connection = sqlite3.connect(db_path)
            self.cursor = self.connection.cursor()
            logging.info("Database connection established successfully")
            self.create_tables()
        except sqlite3.Error as e:
            logging.error(f"Database connection failed: {e}", exc_info=True)
            raise

    def create_tables(self) -> None:
        """
        Create all necessary database tables if they don't exist.
        Includes tables for users, authors, and books with appropriate relationships.
        """
        try:
            logging.info("Creating database tables if they don't exist")

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
            logging.info("Database tables created/verified successfully")
        except sqlite3.Error as e:
            logging.error(f"Failed to create database tables: {e}", exc_info=True)
            raise

    def close_connection(self) -> None:
        """
        Safely close the database connection.
        Should be called when the application is shutting down.
        """
        try:
            self.connection.close()
            logging.info(f"Database connection closed for {self.db_path}")
        except sqlite3.Error as e:
            logging.error(f"Error closing database connection: {e}", exc_info=True)
