#!/bin/zsh
# ☺ ☹ ✗ ✓ ❤ ♥ ♦ ► ☣ ☠ « » ♪ ♫ ◆ ◇ ✣ ✧ ✦ ☾ ⚅ ⚑ ⚐ ◊ ⚒ ⚓ ⚔ ⚕ ⚛
# ⚚ ⚠ ⚡ ☢ ✝ ☭ ⌚ ⌛ ¬ × ÷ ∝ ∞ ∢ ∴ ∵ ♭ ♮ ♯ ♩ ❖ ⋆ ✯ ✩ ✪ ° ☐ ☑

# The following lines were added by compinstall
zstyle :compinstall filename '/home/jmccann/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob histignorespace histignoredups
bindkey -v
# End of lines configured by zsh-newuser-install

# Not interactive?
[ X"${-#*i}" != X"$-" ] || return

autoload -U colors
colors

alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias cd..='cd ..'
alias cd...='cd ../..'

alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

set_pretty_prompt() {
	PS1="%{$fg[cyan]%}%n%{$reset_color%}"
	PS1+=" ⚡ "
	case "$SSH_CLIENT$SSH_CONNECTION" in
	?*) PS1+="%{$fg[magenta]%}%m " ;;
	*)  PS1+="%{$fg[cyan]%}%m " ;;
	esac
	PS1+="%{$reset_color%}"
	PS1+="%(?.%{$fg[green]%}➤.%{$fg[red]%}➤)%{$reset_color%} "
	RPROMPT='%~'
}

man_color() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
			man "$@"
}

case $TERM in
xterm*|tmux*|screen*)
	set_pretty_prompt
	alias man="man_color"
	;;
*)
	PROMPT='%n @ %m:%~ $ '
	;;
esac


bindkey "^[[A" up-line-or-history
bindkey "^[[B" down-line-or-history
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward

alias allmanify='indent -bap -bli0 -i2 -l80 -ncs -npcs -npsl -fca -lc80 -fc1 -nut'
alias tm="tmux choose-session"
alias tmx="TERM=xterm-256color tmux"
alias vin='vim -c "NERDTree"'


if [ -x /usr/games/fortune ]; then
	/usr/games/fortune
elif [ -x /usr/bin/fortune ]; then
	/usr/bin/fortune
fi
echo
