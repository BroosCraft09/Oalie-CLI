#!/data/data/com.termux/files/usr/bin/bash
# Oalie CLI Boot Script

ROOTFS=$HOME/Oalie

# Path & Env
export PATH=$ROOTFS/bin:$ROOTFS/usr/bin:$PATH
export LD_LIBRARY_PATH=$ROOTFS/lib:$ROOTFS/usr/lib
export HOME=$ROOTFS/home

clear

# Banner Oalie
cat << "EOF"
 -================= ≫ ──── ≪•◦ ❈ ◦•≫ ──── ≪=================-
 │                                                          │
 │   █████╗  ██████╗██╗     ██╗███████╗                     │
 │  ██╔══██╗██╔════╝██║     ██║██╔════╝                     │
 │  ███████║██║     ██║     ██║█████╗                       │
 │  ██╔══██║██║     ██║     ██║██╔══╝                       │
 │  ██║  ██║╚██████╗███████╗██║██║                          │
 │  ╚═╝  ╚═╝ ╚═════╝╚══════╝╚═╝╚═╝                          │
 │                                                          │
 │               Welcome to Oalie CLI v1.0                  │
 ╰─━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━─╯
EOF

# Info Sistem
echo -e "\n[ Oalie CLI - Environment Booted ]"
echo "User    : $USER"
echo "Home    : $HOME"
echo "Shell   : bash"
echo "Rootfs  : $ROOTFS"
echo "Date    : $(date)"
echo "Uptime  : $(uptime -p 2>/dev/null || echo 'N/A')"
echo "==============================================="

# Custom prompt (biar mirip distro beneran)
export PS1="\[\e[0;36m\][Oalie@\u \W]$ \[\e[0m\] "

# Start shell
cd $HOME
exec bash --rcfile <(echo "source /etc/bash.bashrc 2>/dev/null || true")
