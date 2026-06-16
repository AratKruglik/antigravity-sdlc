---
description: Install stack plugins from the remote SDLC Marketplace.
argument-hint: "<plugin-name>[,<plugin-name-2>,...]"
---

# /sdlc:install

Install or update framework/foundation plugins from the remote marketplace repository.

## Execution Protocol

You MUST follow these steps in order to install the requested plugins:

### Step 1 — Validate input

If `$ARGUMENTS` is empty:
- Print: `Error: Please specify one or more plugins to install (e.g., /sdlc:install laravel-plugin).`
- Stop. Do not proceed.

### Step 2 — Run the installer script

Run the installer script directly via the terminal tool using this exact command:
```bash
bash "${ANTIGRAVITY_PLUGIN_ROOT:-${AGY_PLUGIN_ROOT:-${CLAUDE_PLUGIN_ROOT}}}/install.sh" "$ARGUMENTS"
```

### Step 3 — Post-install verification

After the installation completes:
- Print: `▶ Verifying installed plugins...`
- Run the verify command:
  ```bash
  agy plugin list
  ```
- Confirm that the requested plugins are listed as active.
