import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 6.2
import "../theme"
import "../components"

Item {
    id: root
    width: Size.windowWidth
    height: Size.windowHeight

    // Search Section
    Rectangle {
        id: searchSection
        width: parent.width
        height: 60
        color: Colors.backgroundColor

        Row {
            anchors.centerIn: parent
            spacing: 10

            TextField {
                id: searchInput
                width: 300
                height: 40
                placeholderText: "Search books..."
                color: Colors.secondaryColor
                placeholderTextColor: Colors.placeholderColor
            }

            Button {
                text: "Add Book"
                width: 100
                height: 40
                background: Rectangle {
                    radius: Size.buttonRadius
                    color: Colors.primaryColor
                }
                contentItem: Text {
                    text: parent.text
                    color: Colors.toastTextColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: addBookDialog.open()
            }

            Button {
                text: "Add Author"
                width: 100
                height: 40
                background: Rectangle {
                    radius: Size.buttonRadius
                    color: Colors.primaryColor
                }
                contentItem: Text {
                    text: parent.text
                    color: Colors.toastTextColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: addAuthorDialog.open()
            }
        }
    }

    // Books List
    ListView {
        id: booksList
        anchors.top: searchSection.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        clip: true
        model: ListModel {
            // Will be populated from backend
        }
        delegate: BookItem {
            width: parent.width
            height: 120
        }
    }

    // Add Book Dialog
    Dialog {
        id: addBookDialog
        title: "Add New Book"
        width: 400
        height: 500
        anchors.centerIn: parent
        modal: true
        standardButtons: Dialog.Ok | Dialog.Cancel

        background: Rectangle {
            color: Colors.backgroundColor
            border.color: Colors.primaryColor
            border.width: 1
            radius: Size.buttonRadius
        }

        header: Rectangle {
            color: Colors.primaryColor
            height: 40
            width: parent.width

            Text {
                text: addBookDialog.title
                color: Colors.toastTextColor
                anchors.centerIn: parent
                font.pixelSize: Size.fontSizeLarge
                font.bold: true
            }
        }

        contentItem: Column {
            spacing: 20
            padding: 20

            TextField {
                id: titleInput
                width: parent.width - 40
                placeholderText: "Book Title"
                color: Colors.secondaryColor
                placeholderTextColor: Colors.placeholderColor
            }

            TextField {
                id: isbnInput
                width: parent.width - 40
                placeholderText: "ISBN"
                color: Colors.secondaryColor
                placeholderTextColor: Colors.placeholderColor
            }

            TextField {
                id: yearInput
                width: parent.width - 40
                placeholderText: "Published Year"
                color: Colors.secondaryColor
                placeholderTextColor: Colors.placeholderColor
                validator: IntValidator {bottom: 1000; top: 9999}
            }

            ComboBox {
                id: authorSelect
                width: parent.width - 40
                model: ListModel {
                    id: authorsModel
                }
                textRole: "text"
                valueRole: "value"
                displayText: currentText || "Select Author"
                
                background: Rectangle {
                    color: Colors.backgroundColor
                    border.color: Colors.primaryColor
                    border.width: 1
                    radius: Size.buttonRadius
                }
                
                contentItem: Text {
                    text: authorSelect.displayText
                    color: Colors.secondaryColor
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideRight
                }
            }

            Button {
                text: "Select Cover Image"
                width: parent.width - 40
                height: 40
                background: Rectangle {
                    radius: Size.buttonRadius
                    color: Colors.primaryColor
                }
                contentItem: Text {
                    text: parent.text
                    color: Colors.toastTextColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: fileDialog.open()
            }

            Image {
                id: selectedCoverImage
                width: parent.width - 40
                height: 150
                fillMode: Image.PreserveAspectFit
                visible: source.toString() !== ""
            }
        }

        onAccepted: {
            // Validation
            if (!titleInput.text) {
                toast.show("Book title is required", true);
                return;
            }

            if (authorSelect.currentValue === -1) {
                toast.show("Please select an author", true);
                return;
            }

            var publishedYear = parseInt(yearInput.text) || 0;
            var imagePath = selectedCoverImage.source.toString();
            
            // Remove the qrc:/ prefix if it exists
            if (imagePath.startsWith("qrc:/")) {
                imagePath = imagePath.substring(4);
            }
            
            var result = bookManager.add_book(
                titleInput.text,
                isbnInput.text,
                publishedYear,
                imagePath,
                authorSelect.currentValue,
                1  // TODO: Replace with actual logged-in user ID
            );
            
            if (result) {
                toast.show("Book added successfully!");
                titleInput.text = "";
                isbnInput.text = "";
                yearInput.text = "";
                authorSelect.currentIndex = 0;
                selectedCoverImage.source = "";
                
                // Refresh the book list
                refreshBookList();
            } else {
                toast.show("Failed to add book", true);
            }
        }

        onOpened: {
            // Refresh authors list when dialog opens
            updateAuthorsList();
        }
    }

    // File Dialog for Cover Image
    FileDialog {
        id: fileDialog
        title: "Choose a cover image"
        nameFilters: ["Image files (*.jpg *.png *.jpeg)"]
        onAccepted: {
            selectedCoverImage.source = fileDialog.selectedFile
        }
    }

    // Add Author Dialog
    Dialog {
        id: addAuthorDialog
        title: "Add New Author"
        width: 400
        height: 300
        anchors.centerIn: parent
        modal: true
        standardButtons: Dialog.Ok | Dialog.Cancel

        background: Rectangle {
            color: Colors.backgroundColor
            border.color: Colors.primaryColor
            border.width: 1
            radius: Size.buttonRadius
        }

        header: Rectangle {
            color: Colors.primaryColor
            height: 40
            width: parent.width

            Text {
                text: addAuthorDialog.title
                color: Colors.toastTextColor
                anchors.centerIn: parent
                font.pixelSize: Size.fontSizeLarge
                font.bold: true
            }
        }

        contentItem: Column {
            spacing: 20
            padding: 20

            TextField {
                id: authorNameInput
                width: parent.width - 40
                placeholderText: "Author Name"
                color: Colors.secondaryColor
                placeholderTextColor: Colors.placeholderColor
            }

            TextField {
                id: birthYearInput
                width: parent.width - 40
                placeholderText: "Birth Year"
                color: Colors.secondaryColor
                placeholderTextColor: Colors.placeholderColor
                validator: IntValidator {bottom: 1000; top: 9999}
            }
        }

        onAccepted: {
            if (!authorNameInput.text) {
                toast.show("Author name is required", true);
                return;
            }

            var birthYear = parseInt(birthYearInput.text) || 0;
            console.log("Adding author:", authorNameInput.text); // Debug print
            var result = authorManager.add_author(authorNameInput.text, birthYear);
            
            if (result) {
                toast.show("Author added successfully!");
                authorNameInput.text = "";
                birthYearInput.text = "";
                console.log("Refreshing authors list after add"); // Debug print
                updateAuthorsList();
            } else {
                toast.show("Failed to add author", true);
            }
        }
    }

    // Add Toast component
    Toast {
        id: toast
    }

    function updateAuthorsList() {
        console.log("Updating authors list"); // Debug print
        var authors = authorManager.search_authors("");
        console.log("Retrieved authors:", JSON.stringify(authors)); // Debug print
        
        authorSelect.model.clear();
        
        // Add a placeholder option
        authorSelect.model.append({
            text: "Select Author",
            value: -1
        });
        
        for (var i = 0; i < authors.length; i++) {
            console.log("Adding author:", authors[i].name); // Debug print
            authorSelect.model.append({
                text: authors[i].name,
                value: authors[i].id
            });
        }
    }

    function refreshBookList() {
        console.log("Refreshing book list..."); // Debug print
        var books = bookManager.search_books(""); // Fetch all books
        booksList.model.clear(); // Clear the current model

        for (var i = 0; i < books.length; i++) {
            booksList.model.append({
                title: books[i].title,
                isbn: books[i].isbn,
                publishedYear: books[i].published_year,
                authorName: books[i].author_name,
                coverImage: books[i].cover_image,
                addedByUser: books[i].added_by_user
            });
        }
    }

    Component.onCompleted: {
        console.log("Dashboard page completed"); // Debug print
        updateAuthorsList();
    }
} 