#!/bin/zsh

testtype () {
	type "$1" &> /dev/null
}

if testtype gnome-settings-daemon
then
				# handles themes, starts gnome-screensaver.
	gnome-settings-daemon & # You may have to use gconf to disable it
				# setting the background.
elif [ -x /usr/lib/gnome/gnome-settings-daemon ]
then
	/usr/lib/gnome/gnome-settings-daemon &
fi

sleep 1

# Helpers
testtype xcompmgr && xcompmgr -cCfF -D 2 &
testtype gnome-power-manager && gnome-power-manager &   # for laptops and stuff
testtype gnome-volume-manager && gnome-volume-manager &  # for mounting CDs, USB sticks, and such
testtype syndaemon && syndaemon -i 2 -k -t -d &

# Init xinit programs
if [ -d /etc/X11/xinit/xinit.d ]
then
  for f in /etc/X11/xinit/xinitrc.d/*
  do
    [ -x "$f" ] && . "$f"
  done

  unset f
fi

# Applets
if pgrep "NetworkManager" &> /dev/null && testtype nm-applet
then
	nm-applet &
fi

if testtype hcitool && testtype bluetooth-applet
then
	if [ -n "$(hcitool dev | grep -v Devices)" ]
	then
		bluetooth-applet &
	fi
fi

[ -f "${HOME}/.Xmodmap" ] && xmodmap "${HOME}/.Xmodmap"
[ -f "${HOME}/.Xresources" ] && xrdb -merge "${HOME}/.Xresources"
[ -f "${HOME}/.background" ] && awsetbg -a "$HOME/.background" &
testtype empathy && empathy --start-hidden &

export DESKTOP_SESSION=gnome

unset testtype

exec awesome
