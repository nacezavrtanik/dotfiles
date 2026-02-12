[[ -v _SHLFLIB_CORE__SOURCED ]] && return
readonly _SHLFLIB_CORE__SOURCED=true

. "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/exits.sh"

readonly _SHLFLIB_CORE__DEFAULT_DIR="$HOME/.local/share/shlf/shelf/"
readonly _SHLFLIB_CORE_DEFAULT_EDITOR='vim -O'
readonly _SHLFLIB_CORE_DEFAULT_PAGER='less -F'
readonly _SHLFLIB_CORE_DEFAULT_GREP='grep -rn'


_shlflib_core__print_header() {
    local title underline
    title="${1^^}"; underline=${1//?/=}
    printf '\n%s\n%s\n\n' "$title" $underline
}


_shlflib_core__create() {
    local name file
    for name in "$@"; do
        file="$name.md"
        name="${name//_/ }"
        if [[ -f $file ]]; then
            printf 'shlf: cannot create %s: Item already exists\n' "'$name'" >&2
            return $_SHLFLIB_EXITS_ITEM_ALREADY_EXISTS
        fi

        _shlflib_core__print_header "$name" > $file
    done
}


_shlflib_core__delete() {
    local name file
    for name in "$@"; do
        file="$name.md"
        if [[ ! -f $file ]]; then
            printf 'shlf: cannot delete %s: Item does not exist\n' \
                "'${name//_/ }'" >&2
            return $_SHLFLIB_EXITS_ITEM_DOES_NOT_EXIST
        fi

        rm -- $file
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
    local name
    for name in *.md; do
        [[ -e $name ]] || continue
        name=${name%.*}; name="${name//_/ }"
        printf '* %s\n' "$name"
    done | ${SHLF_PAGER:-$_SHLFLIB_CORE_DEFAULT_PAGER}
}


_shlflib_core__list_raw() {
    local name
    for name in *.md; do
        [[ -e $name ]] || continue
        printf '%s\n' ${name%.*}
    done
}


_shlflib_core__open() {
    local files name file
    for name in "$@"; do
        file="$name.md"
        if [[ ! -f $file ]]; then
            printf 'shlf: cannot open %s: Item does not exist\n' \
                "'${name//_/ }'" >&2
            return $_SHLFLIB_EXITS_ITEM_DOES_NOT_EXIST
        fi
        files="$files $file"
    done

    ${SHLF_EDITOR:-$_SHLFLIB_CORE_DEFAULT_EDITOR} -- $files
}


_shlflib_core__rename() {
    local old_file="$1.md"
    local old_name="${1//_/ }"
    if [[ ! -f $old_file ]]; then
        printf 'shlf: cannot rename %s: Item does not exist\n' "'$old_name'" >&2
        return $_SHLFLIB_EXITS_ITEM_DOES_NOT_EXIST
    fi
    local new_file="$2.md"
    local new_name="${2//_/ }"
    if [[ -f $new_file ]]; then
        printf 'shlf: cannot rename to %s: Item already exists\n' \
            "'$new_name'" >&2
        return $_SHLFLIB_EXITS_ITEM_ALREADY_EXISTS
    fi

    if cmp --quiet -- \
        <(head -n 4 -- $old_file) \
        <(_shlflib_core__print_header "$old_name")
    then
        _shlflib_core__print_header "$new_name" >> $new_file
        tail -n +5 -- $old_file >> $new_file && rm -- $old_file
    else
        mv -- $old_file $new_file && touch -- $new_file
    fi
}


_shlflib_core__show() {
    local files name file
    for name in "$@"; do
        file="$name.md"
        if [[ ! -f $file ]]; then
            printf 'shlf: cannot show %s: Item does not exist\n' \
                "'${name//_/ }'" >&2
            return $_SHLFLIB_EXITS_ITEM_DOES_NOT_EXIST
        fi
        files="$files $file"
    done

    ${SHLF_PAGER:-$_SHLFLIB_CORE_DEFAULT_PAGER} -- $files
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
