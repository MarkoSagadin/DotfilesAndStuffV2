#!/bin/sh

case ${MONS_NUMBER} in
1)
	mons -o
	echo "one"
	# feh --no-fehbg --bg-fill "${HOME}/wallpapers/a.jpg"
	;;
2)
	mons -s
	echo "two"
	# feh --no-fehbg --bg-fill "${HOME}/wallpapers/a.jpg" \
	#                --bg-fill "${HOME}/wallpapers/b.jpg"
	;;
*)
	# Handle it manually
	;;
esac
