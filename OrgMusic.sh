#!/bin/bash

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

artist_album_does_not_exist () {
	echo "$1"/"$2" does not exist! Attempting to make directory...
	cd "$MUSICDIREC"/"$1" 	
	mkdir "$2"
	echo "$2"/ made! Moving "$1" into "$2"/
	mv "$1" "$2/"	
}

look_for_mp3_files_artist () {	

	for file in *.mp3 ; do	
	
		artist_name="$(mp3info -p "%a" "$file")"
		 
		if [[ -d  "$artist_name/" ]] ; then
			artist_exists "$file" "$artist_name"
		
			#change directory to artist
		
		elif [[ ! -d "$artist_name/" ]] ; then 
			artist_does_not_exist "$file" "$artist_name"
		
		fi
			
	done
}

look_for_mp3_files_album () {
	
	for file in *.mp3 ; do

		album_name="$(mp3info -p "%l" "$file")"
			
		if [[ -d "$album_name/" ]] ; then
			artist_album_exists "$file" "$album_name"
	
		elif [[ ! -d "$album_name/" ]] ; then
			artist_album_does_not_exist "$file" "$album_name"
		
		fi	

	done
} 

look_for_directories () {
	
	for direc in */ ; do
		[ -d "${direc}" ] || continue		# if not a directory, skip
		cd "${direc}"
		look_for_mp3_files_album 
		cd ./..
		
	done
}

extract_zip_files () {

	for file in *.zip ; do
		
		echo Looking for files in $ZIPFIDIREC ...

		unzip "$file" -d $MUSICDIREC 

	done	
}

MUSICDIREC="$1"				#Save the first argument as "$MUSICDIREC" 
ZIPFIDIREC="$2"				#Arg for zip file directory
CURREDIREC="$(pwd)"		#Save the current working directory

#When a pattern matches nothing "Disappears", rather than being treated 
#as a literal string
shopt -s nullglob

#Have the functions to unpack and move files from another directory in a zip file here
if [ -d $ZIPFIDIREC ]; then
	cd $ZIPFIDIREC 
	extract_zip_files
	cd $MUSICDIREC
fi

cd $MUSICDIREC

echo $MUSICDIREC 

#look for mp3 files first
echo Looking for stray mp3 files...
look_for_mp3_files_artist

#move onto directory search
echo Now looking through directories...
look_for_directories

cd $CURREDIREC
