---
name: shadps4-pr5192-review
description: "Code review of upstream PR #5192 (mavethee, kernel I/O event queue: sceKernelAdd/DeleteRead/Write/FileEvent + GetEventFflags/Error), done 3 Oct 2026 at mavethee's request via the user: 10 problems with PR line numbers, a fix plan (~170 lines, ~80 without real vnode events), lock-order cautions; kept for a future fix"
metadata:
  node_type: memory
  type: project
  originSessionId: b5cd4610-ed8e-4e80-b4f1-9139bfdb73d5
  modified: 2026-10-03T08:04:30.663Z
---

User, 3 Oct 2026: mavethee asked the user to look at #5192 for mistakes; review given in chat (written so it can be
forwarded as is), then "ok keep it saved for future fix". **Not our PR**: nothing was posted upstream; whether the lane
ever fixes it, and how (with mavethee or not), is the user's call.

**PR state on 3 Oct:** open, 1 commit e366b1bc (+264/-6, `src/core/libraries/kernel/equeue.cpp` + `equeue.h`), CI
green, mergeable. Reviewers: georgemoralis "does this needed to any game?" (author: Until Dawn, Minecraft call them);
StevenMiller123 "not proper implementations ... nothing to complete them" (author then added `CheckIoEvent` + 10 ms
polling); StevenMiller123 "Fixes Apple TV hanging on boot" (CUSA24186, log attached); georgemoralis 3 Oct review:
"Since sockets are under heavy rewrite, it can't be merged before" (no public socket-rewrite PR found). The commit is
kept locally as `refs/review/pr5192` in C:\shadps4-clean (base = main 8e23388a).

**Findings** (lines = equeue.cpp at e366b1bc unless noted):
1. Lost events in the 10 ms wait loops (L218-221, L228-237): the predicate (`GetTriggeredEvents`, which copies,
   clears and erases events) runs inside `wait_for` and again in the outer `while (!predicate())`; non-I/O events
   (user, timer, flip, GPU) consumed by the first call are lost. Fix: loop on `wait_for`'s return value.
2. Waiter hang (L218, L228): `HasPendingIoEvents()` is read once when the wait starts; a socket event added later by
   another thread and not ready at add time (AddEvent notifies only when ready, L125-127) never wakes the waiter.
   Fix: re-check every round, notify on every I/O add.
3. Closed descriptor (L305-308): FreeBSD's close() removes the fd's kevents; here every wait returns EV_ERROR (spin),
   and a reused fd number inherits the event. Add functions only reject fd < 0 (an unopened fd returns OK). `data` =
   SCE code 0x80020009 instead of errno 9, and the PR's own `sceKernelGetEventError` (L790) reads `fflags` (0) -> 0.
4. Vnode (L374-376): fires at once and on every wait with every watched flag; `Clear()` (equeue.h L94-98) zeroes
   `fflags`, which also holds the watch mask, so the mask is lost after the first delivery. Real events fire only on
   change: hooks in write / truncate / unlink / rename, watch mask in its own field.
5. EV_EOF / EV_ERROR sticky: `TriggerIo` ORs them into `flags` (equeue.h L133-138), `Clear()` never removes them.
6. Regular-file read fires at EOF (L319); FreeBSD's vnode read filter fires only while size - offset != 0.
7. `size` (low-water mark, fflags 1) stored at L804-805 / L833-834 but overwritten by the first check (already at
   add time); fires on any byte.
8. Windows sockets: read only checks FIONREAD > 0 (L329: no peer close, error or pending accept); write always ready
   (L367-370: a non-blocking connect looks finished at once). WSAPoll gives the Linux branch's POLLIN/POLLOUT/POLLHUP.
9. P2P sockets: `P2PSocket::Native()` returns nothing (network/sockets.h L151-152) -> their events never fire.
10. Size()/Tell() (L314-315) read without `file->m_mutex` (read/write/lseek/pread take it); pread seeks to its offset
    and back (file_system.cpp L1020-1024) -> wrong count or a false, sticky EOF. `IOFile::GetSize` = fflush + stat by
    path on every check. The `timo == 0` path (L199) calls GetTriggeredEvents without the queue lock (already so on
    main; CheckIoEvent now modifies events there too).

**Checked fine:** all 8 NIDs (computed from the names: SHA-1(name + suffix 518D64A635DED8C1E6B039B1C3E55230), first 8
bytes little-endian, base64 with '/' -> '-', 11 chars; the method reproduces main's existing IDs); no lock-order
inversion today (nothing takes a queue lock under the file-table lock; other TriggerEvent callers: gnmdriver,
videoout); queue checks and EBADF / ENOENT codes match the existing Add/Delete functions.
**Not verifiable without the real library:** `sceKernelGetEventError` format; the `0xffffff90` mask (rejects
NOTE_LINK 0x10); whether PS4 read events are edge-triggered (EV_CLEAR); the PR makes them level-triggered.

**Fix plan (estimates, not written):** 1+2 ~20 lines (replaces ~25); 3 ~30; 4 ~80-100; 5 ~2; 6 ~3 (deletions);
7 ~10; 8 ~15 (merges two branches); 9 0 until the socket rewrite; 10 ~5. Total ~170; ~80 without real vnode events.
Split option: regular-file events + getters now (1-3, 5-7, 10: ~70 lines), sockets after the rewrite, vnode later.

**Why:** the user wants the review available for a later fix without redoing it.
**How to apply:**
- Before working on it: re-fetch the PR (`git fetch origin pull/5192/head`) and compare with e366b1bc; the line
  numbers above belong to that commit. Check whether the socket rewrite has landed (fixes 8-9 depend on it).
- Lock order: the close cleanup (fix 3) goes at the start of the close function, NOT inside
  `HandleTable::DeleteHandle` (it holds the file-table lock; CheckIoEvent takes queue lock -> table lock). Vnode
  notifications (fix 4) run after the file's own lock is released.
- Upstream writing stays with the user ([[feedback-shadps4-comments-cleanup-later]]).

Related: [[gt7-shadps4-lane]], [[shadps4-fix-candidates]].
