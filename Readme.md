# RTM
![alt text](https://cdn.dribbble.com/users/32384/screenshots/3225544/media/3492fc2c4ca08e9cfcbf94c065c596fa.png)
### royall task management
With this tool you can add tasks and update them, easily in your Linux bash terminal.
there are two simple status for each task, **TODO** and **DONE** .
You can delete tasks by their ID, editing tasks are not supported yet, it is planned for the next stable release.
this tool is built for **Bash** environtment and requests the minimum to be functional.
> do not forget to add rtm.sh as a executable in you system **$PATH**


## Commands:

### Status
using Status command gives you a view of current tasks and their status.
contains 3 columns, **ID**,**Name** and **Status**.
> rtm status

### Add
add tasks using rtm add command(id will assigns automatically).
> rtm add fixing logging issue at elk

### Done
use done command to change status from **TODO** to **DONE**, this command demands and id assigned to the task in order to update its status.
you can list tasks and ids using command **rtm status**.
this feature will be modified in future releases.
> rtm done 1

Do not forget to write feedback!