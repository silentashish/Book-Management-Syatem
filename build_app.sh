#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Application-specific variables
APP_NAME="BOOKSY"
MAIN_SCRIPT="main.py"                   # Your main script filename
DIST_DIR="dist"                         # Output directory for PyInstaller and dmgbuild
DMG_NAME="${APP_NAME}.dmg"
ICON_PATH="resources/AppIcon.icns"      # Path to the .icns icon file
BACKGROUND_IMAGE="resources/background.png" # Path to the background image for dmg
SETTINGS_PY="settings.py"               # Path to the settings.py for dmgbuild
FRONTEND_DIR="frontend"                 # Frontend directory containing QML files
BACKEND_DIR="backend"                   # Backend directory containing Python modules

# Function to display messages
function echo_info {
    echo -e "\033[1;34m$1\033[0m"
}

function echo_error {
    echo -e "\033[1;31m$1\033[0m" >&2
}

# Step 1: Clean up previous builds
echo_info "Cleaning up previous builds..."
rm -rf build "$DIST_DIR"
mkdir -p "$DIST_DIR"

# Step 2: Convert .appiconset to .icns if not already done
if [ ! -f "$ICON_PATH" ]; then
    echo_info "Converting AppIcon.appiconset to AppIcon.icns..."
    iconutil -c icns resources/AppIcon.appiconset
else
    echo_info "AppIcon.icns already exists."
fi

# Step 3: Run PyInstaller to create the .app bundle
echo_info "Building .app bundle with PyInstaller..."

pyinstaller --noconfirm --windowed --name "$APP_NAME" --icon "$ICON_PATH" \
    --add-data "$FRONTEND_DIR:frontend" \
    --add-data "$BACKEND_DIR:backend" \
    --add-data ".env:." \
    --hidden-import watchdog.observers \
    --hidden-import watchdog.events \
    "$MAIN_SCRIPT"

# Verify the .app bundle was created
APP_BUNDLE_PATH="$DIST_DIR/$APP_NAME.app"
if [ ! -d "$APP_BUNDLE_PATH" ]; then
    echo_error "Error: .app bundle was not created at $APP_BUNDLE_PATH. Exiting."
    exit 1
fi

echo_info ".app bundle created successfully at $APP_BUNDLE_PATH"

# Step 4: Ensure settings.py exists
if [ ! -f "$SETTINGS_PY" ]; then
    echo_error "Error: settings.py not found at $SETTINGS_PY. Please create it before building the DMG."
    exit 1
fi

# Step 5: Run dmgbuild to create the .dmg file
echo_info "Creating .dmg file with dmgbuild..."
dmgbuild -s "$SETTINGS_PY" "$APP_NAME" "$DIST_DIR/$DMG_NAME"

# Verify the .dmg was created
DMG_PATH="$DIST_DIR/$DMG_NAME"
if [ -f "$DMG_PATH" ]; then
    echo_info "Successfully created $DMG_PATH"
else
    echo_error "Error: .dmg file was not created."
    exit 1
fi

# Step 6: Clean up temporary files (if any)
echo_info "Cleaning up temporary files..."
# Add any cleanup commands here if necessary

echo_info "Build process completed successfully."
