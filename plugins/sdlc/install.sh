#!/usr/bin/env bash
# Antigravity SDLC Marketplace Installer & Manager
set -euo pipefail

REPO_URL="https://github.com/AratKruglik/antigravity-sdlc.git"

# Ensure python3 is installed
if ! command -v python3 >/dev/null 2>&1; then
    echo "Error: Python 3 is required to run this script."
    exit 1
fi

# Ensure agy is installed
if ! command -v agy >/dev/null 2>&1; then
    echo "Error: Google Antigravity CLI ('agy') is not installed or not in PATH."
    exit 1
fi

# If interactive mode (no arguments) and stdin is piped (e.g. curl | bash), reconnect stdin to tty
if [ $# -eq 0 ]; then
    if [ ! -t 0 ] && [ -e /dev/tty ]; then
        exec < /dev/tty
    fi
fi

python3 - "$@" << 'EOF'
import sys
import os
import json
import tempfile
import subprocess
import re

REPO_URL = "https://github.com/AratKruglik/antigravity-sdlc.git"

ALL_PLUGINS = [
    ("sdlc", "Core Orchestrator & default base agents"),
    ("js-foundation", "Shared JS/TS conventions & npm tooling"),
    ("php-foundation", "Shared PHP standards & testing"),
    ("csharp-foundation", "Shared C# conventions & NuGet tooling"),
    ("java-foundation", "Shared Java standards & Maven/Gradle"),
    ("python-foundation", "Shared Python standards & pytest"),
    ("nodejs-plugin", "Express, Fastify & Koa backend stack"),
    ("nestjs-plugin", "NestJS REST, GraphQL & Microservices"),
    ("nextjs-plugin", "Next.js App Router full-stack"),
    ("react-plugin", "React SPA layout & RTL testing"),
    ("vue-plugin", "Vue 3 Composition API & Pinia state"),
    ("angular-plugin", "Angular signals & NgRx state stack"),
    ("react-native-plugin", "Expo & bare React Native mobile stack"),
    ("laravel-plugin", "Laravel framework & Artisan database migrations"),
    ("symfony-plugin", "Symfony framework & Doctrine database migrations"),
    ("inertia-vue-plugin", "Inertia Vue 3 adapter for Laravel SPA"),
    ("inertia-react-plugin", "Inertia React adapter for Laravel SPA"),
    ("aspnet-core-plugin", "ASP.NET Core Minimal APIs & EF Core"),
    ("java-plugin", "Plain Java libraries & microservices"),
    ("spring-boot-plugin", "Spring Boot REST, Spring Data & JPA"),
    ("python-plugin", "Plain Python libraries & console scripts"),
    ("django-plugin", "Django & DRF APIs & migrations"),
    ("fastapi-plugin", "FastAPI endpoints & Alembic migrations"),
    ("flask-plugin", "Flask app factory & Flask-Migrate database")
]

plugin_names = [p[0] for p in ALL_PLUGINS]
plugin_desc = {p[0]: p[1] for p in ALL_PLUGINS}

def get_installed_plugins():
    try:
        output = subprocess.check_output(["agy", "plugin", "list"], stderr=subprocess.DEVNULL).decode("utf-8")
        data = json.loads(output)
        return {item["name"] for item in data.get("imports", [])}
    except Exception:
        return set()

def resolve_dependencies(temp_dir, requested_plugins):
    installed = set()
    to_install = []
    
    def resolve(plugin):
        if plugin in installed:
            return
        p_json = os.path.join(temp_dir, "plugins", plugin, "plugin.json")
        if os.path.exists(p_json):
            try:
                with open(p_json, "r") as f:
                    data = json.load(f)
                    deps = data.get("dependencies", [])
                    if isinstance(deps, list):
                        for dep in deps:
                            dep_path = os.path.join(temp_dir, "plugins", dep)
                            if os.path.exists(dep_path):
                                resolve(dep)
            except Exception:
                pass
        if plugin not in installed:
            installed.add(plugin)
            to_install.append(plugin)

    for p in requested_plugins:
        if p in plugin_names:
            resolve(p)
        else:
            to_install.append(p)
    return to_install

def clone_repo():
    print("▶ Fetching repository metadata from GitHub...")
    temp_dir = tempfile.mkdtemp()
    subprocess.check_call(
        ["git", "clone", "--depth", "1", REPO_URL, temp_dir],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL
    )
    return temp_dir

def install_plugins(plugins_to_install):
    if not plugins_to_install:
        print("⚠️ No plugins selected for installation.")
        return
    
    temp_dir = clone_repo()
    try:
        ordered = resolve_dependencies(temp_dir, plugins_to_install)
        print(f"🎯 Resolved installation plan: {' -> '.join(ordered)}")
        
        for plugin in ordered:
            plugin_path = os.path.join(temp_dir, "plugins", plugin)
            if os.path.exists(plugin_path):
                print(f"▶ Installing '{plugin}'...")
                subprocess.check_call(["agy", "plugin", "install", plugin_path])
            else:
                print(f"⚠️ Warning: Plugin '{plugin}' not found in monorepo. Skipping.")
        print("✅ Batch installation completed successfully!")
    finally:
        subprocess.call(["rm", "-rf", temp_dir])

def uninstall_plugins(plugins_to_uninstall):
    if not plugins_to_uninstall:
        print("⚠️ No plugins selected for uninstallation.")
        return
        
    print(f"🎯 Resolved uninstallation plan: {', '.join(plugins_to_uninstall)}")
    for plugin in plugins_to_uninstall:
        print(f"▶ Uninstalling '{plugin}'...")
        try:
            subprocess.check_call(["agy", "plugin", "uninstall", plugin])
        except Exception as e:
            print(f"❌ Failed to uninstall '{plugin}': {e}")
    print("✅ Batch uninstallation completed!")

def interactive_menu():
    selected = set()
    
    while True:
        installed = get_installed_plugins()
        os.system("clear" if os.name == "posix" else "cls")
        
        print("=====================================================================")
        print("             Antigravity SDLC Marketplace Manager                    ")
        print("=====================================================================")
        print("Select plugins to install/uninstall (toggle using numbers):")
        print("-" * 69)
        
        for idx, name in enumerate(plugin_names, 1):
            status_str = "\033[92m[Installed]\033[0m" if name in installed else "[Not Installed]"
            sel_str = "[x]" if name in selected else "[ ]"
            print(f"{idx:2d}) {sel_str} {status_str:<25} {name:<22} - {plugin_desc[name]}")
            
        print("-" * 69)
        print("Commands:")
        print("  <numbers> - Toggle selection (e.g., '1', '1,3', '1-5')")
        print("  i         - Run Batch Install on selected plugins")
        print("  u         - Run Batch Uninstall on selected plugins")
        print("  all       - Select all plugins")
        print("  none      - Deselect all plugins")
        print("  q         - Quit")
        print("-" * 69)
        
        sys.stdout.write("Choose an option: ")
        sys.stdout.flush()
        choice = sys.stdin.readline().strip().lower()
        
        if choice == 'q':
            print("Exiting. Goodbye!")
            break
        elif choice == 'all':
            selected = set(plugin_names)
        elif choice == 'none':
            selected = set()
        elif choice == 'i':
            if not selected:
                print("No plugins selected. Press Enter...")
                sys.stdin.readline()
                continue
            install_plugins(list(selected))
            selected = set()
            print("\nPress Enter to continue...")
            sys.stdin.readline()
        elif choice == 'u':
            if not selected:
                print("No plugins selected. Press Enter...")
                sys.stdin.readline()
                continue
            confirm = input(f"Are you sure you want to uninstall {len(selected)} plugins? [y/N]: ").strip().lower()
            if confirm == 'y':
                uninstall_plugins(list(selected))
            selected = set()
            print("\nPress Enter to continue...")
            sys.stdin.readline()
        else:
            parts = choice.replace(" ", "").split(",")
            for part in parts:
                if "-" in part:
                    match = re.match(r"^(\d+)-(\d+)$", part)
                    if match:
                        start, end = int(match.group(1)), int(match.group(2))
                        if 1 <= start <= len(plugin_names) and 1 <= end <= len(plugin_names):
                            for i in range(start, end + 1):
                                name = plugin_names[i - 1]
                                if name in selected:
                                    selected.remove(name)
                                else:
                                    selected.add(name)
                elif part.isdigit():
                    val = int(part)
                    if 1 <= val <= len(plugin_names):
                        name = plugin_names[val - 1]
                        if name in selected:
                            selected.remove(name)
                        else:
                            selected.add(name)

def main():
    if len(sys.argv) > 1:
        args = sys.argv[1:]
        plugins_arg = ""
        uninstall_mode = False
        
        for arg in args:
            if arg.startswith("--plugins="):
                plugins_arg = arg.split("=", 1)[1]
            elif arg == "--uninstall":
                uninstall_mode = True
            elif not arg.startswith("-"):
                plugins_arg = arg
                
        if plugins_arg:
            target_plugins = [p.strip() for p in plugins_arg.split(",") if p.strip()]
            if uninstall_mode:
                uninstall_plugins(target_plugins)
            else:
                install_plugins(target_plugins)
        else:
            print("Error: No plugins specified.")
            sys.exit(1)
    else:
        interactive_menu()

if __name__ == "__main__":
    main()
EOF
