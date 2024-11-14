pragma Singleton
import QtQuick 2.15

QtObject {
    // Define colors as properties
    property color primaryColor: "#238636"
    property color secondaryColor: "#c9d1d9"
    property color placeholderColor: "#6c757d"
    property color backgroundColor: "#161b22"
    property color toastTextColor: "white"
    property color materialBackground: "white"
    readonly property color successColor: "#4CAF50"  // Green
    readonly property color errorColor: "#F44336"    // Red
    readonly property color logoBorderColor: primaryColor  // Using primary color for border
    readonly property color grayColor: "#B0B0B0"  // New gray color
}