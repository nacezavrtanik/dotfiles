[[ -v _SHLFLIB__SOURCED ]] && return
readonly _SHLFLIB__SOURCED=true

. "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/cli.sh"

shlflib_run_cli() { _shlflib_cli_run_cli "$@" ; }
shlflib_register_completion() { _shlflib_cli_register_completion "$@" ; }
