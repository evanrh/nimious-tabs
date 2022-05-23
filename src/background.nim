import std/[asyncjs, jsconsole, jsffi, sugar]
import private/protocol

const settingsVar: cstring = "settings"

var chrome {.importc, nodecl.}: JsObject

proc newUrl(url: cstring): JsObject {.importcpp: "new URL(@)".}
proc getFromStorage(key: cstring): Future[JsObject] {.importcpp: "chrome.storage.sync.get(@)", async.}

proc groupTab(url: cstring): void {.async.} =
  ## If the tab URL matches a group, place it into that group
  let setsJs = await getFromStorage(settingsVar)

  if setsJs.hasOwnProperty("version"):
    # Only run the match if there are settings loaded into storage
    let
      version = setsJs.version.to(string)
      groups = setsJs.groups.to(seq[TabGroup])
      settings = Settings(version: version, groups: groups)
      group = settings.match($url)

    if group != "":
      # Group the tab accordingly
      discard

proc groupTabCallback(tabId: int, changeInfo, tab: JsObject): void =
  if tab.hasOwnProperty(cstring"pendingUrl"):
    let
      str = tab.pendingUrl.to(cstring)
      url = newUrl(str)
    console.log("Grouping on pending url:", url.host)
    groupTab(url.host.to(cstring))

  elif tab.hasOwnProperty(cstring"url"):
    let
      str = tab.url.to(cstring)
      url = newUrl(str)
    console.log("Grouping on committed url:", url.host)
    groupTab(url.host.to(cstring))

chrome.runtime.onInstalled.addListener((reason: JsObject) => (

  if reason.reason == chrome.runtime.OnInstalledReason.INSTALL:
    let obj = newJsObject()
    obj.url = cstring"post_installation.html"
    chrome.tabs.create(obj)
))

chrome.tabs.onUpdated.addListener(groupTabCallback)
