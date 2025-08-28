-- Configuração do LSP para suprimir mensagens desnecessárias
local M = {}

-- Filtros para logs do LSP por cliente
M.log_filters = {
  -- Filtros para JDTLS (Java)
  ["jdtls"] = {
    patterns = {
      "WARNING: Using incubator modules:",
      "jdk%.incubator%.vector",
      "org.apache.aries.spifly.BaseActivator",
      "INFORMAÇÕES: Registered provider",
      "INFO: Registered provider", 
      "ago%.%s+%d+,%s+%d+%s+%d+:%d+:%d+",
      "Logback ServiceProvider",
      "BaseActivator log"
    }
  }
}

-- Configuração global de logs
function M.setup()
  -- Configurar nível de log
  vim.lsp.set_log_level("ERROR")
  
  -- Limitar tamanho do arquivo de log
  local log_path = vim.fn.stdpath("state") .. "/lsp.log"
  if vim.fn.filereadable(log_path) == 1 then
    local file_size = vim.fn.getfsize(log_path)
    -- Se o arquivo for maior que 1MB, limpe-o
    if file_size > 1024 * 1024 then
      local f = io.open(log_path, "w")
      if f then
        f:write("-- Log limpo automaticamente em " .. os.date() .. " --\n")
        f:close()
      end
    end
  end
  
  -- Filtrar mensagens do LSP
  local old_handler = vim.lsp.handlers["window/logMessage"]
  vim.lsp.handlers["window/logMessage"] = function(err, method, params, client_id)
    local client = vim.lsp.get_client_by_id(client_id)
    if client and client.name and M.log_filters[client.name] then
      local filters = M.log_filters[client.name]
      local msg = params.message or ""
      
      -- Verificar se a mensagem corresponde a algum padrão para filtrar
      for _, pattern in ipairs(filters.patterns) do
        if msg:match(pattern) then
          -- Reduzir o nível para DEBUG (geralmente ignorado)
          params.type = vim.lsp.protocol.MessageType.Log
          break
        end
      end
    end
    
    -- Chamar o manipulador original
    if old_handler then
      old_handler(err, method, params, client_id)
    end
  end
end

return M