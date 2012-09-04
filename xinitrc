#!/bin/zsh

testtype () {
	type "$1" &> /dev/null
}

if testtype gnome-settings-daemon; then
	gnome-settings-daemon & # handles themes, starts gnome-screensaver. You may have to use gconf to disable it setting the background.
elif [ -x /usr/lib/gnome/gnome-settings-daemon ]; then
	/usr/lib/gnome/gnome-settings-daemon &
fi

sleep 1

# Helpers
testtype xcompmgr && xcompmgr -cCfF -D 2 &
testtype gnome-power-manager && gnome-power-manager &   # for laptops and stuff
testtype gnome-volume-manager && gnome-volume-manager &  # for mounting CDs, USB sticks, and such

# Init xinit programs
if [ -d /etc/X11/xinit/xinit.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Applets
if pgrep "NetworkManager" &> /dev/null && testtype nm-applet; then
	nm-applet &
fi
if testtype hcitool && testtype bluetooth-applet; then
	if [ -n "$(hcitool dev | grep -v Devices)" ]; then
		bluetooth-applet &
	fi
fi

[ -e "${HOME}/.background" ] && awsetbg -a "$HOME/.background" &
testtype empathy && empathy --start-hidden &

export DESKTOP_SESSION=gnome

COMMAND=awesome
if testtype dbus-launch; then
 COMMAND="dbus-launch --exit-with-session awesome"
fi

unset testtype

exec $COMMAND
