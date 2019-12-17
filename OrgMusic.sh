#!/bin/bash


#TODO: Need to rething how files and directories are going to be organized...

#Create some functions here to declutter code
# $1 will be file name
# $2 artist_name
# $3 album_name

artist_exists () {
	echo "$2" directory exists! Attempting to move "$1" into "$2"/
	mv "$1" "$2/"
}

artist_album_exists () {
	echo "$2"/"$3" directory exists! Attempting to move "$3"/ into "$2"/
	mv "$2" "$3" 
}

artist_does_not_exist () {
	echo "$2" does not exist! Attempting to make directory...
	mkdir "$2"
	echo "$2"/ made! Moving "$1" into "$2"/
	mv "$1" "$2/"
}

#This might not work, hasn't been tested yet...
artist_album_does_not_exists () {
	echo "$2"/"$3" does not exist! Attempting to make directory...
	cd "$MUSICDIREC"/"$2" 	
	mkdir "$3"
	cd "$MUSICDIREC" 
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

#look_for_directories () {}

MUSICDIREC="$1"				#Save the first argument as "$MUSICDIREC" 
CURREDIREC="$(pwd)"		#Save the current working directory

cd $MUSICDIREC

echo $MUSICDIREC 

#look for mp3 files first
echo Looking for stray mp3 files...
look_for_mp3_files

#move onto directory search
echo Now looking through directories...
for direc in */ ; do
	echo "$direc"
	cd "$direc"

	#(
	
	#)	
	cd ./..

done

cd $CURREDIREC
