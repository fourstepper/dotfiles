#!/usr/bin/env bash
# Alt-o session jumper (tmux M-o style popup).
#
# Lists other live sessions most-recently-visited first, so Enter jumps back to
# the session you came from. Current session and EXITED ones are excluded.
# tab/shift-tab to move, type to filter. Type a name with no match + Enter to
# create and switch to a new session.
#
# zellij only reports session creation time, not last-attached time, so
# recency is tracked here: every jump appends the session being left to $mru.
# Sessions never jumped away from fall back to newest-created-first, below the
# visited ones.
set -uo pipefail

mru="${XDG_STATE_HOME:-$HOME/.local/state}/zellij/session-mru"
mkdir -p "$(dirname "$mru")"

# Always set inside a zellij pane; zellij's own "(current)" marker is derived
# from this same variable, so there is no better fallback.
cur="${ZELLIJ_SESSION_NAME:-}"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# Live sessions, newest-created first, current excluded.
zellij ls -rn 2>/dev/null | grep -v 'EXITED' | awk '{print $1}' |
    grep -vxF "$cur" > "$tmp/live"

# Previously visited sessions that still exist, most recent first, deduped.
tail -r "$mru" 2>/dev/null | grep -xF -f "$tmp/live" | awk '!seen[$0]++' > "$tmp/mru"

out=$(
    { cat "$tmp/mru"; grep -vxF -f "$tmp/mru" "$tmp/live"; } |
        fzf --reverse --no-sort --cycle --print-query \
            --header=jump-to-session --bind=shift-tab:up,tab:down
)

query=$(printf '%s\n' "$out" | head -n1)
picked=$(printf '%s\n' "$out" | tail -n +2)
name=${picked:-$query}
[[ -n $name ]] || exit 0

if [[ -n $cur ]]; then
    printf '%s\n' "$cur" >> "$mru"
    tail -n 200 "$mru" > "$mru.new" && mv "$mru.new" "$mru"
fi

zellij action switch-session "$name"
