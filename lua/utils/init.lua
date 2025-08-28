local M = {}

function M.ensure_dir_exists(path)
  if vim.fn.isdirectory(path) == 0 then
    local success, err = pcall(function() 
      vim.fn.mkdir(path, "p") 
    end)
    if not success then
      vim.notify("Erro ao criar diretório: " .. path .. " - " .. err, vim.log.levels.ERROR)
      return false
    end
    return true
  end
  return true
end

return M
