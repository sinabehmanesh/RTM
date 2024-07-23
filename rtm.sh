#!/bin/bash
#RTM is a Royall Task Management system that helps you manage tasks in terminal quickley
#author sina behmanesh 2024

#Import all modules from dir modules
source ./modules/*.sh

#global variables
datafile="./data"


#CLI Help output
function printHelp {
    echo " "
    echo "RTM COMMAND [task number]"
    echo " "
    echo "possible commands:"
    echo -e "\t\tstatus\t\t Check current tasks with their ID and description"
    echo -e "\t\tadd\t\t use add with the task description, id will assign automatically"
    echo -e "\t\tdone\t\t put task id after done to put the task into done section"
    echo -e "\t\tdel,rm\t\t try to delete by its ID"
    echo " "
}

#check if database file exists if not create it
if [ -f ${datafile} ]; then
    logger "database file exists"
else
    info "database file not found, Createing local database."
    sleep 1
    # read $database_create
    # if [[ $database_create == "yes" ]]; then
    #     touch ${datafile}
    # fi
    touch ${datafile}
fi

while (($#))
do
case $1 in 
    --help | -h)
        printHelp
        exit 0;
        ;;
    status)
        check_status
        exit 0;
        ;;
    add)
        add_task ${@: 2}
        exit 0;
        ;;
    done)
        finish_task ${@}
        exit 0;
        ;;
    del | rm)
        remove_task ${@}
        exit 0;
        ;;
    *)
        error "Unkown parameters $1"
        info "\trun rtm --help for help"
        exit 1
esac
shift
done