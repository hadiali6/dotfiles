local vim = vim
local os = os

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

vim.opt.termguicolors = true
vim.opt.mouse = "a"

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.statuscolumn = [[%!v:lua.require'util.statuscolumn'.setup()]]
vim.opt.laststatus = 3
vim.opt.showmode = false
vim.opt.showcmd = false
vim.opt.colorcolumn = "80"
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.scrolloff = 10

vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.smartindent = false --TODO: try this later
vim.opt.breakindent = true

vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vimundo"

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.wrap = false

vim.opt.virtualedit = "block"

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = "split"

vim.opt.updatetime = 250
vim.opt.timeout = false
-- vim.opt.timeoutlen = 300
