# ANON-IRAN OS v7.0 — Red Team Security Platform

```
 █████╗ ███╗   ██╗ ██████╗ ███╗   ██╗     ██╗ ██████╗ ███████╗
██╔══██╗████╗  ██║██╔═══██╗████╗  ██║    ██╔╝██╔═══██╗██╔════╝
███████║██╔██╗ ██║██║   ██║██╔██╗ ██║   ██╔╝ ██║   ██║███████╗
██╔══██║██║╚██╗██║██║   ██║██║╚██╗██║  ██╔╝  ██║   ██║╚════██║
██║  ██║██║ ╚████║╚██████╔╝██║ ╚████║ ██╔╝   ╚██████╔╝███████║
╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═════╝ ╚══════╝
```

## Overview
- **Base OS:** Debian 12 Bookworm + Kali + Parrot + BlackArch repos
- **Tools:** 1474+ security tools (all categories)
- **AI Tools:** 200+ AI/ML security tools with auto-upgrade daemon
- **Languages:** Python3, Java, C/C++, Go, Rust, Ruby, Perl, PHP, C#, Lua, R, NodeJS, Kotlin, Scala, Shell
- **Desktop:** XFCE4 with dark red theme, red folder/app icons
- **Anonymity:** TOR, AnonSurf, ProxyChains, Nipe — auto-start
- **Login:** LightDM with login screen (shows error on wrong credentials)
- **Root:** DISABLED — user `anoniran` has passwordless sudo

## Credentials
| Field | Value |
|-------|-------|
| Username | `anoniran` |
| Password | `ua6248634@` |
| Root | LOCKED (no root login) |

## Build Requirements
- Debian 12 or Ubuntu 22.04+ (64-bit)
- 20+ GB free disk space
- 8+ GB RAM recommended
- Fast internet (downloads ~10GB)
- Run as root

## How to Build

```bash
# 1. Clone or extract this directory
cd ANON-IRAN-ISO

# 2. Build the ISO (takes 2-4 hours)
sudo ./BUILD.sh

# 3. Write to USB
sudo ./WRITE-USB.sh

# OR write manually:
sudo dd if=ANON-IRAN-OS-v7.0-amd64.hybrid.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

## Boot Options
- **BIOS/MBR:** Fully supported (hybrid ISO)
- **UEFI/GPT:** Fully supported (grub-efi)
- **RAM mode:** Add `toram` to boot cmdline to load entirely into RAM
- **Persistent:** Add `persistence` to save changes across boots

## Tool Categories
| Category | Count |
|----------|-------|
| Kali Linux tools | 330+ |
| Parrot OS tools | 210+ |
| BlackArch tools | 75+ |
| Swiss Army (general) | 112+ |
| AI Security | 200+ |
| Red Team Arsenal | 168+ |
| Social Engineering | 48+ |
| Mass Mail | custom |
| OSINT | 65+ |
| Wireless | 25+ |
| Forensics | 30+ |
| C2 Frameworks | 15+ |

## Auto-Services (start on boot)
1. TOR + AnonSurf (anonymous routing)
2. PostgreSQL (Metasploit DB)
3. Redis
4. Apache2 / Nginx
5. BeEF XSS Framework (port 3000)
6. Metasploit RPC daemon (port 55553)
7. GoPhish (phishing framework)
8. SSH Server
9. Docker
10. Neo4j (BloodHound)
11. Ollama (local AI LLMs)
12. AI Auto-Upgrade Daemon
13. AI Security Monitor

## AI Auto-Upgrade
The AI daemon (`anon-iran-ai-upgrade` service) runs every hour and:
- Updates all git repos in `/opt/tools/`
- Updates pip packages
- Fetches latest CVE feed
- Auto-discovers and installs new security tools from GitHub
- Pulls latest LLM models via Ollama

## Key Commands
```bash
# Launch any tool
anon-iran <tool>          # e.g: anon-iran msf, anon-iran beef, anon-iran set

# Anonymity
sudo anonsurf start       # Route all traffic through TOR
sudo anonsurf stop        # Restore normal routing
sudo nmap -sV target      # Scan through proxychains

# Services
anon-iran start-all       # Start all services
anon-iran services        # List running services
anon-iran ai-upgrade      # Run AI upgrade manually

# Tools
ls /opt/tools             # See all 200+ cloned tools
ls /usr/share/wordlists   # See wordlists
ls /usr/share/seclists    # SecLists
```

## Directory Structure
```
/opt/tools/           — 200+ git-cloned security tools
/usr/share/wordlists/ — Password wordlists (rockyou, etc.)
/usr/share/seclists/  — SecLists collection
/usr/share/payloads/  — PayloadsAllTheThings
/usr/local/lib/anon-iran/ai/  — AI daemons
/var/log/anon-iran/   — Service logs
/home/anoniran/.config/anon-iran/api-keys.conf — API keys
```

## API Keys Configuration
Edit `/home/anoniran/.config/anon-iran/api-keys.conf` to add:
- Shodan API key
- VirusTotal API key
- OpenAI / Anthropic API keys
- Censys, SecurityTrails, HaveIBeenPwned, etc.

## License
For educational and authorized penetration testing only.
Always obtain written permission before testing any system.
