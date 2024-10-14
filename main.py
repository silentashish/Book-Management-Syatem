import sys
from PyQt6.QtWidgets import QApplication, QMessageBox
from PyQt6.QtQml import QQmlApplicationEngine
from PyQt6.QtCore import QUrl


# Main function to run the application
def main():
    app = QApplication(sys.argv)

    # Set the style to a non-native style (e.g., Material)
    app.setStyle("Fusion")

    # Use QQmlApplicationEngine to load the QML file
    engine = QQmlApplicationEngine()
    qml_file_path = QUrl.fromLocalFile("frontend/login_page.qml")
    engine.load(qml_file_path)

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
