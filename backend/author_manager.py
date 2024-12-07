"""
Module for managing author-related operations.
Handles author creation, updates, and search functionality in the BOOKSY application.
"""

import logging
from typing import List, Dict, Any
from PyQt6.QtCore import QObject, pyqtSlot
from backend.database_manager import DatabaseManager


class AuthorManager(QObject):
    """
    Handles author management operations.

    This class manages all author-related operations in the BOOKSY application,
    including adding and searching for authors.

    Attributes:
        db (DatabaseManager): Database connection manager instance
    """

    def __init__(self, db_path: str) -> None:
        """
        Initialize AuthorManager with database connection.

        Args:
            db_path (str): Path to the SQLite database
        """
        super().__init__()
        self.db = DatabaseManager(db_path)
        logging.info("AuthorManager initialized successfully")

    @pyqtSlot(str, int, result=bool)
    def add_author(self, name: str, birth_year: int) -> bool:
        """
        Add a new author to the database.

        Args:
            name (str): Author's full name
            birth_year (int): Author's birth year

        Returns:
            bool: True if author added successfully, False otherwise
        """
        try:
            logging.info(f"Adding new author: {name} (Birth year: {birth_year})")

            self.db.cursor.execute(
                "INSERT INTO authors (name, birth_year) VALUES (?, ?)",
                (name, birth_year),
            )
            self.db.connection.commit()

            logging.info(f"Successfully added author: {name}")
            return True

        except Exception as e:
            logging.error(f"Error adding author {name}: {e}", exc_info=True)
            return False

    @pyqtSlot(str, result=list)
    def search_authors(self, query: str) -> List[Dict[str, Any]]:
        """
        Search authors by name. If query is empty, return all authors.

        Args:
            query (str): Search query string

        Returns:
            List[Dict[str, Any]]: List of matching authors with their details
        """
        try:
            logging.info(f"Searching authors with query: {query}")

            if query:
                self.db.cursor.execute(
                    "SELECT id, name, birth_year FROM authors WHERE name LIKE ?",
                    (f"%{query}%",),
                )
            else:
                self.db.cursor.execute("SELECT id, name, birth_year FROM authors")

            results = self.db.cursor.fetchall()
            authors = [
                {"id": row[0], "name": row[1], "birth_year": row[2]} for row in results
            ]

            logging.info(f"Found {len(authors)} matching authors")
            return authors

        except Exception as e:
            logging.error(f"Error searching authors: {e}", exc_info=True)
            return []
