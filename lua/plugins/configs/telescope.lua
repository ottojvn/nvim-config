return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope", -- Carregar ao chamar o comando Telescope
    dependencies = {
      "nvim-lua/plenary.nvim", -- Dependência essencial para Telescope
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        -- build = "make", -- Alternativa se cmake não estiver disponível ou preferido
        cond = function()
          -- Tentar compilar apenas se 'make' ou 'cmake' estiverem disponíveis
          return vim.fn.executable "cmake" == 1 or vim.fn.executable "make" == 1
        end,
        config = function()
          pcall(require('telescope').load_extension, 'fzf')
        end,
        enabled = vim.fn.executable "cmake" == 1 or vim.fn.executable "make" == 1, -- Habilitar apenas se compiladores estiverem presentes
      },
      -- Outras extensões úteis (opcionais):
      -- { "nvim-telescope/telescope-ui-select.nvim" }, -- Melhora vim.ui.select
      -- { "nvim-telescope/telescope-file-browser.nvim" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local builtin = require("telescope.builtin")

      telescope.setup({
        defaults = {
          layout_strategy = "horizontal", -- 'horizontal', 'vertical', 'flex', 'cursor'
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55, -- 55% da largura para preview
              results_width = 0.45,
            },
            vertical = {
              mirror = false,
            },
            flex = {
              flip_columns = 120, -- Inverter colunas se a largura for menor que 120
            },
            width = 0.9,  -- Largura do Telescope (90% da tela)
            height = 0.9, -- Altura do Telescope (90% da tela)
          },
          sorting_strategy = "ascending",
          winblend = 0, -- Transparência da janela (0 = opaco)
          border = {}, -- Estilo da borda (Catppuccin deve cuidar disso)
          borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' }, -- Para bordas arredondadas se não usar tema
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<Esc>"] = actions.close,
            },
            n = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["q"] = actions.close,
            },
          },
          -- Outras opções default...
          -- path_display = { "truncate" }, -- Como mostrar caminhos longos
          -- file_ignore_patterns = { "%.git/", "node_modules/" },
        },
        pickers = {
          -- Configurações específicas por picker
          find_files = {
            theme = "dropdown", -- Exemplo de tema específico para um picker
            hidden = true, -- Mostrar arquivos ocultos
            -- find_command = {'fd', '--type', 'f', '--hidden', '--exclude', '.git'} -- Comando personalizado
          },
          live_grep = {
            -- Adicionar rg_opts aqui se necessário
          },
          buffers = {
            sort_mru = true,
            ignore_current_buffer = true,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,                    -- Habilitar busca fuzzy com fzf
            override_generic_sorter = true,  -- Usar sorter do fzf para genéricos
            override_file_sorter = true,     -- Usar sorter do fzf para arquivos
            case_mode = "smart_case",        -- 'smart_case', 'ignore_case', 'respect_case'
          },
          -- Configurar outras extensões aqui, se adicionadas
          -- file_browser = {
          --   theme = "ivy",
          --   hijack_netrw = true, -- Substituir o Netrw
          -- },
        },
      })

      -- Carregar extensões explicitamente se necessário
      -- pcall(telescope.load_extension, "fzf") -- Já feito no config do plugin fzf-native
      -- pcall(telescope.load_extension, "file_browser")

      -- Mapeamentos de teclas para Telescope
      local map = vim.keymap.set
      map("n", "<leader>ff", function() builtin.find_files() end, { desc = "Telescope: Encontrar Arquivos" })
      map("n", "<leader>fg", function() builtin.live_grep() end, { desc = "Telescope: Live Grep" })
      map("n", "<leader>fb", function() builtin.buffers() end, { desc = "Telescope: Listar Buffers" })
      map("n", "<leader>fh", function() builtin.help_tags() end, { desc = "Telescope: Tags de Ajuda" })
      map("n", "<leader>fo", function() builtin.oldfiles() end, { desc = "Telescope: Arquivos Recentes" })
      map("n", "<leader>fc", function() builtin.commands() end, { desc = "Telescope: Comandos" })
      map("n", "<leader>f;", function() builtin.command_history() end, { desc = "Telescope: Histórico de Comandos" })
      map("n", "<leader>fk", function() builtin.keymaps() end, { desc = "Telescope: Mapeamentos de Teclas" })
      map("n", "<leader>f/", function() builtin.current_buffer_fuzzy_find() end, { desc = "Telescope: Fuzzy Find no Buffer Atual" })

      -- Mapeamentos relacionados ao LSP (alguns podem já estar no on_attach do LSP)
      map("n", "gr", function() builtin.lsp_references() end, { desc = "Telescope: Referências LSP" })
      map("n", "gd", function() builtin.lsp_definitions() end, { desc = "Telescope: Definições LSP (como alternativa)" })
      map("n", "gi", function() builtin.lsp_implementations() end, { desc = "Telescope: Implementações LSP" })
      map("n", "<leader>D", function() builtin.lsp_document_symbols() end, { desc = "Telescope: Símbolos do Documento (LSP)" })
      map("n", "<leader>ds", function() builtin.lsp_dynamic_workspace_symbols() end, { desc = "Telescope: Símbolos do Workspace (LSP)" })
      map("n", "<leader>dl", function() builtin.diagnostics() end, { desc = "Telescope: Diagnósticos (Workspace)" })
    end,
  },
}
