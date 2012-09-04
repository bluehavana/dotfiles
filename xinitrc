gnome-settings-daemon & # handles themes, starts gnome-screensaver. You may have to use gconf to disable it setting the background.
nm-applet &             # assuming you're using Network Manager
empathy --start-hidden &                # if you're using pidgin. You can really put any programs here.
xcompmgr -c & # transparency
gnome-power-manager &   # for laptops and stuff
gnome-volume-manager &  # for mounting CDs, USB sticks, and such
bluetooth-applet &
while true;
do
  awsetbg -t -r $HOME/backgrounds
  sleep 15m
done &
exec awesome
