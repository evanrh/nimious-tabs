import std/[jsconsole, jsffi, sugar]

var chrome {.importc, nodecl.}: JsObject

let color = cstring"#3aa757"

chrome.runtime.onInstalled.addListener(() => (
  let obj = newJsObject()
  obj.color = color
  chrome.storage.sync.set(obj)
  console.log(cstring"Default background color set to %cgreen",
              cstring"color: " & color)
))
