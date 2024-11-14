"""Module for managing author-related operations."""

from PyQt6.QtCore import QObject, pyqtSlot
from backend.database_manager import DatabaseManager


class AuthorManager(QObject):
    """Class for handling author management tasks."""

    def __init__(self, db_path):
        """Initialize the AuthorManager."""
        super().__init__()
        self.db = DatabaseManager(db_path)

    @pyqtSlot(str, int, result=bool)
    def add_author(self, name, birth_year):
        """Add a new author."""
        try:
            self.db.cursor.execute(
                "INSERT INTO authors (name, birth_year) VALUES (?, ?)",
                (name, birth_year),
            )
            self.db.connection.commit()
            return True
        except Exception as e:
            print(f"Error adding author: {e}")
            return False

    @pyqtSlot(str, result=list)
    def search_authors(self, query):
        """Search authors by name. If query is empty, return all authors."""
        try:
            if query:
                self.db.cursor.execute(
                    "SELECT id, name, birth_year FROM authors WHERE name LIKE ?",
                    (f"%{query}%",),
                )
            else:
                self.db.cursor.execute("SELECT id, name, birth_year FROM authors")

            results = self.db.cursor.fetchall()
            print(f"Found authors: {results}")  # Debug print
            return [
                {"id": row[0], "name": row[1], "birth_year": row[2]} for row in results
            ]
        except Exception as e:
            print(f"Error searching authors: {e}")
            return []
