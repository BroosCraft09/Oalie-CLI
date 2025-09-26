Oalie CLI 

Lightweight custom shell dengan kemampuan membuat command sendiri.

🚀 Fitur Utama

· Custom Command Creator - Buat command sendiri
· Command Management - Create, list, edit, delete commands
· Built-in Utilities - System info, package manager, dll
· Termux Compatible - Work di Android dan Linux

📦 Instalasi Cepat

```bash
cd ~
git clone https://github.com/BroosCraft09/Oalie-CLI
CD Oalie-CLI
./start-oalie.sh
```

🎯 Basic Usage

```bash
# Lihat semua command
oalie-help

# Buat command custom
oalie-cmd create namacommand

# Edit command
oalie-cmd edit namacommand

# Jalankan command custom
namacommand
```

✨ Command List

· oalie-ver - Versi Oalie
· oalie-sys - Info sistem
· oalie-cmd create <name> - Buat command baru
· oalie-cmd list - Lihat custom commands
· oalie-cmd edit <name> - Edit command
· exit - Keluar dari Oalie

💡 Contoh Custom Command

```bash
oalie-cmd create hello
oalie-cmd edit hello
# Edit isi command sesuai kebutuhan
```

Oalie CLI - Your lightweight shell with custom commands! 🐚