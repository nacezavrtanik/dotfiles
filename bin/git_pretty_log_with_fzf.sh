#!/bin/bash

git log --all --decorate --oneline --color=always "$@" |
fzf --ansi --no-sort --preview='git show --stat --color=always {1}'
