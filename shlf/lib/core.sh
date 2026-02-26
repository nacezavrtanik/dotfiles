[[ -v _SHLFLIB_CORE__SOURCED ]] && return
readonly _SHLFLIB_CORE__SOURCED=true

. "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/exits.sh"

readonly _SHLFLIB_CORE__DEFAULT_DIR="$HOME/.local/share/shlf/shelf/"
readonly _SHLFLIB_CORE_DEFAULT_EDITOR='vim -O'
readonly _SHLFLIB_CORE_DEFAULT_PAGER='less -F'
readonly _SHLFLIB_CORE_DEFAULT_GREP='grep -rn'


_shlflib_core__print_header() {
    local title underline
    title="$(basename $1)"; title="${title%.md}"; title="${title//_/ }"
    title="${title^^}"; underline=${title//?/=}
    printf '\n%s\n%s\n\n' "$title" $underline
}


_shlflib_core__get_args() {
    local names
    if [[ -v SHLF_PICKER ]]; then
        names=($(eval "_shlflib_core__list_raw | $SHLF_PICKER"))
    else
        local PS3="$1 #) " path
        select name in $(_shlflib_core__list_raw); do
            if [[ -n $name ]]; then
                names=($name)
                break
            else
                printf 'invalid input: %s is not a number\n' "'$REPLY'" >&2
            fi
        done
    fi
    printf '%s ' "${names[@]/%/.md}"
}


_shlflib_core__create() {
    local path
    for path in "$@"; do
        if [[ -f $path ]]; then
            printf 'shlf: cannot create %s: Item already exists\n' "'$path'" >&2
            return $_SHLFLIB_EXITS_ITEM_ALREADY_EXISTS
        fi

        _shlflib_core__print_header $path > $path
    done
}


_shlflib_core__delete() {
    local path
    for path in "$@"; do
        if [[ ! -f $path ]]; then
            printf 'shlf: cannot delete %s: Item does not exist\n' "'$path'" >&2
            return $_SHLFLIB_EXITS_ITEM_DOES_NOT_EXIST
        fi

        rm -- $path
    done
}


_shlflib_core__grep() {
    local name lineno match
    while IFS= read; do
        name="${REPLY%%:*}"
        name="${name/.\//}"
        name="${name/.md/}"
        name="${name//_/ }"

        lineno="${REPLY#*:}"
        lineno="${lineno%%:*}"

        match="${REPLY#*:}"
        match="${match#*:}"

        printf '* %s (%s): %s\n' "$name" "$lineno" "$match"

    done < <(${SHLF_GREP:-$_SHLFLIB_CORE_DEFAULT_GREP} "$1" .)
}


_shlflib_core__list() {
    local path name
    for path in *.md; do
        [[ -e $path ]] || continue
        name=${path%.*}; name="${name//_/ }"
        printf '* %s\n' "$name"
    done | ${SHLF_PAGER:-$_SHLFLIB_CORE_DEFAULT_PAGER}
}


_shlflib_core__list_raw() {
    for path in *.md; do
        [[ -e $path ]] || continue
        name=${path%.*}
        printf '%s\n' "$name"
    done
}


_shlflib_core__open() {
    [[ $# -gt 0 ]] || set -- $(_shlflib_core__get_args open)
    [[ $# -gt 0 ]] || return

    local path paths
    for path in "$@"; do
        if [[ ! -f $path ]]; then
            printf 'shlf: cannot open %s: Item does not exist\n' "'$path'" >&2
            return $_SHLFLIB_EXITS_ITEM_DOES_NOT_EXIST
        fi
        paths="$paths $path"
    done

    eval "${SHLF_EDITOR:-$_SHLFLIB_CORE_DEFAULT_EDITOR} -- $paths"
}


_shlflib_core__rename() {
    if [[ ! -f $1 ]]; then
        printf 'shlf: cannot rename %s: Item does not exist\n' "'$1'" >&2
        return $_SHLFLIB_EXITS_ITEM_DOES_NOT_EXIST
    fi
    if [[ -f $2 ]]; then
        printf 'shlf: cannot rename to %s: Item already exists\n' "'$2'" >&2
        return $_SHLFLIB_EXITS_ITEM_ALREADY_EXISTS
    fi

    if cmp --quiet -- \
        <(head -n 4 -- $1) \
        <(_shlflib_core__print_header "$1")
    then
        _shlflib_core__print_header "$2" >> $2
        tail -n +5 -- $1 >> $2 && rm -- $1
    else
        mv -- $1 $2 && touch -- $2
    fi
}


_shlflib_core__show() {
    [[ $# -gt 0 ]] || set -- $(_shlflib_core__get_args show)
    [[ $# -gt 0 ]] || return

    local path paths
    for path in "$@"; do
        if [[ ! -f $path ]]; then
            printf 'shlf: cannot show %s: Item does not exist\n' "'$path'" >&2
            return $_SHLFLIB_EXITS_ITEM_DOES_NOT_EXIST
        fi
        paths="$paths $path"
    done

    eval "${SHLF_PAGER:-$_SHLFLIB_CORE_DEFAULT_PAGER} -- $paths"
}


_shlflib_core_manage_shelf() {
    local initial_dir="$(pwd)"
    local shelf="${SHLF_DIR:-$_SHLFLIB_CORE_DEFAULT_DIR}"
    mkdir --parents "$shelf" || return $_SHLFLIB_EXITS_FAILURE
    if ! [[ -r $shelf && -w $shelf && -x $shelf ]]; then
        printf 'shlf: cannot manage %s: Insufficient permissions\n' "'$shelf'"
        return $_SHLFLIB_EXITS_INSUFFICIENT_PERMISSIONS
    fi
    cd "$shelf"

    local -A flags_to_commands=(
        [-c]=_shlflib_core__create   [--create]=_shlflib_core__create
        [-d]=_shlflib_core__delete   [--delete]=_shlflib_core__delete
        [-g]=_shlflib_core__grep     [--grep]=_shlflib_core__grep
        [-l]=_shlflib_core__list     [--list]=_shlflib_core__list
        [-L]=_shlflib_core__list_raw [--list-raw]=_shlflib_core__list_raw
        [-o]=_shlflib_core__open     [--open]=_shlflib_core__open
        [-r]=_shlflib_core__rename   [--rename]=_shlflib_core__rename
        [-s]=_shlflib_core__show     [--show]=_shlflib_core__show
    )
    local manage_shelf="${flags_to_commands[$1]}"
    shift
    $manage_shelf "$@"
    local exit_code=$?

    cd "$initial_dir"
    return $exit_code
}
