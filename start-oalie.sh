#!/bin/bash
# Oalie CLI v1.3 - With Custom Command Creator

VERSION="1.3"
OALIE_HOME="$HOME/Oalie"
OALIE_BIN="$OALIE_HOME/bin"
OALIE_ETC="$OALIE_HOME/etc"
OALIE_LOG="$OALIE_HOME/log"
CONF_FILE="$OALIE_ETC/oalie.conf"
LOG_FILE="$OALIE_LOG/oalie.log"
CUSTOM_CMD_DIR="$OALIE_BIN"

# ====== Initialize Directories ======
mkdir -p "$OALIE_HOME" "$OALIE_BIN" "$OALIE_ETC" "$OALIE_LOG"

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
CUSTOM_CMD_DIR="$OALIE_BIN"
EOF
fi

# ====== Load Custom Commands ======
load_custom_commands() {
    if [ -d "$CUSTOM_CMD_DIR" ]; then
        for cmd_file in "$CUSTOM_CMD_DIR"/*; do
            if [ -f "$cmd_file" ] && [ -x "$cmd_file" ]; then
                cmd_name=$(basename "$cmd_file")
                # Tambahkan ke available commands
                eval "$cmd_name() { \"$cmd_file\" \"\$@\"; }"
            fi
        done
    fi
}

# ====== Banner ======
show_banner() {
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
    echo "   Oalie CLI v$VERSION - Custom Commands"
    echo "========================================"
    echo "User    : $USERNAME"
    echo "Date    : $(date '+%Y-%m-%d %H:%M:%S')"
    echo "Custom  : $(ls "$CUSTOM_CMD_DIR" 2>/dev/null | wc -l) commands available"
    echo "========================================"
}

# ====== Custom Commands ======
oalie-ver() {
    echo "Oalie CLI version $VERSION"
    echo "Custom commands directory: $CUSTOM_CMD_DIR"
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
    echo "oalie-cmd create <name> : Create custom command"
    echo "oalie-cmd list          : List custom commands"
    echo "oalie-cmd edit <name>   : Edit custom command"
    echo "oalie-cmd delete <name> : Delete custom command"
    echo "exit            : Exit Oalie CLI"
    
    # Show available custom commands
    if [ -d "$CUSTOM_CMD_DIR" ] && [ "$(ls -A "$CUSTOM_CMD_DIR")" ]; then
        echo ""
        echo "=== Custom Commands ==="
        for cmd in "$CUSTOM_CMD_DIR"/*; do
            if [ -f "$cmd" ] && [ -x "$cmd" ]; then
                echo "  $(basename "$cmd")"
            fi
        done
    fi
}

oalie-uptime() {
    if command -v uptime >/dev/null; then
        uptime
    else
        echo "Uptime: Active"
    fi
}

oalie-sys() {
    echo "=== Oalie System Info ==="
    echo "User    : $USERNAME"
    echo "Version : $VERSION"
    echo "OS      : $(uname -srm)"
    echo "Shell   : $(basename "$SHELL")"
    echo "Date    : $(date)"
    echo "Custom  : $(ls "$CUSTOM_CMD_DIR" 2>/dev/null | wc -l) commands"
}

oalie-clear() {
    show_banner
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

# ====== Custom Command Management ======
oalie-cmd() {
    case "$1" in
        create)
            if [ -z "$2" ]; then
                echo "Usage: oalie-cmd create <command_name>"
                return 1
            fi
            
            local cmd_name="$2"
            local cmd_file="$CUSTOM_CMD_DIR/$cmd_name"
            
            if [ -f "$cmd_file" ]; then
                echo "Error: Command '$cmd_name' already exists!"
                return 1
            fi
            
            # Create template command
            cat > "$cmd_file" << EOF
#!/bin/bash
# Oalie Custom Command: $cmd_name
# Created: $(date)

echo "Custom command: $cmd_name"
echo "Hello from your custom command!"
echo "Arguments received: \$#"
echo "All arguments: \$@"

# Add your custom logic here
# Example: 
# if [ \$# -eq 0 ]; then
#     echo "Usage: $cmd_name <argument>"
# else
#     echo "You said: \$1"
# fi
EOF
            
            chmod +x "$cmd_file"
            echo "✅ Custom command '$cmd_name' created!"
            echo "📝 Edit it with: oalie-cmd edit $cmd_name"
            ;;
        
        list)
            if [ ! -d "$CUSTOM_CMD_DIR" ] || [ -z "$(ls -A "$CUSTOM_CMD_DIR")" ]; then
                echo "No custom commands available."
                echo "Create one with: oalie-cmd create <name>"
                return 0
            fi
            
            echo "=== Custom Commands ==="
            for cmd in "$CUSTOM_CMD_DIR"/*; do
                if [ -f "$cmd" ] && [ -x "$cmd" ]; then
                    local cmd_name=$(basename "$cmd")
                    local line_count=$(wc -l < "$cmd" 2>/dev/null || echo "0")
                    echo "  $cmd_name ($line_count lines)"
                fi
            done
            ;;
        
        edit)
            if [ -z "$2" ]; then
                echo "Usage: oalie-cmd edit <command_name>"
                return 1
            fi
            
            local cmd_name="$2"
            local cmd_file="$CUSTOM_CMD_DIR/$cmd_name"
            
            if [ ! -f "$cmd_file" ]; then
                echo "Error: Command '$cmd_name' not found!"
                echo "Create it first with: oalie-cmd create $cmd_name"
                return 1
            fi
            
            # Try to use available editors
            if command -v nano >/dev/null; then
                nano "$cmd_file"
            elif command -v vim >/dev/null; then
                vim "$cmd_file"
            elif command -v vi >/dev/null; then
                vi "$cmd_file"
            else
                echo "No editor found. Please install nano or vim."
                echo "Command file: $cmd_file"
            fi
            
            chmod +x "$cmd_file"
            echo "✅ Command '$cmd_name' updated!"
            ;;
        
        delete)
            if [ -z "$2" ]; then
                echo "Usage: oalie-cmd delete <command_name>"
                return 1
            fi
            
            local cmd_name="$2"
            local cmd_file="$CUSTOM_CMD_DIR/$cmd_name"
            
            if [ ! -f "$cmd_file" ]; then
                echo "Error: Command '$cmd_name' not found!"
                return 1
            fi
            
            read -p "Are you sure you want to delete '$cmd_name'? (y/N): " confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                rm "$cmd_file"
                echo "✅ Command '$cmd_name' deleted!"
            else
                echo "Deletion cancelled."
            fi
            ;;
        
        *)
            echo "Usage: oalie-cmd [create|list|edit|delete] <command_name>"
            echo ""
            echo "Examples:"
            echo "  oalie-cmd create hello     # Create 'hello' command"
            echo "  oalie-cmd list             # List all custom commands"
            echo "  oalie-cmd edit hello       # Edit 'hello' command"
            echo "  oalie-cmd delete hello     # Delete 'hello' command"
            ;;
    esac
}

# ====== Enhanced Prompt Function ======
oalie-prompt() {
    # Load custom commands setiap kali prompt dimulai
    load_custom_commands
    
    while true; do
        echo -ne "${PROMPT_COLOR}[oalie@${USERNAME} ~]$ \e[0m"
        read -r -e CMD
        
        # Skip empty commands
        if [ -z "$CMD" ]; then
            continue
        fi
        
        # Log command
        echo "$(date '+%Y-%m-%d %H:%M:%S') | $CMD" >> "$LOG_FILE"
        
        # Handle exit command
        if [[ "$CMD" == "exit" ]] || [[ "$CMD" == "quit" ]]; then
            echo "Goodbye from Oalie CLI v$VERSION!"
            break
        fi
        
        # Handle Oalie built-in commands
        if [[ "$CMD" == oalie-* ]]; then
            $CMD
            continue
        fi
        
        # Handle custom commands from bin directory
        local custom_cmd="$CUSTOM_CMD_DIR/$CMD"
        if [ -f "$custom_cmd" ] && [ -x "$custom_cmd" ]; then
            "$custom_cmd" "${@:2}"
            continue
        fi
        
        # Execute system command
        if eval "$CMD" 2>/dev/null; then
            continue
        else
            echo "Command not found: $CMD"
            echo "Type 'oalie-help' for available commands"
        fi
    done
}

# ====== Welcome Message ======
show_welcome() {
    echo "✨ New in v$VERSION: Custom command creator!"
    echo "💡 Try: oalie-cmd create hello"
    echo "📁 Custom commands stored in: $CUSTOM_CMD_DIR"
    echo ""
}

# ====== Main Execution ======
show_banner
show_welcome

# Create example command jika folder kosong
if [ ! -d "$CUSTOM_CMD_DIR" ] || [ -z "$(ls -A "$CUSTOM_CMD_DIR")" ]; then
    echo "📝 No custom commands found. Creating example..."
    oalie-cmd create example >/dev/null 2>&1
fi

echo "Type 'oalie-help' to see available commands"
echo "Type 'exit' to leave Oalie CLI"
echo ""

# Start the prompt
oalie-prompt
