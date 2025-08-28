-- lua/utils/jdtls.lua
local M = {}

function M.get_config()
  local home = os.getenv("HOME")
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
  
  -- Detectar versão do Java
  local java_version
  local handle = io.popen("java -version 2>&1 | awk -F'\"' '/version/ {print $2}'")
  if handle then
    java_version = handle:read("*a"):gsub("[\n\r]", "")
    handle:close()
  end
  
  local is_java_17_plus = false
  local is_java_21_plus = false
  if java_version then
    local major_version = tonumber(java_version:match("^(%d+)"))
    is_java_17_plus = major_version and major_version >= 17
    is_java_21_plus = major_version and major_version >= 21
  end
  
  -- Configurar bundles para debug e testes
  local bundles = {}
  
  -- Adicionar launcher do Eclipse
  local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
  if launcher_jar == "" then
    vim.notify("JDTLS launcher não encontrado", vim.log.levels.ERROR)
    return nil
  end
  
  -- Adicionar bundles de Java Debug e Java Test
  local plugin_paths = {
    -- Java Debug
    vim.fn.stdpath('data') .. "/lazy/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
    -- Java Test
    vim.fn.stdpath('data') .. "/lazy/vscode-java-test/server/*.jar"
  }
  
  -- Adicionar os bundles que existem
  for _, path in ipairs(plugin_paths) do
    local glob_result = vim.fn.glob(path, false, true)
    if type(glob_result) == "table" and #glob_result > 0 then
      vim.list_extend(bundles, glob_result)
    end
  end

  -- Configuração para o sistema operacional
  local os_config = jdtls_path .. "/config_linux"
  if vim.fn.has('mac') == 1 then
    os_config = jdtls_path .. "/config_mac"
  elseif vim.fn.has('win32') == 1 then
    os_config = jdtls_path .. "/config_win"
  end

  -- Verificar se a configuração do OS existe
  if vim.fn.isdirectory(os_config) == 0 then
    vim.notify("Configuração JDTLS para o OS não encontrada: " .. os_config, vim.log.levels.ERROR)
    return nil
  end

  -- Opções de JVM otimizadas para reduzir problemas
  local java_opts = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.application",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=false",     -- Reduzir logs de protocolo
    "-Dlog.level=ERROR",        -- Apenas erros no log
    "-Xms512m",                 -- Reduzir memória inicial
    "-Xmx2g",                   -- Reduzir memória máxima para 2GB
    "-XX:+UseG1GC",             -- Usar coletor G1 para melhor performance
    "-XX:+UseStringDeduplication",
    -- Suprimir warnings de módulos incubator para evitar exit code 13
    "-XX:+UnlockExperimentalVMOptions",
    "-XX:+IgnoreUnrecognizedVMOptions",
    "-Djava.awt.headless=true",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
  }

  -- Adicionar flags específicas para Java 17+
  if is_java_17_plus then
    table.insert(java_opts, "--add-opens")
    table.insert(java_opts, "java.base/sun.nio.fs=ALL-UNNAMED")
    table.insert(java_opts, "--add-opens")
    table.insert(java_opts, "java.base/java.io=ALL-UNNAMED")
    table.insert(java_opts, "--add-opens")
    table.insert(java_opts, "java.base/java.util.concurrent=ALL-UNNAMED")
    table.insert(java_opts, "--add-opens")
    table.insert(java_opts, "java.base/java.net=ALL-UNNAMED")
  end
  
  -- Adicionar flags específicas para Java 21+ (incubator modules)
  if is_java_21_plus then
    table.insert(java_opts, "--enable-preview")
    table.insert(java_opts, "--add-modules")
    table.insert(java_opts, "jdk.incubator.vector")
  end

  -- Adicionar configurações de log para reduzir mensagens desnecessárias
  table.insert(java_opts, "-Dorg.slf4j.simpleLogger.defaultLogLevel=error")
  table.insert(java_opts, "-Dorg.eclipse.jdt.core.compiler.problem.suppressWarnings=enabled")
  
  -- Suprimir warnings específicos que causam exit code 13  
  table.insert(java_opts, "-Djdk.incubator.vector.VECTOR_ACCESS_OOB_CHECK=0")

    -- Completar as opções
  table.insert(java_opts, "-jar")
  table.insert(java_opts, launcher_jar)
  table.insert(java_opts, "-configuration")
  table.insert(java_opts, os_config)
  table.insert(java_opts, "-data")
  table.insert(java_opts, workspace_dir)

  -- Carregamos a configuração Java customizada
  local java_config = require("utils.java_config")
  
  -- Configuração do JDTLS
  local config = {
    cmd = java_opts,
    root_dir = require("jdtls.setup").find_root({ "gradlew", "mvnw", ".git", "pom.xml", "build.gradle" }),
    settings = {
      java = {
        eclipse = { downloadSources = true },
        configuration = { updateBuildConfiguration = "interactive" },
        maven = { downloadSources = true },
        implementationsCodeLens = { enabled = true },
        referencesCodeLens = { enabled = true },
        format = java_config.get_formatter_config(),
        signatureHelp = { enabled = true },
        completion = {
          favoriteStaticMembers = {
            "org.junit.jupiter.api.Assertions.*",
            "java.util.Objects.requireNonNull",
            "java.util.Objects.requireNonNullElse"
          }
        }
      }
    },
    handlers = {
      ['workspace/executeClientCommand'] = function() return {} end,
    },
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    init_options = {
      bundles = bundles,
      extendedClientCapabilities = {
        progressReportProvider = true,
        classFileContentsSupport = true
      }
    }
  }

  return config
end

return M
