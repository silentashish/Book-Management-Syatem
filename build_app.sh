#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e
# Exit on undefined variables
set -u
# Print each command before executing (helpful for debugging)
set -x

# Application-specific variables
APP_NAME="BOOKSY"
MAIN_SCRIPT="main.py"
DIST_DIR="dist"
DMG_NAME="${APP_NAME}.dmg"
ICON_PATH="resources/AppIcon.icns"
BACKGROUND_IMAGE="resources/background.png"
SETTINGS_PY="settings.py"
FRONTEND_DIR="frontend"
BACKEND_DIR="backend"
BUNDLE_ID="com.yourdomain.$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]')"

# Get absolute paths
CURRENT_DIR="$(pwd)"
APP_BUNDLE_PATH="${CURRENT_DIR}/${DIST_DIR}/${APP_NAME}.app"
ICON_ABSOLUTE_PATH="${CURRENT_DIR}/${ICON_PATH}"
BACKGROUND_ABSOLUTE_PATH="${CURRENT_DIR}/${BACKGROUND_IMAGE}"

# Function to display messages
function echo_info() {
    echo -e "\033[1;34m$1\033[0m"
}

function echo_error() {
    echo -e "\033[1;31m$1\033[0m" >&2
}

# Function to check if required tools are installed
function check_requirements() {
    local missing_tools=()
    
    if ! command -v pyinstaller >/dev/null 2>&1; then
        missing_tools+=("pyinstaller")
    fi
    
    if ! command -v dmgbuild >/dev/null 2>&1; then
        missing_tools+=("dmgbuild")
    fi
    
    if ! command -v iconutil >/dev/null 2>&1; then
        missing_tools+=("iconutil")
    fi
    
    if [ ${#missing_tools[@]} -ne 0 ]; then
        echo_error "Missing required tools: ${missing_tools[*]}"
        echo_error "Please install them before running this script."
        exit 1
    fi
}

# Check all requirements first
check_requirements

# Verify all required directories and files exist
for dir in "$FRONTEND_DIR" "$BACKEND_DIR" "resources"; do
    if [ ! -d "$dir" ]; then
        echo_error "Error: Required directory '$dir' not found"
        exit 1
    fi
done

if [ ! -f "$MAIN_SCRIPT" ]; then
    echo_error "Error: Main script '$MAIN_SCRIPT' not found"
    exit 1
fi

# Step 1: Clean up previous builds
echo_info "Cleaning up previous builds..."
rm -rf build "$DIST_DIR"
mkdir -p "$DIST_DIR"

# Step 2: Convert .appiconset to .icns if needed
if [ ! -f "$ICON_PATH" ]; then
    if [ -d "resources/AppIcon.appiconset" ]; then
        echo_info "Converting AppIcon.appiconset to AppIcon.icns..."
        iconutil -c icns "resources/AppIcon.appiconset" -o "$ICON_PATH"
    else
        echo_error "Error: Neither $ICON_PATH nor AppIcon.appiconset found"
        exit 1
    fi
fi

# Step 3: Run PyInstaller
echo_info "Building .app bundle with PyInstaller..."
pyinstaller --clean \
    --noconfirm \
    --windowed \
    --name "$APP_NAME" \
    --icon "$ICON_PATH" \
    --add-data "$FRONTEND_DIR:frontend" \
    --add-data "$BACKEND_DIR:backend" \
    --add-data "resources:resources" \
    --add-data ".env:." \
    --hidden-import watchdog.observers \
    --hidden-import watchdog.events \
    --osx-bundle-identifier "$BUNDLE_ID" \
    "$MAIN_SCRIPT"

# Verify the .app bundle
if [ ! -d "$APP_BUNDLE_PATH" ]; then
    echo_error "Error: .app bundle was not created at $APP_BUNDLE_PATH"
    exit 1
fi

# Update settings.py with correct paths
echo_info "Updating settings.py with correct paths..."
cat > "$SETTINGS_PY" << EOL
# -*- coding: utf-8 -*-
from __future__ import unicode_literals

# Volume format (see hdiutil create -help)
format = "UDBZ"

# Volume size
size = "200M"

# Files to include
files = ["${APP_BUNDLE_PATH}"]

# Symlinks to create
symlinks = {
    "Applications": "/Applications"
}

# Volume icon
icon = "${ICON_ABSOLUTE_PATH}"

# Where to put the icons
icon_locations = {
    "${APP_NAME}.app": (140, 120),
    "Applications": (500, 120)
}

# Window configuration
window_rect = ((100, 100), (640, 280))

# Background
background = "${BACKGROUND_ABSOLUTE_PATH}"

# Show/hide UI elements
show_status_bar = False
show_tab_view = False
show_toolbar = False
show_pathbar = False
show_sidebar = False

# General view configuration
show_icon_preview = False
default_view = "icon"
arrange_by = None
grid_offset = (0, 0)
grid_spacing = 100
scroll_position = (0, 0)
label_pos = "bottom"
text_size = 16
icon_size = 128
EOL

# Create DMG
echo_info "Creating DMG..."
if ! dmgbuild -s "$SETTINGS_PY" "$APP_NAME" "$DIST_DIR/$DMG_NAME"; then
    echo_error "Error: DMG creation failed"
    exit 1
fi

echo_info "Build process completed successfully."