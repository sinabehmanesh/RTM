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

For an open pull request, every new push runs the pre-commit checks.

When a pull request review is submitted as **approved**, CI builds RTM and runs an end-to-end CLI smoke test against the approved PR commit.

Every push to `main` also builds RTM and runs the same smoke test.

The smoke test verifies `add`, `ls`, `edit`, `inp`, `stop`, `undo`, `done`, and `del`. It is intentionally CI-only because it uses and removes `~/.RTM` on the disposable GitHub-hosted runner.
