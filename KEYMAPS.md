# Neovim Configuration - Cheatsheet de Keymaps

Este documento contém todos os mapeamentos de teclas (keymaps) configurados nesta configuração do Neovim, organizados por funcionalidade.

## Índice

- [Geral](#geral)
- [Navegação entre Janelas](#navegação-entre-janelas)
- [Gerenciamento de Buffers](#gerenciamento-de-buffers)
- [Edição](#edição)
- [Movimentação de Linhas](#movimentação-de-linhas)
- [Explorador de Arquivos (NvimTree)](#explorador-de-arquivos-nvimtree)
- [Busca de Arquivos (Telescope)](#busca-de-arquivos-telescope)
- [LSP (Language Server Protocol)](#lsp-language-server-protocol)
- [Git (GitSigns)](#git-gitsigns)
- [Treesitter](#treesitter)
- [Comentários](#comentários)
- [Autocompletar (nvim-cmp)](#autocompletar-nvim-cmp)
- [Utilitários](#utilitários)

---

## Geral

| Teclas | Modo | Descrição |
|--------|------|-----------|
| `<leader>w` | Normal | Salvar arquivo |
| `<leader>q` | Normal | Fechar janela |
| `<leader>h` | Normal | Limpar busca (remover highlight) |

---

## Navegação entre Janelas

| Teclas | Modo | Descrição |
|--------|------|-----------|
| `<C-h>` | Normal | Navegar para janela à esquerda |
| `<C-j>` | Normal | Navegar para janela abaixo |
| `<C-k>` | Normal | Navegar para janela acima |
| `<C-l>` | Normal | Navegar para janela à direita |

### Redimensionar Janelas

| Teclas | Modo | Descrição |
|--------|------|-----------|
| `<C-Up>` | Normal | Aumentar altura da janela |
| `<C-Down>` | Normal | Diminuir altura da janela |
| `<C-Left>` | Normal | Diminuir largura da janela |
| `<C-Right>` | Normal | Aumentar largura da janela |

---

## Gerenciamento de Buffers

| Teclas | Modo | Descrição |
|--------|------|-----------|
| `<S-h>` | Normal | Buffer anterior |
| `<S-l>` | Normal | Próximo buffer |
| `<leader>bd` | Normal | Fechar buffer |

---

## Edição

| Teclas | Modo | Descrição |
|--------|------|-----------|
| `<` | Visual | Recuar seleção (manter seleção) |
| `>` | Visual | Avançar seleção (manter seleção) |
| `p` | Visual | Colar sem sobrescrever o registro |

---

## Movimentação de Linhas

| Teclas | Modo | Descrição |
|--------|------|-----------|
| `<A-j>` | Normal | Mover linha para baixo |
| `<A-k>` | Normal | Mover linha para cima |
| `<A-j>` | Insert | Mover linha para baixo |
| `<A-k>` | Insert | Mover linha para cima |
| `<A-j>` | Visual | Mover seleção para baixo |
| `<A-k>` | Visual | Mover seleção para cima |

---

## Explorador de Arquivos (NvimTree)

| Teclas | Modo | Descrição |
|--------|------|-----------|
| `<leader>e` | Normal | Abrir/fechar explorador de arquivos |

---

## Busca de Arquivos (Telescope)

### Buscas Básicas

| Teclas | Modo | Descrição |
|--------|------|-----------|
| `<leader>ff` | Normal | Buscar arquivos |
| `<leader>fg` | Normal | Buscar texto (live grep) |
| `<leader>fb` | Normal | Buscar buffers |
| `<leader>fh` | Normal | Buscar ajuda (help tags) |

### Buscas Avançadas

| Teclas | Modo | Descrição |
|--------|------|-----------|
| `<leader>fo` | Normal | Arquivos recentes (oldfiles) |
| `<leader>fc` | Normal | Buscar comandos |
| `<leader>f;` | Normal | Histórico de comandos |
| `<leader>fk` | Normal | Buscar mapeamentos de teclas |
| `<leader>f/` | Normal | Fuzzy find no buffer atual |

### LSP no Telescope

| Teclas | Modo | Descrição |
|--------|------|-----------|
| `<leader>D` | Normal | Símbolos do documento (LSP) |
| `<leader>ds` | Normal | Símbolos do workspace (LSP) |
| `<leader>dl` | Normal | Diagnósticos do workspace |

### Navegação no Telescope

| Teclas | Modo | Descrição |
|--------|------|-----------|
| `<C-j>` | Insert/Normal | Mover seleção para baixo |
| `<C-k>` | Insert/Normal | Mover seleção para cima |
| `<C-q>` | Insert/Normal | Enviar selecionados para quickfix |
| `<Esc>` | Insert | Fechar Telescope |
| `q` | Normal | Fechar Telescope |

---

## LSP (Language Server Protocol)

### Diagnósticos

| Teclas | Modo | Descrição |
|--------|------|-----------|
| `[d` | Normal | Diagnóstico anterior |
| `]d` | Normal | Próximo diagnóstico |
| `<leader>de` | Normal | Mostrar erros em float |

### Navegação e Informações

| Teclas | Modo | Descrição |
|--------|------|-----------|
| `K` | Normal | Mostrar documentação (hover) |
| `gD` | Normal | Ir para declaração |
| `gd` | Normal | Ir para definição |
| `gi` | Normal | Ir para implementação |
| `gr` | Normal | Mostrar referências |
| `gt` | Normal | Ir para definição de tipo |

### Ações de Código

| Teclas | Modo | Descrição |
|--------|------|-----------|
| `<leader>rn` | Normal | Renomear símbolo |
| `<leader>ca` | Normal/Visual | Ações de código |
| `<leader>fm` | Normal | Formatar código |

### Java Específico (JDTLS)

| Teclas | Modo | Descrição |
|--------|------|-----------|
| `<leader>jo` | Normal | Organizar imports |
| `<leader>jt` | Normal | Testar classe |
| `<leader>jn` | Normal | Testar método mais próximo |
| `<leader>je` | Normal/Visual | Extrair variável |
| `<leader>jc` | Normal/Visual | Extrair constante |
| `<leader>jf` | Normal | Formatar código |
| `<leader>jl` | Normal | Limpar logs |

---

## Git (GitSigns)

### Navegação entre Hunks

| Teclas | Modo | Descrição |
|--------|------|-----------|
| `]h` | Normal | Próximo hunk |
| `[h` | Normal | Hunk anterior |

### Ações nos Hunks

| Teclas | Modo | Descrição |
|--------|------|-----------|
| `<leader>hs` | Normal/Visual | Stage hunk |
| `<leader>hr` | Normal/Visual | Reset hunk |
| `<leader>hp` | Normal | Preview hunk |
| `ih` | Operator/Visual | Selecionar hunk (text object) |

### Ações no Buffer

| Teclas | Modo | Descrição |
|--------|------|-----------|
| `<leader>hS` | Normal | Stage buffer |
| `<leader>hR` | Normal | Reset buffer |
| `<leader>hu` | Normal | Undo stage hunk |

### Informações Git

| Teclas | Modo | Descrição |
|--------|------|-----------|
| `<leader>hb` | Normal | Blame linha (completo) |
| `<leader>htb` | Normal | Toggle blame linha atual |
| `<leader>hd` | Normal | Diff this |
| `<leader>hD` | Normal | Diff this (HEAD) |
| `<leader>td` | Normal | Toggle deleted lines |

---

## Treesitter

### Seleção Incremental

| Teclas | Modo | Descrição |
|--------|------|-----------|
| `<CR>` | Normal | Iniciar/incrementar seleção |
| `<TAB>` | Normal | Incrementar para escopo |
| `<S-TAB>` | Normal | Decrementar seleção |

### Text Objects

| Teclas | Modo | Descrição |
|--------|------|-----------|
| `af`/`if` | Operator/Visual | Around/inside function |
| `ac`/`ic` | Operator/Visual | Around/inside class |
| `aa`/`ia` | Operator/Visual | Around/inside parameter |
| `al`/`il` | Operator/Visual | Around/inside loop |
| `ai`/`ii` | Operator/Visual | Around/inside conditional |
| `a=`/`i=` | Operator/Visual | Around/inside assignment |
| `a:`/`i:` | Operator/Visual | Around/inside property |
| `a"`/`i"` | Operator/Visual | Around/inside string (") |
| `a'`/`i'` | Operator/Visual | Around/inside string (') |
| `a`` `/`i`` ` | Operator/Visual | Around/inside string (`) |

### Movimentação

| Teclas | Modo | Descrição |
|--------|------|-----------|
| `]m` | Normal | Próximo início de função |
| `]M` | Normal | Próximo fim de função |
| `[m` | Normal | Início de função anterior |
| `[M` | Normal | Fim de função anterior |
| `]]` | Normal | Próximo início de classe |
| `][` | Normal | Próximo fim de classe |
| `[[` | Normal | Início de classe anterior |
| `[]` | Normal | Fim de classe anterior |

### Trocar Elementos

| Teclas | Modo | Descrição |
|--------|------|-----------|
| `<leader>na` | Normal | Trocar com próximo parâmetro |
| `<leader>pa` | Normal | Trocar com parâmetro anterior |

---

## Comentários

| Teclas | Modo | Descrição |
|--------|------|-----------|
| `gcc` | Normal | Comentar/descomentar linha atual |
| `gc` | Normal/Visual | Comentar/descomentar (linha/visual) |
| `gbc` | Normal | Comentar/descomentar bloco atual |
| `gb` | Normal/Visual | Comentar/descomentar em bloco |

---

## Autocompletar (nvim-cmp)

| Teclas | Modo | Descrição |
|--------|------|-----------|
| `<C-Space>` | Insert | Ativar completar |
| `<C-e>` | Insert | Abortar completar |
| `<CR>` | Insert | Confirmar seleção |
| `<Tab>` | Insert | Próximo item / expandir snippet |
| `<S-Tab>` | Insert | Item anterior / voltar no snippet |
| `<C-b>` | Insert | Rolar documentação para cima |
| `<C-f>` | Insert | Rolar documentação para baixo |

---

## Utilitários

| Teclas | Modo | Descrição |
|--------|------|-----------|
| `<leader>?` | Normal | Mostrar keymaps do buffer (which-key) |

---

## Nota sobre a Tecla Leader

A tecla `<leader>` é configurada por padrão como a tecla espaço (` `) no Neovim. Portanto, quando você vir `<leader>w`, isso significa pressionar `Espaço + w`.

## Modifiers

- `<C-x>` = Ctrl + x
- `<A-x>` = Alt + x  
- `<S-x>` = Shift + x
- `<leader>` = Espaço (por padrão)

## Modos

- **Normal**: Modo de navegação padrão
- **Insert**: Modo de inserção de texto
- **Visual**: Modo de seleção de texto
- **Operator**: Aguardando um operador (como depois de `d`, `c`, `y`)