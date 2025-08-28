return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  config = function()
    require('conform').setup {
      formatters_by_ft = { cs = { 'clang_format' } },
      format_on_save = { timeout_ms = 500 },
    }
  end,
}