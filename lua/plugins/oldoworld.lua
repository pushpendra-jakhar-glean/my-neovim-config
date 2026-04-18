return {
  {
    "dgox16/oldworld.nvim",
    priority = 1000,
    config = function()
      require("oldworld").setup({
        variant = "oled",
        highlight_overrides = {
          ["@namespace"] = { fg = "#88c4a0", italic = true },
          ["@lsp.type.namespace"] = { fg = "#88c4a0", italic = true },
          ["@keyword.import"] = { fg = "#7aad96" },
          Structure = { fg = "#a3b585" },
          ["@lsp.type.class"] = { fg = "#a3b585" },
          ["@type"] = { fg = "#a3b585" },
          ["@constructor"] = { fg = "#a3b585" },
        },
      })
      vim.cmd.colorscheme("oldworld")
    end,
  },
}
