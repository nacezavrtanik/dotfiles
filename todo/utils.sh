todoutils_to_name_with_spaces() { printf -- "$1" | tr '_' ' ' ; }
todoutils_to_name_with_underscores() { printf -- "$1" | tr '[:space:]' '_' ; }
