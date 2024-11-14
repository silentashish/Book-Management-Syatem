import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 6.2
import "../theme"
import QtQuick.Controls.Material 2.15

Dialog {
    id: addBookDialog
    
    Component.onCompleted: {
        root.updateAuthorsList()
    }
    
    title: "Add New Book"
    width: Size.dialogWidth
    height: Size.bookDialogHeight
    modal: true
    standardButtons: Dialog.NoButton

    background: Rectangle {
        color: Colors.backgroundColor
        border.color: Colors.primaryColor
        border.width: Size.borderWidth
        radius: Size.buttonRadius
    }

    header: Rectangle {
        color: Colors.primaryColor
        height: Size.headerHeight
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
            Material.accent: Colors.secondaryColor
            Material.background: Colors.backgroundColor
            Material.theme: Material.Dark
        }

        TextField {
            id: isbnInput
            width: parent.width - 40
            placeholderText: "ISBN"
            color: Colors.secondaryColor
            placeholderTextColor: Colors.placeholderColor
            Material.accent: Colors.secondaryColor
            Material.background: Colors.backgroundColor
            Material.theme: Material.Dark
        }

        TextField {
            id: yearInput
            width: parent.width - 40
            placeholderText: "Published Year"
            color: Colors.secondaryColor
            placeholderTextColor: Colors.placeholderColor
            validator: IntValidator { bottom: 1000; top: 9999 }
            Material.accent: Colors.secondaryColor
            Material.background: Colors.backgroundColor
            Material.theme: Material.Dark
        }

        ComboBox {
            id: authorSelect
            width: parent.width - 40
            height: Size.buttonHeight
            padding: Size.inputRadius
            model: ListModel {
                id: authorsModel
            }
            textRole: "text"
            valueRole: "value"

            Material.accent: Colors.secondaryColor
            Material.background: Colors.backgroundColor
            Material.theme: Material.Dark

            background: Rectangle {
                color: Colors.backgroundColor
                border.color: Colors.primaryColor
                border.width: Size.borderWidth
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
            source: fileDialog.selectedFile
            visible: source.toString() !== ""
        }
    }

    footer: Rectangle {  
        color: "transparent"
        border.color: Colors.primaryColor
        border.width: Size.borderWidth
        height: Size.headerHeight
        width: parent.width
        radius: Size.buttonRadius

        Row {
            anchors.centerIn: parent
            spacing: Size.columnSpacing

            Button {
                text: qsTr("Cancel")
                width: Size.buttonWidth / 2
                height: Size.buttonHeight
                onClicked: addBookDialog.close()

                background: Rectangle {
                    radius: Size.buttonRadius
                    border.width: 2
                    border.color: Colors.primaryColor
                    color: "transparent"
                }
                
                contentItem: Text {
                    text: parent.text
                    color: Colors.toastTextColor  
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.centerIn: parent 
                }
            }

            Button {
                text: qsTr("OK")
                width: Size.buttonWidth / 2
                height: Size.buttonHeight
                onClicked: addBookDialog.accepted()
                background: Rectangle {
                    color: Colors.primaryColor
                    radius: Size.buttonRadius
                }
                contentItem: Text {
                    text: parent.text
                    color: Colors.toastTextColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Choose a cover image"
        nameFilters: ["Image files (*.jpg *.png *.jpeg)"]
        onAccepted: {
            selectedCoverImage.source = fileDialog.selectedFile
        }
    }

    onAccepted: {
        addBookHandler(titleInput.text, isbnInput.text, yearInput.text, selectedCoverImage.source, authorSelect.currentValue)
    }

    signal addBookHandler(string title, string isbn, int year, string imagePath, int authorId)
    
    function updateAuthors(authors) {
       authorsModel.clear()
       authorsModel.append({ text: "Select Author", value: -1 })
       for (var i = 0; i < authors.length; i++) {
           authorsModel.append({ text: authors[i].name, value: authors[i].id })
       }
   }
}