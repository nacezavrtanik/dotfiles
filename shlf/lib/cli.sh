[[ -v _SHLFLIB_CLI__SOURCED ]] && return
readonly _SHLFLIB_CLI__SOURCED=true

_SHLFLIB_CLI__ROOT="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
. "$_SHLFLIB_CLI__ROOT/core.sh"
. "$_SHLFLIB_CLI__ROOT/exits.sh"
unset _SHLFLIB_CLI__ROOT


_shlflib_cli__usage() {
    cat << EOF
Usage: shlf [OPTION] [ITEM]...
Manage notes and todos stored as Markdown files.

Item names may contain alphanumeric characters, dashes (-), underscores (_),
and spaces ( ). Underscores and spaces are interchangeable.

Options:
  -c, --create ITEM...    create new items
  -d, --delete ITEM...    delete items
  -g, --grep PATTERN      search for pattern in items
  -h, --help              show this help message
  -l, --list              list all items (pretty format)
  -L, --list-raw          list all items (pipe-friendly format)
  -o, --open [ITEM]...    open items in the editor (default action)
  -r, --rename OLD NEW    rename an item
  -s, --show [ITEM]...    show items in the terminal

The --open option uses \`$_SHLFLIB_CORE_DEFAULT_EDITOR\`, or \$SHLF_EDITOR if set.
The --list and --show options use \`$_SHLFLIB_CORE_DEFAULT_PAGER\`, or \$SHLF_PAGER if set.
The --grep option uses \`$_SHLFLIB_CORE_DEFAULT_GREP\`, or \$SHLF_GREP if set.

Exit status:
EOF
printf '  %-2s    %s\n' "$_SHLFLIB_EXITS_SUCCESS"                  "success"
printf '  %-2s    %s\n' "$_SHLFLIB_EXITS_FAILURE"                  "failure"
printf '  %-2s    %s\n' "$_SHLFLIB_EXITS_INVALID_USAGE"            "invalid usage"
printf '  %-2s    %s\n' "$_SHLFLIB_EXITS_INVALID_ITEM_NAME"        "invalid item name"
printf '  %-2s    %s\n' "$_SHLFLIB_EXITS_ITEM_DOES_NOT_EXIST"      "item does not exist"
printf '  %-2s    %s\n' "$_SHLFLIB_EXITS_ITEM_ALREADY_EXISTS"      "item already exists"
printf '  %-2s    %s\n' "$_SHLFLIB_EXITS_INSUFFICIENT_PERMISSIONS" "insufficient permissions"
}


_shlflib_cli__parse_args() {
    local invalid_usage=false
    local values flag default_flag=--open

    case $# in
        0)
            flag=$default_flag
            ;;
        1)
            case "$1" in
                -c | --create | \
                -d | --delete | \
                -g | --grep   | \
                -r | --rename )
                    invalid_usage=true
                    ;;
                -h | --help     | \
                -l | --list     | \
                -L | --list-raw | \
                -o | --open     | \
                -s | --show   )
                    flag=$1
                    ;;
                *)
                    flag=$default_flag
                    values=("$@")
                    ;;
            esac
            ;;

        2)
            case "$1" in
                -h | --help     | \
                -l | --list     | \
                -L | --list-raw | \
                -r | --rename   )
                    invalid_usage=true
                    ;;
                -c | --create | \
                -d | --delete | \
                -g | --grep   | \
                -o | --open   | \
                -s | --show   )
                    flag=$1
                    shift
                    values=("$@")
                    ;;
                *)
                    flag=$default_flag
                    values=("$@")
                    ;;
            esac
            ;;

        3)
            case "$1" in
                -g | --grep     | \
                -h | --help     | \
                -l | --list     | \
                -L | --list-raw )
                    invalid_usage=true
                    ;;
                -c | --create | \
                -d | --delete | \
                -o | --open   | \
                -r | --rename | \
                -s | --show   )
                    flag=$1
                    shift
                    values=("$@")
                    ;;
                *)
                    flag=$default_flag
                    values=("$@")
                    ;;
            esac
            ;;

        *)
            case $1 in
                -g | --grep     | \
                -h | --help     | \
                -l | --list     | \
                -L | --list-raw | \
                -r | --rename   )
                    invalid_usage=true
                    ;;
                -c | --create | \
                -d | --delete | \
                -o | --open   | \
                -s | --show   )
                    flag=$1
                    shift
                    values=("$@")
                    ;;
                *)
                    flag=$default_flag
                    values=("$@")
                    ;;
            esac
            ;;
    esac

    if $invalid_usage; then
        printf 'shlf: invalid usage\n' >&2
        return $_SHLFLIB_EXITS_INVALID_USAGE
    fi

    for value in "${values[@]}"; do
        name="${value// /_}"; name="${name%.md}"
        if [[ ! $name =~ ^[-_[:alnum:]]+$ ]]; then
            printf 'shlf: cannot parse %s: Contains invalid characters\n' \
                "'$value'" >&2
            return $_SHLFLIB_EXITS_INVALID_ITEM_NAME
        else names="$names $name"
        fi
    done

    printf '%s ' "$flag ${names[@]}"
}


_shlflib_cli__completion() {
    local longopts names current
    longopts=(
        --create --delete --grep --help --list --list-raw --open --rename --show
    )
    names="$(_shlflib_core_manage_shelf -L)"
    current="${COMP_WORDS[COMP_CWORD]// /_}"

    case $COMP_CWORD in
        1)
            COMPREPLY=(
                $(compgen -W "${longopts[*]}" -- "$current")
                $(compgen -W "$names" -- "$current")
            )
            ;;
        *)
            case ${COMP_WORDS[1]} in
                -g | --grep     | \
                -h | --help     | \
                -l | --list     | \
                -L | --list-raw )
                    COMPREPLY=()
                    ;;
                -r | --rename )
                    if [[ $COMP_CWORD == 2 ]]; then
                        COMPREPLY=( $(compgen -W "$names" -- "$current") )
                    else
                        COMPREPLY=()
                    fi
                    ;;
                *)
                    COMPREPLY=( $(compgen -W "$names" -- "$current") )
                    ;;
            esac
            ;;
    esac
}


_shlflib_cli_register_completion() {
    local cmd="${1:-shlf}"
    local completion="_shlflib_cli__completion_${cmd//[!a-zA-Z0-9]/_}"
    eval "$completion() { ${2:+SHLF_DIR='$2'} _shlflib_cli__completion ; }"
    complete -o nosort -F $completion "$cmd"
}


_shlflib_cli_run_cli() {
    local args
    args=( $(_shlflib_cli__parse_args "$@") ) || return $?

    if [[ ${args[0]} == -h || ${args[0]} == --help ]]; then
        _shlflib_cli__usage
    else
        _shlflib_core_manage_shelf ${args[@]}
    fi
}
