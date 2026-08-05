# 使い方

ユーザーが通常やることは次の 2 ファイルの編集と、`make provision` の実行だけです。

## ユーザーが編集するファイル

### 1. `ansible/vars/tools.list` … 一般ツール

1 行 1 パッケージ。pacman で導入されます。`#` で始まる行はコメント。

```
# 例
tmux
neovim
jq
```

### 2. `ansible/vars/ai-tools.list` … AI agent ツールの選択

コメントを外すとそのツールが導入され、専用 config が配置されます。

```
opencode
# goose
# codex
```

## 構築手順

### Step 1: テンプレート (qcow2) の生成と投入

(準備中: M1 で `./cloud-init/build-image.sh` を実装)

1. `make build-image` で cloud-init 有効な Arch の qcow2 を生成
2. Proxmox / KVM にテンプレートとして投入
3. `cloud-init/user-data.example.yml` を編集し username / password を設定

### Step 2: 起動とログイン

テンプレートから VM を起動し、user-data で設定した認証情報でログインします。

### Step 3: bootstrap

(実装予定: M2)

```
curl -fsSL https://raw.githubusercontent.com/<repo>/bootstrap/bootstrap.sh | bash
```

`git` / `base-devel` / `ripgrep` / `ansible` + `yay` が導入されます。

### Step 4: Ansible self-apply

(実装予定: M3)

```
make provision
```

`ansible-playbook -i 'localhost,' ansible/site.yml` が実行され、
base → tools → ai → security の順に適用されます。冪等です。

## 補足

- Phase 2 (M5) では opencode --auto による自律実行環境を提供予定です。
- 詳細は `docs/architecture.md` を参照してください。
