#!/bin/bash
#this file contains configuration and logic for logging.

#Global Vars
logfile_name=$(date +%Y%m%d)
logfile="./log/${logfile_name}"
logdir="./log"

#check if log directory exists and if not create one
if [ -d ${logdir} ]; then
    logger "Log directory exists, logs input to ${logfile} "
else
    mkdir ./log
    logger "Log directory created"
fi

#loggin function
logger () {
    echo $(date +%D" "%H:%M:%S) $1 >> ${logfile}
}