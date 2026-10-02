---
name: feedback-lane-rules-in-claude-md
description: "shadPS4/GT7 lane rules live in the RULES block at the end of C:\\GTNikos\\CLAUDE.md, the one file every new session loads automatically. A newly agreed rule goes there too, not only into memory files."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 0bdb4255-1ac0-4abb-9dd3-ea05165bd11b
  modified: 2026-09-27T19:27:39.482Z
---

27 Sep 2026, the user: "we need every chat to read the rules every time it begins a new session".

Before this, the lane's CLAUDE.md section carried only 6 rules in one sentence; the rest (watcher + catcher before
every run, the pad check, async log caveats, no cross-session messages without the user's word, the wording rule,
8.3 build paths, PR criteria...) sat in memory files and HANDOFF.md, which a new session reads only if it decides to.
Only CLAUDE.md and the MEMORY.md index are loaded automatically.

Now: `### RULES — every new session in the shadPS4 / GT7 lane reads these before doing anything` at the end of
`C:\GTNikos\CLAUDE.md` (line ~5422, 45 lines, English), with a start-of-session reading list.

**Why:** the flagged-chat incident showed a new session acting on rules it had never seen; the user had to change
sessions and lose tokens.

**How to apply:**
- When the user agrees a new standing rule for the lane, add one line to that block in the same turn (Read the
  tail first; other sessions edit CLAUDE.md, so use Edit, never a rewrite). Never shorten the rest of CLAUDE.md.
- Keep the block to emulator facts and positive scope statements (see [[feedback-no-flag-prone-wording]]): it is
  loaded into every session, so nothing flag-prone may go in it, not even as a prohibition.
- It only reaches sessions started in `C:\GTNikos` (CLAUDE.md is per working directory). A session already running
  when the block changes does not see the change unless pointed at it.

Related: [[gt7-shadps4-auditor-handoff]], [[gt7-shadps4-lane]], [[gt-nikos-startup-cost]].
