# shadPS4 fork, GT7 lane - Claude brief

Read `GT7_upstream/README.md` first. Its section "STATE ON 22 SEP 2026 - READ THIS FIRST" is the
current state; the rest of that file is the standing rules, the build and the traps. This file is
the short form.

- Reply to the user in Greek. Repo content (code, commits, docs, PR text) in English.
- Never launch the emulator or the game: the user launches and closes runs. Watch the log.
- Never build or commit in `C:\shadps4-sync`. Never edit `GT7_work/GOW_probe*.bat` or
  `GT7_work/psn_local/server_log.txt`. `gt7-v0.18.0` (Documents\GitHub\shadPS4) is reference only.
- Build with `GT7_upstream\build.bat` and read `NINJA_EXIT`, not the shell's exit code.
- Archive `%APPDATA%\shadPS4\log\shad_log.txt` into `GT7_upstream/logs/` before every launch and
  the moment a run exits, before any analysis. Another chat shares that live log.
- A fix enters the codebase only when the PS4 semantics are explained and the emulator is shown
  wrong or incomplete, never because it makes GT7 progress. Root cause, not symptom.
- One general fix per PR branch, PR-ready from the first line: no comments narrating the
  investigation, no `GT_*` gate, no game named in the code, no Co-Authored-By or
  "generated with" trailer anywhere.
- Instruments live in C++ behind `GT_*` environment variables and are stripped before any PR.
  Emulator tooling is never python or ps1; ad-hoc log analysis scripts stay out of `src`.
- Report research as ROOT CAUSE / EVIDENCE / CHANGE / VALIDATION / REMAINING ISSUE / DIFF REVIEW.
- The active game is `CUSA24769 v01.00`; `CUSA24767 v01.71` is parked. Read the log's `Game id`.
- Worktrees: `C:\shadps4-gt7` = `gt7-main` (b1cd966e); `C:\shadps4-pr-lds` = `pr-lds-stream-commit`
  (65b03b2f, the LDS `Commit()` fix, unpushed); `C:\shadps4-pr` = `pr-descriptor-dword-mask` (older).
