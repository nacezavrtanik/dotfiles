# Add custom commands to $PATH
export PATH=~/dotfiles/bin:$PATH

# Terminal prompt color
. color --prompt > /dev/null

export EDITOR=nvim

alias tree='tree --gitfile ~/dotfiles/.gitignore_global'
alias ncdu='ncdu --color dark'

alias bat='batcat'
export BAT_THEME=base16
export BAT_STYLE=header,grid,numbers

export FZF_DEFAULT_OPTS='
-i --layout=reverse --height=50% --no-info --no-scrollbar --cycle --scroll-off=5
--prompt="?> " --pointer=" >" --border=none --preview-window=border-sharp
--bind=ctrl-d:preview-half-page-down --bind=ctrl-u:preview-half-page-up
--color=16,prompt:4,hl:4,pointer:2,hl+:2,border:2,gutter:-1,bg+:-1,fg+:-1
'

. ~/dotfiles/shlf/lib/shlflib.sh
shlflib_register_completion
export SHLF_DIR=~/dotfiles/shlf/.shelf/
export SHLF_EDITOR='nvim -O'
export SHLF_PAGER='batcat --style plain --color never'
export SHLF_GREP='rg --line-number --color=always'
