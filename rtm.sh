#!/bin/bash
#RTM is a Royall Task Management system that helps you manage tasks in terminal quickley
#author sina behmanesh 2022

#global variables
logfile_name=$(date +%Y%m%d)
logfile="./log/${logfile_name}"
logdir="./log"
datafile="./data"

#variables for printing and grids
bold_text=$(tput bold)
normal_text=$(tput sgr0)
green_text='\033[0;32m'
blue_text='\033[0;34m'
yellow_text='\033[0;33m'
NC_text='\033[0m'

#loggin function
logger () {
    echo $(date +%D" "%H:%M:%S) $1 >> ${logfile}
}

#check if log directory exists and if not create one
if [ -d ${logdir} ]; then
    logger "Log directory exists, logs input to ${logfile} "
else
    mkdir ./log
    logger "Log directory created"
fi


#check if database file exists if not create it
if [ -f ${datafile} ]; then
    logger "database file exists"
else
    # printf "database file not found, do you want to create one?[y/n] \n"
    # read $database_create
    # if [[ $database_create == "yes" ]]; then
    #     touch ${datafile}
    # fi
    touch ${datafile}
fi


if [ $# -eq 1 ] && [ $1 == "status" ]; then
    # while read line; do
    #     echo $line | grep -v "^$"
    # done < $datafile
    #column -t -s "|" --table-columns ID,TASK,STATUS data

    printf  "%s \t\t" "ID"  "NAME" "STATUS"
    printf "\n\n"
    while read -r line ; do
        #printf "${id}\t\t\t${name}\t\t\t${status}\n"  | grep -v "^$"
        id=$(echo ${line} | cut -d '|' -f 1)
        name=$(echo ${line} | cut -d '|' -f 2)
        status=$(echo ${line} | cut -d '|' -f 3)
        if [ ${status} == "TODO" ]; then
            printf  "${id}\t\t${name}\t${yellow_text}${status}${NC_text} \n \n"  | grep -v "^$" 
        elif [ ${status} == "DONE" ]; then
            printf  "${id}\t\t${name}\t${green_text}${status}${NC_text} \n \n"  | grep -v "^$"
        else
            printf "No Tasks Found"
        fi
    done < $datafile

#add tasks and insert them in data file
elif [ $# -gt 1 ]; then
    if [ $1 == "add" ]; then
        id=$(cat data | grep -v "^$" | wc -l )
        id=$(expr $id + 1)
        echo "${id} |${@: 2} | TODO " >> ${datafile}
        printf "Task added with id ${blue_text}${id}${NC_text}. \n"
    fi

#to change the task status into DONE create a desired state of task and currentstate(todo) and replace the with sed
    if [ $1 == "done" ]; then
        currentstate=$(cat ${datafile} | grep -i $2)
        taskname=$(cat ${datafile} | grep -i $2 | cut -d '|' -f 2)
        desiredstate=$(cat ${datafile} | grep -i $2 | cut -d '|' -f -2)

        sed -i "s/^${currentstate}.*/${desiredstate} | DONE/" ${datafile}

        printf "Task ${blue_text}${bold_text}${taskname}${normal_text}${NC_text} is now ${green_text}Done!${NC_text} good job lad! \n"
        logger "${currentstate} changed to ${desiredstate} \n"
    fi

#delete a task with the 
    if [ $1 == "del" ] || [ $1 == "delete" ]; then
        currentstate=$(cat ${datafile} | grep -i $2)
        desiredstate=$(awk "/^${currentstate}.*/{ print NR; exit }" ${datafile})
        sed -i "${desiredstate}d" ${datafile}

        printf "Task ${bold_text}${taskname}${normal_text} Deleted! \n"
        logger "${currentstate} Deleted \n"

    fi
else
    printf "command not found"
fi
