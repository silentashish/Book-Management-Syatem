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
        onSearchRequested: {
            refreshBookList(searchSection.searchInput.text)
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

    // Function to update authors list in AddBookDialog
    function updateAuthorsList() {
        console.log("Updating authors list") // Debug print
        var authors = authorManager.search_authors("")
        console.log("Retrieved authors:", JSON.stringify(authors)) // Debug print

        addBookDialog.authorSelect.model.clear()

        // Add a placeholder option
        addBookDialog.authorSelect.model.append({
            text: "Select Author",
            value: -1
        })

        for (var i = 0; i < authors.length; i++) {
            console.log("Adding author:", authors[i].name) // Debug print
            addBookDialog.authorSelect.model.append({
                text: authors[i].name,
                value: authors[i].id
            })
        }
    }

    // Function to refresh the book list
    function refreshBookList(query) {
        console.log("Refreshing book list...") // Debug print
        var books = bookManager.search_books(query) // Fetch books based on query
        booksModel.clear() // Clear the current model

        for (var i = 0; i < books.length; i++) {
            booksModel.append({
                title: books[i].title,
                isbn: books[i].isbn,
                publishedYear: books[i].published_year,
                authorName: books[i].author_name,
                coverImage: books[i].cover_image,
                addedByUser: books[i].added_by_user
            })
        }
    }

    Component.onCompleted: {
        if (typeof bookManager === "undefined" || typeof authorManager === "undefined") {
            console.error("Error: bookManager or authorManager is undefined in QML")
        } else {
            console.log("bookManager and authorManager are available in QML")
        }
    }
}