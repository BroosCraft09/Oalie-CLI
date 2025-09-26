#!/bin/bash
# Oalie CLI v1.2 - Major Update

VERSION="1.2"
OALIE_HOME="$HOME/Oalie"
CONF_FILE="$OALIE_HOME/etc/oalie.conf"
LOG_FILE="$OALIE_HOME/log/oalie.log"

# ====== Load Config ======
if [ -f "$CONF_FILE" ]; then
    source "$CONF_FILE"
else
    USERNAME=$(whoami)
    PROMPT_COLOR="\e[32m"
fi

# ====== Banner ======
clear
cat << "EOF"
   ██████╗  █████╗ ██╗     ██╗███████╗      ██████╗██╗     ██╗
  ██╔═══██╗██╔══██╗██║     ██║██╔════╝     ██╔════╝██║     ██║
  ██║   ██║███████║██║     ██║█████╗       ██║     ██║     ██║
  ██║   ██║██╔══██║██║     ██║██╔══╝       ██║     ██║     ██║
  ╚██████╔╝██║  ██║███████╗██║███████╗     ╚██████╗███████╗██║
   ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝╚══════╝      ╚═════╝╚══════╝╚═╝
EOF
echo "============================================================"
echo " Welcome to Oalie CLI v$VERSION"
echo "============================================================"
echo "User   : $USERNAME"
echo "Shell  : $(basename $SHELL)"
echo "Rootfs : /"
echo "Date   : $(date)"
echo "============================================================"

# ====== Custom Commands ======
oalie-ver() {
    echo "Oalie CLI version $VERSION"
}

oalie-help() {
    echo "=== Oalie CLI Commands ==="
    echo "oalie-ver       : Cek versi"
    echo "oalie-help      : Lihat command khusus"
    echo "oalie-uptime    : Uptime sistem"
    echo "oalie-sys       : Info sistem (mini neofetch)"
    echo "oalie-clear     : Bersihin layar + reload banner"
    echo "oalie-pkg list  : Lihat daftar package"
    echo "oalie-pkg install <pkg> : Install package palsu"
}

oalie-uptime() {
    echo "System Uptime: $(uptime -p)"
}

oalie-sys() {
    echo "=== Oalie System Info ==="
    echo "User   : $USERNAME"
    echo "Shell  : $(basename $SHELL)"
    echo "OS     : Oalie CLI $VERSION"
    echo "Uptime : $(uptime -p)"
    echo "Date   : $(date)"
}

oalie-clear() {
    clear
    bash "$OALIE_HOME/start-oalie.sh"
}

oalie-pkg() {
    case "$1" in
        list)
            echo "=== Available Packages ==="
            echo "nano  vim  curl  git  neofetch"
            ;;
        install)
            if [ -z "$2" ]; then
                echo "Usage: oalie-pkg install <package>"
            else
                echo "Installing $2 ... done (simulated)."
            fi
            ;;
        *)
            echo "Usage: oalie-pkg [list|install <pkg>]"
            ;;
    esac
}

# ====== Custom Prompt ======
while true; do
    echo -ne "${PROMPT_COLOR}[oalie@cli ~]$ \e[0m"
    read -e CMD
    echo "$(date) | $CMD" >> "$LOG_FILE"
    if declare -f "$CMD" > /dev/null; then
        $CMD
    else
        bash -c "$CMD"
    fi
done
