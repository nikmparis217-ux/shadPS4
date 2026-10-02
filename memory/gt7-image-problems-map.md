---
name: gt7-image-problems-map
description: "Τα προβλήματα εικόνας έρχονται ΜΕΤΑ τα crashes: GT7 1.71 (χρήστης, 29 Σεπ) και από 3 Οκτ για ΟΛΑ τα παιχνίδια και τον emulator (κάθε crash στη ρίζα του πρώτα, στόχος: κανένα παιχνίδι σε error)· ο χάρτης GT7 = C:\\shadps4-gt7\\GT7_upstream\\IMAGE_PROBLEMS_MAP.md"
metadata:
  node_type: memory
  type: project
  originSessionId: 0bdb4255-1ac0-4abb-9dd3-ea05165bd11b
  modified: 2026-10-02T22:57:38.973Z
---

**3 Οκτ 2026, ο χρήστης το γενίκευσε σε όλα:** «after we find why every crash would happen and fix the problem from the
root, we should focus on visual fixes since no game should fall under any error crash». Σειρά για ΟΛΑ τα παιχνίδια
(GT7, GoW, GoT, GTA V) και τον emulator γενικά: (1) για κάθε crash η αιτία του και fix στη ρίζα· (2) ΜΕΤΑ τα οπτικά.
Στόχος: κανένα παιχνίδι να μη σταματά σε error. Ρίζα = ο emulator χειρίζεται σωστά την περίπτωση, ΟΧΙ σβήσιμο του
assert (ένα assert που φεύγει απλώς κάνει το crash λάθος εικόνα). Οι γνωστές περιπτώσεις: [[shadps4-fix-candidates]].

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
