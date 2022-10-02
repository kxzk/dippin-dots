--[[

neovim init.lua
by @kadekillary

--]]

vim.opt.shadafile = 'NONE'
vim.opt.shortmess:append 'sI'   -- turn off neovim into message

require 'impatient'

local disabled_built_ins = {
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "spellfile_plugin",
    "matchit"
}

for _, plugin in pairs(disabled_built_ins) do
    vim.g['loaded_' .. plugin] = 1
end

require 'user.plugins'
require 'user.globals'
require 'user.options'
require 'user.augroups'
require 'user.telescope'
require 'user.treesitter'
require 'user.gitsigns'
-- require 'user.lsp_settings'
require 'user.keymaps'
require 'user.theme'
require 'user.statusline'

vim.opt.shadafile = ''
