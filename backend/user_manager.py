"""Module for managing user-related operations."""

from backend.database_manager import DatabaseManager
import sqlite3
from PyQt6.QtCore import pyqtSlot, QObject


class UserManager(QObject):
    """Class for handling user management tasks."""

    def __init__(self):
        """Initialize the UserManager."""
        super().__init__()
        self.db = DatabaseManager()

    @pyqtSlot(str, str)
    def login(self, username, password):
        """Log in a user with the given username and password."""
        self.db.cursor.execute(
            "SELECT * FROM users WHERE username = ? AND password = ?",
            (username, password),
        )
        user = self.db.cursor.fetchone()
        return user is not None

    def logout(self):
        """Handle logout logic if needed."""
        # Logic for logout can be implemented here
    @pyqtSlot(str, str, str, str, result=bool)
    def signup(self, username, password, firstname, lastname):
        """Sign up a new user with the given username, password, firstname,
        and lastname."""
        print(username, password, firstname, lastname)
        try:
            # Insert the new user into the users table
            self.db.cursor.execute(
                "INSERT INTO users (username, password, firstname, lastname) "
                "VALUES (?, ?, ?, ?)",
                (username, password, firstname, lastname),
            )
            self.db.connection.commit()  # Commit the changes to the database
            return True  # Signup successful
        except sqlite3.IntegrityError:
            # This error occurs if the username already exists
            return False  # Signup failed due to username already taken
        except Exception as e:
            print(f"An error occurred: {e}")
            return False  # Signup failed due to an unexpected error
