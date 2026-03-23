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
  |
  <a href="./README.ja.md"><strong>Japanese</strong></a>
</p>

## Overview

This repository packages a reusable Codex skill, `android-termux-ssh-bootstrap`, for a specific operational path:

- prepare ADB on Windows
- install the official GitHub Termux build
- handle Xiaomi / HyperOS install restrictions
- use `run-as com.termux` on the debuggable GitHub build
- install `openssh`
- configure public-key authentication
- connect to Termux over `ssh` through `adb forward`

The repository stays README-centric on purpose. The workflow is linear and operational, so a strong `SKILL.md` plus repository validation is a better fit than a separate docs UI.

## Quick Start

### 1. Link the skill into Codex on Windows

```powershell
New-Item -ItemType Junction -Path "$env:USERPROFILE\.codex\skills\android-termux-ssh-bootstrap" -Target "<local_repo_path>"
```

### 2. Invoke it from Codex

```text
Use $android-termux-ssh-bootstrap to get this fresh Android phone to a usable Termux SSH shell from Windows.
```

### 3. Expected end state

```powershell
adb forward tcp:8022 tcp:8022
ssh -o IdentitiesOnly=yes -i <private_key_path> -p 8022 <termux_user>@127.0.0.1
```

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

## What the Skill Assumes

- Windows host with PowerShell
- Android device connected by USB
- the user can unlock the phone and approve prompts
- GitHub-release Termux is acceptable
- public-key authentication is preferred over password automation

If the GitHub Termux build is not available, the non-interactive `run-as com.termux` path no longer applies cleanly.

## Validation

This repository includes a structural validator:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-skill.ps1
```

The validator checks:

- required public-facing files exist
- `SKILL.md` frontmatter is present and coherent
- `agents/openai.yaml` includes the expected interface metadata
- icon references resolve to real files
- the default prompt references `$android-termux-ssh-bootstrap`
- the language switch links stay intact

## Why GitHub Termux Builds

This skill intentionally prefers the official GitHub Termux build because it is suitable for `run-as com.termux` driven setup on Windows. That makes ADB-assisted, non-interactive bootstrapping viable in a way that generic sideloading guidance does not.

It also means this repo is not trying to be a universal Termux guide. It is a focused operator skill.

## References

- [SKILL.md](./SKILL.md)
- [README.ja.md](./README.ja.md)
- [Termux app repository](https://github.com/termux/termux-app)
- [Termux releases](https://github.com/termux/termux-app/releases)
