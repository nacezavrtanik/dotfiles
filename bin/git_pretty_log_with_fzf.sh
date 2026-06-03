#!/bin/bash

git log --all --pretty=custom-oneline --color=always "$@" |
fzf --ansi --no-sort --preview='git show --stat --color=always {1}'
