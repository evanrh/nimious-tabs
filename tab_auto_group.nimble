# Package

version       = "0.1.0"
author        = "Evan Hastings"
description   = "A browser extension for auto-grouping tabs"
license       = "GPL-3.0-only"
srcDir        = "src"
backend       = "js"
binDir        = "output"
bin           = @["tab_auto_group.js"]


# Dependencies

requires "nim >= 1.6.6"
