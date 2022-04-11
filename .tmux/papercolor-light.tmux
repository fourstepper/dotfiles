#!/usr/bin/env bash

main() {

	# Colors
	navy='#005f87'
	white='#f5f5f5'
	black='#4d4d4c'
	pink='#d7005f'
	aqua='#3e999f'

	# Icons
	left_sep=''
	right_sep=''

	tmux set-option -g status on
	tmux set-option -g status-left-length 100
	tmux set-option -g status-right-length 100
	tmux set-option -g status-bg "${navy}"
	tmux set-option -g status-fg "${white}"
	tmux set-option -g pane-active-border-style "fg=${pink}"
	tmux set-option -g status-left "#[bg=${pink},fg=${white}] #S #[bg=${white},fg=${pink}]${right_sep} #[bg=${white},fg=${black}]#I #[bg=${navy},fg=${white}]${right_sep}"
	tmux set-option -g status-right "#H ${left_sep}#[bg=${white},fg=${black}] %Y-%m-%d %H:%M %p"
	tmux set-window-option -g window-status-format " #I #W #F"
	tmux set-window-option -g window-status-current-format "#[bg=${aqua},fg=${navy}]${right_sep}#[fg=${white}] #I #W #[bg=${navy},fg=${aqua}]${right_sep}"
}

main

# vim: set filetype=bash
