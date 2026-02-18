vim.g.mapleader = " "
vim.o.mouse = ""

vim.o.termguicolors = false
vim.cmd.colorscheme("memories")
vim.o.cursorline = true
vim.o.cursorlineopt = "number"

vim.o.rulerformat = "%3(%P%)"
vim.o.statusline = [[%<%t %m%h%r%=%P]]
vim.o.laststatus = 1
vim.o.showcmd = false
vim.o.breakindent = true
vim.o.showbreak = "~"
vim.o.fillchars = "vert: ,diff: ,lastline:~,fold:~"

function _G.get_foldtext()
  local linesnr = vim.v.foldend - vim.v.foldstart + 1
  return "(" .. linesnr .. ")"
end
vim.o.foldtext="v:lua.get_foldtext()"

function _G.get_tabline()
  local tabline = {}
  local tabnr_max = vim.fn.tabpagenr("$")
  local tabnr_sel = vim.fn.tabpagenr()
  for tabnr = 1, tabnr_max do
    if tabnr == tabnr_sel then
      tabline[#tabline+1] = "%#TabLineSel#"
    else
      tabline[#tabline+1] = "%#TabLine#"
    end
    tabline[#tabline+1] = " " .. tabnr .. " "
  end
  tabline[#tabline+1] = "%#TabLineFill#"
  return table.concat(tabline)
end
vim.o.tabline="%!v:lua.get_tabline()"

vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 10
vim.o.sidescrolloff = 15

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = -1
vim.o.expandtab = true
vim.cmd("filetype indent off")
vim.api.nvim_create_autocmd(
  { "FileType" },
  {
    pattern = "*",
    callback = function()
      vim.opt_local.formatoptions:remove({ "o", "r" })
    end,
  }
)

vim.o.pumheight = 15
vim.opt.wildmode = { "longest:full", "full" }

vim.opt.diffopt = {
  "vertical",
  "closeoff",
  "hiddenoff",
  "filler",
  "foldcolumn:0",
  "algorithm:histogram",
  "inline:char",
}

vim.keymap.set({ "n", "v" }, "<Leader>8", function()
  vim.o.colorcolumn = (vim.o.colorcolumn == "") and "80" or ""
end)

vim.keymap.set({ "n", "v" }, "<Leader>y", '"+y')
vim.keymap.set({ "n", "v" }, "<Leader>Y", '"+Y', { remap = true })
vim.keymap.set({ "n", "v" }, "<Leader>p", '"+p')
vim.keymap.set({ "n", "v" }, "<Leader>P", '"+P')

vim.o.grepprg = "rg --vimgrep --hidden --glob '!.git/'"
vim.keymap.set("n", "<Leader>cn", ":cnext<CR>")
vim.keymap.set("n", "<Leader>cp", ":cprev<CR>")
vim.keymap.set("n", "<Leader>co", ":copen<CR>")
vim.keymap.set("n", "<Leader>cc", ":cclose<CR>")
vim.keymap.set("n", "<Leader>cf", ":cfirst<CR>")
vim.keymap.set("n", "<Leader>cl", ":clast<CR>")
vim.api.nvim_create_autocmd(
  { "QuickFixCmdPost" },
  {
    pattern = "grep",
    callback = function()
      vim.cmd("cwindow")
    end,
  }
)

vim.api.nvim_create_autocmd(
  { "VimResized" },
  {
    pattern = "*",
    callback = function()
      vim.cmd("wincmd =")
    end
  }
)

vim.api.nvim_create_autocmd(
  { "BufWritePre" },
  {
    pattern="*",
    callback = function()
      vim.cmd([[%s/\s\+$//e]])
    end,
  }
)
