#!/bin/bash
# Oalie CLI v1.4 - Advanced Edition

VERSION="1.4"
OALIE_HOME="$HOME/Oalie"
OALIE_BIN="$OALIE_HOME/bin"
OALIE_ETC="$OALIE_HOME/etc"
OALIE_LOG="$OALIE_HOME/log"
OALIE_HOME_DIR="$OALIE_HOME/home"  # New home directory for Oalie
CONF_FILE="$OALIE_ETC/oalie.conf"
LOG_FILE="$OALIE_LOG/oalie.log"
CUSTOM_CMD_DIR="$OALIE_BIN"
GITHUB_REPO="https://github.com/BroosCraft09/Oalie-CLI"

# ====== Initialize Directories ======
mkdir -p "$OALIE_HOME" "$OALIE_BIN" "$OALIE_ETC" "$OALIE_LOG" "$OALIE_HOME_DIR"

# ====== Load Config ======
if [ -f "$CONF_FILE" ]; then
    source "$CONF_FILE"
else
    USERNAME=$(whoami)
    PROMPT_COLOR="\e[32m"
    THEME="default"
    # Create default config
    cat > "$CONF_FILE" << EOF
USERNAME="$USERNAME"
PROMPT_COLOR="\e[32m"
THEME="default"
CUSTOM_CMD_DIR="$OALIE_BIN"
OALIE_HOME_DIR="$OALIE_HOME_DIR"
EOF
fi

# ====== Change to Oalie Home Directory ======
cd "$OALIE_HOME_DIR" 2>/dev/null || mkdir -p "$OALIE_HOME_DIR" && cd "$OALIE_HOME_DIR"

# ====== Update Check Function ======
check_update() {
    echo "🔍 Checking for updates..."
    
    # Try to get latest version from GitHub
    LATEST_VERSION=$(curl -s "https://raw.githubusercontent.com/BroosCraft09/Oalie-CLI/main/version.txt" 2>/dev/null)
    
    if [ -z "$LATEST_VERSION" ]; then
        LATEST_VERSION=$(wget -qO- "https://raw.githubusercontent.com/BroosCraft09/Oalie-CLI/main/version.txt" 2>/dev/null)
    fi
    
    if [ -z "$LATEST_VERSION" ]; then
        echo "❌ Could not check for updates (no internet connection?)"
        return 1
    fi
    
    if [ "$LATEST_VERSION" != "$VERSION" ]; then
        echo "🎉 New version available: v$LATEST_VERSION"
        echo "📥 Download from: $GITHUB_REPO"
        echo "💡 Current version: v$VERSION"
    else
        echo "✅ You have the latest version: v$VERSION"
    fi
}

# ====== Enhanced CD Command ======
oalie-cd() {
    if [ -z "$1" ]; then
        # cd without arguments goes to Oalie home
        cd "$OALIE_HOME_DIR"
        echo "📁 Changed to Oalie home: $OALIE_HOME_DIR"
    elif [ "$1" == "home" ]; then
        cd "$OALIE_HOME_DIR"
        echo "📁 Changed to Oalie home"
    elif [ "$1" == "bin" ]; then
        cd "$OALIE_BIN"
        echo "📁 Changed to Oalie bin directory"
    elif [ "$1" == "etc" ]; then
        cd "$OALIE_ETC"
        echo "📁 Changed to Oalie etc directory"
    elif [ "$1" == "log" ]; then
        cd "$OALIE_LOG"
        echo "📁 Changed to Oalie log directory"
    elif [ "$1" == "root" ]; then
        cd "$OALIE_HOME"
        echo "📁 Changed to Oalie root directory"
    else
        # Regular cd functionality
        cd "$1" 2>/dev/null || echo "❌ Directory not found: $1"
    fi
}

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
    echo "   Oalie CLI v$VERSION - Advanced Edition"
    echo "========================================"
    echo "User    : $USERNAME"
    echo "Date    : $(date '+%Y-%m-%d %H:%M:%S')"
    echo "Home    : $OALIE_HOME_DIR"
    echo "Custom  : $(ls "$CUSTOM_CMD_DIR" 2>/dev/null | wc -l) commands"
    echo "========================================"
}

# ====== Custom Commands ======
oalie-ver() {
    echo "Oalie CLI version $VERSION"
    echo "Custom commands directory: $CUSTOM_CMD_DIR"
    echo "Oalie home directory: $OALIE_HOME_DIR"
    echo "GitHub: $GITHUB_REPO"
}

oalie-help() {
    echo "=== Oalie CLI Commands v$VERSION ==="
    echo "oalie-ver       : Show version info"
    echo "oalie-help      : Show this help"
    echo "oalie-uptime    : System uptime"
    echo "oalie-sys       : System information"
    echo "oalie-clear     : Clear screen + reload"
    echo "oalie-update    : Check for updates"
    echo "oalie-cd [dir]  : Enhanced cd command"
    echo "oalie-pkg list  : List packages"
    echo "oalie-theme     : Change theme/colors"
    echo "oalie-backup    : Backup custom commands"
    echo "oalie-restore   : Restore from backup"
    echo "oalie-cmd create <name> : Create custom command"
    echo "oalie-cmd list          : List custom commands"
    echo "oalie-cmd edit <name>   : Edit custom command"
    echo "oalie-cmd delete <name> : Delete custom command"
    echo "exit            : Exit Oalie CLI"
    
    # Navigation help
    echo ""
    echo "=== Navigation Shortcuts ==="
    echo "cd              : Go to Oalie home"
    echo "cd home         : Go to Oalie home"
    echo "cd bin          : Go to commands directory"
    echo "cd etc          : Go to config directory"
    echo "cd log          : Go to log directory"
    echo "cd root         : Go to Oalie root"
    
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
        echo "System is running"
        echo "Oalie started: $(date)"
    fi
}

oalie-sys() {
    echo "=== Oalie System Info ==="
    echo "User     : $USERNAME"
    echo "Version  : $VERSION"
    echo "OS       : $(uname -srm)"
    echo "Shell    : $(basename "$SHELL")"
    echo "Date     : $(date)"
    echo "Home     : $OALIE_HOME_DIR"
    echo "Custom   : $(ls "$CUSTOM_CMD_DIR" 2>/dev/null | wc -l) commands"
    echo "GitHub   : $GITHUB_REPO"
}

oalie-clear() {
    show_banner
    echo "Oalie CLI reloaded. Type 'oalie-help' for commands."
}

oalie-update() {
    check_update
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
            echo "wget    - Download tool"
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

# ====== Theme System ======
oalie-theme() {
    case "$1" in
        list)
            echo "=== Available Themes ==="
            echo "default  - Green prompt"
            echo "blue     - Blue prompt"
            echo "red      - Red prompt"
            echo "yellow   - Yellow prompt"
            echo "cyan     - Cyan prompt"
            echo "purple   - Purple prompt"
            ;;
        set)
            case "$2" in
                default) PROMPT_COLOR="\e[32m" ;;
                blue) PROMPT_COLOR="\e[34m" ;;
                red) PROMPT_COLOR="\e[31m" ;;
                yellow) PROMPT_COLOR="\e[33m" ;;
                cyan) PROMPT_COLOR="\e[36m" ;;
                purple) PROMPT_COLOR="\e[35m" ;;
                *) echo "Invalid theme. Use: oalie-theme list"; return 1 ;;
            esac
            # Save to config
            sed -i "s/PROMPT_COLOR=.*/PROMPT_COLOR=\"$PROMPT_COLOR\"/" "$CONF_FILE"
            sed -i "s/THEME=.*/THEME=\"$2\"/" "$CONF_FILE"
            echo "✅ Theme set to: $2"
            ;;
        current)
            echo "Current theme: $(grep THEME "$CONF_FILE" | cut -d= -f2 | tr -d '"')"
            ;;
        *)
            echo "Usage: oalie-theme [list|set <theme>|current]"
            echo "Example: oalie-theme set blue"
            ;;
    esac
}

# ====== Backup System ======
oalie-backup() {
    local backup_dir="$OALIE_HOME/backups"
    local backup_name="oalie-backup-$(date +%Y%m%d-%H%M%S).tar.gz"
    
    mkdir -p "$backup_dir"
    
    echo "📦 Creating backup..."
    tar -czf "$backup_dir/$backup_name" -C "$OALIE_HOME" bin etc 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "✅ Backup created: $backup_name"
        echo "📍 Location: $backup_dir/"
    else
        echo "❌ Backup failed"
    fi
}

oalie-restore() {
    local backup_dir="$OALIE_HOME/backups"
    
    if [ ! -d "$backup_dir" ] || [ -z "$(ls -A "$backup_dir")" ]; then
        echo "❌ No backups found"
        return 1
    fi
    
    echo "=== Available Backups ==="
    ls -1 "$backup_dir" | cat -n
    
    echo ""
    read -p "Enter backup number to restore: " backup_num
    
    local backup_file=$(ls -1 "$backup_dir" | sed -n "${backup_num}p")
    
    if [ -z "$backup_file" ]; then
        echo "❌ Invalid selection"
        return 1
    fi
    
    read -p "Restore from $backup_file? (y/N): " confirm
    if [[ $confirm =~ ^[Yy]$ ]]; then
        echo "🔄 Restoring..."
        tar -xzf "$backup_dir/$backup_file" -C "$OALIE_HOME"
        echo "✅ Restore completed"
    else
        echo "Restore cancelled"
    fi
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
        # Show current directory relative to Oalie home
        current_dir=$(pwd)
        if [[ "$current_dir" == "$OALIE_HOME_DIR"* ]]; then
            display_dir="~${current_dir#$OALIE_HOME_DIR}"
        else
            display_dir="$current_dir"
        fi
        
        echo -ne "${PROMPT_COLOR}[oalie@${USERNAME} ${display_dir}]$ \e[0m"
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
        
        # Handle enhanced cd command
        if [[ "$CMD" == cd* ]]; then
            oalie-cd ${CMD#cd }
            continue
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
    echo "✨ New in v$VERSION:"
    echo "   🏠 Oalie Home Directory"
    echo "   🔄 Update Checker"
    echo "   🎨 Theme System"
    echo "   💾 Backup/Restore"
    echo "   📁 Enhanced Navigation"
    echo ""
    echo "📖 GitHub: $GITHUB_REPO"
    echo ""
}

# ====== Main Execution ======
show_banner
show_welcome

# Check for updates on startup
check_update
echo ""

# Create example command jika folder kosong
if [ ! -d "$CUSTOM_CMD_DIR" ] || [ -z "$(ls -A "$CUSTOM_CMD_DIR")" ]; then
    echo "📝 Creating example command..."
    oalie-cmd create example >/dev/null 2>&1
    oalie-cmd create welcome >/dev/null 2>&1
fi

echo "Type 'oalie-help' to see available commands"
echo "Type 'exit' to leave Oalie CLI"
echo ""

# Start the prompt
oalie-prompt
