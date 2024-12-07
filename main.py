import os
import sys
import logging
import sqlite3
from pathlib import Path
from PyQt6.QtWidgets import QApplication, QMessageBox
from PyQt6.QtQml import QQmlApplicationEngine
from PyQt6.QtCore import QUrl
from backend.user_manager import UserManager
from backend.author_manager import AuthorManager
from backend.book_manager import BookManager
from dotenv import load_dotenv


# Initialize logging
def setup_logging():
    """Configure application-wide logging to both file and console output.
    Creates a logs directory and writes to app.log file."""
    try:
        # Determine base path (handles both PyInstaller and normal execution)
        if getattr(sys, "frozen", False):
            base_path = sys._MEIPASS
        else:
            base_path = os.path.abspath(".")

        log_dir = Path(base_path) / "logs"
        log_dir.mkdir(parents=True, exist_ok=True)
        log_file = log_dir / "app.log"

        logging.basicConfig(
            level=logging.DEBUG,
            format="%(asctime)s - %(levelname)s - %(message)s",
            handlers=[
                logging.FileHandler(log_file, mode="a"),
                logging.StreamHandler(sys.stdout),
            ],
        )
        logging.info("Logging initialized.")
    except Exception as e:
        print(f"Failed to initialize logging: {e}")
        sys.exit(1)


load_dotenv()  # Load .env file variables
setup_logging()


def get_resource_path(relative_path):
    """Get absolute path to resource, works for dev and for PyInstaller.
    Ensures resources (like QML files) can be found in both development
    and compiled environments."""
    try:
        base_path = sys._MEIPASS
    except AttributeError:
        base_path = os.path.abspath(".")

    return os.path.join(base_path, relative_path)


def get_database_path():
    """Set up the SQLite database in the user's Application Support directory.
    Creates the database and necessary tables if they don't exist."""
    # Define the application support directory path for macOS
    app_support_dir = Path.home() / "Library" / "Application Support" / "BOOKSY"
    app_support_dir.mkdir(parents=True, exist_ok=True)
    db_path = app_support_dir / "booksy.db"

    if not db_path.exists():
        # Initialize database schema with tables for users, authors, and books
        try:
            conn = sqlite3.connect(db_path)
            cursor = conn.cursor()
            # Create tables as needed
            cursor.execute(
                """
                CREATE TABLE IF NOT EXISTS users (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    username TEXT NOT NULL,
                    email TEXT NOT NULL
                )
            """
            )
            cursor.execute(
                """
                CREATE TABLE IF NOT EXISTS authors (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    name TEXT NOT NULL
                )
            """
            )
            cursor.execute(
                """
                CREATE TABLE IF NOT EXISTS books (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    title TEXT NOT NULL,
                    author_id INTEGER,
                    FOREIGN KEY(author_id) REFERENCES authors(id)
                )
            """
            )
            conn.commit()
            conn.close()
            logging.info(f"Created new database at {db_path}")
        except sqlite3.Error as e:
            logging.error(f"Failed to create database: {e}")
            QMessageBox.critical(
                None, "Database Error", f"Failed to create database:\n{e}"
            )
            sys.exit(1)

    return str(db_path)


def run_app():
    """Initialize and run the main Qt application.
    Sets up the QML engine, managers, and loads the main UI."""
    try:
        # Initialize Qt application with Fusion style
        app = QApplication(sys.argv)
        app.setStyle("Fusion")
        app.setApplicationName("BOOKSY")

        # Set up QML engine and create manager instances
        engine = QQmlApplicationEngine()

        # Initialize database managers for users, books, and authors
        userManager = UserManager(get_database_path())
        bookManager = BookManager(get_database_path())
        authorManager = AuthorManager(get_database_path())

        # Make managers available to QML
        engine.rootContext().setContextProperty("userManager", userManager)
        engine.rootContext().setContextProperty("bookManager", bookManager)
        engine.rootContext().setContextProperty("authorManager", authorManager)

        # Path to main QML file
        qml_file_path = QUrl.fromLocalFile(get_resource_path("frontend/main.qml"))
        logging.debug(f"Loading QML file from {qml_file_path.toString()}")
        engine.load(qml_file_path)

        # Check if the QML file loaded properly
        if not engine.rootObjects():
            error_message = (
                f"Error: Could not load QML file: {qml_file_path.toString()}"
            )
            logging.error(error_message)
            QMessageBox.critical(None, "QML Load Error", error_message)
            sys.exit(-1)

        logging.info("Application started successfully.")
        return app.exec()

    except Exception as e:
        logging.exception("An unexpected error occurred while running the application.")
        QMessageBox.critical(
            None, "Application Error", f"An unexpected error occurred:\n{e}"
        )
        sys.exit(1)


# Main entry point
if __name__ == "__main__":
    """Application entry point with error handling.
    Initializes environment variables and starts the main application loop."""
    try:
        exit_code = run_app()
        logging.info(f"Application exited with code {exit_code}.")
        sys.exit(exit_code)
    except Exception as e:
        logging.exception("An unexpected error occurred in the main block.")
        QMessageBox.critical(
            None, "Application Error", f"An unexpected error occurred:\n{e}"
        )
        sys.exit(1)
