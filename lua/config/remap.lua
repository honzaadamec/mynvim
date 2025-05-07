vim.g.mapleader = " "
vim.g.maplocalleader = " "


vim.keymap.set("n", "<leader>h", ":wincmd h<CR>")
vim.keymap.set("n", "<leader>j", ":wincmd j<CR>")
vim.keymap.set("n", "<leader>k", ":wincmd k<CR>")
vim.keymap.set("n", "<leader>l", ":wincmd l<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<leader>sv", ":vsplit <CR>")
vim.keymap.set("n", "<leader>sh", ":split <CR>")

vim.keymap.set("x", "p", "pgvy")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "<S-d>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<S-u>", "<cmd>cprev<CR>zz")

local opts = { noremap = true, silent = true }
vim.keymap.set("v", "<leader>y", '"+y', opts)
vim.keymap.set("n", "<leader>yp", ":let @+ = expand('%:p')<CR>", opts)

