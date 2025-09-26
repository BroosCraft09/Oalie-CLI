#!/data/data/com.termux/files/usr/bin/bash
# Oalie CLI v1.1 Boot Script

ROOTFS=$HOME/Oalie

# Path & Env
export PATH=$ROOTFS/bin:$ROOTFS/usr/bin:$PATH
export LD_LIBRARY_PATH=$ROOTFS/lib:$ROOTFS/usr/lib
export HOME=$ROOTFS/home

clear

# Banner Oalie-CLI
cat << "EOF"
 -================= ≫ ──── ≪•◦ ❈ ◦•≫ ──── ≪=================-
 │                                                          │
 │   ██████╗  █████╗ ██╗     ██╗███████╗     ██████╗██╗     │
 │  ██╔═══██╗██╔══██╗██║     ██║██╔════╝    ██╔════╝██║     │
 │  ██║   ██║███████║██║     ██║█████╗      ██║     ██║     │
 │  ██║   ██║██╔══██║██║     ██║██╔══╝      ██║     ██║     │
 │  ╚██████╔╝██║  ██║███████╗██║███████╗    ╚██████╗███████╗│
 │   ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝╚══════╝     ╚═════╝╚══════╝│
 │                                                          │
 │                 Welcome to Oalie-CLI v1.1                │
 ╰─━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━─╯
EOF

# Info Sistem
echo -e "\n[ Oalie-CLI Environment Booted ]"
echo "User    : $USER"
echo "Home    : $HOME"
echo "Shell   : bash"
echo "Rootfs  : $ROOTFS"
echo "Date    : $(date)"
echo "Uptime  : $(uptime -p 2>/dev/null || echo 'N/A')"
echo "==============================================="

# Custom prompt
export PS1="\[\e[0;36m\][Oalie@\u \W]$ \[\e[0m\] "

# === Custom Commands ===
# Oalie info
oalie-info() {
    echo "=== Oalie-CLI Info ==="
    echo "Version : v1.1"
    echo "Author  : BocahGabut09"
    echo "Rootfs  : $ROOTFS"
    echo "Shell   : bash"
    echo "======================="
}

# Oalie update (simulasi update)
oalie-update() {
    echo "[Oalie] Checking for updates..."
    sleep 1
    echo "[Oalie] You are on the latest version: v1.1 🎉"
}

# Oalie exit
oalie-exit() {
    echo "[Oalie] Exiting CLI..."
    sleep 1
    exit 0
}

# Start shell
cd $HOME
exec bash --rcfile <(echo "source /etc/bash.bashrc 2>/dev/null || true; \
alias oalie-info=oalie-info; \
alias oalie-update=oalie-update; \
alias oalie-exit=oalie-exit;")
