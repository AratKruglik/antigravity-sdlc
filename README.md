# SDLC Marketplace for Google Antigravity

Multi-stack AI-assisted SDLC pipelines built on the **Stack Provider Pattern**: a single core orchestrator runs the pipeline, framework plugins register themselves via declarative `stack.md` profiles. No core overrides, no slot registries, no copy-paste between stacks.

A monorepo containing the core SDLC pipeline orchestrator along with 23 shared foundation and stack provider plugins. Cost-optimized: model tiering + custom agent parameters (temperature, max output tokens). Dynamic workflow recipes + guaranteed per-agent model enforcement.

---

## Installation

We provide a streamlined installation script that automatically resolves plugin dependencies (e.g., automatically installing `php-foundation` when you install `laravel-plugin`).

### Option A: One-Liner Installation (from GitHub)

You don't need to clone the repository manually. You can install the core orchestrator directly:

```bash
curl -fsSL https://raw.githubusercontent.com/AratKruglik/antigravity-sdlc/main/install.sh | bash -s -- sdlc
```

To install the orchestrator along with specific stack plugins in one command:

```bash
curl -fsSL https://raw.githubusercontent.com/AratKruglik/antigravity-sdlc/main/install.sh | bash -s -- sdlc,laravel-plugin,nextjs-plugin
```

### Option B: Local Clone Installation

If you prefer to clone the repository first:

1. **Clone this repository:**
   ```bash
   git clone https://github.com/AratKruglik/antigravity-sdlc.git
   cd antigravity-sdlc
   ```

2. **Run the local installer:**
   ```bash
   # Installs the core orchestrator:
   ./install.sh sdlc
   
   # Or install with specific stack plugins:
   ./install.sh sdlc,laravel-plugin
   ```

### Option C: Local Development (via Symlinks)

If you are developing custom stack plugins or want to edit and test changes without running the installer every time:

```bash
# Symlink plugins directly into your global Antigravity config directory:
mkdir -p ~/.gemini/config/plugins

# Link the core orchestrator:
ln -s ~/Projects/antigravity-sdlc/plugins/sdlc ~/.gemini/config/plugins/sdlc

# Link any stack providers you want to test (e.g., nodejs-plugin and its foundation js-foundation):
ln -s ~/Projects/antigravity-sdlc/plugins/js-foundation ~/.gemini/config/plugins/js-foundation
ln -s ~/Projects/antigravity-sdlc/plugins/nodejs-plugin ~/.gemini/config/plugins/nodejs-plugin
```

Alternatively, for workspace-isolated testing, symlink them to your target project's `.agents/plugins/` folder.

---

## Installing Additional Plugins Later

Once the core `sdlc` plugin is installed, you can easily add more stack plugins directly from your active Antigravity session using the `/sdlc:install` slash command.

```
/sdlc:install nextjs-plugin
/sdlc:install django-plugin,python-plugin
```

This command automatically downloads the selected plugins, resolves their dependencies, and runs `agy plugin install` under the hood.

---

## Verifying the Setup

Verify that all plugins were correctly loaded:

```
/sdlc:doctor
/sdlc:list-stacks
```

Once verified, you can run the pipeline on any project:

```
/sdlc:start "Add subscription billing with Stripe"
```

---

## Available Plugins & Installation Reference

The following table lists all 24 plugins available in the marketplace. You can install any plugin:
1. **Via one-liner:** `curl -fsSL https://raw.githubusercontent.com/AratKruglik/antigravity-sdlc/main/install.sh | bash -s -- <plugin-name>`
2. **Via active session command:** `/sdlc:install <plugin-name>`

*Note: Dependencies (such as foundation libraries) are resolved and installed automatically.*

| Plugin Name | Category | Description | One-Liner Installer Argument | Slash Command |
|---|---|---|---|---|
| **`sdlc`** | Core Orchestrator | Core SDLC pipeline orchestrator and 5 cost-tiered base agents. | `sdlc` | `/sdlc:install sdlc` |
| **`js-foundation`** | Shared Foundation | Shared JavaScript/TypeScript standards and npm package tooling. | `js-foundation` | `/sdlc:install js-foundation` |
| **`php-foundation`** | Shared Foundation | Shared PHP PSR standards, Composer tooling, and PHPUnit/Pest testing. | `php-foundation` | `/sdlc:install php-foundation` |
| **`csharp-foundation`**| Shared Foundation | Shared C# conventions, dotnet CLI tooling, NuGet, and testing. | `csharp-foundation` | `/sdlc:install csharp-foundation`|
| **`java-foundation`** | Shared Foundation | Shared Java standards, Maven/Gradle wrappers, and JUnit/Mockito. | `java-foundation` | `/sdlc:install java-foundation` |
| **`python-foundation`**| Shared Foundation | Shared Python PEP 8 standards, dependency management, and pytest. | `python-foundation` | `/sdlc:install python-foundation`|
| **`nodejs-plugin`** | Backend Stack | Express, Fastify, and Koa backend stack. | `nodejs-plugin` | `/sdlc:install nodejs-plugin` |
| **`nestjs-plugin`** | Backend Stack | Opinionated NestJS REST, ORM, GraphQL, and Microservices. | `nestjs-plugin` | `/sdlc:install nestjs-plugin` |
| **`nextjs-plugin`** | Full-Stack | Next.js App Router, Server Actions, and React components. | `nextjs-plugin` | `/sdlc:install nextjs-plugin` |
| **`react-plugin`** | Frontend Stack | React SPA layouts, routing, custom hooks, and RTL testing. | `react-plugin` | `/sdlc:install react-plugin` |
| **`vue-plugin`** | Frontend Stack | Vue 3 Composition API, Pinia state management, and Vitest. | `vue-plugin` | `/sdlc:install vue-plugin` |
| **`angular-plugin`** | Frontend Stack | Angular signals, standalones, NgRx state, and router. | `angular-plugin` | `/sdlc:install angular-plugin` |
| **`react-native-plugin`**| Mobile Stack | Expo and bare React Native mobile layouts, router, and navigation. | `react-native-plugin` | `/sdlc:install react-native-plugin`|
| **`laravel-plugin`** | Backend + DB | Laravel framework, Artisan migrations, and Eloquent models. | `laravel-plugin` | `/sdlc:install laravel-plugin` |
| **`symfony-plugin`** | Backend + DB | Symfony framework, Doctrine ORM mappings, and migrations. | `symfony-plugin` | `/sdlc:install symfony-plugin` |
| **`inertia-vue-plugin`**| Frontend Aspect | Inertia.js Vue 3 adapter for server-driven Laravel frontends. | `inertia-vue-plugin` | `/sdlc:install inertia-vue-plugin`|
| **`inertia-react-plugin`**| Frontend Aspect | Inertia.js React adapter for server-driven Laravel frontends. | `inertia-react-plugin` | `/sdlc:install inertia-react-plugin`|
| **`aspnet-core-plugin`**| Backend + DB | ASP.NET Core Minimal APIs and Entity Framework Core migrations. | `aspnet-core-plugin` | `/sdlc:install aspnet-core-plugin`|
| **`java-plugin`** | Backend Stack | Plain Java libraries, CLI tools, and non-framework services. | `java-plugin` | `/sdlc:install java-plugin` |
| **`spring-boot-plugin`**| Backend + DB | Spring Boot REST services, Spring Data JPA, and Flyway/Liquibase. | `spring-boot-plugin` | `/sdlc:install spring-boot-plugin`|
| **`python-plugin`** | Backend Stack | Plain Python libraries, console scripts, and data pipelines. | `python-plugin` | `/sdlc:install python-plugin` |
| **`django-plugin`** | Backend + DB | Django framework, Django REST Framework APIs, and migrations. | `django-plugin` | `/sdlc:install django-plugin` |
| **`fastapi-plugin`** | Backend + DB | FastAPI async API endpoints and Alembic migrations. | `fastapi-plugin` | `/sdlc:install fastapi-plugin` |
| **`flask-plugin`** | Backend + DB | Flask app blueprints, SQLAlchemy, and Flask-Migrate database. | `flask-plugin` | `/sdlc:install flask-plugin` |

---


## How It Works: Stack Provider Pattern

```
┌─────────────────────────────────────────────────────────────┐
│                    sdlc (core)                               │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  pipeline-orchestrator (skill) — NEVER CHANGES        │  │
│  │                                                       │  │
│  │  Phase 1: BA          → core's business-analyst       │  │
│  │  Phase 2: Dev         → ⚡ DISPATCH to stack provider │  │
│  │  Phase X: extra       → ⚡ stack-specific phases      │  │
│  │  Phase N-2: QA        → core's qa-engineer            │  │
│  │  Phase N-1: Security  → core's security-analyst       │  │
│  │  Phase N: Docs/PR     → core's document-writer        │  │
│  └──────────────────────────────────────────────────────┘  │
│                            ▲                                │
│                            │ reads stack.md profiles        │
└────────────────────────────┼────────────────────────────────┘
                             │
    ┌────────────────────────┼───────────────────────────┐
    │            │           │             │             │
┌───▼───┐  ┌────▼────┐ ┌────▼────┐  ┌────▼────┐  ┌────▼────┐
│laravel│  │ nodejs  │ │  nestjs │  │ nextjs  │  │  react  │
│plugin │  │ plugin  │ │  plugin │  │ plugin  │  │  plugin │
│stack.md│ │ stack.md│ │stack.md │  │stack.md │  │stack.md │
└───────┘  └─────────┘ └─────────┘  └─────────┘  └─────────┘
```

**Key principles:**

1. **Core never changes.** Pipeline logic lives exclusively in `pipeline-orchestrator/SKILL.md`.
2. **Plugins register themselves** via `stack.md` frontmatter — they declare auto-detection rules, priority, agents per phase, and convention skills.
3. **Per-aspect dispatch.** A project can have multiple aspects (backend + frontend + database). Each aspect gets its own specialist.
4. **Priority wins.** When multiple profiles match, the highest priority takes over.

### How Stack Selection Works

When `/sdlc:start` runs, the orchestrator needs to decide which agent handles development. The priority system is how it picks.

Each plugin has a `stack.md` file where it describes itself: *"I handle projects that have X, and my priority is Y."* The orchestrator scans all installed plugins, runs their detection rules against the current project, and picks the highest-priority match.

**Step by step:**

1. Scan `~/.gemini/config/plugins/**/stack.md` — collect all registered profiles.
2. Each profile checks its `detect` rules: is there a `package.json`? Does it contain `react`? Is there a `manage.py`? And so on.
3. From those that matched — the profile with the **highest priority number wins**.

**Example — Laravel + React (Inertia.js) project:**

| Plugin | Priority | Matched? |
|---|---|---|
| `vanilla` (sdlc) | 0 | ✅ always |
| `laravel-plugin` | 100 | ✅ `composer.json` + laravel |
| `react-plugin` | 150 | ✅ `package.json` + react |
| `inertia-react-plugin` | 175 | ✅ `package.json` + `@inertiajs/react` |

Result: **backend** → `laravel-architect`, **frontend** → `inertia-react-architect` (beats plain react at 175 vs 150).

---

## Model Enforcement

Every agent in the SDLC pipeline declares its `model:` in frontmatter. The pipeline guarantees that model is actually used — regardless of the session-level default model.

**Two enforcement layers:**

1. **Orchestrator (Layer 1)** — Step 3b-3 in the pipeline explicitly reads the agent's `.md` frontmatter, resolves the tier or model ID, and passes it in the `Agent()` dispatch call.
2. **PreToolUse hook (Layer 2)** — `plugins/sdlc/hooks/enforce-agent-model.sh` intercepts every `Agent` tool call at the harness level. It reads the agent's declared `model:`, compares it with the requested model, and corrects it via `updatedInput` if they differ. This fires even if the orchestrator misses the step.

The hook is registered in `plugins/sdlc/hooks/hooks.json` and activates automatically when the plugin is installed — no manual `settings.json` changes needed.

**Model ID / Tier mapping:**

| Tier / Shorthand | Model ID |
|---|---|
| `pro-high` | `gemini-3-pro-high` |
| `flash-med` | `gemini-3.5-flash` |
| `flash-low` | `gemini-3-flash` |

*Note: You can also specify the direct model ID (e.g. `model: gemini-3.5-flash`) in the agent frontmatter.*

---

## Agent Configuration: temperature + max_output_tokens

We configure agent behavior and token budgets directly using `model`, `temperature`, and `max_output_tokens` in the frontmatter of each agent. This ensures high determinism for code generation and sufficient creativity for requirements analysis.

### Standard Configuration Table

| Agent | Plugin | model | temperature | max_output_tokens | Rationale |
|---|---|---|---|---|---|
| `business-analyst` | sdlc | `gemini-3-pro-high` | `0.7` | `4096` | Allows creative exploration of edge cases and trial periods |
| `security-analyst` | sdlc | `gemini-3-pro-high` | `0.3` | `4096` | Logic-oriented threat modeling and vulnerability scanning |
| `developer` | sdlc | `gemini-3.5-flash` | `0.1` | `8192` | Highly deterministic, correct code generation with large output space |
| `qa-engineer` | sdlc | `gemini-3.5-flash` | `0.1` | `4096` | Deterministic test execution and verification |
| `document-writer` | sdlc | `gemini-3-flash` | `0.2` | `4096` | Factual, structured documentation generation |
| `laravel-architect` | laravel | `gemini-3.5-flash` | `0.1` | `8192` | Laravel idioms + Inertia/Vue code generation |
| `artisan-specialist` | laravel | `gemini-3.5-flash` | `0.1` | `4096` | Database schemas, factories, and migrations |
| `symfony-architect` | symfony | `gemini-3.5-flash` | `0.1` | `8192` | Symfony REST controllers and dependency injection |
| `doctrine-specialist` | symfony | `gemini-3.5-flash` | `0.1` | `4096` | Doctrine entity mappings and migrations |
| `node-architect` | nodejs | `gemini-3.5-flash` | `0.1` | `8192` | Express/Fastify backend code generation |
| `nest-architect` | nestjs | `gemini-3.5-flash` | `0.1` | `8192` | NestJS controllers and module wiring |
| `nextjs-architect` | nextjs | `gemini-3.5-flash` | `0.1` | `8192` | React Server Components and App Router |
| `react-architect` | react | `gemini-3.5-flash` | `0.1` | `8192` | React SPA layouts and custom hooks |
| `vue-architect` | vue | `gemini-3.5-flash` | `0.1` | `8192` | Vue 3 Composition API code generation |
| `angular-architect` | angular | `gemini-3.5-flash` | `0.1` | `8192` | Angular standalone components and signals |
| `rn-architect` | react-native | `gemini-3.5-flash` | `0.1` | `8192` | Expo mobile layouts and mobile navigation |
| `java-architect` | java | `gemini-3.5-flash` | `0.1` | `8192` | Plain Java core domain classes |
| `spring-boot-architect` | spring-boot | `gemini-3.5-flash` | `0.1` | `8192` | Spring Boot controllers and REST API bindings |
| `aspnet-core-architect` | aspnet-core | `gemini-3.5-flash` | `0.1` | `8192` | Minimal APIs and dependency injection |
| `efcore-specialist` | aspnet-core | `gemini-3.5-flash` | `0.1` | `4096` | EF Core Fluent API column mappings |

---

## Local Overrides

A `.agents/sdlc.local.yaml` file at the project root (not inside the plugin) lets you adapt the pipeline without modifying any plugin:

```yaml
post_pipeline_checks:
  - "composer test"
  - "php artisan route:list --json"

phase_command_overrides:
  qa: "php artisan test --coverage --min=80"

convention_skills_extra:
  - "local:custom-coding-standards"

skip_phases:
  - security  # for internal hotfix branches

extra_phase_prompts:
  development: "Follow our internal-styleguide.md"
```

---

## Adding a New Stack Plugin

Contract for a new framework provider:

```
plugins/your-framework-plugin/
├── plugin.json              # { "name": "...", "dependencies": ["sdlc"] }
├── stack.md                 # YAML frontmatter: stack, priority, aspects, detect
├── agents/
│   └── your-architect.md    # frontmatter: name, model, temperature, max_output_tokens
├── skills/
│   └── your-conventions/
│       └── SKILL.md
└── README.md
```

### `stack.md` example

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
    - file_contains:
        path: requirements.txt
        pattern: "[Dd]jango"
---
# Django Stack Profile

## Agents per phase
# business_analysis: business-analyst
# development.backend: django-architect
# database: django-migrations-specialist
# qa: qa-engineer / security: security-analyst / documentation: document-writer

## Convention skills to apply
# python-foundation:python-conventions
# python-foundation:python-tooling
# python-foundation:pytest-testing
# django-plugin:django-conventions
# django-plugin:django-orm-patterns
```

### Schema validation

```bash
# Validate plugin.json
npx check-jsonschema --schemafile schemas/plugin.schema.json plugin.json

# Validate stack.md frontmatter
npx check-jsonschema --schemafile schemas/stack.schema.json <(yq '.frontmatter' stack.md)
```

---

## Requirements

- Google Antigravity CLI (`agy`) or Antigravity IDE (latest)
- Gemini API key / Vertex model permissions for `gemini-3-pro-high`, `gemini-3.5-flash`, and `gemini-3-flash`
- A Git repository for `document-writer` (PR creation).

## License

MIT — see [`LICENSE`](./LICENSE).
