# settings.py for dmgbuild

application_name = "BOOKSY"
app_path = "dist/BOOKSY.app"  # Ensure this path is correct

volume_name = application_name
format = "UDZO"  # Compressed disk image format
size = "200M"  # Adjust based on app size

background = "resources/background.png"  # Path to a background image (optional)
window_rect = ((100, 100), (600, 400))  # Position and size of the dmg window
background_color = (1, 1, 1)  # White background if no image is provided

icon_locations = {
    application_name: (150, 220),  # Position for the application icon
    "Applications": (400, 220),  # Position for the Applications alias
}

symlinks = {"Applications": "/Applications"}

# Additional settings for better layout
files_list = [
    {"path": app_path, "position": (150, 220)},
    {"path": "/Applications", "position": (400, 220)},
]
