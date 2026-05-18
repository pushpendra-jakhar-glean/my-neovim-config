local jdtls = require("jdtls")

local root_dir = require("jdtls.setup").find_root({
  ".classpath",
  ".project",
  "mvnw",
  "gradlew",
  "pom.xml",
  "build.gradle",
  ".git",
})

if not root_dir then
  return
end

local home = os.getenv("HOME")
local workspace_dir = home .. "/.local/share/jdtls-workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
local java_cmd = home .. "/.local/share/mise/installs/java/openjdk-21.0.2/bin/java"

local config = {
  cmd = {
    java_cmd,
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Xms512m",
    "-Xmx4g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    vim.fn.glob(mason_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration",
    mason_path .. "/config_mac",
    "-data",
    workspace_dir,
  },
  root_dir = root_dir,
  settings = {
    java = {
      autobuild = { enabled = false },
      configuration = {
        runtimes = {
          {
            name = "JavaSE-17",
            path = home .. "/.local/share/mise/installs/java/openjdk-17.0.2",
            default = true,
          },
        },
      },
    },
  },
}

local filter_patterns = {
  "accessible from more than one module",
  "cannot be resolved",
}

config.on_attach = function(client)
  local orig = vim.lsp.handlers["textDocument/publishDiagnostics"]
  vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, cfg)
    result.diagnostics = vim.tbl_filter(function(d)
      for _, pat in ipairs(filter_patterns) do
        if d.message:find(pat) then
          return false
        end
      end
      return true
    end, result.diagnostics)
    return orig(err, result, ctx, cfg)
  end
end

jdtls.start_or_attach(config)
