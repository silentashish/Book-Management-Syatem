import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import "../theme"

Dialog {
    id: addAuthorDialog

    title: "Add New Author"
    width: Size.dialogWidth
    height: Size.dialogHeight
    modal: true
    standardButtons: Dialog.Ok | Dialog.Cancel

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
        radius: Size.buttonRadius

        Text {
            text: addAuthorDialog.title
            color: Colors.toastTextColor
            anchors.centerIn: parent
            font.pixelSize: Size.fontSizeLarge
            font.bold: true
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
                onClicked: addAuthorDialog.close()

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
                onClicked: addAuthorDialog.accepted()
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

    contentItem: Column {
        spacing: Size.columnSpacing
        padding: Size.padding
        anchors.centerIn: parent

        // Author Name Input
        TextField {
            id: nameInput
            placeholderText: "Author Name"
            placeholderTextColor: Colors.placeholderColor
            width: Size.inputWidth
            anchors.horizontalCenter: parent.horizontalCenter
            verticalAlignment: Text.AlignVCenter
            color: Colors.secondaryColor
            Material.accent: Colors.secondaryColor
            Material.background: Colors.backgroundColor
            Material.theme: Material.Dark
            font.pixelSize: Size.fontSizeNormal
        }

        // Birth Year Input
        TextField {
            id: birthYearInput
            placeholderText: "Birth Year"
            placeholderTextColor: Colors.placeholderColor
            width: Size.inputWidth
            anchors.horizontalCenter: parent.horizontalCenter
            verticalAlignment: Text.AlignVCenter
            color: Colors.secondaryColor
            Material.accent: Colors.secondaryColor
            Material.background: Colors.backgroundColor
            Material.theme: Material.Dark
            font.pixelSize: Size.fontSizeNormal
            validator: IntValidator { bottom: 1000; top: 9999 }
        }
    }

    onAccepted: {
        // Emit signals to handle author addition
        addAuthorHandler(nameInput.text, birthYearInput.text)
    }

    // Expose signals
    signal addAuthorHandler(string name, int birthYear)
}