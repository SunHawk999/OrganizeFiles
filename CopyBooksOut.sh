#!/bin/bash

#Create some functions here to declutter code
# $1 will be source directory
# $2 will be destination directory, probably jumpdrives and such

#Pattern:
#   Look for epub files, then cp them to destination
#   Look for directories, if no directories found, stop 
#       Go into found directory, 
#           Look for epub files and cp them to destination
#           Look for directories, if no directories found, go back

copy_epub_file () {
    
    for file in *.epub ; do
        printf "Copying ${file} to ${DESTINATIONDIREC}\n"
        cp "$file" "$DESTINATIONDIREC"
    done
}

look_for_directories () {
    
    copy_epub_file
	for direc in */ ; do
		[ -d "${direc}" ] || continue		# if not a directory, skip
        cd "${direc}"
        #pwd
        look_for_directories
		cd ./..	
	done
}

CURREDIREC="$(pwd)"		#Save the current working directory
SOURCEDIREC="$1"
DESTINATIONDIREC="$2"

#When a pattern matches nothing "Disappears", rather than being treated 
#as a literal string
shopt -s nullglob
cd $SOURCEDIREC

look_for_directories

cd $CURREDIREC