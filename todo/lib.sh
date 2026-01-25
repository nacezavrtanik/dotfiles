#!/bin/bash

readonly invalid_syntax=1
readonly does_not_exist=11
readonly already_exists=12
readonly not_alphanumeric_with_spaces=13


readonly default_todo=todo
readonly workspace_todo=workspace


_arg_to_filename() { printf '%s.md' "$1" | tr '[:space:]' '_' ; }


_usage() {
    cat << EOF
Usage: todo [OPTION]
Manage TODOs.

Options:
  -d, --delete TODO...    delete TODOs
  -h, --help              show this help and exit
  -l, --list              list all TODOs
  -n, --new TODO...       create new TODOs
  -o, --open [TODO]...    open TODOs in Neovim;
                            this is the default option if OPTION is not given;
                            if no TODOs are given, the default TODO is opened
  -r, --rename OLD NEW    rename OLD to NEW
  -s, --show [TODO]...    show TODOs in the terminal;
                            if no TODOs are given, the default TODO is shown

Exit status:
  0     everything OK,
  1     invalid syntax,
  11    does not exist,
  12    already exists,
  13    not alphanumeric with spaces.
EOF
}


_delete() {
    while [[ $# -gt 0 ]]; do
        local file=$(_arg_to_filename "$1")
        if [[ ! -f $file ]]; then
            echo "ERROR: *$1* does not exist ..." >&2
            return $does_not_exist
        fi

        rm $file
        echo "Deleted *$1*!"
        shift
    done
}


_list() {
    ls -1 *.md | sed -e 's/^/* /' -e 's/_/ /g' -e 's/.md$//' | less -F
}


_new() {
    while [[ $# -gt 0 ]]; do
        if [[ ! $1 =~ ^[\ [:alnum:]]+$ ]]; then
            echo "ERROR: *$1* is not alphanumeric with spaces ..." >&2
            return $not_alphanumeric_with_spaces
        fi
        local file=$(_arg_to_filename "$1")
        if [[ -f $file ]]; then
            echo "ERROR: *$1* already exists ..." >&2
            return $already_exists
        fi

        local title="$(printf -- "$1" | tr [:lower:] [:upper:])"
        local underline=$(printf -- "$title" | tr [:print:] '=')
        printf '\n%s\n%s\n\n' "$title" "$underline" > $file

        echo "Created *$1*!"
        shift
    done
}


_open() {
    local todos=""
    while [[ $# -gt 0 ]]; do
        local file=$(_arg_to_filename "$1")
        if [[ ! -f $file ]]; then
            echo "ERROR: *$1* does not exist ..." >&2
            return $does_not_exist
        fi
        todos="$todos $file"
        shift
    done

    nvim -O $todos
}


_rename() {
    local old_file=$(_arg_to_filename "$1")
    if [[ ! -f $old_file ]]; then
        echo "ERROR: *$1* does not exist ..." >&2
        return $does_not_exist
    elif [[ ! $2 =~ ^[\ [:alnum:]]+$ ]]; then
        echo "ERROR: *$2* is not alphanumeric with spaces ..." >&2
        return $not_alphanumeric_with_spaces
    fi
    local new_file=$(_arg_to_filename "$2")
    if [[ -f $new_file ]]; then
        echo "ERROR: *$2* already exists ..." >&2
        return $already_exists
    fi

    mv $old_file $new_file
    local old_title="$(printf -- "$1" | tr [:lower:] [:upper:])"
    local old_underline=$(printf -- "$old_title" | tr [:print:] '=')
    if
        (sed -n -e '2p' $new_file | grep "^$old_title$" > /dev/null) &&
        (sed -n -e '3p' $new_file | grep "^$old_underline$" > /dev/null)
    then
        local new_title="$(printf -- "$2" | tr [:lower:] [:upper:])"
        local new_underline=$(printf -- "$new_title" | tr [:print:] '=')
        sed -i -e "2 s/^$old_title$/$new_title/" $new_file
        sed -i -e "3 s/^$old_underline$/$new_underline/" $new_file
    fi

    echo "*$1* renamed to *$2*!"
}


_show() {
    local todos=""
    while [[ $# -gt 0 ]]; do
        local file=$(_arg_to_filename "$1")
        if [[ ! -f $file ]]; then
            echo "ERROR: *$1* does not exist ..." >&2
            return $does_not_exist
        fi
        todos="$todos $file"
        shift
    done

    cat $todos | less -F
}


manage_todos() {
    local initial_dir="$(pwd)"
    local todos_dir=~/dotfiles/todo/.todos/
    mkdir --parents $todos_dir
    cd $todos_dir
    _new $default_todo $workspace_todo > /dev/null 2>&1

    local exit_code
    case $1 in
        -d | --delete )
            shift
            _delete "$@"
            exit_code=$?
            ;;
        -h | --help )
            _usage
            exit_code=$?
            ;;
        -l | --list )
            _list
            exit_code=$?
            ;;
        -n | --new )
            shift
            _new "$@"
            exit_code=$?
            ;;
        -o | --open )
            shift
            _open "$@"
            exit_code=$?
            ;;
        -r | --rename )
            shift
            _rename "$@"
            exit_code=$?
            ;;
        -s | --show )
            shift
            _show "$@"
            exit_code=$?
            ;;
    esac

    cd "$initial_dir"
    return $exit_code
}

