[[ -v _TODOLIB__SOURCED ]] && return
readonly _TODOLIB__SOURCED=true

. "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/cli.sh"

todolib_run_cli() { _todolib_cli_run_cli "$@" ; }
todolib_register_completion() { _todolib_cli_register_completion "$@" ; }
