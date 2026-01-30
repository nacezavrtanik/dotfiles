. ~/dotfiles/todo/lib.sh


readonly _TODOCLI_INVALID_USAGE=2
readonly _TODOCLI_DEFAULT_FLAG=--open


_TODOCLI_FLAG=$_TODOCLI_DEFAULT_FLAG
_TODOCLI_TODOS=($TODOLIB_DEFAULT_TODO)


_todocli_usage() {
    cat << EOF
Usage: todo [OPTION]
Manage TODOs stored as Markdown files.

The TODOs \`todo\` (default) and \`workspace\` are created automatically.

TODO names may contain alphanumeric characters, dashes (-), underscores (_), and
spaces ( ). Underscores and spaces are interchangeable.

Options:
  -c, --create TODO...    create new TODOs
  -d, --delete TODO...    delete TODOs
  -h, --help              show this help message
  -l, --list              list all TODOs (pretty format)
  -L, --list-raw          list all TODOs (pipe-friendly format)
  -o, --open [TODO]...    open TODOs in Neovim (default action);
                            if no TODOs are given, the default TODO is opened
  -r, --rename OLD NEW    rename OLD to NEW
  -s, --show [TODO]...    show TODOs in the terminal;
                            if no TODOs are given, the default TODO is shown

Exit status:
EOF
printf '  %-2s    %s\n' "0" "success"
printf '  %-2s    %s\n' "$_TODOCLI_INVALID_USAGE" "invalid usage"
printf '  %-2s    %s\n' "$TODOLIB_INVALID_NAME" "invalid name"
printf '  %-2s    %s\n' "$TODOLIB_DOES_NOT_EXIST" "does not exist"
printf '  %-2s    %s\n' "$TODOLIB_ALREADY_EXISTS" "already exists"
}


_todocli_parse_args() {
    case $# in
        0)
            _TODOCLI_FLAG=$_TODOCLI_DEFAULT_FLAG
            _TODOCLI_TODOS=($TODOLIB_DEFAULT_TODO)
            ;;

        1)
            case "$1" in
                -c | --create | \
                -d | --delete | \
                -r | --rename )
                    return $_TODOCLI_INVALID_USAGE
                    ;;
                -h | --help     | \
                -l | --list     | \
                -L | --list-raw | \
                -o | --open     | \
                -s | --show     )
                    _TODOCLI_FLAG=$1
                    _TODOCLI_TODOS=($TODOLIB_DEFAULT_TODO)
                    ;;
                *)
                    _TODOCLI_FLAG=$_TODOCLI_DEFAULT_FLAG
                    _TODOCLI_TODOS=("$@")
                    ;;
            esac
            ;;

        2)
            case "$1" in
                -h | --help     | \
                -l | --list     | \
                -L | --list-raw | \
                -r | --rename   )
                    return $_TODOCLI_INVALID_USAGE
                    ;;
                -c | --create | \
                -d | --delete | \
                -o | --open   | \
                -s | --show   )
                    _TODOCLI_FLAG=$1
                    shift
                    _TODOCLI_TODOS=("$@")
                    ;;
                *)
                    _TODOCLI_FLAG=$_TODOCLI_DEFAULT_FLAG
                    _TODOCLI_TODOS=("$@")
                    ;;
            esac
            ;;

        3)
            case "$1" in
                -h | --help     | \
                -l | --list     | \
                -L | --list-raw )
                    return $_TODOCLI_INVALID_USAGE
                    ;;
                -c | --create | \
                -d | --delete | \
                -o | --open   | \
                -r | --rename | \
                -s | --show   )
                    _TODOCLI_FLAG=$1
                    shift
                    _TODOCLI_TODOS=("$@")
                    ;;
                *)
                    _TODOCLI_FLAG=$_TODOCLI_DEFAULT_FLAG
                    _TODOCLI_TODOS=("$@")
                    ;;
            esac
            ;;

        *)
            case $1 in
                -h | --help     | \
                -l | --list     | \
                -L | --list-raw | \
                -r | --rename   )
                    return $_TODOCLI_INVALID_USAGE
                    ;;
                -c | --create | \
                -d | --delete | \
                -o | --open   | \
                -s | --show   )
                    _TODOCLI_FLAG=$1
                    shift
                    _TODOCLI_TODOS=("$@")
                    ;;
                *)
                    _TODOCLI_FLAG=$_TODOCLI_DEFAULT_FLAG
                    _TODOCLI_TODOS=("$@")
                    ;;
            esac
            ;;
    esac
}


todocli_run() {
    if ! _todocli_parse_args "$@"; then
        printf 'ERROR: Invalid usage ...\n' >&2
        return $_TODOCLI_INVALID_USAGE
    fi

    if [[ $_TODOCLI_FLAG == -h || $_TODOCLI_FLAG == --help ]]; then
        _todocli_usage
    else
        todolib_manage "$_TODOCLI_FLAG" "${_TODOCLI_TODOS[@]}"
    fi
}

