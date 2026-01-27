readonly invalid_name=65
readonly does_not_exist=66
readonly already_exists=73

readonly default_todo=todo
readonly workspace_todo=workspace


_arg_to_name() { printf -- "$1" | tr '_' ' ' ; }
_arg_to_filename() { printf '%s.md' "$1" | tr '[:space:]' '_' ; }


_create() {
    while [[ $# -gt 0 ]]; do
        local name="$(_arg_to_name "$1")"
        if [[ ! $name =~ ^[-\ [:alnum:]]+$ ]]; then
            printf 'ERROR: *%s* contains invalid characters ...\n' "$name" >&2
            return $invalid_name
        fi
        local file=$(_arg_to_filename "$1")
        if [[ -f $file ]]; then
            printf 'ERROR: *%s* already exists ...\n' "$name" >&2
            return $already_exists
        fi

        local title="$(printf -- "$name" | tr [:lower:] [:upper:])"
        local underline=$(printf -- "$title" | tr [:print:] '=')
        printf '\n%s\n%s\n\n' "$title" "$underline" > $file
        printf 'Created *%s*!\n' "$name"
        shift
    done
}


_delete() {
    while [[ $# -gt 0 ]]; do
        local name="$(_arg_to_name "$1")"
        local file=$(_arg_to_filename "$1")
        if [[ ! -f $file ]]; then
            printf 'ERROR: *%s* does not exist ...\n' "$name" >&2
            return $does_not_exist
        fi

        rm -- $file
        printf 'Deleted *%s*!\n' "$name"
        shift
    done
}


_list() {
    ls -1 -- *.md | sed -e 's/^/* /' -e 's/_/ /g' -e 's/.md$//' | less -F
}


_list_raw() {
    ls -1 -- *.md | sed -e 's/.md$//' | less -F
}


_open() {
    local todos=""
    while [[ $# -gt 0 ]]; do
        local file=$(_arg_to_filename "$1")
        if [[ ! -f $file ]]; then
            local name="$(_arg_to_name "$1")"
            printf 'ERROR: *%s* does not exist ...\n' "$name" >&2
            return $does_not_exist
        fi
        todos="$todos $file"
        shift
    done

    nvim -O -- $todos
}


_rename() {
    local old_name="$(_arg_to_name "$1")"
    local old_file=$(_arg_to_filename "$1")
    if [[ ! -f $old_file ]]; then
        printf 'ERROR: *%s* does not exist ...\n' "$old_name" >&2
        return $does_not_exist
    fi
    local new_name="$(_arg_to_name "$2")"
    if [[ ! $new_name =~ ^[-\ [:alnum:]]+$ ]]; then
        printf 'ERROR: *%s* contains invalid characters ...\n' "$new_name" >&2
        return $invalid_name
    fi
    local new_file=$(_arg_to_filename "$2")
    if [[ -f $new_file ]]; then
        printf 'ERROR: *%s* already exists ...\n' "$new_name" >&2
        return $already_exists
    fi

    mv -- $old_file $new_file
    local old_title="$(printf -- "$old_name" | tr [:lower:] [:upper:])"
    local old_underline=$(printf -- "$old_title" | tr [:print:] '=')
    if cmp --quiet -- \
        <(head -n 3 -- $new_file) \
        <(printf '\n%s\n%s\n' "$old_title" "$old_underline")
    then
        local new_title="$(printf -- "$new_name" | tr [:lower:] [:upper:])"
        local new_underline=$(printf -- "$new_title" | tr [:print:] '=')
        sed -i "2,3c $new_title\n$new_underline" $new_file
    fi

    printf '*%s* renamed to *%s*!\n' "$old_name" "$new_name"
}


_show() {
    local todos=""
    while [[ $# -gt 0 ]]; do
        local file=$(_arg_to_filename "$1")
        if [[ ! -f $file ]]; then
            local name="$(_arg_to_name "$1")"
            printf 'ERROR: *%s* does not exist ...\n' "$name" >&2
            return $does_not_exist
        fi
        todos="$todos $file"
        shift
    done

    cat -- $todos | less -F
}


todo_manage() {
    local todos_dir=~/dotfiles/todo/.todos/; mkdir --parents $todos_dir
    local initial_dir="$(pwd)"; cd $todos_dir; trap "cd $initial_dir" EXIT
    _create $default_todo > /dev/null 2>&1
    _create $workspace_todo > /dev/null 2>&1

    local -A flags_to_commands=(
        [-c]=_create   [--create]=_create
        [-d]=_delete   [--delete]=_delete
        [-l]=_list     [--list]=_list
        [-L]=_list_raw [--list-raw]=_list_raw
        [-o]=_open     [--open]=_open
        [-r]=_rename   [--rename]=_rename
        [-s]=_show     [--show]=_show
    )
    local manage="${flags_to_commands[$1]}"
    shift
    $manage "$@"
}

