# StarConflict

function get_files -d 'get packaged files' --argument filter
	tpak -l | grep $filter 2>/dev/null
end

complete -f -c StarConflict
complete -f -c StarConflict -o m -l model -r -a '(get_files '\\.mdf\\\$')' -d 'Load model'
complete -f -c StarConflict -o s -l scene -r -a '(get_files '\\.map\\\$')' -d 'Load scene'
# complete -f -c StarConflict -o p -l partcl -d '?'
# complete -f -c StarConflict -o rd -l ragdoll -d '?'
# complete -f -c StarConflict -opr -l prototype -d '?'
complete -f -c StarConflict -o nosteam -d 'Start without Steam integration'
complete -f -c StarConflict -l lang -d 'Choose language' \
	-r -a 'chinese czech english french german hungarian polish portuguese russian spanish turkish ukrainian vietnamese'
complete -f -c StarConflict -l daemonize -d 'Daemonize after startup'
complete -c StarConflict -l pidfile -d 'Pidfile' -r
complete -c StarConflict -o xterm -d 'Start seperate xterm to show stdout'
# complete -c StarConflict -o from_xterm -d '?'
complete -f -c StarConflict -o test -d 'Show server browser'
complete -f -c StarConflict -o pubtest -d 'Set default server to pubtest'
complete -f -c StarConflict -o dontSaveConfig -d 'Don\'t save config after closing'
complete -f -c StarConflict -o skiplogos -d 'Skip over startup logos'
complete -f -c StarConflict -o safe -d 'Start SC with default config'
# complete -f -c StarConflict -o noMenu -d ''
# complete -f -c StarConflict -o nompcheck -d ''
# complete -f -c StarConflict -o autoLogin -d ''
# complete -f -c StarConflict -o anim -d ''
# complete -f -c StarConflict -o logFileName -d ''
# complete -f -c StarConflict -o logFull -d ''
# complete -f -c StarConflict -l ignoreErrorMsg -d ''
# complete -f -c StarConflict -o filesLog -d ''
# complete -f -c StarConflict -o filesOneBigLog -d ''
