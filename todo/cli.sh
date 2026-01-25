. ~/dotfiles/todo/lib.sh


readonly invalid_usage=2
readonly default_flag=--open


flag=$default_flag
todos=($default_todo)


_usage() {
    cat << EOF
Usage: todo [OPTION]
Manage TODOs.

Options:
  -c, --create TODO...    create new TODOs
  -d, --delete TODO...    delete TODOs
  -h, --help              show this help
  -l, --list              list all TODOs
  -o, --open [TODO]...    open TODOs in Neovim;
                            this is the default option if OPTION is not given;
                            if no TODOs are given, the default TODO is opened
  -r, --rename OLD NEW    rename OLD to NEW
  -s, --show [TODO]...    show TODOs in the terminal;
                            if no TODOs are given, the default TODO is shown

Exit status:
EOF
printf '  %-2s    %s\n' "0" "success,"
printf '  %-2s    %s\n' "$invalid_usage" "invalid usage,"
printf '  %-2s    %s\n' "$not_alphanumeric_with_spaces" "not alphanumeric with spaces,"
printf '  %-2s    %s\n' "$does_not_exist" "does not exist,"
printf '  %-2s    %s\n' "$already_exists" "already exists."
}


_parse_args() {
    case $# in
        0)
            flag=$default_flag
            todos=($default_todo)
            ;;

        1)
            case "$1" in
                -c | --create | \
                -d | --delete | \
                -r | --rename )
                    return $invalid_usage
                    ;;
                -h | --help | \
                -l | --list | \
                -o | --open | \
                -s | --show )
                    flag=$1
                    todos=($default_todo)
                    ;;
                *)
                    flag=$default_flag
                    todos=("$@")
                    ;;
            esac
            ;;

        2)
            case "$1" in
                -h | --help   | \
                -l | --list   | \
                -r | --rename )
                    return $invalid_usage
                    ;;
                -c | --create | \
                -d | --delete | \
                -o | --open   | \
                -s | --show   )
                    flag=$1
                    shift
                    todos=("$@")
                    ;;
                *)
                    flag=$default_flag
                    todos=("$@")
                    ;;
            esac
            ;;

        3)
            case "$1" in
                -h | --help   | \
                -l | --list   )
                    return $invalid_usage
                    ;;
                -c | --create | \
                -d | --delete | \
                -o | --open   | \
                -r | --rename | \
                -s | --show   )
                    flag=$1
                    shift
                    todos=("$@")
                    ;;
                *)
                    flag=$default_flag
                    todos=("$@")
                    ;;
            esac
            ;;

        *)
            case $1 in
                -h | --help   | \
                -l | --list   | \
                -r | --rename )
                    return $invalid_usage
                    ;;
                -c | --create | \
                -d | --delete | \
                -o | --open   | \
                -s | --show   )
                    flag=$1
                    shift
                    todos=("$@")
                    ;;
                *)
                    flag=$default_flag
                    todos=("$@")
                    ;;
            esac
            ;;
    esac
}


todo_cli() {
    if ! _parse_args "$@"; then
        printf 'ERROR: Invalid usage ...\n' >&2
        return $invalid_usage
    fi

    if [[ $flag == -h || $flag == --help ]]; then
        _usage
    else
        todo_manage "$flag" "${todos[@]}"
    fi
}

