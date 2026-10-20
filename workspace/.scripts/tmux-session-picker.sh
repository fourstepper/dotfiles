#!/usr/bin/env bash
# Jump to a tmux session with fzf. Enter picks the highlighted session, or
# creates one named after the query when nothing matches; ctrl-n always
# creates one named after the query.

name=$(
	tmux list-sessions -F '#{session_last_attached},#{session_name}' |
		sort -rn |
		tail -n +2 |
		cut -d',' -f2- |
		fzf --reverse --header 'jump-to-session (ctrl-n: new)' \
			--bind=shift-tab:up,tab:down --cycle \
			--bind 'enter:accept-or-print-query' \
			--bind 'ctrl-n:become(echo {q})' \
			--preview 'tmux capture-pane -pt {}'
)
[ -n "$name" ] || exit 0

# "=" forces an exact match; tmux otherwise prefix-matches session names.
# new-session -P reports the real name, since tmux rewrites "." and ":".
if ! tmux has-session -t "=$name" 2>/dev/null; then
	name=$(tmux new-session -d -P -F '#{session_name}' -s "$name") || exit 1
fi
tmux switch-client -t "=$name"
