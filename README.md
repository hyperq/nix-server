# nix-server

One-script bootstrap for Linux servers: system hardening + Docker + Nix + personal dev environment.

Optimized for China mainland servers (all dependencies use domestic mirrors).

## What It Does

```
[0] Prerequisites     → git, curl
[1] System Init       → SSH hardening, timezone, kernel tuning, ulimits
[2] Docker            → Aliyun apt/yum source, registry mirrors, log rotation
[3] Fail2ban          → SSH brute force protection (3 fails = 1hr ban)
[4] Nix               → Single-user install via USTC mirror
[5] Nix Mirrors       → USTC binary cache
[6] Clone Config      → This repo via ghproxy
[7] Home Manager      → Fish, Starship, Neovim, and CLI tools
```

## Quick Start

```bash
apt-get install -y git curl
git clone https://ghproxy.link/https://github.com/hyperq/nix-server.git ~/nix-server
cd ~/nix-server && bash install.sh
```

> **Important:** Password login is disabled after install. Make sure your pubkey is in `~/.ssh/authorized_keys` before running.

## Included Tools

| Category | Tools |
|----------|-------|
| Shell | fish, starship, zoxide, atuin, fzf |
| Editor | neovim (LazyVim) |
| CLI | bat, eza, fd, ripgrep, jq, yazi, bottom |
| Docker | lazydocker |

## Structure

```
flake.nix          → Nix flake entry (nixpkgs + home-manager)
home.nix           → Packages + fish/starship config
install.sh         → Full server bootstrap script
dotfiles/
  atuin/           → Shell history config
  bat/             → Syntax highlighting theme
  lazydocker/      → Docker TUI config
  nvim/            → LazyVim config (Catppuccin + VSCode keybindings)
  yazi/            → File manager config
```

## Customization

- **Username/home:** Edit `home.username` and `home.homeDirectory` in `home.nix`
- **Packages:** Add/remove from `home.packages` in `home.nix`
- **SSH ports:** Modify firewall section in `install.sh`
- **Docker mirrors:** Update `registry-mirrors` in `install.sh` if mirrors go down

## Supported OS

- Debian 12/13
- Ubuntu 22.04+
- CentOS 8+ / RHEL / AlmaLinux / Rocky Linux

## License

[MIT](LICENSE)
