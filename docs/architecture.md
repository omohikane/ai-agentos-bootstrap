# アーキテクチャ

ai-agentos-bootstrap は「バニラ Arch Linux から AI agent が自律動作できる VM を構築する」ための
宣言的なブートストラップ基盤です。専用 OS は作りません。既存の Arch Linux + cloud-init + Ansible を
組み合わせます。

## レイヤ

```
┌──────────────────────────────────────────────────────────┐
│ [4] AI 自律実行層            (Phase 2)                    │
│     opencode --auto / goose / codex など                 │
│     各 agent の専用 config を配置 (ansible/config/)      │
├──────────────────────────────────────────────────────────┤
│ [3] 設定自動化層            ansible-playbook (localhost) │
│     base → tools → ai → security                        │
│     ユーザーは vars/tools.list, vars/ai-tools.list を編集│
├──────────────────────────────────────────────────────────┤
│ [2] 最小 core 導入           bootstrap.sh (shellscript)  │
│     git, base-devel, ripgrep, ansible + yay のみ固定    │
├──────────────────────────────────────────────────────────┤
│ [1] バニラ層                 cloud-init テンプレート     │
│     username/password のみ投入 → 起動・ログイン可能      │
│     (qcow2 は build-image.sh でローカル生成)             │
└──────────────────────────────────────────────────────────┘
```

## 設計判断

- **完全宣言型**: テンプレートを配布せず、定義ファイルから `build-image.sh` でローカル生成します。
  バージョン管理が容易になり、再現レシピ自体が OSS の価値になります。
- **bootstrap.sh はシンプル固定**: ここで入れすぎない。複雑な設定は Ansible に任せます。
- **Ansible は self-apply**: ログイン後に手動で `make provision` を実行します。冪等性が要件です。
- **AI ツールは選択リスト**: `ai-tools.list` で opencode / goose / codex 等を選択。
  導入時に専用 dotfiles を `ansible/config/<tool>/` から同期します。

## 実行フロー

```
build-image.sh ──► qcow2 (cloud-init 有効) ──► Proxmox / KVM に投入
                                                   │ user-data で user/pass 投入
                                                   ▼
                                            ログイン
                                                   │
bootstrap.sh ◄── (手動 or user-data で取得) ───────┘
                                                   │
make provision ◄── ansible-playbook -i 'localhost,' ansible/site.yml
                                                   ▼
                                    base → tools → ai → security (冪等)
```

## 懸念と今後の課題

- **Arch Linux は rolling release**: 再現性が脆い。CI で生成時点のスナップショット固定、
  または検証用の第 2 ターゲット (Fedora) を検討する。
- **Phase 2 が差別化の肝**: opencode --auto による自律実行・サービス化まで入って初めて
  「AI agent 専用」としての独自性が出る。
