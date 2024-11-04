import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    width: 400
    height: 600

    Column {
        spacing: 20
        anchors.centerIn: parent
        width: parent.width * 0.8

        // Title Label
        Label {
            text: "Create Your Account"
            font.pixelSize: 24
            font.bold: true
            color: "#c9d1d9"
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // First Name Input
        TextField {
            id: firstnameInput
            placeholderText: "First Name"
            color: "#c9d1d9"
            placeholderTextColor: "#6c757d"
            background: Rectangle {
                color: "#161b22"
                radius: 5
                anchors.fill: parent
            }
            leftPadding: 10
            rightPadding: 10
            topPadding: 8
            bottomPadding: 8
            width: 300
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Last Name Input
        TextField {
            id: lastnameInput
            placeholderText: "Last Name"
            color: "#c9d1d9"
            placeholderTextColor: "#6c757d"
            background: Rectangle {
                color: "#161b22"
                radius: 5
                anchors.fill: parent
            }
            leftPadding: 10
            rightPadding: 10
            topPadding: 8
            bottomPadding: 8
            width: 300
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Username Input
        TextField {
            id: usernameInput
            placeholderText: "Username"
            color: "#c9d1d9"
            placeholderTextColor: "#6c757d"
            background: Rectangle {
                color: "#161b22"
                radius: 5
                anchors.fill: parent
            }
            leftPadding: 10
            rightPadding: 10
            topPadding: 8
            bottomPadding: 8
            width: 300
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Password Input
        TextField {
            id: passwordInput
            placeholderText: "Password"
            echoMode: TextInput.Password
            color: "#c9d1d9"
            placeholderTextColor: "#6c757d"
            background: Rectangle {
                color: "#161b22"
                radius: 5
                anchors.fill: parent
            }
            leftPadding: 10
            rightPadding: 10
            topPadding: 8
            bottomPadding: 8
            width: 300
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Signup Button
        Button {
            text: "Sign Up"
            width: 100
            height: 40
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                var signupResult = userManager.signup(usernameInput.text, passwordInput.text, firstnameInput.text, lastnameInput.text);
                if (signupResult) {
                    // Show success toast
                    showToast("Signup Successful! Login to continue");
                    usernameInput.text = "";
                    passwordInput.text = "";
                    firstnameInput.text = "";
                    lastnameInput.text = "";
                } else {
                    // Show failure toast
                    showToast("Signup Failed! Username may already be taken.");
                }
            }
            background: Rectangle {
                color: "#238636"
                radius: 5
            }
            contentItem: Text {
                text: qsTr("Sign Up")
                color: "#ffffff"
                font.bold: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.centerIn: parent
            }
        }

        // Back to Login Link
        Text {
            text: "Already have an account? Login"
            color: "#238636"
            font.bold: true
            font.underline: true
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // Load the login page
                    pageLoader.source = "login_page.qml";
                }
            }
        }
    }

    // Toast Message
    Text {
        id: toastMessage
        text: ""
        color: "white"
        font.pixelSize: 16
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50
        opacity: 0.0
        visible: false

        // Fade-in and fade-out animation
        Behavior on opacity {
            NumberAnimation { duration: 500 }
        }
    }

    // Function to show toast
    function showToast(message) {
        toastMessage.text = message;
        toastMessage.visible = true;
        toastMessage.opacity = 1.0;

        // Delay before starting fade-out
        toastTimer.start();
    }

    Timer {
        id: toastTimer
        interval: 2000 // Duration toast is visible before fading out (in milliseconds)
        onTriggered: {
            toastMessage.opacity = 0.0;
            toastMessage.visible = false;
        }
    }
}
