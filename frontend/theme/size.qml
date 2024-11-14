pragma Singleton
import QtQuick 2.15

QtObject {
    // Window size
    readonly property int windowWidth: 800
    readonly property int windowHeight: 1200

    // Dialog size
    readonly property int dialogWidth: 400
    readonly property int dialogHeight: 300
    readonly property int bookDialogHeight: 700


    // Spacing and margins
    readonly property int columnSpacing: 20
    readonly property int padding: 20

    // Header and Footer
    readonly property int headerHeight: 50  // Increased to match button height

    // Border
    readonly property int borderWidth: 1

    // Text sizes
    readonly property int titleFontSize: 24
    readonly property int toastFontSize: 16

    // Input fields
    readonly property int inputWidth: 300
    readonly property int inputPaddingLeft: 10
    readonly property int inputPaddingRight: 10
    readonly property int inputPaddingTop: 8
    readonly property int inputPaddingBottom: 8
    readonly property int inputRadius: 5

    // Button
    readonly property int buttonWidth: 140  // Adjusted to fit two buttons side by side
    readonly property int buttonHeight: 50  // Matches header and footer height
    readonly property int buttonRadius: 5

    // Toast
    readonly property int toastBottomMargin: 50
    readonly property int toastDuration: 2000
    readonly property int toastAnimationDuration: 500
    readonly property real toastWidth: 300
    readonly property real toastPaddingHorizontal: 40
    readonly property real toastPaddingVertical: 20

    // Font Sizes
    readonly property int fontSizeSmall: 14
    readonly property int fontSizeNormal: 16
    readonly property int fontSizeLarge: 18
    readonly property int fontSizeTitle: 32

    // Logo dimensions
    readonly property int logoWidth: 120
    readonly property int logoHeight: 120
    readonly property int logoBorderWidth: 2
    readonly property int logoBorderRadius: 10
    readonly property int logoContainerWidth: logoWidth + (2 * logoBorderWidth)
    readonly property int logoContainerHeight: logoHeight + (2 * logoBorderWidth)
}