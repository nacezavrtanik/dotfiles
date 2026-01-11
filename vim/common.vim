set number
set relativenumber
set scrolloff=10

set hlsearch
set incsearch
nnoremap <C-l> :nohlsearch<CR><C-l>

set splitright
set splitbelow

set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set autoindent

autocmd BufWritePre * :%s/\s\+$//e
