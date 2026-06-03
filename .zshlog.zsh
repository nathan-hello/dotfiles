# zsh session log: script(1) terminal capture + JSONL metadata.
#
# Output:
#   ~/.local/state/zsh-session-log/<session-id>/meta.json
#   ~/.local/state/zsh-session-log/<session-id>/typescript
#   ~/.local/state/zsh-session-log/<session-id>/timing
#
# meta.json is JSONL: one JSON object per line.

if [ -n "${ZSH_SESSION_LOG_LOADED:-}" ]; then
	return 0 2>/dev/null || exit 0
fi
ZSH_SESSION_LOG_LOADED=1

case $- in
	*i*) ;;
	*) return 0 2>/dev/null || exit 0 ;;
esac

: "${ZSH_SESSION_LOG_DIR:=$HOME/.local/state/zsh-session-log}"
: "${ZSH_SESSION_LOG_CLEANUP_AGE_SECONDS:=300}"
: "${ZSH_SESSION_LOG_KEEP_BROKEN:=0}"

_zsl_cmd_exists() {
	command -v "$1" >/dev/null 2>&1
}

_zsl_now() {
	date '+%Y-%m-%dT%H:%M:%S%z'
}

_zsl_epoch() {
	date '+%s'
}

_zsl_sanitize() {
	printf '%s' "$1" | tr -cd '[:alnum:]_.-'
}

_zsl_disable() {
	return 0 2>/dev/null || exit 0
}

_zsl_cleanup_orphans() {
	[ -d "$ZSH_SESSION_LOG_DIR" ] || return 0

	_now="$(_zsl_epoch)"

	find "$ZSH_SESSION_LOG_DIR" -mindepth 1 -maxdepth 1 -type d 2>/dev/null |
		while IFS= read -r _d; do
			[ -e "$_d/meta.json" ] || continue

			if [ -e "$_d/typescript" ] || [ -e "$_d/timing" ]; then
				continue
			fi

			_mtime="$(
				find "$_d" -maxdepth 0 -printf '%T@\n' 2>/dev/null |
					sed 's/\..*$//'
			)"

			case $_mtime in
				'' | *[!0-9]*) continue ;;
			esac

			if [ $((_now - _mtime)) -ge "$ZSH_SESSION_LOG_CLEANUP_AGE_SECONDS" ]; then
				rm -rf -- "$_d"
			fi
		done
}

_zsl_write_json() {
	_type=$1
	shift

	[ -n "${ZSH_SESSION_LOG_META:-}" ] || return 0

	jq -cn --arg type "$_type" '
		$ARGS.positional as $a
		| { type: $type }
		+ reduce range(0; $a | length; 2) as $i ({};
			if ($i + 1) < ($a | length) then
				. + { ($a[$i]): $a[$i + 1] }
			else
				.
			end
		)
	' --args "$@" >>"$ZSH_SESSION_LOG_META"
}

_zsl_write_session_end() {
	_exit_status=$1
	_command_count=$2
	shift 2

	[ -n "${ZSH_SESSION_LOG_META:-}" ] || return "$_exit_status"

	jq -cn \
		--argjson exit_status "${_exit_status:-0}" \
		--argjson command_count "${_command_count:-0}" '
			$ARGS.positional as $a
			| {
				type: "session_end",
				exit_status: $exit_status,
				command_count: $command_count
			}
			+ reduce range(0; $a | length; 2) as $i ({};
				if ($i + 1) < ($a | length) then
					. + { ($a[$i]): $a[$i + 1] }
				else
					.
				end
			)
		' --args "$@" >>"$ZSH_SESSION_LOG_META"
}

_zsl_preexec() {
	ZSH_SESSION_LOG_COMMAND_COUNT=$((ZSH_SESSION_LOG_COMMAND_COUNT + 1))
	export ZSH_SESSION_LOG_COMMAND_COUNT

	_zsl_write_json \
		"command" \
		"time" "$(_zsl_now)" \
		"cwd" "$PWD" \
		"command" "$1"
}

_zsl_precmd() {
	_zsl_write_json \
		"prompt" \
		"time" "$(_zsl_now)" \
		"cwd" "$PWD"
}

_zsl_zshexit() {
	_exit_status=$?

	_zsl_write_session_end \
		"$_exit_status" \
		"${ZSH_SESSION_LOG_COMMAND_COUNT:-0}" \
		"time" "$(_zsl_now)" \
		"cwd" "$PWD"

	if [ "${ZSH_SESSION_LOG_KEEP_BROKEN:-0}" != 1 ]; then
		if [ ! -s "${ZSH_SESSION_LOG_TYPESCRIPT:-}" ] &&
			[ ! -s "${ZSH_SESSION_LOG_TIMING:-}" ]; then
			rm -rf -- "${ZSH_SESSION_LOG_SESSION_DIR:-/nonexistent}"
		fi
	fi

	return "$_exit_status"
}

mkdir -p -- "$ZSH_SESSION_LOG_DIR" || _zsl_disable

# Parent shell: create paths, then exec under script(1).
if [ -z "${ZSH_SESSION_LOG_ACTIVE:-}" ]; then
	_zsl_cleanup_orphans

	_zsl_cmd_exists jq || _zsl_disable
	_zsl_cmd_exists script || _zsl_disable

	ZSH_SESSION_LOG_TS="$(date '+%Y%m%d-%H%M%S')"
	ZSH_SESSION_LOG_HOST="$(_zsl_sanitize "${HOST:-unknown}")"
	ZSH_SESSION_LOG_SESSION_ID="${ZSH_SESSION_LOG_TS}-${ZSH_SESSION_LOG_HOST}-$$"
	ZSH_SESSION_LOG_SESSION_DIR="$ZSH_SESSION_LOG_DIR/$ZSH_SESSION_LOG_SESSION_ID"

	mkdir -p -- "$ZSH_SESSION_LOG_SESSION_DIR" || _zsl_disable

	ZSH_SESSION_LOG_META="$ZSH_SESSION_LOG_SESSION_DIR/meta.json"
	ZSH_SESSION_LOG_TYPESCRIPT="$ZSH_SESSION_LOG_SESSION_DIR/typescript"
	ZSH_SESSION_LOG_TIMING="$ZSH_SESSION_LOG_SESSION_DIR/timing"

	export ZSH_SESSION_LOG_ACTIVE=1
	export ZSH_SESSION_LOG_DIR
	export ZSH_SESSION_LOG_SESSION_ID
	export ZSH_SESSION_LOG_SESSION_DIR
	export ZSH_SESSION_LOG_META
	export ZSH_SESSION_LOG_TYPESCRIPT
	export ZSH_SESSION_LOG_TIMING
	export ZSH_SESSION_LOG_COMMAND_COUNT=0
	export ZSH_SESSION_LOG_CLEANUP_AGE_SECONDS
	export ZSH_SESSION_LOG_KEEP_BROKEN

	exec script -q -f -e \
		--timing="$ZSH_SESSION_LOG_TIMING" \
		"$ZSH_SESSION_LOG_TYPESCRIPT" \
		-c 'exec zsh -il'

	rm -rf -- "$ZSH_SESSION_LOG_SESSION_DIR"
	_zsl_disable
fi

# Child shell under script(1).

_zsl_cmd_exists jq || _zsl_disable

if [ -z "${ZSH_SESSION_LOG_SESSION_DIR:-}" ] ||
	[ -z "${ZSH_SESSION_LOG_META:-}" ] ||
	[ -z "${ZSH_SESSION_LOG_TYPESCRIPT:-}" ] ||
	[ -z "${ZSH_SESSION_LOG_TIMING:-}" ]; then
	_zsl_disable
fi

: "${ZSH_SESSION_LOG_COMMAND_COUNT:=0}"

# Create meta.json only in the script child.
: >"$ZSH_SESSION_LOG_META" || _zsl_disable

_zsl_write_json \
	"session_start" \
	"time" "$(_zsl_now)" \
	"session_id" "${ZSH_SESSION_LOG_SESSION_ID:-unknown}" \
	"host" "${HOST:-unknown}" \
	"pid" "$$" \
	"ppid" "$PPID" \
	"tty" "$(tty 2>/dev/null || printf 'unknown')" \
	"cwd" "$PWD" \
	"shell" "zsh" \
	"zsh_version" "${ZSH_VERSION:-unknown}" \
	"typescript" "$ZSH_SESSION_LOG_TYPESCRIPT" \
	"timing" "$ZSH_SESSION_LOG_TIMING"

autoload -Uz add-zsh-hook || _zsl_disable
add-zsh-hook preexec _zsl_preexec
add-zsh-hook precmd _zsl_precmd
add-zsh-hook zshexit _zsl_zshexit
