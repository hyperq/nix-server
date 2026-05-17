#!/usr/bin/env bash
set -euo pipefail

# ===========================================
# Server bootstrap: System init + Docker + Nix + Home Manager
# Tested on: Debian 13 / Ubuntu 22+ / CentOS 8+
# ===========================================

# TODO: replace with your repo
REPO_URL="https://ghproxy.link/https://github.com/hyperq/nix-server.git"
NIX_DIR="$HOME/nix-server"

# -------------------------------------------
# [0] Prerequisites
# -------------------------------------------
echo "==> [0/8] Installing prerequisites..."
if command -v apt-get &>/dev/null; then
  apt-get update && apt-get install -y git curl
elif command -v yum &>/dev/null; then
  yum install -y git curl
fi

# -------------------------------------------
# [1] System initialization
# -------------------------------------------
echo "==> [1/8] System initialization (SSH + Security + Performance)..."

# --- SSH: root + pubkey login, disable password ---
SSHD_CONFIG="/etc/ssh/sshd_config"
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' "$SSHD_CONFIG"
sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' "$SSHD_CONFIG"
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' "$SSHD_CONFIG"
sed -i 's/^#\?MaxAuthTries.*/MaxAuthTries 3/' "$SSHD_CONFIG"
sed -i 's/^#\?ClientAliveInterval.*/ClientAliveInterval 60/' "$SSHD_CONFIG"
sed -i 's/^#\?ClientAliveCountMax.*/ClientAliveCountMax 3/' "$SSHD_CONFIG"
mkdir -p ~/.ssh && chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys
systemctl restart sshd

# --- Timezone ---
timedatectl set-timezone Asia/Shanghai

# --- Kernel: security hardening ---
cat > /etc/sysctl.d/99-security.conf << 'EOF'
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.tcp_syncookies = 1
net.ipv4.conf.all.log_martians = 1
EOF

# --- Kernel: performance tuning ---
cat > /etc/sysctl.d/99-performance.conf << 'EOF'
# File descriptors
fs.file-max = 1048576
fs.inotify.max_user_watches = 524288
fs.inotify.max_user_instances = 1024

# TCP
net.core.somaxconn = 65535
net.core.netdev_max_backlog = 65535
net.ipv4.tcp_max_syn_backlog = 65535
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_keepalive_intvl = 30
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.ip_local_port_range = 1024 65535

# Memory
vm.swappiness = 10
vm.overcommit_memory = 1
EOF

sysctl --system > /dev/null

# --- File descriptor limits ---
cat > /etc/security/limits.d/99-server.conf << 'EOF'
* soft nofile 1048576
* hard nofile 1048576
* soft nproc 65535
* hard nproc 65535
root soft nofile 1048576
root hard nofile 1048576
EOF

echo "    SSH: root+pubkey enabled, password disabled"
echo "    Timezone: Asia/Shanghai"
echo "    Kernel: security + TCP/memory tuning applied"

# -------------------------------------------
# [2] Docker
# -------------------------------------------
echo "==> [2/8] Installing Docker (Aliyun mirror)..."
if ! command -v docker &>/dev/null; then
  . /etc/os-release
  case "$ID" in
    debian|ubuntu)
      apt-get update
      apt-get install -y ca-certificates curl gnupg
      install -m 0755 -d /etc/apt/keyrings
      curl -fsSL "https://mirrors.aliyun.com/docker-ce/linux/$ID/gpg" -o /etc/apt/keyrings/docker.asc
      chmod a+r /etc/apt/keyrings/docker.asc
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://mirrors.aliyun.com/docker-ce/linux/$ID $VERSION_CODENAME stable" > /etc/apt/sources.list.d/docker.list
      apt-get update
      apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
      ;;
    centos|rhel|almalinux|rocky)
      yum install -y yum-utils
      yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
      sed -i 's+download.docker.com+mirrors.aliyun.com/docker-ce+' /etc/yum.repos.d/docker-ce.repo
      yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
      ;;
    *)
      echo "    Unsupported OS: $ID. Install Docker manually."
      exit 1
      ;;
  esac
  systemctl enable --now docker
else
  echo "    Docker already installed, skipping."
fi

# --- Docker: registry mirrors + log rotation + respect firewall ---
mkdir -p /etc/docker
cat > /etc/docker/daemon.json << 'EOF'
{
  "registry-mirrors": [
    "https://docker.1ms.run",
    "https://docker.xuanyuan.me"
  ],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "50m",
    "max-file": "3"
  },
  "storage-driver": "overlay2",
  "iptables": false
}
EOF
systemctl restart docker 2>/dev/null || true

# -------------------------------------------
# [3] Fail2ban (firewall via cloud security group)
# -------------------------------------------
echo "==> [3/8] Configuring fail2ban..."

# Firewall: use cloud provider's security group (Alibaba Cloud, etc.)
# Only fail2ban for OS-level SSH brute force protection

. /etc/os-release
case "$ID" in
  debian|ubuntu)
    apt-get install -y fail2ban
    ;;
  centos|rhel|almalinux|rocky)
    yum install -y fail2ban
    ;;
esac

cat > /etc/fail2ban/jail.local << 'EOF'
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 3

[sshd]
enabled = true
port = ssh
backend = systemd
EOF

systemctl enable --now fail2ban
echo "    Fail2ban: 3 failures = 1 hour ban"
echo "    Firewall: managed by cloud security group"

# -------------------------------------------
# [4] Nix
# -------------------------------------------
echo "==> [4/8] Installing Nix (single-user, no daemon)..."
if ! command -v nix &>/dev/null; then
  curl -L https://mirrors.ustc.edu.cn/nix/latest/install | sh -s -- --no-daemon
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
else
  echo "    Nix already installed, skipping."
fi

# -------------------------------------------
# [4] Nix mirrors
# -------------------------------------------
echo "==> [5/8] Configuring China mirrors (USTC)..."
mkdir -p ~/.config/nix
cat > ~/.config/nix/nix.conf << 'EOF'
experimental-features = nix-command flakes
substituters = https://mirrors.ustc.edu.cn/nix-store https://cache.nixos.org
trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
EOF

# -------------------------------------------
# [5] Clone config
# -------------------------------------------
echo "==> [6/8] Cloning config..."
if [ -d "$NIX_DIR" ]; then
  cd "$NIX_DIR" && git pull
else
  git clone "$REPO_URL" "$NIX_DIR"
  cd "$NIX_DIR"
fi

# -------------------------------------------
# [6] Activate home-manager
# -------------------------------------------
echo "==> [7/8] Activating home-manager..."
nix run home-manager -- switch --flake .#server

echo ""
echo "========================================="
echo "  All done! Server is ready."
echo "========================================="
echo "  - Run 'fish' to enter your shell"
echo "  - Make fish default: chsh -s \$(which fish)"
echo "  - Add your pubkey to ~/.ssh/authorized_keys"
echo "  - Password login is DISABLED"
echo ""
