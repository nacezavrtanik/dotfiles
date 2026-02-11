# Add custom commands to $PATH
export PATH=~/dotfiles/bin:$PATH

# Terminal prompt color
. color --prompt > /dev/null

alias tree='tree --gitfile ~/dotfiles/.gitignore_global'
alias ncdu='ncdu --color dark'

export EDITOR=nvim

. ~/dotfiles/todo/lib/todolib.sh
todolib_register_completion
export TODO_HOME=~/dotfiles/todo/.todos/
export TODO_EDITOR='nvim -O'

. ~/dotfiles/shlf/lib/shlflib.sh
shlflib_register_completion
export SHLF_DIR=~/dotfiles/shlf/.shelf/
export SHLF_EDITOR='nvim -O'
