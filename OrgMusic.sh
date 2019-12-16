#!/bin/bash


MUSICDIREC="$1" 	#Save the first argument as "$musDirectory" 
CURREDIREC="$(pwd)" #Save the current working directory

cd $MUSICDIREC

for file in *.mp3 ; do
	#echo "$file"
	#testVar="$(mp3info -p "%a" "$file")"
	#echo $testVar

	
	# Subshell for scoping
	(
	
	artist_name="$(mp3info -p "%a" "$file")"
	album_name="$(mp3info -p "%l" "$file")"

	#echo $albumName	
	# Perform a check if the artist directory exists
	if [[ -d  "$artist_name/" ]] ; then
		echo "$artist_name" directory exists! Attempting to move "$file" into "$artist_name"/
		mv "$file" "$artist_name/"


	else 
		echo "$artist_name" does not exist! Attempting to make directory...
		mkdir "$artist_name"
		echo "$artist_name"/ made! Moving "$file" into "$artist_name"/
		mv "$file" "$artist_name/"
		
		
	fi
	)
		
done

cd $CURREDIREC


