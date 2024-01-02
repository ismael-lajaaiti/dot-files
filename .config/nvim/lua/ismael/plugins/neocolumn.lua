return {
    "ecthelionvi/NeoColumn.nvim",

    config = function()
        require("NeoColumn").setup({
            NeoColumn = { "80" },
            custom_NeoColumn = { julia = "92" },
            always_on = { true },
        })
    end,
}
