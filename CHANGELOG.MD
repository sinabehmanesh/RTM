# Change Log
All notable changes to this project will be documented in this file.

## [v3.0.0] - 2026-09-07

RTM v3 keeps the original project intentionally small while making the CLI practical for daily use.

### Added
- `rtm ls` to list tasks.
- `rtm edit ID` to edit a task name interactively.
- `rtm undo ID` to move a task back to `TODO`.
- `rtm inp ID` to mark a task as `INP` (in progress).
- `rtm stop ID` to mark a task as `STOP`.
- Four task states: `TODO`, `INP`, `DONE`, and `STOP`.
- Colored status output for the task list.
- Argument validation and clearer errors for missing commands, missing IDs, and unknown tasks.
- Pre-commit configuration with YAML checks, merge-conflict checks, whitespace checks, `gofmt`, and `go vet`.
- GitHub Actions CI using GitHub-hosted Ubuntu runners.
- End-to-end CLI smoke tests for `add`, `ls`, `edit`, `inp`, `stop`, `undo`, `done`, and `del`.
- `CONTRIBUTING.md` with a short development and pre-commit guide.

### Changed
- Simplified the CLI around the core workflow: add, list, edit, delete, and change task state.
- `status` was replaced by `ls`.
- Task listing is ordered by ID and shows only ID, status, and task name.
- Existing SQLite/GORM storage and the `~/.RTM/gorm.db` database location remain unchanged.
- CI now follows the pull-request lifecycle:
  - non-draft PR updates run linting,
  - review requests and approvals run linting, build, and functional tests,
  - merges to `main` run build and functional tests.

### Removed
- `export` command.
- `rm` alias for task deletion; `del` is now the delete command.
- Legacy two-state `TODO` / `DONE` workflow.

## [v2.2]
### Upcoming changes:
- introduce editing tasks, you can edit task description/name using edit command
- auto installation for this task

## [v2.1]
- ability to export tasks into a file, export command.

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
