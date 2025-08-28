-- Configuração de filtros para logs do LSP
-- Este módulo permite filtrar e personalizar mensagens de log do LSP

local M = {}

-- Filtros personalizados para mensagens de log do LSP
M.filters = {
  -- Filtrar avisos comuns do JDTLS
  ["java"] = {
    {
      pattern = "WARNING: Using incubator modules:",
      level = vim.log.levels.DEBUG  -- Rebaixar para DEBUG (não exibido por padrão)
    },
    {
      pattern = "INFORMAÇÕES: Registered provider",
      level = vim.log.levels.DEBUG
    },
    {
      pattern = "org.apache.aries.spifly.BaseActivator",
      level = vim.log.levels.DEBUG
    },
    {
      pattern = "ago.%s+%d+,%s+%d+%s+%d+:%d+:%d+",  -- Padrão para datas em português
      level = vim.log.levels.DEBUG
    }
  }
}

-- Função para configurar filtros de log
function M.setup()
  -- Configurar manipulador personalizado para logs do LSP
  local old_handler = vim.lsp.handlers["window/logMessage"]
  
  vim.lsp.handlers["window/logMessage"] = function(err, method, params, client_id)
    -- Verificar se devemos filtrar esta mensagem
    local client = vim.lsp.get_client_by_id(client_id)
    if client and client.name and M.filters[client.name] then
      local filters = M.filters[client.name]
      
      -- Verificar se a mensagem corresponde a algum dos padrões a serem filtrados
      for _, filter in ipairs(filters) do
        if params.message:match(filter.pattern) then
          -- Ajustar o nível de log conforme especificado no filtro
          params.type = filter.level
          break
        end
      end
    end
    
    -- Chamar o manipulador original com os parâmetros possivelmente modificados
    if old_handler then
      old_handler(err, method, params, client_id)
    end
  end
  
  -- Configurar para não mostrar mensagens DEBUG por padrão
  vim.lsp.set_log_level("WARN")
end

return M