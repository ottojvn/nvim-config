return {
  -- Motor de autocompletar
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter", -- Carregar ao entrar no modo de inserção
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",   -- Fonte para LSP
      "hrsh7th/cmp-buffer",     -- Fonte para palavras no buffer atual
      "hrsh7th/cmp-path",       -- Fonte para caminhos de arquivo
      "L3MON4D3/LuaSnip",       -- Motor de snippets
      "saadparwaiz1/cmp_luasnip", -- Integração LuaSnip com nvim-cmp
      "rafamadriz/friendly-snippets", -- Coleção de snippets
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      
      -- Carregar snippets do friendly-snippets e quaisquer snippets personalizados
      require("luasnip.loaders.from_vscode").lazy_load()
      
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}
