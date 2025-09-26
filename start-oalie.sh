#!/bin/bash
# Oalie CLI v1.1

clear

# Banner
cat << "EOF"
   ██████╗  █████╗ ██╗     ██╗███████╗     ██████╗██╗     ██╗
  ██╔═══██╗██╔══██╗██║     ██║██╔════╝    ██╔════╝██║     ██║
  ██║   ██║███████║██║     ██║███████╗    ██║     ██║     ██║
  ██║   ██║██╔══██║██║     ██║██╔════╝    ██║     ██║     ██║
  ╚██████╔╝██║  ██║███████╗██║███████╗    ╚██████╗███████╗██║
   ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝╚══════╝     ╚═════╝╚══════╝╚═╝

             Welcome to Oalie CLI v1.1
============================================================
EOF

# Pastikan folder home ada
if [ ! -d "$HOME/Oalie/home" ]; then
    mkdir -p "$HOME/Oalie/home"
fi

# Info environment
echo "[ Oalie CLI - Environment Booted ]"
echo "User    : $USER"
echo "Home    : $HOME/Oalie/home"
echo "Shell   : $SHELL"
echo "Rootfs  : $HOME/Oalie"
echo "Date    : $(date)"
echo "Uptime  : $(uptime -p)"
echo "============================================================"
echo

# Fungsi command custom
oalie_help() {
    echo "Oalie CLI v1.1 - Custom Commands"
    echo "  oalie-help   : Show this help"
    echo "  oalie-about  : About Oalie CLI"
    echo "  oalie-clear  : Clear screen with banner"
}

oalie_about() {
    echo "Oalie CLI v1.1"
    echo "Created for Termux experiment."
    echo "This is a mini custom Linux-like environment."
}

oalie_clear() {
    clear
    bash "$HOME/Oalie/start-oalie.sh"
}

# Export command ke shell
alias oalie-help=oalie_help
alias oalie-about=oalie_about
alias oalie-clear=oalie_clear

# Masuk ke 'home' Oalie
cd "$HOME/Oalie/home"

# Start interactive shell
exec bash --login
