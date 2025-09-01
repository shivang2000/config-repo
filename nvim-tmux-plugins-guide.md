# Neovim & Tmux Configuration Plugins Guide

This document provides a comprehensive overview of all plugins used in the Neovim and Tmux configuration setup.

## 🌟 Neovim Configuration

The Neovim setup is built on top of **LazyVim** and uses **lazy.nvim** as the plugin manager.

### 🎯 Plugin Manager & Base Configuration

#### lazy.nvim

- **Repository**: [folke/lazy.nvim](https://github.com/folke/lazy.nvim)
- **Purpose**: Modern plugin manager for Neovim with lazy loading capabilities
- **Features**:
  - Fast startup times through lazy loading
  - Automatic plugin updates checking
  - Built-in plugin performance monitoring

#### LazyVim

- **Repository**: [LazyVim/LazyVim](https://github.com/LazyVim/LazyVim)
- **Purpose**: A Neovim starter configuration built on top of lazy.nvim
- **Features**:
  - Pre-configured LSP setup
  - Modern UI components
  - Sensible default keybindings

### 🤖 AI & Code Assistance Plugins

#### Avante.nvim

- **Repository**: [yetone/avante.nvim](https://github.com/yetone/avante.nvim)
- **Purpose**: AI-powered code assistance and chat interface
- **Features**:
  - Claude API integration (using claude-sonnet-4 model)
  - Moonshot AI provider support
  - Image pasting support via img-clip.nvim
  - Markdown rendering for AI responses
- **Configuration**:
  - Uses external instruction file (`avante.md`)
  - Configurable temperature and token limits
  - Timeout settings for API calls

#### ChatGPT.nvim

- **Repository**: [jackMort/ChatGPT.nvim](https://github.com/jackMort/ChatGPT.nvim)
- **Purpose**: ChatGPT integration for Neovim
- **Features**:
  - Direct ChatGPT API access
  - Interactive chat interface
  - Code generation and assistance

#### Windsurf/Codeium

- **Repository**: [Exafunction/windsurf.nvim](https://github.com/Exafunction/windsurf.nvim)
- **Purpose**: AI code completion and assistance
- **Features**:
  - Real-time code suggestions
  - Context-aware completions
  - Integration with nvim-cmp

#### MCP Hub

- **Repository**: [ravitemer/mcphub.nvim](https://github.com/ravitemer/mcphub.nvim)
- **Purpose**: Model Context Protocol integration
- **Features**:
  - Global MCP hub binary installation
  - Protocol-based AI model communication

### 🎨 UI & Appearance Plugins

#### Nightfox Theme

- **Repository**: [EdenEast/nightfox.nvim](https://github.com/EdenEast/nightfox.nvim)
- **Purpose**: Dark theme with multiple variants
- **Configuration**:
  - Using "carbonfox" variant
  - Full transparency enabled
  - Transparent sidebars and floating windows
  - Custom highlight groups for UI elements

#### Lualine

- **Repository**: [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
- **Purpose**: Fast and customizable statusline
- **Features**:
  - Auto theme detection
  - Minimal, clean appearance

#### Tokyo Night (Secondary Theme)

- **Repository**: [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim)
- **Purpose**: Alternative dark theme option
- **Configuration**: Custom transparency overrides

### 📁 File Management & Navigation

#### Snacks Explorer

- **Repository**: [folke/snacks.nvim](https://github.com/folke/snacks.nvim)
- **Purpose**: Modern file explorer and picker
- **Features**:
  - Hidden files always visible
  - Git-ignored files shown
  - Custom keybinding (`<space>e`)
  - File picker with enhanced visibility

### 🔧 Development Tools

#### Git Blame

- **Repository**: [f-person/git-blame.nvim](https://github.com/f-person/git-blame.nvim)
- **Purpose**: Inline git blame information
- **Features**:
  - Virtual text blame display
  - Custom message template with author, date, and SHA
  - Configurable date format and column positioning

#### Multi-Cursor (Visual Multi)

- **Repository**: [mg979/vim-visual-multi](https://github.com/mg979/vim-visual-multi)
- **Purpose**: Multiple cursor editing
- **Features**:
  - Custom key mappings (`Ctrl+n`, `Ctrl+a`, etc.)
  - Advanced multi-cursor operations
  - Subword selection support

### 🧠 Code Completion & AI Assistance

Your setup uses a modern **dual completion system** with multiple AI providers:

#### Primary Completion Engine: Blink.cmp

- **Repository**: [saghen/blink.cmp](https://github.com/saghen/blink.cmp)
- **Purpose**: Ultra-fast completion engine (replacing nvim-cmp)
- **Features**:
  - Written in Rust for maximum performance
  - Async completion sources
  - Built-in fuzzy matching
  - LSP completion integration
  - Snippet support via LuaSnip and mini.snippets

#### AI Code Completion Providers

**1. GitHub Copilot (Primary AI)**

- **Plugin**: `copilot.lua` + `blink-cmp-copilot`
- **Integration**: Full line/function suggestions
- **Status**: ✅ **ACTIVE** - Integrated with blink.cmp via bridge plugin
- **Features**: Context-aware code generation, multi-language support

**2. TabNine AI**

- **Plugin**: `cmp-tabnine`
- **Integration**: AI-powered completions
- **Status**: ✅ **ACTIVE** - Provides alternative AI suggestions
- **Features**: Deep learning code predictions

**3. Windsurf/Codeium**

- **Plugin**: `windsurf.nvim`
- **Purpose**: Additional AI completion provider
- **Status**: ✅ **ACTIVE** - Secondary AI assistant

#### Completion Popup & UI

- **Engine**: `blink.cmp` handles all popup rendering
- **Compatibility**: `blink.compat` ensures nvim-cmp plugin compatibility
- **UI Features**:
  - Fast, non-blocking completion menu
  - Source indicators (LSP, Copilot, TabNine, etc.)
  - Customizable appearance and behavior

#### Snippet Engines

- **LuaSnip**: Advanced snippet engine (LazyVim extra enabled)
- **mini.snippets**: Lightweight alternative snippet system
- Both engines provide code templates and expansion

#### Chat-based AI (Non-completion)

- **Avante.nvim**: Claude-4 integration for code discussions
- **ChatGPT.nvim**: Direct ChatGPT interface
- **CopilotChat.nvim**: GitHub Copilot's chat interface

### 📦 Supporting Dependencies

- **plenary.nvim**: Lua utility functions (required by multiple plugins)
- **nui.nvim**: UI component library
- **nvim-cmp**: Legacy completion framework (superseded by blink.cmp)
- **telescope.nvim**: Fuzzy finder integration
- **fzf-lua**: Alternative fuzzy finder
- **dressing.nvim**: Enhanced input/select UI
- **nvim-web-devicons**: File type icons
- **copilot.lua**: GitHub Copilot integration
- **img-clip.nvim**: Image pasting support
- **render-markdown.nvim**: Markdown rendering
- **trouble.nvim**: Diagnostics and quickfix enhancement

---

## 🖥️ Tmux Configuration

The Tmux setup focuses on productivity, session management, and visual enhancement.

### 🔌 Plugin Manager

#### TPM (Tmux Plugin Manager)

- **Repository**: [tmux-plugins/tpm](https://github.com/tmux-plugins/tpm)
- **Purpose**: Plugin manager for tmux
- **Installation**: `~/.tmux/plugins/tpm/tpm`

### 🛠️ Core Functionality Plugins

#### tmux-sensible

- **Repository**: [tmux-plugins/tmux-sensible](https://github.com/tmux-plugins/tmux-sensible)
- **Purpose**: Basic tmux settings everyone can agree on
- **Features**:
  - Sensible default options
  - Better key bindings
  - Improved mouse support

#### tmux-yank

- **Repository**: [tmux-plugins/tmux-yank](https://github.com/tmux-plugins/tmux-yank)
- **Purpose**: Copy to system clipboard
- **Features**:
  - Vi-mode copy integration
  - System clipboard synchronization
  - Cross-platform clipboard support

### 💾 Session Management

#### tmux-resurrect

- **Repository**: [tmux-plugins/tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect)
- **Purpose**: Persist tmux sessions across reboots
- **Features**:
  - Save and restore tmux sessions
  - Neovim session strategy integration
  - Window and pane layout preservation

#### tmux-continuum

- **Repository**: [tmux-plugins/tmux-continuum](https://github.com/tmux-plugins/tmux-continuum)
- **Purpose**: Automatic session saving and restoration
- **Configuration**:
  - Auto-restore enabled
  - Works with tmux-resurrect

#### tmux-sessionx

- **Repository**: [omerxx/tmux-sessionx](https://github.com/omerxx/tmux-sessionx)
- **Purpose**: Enhanced session management with fuzzy finding
- **Features**:
  - Zoxide integration for smart directory jumping
  - Custom path management
  - Window dimensions: 75% width, 85% height
  - Bound to `o` key
- **Configuration**:
  - Custom paths support
  - Subdirectory filtering disabled
  - Current session filtering disabled

### 🎨 Visual Enhancement

#### Catppuccin Theme

- **Repository**: [omerxx/catppuccin-tmux](https://github.com/omerxx/catppuccin-tmux) (Fork)
- **Purpose**: Beautiful, pastel theme for tmux
- **Features**:
  - Custom status modules (directory, date_time, session)
  - Window separators and numbering
  - Meetings integration script
  - Custom separators and fill styles
- **Status Modules**:
  - Left: Session name
  - Right: Current directory, time (HH:MM format)

### 🔍 Search & Navigation

#### tmux-fzf

- **Repository**: [sainnhe/tmux-fzf](https://github.com/sainnhe/tmux-fzf)
- **Purpose**: Fuzzy finder integration for tmux
- **Features**:
  - Window, session, and pane searching
  - Command palette functionality

#### tmux-fzf-url

- **Repository**: [wfxr/tmux-fzf-url](https://github.com/wfxr/tmux-fzf-url)
- **Purpose**: Extract and open URLs from tmux panes
- **Configuration**:
  - Custom FZF options (60% width, 30% height)
  - 2000 URL history limit
  - Custom prompt and border label

#### tmux-thumbs

- **Repository**: [fcsonline/tmux-thumbs](https://github.com/fcsonline/tmux-thumbs)
- **Purpose**: Copy/paste enhancement with hints
- **Features**:
  - Visual hints for copyable text
  - Fast text selection
  - Pattern matching for common text types

### 🪟 Window Management

#### tmux-floax

- **Repository**: [omerxx/tmux-floax](https://github.com/omerxx/tmux-floax)
- **Purpose**: Floating window management
- **Configuration**:
  - Size: 80% width, 80% height
  - Magenta border, blue text
  - Bound to `p` key
  - Auto path changing enabled

### ⚙️ Key Configuration Summary

#### Custom Tmux Bindings

- **Prefix**: `Ctrl+A` (instead of default Ctrl+B)
- **Session Switching**:
  - `Alt+1`: main session
  - `Alt+2`: ide session
  - `Alt+3`: jest-runner session
  - `Alt+4`: code-runner session
  - `Alt+5`: claude-terminal session
- **Pane Resizing**:
  - `Alt+h/j/k/l`: Resize panes in respective directions
- **Plugin Bindings**:
  - `o`: sessionx (session management)
  - `p`: floax (floating windows)

#### General Settings

- **Base index**: 1 (windows start at 1)
- **Mouse support**: Enabled
- **Clipboard**: System clipboard integration
- **Vi mode**: Enabled for copy mode
- **History**: 1,000,000 lines
- **Escape time**: 0ms (no delay)
- **Window renumbering**: Automatic
- **Detach behavior**: Stay in tmux when closing sessions

---

## 🚀 Installation Notes

### Neovim Setup

1. Ensure you have Neovim 0.9+ installed
2. Install the configuration by placing files in `~/.config/nvim/`
3. Run `:lazy` to install all plugins
4. Restart Neovim to apply all configurations

### Tmux Setup

1. Install tmux 3.0+
2. Place configuration in `~/.config/tmux/tmux.conf`
3. Install TPM: `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
4. Reload tmux config: `tmux source-file ~/.config/tmux/tmux.conf`
5. Install plugins: `Prefix + I` (Ctrl+A, then I)

### Dependencies

- **Node.js**: Required for MCP Hub and some language servers
- **Git**: Essential for version control plugins
- **FZF**: For fuzzy finding capabilities
- **Zoxide**: For smart directory jumping (optional but recommended)
- **Python/pip**: For some Neovim plugins
- **Clipboard utilities**: `xclip` (Linux) or `pbcopy` (macOS)

---

## 💡 Tips & Usage

### Neovim Workflow

- Use `<space>e` to open the file explorer
- AI assistance is available through Avante, ChatGPT, and Codeium
- Git blame information appears inline while editing
- Multi-cursor editing with `Ctrl+n` for quick selections

### Tmux Workflow

- Quick session switching with `Alt+1-5` for predefined sessions
- Use `o` for fuzzy session management
- Press `p` for floating terminal windows
- URLs in terminal can be extracted and opened with the fzf-url plugin
- Sessions automatically save and restore across reboots

This configuration provides a powerful, modern development environment optimized for productivity and visual appeal.
