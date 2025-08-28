-- Bootstrap lazy.nvim
-- Carregar configurações básicas
local function safe_require(module)
  local success, result = pcall(require, module)
  if not success then
    success, result = pcall(require, "core." .. module)
    if not success then
      print("Erro ao carregar módulo: " .. module)
    end
  end
  return success
end

-- Carregar módulos essenciais
safe_require("options")
safe_require("keymaps")
safe_require("autocmds")

-- Instalar e configurar gerenciador de plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- IMPORTANTE: Para evitar o erro "Re-sourcing your config is not supported with lazy.nvim",
-- é recomendado não recarregar este arquivo diretamente após fazer alterações.
-- Em vez disso, saia do Neovim e inicie-o novamente.
-- Ou use o comando :Lazy sync para atualizar os plugins.

-- Carregar plugins
require("lazy").setup("plugins", {
  checker = {
    enabled = true,
    notify = false,
    frequency = 3600, -- verificar a cada hora
  },
  change_detection = { notify = false },
  install = { colorscheme = { "rose-pine" } },
  ui = { border = "rounded" },
  performance = {
    rtp = {
      disabled_plugins = {
        "netrwPlugin", "tohtml", 
      }
    }
  }
})
