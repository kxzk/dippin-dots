vim.api.nvim_set_hl(0, "MsgArea", { fg = "#b8b2a8" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#b8b2a8", bg = "#ede8e0" })

-- hate those ugly ass green docstrings
-- vim.api.nvim_set_hl(0, "@string.documentation.python", {
-- 	fg = "#5c6773",
-- 	italic = true,
-- })

vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true, sp = "#FF4444" })
vim.api.nvim_set_hl(0, "SpellCap", { undercurl = true, sp = "#D97700" })
vim.api.nvim_set_hl(0, "SpellLocal", { undercurl = true, sp = "#6B7D6A" })
vim.api.nvim_set_hl(0, "SpellRare", { undercurl = true, sp = "#8B7D8B" })
