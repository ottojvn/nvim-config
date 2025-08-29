-- lua/utils/jdtls.lua
local M = {}

function M.get_config()
  -- Standard nvim-jdtls paths
  local jdtls_install = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
  local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

  -- Basic installation check
  if vim.fn.isdirectory(jdtls_install) == 0 then
    vim.notify("JDTLS não encontrado. Execute :MasonInstall jdtls", vim.log.levels.WARN)
    return nil
  end

  -- Create workspace directory
  vim.fn.mkdir(workspace_dir, "p")
  
  -- Find launcher jar
  local launcher_jar = vim.fn.glob(jdtls_install .. "/plugins/org.eclipse.equinox.launcher_*.jar")
  if launcher_jar == "" then
    vim.notify("JDTLS launcher não encontrado", vim.log.levels.ERROR)
    return nil
  end
  
  -- OS-specific config
  local os_config = jdtls_install .. "/config_" .. (vim.fn.has('mac') == 1 and "mac" or (vim.fn.has('win32') == 1 and "win" or "linux"))

  -- Minimal JVM flags following nvim-jdtls standards
  local cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.application",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Xms1g",
    "-Xmx2g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", launcher_jar,
    "-configuration", os_config,
    "-data", workspace_dir,
  }

  -- Standard bundles for debugging and testing
  local bundles = {}
  vim.list_extend(bundles, vim.split(vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n"))
  vim.list_extend(bundles, vim.split(vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/java-test/extension/server/*.jar"), "\n"))

  return {
    cmd = cmd,
    root_dir = require("jdtls.setup").find_root({ "gradlew", "mvnw", ".git", "pom.xml", "build.gradle" }),
    settings = {
      java = {
        eclipse = { downloadSources = true },
        configuration = { updateBuildConfiguration = "interactive" },
        maven = { downloadSources = true },
        implementationsCodeLens = { enabled = true },
        referencesCodeLens = { enabled = true },
        format = { enabled = true }
      }
    },
    init_options = { bundles = bundles },
    capabilities = vim.lsp.protocol.make_client_capabilities()
  }
end

return M
