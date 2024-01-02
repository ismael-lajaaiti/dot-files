return {
    {
        "jpalardy/vim-slime",
        keys = {
            { "<leader>sc", "<cmd>SlimeConfig<cr>",            desc = "Configure Slime" },
            { "<leader>sp", "<Plug>SlimeParagraphSend<cr>))",  desc = "Send paragraph and move" },
            { "<leader>sP", "<Plug>SlimeParagraphSend<cr>k",   desc = "Send paragraph" },
            { "<leader>sl", "<Plug>SlimeLineSend<cr>",         desc = "Send line and move" },
            { "<leader>sL", "<Plug>SlimeLineSend<cr>k",        desc = "Send line" },
            { "<leader>sr", "<Plug>SlimeRegionSend<cr>k",      mode = { "v" },                  desc = "Send region visually selected." },
            { "<leader>sa", "ggVG<Plug>SlimeRegionSend<cr>gg", desc = "Send all buffer." },
        },
        config = function()
            -- vim.keymap.set("v", "<leader>sr", "<Plug>SlimeRegionSend")
            vim.g.slime_target = "tmux"
            vim.g.slime_default_config = {
                socket_name = vim.api.nvim_eval('get(split($TMUX, ","), 0)'),
                target_pane = '{bottom-right}',
            }
            vim.g.slime_dont_ask_default = 1
            vim.g.slime_bracketed_paste = 1
        end,
    },
}
