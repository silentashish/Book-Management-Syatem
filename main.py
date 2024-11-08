import os
import sys
from PyQt6.QtWidgets import QApplication, QMessageBox
from PyQt6.QtQml import QQmlApplicationEngine
from PyQt6.QtCore import QUrl
from backend.user_manager import UserManager
from backend.author_manager import AuthorManager
from backend.book_manager import BookManager
from dotenv import load_dotenv
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import time

load_dotenv()  # Load .env file variables


class FileChangeHandler(FileSystemEventHandler):
    def __init__(self, restart_callback):
        self.restart_callback = restart_callback

    def on_modified(self, event):
        if event.src_path.endswith((".py", ".qml")):
            print(f"Change detected in {event.src_path}. Restarting...")
            self.restart_callback()


def run_app():
    """Run the Qt application."""
    app = QApplication(sys.argv)
    app.setStyle("Fusion")

    # Load QML and create the app window
    engine = QQmlApplicationEngine()

    # Create instances of managers
    userManager = UserManager()
    bookManager = BookManager()
    authorManager = AuthorManager()

    # Set context properties before loading QML
    engine.rootContext().setContextProperty("userManager", userManager)
    engine.rootContext().setContextProperty("bookManager", bookManager)
    engine.rootContext().setContextProperty("authorManager", authorManager)

    # Path to main QML file
    qml_file_path = QUrl.fromLocalFile(
        os.path.join(os.path.dirname(__file__), "frontend/main.qml")
    )
    engine.load(qml_file_path)

    # Check if the QML file loaded properly
    if not engine.rootObjects():
        error_msg = QMessageBox()
        error_msg.setText(f"Error: Could not load QML file: {qml_file_path.toString()}")
        error_msg.setIcon(QMessageBox.Icon.Critical)
        error_msg.exec()
        sys.exit(-1)

    return app.exec()


def start_watcher():
    observer = Observer()
    event_handler = FileChangeHandler(
        restart_callback=lambda: sys.exit(3)
    )  # Exit code 3 for restart
    observer.schedule(event_handler, ".", recursive=True)
    observer.start()
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()


if __name__ == "__main__":
    while True:
        if os.getenv("DEV_MODE") == "1":
            watcher_pid = os.fork()  # Create a child process for the watcher
            if watcher_pid == 0:
                start_watcher()
            else:
                exit_code = run_app()
                if exit_code == 3:  # Restart code
                    print("Restarting application...")
                else:
                    os.kill(watcher_pid, 9)
                    sys.exit(exit_code)
        else:
            sys.exit(run_app())
