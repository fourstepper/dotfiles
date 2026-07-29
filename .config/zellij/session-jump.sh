#!/usr/bin/env bash
# Alt-o session jumper (tmux M-o style popup).
#
# Lists other sessions most-recently-visited first, so Enter jumps back to the
# session you came from. Resurrectable sessions (zellij's "EXITED - attach to
# resurrect") are listed too, tagged `exited` and grouped below the live ones so
# the pre-highlighted entry is never a dead session; picking one resurrects it
# with its tabs, panes and cwds. Current session excluded. tab/shift-tab to
# move, type to filter. Type a name with no match + Enter to create and switch
# to a new session.
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

# Split live from resurrectable, newest-created first, current excluded.
zellij ls -rn 2>/dev/null |
    awk -v cur="$cur" -v live="$tmp/live" -v dead="$tmp/dead" '
        $1 == cur { next }
        { print $1 > ($0 ~ /EXITED/ ? dead : live) }
    '
touch "$tmp/live" "$tmp/dead"

# Order one group by last-visited (from $mru), then whatever is left as-is.
by_recency() {
    local names=$1 seen=$tmp/seen
    tail -r "$mru" 2>/dev/null | grep -xF -f "$names" | awk '!s[$0]++' > "$seen"
    cat "$seen"
    grep -vxF -f "$seen" "$names"
}

# Pad names so the `exited` tags line up in one column. The tag is greyed with
# an explicit 256-color grey rather than SGR 2 (dim), which does not survive
# zellij's pass-through to the terminal.
width=$(awk '{ if (length > w) w = length } END { print w + 0 }' "$tmp/live" "$tmp/dead")

out=$(
    {
        by_recency "$tmp/live"
        by_recency "$tmp/dead" |
            awk -v w="$width" '{ printf "%-*s  \033[38;5;245mexited\033[0m\n", w, $0 }'
    } |
        fzf --ansi --reverse --no-sort --cycle --print-query \
            --header=jump-to-session --bind=shift-tab:up,tab:down
)

query=$(printf '%s\n' "$out" | head -n1)
# Strips the padding and the `exited` tag off a picked resurrectable session.
picked=$(printf '%s\n' "$out" | tail -n +2 | awk 'NF { print $1 }')
name=${picked:-$query}
[[ -n $name ]] || exit 0

if [[ -n $cur ]]; then
    printf '%s\n' "$cur" >> "$mru"
    tail -n 200 "$mru" > "$mru.new" && mv "$mru.new" "$mru"
fi

# Resurrects the session if it is one of the EXITED ones, otherwise plain switch
# (or create, for a name typed in that matched nothing).
zellij action switch-session "$name"
