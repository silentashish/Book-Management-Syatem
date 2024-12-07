"""Module for managing user-related operations."""

import json
import logging
import sqlite3
from backend.database_manager import DatabaseManager
from PyQt6.QtCore import pyqtSlot, QObject
import bcrypt
from PyQt6.QtCore import QSettings


class UserManager(QObject):
    """Class for handling user management tasks."""

    def __init__(self, db_name):
        """Initialize the UserManager."""
        super().__init__()
        self.db = DatabaseManager(db_name)
        logging.info("UserManager initialized")

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
        """Log in a user and store their information if successful.

        Args:
            username: User's login name
            password: User's plain text password

        Returns:
            bool: True if login successful, False otherwise
        """
        try:
            logging.info(f"Attempting login for user: {username}")
            # Query database for user credentials and profile information
            self.db.cursor.execute(
                "SELECT password, id, username, firstname, lastname, email FROM users WHERE username = ?",
                (username,),
            )
            result = self.db.cursor.fetchone()

            if result is None:
                logging.warning(f"Login failed: User {username} not found")
                return False

            stored_password = result[0]

            # Verify the password using bcrypt
            if not self._check_password(password, stored_password):
                logging.warning(f"Login failed: Invalid password for user {username}")
                return False

            logging.info(f"User {username} logged in successfully")

            # Cache user session data locally using QSettings
            settings = QSettings("MyApp", "UserData")
            settings.setValue("id", result[1])
            settings.setValue("username", result[2])
            settings.setValue("firstname", result[3])
            settings.setValue("lastname", result[4])
            settings.setValue("email", result[5])

            return True

        except Exception as e:
            logging.error(f"Login error for user {username}: {e}", exc_info=True)
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
        """Sign up a new user with the given details.

        Args:
            username: Desired login name
            password: Plain text password to be hashed
            firstname: User's first name
            lastname: User's last name
            email: User's email address

        Returns:
            bool: True if signup successful, False if username taken or other error
        """
        try:
            hashed_password = self._hash_password(password)

            # Attempt to create new user record
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
            return True
        except sqlite3.IntegrityError:
            return False  # Username already exists
        except Exception:
            return False  # Silently fail on other errors

    @pyqtSlot(result=bool)
    def is_user_logged_in(self) -> bool:
        """Check if user data exists in QSettings."""
        settings = QSettings("MyApp", "UserData")
        return settings.contains("id")

    @pyqtSlot(result=str)
    def get_user_data(self) -> str:
        """Retrieve cached user data from local settings.

        Returns:
            str: JSON string containing user's first name, last name and ID
        """
        settings = QSettings("MyApp", "UserData")
        data = {
            "firstName": settings.value("firstname"),
            "lastName": settings.value("lastname"),
            "id": settings.value("id"),
        }
        return json.dumps(data)
