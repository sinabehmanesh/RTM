# Development

RTM is intentionally small. Keep changes simple and avoid adding abstractions unless they solve a real problem.

## Requirements

- Go version from `go.mod`
- Python 3
- `pre-commit`

Install pre-commit:

```bash
python -m pip install pre-commit==4.6.1
pre-commit install
```

Run all checks manually:

```bash
pre-commit run --all-files
```

Build RTM:

```bash
go build -o rtm .
```

## CI

For a non-draft pull request, every new push/update runs the pre-commit checks.

When a reviewer is requested, CI runs pre-commit, builds RTM, and runs the end-to-end CLI smoke test.

When a reviewer approves the pull request, CI runs pre-commit, builds RTM, and runs the same smoke test again against the approved PR commit.

When the pull request is merged into `main`, CI builds RTM and runs the smoke test. Linting is not repeated for the merged commit.

The smoke test verifies `add`, `ls`, `edit`, `inp`, `stop`, `undo`, `done`, and `del`. It is intentionally CI-only because it uses and removes `~/.RTM` on the disposable GitHub-hosted runner.
