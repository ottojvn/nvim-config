-- LSP e completions
return {
  {
    "williamboman/mason.nvim",
    priority = 100, -- Garantir que o Mason seja carregado primeiro
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    },
    build = ":MasonUpdate",
    config = function(_, opts)
      require("mason").setup(opts)
    end
  },

  {
    "williamboman/mason-lspconfig.nvim",
    priority = 90,
    dependencies = { 
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig"
    },
    opts = {
      ensure_installed = {
        "lua_ls", "clangd", "csharp_ls", "html", "cssls", "ts_ls", "jsonls",
        "jdtls", "gopls", "pyright", "marksman", "rust_analyzer", "yamlls"
      }
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
    end
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    priority = 80,
    dependencies = {
      { "williamboman/mason.nvim", lazy = false },
      { "williamboman/mason-lspconfig.nvim", lazy = false },
      "hrsh7th/cmp-nvim-lsp",
      {
        "mfussenegger/nvim-jdtls",
        ft = "java",
      },
      {
        "folke/neodev.nvim",
        ft = "lua",
      }
    },
    config = function()
      -- Inicializar o neodev antes de qualquer configuração do LSP
      require("neodev").setup({})
      
      -- Configurar handlers globais para o LSP
      if package.loaded["utils.lsp_handlers"] then
        require("utils.lsp_handlers").enhance_handlers()
      end
      
      -- Configurar gerenciador de logs
      if package.loaded["utils.lsp_log_manager"] then
        require("utils.lsp_log_manager").setup()
      end
      
      -- Configurar filtros de log
      if package.loaded["utils.lsp_log_filter"] then
        require("utils.lsp_log_filter").setup()
      end

      -- Diagnósticos
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          source = "if_many",
        },
        float = {
          source = "always",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
      })

      -- Icones para diagnósticos
      for type, icon in pairs({ Error = " ", Warn = " ", Hint = " ", Info = " " }) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      -- Keymaps globais
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Diagnóstico anterior" })
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Próximo diagnóstico" })
      vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, { desc = "Mostrar erros" })

      -- Auto comandos
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local bufnr = ev.buf

          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = "LSP: " .. desc })
          end

          -- Keymaps padrão para LSP
          map("n", "K", vim.lsp.buf.hover, "Mostrar documentação")
          map("n", "gi", vim.lsp.buf.implementation, "Ir para implementação")
          map("n", "gr", vim.lsp.buf.references, "Mostrar referências")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Renomear símbolo")
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Ações de código")
          map("n", "gD", vim.lsp.buf.declaration, "Ir para declaração")
          map("n", "gd", vim.lsp.buf.definition, "Ir para definição")
          map("n", "gt", vim.lsp.buf.type_definition, "Ir para definição de tipo")
          map("n", "<leader>fm", function() vim.lsp.buf.format({ async = true }) end, "Formatar código")
        end,
      })

      -- Capacidades do cliente
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
      
      -- Obter módulos
      local lspconfig = require("lspconfig")
      
      -- Configurar servidor Lua manualmente (evitando dependência do mason-lspconfig)
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          }
        }
      })
      
      -- Tentar usar mason-lspconfig para outros servidores
      local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
      if status_ok and mason_lspconfig.setup_handlers then
        mason_lspconfig.setup_handlers({
          function(server_name)
            -- Pular servidores já configurados ou que precisam de config especial
            if server_name ~= "lua_ls" and server_name ~= "jdtls" then
              lspconfig[server_name].setup({ capabilities = capabilities })
            end
          end,
        })
      else
        -- Configuração manual dos servidores se mason-lspconfig não estiver disponível
        local servers = { "clangd", "cssls", "html", "ts_ls", "jsonls", "pyright", "rust_analyzer" }
        for _, server in ipairs(servers) do
          if lspconfig[server] then
            lspconfig[server].setup({ capabilities = capabilities })
          end
        end
        
        print("Aviso: mason-lspconfig não encontrado ou setup_handlers indisponível. Usando configuração manual.")
      end

      -- Configuração para Java
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()
          -- Inicializar configurações Java de forma segura
          local java_config_ok, java_config = pcall(require, "utils.java_config")
          if java_config_ok then
            java_config.setup()
          end
          
          -- Carregar configuração JDTLS de forma segura
          local jdtls_ok, jdtls_util = pcall(require, "utils.jdtls")
          if jdtls_ok then
            local config = jdtls_util.get_config()
            
            -- Iniciar o JDTLS
            local jdtls_ok, jdtls = pcall(require, "jdtls")
            if jdtls_ok then
              -- Mapeamentos específicos para JDTLS
              local function map(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { buffer = 0, desc = "Java: " .. desc })
              end
              
              -- Mapeamentos específicos para JDTLS
              map("n", "<leader>jo", function() jdtls.organize_imports() end, "Organizar imports")
              map("n", "<leader>jt", function() jdtls.test_class() end, "Testar classe")
              map("n", "<leader>jn", function() jdtls.test_nearest_method() end, "Testar método")
              map("n", "<leader>je", function() jdtls.extract_variable() end, "Extrair variável")
              map("v", "<leader>je", function() jdtls.extract_variable(true) end, "Extrair variável")
              map("n", "<leader>jc", function() jdtls.extract_constant() end, "Extrair constante")
              map("v", "<leader>jc", function() jdtls.extract_constant(true) end, "Extrair constante")
              map("n", "<leader>jf", function() vim.lsp.buf.format({ async = true }) end, "Formatar código")
              map("n", "<leader>jl", function() 
                if java_config_ok then 
                  java_config.clean_logs() 
                end 
              end, "Limpar logs")
              
              -- Iniciar o JDTLS
              jdtls.start_or_attach(config)
            end
          end
        end,
      })
    end,
  },
}
