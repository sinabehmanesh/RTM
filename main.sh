#!/bin/bash
#RTM is a Royall Task Management system that helps you manage tasks in terminal quickley


#global variables
logfile_name=$(date +%Y%m%d%H)
logfile="./log/${logfile_name}"
datafile="./data"

#loggin function
logger () {
    echo $(date +%D" "%H:%M:%S) $1 >> ${logfile}
}

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
    column -t -s "|" --table-columns ID,TASK,STATUS data 

elif [ $# -gt 1 ]; then
    if [ $1 == "in" ]; then
        id=$(cat data | grep -v "^$" | wc -l )
        id=$(expr $id + 1)
        echo "${id} |${@: 2} |TODO " >> ${datafile}
        printf "Task added with id ${id}. \n"
    fi

    if [ $1 == "done" ]; then
        currentstate=$(cat ${datafile} | grep -i $2)
        echo ${currentstate}
        sed -i "s/^${2}.*/${currentstate} DONE/" ${datafile}
    fi

    if [ $1 == "del" ] || [ $1 == "delete" ]; then
        echo "RTM delete operation"
    fi
else
    printf "command not found"
fi
