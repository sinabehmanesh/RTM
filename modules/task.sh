#!/bin/bash
#This file is the core functions for RTM.

function check_status {
    grid_header
    while read -r line ; do
        #printf "${id}\t\t\t${name}\t\t\t${status}\n"  | grep -v "^$"
        id=$(echo ${line} | cut -d '|' -f 1)
        name=$(echo ${line} | cut -d '|' -f 2)
        status=$(echo ${line} | cut -d '|' -f 3)
        if [ ${status} == "TODO" ]; then
            printf  "${id}\t${YELLOW}${status}${NC}\t\t${name}\t\n \n"  | grep -v "^$" 
        elif [ ${status} == "DONE" ]; then
            printf  "${id}\t${GREEN}${status}${NC}\t\t${name}\t\n\n"  | grep -v "^$"
        else
            printf "No Tasks Found"
        fi
    done < $datafile
}

function add_task {
    id=$(cat data | grep -v "^$" | wc -l )
    id=$(expr $id + 1)
    echo "${id} |${@} | TODO " >> ${datafile}
    printf "Task added with id ${BLUE}${id}${NC}. \n"
}

function finish_task {
    currentstate=$(cat ${datafile} | grep -i $2)
    taskname=$(cat ${datafile} | grep -i $2 | cut -d '|' -f 2)
    desiredstate=$(cat ${datafile} | grep -i $2 | cut -d '|' -f -2)

    sed -i "s/^${currentstate}.*/${desiredstate} | DONE/" ${datafile}

    printf "Task ${BLUE}${BOLD_TEXT}${taskname}${NORMAL}${NC} is now ${GREEN}Done!${NC} good job lad! \n"
    logger "${currentstate} changed to ${desiredstate} \n" 
}

function remove_task {
    currentstate=$(cat ${datafile} | grep -i $2)
    desiredstate=$(awk "/^${currentstate}.*/{ print NR; exit }" ${datafile})
    sed -i "${desiredstate}d" ${datafile}

    printf "Task ${BOLD_TEXT}${taskname}${NORMAL} Deleted! \n"
    logger "${currentstate} Deleted \n"
}