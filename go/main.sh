#!/bin/bash

if [[ -f ~/dotfiles/color/.theme ]]; then
    theme_color=$(< ~/dotfiles/color/.theme)
else
    theme_color=black
fi

actions_pre_file=~/dotfiles/go/.actions_pre
actions_post_file=~/dotfiles/go/.actions_post
actions_file=~/dotfiles/go/.actions
touch "$actions_pre_file" "$actions_file" "$actions_post_file"
action=$(\
    cat "$actions_pre_file" "$actions_file" "$actions_post_file" |
    grep -v -e "^[[:space:]]*$" |
    fzf --height 33% \
        --layout reverse \
        --border sharp \
        --info hidden \
        --prompt "<filter> " \
        --pointer " >" \
        --cycle \
        --color "prompt:$theme_color,pointer:$theme_color" \
        --query "$1" \
        --select-1 \
)
command $action
