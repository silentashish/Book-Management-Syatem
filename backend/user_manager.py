"""Module for managing user-related operations."""

from backend.database_manager import DatabaseManager
import sqlite3
from PyQt6.QtCore import pyqtSlot, QObject
import bcrypt


class UserManager(QObject):
    """Class for handling user management tasks."""

    def __init__(self):
        """Initialize the UserManager."""
        super().__init__()
        self.db = DatabaseManager()

    def _hash_password(self, password: str) -> bytes:
        """Hash a password using bcrypt."""
        # Convert the password to bytes and generate salt
        password_bytes = password.encode("utf-8")
        salt = bcrypt.gensalt()
        # Hash the password
        return bcrypt.hashpw(password_bytes, salt)

    def _check_password(self, password: str, hashed_password: bytes) -> bool:
        """Verify a password against its hash."""
        password_bytes = password.encode("utf-8")
        return bcrypt.checkpw(password_bytes, hashed_password)

    @pyqtSlot(str, str, result=bool)
    def login(self, username, password):
        """Log in a user with the given username and password."""
        try:
            # Get the stored hashed password for the username
            self.db.cursor.execute(
                "SELECT password FROM users WHERE username = ?", (username,)
            )
            result = self.db.cursor.fetchone()

            if result is None:
                return False  # Username not found

            stored_password = result[0]

            # Verify the password
            return self._check_password(password, stored_password)
        except Exception as e:
            print(f"Login error: {e}")
            return False

    def logout(self):
        """Handle logout logic if needed."""
        # Logic for logout can be implemented here

    @pyqtSlot(str, str, str, str, str, result=bool)
    def signup(self, username, password, firstname, lastname, email):
        """Sign up a new user with the given details."""
        try:
            # Hash the password before storing
            hashed_password = self._hash_password(password)

            # Insert the new user into the users table
            query = (
                "INSERT INTO users "
                "(username, password, firstname, lastname, email) "
                "VALUES (?, ?, ?, ?, ?)"
            )
            self.db.cursor.execute(
                query,
                (username, hashed_password, firstname, lastname, email),
            )
            self.db.connection.commit()
            return True  # Signup successful
        except sqlite3.IntegrityError:
            # This error occurs if the username already exists
            return False  # Signup failed due to username already taken
        except Exception as e:
            print(f"An error occurred during signup: {e}")
            return False  # Signup failed due to an unexpected error
