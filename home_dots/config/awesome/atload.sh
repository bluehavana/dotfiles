#!/bin/zsh
# vi:filetype=sh

testtype () {
    type "$1" &> /dev/null
}

testtype xcompmgr && xcompmgr -cCfF -D 2 &
testtype syndaemon && syndaemon -i 2 -k -t -d & # disable touchpad if necessary

# Applets
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

[ -f "${HOME}/.Xmodmap" ] && xmodmap "${HOME}/.Xmodmap" &
[ -f "${HOME}/.Xresources" ] && xrdb -merge "${HOME}/.Xresources" &

testtype empathy && empathy --start-hidden &

unset testtype
