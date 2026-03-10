# Claude Code Plugin Manifest Reference

Source: https://code.claude.com/docs/en/plugins-reference

This is a platform reference, not an FDF repository policy document.
Use it to understand Claude manifest fields. Use docs/distribution/claude-feature-driven-flow-repo-spec.md for the manifest choices this repository actually ships.


## Plugin Manifest (`plugin.json`)

Location: `.claude-plugin/plugin.json` (optional — Claude Code auto-discovers components without it)

### Complete schema

```json
{
  "name": "plugin-name",
  "version": "1.2.0",
  "description": "Brief plugin description",
  "author": {
    "name": "Author Name",
    "email": "author@example.com",
    "url": "https://github.com/author"
  },
  "homepage": "https://docs.example.com/plugin",
  "repository": "https://github.com/author/plugin",
  "license": "MIT",
  "keywords": ["keyword1", "keyword2"],
  "commands": ["./custom/commands/special.md"],
  "agents": "./custom/agents/",
  "skills": "./custom/skills/",
  "hooks": "./config/hooks.json",
  "mcpServers": "./mcp-config.json",
  "outputStyles": "./styles/",
  "lspServers": "./.lsp.json"
}
```

### Required fields

| Field  | Type   | Description                               | Example              |
| :----- | :----- | :---------------------------------------- | :------------------- |
| `name` | string | Unique identifier (kebab-case, no spaces) | `"deployment-tools"` |

The `name` is used for namespacing components. For example, agent `agent-creator` for plugin `plugin-dev` appears as `plugin-dev:agent-creator` in the UI.

### Metadata fields

| Field         | Type   | Description                                                                 | Example                                            |
| :------------ | :----- | :-------------------------------------------------------------------------- | :------------------------------------------------- |
| `version`     | string | Semantic version. `plugin.json` takes priority over marketplace entry.      | `"2.1.0"`                                          |
| `description` | string | Brief explanation of plugin purpose                                         | `"Deployment automation tools"`                    |
| `author`      | object | Author information (`name`, `email`, `url`)                                 | `{"name": "Dev Team", "email": "dev@company.com"}` |
| `homepage`    | string | Documentation URL                                                           | `"https://docs.example.com"`                       |
| `repository`  | string | Source code URL                                                             | `"https://github.com/user/plugin"`                 |
| `license`     | string | SPDX license identifier                                                     | `"MIT"`, `"Apache-2.0"`                            |
| `keywords`    | array  | Discovery tags                                                              | `["deployment", "ci-cd"]`                          |

### Component path fields

| Field          | Type                  | Description                              | Example                                |
| :------------- | :-------------------- | :--------------------------------------- | :------------------------------------- |
| `commands`     | string\|array         | Additional command files/directories     | `"./custom/cmd.md"` or `["./cmd1.md"]` |
| `agents`       | string\|array         | Additional agent files                   | `"./custom/agents/reviewer.md"`        |
| `skills`       | string\|array         | Additional skill directories             | `"./custom/skills/"`                   |
| `hooks`        | string\|array\|object | Hook config paths or inline config       | `"./my-extra-hooks.json"`              |
| `mcpServers`   | string\|array\|object | MCP config paths or inline config        | `"./my-extra-mcp-config.json"`         |
| `outputStyles` | string\|array         | Additional output style files/dirs       | `"./styles/"`                          |
| `lspServers`   | string\|array\|object | LSP server configurations                | `"./.lsp.json"`                        |

**Path behavior**: Custom paths supplement default directories — they do not replace them. All paths must be relative to plugin root and start with `./`.

### Environment variables

`${CLAUDE_PLUGIN_ROOT}` — absolute path to the plugin directory. Use in hooks, MCP servers, and scripts:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "hooks": [{ "type": "command", "command": "${CLAUDE_PLUGIN_ROOT}/scripts/process.sh" }]
      }
    ]
  }
}
```

---

## Plugin Directory Structure

### Standard layout

```
enterprise-plugin/
├── .claude-plugin/           # Metadata directory (optional)
│   └── plugin.json           # Plugin manifest
├── commands/                 # Default command location (legacy)
│   ├── status.md
│   └── logs.md
├── agents/                   # Default agent location
│   ├── security-reviewer.md
│   └── compliance-checker.md
├── skills/                   # Agent skills (preferred over commands/)
│   ├── code-reviewer/
│   │   └── SKILL.md
│   └── pdf-processor/
│       ├── SKILL.md
│       └── scripts/
├── hooks/
│   └── hooks.json
├── settings.json             # Default plugin settings (agent settings only)
├── .mcp.json                 # MCP server definitions
├── .lsp.json                 # LSP server configurations
├── scripts/                  # Hook and utility scripts
├── LICENSE
└── CHANGELOG.md
```

> **Warning**: All component directories (`commands/`, `agents/`, `skills/`, `hooks/`) must be at the plugin root, not inside `.claude-plugin/`. Only `plugin.json` belongs in `.claude-plugin/`.

### File locations reference

| Component       | Default Location             | Notes                                                  |
| :-------------- | :--------------------------- | :----------------------------------------------------- |
| **Manifest**    | `.claude-plugin/plugin.json` | Optional                                               |
| **Commands**    | `commands/`                  | Legacy; prefer `skills/` for new work                  |
| **Agents**      | `agents/`                    | Subagent markdown files                                |
| **Skills**      | `skills/`                    | `<name>/SKILL.md` structure                            |
| **Hooks**       | `hooks/hooks.json`           | Hook configuration                                     |
| **MCP servers** | `.mcp.json`                  | MCP server definitions                                 |
| **LSP servers** | `.lsp.json`                  | Language server configurations                         |
| **Settings**    | `settings.json`              | Default config; only `agent` settings currently supported |

---

## Plugin Installation Scopes

| Scope     | Settings file                 | Use case                                            |
| :-------- | :---------------------------- | :-------------------------------------------------- |
| `user`    | `~/.claude/settings.json`     | Personal plugins across all projects (default)      |
| `project` | `.claude/settings.json`       | Team plugins shared via version control             |
| `local`   | `.claude/settings.local.json` | Project-specific plugins, gitignored                |
| `managed` | Managed settings              | Managed plugins (read-only, update only)            |

---

## Plugin Caching and File Resolution

Marketplace plugins are copied to `~/.claude/plugins/cache` for security. Plugins cannot reference files outside their directory — paths like `../shared-utils` will not work.

**Workaround**: use symlinks inside the plugin directory — they are followed during the copy:

```bash
ln -s /path/to/shared-utils ./shared-utils
```

---

## Version Management

Follow semantic versioning (`MAJOR.MINOR.PATCH`):

```json
{ "name": "my-plugin", "version": "2.1.0" }
```

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward-compatible)
- **PATCH**: Bug fixes (backward-compatible)

> **Warning**: Claude Code uses the version to detect updates. If you change the plugin code without bumping the version, existing users will not see the changes due to caching.