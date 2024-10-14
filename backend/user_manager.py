from backend.database_manager import DatabaseManager


class UserManager:
    def __init__(self):
        self.db = DatabaseManager()

    def login(self, username, password):
        self.db.cursor.execute(
            "SELECT * FROM users WHERE username = ? AND password = ?",
            (username, password),
        )
        user = self.db.cursor.fetchone()
        return user is not None

    def logout(self):
        # Handle logout logic if needed
        pass
