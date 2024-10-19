"""Module for managing user-related operations."""

from backend.database_manager import DatabaseManager


class UserManager:
    """Class for handling user management tasks."""

    def __init__(self):
        """Initialize the UserManager."""
        self.db = DatabaseManager()

    def login(self, username, password):
        """Description of what this method does."""
        self.db.cursor.execute(
            "SELECT * FROM users WHERE username = ? AND password = ?",
            (username, password),
        )
        user = self.db.cursor.fetchone()
        return user is not None

    def logout(self):
        """Description of what this method does."""
        # Handle logout logic if needed
