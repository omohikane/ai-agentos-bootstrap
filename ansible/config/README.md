# ansible/config/

ここに各 AI agent ツール専用の dotfiles を置きます。

`ansible/config/<tool>/` 内のファイルは、ai role (M3 実装予定) によって
ホームディレクトリの `~/.config/<tool>/` へ同期されます。

## 予定

```
config/
├── opencode/
│   └── opencode.json        … opencode の設定
├── goose/
│   └── ...
└── codex/
    └── ...
```

ツールを追加する場合は、`ansible/vars/ai-tools.list` に追加し、
`ansible/config/<tool>/` に設定ファイルを用意してください。
