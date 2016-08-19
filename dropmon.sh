#!/bin/bash
#Script to monitor drop folder for incoming malware analysis jobs.
#Ver .01 Eric Stoycon estoycon@gmail.com
####Var Section
INC=$HOME/samples
DROP=$INC/drop
WORKING=$INC/working

#Functions
checkforFiles()
{
#Check if there are any files awaiting to be processed
    if [ "$(ls -A $DROP)" ]; then
        OK=1
    else
        OK=0
    fi
}

moveFiles()
{
    IFS=$(echo -en "\n\b")
    FILES=$DROP/*
    for f in $FILES
    do
        mv $f $WORKING
    done
}

removeSpaces()
{
    IFS=$(echo -en "\n\b")
    LIST=$WORKING/*
    for z in $LIST
    do
        mv "${z}" "${z// /_}"
    done
}

checkforFiles()
if [ $OK -eq 1 ]; then
    moveFiles
    if [ $? -eq 0 ]; then
        removeSpaces
    else
        echo "removing spaces failed!"
    fi
else
    echo "No files to move"
fi
#Main
checkforFiles
