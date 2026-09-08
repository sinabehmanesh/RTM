# RTM

### royall task management

RTM is a small CLI task manager for Linux and Windows.
It keeps things simple: every task has only an ID, a name, and a status.

Task statuses are:

- `TODO` - task is waiting to be started
- `INP` - task is in progress
- `DONE` - task is finished
- `STOP` - task has been stopped

## Install

The automatic installers require `git` and `go` to already be available in `PATH`.
They clone RTM, build it, and add the RTM binary directory to your user `PATH`.
Running the installer again updates the existing installation from `main` and rebuilds RTM.

### Linux

From a cloned repository:

```bash
sh install.sh
```

Or directly from GitHub:

```bash
curl -fsSL https://raw.githubusercontent.com/sinabehmanesh/RTM/main/install.sh | sh
```

The default installation uses:

```text
source: ~/.local/share/rtm/source
binary: ~/.local/bin/rtm
```

If `~/.local/bin` is not already in `PATH`, the installer adds it to your shell profile. Open a new terminal afterwards, or source the profile shown by the installer.

### Windows

From a cloned repository, run in Command Prompt:

```bat
install.bat
```

Or download and run the installer directly:

```bat
curl.exe -fsSL -o "%TEMP%\rtm-install.bat" https://raw.githubusercontent.com/sinabehmanesh/RTM/main/install.bat && call "%TEMP%\rtm-install.bat"
```

The default installation uses:

```text
source: %LOCALAPPDATA%\RTM\source
binary: %LOCALAPPDATA%\RTM\bin\rtm.exe
```

The installer adds the binary directory to your user `PATH`. Open a new terminal after installation.

## Manual build

Clone the repository and build it with:

```bash
go build -o rtm .
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
