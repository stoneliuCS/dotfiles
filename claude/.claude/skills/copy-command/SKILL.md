---
name: copy-command
description: Copy any shell command you give the user to run themselves to the macOS clipboard with pbcopy. Trigger whenever your response asks the user to run a command in their own terminal or via the `!` prefix (e.g. interactive logins like `sf org login web`, `gcloud auth login`, setup or install commands), even if they didn't ask for it to be copied.
---

# Copy Command

When you hand the user a command to run, also put it on their clipboard so they can paste it straight away.

## Steps
1. Write the exact final command, ready to paste. Fill in real values (URLs, aliases, paths) rather than placeholders whenever you know them.
2. Copy it with `printf '%s' '<command>' | pbcopy`. Use `printf '%s'` so no trailing newline is added; a trailing newline can make some terminals run the command as soon as it's pasted.
   - If the command contains single quotes, use a quoted heredoc instead: `pbcopy <<'EOF'` ... `EOF` (this one does add a trailing newline, so prefer `printf` when possible).
3. Show the command in a code block as usual, and add one short line confirming it's on the clipboard.

## Rules
- Copy the plain command without the `!` prefix, unless the user is meant to type it into the Claude Code prompt. In that case, say they can type `!` and then paste.
- If you give several commands to run in order, copy them as one block joined by newlines, and say so. If they must run separately (for example, wait for a browser login first), copy only the first one and say which one is on the clipboard.
- Never copy secrets (passwords, tokens, keys) to the clipboard. Leave a placeholder and tell the user to fill it in.
- Don't copy commands that you run yourself through the Bash tool. This is only for commands the user runs.
