# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export GPG_TTY=$(tty)

# non-mac rules
if [ "$(uname)" != "Darwin" ]; then
    # SSH agent and GPG
    unset SSH_AGENT_PID

    if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
        export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
    fi

    gpg-connect-agent updatestartuptty /bye >/dev/null

    # linux-desktop specific aliases
    alias nautilus='nautilus -w $(pwd)'
fi


# mac-only rules
if [ "$(uname)" == "Darwin" ]; then
    if [ -d "/opt/homebrew/Caskroom/google-cloud-sdk" ]; then
        # Source google-cloud-sdk components
        source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc"
        source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"
        # bash completion v2
    fi
    [[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"
    # export homebrew sbin
    export PATH="/opt/homebrew/sbin:$PATH"
    export NVM_DIR="$HOME/.nvm"
fi

# ve <virtualenv name> activates the virtualenv
ve() { source $1/bin/activate; }

# source kubectl completion if kubectl is in $PATH
if which kubectl &> /dev/null; then
    source <(kubectl completion bash)
fi

export EDITOR="nvim"

# don't warn about bash not being available on macos
export BASH_SILENCE_DEPRECATION_WARNING=1

# fzf command (primarily for neovim)
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules,**/.terragrunt-cache/**,**/.cache/**}/*"'
export FZF_DEFAULT_OPTS='--bind J:down,K:up --ansi'

# Add to PATH
export PATH=/usr/local/go/bin:/opt/homebrew/bin:$HOME/.cargo/bin/:$HOME/go/bin:$HOME/workspace/.scripts:$HOME/bin:$PATH

# # Ruby gem paths
export GEM_HOME=$HOME/.gem

# Avoid duplicates
HISTCONTROL=ignoredups:erasedups

# Set bigger history
export HISTSIZE=100000
export HISTFILESIZE=100000

# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# After each command, append to the history file right away
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\n\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

alias vim='nvim'
alias v='nvim'
alias cds='cd ~/workspace/'
alias cdw='cd ~/workspace/work/'
alias cdp='cd ~/workspace/personal/'
alias cdi='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs'
alias randompass='< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;'
alias ca='cursor-agent'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Lazy-load NVM — only initializes when nvm/node/npm/npx is first called
_nvm_lazy_load() {
    unset -f nvm node npm npx
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
nvm() { _nvm_lazy_load; nvm "$@"; }
node() { _nvm_lazy_load; node "$@"; }
npm() { _nvm_lazy_load; npm "$@"; }
npx() { _nvm_lazy_load; npx "$@"; }

eval "$(direnv hook bash)"

# Dynamic zellij tab names: a tab is named "<command> ❯ <path>" for whatever
# command its pane starts, and drops back to the path once that command is done.
#
# `zellij action rename-tab` targets the *focused* tab - a pane cannot address
# the tab it lives in from the inside - so the reset is skipped for anything
# that ran longer than __ZELLIJ_TAB_IDLE_AFTER seconds: by then the pane may be
# in a tab that is no longer on screen, and renaming would hit the wrong tab.
# Such a tab keeps the command name until the next command runs in it.
#
# Keep this block last in ~/.bashrc: __zellij_tab_idle has to be the final
# PROMPT_COMMAND entry (direnv above appends one too), otherwise the DEBUG trap
# fires for the prompt hooks themselves instead of for real commands.
if [ -n "${ZELLIJ:-}" ] && command -v zellij >/dev/null 2>&1; then
    __ZELLIJ_TAB_IDLE_AFTER=10
    # Commands too generic or too short-lived to be worth a tab name.
    __ZELLIJ_TAB_SKIP=" cd ls ll la clear pwd echo export unset which type source . "

    __zellij_tab_path() {
        local path=${PWD/#$HOME/\~}
        printf '%s' "${path:-/}"
    }

    __zellij_tab_rename() {
        [ "$1" = "${__zellij_tab_name:-}" ] && return
        __zellij_tab_name=$1
        # Backgrounded so the IPC round-trip never stalls the prompt, inside a
        # subshell so the job lands in that subshell's job table instead of the
        # interactive shell's - otherwise bash prints "[1]+ Done ..." every time.
        ( zellij action rename-tab "$1" >/dev/null 2>&1 & )
    }

    # DEBUG trap, acts on the first command of each prompt line only.
    __zellij_tab_busy() {
        [ -n "${__zellij_tab_armed:-}" ] || return
        [ -n "${COMP_LINE:-}" ] && return
        __zellij_tab_armed=
        __zellij_tab_started=$SECONDS
        local word cmd=
        for word in $BASH_COMMAND; do
            case $word in
                *=*|sudo|doas|env|command|time|builtin|exec|nohup) continue ;;
            esac
            cmd=${word##*/}
            break
        done
        [ -n "$cmd" ] || return
        case $__ZELLIJ_TAB_SKIP in
            *" $cmd "*) return ;;
        esac
        __zellij_tab_rename "$cmd ❯ $(__zellij_tab_path)"
    }

    # Last PROMPT_COMMAND entry: the command is done, so go back to the cwd.
    __zellij_tab_idle() {
        local elapsed=0
        if [ -n "${__zellij_tab_started:-}" ]; then
            elapsed=$(( SECONDS - __zellij_tab_started ))
            __zellij_tab_started=
        fi
        __zellij_tab_armed=1
        [ "$elapsed" -gt "$__ZELLIJ_TAB_IDLE_AFTER" ] && return
        __zellij_tab_rename "$(__zellij_tab_path)"
    }

    trap '__zellij_tab_busy' DEBUG
    PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}__zellij_tab_idle"
fi
