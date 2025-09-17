return {
  {
    "folke/noice.nvim",
    opts = {
      notify = {
        enabled = true,
        view = "notify",
      },
      views = {
        notify = {
          backend = "notify",
          fallback = "mini",
          format = "notify",
          replace = false,
          merge = false,
        },
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 10000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.4)
      end,
      stages = "static",
      render = "default",
      background_colour = "#000000",
      top_down = true,
    },
    config = function(_, opts)
      local notify = require("notify")

      -- Custom stage for top center positioning
      local stages_util = require("notify.stages.util")
      local stages = {
        function(state)
          local next_height = state.message.height + 2
          local next_row = stages_util.available_slot(state.open_windows, next_height, stages_util.DIRECTION.TOP_DOWN)
          if not next_row then
            return nil
          end

          -- Calculate center position
          local win_width = state.message.width + 4
          local col = math.floor((vim.o.columns - win_width) / 2)

          return {
            relative = "editor",
            anchor = "NW",
            width = state.message.width,
            height = state.message.height,
            col = col,
            row = next_row,
            border = "rounded",
            style = "minimal",
          }
        end,
        function()
          return {
            col = vim.o.columns,
            time = true,
          }
        end,
      }

      opts.stages = stages
      notify.setup(opts)
      vim.notify = notify
    end,
  },
}