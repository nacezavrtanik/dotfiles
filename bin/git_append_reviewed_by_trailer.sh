#!/bin/bash

mapfile -t reviewers < <(
    git log --format='%an <%ae>' |
    sort -u |
    fzf --preview='git show --color=always'
)

for r in "${reviewers[@]}"; do
    git commit --amend --no-edit --trailer "Reviewed-by: $r"
done
