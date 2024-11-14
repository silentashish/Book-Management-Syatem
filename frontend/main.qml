import QtQuick 2.15
import QtQuick.Controls 2.15
import 'theme'

ApplicationWindow {
    visible: true
    width: Size.windowHeight
    height: Size.windowWidth
    title: "Login Page"
    color: Colors.backgroundColor

    Loader {
        id: pageLoader
        anchors.fill: parent
        source: "pages/login_page.qml"
    }
}