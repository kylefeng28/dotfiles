## Karabiner, Compose Key, and other keybindings
Compose key is set to Right Option key, which Karabiner maps to Shift-Ctrl-F13.
See `~/.config/karabiner/assets/complex_modifications/custom.json` and `~/Library/KeyBindings/DefaultKeyBinding.dict` (which contains the compose key rules).

See:
- http://github.com/gnarf/osx-compose-key - GitHub repo with instructions 
- http://lolengine.net/blog/2012/06/17/compose-key-on-os-x - Blog post
  - Dead link, see archived version [here](https://web.archive.org/web/20180831180737/http://lolengine.net/blog/2012/06/17/compose-key-on-os-x)
- http://osxnotes.net/keybindings.html - contains `compose2keybindings.pl` script to convert an X11 compose key rule file and converts it to a `DefaultKeyBinding.dict` file
- http://heisencoder.net/2008/04/fixing-up-mac-key-bindings-for-windows.html
- https://gist.github.com/gnarf/0d29c05b189a51894399

## Using key as modifier
From [this Reddit thread](https://www.reddit.com/r/Karabiner/comments/13je4ro/comment/jkfhaw1)

Separating held vs tapped:
```
{
    "conditions": [],
    "from": {
        "key_code": "escape",
        "modifiers": { "optional": [ "any" ] }
    },
    "to_after_key_up": [
        {
            "set_variable": {
                "name": "nav_layer",
                "value": 0
            }
        }
    ],
    "to": [
        {
            "set_variable": {
                "name": "nav_layer",
                "value": 1
            }
        }
    ],
    "to_if_alone": [{ "key_code": "escape" }],
    "to_if_held_down": [{ "key_code": "comma" }],
    "type": "basic"
},
```

```
"conditions": [
    { "type": "variable_if", "name": "nav_layer", "value": 1 }
],
```

## Karabiner input mode/input source IDs
Note: [kawa](https://github.com/hatashiro/kawa) is much better at this than trying to configure it within Karabiner.
However, if needed, here are the input mode and input source IDs for these languages:

English:
```
    "input_source": {
        "input_source_id": "com.apple.keylayout.US",
        "language": "en"
    },

Chinese:
    "input_source": {
        "input_mode_id": "com.apple.inputmethod.SCIM.ITABC",
        "input_source_id": "com.apple.inputmethod.SCIM.ITABC",
        "language": "zh-Hans"
    },

Japanese:
    "input_source": {
        "input_mode_id": "com.apple.inputmethod.Japanese",
        "input_source_id": "com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese",
        "language": "ja"
    },

Korean:
    "input_source": {
        "input_mode_id": "^com\\.apple\\.inputmethod\\.Korean\\.HNCRomaja$",
        "input_source_id": "^com\\.apple\\.inputmethod\\.Korean\\.HNCRomaja$",
        "language": "ko"
    },
```

Example rule:
```
{
   "type": "basic",
   "from": {
       "key_code": "2",
       "modifiers": { "mandatory": ["fn"] }
   },
   "to": [
       {
           "select_input_source": {
               "input_mode_id": "^com\\.apple\\.inputmethod\\.SCIM\\.ITABC$",
               "input_source_id": "^com\\.apple\\.inputmethod\\.SCIM\\.ITABC$",
               "language": "^zh-Hans$"
           }
       }
   ]
},
```
