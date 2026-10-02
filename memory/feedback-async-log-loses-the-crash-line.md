---
name: feedback-async-log-loses-the-crash-line
description: "Με async logging το «0 Critical» ΔΕΝ αποκλείει crash: η γραμμή του crash μένει στην ουρά και χάνεται στο ExitProcess. Διάβασε τους χρόνους των αρχείων που γράφει το shutdown και πιάσε τον κωδικό εξόδου με handle."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 0bdb4255-1ac0-4abb-9dd3-ea05165bd11b
  modified: 2026-09-27T18:08:39.079Z
---

27 Σεπ 2026, shadPS4 TEST17. Το run 5 έκλεισε σιωπηλά: 0 Critical, κανένα WER, κανένα nvlddmkm. Ο builder έγραψε ότι ίσως
ήταν «διαφορετική έξοδος» από το run 6, που είχε `Unhandled Exception code 0xc0000005`. Ήταν λάθος. Το run 5 είχε ΙΔΙΑ υπογραφή
αρχείων: flush των logs → +106 ms το `play_time.txt` → `imgui.ini` ανέγγιχτο. Έλειπαν επίσης ΚΑΙ οι γραμμές του ίδιου του
Shutdown, ενώ το `play_time.txt` αποδείκνυε ότι το Shutdown έτρεξε. Με `Log.sync=false` το `Log::Flush()` αδειάζει μόνο το file
sink. Ό,τι είναι ακόμα στην ουρά του async logger πεθαίνει μαζί με το worker thread στο ExitProcess.

**Why:** η απουσία μιας γραμμής αποδεικνύει κάτι μόνο αν ο μηχανισμός μπορούσε να την είχε γράψει. Τα τελευταία ~100 ms ενός
async log είναι τυφλό σημείο, και εκεί ακριβώς πέφτει η γραμμή του crash.
**How to apply:** σε σιωπηλή έξοδο:
1. διάβασε τους χρόνους των αρχείων που γράφει ΜΟΝΟ το shutdown, και βρες στον κώδικα ποιο μονοπάτι τα γράφει ([[gt7-shadps4-auditor-handoff]], (θ)). Το NTFS κρατά την ώρα της τελευταίας ΕΓΓΡΑΦΗΣ, όχι του κλεισίματος (μετρημένο).
2. πριν από κάθε run όπλισε catcher που κρατά handle στο process και γράφει τον κωδικό εξόδου. Το run 6 έδωσε 0xC0000005 σε 96 s, ενώ ο launcher του run 5 έχασε τον κωδικό μαζί με την κονσόλα.
3. ένα όργανο που πρέπει να επιβιώσει από crash γράφει ΣΥΓΧΡΟΝΑ, πριν από κάθε shutdown.

**27 Σεπ 21:1x — «ο τρόπος των lab tests» = ο κώδικας του branch `gt7-v0.18.0` (ο χρήστης το ζήτησε με όνομα):**
1938e61d drain της async ουράς σε ΚΑΘΕ έξοδο (Flush = flush + wait_all 3 s, Terminate πριν από quick_exit, VEH σε breakpoint)·
a6b85ea6 fsync του log ανά 1 s (LogSync thread)· 8c13b6ae death crumb (file-backed mapping που επιζεί και του __fastfail, το
επόμενο run γράφει `log/last_crumb.txt`)· 8c98e101 ο launcher κρατά/αποκωδικοποιεί το exit code (`logs\last_exit.txt`) + Shutdown
κάνει drain· VK_EXT_device_fault στο vk_instance.cpp («==== DEVICE FAULT», `device_fault.bin`)· post-run αναφορά στο
`GT7_work\run_gt7.ps1` (γρ. 498-604). Τα TEST19b/20 builds δεν έχουν ΤΙΠΟΤΑ από αυτά (pre-PR, χωρίς instruments). Upstream
default = `sync{true}` (emulator_settings.h:269), ενώ τα test profiles μας = `"sync": false` → εκεί χάνονται οι γραμμές· το
upstream `Flush()` κάνει flush τα sinks, ΟΧΙ drain της ουράς.

Συγγενικά: [[feedback-metric-you-have-not-read]], [[feedback-existence-is-not-visibility]].
