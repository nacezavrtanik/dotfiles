#!/bin/bash

invalid_syntax=1
does_not_exist=11
already_exists=12
not_alphanumeric_with_spaces=13


usage() {
    cat << EOF
Usage: todo [OPTION]
Manage TODOs.

Options:
  -d, --delete TODO       delete TODO
  -h, --help              show this help and exit
  -l, --list              list all TODOs
  -n, --new TODO          create new TODO
  -o, --open [TODO]...    open TODOs in Neovim;
                            this is the default option if OPTION is not given;
                            if no TODOs are given, the default TODO is opened
  -r, --rename OLD NEW    rename OLD to NEW
  -s, --show TODO         show TODO in the terminal;
                            if TODO is not given, the default TODO is shown

Exit status:
  0     everything OK,
  1     invalid syntax,
  11    does not exist,
  12    already exists,
  13    not alphanumeric with spaces.
EOF
}

arg_to_filename() {
    printf '%s.md' "$1" | tr '[:space:]' '_'
}

delete() {
    file=$(arg_to_filename "$1")
    if [[ ! -f $file ]]; then
        echo "ERROR: *$1* does not exist ..." >&2
        return $does_not_exist
    fi

    rm $file
    echo "Deleted *$1*!"
}

list() {
    ls -1 *.md | sed -e 's/^/* /' -e 's/_/ /g' -e 's/.md$//' | less -F
}

new() {
    if [[ ! $1 =~ ^[\ [:alnum:]]+$ ]]; then
        echo "ERROR: *$1* is not alphanumeric with spaces ..." >&2
        return $not_alphanumeric_with_spaces
    fi
    file=$(arg_to_filename "$1")
    if [[ -f $file ]]; then
        echo "ERROR: *$1* already exists ..." >&2
        return $already_exists
    fi

    title="$(printf -- "$1" | tr [:lower:] [:upper:])"
    underline=$(printf -- "$title" | tr [:print:] '=')
    printf '\n%s\n%s\n\n' "$title" "$underline" > $file

    echo "Created *$1*!"
}

open() {
    todos=""
    while [[ $# -gt 0 ]]; do
        file=$(arg_to_filename "$1")
        if [[ ! -f $file ]]; then
            echo "ERROR: *$1* does not exist ..." >&2
            return $does_not_exist
        fi
        todos="$todos $file"
        shift
    done

    nvim -O $todos
}

rename() {
    old_file=$(arg_to_filename "$1")
    if [[ ! -f $old_file ]]; then
        echo "ERROR: *$1* does not exist ..." >&2
        return $does_not_exist
    elif [[ ! $2 =~ ^[\ [:alnum:]]+$ ]]; then
        echo "ERROR: *$2* is not alphanumeric with spaces ..." >&2
        return $not_alphanumeric_with_spaces
    fi
    new_file=$(arg_to_filename "$2")
    if [[ -f $new_file ]]; then
        echo "ERROR: *$2* already exists ..." >&2
        return $already_exists
    fi

    mv $old_file $new_file
    old_title="$(printf -- "$1" | tr [:lower:] [:upper:])"
    old_underline=$(printf -- "$old_title" | tr [:print:] '=')
    if
        (sed -n -e '2p' $new_file | grep "^$old_title$" > /dev/null) &&
        (sed -n -e '3p' $new_file | grep "^$old_underline$" > /dev/null)
    then
        new_title="$(printf -- "$2" | tr [:lower:] [:upper:])"
        new_underline=$(printf -- "$new_title" | tr [:print:] '=')
        sed -i -e "2 s/^$old_title$/$new_title/" $new_file
        sed -i -e "3 s/^$old_underline$/$new_underline/" $new_file
    fi

    echo "*$1* renamed to *$2*!"
}

show() {
    file=$(arg_to_filename "$1")
    if [[ ! -f $file ]]; then
        echo "ERROR: *$1* does not exist ..." >&2
        return $does_not_exist
    fi

    less -F $file
}


initial_dir="$(pwd)"
todos_dir=~/dotfiles/todo/.todos/
mkdir --parents $todos_dir
default_flag=--open
default_todo=todo
workspace_todo=workspace


parse_args() {
    case $# in
        0)
            flag=$default_flag
            todos=("$default_todo")
            ;;

        1)
            case "$1" in
                -d | --delete | \
                -n | --new    | \
                -r | --rename )
                    return $invalid_syntax
                    ;;
                -h | --help | \
                -l | --list | \
                -o | --open | \
                -s | --show )
                    flag=$1
                    todos=("$default_todo")
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
                    return $invalid_syntax
                    ;;
                -d | --delete | \
                -n | --new    | \
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
                -d | --delete | \
                -h | --help   | \
                -l | --list   | \
                -n | --new    | \
                -s | --show   )
                    return $invalid_syntax
                    ;;
                -o | --open   | \
                -r | --rename )
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
                -d | --delete | \
                -h | --help   | \
                -l | --list   | \
                -n | --new    | \
                -r | --rename | \
                -s | --show   )
                    return $invalid_syntax
                    ;;
                -o | --open)
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

    ARGS=("$flag")
    ARGS+=("${todos[@]}")
}


main() {
    cd $todos_dir
    [[ -f "$default_todo.md" ]] || new $default_todo > /dev/null
    [[ -f "$workspace_todo.md" ]] || new $workspace_todo > /dev/null

    set -- "${ARGS[@]}"

    case $1 in
        -d | --delete )
            delete "$2"
            exit_code=$?
            ;;

        -h | --help )
            usage
            exit_code=$?
            ;;

        -l | --list )
            list
            exit_code=$?
            ;;

        -n | --new )
            new "$2"
            exit_code=$?
            ;;

        -o | --open )
            shift
            open "$@"
            exit_code=$?
            ;;

        -r | --rename )
            shift
            rename "$@"
            exit_code=$?
            ;;

        -s | --show )
            show "$2"
            exit_code=$?
            ;;
    esac

    cd "$initial_dir"
    return $exit_code
}


if ! parse_args "$@"; then
    echo "ERROR: Invalid syntax ..." >&2
    exit $invalid_syntax
fi


main

