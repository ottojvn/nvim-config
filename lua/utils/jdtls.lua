-- lua/utils/jdtls.lua
local M = {}

function M.get_config()
  local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

  -- Verificar se o JDTLS está instalado
  if vim.fn.isdirectory(jdtls_path) == 0 then
    vim.notify("JDTLS não encontrado. Execute :MasonInstall jdtls", vim.log.levels.WARN)
    return nil
  end

  -- Garantir que o diretório de workspace existe
  local util = require("utils")
  util.ensure_dir_exists(workspace_dir)
  
  -- Configurar bundles para debug e testes (seguindo padrão nvim-jdtls)
  local bundles = {}
  
  -- Adicionar launcher do Eclipse
  local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
  if launcher_jar == "" then
    vim.notify("JDTLS launcher não encontrado", vim.log.levels.ERROR)
    return nil
  end
  
  -- Bundles para Java Debug e Java Test (padrão nvim-jdtls)
  local debug_bundle = vim.fn.glob(vim.fn.stdpath('data') .. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true)
  if debug_bundle and #debug_bundle > 0 then
    table.insert(bundles, debug_bundle[1])
  end
  
  local test_bundle = vim.fn.glob(vim.fn.stdpath('data') .. "/mason/packages/java-test/extension/server/*.jar", true)
  if test_bundle and #test_bundle > 0 then
    vim.list_extend(bundles, test_bundle)
  end

  -- Configuração para o sistema operacional (padrão nvim-jdtls)
  local os_config
  if vim.fn.has('mac') == 1 then
    os_config = jdtls_path .. "/config_mac"
  elseif vim.fn.has('win32') == 1 then
    os_config = jdtls_path .. "/config_win"
  else
    os_config = jdtls_path .. "/config_linux"
  end

  -- Verificar se a configuração do OS existe
  if vim.fn.isdirectory(os_config) == 0 then
    vim.notify("Configuração JDTLS para o OS não encontrada: " .. os_config, vim.log.levels.ERROR)
    return nil
  end

  -- Opções de JVM simplificadas (seguindo padrões nvim-jdtls)
  local cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.application",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=false",
    "-Dlog.level=ERROR",
    "-Xms1g",
    "-Xmx2G",
    "-jar", launcher_jar,
    "-configuration", os_config,
    "-data", workspace_dir,
  }

  -- Adicionar flags para compatibilidade com Java 9+ (necessário para evitar exit code 13)
  table.insert(cmd, 2, "--add-modules=ALL-SYSTEM")
  table.insert(cmd, 3, "--add-opens")
  table.insert(cmd, 4, "java.base/java.util=ALL-UNNAMED")
  table.insert(cmd, 5, "--add-opens")
  table.insert(cmd, 6, "java.base/java.lang=ALL-UNNAMED")

  -- Configuração do JDTLS (seguindo padrões nvim-jdtls)
  local config = {
    cmd = cmd,
    root_dir = require("jdtls.setup").find_root({ "gradlew", "mvnw", ".git", "pom.xml", "build.gradle" }),
    settings = {
      java = {
        eclipse = { downloadSources = true },
        configuration = { updateBuildConfiguration = "interactive" },
        maven = { downloadSources = true },
        implementationsCodeLens = { enabled = true },
        referencesCodeLens = { enabled = true },
        signatureHelp = { enabled = true },
        completion = {
          favoriteStaticMembers = {
            "org.junit.jupiter.api.Assertions.*",
            "java.util.Objects.requireNonNull",
            "java.util.Objects.requireNonNullElse"
          }
        },
        format = {
          enabled = true,
          settings = {
            -- Configurações de formatação básicas (inline)
            org_eclipse_jdt_core_formatter_tabulation_char = "space",
            org_eclipse_jdt_core_formatter_tabulation_size = "4",
            org_eclipse_jdt_core_formatter_lineSplit = "120",
          }
        }
      }
    },
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    init_options = {
      bundles = bundles,
    }
  }

  return config
end

return M
