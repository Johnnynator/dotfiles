#!/bin/bash
#          ██                  ██    
#         ░██                 ░██    
#  █████  ░██  ██████   █████ ░██  ██
# ██░░░██ ░██ ██░░░░██ ██░░░██░██ ██ 
#░██  ░░  ░██░██   ░██░██  ░░ ░████  
#░██   ██ ░██░██   ░██░██   ██░██░██ 
#░░█████  ███░░██████ ░░█████ ░██░░██
# ░░░░░  ░░░  ░░░░░░   ░░░░░  ░░  ░░ 
# Another panel used for information

# disable path name expansion or * will be expanded in the line
# cmd=( $line )
set -f

# Sourced files
source ~/.cache/wal/colors.sh # Color scheme using $COLOR0 - $COLOR7
source ~/.config/herbstluftwm/icons_panel.txt # Contains icons for panel

# Functions
# Only prints the date if it's different that the one saved
function uniq_linebuffered() {
    awk -W interactive '$0 != l { print ; l=$0 ; fflush(); }' "$@"
}

# Returns the battery level
function get_battery() {
    BATT_LEVEL=$(acpi -b | grep -o '[[:digit:]]\+%' | sed 's/%//' | tail -1)
    if [[ $(cat "$POWERSUPPLY/online") != 1 ]]; then
        if [[ $BATT_LEVEL -ge 80 ]]; then
            BATT_ICON=$ICON_BATTERY_FULL
        elif [[ $BATT_LEVEL -ge 60 && $BATT_LEVEL -lt 80 ]]; then
            BATT_ICON=$ICON_BATTERY_THREEQUARTERS
        elif [[ $BATT_LEVEL -ge 40 && $BATT_LEVEL -lt 60 ]]; then
            BATT_ICON=$ICON_BATTERY_HALF
        elif [[ $BATT_LEVEL -ge 20 && $BATT_LEVEL -lt 40 ]]; then
            BATT_ICON=$ICON_BATTERY_QUARTER
        elif [[ $BATT_LEVEL -lt 20 ]]; then
            BATT_ICON=$ICON_BATTERY_EMPTY
        fi
    else
        BATT_ICON=$ICON_BATTERY_FULL
    fi
    #echo -en "$BATT_LEVEL"
    echo -en "$BATT_ICON"
}

# Gets the current volume and an appropirate icon
function get_volume() {
    VOLUME=$(ponymix get-volume)
    ponymix is-muted
    if [[ $? -ne 0 ]]; then
        if [[ $VOLUME -ge 70 ]]; then
            VOLUME_ICON=$ICON_VOLUME_HIGH
        elif [[ $VOLUME -gt 0 && $VOLUME -lt 70 ]]; then
            VOLUME_ICON=$ICON_VOLUME_LOW
        else
            VOLUME_ICON=$ICON_VOLUME_MUTE
        fi
    else
        VOLUME_ICON=$ICON_VOLUME_MUTE
    fi
    echo -en "$VOLUME_ICON"
}

# Gets the wifi connection state and ssid
function get_wifi() {
    WIFI_INTERFACE="wlp3s0"
    #WIFI_SIGNAL=$(iw "$WIFI_INTERFACE" link | grep 'signal' | sed 's/signal: //' | sed 's/ dBm//' | sed 's/\t//')
    #WIFI_SSID=$(iw "$WIFI_INTERFACE" link | grep 'SSID' | sed 's/SSID: //')
    if [[ $(iw "$WIFI_INTERFACE" link) != "Not connected." ]]; then
        echo -en "$ICON_WIFI_CONNECTED"
        #echo -en "$WIFI_SSID"
    else
        echo -en "$ICON_WIFI_DISCONNECTED"
    fi
}

function get_wired() {
    WIRED_INTERFACE="enp0s25"
    WIRED_CONNECTION=$(cat "/sys/class/net/$WIRED_INTERFACE/carrier")
    if [[ $WIRED_CONNECTION -eq 1 ]]; then
        echo -en "$ICON_WIRED_CONNECTED"
    else
        echo -en "$ICON_WIFI_DISCONNECTED"
    fi
}

function get_mobile() {
    MOBILE_INTERFACE="wwp0s20u4"
    MOBILE_SIGNAL=$(iw "$MOBILE_INTERRFACE" link | grep 'signal' | sed 's/signal: //' | sed 's/ dBm//' | sed 's/\t//')
    if [[ $(iw "$MOBILE_INTERFACE" link) != "Not connected." ]]; then
        echo -en "$ICON_WIFI_CONNECTED"
    else
        echo -en "$ICON_WIFI_DISCONNECTED"
    fi
}
   
# Use the correct monitor
monitor=${1-0}
geometry=( $(herbstclient monitor_rect "$monitor") )
if [ -z "$geometry" ] ; then
    echo "Invalid monitor $monitor"
    exit 1
fi

# Initialize variables
battery=$(get_battery)
volume=$(get_volume)
wifi=$(get_wifi)
mobile=$(get_mobile)
wired=$(get_wired)

# Define the panel size
x=$((geometry[0] + 1150))
y=$((geometry[1] + 0))
panel_width=$((geometry[2] - 1150))
panel_height=20
pad_amount=$((y + panel_height))

# Set fonts to use
font1="boxxy:size=9"
font2="FontAwesome:size=9"

herbstclient pad $monitor 0 0 $pad_amount 0
{
    # Events to listen for
    # Date events
    while true ; do
        date +'date_day %a %e %b'
        date +'date_min %I:%M %p'
        sleep 1 || break
    done > >(uniq_linebuffered) &
    date_pid=$!

    # Herbstluftwm events
    herbstclient --idle

    # Upon finish, kill stray event-emitting processes
    kill $date_pid
} 2> /dev/null | {
    date_day=""
    date_min=""

    while true ; do
        # Centered text
        echo -en "%{c}%{U-}%{F$COLOR7}%{B-}"
        echo -en "$wired   "
	echo -en "$mobile   "
	echo -en "$wifi  "
        echo -en "%{A:urxvt -e "alsamixer":}$volume%{A}  "
        echo -en "$battery  "
        echo -en "$date_day $date_min"
        echo
        # wait for next event
        read line || break
        cmd=( $line )
        # find out event origin
        case "${cmd[0]}" in
            date_day) # The day changes
                date_day="${cmd[@]:1}"
                ;;
            date_min) # The minute changes
                date_min="${cmd[@]:1}"
                battery=$(get_battery)
                volume=$(get_volume)
                wifi=$(get_wifi)
		mobile=$(get_mobile)
		wired=$(get_wired)
                ;;
            quit_panel) # The panel is quit
                exit
                ;;
            reload) # Herbstluftwm is reloaded
                exit
                ;;
        esac
    done
# Now funnel the errors to nowhere and the good stuff to the panel
# lemonbar                                     # Panel program to use
# -b                                           # start panel at the bottom
# -u <number>                                  # Underline width
# -g <width>x<height>+<x offset>+<y offset>    # Panel geometry
# -B <color>                                   # Background color
# -F <color>                                   # Foreground color
# -f <font>                                    # Primary font
# -f <font>                                    # Secondary font (icons)
# sh               # Pipe to sh so clickable areas can execute commands
} 2> /dev/null | lemonbar -b -u 3 -g "$panel_width"x"$panel_height"+"$x"+"$y" -B $background -F $foreground -f $font1 -f $font2 | sh

