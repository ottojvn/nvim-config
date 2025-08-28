-- Configuração para Java
local M = {}

-- Configurações do formatador IntelliJ (inline, sem XML)
M.formatter_settings = {
  -- Configurações básicas de formatação IntelliJ
  ["org.eclipse.jdt.core.formatter.tabulation.char"] = "space",
  ["org.eclipse.jdt.core.formatter.tabulation.size"] = "4",
  ["org.eclipse.jdt.core.formatter.use_tabs_only_for_leading_indentations"] = "false",
  ["org.eclipse.jdt.core.formatter.lineSplit"] = "120",
  
  -- Chaves e blocos (IntelliJ style)
  ["org.eclipse.jdt.core.formatter.brace_position_for_block"] = "end_of_line",
  ["org.eclipse.jdt.core.formatter.brace_position_for_type_declaration"] = "end_of_line",
  ["org.eclipse.jdt.core.formatter.brace_position_for_method_declaration"] = "end_of_line",
  ["org.eclipse.jdt.core.formatter.brace_position_for_constructor_declaration"] = "end_of_line",
  ["org.eclipse.jdt.core.formatter.brace_position_for_enum_declaration"] = "end_of_line",
  ["org.eclipse.jdt.core.formatter.brace_position_for_annotation_type_declaration"] = "end_of_line",
  
  -- Espaçamento (IntelliJ style)
  ["org.eclipse.jdt.core.formatter.insert_space_before_opening_brace_in_block"] = "insert",
  ["org.eclipse.jdt.core.formatter.insert_space_before_opening_brace_in_method_declaration"] = "insert",
  ["org.eclipse.jdt.core.formatter.insert_space_before_opening_brace_in_type_declaration"] = "insert",
  ["org.eclipse.jdt.core.formatter.insert_space_after_comma_in_method_declaration_parameters"] = "insert",
  ["org.eclipse.jdt.core.formatter.insert_space_after_comma_in_method_invocation_arguments"] = "insert",
  
  -- Quebras de linha
  ["org.eclipse.jdt.core.formatter.blank_lines_before_method"] = "1",
  ["org.eclipse.jdt.core.formatter.blank_lines_before_field"] = "0",
  ["org.eclipse.jdt.core.formatter.blank_lines_before_first_class_body_declaration"] = "0",
  
  -- Comentários
  ["org.eclipse.jdt.core.formatter.comment.line_length"] = "120",
  ["org.eclipse.jdt.core.formatter.comment.format_block_comments"] = "true",
  ["org.eclipse.jdt.core.formatter.comment.format_javadoc_comments"] = "true"
}

-- Inicialização das configurações Java
function M.setup()
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

-- Obter configurações de formatação (inline, sem arquivos XML)
function M.get_formatter_config()
  return {
    enabled = true,
    settings = M.formatter_settings
  }
end

return M