# Package

version       = "0.1.0"
author        = "Evan Hastings"
description   = "A browser extension for auto-grouping tabs"
license       = "GPL-3.0-only"
srcDir        = "src"
backend       = "js"
binDir        = "output"
bin           = @["background.js"]


# Dependencies

requires "nim >= 1.6.6"

import os

let distDir = "./dist"
let viewDir = srcDir / "./views"

proc copyFileFromPath(path: string) =
  let fname = splitPath(path).tail
  cpFile(path, distDir / fname)

# Post-build hook to copy files to bundle dir
after build:

  # Copy extension manifest
  copyFileFromPath(srcDir / "manifest.json")

  # Copy output files to bundle
  for file in binDir.listFiles:
    copyFileFromPath(file)

  for file in viewDir.listFiles:
    copyFileFromPath(file)
