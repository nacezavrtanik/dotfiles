. ~/dotfiles/todo/lib.sh
. ~/dotfiles/todo/utils.sh
. ~/dotfiles/todo/exitcodes.sh


_todocli_usage() {
    cat << EOF
Usage: todo [OPTION]
Manage TODOs stored as Markdown files.

The TODOs \`$TODOLIB_DEFAULT_TODO\` (default) and \`$TODOLIB_WORKSPACE_TODO\` are created automatically.

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
printf '  %-2s    %s\n' "$TODOEXITCODES_SUCCESS"        "success"
printf '  %-2s    %s\n' "$TODOEXITCODES_INVALID_USAGE"  "invalid usage"
printf '  %-2s    %s\n' "$TODOEXITCODES_INVALID_NAME"   "invalid name"
printf '  %-2s    %s\n' "$TODOEXITCODES_DOES_NOT_EXIST" "does not exist"
printf '  %-2s    %s\n' "$TODOEXITCODES_ALREADY_EXISTS" "already exists"
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
        return $TODOEXITCODES_INVALID_USAGE
    fi

    local names name value
    for value in "${values[@]}"; do
        name="$(todoutils_to_name_with_underscores "$value")"
        if [[ ! $name =~ ^[-_[:alnum:]]+$ ]]; then
            printf 'ERROR: *%s* contains invalid characters ...\n' "$value" >&2
            return $TODOEXITCODES_INVALID_NAME
        else names="$names $name"
        fi
    done

    printf '%s ' "$flag ${names[@]}"
}


_todocli_completion() {
    local longopts names current
    longopts='--create --delete --help --list --list-raw --open --rename --show'
    names="$(todolib_manage_todos -L)"
    current="$(todoutils_to_name_with_underscores "${COMP_WORDS[COMP_CWORD]}")"

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


todocli_register_completion() {
    complete -o nosort -F _todocli_completion todo
}


todocli_run_cli() {
    local args=( $(_todocli_parse_args "$@") )
    local exit_code=$?; [[ $exit_code -gt 0 ]] && return $exit_code

    if [[ ${args[0]} == -h || ${args[0]} == --help ]]; then
        _todocli_usage
    else
        todolib_manage_todos ${args[@]}
    fi
}

