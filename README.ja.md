<p align="center">
  <img src="./assets/icon.svg" width="140" alt="Android Termux SSH Bootstrap Skill icon">
</p>

<div align="center">

# Android Termux SSH Bootstrap Skill

Windows PC から、更地の Android 端末を root なしで Termux-over-SSH まで持っていくための Codex スキルです。

</div>

<p align="center">
  <img alt="License" src="https://img.shields.io/github/license/Sunwood-ai-labs/android-termux-ssh-bootstrap-skill?style=flat-square">
  <img alt="Validation" src="https://github.com/Sunwood-ai-labs/android-termux-ssh-bootstrap-skill/actions/workflows/validate-skill.yml/badge.svg">
  <img alt="Type" src="https://img.shields.io/badge/Codex-Skill-0B57D0?style=flat-square">
  <img alt="Platform" src="https://img.shields.io/badge/platform-Windows%20%7C%20Android-2E7D32?style=flat-square">
</p>

<p align="center">
  <a href="./README.md"><strong>English</strong></a>
  ·
  <a href="./README.ja.md"><strong>日本語</strong></a>
</p>

## 概要

このリポジトリは、`android-termux-ssh-bootstrap` という Codex スキルを公開用にまとめたものです。扱う対象はかなり絞っていて、次の運用フローに集中しています。

- Windows 側の ADB 準備
- 公式 GitHub 版 Termux の導入
- Xiaomi / HyperOS のインストール制限への対応
- `run-as com.termux` が使えるかの実行時確認
- `openssh` の導入
- 公開鍵認証の設定
- `adb forward` 越しの SSH 接続

このリポジトリは意図的に README 中心です。ワークフローが線形で運用寄りなので、docs サイトを増やすより `SKILL.md` と検証スクリプトを強く保つ方が適しています。

## クイックスタート

### 1. リポジトリを取得する

```powershell
git clone https://github.com/Sunwood-ai-labs/android-termux-ssh-bootstrap-skill.git
```

### 2. Windows の Codex skills にリンクする

```powershell
New-Item -ItemType Junction -Path "$env:USERPROFILE\.codex\skills\android-termux-ssh-bootstrap" -Target "<local_repo_path>\\android-termux-ssh-bootstrap-skill"
```

### 3. Codex から呼び出す

```text
Use $android-termux-ssh-bootstrap to get this fresh Android phone to a usable Termux SSH shell from Windows.
```

### 4. 到達状態

```powershell
adb forward tcp:8022 tcp:8022
ssh -o IdentitiesOnly=yes -i <private_key_path> -p 8022 <termux_user>@127.0.0.1
```

## リポジトリ名とスキル名

- リポジトリ名: `android-termux-ssh-bootstrap-skill`
- スキル名: `android-termux-ssh-bootstrap`
- 呼び出し名: `$android-termux-ssh-bootstrap`

GitHub 上の配布名と、Codex で呼び出す `$skill` 名は別です。README ではその差がわかるように明示しています。

## リポジトリ構成

```text
.
|-- SKILL.md
|-- README.md
|-- README.ja.md
|-- CONTRIBUTING.md
|-- SECURITY.md
|-- CODE_OF_CONDUCT.md
|-- LICENSE
|-- .editorconfig
|-- .gitattributes
|-- .gitignore
|-- agents/
|   `-- openai.yaml
|-- assets/
|   |-- icon.svg
|   |-- android-termux-ssh-bootstrap.svg
|   `-- social-card.svg
|-- scripts/
|   `-- validate-skill.ps1
`-- .github/
    |-- CODEOWNERS
    |-- ISSUE_TEMPLATE/
    |   `-- config.yml
    |-- workflows/
    |   `-- validate-skill.yml
    `-- pull_request_template.md
```

## このスキルの前提

- Windows ホストで PowerShell が使えること
- Android 端末が USB 接続されていること
- 端末のロック解除や各種許可をユーザーが行えること
- GitHub 版 Termux を使ってよいこと
- パスワード自動入力ではなく公開鍵認証を優先すること

インストールした GitHub 版 Termux が期待どおり `run-as com.termux` を使えない場合、このスキルの非対話セットアップ経路は成立しないので、より手動寄りの分岐へ切り替える必要があります。

## 検証

このリポジトリには、ローカル検証スクリプトと GitHub Actions ワークフローの両方を入れています。

ローカル実行:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-skill.ps1
```

確認しているのは次です。

- 公開向け必須ファイルの存在
- `SKILL.md` の frontmatter
- `agents/openai.yaml` の整合
- アイコン参照が追跡中の SVG に解決できること
- `default_prompt` に `$android-termux-ssh-bootstrap` が入っていること
- README の言語切り替えリンク

## なぜ GitHub 版 Termux なのか

このスキルは、Windows から ADB 主導で組み立てるために、公式 GitHub 版 Termux と `run-as com.termux` の検証を前提にしています。これは「常に絶対そうである」と決め打ちするのではなく、実行時に確認する前提です。

つまりこの repo は、汎用 Termux 解説ではなく、Windows + Android + USB + SSH の一つの運用経路に集中した skill repo です。

## スコープ境界

### 含むもの

- Windows + Android の USB フロー
- GitHub 版 Termux 導線
- HyperOS / Xiaomi の手動インストール fallback
- SSH 公開鍵設定
- 最終接続先が本当に Termux かの確認

### 含まないもの

- Google Play 版 Termux の運用
- root 前提の Android 改変
- Termux 以外の汎用 SSH サーバー構築
- 端末側の手動承認が必要なのに完全自動と断言すること

## 参照

- [SKILL.md](./SKILL.md)
- [README.md](./README.md)
- [Termux app repository](https://github.com/termux/termux-app)
- [Termux releases](https://github.com/termux/termux-app/releases)

## ライセンス

このリポジトリは [MIT License](./LICENSE) で公開します。
