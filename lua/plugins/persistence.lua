return {
  {
    "folke/persistence.nvim",
    init = function()
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          if vim.fn.argc(-1) ~= 0 then
            return
          end

          -- Load the session for the current directory only when Neovim starts
          -- without file arguments. This keeps project state isolated.
          require("lazy").load({ plugins = { "persistence.nvim" } })
          pcall(function()
            require("persistence").load()
          end)
        end,
      })
    end,
    opts = {
      branch = false,
    },
  },
}
