import std/[jsre, json, jsonutils]

type
  TabGroup* = ref object
    name: string
    rules: seq[string]
  ## A named tab group that contains rules to match against browser tabs

  Settings* = ref object
    version*: string
    groups*: seq[TabGroup]

proc importFromString*(fileData: string): Settings =
  ## Deserialize settings data from a JSON encoded string
  let
    parsed = parseJson(fileData)
    info = to(parsed, Settings)
  result = info

proc exportSettings*(settingsData: Settings): string =
  ## Serializes settings into a pretty-formatted JSON string
  let ser = toJson(settingsData)
  result = pretty(ser)

func match(group: TabGroup, url: string): bool =
  for rule in group.rules:
    let regex = newRegExp(rule.cstring, r"i")
    if url.contains(regex):
      return true
  return false

func match*(settings: Settings, url: string): string =
  ## Determine if url matches a group and return a name if it does
  for g in settings.groups:
    if g.match(url):
      return g.name
  return ""


when isMainmodule:
  # Sample test of importing from a JSON string
  let
    version = "0.1.0"
    name = "Example"
    jsInp = $( %*{
      "version": version,
      "groups": [
        {
          "name": name,
          "rules": []
        }
      ]
    })
  let settings = importFromString(jsInp)

  assert settings.version == "0.1.0"
