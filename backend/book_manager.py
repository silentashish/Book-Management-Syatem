"""
Module for managing book-related operations.
Handles book creation, updates, deletion, and search functionality in the BOOKSY application.
"""

import logging
from typing import List, Dict, Any, Optional
import tempfile
from PyQt6.QtCore import QObject, pyqtSlot, QSettings
from backend.database_manager import DatabaseManager


def get_image_path_from_data(image_data: bytes, image_id: str) -> Optional[str]:
    """
    Save image data to a temporary file and return the file path.

    Args:
        image_data (bytes): Binary image data to be saved
        image_id (str): Unique identifier for the image file

    Returns:
        Optional[str]: Path to the temporary image file, or None if no image data
    """
    if not image_data:
        logging.debug("No image data provided")
        return None

    try:
        temp_file = tempfile.NamedTemporaryFile(
            delete=False, suffix=f"_book_cover_{image_id}.png"
        )
        temp_file_path = temp_file.name

        with open(temp_file_path, "wb") as file:
            file.write(image_data)

        logging.debug(f"Successfully saved image to temporary file: {temp_file_path}")
        return temp_file_path
    except Exception as e:
        logging.error(f"Error saving image data: {e}", exc_info=True)
        return None


class BookManager(QObject):
    """
    Handles book management operations including CRUD operations.

    This class manages all book-related operations in the BOOKSY application,
    including adding, updating, deleting, and searching for books.

    Attributes:
        db (DatabaseManager): Database connection manager instance
    """

    def __init__(self, db_path: str) -> None:
        """
        Initialize BookManager with database connection.

        Args:
            db_path (str): Path to the SQLite database
        """
        super().__init__()
        self.db = DatabaseManager(db_path)
        logging.info("BookManager initialized successfully")

    @pyqtSlot(str, str, int, str, int, int, result=bool)
    def add_book(
        self,
        title: str,
        isbn: str,
        published_year: int,
        cover_image_path: str,
        author_id: int,
        user_id: int,
    ) -> bool:
        """
        Add a new book to the database.

        Args:
            title (str): Book title
            isbn (str): Book ISBN number
            published_year (int): Year of publication
            cover_image_path (str): Path to book cover image
            author_id (int): ID of the book's author
            user_id (int): ID of the user adding the book

        Returns:
            bool: True if book added successfully, False otherwise
        """
        try:
            logging.info(f"Adding new book: {title} (ISBN: {isbn})")

            cover_image = None
            if cover_image_path and cover_image_path.startswith("file://"):
                clean_path = cover_image_path[7:]
                logging.debug(f"Processing cover image from path: {clean_path}")
                with open(clean_path, "rb") as file:
                    cover_image = file.read()

            self.db.cursor.execute(
                """
                INSERT INTO books (title, isbn, published_year, cover_image, author_id, added_by)
                VALUES (?, ?, ?, ?, ?, ?)
                """,
                (title, isbn, published_year, cover_image, author_id, user_id),
            )
            self.db.connection.commit()

            logging.info(f"Successfully added book: {title}")
            return True

        except Exception as e:
            logging.error(f"Error adding book {title}: {e}", exc_info=True)
            return False

    @pyqtSlot(str, result="QVariantList")
    def search_books(self, query: str) -> List[Dict[str, Any]]:
        """
        Search books by title or ISBN.

        Args:
            query (str): Search query string

        Returns:
            List[Dict[str, Any]]: List of matching books with their details
        """
        try:
            logging.info(f"Searching books with query: {query}")

            self.db.cursor.execute(
                """
                SELECT b.title, b.isbn, b.published_year, a.name as author_name, 
                    b.cover_image, u.username as added_by_user, u.id as added_by_user_id, b.id
                FROM books b
                LEFT JOIN authors a ON b.author_id = a.id
                LEFT JOIN users u ON b.added_by = u.id
                WHERE b.title LIKE ? OR b.isbn LIKE ?
                """,
                (f"%{query}%", f"%{query}%"),
            )
            results = self.db.cursor.fetchall()
            settings = QSettings("MyApp", "UserData")
            userId = settings.value("id")

            books = []
            for row in results:
                image_path = get_image_path_from_data(row[4], row[0])
                book = {
                    "title": row[0],
                    "isbn": row[1],
                    "published_year": row[2],
                    "author_name": row[3],
                    "cover_image": image_path,
                    "added_by_user": row[5],
                    "added_by_author": str(userId) == str(row[6]),
                    "bookId": row[7],
                }
                books.append(book)

            logging.info(f"Found {len(books)} matching books")
            return books

        except Exception as e:
            logging.error(f"Error searching books: {e}", exc_info=True)
            return []

    @pyqtSlot(int, result=bool)
    def delete_book(self, book_id: int) -> bool:
        """
        Delete a book (only for authors).

        Args:
            book_id (int): ID of the book to delete

        Returns:
            bool: True if book deleted successfully, False otherwise
        """
        try:
            self.db.cursor.execute("DELETE FROM books WHERE id = ?", (book_id,))
            self.db.connection.commit()
            return True
        except Exception as e:
            print(f"Error deleting book: {e}")
            return False

    @pyqtSlot(int, str, str, int, str, int, result=bool)
    def update_book(
        self,
        book_id: int,
        title: str,
        isbn: str,
        published_year: int,
        cover_image_path: str,
        author_id: int,
    ) -> bool:
        """
        Update book details.

        Args:
            book_id (int): ID of the book to update
            title (str): Updated book title
            isbn (str): Updated book ISBN number
            published_year (int): Updated year of publication
            cover_image_path (str): Path to updated book cover image
            author_id (int): ID of the updated book's author

        Returns:
            bool: True if book updated successfully, False otherwise
        """
        try:
            logging.info(f"Updating book: {title} (ISBN: {isbn})")

            cover_image = None
            if cover_image_path and cover_image_path.startswith("file://"):
                clean_path = cover_image_path[7:]
                logging.debug(f"Processing cover image from path: {clean_path}")
                with open(clean_path, "rb") as file:
                    cover_image = file.read()

            if cover_image:
                self.db.cursor.execute(
                    """
                    UPDATE books 
                    SET title = ?, isbn = ?, published_year = ?, cover_image = ?, author_id = ?,
                        updated_at = CURRENT_TIMESTAMP
                    WHERE id = ?
                """,
                    (title, isbn, published_year, cover_image, author_id, book_id),
                )
            else:
                self.db.cursor.execute(
                    """
                    UPDATE books 
                    SET title = ?, isbn = ?, published_year = ?, author_id = ?,
                        updated_at = CURRENT_TIMESTAMP
                    WHERE id = ?
                """,
                    (title, isbn, published_year, author_id, book_id),
                )

            self.db.connection.commit()

            logging.info(f"Successfully updated book: {title}")
            return True

        except Exception as e:
            logging.error(f"Error updating book {title}: {e}", exc_info=True)
            return False
