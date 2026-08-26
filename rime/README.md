## rime config

### bpmf_py: `bpmf_py.schema.yaml` and `bpmf_py.yaml`.
Type bopomofo (zhuyin) using pinyin. For example:
- typing `b` -> "ㄅ", `m` -> "ㄆ", `m` -> "ㄇ", `f` -> "ㄈ"
- typing `ao` -> "ㄠ", `zhong` -> "ㄓㄨㄥ" which can converted to "中".
- typing `nihao` -> produces `ㄋㄧˇ ㄏㄠˇ` which can be converted to "你好"

This is inspired by Japanese romaji keyboards where typing `a` produces あ and typing `watashi` produces "わたし"
which can be converted to "私".

Based on [rime-bopomofo schema](https://github.com/rime/rime-bopomofo/blob/master/bopomofo.schema.yaml).

### Guides
- https://blog.bdim.moe/posts/configuring-rime-input-method-on-macos/
- https://www.mintimate.cc/en/guide/
  - https://www.mintimate.cc/en/guide/configurationOverride.html
- https://hantang.github.io/rime-docs/collect/RimeDescription-Schema/

### Examples
Squirrel:
- https://raw.githubusercontent.com/Mintimate/oh-my-rime/refs/heads/main/squirrel.yaml

rime:
- https://github.com/Mintimate/oh-my-rime/blob/main/terra_pinyin.schema.yaml
- https://github.com/rime/rime-bopomofo/blob/master/bopomofo.schema.yaml
- https://github.com/zongxinbo/rime-zong/blob/master/schemas/pinyin_ice/pinyin_ice.schema.yaml
