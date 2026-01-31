[[ -v _TODOLIB_UTILS__SOURCED ]] && return
readonly _TODOLIB_UTILS__SOURCED=true

_todolib_utils_to_name_with_spaces() { printf -- "$1" | tr '_' ' ' ; }
_todolib_utils_to_name_with_underscores() { printf -- "$1" | tr '[:space:]' '_' ; }
