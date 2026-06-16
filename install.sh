#!/usr/bin/env bash
# Antigravity SDLC Marketplace Installer
set -euo pipefail

REPO_URL="https://github.com/AratKruglik/antigravity-sdlc.git"

# Ensure agy is installed
if ! command -v agy >/dev/null 2>&1; then
    echo "Error: Google Antigravity CLI ('agy') is not installed or not in PATH."
    echo "Please install it first and try again."
    exit 1
fi

PLUGINS_ARG=""
# Parse arguments
for arg in "$@"; do
    case $arg in
        --plugins=*)
            PLUGINS_ARG="${arg#*=}"
            shift
            ;;
        *)
            if [ -z "$PLUGINS_ARG" ]; then
                PLUGINS_ARG="$arg"
            fi
            ;;
    esac
done

if [ -z "$PLUGINS_ARG" ]; then
    echo "No plugins specified. Defaulting to 'sdlc' (core orchestrator)."
    PLUGINS_ARG="sdlc"
fi

# Create temp directory for cloning
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

echo "▶ Fetching repository metadata from GitHub..."
git clone --depth 1 "$REPO_URL" "$TEMP_DIR" >/dev/null 2>&1

# Use Python to resolve dependencies topologically
RESOLVED_PLUGINS=$(python3 -c '
import json, os, sys
temp_dir = sys.argv[1]
requested = sys.argv[2].replace(" ", "").split(",")
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
        except Exception as e:
            pass
    if plugin not in installed:
        installed.add(plugin)
        to_install.append(plugin)

for p in requested:
    resolve(p)
print(",".join(to_install))
' "$TEMP_DIR" "$PLUGINS_ARG")

if [ -z "$RESOLVED_PLUGINS" ]; then
    echo "Error: Could not resolve any valid plugins to install."
    exit 1
fi

IFS=',' read -ra PLUGINS_LIST <<< "$RESOLVED_PLUGINS"

echo "🎯 Resolved installation order: ${PLUGINS_LIST[*]}"

for plugin in "${PLUGINS_LIST[@]}"; do
    PLUGIN_PATH="$TEMP_DIR/plugins/$plugin"
    if [ ! -d "$PLUGIN_PATH" ]; then
        echo "⚠️ Warning: Plugin '$plugin' not found in repository. Skipping."
        continue
    fi
    
    echo "▶ Installing '$plugin'..."
    agy plugin install "$PLUGIN_PATH"
done

echo "✅ All requested plugins installed successfully!"
