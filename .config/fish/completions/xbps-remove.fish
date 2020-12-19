# xbps-remove
complete -f -c xbps-remove -a "(__fish_print_packages --installed)" -d "Installed Package"
complete -c xbps-remove -s C -l config --description 'Specifies a path to the XBPS configuration directory.' -r -a '(__fish_complete_directories (commandline -ct))'
complete -c xbps-remove -s c -l cachedir --description 'Specifies a path to the cache directory, where binary packages are stored.' -r -a '(__fish_complete_directories (commandline -ct))'
complete -c xbps-remove -s d -l debug --description 'Enables extra debugging shown to stderr.'
complete -c xbps-remove -s F -l force-revdeps --description 'Forcefully remove package even if there are reverse dependencies and/or broke…'
complete -c xbps-remove -s f -l force --description 'Forcefully remove package files even if they have been modified.'
complete -c xbps-remove -s h -l help --description 'Show the help message.'
complete -c xbps-remove -s n -l dry-run  --description 'Dry-run mode.  Show what actions would be done but don\'t do anything.'
complete -c xbps-remove -s O -l clean-cache --description 'Cleans cache directory removing obsolete binary packages.'
complete -c xbps-remove -s o -l remove-orphans --description 'Removes installed package orphans that were installed automatically (as depen…'
complete -c xbps-remove -s R -l recursive --description 'Recursively remove packages that were installed by PKGNAME and aren\'t require…'
complete -c xbps-remove -s r -l rootdir  --description 'Specifies a full path for the target root directory.' -r -a '(__fish_complete_directories (commandline -ct) "Rootdir")'
complete -c xbps-remove -s v -l verbose --description 'Enables verbose messages.'
complete -c xbps-remove -s y -l yes --description 'Assume yes to all questions and avoid interactive questions.'
complete -c xbps-remove -s V -l version --description 'Show the version information.'

