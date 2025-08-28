-- Configuração para Java
local M = {}

-- Configurações do formatador (usando apenas IntelliJ)
M.formatter = {
  profile = "IntelliJIDEA",
  file = "eclipse-java-intellij-style.xml",
  line_length = 120
}

-- Inicialização das configurações Java
function M.setup()
  -- Verificar diretório de formatadores
  local format_dir = vim.fn.stdpath("config") .. "/formatters"
  local style_file = format_dir .. "/" .. M.formatter.file
  
  -- Criar diretório se não existir
  if vim.fn.isdirectory(format_dir) == 0 then
    vim.fn.mkdir(format_dir, "p")
  end
  
  -- Verificar se arquivo de estilo existe
  if vim.fn.filereadable(style_file) == 0 then
    vim.notify("Arquivo de estilo Java não encontrado: " .. style_file, vim.log.levels.WARN)
  end

  -- Limpar logs antigos
  M.clean_logs()
  
  -- Configurar filtros de log específicos para Java
  local log_manager = require("utils.lsp_log_manager")
  log_manager.log_filters["jdtls"] = {
    patterns = {
      "WARNING: Using incubator modules:",
      "org.apache.aries.spifly.BaseActivator",
      "INFORMAÇÕES: Registered provider",
      "ago%.%s+%d+,%s+%d+%s+%d+:%d+:%d+"
    }
  }
end

-- Limpar logs antigos
function M.clean_logs()
  local log_path = vim.fn.stdpath("state") .. "/lsp.log"
  if vim.fn.filereadable(log_path) == 1 then
    local file_size = vim.fn.getfsize(log_path)
    -- Limpar se for maior que 1MB
    if file_size > 1024 * 1024 then
      local f = io.open(log_path, "w")
      if f then
        f:write("-- Log limpo automaticamente em " .. os.date() .. " --\n")
        f:close()
        vim.notify("Log LSP limpo automaticamente", vim.log.levels.INFO)
      end
    end
  end
end

-- Obter configurações de formatação
function M.get_formatter_config()
  return {
    enabled = true,
    settings = {
      url = vim.fn.stdpath("config") .. "/formatters/" .. M.formatter.file,
      profile = M.formatter.profile
    }
  }
end

return M