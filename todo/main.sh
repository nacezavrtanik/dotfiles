#!/bin/bash

invalid_syntax=1
does_not_exist=11
already_exists=12
is_not_alphanumeric=13


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
  13    is not alphanumeric.
EOF
}

delete() {
    if [[ ! -f "$1.md" ]]; then
        echo "ERROR: *$1* does not exist ..." >&2
        return $does_not_exist
    fi

    rm "$1.md"
    echo "Deleted *$1*!"
}

list() {
    ls -1 *.md | sed -e 's/^/* /' -e 's/.md$//' | less -F
}

new() {
    if [[ -f "$1.md" ]]; then
        echo "ERROR: *$1* already exists ..." >&2
        return $already_exists
    elif [[ ! $1 =~ ^[[:alnum:]]+$ ]]; then
        echo "ERROR: *$1* is not alphanumeric ..." >&2
        return $is_not_alphanumeric
    fi

    title="$(echo "$1" | tr [:lower:] [:upper:])"
    underline=$(echo $title | tr [:print:] '=')
    printf '\n%s\n%s\n\n' "$title" "$underline" > "$1.md"

    echo "Created *$1*!"
}

open() {
    todos=""
    while [[ $# -gt 0 ]]; do
        if [[ ! -f "$1.md" ]]; then
            echo "ERROR: *$1* does not exist ..." >&2
            return $does_not_exist
        fi
        todos="$todos $1.md"
        shift
    done

    nvim -O $todos
}

rename() {
    if [[ ! -f "$1.md" ]]; then
        echo "ERROR: *$1* does not exist ..." >&2
        return $does_not_exist
    elif [[ -f "$2.md" ]]; then
        echo "ERROR: *$2* already exists ..." >&2
        return $already_exists
    elif [[ ! $1 =~ ^[[:alnum:]]+$ ]]; then
        echo "ERROR: *$2* is not alphanumeric ..." >&2
        return $is_not_alphanumeric
    fi

    mv "$1.md" "$2.md"
    old_title=$(echo $1 | tr [:lower:] [:upper:])
    old_underline=$(head --bytes="${#old_title}" < /dev/zero | tr '\0' '=')
    if
        (sed -n -e '2p' "$2.md" | grep "^$old_title$" > /dev/null) &&
        (sed -n -e '3p' "$2.md" | grep "^$old_underline$" > /dev/null)
    then
        new_title=$(echo $2 | tr [:lower:] [:upper:])
        new_underline=$(head --bytes="${#new_title}" < /dev/zero | tr '\0' '=')
        sed -i -e "2 s/^$old_title$/$new_title/" "$2.md"
        sed -i -e "3 s/^$old_underline$/$new_underline/" "$2.md"
    fi

    echo "*$1* renamed to *$2*!"
}

show() {
    if [[ ! -f "$1.md" ]]; then
        echo "ERROR: *$1* does not exist ..." >&2
        return $does_not_exist
    fi

    less -F "$1.md"
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
            todos=$default_todo
            ;;

        1)
            case $1 in
                -h | --help | \
                -l | --list | \
                -o | --open | \
                -s | --show )
                    flag=$1
                    todos=$default_todo
                    ;;

                *)
                    flag=$default_flag
                    todos=$1
                    ;;
            esac
            ;;

        2)
            case $1 in
                -d | --delete | \
                -n | --new | \
                -o | --open | \
                -s | --show )
                    flag=$1
                    todos=$2
                    ;;

                -h | --help | \
                -l | --list | \
                -r | --rename )
                    return $invalid_syntax
                    ;;

                *)
                    flag=$default_flag
                    todos="$1 $2"
                    ;;
            esac
            ;;

        3)
            case $1 in
                -o | --open | \
                -r | --rename )
                    flag=$1
                    todos="$2 $3"
                    ;;

                -d | --delete | \
                -h | --help | \
                -l | --list | \
                -n | --new | \
                -s | --show )
                    return $invalid_syntax
                    ;;

                *)
                    flag=$default_flag
                    todos="$@"
            esac
            ;;

        *)
            case $1 in
                -o | --open)
                    flag=$1
                    shift
                    todos="$@"
                    ;;

                -d | --delete | \
                -h | --help | \
                -l | --list | \
                -n | --new | \
                -r | --rename | \
                -s | --show )
                    return $invalid_syntax
                    ;;

                *)
                    flag=$default_flag
                    todos="$@"
                    ;;
            esac
            ;;
    esac
    printf -- "$flag $todos"
}

manage_todos() {
    cd $todos_dir

    [[ -f "$default_todo.md" ]] || new $default_todo > /dev/null
    [[ -f "$workspace_todo.md" ]] || new $workspace_todo > /dev/null

    case $1 in
        -d | --delete )
            delete $2
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
            new $2
            exit_code=$?
            ;;

        -o | --open )
            shift
            open "$@"
            exit_code=$?
            ;;

        -r | --rename )
            rename $2 $3
            exit_code=$?
            ;;

        -s | --show )
            show $2
            exit_code=$?
            ;;
    esac

    cd "$initial_dir"
    return $exit_code
}


if args=$(parse_args "$@"); then
    manage_todos $args
else
    cat << EOF >&2
Invalid syntax ...
Try 'todo --help' for more information.
EOF
    (exit $invalid_syntax)
fi

