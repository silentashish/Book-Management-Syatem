# -*- coding: utf-8 -*-
from __future__ import unicode_literals

# Volume format (see hdiutil create -help)
format = "UDBZ"

# Volume size
size = "200M"

# Files to include
files = ["/Users/agautam/Academic/521-Programming/project/dist/BOOKSY.app"]

# Symlinks to create
symlinks = {
    "Applications": "/Applications"
}

# Volume icon
icon = "/Users/agautam/Academic/521-Programming/project/resources/AppIcon.icns"

# Where to put the icons
icon_locations = {
    "BOOKSY.app": (140, 120),
    "Applications": (500, 120)
}

# Window configuration
window_rect = ((100, 100), (640, 280))

# Background
background = "/Users/agautam/Academic/521-Programming/project/resources/background.png"

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
