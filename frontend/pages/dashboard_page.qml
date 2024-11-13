// frontend/pages/Dashboard.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../theme"
import "../components"

Item {
    id: root
    width: Size.windowWidth
    height: Size.windowHeight

    // Toast Component
    Toast {
        id: toast
    }

    // Search Section
    SearchSection {
        id: searchSection
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        // Connect button signals to open dialogs
        onAddBookClicked: addBookDialog.open()
        onAddAuthorClicked: addAuthorDialog.open()
        onSearchRequested: function(query) {
            console.log("Search requested with query:", query);
            refreshBookList(query);
        }
    }

    // Books List
    ListView {
        id: booksList
        anchors.top: searchSection.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        clip: true
        model: booksModel
        delegate: BookItem {
            title: model.title
            isbn: model.isbn
            publishedYear: model.publishedYear
            authorName: model.authorName
            coverImage: model.coverImage
            addedByUser: model.addedByUser
        }
    }

    // Define booksModel as a ListModel
    ListModel {
        id: booksModel
        // Will be populated from backend
    }

    // Add Book Dialog
    AddBookDialog {
        id: addBookDialog
        anchors.centerIn: parent

        // Connect the signal emitted from the dialog to a handler
        onAddBookHandler: function(title, isbn, year, imagePath, authorId) {
            // Validation is already handled in Dashboard
            if (!title) {
                toast.show("Book title is required", true)
                return
            }

            if (authorId === -1) {
                toast.show("Please select an author", true)
                return
            }

            var publishedYear = parseInt(year) || 0
            var imagePathClean = imagePath.startsWith("qrc:/") ? imagePath.substring(4) : imagePath

            var result = bookManager.add_book(
                title,
                isbn,
                publishedYear,
                imagePathClean,
                authorId,
                1  // TODO: Replace with actual logged-in user ID
            )

            if (result) {
                toast.show("Book added successfully!")
                addBookDialog.close()
                // Refresh the book list
                refreshBookList()
            } else {
                toast.show("Failed to add book", true)
            }
        }
    }

    // Add Author Dialog
    AddAuthorDialog {
        id: addAuthorDialog
        anchors.centerIn: parent

        // Connect the signal emitted from the dialog to a handler
        onAddAuthorHandler: function(name, birthYear) {
            if (!name) {
                toast.show("Author name is required", true)
                return
            }

            var parsedBirthYear = parseInt(birthYear) || 0
            var result = authorManager.add_author(name, parsedBirthYear)

            if (result) {
                toast.show("Author added successfully!")
                addAuthorDialog.close()
                // Refresh authors list in AddBookDialog
                updateAuthorsList()
            } else {
                toast.show("Failed to add author", true)
            }
        }
    }

    Rectangle {
        id: blurBackground
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.5)  // Set the color to semi-transparent white
        visible: addBookDialog.visible || addAuthorDialog.visible  // Show when any dialog is open
    }

    function updateAuthorsList() {
        var authors = authorManager.search_authors("");  // Directly get the list

        if (addBookDialog && typeof addBookDialog.updateAuthors === "function") {
            console.log('Updating authors list');
            addBookDialog.updateAuthors(authors);
        } else {
            console.error("addBookDialog or updateAuthors method is undefined");
        }
    }

    // Function to refresh the book list
    function refreshBookList(query) {
        var books = bookManager.search_books(query); 
        booksModel.clear();

        for (var i = 0; i < books.length; i++) {
            var book = books[i];

            booksModel.append({
                title: book.title || "Unknown Title",
                isbn: book.isbn || "Unknown ISBN",
                publishedYear: book.published_year || 0,
                authorName: book.author_name || "Unknown Author",
                coverImage: book.cover_image || "../images/default_cover.png",
                addedByUser: book.added_by_user || 0
            });
        }
    }

    Component.onCompleted: {
        if (typeof bookManager === "undefined" || typeof authorManager === "undefined") {
            console.error("Error: bookManager or authorManager is undefined in QML")
        } else {
            refreshBookList("")
        }
    }
}