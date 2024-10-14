import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: "Login Page"
    color: "#0d1117" // Background color for the window

    Column {
        spacing: 20
        anchors.centerIn: parent
        width: parent.width * 0.8

        // Title Label
        Label {
            text: "Login to Your Account"
            font.pixelSize: 24
            font.bold: true
            color: "#c9d1d9" // Light gray text color for better contrast
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Username Input
        TextField {
            id: usernameInput
            placeholderText: "Username"
            color: "#c9d1d9"
            background: Rectangle {
                color: "#161b22" // Darker gray for input fields
                radius: 5
            }
            padding: 10
            height: 40
            width: 300
            anchors.horizontalCenter: parent.horizontalCenter
            verticalAlignment: Text.AlignVCenter
        }

        // Password Input
        TextField {
            id: passwordInput
            placeholderText: "Password"
            echoMode: TextInput.Password
            color: "#c9d1d9"
            background: Rectangle {
                color: "#161b22"
                radius: 5
            }
            padding: 10
            height: 40
            width: 300
            anchors.horizontalCenter: parent.horizontalCenter
            verticalAlignment: Text.AlignVCenter
        }

        // Login Button
        Button {
            text: "Login"
            width: 100
            height: 40
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                if (usernameInput.text === "admin" && passwordInput.text === "password") {
                    usernameInput.placeholderText = "Login Successful!"
                    usernameInput.text = ""
                    passwordInput.text = ""
                } else {
                    usernameInput.placeholderText = "Invalid credentials, try again"
                    usernameInput.text = ""
                    passwordInput.text = ""
                }
            }
            background: Rectangle {
                color: "#238636" // GitHub-style green for the button background
                radius: 5
            }
            contentItem: Text {
                text: qsTr("Login")
                color: "#ffffff" // White text color for contrast on the button
                font.bold: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.centerIn: parent
            }
        }
    }
}