#!/bin/bash

#Create some functions here to declutter code
# $1 will be file name
# $2 artist_name
# $3 album_name

artist_exists () {
	echo "$2" directory exists! Attempting to move "$1" into "$2"/
	mv "$1" "$2/"
}

artist_does_not_exist () {
	echo "$2" does not exist! Attempting to make directory...
	mkdir "$2"
	echo "$2"/ made! Moving "$1" into "$2"/
	mv "$1" "$2/"
}

look_for_mp3_files () {

for file in *.mp3 ; do
	
	# Subshell for scoping
	(
	artist_name="$(mp3info -p "%a" "$file")"
	album_name="$(mp3info -p "%l" "$file")"

	# Perform a check if the artist directory exists
	if [[ -d  "$artist_name/" ]] ; then
		artist_exists "$file" "$artist_name"
		
		#change directory to artist
		
	elif [[ ! -d "$artist_name/" ]] ; then 
		artist_does_not_exist "$file" "$artist_name"
		
	fi
	)
		
done
} 

MUSICDIREC="$1"				#Save the first argument as "$MUSICDIREC" 
CURREDIREC="$(pwd)"		#Save the current working directory

cd $MUSICDIREC

echo $MUSICDIREC 

#look for mp3 files first
look_for_mp3_files

#move onto directory search
for direc in */ ; do
	echo "$direc"
done

cd $CURREDIREC


