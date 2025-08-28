return {
  -- Statusline minimalista e informativa
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",                               -- Carregar um pouco mais tarde
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- Para ícones (opcional)
    config = function()
      local lualine = require("lualine")
      local lualine_theme = "auto"
      lualine.setup({
        options = {
          theme = lualine_theme,
          icons_enabled = true,
          component_separators = "", -- Sem separadores de componentes
          section_separators = "",   -- Sem separadores de seções
          disabled_filetypes = {
            statusline = { "dashboard", "NvimTree", "alpha" },
            winbar = {},
          },
          always_divide_middle = true,
          globalstatus = true, -- Uma única statusline para todas as janelas
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            {
              "filename",
              path = 1,             -- 0: apenas nome, 1: relativo ao cwd, 2: absoluto, 3: relativo ao projeto
              shorting_target = 40, -- Comprimento máximo antes de encurtar
            },
            {
              "diagnostics",
              sources = { "nvim_diagnostic" }, -- "nvim_lsp" para apenas LSP, "nvim_diagnostic" para todos
              symbols = { error = " ", warn = " ", info = " ", hint = " " },
            },
          },
          lualine_x = { "filetype" },
          lualine_y = { "progress" }, -- Progresso no arquivo (ex: 75%)
          lualine_z = { "location" }, -- Linha e coluna (ex: Ln 10, Col 5)
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {}, -- Tabline vazia por padrão
        winbar = {},
        inactive_winbar = {},
        extensions = { "nvim-tree", "toggleterm", "lazy" }, -- Integrações com outros plugins
      })
    end,
  },

  -- Comentários fáceis
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    keys = {
      { "gc",  mode = { "n", "v" }, desc = "Comentar/descomentar (linha/visual)" },
      { "gcc", mode = "n",          desc = "Comentar/descomentar linha atual" },
      { "gbc", mode = "n",          desc = "Comentar/descomentar bloco atual (com movimento)" },
      { "gb",  mode = { "n", "v" }, desc = "Comentar/descomentar em bloco (visual)" },
    },
    config = function()
      require("Comment").setup({
        -- Mapeamentos padrão gcc (normal) e gc (visual) são bons
        -- Mapeamentos personalizados podem ser adicionados aqui se necessário
        -- Por exemplo, para usar <leader>/
        --toggler = {
        --line = '<leader>/',
        --block = '<leader>/',
        --},
        --opleader = {
        --line = '<leader>/',
        --block = '<leader>/',
        --},
      })
    end,
  },

  -- Autopreenchimento de pares
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",                  -- Carregar ao entrar no modo de inserção
    opts = {
      check_ts = true,                      -- Usar Treesitter para verificar contexto (evitar autopair em strings/comentários)
      ts_config = {
        lua = { "string" },                 -- Não autopair dentro de strings Lua
        javascript = { "template_string" }, -- Idem para template strings JS
        java = false,                       -- Desabilitar verificação TS para Java se causar problemas
      },
      disable_filetype = { "TelescopePrompt", "spectre_panel", "neogitstatus", "NvimTree" },
      -- fast_wrap = {}, -- Para adicionar wrap com <leader> + char
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)
      -- A integração com nvim-cmp (para a tecla <CR>) é feita no arquivo de configuração do nvim-cmp.
    end,
  },

  -- File Explorer
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      view = {
        width = 30,
        side = "left",
      },
      renderer = {
        group_empty = true,
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
        },
      },
      filters = {
        dotfiles = false,
        git_ignored = false,
      },
      git = {
        enable = true,
        ignore = false,
      },
      actions = {
        open_file = {
          quit_on_open = false,
          resize_window = true,
        },
      },
    },
    config = function(_, opts)
      -- Desabilitar netrw para evitar conflitos
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      
      require("nvim-tree").setup(opts)
    end,
  },

  -- Notificações (para cmdheight = 0 e melhor feedback visual)
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      background_colour = "#000000", -- Cor de fundo (pode ser ajustada pelo tema Catppuccin)
      fps = 30,
      icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = "",
        TRACE = "✎",
      },
      level = vim.log.levels.INFO,  -- Nível mínimo para mostrar notificações
      minimum_width = 50,
      render = "default",           -- 'default', 'minimal', 'compact'
      stages = "fade_in_slide_out", -- Animação
      timeout = 3000,               -- Tempo em ms para notificações desaparecerem
      top_down = true,
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify -- Substitui o vim.notify padrão
    end,
  },

  -- Which-key: Menu de ajuda para keymaps
  -- Configuração abrangente com mais de 50 keymaps organizados por categoria
  -- Inclui ícones Unicode e emojis para melhor identificação visual
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      preset = "modern",
      delay = 200,
      expand = 1,
      notify = false,
      triggers = {
        { "<auto>", mode = "nxso" },
      },
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>b", group = "󰓩 Buffers" },
          { "<leader>d", group = "🔍 Diagnósticos" },
          { "<leader>f", group = "📁 Arquivos" },
          { "<leader>g", group = "󰊢 Git" },
          { "<leader>h", group = "󰊢 Git Hunks" },
          { "<leader>j", group = "☕ Java" },
          { "<leader>l", group = "🔧 LSP" },
          { "<leader>s", group = "🔍 Buscar" },
          { "<leader>t", group = "🔧 Toggle" },
          { "<leader>w", desc = "💾 Salvar arquivo" },
          { "<leader>q", desc = "❌ Fechar janela" },
          { "<leader>e", desc = "📂 Explorador" },
        },
      },
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
        ellipsis = "…",
        mappings = true,
        rules = false,
        colors = true,
        keys = {
          Up = " ",
          Down = " ",
          Left = " ",
          Right = " ",
          C = "󰘴 ",
          M = "󰘵 ",
          D = "󰘳 ",
          S = "󰘶 ",
          CR = "󰌑 ",
          Esc = "󱊷 ",
          ScrollWheelDown = "󱕐 ",
          ScrollWheelUp = "󱕑 ",
          NL = "󰌑 ",
          BS = "󰁮",
          Space = "󱁐 ",
          Tab = "󰌒 ",
          F1 = "󱊫",
          F2 = "󱊬",
          F3 = "󱊭",
          F4 = "󱊮",
          F5 = "󱊯",
          F6 = "󱊰",
          F7 = "󱊱",
          F8 = "󱊲",
          F9 = "󱊳",
          F10 = "󱊴",
          F11 = "󱊵",
          F12 = "󱊶",
        },
      },
      win = {
        border = "rounded",
        position = "bottom",
        margin = { 1, 0, 1, 0 },
        padding = { 1, 2, 1, 2 },
        winblend = 0,
        zindex = 1000,
      },
      layout = {
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "left",
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      
      -- Registrar keymaps adicionais que podem não estar no spec
      wk.add({
        -- Geral
        { "<leader>w", desc = "💾 Salvar arquivo" },
        { "<leader>q", desc = "❌ Fechar janela" },
        { "<leader>h", desc = "🔍 Limpar busca" },
        { "<leader>e", desc = "📂 Explorador" },
        
        -- Buffers
        { "<leader>bd", desc = "❌ Fechar buffer" },
        
        -- Telescope
        { "<leader>ff", desc = "📄 Buscar arquivos" },
        { "<leader>fg", desc = "🔍 Live grep" },
        { "<leader>fb", desc = "📋 Listar buffers" },
        { "<leader>fh", desc = "❓ Tags de ajuda" },
        { "<leader>fo", desc = "📚 Arquivos recentes" },
        { "<leader>fc", desc = "⌨️  Comandos" },
        { "<leader>f;", desc = "📜 Histórico comandos" },
        { "<leader>fk", desc = "🔑 Mapeamentos teclas" },
        { "<leader>f/", desc = "🔍 Fuzzy find buffer" },
        
        -- LSP
        { "<leader>rn", desc = "✏️  Renomear símbolo" },
        { "<leader>ca", desc = "🔧 Ações de código" },
        { "<leader>fm", desc = "🎨 Formatar código" },
        { "<leader>de", desc = "🐛 Mostrar erros" },
        { "<leader>D", desc = "📋 Símbolos documento" },
        { "<leader>ds", desc = "🌐 Símbolos workspace" },
        { "<leader>dl", desc = "🔍 Diagnósticos" },
        
        -- Navegação LSP (não-leader)
        { "K", desc = "📖 Documentação (hover)" },
        { "gd", desc = "🎯 Ir para definição" },
        { "gD", desc = "🎯 Ir para declaração" },
        { "gi", desc = "🔗 Ir para implementação" },
        { "gr", desc = "🔍 Mostrar referências" },
        { "gt", desc = "🏷️  Ir para tipo" },
        { "[d", desc = "⬆️  Diagnóstico anterior" },
        { "]d", desc = "⬇️  Próximo diagnóstico" },
        
        -- Git Hunks
        { "<leader>hs", desc = "➕ Stage hunk", mode = { "n", "v" } },
        { "<leader>hr", desc = "🔄 Reset hunk", mode = { "n", "v" } },
        { "<leader>hS", desc = "➕ Stage buffer" },
        { "<leader>hu", desc = "⏪ Undo stage hunk" },
        { "<leader>hR", desc = "🔄 Reset buffer" },
        { "<leader>hp", desc = "👁️  Preview hunk" },
        { "<leader>hb", desc = "👤 Blame linha" },
        { "<leader>htb", desc = "🔄 Toggle blame" },
        { "<leader>hd", desc = "📊 Diff this" },
        { "<leader>hD", desc = "📊 Diff this (HEAD)" },
        { "[h", desc = "⬆️  Hunk anterior" },
        { "]h", desc = "⬇️  Próximo hunk" },
        
        -- Git text objects
        { "ih", desc = "🎯 Selecionar hunk", mode = { "o", "x" } },
        
        -- Java/JDTLS
        { "<leader>jo", desc = "📦 Organizar imports" },
        { "<leader>jt", desc = "🧪 Testar classe" },
        { "<leader>jn", desc = "🧪 Testar método" },
        { "<leader>je", desc = "📤 Extrair variável", mode = { "n", "v" } },
        { "<leader>jc", desc = "📤 Extrair constante", mode = { "n", "v" } },
        { "<leader>jf", desc = "🎨 Formatar código" },
        { "<leader>jl", desc = "🧹 Limpar logs" },
        
        -- Toggles
        { "<leader>td", desc = "👻 Toggle deleted" },
        
        -- Navegação entre buffers
        { "<S-h>", desc = "⬅️  Buffer anterior" },
        { "<S-l>", desc = "➡️  Próximo buffer" },
        
        -- Comentários 
        { "gc", desc = "💬 Comentar/descomentar", mode = { "n", "v" } },
        { "gcc", desc = "💬 Comentar linha atual" },
        { "gbc", desc = "💬 Comentar bloco" },
        { "gb", desc = "💬 Comentar bloco", mode = { "n", "v" } },
      })
    end,
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "📋 Keymaps buffer local",
      },
    },
  },
}
