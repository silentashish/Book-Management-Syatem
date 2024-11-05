import QtQuick 2.15
import QtQuick.Controls 2.15
import "../theme"

Item {
    id: root
    anchors.fill: parent

    function show(message, isError = false) {
        toastBackground.color = isError ? Colors.errorColor : Colors.successColor
        toastMessage.text = message
        toastBackground.visible = true
        toastBackground.opacity = 1.0
        toastTimer.start()
    }

    Rectangle {
        id: toastBackground
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Size.toastBottomMargin
        width: Size.toastWidth
        height: toastMessage.height + Size.toastPaddingVertical
        radius: Size.buttonRadius
        opacity: 0.0
        visible: false
        color: Colors.successColor  

        Behavior on opacity {
            NumberAnimation { duration: Size.toastAnimationDuration }
        }

        Text {
            id: toastMessage
            text: ""
            color: Colors.toastTextColor
            font.pixelSize: Size.fontSizeNormal
            anchors.centerIn: parent
            width: parent.width - Size.toastPaddingHorizontal
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            visible: parent.visible
        }
    }

    Timer {
        id: toastTimer
        interval: Size.toastDuration
        onTriggered: {
            toastBackground.opacity = 0.0
            toastBackground.visible = false
        }
    }
} 