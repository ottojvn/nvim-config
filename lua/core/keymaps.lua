-- Configuração de mapeamentos de teclas (keybindings)
-- Mapeamentos globais e atalhos personalizados

local map = vim.keymap.set

-- Mapeamentos gerais
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Salvar arquivo" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Fechar janela" })
map("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Limpar busca" })

-- Navegação entre janelas
map("n", "<C-h>", "<C-w>h", { desc = "Navegar para janela à esquerda" })
map("n", "<C-j>", "<C-w>j", { desc = "Navegar para janela abaixo" })
map("n", "<C-k>", "<C-w>k", { desc = "Navegar para janela acima" })
map("n", "<C-l>", "<C-w>l", { desc = "Navegar para janela à direita" })

-- Redimensionar janelas
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Aumentar altura" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Diminuir altura" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Diminuir largura" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Aumentar largura" })

-- Edição
map("v", "<", "<gv", { desc = "Recuar seleção" })
map("v", ">", ">gv", { desc = "Avançar seleção" })
map("v", "p", '"_dP', { desc = "Colar sem sobrescrever" })

-- Movimentação de linhas
map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Mover linha para baixo" })
map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Mover linha para cima" })
map("i", "<A-j>", "<Esc><cmd>m .+1<CR>==gi", { desc = "Mover linha para baixo" })
map("i", "<A-k>", "<Esc><cmd>m .-2<CR>==gi", { desc = "Mover linha para cima" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Mover seleção para baixo" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Mover seleção para cima" })

-- Buffers
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Buffer anterior" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Próximo buffer" })
map("n", "<leader>bd", "<cmd>bd<CR>", { desc = "Fechar buffer" })

-- NvimTree
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Abrir/fechar explorador" })

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Buscar arquivos" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Buscar texto" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Buscar buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Buscar ajuda" })

return {}
