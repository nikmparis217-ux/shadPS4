---
name: feedback-arm-only-current-test
description: "shadPS4 watcher/auditor — όπλιζε watcher + catcher ΜΟΝΟ για το test που μόλις έχτισε ο builder· 30 λεπτά χωρίς νέο run = σταματάς τελείως (χρήστης, 29 Σεπ 2026)"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 0bdb4255-1ac0-4abb-9dd3-ea05165bd11b
  modified: 2026-09-29T04:58:34.512Z
---

Όπλιζε log watcher και exit-code catcher μόνο για το test build που μόλις έχτισε ο builder (το άλλο chat).
Όχι παλιά tests, όχι builds που δεν έχτισε ο builder. Αν περάσουν 30 λεπτά χωρίς νέο run αυτού του test,
σταματάς watcher και catcher ΤΕΛΕΙΩΣ (δεν τα ξαναοπλίζεις μέχρι το επόμενο build του builder).

**Why:** ο χρήστης, 29 Σεπ 2026: (1) «dont arm old tests. only tests that we actually make old tests there is no
point wasting tokens»· (2) 07:50: «disarm the watchers. from now on we only arm the tests the other chat builds and
after 30 mins if the test is not rerun stop the watch completely». Κάθε οπλισμένο loop κοστίζει polling και task
notifications. Τα loops του TEST28 περίμεναν από τις 07:04 (τέλος run 3) χωρίς run 4 και σταμάτησαν 07:53.

**How to apply:**
- Νέο build του builder: σταμάτα τα loops του προηγούμενου, όπλισε μόνο το νέο.
- 30 λεπτά χωρίς launch από το τέλος του τελευταίου run (ή από το όπλισμα, αν δεν έτρεξε ποτέ): TaskStop και στα δύο,
  μετά σκότωσε τα msys bash που μένουν (Win32_Process: command line με το δικό σου scratchpad· πρώτα το loop, μετά
  τον watcher, `taskkill /PID <winpid> /T /F`) και επιβεβαίωσε ότι δεν έμεινε κανένα.
- Το 30λεπτο είναι ενσωματωμένο στα `watch_loop_v6.sh` / `watch_clean171_v6.sh` / `catch_loop_v6.ps1` (scratchpad
  0bdb4255): σταματούν μόνα τους, και η ειδοποίηση λήξης του task είναι το σήμα να ενημερωθεί το handoff.
- Ο κανόνας είναι και στο RULES block του CLAUDE.md (Runs).

Σχετικά: [[gt7-shadps4-auditor-handoff]], [[feedback-taskstop-leaves-bash-child]], [[feedback-lane-rules-in-claude-md]].
