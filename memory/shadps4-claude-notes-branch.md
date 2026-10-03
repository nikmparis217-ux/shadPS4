---
name: shadps4-claude-notes-branch
description: "Branch `claude` on the PUBLIC fork (remote `mine`) is MY personal memory for the shadPS4/GT7 lane: read CLAUDE_MEMORY.md at session start, append lessons/fixes/refuted hypotheses, push with plumbing; since 2 Oct EVERY md a session writes goes there too, pushed right after the write"
metadata:
  node_type: memory
  type: project
  originSessionId: 69673bdb-6869-4891-9c3e-5db85d30824f
  modified: 2026-10-03T10:22:17.054Z
---

On 23 Sep 2026 the user created branch `claude` on `nikmparis217-ux/shadPS4` (remote `mine`) and
then defined what it is for: «this is your personal branch for anything you need to remember for
next sessions old fixes old mistakes to not repeat etc». It is an orphan, notes-only branch (no
source, no gt7-main history). It holds the lane's handoffs (CLAUDE.md, GT7_upstream/*.md, GT7_work/*.md)
and, since commit 5f727a8f, **`CLAUDE_MEMORY.md`**: standing rules, 25 mistakes not to repeat,
proven fixes (65b03b2f LDS Commit, 4720205e fences, 387baa06 MappedPrefixAt, ...), refuted
hypotheses, open targets with exact state (runs 351-353: the killer of cube 0x100b1b0000 is a
960x540 R16G16Sfloat RT, MipOf correct, run 354 = simultaneous-vs-sequential awaiting user go).

**Why:** the user wants lane knowledge to survive sessions on GitHub. They chose the PUBLIC fork
knowingly (same fork as the PR branches; upstream does not want AI - see
[[feedback-shadps4-comments-cleanup-later]]). Do not re-litigate. Push only to `mine`, never `origin`.

**How to apply:**
- At the start of any shadPS4 session: `git -C /c/shadps4-gt7 show claude:CLAUDE_MEMORY.md`.
- When a lesson, proven fix, refuted hypothesis or run result appears, append it to
  CLAUDE_MEMORY.md (English, append-only: mark wrong entries wrong rather than deleting) and push.
- ANOTHER SESSION ALSO COMMITS HERE (the 1.71/offline chat added 7a203945). Always
  `git fetch mine claude` first and build on the remote tip.
- Recipe (never touches gt7-main's index or tree):

      cd /c/shadps4-gt7; git fetch mine claude   # compare FETCH_HEAD with claude first
      export GIT_INDEX_FILE=<scratchpad>/claude-notes.index   # NOT under .git - it is a pointer file
      git read-tree claude
      b=$(git hash-object -w --path=CLAUDE_MEMORY.md <scratchpad>/CLAUDE_MEMORY.md)
      git update-index --add --cacheinfo "100644,$b,CLAUDE_MEMORY.md"
      C=$(git commit-tree "$(git write-tree)" -p claude -m "...")   # NO trailer
      git update-ref refs/heads/claude "$C"; unset GIT_INDEX_FILE
      git push mine refs/heads/claude:refs/heads/claude

- Edit a copy in the scratchpad (extract with `git show claude:CLAUDE_MEMORY.md > ...`), never in
  the gt7-main working tree.
- `git status` with a stale GIT_INDEX_FILE shows everything `D`/`??` - artifact, unset and recheck.
- No Co-Authored-By trailer (user rule for this lane: none anywhere).
- 2 Oct 2026 14:58, user to the auditor: «save any md you have there also» → commit bb90192 (on 1c63b31): 22 NEW
  files, nothing existing changed: `GT7_upstream/` CRASH_MAP, IMAGE_PROBLEMS_MAP, HANDOFF, MERGE_upstream_19700eba,
  REPORT_PR5165_PR5166, `logs/test37_plan_resource_guards.md`; `shadps4-gow|got|gtav/README.md` (disk folder names);
  `memory/` = the auditor sessions' memory files. Left out on purpose: GT7_upstream/README.md and GT7_171_RUN348/350
  (the offline-patch line, not emulator work), MEMORY.md (indexes every lane of the project). A second recipe that
  writes into no existing repo: `git clone --single-branch --branch claude <fork url>` into a scratchpad,
  `git config core.autocrlf false` there (the global `true` turns the checkout CRLF), add only the new paths, commit as
  nikmparis217-ux <295578344+nikmparis217-ux@users.noreply.github.com>, `git ls-remote` the tip, push fast-forward.
- 2 Oct 2026 ~17:40, user to the builder (gtnikos-02): «everything you write in md goes also to your claude branch
  to have a safe place saved your md» → standing, for every session (rule line in the CLAUDE.md block): every md
  written (handoffs, memory files, audits, plans) is committed to `claude` at its disk path and pushed right after
  the write. Paths: `GT7_upstream/` = C:\shadps4-gt7\GT7_upstream, `shadps4-<game>/` = C:\shadps4-<game>,
  `memory/` = this memory folder, `shadps4-lane/` = C:\shadps4-lane (the lane's own CLAUDE.md since 2 Oct,
  [[shadps4-lane-folder]]), `GTNikos/CLAUDE_shadps4_section.md` = ONLY the shadPS4 section of
  C:\GTNikos\CLAUDE.md (the rest is the game project). Stays out: MEMORY.md (indexes every lane). The branch is
  public, so the one gmail address in gt7-shadps4-lane.md (~line 860, a commit author) is written as
  `<gmail address>` in the branch copy only; scan for addresses, tokens and keys before every push.
- 3 Oct 2026 ~12:35, builder shadps4-lane-f9: passed `MEMORY.md` to the prep script with the other memory names and
  pushed it. User, once told the index also names the non-emulator lanes: "no that is not fine. remove it" -> ~13:15
  the branch was rewritten with `--force-with-lease`: a46666fd + one commit holding the same notes without
  MEMORY.md; the three commits after a46666fd left the branch. GitHub still served the old commit by its exact id
  right after (API HTTP 200; only GitHub Support can purge it, the user's step), so never write a removed commit's id anywhere
  public. The "every md" rule does NOT cover MEMORY.md: check every path against "Stays out" above before each push.
- The local `claude` ref lags the remote whenever a session pushes from a scratchpad clone (2 Oct 17:3x: local
  1c63b313, remote f498fe6e). Build on FETCH_HEAD (`-p FETCH_HEAD`), then
  `git update-ref refs/heads/claude <new> <old>`. All the shadPS4 worktrees (C:\shadps4-clean, C:\shadps4-gt7,
  Documents\GitHub\shadPS4) are ONE repository, so the recipe runs from any of them.
