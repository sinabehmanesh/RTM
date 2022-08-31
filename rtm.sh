#!/bin/bash
#RTM is a Royall Task Management system that helps you manage tasks in terminal quickley
#author sina behmanesh 2022

#global variables
logfile_name=$(date +%Y%m%d)
logfile=~/.rtm/log/$logfile_name
logdir=~/.rtm/log
datafile=~/.rtm/data

#variables for printing and grids
bold_text=$(tput bold)
normal_text=$(tput sgr0)

#loggin function
logger () {
    echo "$(date +%D" "%H:%M:%S) $1 >> $logfile"
}

#check if log directory exists and if not create one
if [[ ! -d "$logdir" ]]; then
    mkdir -p ~/.rtm/log
fi


#check if database file exists if not create it
if [ ! -f $datafile ]; then
    touch $datafile
fi

if [ $# -eq 1 ] && [ $1 == "status" ]; then
    # while read line; do
    #     echo $line | grep -v "^$"
    # done < $datafile
	if [[ -s $datafile ]]; then
    	column -t -s "|" -c ID,TASK,STATUS $datafile
	else
		echo -e "You don't have any existing tasks!\nTry: \"rtm --help\" to see how to add a new task"
fi

#add tasks and insert them in data file
elif [ $# -gt 1 ]; then
    if [ $1 == "add" ]; then
        id=$(cat $datafile | tail -n 1 | gawk -F' ' '{print $1}' )
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
        task=$(cat ${datafile} | egrep "^$2")
		echo $task
        sed -i "$2 d" $datafile

        printf "Task ${bold_text}${taskname}${normal_text} Deleted! \n"
        logger "${currentstate} Deleted \n"

    fi
elif [[ $1 = '-h' ]] || [[ $1 = '--help' ]]; then
	echo -e "Usage: $0 COMMAND [STRING]
	Example usage:
	\tShow list of tasks:
	\t\trtm status
	\tAdd a task.
	\t\trtm add Deploy Kubernetes Cluster for John
	\tDelete a task:
	\t\trtm del"
else
	echo "rtm: missing operand
Try 'rtm --help' for more information."
fi
