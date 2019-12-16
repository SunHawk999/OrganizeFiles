#!/bin/bash


musDirectory="$1" 	#Save the first argument as "$musDirectory"
curDirectory="$(pwd)" #Save the current working directory

cd $musDirectory

for file in *.mp3 ; do
	#echo "$file"
	#testVar="$(mp3info -p "%a" "$file")"
	#echo $testVar

	
	# Subshell for scoping
	(
	
	artistName="$(mp3info -p "%a" "$file")"
	albumName="$(mp3info -p "%l" "$file")"

	#echo $albumName	
	# Perform a check if the artist directory exists
	if [[ -d  "$artistName/" ]] ; then
		echo "$artistName" directory exists! Attempting to move "$file" into "$artistName"/
		mv "$file" "$artistName/"


	else 
		echo "$artistName" does not exist! Attempting to make directory...
		mkdir "$artistName"
		echo "$artistName"/ made! Moving "$file" into "$artistName"/
		mv "$file" "$artistName/"
		
		
	fi
	)
		
done

cd $curDirectory


