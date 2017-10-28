#!/bin/bash
#                                     ██
# ██████                             ░██
#░██░░░██  ██████   ███████   █████  ░██
#░██  ░██ ░░░░░░██ ░░██░░░██ ██░░░██ ░██
#░██████   ███████  ░██  ░██░███████ ░██
#░██░░░   ██░░░░██  ░██  ░██░██░░░░  ░██
#░██     ░░████████ ███  ░██░░██████ ███
#░░       ░░░░░░░░ ░░░   ░░  ░░░░░░ ░░░ 
# Panel for herbstluftwm using lemonbar configuration

# Disable path name expansion or * will be expanded in the line
# cmd=( $line )
set -f

# Sourced files
source ~/.cache/wal/colors.sh # Color scheme using  $COLOR0 - $COLOR7
source ~/.config/herbstluftwm/icons_panel.txt # contains icons for panel

# Use the current monitor
monitor=${1-0}
geometry=( $(herbstclient monitor_rect "$monitor") )
if [ -z "$geometry" ]; then
    echo "Invalid monitor $monitor"
    exit 1
fi

# Define the panel size
x=$((geometry[0] + 520))
y=$((geometry[1] + 0))
panel_width=$((geometry[2] - 1040)) # Minus 2x makes it center
panel_height=20
pad_amount=$((y + panel_height))

# Set fonts to use
font1="DejaVuSansMono:size=9" # Main font for text
font2="FontAwesome:size=9" # Icon font for icons

herbstclient pad $monitor 0 0 $pad_amount 0
{
    # Events to be monitored
    # Herbstluftwm Events:
    herbstclient --idle
# Pipe output to next section and errors to nowhere
} 2> /dev/null | {
    # Get status of tags in respect to the current monitor
    TAGS=( $(herbstclient tag_status $monitor) )
    unset TAGS[${#TAGS[@]}]
	echo $monitor >&2
	echo ${TAGS[19]} >&2
    while true; do
        # Center and add underline for current tags
        echo -en "%{c}%{+u}"
        for i in "${TAGS[@]}"; do
            case ${i:0:1} in
                '#') # Active tag on current monitor
                    echo -en "%{+u}%{F$COLOR7}%{U$COLOR7}"
                    ;;
                '+') # Active on other monitor
                    echo -en "%{+u}%{F"#aaaaaa"}%{U$COLOR7}"
                    ;;
                ':') # Items are open but tag is not visible
                    echo -en "%{-u}%{F$COLOR7}%{U-}"
                    ;;
                '!') # Urgent tag, you never know
                    echo -en "%{+u}%{F$COLOR3}%{U$COLOR3}"
                    ;;
                *)
                    echo -en "%{-u}%{F"#404040"}%{U-}"
                    ;;
            esac
            # Now that it's formatted add the tag title
            # Open a clickable area for tag switching
            echo -n "%{A:herbstclient use \\${i:1}:}"
            echo -en "   ${i:1}   " # Tag title
            echo -n "%{A}" # Close the click area
        done
        echo
        # Wait for next event
        read line || break
        cmd=( $line )
        # Then figure out where it came from
        case "${cmd[0]}" in
            tag*) # Herbstclient tag event (Window open, close etc)
                TAGS=( $(herbstclient tag_status $monitor) )
                unset TAGS[${TAGS[@]}]
                ;;
            quit_panel) # Quit the panel
                exit
                ;;
            reload) # Panel is reloaded
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
} 2> /dev/null | lemonbar -b -u 2 -g "$panel_width"x"$panel_height"+"$x"+"$y" -B $background -F $foreground -f $font1 -f $font2 | sh
