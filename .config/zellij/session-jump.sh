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
# With --last the picker is skipped entirely and the top entry - the session you
# came from - is jumped to straight away, no popup and no fzf.
#
# zellij only reports session creation time, not last-attached time, so
# recency is tracked here: every jump appends the session being left to $mru.
# Sessions never jumped away from fall back to newest-created-first, below the
# visited ones.
#
# The hot path is kept to three processes - zellij ls, awk, fzf - because this
# runs on every Alt-o and the popup has to feel instant. Everything the
# resurrect path needs (cache dir lookup, temp files) is set up lazily inside
# claude_resume, which only runs when an exited session is actually picked.
set -uo pipefail

mru="${XDG_STATE_HOME:-$HOME/.local/state}/zellij/session-mru"

# Always set inside a zellij pane; zellij's own "(current)" marker is derived
# from this same variable, so there is no better fallback.
cur="${ZELLIJ_SESSION_NAME:-}"

# Resurrecting rewrites `claude` panes to resume, so they come back on the
# conversation they were on instead of a blank one.
#
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
    local session=$1 cache layout tag id tmp

    # Path is version-dependent (`contract_version_1/` today), hence the glob.
    cache=$(zellij setup --check 2>/dev/null | sed -n 's/^\[CACHE DIR\]: //p' | tr -d '"')
    layout=$(echo "$cache"/*/session_info/"$session"/session-layout.kdl)
    [[ -f $layout ]] || return 0

    tmp=$(mktemp -d) || return 0
    trap 'rm -rf "$tmp"' RETURN

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

# One awk builds the whole menu: current session dropped, live sessions before
# resurrectable ones, each group ordered by last-visited (from $mru) and then by
# newest-created (the order `zellij ls -rn` already emits).
#
# Every row is `<live|dead>\t<display>`; fzf is pointed at field 2 so the status
# flag is invisible and unmatchable but still comes back on the picked line.
# The `exited` tags are padded into one column and greyed with an explicit
# 256-color grey rather than SGR 2 (dim), which does not survive zellij's
# pass-through to the terminal.
session_rows() {
    zellij ls -rn 2>/dev/null |
        awk -v cur="$cur" -v mru="$mru" '
            function emit(names, count, tag,    i, rank_best, pick, seen, r) {
                # Ranked names first, most recently left at the top. count is
                # small (one line per session), so repeated max-scan is cheaper
                # than any real sort.
                for (;;) {
                    rank_best = 0
                    pick = 0
                    for (i = 1; i <= count; i++) {
                        if (seen[i]) continue
                        r = rank[names[i]]
                        if (r > rank_best) { rank_best = r; pick = i }
                    }
                    if (!pick) break
                    seen[pick] = 1
                    show(names[pick], tag)
                }
                for (i = 1; i <= count; i++)
                    if (!seen[i]) show(names[i], tag)
            }

            function show(name, tag) {
                if (tag == "")
                    printf "live\t%s\n", name
                else
                    printf "dead\t%-*s  \033[38;5;245m%s\033[0m\n", width, name, tag
            }

            BEGIN {
                # Later line in $mru = more recently left = higher rank.
                while ((getline name < mru) > 0) rank[name] = ++visits
            }

            $1 == cur { next }

            {
                if (length($1) > width) width = length($1)
                if ($0 ~ /EXITED/) dead[++dead_count] = $1
                else live[++live_count] = $1
            }

            END {
                emit(live, live_count, "")
                emit(dead, dead_count, "exited")
            }
        '
}

if [[ ${1:-} == --last ]]; then
    picked=$(session_rows | head -n1)
    query=
else
    out=$(session_rows |
        fzf --ansi --reverse --no-sort --cycle --print-query \
            --delimiter=$'\t' --with-nth=2 \
            --header=jump-to-session --bind=shift-tab:up,tab:down)

    # `out` is the typed query, then the picked row if anything was picked.
    # Split with parameter expansion rather than head/tail - two more forks on a
    # path that is meant to feel instant.
    query=${out%%$'\n'*}
    picked=${out#*$'\n'}
    [[ $picked == "$query" ]] && picked=
fi

# fzf strips the ANSI it rendered, so a picked row is a plain
# `live|dead<TAB>name[padding  exited]`.
status=${picked%%$'\t'*}
name=${picked#*$'\t'}
name=${name%%[[:space:]]*}
name=${name:-$query}
[[ -n $name ]] || exit 0

if [[ -n $cur ]]; then
    [[ -d ${mru%/*} ]] || mkdir -p "${mru%/*}"
    printf '%s\n' "$cur" >> "$mru"
    tail -n 200 "$mru" > "$mru.new" && mv "$mru.new" "$mru"
fi

# Resurrects the session if it is one of the EXITED ones, otherwise plain switch
# (or create, for a name typed in that matched nothing).
[[ $status == dead ]] && claude_resume "$name"

exec zellij action switch-session "$name"
