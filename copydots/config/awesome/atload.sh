#!/bin/zsh
# vi:filetype=sh

testtype () {
    type "$1" &> /dev/null
}

if testtype xcompmgr
then
    xcompmgr -cCfF -D 2 &
elif testtype compton
then
    compton -cCf -D 2 &
fi
testtype syndaemon && syndaemon -i 2 -k -t -d & # disable touchpad if necessary

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
# needs to be loaded before xscreensaver
# also can't be backgrounded since it takes a while
[ -f "${HOME}/.Xresources" ] && xrdb -merge "${HOME}/.Xresources"

# Applets
testtype pasystray && pasystray &

if testtype xscreensaver
then
    xscreensaver -nosplash &
elif testtype gnome-screensaver
then
    gnome-screensaver &
fi

testtype empathy && empathy --start-hidden &

unset -f testtype
