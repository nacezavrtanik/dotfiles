[[ -v _TODOLIB_CORE__SOURCED ]] && return
readonly _TODOLIB_CORE__SOURCED=true

. "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/exits.sh"

readonly _TODOLIB_CORE_DEFAULT_EDITOR='vim -O'
readonly _TODOLIB_CORE_DEFAULT_PAGER='less -F'
readonly _TODOLIB_CORE_DEFAULT_TODO=todo


_todolib_core__print_header() {
    local title underline
    title="${1^^}"; underline=${1//?/=}
    printf '\n%s\n%s\n\n' "$title" $underline
}


_todolib_core__create() {
    local name file
    for name in "$@"; do
        file="$name.md"
        name="${name//_/ }"
        if [[ -f $file ]]; then
            printf 'ERROR: *%s* already exists ...\n' "$name" >&2
            return $_TODOLIB_EXITS_ALREADY_EXISTS
        fi

        _todolib_core__print_header "$name" > $file
        printf 'Created *%s*!\n' "$name"
    done
}


_todolib_core__delete() {
    local name file
    for name in "$@"; do
        file="$name.md"
        name="${name//_/ }"
        if [[ ! -f $file ]]; then
            printf 'ERROR: *%s* does not exist ...\n' "$name" >&2
            return $_TODOLIB_EXITS_DOES_NOT_EXIST
        fi

        rm -- $file
        printf 'Deleted *%s*!\n' "$name"
    done
}


_todolib_core__list() {
    local name
    for name in *.md; do
        name=${name%.*}; name="${name//_/ }"
        printf '* %s\n' "$name"
    done | less -F
}


_todolib_core__list_raw() {
    local name
    for name in *.md; do printf '%s\n' ${name%.*}; done | less -F
}


_todolib_core__open() {
    local files name file
    for name in "$@"; do
        file="$name.md"
        if [[ ! -f $file ]]; then
            printf 'ERROR: *%s* does not exist ...\n' "${name//_/ }" >&2
            return $_TODOLIB_EXITS_DOES_NOT_EXIST
        fi
        files="$files $file"
    done

    ${TODO_EDITOR:-$_TODOLIB_CORE_DEFAULT_EDITOR} -- $files
}


_todolib_core__rename() {
    local old_file="$1.md"
    local old_name="${1//_/ }"
    if [[ ! -f $old_file ]]; then
        printf 'ERROR: *%s* does not exist ...\n' "$old_name" >&2
        return $_TODOLIB_EXITS_DOES_NOT_EXIST
    fi
    local new_file="$2.md"
    local new_name="${2//_/ }"
    if [[ -f $new_file ]]; then
        printf 'ERROR: *%s* already exists ...\n' "$new_name" >&2
        return $_TODOLIB_EXITS_ALREADY_EXISTS
    fi

    if cmp --quiet -- \
        <(head -n 4 -- $old_file) \
        <(_todolib_core__print_header "$old_name")
    then
        _todolib_core__print_header "$new_name" >> $new_file
        tail -n +5 -- $old_file >> $new_file && rm -- $old_file
    else
        mv -- $old_file $new_file && touch -- $new_file
    fi

    printf '*%s* renamed to *%s*!\n' "$old_name" "$new_name"
}


_todolib_core__show() {
    local files name file
    for name in "$@"; do
        file="$name.md"
        if [[ ! -f $file ]]; then
            printf 'ERROR: *%s* does not exist ...\n' "${name//_/ }" >&2
            return $_TODOLIB_EXITS_DOES_NOT_EXIST
        fi
        files="$files $file"
    done

    cat -- $files | ${TODO_PAGER:-$_TODOLIB_CORE_DEFAULT_PAGER}
}


_todolib_core_manage_todos() {
    local initial_dir="$(pwd)"
    local todos_dir=~/dotfiles/todo/.todos/
    mkdir --parents $todos_dir
    cd $todos_dir
    _todolib_core__create $_TODOLIB_CORE_DEFAULT_TODO > /dev/null 2>&1

    local -A flags_to_commands=(
        [-c]=_todolib_core__create   [--create]=_todolib_core__create
        [-d]=_todolib_core__delete   [--delete]=_todolib_core__delete
        [-l]=_todolib_core__list     [--list]=_todolib_core__list
        [-L]=_todolib_core__list_raw [--list-raw]=_todolib_core__list_raw
        [-o]=_todolib_core__open     [--open]=_todolib_core__open
        [-r]=_todolib_core__rename   [--rename]=_todolib_core__rename
        [-s]=_todolib_core__show     [--show]=_todolib_core__show
    )
    local manage_todos="${flags_to_commands[$1]}"
    shift
    $manage_todos "$@"
    local exit_code=$?

    cd "$initial_dir"
    return $exit_code
}
