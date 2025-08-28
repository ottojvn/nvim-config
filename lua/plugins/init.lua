return {
	-- Gerenciador de plugins lazy.nvim (configuração do próprio lazy)
	{
		"folke/lazy.nvim",
		version = false, -- Usar branch principal, ou especificar uma versão como "stable"
		opts = {
			-- Configurações de UI para o lazy.nvim
			ui = {
				border = "rounded", -- 'none', 'single', 'double', 'rounded', 'solid', 'shadow'
			},
			-- Corescheme para a UI do lazy.nvim durante a instalação/atualização
			install = {
				colorscheme = { "catppuccin" }, -- Tenta usar catppuccin, fallback para habamax se não disponível
			},
			-- Verificador de atualizações de plugins
			checker = {
				enabled = true,       -- Verificar atualizações automaticamente
				notify = false,       -- Não notificar sobre atualizações na inicialização (pode ser verificado com :Lazy)
				frequency = 3600 * 6, -- Verificar a cada 6 horas (em segundos)
			},
			-- Otimizações de performance
			performance = {
				rtp = {
					-- Plugins do runtime do Neovim que podem ser desabilitados se não usados
					-- Cuidado ao desabilitar, alguns são úteis ou dependências implícitas
					disabled_plugins = {
						-- "gzip",
						-- "matchit", -- Útil para % em HTML, etc.
						-- "matchparen", -- Essencial para destacar parênteses correspondentes
						"netrwPlugin", -- Será substituído por outro file explorer se desejado (ex: mini.files, nvim-tree)
						-- "tarPlugin",
						"tohtml",
						-- "tutor",
						-- "zipPlugin",
					},
				},
			},
			-- Especifica que os arquivos de configuração dos plugins estão em lua/plugins/configs
			-- e que cada arquivo.lua nesse diretório é um spec de plugin.
			-- Esta abordagem é mais explícita do que apenas "plugins" se quisermos aninhar.
			-- No entanto, lazy.nvim é inteligente: se "plugins" for um diretório, ele procurará
			-- por lua/plugins/*.lua ou lua/plugins/init.lua.
			-- Para esta estrutura, os imports abaixo são mais explícitos.
		},
	},

	-- Tema (deve ser carregado cedo e sem lazy-loading)
	{ import = "plugins.configs.theme" },

	-- LSP, Mason e servidores de linguagem
	{ import = "plugins.configs.lsp" },

	-- Motor de autocompletar e snippets
	{ import = "plugins.configs.completion" },

	-- Fuzzy finding
	{ import = "plugins.configs.telescope" },

	-- Syntax highlighting e análise estrutural
	{ import = "plugins.configs.treesitter" },

	-- Elementos de UI (Statusline, Comentários, Autopairs, Notificações)
	{ import = "plugins.configs.ui" },

	-- Integração Git
	{ import = "plugins.configs.git" },

	{ import = "plugins.configs.conform" },

	-- Extensões Java
	{ import = "plugins.configs.java_extensions" },
}
