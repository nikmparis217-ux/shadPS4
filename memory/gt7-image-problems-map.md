---
name: gt7-image-problems-map
description: "GT7 1.71: τα προβλήματα εικόνας παρκαρισμένα πίσω από τα crashes (χρήστης, 29 Σεπ)· ο χάρτης = C:\\shadps4-gt7\\GT7_upstream\\IMAGE_PROBLEMS_MAP.md"
metadata:
  node_type: memory
  type: project
  originSessionId: 0bdb4255-1ac0-4abb-9dd3-ea05165bd11b
  modified: 2026-09-28T22:34:22.061Z
---

Ο χρήστης (29 Σεπ 2026): πρώτα να σταματήσουν τα crashes του GT7 1.71, ΜΕΤΑ τα προβλήματα εικόνας ένα-ένα.
Χάρτης: `C:\shadps4-gt7\GT7_upstream\IMAGE_PROBLEMS_MAP.md` — ανά σύμπτωμα: αιτία, ετυμηγορία του lab patch,
κώδικας (upstream e518a651), πρώτη μέτρηση στο 1.71. Στοιχεία με αριθμούς γραμμών:
`GT7_upstream\logs\lab_rendering_patches_review.txt`. Pointer και στο `GT7_upstream\HANDOFF.md` (ενότητα GT7 1.71).

**Why:** το πρώτο test του δρόμου (Precise readbacks από boot) προσθέτει ένα πλήρες GPU drain ανά read fault και
σκότωσε το lab run 260· σε build που ήδη κρασάρει συχνά, ένα νέο crash δεν ξεχωρίζει από τα παλιά.

**How to apply:**
- Μία γραμμή του χάρτη τη φορά· πρώτα η μέτρηση «Chase next» στο 1.71 (lab = GT7 1.00 σε v0.18.0)· fix στον
  γενικό μηχανισμό, όχι το lab patch.
- Τα λάθος γράμματα = ΔΥΟ κλάδοι του `InvalidateMemory` (REPORT_PR5165_PR5166.md 205-224, του d9): 34 αναφορές
  μέσα σε μία σελίδα → MaybeCpuDirty → το test κοιτά μόνο 64 bytes (texture_cache.cpp:700-717)· 42 σε 2+ σελίδες →
  `UntrackImageHead/Tail` βγάζουν τη σελίδα από την παρακολούθηση χωρίς dirty (137-147, 900-935). Οι αστοχίες
  μετρημένες· ότι φτιάχνουν τα γράμματα «very likely»· απόδειξη = TEST28 του report (όχι το `test28-snormnz-conv` της
  29 Σεπ, που είναι το SnormNz crash fix). ⚠ Διάβασα πρώτα το δικό μου
  audit και έγραψα «round-robin = άγνωστη αιτία» ενώ το report την είχε ήδη βρει: για γράμματα, πρώτα το REPORT.
- Το 32-push-slot patch του lab ΔΕΝ είναι πρόβλημα εικόνας: είναι το info.h:183 crash → λίστα σταθερότητας.
- Νέο σύμπτωμα εικόνας = νέα γραμμή στον ίδιο χάρτη, όχι νέο αρχείο.

Σχετικά: [[gt7-shadps4-auditor-handoff]], [[gt7-shadps4-lane]].
