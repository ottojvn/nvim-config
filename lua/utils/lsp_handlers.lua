-- Adicionar handlers globais para comandos específicos do LSP
local enhance_handlers = function()
  -- Criar um handler vazio para o comando executeClientCommand do JDTLS
  vim.lsp.handlers["workspace/executeClientCommand"] = function()
    return {}
  end
  
  -- Melhorar o handler de diagnósticos para melhor visibilidade
  local orig_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]
  vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, method, result, client_id, bufnr, config)
    -- Chamada ao handler original
    orig_handler(err, method, result, client_id, bufnr, config)
    
    -- Verificar se há erros para este buffer
    local diagnostics = vim.diagnostic.get(bufnr)
    if #diagnostics > 0 then
      -- Imprimir mensagem mais amigável para erros do JDTLS
      for _, diagnostic in ipairs(diagnostics) do
        if diagnostic.source == "jdtls" and diagnostic.severity == vim.diagnostic.severity.ERROR then
          vim.api.nvim_echo({
            {"JDTLS: ", "WarningMsg"},
            {diagnostic.message, "Normal"}
          }, false, {})
          break -- Apenas mostra o primeiro erro para não sobrecarregar
        end
      end
    end
  end
end

return {
  enhance_handlers = enhance_handlers
}