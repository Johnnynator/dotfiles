while read pid; do
	kill -s HUP $pid
done < $HOME/.sv/runsvdir.pid
