#!/bin/bash
#Script to monitor drop folder for incoming malware analysis jobs. 
#Ver .01 Eric Stoycon eastoycon@novanthealh.org
####Var Section
CUDIR=$HOME/install/cuckoo
CULOG=$CUDIR/log/cuckoo.log
WORKING=$HOME/working
STORAGE=$CUDIR/storage/analyses
ARCH=$HOME/archive
RPT=$HOME/reports
OUT=$HOME/out
DONE=$HOME/submitted
DATE=`date +%Y-%m-%d`


autoCUCKOO()
{
    IFS=$(echo -en "\n\b")
    SAMPLES=$WORKING/*
    SUBMIT=$CUDIR/utils/submit.py
    for s in $SAMPLES
    do
        t=0
        FNAME=`basename $s`
        #echo "File name is $FNAME"
        if [ ${s: -4} == ".txt" ]
        then
            URL=$(head -n 1 $s)
            RET=`$SUBMIT --url $URL`
        else
            RET=`$SUBMIT "$s"`
            
        fi
        ID=$(echo $RET | awk '{print $9}')
        #echo "ID is $ID"
        RPTDIR=$STORAGE/$ID
        RPTFILE=$RPTDIR/reports/report.html
        while [ $t -eq  0 ]
        do
            if [ -e "$RPTFILE" ]
            then
                #echo  "$RPTFILE Found"
                cp $RPTFILE $RPT/$DATE.$FNAME.report.html
                t=1
            else
                t=0
                #echo "Sleeping"
                sleep 30
            fi
        done 
        mv $s $DONE 
    done
}


if [ "$(ls -A $WORKING)" ]; then
#    #cho "Submitting"
    autoCUCKOO
fi
if [ "$(ls -A $RPT)" ]; then
    $HOME/bin/sendEmail.py
fi
