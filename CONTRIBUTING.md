# Contributing a Stack Plugin

The `antigravity-sdlc` marketplace is designed to be extended with stack plugins — language/framework-specific adapters that plug into the core orchestration. This guide walks through adding one.

## What "stack plugin" means

A stack plugin is a Google Antigravity plugin that lives under `plugins/<stack>/` and declares:

- At least a framework architect agent (e.g. `laravel-architect.md`).
- A `stack.md` profile at the root of the plugin directory that the core orchestrator uses to discover and route to these agents.
- Optional auto-detection rules (which project files indicate this stack).
- Custom convention skills.

The orchestrator in the `sdlc` core plugin reads all installed `stack.md` profiles at session start and maps generic roles ("developer", "database") to your stack-specific agents.

## Directory layout

```
plugins/<stack>/
├── plugin.json              # { "name": "sdlc-<stack>", "version": "0.1.0" }
├── stack.md                 # Contract with core — validates against schema
├── agents/
│   ├── <stack>-architect.md # Replaces developer/framework architect
│   └── ...                  # Any custom roles (e.g. specialist agents)
├── skills/
│   └── <framework-skill>/SKILL.md
└── README.md
```

## `stack.md` contract

Validate against [`schemas/stack.schema.json`](./schemas/stack.schema.json). Minimum required fields in frontmatter:

```yaml
---
stack: django
priority: 150
aspects: [backend, database]
detect:
  any:
    - file_exists: manage.py
    - file_contains:
        path: pyproject.toml
        pattern: "[Dd]jango"
---
# Django Stack Profile
```

Recommended additions:

- `priority` — priority weight for aspect resolution.
- `aspects` — aspects this stack plugin handles (e.g., `backend`, `frontend`, `database`).
- `detect` — files/content patterns for auto-detection.

## Local development

With Google Antigravity, you can load local plugins by staging them in the global configuration directory or workspace directory:

- Workspace level: place in `<workspace>/.agents/plugins/<your-stack>/`
- Global level: place in `~/.gemini/config/plugins/<your-stack>/`

Then inside Google Antigravity:

```
/sdlc:start "Add user profile endpoint"
```

The orchestrator will detect your stack via `stack.md` and route the development phase to your agents.

## Schema validation

To validate your `plugin.json` and `stack.md` frontmatter:

```bash
# Validate plugin.json
npx check-jsonschema --schemafile schemas/plugin.schema.json plugin.json

# Validate stack.md frontmatter
npx check-jsonschema --schemafile schemas/stack.schema.json <(yq '.frontmatter' stack.md)
```

## Pull request checklist

- [ ] `plugin.json` is located at the root of the plugin directory.
- [ ] `stack.md` validates against the schema.
- [ ] Your architect agents exist and have `tools:` frontmatter (least privilege).
- [ ] `README.md` in your package documents the stack version, prerequisites, and any MCP dependencies.
- [ ] You tested locally against the core `sdlc` plugin.

## Role naming convention

Google Antigravity's `Agent` tool accepts only **bare agent names** — there is no `plugin:agent` namespacing. To keep core and stack plugins coexisting cleanly:

- **Core plugin (`sdlc`) reserves:** `business-analyst`, `developer`, `qa-engineer`, `security-analyst`, `document-writer`. Stack plugins MUST NOT ship agents with these names.
- **Stack plugins reserve generic role names:** `<stack>-architect`, `<specialist>-specialist`. Use distinctive names to avoid collisions.
