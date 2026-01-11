# Add custom commands to $PATH
export PATH=$PATH:~/bin

# Terminal prompt color
. color --prompt > /dev/null

# Aliases
alias go='. go'    # . to enable immediate prompt change
alias fzf='fzf --height 33% --layout reverse --border sharp --info hidden --prompt "<filter> " --pointer " >" --cycle --color "prompt:black,pointer:$(< ~/bin/.theme)"'
