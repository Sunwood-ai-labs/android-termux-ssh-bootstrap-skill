---
name: android-termux-ssh-bootstrap
description: Set up a fresh Android device for Termux-over-SSH from a Windows PC by preparing ADB, installing the GitHub Termux build, handling HyperOS USB install restrictions, using run-as on the debuggable GitHub build, installing openssh, configuring public-key authentication, and connecting through adb port forwarding. Use when the user wants to get from a blank Android phone to a usable Termux SSH shell without root.
---

# Android Termux SSH Bootstrap

Use this skill when the user wants to:

- connect a fresh Android device to a Windows PC
- install Termux from GitHub Releases
- avoid password-based SSH setup
- reach a real Termux shell over SSH via USB

Do not use this skill for generic Linux SSH work or for F-Droid-only workflows that explicitly forbid the GitHub build. This workflow relies on the GitHub Termux build being `DEBUGGABLE`, so `run-as com.termux` can be used for non-interactive setup.

## Outcome

The target state is:

```powershell
adb forward tcp:8022 tcp:8022
ssh -o IdentitiesOnly=yes -i <pubkey_private_key> -p 8022 <termux_user>@127.0.0.1
```

`<termux_user>` must be discovered from Termux with `whoami`. Never hardcode user-specific values from a previous device.

## Preconditions

- Host OS is Windows with PowerShell available.
- Android device is connected by USB.
- The user can unlock the phone and approve prompts.
- A public key already exists on Windows, preferably `%USERPROFILE%\.ssh\id_ed25519.pub`.

If `adb` is missing, install official Android SDK Platform Tools first.

## Core Rules

1. Prefer GitHub Termux builds when you need non-interactive automation.
2. Match the APK asset to the device ABI. Do not assume `arm64-v8a`; derive it.
3. Prefer public-key authentication. Do not automate plaintext password entry unless the user explicitly asks.
4. Treat Xiaomi / HyperOS `INSTALL_FAILED_USER_RESTRICTED` as a device policy issue, not an ADB bug.
5. Validate at each boundary: ADB ready, Termux installed, run-as usable, openssh installed, sshd running, SSH reachable.

## Required Variables

Resolve these values before proceeding:

- `<apk_path>`: downloaded Termux APK path on Windows
- `<release_tag>`: GitHub release tag actually chosen
- `<pubkey_path>`: Windows public key path
- `<termux_user>`: output of `whoami` inside Termux
- `<abi_list>`: result of `adb shell getprop ro.product.cpu.abilist`

## Workflow

### 1. Prepare and verify ADB

If `adb` is not installed, install Android SDK Platform Tools and ensure `adb version` works.

Validation:

```powershell
adb version
adb devices -l
```

Do not proceed until the device appears as `device`.

If the state is `unauthorized`, have the user unlock the phone and approve `USB debugging`.

### 2. Handle device-side install prerequisites

Tell the user to enable:

- `USB debugging`
- on Xiaomi / HyperOS: `Install via USB`
- if present: `USB debugging (Security settings)`

If `adb install` later fails with:

```text
INSTALL_FAILED_USER_RESTRICTED: Install canceled by user
```

switch to the manual installer path in step 5.

### 3. Resolve the correct GitHub Termux APK

Read the device ABI:

```powershell
adb shell getprop ro.product.cpu.abilist
```

Use the official Termux GitHub release assets and choose the matching APK flavor. Prefer the ABI-specific asset over `universal` unless there is a clear reason not to.

Official sources:

- <https://github.com/termux/termux-app>
- <https://github.com/termux/termux-app/releases>

If the user asks for the latest release, verify the current release tag and asset names from GitHub before downloading.

### 4. Download and verify the APK

If `gh` is available, downloading is straightforward:

```powershell
gh release download <release_tag> -R termux/termux-app -p "<apk_filename>" -p "<sha256_filename>" -D <download_dir>
```

Validate the SHA256 before installing.

### 5. Install Termux

First try:

```powershell
adb install "<apk_path>"
```

If that fails with `INSTALL_FAILED_USER_RESTRICTED`, push the APK to the device and have the user install it from the file manager:

```powershell
adb push "<apk_path>" /sdcard/Download/<apk_filename>
```

Then instruct the user to open the APK from `Download` and install it manually. Do not promise that HyperOS can always be fully driven from ADB; in many cases the final confirmation is user-side.

### 6. Launch Termux and verify the GitHub build properties

Launch the app:

```powershell
adb shell monkey -p com.termux -c android.intent.category.LAUNCHER 1
adb shell pm path com.termux
adb shell dumpsys package com.termux | findstr /I "DEBUGGABLE versionName"
```

Then verify `run-as`:

```powershell
adb shell run-as com.termux pwd
adb shell run-as com.termux ls -la files
```

If `run-as com.termux` fails, stop and reassess. This usually means the installed build is not the debuggable GitHub build, so this skill's non-interactive path does not apply.

### 7. Use a reusable Termux command wrapper

For all non-interactive Termux commands, use a wrapper like this:

```powershell
$remote = @'
run-as com.termux env -i HOME=/data/user/0/com.termux/files/home PREFIX=/data/user/0/com.termux/files/usr PATH=/data/user/0/com.termux/files/usr/bin:/data/user/0/com.termux/files/usr/bin/applets TERM=xterm-256color /data/user/0/com.termux/files/usr/bin/bash -lc '<termux_command>'
'@
adb shell $remote
```

Use it for package installation, `whoami`, SSH key placement, and `sshd` startup.

### 8. Install OpenSSH inside Termux

Use the wrapper and run:

```text
pkg update -y && pkg install -y openssh
```

Do not skip `pkg update`. Initial mirror selection and package metadata refresh may take time on the first run.

### 9. Configure public-key authentication

Prefer the user's existing public key. A typical choice is:

```text
%USERPROFILE%\.ssh\id_ed25519.pub
```

Push it to a temporary device path:

```powershell
adb push "<pubkey_path>" /data/local/tmp/codex_termux_id_ed25519.pub
```

Then install it into `authorized_keys` from Termux:

```text
mkdir -p "$HOME/.ssh" && cat /data/local/tmp/codex_termux_id_ed25519.pub > "$HOME/.ssh/authorized_keys" && chmod 700 "$HOME/.ssh" && chmod 600 "$HOME/.ssh/authorized_keys"
```

After that, remove the temporary copy:

```powershell
adb shell rm /data/local/tmp/codex_termux_id_ed25519.pub
```

### 10. Start sshd and discover the Termux username

Start the daemon from Termux:

```text
sshd
```

Discover the actual SSH username:

```text
whoami
```

Save that as `<termux_user>`. Do not reuse a username from a prior device.

### 11. Forward the port and verify SSH

Forward USB port 8022:

```powershell
adb forward tcp:8022 tcp:8022
adb forward --list
```

Connect:

```powershell
ssh -o IdentitiesOnly=yes -i <pubkey_private_key> -p 8022 <termux_user>@127.0.0.1
```

For non-interactive verification, run something like:

```powershell
cmd /c ssh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=%TEMP%\termux_known_hosts -o IdentitiesOnly=yes -i <pubkey_private_key> -p 8022 <termux_user>@127.0.0.1 "whoami"
```

Then verify it is really a Termux environment:

```powershell
cmd /c ssh -o StrictHostKeyChecking=yes -o UserKnownHostsFile=%TEMP%\termux_known_hosts -o IdentitiesOnly=yes -i <pubkey_private_key> -p 8022 <termux_user>@127.0.0.1 ". /data/data/com.termux/files/usr/etc/profile; printenv HOME; printenv PREFIX; command -v pkg"
```

## Validation Checklist

These must all pass before you claim success:

1. `adb devices -l` shows the device as `device`
2. `adb shell pm path com.termux` returns a package path
3. `adb shell run-as com.termux pwd` works
4. `pkg install -y openssh` completes
5. `whoami` in Termux returns a concrete `<termux_user>`
6. `sshd` starts without fatal errors
7. `adb forward --list` contains `tcp:8022`
8. `ssh` login succeeds
9. remote `command -v pkg` resolves inside Termux

## Troubleshooting

### `adb devices -l` shows `unauthorized`

- user must unlock the phone
- user must approve `USB debugging`
- replug USB if necessary

### `INSTALL_FAILED_USER_RESTRICTED`

- this is usually a device-side restriction, common on Xiaomi / HyperOS
- ask the user to enable `Install via USB`
- if needed, also enable `USB debugging (Security settings)`
- if ADB install is still blocked, switch to `adb push` plus manual on-device install

### `run-as com.termux` fails

- the installed build may not be a GitHub debug build
- the app may not be fully installed yet
- fall back to user-driven setup inside the Termux UI if necessary

### SSH works once, then dies later

OEM power management may kill Termux or `sshd`.

Recommend:

- exclude Termux from battery optimization
- allow autostart if the OEM exposes it
- keep Termux foregrounded during initial validation

## Notes

- `adb shell` is Android's `shell` user, not the Termux shell
- the real success condition is SSH into Termux, not merely shell access to Android
- use concrete runtime evidence in the final report: chosen asset, install result, username, and verification command outputs
