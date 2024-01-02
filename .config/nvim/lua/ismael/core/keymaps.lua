vim.g.mapleader = " "

local keymap = vim.keymap -- for consiceness

-- general keymaps
keymap.set("n", "<leader>cv", ":silent tab drop ~/.config/nvim<cr>")
keymap.set("n", "<leader>sov", ":source ~/.config/nvim/init.lua<cr>")

-- Sort: case sensitive (caps first).
keymap.set("v", "so", ":sort<cr>")
keymap.set("n", "sop", "vip:sort<cr>")

-- Sort: case insensitive.
keymap.set("v", "So", ":sort i<cr>")
keymap.set("n", "Sop", "vip:sort i<cr>")

keymap.set("i", "jk", "<ESC>")
keymap.set("v", "ui", "<ESC>")

keymap.set("n", "x", '"_x')

keymap.set("v", "K", ":m-2<CR>gv=gv")
keymap.set("v", "J", ":m'>+<CR>gv=gv")

keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

keymap.set("n", "<leader>nh", ":noh<cr>") -- clear researsh highlighting

keymap.set("n", "<leader>fm", function()
	vim.lsp.buf.format()
end)

keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split window equal width
keymap.set("n", "<leader>sx", ":close<CR>") -- split window vertically

keymap.set("n", "<leader>to", ":tabnew<CR>") -- open new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
keymap.set("n", "<leader>tl", ":tabn<CR>") -- go to next tab
keymap.set("n", "<leader>th", ":tabp<CR>") -- go to previous tab

-- LaTeX keymap
keymap.set("n", "<leader>it", "ysiw}i\\textit<esc>", {remap = true})
keymap.set("v", "<leader>it", "S}i\\textit<esc>", {remap = true})
keymap.set("n", "<leader>bf", "ysiw}i\\textbf<esc>", {remap = true})
keymap.set("v", "<leader>bf", "S}i\\textbf<esc>", {remap = true})
keymap.set("n", "<leader>mbf", "ysiw}i\\mathbf<esc>", {remap = true})
keymap.set("v", "<leader>mbf", "S}i\\mathbf<esc>", {remap = true})
keymap.set("n", "<leader>mca", "ysiw}i\\mathcal<esc>", {remap = true})
keymap.set("v", "<leader>mca", "S}i\\mathcal<esc>", {remap = true})
