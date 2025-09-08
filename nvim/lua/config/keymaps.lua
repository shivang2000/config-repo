-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>fp", function()
  local path = vim.fn.expand("%:~:.")
  vim.fn.setreg("+", path) -- copy to system clipboard
  vim.notify("Copied path: " .. path)
end, { desc = "Copy relative file path" })
vim.keymap.set("i", "<A-S-o>", "<C-o>O", { desc = "Insert new line above" })
vim.keymap.set("i", "<A-o>", "<C-o>o", { desc = "Insert new line below" })
