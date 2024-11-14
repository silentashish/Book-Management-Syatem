// frontend/components/SearchSection.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import "../theme"

Rectangle {
    id: searchSection
    width: parent.width
    height: 80
    color: Colors.backgroundColor

    signal addBookClicked()
    signal addAuthorClicked()
    signal searchRequested(string query)
    signal searchButtonClicked()
    signal logoutClicked()

    RowLayout {
        anchors.fill: parent
        spacing: 20

        // Slightly increased left padding
        Item {
            Layout.preferredWidth: 15
        }

        RowLayout {
            spacing: 10
            Layout.alignment: Qt.AlignVCenter

            TextField {
                id: searchInput
                width: parent.width * 0.5  // Sets width to 50% of parent width
                height: 40
                placeholderText: "Search books..."
                color: Colors.secondaryColor
                placeholderTextColor: Colors.placeholderColor
                Material.accent: Colors.secondaryColor
                Material.background: Colors.backgroundColor
                Material.theme: Material.Dark

                onAccepted: {
                    searchRequested(searchInput.text)
                }
            }

            Button {
                id: searchButton
                text: "Search"
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
                    anchors.centerIn: parent
                }
                onClicked: {
                    searchButtonClicked()
                    searchRequested(searchInput.text)
                }
            }
        }

        Item {
            Layout.fillWidth: true
        }

        RowLayout {
            spacing: 10
            Layout.alignment: Qt.AlignVCenter

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
                    anchors.centerIn: parent
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
                    anchors.centerIn: parent
                }
                onClicked: addAuthorClicked()
            }
        }

        Item {
            Layout.fillWidth: true
        }

        RowLayout {
            spacing: 10
            Layout.alignment: Qt.AlignVCenter

            Text {
                id: nameDisplay
                color: Colors.secondaryColor
                text: ""
                font.pointSize: 14
            }

            Button {
                id: logoutButton
                text: "Logout"
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
                    anchors.centerIn: parent
                }
                onClicked: logoutClicked()
            }
        }

        // Slightly increased right padding
        Item {
            Layout.preferredWidth: 15
        }
    }

    Component.onCompleted: {
        if (typeof bookManager === "undefined" || typeof authorManager === "undefined") {
            console.error("Error: bookManager or authorManager is undefined in QML");
        } else {
            var userDataString = userManager.get_user_data();
            var userData = JSON.parse(userDataString);
            var fullname = userData.firstName + " " + userData.lastName;
            nameDisplay.text = fullname;
        }
    }
}
