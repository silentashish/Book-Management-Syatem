"""Module for managing book-related operations."""

from PyQt6.QtCore import QObject, pyqtSlot
from backend.database_manager import DatabaseManager
import tempfile
from PyQt6.QtCore import QSettings


def get_image_path_from_data(image_data, image_id):
    """Save image data to a temporary file and return the file path."""
    if not image_data:
        return None

    # Create a temporary file path
    temp_file = tempfile.NamedTemporaryFile(
        delete=False, suffix=f"_book_cover_{image_id}.png"
    )
    temp_file_path = temp_file.name

    # Write the image data to the file
    with open(temp_file_path, "wb") as file:
        file.write(image_data)

    return temp_file_path


class BookManager(QObject):
    """Class for handling book management tasks."""

    def __init__(self, db_path):
        """Initialize the BookManager."""
        super().__init__()
        self.db = DatabaseManager(db_path)

    @pyqtSlot(str, str, int, str, int, int, result=bool)
    def add_book(
        self, title, isbn, published_year, cover_image_path, author_id, user_id
    ):
        """Add a new book to the database."""
        try:
            # Handle cover image
            cover_image = None
            if cover_image_path and cover_image_path.startswith("file://"):
                # Remove the file:// prefix
                clean_path = cover_image_path[7:]
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
            return True
        except Exception as e:
            print(f"Error adding book: {e}")
            return False

    @pyqtSlot(str, result="QVariantList")
    def search_books(self, query):
        """Search books by title or ISBN."""
        try:
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

            # Fetch the current user's ID
            settings = QSettings("MyApp", "UserData")
            userId = settings.value("id")

            books = []
            for row in results:
                # Create temp image path
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
                print(str(userId) == str(row[6]))
                books.append(book)

            return books
        except Exception as e:
            print(f"Error searching books: {e}")
            return []

    @pyqtSlot(int, result=bool)
    def delete_book(self, book_id):
        """Delete a book (only for authors)."""
        try:
            self.db.cursor.execute("DELETE FROM books WHERE id = ?", (book_id,))
            self.db.connection.commit()
            return True
        except Exception as e:
            print(f"Error deleting book: {e}")
            return False

    @pyqtSlot(int, str, str, int, str, int, result=bool)
    def update_book(
        self, book_id, title, isbn, published_year, cover_image_path, author_id
    ):
        """Update book details."""
        try:
            # Handle cover image
            cover_image = None
            if cover_image_path and cover_image_path.startswith("file://"):
                # Remove the file:// prefix
                clean_path = cover_image_path[7:]
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
            return True
        except Exception as e:
            print(f"Error updating book: {e}")
            return False
