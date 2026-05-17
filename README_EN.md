# 🚀 nix-server

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

One-script bootstrap for Linux servers: system hardening + Docker + Nix + personal dev environment.

Optimized for China mainland servers — all dependencies use domestic mirrors.

[中文](README.md) | English

## ✨ What It Does

```
[0] 📦 Prerequisites   → git, curl
[1] 🔒 System Init     → SSH hardening, timezone, kernel tuning, ulimits
[2] 🐳 Docker          → Aliyun source, registry mirrors, log rotation
[3] 🛡️ Fail2ban        → SSH brute force protection (3 fails = 1hr ban)
[4] ❄️ Nix             → Single-user install via USTC mirror
[5] 🪞 Nix Mirrors     → USTC binary cache
[6] 📥 Clone Config    → This repo via ghproxy
[7] 🏠 Home Manager    → Fish, Starship, Neovim, and CLI tools
```

## 🏃 Quick Start

```bash
apt-get install -y git curl
git clone https://ghproxy.link/https://github.com/hyperq/nix-server.git ~/nix-server
cd ~/nix-server && bash install.sh
```

> ⚠️ **Warning:** Password login is disabled after install. Make sure your pubkey is in `~/.ssh/authorized_keys` before running.

## 🧰 Included Tools

| Category | Tools |
|----------|-------|
| 🐚 Shell | fish, starship, zoxide, atuin, fzf |
| ✏️ Editor | neovim (LazyVim + Catppuccin theme) |
| 🔧 CLI | bat, eza, fd, ripgrep, jq, yazi, bottom |
| 🐳 Docker | lazydocker |

## 📁 Structure

```
flake.nix          → Nix Flake entry (nixpkgs + home-manager)
home.nix           → Packages + fish/starship config
install.sh         → Full server bootstrap script
dotfiles/
  ├── atuin/       → Shell history config
  ├── bat/         → Syntax highlighting theme
  ├── lazydocker/  → Docker TUI config
  ├── nvim/        → LazyVim (Catppuccin + VSCode keybindings)
  └── yazi/        → File manager config
```

## ⚙️ Customization

| Need | Where to Edit |
|------|--------------|
| Username/home dir | `home.nix` → `home.username` / `home.homeDirectory` |
| Add/remove packages | `home.nix` → `home.packages` |
| Open ports | `install.sh` → firewall section |
| Docker mirrors | `install.sh` → `registry-mirrors` (swap if mirrors die) |

## 💻 Supported OS

| Distro | Version |
|--------|---------|
| 🟢 Debian | 12 / 13 |
| 🟢 Ubuntu | 22.04+ |
| 🟢 CentOS / RHEL | 8+ |
| 🟢 AlmaLinux / Rocky | 8+ |

## 📄 License

[MIT](LICENSE) © 2026 hyperq
