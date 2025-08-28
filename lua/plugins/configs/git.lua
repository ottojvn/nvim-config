return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile" }, -- Carregar quando um buffer for lido ou arquivo novo
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            signs = {
                add = { text = '▎' },
                change = { text = '▎' },
                delete = { text = '' },
                topdelete = { text = '' },
                changedelete = { text = '▎' },
                untracked = { text = '▎' },
            },
            signcolumn = true, -- Habilitar signcolumn
            numhl = false,     -- Não destacar números de linha com sinais git
            linehl = false,    -- Não destacar a linha inteira com sinais git
            word_diff = false, -- Mostrar diff por palavra (pode ser custoso)
            watch_gitdir = {
                interval = 1000,
                follow_files = true,
            },
            attach_to_untracked = true,
            current_line_blame = false, -- Mostrar blame na linha atual (pode ser ativado por mapeamento)
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = 'eol', -- 'eol' ou 'overlay'
                delay = 1000,
                ignore_whitespace = false,
            },
            current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil,  -- Função para formatar status para Lualine (Lualine tem sua própria)
            max_file_length = 40000, -- Limite de tamanho de arquivo para processar
            preview_config = {
                border = "rounded",
                style = "minimal",
                relative = "cursor",
                row = 0,
                col = 1,
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                local map = function(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs,
                        { buffer = bufnr, noremap = true, silent = true, desc = "GitSigns: " .. desc })
                end

                -- Navegação entre hunks
                map('n', ']h', function()
                    if vim.wo.diff then return ']c' end -- Se em modo diff, usa o mapeamento padrão do Vim
                    vim.schedule(function() gs.next_hunk() end)
                    return '<Ignore>'
                end, 'Próximo Hunk')

                map('n', '[h', function()
                    if vim.wo.diff then
                        vim.cmd.normal({ '[c', bang = true }); return
                    end
                    vim.schedule(function() gs.prev_hunk() end)
                    return '<Ignore>'
                end, 'Hunk Anterior')

                -- Ações
                map({ 'n', 'v' }, '<leader>hs', gs.stage_hunk, 'Stage Hunk')
                map({ 'n', 'v' }, '<leader>hr', gs.reset_hunk, 'Reset Hunk')
                map('n', '<leader>hS', gs.stage_buffer, 'Stage Buffer')
                map('n', '<leader>hu', gs.undo_stage_hunk, 'Undo Stage Hunk')
                map('n', '<leader>hR', gs.reset_buffer, 'Reset Buffer')
                map('n', '<leader>hp', gs.preview_hunk, 'Preview Hunk')
                map('n', '<leader>hb', function() gs.blame_line { full = true } end, 'Blame Linha (Completo)')
                map('n', '<leader>htb', gs.toggle_current_line_blame, 'Toggle Blame Linha Atual')
                map('n', '<leader>hd', gs.diffthis, 'Diff This (~)')
                map('n', '<leader>hD', function() gs.diffthis('~') end, 'Diff This (HEAD)')
                map('n', '<leader>td', gs.toggle_deleted, 'Toggle Deleted')

                -- Text object
                map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'Selecionar Hunk (Text Object)')
            end,
        }
    }
}
