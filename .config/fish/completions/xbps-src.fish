# Completions for 

function __fish_xbps_src_print_cross_archs -d 'Print all supported cross archs'
	set -l archs aarch64-musl aarch64 armv5te-musl armv5te armv5tel-musl armv5tel armv6hf-musl armv6hf armv6l-musl armv6l armv7hf-musl armv7hf armv7l-musl armv7l i686-musl i686 mips-musl mipsel-musl mipselhf-musl mipshf-musl ppc-musl ppc ppc64-musl ppc64 ppc64le-musl ppc64le x86_64-musl
	printf '%s\tArch\n' $archs
end

function __fish_xbps_src_print_bootstrap_archs -d 'Print all supported cross archs'
	set -l archs aarch64-musl aarch64 armv5te-musl armv5te armv5tel-musl armv5tel armv6hf-musl armv6hf armv6l-musl armv6l armv7hf-musl armv7hf armv7l-musl armv7l i686-musl i686 mips-musl mipsel-musl mipselhf-musl mipshf-musl ppc-musl ppc ppc64-musl ppc64 ppc64le-musl ppc64le x86_64-musl x86_64
	printf '%s\tArch\n' $archs
end



function __fish_xbps_src_no_subcommand -d 'Test if xbps-src has yet to be given the subcommand'
	for i in (commandline -opc)
		if contains  -- $i fetch extract patch build install pkg chroot binary-bootstrap bootstrap bootstrap-update clean-repocache check list remove remove-autodeps purge-distfiles show show-avail show-build-deps show-deps show-files show-hostmakedepends show-makedepends show-options show-shlib-provides show-shlib-requires show-var show-repo-updates show-sys-updates sort-dependencies update-bulk update-sys update-check update-hash-cache zap
			return 1
		end
	end
	return 0
end

function __fish_xbps_src_print_packages -d 'Find packages :)'
	set -l dirs (__fish_complete_suffix 'srcpkgs/(commandline -ct)' '/')
	set -l dirs srcpkgs/*
	string replace 'srcpkgs/' '' -- $dirs
	return
end

function __fish_xbps_src_use_package -d 'Test if xbps-src should have package as a potential completion'
	for i in (commandline -opc)
		if contains -- $i fetch extract patch configure build check install pkg remove show show-avail show-build-deps show-deps show-files show-hostmakedepends show-makedepends show-options show-shlib-provides show-shlib-requires update-check
			return 0
		end
	end
	return 1
end

function __fish_xbps_src_use_bootstrap_archs -d 'Test for bin bootstrap :)'
	for i in (commandline -opc)
		if contains -- $i binary-bootstrap
			return 0
		end
	end
	return 1
end

complete -f -c xbps-src -n '__fish_xbps_src_use_package' -a '(__fish_xbps_src_print_packages)' -d 'Package'
complete -f -c xbps-src -n '__fish_xbps_src_use_bootstrap_archs' -a '(__fish_xbps_src_print_bootstrap_archs)' -d 'Archs'

complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'fetch' -d 'Download package source distribution file(s)'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'extract' -d 'Extract package source distribution file(s)'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'patch' -d 'Patch the package sources'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'build' -d 'Build package source'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'install' -d 'Install target package'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'pkg' -d 'Build binary package'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'chroot' -d 'Enter to the chroot'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'binary-bootstrap' -d 'Install bootstrap packages from host repositories'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'bootstrap' -d 'Build and install from source the bootstrap packages'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'bootstrap-update' -d 'Updates bootstrap packages with latest versions available from registered repositories'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'clean-repocache' -d 'Removes obsolete packages from <hostdir>/repocache'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'check' -d 'Run the package check(s) after building'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'clean' -d 'Removes auto dependencies, cleans up <masterdir>/builddir and <masterdir>/destdir'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'list' -d 'Lists installed packages in <masterdir>'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'remove' -d 'Remove target package from <destdir>'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'remove-autodeps' -d ' Removes all package dependencies that were installed automatically'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'purge-distfiles' -d 'Removes all obsolete distfiles in <hostdir>/sources.'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'show' -d 'Show information for the specified package.'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'show-avail' -d 'Returns 0 if package can be built for the given architecture'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'show-build-deps' -d 'Show required build dependencies'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'show-deps' -d 'Show required run-time dependencies'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'show-files' -d 'Show files installed by <pkgname>'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'show-hostmakedepends' -d 'Show required host build dependencies for <pkgname>'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'show-makedepends' -d 'Show required target build dependencies for <pkgname>'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'show-options' -d 'Show available build options by <pkgname>.'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'show-shlib-provides' -d 'Show list of provided shlibs for <pkgname>'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'show-shlib-requires' -d 'Show list of required shlibs for <pkgname>'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'show-var' -d 'Prints the value of <var> if it\'s defined in xbps-src'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'show-repo-updates' -d 'Prints the list of outdated packages'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'show-sys-updates' -d 'Prints the list of outdated packages in your system'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'sort-dependencies' -d 'Given a list of packages specified as additional arguments, a sorted dependency list will be returned to stdout'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'update-bulk' -d 'Rebuilds all packages in the system repositories that are outdated'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'update-sys' -d 'Rebuilds all packages in your system that are outdated and updates them'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'update-check' -d 'Check upstream site of <pkgname> for new releases'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'update-hash-cache' -d 'Update the hash cache with existing source distfiles'
complete -f -n '__fish_xbps_src_no_subcommand' -c xbps-src -a 'zap' -d 'Removes a masterdir but preserving ccache, distcc and host directories'

complete -f -c xbps-src -s a -r -a '(__fish_xbps_src_print_cross_archs)' -d 'Cross compile packages for this target machine'
complete -f -c xbps-src -s m -r -a "(__fish_complete_directories '(commandline -ct)' 'masterdir')" -d 'Absolute path to a directory to be used as masterdir'
complete -f -c xbps-src -s H -r -a "(__fish_complete_directories '(commandline -ct)' 'hostdir')" -d 'Absolute path to a directory to be used as hostdir'
complete -f -c xbps-src -s C -d 'Do not remove build directory, automatic dependencies and package destdir after successful install'
complete -f -c xbps-src -s E -d 'If a binary package exists in a local repository for the target package, do not try to build it, exit immediately'
complete -f -c xbps-src -s f -d 'Force running the specified stage even if it ran successfully'
complete -f -c xbps-src -s G -d 'Enable XBPS_USE_GIT_REVS'
complete -f -c xbps-src -s Q -d 'Enable running the check stage'
complete -f -c xbps-src -s g -d 'Enable building -dbg packages with debugging symbols'
complete -f -c xbps-src -s h -d 'Usage output'
complete -f -c xbps-src -s I -d 'Ignore required dependencies'
complete -x -c xbps-src -s j -d 'Number of parallel build jobs to use when building packages' 
complete -f -c xbps-src -s L -d 'Disable ASCII colors'
complete -f -c xbps-src -s N -d 'Disable use of remote repositories to resolve dependencies'
complete -x -c xbps-src -s o -d 'Enable or disable (prefixed with ~) package build options'
complete -f -c xbps-src -s r -r -a "(__fish_complete_directories '(commandline -ct)' 'repodir')" -d 'Use an alternative local repository to store generated binary packages'
complete -f -c xbps-src -s t -d 'Create a temporary masterdir to not pollute the current one'


