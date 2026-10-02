---
name: shadps4-lane-folder
description: "Since 2 Oct 2026 the shadPS4 lane's sessions start in C:\\shadps4-lane (7 KB CLAUDE.md = lane brief + RULES block) instead of C:\\GTNikos (509 KB CLAUDE.md, ~125k tokens at every start and every compaction); its Claude memory folder is a JUNCTION to c--GTNikos\\memory - remove only with cmd /c rmdir"
metadata:
  node_type: memory
  type: project
  originSessionId: 49cf0e5f-403f-49b2-b3c1-d4be39ba3d59
  modified: 2026-10-02T15:09:15.017Z
---

2 Oct 2026, the user asked whether graphify would stop the re-reading of the same files. Measured answer: the
biggest repeated load is `C:\GTNikos\CLAUDE.md` itself, 509,002 bytes (~125k tokens), which Claude Code loads at
every session start and again after every compaction; only 7 KB of it (1.4 %) is this lane. The user agreed to start
the lane's sessions from a folder of their own.

What was set up (builder gtnikos-02, ~18:10):
- `C:\shadps4-lane\CLAUDE.md` (7,212 bytes): a short brief (where everything is, the junction warning) + the RULES
  block copied from the end of `C:\GTNikos\CLAUDE.md`. The block stays there too, with one added line saying where
  sessions start; that file was NOT shortened, because on 16 Aug the user decided not to cut it
  ([[gt-nikos-startup-cost]]).
- `C:\shadps4-lane\.claude\settings.local.json`: the same 10 permission allow rules as
  `C:\GTNikos\.claude\settings.local.json`, without `enabledMcpjsonServers: unreal-mcp` (there is no `.mcp.json`
  there, so a lane session does not try to reach the Unreal MCP server).
- `C:\Users\Νίκος\.claude\projects\c--shadps4-lane\memory` = directory JUNCTION to `...\c--GTNikos\memory`
  (149 files seen through it). Claude Code names a project folder after the working directory with every character
  that is not a letter or digit turned into `-` (`c:\GTNikos` -> `c--GTNikos`, `C:\Users\Νίκος` -> `C--Users------`),
  so a session started in `C:\shadps4-lane` uses `c--shadps4-lane` and finds the shared memory there.

**Why:** ~125k tokens of game notes at every start and after every compaction, and the context they fill brings the
next compaction sooner, which is what forces most of the mid-session re-reads.

**How to apply:**
- The user opens `C:\shadps4-lane` in VS Code (File > Open Folder) for new lane sessions, builder and auditor alike.
  Sessions already running in `C:\GTNikos` keep going; `/resume` lists only the sessions of the folder it runs in.
- A new lane rule = one line in BOTH copies of the RULES block, in the same turn ([[feedback-lane-rules-in-claude-md]]).
- ⚠ Remove the junction only with `cmd /c rmdir "<link>"`. Windows PowerShell 5.1 `Remove-Item -Recurse` (and other
  recursive deletes that follow junctions) can walk into it and delete the TARGET's files: every lane's memory, most of
  which (the game's) is not on the `claude` branch.
- If a new lane session reports an empty memory folder, the folder-name rule above was wrong for it: read the memory
  path its system prompt prints and make the junction there.
- Undo: `cmd /c rmdir` the junction, delete the `c--shadps4-lane` project folder and `C:\shadps4-lane`, and drop the
  "Sessions start in" line from the RULES block in `C:\GTNikos\CLAUDE.md`.

Related: [[shadps4-claude-notes-branch]], [[gt7-shadps4-lane]].
