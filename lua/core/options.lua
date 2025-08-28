-- Configuração otimizada para Neovim
-- Configurações de opções globais do editor

local opt = vim.opt

-- Configurar tecla leader (deve ser definida o mais cedo possível)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Indentação (configuração consistente)
opt.expandtab = true
opt.tabstop = 2        -- Número de espaços que uma tab representa
opt.shiftwidth = 2     -- Número de espaços para indentação automática
opt.softtabstop = 2    -- Número de espaços ao usar tab no modo insert
opt.autoindent = true
opt.smartindent = true

-- Edição
opt.backspace = "indent,eol,start"
opt.wrap = false
opt.hidden = true

-- Persistência
opt.undofile = true
opt.swapfile = false
opt.undodir = vim.fn.stdpath('data') .. "/undodir"

-- Verificar e criar diretório de undo com melhor tratamento de erro
local function setup_undo_dir()
  local undodir = vim.fn.stdpath('data') .. "/undodir"
  local stat = vim.loop.fs_stat(undodir)
  
  if not stat then
    local success = vim.fn.mkdir(undodir, "p")
    if success == 0 then
      print("Erro: Não foi possível criar diretório de undo: " .. undodir)
      opt.undofile = false -- Desabilitar se não conseguir criar
    end
  end
end

setup_undo_dir()

-- Interface
opt.clipboard = "unnamedplus"
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.termguicolors = true
opt.cmdheight = 1
opt.showmode = false

-- Busca
opt.incsearch = true
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Outros
opt.mouse = 'a'
opt.updatetime = 300
opt.timeoutlen = 500
opt.completeopt = "menu,menuone,noselect"

-- Configurações visuais para diagnósticos (podem ser ajustadas pelo LSP)
vim.diagnostic.config({
    virtual_text = false, -- Desabilitar texto virtual inline por padrão (menos intrusivo)
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

-- Configurações de formatação para diagnósticos (ícones)
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

return {}
