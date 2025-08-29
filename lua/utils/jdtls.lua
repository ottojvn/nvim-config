-- lua/utils/jdtls.lua
local M = {}

-- Função para diagnosticar problemas comuns do JDTLS
function M.diagnose()
  local issues = {}
  local jdtls_install = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
  
  -- Verificar instalação do Java
  local java_version = vim.fn.system("java -version 2>&1")
  if vim.v.shell_error ~= 0 then
    table.insert(issues, "❌ Java não encontrado no PATH")
  else
    local version_match = java_version:match("version \"([^\"]+)\"") or java_version:match("version ([%d%.]+)")
    if version_match then
      local major_version = tonumber(version_match:match("^(%d+)"))
      if major_version and major_version >= 11 then
        table.insert(issues, "✅ Java " .. version_match .. " detectado")
      else
        table.insert(issues, "⚠️  Java " .. version_match .. " detectado (recomendado Java 11+)")
      end
    end
  end
  
  -- Verificar instalação do JDTLS
  if vim.fn.isdirectory(jdtls_install) == 0 then
    table.insert(issues, "❌ JDTLS não instalado em: " .. jdtls_install)
  else
    table.insert(issues, "✅ JDTLS encontrado em: " .. jdtls_install)
    
    -- Verificar launcher
    local launcher_jar = vim.fn.glob(jdtls_install .. "/plugins/org.eclipse.equinox.launcher_*.jar")
    if launcher_jar == "" then
      table.insert(issues, "❌ Launcher JAR não encontrado")
    else
      table.insert(issues, "✅ Launcher JAR encontrado")
    end
  end
  
  -- Verificar bundles de debug/test
  local debug_jars = vim.split(vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n")
  local test_jars = vim.split(vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/java-test/extension/server/*.jar"), "\n")
  
  local debug_count = 0
  for _, jar in ipairs(debug_jars) do
    if jar ~= "" then debug_count = debug_count + 1 end
  end
  
  local test_count = 0
  for _, jar in ipairs(test_jars) do
    if jar ~= "" then test_count = test_count + 1 end
  end
  
  if debug_count > 0 then
    table.insert(issues, "✅ " .. debug_count .. " debug bundles encontrados")
  else
    table.insert(issues, "⚠️  Nenhum debug bundle encontrado")
  end
  
  if test_count > 0 then
    table.insert(issues, "✅ " .. test_count .. " test bundles encontrados")
  else
    table.insert(issues, "⚠️  Nenhum test bundle encontrado")
  end
  
  -- Exibir diagnóstico
  vim.notify("=== Diagnóstico JDTLS ===", vim.log.levels.INFO)
  for _, issue in ipairs(issues) do
    vim.notify(issue, vim.log.levels.INFO)
  end
  
  return issues
end

function M.get_config()
  -- Standard nvim-jdtls paths
  local jdtls_install = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
  local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

  -- Enhanced installation check with specific guidance
  if vim.fn.isdirectory(jdtls_install) == 0 then
    vim.notify("JDTLS não encontrado em: " .. jdtls_install, vim.log.levels.ERROR)
    vim.notify("Execute: :MasonInstall jdtls", vim.log.levels.INFO)
    return nil
  end

  -- Create workspace directory with error handling
  local success, err = pcall(vim.fn.mkdir, workspace_dir, "p")
  if not success then
    vim.notify("Falha ao criar diretório workspace: " .. tostring(err), vim.log.levels.ERROR)
    return nil
  end
  
  -- Find launcher jar with better error reporting
  local launcher_jar = vim.fn.glob(jdtls_install .. "/plugins/org.eclipse.equinox.launcher_*.jar")
  if launcher_jar == "" then
    vim.notify("JDTLS launcher não encontrado em: " .. jdtls_install .. "/plugins/", vim.log.levels.ERROR)
    vim.notify("Verifique a instalação do JDTLS executando: :MasonInstall jdtls", vim.log.levels.INFO)
    return nil
  end
  
  -- OS-specific config with validation
  local os_config = jdtls_install .. "/config_" .. (vim.fn.has('mac') == 1 and "mac" or (vim.fn.has('win32') == 1 and "win" or "linux"))
  if vim.fn.isdirectory(os_config) == 0 then
    vim.notify("Configuração do OS não encontrada: " .. os_config, vim.log.levels.WARN)
  end

  -- Essential JVM flags for Java 17+ compatibility
  local cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.application",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=false",
    "-Dlog.level=ERROR",
    "-Xms1g",
    "-Xmx2G",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "--add-opens", "java.base/java.net=ALL-UNNAMED",
    "--add-opens", "java.base/java.nio=ALL-UNNAMED",
    "--add-opens", "java.base/java.util.concurrent=ALL-UNNAMED",
    "--add-opens", "java.base/sun.nio.ch=ALL-UNNAMED",
    "-jar", launcher_jar,
    "-configuration", os_config,
    "-data", workspace_dir,
  }

  -- Standard bundles for debugging and testing with validation
  local bundles = {}
  
  -- Java Debug Adapter bundles
  local debug_jars = vim.split(vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n")
  for _, jar in ipairs(debug_jars) do
    if jar ~= "" and vim.fn.filereadable(jar) == 1 then
      table.insert(bundles, jar)
    end
  end
  
  -- Java Test bundles
  local test_jars = vim.split(vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/java-test/extension/server/*.jar"), "\n")
  for _, jar in ipairs(test_jars) do
    if jar ~= "" and vim.fn.filereadable(jar) == 1 then
      table.insert(bundles, jar)
    end
  end
  
  -- Log bundle info for debugging
  if #bundles > 0 then
    vim.notify("Carregados " .. #bundles .. " bundles para debugging/testing", vim.log.levels.DEBUG)
  else
    vim.notify("Nenhum bundle de debug/test encontrado. Funcionalidades de debug podem não estar disponíveis.", vim.log.levels.WARN)
  end

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
