// frontend/components/AddAuthorDialog.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import "../theme"

Dialog {
    id: addAuthorDialog
    title: "Add New Author"
    width: 400
    height: 300
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
            validator: IntValidator { bottom: 1000; top: 9999 }
        }
    }

    onAccepted: {
        // Emit signals to handle author addition
        addAuthorHandler(authorNameInput.text, birthYearInput.text)
    }

    // Expose signals
    signal addAuthorHandler(string name, string birthYear)
}