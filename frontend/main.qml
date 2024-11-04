import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: "Login Page"
    color: "#0d1117"

    Loader {
        id: pageLoader
        anchors.fill: parent
        source: "login_page.qml" // Load the login page initially
    }
}