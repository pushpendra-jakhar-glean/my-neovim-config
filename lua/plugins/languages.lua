return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Pyright already defaults to open-file diagnostics. This matters in
        -- Scio because its pyrightconfig.json is at the monorepo root.
        pyright = {},

        -- ts_ls runs one server at the pnpm workspace root and chooses the
        -- nearest tsconfig for each buffer, which is the intended monorepo
        -- mode for Scio.
        ts_ls = {},
      },
    },
  },
}
