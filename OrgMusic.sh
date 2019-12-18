#!/bin/bash

#Create some functions here to declutter code
# $1 will be file name
# $2 artist_name or album_name depending on particular function

artist_exists () {
	printf "$2 directory exists! Attempting to move $1 into $2\n"
	mv "$1" "$2/"
}

artist_album_exists () {
	printf "$1/$2 directory exists! Attempting to move $1 into $2\n"
	mv "$1" "$2/" 
}

artist_does_not_exist () {
	printf "$2 does not exist! Attempting to make directory...\n"
	mkdir "$2"
	printf "$2/ made! Moving $1 into $2\n"
	mv "$1" "$2/"
}

artist_album_does_not_exist () {
	printf "$1/$2 does not exist! Attempting to make directory...\n" 	
	mkdir "$2"
	printf "$2/ made! Moving $1 into $2/\n"
	mv "$1" "$2/"	
}

look_for_mp3_files_artist () {	

	for file in *.mp3 ; do	
		
		artist_name="$(ffprobe -loglevel error -show_entries format_tags=artist -of default=noprint_wrappers=1:nokey=1 "$file")"		
 
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
	
		album_name="$(ffprobe -loglevel error -show_entries format_tags=album -of default=noprint_wrappers=1:nokey=1 "$file")"
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
		
		printf "Looking for files in $ZIPFIDIREC ...\n"

		unzip "$file" -d $MUSICDIREC 

	done	
}

move_zip_files () {
	
	for file in *.zip ; do
		
		printf "Moving zip files...\n\n"
	done
}

move_cover_images () {
	printf "move cover images...\n\n"

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
	printf "Looking for zip files to extract mp3 files...\n\n"
	extract_zip_files	
fi

cd $MUSICDIREC

#echo $MUSICDIREC 

#look for mp3 files first
printf "Looking for stray mp3 files...\n\n"
look_for_mp3_files_artist

#move onto directory search
printf "\nNow looking through directories...\n\n"
look_for_directories

cd $CURREDIREC
