vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = -1

vim.opt_local.textwidth = 80

vim.opt_local.suffixesadd:append(".md")
vim.opt_local.isfname:append("32,58")
function _G.get_includeexpr()
  local fname = vim.v.fname
  fname = fname:gsub(": ", "/")
  fname = fname:gsub(" ", "_")
  return fname
end
vim.opt_local.includeexpr = "v:lua.get_includeexpr()"
