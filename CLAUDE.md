# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **personal configuration repository** containing dotfiles and settings for development tools. The main components are:

- **Neovim configuration** (`nvim/`) - LazyVim-based setup with AI integrations
- **Tmux configuration** (`tmux/`) - Terminal multiplexer with productivity plugins
- **Application configs** - AWS VPN, GitHub CLI, iTerm2, Raycast, and others

## Key Architecture

### Neovim Setup (nvim/)
- **Base**: LazyVim starter template with lazy.nvim plugin manager
- **Structure**:
  - `init.lua` - Bootstrap file that loads config.lazy
  - `lua/config/` - Core LazyVim configuration (lazy.lua, options.lua, keymaps.lua, autocmds.lua)
  - `lua/plugins/` - Custom plugin configurations
- **AI Integration**: Multiple AI providers configured (Claude-4 via Avante, GitHub Copilot, ChatGPT, Codeium)
- **Code Formatting**: Uses Stylua with 2-space indents, 120 column width (`stylua.toml`)

### Tmux Setup (tmux/)
- **Main config**: `tmux.conf` with Catppuccin theme and productivity plugins
- **Key bindings**: Ctrl+A prefix, Alt+1-6 for session switching, smart Vim integration
- **Plugin management**: TPM (Tmux Plugin Manager) for session persistence, fuzzy finding, and UI enhancements

## Development Commands

### Neovim
- **Plugin management**: `:Lazy` - Install/update/manage plugins
- **Code formatting**: Uses Stylua for Lua files (automatically configured)
- **AI assistance**:
  - Avante.nvim for Claude-4 integration
  - GitHub Copilot for code completion
  - ChatGPT.nvim for direct OpenAI access

### Tmux
- **Plugin installation**: `Ctrl+A + I` (after sourcing config)
- **Plugin updates**: `Ctrl+A + U`
- **Session management**: `Alt+1-6` for predefined sessions (main, ide, jest-runner, code-runner, claude-terminal, backend-ide)
- **Reload config**: `tmux source-file ~/.config/tmux/tmux.conf`

## Configuration Management

### File Locations
- Neovim: `~/.config/nvim/`
- Tmux: `~/.config/tmux/tmux.conf`
- Git tracking: All configs are version controlled

### Tmux Session Architecture
Pre-configured sessions accessible via Alt+number:
- **main** (Alt+1): Primary development session
- **ide** (Alt+2): IDE/editor session
- **jest-runner** (Alt+3): Test runner session
- **code-runner** (Alt+4): Code execution session
- **claude-terminal** (Alt+5): AI/Claude interaction session
- **backend-ide** (Alt+6): Backend development session

### AI Provider Configuration
- **Primary**: Claude-4 (claude-sonnet-4-20250514) via Avante.nvim
- **Secondary**: GitHub Copilot, ChatGPT, Codeium/Windsurf
- **Completion**: Blink.cmp engine with multiple AI sources
- **Instructions**: Uses external `avante.md` for AI context

## Common Tasks

### Plugin Updates
```bash
# Neovim plugins
nvim -c ":Lazy update"

# Tmux plugins
tmux run-shell ~/.tmux/plugins/tpm/scripts/update_plugin.sh
```

### Configuration Reloads
```bash
# Tmux
tmux source-file ~/.config/tmux/tmux.conf

# Neovim (restart required for major changes)
```

### Troubleshooting
- Neovim: Check `:checkhealth` and `:Lazy profile`
- Tmux: Verify TPM installation at `~/.tmux/plugins/tpm/`
- AI providers: Ensure API keys are properly configured in respective plugin configs