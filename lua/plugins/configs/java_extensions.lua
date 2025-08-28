return {
  -- Java Debug e Java Test Extension para JDTLS
  {
    "mfussenegger/nvim-jdtls",
    dependencies = {
      {
        "microsoft/java-debug",
        build = function()
          local debug_path = vim.fn.stdpath('data') .. "/lazy/java-debug"
          vim.notify("Compilando java-debug...", vim.log.levels.INFO)
          vim.fn.jobstart({
            "bash", "-c", 
            "cd " .. debug_path .. " && chmod +x ./mvnw && ./mvnw clean install -DskipTests"
          }, {
            on_exit = function(_, code)
              if code == 0 then
                vim.notify("java-debug compilado com sucesso!", vim.log.levels.INFO)
              else
                vim.notify("Falha ao compilar java-debug. Execute o script scripts/compile_java_debug.sh manualmente.", vim.log.levels.ERROR)
              end
            end
          })
        end,
        dir = vim.fn.stdpath('data') .. "/lazy/java-debug",
        url = "https://github.com/microsoft/java-debug",
      },
      {
        "microsoft/vscode-java-test",
        build = function()
          local test_path = vim.fn.stdpath('data') .. "/lazy/vscode-java-test"
          vim.notify("Compilando vscode-java-test...", vim.log.levels.INFO)
          vim.fn.jobstart({
            "bash", "-c",
            "cd " .. test_path .. " && npm install && (npm run build-plugin || npm run build || npm run compile)"
          }, {
            on_exit = function(_, code)
              if code == 0 then
                vim.notify("vscode-java-test compilado com sucesso!", vim.log.levels.INFO)
              else
                vim.notify("Falha ao compilar vscode-java-test. Execute o script scripts/compile_java_test.sh manualmente.", vim.log.levels.ERROR)
              end
            end
          })
        end,
        dir = vim.fn.stdpath('data') .. "/lazy/vscode-java-test",
        url = "https://github.com/microsoft/vscode-java-test",
      }
    },
    ft = { "java" },
  }
}