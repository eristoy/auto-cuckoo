#!/bin/bash
#Ver .01 Eric Stoycon eastoycon@novanthealh.org
####Var Section
CUDIR=$HOME/install/cuckoo


checkCUCKOO()
{
    if  ps ax | grep -v grep | grep cuckoo.py > /dev/null 
    then 
       echo "Cuckoo Running" 
    else
        echo "Starting Cuckoo"
        if ps ax | grep -v grep | grep Win7-64 > /dev/null
        then
            echo "vm found to be running. Starting Cuckoo"
            /usr/bin/python $CUDIR/cuckoo.py &>/dev/null &
        else
            echo "Starting VM for cuckoo"
            /usr/bin/vboxmanage startvm Win7-64 --type headless &
            sleep 10
            /usr/bin/python $CUDIR/cuckoo.py &>/dev/null &

    fi    
fi
}

checkCUCKOO
