---
name: writing-edit
description: Give feedback on a piece of the user's writing, edit it (grammar, clarity, concision), and copy the final version to the macOS clipboard with pbcopy. Trigger when the user asks to fix grammar, edit, polish, proofread, review, or get feedback on writing they paste or point to (briefs, answers, messages, docs), or says "put it in my clipboard" for edited text.
---

# Writing Edit

Edit the user's writing, explain the key changes briefly, then copy the final text to the clipboard.

## Editing
- Keep the user's voice, meaning, and structure. Augment and tighten; don't rewrite from scratch.
- Fix grammar, awkward phrasing, and vague wording. Cut filler and redundant phrases.
- Don't invent facts, numbers, or claims. If a number or claim rests on an unstated assumption, flag it (e.g., "reduction in churn" implies a known baseline churn rate).
- Keep it as prose unless the user asks for sections. Don't add labeled headers like "What I'd do differently:"; weave ideas into the text.
- If the writing answers a prompt (worksheet, brief, question), check it actually answers what's asked, and flag any gaps.

## Response format
1. The edited text in a blockquote.
2. Feedback: 2–4 short bullets on the most important changes and why. Skip minor fixes.
3. One line confirming it's on the clipboard.

Keep the whole response short.

## Multi-turn edits
Treat each message as its own standalone piece of text. Don't merge it with text edited earlier in the conversation unless the user explicitly asks to combine them.

## Clipboard
Copy the final text only (no quote markers or commentary) with a quoted heredoc so `$`, quotes, and backticks survive, then verify:

```bash
cat <<'EOF' | pbcopy
<final text>
EOF
pbpaste
```

If the user asks for another revision, apply it and re-copy the new version.
