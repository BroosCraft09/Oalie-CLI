#!/bin/bash
# Oalie CLI v1.2 - Fixed Version

VERSION="1.2"
OALIE_HOME="$HOME/Oalie"
CONF_FILE="$OALIE_HOME/etc/oalie.conf"
LOG_FILE="$OALIE_HOME/log/oalie.log"

# ====== Initialize Directories ======
mkdir -p "$OALIE_HOME"/{etc,log,bin}

# ====== Load Config ======
if [ -f "$CONF_FILE" ]; then
    source "$CONF_FILE"
else
    USERNAME=$(whoami)
    PROMPT_COLOR="\e[32m"
    # Create default config
    cat > "$CONF_FILE" << EOF
USERNAME="$USERNAME"
PROMPT_COLOR="\e[32m"
EOF
fi

# ====== Banner ======
clear
cat << "EOF"
   ██████╗  █████╗ ██╗     ██╗███████╗
  ██╔═══██╗██╔══██╗██║     ██║██╔════╝
  ██║   ██║███████║██║     ██║█████╗  
  ██║   ██║██╔══██║██║     ██║██╔══╝  
  ╚██████╔╝██║  ██║███████╗██║███████╗
   ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝╚══════╝
EOF
echo "========================================"
echo "   Oalie CLI v$VERSION - Lightweight Shell"
echo "========================================"
echo "User    : $USERNAME"
echo "Date    : $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================"

# ====== Custom Commands ======
oalie-ver() {
    echo "Oalie CLI version $VERSION"
}

oalie-help() {
    echo "=== Oalie CLI Commands ==="
    echo "oalie-ver       : Show version"
    echo "oalie-help      : Show this help"
    echo "oalie-uptime    : System uptime"
    echo "oalie-sys       : System information"
    echo "oalie-clear     : Clear screen + reload"
    echo "oalie-pkg list  : List packages"
    echo "oalie-pkg install <pkg> : Install package"
    echo "exit            : Exit Oalie CLI"
}

oalie-uptime() {
    if command -v uptime >/dev/null; then
        uptime
    else
        echo "Uptime: $(($(date +%s) - $(date -d "$(ps -p 1 -o lstart=)" +%s))) seconds"
    fi
}

oalie-sys() {
    echo "=== Oalie System Info ==="
    echo "User    : $USERNAME"
    echo "Version : $VERSION"
    echo "OS      : $(uname -srm)"
    echo "Shell   : $(basename "$SHELL")"
    echo "Date    : $(date)"
}

oalie-clear() {
    clear
    # Simple reload without recursive call
    echo "Oalie CLI reloaded. Type 'oalie-help' for commands."
}

oalie-pkg() {
    case "$1" in
        list)
            echo "=== Available Packages ==="
            echo "nano    - Text editor"
            echo "vim     - Text editor"  
            echo "curl    - HTTP client"
            echo "git     - Version control"
            echo "htop    - Process viewer"
            ;;
        install)
            if [ -z "$2" ]; then
                echo "Usage: oalie-pkg install <package>"
            else
                echo "[Simulation] Installing $2..."
                echo "Package '$2' would be installed here."
            fi
            ;;
        *)
            echo "Usage: oalie-pkg [list|install <pkg>]"
            ;;
    esac
}

# ====== Enhanced Prompt Function ======
oalie-prompt() {
    while true; do
        echo -ne "${PROMPT_COLOR}[oalie@${USERNAME} ~]$ \e[0m"
        read -r -e CMD
        
        # Log command
        echo "$(date '+%Y-%m-%d %H:%M:%S') | $CMD" >> "$LOG_FILE"
        
        # Handle exit command
        if [[ "$CMD" == "exit" ]]; then
            echo "Goodbye from Oalie CLI!"
            break
        fi
        
        # Handle Oalie commands
        if [[ "$CMD" == oalie-* ]]; then
            $CMD
        else
            # Execute system command
            if eval "$CMD" 2>/dev/null; then
                continue
            else
                echo "Command not found: $CMD"
                echo "Type 'oalie-help' for Oalie commands"
            fi
        fi
    done
}

# ====== Main Execution ======
echo "Type 'oalie-help' to see available commands"
echo "Type 'exit' to leave Oalie CLI"
echo ""

# Start the prompt
oalie-prompt
