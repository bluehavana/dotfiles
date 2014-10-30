#!/bin/zsh
# vi:filetype=sh

testtype () {
    type "$1" &> /dev/null
}

testtype xcompmgr && xcompmgr -cCfF -D 2 &
testtype syndaemon && syndaemon -i 2 -k -t -d & # disable touchpad if necessary

[ -f "${HOME}/.Xmodmap" ] && xmodmap "${HOME}/.Xmodmap" &

# Needs to be loaded before xscreensaver
[ -f "${HOME}/.Xresources" ] && xrdb -merge "${HOME}/.Xresources" &

# Applets
testtype pasystray && pasystray &
if testtype xscreensaver
then
    xscreensaver -nosplash &
elif testtype gnome-screensaver
then
    gnome-screensaver &
fi

if pgrep "NetworkManager" &> /dev/null && testtype nm-applet
then
    nm-applet &
fi

if testtype hcitool
then
    if [ -n "$(hcitool dev | grep -v Devices)" ]
    then
        if testtype blueman-applet
        then
            blueman-applet &
        elif testtype bluetooth-applet
        then
            bluetooth-applet &
        fi
    fi
fi

testtype empathy && empathy --start-hidden &

unset testtype
