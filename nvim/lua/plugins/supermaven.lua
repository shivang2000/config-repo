return {
  {
    "supermaven-inc/supermaven-nvim",
    event = "VeryLazy",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<M-l>", -- Alt+l for Supermaven accept (only when no other AI is showing)
          clear_suggestion = "<M-c>", -- Alt+c for clear
          accept_word = "<M-w>", -- Alt+w for accept word
        },
        ignore_filetypes = { "cpp" },
        color = {
          suggestion_color = "#666666", -- Dimmed color to not conflict with Copilot
          cterm = 244,
        },
        log_level = "info",
        disable_inline_completion = true, -- Disable inline to prioritize Copilot, but keep in CMP
        disable_keymaps = false,
        condition = function()
          return true
        end
      })
    end,
  },
}