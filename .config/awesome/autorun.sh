#!/usr/bin/env bash

function run {
        if ! pgrep -f $1 ;
        then
                $@&
        fi
}

# setup touchpad
# xinput list-props 13
xinput set-prop 13 307 1     # Tapping Enabled
xinput set-prop 13 320 0 1 0 # Scroll Method Enabled
xinput set-prop 13 322 0.2   # Accel Speed
# start programs
run mullvad-vpn
run picom -b
run udiskie --tray
run discord --start-minimized
