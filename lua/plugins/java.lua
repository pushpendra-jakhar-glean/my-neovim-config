return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false,
        signs = true,
        underline = true,
      },
      servers = {
        jdtls = {},
      },
      setup = {
        jdtls = function()
          return true -- disable lspconfig jdtls, ftplugin handles it
        end,
      },
    },
  },
}
