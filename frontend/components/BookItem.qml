// frontend/components/BookItem.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../theme"

Rectangle {
    id: bookItem
    width: parent.width
    height: 120
    color: Colors.backgroundColor
    border.color: Colors.primaryColor
    border.width: 1
    radius: Size.buttonRadius  // Use Size for consistency

    // Define properties corresponding to model roles
    property string title: ""
    property string isbn: ""
    property int publishedYear: 0
    property string authorName: ""
    property string coverImage: ""
    property int addedByUser: 0

    // Existing property
    property bool isAuthor: false // Will be set based on user role

    Row {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Rectangle {
            width: 100
            height: parent.height - 20
            radius: 5
            border.color: Colors.primaryColor
            border.width: 1
            color: "transparent"

            Image {
                id: coverImageItem
                anchors.fill: parent
                source: coverImage !== "" ? coverImage : "../images/default_cover.png"
                fillMode: Image.PreserveAspectFit
            }
        }

        Column {
            spacing: 5

            Text {
                text: title
                color: Colors.secondaryColor
                font.pixelSize: Size.fontSizeLarge
                font.bold: true
            }

            Text {
                text: "By: " + authorName
                color: Colors.secondaryColor
                font.pixelSize: Size.fontSizeNormal
            }

            Text {
                text: "ISBN: " + isbn
                color: Colors.secondaryColor
                font.pixelSize: Size.fontSizeSmall
            }

            Text {
                text: "Published: " + publishedYear
                color: Colors.secondaryColor
                font.pixelSize: Size.fontSizeSmall
            }
        }

        // Edit and Delete buttons (only visible for authors)
        Row {
            visible: isAuthor
            spacing: 5

            Button {
                text: "Edit"
                width: 60
                height: 30
                background: Rectangle {
                    color: Colors.primaryColor
                    radius: Size.buttonRadius
                }
                contentItem: Text {
                    text: parent.text
                    color: Colors.toastTextColor
                    anchors.centerIn: parent
                    font.pixelSize: Size.fontSizeSmall
                }
                onClicked: {
                    console.log("Edit button clicked for book:", title)
                }
            }

            Button {
                text: "Delete"
                width: 60
                height: 30
                background: Rectangle {
                    color: Colors.primaryColor
                    radius: Size.buttonRadius
                }
                contentItem: Text {
                    text: parent.text
                    color: Colors.toastTextColor
                    anchors.centerIn: parent
                    font.pixelSize: Size.fontSizeSmall
                }
                onClicked: {
                    console.log("Delete button clicked for book:", title)
                }
            }
        }
    }
}