return {
  -- Configure Copilot separately for inline suggestions
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 25, -- Very fast response for immediate suggestions
        keymap = {
          accept = "<M-Tab>",
          accept_word = "<M-Right>",
          accept_line = "<M-Down>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<M-Backspace>",
        },
      },
      panel = {
        enabled = true,
        auto_refresh = true,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>",
        },
      },
    },
  },
  {
    "giuxtaposition/blink-cmp-copilot",
  },
  {
    "jonahgoldwastaken/copilot-status.nvim",
    dependencies = { "copilot.lua" }, -- or "zbirenbaum/copilot.lua"
    lazy = true,
    event = "BufReadPost",
  },
  -- Enhanced Blink CMP configuration
  {
    "saghen/blink.cmp",
    dependencies = {
      "saghen/blink.compat",
    },
    opts = function(_, opts)
      -- Extend the default LazyVim config
      opts.sources = opts.sources or {}
      opts.sources.default = { "copilot", "lsp", "path", "snippets", "buffer", "supermaven", "codeium" }

      -- Context-aware source selection for different filetypes (Copilot always first)
      opts.sources.per_filetype = {
        python = { "copilot", "lsp", "supermaven", "snippets", "buffer" },
        javascript = { "copilot", "lsp", "codeium", "snippets", "buffer" },
        typescript = { "copilot", "lsp", "codeium", "snippets", "buffer" },
        lua = { "copilot", "lsp", "snippets", "buffer" },
        rust = { "copilot", "lsp", "supermaven", "snippets", "buffer" },
        go = { "copilot", "lsp", "supermaven", "snippets", "buffer" },
        markdown = { "copilot", "buffer", "path", "snippets" },
      }

      opts.sources.providers = opts.sources.providers or {}
      -- AI providers with optimized scoring and limits
      opts.sources.providers.copilot = {
        name = "copilot",
        module = "blink-cmp-copilot",
        score_offset = 2000, -- Maximum priority - always first
        async = true,
        max_items = 5, -- More Copilot suggestions
        min_keyword_length = 1, -- Trigger after just 1 character
        enabled = true,
      }
      opts.sources.providers.supermaven = {
        name = "supermaven",
        module = "blink.compat.source",
        score_offset = 900, -- High priority, good for performance-critical code
        async = true,
        max_items = 2,
        min_keyword_length = 2,
      }
      opts.sources.providers.codeium = {
        name = "codeium",
        module = "blink.compat.source",
        score_offset = 800, -- Good for web development
        async = true,
        max_items = 2,
        min_keyword_length = 3,
      }

      -- Enhanced LSP configuration
      opts.sources.providers.lsp = {
        name = "lsp",
        score_offset = 700, -- Lower than AI but still important
        max_items = 10,
      }

      -- Enhanced completion menu with performance optimizations
      opts.completion = opts.completion or {}
      opts.completion.trigger = {
        prefetch_on_insert = true,
        show_on_insert_on_trigger_character = true, -- Show immediately on trigger chars
        show_on_keyword = true, -- Show on any keyword
        show_on_trigger_character = true,
        show_on_x_blocked_trigger_characters = {}, -- Don't block on any characters
        -- Immediate show when typing
        immediate_show = true,
        show_on_accept_on_trigger_character = true,
      }
      opts.completion.accept = {
        auto_brackets = {
          enabled = true,
          default_brackets = { "(", ")" },
          override_brackets_for_filetypes = {
            lua = { "(", ")" },
            python = { "(", ")" },
          },
        },
      }
      opts.completion.menu = opts.completion.menu or {}
      opts.completion.menu.max_height = 12
      opts.completion.menu.border = "none" -- VSCode-like clean look
      opts.completion.menu.scrollbar = true
      opts.completion.menu.direction_priority = { "s", "n" } -- Prefer below cursor

      -- Position menu to the right to show ghost text
      opts.completion.menu.winblend = 10 -- Slight transparency like VSCode
      opts.completion.menu.winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder,CursorLine:PmenuSel,Search:None"

      -- VSCode-style layout with proper spacing and positioning
      opts.completion.menu.draw = opts.completion.menu.draw or {}
      opts.completion.menu.draw.padding = 1
      opts.completion.menu.draw.gap = 2

      -- Position menu strategically to show ghost text
      opts.completion.menu.auto_show = true
      opts.completion.menu.col_offset = 0 -- Move menu to show ghost text better

      -- Synchronize menu with ghost text suggestions
      opts.completion.ghost_text = {
        enabled = true,
      }

      opts.completion.menu.draw.columns = {
        { "kind_icon", gap = 1 },
        { "label", "label_description", gap = 1 },
        { "source_name" },
      }
      opts.completion.menu.draw.components = {
        source_name = {
          text = function(ctx)
            local icons = {
              copilot = "",
              supermaven = "🧠",
              codeium = "",
              lsp = "LSP",
              buffer = "BUF",
              path = "PATH",
              snippets = "SNIP",
              Text = "󰉿",
              Method = "󰊕",
              Function = "󰊕",
              Constructor = "󰒓",

              Field = "󰜢",
              Variable = "󰆦",
              Property = "󰖷",

              Class = "󱡠",
              Interface = "󱡠",
              Struct = "󱡠",
              Module = "󰅩",

              Unit = "󰪚",
              Value = "󰦨",
              Enum = "󰦨",
              EnumMember = "󰦨",

              Keyword = "󰻾",
              Constant = "󰏿",

              Snippet = "󱄽",
              Color = "󰏘",
              File = "󰈔",
              Reference = "󰬲",
              Folder = "󰉋",
              Event = "󱐋",
              Operator = "󰪚",
              TypeParameter = "󰬛",
            }
            return icons[ctx.source_name] or ctx.source_name
          end,
          highlight = "BlinkCmpSource",
        },
      }

      return opts
    end,
  },
}
