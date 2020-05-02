#!/bin/bash

#Script to run both CopyMusicOut.sh and OrgMusic.sh

CURREDIREC="$(pwd)"		#Save the current working directory
SOURCEDIREC="$1"
DESTINATIONDIREC="$2"
shopt -s nullglob

printf "Copying music files from ${SOURCEDIREC} to ${DESTINATIONDIREC}\n"
bash CopyMusicOut.sh "$SOURCEDIREC" "$DESTINATIONDIREC"

printf "Organizing music files in ${DESTINATIONDIREC}\n"
bash OrgMusic.sh "$DESTINATIONDIREC"
