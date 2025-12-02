return {
  -- Configure Copilot separately for inline suggestions
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75, -- Reduced from 25ms for better performance
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
        auto_refresh = false, -- Disabled for performance
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
    dependencies = { "copilot.lua" },
    lazy = true,
    event = "BufReadPost",
  },
  -- Optimized Blink CMP configuration - Copilot only
  {
    "saghen/blink.cmp",
    dependencies = {
      "saghen/blink.compat",
    },
    opts = function(_, opts)
      -- Simplified sources - only Copilot + essentials
      opts.sources = opts.sources or {}
      opts.sources.default = { "copilot", "lsp", "path", "snippets", "buffer" }

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
      -- Copilot configuration
      opts.sources.providers.copilot = {
        name = "copilot",
        module = "blink-cmp-copilot",
        score_offset = 2000,
        async = true,
        max_items = 5, -- More Copilot suggestions
        min_keyword_length = 1, -- Trigger after just 1 character
        enabled = true,
      }

      -- LSP configuration
      opts.sources.providers.lsp = {
        name = "lsp",
        score_offset = 1000,
        max_items = 8, -- Reduced from 10
      }

      -- Buffer configuration
      opts.sources.providers.buffer = {
        max_items = 5,
        min_keyword_length = 3, -- Only trigger after 3 chars
      }

      -- Optimized completion menu with better performance
      opts.completion = opts.completion or {}
      opts.completion.trigger = {
        prefetch_on_insert = false, -- Disabled for performance
        show_on_insert_on_trigger_character = true,
        show_on_keyword = true,
        show_on_trigger_character = true,
        show_on_x_blocked_trigger_characters = {},
      }
      opts.completion.accept = {
        auto_brackets = {
          enabled = true,
          default_brackets = { "(", ")" },
        },
      }
      opts.completion.menu = opts.completion.menu or {}
      opts.completion.menu.max_height = 10 -- Reduced from 12
      opts.completion.menu.border = "none"
      opts.completion.menu.scrollbar = true
      opts.completion.menu.direction_priority = { "s", "n" }
      opts.completion.menu.winblend = 10

      opts.completion.menu.draw = opts.completion.menu.draw or {}
      opts.completion.menu.draw.padding = 1
      opts.completion.menu.draw.gap = 1 -- Reduced from 2
      opts.completion.menu.auto_show = true

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
