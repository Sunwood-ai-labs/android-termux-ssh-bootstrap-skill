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
  |
  <a href="./README.ja.md"><strong>Japanese</strong></a>
</p>

## 概要

このリポジトリは、`android-termux-ssh-bootstrap` という Codex スキルを再利用しやすい形で公開するものです。対象は次のような運用フローです。

- Windows で ADB を準備する
- 公式 GitHub Releases 版の Termux を導入する
- Xiaomi / HyperOS のインストール制限に対応する
- debuggable な GitHub build 上で `run-as com.termux` を使う
- `openssh` を導入する
- 公開鍵認証を設定する
- `adb forward` 経由で Termux に `ssh` 接続する

このリポジトリは意図的に README 中心です。ワークフローが直線的で運用寄りなので、docs サイトを増やすより `SKILL.md` と検証スクリプトを強く保つ方が適しています。

## クイックスタート

### 1. Windows の Codex skills にリンクする

```powershell
New-Item -ItemType Junction -Path "$env:USERPROFILE\.codex\skills\android-termux-ssh-bootstrap" -Target "<local_repo_path>"
```

### 2. Codex から呼び出す

```text
Use $android-termux-ssh-bootstrap to get this fresh Android phone to a usable Termux SSH shell from Windows.
```

### 3. 到達状態

```powershell
adb forward tcp:8022 tcp:8022
ssh -o IdentitiesOnly=yes -i <private_key_path> -p 8022 <termux_user>@127.0.0.1
```

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
|-- .gitignore
|-- agents/
|   `-- openai.yaml
|-- assets/
|   `-- icon.svg
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
- GitHub Releases 版 Termux を使ってよいこと
- パスワード自動入力ではなく公開鍵認証を優先すること

GitHub 版 Termux を使えない場合、このスキルの `run-as com.termux` を前提にした非対話セットアップ経路は成立しません。

## 検証

このリポジトリには構造検証スクリプトが含まれます。

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-skill.ps1
```

検証内容:

- 公開に必要なファイルがそろっているか
- `SKILL.md` の frontmatter が正しいか
- `agents/openai.yaml` のインターフェース定義が正しいか
- アイコン参照が実ファイルに解決できるか
- `default_prompt` が `$android-termux-ssh-bootstrap` を参照しているか
- README の言語切替リンクが維持されているか

## なぜ GitHub 版 Termux なのか

このスキルは、Windows から `run-as com.termux` を使った非対話セットアップを成立させるために、公式 GitHub 版 Termux を前提にしています。一般的な Termux 導入ガイドを広く扱うことよりも、この運用経路を確実に再現できることを優先しています。

そのため、このリポジトリは汎用 Termux 解説ではなく、特定の実務フローに最適化した operator skill です。

## 参照

- [SKILL.md](./SKILL.md)
- [README.md](./README.md)
- [Termux app repository](https://github.com/termux/termux-app)
- [Termux releases](https://github.com/termux/termux-app/releases)
