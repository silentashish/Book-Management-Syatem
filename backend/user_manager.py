"""Module for managing user-related operations."""

import json
import sqlite3
from backend.database_manager import DatabaseManager
from PyQt6.QtCore import pyqtSlot, QObject
import bcrypt
from PyQt6.QtCore import QSettings


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
        """Log in a user and store their information if successful."""
        try:
            # Get the stored hashed password and user information for the username
            self.db.cursor.execute(
                "SELECT password, id, username, firstname, lastname, email FROM users WHERE username = ?",
                (username,),
            )
            result = self.db.cursor.fetchone()

            if result is None:
                return False  # Username not found

            stored_password = result[0]

            # Verify the password
            if not self._check_password(password, stored_password):
                return False  # Password verification failed

            # Store user information using QSettings
            settings = QSettings("MyApp", "UserData")  # Replace with your app name
            settings.setValue("id", result[1])
            settings.setValue("username", result[2])
            settings.setValue("firstname", result[3])
            settings.setValue("lastname", result[4])
            settings.setValue("email", result[5])

            return True  # User information stored successfully

        except Exception as e:
            print(f"Error during login and store: {e}")
            return False

    @pyqtSlot(result=bool)
    def logout(self):
        """Handle logout logic by clearing user data."""
        try:
            settings = QSettings("MyApp", "UserData")
            settings.clear()
            return True

        except Exception as e:
            print(f"Error during logout: {e}")
            return False

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

    @pyqtSlot(result=bool)
    def is_user_logged_in(self) -> bool:
        """Check if user data exists in QSettings."""
        settings = QSettings("MyApp", "UserData")
        return settings.contains("id")

    @pyqtSlot(result=str)
    def get_user_data(self) -> str:
        """Check if user data exists in QSettings."""
        settings = QSettings("MyApp", "UserData")
        data = {
            "firstName": settings.value("firstname"),
            "lastName": settings.value("lastname"),
            "id": settings.value("id"),
        }
        return json.dumps(data)
