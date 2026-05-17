# 🚀 nix-server

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

一键初始化 Linux 服务器：系统加固 + Docker + Nix + 个人开发环境。

专为国内服务器优化，所有依赖均使用国内镜像源。

[English](README_EN.md) | 中文

## ✨ 功能概览

```
[0] 📦 前置依赖      → git, curl
[1] 🔒 系统初始化    → SSH 加固、时区、内核调优、文件描述符
[2] 🐳 Docker       → 阿里云源安装、镜像加速、日志轮转
[3] 🛡️ Fail2ban     → SSH 防暴力破解（3 次失败封禁 1 小时）
[4] ❄️ Nix          → 中科大镜像单用户安装
[5] 🪞 Nix 镜像     → USTC binary cache
[6] 📥 拉取配置      → 通过 ghproxy 克隆本仓库
[7] 🏠 Home Manager → Fish、Starship、Neovim 及 CLI 工具链
```

## 🏃 快速开始

```bash
apt-get install -y git curl
git clone https://ghproxy.link/https://github.com/hyperq/nix-server.git ~/nix-server
cd ~/nix-server && bash install.sh
```

> ⚠️ **注意：** 安装后密码登录将被禁用！运行前请确保你的公钥已添加到 `~/.ssh/authorized_keys`。

## 🧰 包含工具

| 类别 | 工具 |
|------|------|
| 🐚 Shell | fish, starship, zoxide, atuin, fzf |
| ✏️ 编辑器 | neovim (LazyVim + Catppuccin 主题) |
| 🔧 CLI | bat, eza, fd, ripgrep, jq, yazi, bottom |
| 🐳 Docker | lazydocker |

## 📁 项目结构

```
flake.nix          → Nix Flake 入口 (nixpkgs + home-manager)
home.nix           → 包列表 + fish/starship 配置
install.sh         → 完整服务器初始化脚本
dotfiles/
  ├── atuin/       → 命令历史配置
  ├── bat/         → 语法高亮主题
  ├── lazydocker/  → Docker TUI 配置
  ├── nvim/        → LazyVim (Catppuccin + VSCode 键位)
  └── yazi/        → 文件管理器配置
```

## ⚙️ 自定义

| 需求 | 修改位置 |
|------|---------|
| 用户名/目录 | `home.nix` → `home.username` / `home.homeDirectory` |
| 增减软件包 | `home.nix` → `home.packages` |
| 开放端口 | `install.sh` → 防火墙区域 |
| Docker 镜像源 | `install.sh` → `registry-mirrors`（镜像挂了就换） |

## 💻 支持系统

| 发行版 | 版本 |
|--------|------|
| 🟢 Debian | 12 / 13 |
| 🟢 Ubuntu | 22.04+ |
| 🟢 CentOS / RHEL | 8+ |
| 🟢 AlmaLinux / Rocky | 8+ |

## 📄 许可证

[MIT](LICENSE) © 2026 hyperq
