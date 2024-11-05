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
            text: "Create Your Account"
            font.pixelSize: Size.titleFontSize
            font.bold: true
            color: Colors.secondaryColor 
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }  

        // First Name Input
        TextField {
            id: firstnameInput
            placeholderText: "First Name"
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

        // Last Name Input
        TextField {
            id: lastnameInput
            placeholderText: "Last Name"
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

        // Email Input
        TextField {
            id: emailInput
            placeholderText: "Email"
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

        // Username Input
        TextField {
            id: usernameInput
            placeholderText: "Username"
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

        // Password Input
        TextField {
            id: passwordInput
            placeholderText: "Password"
            echoMode: TextInput.Password
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

        // Signup Button
        Button {
            text: qsTr("Sign Up")
            width: Size.buttonWidth
            height: Size.buttonHeight
            anchors.horizontalCenter: parent.horizontalCenter
            Material.foreground: Colors.toastTextColor
            
            background: Rectangle {
                radius: Size.buttonRadius
                color: Colors.primaryColor
            }
            
            onClicked: {
                // Validation
                if (!firstnameInput.text || !lastnameInput.text || !usernameInput.text || 
                    !passwordInput.text || !emailInput.text) {
                    toast.show("All fields are required.", true);
                    return;
                }

                // Email validation regex
                var emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailPattern.test(emailInput.text)) {
                    toast.show("Please enter a valid email address.", true);
                    return;
                }

                // Minimum length validation
                if (usernameInput.text.length < 3) {
                    toast.show("Username must be at least 3 characters long.", true);
                    return;
                }

                if (passwordInput.text.length < 6) {
                    toast.show("Password must be at least 6 characters long.", true);
                    passwordInput.text = "";
                    return;
                }

                var signupResult = userManager.signup(usernameInput.text, passwordInput.text, 
                    firstnameInput.text, lastnameInput.text, emailInput.text);
                if (signupResult) {
                    toast.show("Signup Successful! Login to continue");
                    usernameInput.text = "";
                    passwordInput.text = "";
                    firstnameInput.text = "";
                    lastnameInput.text = "";
                    emailInput.text = "";
                } else {
                    toast.show("Signup Failed! Username may already be taken.", true);
                }
            }
            font.pixelSize: Size.fontSizeNormal
        }

        // Back to Login Link
        Text {
            text: "Already have an account? Login"
            color: Colors.primaryColor 
            font.bold: true
            font.underline: true
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // Load the login page
                    pageLoader.source = "pages/login_page.qml";
                }
            }
            font.pixelSize: Size.fontSizeSmall
        }
    }

    Toast {
        id: toast
    }
}
