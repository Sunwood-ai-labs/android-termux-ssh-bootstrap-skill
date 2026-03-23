# Contributing

## Scope

This repository is intentionally narrow. Contributions should improve one of these areas:

- skill accuracy for the Windows to Android bootstrap flow
- public repository clarity
- validation and operator safety

## Before Opening a PR

1. Keep the workflow centered on the GitHub Termux build and `adb` plus `ssh`.
2. Avoid turning this repository into a generic Android or Linux guide.
3. Run the validator locally.

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-skill.ps1
```

## Pull Request Expectations

- explain the operator problem being fixed
- update `README.md`, `README.ja.md`, and `SKILL.md` when behavior changes
- keep placeholders generic, not device-specific
- prefer concrete validation evidence over assumptions

## Style Notes

- keep repository text concise and operational
- prefer ASCII unless Japanese text is required
- do not hardcode usernames, serials, or local machine paths in shared docs
