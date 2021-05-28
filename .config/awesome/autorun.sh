#!/usr/bin/env bash

function run {
        if ! pgrep -f $1 ;
        then
                $@&
        fi
}

# setup touchpad
xinput set-prop 13 313 1     #tapping
xinput set-prop 13 326 0 1 0 #side scrolling
xinput set-prop 13 328 0.2   #acceleration
# start programs
run mullvad-vpn
run picom -b
run udiskie --tray
run discord --start-minimized
