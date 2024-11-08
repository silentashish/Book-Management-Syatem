// frontend/components/SearchSection.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../theme"

Rectangle {
    id: searchSection
    width: parent.width
    height: 60
    color: Colors.backgroundColor

    // Signals to communicate button clicks
    signal addBookClicked()
    signal addAuthorClicked()
    signal searchRequested(string query)

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

            onAccepted: {
                searchRequested(searchInput.text)
            }
        }

        Button {
            id: addBookButton
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
            onClicked: addBookClicked()
        }

        Button {
            id: addAuthorButton
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
            onClicked: addAuthorClicked()
        }
    }

    // Optional: Add a Search Button if needed
}