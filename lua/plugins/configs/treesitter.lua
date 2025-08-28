return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate", -- Comando para atualizar/instalar parsers
    event = { "BufReadPost", "BufNewFile" }, -- Carregar quando um buffer for lido ou novo arquivo criado
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects", -- Para text objects avançados
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        -- Lista de linguagens para instalar parsers. "all" para todas as suportadas.
        ensure_installed = {
          "bash",
          "c",
          "cpp",
          "go",
          "html",
          "javascript",
          "json",
          "lua",
          "python",
          "rust",
          "scss",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "yaml",
        },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = true,
        },
        indent = {
          enable = true,
          -- disable = { "python" },
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>", -- Iniciar seleção incremental
            node_incremental = "<CR>", -- Incrementar seleção para o próximo nó
            scope_incremental = "<TAB>", -- Incrementar para o escopo do nó (ex: conteúdo da função)
            node_decremental = "<S-TAB>", -- Decrementar seleção
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Olhar à frente para seleções mais inteligentes
            keymaps = {
              -- Mapeamentos padrão:
              -- "af" = "@function.outer", "if" = "@function.inner"
              -- "ac" = "@class.outer", "ic" = "@class.inner"
              -- Para mais, veja :h nvim-treesitter-textobjects-select-keymaps
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["al"] = "@loop.outer", -- around loop
              ["il"] = "@loop.inner", -- inside loop
              ["ai"] = "@conditional.outer", -- around if/else
              ["ii"] = "@conditional.inner", -- inside if/else
              ["a="] = "@assignment.outer", -- around assignment
              ["i="] = "@assignment.inner", -- inside assignment lhs+rhs
              ["a:"] = "@property.outer", -- around a property/field in a struct/object
              ["i:"] = "@property.inner",
              ['a"'] = "@string.outer",
              ['i"'] = "@string.inner",
              ["a'"] = "@string.outer", -- Assuming ' also delimits strings
              ["i'"] = "@string.inner",
              ["a`"] = "@string.outer", -- For template literals etc.
              ["i`"] = "@string.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- Adicionar saltos à jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>na"] = "@parameter.inner", -- swap_next_argument
            },
            swap_previous = {
              ["<leader>pa"] = "@parameter.inner", -- swap_previous_argument
            },
          },
        },
        -- Outras configurações do Treesitter podem ser adicionadas aqui
        -- Ex: nvim-ts-autotag para fechar tags HTML automaticamente
        autotag = { enable = true },
      })
      -- vim.diagnostic.disable_next_line({ "undefined-global" })
    end,
  },

  -- (Opcional, mas útil) Autotag para HTML/XML
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "xml", "javascriptreact", "typescriptreact", "svelte", "vue" },
    config = function()
      require("nvim-ts-autotag").setup({
        -- Opções, se necessário
        -- enable_rename = true,
        -- enable_close = true,
        -- enable_close_on_slash = true,
      })
    end,
  },
}
