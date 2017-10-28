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

# MPD
function mpd() {
   nowplaying=`mpc | head -n 1`
    if [[ "$nowplaying" != volume* ]]
      then
        echo "%{A1:"mpc toggle":}%{A2:"mpc stop":}%{A3:"mpc random":}%{A4:"mpc next":}%{A5:"mpc prev":}%{T2} %{T1}$nowplaying%{A}%{A}%{A}%{A}%{A}  "
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
mpd=$(mpd)

# Define the panel size
x=$((geometry[0] + 0))
y=$((geometry[1] + 0))
panel_width=$((geometry[2] - 1280))
panel_height=20
pad_amount=$((y + panel_height))

# Set fonts to use
font1="boxxy:size=9"
font2="FontAwesome:size=9"

herbstclient pad $monitor 0 0 $pad_amount 0
{
    while true; do
        mpc idle
    done &

    # Herbstluftwm events
    herbstclient --idle

    # Upon finish, kill stray event-emitting processes
} 2> /dev/null | {
    while true ; do
        # Centered text
        echo -en "%{c}%{U-}%{F$COLOR7}%{B-}"
        echo -en "$mpd"
	echo
        # wait for next event
        read line || break
        cmd=( $line )
        # find out event origin
        case "${cmd[0]}" in
            player) # The minute changes
		mpd=$(mpd)
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

