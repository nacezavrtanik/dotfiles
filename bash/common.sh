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

. ~/dotfiles/shlf/lib/shlflib.sh
shlflib_register_completion
export SHLF_DIR=~/dotfiles/shlf/.shelf/
export SHLF_EDITOR='nvim -O'
export SHLF_PAGER='batcat --style plain --color never'
