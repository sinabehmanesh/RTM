#!/bin/bash
#RTM is a Royall Task Management system that helps you manage tasks in terminal quickley


#global variables
logfile_name=$(date +%Y%m%d)
logfile="./log/${logfile_name}"
datafile="./data"

#variables for printing and grids
bold_text=$(tput bold)
normal_text=$(tput sgr0)


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

#add tasks and insert them in data file
elif [ $# -gt 1 ]; then
    if [ $1 == "add" ]; then
        id=$(cat data | grep -v "^$" | wc -l )
        id=$(expr $id + 1)
        echo "${id} |${@: 2} | TODO " >> ${datafile}
        printf "Task added with id ${id}. \n"
    fi

#to change the task status into DONE create a desired state of task and currentstate(todo) and replace the with sed
    if [ $1 == "done" ]; then
        currentstate=$(cat ${datafile} | grep -i $2)
        taskname=$(cat ${datafile} | grep -i $2 | cut -d '|' -f 2)
        desiredstate=$(cat ${datafile} | grep -i $2 | cut -d '|' -f -2)

        sed -i "s/^${currentstate}.*/${desiredstate} | DONE/" ${datafile}

        printf "Task ${bold_text}${taskname}${normal_text} is now Done! good job lad! \n"
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
