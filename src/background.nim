import std/[jsconsole, jsffi, sugar]
import private/protocol

var chrome {.importc, nodecl.}: JsObject

chrome.runtime.onInstalled.addListener((reason: JsObject) => (

  if reason.reason == chrome.runtime.OnInstalledReason.INSTALL:
    let obj = newJsObject()
    obj.url = cstring"post_installation.html"
    chrome.tabs.create(obj)
))
