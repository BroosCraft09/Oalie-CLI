# Oalie CLI v1.4 

# 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/BroosCraft09/Oalie-CLI.git
cd Oalie-CLI

# Run Oalie CLI
./start-oalie.sh
```

# 📁 Project Structure

```
Oalie-CLI/
├── start-oalie.sh     # Main launcher script
├── README.md          # This file
├── bin/               # Custom commands directory
├── etc/               # Configuration files
├── home/              # Oalie workspace environment
├── log/               # System logs
├── usr/               # User programs
├── var/               # Variable data
├── tmp/               # Temporary files
├── lib/               # Libraries
├── coreutils-9.5/     # Core utilities source
├── musl-1.2.5/        # Musl libc source
└── git/               # Git-related files
```

# ✨ Features

# 🏠 Isolated Environment

· Dedicated Home Directory - Starts in home/ folder
· Self-Contained - All files within Oalie-CLI directory
· Portable - Easy to move or backup entire project

# 🔧 Core Functionality

· Custom Command System - Create your own commands in bin/
· Theme Support - Multiple color themes
· Update Checking - Automatic version checks
· Backup/Restore - Protect your custom commands

# 📦 Built-in Tools

· Core Utilities - Complete GNU coreutils suite
· Musl Libc - Lightweight standard library
· Git Integration - Version control ready

# 🎯 Basic Usage

```bash
# Start Oalie CLI
./start-oalie.sh

# Inside Oalie environment:
oalie-help          # View all commands
oalie-cmd create hi # Create custom command
cd                  # Return to Oalie home
ls                  # List files in current directory
```

# 🔧 Command Reference

```bash
Navigation Commands

· cd - Return to Oalie home (home/)
· cd bin - Go to commands directory
· cd etc - Go to configuration directory
· cd log - View log files
· cd usr - Access user programs

System Commands

· oalie-ver - Show version information
· oalie-help - Display help menu
· oalie-update - Check for updates
· oalie-sys - System information
· oalie-theme - Change interface theme

Custom Commands

· oalie-cmd create <name> - Create new command
· oalie-cmd list - List available commands
· oalie-cmd edit <name> - Edit command
· oalie-cmd delete <name> - Remove command
```

## 🛠️ Development

Adding Custom Commands

```bash
# Create a new command
oalie-cmd create mycommand

# Edit the command (opens in nano/vim)
oalie-cmd edit mycommand

# Command files are stored in bin/
ls bin/
```

Project Structure Details

```bash
· bin/ - Your custom commands live here
· etc/ - Configuration files for Oalie environment
· home/ - Your workspace, starts here automatically
· log/ - System logs and command history
· usr/ - Additional utilities and programs
```

# 🌈 Themes

Change the interface appearance:

```bash
oalie-theme list     # Available themes
oalie-theme set blue # Change to blue theme
oalie-theme set red  # Change to red theme
```

# 🔄 Maintenance

Backup Your Commands

```bash
oalie-backup    # Backup custom commands to backups/
oalie-restore   # Restore from backup
```

Update Checking

Oalie automatically checks for updates on startup. Manual check:

```bash
oalie-update
```

# 📦 Dependencies

Included in this repository:

· Core Utilities 9.5
· Musl Libc 1.2.5
· Git integration

No external dependencies required! Everything is self-contained.

# 🚀 Advanced Features

Building from Source

The repository includes source code for:

· coreutils-9.5/ - GNU core utilities
· musl-1.2.5/ - Musl C library

Custom Development

· Extend Oalie by adding scripts to bin/
· Modify configuration in etc/
· Add libraries to lib/

# ❓ Troubleshooting

If Oalie won't start:

```bash
# Make sure the script is executable
chmod +x start-oalie.sh

# Check file permissions
ls -la start-oalie.sh
```

Reset to defaults:

```bash
# Delete configuration
rm -rf etc/oalie.conf

# Restart Oalie
./start-oalie.sh
```

# 📞 Support

· GitHub: https://github.com/BroosCraft09/Oalie-CLI
· Issues: Use GitHub Issues for bug reports
· Features: Pull requests welcome!

---

Oalie CLI v1.4 - Your complete, self-contained shell environment! 🐚

Start exploring with ./start-oalie.sh