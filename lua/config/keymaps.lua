-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>sx", function()
  Snacks.picker.grep({
    exclude = {
      "javatests/**",
      "**/test/**",
      "**/tests/**",
      "**/testdata/**",
      "**/test_utils/**",
      "**/testing/**",
      "**/*Test.java",
      "**/*_test.go",
      "**/*_test.py",
    },
  })
end, { desc = "Grep (no tests)" })
