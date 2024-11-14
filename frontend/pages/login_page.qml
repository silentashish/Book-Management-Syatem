import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import "../theme"
import "../components"

Item {
    id: root
    width: Size.windowWidth
    height: Size.windowHeight

    Column {
        spacing: Size.columnSpacing
        anchors.centerIn: parent
        width: parent.width * Size.columnWidth

        // Add Logo Image
        Rectangle {
            width: Size.logoContainerWidth
            height: Size.logoContainerHeight
            radius: Size.logoBorderRadius
            border.width: Size.logoBorderWidth
            border.color: Colors.logoBorderColor
            anchors.horizontalCenter: parent.horizontalCenter
            clip: true
            
            Image {
                anchors.centerIn: parent
                width: Size.logoWidth
                height: Size.logoHeight
                source: "../images/logo.png"
                fillMode: Image.PreserveAspectCrop
            }
        }

        // Title Label
        Label {
            text: "Login to Your Account"
            font.pixelSize: Size.titleFontSize
            font.bold: true
            color: Colors.secondaryColor 
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: Size.toastBottomMargin
        }

        // Username Input
        TextField {
            id: usernameInput
            placeholderText: "Username"
            placeholderTextColor: Colors.placeholderColor
            width: Size.inputWidth
            anchors.horizontalCenter: parent.horizontalCenter
            verticalAlignment: Text.AlignVCenter
            Material.accent: Colors.primaryColor
            color: Colors.secondaryColor                    
            Material.background: Colors.backgroundColor  
            Material.theme: Material.Dark  
            font.pixelSize: Size.fontSizeNormal
        }

        // Password Input
        TextField {
            id: passwordInput
            placeholderText: "Password"
            echoMode: TextInput.Password
            placeholderTextColor: Colors.placeholderColor
            width: Size.inputWidth
            anchors.horizontalCenter: parent.horizontalCenter
            verticalAlignment: Text.AlignVCenter
            Material.accent: Colors.primaryColor
            color: Colors.secondaryColor                    
            Material.background: Colors.backgroundColor  
            Material.theme: Material.Dark  
            font.pixelSize: Size.fontSizeNormal
        }

        // Login Button
        Button {
            text: qsTr("Login")
            width: Size.buttonWidth
            height: Size.buttonHeight
            anchors.horizontalCenter: parent.horizontalCenter
            Material.background: Colors.primaryColor
            Material.foreground: Colors.toastTextColor
            background: Rectangle {
                radius: Size.buttonRadius
                color: Colors.primaryColor
            }
            onClicked: {
                // Validation
                if (!usernameInput.text || !passwordInput.text) {
                    toast.show("Username and password are required.", true);
                    return;
                }

                var loginResult = userManager.login(usernameInput.text, passwordInput.text);
                if (loginResult) {
                    toast.show("Login Successful!");
                    usernameInput.text = "";
                    passwordInput.text = "";
                    pageLoader.source = "pages/dashboard_page.qml";
                } else {
                    toast.show("Invalid credentials, try again", true);
                    passwordInput.text = "";
                }
            }
            font.pixelSize: Size.fontSizeNormal
        }

        // Signup Link Text
        Text {
            text: "Don't have an account? Sign Up"
            color: Colors.primaryColor 
            font.bold: true
            font.underline: true // Underline the text
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            MouseArea {
                anchors.fill: parent // Make the entire text clickable
                onClicked: {
                    // Load the signup page
                    pageLoader.source = "pages/signup_page.qml";
                }
            }
            font.pixelSize: Size.fontSizeSmall
        }
    }

    Component.onCompleted: {
        if (typeof bookManager === "undefined" || typeof authorManager === "undefined") {
            console.error("Error: bookManager or authorManager is undefined in QML")
        } else {
            if(userManager.is_user_logged_in())
            {
                pageLoader.source = "pages/dashboard_page.qml";
            }
            
        }
    }

    // Add Toast component
    Toast {
        id: toast
    }
    
}