# Claude Code Statusline

A custom multi-line statusline for [Claude Code](https://claude.com/claude-code).
Shows live plan usage, context, cost, tool calls, running subagents, and every
loaded skill — wrapped to your terminal width.

```
shivang │ Opus 4.8 (1M context) │ my-repo[main] │ [██░░░░░░░░] 24% │ 5h:35%(2h40m) wk:33%(2d1h) │ $2.73 │ 🔧 142 │ 🤖 3 (+1)
⚡ omc · superpowers · caveman · serena · playwright · figma · github · context7 · typescript-lsp
  frontend-design · sonarqube · coderabbit · graphify · brainstorming
```

## What it shows

**Line 1**
| Segment | Meaning |
|---|---|
| `user` | OS username |
| `model` | active model |
| `repo[branch]` | project dir + git branch |
| `[████░░] 24%` | context-window used (auto-compact aware) |
| `5h:35%(2h40m) wk:33%(2d1h)` | **real subscription limits** — 5-hour + weekly usage %, with reset countdown |
| `$2.73` | session cost |
| `🔧 142` | total tool calls this session |
| `🤖 3 (+1)` | running `claude` processes, and live subagents in this session |

**Line 2+** — `⚡ enabled-plugins · skills-invoked-this-session`, deduped and
wrapped to your terminal/pane width so the full list is always visible.

## Install

1. Copy the script to your Claude config dir:
   ```bash
   cp shivang-claude-statusline.js ~/.claude/
   ```
2. Add to `~/.claude/settings.json`:
   ```json
   "statusLine": {
     "type": "command",
     "command": "node \"$HOME/.claude/shivang-claude-statusline.js\""
   }
   ```
   If `node` isn't on your PATH, use an absolute path to your node binary.

## Notes

- **Requires Claude Code ≥ 2.1.168** — that's when the statusline JSON started
  including the `rate_limits` field (the 5h/weekly usage %).
- **Width**: skill wrapping uses the tmux pane width when inside tmux, else
  `$COLUMNS`, else a 100-col fallback. Re-queries every render, so it follows
  live terminal resizes.
- **Env knob**: `STATUSLINE_SKILL_WIDTH=NN` forces a fixed skill-row width.
- Auto-creates `~/.claude/statusline-skills.json` (per-session skill/tool/agent
  cache — read incrementally, O(delta) per render).
- **Zero npm dependencies** — pure Node standard library.

## How it works

Claude Code pipes a JSON blob to the statusline command's stdin on every render
(model, workspace, cost, `context_window`, `rate_limits`, `transcript_path`).
The script reads that, plus:
- the session transcript (tail, incrementally) for invoked skills, tool-call
  count, and live subagents (spawned `Agent`/`Task` tool calls minus completed
  `tool_result`s),
- `~/.claude/settings.json` `enabledPlugins` for the loaded-plugin list,
- `tmux` for the pane width.
