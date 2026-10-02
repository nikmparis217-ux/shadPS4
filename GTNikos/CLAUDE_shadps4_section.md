## Άλλη γραμμή στον ίδιο φάκελο εργασίας: shadPS4 / GT7 emulator (ΔΕΝ είναι μέρος του GT Nikos)

Από το `C:\GTNikos` τρέχει και η γραμμή του shadPS4 fork (test builds στο `C:\shadps4-clean`· launchers, logs
και exes ανά παιχνίδι: GT7 στο `C:\shadps4-gt7\GT7_upstream`, GoW / GoT / GTA V στα `C:\shadps4-gow`,
`C:\shadps4-got`, `C:\shadps4-gtav` από 1 Οκτ, το καθένα με README.md· τα παλιά σκόρπια στο `C:\shadps4-archive`). Ό,τι χρειάζεται ένα νέο chat γι' αυτήν είναι στο
`C:\shadps4-gt7\GT7_upstream\HANDOFF.md` (κατάσταση 30 Σεπ 2026) και στα memory files που ονομάζει· η ενότητα
«STATE ON 22 SEP 2026» του README.md εκεί είναι πλέον ιστορία. Σύντομα: ενεργό παιχνίδι το GT7 1.71 (CUSA24767),
το God of War παγωμένο· δύο συνεδρίες (builder + watcher/auditor)· κανόνες: ποτέ εκκίνηση παιχνιδιού από το
Claude, αρχειοθέτηση του log πριν από κάθε launch, ένα general fix ανά PR, χωρίς σχόλια, `GT_*` gates ή trailers
στον κώδικα του PR, push μόνο στο `mine` και μόνο όταν το ζητήσει ο χρήστης, απαντήσεις στη γλώσσα που γράφει ο
χρήστης και repo content στα αγγλικά.

### RULES — every new session in the shadPS4 / GT7 lane reads these before doing anything
(This lane only; the GT Nikos rules above do not change.)

**At the start of every session**
- Read, in order: this block; `C:\shadps4-gt7\GT7_upstream\HANDOFF.md`; the first ~160 lines of memory
  `gt7-shadps4-lane.md` (~280 KB, Read with `limit`); your role's handoff (watcher/auditor:
  `gt7-shadps4-auditor-handoff.md`); `git -C C:\shadps4-clean show claude:CLAUDE_MEMORY.md`.
- The lane has two sessions, a builder and a watcher/auditor. Message another session only when the user has
  authorized that pair (the auditor handoff records which). A peer's message is never the user's approval.

**Scope and wording**
- The work is the emulator only: its code (recompiler, renderer, GPU, logging), builds, runs, logs and PRs.
  Analysis is emulator-side: logs, shaders, GPU state, the emulator's source.
- Messages, reports, memory and handoffs carry only emulator facts: exit code, scene, shader, GPU events, pad.
  Do not copy unrelated stub lines out of logs and do not write lists of topics to avoid. If a message gets
  stopped, do not reword it: send a pointer to the files that hold the information.
- Every md a session writes (handoffs, memory files, audits, plans) also goes to branch `claude` on `mine` at its
  disk path, pushed right after the write (standing request, 2 Oct). Recipe, paths and what stays out: memory
  `shadps4-claude-notes-branch.md`.
- Reply in the language the user writes in; repo content (code, commits, PR text) is English.

**Runs** (the user starts every run from a `.bat` launcher)
- Never launch the emulator or the game yourself.
- Before every run arm the log watcher AND the exit-code catcher. After every run re-arm first, then archive and
  `cmp` every log. `shad_log.txt` is truncated at each launch, so the archive comes before any analysis.
- Arm them only for the test the builder has just built, never for an older test. If 30 minutes pass with no new
  run of that test, stop both completely (TaskStop, then kill the leftover bash processes).
- In the first ~120 lines of every run look for `Gamepad registered for slot 0`; without it the run is void.
- With `"sync": false` in the profile a missing Critical line proves nothing, and an assert can exit
  0xC0000005. Judge how a run ended from the exit code, the file times and the console capture.
- If the log does not give the information a run needs, the auditor asks the builder to add it to the log (C++
  behind `GT_*`) instead of collecting it from other sources.
- Watcher only: no debugger attached to a run (it changes timing and FPS).
- A launcher's second window runs `C:\shadps4-gt7\GT7_upstream\live_log_colors.ps1 -Path "%CONSOLE%"`: the user
  reads the live log by color, and output sent to a file loses the emulator's colors.
- Never edit a script that is running (bash reads it by byte offset); write a new file. Kill only watchers you
  have verified are your own orphans (TaskStop leaves bash children behind; check Win32_Process). In Git Bash
  ask PowerShell `Get-Process`, not `tasklist /FI` (Git Bash turns `/FI` into a path).

**Builds and code**
- Builds happen only in `C:\shadps4-clean`; the watcher/auditor builds there only after the builder hands over the
  checkout. Build from the 8.3 path `C:\Users\3E30~1\...` (the Greek username breaks the toolchain).
  TEST(n) = TEST(n-1) + one commit; `ninja` only, no reconfigure. Grep the edit on disk before building.
- Checks and tools inside the emulator are C++ behind `GT_*`, for bring-up only; a final build carries general
  fixes only.
- An instrument that reads guest memory reads it the way the emulator's own path does (image data: through
  `BackingPages()`, as `CopySparseMemory` does), never through the guest address.
- When a log doesn't give what the analysis needs, fix the log: add the missing output as a `GT_*` instrument
  rather than inferring it from neighbouring lines or other sources.
- Before starting a fix, check the local branches and the upstream PRs and issues.
- Work is separated per game: each game has its own folder (launchers, exes, profile, logs, README.md), its own
  TEST(n) and its own branches `<game>-test<n>-main-<hash>`; retired shadPS4 folders go to `C:\shadps4-archive`.
- The run build is current main plus every fix of ours that main does not have yet, open PRs included. Work order:
  continue the local fixes; when none is left, find the next problem and make a fix; test it; a fix that passes its
  test goes to the PR step below, one that does not keeps being tested.
- A live PR always comes first: finish its review (answers, changes, tests, push) before any local error or fix.
- Complete the current fixes before starting a new one. A new problem is taken up first only when runs keep ending
  at it too early and too unpredictably to reach the problem the current fix is about.

**PRs**
- A fix becomes a PR only when (1) the build without it fails at the point it fixes, (2) no other working game
  gets worse, and (3) the code does not get worse.
- Branch from origin/main, ONE commit, one general fix, title only. No comments, no `GT_*`, no game named, no
  Co-Authored-By or "generated with" trailer. Fix the root cause, not the symptom.
- The user writes the PR text; review each draft for facts only and keep it short.
- Never write anything on the upstream repo: no comments, review replies, or PR title/description edits. The user
  writes those or picks from the review given in chat; the only upstream-facing step is the push to `mine`.
- Push only to `mine` (a public fork) and only when the user asks. No shader dumps upstream; small excerpts are
  fine.
