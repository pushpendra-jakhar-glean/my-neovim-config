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

jdtls.start_or_attach(config)
