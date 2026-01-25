readonly not_alphanumeric_with_spaces=65
readonly does_not_exist=66
readonly already_exists=73

readonly default_todo=todo
readonly workspace_todo=workspace


_arg_to_filename() { printf '%s.md' "$1" | tr '[:space:]' '_' ; }


_delete() {
    while [[ $# -gt 0 ]]; do
        local file=$(_arg_to_filename "$1")
        if [[ ! -f $file ]]; then
            printf 'ERROR: *%s* does not exist ...\n' "$1" >&2
            return $does_not_exist
        fi

        rm $file
        printf 'Deleted *%s*!\n' "$1"
        shift
    done
}


_list() {
    ls -1 *.md | sed -e 's/^/* /' -e 's/_/ /g' -e 's/.md$//' | less -F
}


_new() {
    while [[ $# -gt 0 ]]; do
        if [[ ! $1 =~ ^[\ [:alnum:]]+$ ]]; then
            printf 'ERROR: *%s* is not alphanumeric with spaces ...\n' "$1" >&2
            return $not_alphanumeric_with_spaces
        fi
        local file=$(_arg_to_filename "$1")
        if [[ -f $file ]]; then
            printf 'ERROR: *%s* already exists ...\n' "$1" >&2
            return $already_exists
        fi

        local title="$(printf -- "$1" | tr [:lower:] [:upper:])"
        local underline=$(printf -- "$title" | tr [:print:] '=')
        printf '\n%s\n%s\n\n' "$title" "$underline" > $file

        printf 'Created *%s*!\n' "$1"
        shift
    done
}


_open() {
    local todos=""
    while [[ $# -gt 0 ]]; do
        local file=$(_arg_to_filename "$1")
        if [[ ! -f $file ]]; then
            printf 'ERROR: *%s* does not exist ...\n' "$1" >&2
            return $does_not_exist
        fi
        todos="$todos $file"
        shift
    done

    nvim -O $todos
}


_rename() {
    local old_file=$(_arg_to_filename "$1")
    if [[ ! -f $old_file ]]; then
        printf 'ERROR: *%s* does not exist ...\n' "$1" >&2
        return $does_not_exist
    elif [[ ! $2 =~ ^[\ [:alnum:]]+$ ]]; then
        printf 'ERROR: *%s* is not alphanumeric with spaces ...\n' "$2" >&2
        return $not_alphanumeric_with_spaces
    fi
    local new_file=$(_arg_to_filename "$2")
    if [[ -f $new_file ]]; then
        printf 'ERROR: *%s* already exists ...\n' "$2" >&2
        return $already_exists
    fi

    mv $old_file $new_file
    local old_title="$(printf -- "$1" | tr [:lower:] [:upper:])"
    local old_underline=$(printf -- "$old_title" | tr [:print:] '=')
    if
        (sed -n -e '2p' $new_file | grep "^$old_title$" > /dev/null) &&
        (sed -n -e '3p' $new_file | grep "^$old_underline$" > /dev/null)
    then
        local new_title="$(printf -- "$2" | tr [:lower:] [:upper:])"
        local new_underline=$(printf -- "$new_title" | tr [:print:] '=')
        sed -i -e "2 s/^$old_title$/$new_title/" $new_file
        sed -i -e "3 s/^$old_underline$/$new_underline/" $new_file
    fi

    printf '*%s* renamed to *%s*!\n' "$1" "$2"
}


_show() {
    local todos=""
    while [[ $# -gt 0 ]]; do
        local file=$(_arg_to_filename "$1")
        if [[ ! -f $file ]]; then
            printf 'ERROR: *%s* does not exist ...\n' "$1" >&2
            return $does_not_exist
        fi
        todos="$todos $file"
        shift
    done

    cat $todos | less -F
}


todo_manage() {
    local todos_dir=~/dotfiles/todo/.todos/; mkdir --parents $todos_dir
    local initial_dir="$(pwd)"; cd $todos_dir; trap "cd $initial_dir" EXIT
    _new $default_todo $workspace_todo > /dev/null 2>&1

    local -A flags_to_commands=(
        [-d]=_delete [--delete]=_delete
        [-l]=_list   [--list]=_list
        [-n]=_new    [--new]=_new
        [-o]=_open   [--open]=_open
        [-r]=_rename [--rename]=_rename
        [-s]=_show   [--show]=_show
    )
    local manage="${flags_to_commands[$1]}"
    shift
    $manage "$@"
}

