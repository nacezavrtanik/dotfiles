set -o vi
export EDITOR=nvim

export PATH=~/dotfiles/bin:$PATH

. color --prompt > /dev/null

weather() {
    curl -s wttr.in/$1?Fq | sed \
        -e 's/38;5;196/38;5;1/g' \
        -e 's/38;5;202/38;5;1/g' \
        -e 's/38;5;208/38;5;1/g' \
        -e 's/38;5;046/38;5;2/g' \
        -e 's/38;5;047/38;5;2/g' \
        -e 's/38;5;082/38;5;2/g' \
        -e 's/38;5;118/38;5;2/g' \
        -e 's/38;5;154/38;5;2/g' \
        -e 's/38;5;190/38;5;2/g' \
        -e 's/38;5;220/38;5;3/g' \
        -e 's/38;5;226/38;5;3/g' \
        -e 's/38;5;228/38;5;3/g' \
        -e 's/38;5;21/38;5;4/g'  \
        -e 's/38;5;111/38;5;4/g' \
        -e 's/38;5;250/38;5;4/g' \
        -e 's/38;5;039/38;5;6/g' \
        -e 's/38;5;44/38;5;6/g'  \
        -e 's/38;5;045/38;5;6/g' \
        -e 's/38;5;048/38;5;6/g' \
        -e 's/38;5;049/38;5;6/g' \
        -e 's/38;5;050/38;5;6/g' \
        -e 's/38;5;051/38;5;6/g' \
        -e 's/38;5;240/38;5;7/g' \
        -e 's/38;5;255/38;5;7/g'
}
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

. ~/repos/shlf/lib/shlflib.sh
shlflib_register_completion
export SHLF_DIR=~/dotfiles/.shelf/
export SHLF_EDITOR='nvim -O'
export SHLF_PAGER='batcat --style=plain --color=always'
export SHLF_GREP='rg --line-number --color=always'
export SHLF_PICKER='fzf --preview="shlf --show {}"'
