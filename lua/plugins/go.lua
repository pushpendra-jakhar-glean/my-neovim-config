return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          -- Native vim.lsp.config does not call the legacy on_new_config hook.
          -- Resolve the driver separately for each client before spawning gopls.
          cmd = function(dispatchers, config)
            local env = vim.tbl_extend("force", {}, config.cmd_env or {})
            local root = config.root_dir
              and vim.fs.root(config.root_dir, { "MODULE.bazel", "WORKSPACE", "WORKSPACE.bazel", ".git" })
            local driver = root and vim.fs.joinpath(root, "tools", "gopackagesdriver.sh")

            if driver and vim.fn.executable(driver) == 1 then
              env.GOPACKAGESDRIVER = driver
            end

            -- Keep this visible in the client config for runtime inspection.
            config.cmd_env = env
            return vim.lsp.rpc.start({ "gopls" }, dispatchers, {
              cwd = config.cmd_cwd or config.root_dir,
              env = env,
              detached = config.detached,
            })
          end,
        },
      },
    },
  },
}
