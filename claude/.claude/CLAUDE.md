# Global instructions

## Long-running shell commands

Whenever running a long-running command (dev servers, watchers, anything that doesn't exit quickly), open a new temporary tmux window/tab for it instead of running it inline via the Bash tool. Quick one-shot commands (typechecks, single import checks, `git status`, `curl` with a short timeout, etc.) are fine directly in Bash.
