#!/bin/bash

#TODO: Need to rethink how files and directories are going to be organized...

#Create some functions here to declutter code
# $1 will be file name
# $2 artist_name or album_name depending on particular function

artist_exists () {
	echo "$2" directory exists! Attempting to move "$1" into "$2"/
	mv "$1" "$2/"
}

artist_album_exists () {
	echo "$1"/"$2" directory exists! Attempting to move "$1"/ into "$2"/
	mv "$1" "$2" 
}

artist_does_not_exist () {
	echo "$2" does not exist! Attempting to make directory...
	mkdir "$2"
	echo "$2"/ made! Moving "$1" into "$2"/
	mv "$1" "$2/"
}

#This might not work, hasn't been tested yet...
artist_album_does_not_exist () {
	echo "$1"/"$2" does not exist! Attempting to make directory...
	cd "$MUSICDIREC"/"$1" 	
	mkdir "$2"
	cd "$MUSICDIREC" 
}

look_for_mp3_files_artist () {

	for file in *.mp3 ; do	
		# Subshell for scoping
		(
		artist_name="$(mp3info -p "%a" "$file")"
		
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

look_for_mp3_files_album () {
	
	for file in *.mp3 ; do
		#Subshell for scoping
		(
		album_name="$(mp3info -p "%l" "$file")"
			
		if [[ -d "$album_name/" ]] ; then
			artist_album_exists "$file" "$album_name"
	
		elif [[ ! -d "$album_name/" ]] ; then
			artist_album_does_not_exist "$file" "$album_name"

		fi 
		)

	done
} 

look_for_directories () {
	
	for direc in */ ; do
		[ -d "${direc}" ] || continue		# if not a directory, skip
		#echo "${direc}"
		cd "${direc}"
		#echo $pwd
		look_for_mp3_files_album 
		cd ./..
		
	done
}

MUSICDIREC="$1"				#Save the first argument as "$MUSICDIREC" 
CURREDIREC="$(pwd)"		#Save the current working directory

cd $MUSICDIREC

echo $MUSICDIREC 

#look for mp3 files first
echo Looking for stray mp3 files...
look_for_mp3_files_artist

#move onto directory search
echo Now looking through directories...
look_for_directories

cd $CURREDIREC
