<p align="center">
  <img src="./assets/icon.svg" width="140" alt="Android Termux SSH Bootstrap Skill icon">
</p>

<div align="center">

# Android Termux SSH Bootstrap Skill

Codex skill for taking a fresh Android device to a usable Termux SSH shell from a Windows PC without root.

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

## Overview

This repository packages a reusable Codex skill, `android-termux-ssh-bootstrap`, for one focused operator workflow:

- prepare ADB on Windows
- install the official GitHub Termux build
- handle Xiaomi / HyperOS install restrictions
- validate whether `run-as com.termux` is usable on the installed build
- install `openssh`
- configure public-key authentication
- connect to Termux over `ssh` through `adb forward`

The repository is intentionally README-centric. The workflow is linear and operational, so a strong `SKILL.md` plus repository validation is a better fit than a separate docs site.

## Quick Start

### 1. Clone the repository

```powershell
git clone https://github.com/Sunwood-ai-labs/android-termux-ssh-bootstrap-skill.git
```

### 2. Link the skill into Codex on Windows

```powershell
New-Item -ItemType Junction -Path "$env:USERPROFILE\.codex\skills\android-termux-ssh-bootstrap" -Target "<local_repo_path>\\android-termux-ssh-bootstrap-skill"
```

### 3. Invoke it from Codex

```text
Use $android-termux-ssh-bootstrap to get this fresh Android phone to a usable Termux SSH shell from Windows.
```

### 4. Expected end state

```powershell
adb forward tcp:8022 tcp:8022
ssh -o IdentitiesOnly=yes -i <private_key_path> -p 8022 <termux_user>@127.0.0.1
```

## Repository Name vs Skill Name

- Repository name: `android-termux-ssh-bootstrap-skill`
- Skill name: `android-termux-ssh-bootstrap`
- Invocation name: `$android-termux-ssh-bootstrap`

The repository name is for GitHub distribution. The `$skill` name is what Codex uses when you invoke the skill.

## Repository Layout

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

## What the Skill Assumes

- Windows host with PowerShell
- Android device connected by USB
- user can unlock the phone and approve prompts
- GitHub-release Termux is acceptable
- public-key authentication is preferred over password automation

If the installed GitHub Termux build does not expose the expected `run-as com.termux` behavior, the non-interactive path must be treated as unavailable and the workflow needs to fall back to a more manual setup path.

## Validation

This repository includes both a local validator and a GitHub Actions workflow.

Run locally:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-skill.ps1
```

The checks cover:

- required public-facing files exist
- `SKILL.md` frontmatter is present and coherent
- `agents/openai.yaml` includes the expected interface metadata
- icon references resolve to the tracked SVG assets
- the default prompt references `$android-termux-ssh-bootstrap`
- both README files contain language-switch links

## Why GitHub Termux Builds

This skill intentionally prefers the official GitHub Termux build because the workflow is designed around validating and using `run-as com.termux` for ADB-assisted setup on Windows. That is a runtime gate, not a timeless guarantee, so the skill explicitly validates it before relying on it.

This also means the repo is not trying to be a universal Termux guide. It is a focused operator skill for one concrete Windows + Android + USB + SSH path.

## Scope Boundaries

### Included

- Windows + Android USB flow
- GitHub-release Termux path
- HyperOS / Xiaomi manual install fallback
- SSH key setup
- proof that the final shell is actually Termux

### Not Included

- Google Play Termux workflows
- root-only Android modifications
- generic Linux SSH server setup unrelated to Termux
- claims of full automation on devices that still require manual security confirmation

## References

- [SKILL.md](./SKILL.md)
- [README.ja.md](./README.ja.md)
- [Termux app repository](https://github.com/termux/termux-app)
- [Termux releases](https://github.com/termux/termux-app/releases)

## License

This repository is released under the [MIT License](./LICENSE).
