[[ -v _TODOLIB_CLI__SOURCED ]] && return
readonly _TODOLIB_CLI__SOURCED=true

_TODOLIB_CLI__ROOT="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
. "$_TODOLIB_CLI__ROOT/core.sh"
. "$_TODOLIB_CLI__ROOT/exits.sh"
unset _TODOLIB_CLI__ROOT


_todolib_cli__usage() {
    cat << EOF
Usage: todo [OPTION]
Manage a set of TODOs stored as Markdown files.

TODO names may contain alphanumeric characters, dashes (-), underscores (_), and
spaces ( ). Underscores and spaces are interchangeable.
The default TODO is named \`$_TODOLIB_CORE_DEFAULT_TODO\` and is created automatically.

Options:
  -c, --create TODO...    create new TODOs
  -d, --delete TODO...    delete TODOs
  -h, --help              show this help message
  -l, --list              list all TODOs (pretty format)
  -L, --list-raw          list all TODOs (pipe-friendly format)
  -o, --open [TODO]...    open TODOs in the editor (default action);
                            opens default TODO if none given
  -r, --rename OLD NEW    rename a TODO
  -s, --show [TODO]...    show TODOs in the terminal;
                            shows default TODO if none given

The --open option uses \`$_TODOLIB_CORE_DEFAULT_EDITOR\`, or \$TODO_EDITOR if set.
The --list and --show options use \`$_TODOLIB_CORE_DEFAULT_PAGER\`, or \$TODO_PAGER if set.

Exit status:
EOF
printf '  %-2s    %s\n' "$_TODOLIB_EXITS_SUCCESS"        "success"
printf '  %-2s    %s\n' "$_TODOLIB_EXITS_INVALID_USAGE"  "invalid usage"
printf '  %-2s    %s\n' "$_TODOLIB_EXITS_INVALID_NAME"   "invalid TODO name"
printf '  %-2s    %s\n' "$_TODOLIB_EXITS_DOES_NOT_EXIST" "TODO does not exist"
printf '  %-2s    %s\n' "$_TODOLIB_EXITS_ALREADY_EXISTS" "TODO already exists"
}


_todolib_cli__parse_args() {
    local invalid_usage=false
    local flag default_flag=--open
    local values default_values=($_TODOLIB_CORE_DEFAULT_TODO)

    case $# in
        0)
            flag=$default_flag
            values=$default_values
            ;;

        1)
            case "$1" in
                -c | --create | \
                -d | --delete | \
                -r | --rename )
                    invalid_usage=true
                    ;;
                -h | --help     | \
                -l | --list     | \
                -L | --list-raw | \
                -o | --open     | \
                -s | --show     )
                    flag=$1
                    values=$default_values
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
        printf 'ERROR: Invalid usage ...\n' >&2
        return $_TODOLIB_EXITS_INVALID_USAGE
    fi

    local names name value
    for value in "${values[@]}"; do
        name="${value// /_}"
        if [[ ! $name =~ ^[-_[:alnum:]]+$ ]]; then
            printf 'ERROR: *%s* contains invalid characters ...\n' "$value" >&2
            return $_TODOLIB_EXITS_INVALID_NAME
        else names="$names $name"
        fi
    done

    printf '%s ' "$flag ${names[@]}"
}


_todolib_cli__completion() {
    local longopts names current
    longopts='--create --delete --help --list --list-raw --open --rename --show'
    names="$(_todolib_core_manage_todos -L)"
    current="${COMP_WORDS[COMP_CWORD]// /_}"

    case $COMP_CWORD in
        1)
            COMPREPLY=(
                $(compgen -W "$longopts" -- "$current")
                $(compgen -W "$names" -- "$current")
            )
            ;;
        *)
            case ${COMP_WORDS[1]} in
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


_todolib_cli_register_completion() {
    local cmd="${1:-todo}"
    local completion="_todolib_cli__completion_${cmd//[!a-zA-Z0-9]/_}"
    eval "$completion() { ${2:+TODO_HOME='$2'} _todolib_cli__completion ; }"
    complete -o nosort -F $completion "$cmd"
}


_todolib_cli_run_cli() {
    local args
    args=( $(_todolib_cli__parse_args "$@") ) || return $?

    if [[ ${args[0]} == -h || ${args[0]} == --help ]]; then
        _todolib_cli__usage
    else
        _todolib_core_manage_todos ${args[@]}
    fi
}
