local opt = vim.opt

-- Indentação
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 2
opt.softtabstop = 4
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

-- Verificar e criar diretório de undo
pcall(function()
  local undodir = vim.fn.stdpath('data') .. "/undodir"
  if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
  end
end)

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
