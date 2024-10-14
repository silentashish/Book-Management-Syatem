from backend.database_manager import DatabaseManager


class BookManager:
    def __init__(self):
        self.db = DatabaseManager()

    def add_book(self, title, author, year):
        self.db.cursor.execute(
            "INSERT INTO books (title, author, year) VALUES (?, ?, ?)",
            (title, author, year),
        )
        self.db.connection.commit()

    def search_book(self, title):
        self.db.cursor.execute(
            "SELECT * FROM books WHERE title LIKE ?", (f"%{title}%",)
        )
        return self.db.cursor.fetchall()
