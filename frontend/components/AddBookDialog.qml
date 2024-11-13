// frontend/components/AddBookDialog.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 6.2  // Adjust version based on your Qt installation
import "../theme"

Dialog {
    id: addBookDialog
    
    Component.onCompleted: {
        root.updateAuthorsList()
    }
    
    title: "Add New Book"
    width: 400
    height: 500
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
            validator: IntValidator { bottom: 1000; top: 9999 }
        }

        ComboBox {
            id: authorSelect
            width: parent.width - 40
            model: ListModel {
                id: authorsModel
            }
            textRole: "text"
            valueRole: "value"

            background: Rectangle {
                color: Colors.backgroundColor
                border.color: Colors.primaryColor
                border.width: 1
                radius: Size.buttonRadius
            }

            contentItem: Text {
                text: authorSelect.currentText || "Select Author"
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

    // File Dialog for Cover Image
    FileDialog {
        id: fileDialog
        title: "Choose a cover image"
        nameFilters: ["Image files (*.jpg *.png *.jpeg)"]
        onAccepted: {
            selectedCoverImage.source = fileDialog.selectedFile
        }
    }

    onAccepted: {
        // Emit signals to handle book addition
        addBookHandler(titleInput.text, isbnInput.text, yearInput.text, selectedCoverImage.source, authorSelect.currentValue)
    }

    // Expose signals
    signal addBookHandler(string title, string isbn, int year, string imagePath, int authorId)
    
    function updateAuthors(authors) {
       authorsModel.clear()
       authorsModel.append({ text: "Select Author", value: -1 })
       for (var i = 0; i < authors.length; i++) {
           authorsModel.append({ text: authors[i].name, value: authors[i].id })
       }
   }
}