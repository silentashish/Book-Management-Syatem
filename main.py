"""Main module for the application."""

import sys
from PyQt6.QtWidgets import QApplication, QMessageBox
from PyQt6.QtQml import QQmlApplicationEngine
from PyQt6.QtCore import QUrl
from backend.user_manager import UserManager
from backend.author_manager import AuthorManager
from backend.book_manager import BookManager


# Main function to run the application
def main():
    """Main function to run the application."""
    app = QApplication(sys.argv)

    # Set the style to a non-native style
    app.setStyle("Fusion")

    # Use QQmlApplicationEngine to load the QML file
    engine = QQmlApplicationEngine()
    qml_file_path = QUrl.fromLocalFile("frontend/main.qml")
    engine.load(qml_file_path)

    # Create instances of managers
    userManager = UserManager()
    bookManager = BookManager()
    authorManager = AuthorManager()

    # Set context properties
    engine.rootContext().setContextProperty("userManager", userManager)
    engine.rootContext().setContextProperty("bookManager", bookManager)
    engine.rootContext().setContextProperty("authorManager", authorManager)

    # Check if the QML file was loaded properly
    if not engine.rootObjects():
        error_msg = QMessageBox()
        error_msg.setText(f"Error: Could not load QML file: {qml_file_path.toString()}")
        error_msg.setIcon(QMessageBox.Icon.Critical)
        error_msg.exec()
        sys.exit(-1)

    sys.exit(app.exec())


if __name__ == "__main__":
    main()
