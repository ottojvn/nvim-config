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

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 1000
    end,
    opts = {
      layout = {
        height = {
          max = 20
        },
        width = {
          max = 80
        },
        spacing = 3,
        align = "center",
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      -- Seus registros de atalhos aqui
      -- Ex: wk.register({ ... })
    end,
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
}
