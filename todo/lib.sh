readonly TODOLIB_INVALID_NAME=65
readonly TODOLIB_DOES_NOT_EXIST=66
readonly TODOLIB_ALREADY_EXISTS=73

readonly TODOLIB_DEFAULT_TODO=todo
readonly _TODOLIB_WORKSPACE_TODO=workspace


_todolib_arg_to_name() { printf -- "$1" | tr '_' ' ' ; }
_todolib_arg_to_filename() { printf '%s.md' "$1" | tr '[:space:]' '_' ; }


_todolib_create() {
    while [[ $# -gt 0 ]]; do
        local name="$(_todolib_arg_to_name "$1")"
        if [[ ! $name =~ ^[-\ [:alnum:]]+$ ]]; then
            printf 'ERROR: *%s* contains invalid characters ...\n' "$name" >&2
            return $TODOLIB_INVALID_NAME
        fi
        local file=$(_todolib_arg_to_filename "$1")
        if [[ -f $file ]]; then
            printf 'ERROR: *%s* already exists ...\n' "$name" >&2
            return $TODOLIB_ALREADY_EXISTS
        fi

        local title="$(printf -- "$name" | tr [:lower:] [:upper:])"
        local underline=$(printf -- "$title" | tr [:print:] '=')
        printf '\n%s\n%s\n\n' "$title" "$underline" > $file
        printf 'Created *%s*!\n' "$name"
        shift
    done
}


_todolib_delete() {
    while [[ $# -gt 0 ]]; do
        local name="$(_todolib_arg_to_name "$1")"
        local file=$(_todolib_arg_to_filename "$1")
        if [[ ! -f $file ]]; then
            printf 'ERROR: *%s* does not exist ...\n' "$name" >&2
            return $TODOLIB_DOES_NOT_EXIST
        fi

        rm -- $file
        printf 'Deleted *%s*!\n' "$name"
        shift
    done
}


_todolib_list() {
    ls -1 -- *.md | sed -e 's/^/* /' -e 's/_/ /g' -e 's/.md$//' | less -F
}


_todolib_list_raw() {
    ls -1 -- *.md | sed -e 's/.md$//' | less -F
}


_todolib_open() {
    local todos=""
    while [[ $# -gt 0 ]]; do
        local file=$(_todolib_arg_to_filename "$1")
        if [[ ! -f $file ]]; then
            local name="$(_todolib_arg_to_name "$1")"
            printf 'ERROR: *%s* does not exist ...\n' "$name" >&2
            return $TODOLIB_DOES_NOT_EXIST
        fi
        todos="$todos $file"
        shift
    done

    nvim -O -- $todos
}


_todolib_rename() {
    local old_name="$(_todolib_arg_to_name "$1")"
    local old_file=$(_todolib_arg_to_filename "$1")
    if [[ ! -f $old_file ]]; then
        printf 'ERROR: *%s* does not exist ...\n' "$old_name" >&2
        return $TODOLIB_DOES_NOT_EXIST
    fi
    local new_name="$(_todolib_arg_to_name "$2")"
    if [[ ! $new_name =~ ^[-\ [:alnum:]]+$ ]]; then
        printf 'ERROR: *%s* contains invalid characters ...\n' "$new_name" >&2
        return $TODOLIB_INVALID_NAME
    fi
    local new_file=$(_todolib_arg_to_filename "$2")
    if [[ -f $new_file ]]; then
        printf 'ERROR: *%s* already exists ...\n' "$new_name" >&2
        return $TODOLIB_ALREADY_EXISTS
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


_todolib_show() {
    local todos=""
    while [[ $# -gt 0 ]]; do
        local file=$(_todolib_arg_to_filename "$1")
        if [[ ! -f $file ]]; then
            local name="$(_todolib_arg_to_name "$1")"
            printf 'ERROR: *%s* does not exist ...\n' "$name" >&2
            return $TODOLIB_DOES_NOT_EXIST
        fi
        todos="$todos $file"
        shift
    done

    cat -- $todos | less -F
}


todolib_manage() {
    local todos_dir=~/dotfiles/todo/.todos/
    mkdir --parents $todos_dir
    cd $todos_dir
    _todolib_create $TODOLIB_DEFAULT_TODO > /dev/null 2>&1
    _todolib_create $_TODOLIB_WORKSPACE_TODO > /dev/null 2>&1

    local -A flags_to_commands=(
        [-c]=_todolib_create   [--create]=_todolib_create
        [-d]=_todolib_delete   [--delete]=_todolib_delete
        [-l]=_todolib_list     [--list]=_todolib_list
        [-L]=_todolib_list_raw [--list-raw]=_todolib_list_raw
        [-o]=_todolib_open     [--open]=_todolib_open
        [-r]=_todolib_rename   [--rename]=_todolib_rename
        [-s]=_todolib_show     [--show]=_todolib_show
    )
    local manage="${flags_to_commands[$1]}"
    shift
    $manage "$@"
}

