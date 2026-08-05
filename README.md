# ai-agentos-bootstrap

> 仮称です。リポジトリ名は今後変更される可能性があります。

AI agent 専用 VM を構築するための OSS ブートストラップ基盤です。

通常の KVM / Proxmox / Hyper-V 上の **Arch Linux** に cloud-init テンプレートから起動し、
`bootstrap.sh` で最小ツール群を導入、その後 **Ansible を自分自身 (localhost) に適用**して
パッケージ・ツールの自動導入と設定を行います。

## コンセプト

- **バニラ = cloud-init テンプレート**: username / password だけ投入して起動・ログインできる状態にします
- **bootstrap.sh**: `git` / `base-devel`(ビルド用) / `ripgrep` / `ansible` + `yay` を導入するシンプルな固定ステップ
- **Ansible self-apply**: ログイン後に自分の環境へ適用。パッケージ導入・設定を自動化します
- **ユーザーの主な作業は 2 ファイルの編集だけ**:
  - `ansible/vars/tools.list` … 一般ツール
  - `ansible/vars/ai-tools.list` … AI agent ツール (opencode / goose / codex など)

## 全体フロー

```
[1] cloud-init テンプレート (qcow2) を Proxmox / KVM に投入
    → username/password を投入して起動・ログイン可能な状態
[2] bootstrap.sh: git, base-devel, ripgrep, ansible + yay を導入
[3] make provision: ansible-playbook を localhost に適用 (base → tools → ai → security)
[4] (Phase 2) opencode --auto 等で AI が自律的に作業できる環境
```

## リポジトリ構成

```
├── cloud-init/   … qcow2 テンプレ生成 + user-data/meta-data 例
├── bootstrap/    … バニラへの最小 core 導入 (shellscript)
├── ansible/      … 設定自動化 (base / tools / ai / security)
│   └── vars/     … tools.list / ai-tools.list (ユーザー編集ファイル)
└── docs/         … アーキテクチャ / 使い方
```

## クイックスタート

(準備中: M1 で `build-image.sh` を実装し、この節を埋めます)

## ステータス

- [x] M0 骨格 (このリポジトリ構成)
- [ ] M1 cloud-init テンプレ生成スクリプト
- [ ] M2 bootstrap.sh
- [ ] M3 Ansible self-apply
- [ ] M4 CI 冪等・再現性検証
- [ ] M5 AI 自律実行環境 (Phase 2)

## ライセンス

(未設定)
