// frontend/components/BookItem.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../theme"

Rectangle {
    id: bookItem
    width: parent.width
    height: 140
    color: Colors.backgroundColor
    border.color: Colors.primaryColor
    border.width: 1
    radius: Size.buttonRadius

    // Define properties corresponding to model roles
    property string title: ""
    property string isbn: ""
    property int publishedYear: 0
    property string authorName: ""
    property string coverImage: ""
    property int addedByUser: 0
    property bool isAuthor: false
    property int bookId: 0

    signal deleteBook(int id)

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 15

        // Cover Image Section
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

        // Book Details Section
        ColumnLayout {
            spacing: 5
            Layout.fillWidth: true

            Text {
                text: title
                color: Colors.secondaryColor
                font.pixelSize: Size.fontSizeLarge
                font.bold: true
                Layout.alignment: Qt.AlignLeft
            }

            Text {
                text: "By: " + authorName
                color: Colors.secondaryColor
                font.pixelSize: Size.fontSizeNormal
                Layout.alignment: Qt.AlignLeft
            }

            Text {
                text: "ISBN: " + isbn
                color: Colors.secondaryColor
                font.pixelSize: Size.fontSizeSmall
                Layout.alignment: Qt.AlignLeft
            }

            Text {
                text: "Published: " + publishedYear
                color: Colors.secondaryColor
                font.pixelSize: Size.fontSizeSmall
                Layout.alignment: Qt.AlignLeft
            }
        }

        // Spacer to push buttons to the right
        Item {
            Layout.fillWidth: true
        }

        // Edit and Delete Buttons Section
        RowLayout {
            spacing: 10
            Layout.alignment: Qt.AlignVCenter
            visible: isAuthor

            Button {
                text: "Delete"
                width: 100
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
                    if(bookId !== 0){
                        deleteBook(bookId)
                    }
                }
            }
        }
    }
}
