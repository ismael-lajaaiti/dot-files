return {
    "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
    keys = {
        { "<leader>dd", "<cmd>ToggleDiag<cr>", desc = "Toggle LSP diagnostics" },
    },
    config = function()
        require('toggle_lsp_diagnostics').init()
    end,
}
