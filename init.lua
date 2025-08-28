-- Bootstrap lazy.nvim
-- Configuração principal do Neovim com lazy.nvim

-- Carregar configurações básicas
local function safe_require(module)
  local success, result = pcall(require, "core." .. module)
  if not success then
    print("Erro ao carregar módulo core." .. module .. ": " .. result)
    return false
  end
  return true
end

-- Carregar módulos essenciais
safe_require("options")
safe_require("keymaps")
safe_require("autocmds")

-- Instalar e configurar gerenciador de plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

-- Carregar plugins com tratamento de erro
local lazy_setup_ok, lazy_error = pcall(function()
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
end)

if not lazy_setup_ok then
  print("Erro ao configurar plugins: " .. lazy_error)
end
