. ~/dotfiles/todo/lib.sh


if ! [[ -v _TODOCLI_SOURCED ]]; then
    _TODOCLI_SOURCED=true
    readonly _TODOCLI_INVALID_USAGE=2
    readonly _TODOCLI_INVALID_NAME=65
fi


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
printf '  %-2s    %s\n' "$_TODOCLI_INVALID_NAME" "invalid name"
printf '  %-2s    %s\n' "$TODOLIB_DOES_NOT_EXIST" "does not exist"
printf '  %-2s    %s\n' "$TODOLIB_ALREADY_EXISTS" "already exists"
}


_todocli_parse_args() {
    local invalid_usage=false
    local flag default_flag=--open
    local values default_values=($TODOLIB_DEFAULT_TODO)

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
        return $_TODOCLI_INVALID_USAGE
    fi

    local names name value
    for value in "${values[@]}"; do
        name="$(printf -- "$value" | tr '[:space:]' '_')"
        if [[ ! $name =~ ^[-_[:alnum:]]+$ ]]; then
            printf 'ERROR: *%s* contains invalid characters ...\n' "$value" >&2
            return $_TODOCLI_INVALID_NAME
        else names="$names $name"
        fi
    done

    printf '%s ' "$flag ${names[@]}"
}


todocli_run_cli() {
    args=( $(_todocli_parse_args "$@") )
    exit_code=$?; [[ $exit_code -gt 0 ]] && return $exit_code

    if [[ ${args[0]} == -h || ${args[0]} == --help ]]; then
        _todocli_usage
    else
        todolib_manage_todos ${args[@]}
    fi
}

