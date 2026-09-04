#!/usr/bin/env bash
# Opens a new zellij tab in the directory of the pane that was focused when
# Alt-t (Cmd-T in Alacritty) was pressed.
#
# A keybound `NewTab` only takes a static `cwd`, with no way to say "wherever
# the focused pane happens to be", so the keybinding runs this in a throwaway
# floating pane instead. Zellij opens new panes in the focused pane's
# directory, so $PWD here is already the directory the new tab should get.
set -uo pipefail

exec zellij action new-tab --cwd "$PWD"
