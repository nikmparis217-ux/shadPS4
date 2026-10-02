---
name: llvm-symbolizer-pdb-mismatch-silent
description: "Το llvm-symbolizer (native PDB reader) παίρνει ΣΙΩΠΗΛΑ λάθος pdb: ψάχνει δίπλα στο exe, μετά στο path που γράφει το exe, χωρίς έλεγχο GUID. Symbolize μόνο από φάκελο με exe + pdb δίπλα-δίπλα."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 0bdb4255-1ac0-4abb-9dd3-ea05165bd11b
  modified: 2026-09-27T14:01:15.934Z
---

27 Σεπ 2026, shadPS4. Το exe του TEST17d γράφει μέσα του το `C:\shadps4-clean\Build\x64-Clang-RelWithDebInfo\shadps4.pdb`.
Ο builder έχτισε το TEST18 στον ίδιο φάκελο στις 16:59. Μετά από αυτό, το ίδιο crash RIP (0x700000b0acc5, TEST17d r4) έδωσε:
- με exe + το δικό του pdb δίπλα-δίπλα: `ZydisInputPeek` (Decoder.c:260). Σωστό, και ταιριάζει με το r4.
- με `--obj=backup_exe\shadps4_test17d_6b999dac_gt7.exe`, χωρίς pdb δίπλα: `XXH3_64bits_digest` (xxhash.h:6695). Αυτή ήταν
  η απάντηση του pdb του TEST18, χωρίς error και χωρίς warning.

Άρα, μετρημένα, ο native reader κάνει δύο πράγματα:
1. ψάχνει πρώτα `<φάκελος exe>\<όνομα pdb>` και μετά το απόλυτο path του CodeView record·
2. ΔΕΝ συγκρίνει GUID/age.

**Why:** μια λάθος συνάρτηση μοιάζει απόλυτα αληθοφανής, με υπαρκτό όνομα, αρχείο και γραμμή, και στέλνει την ανάλυση σε λάθος
υποσύστημα. Κάθε νέο build στον ίδιο φάκελο ακυρώνει σιωπηλά το symbolize ΟΛΩΝ των παλιών runs.

**How to apply:**
1. Για κάθε exe που τρέχει, κράτα αντίγραφο exe + `shadps4.pdb` στον ΙΔΙΟ φάκελο (αρκούν hard links με `ln`) και δώσε
   `--obj=` εκεί.
2. Πριν εμπιστευτείς ένα αποτέλεσμα, έλεγξε ότι το SHA256 του pdb είναι αυτό του build του run.
3. Σε αμφιβολία, ένα γνωστό RIP πρέπει να δώσει τη γνωστή συνάρτηση.

Συγγενικά: [[gt7-shadps4-auditor-handoff]], [[feedback-metric-you-have-not-read]].
