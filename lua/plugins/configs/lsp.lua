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
      },
      install_root_dir = vim.fn.stdpath("data") .. "/mason",
      PATH = "prepend", -- Garantir que ferramentas do Mason tenham prioridade no PATH
      log_level = vim.log.levels.INFO,
      max_concurrent_installers = 4,
      -- Configuração para reduzir warnings desnecessários no checkhealth
      -- Os warnings sobre luarocks, ruby, php, composer e julia são informativos
      -- e apenas indicam que essas ferramentas estão disponíveis para uso opcional
      providers = {
        "mason.providers.registry-api",
        "mason.providers.client",
      },
    },
    build = ":MasonUpdate",
    config = function(_, opts)
      require("mason").setup(opts)
      
      -- Adicionar comando para instalar dependências opcionais do Rust se necessário
      vim.api.nvim_create_user_command("MasonInstallRustDeps", function()
        vim.notify("Configurando Rust toolchain para rust_analyzer...", vim.log.levels.INFO)
        vim.fn.system("rustup default stable")
        local result = vim.fn.system("rustup show")
        if vim.v.shell_error == 0 then
          vim.notify("Rust toolchain configurado com sucesso!", vim.log.levels.INFO)
          vim.notify("Agora você pode reinstalar rust_analyzer se necessário: :MasonInstall rust_analyzer", vim.log.levels.INFO)
        else
          vim.notify("Erro ao configurar Rust toolchain. Verifique se rustup está instalado.", vim.log.levels.ERROR)
        end
      end, { desc = "Configurar dependências Rust para mason" })
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
      -- Lista de servidores LSP essenciais para instalar automaticamente
      -- rust_analyzer foi removido da lista automática devido a dependências do cargo
      -- Use :MasonInstallRustDeps e depois :MasonInstall rust_analyzer se precisar de Rust
      ensure_installed = {
        "lua_ls",      -- Lua (Neovim configuration)
        "clangd",      -- C/C++
        "csharp_ls",   -- C#
        "html",        -- HTML
        "cssls",       -- CSS
        "ts_ls",       -- TypeScript/JavaScript  
        "jsonls",      -- JSON
        "jdtls",       -- Java (configurado especialmente)
        "gopls",       -- Go
        "pyright",     -- Python
        "marksman",    -- Markdown
        "yamlls"       -- YAML
        -- rust_analyzer pode ser instalado manualmente após configurar Rust toolchain
      },
      automatic_installation = true, -- Instalar automaticamente servidores ausentes
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
      local lsp_handlers_ok, lsp_handlers = pcall(require, "utils.lsp_handlers")
      if lsp_handlers_ok and lsp_handlers.enhance_handlers then
        lsp_handlers.enhance_handlers()
      end
      
      -- Configurar gerenciador de logs
      local log_manager_ok, log_manager = pcall(require, "utils.lsp_log_manager")
      if log_manager_ok and log_manager.setup then
        log_manager.setup()
      end
      
      -- Configurar filtros de log
      local log_filter_ok, log_filter = pcall(require, "utils.lsp_log_filter")
      if log_filter_ok and log_filter.setup then
        log_filter.setup()
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
        
        -- Usar vim.notify ao invés de print para melhor consistência
        if not status_ok then
          vim.notify("Mason-lspconfig não encontrado. Usando configuração manual dos servidores LSP.", vim.log.levels.DEBUG)
        else
          vim.notify("setup_handlers não disponível no mason-lspconfig. Usando configuração manual.", vim.log.levels.DEBUG)
        end
      end

      -- Configuração para Java usando lspconfig (mais compatível)
      lspconfig.jdtls.setup({
        capabilities = capabilities,
        cmd = { "jdtls" }, -- Requer jdtls no PATH (instalado via Mason)
        root_dir = lspconfig.util.root_pattern('gradlew', '.git', 'mvnw', 'pom.xml', 'build.gradle'),
        settings = {
          java = {
            eclipse = { downloadSources = true },
            configuration = { updateBuildConfiguration = "interactive" },
            maven = { downloadSources = true },
            implementationsCodeLens = { enabled = true },
            referencesCodeLens = { enabled = true },
            format = { enabled = true }
          }
        },
        init_options = {
          bundles = {}
        }
      })
      
      -- Mapeamentos específicos para JDTLS quando anexado
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client.name == "jdtls" then
            local function map(mode, lhs, rhs, desc)
              vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = "Java: " .. desc })
            end
            
            -- Requer nvim-jdtls plugin para funções específicas
            local jdtls_ok, jdtls = pcall(require, "jdtls")
            if jdtls_ok then
              map("n", "<leader>jo", function() jdtls.organize_imports() end, "Organizar imports")
              map("n", "<leader>jt", function() jdtls.test_class() end, "Testar classe")
              map("n", "<leader>jn", function() jdtls.test_nearest_method() end, "Testar método")
              map("n", "<leader>je", function() jdtls.extract_variable() end, "Extrair variável")
              map("v", "<leader>je", function() jdtls.extract_variable(true) end, "Extrair variável")
              map("n", "<leader>jc", function() jdtls.extract_constant() end, "Extrair constante")
              map("v", "<leader>jc", function() jdtls.extract_constant(true) end, "Extrair constante")
            end
          end
        end,
      })

    end,
  },
}
