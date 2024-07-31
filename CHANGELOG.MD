
# Change Log
All notable changes to this project will be documented in this file.

## [v2.1] 
### Upcoming changes:
- introduce editing tasks, you can edit task description/name using edit command
- ability to delete all tasks at once, also exporting them into a file.
- auto installation for this task


## [v2.0]
- Language will be changed to Golang
- Same features as the version 1.0 released.
- sqlite database included, it now uese sqlite database.

~~- introduce editing tasks. a new function that can be invoked to edit a task by ints ID.~~
~~- auto installation, the classic Curl + bash installation format.~~

## [v1.0] - 2024-07-23
 
First stable release, This is the first release of RTM as a cli task manager.
> still no official website is up, I also do not plan to have one in the future.
 
### Added
- RTM code base in bash with full functional modules.
- logger, ci-output, task functions(add, del, done, status)

 
### Changed
- reworked bash structure, it is no longer using the beta code base.
- changed the grid collumns, switched the name and status for better visualization.

### Fixed
-  nothing yet