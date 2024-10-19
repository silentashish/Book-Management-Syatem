"""Module for managing book-related operations."""

from backend.database_manager import DatabaseManager


class BookManager:
    """Class for handling book management tasks."""

    def __init__(self):
        """Initialize the BookManager."""
        self.db = DatabaseManager()

    def add_book(self, title, author, year):
        """Add a book to the database."""
        self.db.cursor.execute(
            "INSERT INTO books (title, author, year) VALUES (?, ?, ?)",
            (title, author, year),
        )
        self.db.connection.commit()

    def search_book(self, title):
        """Search for a book by title."""
        self.db.cursor.execute(
            "SELECT * FROM books WHERE title LIKE ?", (f"%{title}%",)
        )
        return self.db.cursor.fetchall()
