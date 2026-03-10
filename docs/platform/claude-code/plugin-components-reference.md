# Claude Code Plugin Components Reference

Source: https://code.claude.com/docs/en/plugins-reference

This is a platform reference, not an FDF repository policy document.
It explains Claude plugin capabilities in general. FDF repository conventions may be stricter than the platform allows.


Plugin components extend Claude Code with custom functionality. A plugin can include any combination of: skills, agents, hooks, MCP servers, and LSP servers.

---

## Skills

Skills create `/name` shortcuts that you or Claude can invoke.

**Location**: `skills/` directory in plugin root (preferred) or `commands/` (legacy)

**Structure**:
```
skills/
├── pdf-processor/
│   ├── SKILL.md
│   ├── reference.md    (optional)
│   └── scripts/        (optional)
└── code-reviewer/
    └── SKILL.md
```

Skills are directories with `SKILL.md`; commands are simple markdown files. Skills can include supporting files alongside `SKILL.md`. Skills and commands are automatically discovered when the plugin is installed. Claude can invoke them automatically based on task context.

See [Skills reference](https://code.claude.com/docs/en/skills) for complete SKILL.md frontmatter fields.

---

## Agents

Agents are specialized subagents for specific tasks that Claude can invoke automatically.

**Location**: `agents/` directory in plugin root

**File format**:
```markdown
---
name: agent-name
description: What this agent specializes in and when Claude should invoke it
---

Detailed system prompt for the agent describing its role, expertise, and behavior.
```

- Agents appear in the `/agents` interface
- Claude can invoke agents automatically based on task context
- Plugin agents work alongside built-in Claude agents

---

## Hooks

Hooks respond to Claude Code events automatically.

**Location**: `hooks/hooks.json` in plugin root, or inline in `plugin.json`

**Configuration**:
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/format-code.sh"
          }
        ]
      }
    ]
  }
}
```

### Available events

| Event                | Trigger                                         |
| :------------------- | :---------------------------------------------- |
| `PreToolUse`         | Before Claude uses any tool                     |
| `PostToolUse`        | After Claude successfully uses any tool         |
| `PostToolUseFailure` | After Claude tool execution fails               |
| `PermissionRequest`  | When a permission dialog is shown               |
| `UserPromptSubmit`   | When user submits a prompt                      |
| `Notification`       | When Claude Code sends notifications            |
| `Stop`               | When Claude attempts to stop                    |
| `SubagentStart`      | When a subagent is started                      |
| `SubagentStop`       | When a subagent attempts to stop                |
| `SessionStart`       | At the beginning of sessions                    |
| `SessionEnd`         | At the end of sessions                          |
| `TeammateIdle`       | When an agent team teammate is about to go idle |
| `TaskCompleted`      | When a task is being marked as completed        |
| `PreCompact`         | Before conversation history is compacted        |

### Hook types

| Type      | Description                                                               |
| :-------- | :------------------------------------------------------------------------ |
| `command` | Execute shell commands or scripts                                         |
| `prompt`  | Evaluate a prompt with an LLM (uses `$ARGUMENTS` placeholder for context) |
| `agent`   | Run an agentic verifier with tools for complex verification tasks         |

---

## MCP Servers

MCP servers connect Claude Code with external tools and services.

**Location**: `.mcp.json` in plugin root, or inline in `plugin.json`

**Configuration**:
```json
{
  "mcpServers": {
    "plugin-database": {
      "command": "${CLAUDE_PLUGIN_ROOT}/servers/db-server",
      "args": ["--config", "${CLAUDE_PLUGIN_ROOT}/config.json"],
      "env": {
        "DB_PATH": "${CLAUDE_PLUGIN_ROOT}/data"
      }
    }
  }
}
```

- Plugin MCP servers start automatically when the plugin is enabled
- Servers appear as standard MCP tools in Claude's toolkit
- Always use `${CLAUDE_PLUGIN_ROOT}` for paths to plugin files

---

## LSP Servers

LSP servers give Claude real-time code intelligence (diagnostics, go to definition, find references, hover).

**Location**: `.lsp.json` in plugin root, or inline in `plugin.json`

**`.lsp.json` format**:
```json
{
  "go": {
    "command": "gopls",
    "args": ["serve"],
    "extensionToLanguage": {
      ".go": "go"
    }
  }
}
```

### Required fields

| Field                 | Description                                  |
| :-------------------- | :------------------------------------------- |
| `command`             | The LSP binary to execute (must be in PATH)  |
| `extensionToLanguage` | Maps file extensions to language identifiers |

### Optional fields

| Field                   | Description                                               |
| :---------------------- | :-------------------------------------------------------- |
| `args`                  | Command-line arguments for the LSP server                 |
| `transport`             | `stdio` (default) or `socket`                             |
| `env`                   | Environment variables when starting the server            |
| `initializationOptions` | Options passed during initialization                      |
| `settings`              | Settings via `workspace/didChangeConfiguration`           |
| `workspaceFolder`       | Workspace folder path for the server                      |
| `startupTimeout`        | Max time to wait for startup (milliseconds)               |
| `shutdownTimeout`       | Max time to wait for graceful shutdown (milliseconds)     |
| `restartOnCrash`        | Whether to restart automatically if the server crashes    |
| `maxRestarts`           | Maximum restart attempts before giving up                 |

> **Warning**: The language server binary must be installed separately. LSP plugins configure the connection, not the server itself.

### Official LSP plugins (from marketplace)

| Plugin           | Language server            | Install command                                    |
| :--------------- | :------------------------- | :------------------------------------------------- |
| `pyright-lsp`    | Pyright (Python)           | `pip install pyright` or `npm install -g pyright`  |
| `typescript-lsp` | TypeScript Language Server | `npm install -g typescript-language-server typescript` |
| `rust-lsp`       | rust-analyzer              | See rust-analyzer installation docs                |