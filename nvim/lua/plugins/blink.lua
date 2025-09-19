return {
  -- Configure Copilot separately for inline suggestions
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
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
      opts.sources.default = { "lsp", "path", "snippets", "buffer", "copilot", "supermaven" }

      opts.sources.providers = opts.sources.providers or {}
      opts.sources.providers.copilot = {
        name = "copilot",
        module = "blink-cmp-copilot",
        score_offset = 100,
        async = true,
      }
      opts.sources.providers.supermaven = {
        name = "supermaven",
        module = "blink.compat.source",
        score_offset = 80,
        async = true,
      }

      -- Enhanced completion menu
      opts.completion = opts.completion or {}
      opts.completion.menu = opts.completion.menu or {}
      opts.completion.menu.draw = opts.completion.menu.draw or {}
      opts.completion.menu.draw.columns = {
        { "kind_icon" },
        { "label", "label_description", gap = 1 },
        { "source_name" },
      }
      opts.completion.menu.draw.components = {
        source_name = {
          text = function(ctx)
            local icons = {
              copilot = "",
              supermaven = "🧠",
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
