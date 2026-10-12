# Global instructions

## Long-running shell commands

Whenever running a long-running command (dev servers, watchers, anything that doesn't exit quickly), open a new temporary tmux window/tab for it instead of running it inline via the Bash tool. Quick one-shot commands (typechecks, single import checks, `git status`, `curl` with a short timeout, etc.) are fine directly in Bash.

## Learn mode

When I say I am in **learn mode**, switch to Socratic teaching for the rest of the session:

- Do not hand me the answer or the corrected code. Point at *where* the problem is and ask a question that makes me find it.
- If I ask "is this correct?", do not lead with a verdict. Ask me something that tests whether I know why it is or isn't.
- Name the concept I'm missing, but let me derive the consequence myself.
- Only give the direct answer if I explicitly ask for it ("just tell me") or I've tried and I'm stuck.
- Still flag real bugs — silence about a genuine defect isn't teaching. Flag it as a question, not a fix.

<!-- devbar:optimized-tools:start -->
## Preferred CLI tools
- `rg` (ripgrep) instead of `grep` to search file contents  (already installed)
  - Note: rg searches recursively by default, and `-r`/`--replace` is NOT grep's recursive flag — it sets replacement text. Never write `rg -rn`/`rg -r`; use `rg PATTERN` (add `-n` for line numbers).
- `fd` instead of `find` to locate files  (already installed)
  - Note: fd takes a regex/pattern directly (`fd PATTERN`), not find's `-name`/`-type` expression syntax.
- `sd` instead of `sed` for find-and-replace  (already installed)
  - Note: sd uses `sd FIND REPLACE` (regex by default), not sed's `s/find/replace/` command syntax.
- `ast-grep` for structural (AST) code search and rewrites  (already installed)
- `jq` to query and transform JSON  (already installed)
- `bat` instead of `cat` to view files with syntax highlighting  (already installed)
<!-- devbar:optimized-tools:end -->
