#!/bin/bash

. ~/dotfiles/todo/lib.sh


readonly default_flag=--open


flag=$default_flag
todos=($default_todo)


_parse_args() {
    case $# in
        0)
            flag=$default_flag
            todos=($default_todo)
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
                -h | --help   | \
                -l | --list   )
                    return $invalid_syntax
                    ;;
                -d | --delete | \
                -n | --new    | \
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
    esac
}


cli() {
    if ! _parse_args "$@"; then
        printf 'ERROR: Invalid syntax ...\n' >&2
        return $invalid_syntax
    fi
    manage_todos "$flag" "${todos[@]}"
}

