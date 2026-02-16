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
-i --cycle --no-scrollbar --scroll-off=5 --no-info
--layout=reverse --height=66% --border=sharp
--preview-window="right,50%,border-sharp,<80(down,66%,border-sharp)" --multi
--prompt="?> " --pointer=" >" --marker="*"
--bind=ctrl-d:preview-half-page-down --bind=ctrl-u:preview-half-page-up
--color=16,border:0,preview-border:2,pointer:2,hl+:2,prompt:4,hl:4,marker:5
--color=gutter:-1,bg+:-1,fg+:-1
'

. ~/dotfiles/shlf/lib/shlflib.sh
shlflib_register_completion
export SHLF_DIR=~/dotfiles/shlf/.shelf/
export SHLF_EDITOR='nvim -O'
export SHLF_PAGER='batcat --style=plain --color=always'
export SHLF_GREP='rg --line-number --color=always'
export SHLF_PICKER='fzf --preview="shlf --show {}"'
