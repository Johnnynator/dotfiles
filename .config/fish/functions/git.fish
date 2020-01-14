# Defined in - @ line 1
function git --wraps hub --description 'Alias for hub, which wraps git to provide extra functionality with GitHub.'
	hub  $argv;
end
