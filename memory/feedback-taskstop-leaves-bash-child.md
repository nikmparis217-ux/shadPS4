---
name: feedback-taskstop-leaves-bash-child
description: TaskStop and a Claude Code restart leave Git Bash background scripts running as orphans; always check Win32_Process afterwards
metadata:
  node_type: memory
  type: feedback
  originSessionId: 69673bdb-6869-4891-9c3e-5db85d30824f
  modified: 2026-09-27T01:52:47.143Z
---

On Windows, stopping a Git Bash background task (TaskStop, or a Claude Code restart that marks every task "stopped") can leave the bash process that runs the script alive. The task list says "stopped". The process keeps running and can no longer notify the session.

On 27 Sep 2026, 19 `watch_clean171_v4.sh` watchers from TEST3-TEST16 survived a restart as orphans. Each polled `ps -W` every 2 s during the user's emulator runs. A TaskStop on a fresh watcher left its script child (pid 12052) running as well.

**Why:** orphans cost CPU during frame-rate and crash runs, and one can quietly archive a run under a stale label. Meanwhile the session believes nothing is watching.

**How to apply:**
- After TaskStop or a restart, list `Get-CimInstance Win32_Process -Filter "Name='bash.exe'"` and match the session scratchpad id in CommandLine.
- Kill only your own script processes. Another session's scratchpad id means another session's process.
- Re-arm only the watchers still needed.

Related: [[feedback-never-edit-a-running-script]], [[gitbash-slash-flag-mangling]], [[gt7-shadps4-lane]].

**Which orphan is which (27 Sep 20:58):** every watcher runs the same script, so the command line cannot tell them apart,
and the script process's Windows parent is always gone, so ParentAlive is useless too. In Git Bash, `ps -l` maps the MSYS
PID to the WINPID. `tr '\0' '\n' < /proc/<msys pid>/environ | grep ^RUN=` then names the run that each script process
watches. Kill only the WINPID whose RUN belongs to the stopped task.
