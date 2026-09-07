# RTM

### royall task management

RTM is a small CLI task manager for Linux and Windows.
It keeps things simple: every task has only an ID, a name, and a status.

Task statuses are:

- `TODO` - task is waiting to be started
- `INP` - task is in progress
- `DONE` - task is finished
- `STOP` - task has been stopped

## Build

Clone the repository and build it with:

```bash
go build -o rtm main.go
```

Put the resulting binary somewhere in your `PATH`.

## Data

RTM uses SQLite to store tasks locally for each user.
The database is stored at:

```text
~/.RTM/gorm.db
```

## Commands

### List tasks

```bash
rtm ls
```

### Add a task

```bash
rtm add fix logging issue at elk
```

New tasks always start with the `TODO` status.

### Edit a task

```bash
rtm edit 1
```

RTM will show the current task name and ask for the new one.

### Delete a task

```bash
rtm del 1
```

### Mark a task as done

```bash
rtm done 1
```

### Move a task back to TODO

```bash
rtm undo 1
```

### Mark a task as in progress

```bash
rtm inp 1
```

### Stop a task

```bash
rtm stop 1
```
