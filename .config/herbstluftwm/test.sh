#!/bin/bash
set -f
source ~/.cache/wal/colors.sh

monitor=0
    # Get status of tags in respect to the current monitor
    TAGS=( $(herbstclient tag_status $monitor) )
    unset TAGS[${#TAGS[@]}]

        # Center and add underline for current tags
        echo -en "%{c}%{+u}"
        for i in "${TAGS[@]}"; do
	    echo -en "${i:0}"
            # Now that it's formatted add the tag title
            # Open a clickable area for tag switching
            echo -e "   ${i:1}   " # Tag title
        done

