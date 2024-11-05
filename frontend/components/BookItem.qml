import QtQuick 2.15
import QtQuick.Controls 2.15
import "../theme"

Rectangle {
    id: root
    color: Colors.backgroundColor
    border.color: Colors.primaryColor
    border.width: 1
    radius: 5

    property bool isAuthor: false // Will be set based on user role

    Row {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Image {
            id: coverImage
            width: 100
            height: parent.height - 20
            source: model.coverImage ? model.coverImage : "../images/default_cover.png"
            fillMode: Image.PreserveAspectFit
        }

        Column {
            spacing: 5

            Text {
                text: model.title
                color: Colors.secondaryColor
                font.pixelSize: Size.fontSizeLarge
                font.bold: true
            }

            Text {
                text: "By: " + model.authorName
                color: Colors.secondaryColor
                font.pixelSize: Size.fontSizeNormal
            }

            Text {
                text: "ISBN: " + model.isbn
                color: Colors.secondaryColor
                font.pixelSize: Size.fontSizeSmall
            }

            Text {
                text: "Published: " + model.publishedYear
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
                onClicked: {
                    // Implement edit functionality
                }
            }

            Button {
                text: "Delete"
                onClicked: {
                    // Implement delete functionality
                }
            }
        }
    }
} 