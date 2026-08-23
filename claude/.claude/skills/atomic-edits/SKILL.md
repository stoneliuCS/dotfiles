---
name: atomic-edits
description: Make every code edit atomic (a few lines at most) with an explanation of what each major line does, why, and how it changes the system's behavior. Trigger for any coding/implementation task — writing, editing, or proposing changes to code — not just when the user explicitly asks for atomicity.
---

# Atomic edits with explanations

Stone wants to follow along at the line level, not just the diff level. Every code change must be small enough and explained enough that he can understand the behavior before the next change happens.

## Rules

- Split work into the smallest edits that still compile/run — a few lines each. Never bundle multiple unrelated changes into one Edit call.
- Before (or immediately after) each edit, explain in prose:
  - What the change does, line by line for the major/non-obvious lines (skip boilerplate lines that don't need explaining).
  - Why this line/approach was chosen over alternatives.
  - How it changes the overall system's behavior — what was true before, what's true after, what a caller/user would now observe differently.
- If a "logical change" naturally needs more than ~5-10 lines, stop and break it into an ordered sequence of atomic edits instead of one large one. Say what the sequence is before starting.
- Apply this to proposed changes too, not just applied ones — when presenting a plan or diff for approval, present it as a sequence of atomic, explained steps rather than one large patch.
- Don't skip this process for "obvious" or "trivial" edits — the explanation can be one short sentence, but it must be present.
- This does not require asking for approval after every single edit (only if the user separately asked for that) — it requires that each edit is small and explained as you go.
