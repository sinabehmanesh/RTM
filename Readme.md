# RTM
![alt text](https://cdn.dribbble.com/users/32384/screenshots/3225544/media/3492fc2c4ca08e9cfcbf94c065c596fa.png)
### royall task management
With this tool you can add tasks and update them, easily in your Linux/Windows terminal.
there are two simple status for each task, **TODO** and **DONE** .
You can delete tasks by their ID, editing tasks are not supported yet, it is planned for the next stable release.
this tool is built for **CLI** environtment and requests the minimum to be functional.

## Build
to build and use this applications, easliy:
- Clone source code
- Build with `go build -o rtm main.go `
- Output binary is the target binary, you can put it in you **USER** path.

## Info
This application uses sqlite to store tasks for each user, you can find the db file in you ~/.RTM/gorm.db


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

### Delete
you can easily delete tasks by their ID, just get the latest status using status command and then try **rtm del ID**.
both del and rm can be used, this will run a delete query on the table.


### Export
If you ever wanted to have a backup of you work, you can run **rtm export**.
this command will create a backup from your current work status in the config directory.
it also appends a date to the file name so the file can be recognized.


Do not forget to write feedback!