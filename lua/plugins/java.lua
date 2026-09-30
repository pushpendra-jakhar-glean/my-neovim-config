-- Keep JDTLS scoped to one Scio Java tree. A server rooted at the repository
-- root tries to index unrelated projects; loading both java/ and javatests/
-- into every server duplicates the entire index.
local function scio_java_root(path)
  local workspace = vim.fs.root(path, { "MODULE.bazel", "WORKSPACE", "WORKSPACE.bazel", ".git" })
  if not workspace then
    return nil
  end

  for _, source_dir in ipairs({ "java", "javatests" }) do
    local root = vim.fs.joinpath(workspace, source_dir)
    if path == root or vim.startswith(path, root .. "/") then
      return root
    end
  end
end

local function project_name(root)
  if not root then
    return nil
  end
  -- The complete path keeps separate Scio worktrees from sharing an Eclipse
  -- workspace and corrupting each other's indexes.
  return root:gsub("[^%w_.-]", "_"):gsub("^_+", "")
end

return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      opts.root_dir = scio_java_root
      opts.project_name = project_name
      opts.jdtls_workspace_dir = function(name)
        return vim.fn.stdpath("data") .. "/jdtls-workspace-v5/" .. name
      end

      -- The wrapper passes these directly to the JDTLS JVM. A smaller initial
      -- heap avoids reserving gigabytes for every worktree while leaving room
      -- for a single source tree's index.
      vim.list_extend(opts.cmd, {
        "--jvm-arg=-Xms256m",
        "--jvm-arg=-Xmx4g",
      })

      opts.dap = false
      opts.dap_main = false
      opts.test = false
      opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
        java = {
          autobuild = { enabled = false },
          maxConcurrentBuilds = 1,
          configuration = {
            updateBuildConfiguration = "disabled",
            runtimes = {
              {
                name = "JavaSE-17",
                path = vim.env.HOME .. "/.local/share/mise/installs/java/openjdk-17.0.2",
                default = true,
              },
            },
          },
          project = {
            sourcePaths = { "." },
          },
        },
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = true,
        signs = true,
        underline = true,
      },
      servers = {
        jdtls = {
          keys = {
            { "gd", vim.lsp.buf.definition, desc = "Goto Definition" },
            { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
          },
        },
      },
      setup = {
        jdtls = function()
          return true
        end,
      },
    },
  },
}
