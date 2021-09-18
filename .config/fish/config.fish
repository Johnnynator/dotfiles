set fish_greeting
set -x PATH $HOME/.bin $PATH
set -x VAGRANT_DEFAULT_PROVIDER libvirt
set -x CMAKE_EXPORT_COMPILE_COMMANDS 1
set -x CMAKE_GENERATOR Ninja
if status is-interactive
    # Commands to run in interactive sessions can go here
end
