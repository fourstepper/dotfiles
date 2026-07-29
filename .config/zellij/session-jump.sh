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
#
# Resurrecting also rewrites `claude` panes to resume, so they come back on the
# conversation they were on instead of a blank one.
set -uo pipefail

mru="${XDG_STATE_HOME:-$HOME/.local/state}/zellij/session-mru"
mkdir -p "$(dirname "$mru")"

# Always set inside a zellij pane; zellij's own "(current)" marker is derived
# from this same variable, so there is no better fallback.
cur="${ZELLIJ_SESSION_NAME:-}"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# Zellij records the foreground process of every pane in a per-session
# session-layout.kdl and replays it on resurrect. A pane running claude is
# serialized as a bare `command="claude"`, which resurrects into a fresh, empty
# conversation, so an explicit resume flag is injected here instead.
#
# ~/.claude/hooks/zellij-tag-pane.sh names each claude pane `claude:<8 hex of
# session id>` and zellij serializes pane names, so the tag survives into the
# layout: it is resolved back to a full session id through the transcript
# filename and the pane resurrects onto its own conversation, even with several
# claude panes in one cwd. Untagged panes (claude started before the hook
# existed) fall back to --continue, ie. the newest conversation for the cwd.
#
# Only the session being resurrected is rewritten; zellij rewrites the layout of
# a live session every serialization_interval anyway.
claude_resume() {
    local session=$1 layout tag id
    layout=$(echo "$cache"/*/session_info/"$session"/session-layout.kdl)
    [[ -f $layout ]] || return 0

    # tag -> full session id, resolved from the transcript claude keeps per
    # conversation. Transcripts outlive the session, so a tag stays resolvable.
    : > "$tmp/ids"
    for tag in $(grep -o 'name="claude:[0-9a-f]\{8\}"' "$layout" | grep -o '[0-9a-f]\{8\}' | sort -u); do
        id=$(echo "$HOME"/.claude/projects/*/"$tag"*.jsonl)
        id=${id%% *}
        [[ -f $id ]] || continue
        id=${id##*/}
        printf '%s\t%s\n' "$tag" "${id%.jsonl}" >> "$tmp/ids"
    done

    awk -v ids="$tmp/ids" '
        BEGIN {
            while ((getline line < ids) > 0) {
                split(line, field, "\t")
                id[field[1]] = field[2]
            }
        }

        # Drops the resume flags a previous resurrect injected while keeping
        # anything else the pane was started with (--model, --verbose, ...), so
        # the flag added below is the only one claude sees.
        function kept_args(line,    count, part, i, token, drop_value, out) {
            count = split(line, part, "\"")
            # Quoted tokens sit at the even indices of a split on the quotes.
            for (i = 2; i < count; i += 2) {
                token = part[i]
                if (drop_value && token ~ /^[0-9a-f-]{8,}$/) { drop_value = 0; continue }
                drop_value = 0
                if (token == "--continue" || token == "-c") continue
                if (token == "--resume" || token == "-r" || token == "--session-id") {
                    drop_value = 1
                    continue
                }
                out = out " \"" token "\""
            }
            return out
        }

        /pane command="([^"]*\/)?claude"/ && /\{[ \t]*$/ {
            header = $0
            match(header, /^[ \t]*/)
            indent = substr(header, 1, RLENGTH)

            resume = ""
            if (match(header, /name="claude:[0-9a-f]+"/)) {
                tag = substr(header, RSTART, RLENGTH)
                gsub(/^name="claude:|"$/, "", tag)
                resume = id[tag]
            }

            # Command panes serialize as a flat list of nodes, so scanning to the
            # closing brace at the header indent cannot run past the block.
            body = ""
            extra = ""
            while ((getline line) > 0) {
                if (line == indent "}") break
                if (line ~ /^[ \t]*args /) { extra = kept_args(line); continue }
                body = body line "\n"
            }

            print header
            if (resume != "")
                printf "%s    args \"--resume\" \"%s\"%s\n", indent, resume, extra
            else
                printf "%s    args \"--continue\"%s\n", indent, extra
            printf "%s", body
            print indent "}"
            next
        }
        { print }
    ' "$layout" > "$tmp/layout" && cat "$tmp/layout" > "$layout"
}

# Path is version-dependent (`contract_version_1/` today), hence the glob above.
cache=$(zellij setup --check 2>/dev/null | sed -n 's/^\[CACHE DIR\]: //p' | tr -d '"')

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
if grep -qxF "$name" "$tmp/dead"; then
    claude_resume "$name"
fi

zellij action switch-session "$name"
