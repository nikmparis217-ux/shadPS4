---
name: gt7-shadps4-lane
description: "Το GT7/shadPS4 lane — ΑΠΟ 13 Σεπ 2026 δουλεύει πάνω στο upstream main (gt7-main + pr-* branches) με μόνιμα γενικά fixes, όχι stubs· πού ζουν τα handoffs, build/run πρωτόκολλο, headless qrenderdoc recipe· τα runs 250-274 (κίτρινο έδαφος/readbacks/whitewash) είναι ιστορία της παλιάς φάσης στο gt7-v0.18.0"
metadata:
  node_type: memory
  type: reference
  originSessionId: fea3dcca-edb7-4564-9821-abd29ed72fa8
  modified: 2026-10-02T22:54:48.874Z
---

Ξεχωριστό lane από το GT Nikos ΚΑΙ από το GT7→Blender (F:): ο **emulator shadPS4** στο
`C:\Users\Νίκος\Documents\GitHub\shadps4` (remote `mine`; `origin` = upstream shadps4-emu).
Στόχος: να τρέχει το GT7 (ταβάνι = Arcade Mode, το always-online δεν πατσάρεται).

**3 Οκτ ~01:40 — η διαδρομή ενός shader (χρήστης: «save everything we learned ... so we always know the correct
  order»):** ο χάρτης 22 βημάτων παιχνίδι → οθόνη με file:line στο main bf794b3f = memory `shadps4-gpu-path-map.md`
  (ανανέωση γραμμών: `builder_scripts\gpu_path_lines_v1.sh`, v2-v4). «144» = `signals.cpp:144` (ο τελευταίος exception
  handler): GT7 #5/#6/#11 = κώδικας του παιχνιδιού· GoT = nvoglv64.dll στο βήμα 15 (compute pipeline
  0x98170c4bfeeeaffe, cs 0x14906b6a)· GoW ΠΟΤΕ (device lost: buffer_cache.cpp:443 στο TEST2). Βήματα 1-5: το GT7 #3
  «PM4 type 0» είναι στον packet reader· ύποπτο: το `chain` bit του INDIRECT_BUFFER δεν διαβάζεται ποτέ
  (pm4_cmds.h:896, liverpool.cpp:794 / :928)· πρώτο μετά το reset (με το ok του χρήστη): [test] log στο σημείο του
  type 0. GoW: μόνο «SetQueueReg vqid 4 reg 0xb» (579), που το main προσπερνά. Opcodes (ερώτηση «over 20»): σε 302
  logs ΜΟΝΟ το DS_ORDERED_COUNT· 64-bit V_CMP: το main έχει 15 από 32, λείπουν 17, κανένα δεν το χτυπά παιχνίδι μας
  (το 69ac5fa9 της 6 Σεπ τα έχει και τα 32). Χρήστης: «we will make a regression test for this specifically» →
  17 γραμμές `case` + GPU tests στο `tests/gcn` του main (σχέδιο στο map, περιμένει ok + reset). PS4 Pro: τα 32 ίδια·
  το Neo προσθέτει 20 compares 16-bit, το main μεταφράζει 0. Χρήστης: προς το παρόν ΜΟΝΟ έρευνα, κανένα build· τα
  γνωστά υποψήφια fixes κρατιούνται ως γνώση, ΟΧΙ ως πλάνο: `shadps4-fix-candidates.md`.

⚠⚠⚠ **2 Οκτ ~21:45 — ΠΑΓΩΜΑ ΠΡΟΫΠΟΛΟΓΙΣΜΟΥ (χρήστης): μένει 10 % του εβδομαδιαίου ορίου, reset Κυρ 4 Οκτ 2026
  12:00. Ως τότε ΜΟΝΟ αλλαγές που ζητούν οι devs στα ανοιχτά PRs (#5218, #5155)· καμία νέα έρευνα, build ή test.** Τα
  ευρήματα του «Clamped size» + το σχέδιο: memory `shadps4-unbounded-vsharp-clamp.md` (συνέχεια μετά το reset).

⚠⚠⚠ **2 Οκτ ~21:35 — χρήστης: «i want a fix in its core» για το «Clamped size», όχι επιφανειακό. Έρευνα (μόνο
  ανάγνωση):** clamp = #2447 (Φεβ 2025, σκόπιμη λύση)· ERROR = #4782 (5 Σεπ 2026). GT7 (cached SPIR-V,
  `logs\vsharp_access_20261002.txt`): fs 0x74f5f10c διαβάζει εγγραφή 64 bytes X (0x840464a6: 128 bytes) όπου το X
  διαβάζεται από ΑΛΛΟ buffer με index από image fetch = αποφασίζεται στη GPU ανά pixel· Y = το δικό μας alignment
  adjust (buf_offsets). GoW cs 0x7463e726: index (x&3)*4+(y&3) → ≤ ~904 bytes. Άρα για το GT7 ούτε compiler ούτε host
  ξέρουν το εύρος πριν το draw: το bind ως το τέλος του mapping είναι η σωστή συντηρητική επιλογή του μοντέλου. DMA
  (BDA page table) υπάρχει μόνο opt-in (default false) για dynamic ReadConst, με διόρθωση μετά το submit. Αληθινά
  ελαττώματα: ERROR για νόμιμο V#· `GetSize()` u32 overflow (16×0x10000000 → 0 → null buffer). Κόστος ανά frame ΔΕΝ
  μετρήθηκε → πρόταση: log-only [test] μετρητής κόστους πρώτα, μετά επιλογή (μοντέλο μεγέθους ή BDA για unbounded).

⚠⚠⚠ **2 Οκτ ~21:25 — τι είναι το «Clamped size» (ερώτηση χρήστη):** ο shader φτιάχνει ΜΟΝΟΣ του το V# από pointer
  64-bit των user data με num_records = σταθερά 0xFFFFFFFF («χωρίς όριο»· στη GPU το num_records είναι μόνο bounds
  check), dword3 0x2000C004. Απόδειξη: IR του GoW cs 0x7463e726 + τα .meta (`builder_scripts\vsharp_scan_v1.py`,
  `logs\vsharp_unbounded_scan_20261002.txt`): GT7 fs 0x74f5f10c / 0x840464a6 / 0x5598df2e / 0x1416ac3d = flatbuf
  dwords 0-1, stride 0, read-only· GoW = dwords 2-3 + OR 0x100000 (stride 16 → 4294967280). Main: ClampRangeSize
  (≥1 GB) κόβει ως το τέλος του guest mapping → LOG_ERROR σε ΚΑΘΕ bind → ObtainBuffer όλου του εύρους (δεκάδες MB:
  resident + sync όλου). Το clamp σωστό, το ERROR θόρυβος· κόστος ανά frame ΔΕΝ μετρήθηκε.

⚠⚠⚠ **2 Οκτ ~21:15 — ερώτηση χρήστη: guards και για V#; Γίνεται, αλλά καμία μέτρηση δεν το ζητά.** Το pass του #5218
  μαζεύει ΜΟΝΟ image instructions (resource_guard_pass.cpp:614). Main ανά V#: address/size 0 → null ήδη· αλλιώς
  ClampRangeSize (≥1 GB: ASSERT «Attempted to access invalid address»), ObtainBuffer, invalidate αν γράφεται· stride /
  format / swizzle στο permutation key. Logs: το assert σε 0 από 343 logs (GT7 312, GoW 9, GoT 9, GTA V 13)· GT7 TEST40 r2
  1.605.678 «Clamped size» (+2.065.140 skipped) σε 786 shaders, ΟΛΑ «from 4294967295» (num_records 0xFFFFFFFF = σκόπιμο
  unbounded buffer, όχι σκουπίδι), ίδιο και με fix off (TEST37 r1)· GoW μόνο 4294967280 / 4294967216 (stride 16 × σχεδόν
  max, overflow u32) σε 6 shaders· permutations TEST40 r2 max 9 ανά shader (όχι έκρηξη). Άρα όχι στο #5218· αν ποτέ:
  πρώτα log-only [test] που μετρά V# πίσω από false συνθήκες, μετά ξεχωριστό PR. HANDOFF.md, update ~21:15.

⚠⚠⚠ **2 Οκτ ~21:05 — έλεγχος των 3 GoW fixes για PR (μόνο ανάγνωση): κανένα έτοιμο, όχι λόγω format.**
  clang-format 19.1.5 όπως το CI (ολόκληρα τα αλλαγμένα `src/*.cpp|h`, style `src/.clang-format`): 6 + 19 + 4 αρχεία
  καθαρά (rc 0, κανένα diff/trailing ws, LF)· έλεγχοι: τα ίδια αρχεία του main καθαρά, χαλασμένο αντίγραφο → rc 1· το
  «όλα flagged» της 1 Οκτ ήταν λάθος διαδρομή style. merge-tree στο bf794b3f: tg-size-sgpr ΧΩΡΙΣ conflict αλλά επειδή
  το 5→6 του = οι τιμές του main τώρα → rebase χωρίς bump· tg+ds conflict μόνο στο ShaderMetaVersion, tsharp μόνο στις
  γραμμές version → κάθε rebase θέλει main+1 με το χέρι. Το main έχει ακόμα όλα τα κενά (DS_ORDERED_COUNT χωρίς
  translator, κανένα `tg_size`, assert resource_discover_pass.cpp:257). Upstream: τίποτα νέο (#496 ανοιχτό, #2899
  κλειστό 2025)· τα named post-ops ήρθαν με το #4782 (5 Σεπ) = οι «other cases» του baggins183 στο #4999. Εμπόδια όπως
  στο gow-fixes-for-pr.md. Αρχείο: `C:\shadps4-gow\logs\gow_fixes_pr_check_20261002.txt`· scripts στο
  `C:\shadps4-gow\tools\`. Λεπτομέρειες: HANDOFF.md, update ~21:05.

⚠⚠⚠ **2 Οκτ ~20:55 — ο χρήστης: shadps4-lane-8f = ο νέος watcher/auditor.** Εξουσιοδοτημένο ζεύγος: builder
  shadps4-lane-f9 ↔ auditor shadps4-lane-8f, για τα δύο μηνύματα του builder (ειδοποίηση πριν από switch του checkout,
  details μετά από build). ListAgents 20:53: μόνο ο shadps4-lane-8f (οι gtnikos-e8 / gtnikos-02 έφυγαν). PRs και
  remotes αμετάβλητα από τις 18:37. Επόμενο: ο έλεγχος των GoW fixes (μόνο ανάγνωση).

⚠⚠⚠ **2 Οκτ ~18:40 — νέος builder shadps4-lane-f9 (αντί του gtnikos-02, ξεκίνησε στο `C:\shadps4-lane`)· έλεγχος μόνο
  ανάγνωσης, τίποτα δεν χτίστηκε / άλλαξε / ξεκίνησε.** origin/main = **bf794b3f** «started 0.19.1 WIP» (μόνο γραμμές
  έκδοσης). **#5218 head 9a6e7de8** = merge του bf794b3f από τον χρήστη (17:39:44, μόνο οι ίδιες γραμμές), 5 commits,
  mergeable clean, CI 4af30efb και 9a6e7de8 = 10 success + pre-release skipped· κανένα σχόλιο ή review μετά την απάντηση
  του χρήστη (13:45:40Z). Ο κώδικας του PR (v2 + μετακίνηση) δεν έχει τρέξει ποτέ σε παιχνίδι. #5155 head 302facf1 (+2
  GitHub merges), 1 αρχείο +1, 0 σχόλια, CI πράσινο. #5219 αμετάβλητο (be258106), τα 2 Linux builds ακόμα failure. Τοπικό
  `resource-guards` = 18dc8618, δύο merges πίσω από το `mine`. Κανένα shadps4, κανένα run μετά τις 14:32. ListAgents:
  gtnikos-e8 (busy), gtnikos-02 (idle), shadps4-lane-8f (νέο, όχι επιβεβαιωμένο ως auditor). Το main αγνοεί ακόμα το
  CHAIN bit του INDIRECT_BUFFER (liverpool.cpp:794 / :928) = το αδοκίμαστο lead της 24 Σεπ για το #3. Προτάσεις
  (περιμένουν τον χρήστη): HANDOFF.md, update ~18:40.

⚠⚠⚠ **2 Οκτ ~17:05 — ο raphaelthegreat άνοιξε δικό του PR #5219** «video_core: Renderer optimizations pt2 (texture cache edition)» (13:52 UTC, head be258106,
  11 commits, 27 αρχεία +871/−849, μόνο common + video_core). Read-only έλεγχος, ref `refs/pr/5219` στο clean (μόνο fetch). Για το #5196: ο βρόχος μας μεταφέρεται
  ΑΥΤΟΥΣΙΟΣ σε `ComputeImageSize` (tile.h), το GetArrayMode αυτούσιο στο tiling.h, το tiling.comp ίδιο· MipInfo pitch/height → u16. Για το #5218: κανένα κοινό αρχείο, merge-tree
  χωρίς conflicts· ⚠ στο νέο BindTextures το null path κρατά το `desc` του προηγούμενου bind στη θέση → ο τύπος descriptor του null slot = ό,τι δέθηκε
  τελευταίο εκεί (Storage μετά από storage image), ενώ στο main = πάντα eSampledImage· τα dead slots του #5218 περνούν από εκεί. SurfaceFormat →
  liverpool_to_vk.h, ίδιο assert/μήνυμα. #5218 head τώρα **4af30efb** (merge του main c7e065d1 0.19.0 από τον χρήστη 16:48), 4 commits, κανένα νέο σχόλιο·
  το τοπικό `resource-guards` μένει 18dc8618 (ένα merge πίσω). Λεπτομέρειες: HANDOFF.md, update ~17:05.
  ~17:15 οπτικά: καμία αλλαγή από τον κώδικα (layouts, formats, swizzles, κανόνες GC = ίδια αποτελέσματα με το main)· μόνο αποτυχίες θα φαίνονταν: per-image locks, τύπος null slot, και
  uint16_t στο UNIFORM buffer του tiling.comp χωρίς uniformAndStorageBuffer16BitAccess (ενεργό μόνο το storageBuffer16BitAccess).
  ~17:20 CI του #5219: FAIL τα 2 Linux builds (clang-19 + gcc-14, libstdc++, Release), στο build step (exit code 2)· περνούν macOS, τα C++ tests (ubuntu με libc++), clang-format· η γραμμή
  του error θέλει login («Sign in to view logs»). Το δικό μας CI: 18dc8618 success, 4af30efb σε εξέλιξη.
  ~17:40 ο χρήστης: κάθε md που γράφεται → και στο branch `claude` του `mine`, push αμέσως (γραμμή στο block
  του CLAUDE.md)· HANDOFF.md, αυτό το αρχείο (νέο εκεί), η σημείωση του branch και το shadPS4 τμήμα του
  CLAUDE.md, πάνω στο f498fe6e του auditor.
  ~18:10 ο χρήστης συμφώνησε: οι συνεδρίες του lane ξεκινούν στο `C:\shadps4-lane` (δικό του CLAUDE.md 7 KB αντί
  509 KB· memory = junction στο c--GTNikos, ίδια αρχεία)· λεπτομέρειες: shadps4-lane-folder.md.

⚠⚠⚠ **2 Οκτ ~16:45 — η αλλαγή του reviewer ΕΓΙΝΕ και ΣΠΡΩΧΤΗΚΕ: #5218 head 18dc8618, 3 commits** (χρήστης: «ok proceed
  as he asked»· νέο commit από πάνω, χωρίς force-push). 18dc8618 «shader_recompiler: Move the resource guards into a
  separate pass»: νέο `ir/passes/resource_guard_pass.cpp` (924 γραμμές) = ανάλυση + evaluator ΑΥΤΟΥΣΙΑ από το 16369d61
  + `ResourceGuardPass` (γράφει `resources[i].guards`)· οι 2 sharp helpers → resource_pass.h· το
  resource_patching_pass.cpp διαφέρει από το main ΜΟΝΟ κατά −44 (helpers) +3 (`.guard =`). Script
  `scratchpad\move_guard_pass.py` (ελέγχει κάθε όριο). clang-format 19 καθαρό, 0 CR, 0 GT_. Build 16:35:24-16:41:31,
  CMake ξανάτρεξε, 2383 βήματα, NINJA_EXIT=0, 0 warnings στο src, log `logs\pr5218_guardpass_build.log`. Push
  db68308b..18dc8618. ⚠ Το παλιό «όλα τα GoW αρχεία αφόρμαρτα» = ΔΙΚΟ ΜΟΥ λάθος μεθόδου (το style είναι
  `src/.clang-format`)· να ξαναγίνει με `--dry-run --Werror` στα αληθινά αρχεία.

⚠⚠⚠ **2 Οκτ ~16:23 — ΑΝΟΙΧΤΟ PR #5218** «shader_recompiler: Skip images and samplers behind untaken branches» (ο
  χρήστης, 13:11:33 UTC, head db68308b, 2 commits, δικό του κείμενο). **1ο σχόλιο** raphaelthegreat (13:19:59 UTC):
  «Firstly can you move all the resource guard pass into a separate pass/different cpp at least so it doesnt clutter
  resource patching». Γεγονότα: στο 16369d61 το resource_patching_pass.cpp 955 → 1879 γραμμές· ανάλυση = γρ. 940-1574,
  per-draw evaluator (EvaluateDead) = γρ. 1608-1879· είναι εκεί ΜΟΝΟ λόγω του κανόνα «χωρίς νέα αρχεία» των test builds
  (νέο αρχείο = CMake re-run)· το σχέδιο 30 Σεπ το είχε ξεχωριστό pass πριν το ResourcePatchingPass. Η μετακίνηση θέλει
  το ok του χρήστη (CMake re-run, switch με ειδοποίηση στον e8, compile check, push που αλλάζει αμέσως το #5218). Τα GoW
  fixes (χρήστης: «now for the GOW fixes») σε παύση λόγω PR: κανένα έτοιμο ως έχει· clang-format έλεγχος = ύποπτος
  (έβγαλε ΟΛΑ τα αρχεία), να ξαναγίνει.

⚠⚠⚠ **2 Οκτ ~15:22 — `mine/resource-guards` = db68308b, ΟΧΙ 16369d61:** GitHub merge «Merge branch
  'shadps4-emu:main' into resource-guards» (γονείς 16369d61 + main 3912336f, 15:19:58 από τον λογαριασμό του χρήστη).
  Ελεγμένο: tree = `git merge-tree` των δύο, diff έναντι 3912336f ίδιο patch-id με το 7e778987..16369d61 (c92647a1...),
  11 αρχεία +1083/-16 → το merge φέρνει μόνο το main. Ο χρήστης ανοίγει το PR (δεν υπάρχει ακόμα)· με 2 commits το
  GitHub προτείνει τίτλο το όνομα του branch· δόθηκε ο τίτλος του commit. Προσφέρθηκε, δεν έγινε: rebase στο 3912336f
  + force-push για ΕΝΑ commit (μόνο με το ok του, πριν ανοίξει το PR). **Χρήστης ~16:09: μένουν τα 2 commits** («it is
  an experiment anyway»)· η περιγραφή του PR = κείμενο του χρήστη (έλεγχος μόνο για γεγονότα/typos)· PR ακόμα κανένα.

⚠⚠⚠ **2 Οκτ ~15:05 — το fix μένει ΕΝΑ commit / ΕΝΑ PR** (χρήστης: «ok so we keep it a whole»)· δόθηκε στο chat απλή
  εξήγηση του fix για το δικό του κείμενο στο PR· τίποτα δεν χτίστηκε, άλλαξε, σπρώχτηκε ή ξεκίνησε. Πριν, στο «σε
  κομμάτια;» (read-only): ο μηχανισμός (συνθήκες στο compile, αποτίμηση ανά draw, null στο GetSharp, dead set στο
  permutation key, cache version) δουλεύει μόνο ολόκληρος· κόψιμο ανά οικογένεια συνθηκών (μηχανισμός + integer ~790
  γραμμές, lane masks ~75, float ~220) θα δούλευε κομμάτι-κομμάτι (unknown = live, μονότονη λογική), αλλά το 1ο μένει
  το μεγαλύτερο. Ο χρήστης θα γράψει στο review ότι είναι πειραματικό. Αριθμοί της εξήγησης (audits του e8): fs
  0x2a265dff off (TEST37 r1-r4) 24-39 compiles/run, T#/S# rejections 18-65 / 74-283, 3 από 4 έληξαν στο SurfaceFormat /
  ComponentSwizzle assert στο image #0 του· on (TEST39 r1-r2, TEST40 r1-r2) 1 compile, 0 / 0, κανένα τέτοιο assert, και
  τα 4 έφτασαν σε αγώνα· GT_GUARDCHECK 0 HIT (GT7 2 runs, GoW 2, GoT 3, GTA V χωρίς shaders με guards).

⚠⚠⚠ **2 Οκτ ~14:05 — «ok do all steps»: 4 builds, 8 launchers, push· ΚΑΝΕΝΑ launch.** Κανένα shadps4 στα builds
  (τελευταίο run GTA V r5, τέλος 13:17:22)· ο gtnikos-e8 πήρε ειδοποίηση πριν το πρώτο switch + details μετά από κάθε
  build. (1) **16369d61 χτίζεται πάνω στο 7e778987** (214 βήματα, 0 warnings, χωρίς CMake, κανένα exe) και
  **σπρώχτηκε**: `mine/resource-guards` 4e06ba5b → 16369d61 (forced), κανένα PR. origin/main = 3912336f (+5 commits:
  #5186 #5182 #5212 #5208 #5214), κανένα στα 11 αρχεία του fix, merge-tree καθαρό. #5155 head 5d55be06 (νέο «Update
  branch»), 0 reviews. (2) Το [test] commit πήρε amend: το πρώτο build του TEST40 έδωσε 2 warnings (-Wunused-result,
  `ir.BufferAtomicOr` [[nodiscard]]) → `static_cast<void>(...)` (+4 −3, ίδια συμπεριφορά). Νέα hashes: **GT7 TEST40
  07a74022**, **GoW TEST2 6b19950f**, **GoT/GTA V TEST2 e8a9f602** (patch-id bdda5971 και στις δύο γραμμές TEST1).
  (3) Builds 0 warnings: TEST40 3 βήματα μετά το amend, GoW 109, GoT/GTA V 106· exes + pdb dirs στα backup_exe κάθε
  φακέλου (TEST40 44C88540…, GoW E3D6193A…, GoT/GTA V AB67D366…). (4) Launchers με ακριβείς αντικαταστάσεις
  (`builder_scripts\make_test40_launchers.pl`, `make_test2_launchers.pl`): `TEST40_GT7_07a74022_guardcheck_diag_console.bat`
  (=1) + `..._guardcheck_canary_diag_console.bat` (=2) από τον TEST39· `<GAME>_TEST2_<hash>_guardcheck_console.bat` +
  `..._guardcheck_canary_console.bat` από κάθε TEST1 fixon. Λεπτομέρειες: `logs\test40_build_details.txt`, τα README
  των φακέλων. (5) Τι έχει να ελέγξει: GoW TEST1 r2 106 shaders με guards (81 με dead set)· GoT r2 5 (4)· **GTA V r3/r4
  0 shaders με guards** ως το assert του hull shader → ένα GTA V check run δείχνει μόνο τη γραμμή εκκίνησης.
  Επόμενο: τα runs του χρήστη, canary (=2) πρώτα· `guardcheck HIT` = λάθος «dead».

⚠⚠⚠ **2 Οκτ ~13:40 — «all 3»: γραμμένα, ΟΧΙ build, ΟΧΙ push** (plumbing· checkout ανέγγιχτο). (A) PR commit v2
  **16369d61** (main 7e778987, ίδιος τίτλος, 0 GT_): FAbs = float-op αποτέλεσμα· setting `resource_guards_enabled`
  (default true, per-game)· `SkipResourceGuards()` = setting off Ή shader_collect Ή patch· το skip στο InfoPersistent,
  meta με άλλη απόφαση απορρίπτεται. Τοπικό `resource-guards` = 16369d61, το `mine` ακόμα 4e06ba5b. (B) GT_GUARDCHECK
  [test] commit: GT7 **TEST40 6ccc1abc**, GoW **TEST2 1cb4c9b2**, GoT/GTA V **TEST2 d4da0296** (ίδιες γραμμές):
  atomic OR στο block κάθε νεκρής χρήσης → buffer → `guardcheck HIT` στο log· =2 canary· χωρίς pipeline cache.
  Επόμενο, με εντολή χρήστη: 4 builds, launchers, push.

⚠⚠⚠ **2 Οκτ ~13:00 — έλεγχος του 4e06ba5b (μόνο ανάγνωση) για λάθος «dead»** (χρήστης: «could we do anything
  with the possible risk?»). Κανένα build/run/push. Λάθος απόφαση θέλει λάθος δεδομένα, λάθος συνθήκη ή λάθος
  αριθμητική· τίποτα από τα τρία: τα δύο φύλλα (GetUserData, flattened ReadConst) διαβάζουν το flat buffer στο
  SPIR-V με DMA ή χωρίς· dead set και buffer που ανεβαίνει = ίδιο `program->info`, refresh σε κάθε draw· το pass
  τρέχει πριν το structurization, 1 IR block ανά CFG block, `branch_cond` = η συνθήκη του ίδιου του block· κάθε
  exec scope έχει ακμή που το παρακάμπτει· το InverseBallot διαβάζει μόνο το δικό του bit, άρα οι μάσκες είναι
  ακριβείς ανά lane· τα undefined του SPIR-V δίνουν Unknown. Γωνίες: (a) FAbs(-0.0) bits (GLSL.std.450 «x if
  x >= 0»), μόνο μέσω bitcast· (b) το ReplaceShader (shader editor) κρατά τα guards, ενώ το plan έλεγε όχι·
  (c) το #5155 αλλάζει το `flattened_ud_buf` χωρίς RefreshResourceGuards: καμία επίδραση σήμερα, αλλά όποιο PR
  μπει δεύτερο κάνει refresh. Χειρότερη περίπτωση: μηδενικά από εκείνο το slot (pixel: μαύρη/διάφανη υφή·
  compute/vertex: μηδενικά σε ό,τι υπολογίζει). Πρόταση, ΔΕΝ ξεκίνησε: GT_* έλεγχος στη GPU (bit σε buffer όταν
  διαβάζεται νεκρό slot· τρέχει μόνο αν η απόφαση είναι λάθος· FPS μη συγκρίσιμα). Περιμένει τον χρήστη.

⚠⚠⚠ **2 Οκτ ~02:45 — το resource-guard fix ως ΕΝΑ commit στο fork: branch `resource-guards` = 4e06ba5b** (εντολή
  χρήστη: «a commit of a different branch on our latest fix with the 1000+ line code ... on OUR fork not origin»).
  Τίτλος μόνο: «shader_recompiler: Skip images and samplers behind untaken branches», parent main 7e778987, χωρίς
  trailer. Περιεχόμενο = ebcfc8a2 + 9bc582bb (TEST38/TEST39) = c8408b45 + 2d7c711e (TEST1): ίδιο patch-id 67b0b53b·
  ΧΩΡΙΣ τα [test] commits (guardlog, GT_GUARDLOG/GT_NOGUARDS), 0 γραμμές GT_· 9 αρχεία +1068 −15· cache 7/7 (main
  6/6). `git merge-tree` καθαρό + commit-tree → checkout ανέγγιχτο· clang-format/whitespace/CR καθαρά. ΔΕΝ έχει
  γίνει compile πάνω στο 7e778987 (ίδιος κώδικας χτίστηκε σε 2338a06f και d9cf41ba). Νέο branch στο `mine`, κανένα PR,
  τίποτα στο origin. Ανοιχτό για PR: κριτήριο (2) δεν έχει δειχθεί + μόνο 2 runs GT7 με το pass.

⚠⚠⚠ **2 Οκτ ~01:35 — καθαρισμός μετά το merge του #5196** (χρήστης: «delete all unecesery stuff we dont need
  anymore»· για τα υπόλοιπα: «none other»). Σβήστηκαν: τοπικό `tiled-mip-layout` + tag `pr5196-before-numslices`,
  stale refs `mine/tiled-mip-layout` / `mine/user-data-flatbuf-fallback`, stale worktree `C:/shadps4-pr5126`· στο
  `bc_checker` όλα τα PR before/after (pre_*/lt/t36 variants, run5-run15, gpu_main/gpu_fixed/gpu_run, main_src,
  gpu_obj, pr_evidence) → οι αναφορές σε run14/run15/pr_evidence είναι πλέον ιστορία· ΜΕΝΟΥΝ `bc_checker.cpp/.exe`
  (= το πρώην t36) + build.bat + stub, `tiling_gpu_test.cpp/.exe` + build_gpu_test.bat· το `bash-edit-diff` (9,9 GB).
  ΔΕΝ σβήστηκαν (όχι από τον χρήστη): exes TEST3/19/29-38, logs πριν τις 24 Σεπ, exes gow1-3.

⚠⚠⚠ **2 Οκτ ~01:20 — PR #5196 MERGED.** CI στο 43db7964: 10 πράσινα + pre-release skipped. Ο χρήστης απάντησε «on it»
  στο νήμα num_slices (22:01 UTC)· raphaelthegreat APPROVED το 43db7964 (22:16:12 UTC) και το έκανε merge 6 s μετά
  (squash): upstream main = **7e778987** «video_core: Fix mip layout and detiling of tiled textures (#5196)», parent
  fecfbed0, author nikmparis217-ux, **tree ae943cc8 = ίδιο με του 43db7964**. Τοπικό origin/main = 7e778987. Συνέπειες:
  επόμενη test γραμμή πάνω σε main ≥ 7e778987 ΧΩΡΙΣ τα commits του PR (οι στοίβες TEST1/TEST39 έχουν την παλιά έκδοση·
  νικά η σειρά του main)· η «main» εκδοχή του `TilingInfoHost` στο GPU test ισχύει μόνο για main ΠΡΙΝ το 7e778987.
  Ανοιχτό PR μας μένει ΜΟΝΟ το **#5155** (preload permutation user data, head 584cc21c, 0 σχόλια).

⚠⚠⚠ **2 Οκτ ~01:05 — #5196: η αλλαγή num_slices ΕΓΙΝΕ και ΣΤΑΛΘΗΚΕ με force-push (εντολή χρήστη: «ok make the change
  and force push it» + «remembre only ghat one line he asked»).** Head **43db7964** = ΕΝΑ commit πάνω στο fecfbed0 (ήταν
  ee17897f = 4697d56c + 2 merges), ίδιο μήνυμα (μόνο τίτλος), ίδιος author + author date, χωρίς trailer. Tree = του
  ee17897f + ΜΟΝΟ η αλλαγή: το `micro_tiled_mips` παίρνει τη θέση του αχρησιμοποίητου `num_slices` στο `TilingInfo` του
  tile_manager.cpp ΚΑΙ του tiling.comp, και οι 2 γραμμές `params.num_slices = ...` έγιναν `params.micro_tiled_mips = ...`
  (σειρά bank_swizzle, micro_tiled_mips, num_mips, mips = 268 B όπως το main)· έναντι main 4 αντικατεστημένες γραμμές.
  Έλεγχοι πριν το push: diff μόνο στα 2 αρχεία (+4 −8), κανένα CR, κανένα trailing whitespace, clang-format καθαρό.
  Με git plumbing (temp index + commit-tree) → το checkout του `C:\shadps4-clean` ΔΕΝ άλλαξε· κανένα τοπικό build (το CI
  χτίζει). `--force-with-lease` στο ee17897f. Τοπικό `tiled-mip-layout` = 43db7964· παλιό head = τοπικό tag
  `pr5196-before-numslices`. ⚠ Το `tiling_gpu_test.cpp` (`TilingInfoHost`) έχει ακόμα την ΠΑΛΙΑ διάταξη 272 B: θέλει τη
  νέα σειρά πριν ξαναχτιστεί πάνω σε build με το tiling.comp του 43db7964. Οι test γραμμές κρατούν την παλιά έκδοση του
  PR (το num_slices δεν διαβαζόταν ποτέ → ίδια συμπεριφορά).

⚠⚠⚠ **2 Οκτ ~00:55 — #5196: 2 νέα σχόλια raphaelthegreat, το ένα ζητά αλλαγή κώδικα· τίποτα δεν άλλαξε / χτίστηκε /
  στάλθηκε.** (1) 21:41 UTC, στο νήμα 128 bpp: «ciaddrlib from what I saw fallbacks to micro tiling, so i guess this is
  fine». Γεγονός: το `ciaddrlib.cpp:1267-1272` αλλάζει τον ΤΥΠΟ micro tile (display → non-display = thin), όχι το array
  mode· η μόνη πτώση σε 1D_TILED_THIN1 στο ciaddrlib (`:736`) είναι depth/stencil. (2) 21:48 UTC, νέο νήμα στο
  `tile_manager.cpp` γρ. 35: «Can you replace num_slices here since its unused». Γεγονότα: το `TilingInfo::num_slices`
  γράφεται στο `tile_manager.cpp:205` / `:295`, δηλώνεται στο `tiling.comp:104`, ο shader ΔΕΝ το διαβάζει ποτέ (ούτε στο
  main, από το #3374 d9108cd3)· block `scalar` → C++ και GLSL ίδια σειρά πεδίων· 272 B με το PR, 268 B χωρίς (= main)·
  αγγίζει tile_manager.cpp:33/205/295 + tiling.comp:104· το τοπικό GPU test έχει δικό του αντίγραφο (`TilingInfoHost`,
  static_assert) που θέλει την ίδια αλλαγή. Αλλαγή = νέο commit πάνω στο mine/tiled-mip-layout (ee17897f) ή amend +
  force-push· το τοπικό `tiled-mip-layout` = 4697d56c.

⚠⚠⚠ **2 Οκτ ~00:30 — #5196: ΠΡΩΤΟ review σχόλιο (ερώτηση) + αναφορά δοκιμής· καμία αλλαγή κώδικα.** squidbus (20:40
  UTC): Sonic Colors Ultimate μπαίνει in-game με σωστά textures «aside from some bugged UI elements». raphaelthegreat
  (20:43 UTC, inline στο `tiling.comp` γρ. 161): «Why was this changed?» = η σειρά 128 bpp στο DISPLAY micro tile
  (`y0,x0,x1,x2,y1,y2` → `x0,y0,x1,y1,x2,y2`). Γεγονότα στον χρήστη (όχι έτοιμο κείμενο): παλιά = `addrlib1.cpp:3070-3076`
  (ADDR_DISPLAYABLE case 128), νέα = `:3083-3090` (ADDR_NON_DISPLAYABLE)· SI/CI το επιβάλλουν: `siaddrlib.cpp:1952-1957`,
  `ciaddrlib.cpp:1267-1272` «128 bpp tiling must be non-displayable»· GPCS4: `computeSurfaceTileMode` → Thin για 128 bpp,
  κανένας Display 128 bpp tiler. Μέτρηση: checker μόνο με την παλιά σειρά (`run15`) 30/333 λάθος, όλα 128 bpp Display2DThin /
  Display2DThinPrt / DisplayThinPrt· με την αλλαγή (`run14`) 0· GPU test: 70 περιπτώσεις 128 bpp display, main 70 λάθος, fix 0.
  Head ee17897f (2ο «Update branch» 15:39 UTC), καθαρό diff έναντι main fecfbed0 = το 4697d56c· CI 10 πράσινα. Το τοπικό
  `tiled-mip-layout` μένει 4697d56c (πίσω από το `mine` κατά 2 merges). **00:32 ο χρήστης απάντησε** (reply 4160704815):
  checker 30/333 + οι 2 γραμμές HwlSetupTileInfo + το path του addrlib. Έλεγχος: το pin του upstream (kosmickrisp bac93e02
  → mesa 063dfaee) έχει siaddrlib/ciaddrlib/addrlib1 ΙΔΙΑ με το δικό μας checkout → οι γραμμές πέφτουν σωστά και upstream·
  μόνη ανακρίβεια «333 checkers» = 333 περιπτώσεις ΕΝΟΣ checker.

⚠⚠⚠ **1 Οκτ ~16:20 — GoW TEST1 ΞΑΝΑΧΤΙΣΜΕΝΟ ΜΕ τα 3 GoW fixes = 1c6cff84 (χτισμένο, όχι τρεγμένο).** Χρήστης
  (16:05): «you are right that was my mistake. delete the old prob and make a new including our gow fixes». Σβήστηκαν
  από το `C:\shadps4-gow` το exe 7d09a8a8, ο φάκελος pdb και οι 2 launchers GOW_TEST1_7d09a8a8 (κανένα run· τα
  αντίγραφα GoT/GTA V ίδια byte-byte, μένουν). `gow-test1-main-d9cf41ba` 7d09a8a8 → 1c6cff84 με cherry-pick:
  f6258522 = tg-size-sgpr b89a2772, 0a8c27c2 = ds-ordered-count a1af1159, 1c6cff84 = tsharp-dw1-mask dc08b752· κάθε
  pick ίδιες +/- γραμμές με την πηγή. Conflicts ΜΟΝΟ στις εκδόσεις cache (B8/M10· main d9cf41ba ήδη 6/6, 7d09a8a8
  7/7) και στη σειρά μελών/initializers του ImageResource (post_op_dw1_mask, μετά guard). Τα guard groups κλειδώνουν
  στο ίδιο `sharps[0]` που το discover pass έχει ήδη ξε-μασκάρει → masked T# = ίδια ομάδα με το ImageResource του.
  Build `ninja -k 0` 106 βήματα, 55 s, 0 errors / 0 warnings (`C:\shadps4-gow\logs\gow_test1_build.log`)· exe
  B142D73C…E07E, 62.605.824 B (strings BufferOrderedCount/GdsOrderedSignal μέσα, όχι στο 7d09a8a8)· launchers
  `GOW_TEST1_1c6cff84_{fixon,fixoff}_console.bat` = ίδιο σώμα με τους σβησμένους, GoW fixes αναμμένα και στους δύο.
  Προφίλ: config.json ≠ GOW3 ΜΟΝΟ στο patch_shaders (GOW3 true). Αναμονή = GOW3: ~320 shaders, Sony splash, μετά
  nvlddmkm 153 → «Device lost during submit». GoT/GTA V TEST1 μένουν 7d09a8a8 (χωρίς GoW fixes). Base main μένει
  d9cf41ba (origin/main τώρα dd43d1ca: #5203, #5194 — δεν μπήκαν). Ειδοποίηση + build details στον gtnikos-e8.

⚠⚠⚠ **1 Οκτ ~08:55 — Η δουλειά ΧΩΡΙΖΕΤΑΙ ΑΝΑ ΠΑΙΧΝΙΔΙ· TEST1 για GoW / GoT / GTA V χτισμένο (όχι τρεγμένο).**
  Φάκελοι: `C:\shadps4-gow`, `C:\shadps4-got`, `C:\shadps4-gtav` (README.md, launchers fixon/fixoff, backup_exe,
  logs, `tools\runsummary.awk`, προφίλ user\ με patch_shaders false)· GT7 μένει `C:\shadps4-gt7\GT7_upstream`. Τα
  σκόρπια shadPS4 του C: στο `C:\shadps4-archive` (README.md: τι, από πού)· έμειναν shadps4-gt7, shadps4-clean,
  test19-gt7 + test4-gt7 (προφίλ + save A του TEST39), Documents\GitHub\shadPS4, ο φάκελος παιχνιδιών στο Desktop.
  Worktrees sync/wt35 μεταφέρθηκαν με `git worktree repair` (+ 54 submodule links του sync, status ίδιο). TEST1 =
  gow-/got-/gtav-test1-main-d9cf41ba = 7d09a8a8 (main d9cf41ba + στοίβα TEST39 χωρίς T# check / SnormNz + GT_GUARDLOG,
  GT_NOGUARDS = baseline ίδιο exe, `[GT_DIAG] tools:`), exe 2037E104…, ένα αντίγραφο ανά παιχνίδι. GoW αναμένεται να
  σταματήσει ~50 shaders μέσα σε DS_ORDERED_COUNT (λείπει από το main)· τα 3 GoW branches ΔΕΝ μπήκαν — αποφασίζει ο
  χρήστης. Ανοιχτά PR: #5196 ΚΑΙ #5155 (preload), 0 reviews· στις 04:45 UTC «Update branch» merge και στα δύο από τον
  λογαριασμό του χρήστη → τα τοπικά branches πίσω, ποτέ push χωρίς το merge.

⚠⚠⚠ **1 Οκτ ~07:50 — Πίνακας πριν/μετά για τον χρήστη (σβηστό = TEST37 r1-r4, αναμμένο = TEST39 r1-r2).** Με τα
  «Skipped N» (`builder_scripts\beforeafter.awk`, `logs\test39_beforeafter_counts.txt`): rejections T#/S# 18-65 /
  74-283 → 0/0· οι παραλλαγές του fs 0x2a265dff = 18-29 % όλων των permutations κάθε run του TEST37, η καθεμία με
  νέο graphics pipeline (38/38 στο r4)· οι παραλλαγές των ΑΛΛΩΝ shaders ανά shader ίδιες (0,18-0,24 με ή χωρίς fix)·
  «Unimplemented clamp mode» 57-179 (modes 4/5/7) → 9 (μόνο mode 4)· καμία νέα υπογραφή Warning/Error (οι 3 «νέες»
  = ίδια μηνύματα του main σε μετακινημένες γραμμές), 22 έφυγαν (SurfaceFormat, ComponentSwizzle, ClampMode :321,
  rejections). Γενικό όφελος = ο κανόνας του hardware: ένας descriptor μετράει μόνο αν το draw μπορεί να τον διαβάσει.

⚠⚠⚠ **1 Οκτ ~07:00 — FPS μετρημένο από το log: καμία αλλαγή που να χρεώνεται στο fix.** Χρήστης: «το fix είχε
  μόνο επίπτωση στα fps, λίγο χαμηλότερα». Ρολόι = `netctl.cpp:99` (~61,2 Hz), frames = `gamelivestreaming.cpp:70`
  (+ «Skipped N»), ανά σκηνή και σε κάδους 2 s (`builder_scripts\fpsseg.awk`, `fpsbuck.awk`, `racemix.awk`). Μενού /
  φόρτωση ίδια σε TEST35-39· η αρχή του αγώνα 2-4 fps σε ΟΛΑ τα builds (255-619 pipelines, cache κρύα κάθε run).
  Αγώνας σε ήσυχους κάδους (κανένα compile σε αυτόν και στον προηγούμενο): TEST39 r2 19,9, TEST35 r7 17,9, TEST34 r5
  25,9, TEST32 r5 27,4 / r6 22,4 — runs του ίδιου build διαφέρουν όσο και τα builds. Γραμμές log/frame ίδιες (~600,
  ~550 το `BindBuffers: Clamped size` του main). Το fix: μία αποτίμηση πίνακα ανά stage ανά GetProgram· το TEST39 μία
  ακόμα (GT_DIAG) + σάρωση της λίστας bindlog για 2 shaders. Το TEST38 = το fix χωρίς τα logs του TEST39.

⚠⚠⚠ **1 Οκτ ~01:03 — Review του auditor για TEST39 r1+r2 (μήνυμα gtnikos-e8 με εντολή χρήστη) = ίδια ευρήματα.**
  Προσθέτει: r1 267 s EXIT 0x80000003, 51,7 s μετά το resume της πρώτης παύσης· r2 405 s EXIT 0xC0000005, 10,18 s
  αγώνα μετά από restart· 0 «(recomputed»· dumps = TEST34 r1, bindlog 0x74f5f10c = TEST36 r1· μόνο νέο το
  `liverpool.cpp:60` NextPacket του main (4810 dwords, 4 έμειναν) μία φορά στο r2 (και στα test32_6, test33_4, ποτέ
  σε run κλάσης 3)· το «image N of M» του bindlog είναι 0-based (ελέγχθηκε στον κώδικα). CRASH_MAP «Suggested order
  0 = more TEST39 runs» — ο χρήστης είπε ~00:50 όχι άλλο run. Καμία απάντηση στον auditor (όχι εγκεκριμένο μήνυμα).

⚠⚠⚠ **1 Οκτ ~00:57 — TEST39 r1+r2 έναντι TEST37 r1-r4 (ίδιος κώδικας, fix σβηστό): το fix ΕΛΥΣΕ την κλάση 13.**
  Χρήστης ~00:50: «im not doing another run» (είπε «3 runs», υπάρχουν 2· TEST38 0 runs). r2 00:41:08-00:47:54 τέλος
  κλάση 6: `signals.cpp:144` 0xC0000005 στο eboot(0xbb40000)+0x18eaf37, WorkT, 11,3 s μετά από start request. Σβηστό
  / αναμμένο: SurfaceFormat/ComponentSwizzle στο image #0 του fs 0x2a265dff 3/4 (1-2' στα Buddy/TopRoot) / 0/2 (και τα
  δύο έτρεξαν αγώνα, guardlog dead σε ΚΑΘΕ bind)· compiles 24-39 / 1· rejections T#/S# 18-63/74-281 / 0/0 — και τα 16
  παλιά runs που έφτασαν αγώνα (TEST30-37) είχαν 45-384/169-1277. Κλάσεις 2/4/7: 0 και στις δύο ομάδες = αναπόφαστο.
  Ερώτηση χρήστη για τον «διακόπτη»: `patch_shaders` true σε όλα τα 6 test προφίλ = κατάλοιπο default (TRUE από #1633
  30 Νοε 2024 ως #3181 6 Ιουλ 2025, τα παλιά configs το κρατούν)· το gate του TEST37 έσβηνε το fix για ΚΑΘΕ παιχνίδι
  με την επιλογή ανοιχτή (= main, χωρίς ζημιά)· το HasShaderPatch του TEST38 το διορθώνει και μπαίνει στο PR. Άλλο
  παιχνίδι στο TEST38/39: ΔΕΝ μετρήθηκε (κριτήριο 2 του PR).

⚠⚠⚠ **1 Οκτ ~00:46 — TEST39 r1: το fix ΕΤΡΕΞΕ και έκανε ό,τι έλεγε το σχέδιο· τέλος = κλάση 3 (παλιά).** r1
  00:36:27-00:40:53 (`shad_log_test39_gt7_1_at_exit_004102.txt`), pad OK, έφτασε αγώνα. Τέλος `liverpool.cpp:249`
  «Unimplemented PM4 type 0» ~47 s μετά τη γραμμή εκκίνησης (CRASH_MAP κλάση 3, 13 runs από test15_3· εκτός draw,
  τελευταίο fs 0x9c23f9ea / vs 0x8167a22c). Έναντι TEST36 r1: fs 0x2a265dff **1** compile (39), `Rejecting invalid
  T#` **0** (123), `S#` **0** (458), 0 SurfaceFormat / Thick3DThickPrt_32 / GetArrayMode· permutations 258 (270, όχι
  ≤232: 252 προγράμματα που το TEST36 r1 δεν έφτασε)· στα 1010 κοινά προγράμματα +37 σε 32 με +1/+2 = ο θόρυβος
  δύο runs ίδιου build (TEST35 r1/r3). Guardlog ΜΙΑ γραμμή όλο το run: 0x2a265dff «conds F, dead 0x7, [50]=0x0,
  images #0 #1 dead, #2 -, samplers #0 dead» (= πρόβλεψη)· 0x74f5f10c dead 0x0 (#1 live?, #6-#9 live). Εικόνα ίδια
  (χρήστης ~00:44, run 2: «exactly the same as before») — ΣΩΣΤΟ: dead slot = ό,τι το draw δεν διαβάζει. Μαύρος δρόμος /
  έδαφος + κόκκινος χάρτης = IMAGE_PROBLEMS_MAP γραμμές 1 και 3 (readbacksMode 0), παρκαρισμένα. Run 2 από 00:41:10.
  #5196: 0 σχόλια, 0 reviews.

⚠⚠⚠ **1 Οκτ ~00:36 — TEST39 ΧΤΙΣΜΕΝΟ = TEST38 + [test] log αποφάσεων guard, κανένα run ακόμα.** Αίτημα auditor
  (μέσω χρήστη ~00:28) + «use the same prob[e]» = GT_BINDLOG. `test39-main-2338a06f` **0247e2e9**: `GtEvaluate`,
  γραμμές `[GT_DIAG] guardlog` (conds F/T/?, όροι groups, dead mask, dwords που διαβάζει, κάθε image/sampler
  -/dead/live/live?) στο πρώτο bind και σε κάθε αλλαγή, ≤512/shader· η σημείωση GT_DIAG του image στο texture binding
  λέει την κατάσταση guard· bindlog cap 256 ΑΝΑ shader. Launcher `TEST39_GT7_0247e2e9_warm_diag_console.bat`
  (GT_BINDLOG=0x74f5f10c,0x2a265dff), exe AE4EADE5, `logs\test39_build_details.txt`. TEST37 r2 = ίδιο τέλος με r1.
  PR = ebcfc8a2 + 9bc582bb μόνο.

⚠⚠⚠ **1 Οκτ ~00:23 — TEST38 ΧΤΙΣΜΕΝΟ (εντολή ~00:17 «do the suggested»), κανένα run ακόμα.**
  `test38-main-2338a06f` **9bc582bb** = TEST37 + «vk_pipeline_cache: Skip resource guards only for shaders that have a
  patch»: `Info::skip_resource_guards` = `IsPatchShaders() && HasShaderPatch()` (οποιοδήποτε `<stage>_<hash>_*.spv`
  στο `user\shader\patch`) → στο προφίλ GT7 η ανάλυση τρέχει ΠΡΩΤΗ φορά. clang-format 19: 0. Build 40 s, NINJA_EXIT=0.
  Exe 16A7A96D, launcher `TEST38_GT7_9bc582bb_warm_diag_console.bat`, `logs\test38_build_details.txt`· auditor
  ειδοποιήθηκε πριν (~00:19) και μετά (~00:22).

⚠⚠⚠ **1 Οκτ ~00:12 — Το fix του TEST37 είναι ΣΒΗΣΤΟ στο προφίλ GT7: τα runs ΔΕΝ το δοκιμάζουν.** Το
  `FindResourceGuards` (resource_patching_pass.cpp:1524) παραλείπει όλη την ανάλυση όταν `IsPatchShaders()`, και το
  `C:\shadps4-test19-gt7\user\config.json` έχει `"patch_shaders": true` (και τα 6 test προφίλ· default κώδικα false)·
  ο φάκελος `user\shader\patch` είναι ΑΔΕΙΟΣ → η ρύθμιση μόνο σβήνει το fix. r1 (00:04:48-00:06:57): 0x2a265dff 35
  compiles, S# 147, T# 38, και ΤΕΛΟΣ στο `liverpool_to_vk.cpp:788 SurfaceFormat` «Unknown data_format=46» στο image #0
  του fs 0x2a265dff (guarded slot· το assert που κρατούσε το T# check). Πρόταση: gate σε ΥΠΑΡΚΤΟ patch αρχείο, όχι στη
  ρύθμιση → TEST38 = TEST37 + 1 commit. Περιμένει τον χρήστη.

⚠⚠⚠ **30 Σεπ ~23:57 — TEST37 ΧΤΙΣΜΕΝΟ (εντολή ~23:52 «build test 37»), κανένα run ακόμα.** main ακόμα 2338a06f,
  #5196 αμετάβλητο. ebcfc8a2: `build_clean.bat -k 0` 69 s, NINJA_EXIT=0, 117 βήματα, 0 warnings, χωρίς CMake. Exe
  `backup_exe\shadps4_test37_ebcfc8a2_gt7.exe` 53280C4E...F217C + `pdb_test37_ebcfc8a2`· launcher
  `TEST37_GT7_ebcfc8a2_warm_diag_console.bat` 5697579...B4A3 (`make_test37_launcher.pl`). Όλα + τι πρέπει να δείξει
  ένα run: `logs\test37_build_details.txt`. Build details στάλθηκαν στον auditor gtnikos-e8 ~23:56.

⚠⚠⚠ **30 Σεπ ~23:40 — TEST37 COMMITTED, ΟΧΙ build (περιμένει εντολή).** `test37-main-2338a06f` = 04558db8 +
  028f3c8a (revert 9dce3330) + 22105b66 (revert d833bab4) + **ebcfc8a2** "shader_recompiler: Skip images and samplers
  a draw does not read" (+1051/-15, grep on disk OK, clang-format καθαρό). Auditor ειδοποιήθηκε ~23:12. Αποκλίσεις
  από το σχέδιο: κανένα νέο αρχείο (αλλιώς το ninja ξανατρέχει CMake) → pass 0 μέσα στο `ResourcePatchingPass`·
  evaluator μόνο για τα μετρημένα σχήματα· shader patching on = χωρίς guards.

⚠⚠⚠ **30 Σεπ ~23:10 — gtnikos-02: Η ΡΙΖΑ των κλάσεων 2, 4, 7 βρέθηκε (read-only έρευνα)· σχέδιο ΕΓΚΡΙΘΗΚΕ·
  build ΜΟΝΟ με εντολή χρήστη.** Ο χρήστης απέρριψε το T# check ως σύμπτωμα. Ρίζα: η PS4 GPU διαβάζει T#/S# μόνο
  όταν εκτελείται εντολή που το χρησιμοποιεί· το shadPS4 αποκωδικοποιεί, specializes και δένει ΚΑΘΕ image/sampler σε
  ΚΑΘΕ draw, άρα τα σκουπίδια σε slots πίσω από uniform branch που δεν παίρνεται γίνονται images. fs 0x2a265dff:
  img0/img1/samp0 μόνο μέσα σε `if (0u != data[50])`, data[50]=0 και στα 39 permutations, το live img2 ίδιο και στα
  39 → 39 permutations από σκουπίδια. Census: 469/1187 shaders της GT7 (3397 slots)· και το GoW· upstream τίποτα.
  Σχέδιο: `GT7_upstream\logs\test37_plan_resource_guards.md` (νέο pass ανάμεσα σε Flatten και Patching· πίνακας
  συνθηκών ανά group· dead group → `GetSharp` = Null/zero S# σε compile, key (κουβαλά το dead set) και bind·
  storage images πάντα live· Unknown = live). TEST37 = TEST36 − 9dce3330 − d833bab4 + fix. Απόδειξη: `Compiling fs
  shader 0x2a265dff` 15-58 → 1, rejections ~μισά, κανένα `Thick3DThickPrt_32 detiler`. Η σύνδεση της κλάσης 2 είναι
  ΣΥΜΠΕΡΑΣΜΑ (ίδια οικογένεια ±1.0· κανένα meta δεν έχει το T# της) → το TEST37 κρίνει. #5196 αμετάβλητο 23:08.

⚠⚠⚠ **30 Σεπ ~21:05 — ΝΕΟΣ BUILDER gtnikos-02 (αντί gtnikos-66)· έλεγχος κατάστασης, καμία αλλαγή.** origin/main =
  2338a06f (fetch 20:57). #5196: CI 10/10 πράσινα + pre-release skipped (τελευταίο 17:53:01Z), 0 σχόλια / reviews,
  mergeable clean. #5155 αμετάβλητο. Κανένα shadps4, κανένα run μετά το TEST36 r1, κανένα loop, τίποτα οπλισμένο.
  ListAgents: ο gtnikos-04 έφυγε· μόνο ο gtnikos-e8 (~20:54, idle), ΑΕΠΙΒΕΒΑΙΩΤΟ αν είναι ο auditor· κανένα μήνυμα.
  ⚠ Κλάση 7 στο TEST36 (και στο #5196) = **`tiling.cpp:66`**, όχι :65 (το 04558db8 πρόσθεσε γραμμή)· το r1 δεν έχει
  καμία γραμμή tiling.cpp, άρα το 0 στέκει. Για το T# fix (ανάγνωση): `IsValidGpuMapping` = μόνο `addr + size < 1 TiB`
  → T# στο 0 περνάει· `IsValidMapping` ελέγχει το VMA map· tiling_index 5 bit, TileMode 0-26 + 31 → 27-30 = το
  UNREACHABLE. Περιμένει εντολή χρήστη.

⚠⚠⚠ **30 Σεπ ~20:50 — PR #5196 ΑΝΟΙΧΤΟ + νέο HANDOFF.** Ο χρήστης άνοιξε το **#5196** (17:36:30Z = 20:36, head
  `mine/tiled-mip-layout` 4697d56c, 1 commit, 6 αρχεία +54/−41· 20:40: 0 σχόλια, CI 3/10 πράσινα, 7 σε εξέλιξη). Το κείμενο
  είναι του χρήστη, ελεγμένο για γεγονότα σε 6 γύρους (το τελικό = `body` στο API). #5155 ανοιχτό, merge-tree καθαρό με
  2338a06f. Repo για τον tester ΔΕΝ φτιάχτηκε. Νέο `GT7_upstream\HANDOFF.md` (το παλιό → `superseded\HANDOFF_20260930_builder_66.md`)
  + `GT7_upstream\NEXT_BUILDER_PROMPT.txt` (το prompt του επόμενου builder). `gh` ΔΕΝ είναι logged in → PR μέσω public API
  (curl), push μέσω git.

⚠⚠⚠ **30 Σεπ ~19:52 — PUSH στο `mine`** (χρήστης ~19:50: «push the fix to our fork so i make the pr as the rules
  request»). `mine/tiled-mip-layout` = **4697d56c** (νέο branch, χωρίς force· `ls-remote` = το τοπικό)· origin/main
  19:51 = 2338a06f, αμετάβλητο. Το PR το ανοίγει και το γράφει ο χρήστης
  (https://github.com/nikmparis217-ux/shadPS4/pull/new/tiled-mip-layout)· στο upstream δεν γράφτηκε τίποτα. Στο push:
  TEST36 = 1 ελεγμένο run (κλάση 1)· η κλάση 12 δεν ξαναφάνηκε, αλλά ούτε εξηγήθηκε. **~20:28: ο tester ΜΕΝΕΙ ΤΟΠΙΚΑ**
  (χρήστης: δημοσιεύεται μόνο αν το ζητήσει κάποιος)· οι αποδείξεις για «0 of 440» και τις 31 τιμές ήταν ΜΟΝΟ στο scratchpad
  → τώρα `builder_scripts\bc_checker\pr_evidence\` (README· το thresh.exe ξανάτρεξε εκεί: 0 of 440, alt 0).

⚠⚠⚠ **30 Σεπ ~19:45 — PR τίτλος + GPU regression test.** `tiled-mip-layout` **4697d56c** «video_core: Fix mip layout
  and detiling of tiled textures» (ίδιο tree c7816d8c, ΤΟΠΙΚΟ). `bc_checker\tiling_gpu_test.cpp`: τρέχει τον ΑΛΗΘΙΝΟ
  κώδικα (UpdateSize από το image_info.cpp.obj του build, πίνακες από tiling.cpp.obj, το SPIR-V του tiling.comp που
  έχει το exe) στην GPU έναντι addrlib, κάθε texel κάθε mip, detiler + tiler· 387 cases / 4019 mips. Fix: 0 λάθη.
  main 2338a06f (`build_gpu_test_main.bat`): 342/387 λάθος, 73 ASSERT στο UpdateSize, GT7 mips 3-5 = 1008/240/48.
  ⚠ Παγίδα: addrlib με basePitch + emulator με pitch = width = ψεύτικη αποτυχία (8 BC1 256x1024)· ο T# του παιχνιδιού
  έχει το ALIGNED pitch → τρέχουν και τα δύο setups. `logs\tiling_gpu_regression.txt`. TEST36 r1 = κλάση 1, τίποτα νέο.

⚠⚠⚠ **30 Σεπ ~19:05 — TEST36 ΧΤΙΣΜΕΝΟ + PR branch ΕΤΟΙΜΟ (ΤΟΠΙΚΟ, ΟΧΙ push)** (χρήστης ~18:55: «make test 36 with
  the full fix. after it passes ... we PR»). `logs\test36_build_details.txt`. **TEST36 = `test36-main-2338a06f` 04558db8**
  = TEST35 91ffbea6 + ΕΝΑ commit (commit-tree με το tree του 15a397ea = f98ac317 + 15a397ea μαζί). Build 18:58:44-58,
  NINJA_EXIT=0, 16 βήματα, 0 warnings, χωρίς CMake. Exe `backup_exe\shadps4_test36_04558db8_gt7.exe` 19F00C64…DFF0, pdb
  `pdb_test36_04558db8` 911457E8…6A75, launcher `TEST36_GT7_04558db8_warm_diag_console.bat` EFF3CBC4…0B12 (121 γρ.,
  `make_test36_launcher.pl`, GT_BINDLOG μένει). origin/main 18:50 = 2338a06f. Ο watcher ενημερώθηκε πριν/μετά.
  **PR branch `tiled-mip-layout` 21055b66** = origin/main + 1 commit «texture_cache: Fix the layout and detiling of tiled
  images» (tree c7816d8c: τα 6 αρχεία του fix από το TEST36 — image_info.cpp/.h, tile.h, tile_manager.cpp, tiling.comp,
  tiling.cpp — +54/−41, patch-id = το συνδυασμένο diff 2338a06f..TEST36 σε αυτά)· κανένα άλλο commit της στοίβας δεν
  αγγίζει αυτά τα 6, καμία χρήση συμβόλου των instruments· clang-format 19.1.5 καθαρό, `diff --check` καθαρό, κανένα
  σχόλιο/GT_. Κανένα ανοιχτό upstream PR δεν αγγίζει τα 6 αρχεία (63 open, 10 υποψήφια ελέγχθηκαν). ⚠ Κλάση 12 (ΝΕΑ στο
  TEST35, 1/7): υποψήφια 0ca8528f (ΜΟΝΟ thick arrays) ή #5193· τα readback/tile copies είναι μεγέθους ≤ του staging τους και
  με το νέο layout· upstream #4816 (RFC) = ίδιο είδος (readback overrun). Αν ξαναβγεί στο TEST36 → [test] γραμμή για κάθε
  dedicated staging request ΠΡΙΝ το PR. Push στο `mine` μόνο όταν περάσει + πει ο χρήστης· το κείμενο το γράφει ο χρήστης.

⚠⚠⚠ **30 Σεπ ~18:45 — ΤΑ ΥΠΟΛΟΙΠΑ MIPS ΔΙΟΡΘΩΘΗΚΑΝ offline· TEST36 έτοιμο, ΟΧΙ build** (χρήστης ~18:30: «fix the
  remaining mips so the mip section is fully completed»). `logs\test36_prep_remaining_mips.txt`. TEST35 r1-r6: το
  bindlog λέει image 4 του fs 0x74f5f10c = 0x30041e0000 = «image dump 00» (το slot 6 = νέο 4x4 R32G32Uint σε κάθε draw,
  γεμίζει το cap 256). **`test36-remaining-mips`** (wt35) = TEST35 + **f98ac317** (GetArrayMode(Thin3DThinPrt) =
  ArrayPrt3DTiledThin1· ΑΠΟΔΕΙΞΗ = GB_TILE_MODE18 0x9240032C του PS4 από το GnmTilemodes.cpp του GPCS4, όλα τα άλλα
  πεδία των 31 τιμών ίδια με τους πίνακές μας εκτός από το Neo alt pipe) + **15a397ea** (128 bpp display = thin σειρά·
  addrlib SI/CI + Sony: bitsPerElement == 128 → Thin, κανένας display tiler 128). Checker 35 → 30 → **0/333**. GT7 +
  GoW δεν τα χρησιμοποιούν ΠΟΤΕ → τρέξιμο = μόνο έλεγχος regression. Upstream 18:45: origin/main ακόμα 2338a06f, το
  TEST35 το περιέχει. Επόμενο: fetch ξανά, μήνυμα στον watcher, build TEST36 όταν πει ο χρήστης ότι τελείωσαν τα runs.

⚠⚠⚠ **30 Σεπ ~18:00 — TEST35 ΧΤΙΣΜΕΝΟ, περιμένει run, τίποτα οπλισμένο** (χρήστης ~17:50: «2 plus the tool to read
  what texture the buddy shader reads»). `logs\test35_build_details.txt`. **`test35-main-2338a06f` 91ffbea6** = origin/main
  2338a06f + όλο το stack του TEST34 με `replay_onto_main.sh` (11 commits, ίδιες +/- γραμμές· 23533fc9 → 0ca8528f) + ΕΝΑ
  `[test]` 91ffbea6: με `GT_BINDLOG=<hash>` το BindTextures γράφει κάθε image του shader, μία φορά ανά slot/image/view,
  ΜΕΤΑ το FindTexture (άρα μετά το upload και το dump) → «[GT_DIAG] bindlog … -> image dump NN» ή «not in the image dump»
  (≤256 γραμμές). Launcher `TEST35_GT7_91ffbea6_warm_diag_console.bat` (121, EC7EC1CE…B115) με `GT_BINDLOG=0x74f5f10c`.
  Build 17:57:19-56 NINJA_EXIT=0, 28 βήματα, 0 warnings, όχι CMake· exe 6EDFAA72…7C71, pdb `pdb_test35_91ffbea6`.
  **Το `C:\shadps4-clean` είναι στο test35-main-2338a06f.** Fixes μας εκτός main: 4fb85d78, d4160dd8 (= ανοιχτό PR
  #5155, Preload), cad636ac, 791ebf03, 34e1d0da, 23533fc9. clang-format του project = **19** (VS BuildTools), όχι το 22.

⚠⚠⚠ **30 Σεπ ~17:40 — Η ΑΠΟΔΕΙΞΗ ΤΟΥ TEST34 ΣΤΕΚΕΙ· TEST35 έτοιμο, ΟΧΙ build** (χρήστης ~17:05: «αν περάσει, φτιάχνουμε
  και τα υπόλοιπα mips για ένα πλήρες mip PR»). `logs\test34_dumpcheck\README.txt` + `test34_proof_r1.png`. r1-r4 (κλάσεις
  2, 3, 4, 4) έγραψαν τα ίδια 16 BC7 tm-16· με το 34e1d0da 0 μηδενικά / 0 εκτός εικόνας σε κάθε mip, με τον τύπο του main 52
  mips λάθος, όλα διαβάζουν και πέρα από το τέλος. Auditor: και τα 16 ανεβαίνουν στην ΠΡΩΤΗ Buddy οθόνη (16 = το cap
  του dump)· dump 00 (0x30041e0000) = image 4 του fs 0x74f5f10c μόνο μέσω της γραμμής GT_IMGINFO_LOG της 26 Σεπ
  (`imginfo_lines_clean171_13_001305.txt`), το log του TEST34 δεν το λέει. Το main έχει ΑΚΟΜΑ `ASSERT(!props.is_block)` → το PR κουβαλά και το
  4fb85d78. Checker: layers όπως το NumLayers() (pow2pad) → 18/24 «6-layer» ήταν λάθος του checker· `-thicklayers` →
  όλα τα 28 thick arrays σωστά· μένουν 35 = 30 128-bit display (σειρά micro tile, και στο mip 0) + 5 tm 18 (πίνακας), κανένα
  mip-chain. 96 runs GT7: ΠΟΤΕ tm 18 ή 128-bit display· Thick1DThick / Thick3DThickPrt ναι, arrays ή volumes = άγνωστο.
  **`test35-thick-layers` 23533fc9** (image_info.cpp +6/−4) στο side worktree `C:\shadps4-wt35`· το `C:\shadps4-clean`
  μένει στο test34. PR preview: origin/main 2338a06f + squash(4fb85d78, 34e1d0da, 23533fc9) = tree f426a1ec, 5 αρχεία
  +48/−36. Το main προχώρησε (#5193: offset του sparse arena σε bytes αντί blocks στα SubRange/CanMergeWith — εκεί
  εμφανίστηκε η κλάση 2).

⚠⚠⚠ **30 Σεπ ~16:15 — TEST34 ΧΤΙΣΜΕΝΟ (dump για την in-run απόδειξη του per-mip fix), περιμένει run, τίποτα
  οπλισμένο** (χρήστης ~14:55: «ok make the new test»). **`test34-imgdump` 76a35aac** = 34e1d0da + ΕΝΑ `[test]` commit
  (texture_cache.cpp +135): με `GT_IMGDUMP_DIR` το RefreshImage γράφει τα guest bytes των πρώτων 16 BC images με
  `micro_tiled_mips != 0` όπως τα παίρνει ο detiler (`CopySparseMemory`, ΜΟΝΟ αν η περιοχή δεν είναι GPU-modified·
  αλλιώς γραμμή «not written») σε `img_NN_<addr>_uK.bin` + `.txt`. Offline: `bc_checker.exe -dump <txt>` → DDS new/old
  ανά mip, `python dumpsheet.py <dir>\view <stem>` → ένα PNG old | new. `-synth` δοκιμή: 1008/240/48 διαφορές στα mips
  3-5 = τα νούμερα του run5· ΝΕΟ: με τον τύπο του main 576/192/48 blocks διαβάζονται ΠΕΡΑ από το τέλος της εικόνας.
  Build 16:03:44-16:04:04 NINJA_EXIT=0, 3 βήματα, 0 warnings· exe 63BEE190…4E89, pdb `pdb_test34_76a35aac`, launcher
  `TEST34_GT7_76a35aac_warm_diag_console.bat` BEE62E4A…DBC8 (119 γραμμές, dumps στο `logs\imgdump_test34_gt7_<TS>`).
  **Το `C:\shadps4-clean` είναι στο test34-imgdump.** Επόμενο: ΕΝΑ run ως το Buddy screen → dump 00 → sheet → PR.

⚠⚠⚠ **30 Σεπ ~14:50 — TEST33 r1-r4 (07:08-07:18) ελεγμένα από τον auditor: κλάσεις 2, 1, 2, 5 = όλες γνωστές**
  (`logs\test33_gt7_runs_audit.txt`, CRASH_MAP TEST33). r1 ΔΕΝ παρακολουθήθηκε (loops idle-stop 01:21 πριν το launch).
  tiling.cpp:65 / image_info.cpp = 0· fs 0x74f5f10c δέθηκε 27/337/262/1384 φορές. Ανάγνωση builder: καμία regression από
  το 34e1d0da· η κλάση 2 (ίδια σελίδα, ίδια δύο 8 MiB blocks) ΜΕΝΕΙ → το layout των μικρών mips ΔΕΝ είναι αυτό που γράφει
  στην τρύπα. Τα shots ΔΕΝ δείχνουν το fix (τα λάθος mips του main = 3-5, 128/64/32 px· καμία εικόνα Buddy/assist-preset
  δεν δένεται με αυτό το texture) → ο κανόνας PR (1) στηρίζεται μόνο στον checker. Πρόταση (αποφασίζει ο χρήστης): TEST34 =
  TEST33 + ΕΝΑ `GT_*` commit που γράφει τα guest bytes του texture (μέσω `BackingPages()`) σε αρχείο· offline ο checker
  κάνει detile τα mips 3-5 με τον παλιό ΚΑΙ τον νέο τύπο σε BC7 DDS (Pillow 12.3 εδώ τα κάνει PNG) = in-run απόδειξη· μετά
  PR με το 34e1d0da μόνο. Πριν το επόμενο launch ο watcher ξαναοπλίζει (FIRST=5).

⚠⚠⚠ **30 Σεπ ~00:50 — TEST33 ΧΤΙΣΜΕΝΟ = BC βήμα 2, περιμένει το 1ο run, τίποτα οπλισμένο** (χρήστης ~00:20: «apply 1 and
  the first two of the 4 ... and build the new test»). **`test33-mip-tile-mode` 34e1d0da** = test33-main-e754ce62 791ebf03 +
  ΕΝΑ commit «texture_cache: Use the 1D layout for mips that drop out of macro tiling» (5 αρχεία +45/−34): tile.h
  `IsMacroTiledMip` (ο ίδιος κανόνας extents που είχε ήδη το size, βγαλμένος από το `ImageSizeMacroTiled`),
  `ImageInfo::micro_tiled_mips` (bit ανά mip που πέφτει σε 1D), `TilingInfo.micro_tiled_mips`, tiling.comp = micro τύπος
  ανά mip· thick/XThick mip που πέφτει = 1D_TILED_THICK = **4** slices (padding + alignment + διεύθυνση). Το threshold
  της AMD ΔΕΝ μπήκε: με τους πίνακες του PS4 δεν πυροδοτείται ΠΟΤΕ (0/440, κανονικοί + alt· scratchpad `bc18\thresh.cpp`).
  Ομάδα (a) (20, DegradeLargeThickTile) = καμία αλλαγή στον emulator· ο checker δημιουργεί πλέον addrlib με
  `allowLargeThickTile` (παλιός κώδικας `bc_checker_pre_mipmode.cpp`, χωρίς `-fixed`). **run10 252/333** (ήταν 216·
  +20 +16· τίποτα δεν χάλασε), run11 με tm-18 PRT 257. BC7 tm 16 του GT7: 0/11 mips λάθος (3/11 στο main). Build
  NINJA_EXIT=0, 75 βήματα, 47 s, 0 warnings· exe `backup_exe\shadps4_test33_34e1d0da_gt7.exe` 3FEA75A2…D011, pdb
  `pdb_test33_34e1d0da`, launcher `TEST33_GT7_34e1d0da_warm_diag_console.bat` E8AF6C61…432F. **Το `C:\shadps4-clean`
  είναι πλέον σε αυτό το branch.** Όλα στο `logs\test33_build_details.txt` + HANDOFF.md. Επόμενο: runs του TEST33
  (Buddy screen)· αν περάσει → PR branch από origin/main με το 34e1d0da μόνο (merge-tree καθαρό).

⚠⚠⚠ **29 Σεπ ~23:45 — #5181 ΚΑΙ #5137 MERGED** (raphaelthegreat 20:36Z). origin/main = 8c91be2b (#5181) ← 1a0f5be8
  (#5137) ← eb2fb486 (#5178) ← c810d6e1 (#5177)· patch-ids = ακριβώς τα δικά μας (v2 5d6c51d8, d2a0e3ed). ΔΙΟΡΘΩΣΗ: PR με
  ΕΝΑ commit → το squash παίρνει τον τίτλο του COMMIT, όχι του PR (ο παλιός τίτλος δεν έφτασε στο main). Ζωντανό PR τώρα:
  **#5155** (open, 0 reviews, CI πράσινο, merge-tree καθαρό με e754ce62). Μετά μπήκε και το **#5171** (e754ce62, spirv
  1D images, ΧΩΡΙΣ bump του cache version). **TEST33 base = branch `test33-main-e754ce62` 791ebf03** (e754ce62 + τα 8
  εναπομείναντα commits του TEST32· διαφορά από TEST32 = ακριβώς #5177+#5178+#5171), ΟΧΙ build·
  το checkout μένει στο test32. **BC βήμα 1 ΕΓΙΝΕ:** με tm 18 = ArrayPrt3DTiledThin1 (scratch αντίγραφο tiling.cpp,
  `bc_checker\tiling_prt18.cpp` + `build18.bat`) το fix πάει 216 → 221/333· αλλάζουν ΜΟΝΟ οι 5 περιπτώσεις του tm 18 και
  γίνονται 0/0 → το fix δεν χαλάει το 18, οι δύο πίνακες του emulator για το 18 διαφωνούν (LUT = PRT, GetArrayMode = 3D).
  Ποιος είναι του PS4 δεν μετριέται με addrlib. GT7 BC census: μόνο tm 13 + 16 → tm 18 = ξεχωριστό candidate, παρκαρισμένο.
  Επόμενο: BC βήμα 2 (per-mip mode: tile.h threshold TODO, bitmask στο ImageInfo, TilingInfo, tiling.comp main).

⚠⚠⚠ **29 Σεπ ~23:40 — #5181 APPROVED** (raphaelthegreat). Μένουν στον χρήστη: title (squash = τίτλος PR στο main — ΛΑΘΟΣ
  για PR ενός commit, βλ. από πάνω) + description. ΚΑΝΟΝΑΣ: το ζωντανό PR ΠΑΝΤΑ πρώτο, πριν από τοπικά σφάλματα/fixes.

⚠⚠⚠ **29 Σεπ ~22:58 — v2 5d6c51d8 PUSH (force-with-lease πάνω στο 625c1da1) στο mine/user-data-flatbuf-fallback = head
  του #5181.** Χρήστης: TEST32 «has passed». Title/description του PR περιγράφουν ακόμα το παλιό fallback — τα ξαναγράφει ο
  χρήστης. ΚΑΝΟΝΑΣ: τίποτα γραμμένο upstream από το Claude (σχόλια, απαντήσεις, title/description)· μόνο το push.
  Whitewash ΔΕΝ διορθώθηκε από το v2: TEST32 r5 t0124s/t0155s + r6 t0111s το δείχνουν, TEST30 r5/r7/r10 όχι →
  διαλείπον και στα δύο builds. FPS «λίγο πιο γρήγορο» = εντύπωση χρήστη. Ανάλυση → auditor chat. Επόμενο: σχέδιο BC.

⚠⚠⚠ **29 Σεπ ~22:20 — REVIEW #5181 → v2 + TEST32 ΧΤΙΣΜΕΝΟ (χρήστης: «changes are asked ... make the proper changes and
  we test that first»).** raphaelthegreat: το fallback (1) στηρίζεται σε flatbuf που υπάρχει μόνο με ReadConst, (2) δέσιμο
  μόνο όταν χρειάζεται = σπάει «ίδιος αριθμός bindings σε όλα τα permutations». Ζήτησε: ΚΑΘΟΛΟΥ user data στο push data,
  flatbuf και για GetUserData, όχι ud_mask. **v2 = τοπικό `user-data-flatbuf-v2` 5d6c51d8** (πάνω στο cecd03b7, title
  «shader_recompiler: Read user data from the flat buffer», ΟΧΙ push): 10 αρχεία +23/−66· AddFlatbuf για GetUserData+ReadConst
  (has_readconst→has_flatbuf)· έφυγαν ud_mask/PushUd/Bindings::user_data/PushData::ud_regs (56 B)· StageSpecialization
  shortcut = `buffers/images/samplers empty` αντί `bitset.none()` (τα special buffers δεν βάζουν bit → flatbuf-only shader
  ξαναχρησιμοποιεί module άλλου start· ήδη στο main για hs 0x933eadb2)· ΟΧΙ `info->` μέσα στο operator== (preloaded spec σε
  υπάρχον program = dangling info)· ShaderBinaryVersion ΚΑΙ ShaderMetaVersion 5→6. Μέτρηση caches: νέο flatbuf μόνο σε cs
  (GT7 4, GoW 1 = 0x4cce254e, GoT 0)· IsComputeImageCopy/Clear (ακριβώς 2 buffers) → κανένας δεν αλλάζει (ο GoW έχει
  is_formatted=0 και στα δύο). **TEST32 `test32-ud-flatbuf` 2ccb31e0** = TEST31 + 1 commit (tree = 3bc09423 + v2, ίδιες
  +/-), NINJA_EXIT=0, 80 βήματα, 47 s· exe 2F0D8E4E…EF3D, pdb `pdb_test32_2ccb31e0`, launcher 17CAF6BC…9121,
  `logs\test32_build_details.txt`· notice+details στον 04. ΚΑΘΕ run κρύο (versions 6). Μετά: force-push v2 →
  `mine/user-data-flatbuf-fallback` ΜΟΝΟ όταν το πει ο χρήστης. Παγωμένα (όχι ακυρωμένα): BC βήματα 1-2 + TEST33 με τα
  readings T#/SnormNz· tm 18: `GetPipeConfig` βάζει το 18 με τα 2D (P8_32x32_16x16), το 15 με τα 3D.

⚠⚠⚠ **29 Σεπ ~21:40 — ΝΕΟΣ ΚΑΝΟΝΑΣ + BC checker.** Χρήστης: «we must complete a fix before we make a new one unless
  the game crashes way to randomly...» (γραμμή στο CLAUDE.md RULES). Checker `GT7_upstream\builder_scripts\bc_checker\`
  (addrlib των externals + tiling.cpp/tile.h του emulator + port του UpdateSize/tiling.comp· τρέξιμο `-nobase -hawaii
  [-fixed]`· ΠΟΤΕ Bonaire = thick quirk). GT7 BC7 1024² tm16: layout = AMD, texels λάθος στα mips 3-5 (detiler = macro
  τύπος σε 1D mips)· candidate fix (κανόνας CI ανά mip + micro τύπος) = 0 διαφορές, sweep 0 → 216/333. Εμπόδιο: tm 18
  (LUT = PRT, GetArrayMode = 3D thin). Ξεχωριστά: pow2 pad ΚΑΙ των layers (addrlib PostComputeMipLevel), thick 64/128bpp,
  128-bit display. SnormNz = κώδικας πλήρης (λείπει run)· T# check: specialization διαβάζει T# πριν το check + address 0.

⚠⚠⚠ **29 Σεπ ~20:40 — PushUd PR branch PUSHED (χρήστης: «commit the new fix to our fork seperate branch as always ...
  proper tittle»).** `mine/user-data-flatbuf-fallback` **625c1da1** (ls-remote OK), parent origin/main cecd03b7 (αμετάβλητο),
  title «shader_recompiler: Read user data from the flat buffer when push slots run out», noreply, χωρίς trailer. 4 αρχεία
  +19/−3: τα 3 του fix byte-ίδια με 1707582f + **`ShaderBinaryVersion` 5→6** (η ΜΟΝΗ γραμμή χωρίς build/run): το cache που
  άφησε το TEST28 r3 όταν πέθανε στην παύση (`cache_before_launch_20260929_082454`) έχει `0x7bab5d15_0.spv` που διαβάζει push
  slot 16 → χωρίς bump το διορθωμένο build το ξαναφορτώνει (το directory cache γράφεται ενώ τρέχει). Upstream κάνει bump για
  αλλαγή εξόδου shader (#4941, #5090). Κανένα ανοιχτό PR/issue· μόνο #1032 (έβαλε τα 16 κοινά slots + το assert). Branch μόνο
  του = ΔΕΝ χτίστηκε. Ερώτηση χρήστη «16 ανά stage όπως το PS4;» → όχι σε push constants (1 block/pipeline, 128 B εγγυημένα,
  χρειάζονται 5×64 B)· «κάθε stage από το flatbuf του» εφικτό αλλά αλλάζει κάθε shader κάθε παιχνιδιού → ξεχωριστό test μόνο
  με go. ⚠ Git Bash `grep -c $'\r'` = ΚΑΘΕ γραμμή (μοτίβο μόνο CR = κενό) → ψεύτικο «CRLF»· bytes με python.
  ~20:45: ο auditor (`gtnikos-04`) έδωσε `GT7_upstream\CRASH_MAP.md` (10 ανοιχτές κλάσεις + log γραμμές ανά κλάση, σειρά #4,
  #1, #2). #1 (GPU write στο 0, 10 runs) ↔ «Coercing copy source layers 8 and destination layers 48» μόνο σε αυτά τα runs·
  στον κώδικα `Runtime::CopyImage`/`ResolveImage` = extent από την ΠΗΓΗ, χωρίς clamp στον προορισμό. Πρόταση: TEST32 = +1 GT_*
  commit με τις γραμμές των #4 και #1· περιμένει go.

⚠⚠⚠ **29 Σεπ ~20:30 — PushUd fix: αποτέλεσμα + γενικότητα (μετρημένα).** TEST30 r10: η draw της παύσης που κράσαρε
  (fs 0xb2d26667 6 + hs 0x27d2194a 5 = 11 slots, vs/TES 0xdbbb8a3c 6 → 17) διάβασε ud_0..5 από srt_flatbuf, 3 παύσεις, 0 assert·
  r7 = η in-race draw (vs 0xc56c214c). Το «κόλλημα» στην 1η παύση = ~500 compiles στο GpuCommandProcessor (72 s, 2 frames)· το
  ίδιο στο r5 με τον παλιό δρόμο (314 compiles, ~43 s)· μετά το μενού βγαίνει (23 FPS). ΟΧΙ GT7-specific: 16 κοινά push slots για
  ΟΛΑ τα stages (PushData 120/128 B), overflow μόνο σε tess pipelines. Κάλυψη: κάθε graphics module που διαβάζει ud έχει flatbuf
  (GT7 1420/1420, GoW 42/42, GoT 72/72· χωρίς flatbuf μόνο cs). Ξεχωριστό, προϋπάρχον: shortcut `bitset.none()` στο
  StageSpecialization αγνοεί το start → στο GT7 εκτεθειμένος μόνο ο hs 0x933eadb2 (fs είναι πάντα slot 0). Το fix μόνο του πάνω στο
  cecd03b7 = «same +/- lines» (36ddca09, χωρίς ref). Εργαλείο: scratchpad `udscan.py` (SPIR-V parse, πηγή κάθε ud_N).

⚠⚠⚠ **29 Σεπ 19:58 — TEST31 ΧΤΙΣΜΕΝΟ (χρήστης ~19:45: «the next tests ... built with the current upstream code plus our
  fixes», μετά «go»).** `test31-main-cecd03b7` **1707582f** = τα 10 commits του TEST30 με `replay_onto_main.sh` πάνω στο
  origin/main **cecd03b7** (+#5172 settings, +#5175 timed rwlocks)· όλα «same +/- lines», delta από TEST30 = ΑΚΡΙΒΩΣ τα δύο
  upstream commits (8 αρχεία +77/−234), καμία επικάλυψη αρχείων. NINJA_EXIT=0, 114 βήματα, 96 s, 0 warnings, CMake δεν
  ξανάτρεξε (tests/ εκτός build graph). Exe `shadps4_test31_1707582f_gt7.exe` DE3A683C…43FC, pdb `pdb_test31_1707582f`
  246025E8…99E0, launcher `TEST31_GT7_1707582f_warm_diag_console.bat` 90C221B5…5DEB (`builder_scripts\make_test31_launcher.pl`).
  `logs\test31_build_details.txt`. ListAgents: αυτή η συνεδρία = `gtnikos-66`, peer = `gtnikos-04` (πήρε notice + details).
  Επόμενο ζητούμενο test = TEST32 = TEST31 + 1 commit· αν κουνηθεί το main, ξανά replay. Ανοιχτά PR που ΔΕΝ βοηθούν:
  **#5178** sceKernelGetProcessType (+g+UP8Pyfmo) — κανένα παιχνίδι μας δεν το κάνει import· **#5179** sceGnmSetGsRingSizes
  (jtkqXpAOY6w) + sceGnmSetupMipStatsReport (+xuDhxlWRPg) — import σε GT7 1.71/1.00/GoW/GoT, 0 κλήσεις σε κανένα log (και
  στα lab 1.00 runs μέσα/μετά τον αγώνα, Lib.GnmDriver σε debug)· τους ring-size registers δεν τους διαβάζει τίποτα.
  #5172: `redzone_patches` (General, default false) + το παλιό game-specific κλειδί αντιστοιχίζεται εκεί.

⚠⚠⚠ **29 Σεπ 08:37 — TEST30 ΧΤΙΣΜΕΝΟ (χρήστης ~08:32: «we keep all our pr fixes plus we continue development to the local
  fixes. if no local fixes we find the next problem and make a fix. we test it and if succesful we pr. if not we continue
  testing» → γραμμή στο RULES block + [[feedback-shadps4-run-base-main-plus-fixes]]).** `test30-pushud-flatbuf` **600bce36** =
  106e7263 + 1 commit «shader_recompiler: Read user data from the flat buffer when the push slots are full» (plumbing, 3 αρχεία
  **+18/−2** — το «+16/−2» του d9 = λάθος μέτρημα· ίδιες γραμμές με το pushud_flatbuf.diff ανά αρχείο, clang-format 19.1.5 = 0).
  NINJA_EXIT=0, 69 βήματα, 39 s, 0 warnings· CMake ΔΕΝ ξανάτρεξε → η version γραμμή λέει ακόμα test29/106e7263. Exe
  `backup_exe\shadps4_test30_600bce36_gt7.exe` 65FF1F6A…C707, pdb `pdb_test30_600bce36` 3DF27A87…3CE9, launcher
  `TEST30_GT7_600bce36_warm_diag_console.bat` E1CF2ADC…C18C (= TEST29 εκτός γρ. 2-3, 7, 57-58, 96, 103-104). Σειρά slots =
  SwStage (runtime_info.h:27: Fragment, TessControl, TessEval, Vertex) → fs 0-5, hs 6-10, vs 11-16 → ο vs 0x7bab5d15 ξεχειλίζει.
  Το input cache (1520) δεν έχει ΚΑΝΕΝΑ από τα 4 modules → μεταγλωττίζονται στο run. Upstream 08:34: main = e35735c2, κανένα
  ανοιχτό PR/issue (μόνο τα κλειστά #1013/#1032). Στον d0: notice πριν το checkout + build details (`logs\test30_build_details.txt`).
  Επόμενο (τοπικά fixes, με τη σειρά): runs TEST30 → αν περάσει το pause, PR branch όταν το πει ο χρήστης· μετά BC πλήρες
  (checker πρώτα), T# check, SnormNz (θέλει run που να φτάνει το T#).
⚠⚠⚠ **29 Σεπ ~08:30 — ΝΕΟΣ BUILDER `gtnikos-f3` (αντικαθιστά τον d9).** Auditor = `gtnikos-d0` (από 08:13): επαλήθευσε το
  build του TEST29 08:15 και όπλισε test29_gt7_1..12 08:17 → το «nothing is armed / d0 ρόλος άγνωστος» του d9 = ΠΑΛΙΟ. Runs
  TEST29 από 08:24: r1 = `liverpool.cpp:249` «Unimplemented PM4 type 0, base reg: 0, size: 1» (γνωστή κλάση· παλιά builds στη γρ.
  256), 0x80000003, pad γρ. 121, ~6000 γρ. log· GT_DIAG «outside a draw or dispatch; last: dispatch 4080x1x1 cs 0xabe484108a360b66».
  r2 08:26:01-~08:28:37 = `address_space.cpp:552 Protect` (όπως μόνο το test22_gt7_1), 0x80000003, pad γρ. 121, GT_DIAG: draw
  count 3 fs 0x2a265dff vs 0x610d64f· 0 info.h:183 / pixel_format.h:359 / num_format=6. Τα runs = audit του d0. Έλεγχος TEST30 (read-only, 106e7263): οι ΜΟΝΟΙ αναγνώστες των push UD slots = τα 4 σημεία του patch
  (info.h PushUd/AddBindings, emit_spirv.cpp:666, emit_spirv_context_get_set.cpp:50)· has_readconst ⇔ Flatbuf binding
  (shader_info_collection_pass.cpp:147-153)· πρώτα 16 dwords του flatbuf = user data (srt.h:29, flatten pass :653, RefreshFlatBuf),
  upload σε κάθε draw (vk_rasterizer.cpp:948)· στο cache του TEST28 (`C:\shadps4-test19-gt7\cache_before_launch_20260929_082454`)
  fs/hs/vs του draw έχουν `srt_flatbuf`, το ls όχι (0 UD) → το fix φτάνει αυτό το draw. Εκκρεμούν (χρήστης): (1) #5137/#5155
  μένουν στο run build (πρόταση: ναι, run exe = main + ό,τι λείπει από το main)· (2) go TEST30, αφού πάρει runs το TEST29 (ο auditor
  οπλίζει μόνο το νεότερο build).

⚠⚠⚠ **29 Σεπ ~08:15 — TEST29 ΧΤΙΣΜΕΝΟ = rebase στο main (χρήστης: «remove whatever is local and apply the main with the fixes
  that we havent pred yet») + νέο HANDOFF.md (χρήστης: «make a new handoff for next chat»).** `test29-main-e35735c2` **106e7263** =
  origin/main e35735c2 + με την παλιά σειρά, ίδιες +/- γραμμές (`GT7_upstream\builder_scripts\replay_onto_main.sh` = merge-tree +
  commit-tree, checkout ανέγγιχτο μέχρι το switch): #5137 cfb03b83, BC macro-tiled 3bce9191, #5155 72af07aa, T# check 25e63680,
  4× GT_DIAG (f9bb694b 1a52a514 e65cb43a 344abbd3), SnormNz 106e7263. Έφυγαν (ίδιες +/- γραμμές στο main): #5114, #5131, #5150,
  #5165, readlane ×3 (main = #5169 +1/−1 = TEST21M). GoW branches ΟΧΙ (ποτέ στη γραμμή GT7). NINJA_EXIT=0, 0 warnings σε src/,
  ΠΛΗΡΕΣ rebuild 2381 βήματα (upstream CMakeLists +2 γρ. → ninja ξανάτρεξε CMake μόνο του). Exe `backup_exe\shadps4_test29_106e7263_gt7.exe`
  C3DD1133…0AC2, pdb `pdb_test29_106e7263` 8AEFF397…6EE1, launcher `TEST29_GT7_106e7263_warm_diag_console.bat` 70B63410…4D3A (= TEST28
  εκτός γρ. 2-3, 7, 57-58, 96, 103-104). Όλα στο `logs\test29_build_details.txt`. ⚠ Ο 8c πήρε το notice του switch (~07:55) αλλά η
  συνεδρία του έκλεισε πριν τα build details (ENOINBOX)· κανένας watcher δεν τρέχει· peer τώρα `gtnikos-d0` (ρόλος άγνωστος, ΔΕΝ του
  έστειλα). ⚠ Cache: το #5133 (f6cd16e8) έβγαλε το `ImageSpecialization::is_cube` χωρίς bump (ShaderMetaVersion 5): ίδιο 24 B, τα
  επόμενα πεδία −1 byte → παλιά specs διαβάζονται μετατοπισμένα (is_srgb = παλιό is_cube) → περισσότερα compiles από το ίδιο snapshot.
  TEST28 (8c: `logs\test28_gt7_runs_audit.txt`, επαληθευμένο): 3 runs, pad γρ. 121, το fix ΔΕΝ φτάστηκε (0 pixel_format.h:359, 0
  «Rejecting invalid T#»· το test25_gt7_4 το βρήκε στην τελευταία γραμμή log 793.080 γρ.)· τέλη: device lost ×2 (r2 + nvlddmkm 13
  «WIDTH CT Violation», ίδια ESR σε 8 runs TEST13→TEST28), PushUd `info.h:183` ×1 (pause στον αγώνα).
  **PushUd = ΤΟ ΕΠΟΜΕΝΟ (πρόταση TEST30 = TEST29 + 1 commit, ΘΕΛΕΙ go χρήστη):** το draw (GT_DIAG γραμμή: fs 0xa753ac8c, hs 0x27d2194a,
  vs 0x7bab5d15, ls 0xbe4254f7) θέλει 6+5+6+0 = 17 user-data slots, υπάρχουν 16 (PushData 120/128 B). Fix: stage που δεν χωρά ΚΑΙ
  έχει flat buffer (οι πρώτες 16 dwords του = τα user data του, RefreshFlatBuf) διαβάζει από εκεί (`EmitFlatbufferLoad(reg)`) και δεν
  παίρνει slots· ίδιος κανόνας στα PushUd / AddBindings / EmitSPIRV / EmitGetUserData: `UserDataInFlatbuf(bnd) = has_readconst &&
  bnd.user_data + ud_mask.NumRegs() > NUM_USER_DATA_REGS`. Pipelines που χωράνε = byte-ίδια. GT7 cache: 1135/1139 modules που διαβάζουν
  UD έχουν flat buffer· τα 4 χωρίς κρατούν το ASSERT. Έτοιμο: `builder_scripts\pushud_flatbuf.pl` + `pushud_flatbuf.diff` (3 αρχεία
  +16/−2, clang-format 19 = 0, `git apply --check` OK). Σημειώσεις: το παλιό module του vs στο live cache διαβάζει slot 16 (=buf_offsets)
  → το snapshot του launcher δεν το έχει (καθαρό test)· προϋπάρχον στον κώδικα: το `bitset.none()` shortcut της StageSpecialization
  αγνοεί το `start` (shader χωρίς resources που διαβάζει UD) — αμέτρητο, όχι μέρος του fix.

⚠⚠⚠ **29 Σεπ ~01:45 — TEST28 ΧΤΙΣΜΕΝΟ (χρήστης: «make the needed test. one fix test at a time»).** `test28-snormnz-conv`
  **05d66732** = test27b-pr5165 f2a5983c + 1 commit «pixel_format: Return no conversion for SnormNz formats without one»
  (MapNumberConversion: το SnormNz default → `NumberConversion::None` αντί για UNREACHABLE_MSG, pixel_format.h:359· clang-format 19.1.5 = 0).
  NINJA_EXIT=0, 126 βήματα. Exe `backup_exe\shadps4_test28_05d66732_gt7.exe` 7A61AE8C…693A, pdb `pdb_test28_05d66732` C9C99760…8D7B.
  Launcher `TEST28_GT7_05d66732_warm_diag_console.bat` BB1B09AD…5044 (= του TEST27b-PR5165, αλλαγμένες μόνο γρ. 2,3,7,57,58,96,103,104).
  8c: notice ΠΡΙΝ + build details. Απόδειξη ανά run: κανένα pixel_format.h:359· αν ξαναβγεί το T#, «Rejecting invalid T# ... num_format=6»
  με data_format ΕΚΤΟΣ 1,2,3,5,10,12. **#5150 MERGED 22:30:21Z = c01ae7e6** → ανοιχτά μόνο #5137, #5155.
⚠⚠⚠ **#5169 MERGED 28 Σεπ 22:26:47Z (01:26 τοπικά 29 Σεπ) από τον raphaelthegreat = 4c7b287f** (η +1/−1 έκδοση facea2df). PR μας:
  merged #5070, #5126, #5131, #5114, #5169· ανοιχτά #5137, #5150, #5155. Επόμενο (χρήστης: «one fix test at a time»): TEST28 =
  test27b-pr5165 f2a5983c + ΜΟΝΟ το MapNumberConversion (SnormNz default → None), μετά το BC (checker → TEST29).
⚠⚠⚠ **29 Σεπ ~01:30 — PR #5169 ΕΝΗΜΕΡΩΜΕΝΟ (χρήστης: «yes»):** `mine/tess-readlane-first` = **facea2df** (1 commit πάνω στο main
  fb6367d2, +1/−1, αρχείο ΙΔΙΟ με το δοκιμασμένο 766d40a1, patch-id 6decb274), force-with-lease πάνω στο 210622aa· upstream ΧΩΡΙΣ branch.
  Τοπικά: tess-readlane-first = facea2df, -v2 = 210622aa (+2 έκδοση), -v1 = c5a506ad (one-liner). API: 1 commit, +1/−1, CI ξανατρέχει.
  Απάντηση στους reviewers = ο χρήστης.
⚠⚠⚠ **29 Σεπ 01:12-01:21 — TEST21M 4 runs (pad OK σε όλα): Η ΜΕΤΑΚΙΝΗΣΗ ΔΟΥΛΕΥΕΙ.** r4 μεταγλώττισε το hs 0x27d2194a χωρίς
  «patch addr non imm», .spv 4FD635A79E97A195… = ΙΔΙΟ με TEST21/TEST19b. Σύγκριση cache (spvcmp2.sh, awk, μέθοδος spvcmp_t21, έναντι
  test21_gt7_2): r1 28 κοινά shaders / 26 ίδια, r2 27/26, r3 (cache `cache_before_launch_20260929_011846`) 344/333 + 10 υποσύνολο,
  r4 (user\cache) 451/443 + 7 υποσύνολο· ΜΟΝΗ διαφορά σε όλα = 0x2a265dff = θόρυβος (διαφέρει ΚΑΙ ανάμεσα σε test21 r1 και r2, ίδιο exe:
  14/7). Τέλη: r1/r2 `tiling.cpp:65 GetArrayMode` (άγνωστο tile mode), r3/r4 `liverpool_to_vk.cpp:788 SurfaceFormat` (βάση χωρίς T# guard,
  ΜΕΤΑ το hs στο r4)· κανένα από την αλλαγή. ⚠ Το user\cache ΑΛΛΑΖΕΙ με κάθε νέο launch (ο launcher το μετακινεί σε
  cache_before_launch_<TS του ΕΠΟΜΕΝΟΥ launch>) → διάβαζε ΠΑΝΤΑ το σωστό φάκελο (το «run3 40 blobs» ήταν μισό-αντιγραμμένο snapshot).
⚠⚠⚠ **29 Σεπ ~01:15 — TEST21M ΧΤΙΣΜΕΝΟ (χρήστης: «lets test it») = review του #5169:** squidbus (γρ. 109) «I don't think we
  need to run this twice?» + raphaelthegreat «is the constant propagation pass needed again after running readlane elim?».
  `test21m-readlane-move` **766d40a1** = test20c-notess 14a1ba6b + 1 commit, recompiler.cpp +1/−1 (RLE αμέσως μετά το ΠΡΩΤΟ CP, η
  ύστερη κλήση ΦΕΥΓΕΙ, ΧΩΡΙΣ δεύτερο CP) = TEST21 b5cace01 μείον 2 γραμμές. NINJA_EXIT=0, 53 βήματα, 0 warnings. Exe
  `backup_exe\shadps4_test21m_766d40a1_gt7.exe` 81492F2D…5604, pdb `pdb_test21m_766d40a1` AB075C9D…A997. Launcher
  `TEST21M_GT7_766d40a1_warm_console.bat` 194DB733…C217 (από το TEST21 warm: ίδιο REFA 1520, ίδιο save A, + live_log_colors).
  Checkout clean = test21m-readlane-move (8c: notice ΠΡΙΝ + build details). Μετά το run: `C:\shadps4-test19-gt7\user\cache` έναντι
  REFA + T21_2 (μέθοδος spvcmp_t21). Το CP δεν χρειάζεται: το TessellationPreprocess τελειώνει ΗΔΗ με CP πριν τα Hull/Domain· θα
  μετρούσε μόνο για αριθμητική πάνω σε προωθημένη τιμή μέσα στο TessellationPreprocess ή στο RingAccessElimination (κανένα shader).
  Αν ίδιο → +1/−1 πάνω στο main, force-with-lease του mine/tess-readlane-first (go χρήστη).
⚠⚠⚠ **29 Σεπ 00:51 (21:51Z) — PR #5169 ΑΝΟΙΧΤΟ (ο χρήστης):** «shader_recompiler: Eliminate readlanes before the tessellation and
  ring passes», head tess-readlane-first **210622aa**, 1 commit, +2/−0, base main **fb6367d2**. Το κείμενο το έγραψε ο ίδιος (review
  facts από εμένα: σειρά από το #2667, 5 asserts + 3 σιωπηλά `.U32()`, πριν = TEST11 `patch addr non imm`, μετά = TEST21, cold
  TEST19b έναντι warm TEST21 byte-ίδια). **#5114 MERGED 28 Σεπ 21:46Z = fb6367d2** (το αντίγραφό μας 65b739ed φεύγει με το επόμενο base).
  PR μας τώρα: ανοιχτά #5137, #5150, #5155, #5169· merged #5070, #5126, #5131, #5114.
⚠⚠⚠ **29 Σεπ ~00:40 — PUSH readlane (χρήστης: «push the full version on our fork at the existing branch»):** `mine/tess-readlane-first`
  = **210622aa** (1 commit πάνω στο origin/main **fca10b26** = το merge του #5165, τίτλος «shader_recompiler: Eliminate readlanes before the
  tessellation and ring passes», χωρίς body, noreply identity, patch-id 6c8110fd = b5cace01, blob recompiler.cpp ΙΔΙΟ με το δοκιμασμένο),
  `--force-with-lease` πάνω στο web merge c0c0cbdc (plumbing, temp index, checkout ΑΝΕΓΓΙΧΤΟ). Τοπικά: tess-readlane-first = 210622aa, το
  παλιό one-liner = `tess-readlane-first-v1` (c5a506ad). Το PR το ανοίγει ο χρήστης (compare link). Σφάλμα πριν: `ASSERT_MSG(addr.IsImmediate(),
  "patch addr non imm")` στο HullShaderTransform (TEST11, `logs\shad_log_test11_gt7_at_exit_001620.txt`)· μετά: TEST21 χωρίς assert.
⚠⚠⚠ **29 Σεπ ~00:15 — readlane (b5cace01): ΠΛΗΡΕΣ για τη ΣΕΙΡΑ, απάντηση στον χρήστη («will it make anything worse?»).**
  Καλύπτει και τα 8 σημεία (TessellationPreprocess/Hull/Domain/RingAccessElimination = τα ΜΟΝΑ passes πριν από την παλιά θέση)· το
  one-liner στο mine μόνο τα tess. Μετρημένα: cache TEST21 έναντι TEST19b 496 byte-ίδια, κάθε blob του TEST19b ακριβώς ίδιο (το one-liner
  αγγίζει ΜΟΝΟ tess → κάθε άλλο shader = ίδιο με χωρίς fix)· 0 asserts readlane/hull/ring σε 1044 archived logs μετά το fix (τελευταίο
  hull assert = TEST11 00:16 27 Σεπ)· upstream main 16 commits μετά το e518a651, ΚΑΝΕΝΑ σε recompiler.cpp/readlane/hull/ring/CP· κανένα
  άλλο PR για το ίδιο (#5074 ήδη μέσα). Από ανάγνωση: ακριβής προώθηση WriteLane→ReadLane· η σειρά = του upstream ΠΡΙΝ το #2667 (1f9ac53c,
  Μάρ 2025, στόχος phis όχι θέση). ⚠ Προϋπάρχον κενό στο pass: το `IsPossibleToEliminate` ΔΕΧΕΤΑΙ ReadLane μέσα στο δέντρο phi, το
  `GetRealValue` όχι → UNREACHABLE· με το 2ο CP ένα lane που γίνεται immediate μπορεί θεωρητικά να το φτάσει (καμία εμφάνιση). Επίσης το
  `SearchChain` κάνει `.U32()` στο lane του WriteLane χωρίς έλεγχο immediate (προϋπάρχον). Cache versions = μόνο format → παλιό cache
  κρατά παλιό SPIR-V (γι' αυτό τα άλλα παιχνίδια ΚΡΥΑ). A/B για άλλα παιχνίδια: `backup_exe\shadps4_test20c_14a1ba6b_gt7.exe` (χωρίς) vs
  `shadps4_test21_b5cace01_gt7.exe` (με) = διαφέρουν ΜΟΝΟ σε αυτό το commit· χρειάζονται launchers για το άλλο παιχνίδι (go χρήστη).
⚠⚠⚠ **28 Σεπ 23:41 (20:41Z) — #5165 MERGED upstream (fca10b26, raphaelthegreat: «This seems faster than always splitting so
  merging this for now»)· το #5166 ΚΛΕΙΣΤΗΚΕ ΧΩΡΙΣ merge 4 s μετά, χωρίς σχόλιο.** Τελικά heads 3b8aca53 / 56027bf7 = ακριβώς τα
  `refs/remotes/pr/5165|5166` που δοκιμάσαμε. Χρήστης: «never mind this pr was merged already» → η αναφορά = ιστορικό (σημειωμένο
  στην κορυφή της)· ΑΚΥΡΩΝΟΝΤΑΙ counter build και μέτρηση ταχύτητας. Ανοιχτά, όλα με go χρήστη: TEST28 (texture cache· η βάση του, το
  build του #5165, έχει πλέον την ίδια αλλαγή με το upstream), PushUd (παρκαρισμένο «μέχρι να τελειώσει το review» = τελείωσε), sync vs
  async. Το σχόλιο του χρήστη στο #5165 (17:46Z «i will test and report back») έμεινε χωρίς απάντηση· το αποτέλεσμα αν το θέλει:
  γλυφές και device lost αμετάβλητα. Ο 8c ΔΕΝ ενημερώθηκε (όχι checkout/build θέμα).
  23:55 (χρήστης: «what fixes do we use ... not pushed for pr yet?») — builds (8b967597) έναντι PR, με diff από το API: #5114 ίδιες
  +/- γραμμές (άλλο patch-id μόνο από context), #5137 / #5150 ίδιο patch-id, #5155 ίδιος κώδικας (το 745d7716 έχει + σχόλιο 2 γραμμών),
  #5131 merged e0cd957a = 7f8b5076 (patch-id 99fcc3be) → φεύγει με το επόμενο base. ΧΩΡΙΣ PR: b5cace01 readlane (το
  mine/tess-readlane-first = ΠΑΛΙΟ one-liner, patch-id 8443dcd0 + web merge commit), b1dcd894 BC macro-tiled (τοπικό, ΟΧΙ πλήρες),
  bca257a6 T# format/swizzle (τοπικό, ΕΛΛΙΠΕΣ). Εκτός builds: clamplog 10baa842, 3 GoW. Τα commits του mine ΔΕΝ είναι σε κανένα τοπικό
  clone (ούτε clean ούτε GitHub\shadps4) → σύγκριση μόνο μέσω API diff.
⚠⚠⚠ **28 Σεπ ~23:45 — ΑΝΑΦΟΡΑ για τα #5165/#5166 (χρήστης: «i want a full report on both prs tests runs»):**
  `C:\shadps4-gt7\GT7_upstream\REPORT_PR5165_PR5166.md` — όλα τα runs TEST25/26/27/27b (πίνακες ανά build και ανά run), βάση
  (8b967597 = upstream e518a651 + 8 δικά μας fixes + 3 GT_DIAG), patch-id tested = PR heads, caveats (λίγα runs, blocks, timing του
  check), τι ΔΕΝ μετρήθηκε. ⚠ Τα log lines ΔΕΝ έχουν timestamps → FPS από τα υπάρχοντα logs ΑΔΥΝΑΤΟ (το είχα υποσχεθεί λάθος).
⚠⚠⚠ **28 Σεπ ~23:15 — TEST27b ΞΑΝΑΧΤΙΣΜΕΝΑ (go χρήστη: «Rebuild both» + «Colored window»).** Review 8c: το `GtRangeHash`
  διάβαζε το guest range ΑΠΕΥΘΕΙΑΣ από το VA, ενώ το upload περνά από `CopySparseMemory` (memory.cpp:147-162: σελίδες 16 KB μέσω
  `BackingPages()`, μηδενικά όπου δεν υπάρχει backing) → σελίδα χωρίς backing ή μη αναγνώσιμη = fault ΜΕΣΑ στο instrument. Και τα 3 runs
  των ΠΑΛΙΩΝ builds (pr5165 r1-r2, pr5166 r1) σταμάτησαν στο ίδιο draw, το TEST26 χωρίς το commit πέρασε 5/5 (8c:
  `logs\test27b_runs_1_3_audit.txt`). Fix: hash ανά σελίδα 16 KB μέσω `Core::Memory::Instance()->GetAddressSpace().BackingPages()`,
  static 16 KB μηδενικά για τρύπες, `HashCombine` των hash ανά σελίδα· το guest VA δεν διαβάζεται ποτέ. Amend του ΕΝΟΣ 27b commit
  (ίδιος τίτλος, χωρίς trailer), τα παλιά σε tags `test27b-pr5165-v1` (96aad9aa) / `test27b-pr5166-v1` (329a88b2).
  `test27b-pr5165` **f2a5983c** (3 βήματα, exe FBD8FE40…A5A3, pdb A3533974…4405)· `test27b-pr5166` **e9e8a11a** (33 βήματα, exe
  A81C9882…88F3, pdb EE35D8C8…2897)· NINJA_EXIT=0, clang-format 0. Checkout τώρα: test27b-pr5166. 8c: notice + details.
  Audit 8c `logs\test27b_rebuild_audit.txt` ΟΚ (patch-id b859fe6b4fd7 και στα δύο, επαληθευμένο)· armed
  `test27b_pr5165_f2a5983c_gt7_1` + `test27b_pr5166_e9e8a11a_gt7_1`· το (2) το απέσυρε.
  **Rebuilt r1 (f2a5983c, 22:56:57-22:58:53): το freeze του v1 ΕΦΥΓΕ** (το draw συνεχίζει) → η αιτία ήταν το VA read. Τέλος: device
  lost, exit 0x80000003 (8c: `logs\test27b_rebuild_run_1_audit.txt`). Stale 6 = 4 από τον έλεγχο των πρώτων 64 bytes + 2 round-robin,
  όλα R8Unorm πλάτους 64, tile_mode 8· ΕΝΑ πέφτει στην οθόνη με τα λάθος γράμματα της φωτογραφίας του χρήστη (πρώτος άμεσος σύνδεσμος).
  Επόμενο (αν το πει ο χρήστης): έλεγχος MaybeCpuDirty σε ΟΛΗ την εικόνα αντί για τα πρώτα 64 bytes — πρώτα upstream PRs/issues.
  **Rebuilt pr5165 r2-r5: ΚΑΙ ΤΑ 4 έφτασαν στον αγώνα (TEST26 = ίδιο PR χωρίς το commit: 0/5)** → ΠΡΟΣΟΧΗ: η μόνη διαφορά είναι το
  27b commit (hash σε κάθε upload + round-robin στο GPU thread) = πιθανή αλλαγή timing, ΟΧΙ απόδειξη υπέρ του #5165· δίκαιη σύγκριση
  μόνο 27b-5165 έναντι 27b-5166. Και τα 4 τελείωσαν στο ΙΔΙΟ νέο assert `info.h:183 Info::PushUd` (exit 0x80000003 ×3, 0xC0000005 r5)
  σε tessellated draws (8c: `logs\test27b_rebuild_run_2_audit.txt`, `…runs_3_5_audit.txt`, επαληθευμένα). Αιτία (διαβασμένη): ΕΝΑ
  `Bindings` για όλα τα stages (vk_rasterizer.cpp:639-647), τα user-data regs όλων μπαίνουν σε ΕΝΑ block των 16 (resource.h:14) → LS+HS+
  VS+FS μαζί > 16. Ούτε το #5165 ούτε το commit αγγίζουν αυτόν τον κώδικα· φαίνεται τώρα γιατί τα runs πάνε πιο βαθιά (νέα shaders).
  Rebuilt pr5166 r1 (23:10:25): αγώνας, ΙΔΙΟ assert (επαληθευμένο) → 5/5 αγώνες στα rebuilt τελειώνουν εκεί. Και το pause στον αγώνα
  το προκαλεί αμέσως. **ΠΑΡΚΑΡΙΣΜΕΝΟ από τον χρήστη μέχρι να τελειώσει η αξιολόγηση #5165/#5166.** Upstream (28 Σεπ): origin/main
  197655f8 έχει ακόμα 16, κανένα commit από το 8b967597· μόνο τα παλιά κλειστά #1013 (UD ως push constants) και #1032 («Increase push
  constants user data to full capacity»)· κανένα ανοιχτό PR/issue για το overflow. (`gh` χωρίς login· έψαξα με το public search API.)
  Rebuilt pr5166 r2: device lost ΠΡΙΝ τον αγώνα (όπως TEST27 r4)· r3: 87 s αγώνα → `liverpool.cpp:256` «Unimplemented PM4 type 0, base
  reg: 0, size: 1» (υπάρχει ήδη σε TEST15/17c/17d/18/21, πριν από τα PR). ΤΕΛΙΚΟ rebuilt, 5 runs το καθένα (5165 / 5166): αγώνας
  4 / 2 · DL πριν τον αγώνα 1 / 2 · PushUd στον αγώνα 4 / 1 · PM4 type 0 0 / 2 (r3 στον αγώνα, r5 πριν). PM4 type 0 στα TEST25-27: 0/14.
  Όλα επαληθευμένα. Stale reports (όλα τα 27b): 71 = 34 μονοσέλιδες εικόνες που κράτησε ο έλεγχος 64 bytes + 37 πολυσέλιδες ΜΕΡΙΚΩΣ
  watched (UntrackImageHead/Tail) → δύο τρύπες στο InvalidateMemory· πρόταση TEST28 = TEST27b-pr5165 + fix (όταν το πει ο χρήστης). **Τα PR (GitHub):** #5165 «Resolve data corruption issues caused
  by reordering uploads too early», #5166 «Opened so performance of either solution can be compared» — κανένα παιχνίδι· μόνο σχόλιο =
  του χρήστη στο #5165 («could help with a problem with glyphs in GT7. i will test and report back»).
  Υποψήφιο (2) του 8c (δεύτερο lock του texture-cache mutex από το GtCheckStaleImages μέσα σε UpdateImage): ΔΕΝ υπάρχει δρόμος — ο
  ΜΟΝΟΣ caller του `OnSubmit` είναι το liverpool.cpp:141-147 ανάμεσα στα submits· το `Scheduler::Wait→Flush` δεν το φτάνει.
  **Live παράθυρο:** το redirect σε αρχείο ΧΑΝΕΙ τα χρώματα (το spdlog wincolor χρωματίζει μόνο σε αληθινή κονσόλα) → νέο
  `C:\shadps4-gt7\GT7_upstream\live_log_colors.ps1` (140 γρ., SHA256 5802F13D…DBE9): χρώματα του wincolor (Info πράσινο, Debug cyan,
  Warning κίτρινο, Error κόκκινο, Critical λευκό σε κόκκινο), γραμμή pad σε πράσινο φόντο, exit code πράσινο/κόκκινο, ανά file:line
  έως 4/δευτ. + γκρι μετρητής. Launchers `TEST27b_PR5165_GT7_f2a5983c_…`, `TEST27b_PR5166_GT7_e9e8a11a_…` (111 CRLF ASCII, διαφορές
  από TEST25 στις 2-3, 7, 57-58, 96, 103-105)· οι παλιοί στο `GT7_upstream\superseded`· generator: scratchpad `make_test27b_launcher_v2.pl`.
  **Log mode:** lab profile (`AppData\Roaming\shadPS4\config.json`) `sync: true`, TEST profile (`C:\shadps4-test19-gt7\user\config.json`)
  `sync: false`, ίδιο filter. Με GT_DIAG=1 το log.cpp:78-83 (commit 3f6ccec4) κάνει μετά από ΚΑΘΕ Critical flush + `wait_all(500 ms)`
  της ουράς (assert, device lost, unhandled fault γράφουν Critical πρώτα). TEST27 r1: 600.553 γρ. σε ~270 s, 300.082 =
  `vk_rasterizer.cpp:890 BindBuffers` Error από το GPU thread. Σύσταση: async για σύγκριση με TEST25-27· ο χρήστης βρίσκει το sync
  «very good» — ΑΝΟΙΧΤΟ. Εκκρεμούν οι γραμμές του 8c: (a) watchdog προόδου του GPU thread, (b) επαναλαμβανόμενο fault στην ίδια διεύθυνση.

⚠⚠⚠ **28 Σεπ ~22:20 — TEST27b ΧΤΙΣΜΕΝΑ (χρήστης: «make the new run with the asked test ... for both prs»).** ΕΝΑ GT_DIAG commit
  με τα 4 asks του 8c (patch-id 5efa9254fc79), 9 αρχεία +310/−2: (1) `GtNoteScope`/`g_gt_resource_note` (common/gt_assert_hook.h,
  thread_local στο assert.cpp): specialization ForEachSharp, pipeline key color targets, BindTextures, PrepareRenderState color/depth,
  EliminateFastClear → στο assert: «the assert fired while this thread was reading <kind>… raw dwords»· (2) `GtNoteStageHash` μετά
  το GetParams (bind_stage + RefreshComputeKey) + «(its pipeline was still being set up)»· (3) stale-image: `gt_upload_hash/tick` στο
  Image (hash όλου του guest range σε κάθε upload του RefreshImage), round-robin 4 εικόνες/4 MB ανά submit (RunGarbageCollector), max
  200 Warning «[GT_DIAG] stale image (…)». **Υπόθεση για τα λάθος γράμματα:** το MaybeCpuDirty (μικρή εικόνα μέσα σε μία σελίδα,
  untracked από write σε ΓΕΙΤΟΝΙΚΑ δεδομένα) ελέγχει ΜΟΝΟ τα πρώτα ≤8x8 pixels (texture_cache.cpp RefreshImage «check up to 64 first
  pixels») → glyph με ίδια πρώτα bytes κρατά την ΠΑΛΙΑ εικόνα («n»→«r»+κενό). Το instrument το πιάνει ακριβώς εκεί. ΑΠΟΔΕΙΞΗ ΟΧΙ ΑΚΟΜΑ.
  `test27b-pr5166` **329a88b2** (= 8b013d3e + commit) 48 βήματα, exe 6C0262C6…CD5A, pdb E2636A3B…FD4D· `test27b-pr5165` **96aad9aa**
  (= 83031bba + ίδιο commit, καθαρό cherry-pick) 59 βήματα, exe 95BC9563…9B27, pdb 8A184FCD…9077· NINJA_EXIT=0, 0 warnings, clang-format
  0. Launchers `TEST27b_PR5165_GT7_96aad9aa_…`, `TEST27b_PR5166_GT7_329a88b2_…` (111 CRLF ASCII, ίδιες 8 γρ.). 8c: switch + details.
  ⚠ Παγίδα: static helper ορισμένη ΜΕΤΑ τη χρήση (GtRangeHash) → τη μετέφερα στην αρχή του αρχείου πριν το build.
⚠⚠⚠ **28 Σεπ ~21:45 — TEST27 runs 1-2 (8c: `logs\test27_build_audit.txt`, `logs\test27_runs_1_2_audit.txt`), επαληθευμένα.**
  r1 έφτασε στον αγώνα (hs 0x27d2194a γρ. 455056, χωρίς assert) → device lost ~76 s μετά (γρ. 600550)· r2 device lost νωρίς (γρ.
  60943) + signals.cpp:144 (60971). Pad 121 και στα δύο. Σύνολο σήμερα: TEST25 3/5 στον αγώνα, TEST26 0/5, TEST27 1/2· device lost
  3/5, 4/5, 2/2 → κανένα PR δεν σταματά το device lost ως τώρα· λάθος γράμματα + μαύρα σχήματα σε ΟΛΑ τα builds. Φωτογραφίες r1 του
  χρήστη στο `logs\user_photos_test27_gt7_1\` (τις έστειλα στον 8c κατ' εντολή του χρήστη). test27_gt7_3 οπλισμένο.
  ~21:50: r3 αγώνας ~11 s → device lost (nvlddmkm 13,13,153 = η in-race υπογραφή του TEST25 r3/TEST18 r6)· r4 device lost στο
  PresentThread πριν τον αγώνα (33/33 Critical εκεί). TEST27 = 2/4 στον αγώνα, 4/4 device lost. Απάντηση στον χρήστη: ΟΧΙ φταίξιμο
  των PR — device lost, λάθος γράμματα (TEST11+) και μαύρα σχήματα υπήρχαν ΠΡΙΝ· κανένα PR δεν αγγίζει το texture cache.
⚠⚠⚠ **28 Σεπ ~21:32 — TEST27 ΧΤΙΣΜΕΝΟ = TEST25 + upstream #5166 (χρήστης: «its time for the next pr test»).** `test27-pr5166`
  **8b013d3e** = 8b967597 + cherry-pick 56027bf7 (patch-id 3f88a867c598 = upstream), buffer_cache.cpp +65/−66, NINJA_EXIT=0, 33
  βήματα, 0 warnings (log scratchpad `build_test27.log`). Exe `backup_exe\shadps4_test27_8b013d3e_gt7.exe` A407DD9B…52F8, pdb
  `pdb_test27_8b013d3e` 5E9E79ED…CB26. Launcher `TEST27_GT7_8b013d3e_warm_diag_console.bat` (111 CRLF ASCII, ίδιες 8 γρ. με TEST26).
  8c: ειδοποίηση πριν το switch + build details. ⚠ Παγίδα: `cmd //c "build_clean.bat > …"` από Git Bash = «not recognized», ΤΙΠΟΤΑ
  δεν χτίστηκε → τρέχε από PowerShell: `cmd /c "C:\shadps4-gt7\GT7_upstream\build_clean.bat > <log> 2>&1"` με TEMP/TMP 8.3.
  TEST26 runs 1-5 + TEST25 r5 (8c: `logs\test26_runs_1_5_audit.txt`): TEST26 0/5 στον αγώνα (4 device lost, 1 tiling.cpp:65 tile
  mode 27), TEST25 r5 device lost στο ίδιο σημείο → TEST25 3/5 σήμερα. Επαλήθευσα: pad γρ. 121 σε όλα, line pointers σωστά, αντίγραφα
  ίδια. ⚠ Χρόνος = confound: ΟΛΑ τα runs μετά τις 20:55 (και των δύο builds) πέθαναν νωρίς· εναλλάξ builds στα επόμενα runs.
  ⚠ Classifier stop 21:1x στην ανάλυση των device-fault reports αυτών των runs: ΜΗΝ την ξαναπαράγεις· μόνο δείκτες σε αρχεία.
⚠⚠⚠ **28 Σεπ ~20:56 — ο ακριβής μηχανισμός του bug #5165/#5166 + audit του TEST26 από 8c.** Κάθε session = upload cmdbuf +
  primary, και το SubmitExecution τα βάζει upload ΠΡΙΝ από primary ΑΝΑ session (vk_scheduler.cpp:206-211). Στο 8b967597 το
  FlushSyncBatch κάνει `if (copies.empty()) return;` ΠΡΙΝ το BeginSession → fence (EventWriteEos/Eop, ReleaseMem, WriteData με
  !wr_one_addr) με άδειο batch ΔΕΝ ανοίγει νέα session → uploads μετά το fence μπαίνουν στο upload της ΙΔΙΑΣ session και τρέχουν πριν
  από draws του πριν-το-fence. #5166 (56027bf7, «Always split command buffers on possible fences», body: sister PR του #5165 «so
  performance of either solution can be compared») = μόνο αυτό το early return → BeginSession σε ΚΑΘΕ fence. #5165 = copy επί τόπου
  μέσω Runtime::CopyBuffer, που κάνει EndRendering ανά upload. Κόστος: #5166 split ανά fence, #5165 render-pass break ανά upload.
  `git merge-tree --merge-base=56027bf7~1 8b967597 56027bf7` = καθαρό. 8c: TEST26 ίδιο με upstream, test26_gt7_1 οπλισμένο
  (`logs\test26_build_audit.txt`). Σημείωσή του επαληθευμένη ΜΕ ΔΙΟΡΘΩΣΗ: στο TEST25 ΕΝΑ SynchronizeMemoryFromImage ανά read-only
  texel buffer (ObtainBuffer:186, από #5100)· το #5165 ΠΡΟΣΘΕΤΕΙ δεύτερο μέσα στο SynchronizeMemory (:351) → διπλό ίδιο copy/fill
  στο TEST26, ίδιο αποτέλεσμα, επιπλέον κόστος μόνο στην πλευρά του #5165 (σύγκριση FPS).
⚠⚠⚠ **28 Σεπ ~20:47 — TEST26 ΧΤΙΣΜΕΝΟ = TEST25 + upstream #5165 (χρήστης: «lets test both of them first pr 5165»).**
  `test26-pr5165` **83031bba** = 8b967597 + cherry-pick του 3b8aca53 «video_core: Remove batching» (author raphaelthegreat, patch-id
  8fc0f1c8b322 = ίδιο με το PR), 6 αρχεία +36/−145, NINJA_EXIT=0, 33 βήματα, 0 warnings. Exe `backup_exe\shadps4_test26_83031bba_gt7.exe`
  9038A847…C99E, pdb `pdb_test26_83031bba` C4402FE2…C6DE. Launcher `TEST26_GT7_83031bba_warm_diag_console.bat` (111 CRLF ASCII, 8 γρ.).
  8c: ειδοποίηση πριν το switch + build details. Επόμενο: TEST27 = TEST25 + #5166 (56027bf7) ως SIBLING (το #5165 σβήνει τον κώδικα
  του #5166). ⚠ Χρήστης 20:58: πρώτα μερικά runs του TEST26, μετά runs με #5166 — το TEST27 χτίζεται ΜΟΝΟ όταν το πει. Refs `upstream-pr5165`/`upstream-pr5166` τοπικά. Asks 8c από run 4 (`logs\test25_run_4_audit.txt`): (1) ποιο resource
  (image/formatted buffer/colour target, stage, binding, πεδία sharp) πριν το UNREACHABLE του MapNumberConversion στα 3 μονοπάτια
  pipeline setup (specialization.h:143/:125, vk_pipeline_cache.cpp:431)· (2) stage hashes στο per-thread work record μόλις τα έχει το
  pipeline key — ΜΕΤΑ τα δύο PR tests.
⚠⚠⚠ **28 Σεπ ~20:35 — upstream #5165 / #5166 (raphaelthegreat, ανοιχτά, ίδιο bug):** το buffer cache μαζεύει uploads (`sync_batch`,
  buffer_cache.cpp:184) και τα γράφει στο upload cmdbuf που τρέχει ΠΡΙΝ από τη δουλειά της ΙΔΙΑΣ session (ακριβώς: 20:56) → σε fence (OnFence,
  vk_rasterizer.cpp:511) παλιότερη δουλειά διαβάζει νεότερα δεδομένα. #5165 = καταργεί το batching (+36/−145, 6 αρχεία), #5166 =
  split του cmdbuf σε ΚΑΘΕ fence. Και τα δύο `git apply --check` = 0 στο test25-diag3. Πρόταση: TEST26 = TEST25 + #5165 (A/B στο
  ποσοστό device lost· TEST25 2/4). Upstream PR μας: ανοιχτά #5114, #5137, #5150, **#5155 (preload)**· merged #5070/#5126/#5131.
  Χωρίς PR: readlane-early b5cace01 (αντικαθιστά το tess-readlane-first στο mine), bc-macro-tiled, tsharp-check (ΕΛΛΙΠΕΣ: test25_gt7_4
  = Bc6/SnormNz assert στο pixel_format.h:359 επειδή το specialization.h:143 διαβάζει κάθε T# ΠΡΙΝ το check), clamplog, 3 GoW.
⚠⚠⚠ **28 Σεπ ~19:40 — TEST25 ΧΤΙΣΜΕΝΟ = τα 3 asks του 8c (go χρήστη: «first the implementation of the new asked tools»).**
  `test25-diag3` **8b967597** = e7afc20d + 1 commit «[test] Log the last real GPU tick, the memory next to a faulting page and
  the work in flight when GT_DIAG is set» (4 αρχεία +327/−25, clang-format 19 = 0, NINJA_EXIT=0, 45 βήματα, 0 warnings).
  (1) `Semaphore::GtNoteCounter` στο Refresh (ΠΡΙΝ το early return, μόνο με `GtDiagEnabled()`): τελευταίο πραγματικό tick
  (< CurrentTick, CAS max, ποτέ πίσω) + ώρα, 1η τιμή που δεν είναι tick + ώρα· `GtNowUs` βγήκε από το anon namespace (vk_instance.h).
  (2) GtLogAddressOwners: όταν τίποτα δεν καλύπτει τη σελίδα → πλησιέστερα live/unbound από κάτω/πάνω με signed απόσταση.
  (3) γραμμή «GPU counter:» + τα 16 entries κρίνονται με το last real tick + `GtLogInFlight`: μία γραμμή/tick (≤16, «and N more»,
  rewritten μετρημένα, γραμμή αν τα 32768 δεν φτάνουν πίσω, «submit started»/«still being recorded»). Exe
  `backup_exe\shadps4_test25_8b967597_gt7.exe` A58282C3…A736, pdb `pdb_test25_8b967597` 038B292B…BCBC. Launcher
  `TEST25_GT7_8b967597_warm_diag_console.bat` (111 CRLF ASCII, 8 γρ. διαφορά από TEST24, GT_DIAG=1 μόνο). ⚠ Το scm_rev είναι
  ΑΔΕΙΟ σε αυτό το build: το exe δεν κουβαλά commit id (μετά το commit: ninja «no work to do»). 8c: ειδοποίηση πριν το switch +
  build details + απαντήσεις στα 5 audit points του (διαφορά: tick = τιμή < CurrentTick, όχι «μόνο 2^64−1»). **Audit 8c ΠΕΡΑΣΕ
  (5/5, «nothing to change»· ο κανόνας < CurrentTick κρίθηκε σωστός), test25_gt7_1 ΟΠΛΙΣΜΕΝΟ (watcher + catcher)**.
  test25_gt7_1 έτρεξε (20:11→20:12:58, exit 0x80000003, audit 8c): report στο `logs\shad_log_test25_gt7_1_at_exit_201314.txt`
  γρ. 88294-88464. test25_gt7_2 (20:14:09→20:18:17): exit 0xC0000005, κανένα device lost/GPU event, pad OK· μόνη Critical =
  signals.cpp:144 unhandled exception σε guest thread (`shad_log_test25_gt7_2_at_exit_201832.txt` γρ. 816430), «Cache dumped»
  μετά· hs 0x27d2194a compiled χωρίς assert (γρ. 257162). test25_gt7_3 (20:19:15→20:21:15, exit 0x80000003, nvlddmkm 13,13,153
  στις 20:21:13.877, 33/33 Critical): report γρ. 278112-278168 → **WriteInvalid στη GPU διεύθυνση 0x0** (σελίδα 0x0-0xfff),
  κανένα range ποτέ, πλησιέστερο live 106 MiB πάνω· last real tick 8417 και 1η 2^64−1 στην ίδια ανάγνωση, 349 ms πριν το report·
  in flight 8418 (1612) + 8419 (3 dispatches), 8420 (1633) ακόμα σε recording. Το DMA path (uses_dma, ReadConst) μόνο ΔΙΑΒΑΖΕΙ →
  δεν δίνει WriteInvalid. Πρόταση: run με GT_GPU_CHECKPOINTS=1 + GT_DIAG=1 (ίδιο exe, μόνο launcher) — απόφαση χρήστη.
  test25_gt7_4 ξεκίνησε 20:22.
⚠⚠⚠ **28 Σεπ ~19:10 — TEST24 run 1 (test24_gt7_1) ΕΠΑΛΗΘΕΥΜΕΝΟ έναντι των logs (audit 8c `logs\test24_run_1_audit.txt`).**
  19:02:29→19:05:20.9, exit 0x80000003 μετά το «Cache dumped», pad γρ. 121, GT_DIAG γρ. 101, 24/24 Critical (αρχείο = κονσόλα),
  nvlddmkm 153 στις 19:05:19.644 (όχι 13/4101). Device lost (submit, PresentThread): WriteInvalid **0x4a6008000** (TEST23 r1:
  0x4a6002000 — ίδιο 64 KiB block, 24 KiB απόσταση). Binding report πλήρες (7017 binds, 2132 unbinds, 0 dropped, history όχι
  γεμάτο) και **κανένα range, live ή unbound, δεν κάλυψε ποτέ τη σελίδα**. ⚠ Ελάττωμα ΤΟΥ ΔΙΚΟΥ ΜΟΥ instrument: μετά την απώλεια ο
  driver δίνει counter 2^64−1 με eSuccess, το `Semaphore::Refresh` (μόνος writer του gpu_tick) το αποθηκεύει → τα 16 entries (όλα
  tick 7812, ένα command buffer) γράφουν «finished» ψευδώς. Asks 8c για TEST25: (1) GT_DIAG side copy στο Refresh του τελευταίου
  πραγματικού tick (< CurrentTick), αλλιώς «unknown» (+ δική μου πρόταση: ώρα της 1ης ανάγνωσης 2^64−1)· (2) όταν τίποτα δεν
  καλύπτει τη σελίδα, τα πλησιέστερα live/unbound ranges από κάτω και πάνω με απόσταση· (3) μία γραμμή ανά tick για ό,τι
  καταγράφηκε μετά το τελευταίο γνωστό finished tick (tick, πλήθος, πρώτο/τελευταίο #, draws/dispatches). test24_gt7_2 ΟΠΛΙΣΜΕΝΟ
  από τον 8c (19:12 δεν είχε ξεκινήσει). Εκκρεμεί go χρήστη για TEST25· αν τρέξει πρώτα το run 2, build ΜΕΤΑ.
⚠⚠⚠ **28 Σεπ ~18:15 — TEST24 ΧΤΙΣΜΕΝΟ = τα 4 κενά log του 8c (`logs\test23_runs_1_2_audit.txt`), go χρήστη «yes».**
  `test24-diag2` **e7afc20d** = 3f6ccec4 + 1 commit «[test] Log the owner of a faulting page, finished GPU work and bad image
  barriers when GT_DIAG is set» (7 αρχεία, +358/−18, clang-format 0, NINJA_EXIT=0, 44 βήματα, 0 warnings). GT_DIAG μόνο:
  (1) image.cpp GetBarriers: Critical ΠΡΙΝ το ASSERT(subres_idx < states.size()) — layout, idx/level/layer, states.size(), partial
  range ή «full range over split image», info.resources, ταυτότητα image (uid, guest addr/size, type, format, WxHxD, L×A, samples,
  tile)· (2) image.cpp:170 + Error με ίδια ταυτότητα (ίδιο uid) + το draw του νήματος (`GtDescribeCurrentWork`, vk_rasterizer.cpp)·
  (3) VK_EXT_device_address_binding_report + δικός του messenger (δημιουργείται ΠΡΙΝ το device) → GtBindingLog (mutex, live ≤2^18,
  names ≤2^18, unbound ring 2^14, drops μετρημένα)· στο device lost κάθε Read/Write/ExecuteInvalid → live + πρόσφατα unbound ranges
  της σελίδας με το debug name του emulator (hook στο SetObjectName, vk_platform.h: images/buffers/memory)· (4) κάθε journal entry
  κρατά scheduler.CurrentTick()· στο device lost KnownGpuTick() (ΧΩΡΙΣ query/wait) → finished / not known finished. Ένας αναγνώστης
  GT_DIAG: `Common::GtDiagEnv()` (gt_assert_hook.h, και στο log.cpp). Χωρίς GT_DIAG = TEST23 off. Exe
  `backup_exe\shadps4_test24_e7afc20d_gt7.exe` C5A0EC84…4B78, pdb `pdb_test24_e7afc20d` 92D4CBD1…29EB. Launcher
  `TEST24_GT7_e7afc20d_warm_diag_console.bat` (111 CRLF ASCII, 8 γρ. διαφορά από TEST23, GT_DIAG=1 μόνο). 8c ειδοποιήθηκε πριν το
  switch + με τα 5 σημεία του. **Audit 8c ΠΕΡΑΣΕ (5/5), test24_gt7_1 ΟΠΛΙΣΜΕΝΟ**· εκκρεμεί run χρήστη. Σημ. 8c για αργότερα (καμία
  αλλαγή τώρα): το όνομα φεύγει στο 1ο unbind (2ο range ίδιου handle = χωρίς όνομα)· live range χωρίς unbind μένει live· το
  GT_DIAG πλέον προσθέτει 1 extension + 1 feature + messenger στη δημιουργία device (το GPU command stream ίδιο).
⚠⚠⚠ **28 Σεπ ~08:55 — TEST23 ΧΤΙΣΜΕΝΟ = instrument για τα 3 κενά log του 8c (go χρήστη: «yes»· ΝΕΟΣ κανόνας στο CLAUDE.md:
  «όταν το log δεν δίνει ό,τι χρειάζεται η ανάλυση, διόρθωσε το log» με GT_*).** `test23-diag` **3f6ccec4** = bca257a6 + 1 commit
  «[test] Log device faults, recent GPU work and the draw behind an assert when GT_DIAG is set» (9 αρχεία, +471/−3, clang-format 0).
  GT_DIAG: (1) μετά από Critical → logger->flush + async_sink::wait_all(500 ms) (το spdlog async_sink γράφει κονσόλα ΠΡΙΝ το αρχείο,
  το αρχείο κάνει flush μόνο όταν ζητηθεί)· (2) σε device lost (scheduler submit, buffer_cache sparse bind, presenter ×2):
  VK_EXT_device_fault report + summary μνήμη/instruction pointers + τα 16 τελευταία draws/dispatches από journal (32768 entries,
  όλα atomic, seqlock ανά entry)· (3) assert → hook στο assert_fail_impl ΠΡΙΝ το Shutdown: το draw/dispatch που στηνόταν στο νήμα
  (thread_local, ξεκινά ΠΡΙΝ το GetGraphicsPipeline → assert στη μεταγλώττιση = «pipeline not built yet»). GT_GPU_CHECKPOINTS:
  NV checkpoints ανά draw (marker = seq<<32 | primary hash, ID όχι διεύθυνση), ΞΕΧΩΡΙΣΤΟΣ διακόπτης. Χωρίς διακόπτες = TEST22
  (μόνο ένα επιπλέον query του FaultFeatures). Κώδικας από το παλιό gt7-main (LogDeviceFaultInfo/GT_GPU_CHECKPOINTS), λιτός.
  Build 42 βήματα, NINJA_EXIT=0, 0 warnings. Exe `backup_exe\shadps4_test23_3f6ccec4_gt7.exe` 888DCEF0…D559, pdb
  `pdb_test23_3f6ccec4` B81D2C91…D733. Launcher `TEST23_GT7_3f6ccec4_warm_diag_console.bat` (GT_DIAG=1 μόνο, γρ. 6). 8c ειδοποιήθηκε
  πριν/μετά. **Audit 8c ΠΕΡΑΣΕ (5/5 σημεία, hashes, launcher 111/111 CRLF), watcher + catcher ΟΠΛΙΣΜΕΝΟΙ για test23_gt7_1**· εκκρεμεί
  run χρήστη. **Runs 1+2 (επαληθευμένα από d9 στα logs + event log):** και τα δύο exit 0x80000003 (int3 του assert ΜΕΤΑ από
  καθαρό Shutdown, «Cache dumped»), pad γρ. 120, Critical αρχείο = κονσόλα (23/23, 2/2) → το flush δουλεύει. r1: device lost
  (submit, PresentThread), nvlddmkm 153 08:58:14.250· fault report = 1 WriteInvalid 0x4a6002000, χωρίς owner· last-16 ok·
  ΚΑΝΕΝΑ hook line = σωστό (το hook σωπαίνει σε νήμα που δεν έστησε ποτέ draw). r2: hs 0x27d2194a καθαρό (3/3 runs), μετά
  ~52 s image.cpp:259 ASSERT(subres_idx < subresource_states.size()) χωρίς μήνυμα (GetBarriers, partial transition εκτός
  levels×layers)· hook: draw count 3, fs 0x2a265dff vs 0x610d64f (υπάρχει και στο last-16 του r1, συχνό draw)· 12 γρ. πριν το
  ΜΟΝΑΔΙΚΟ image.cpp:170 (Bc2UnormBlock 1D not supported, δημιουργείται παρ' όλα αυτά). 8c: 4 κενά log στο
  `logs\test23_runs_1_2_audit.txt` (1 ταυτότητα image+range στο :259, 2 ίδια ταυτότητα+draw στο :170, 3 owner της σελίδας μέσω
  VK_EXT_device_address_binding_report [υπάρχει στη GPU], 4 tick ανά journal entry + τελευταίο γνωστό GPU tick). Πρόταση d9:
  TEST24 = 3f6ccec4 + 1 commit με όλα τα 4, GT_DIAG μόνο — ΑΝΑΜΕΝΕΙ go χρήστη. ⚠ Για μελλοντικό checkpoint run: ο launcher θέλει ΚΑΙ GT_DIAG=1 ΚΑΙ GT_GPU_CHECKPOINTS=1 — μόνο του το checkpoints
  κρατά journal + hook, αλλά χωρίς VK_EXT_device_fault και χωρίς flush των Critical (το log.cpp διαβάζει μόνο GT_DIAG).
⚠⚠⚠ **28 Σεπ ~08:10 — TEST22 ΧΤΙΣΜΕΝΟ (go του χρήστη στο chat d9: «ok make the test»).** `test22-tsharp-check` **bca257a6** =
  b5cace01 + 1 commit «vk_rasterizer: Reject T# with an unsupported format or component swizzle» (+23/−5 σε liverpool_to_vk.cpp/.h +
  vk_rasterizer.cpp, clang-format 19 = 0). BindTextures απορρίπτει ΚΑΙ όταν `LiverpoolToVK::IsSurfaceFormatSupported(dfmt, nfmt)` = false,
  ή, ΜΟΝΟ για μη-storage (= image_view.cpp:69, η μόνη κλήση ComponentMapping), όταν `IsComponentMappingSupported(DstSelect())` = false
  (τιμές 2/3)· το warning τυπώνει ΚΑΙ type/height/dst_sel. Build 12 βήματα, NINJA_EXIT=0, 0 warnings. Exe
  `backup_exe\shadps4_test22_bca257a6_gt7.exe` SHA256 61C14528…C883, pdb `pdb_test22_bca257a6` 4DC10A2A…9E9F. Launcher
  `TEST22_GT7_bca257a6_warm_console.bat` = το warm του TEST21 με 6 γραμμές αλλαγμένες (exe, ονόματα logs, echo). ⚠ Το sed του Git Bash
  ΑΦΑΙΡΕΣΕ τα CR από τις γραμμές που πέρασαν (106 σκέτα LF) → CRLF με PowerShell, έλεγχος με bytes. Checkout = test22-tsharp-check
  (8c ειδοποιήθηκε πριν το switch και πήρε τα στοιχεία μετά). Audit 8c OK (ίδιος πίνακας με το SurfaceFormat, ίδια accessors με το ImageInfo, CompSwizzle = ακριβώς οι 6 τιμές,
  is_written = is_storage, hashes/bytes/CRLF ελεγμένα)· test22_gt7_1 ΟΠΛΙΣΜΕΝΟ (watcher + catcher).
  **Runs (αναφορές 8c, επαληθευμένες):** _1 (pad OK): 52 T# απορρίψεις (23 με dst_sel 2/3), 0 asserts SurfaceFormat/ComponentSwizzle·
  τέλος πριν τον αγώνα = address_space.cpp:552 «addr 0x0 out of bounds» μετά από `Tracking memory region 0x0 - 0x2000` (γνωστή κλάση:
  T16 r1, T17c r1, T17d r5· μόνο το texture cache καλεί UpdatePageWatchers, texture_cache.cpp:844/867, και το BindTextures δίνει null
  σε T# με address 0 → εικόνα στο 0 από άλλο μονοπάτι). _2 (pad OK): ΑΓΩΝΑΣ, hs 0x27d2194a χωρίς assert (γρ. 565152), .spv byte-ΙΔΙΟ με
  του test21_gt7_2 (4FD635A7…788F) = 2ο πέρασμα του σημείου· 306 T# + 1047 S# απορρίψεις, 0 asserts της κλάσης· τέλος = το ΓΝΩΣΤΟ
  reset του αγώνα (id 13 WIDTH CT Violation (0x4,0x0) + ESR 0x80000010/0x4/0xf00 + 153, 08:22:15.04· SanitizeCopyLayers 8→48 215
  γραμμές πριν), 0xC0000005. Εκκρεμεί: test22_gt7_3 (οπλισμένο), «κανένα άλλο παιχνίδι χειρότερα» για τα δύο PR (επιλογή χρήστη).
⚠⚠⚠ **28 Σεπ ~07:15 — #5114 PUSHED ΑΠΟ ΤΟΝ ΙΔΙΟ τον χρήστη** (δική του κονσόλα, `git -C C:\shadps4-clean push --force-with-lease`,
  «forced update» 025e200f...0bcca4b8). API: head 0bcca4b8, 1 commit, 4 αρχεία, +34/−1, mergeable=True (CI σε εξέλιξη).
  Σχόλιό του στο PR για το GTA V: γεγονότα ελεγμένα (0 F64 VOP1/VOPC στα 859 shaders, ίδιο SPIR-V, 54 tests 0 failures).
⚠⚠⚠ **28 Σεπ ~06:55 — #5114 ΞΑΝΑ-ΛΥΜΕΝΟ ΤΟΠΙΚΑ, ΟΧΙ PUSHED.** Χρήστης: «5114 had conflicts with main ... make and push it».
  Νέα σύγκρουση: το #5030 (282e5c79) πρόσθεσε 2 tests `addc_u32_*` στο ΤΕΛΟΣ του tests/gcn/test_gcn_instructions.cpp, όπως το PR
  (append/append). **0bcca4b8** = ΕΝΑ commit πάνω στο origin/main **4cbd23ef**, μόνο τίτλος (το body του 11d8b765/75f39d66
  έφυγε, κανόνας title-only), author = noreply + ημερ. 25 Σεπ, +34/−1 σε 4 αρχεία, +/- γραμμές ΙΔΙΕΣ με το 75f39d66, κρατά ΟΛΑ
  τα tests (subb, addc×2, floor_f64), clang-format 19 χωρίς νέες διαφορές. Script `pr5114_rebuild.sh` (scratchpad b4526947),
  plumbing, checkout του clean ΑΝΕΠΑΦΟ. Head του PR στο mine = 025e200f (11d8b765 + 6 web merges, κανένα commit maintainer).
  Το `push --force-with-lease=...:025e200f mine 0bcca4b8:refs/heads/f64-literal-high-dword` το ΑΡΝΗΘΗΚΕ ο classifier
  (Git Destructive) → απόφαση χρήστη: να το τρέξει ο ίδιος / να δώσει άδεια, ή resolve στο GitHub web (κράτα και τα δύο).
⚠⚠⚠ **28 Σεπ ~00:45 — TEST21 ΠΕΡΝΑ ΤΟ ΣΗΜΕΙΟ ΣΤΟ GT7 (3 warm runs, αναφορές 8c).** test21_gt7_2: έφτασε στον αγώνα, το hs
  0x27d2194a μεταγλωττίστηκε ΧΩΡΙΣ assert (TEST11 χωρίς fix: «patch addr non imm»)· το .spv = byte-ΙΔΙΟ με του TEST19b (tess
  one-liner), SHA256 4FD635A7…788F. Τέλος 85k γραμμές αργότερα στον αγώνα: liverpool.cpp:256 PM4 type 0 (όπως το test20a_gt7_5 στο
  boot), 0xC0000005. test21_gt7_1: SurfaceFormat 19/9 (liverpool_to_vk.cpp:788) πριν τον αγώνα = ίδιο κείμενο με το test19b_gt7_1
  (TEST19b κρύο) → όχι του TEST21. test21_gt7_3: liverpool_to_vk.cpp:428 ComponentSwizzle unreachable μία γραμμή μετά το «Rejecting
  invalid S#» (κλάση c2). Άρα 2/3 = κλάση «άκυρο T#» της βάσης. Σύγκριση ΠΕΡΙΕΧΟΜΕΝΟΥ (`spvcmp_t21.ps1` + `compile_lines_t21.ps1`,
  scratchpad b4526947): cache του test21_gt7_2 = `cache_before_launch_20260928_003939` (1177 spv) έναντι REFB `_20260927_204827`:
  613 νέα blobs, 496 byte-ίδια· 12 shaders μόνο με ΕΠΙΠΛΕΟΝ permutations (κάθε blob του TEST19b αναπαράγεται ακριβώς· διαφορά =
  ακριβώς το πλήθος των επιπλέον, που μεταγλωττίστηκαν σε σημεία του αγώνα όπου το TEST19b δεν έφτιαξε νέο permutation)· 0x2a265dff
  15/30 ίδια = γνωστός θόρυβος (για ζευγάρωμα χρειάζεται το spec από το .meta· το InfoPersistent γράφεται raw με pointers, το spec
  είναι πριν από αυτό)· 81 shaders που το TEST19b δεν μεταγλώττισε. test20a_gt7_8: το κείμενο του BC assert (image_info.cpp:184)
  μετρημένο, A 5/5. Εκκρεμεί (χρήστης): άλλα παιχνίδια κρύα, προαιρετικά κρύο GT7 / TEST21b, μετά PR branch στο τρέχον main.
⚠⚠⚠ **28 Σεπ ~00:20 — TEST21 = ΟΛΟΚΛΗΡΟ fix της κλάσης readlane (χρήστης: «ok then we make a full fix ... close the problem
  entirely»). ΑΝΤΙΚΑΘΙΣΤΑ το tess one-liner· το PR του tess ΔΕΝ έχει ανοίξει.** Ρίζα (8c το επιβεβαίωσε): το #2667 1f9ac53c
  (Μάρ 2025) έβγαλε το FoldReadLane από το constant propagation και έβαλε το ReadLaneEliminationPass ΜΕΤΑ το RingAccessElimination
  → τα tess/ring passes τρέχουν με readlanes. 8 σημεία θέλουν σταθερά: hull_shader_transform.cpp :180 (MatchImm→UNREACHABLE),
  :397 (MatchImm→ASSERT), :478 ASSERT, :677 ASSERT, :586 `.U32()` ΣΙΩΠΗΛΟ (DEBUG_ASSERT μόνο)· ring_access_elimination.cpp :38
  ASSERT (LS), :114/:117 `.U32()` ΣΙΩΠΗΛΑ (GS). Fix: recompiler.cpp +2 αμέσως μετά το ΠΡΩΤΟ ConstantPropagationPass:
  `ReadLaneEliminationPass(program)` + `ConstantPropagationPass(program.post_order_blocks)`, για ΚΑΘΕ shader· η ύστερη κλήση ΜΕΝΕΙ
  (οι απαλοιφές μόνο αυξάνονται). Το CP = ένα RPO sweep χωρίς case Phi → χωρίς κάτι να απαλειφθεί, και τα 2 νέα passes = no-op
  (συλλογισμός, όχι μέτρηση). `test21-readlane-early` **b5cace01** = test20c-notess 14a1ba6b + 1 commit «shader_recompiler: Eliminate
  readlanes before the tessellation and ring passes», clang-format 19 = 0. Build 11 s, 3 βήματα, NINJA_EXIT=0. Exe
  `backup_exe\shadps4_test21_b5cace01_gt7.exe` SHA256 0E402A73…C945, pdb `pdb_test21_b5cace01` 179BBD1F…22C3. Launcher
  `TEST21_GT7_b5cace01_cold.bat` (= TEST19B cold + console tail του TEST20A· ΚΡΥΟ υποχρεωτικά: cache χωρίς ταυτότητα build).
  Checkout clean = test21-readlane-early (8c ειδοποιήθηκε ΠΡΙΝ). Reference cache TEST19b: `C:\shadps4-test19-gt7\
  cache_before_launch_20260927_204827` (2986, έχει hs 0x27d2194a). ⚠ Σύγκριση .spv ΑΝΑ ΟΝΟΜΑ ΑΚΥΡΗ: ίδια ονόματα από άλλα runs
  διαφέρουν 22/50, 33/91, 11/38, με ΑΛΛΟ ΜΕΓΕΘΟΣ (perm idx 10-13 του 0x2a265dff) → πιθανώς η σειρά permutations αλλάζει ανά run·
  σύγκριση ανά hash ως ΣΥΝΟΛΟ blobs (έλεγχος: 23/25, 52/58, 24/25 ίδια· θόρυβος μόνο σε 6 multi-permutation shaders, κυρίως
  0x2a265dff). Audit 8c OK + ΟΠΛΙΣΜΕΝΑ `test21_gt7_1` (watcher bu5d36bf2, catcher bvh1m0os1, κλειδί = όνομα exe → πιάνει και
  τους δύο launchers). ΝΕΟΣ `TEST21_GT7_b5cace01_warm_console.bat` (= TEST20A console με test21): πρόταση 8c warm ΠΡΩΤΑ, γιατί το
  μόνο κρύο run της βάσης (test19b_gt7_1) σταμάτησε ~107 s στο SurfaceFormat assert liverpool_to_vk.cpp:788 (19/9) στο
  BuddyWindowRoot πριν τον αγώνα· warm = ίδια είσοδος με το control test19b_gt7_2 (το hs 0x27d2194a δεν είναι στο snapshot →
  μεταγλωττίζεται με TEST21). Σειρά = απόφαση χρήστη. Upstream main e0cd957a = #5131 squash (τίτλος «... on the KHR path»)· στο
  νέο main το τοπικό #5131 (7f8b5076) φεύγει από το test stack. Εκκρεμεί: run χρήστη, άλλα παιχνίδια κρύα (επιλογή χρήστη),
  TEST21b instrument (επιλογή χρήστη), μετά PR branch πάνω στο τρέχον main.
⚠⚠⚠ **27 Σεπ 22:42 — PUSHED ΣΤΟ mine ΤΑ 2 PR BRANCHES (preload, tess)· εντολή χρήστη: «the two fixes we can pr them ... you
  commit only to our fork no force push to the main origin».** Τα PR στο upstream τα ανοίγει ο ίδιος (κανόνας upstream: commit,
  PR και review από άνθρωπο που εξηγεί το πρόβλημα)· του έδωσα review στο chat. Ξαναφτιαγμένα με plumbing
  (`make_pr_branches_v2.sh` στο scratchpad της b4526947) πάνω στο νέο origin/main **916dea43** (#5152 = μόνο mesa submodule, κανένα
  σχετικό αρχείο)· το checkout του clean ΔΕΝ άλλαξε (test20c-notess 14a1ba6b).
  - `preload-permutation-ud` **4077b8bf** «video_core: Use each preloaded permutation's own flattened user data» (patch-id b0344bed =
    12cdf269, ίδιο blob 70624499).
  - `tess-readlane-first` **c5a506ad** «shader_recompiler: Eliminate readlanes before tessellation preprocessing» (patch-id 8443dcd0
    = ea4897c6, ίδιο blob a8da3a41).
  - Plain push, όχι force· ls-remote = local. 1 commit, μόνο τίτλος, noreply identity, χωρίς //, GT_, trailer. clang-format **19.1.5**
    = `C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\Llvm\x64\bin\clang-format.exe` (το LLVM στο PATH είναι
    22.1.8 ≠ CI) = 0 σε όλο το αρχείο. Upstream: κανένα PR/issue για τα δύο (search API· το `gh` ΔΕΝ είναι logged in εδώ).
  - Links: `https://github.com/shadps4-emu/shadPS4/compare/main...nikmparis217-ux:shadPS4:<branch>`.
  - **23:5x: ΚΑΙ ΤΑ ΔΥΟ branches στο mine πήραν merge commit από το GitHub web** («Merge branch 'shadps4-emu:main' into …»,
    preload **ad9fb11a**, tess **c7de6f61**, author `<gmail address>` — ΟΧΙ το noreply) πάνω στο νέο upstream main
    **cc3d367e** (#5153/#5154/#5144, τίποτα σε renderer_vulkan/ ή shader_recompiler/). Tree = fix πάνω στο cc3d367e, diff 1 γραμμή,
    ΑΛΛΑ 2 commits → το GitHub προτείνει τον τίτλο από το όνομα branch («Preload permutation ud»). Κανένα PR ακόμα. Επιλογές
    στον χρήστη: (α) ως έχει, (β) rebuild σε 1 commit πάνω στο cc3d367e + force-with-lease ΜΟΝΟ στο mine, (γ) ίδιο σε νέο όνομα
    branch χωρίς force. Περιμένω απόφαση.
  - `bc-macro-tiled` 00fcba63 μένει ΤΟΠΙΚΟ. Κανένα build των ίδιων των PR branches (αρχεία = δοκιμασμένου TEST19b: preload μείον 2
    γραμμές σχολίου, tess byte-ίδιο). Κριτήριο (2) άλλα παιχνίδια: για κανένα ακόμα· tess (−) δεν έφτασε ποτέ στον αγώνα στο TEST20
    → η απόδειξη (1) είναι το TEST11. Το 8c ΔΕΝ ειδοποιήθηκε.
  - Μηχανισμός preload (για ερωτήσεις review): το `NumBindings` (resource.h:168) διαβάζει το T# από το `info.flattened_ud_buf` και με
    `MipStorageFallbackMode::DynamicIndex` δίνει ένα descriptor ανά mip· στο preload το `BuildDescSetLayout` και ο compute ctor το
    καλούν ΑΜΕΣΩΣ μετά τα stages του record (τα buffers παρακάμπτονται με `AmdGpu::Buffer{}`, τα images ΟΧΙ). Το live path κάνει
    `RefreshFlatBuf()` πριν χτίσει (vk_pipeline_cache.cpp:678) και το `RegisterShaderMeta` σώζει το flat buf ΑΝΑ permutation.
⚠⚠⚠ **27 Σεπ ~21:50 — PR BRANCHES ΤΩΝ 3 ΤΟΠΙΚΩΝ FIXES, ΜΟΝΟ ΤΟΠΙΚΑ (builder `gtnikos-d9`· χρήστης: «make seperate prs for
  each fix»). ΚΑΝΕΝΑ push.** Βάση origin/main **bcf083f0** (#5151 = μόνο page_manager.cpp +2). Φτιαγμένα με plumbing (προσωρινό
  index στο scratchpad, `make_pr_branches_v1.sh`), το checkout του clean ΔΕΝ άλλαξε (test20c-notess 14a1ba6b).
  - `bc-macro-tiled` **00fcba63** (−1: `ASSERT(!props.is_block)`, image_info.cpp:184)· patch-id = b1dcd894.
  - `preload-permutation-ud` **12cdf269** (+1). ΧΩΡΙΣ το σχόλιο 2 γραμμών ΚΑΙ χωρίς το body του 745d7716 (ονόμαζε παιχνίδι + hash)·
    το αρχείο = του δοκιμασμένου μείον τις 2 γραμμές σχολίου (diff IDENTICAL), γι' αυτό άλλο patch-id.
  - `tess-readlane-first` **ea4897c6** (+1)· patch-id = 4ce4d7fb.
  - Όλα: 1 commit, μόνο τίτλος, noreply identity, clang-format 19 = 0, χωρίς //, GT_, παιχνίδι. Ονόματα ελεύθερα (local, mine, PR API).
  - Αποδείξεις: preload 3/3 (−) device lost στο SDR, 7/7 (+) περνούν. BC 3/3 (−) πεθαίνουν στην ΠΡΩΤΗ χρήση του fs 0x74f5f10c, 4/4
    (+) τον σχεδιάζουν 119-308 φορές· κείμενο `image_info.cpp:184 Assertion Failed` σε 4 παλιά logs (test3b, test3r, clean171_11/12),
    ίδιο σημείο. SOURCE: το UpdateSize κάνει ήδη mip_w/h σε blocks πριν το tiling call, και ο (de)tiler δουλεύει σε blocks με
    num_bits = bits/block → το assert μπλόκαρε μονοπάτι με σωστές εισόδους. Tess: TEST20C ΑΚΡΙΤΟ (0/3 στον αγώνα· το control
    μεταγλώττισε το hs 0x27d2194a στη γραμμή 199963, το πιο μακρινό C πέθανε στη 151126)· παλιά απόδειξη TEST11 (`patch addr non imm`).
  - Upstream: κανένα PR/issue για τα 3. Ανοιχτό #4720 (άλλου) αλλάζει vk_pipeline_serialization.cpp +53/−53 → πιθανό conflict, όχι διπλό.
  - Ανοιχτά πριν από PR: οπτικός έλεγχος του BC texture (δεν έγινε)· tess = ένα C run στον αγώνα ή απόφαση χρήστη να αρκεί το TEST11.
  - ⚠ Οι «αποδείξεις» εδώ καλύπτουν ΜΟΝΟ το κριτήριο (1) του χρήστη. Τα 3 κριτήρια + η κατάσταση ανά fix = «ΚΡΙΤΗΡΙΑ ΧΡΗΣΤΗ»
    πιο κάτω (8c, 21:50)· ο χρήστης 21:55: BC ΟΧΙ έτοιμο. Κανένα branch δεν είναι PR-ready μέχρι να καλυφθούν.
  - **22:05 CONSOLE CAPTURE για το κείμενο του BC assert:** `GT7_upstream\TEST20A_GT7_4cd5cb68_warm_console.bat` = cp του TEST20A +
    Edit (ίδιο exe/cache/save/profile)· stdout+stderr → `logs\console_test20a_gt7_<TS>.txt`, exit code στο τέλος του, 2ο παράθυρο
    `Get-Content -Wait`. ΓΙΑΤΙ ΔΟΥΛΕΥΕΙ (SOURCE): log.cpp:128-129 σε Windows + `"type": "wincolor"` = wincolor_stdout_sink_mt, colour mode
    automatic → σε redirect το GetConsoleMode αποτυγχάνει → WriteFile ανά γραμμή (spdlog wincolor_sink.cpp:85/129)· exe = PE subsystem 3
    (console). Το `color_mode::always` (log.cpp:135) είναι το ΜΗ-Windows branch. ⚠ Και τα δύο sinks πίσω από την ΙΔΙΑ async ουρά (8c):
    ό,τι μένει στην ουρά όταν πεθαίνει το process χάνεται και από τα δύο. Audit 8c: OK· καταγράφεται ως test20a_gt7_5 (ίδιο exe path).
    Dry run ΜΟΝΟ των νέων γραμμών με where.exe (χωρίς start, χωρίς profile). Branches: audit 8c OK (patch-ids, byte-ίδια αρχεία).
    Πρόταση 8c για το κριτήριο (2): build ΚΑΘΕ PR branch (σκέτο main + 1 fix) ως βάση σύγκρισης στα άλλα παιχνίδια.
  - **22:10 test20a_gt7_5/6/7:** 5 = console capture ΔΟΥΛΕΥΕΙ (κράτησε το Critical `liverpool.cpp:256` PM4 type 0 που έχασε το αρχείο)
    αλλά πέθανε στο boot· 6 = 0xC000013A κλείσιμο κονσόλας, άκυρο· 7 (απλός launcher) = Buddy, 0xC0000005 → A 4/4 χωρίς κείμενο.
    SOURCE (8c το επιβεβαίωσε στο 4cd5cb68): `assert_fail_impl` = RemoveHandlers → Shutdown → int3· ο VEH που αφαιρείται εξυπηρετεί και
    το GuestFaultSignalHandler του page_manager → guest fault μέσα στο Shutdown = unhandled AV = 0xC0000005 ΠΡΙΝ το int3. Με sync false
    το LOG_CRITICAL μόνο μπαίνει στην ουρά = ΑΓΩΝΑΣ (a5: βγήκε στην κονσόλα). Άρα το exit code δεν λέει τίποτα για το αν ήταν assert.
  - ⚠⚠ **22:15 ΧΡΗΣΤΗΣ: «we fix a problem completely we dont just make code adjustments» + «we want clean emulator fixes ... not break/
    make worse other games or the emulator ... proper fix for all the problems like the pr 5137 did with the S#».** Το sync-run ΔΕΝ
    ετοιμάστηκε. Εφαρμογή:
    - Preload = σωστό fix ρίζας (και οι δύο Load*Pipeline χτίζουν το pipeline ΑΜΕΣΩΣ μετά τα stages του record, :155-165/:214-244).
    - Tess = σωστό για την αιτία του (SSA + const-prop τρέχουν ΠΡΙΝ το TessellationPreprocess, recompiler.cpp:96-103· το :107 ξανατρέχει).
    - **BC = ΟΧΙ πλήρες. Η κλάση = macro-tiled mip chains, 3 ελαττώματα στο main bcf083f0:** (α) το stale `ASSERT(!props.is_block)`
      image_info.cpp:184· (β) `ImageSizeMacroTiled` tile.h:329-349 υποβιβάζει mip>0 σε micro ΜΟΝΟ αν < macro tile (`// TODO: threshold
      check`), ενώ το addrlib `EgBasedLib::ComputeSurfaceMipLevelTileMode` (egbaddrlib.cpp:1062) για THIN (και PRT_TILED_THIN1) ΚΑΙ όταν
      interleave > threshold1/threshold2, για THICK μόνο με μέγεθος, + thick→thin όταν numSlices < thickness· το CI δεν το αλλάζει·
      egbaddrlib.cpp:487-503: υποβιβασμένο mip = layout 1D· (γ) tiling.comp:426-447 κάνει macro addressing σε ΚΑΘΕ mip macro εικόνας →
      τα mips 3-10 του BC7 1024² ανακατεμένα, και σε ΚΑΘΕ macro texture με μικρά mips. Σωστό fix = ΕΝΑ tile mode ανά mip όπως το addrlib,
      που το χρησιμοποιούν ΚΑΙ το size code ΚΑΙ ο (de)tiler. **addrlib ΥΠΑΡΧΕΙ στον δίσκο:**
      `C:\shadps4-clean\externals\mesa-kosmickrisp\externals\mesa\src\amd\addrlib` (r800 = SI/CI) → oracle για C++ checker.
    - **Κλάση «άκυρο T#» (όπως το #5137 για S#):** ComponentSwizzle dst_sel 2/3 (c2, T18 r5), SurfaceFormat 19/9 (T19b r1), tile mode 29
      (T15 r4), zero-size T# 0x3f80000000 (menu 153). Στο main: `Image::Valid()` = μόνο `type & 0x8` (resource.h:57)· το BindTextures
      απορρίπτει μόνο address 0/FormatInvalid, πρώτο byte unmapped, άγνωστο enum dfmt/nfmt. Πρόταση: ΕΝΑΣ πλήρης έλεγχος T# → null image.
⚠⚠⚠ **27 Σεπ ~20:45 — TEST20 = leave-one-out των 3 τοπικών fixes (απόφαση χρήστη «ok lets do it»).** Κάθε branch = test19b-prcheck
  4ce4d7fb + ΜΟΝΟ ένα revert: `test20a-nobc` 4cd5cb68 (−BC, exe 1CFBC48F…8315), `test20b-nopreload` 0a110358 (−preload, exe
  BAB5D7E7…C395), `test20c-notess` 14a1ba6b (−tess, exe 90D81C99…597B)· exe+pdb δίπλα-δίπλα στο `backup_exe\pdb_test20x_<hash>`.
  Launchers `TEST20{A,B,C}_GT7_<hash>_warm.bat`: σε ΚΑΘΕ launch μετακινούν το cache → `cache_before_launch_<TS>` και αντιγράφουν
  το snapshot `C:\shadps4-test19-gt7\cache_input_warm_20260927_184409` (1520 αρχεία, ΧΩΡΙΣ hs 0x27d2194a) + save A· αρνούνται
  αλλιώς. Control = test19b_gt7_2 (ίδια είσοδος). Αναμενόμενα: B = device lost στο SDRSettingRoot· A = `image_info.cpp:184`
  στο BuddyWindowRoot· C = «patch addr non imm» (hull_shader_transform.cpp:478/479) στο hs 0x27d2194a στην αρχή του αγώνα.
  Dry runs OK (scratch profile). Το test20a έκανε FULL rebuild (2378 βήματα, χωρίς reconfigure, αιτία άγνωστη). Checkout:
  test20c-notess. Μετά: ένα PR ανά fix (σειρά BC → preload → tess) + έλεγχος εικόνας του BC texture (lab dump).
  **TEST20B ΑΠΟΤΕΛΕΣΜΑ (20:48-20:57): το preload fix ΧΡΕΙΑΖΕΤΑΙ.** 4/4 runs (r1-r3 χωρίς watcher, r4 με catcher) πεθαίνουν στο
  ΙΔΙΟ σημείο, 0,2-0,6 s μετά το πρώτο TopRootWindow (όλα με «Preloaded 424» όπως το control, που περνά). r4: EXIT 0xC0000005,
  20,5 s. 0 Critical, κανένα nvlddmkm/WER. ΟΧΙ το αναμενόμενο του REM (device lost στο SDRSettingRoot): με αυτή την cache το bug
  φαίνεται νωρίτερα και ως AV. Confound του full rebuild ΑΠΟΚΛΕΙΣΤΗΚΕ (8c, llvm-pdbutil, 66.705 συναρτήσεις: κάθε TEST20 διαφέρει
  ΜΟΝΟ στη συνάρτηση του revert). Άγνωστο: πού πέφτει το AV (driver ή emulator). Logs `GT7_upstream\logs\*test20b*` (r3 =
  `_UNWATCHED_`, r4 = `_at_exit_205759` + `test20b_gt7_4_exit_code.txt`). ⚠ Το file sink (stdio buffer, flush μόνο στο shutdown)
  χάνει τις τελευταίες γραμμές ενός crash, η κονσόλα ΟΧΙ· τα screenshots του watcher πιάνουν ό,τι είναι μπροστά (ήταν το VS Code).
  Πρόταση προς χρήστη (εκκρεμεί): launcher `> logs\console_<RUN>_<TS>.txt 2>&1` + live παράθυρο (Get-Content -Wait) + exit code
  στο ίδιο αρχείο, με audit του 8c πριν από 20A/20C.
  ⚠⚠ **ΔΙΟΡΘΩΣΗ 8c, 27 Σεπ 21:40: το παραπάνω «ΑΠΟΤΕΛΕΣΜΑ» του TEST20B είναι ΑΚΥΡΟ.** Τα r1-r4 ήταν runs ΧΩΡΙΣ καταχωρημένο
  gamepad ([[gt7-no-gamepad-dies-at-boot-toproot]]). Έγκυρα runs (με pad), όλα με την ίδια cache/save με το control:
  - **B (−preload): 3/3** (r5-r7) device lost στο SDRSettingRoot, nvlddmkm 153, EXIT 0x80000003 → το preload fix χρειάζεται.
  - **A (−BC): 3/3** (r2-r4) πεθαίνουν <1 s μετά το ΠΡΩΤΟ BuddyDummyRoot, EXIT 0xC0000005, κανένα nvlddmkm, κείμενο assert δεν
    πιάστηκε → συμβατό με το BC fix.
  - **C (−tess): 3/3 πεθαίνουν ΠΡΙΝ από τον αγώνα, κάθε φορά αλλού και αλλιώς:** r1 device lost (153) + 0xC0000005, r2 Critical
    `liverpool_to_vk.cpp:428 ComponentSwizzle: Unreachable` μετά από `Rejecting invalid T#` + 0x80000003, r3 Critical
    `buffer_cache.cpp:424 SubmitPendingArenaBinds` «Device lost during submit» (153) + 0x80000003. Κανένα δεν έφτασε στο hs
    0x27d2194a (το control το μεταγλώττισε ΜΕΣΑ στον αγώνα). Το revert αγγίζει μόνο tess compiles και τα r1/r3 δεν έκαναν
    κανένα → το C δεν έχει δείξει ακόμα τίποτα για το tess fix· δείχνει διακοπτόμενες αποτυχίες της βάσης 4ce4d7fb πριν από τον
    αγώνα, που το ΕΝΑ control run (test19b_gt7_2) δεν έπιασε. Λεπτομέρειες: [[gt7-shadps4-auditor-handoff]].
  ⚠ 27 Σεπ 21:30: ο builder `gtnikos-38` «is flagged» (ο χρήστης)· νέο chat `gtnikos-d9`. Κανένα cross-session μήνυμα χωρίς
  ρητή εντολή του χρήστη.
  ⚠⚠ **ΚΡΙΤΗΡΙΑ ΧΡΗΣΤΗ ΓΙΑ ΤΑ 3 PR (27 Σεπ 21:50):** «αν τα tests αποδείξουν ότι το fix που λείπει ρίχνει το παιχνίδι στο ίδιο
  σημείο που διορθώνει το fix, κάνουμε 3 ξεχωριστά PR» + «αλλά πρέπει να ελέγξουμε ότι δεν χειροτερεύει ή κρασάρει κανένα άλλο
  παιχνίδι που δουλεύει, και ότι δεν χειροτερεύει τον κώδικα». Κατάσταση 21:50 (8c):
  - BC: τοποθεσία ✓ (A 3/3 στην πρώτη χρήση του fs 0x74f5f10c, 4/4 με το fix περνούν)· λείπει το κείμενο του assert (console
    capture) + έλεγχος ότι το texture βγαίνει σωστό. **Χρήστης 21:55: «bc texture is not ready then» → ΟΧΙ PR ακόμα.**
    **28 Σεπ 00:36 ΤΟ ΚΕΙΜΕΝΟ ΥΠΑΡΧΕΙ:** test20a_gt7_8 (console launcher) → `image_info.cpp:184 lambda: Assertion Failed!`
    (console γρ. 39559 ΚΑΙ file log) 9 γραμμές μετά το bind του stage 0x74f5f10c, στο PlayGo BuddyWindowRoot, έξοδος 0xC0000005
    (assert → AV στο Shutdown, όπως προέβλεψε ο d9). A = 5/5. Μένει: έλεγχος ότι το texture βγαίνει σωστό + κριτήρια 2/3.
    Άλλα παιχνίδια: δεν μπορεί να χειροτερέψει κανένα που δουλεύει (το ASSERT
    είναι πάντα ενεργό, άρα η γραμμή μόνο κρασάριζε). Κώδικας: το UpdateSize ήδη κάνει τα BC 4×4 blocks πριν από τη
    γεωμετρία και ×4 μετά, όπως στο micro path.
  - Preload: τοποθεσία ✓ (B 3/3 στο SDRSettingRoot, 7/7 με το fix περνούν). Αλλάζει μόνο pipelines που χτίζονται από τη ζεστή
    cache όταν ένα πρόγραμμα έχει >1 permutation (το draw ξαναγεμίζει το buffer από τα live user data, info.h:196-200). Θέλει
    warm run άλλου παιχνιδιού με/χωρίς. Το commit έχει σχόλιο 2 γραμμών που ΠΡΕΠΕΙ να φύγει για το PR.
  - Tess: ✗ ακόμα (κανένα C run δεν έφτασε στον αγώνα). Τρέχει μόνο για tess shaders· το ReadLaneEliminationPass ήδη τρέχει
    για ΚΑΘΕ shader στο recompiler.cpp:107, το fix το τρέχει και νωρίτερα για tess. GoW/GoT dumps του TEST19b: 0 hs/ds/ls,
    αλλά σταμάτησαν νωρίς (GoW χωρίς τα 3 δικά του fixes, GoT στο F64 bug) → όχι απόδειξη.
⚠⚠⚠ **27 Σεπ ~18:35 — TEST19b = ΤΟ ΕΝΕΡΓΟ (το TEST19 51ae31cf ΑΝΤΙΚΑΤΑΣΤΑΘΗΚΕ πριν τρέξει ποτέ).** Απόφαση χρήστη (μέσω 8c): το #5137
  ξαναγράφτηκε σε `AmdGpu::Sampler::Valid()` (PR commit d2a0e3ed πάνω στο e518a651, μόνο τίτλος, clang-format 19: 0· local
  `sampler-catch-all` → d2a0e3ed· **PUSHED στο mine με εντολή χρήστη, μετά τα 2 GT7 runs** — lease 95b03670, το PR #5137 = 1 commit,
  +14/-1, base e518a651 = τρέχον main, CI τρέχει) και δοκιμάζεται μαζί με τα 3 τοπικά. `test19b-prcheck` 4ce4d7fb = ίδια σύνθεση με
  το #5137 αλλαγμένο· build 88 βήματα, exe SHA256 B2D44157…5F50, pdb 86B27754…14CA· exes `backup_exe\shadps4_test19b_4ce4d7fb_
  {gt7,gow,got}.exe`, pdb `backup_exe\pdb_test19b_4ce4d7fb\`· launchers `TEST19B_{GT7,GOW,GOT}_4ce4d7fb_{cold,warm}.bat` (τα
  TEST19_*_51ae31cf_*.bat σβήστηκαν)· ίδια profiles. Runs test19b_{gt7,gow,got}_1 (cold) / _2 (warm). Πριν από force-push:
  `git fetch mine` (τα mine/* refs μένουν πίσω από τα Update-branch merges του GitHub) + `--force-with-lease`.
⚠⚠⚠ **27 Σεπ ~18:30 — TEST19 ΧΤΙΣΜΕΝΟ (gtnikos-38, «do it»): ο έλεγχος 3 παιχνιδιών πριν από τα PR των 3 τοπικών fixes.**
- `test19-prcheck` 51ae31cf = origin/main e518a651 (#5031) + τα 4 ανοιχτά PR (ένα πραγματικό commit το καθένα: #5114 11d8b765,
  #5131 12d41c22, #5137 a053b271, #5150 e6643c25) + BC 8bc5639f + preload f13bf337 + tess e88a86b9. ΧΩΡΙΣ instruments/GT_*/T# guards.
  Γιατί και τα PR: χωρίς #5131/#5137 το GT7 πεθαίνει νωρίς (TEST7)· προηγούμενο = TEST3 (main + ανοιχτά PR + νέο fix). Audit 8c: CLEAN.
- ⚠ **Το #5114 ΣΥΓΚΡΟΥΕΤΑΙ πλέον με το main** (tests/gcn/test_gcn_instructions.cpp, το #5031 πρόσθεσε test στο ίδιο σημείο)· εδώ λύθηκε
  κρατώντας και τα δύο tests· στο GitHub το PR θα θέλει resolve.
- Incremental build (38 βήματα, NINJA_EXIT=0)· ⚠ ο τίτλος/log header λέει ακόμα «test18-prfault v.0.18.0-178-gb5fa4401» (scm_rev
  χωρίς reconfigure) → ταυτότητα = όνομα exe + SHA256 E9F7BA75…31E5 (pdb D62E8B61…15E2). Exes `backup_exe\shadps4_test19_51ae31cf_
  {gt7,gow,got}.exe`, pdb `backup_exe\pdb_test19_51ae31cf\`. Launchers `GT7_upstream\TEST19_{GT7,GOW,GOT}_51ae31cf_{cold,warm}.bat`
  (dry runs OK)· profiles `C:\shadps4-test19-{gt7,gow,got}` (gow/got με `save_start` που αποκαθίσταται σε κάθε launch).
- Αναμενόμενα: GoW σταματά στο DS_ORDERED_COUNT (#496)· GT7 μπορεί να σταματήσει σε T# assert (χωρίς guards)· GoT = άγνωστο.
- **#5137: ο squidbus ζήτησε (15:21Z) «move this to a function like Valid() inside Sampler»**· ο χρήστης απάντησε ότι θα το κάνει.
  Στοιχεία 8c: το `AmdGpu::Sampler::Valid()` υπάρχει ήδη ως stub (resource.h:460)· το ta_bc_base είναι context register (μένει
  στο call site)· τα enums είναι συνεχόμενα από 0 (χωρίς magic_enum στο header). Αλλαγή = amend του ΕΝΟΣ commit + force-push μόνο όταν το πει.

⚠⚠⚠ **27 Σεπ ~17:05 — TEST18 ΧΤΙΣΜΕΝΟ (builder gtnikos-38): το PR commit του fault probe πάνω στο σημερινό main.**
- Απόφαση χρήστη: «only build a test for gt7 since its the only one using this fix for now»· μετά διάλεξε «today's main +
  our fixes». Άρα ΠΑΡΑΛΕΙΠΟΝΤΑΙ GoW/GoT για ΑΥΤΟ το PR (όχι μόνιμη αλλαγή του κανόνα των 3 παιχνιδιών).
- Γιατί όχι σκέτο PR branch: το caeb240d έχει ακόμα `ASSERT(!props.is_block)` (image_info.cpp:184· το «#5018» = 404, ΜΗΝ το αναφέρεις) → το GT7 πεθαίνει
  στο BuddyWindowRoot, πριν από τον αγώνα όπου συμβαίνει το fault. «upstream main + ΜΟΝΟ το PR» δεν φτάνει ποτέ εκεί.
- PR branch `fault-probe-page` e6643c25 (parent caeb240d, 1 αρχείο **+4/−2**· αρχικά είπα λάθος +3/−2 στον χρήστη, το
  διόρθωσε ο 8c). ΚΑΝΕΝΑ push. Upstream: κανένα PR/issue για το GuestFaultSignalHandler (8c).
- TEST18 = `test18-prfault` b5fa4401 = caeb240d + e6643c25 + 19 cherry-picks του TEST17d stack.
  - Εκτός: 5db8d018 / ce445dd1 (= merged #5126 / #5125+#5127), 531a5a70 / c3a64010 με τα reverts τους, κάθε merge.
  - Όλα τα patch-ids ίδια με τα πρωτότυπα (8c). Δέντρο TEST17d→TEST18 = 6 upstream αρχεία + η μορφή του #5126 (u32 + enum,
    ίδιες θέσεις bit) + tests/gcn −39.
  - Cherry-picks σε ΠΡΟΣΩΡΙΝΟ worktree (`--detach`, scratchpad), μετά `git switch` στο clean: το build dir βλέπει μόνο ό,τι
    διαφέρει στο τελικό δέντρο.
- Cache 5/5, άρα ο warm snapshot ισχύει. Τα binaries κλειδώνουν σε `{pgm_hash}_{perm_idx}`, οπότε το #5145 (Flat στο
  SubgroupLocalInvocationId των vertex shaders) ΔΕΝ φτάνει στα cached vertex SPIR-V (8c).
- Build: CMake ξανάτρεξε (upstream CMakeLists, αρχεία vdecsw) και το branch μπαίνει στις ρυθμίσεις → ΠΛΗΡΕΣ build 2380 βήματα,
  6 λ., NINJA_EXIT=0. Ο τίτλος είναι ΣΩΣΤΟΣ αυτή τη φορά: `test18-prfault` / `v.0.18.0-178-gb5fa4401-dirty`.
- Αρχεία:
  - exe `backup_exe\shadps4_test18_b5fa4401_gt7.exe`, SHA256 EB4292EA…EB00E0;
  - pdb `backup_exe\pdb_test18_b5fa4401\shadps4.pdb` F42306A2…DAC3A0E, με hard link `shadps4.exe` δίπλα του;
  - launcher `GT7_upstream\TEST18_GT7_b5fa4401_prfault_warm.bat` (ίδια GT_* με το 17d, dry run OK με αντίγραφο χωρίς launch);
  - profile `C:\shadps4-test18-gt7\user` (= test17 χωρίς cache/log, 91 αρχεία)· RUN `test18_gt7_1`.
- ⚠ **llvm-symbolizer διαλέγει ΣΙΩΠΗΛΑ λάθος pdb** (8c, μετρημένο): δοκιμάζει πρώτα `<φάκελος exe>\shadps4.pdb`, μετά το path
  που είναι γραμμένο μέσα στο exe (= build dir). `--obj=backup_exe\<exe>` χωρίς pdb δίπλα = pdb του ΤΕΛΕΥΤΑΙΟΥ build, λάθος
  συνάρτηση, κανένα warning. Symbolize ΜΟΝΟ από φάκελο με exe + shadps4.pdb μαζί.
- **ΑΠΟΤΕΛΕΣΜΑ: το PR commit ΑΠΟΔΕΙΧΤΗΚΕ στο σημερινό main (TEST18 r6, 17:15:40-17:17:17).**
  - GT_FAULTEND #1/#2 (Job#10, Job#15) στις γραμμές 80832/93295, μετά το InRaceRoot (74510): write στο 0x2077ffffc (= TEST17d
    r5), χειρίστηκε με probe 4 bytes, το run συνέχισε ~17 s.
  - Τέλος = το ΓΝΩΣΤΟ reset του αγώνα: nvlddmkm id 13 «WIDTH CT Violation (0x4,0x0)» + ESR 0x80000010/0x4/0xf00 + 153, ίδιο bit
    προς bit με T13 r1 / T17 r4, με `SanitizeCopyLayers 8 → 48` 29 γραμμές πριν → vk_scheduler.cpp:242. Άσχετο με το fix.
  - r1-r5 δεν έφτασαν στο σημείο: game-side AV (σπάνιο ADHOC «(nil).np», όπως σε 4 logs του TEST6)· PM4 type 0 ×2 (IB ≥43 και 6)·
    Zydis handler· νέο assert liverpool_to_vk.cpp:428 ComponentSwizzle (dst_sel 2/3, σκουπίδι T# σε IB ≥37).
  - Ο χρήστης (17:18): «i only care for the pr to work until is pushed» → το PR είναι έτοιμο, push ΜΟΝΟ όταν το πει.
  - **PUSHED (αίτημα χρήστη):** `mine/fault-probe-page` = e6643c25 (ls-remote επαληθευμένο), νέο branch, τίποτα άλλο. Το PR το
    ανοίγει και το γράφει ο χρήστης: https://github.com/nikmparis217-ux/shadPS4/pull/new/fault-probe-page. clang-format 19:
    0 αλλαγές — ⚠ με το αρχείο από stdin· με όρισμα-αρχείο το `--assume-filename` αγνοείται, το .clang-format δεν βρίσκεται
    και φαίνεται ψεύτικο «WOULD CHANGE» ακόμα και στο αρχείο του upstream.
  - **PR #5150 ΑΝΟΙΧΤΟ** (ο χρήστης, 27 Σεπ 17:58 τοπική): https://github.com/shadps4-emu/shadPS4/pull/5150, head e6643c25.
    Κείμενο δικό του (≈ το draft του 2ου γύρου)· ΔΕΝ πήρε τη γραμμή «πώς το ελέγξαμε», το «e.g.» στη λίστα, ούτε έκοψε το «because
    it depends on timing» — επιλογή του. CI ~18:05: clang-format / reuse / get-info πράσινα, builds + C++ tests σε εξέλιξη.
    Build του TEST18 ΠΕΡΙΕΙΧΕ ΚΑΙ #5114 + 3 τοπικά T# guards (72320ba4, 494a78d1, 5dc75198, σε κανένα PR) — αν ρωτήσει maintainer.
  - **Ετοιμότητα των 3 τοπικών GT7 fixes (27 Σεπ ~18:20, ερώτηση χρήστη):** και τα τρία ΧΡΕΙΑΖΟΝΤΑΙ ακόμα στο upstream main
    e518a651 (assert στη 184, καμία γραμμή preload, κανένα ReadLaneElimination στην αρχή του TessellationPreprocess) και είναι σε
    δεκάδες GT7 runs (BC ~50 από TEST4, preload ~47 από TEST5, tess ~38 από TEST12)· ΚΑΝΕΝΑ δεν έτρεξε σε άλλο παιχνίδι. Το
    ReadLaneEliminationPass τρέχει ήδη ΑΜΕΣΩΣ ΜΕΤΑ τα tess transforms (recompiler.cpp:107), άρα το fix απλώς το φέρνει νωρίτερα.
    Επόμενο (μόνο αν το πει): ένα exe = main + τα 3, χωρίς instruments, runs GT7 + GoW + GoT, cold και warm.

⚠⚠⚠ **27 Σεπ ~13:50 — HANDOFF ΤΟΥ BUILDER: `C:\shadps4-gt7\GT7_upstream\HANDOFF.md` (ο χρήστης ζήτησε νέο chat).** Εκεί, στα
αγγλικά: κανόνες, πού είναι τι, κατάσταση GoW/GT7, PR του χρήστη, τι περιμένει απόφασή του, συνταγή για το επόμενο GT7 build (test18
πάνω στο 8151ee25: ποια commits του TEST17 μένουν, ποια φεύγουν), παγίδες. **GOW3 = ΙΔΙΟ TDR στο ίδιο splash** (λεπτομέρειες στο τέλος
αυτού του αρχείου και στο [[gow-fixes-for-pr]])· spirv-val VALID (και οι δύο συνεδρίες). Δείκτες ενημερωμένοι: `C:\shadps4-gt7\CLAUDE.md`
(ξαναγραμμένο: 1.71 ενεργό, builds στο clean), ενότητα «CURRENT STATE» πάνω από το «STATE ON 22 SEP» του README, η παράγραφος shadPS4 στο
τέλος του `C:\GTNikos\CLAUDE.md`. `GT7_upstream\build_clean.bat` περνά πλέον ορίσματα στο ninja (`-k 0`). Κανένας watcher οπλισμένος· το
`C:\shadps4-clean` ελεύθερο στο `gow-orderedcount` 7ad6b6d0· ο διάδοχος συστήνεται στον `gtnikos-8c`. Το branch `claude`
(CLAUDE_MEMORY.md) μένει stale από το TEST9 — δουλειά για τον διάδοχο.

⚠⚠⚠ **27 Σεπ ~13:20 — ΑΠΟΦΑΣΗ ΧΡΗΣΤΗ: το GoW ΠΑΓΩΝΕΙ μετά το GOW3, συνεχίζουμε GT7.** Τα GoW fixes = τρία ΤΟΠΙΚΑ branches ενός
commit πάνω στο origin/main 8151ee25 → ΟΛΑ στο [[gow-fixes-for-pr]] (`tg-size-sgpr` b89a2772, `ds-ordered-count` a1af1159 πάνω του,
`tsharp-dw1-mask` dc08b752)· ελεγμένα με diff έναντι του δοκιμασμένου κώδικα, ΚΑΝΕΝΑ push. Upstream: fetch → local `main` 7e0c8111 →
8151ee25 (#5138 mesa-kosmickrisp = μόνο macOS, #5128 vdecsw) — ο χρήστης: «ΜΟΝΟ τα εγκεκριμένα (merged), όχι PR άλλων». Merge του
origin/main στο `gow-orderedcount` → 7ad6b6d0 (source μόνο, δεν χτίστηκε· το submodule mesa-kosmickrisp δείχνει « M» = παλιό commit, άσχετο
στα Windows). Το `mine/main` (fork) είναι ακόμα d96278e1 — ΔΕΝ το έσπρωξα.

⚠⚠⚠ **27 Σεπ ~13:00 — GOW2 = το T# fix ΔΟΥΛΕΥΕΙ, μετά TDR· GOW3 ΧΤΙΣΜΕΝΟ (ordered count ανά 64-lane GCN wave).**
GOW2 run 1 (12:40:59-12:41:43, 44 s, `logs\shad_log_gow2_1_at_exit_124156.txt`): fs 0xcc4267a6 μεταφράζεται (0 discover asserts)·
τέλος = `buffer_cache.cpp:424 SubmitPendingArenaBinds` «Device lost during submit» + σκέτο nvlddmkm **153** (όχι id 13). 689 «Clamped size
from 0xFFFFFFF0» ήδη από τη γραμμή 997 (πριν από κάθε ordered count). spirv-val (SDK 1.4.357, vulkan1.3) στο cs_0x38c7b95b_0.spv: VALID.
Audit του peer «διπλομέτρηση ανά wave» = ΑΝΑΙΡΕΘΗΚΕ: και τα δύο ops μέσα σε `If (LocalInvocationId.x == 0)` (asl γραμμή 334) → ΜΟΝΟ το
thread 0 του 64-thread workgroup (= 1 GCN wave) → μόνο το κάτω subgroup (και το run 015 trace: 0,186,372 χωρίς διπλά). ΤΟ ΑΛΗΘΙΝΟ πρόβλημα:
το πάνω subgroup είχε ΔΙΚΟ ΤΟΥ ticket (2w+1) και το άφηνε ΜΟΝΟ στο S_ENDPGM signal (block $464, μετά από ΟΛΟ το `If %4198` σώμα) → το
op του workgroup w+1 περίμενε να ΤΕΛΕΙΩΣΕΙ ολόκληρο το w = σειριακό dispatch → πιθανή οδός για 153. ($174 ξεκινά με Barrier για όλα τα
threads → το πάνω μισό φτάνει στο ENDPGM πάντα ΜΕΤΑ το op.) TG_SIZE: μόνο BFE(6,11) → M0[15:0], που το op αγνοεί.
**GOW3** `gow-orderedcount` **586d0579** «WIP ds_ordered_count: count 64-lane GCN waves»: wave index/TG_SIZE = LocalInvocationIndex>>6,
DivCeil(threads,64)· S_ENDPGM signal = περίμενε ticket ≥ wave → CAS(wave→wave+1) (idempotent: αδρανές subgroup ήδη ελευθερωμένου wave =
τίποτα)· αφαιρέθηκε το `<bit>`· ShaderBinaryVersion 6→7. Γνωστό όριο (όχι στο GoW), ΔΥΟ περιπτώσεις: (α) δύο ενεργά subgroups ΙΔΙΟΥ GCN wave
στο op → το 2ο περιμένει για πάντα· (β) αδρανές subgroup που φτάνει στο S_ENDPGM ΠΡΙΝ το op του wave του (χωρίς barrier ενδιάμεσα) βλέπει
ticket == w, κάνει CAS σε w+1 → το WaitForTurn(== w) του op δεν πετυχαίνει ποτέ. Και τα δύο → per-wave LDS mailbox/«τελευταίο μισό
βγαίνει» πριν από PR. Build 5 βήματα OK· exe `backup_exe\shadps4_gow3_586d0579_gow.exe`
(BD3FFD1E…1AA83924), PDB `pdb_gow3_586d0579` (FB7F1D4C…0475C95B)· launcher `GT7_upstream\GOW3_gcnwave_586d0579.bat` (dry run OK)·
dumps/cache του GOW2 → `logs\gow2_1_artifacts` (GOW3 cold). ⚠ Ο peer αντιπαρέβαλε ΜΟΝΟ το scalar branch ΑΝΑΜΕΣΑ στα ops, όχι το If που
τα ΠΕΡΙΚΛΕΙΕΙ — πριν δεχτείς audit «διπλομέτρησης», διάβασε τις συνθήκες των If γύρω από την εντολή στο `*.asl.txt`.

⚠⚠⚠ **27 Σεπ ~06:16 — GOW1 ΕΤΡΕΞΕ: το DS_ORDERED_COUNT ΔΟΥΛΕΥΕΙ· GOW2 ΧΤΙΣΜΕΝΟ για το επόμενο assert.**
GOW1 run 1 (06:02, ~12 s, log `logs\shad_log_gow1_1_at_exit_060240.txt`): cs 0x38c7b95b μεταφράζεται + pipeline 0xfe3aa756ad1ee51d,
0 «Unknown opcode», 0 nvlddmkm· wave64 lowering Ballot×3 + MaskedBitCount32×2 σε αυτόν (ο κίνδυνος διπλομέτρησης ΜΕΝΕΙ ανοιχτός — θέλει
οπτικό/trace έλεγχο, όχι μόνο «δεν κράσαρε»). Τα flatten errors «GetAttributeU32»/«Phi» = δυναμικά ReadConst offsets (147 Phi σε όλο το
log) → DMA fallback, ΟΧΙ από την αλλαγή μας. Τέλος: `resource_discover_pass.cpp:257 ASSERT(IsSharpSource(source))` στο fs 0xcc4267a6.
ΡΙΖΑ (από το IR dump `*.pre-res-discover.irprogram.txt`, dump_shaders=ON τα γράφει από το #5059): T# dword1 = `BitwiseAnd32(ReadConst,
0xC3FFFFFF)` = μηδενίζει NUM_FORMAT (dw1 bits 26-29) → UNORM (sRGB υφή διαβάζεται γραμμικά)· το %262 έχει ΚΑΙ άλλες χρήσεις (SGPR9, SCC)
→ αλλάζει μόνο τι παίρνει το GetSharp, ΠΟΤΕ το IR. Το discover pass (#4782, 5 Σεπ) ελέγχει ΚΑΘΕ dword· ο παλιός tracker κοίταζε μόνο το
dword0 → αγνοούσε σιωπηλά τη μάσκα. Upstream head = d96278e1, κανένα PR/issue. FIX 8f008d67 (WIP στο gow-orderedcount): post-op
`BitwiseAndDw1WithImm` (καθρέφτης του V# `BitwiseOrDw1WithImm`), `ImageResource::post_op_dw1_mask` (+ στο dedup), εφαρμογή στο
`GetSharp`, `CheckImageDw1MaskPattern` (οποιοδήποτε operand immediate), ShaderMetaVersion 6→7 (το Info σειριοποιείται raw). Ο peer
σκάναρε και τα 83 dumps: μόνο αυτή η μάσκα. clang-format **19** = `VS BuildTools\VC\Tools\Llvm\x64\bin\clang-format.exe` (19.1.5)·
το `C:\Program Files\LLVM` είναι 22. ⚠ Στο Git Bash `grep -c $'\r'` ΚΑΙ `awk '/\r/'` λένε ψέματα (text mode)· αυθεντικό = `git ls-files --eol`
(i/lf w/crlf). Build 80 βήματα NINJA_EXIT=0· exe `backup_exe\shadps4_gow2_8f008d67_gow.exe` (7FBEE40E…34AAD5C39), PDB `pdb_gow2_8f008d67`
(8673E2BE…F9A5C9ED67)· launcher `GT7_upstream\GOW2_tsharpmask_8f008d67.bat` (CRLF, dry run από PowerShell OK)· dumps + cache του GOW1
μετακινήθηκαν στο `logs\gow1_1_artifacts` (GOW2 = cold όπως το GOW1). PR branch ΜΟΝΟ όταν το ζητήσει ο χρήστης (από origin/main,
ShaderMetaVersion 5→6 εκεί). ⚠⚠ **ΛΑΘΟΣ ΜΟΥ: ο χρήστης είχε ανοίξει ΗΔΗ το #4999 (10 Σεπ, branch `pr-descriptor-dword-mask` 38244d07)
για ΑΚΡΙΒΩΣ αυτή τη μάσκα του GoW** — baggins183 (11 Σεπ): «the approach would work although it doesn't really match other cases that
use SharpFetchPostOp. But I would rather handle this in srt program itself» → έκλεισε 24 Σεπ χωρίς merge. Άρα το GOW2 = σωστό TEST build,
αλλά PR ΜΟΝΟ με τη σχεδίαση που ζήτησε (η μάσκα μέσα στο SRT walker program) ή αφού ρωτηθεί. Η αναζήτηση `author:` του API γύρισε ΚΕΝΗ·
το per-branch `pulls?head=nikmparis217-ux:<branch>` δουλεύει → [[feedback-check-existing-branches-first]].
**Τι μένει για PR στο GT7 (έλεγχος 27 Σεπ ~06:30 έναντι origin/main d96278e1, ΟΛΑ λείπουν upstream):** e88a86b9 tess readlane (1 γραμμή)·
103b0976 T# ζεύγος format· 0db8c566 preload flatbuf (+3)· 8bc5639f BC σε macro-tiled (−1 ASSERT)· 10baa842 clamp log→debug. Ανοιχτά:
#5137 (#5114 = όχι GT7). Merged: #5070, #5126, **#5131 (28 Σεπ 00:09 τοπική ώρα, squash από squidbus = e0cd957a, τίτλος
«... on the KHR path (#5131)»· το τοπικό αντίγραφο 7f8b5076 φεύγει από τα test builds πάνω στο νέο main)**. Κλειστά: #5132/#5135 (→#5137), #4999, #4996.

⚠⚠⚠ **27 Σεπ ~05:50 — GOW1 ΧΤΙΣΜΕΝΟ: DS_ORDERED_COUNT για το God of War (ο χρήστης: «find and fix the missing opcode for gow»).**
Branch `gow-orderedcount` στο `C:\shadps4-clean` = origin/main d96278e1 + b8c30ff2 (catch-all = περιεχόμενο #5137) + 596ed125 + 88c61ea9
(WIP, 23 αρχεία, +285): (1) TG_SIZE SGPR (RSRC2 bit 10 → `HwComputeRuntimeInfo::tg_size_enable`) = {first_wave<<31 | ordered_append_term
[16:6] | waves[5:0]}· (2) `DS_ORDERED_COUNT` → `GdsOrderedCount` → (resource patching) `BufferOrderedCount` στο GDS buffer: counter στο
M0[31:16]+index*4, ΕΝΑ atomic ανά wave (lowest active lane), add ή swap (offset1 bit 4), αποτέλεσμα broadcast, σειρά = ticket στο
`GdsOrderedTicketOffset` 0x10000 (GDS buffer 64 KB+4, μηδενίζεται πριν από κάθε dispatch + IsBufferAccessed για barrier· το upstream ΔΕΝ
ελέγχει ποτέ το GDS buffer για barriers), release στην εντολή (offset1 bits 0-1), S_ENDPGM απελευθερώνει wave που δεν το έκανε·
μόνο compute (αλλιώς «missing opcode» όπως πριν)· ShaderBinary/Meta version 5→6. Port του δικού μας παλιού σχεδίου (6-8 Σεπ, runs 010-015,
επαληθευμένο με trace)· το Sirit OpAtomicStore είναι πλέον σωστό upstream. ISA: Sea Islands/GCN3 = «in order of wavefront creation»·
Vega = «4 dedicated ordered-count counters (packers)»· LLVM `AMDGPUDSOrderedIntrinsic`: M0 = {hi16 address, lo16 waveID}, offset1 =
release | done<<1 | shader type<<2 | swap<<4· LLVM AMDGPUUsage: Work-Group Info SGPR layout. Το #2899 (upstream) έκλεισε από τον ίδιο τον
συγγραφέα μετά το σχόλιο του squidbus ακριβώς γι' αυτά. ⚠ ΑΝΟΙΧΤΟ: το upstream έχει πλέον `LowerWave64BallotPass` (#4995/#5116)· αν το
ballot της τιμής είναι 64-wide και το op ανά 32-lane subgroup → διπλομέτρηση· το log του run το λέει («Lowering .* for wave64»).
exe `backup_exe\shadps4_gow1_88c61ea9_gow.exe` (298EC1FF…9D9DDBF81), PDB `pdb_gow1_88c61ea9` (0151ABDF…B938DCA94C), profile
`C:\shadps4-gow1` (= TEST3 GoW χωρίς cache/log/dumps, dump_shaders ON), launcher `GT7_upstream\GOW1_orderedcount_88c61ea9.bat`
(dry run OK)· watcher gow1_1 οπλισμένος (peer). ⚠ Dry run από Git Bash: το `find` μέσα στο .bat είναι το GNU find (PATH) → σαρώνει
όλο το C: και κολλάει· βάλε System32 πρώτο στο PATH του dry run. Ο χρήστης τρέχει GTA V (peer, #5114) πρώτα.

⚠⚠⚠ **27 Σεπ ~05:00 — ΔΥΟ ΚΑΤΗΓΟΡΙΕΣ GPU RESET, ΧΩΡΙΖΟΝΤΑΙ ΑΠΟ ΤΟ SYSTEM LOG.** TEST17 run 4 = αγώνας (InRaceRoot 04:56:37) → reset
04:57:13 με **nvlddmkm id 13 «Graphics Exception on GPC 2: WIDTH CT Violation. Coordinates: (0x4, 0x0)» + ESR 0x510420=0x80000010
0x510434=0x4 0x510438=0xf00** + 153. ΙΔΙΑ bit-προς-bit στις 00:50:01 = TEST13 r1 (το άλλο device lost ΣΤΟΝ ΑΓΩΝΑ). ΟΛΑ τα resets των
μενού = σκέτο 153 χωρίς id 13. Άρα: αγώνας = παραβίαση πλάτους color target (Xid 13, ντετερμινιστική)· μενού = timeout 153.
Συσχέτιση στο log για τον αγώνα: `vk_runtime.cpp:56 SanitizeCopyLayers: Coercing copy source layers 8 and destination layers 48` ΜΟΝΟ
στα 2 CT-violation runs (672 / 38 γραμμές πριν το τέλος)· τα 5 runs που πέρασαν αγώνα χωρίς reset έχουν μόνο «3 και 4». 48 = 8×6 (8 cubes;
υπόθεση: ίδια μνήμη ως 8 layers και ως 48 faces). ΕΡΓΑΛΕΙΟ: `Get-WinEvent System nvlddmkm` ΜΕ τα Properties (το id 13 γράφει τον τύπο).
(Διόρθωση peer: οι 3 πρώτες γραμμές κάθε run είναι 1→8, 1→6, 3→4.) **ΥΠΟΠΤΟΣ ΚΩΔΙΚΑΣ (peer, ελεγμένος read-only @c48229d2, ΑΝΑΠΟΔΕΙΚΤΟ
μέχρι probe που τυπώνει πλάτη):** ESR κατά το gf100 PROP trap layout του nouveau: 0x80000010 bit 0x10 = **RT_WIDTH_OVERRUN**, x=4 y=0,
format 0xf → το ROP έγραψε πέρα από το ΠΛΑΤΟΣ του color target. Callers του SanitizeCopyLayers: `CopyMip` (:396) εξαιρείται (ASSERT dst
mip == src)· `Runtime::CopyImage` (:266) και `ResolveImage` (:530) παίρνουν extent από το ΠΛΑΤΟΣ/ΥΨΟΣ της ΠΗΓΗΣ (vk_runtime.cpp:236-237),
ΧΩΡΙΣ clamp στο dst. `ExpandImage` (texture_cache.cpp:479, από ResolveOverlap :276/:282/:305) φτιάχνει τη νέα εικόνα από το αίτημα και
αντιγράφει με το extent της παλιάς· συγκρίνει μόνο `SubresourceExtent{levels, layers}` (defaulted <=>, λεξικογραφικά: levels πρώτα),
ΠΟΤΕ πλάτος/ύψος → στενότερο αίτημα 48 layers παίρνει φαρδύτερη αντιγραφή 8 layers. ⚠ Λιγότερα layers/levels ΔΕΝ γράφουν εκτός ορίων
(SanitizeCopyLayers = min, num_mips = min → μόνο απώλεια δεδομένων)· το RT_WIDTH_OVERRUN μπορεί να έρθει ΜΟΝΟ από πλάτος/ύψος. Το ίδιο ισχύει για το recreate του ResolveDepthOverlap
(:193/:226). vk_runtime.cpp = ίδιο με upstream d96278e1. Πρόταση peer (αποφασίζει ο χρήστης): log-only probe σε CopyImage/ResolveImage
όταν src≠dst σε μέγεθος· αν επιβεβαιωθεί, fix = clamp κάθε region στο min(src,dst) ανά mip (το απαιτεί και το Vulkan) → γενικό upstream PR.

⚠⚠⚠ **27 Σεπ ~04:37 — TEST17 run 1 = GPU reset στα μενού (KeyAssign SteeringType, 153 στις 04:36:02) ΧΩΡΙΣ την υπογραφή 0x3f80000000**
(καμία απόρριψη μηδενικού μεγέθους, κανένας Thick3D detiler· log πλήρες, mod 4096 = 2027) → εκείνη η υπογραφή = 6 από 7. Το TEST17 δεν κρίθηκε ακόμα.
**~04:46 ΔΙΟΡΘΩΣΗ (δική μου): ΑΦΗΝΕΙ ίχνος = ΔΕΥΤΕΡΗ υπογραφή.** 47170 `Tracking memory region 0x109ed93000 - 0x11026a0000 … not fully GPU mapped`
= **1.56 GiB** (0x6390D000· το «99 MB» του peer = ένα hex ψηφίο λιγότερο) = IMAGE (το warning το καλεί ΜΟΝΟ το TextureCache) → 47174 `GetArena:
Migrating arena` = το ΜΟΝΑΔΙΚΟ σε όλα τα logs TEST15-17 (το range περνά το όριο arena 4 GiB στο 0x1100000000) → 417 EnsureResident ως block 1114730
= ακριβώς το τέλος του range (τα EnsureResident είναι κανονικά, 1275-2091/run) → 48044 το ίδιο range από ΝΗΜΑ ΠΑΙΧΝΙΔΙΟΥ Job#15 (write fault →
InvalidateMemory → CpuDirty + Untrack → ξανά upload ολόκληρο) → 48188 τελευταίο SubmitDone. Το range ΔΕΝ υπάρχει σε κανένα άλλο από τα 33 logs
TEST11-17. Ίδια κλάση με το μηδενικό μέγεθος: T# περνά όλους τους ελέγχους με παράλογο μέγεθος (0 ή 1.56 GiB)· μηχανισμός ΜΗ αποδεδειγμένος (το
μέγεθος του upload ή η πρώτη εκτέλεση του arena migration). Ένας έλεγχος θα τα έπιανε και τα δύο: `rasterizer->IsMapped(addr, guest_size)` (false
για size 0) — ΠΡΩΤΑ log-only, αποφασίζει ο χρήστης. Ο peer ξαναξεκίνησε ως `gtnikos-83` (το pipe του gtnikos-8f νεκρό)· επιβεβαίωσε τα παραπάνω.
Run 2 (043937): μόνο μενού, SDRSettingRoot, flushed, 0 υπογραφές/απορρίψεις, κανένα 153. Run 3 (04:46, ΧΩΡΙΣ watcher, `_3_unwatched_lastwrite_044706`):
~1 min, BuddyWindowRoot, flushed, 5 T# + 21 S#, 0 υπογραφές, κανένα 153 → μάλλον κλειστό με το χέρι. ⇒ Το TEST17 ΔΕΝ έχει κριθεί (το T# 0x3f80000000
δεν εμφανίστηκε σε κανένα run). ⚠ CONFOUND χρονισμού: 19 ορφανοί watchers (TEST3-16) έτρεχαν `ps -W` κάθε 2 s παράλληλα με τα runs· τους σκότωσε ο
peer ~04:50 (το TaskStop σε background task του Git Bash ΔΕΝ σκοτώνει το child του script → [[feedback-taskstop-leaves-bash-child]]).
Από run 4: ένας watcher. ⚠ Ο φάκελος `shots_<run>` φτιάχνεται όταν ΟΠΛΙΖΕΤΑΙ ο watcher, όχι όταν ξεκινά ο emulator· δεν αποδεικνύει run.

⚠⚠⚠ **27 Σεπ ~04:30 — ΤΑ GPU RESETS ΤΩΝ ΜΕΝΟΥ ΕΧΟΥΝ ΥΠΟΓΡΑΦΗ ΔΕΔΟΜΕΝΩΝ (6/6, με ΚΑΙ χωρίς debugger).**
Δύο διαδοχικές γραμμές του GpuCommandProcessor πριν από κάθε reset: `Tracking memory region 0x3f80000000 - 0x3f80000000 which is not
fully GPU mapped` → `Creating tiling pipeline Thick3DThickPrt_32 detiler` (TEST13 r2, TEST14 r1, TEST15 r2/r6, TEST16 r3/r4). Το watch
στο 0x3f80000000 ΔΕΝ υπάρχει σε κανένα από τα 11 άλλα runs· ο detiler μόνος του είναι αθώος (TEST11: χωρίς watch, συνέχισε 4353 γραμμές).
0x3f80000000 = 0x3f800000 (1.0f) << 8 → float δεδομένα διαβασμένα ως T#. Περνά γιατί `IsValidGpuMapping` (memory.h:208) = ΜΟΝΟ
`addr + size < 1 TiB`, ΟΧΙ έλεγχος mapping. ⚠ Το «0x3f80000000 - 0x3f80000000» ΔΕΝ σημαίνει μη mapped μνήμη: `Rasterizer::IsMapped`
επιστρέφει false για size 0 → `guest_size` (u32) = 0, πιθανότατα wrap από σκουπίδια διαστάσεων (διόρθωση του peer). TEST17 c48229d2 =
TEST16 + «Reject T# whose image size is zero» + [test] log ποια συνθήκη απέρριψε· κριτήριο: «Rejecting T# with zero image size
address=0x3f80000000» στα μενού ΧΩΡΙΣ nvlddmkm 153 μετά. TEST13 r1 (device lost στον αγώνα) ΔΕΝ έχει την υπογραφή → άλλη αιτία.
Οι 6 απορρίψεις tile_mode 27-30 του TEST16 είχαν ΟΛΕΣ διεύθυνση ≥ 1 TiB → τις έκοβε ήδη ο έλεγχος εύρους.
TEST16 runs: r1 κλειστό με το χέρι, r2 αγώνας ~17 s κλειστό κανονικά, r3/r4 menu resets, r4 = πρώτη φορά που ο νέος έλεγχος έπιασε
2 T# με tile_mode=28 (αλλά βλ. από κάτω: ≥ 1 TiB), r5 κλειστό κανονικά στα μενού. Logs `shad_log_test16_gt7_N_at_exit_*.txt`.
Οπλισμένα (μόνο watcher): TEST17 run 1 (πρόταση peer) + TEST16 run 6.

⚠⚠⚠ **27 Σεπ ~04:40 — ΝΕΟ PR για το catch-all (απόφαση χρήστη «new pr»):** branch **`sampler-catch-all` a053b271** στο `mine` = ΕΝΑ commit
πάνω στο origin/main d96278e1, «vk_rasterizer: Bind a default sampler for S# with undefined fields», 15 γραμμές, μόνο τίτλος, χωρίς trailer,
clang-format 19 καθαρό (το ίδιο block με το 66435d7e, χωρίς το GtSamplerDump context). Φτιάχτηκε με προσωρινό index, το working tree
(test17-tsharpsize) ΔΕΝ πειράχτηκε. **~05:10: ο χρήστης άνοιξε το PR #5137** (head a053b271 → shadps4-emu:main, 02:01Z)· τα #5132 + #5135
ΕΚΛΕΙΣΑΝ. **GoW ΔΕΝ μπορεί να το δοκιμάσει:** ο χρήστης (~05:15) «σκάει πριν»· = το γνωστό `Unknown opcode DS_ORDERED_COUNT` →
«Shader translation has failed» (TEST3 log, γραμμή 2591, πρώτος compute shader· κενό upstream #496, το #2899 έκλεισε) → ούτε pass ούτε
regression. Μένει το GoT (το bug του ConstructSharpFetch που το σταματούσε στο TEST3 διορθώθηκε upstream με #5129) — δεν έχει τρέξει. Στο κείμενο του PR ο χρήστης κράτησε FPS «2-8 → 15-24»· του είπα ότι τα 2-8 ήταν ΜΕ
debugger και ότι το TEST14 r2 (χωρίς catch-all, χωρίς debugger) έκανε ήδη 22 FPS — απόφασή του. Τα exe TEST15-17 = catch-all + 30 ακόμα
commits (bary, preload, tess, BC macro-tiled, έλεγχοι T#, instruments)· upstream main + ΜΟΝΟ το PR δεν έχει τρέξει ποτέ.
Τι ζήτησε ο squidbus (#5135, 26 Σεπ 23:28Z, αυτολεξεί): «detect these garbage samplers sooner and have a catch-all dummy sampler». Έλεγχος στο
d96278e1: οι ΜΟΝΕΣ αόριστες κωδικοποιήσεις του S# = max_aniso 5-7, filter_mode 3, mip_filter 3 (+ Custom border που διαβάζει τον πίνακα)·
clamp/depth compare/xy filter/border type καλύπτουν ΟΛΕΣ τις τιμές των bit τους, το z_filter δεν μετατρέπεται· το `GetSampler` έχει ΕΝΑΝ καλούντα
(αυτό το loop). ΔΕΝ καλύπτεται: Custom border με base ≠ 0 και σκουπίδι index (δεν το έχουμε δει). Πιθανή ένσταση reviewer: υπάρχει
`AmdGpu::Sampler::Valid()` που επιστρέφει `true` και δεν το καλεί κανείς, ενώ Buffer/Image ελέγχουν στο `GetSharp` (shader_recompiler/resource.h,
`!Valid()` → `Null()`) — το ίδιο pattern για το S# θα ήταν το «sooner».

⚠⚠⚠ **27 Σεπ ~04:32 — TEST17 ΧΤΙΣΜΕΝΟ για τα GPU resets των μενού.** Ο peer βρήκε υπογραφή σε 6/6 resets (με ΚΑΙ χωρίς debugger):
`page_manager.cpp:139 Tracking memory region 0x3f80000000 - 0x3f80000000 … not fully GPU mapped` + `Creating tiling pipeline Thick3DThickPrt_32
detiler` → reset· 0/11 στα άλλα runs. ΔΙΚΗ ΜΟΥ ανάγνωση: τα όρια είναι page-aligned και το `IsMapped` δίνει false για size 0 ΕΞ ΟΡΙΣΜΟΥ →
το image από εκείνο το T# (0x3f800000 = 1.0f ως διεύθυνση) έχει **guest_size 0** (MipInfo::size + guest_size = u32 → wrap ακριβώς στο 0),
όχι απαραίτητα αχαρτογράφητη διεύθυνση· μετά detile με range 0 + αντιγραφή ολόκληρου image από buffer 0 bytes (πιθανό, όχι αποδεδειγμένο).
`IsValidGpuMapping` = μόνο έλεγχος < 1 TiB, ΟΧΙ mapping. Branch `test17-tsharpsize` **c48229d2** = 6dbece23 + 9fb8d553 «Reject T# whose image
size is zero» (στο per-binding loop, `desc.info.guest_size == 0` → null binding + warning με διαστάσεις) + c48229d2 «[test]» (το warning του
T# λέει ποια συνθήκη: bad address/format/tile mode). exe `shadps4_test17_c48229d2_gt7.exe` (19408A98…95AA05B1), profile `C:\shadps4-test17-gt7`,
launcher `TEST17_GT7_c48229d2_tsharpsize_warm.bat` (dry run OK). ΑΠΟΦΑΣΙΖΕΙ: «zero image size address=0x3f80000000» στα μενού ΧΩΡΙΣ nvlddmkm 153.
TEST16 runs 1-5: 0 crash· 2 resets (r3, r4 = η υπογραφή)· ΚΑΝΕΝΑ tile 27-30 κάτω από 1 TiB → ο έλεγχος tile mode δεν ήταν ποτέ ο αποφασιστικός.

⚠⚠⚠ **27 Σεπ ~04:15 — TEST16 ΧΤΙΣΜΕΝΟ (δεν έχει τρέξει):** `C:\shadps4-clean` branch `test16-tsharptile` **6dbece23** = 66435d7e + ΕΝΑ commit
«vk_rasterizer: Reject T# with an undefined tile mode» (`!magic_enum::enum_contains(tsharp.GetTileMode())` στον ΥΠΑΡΧΟΝΤΑ έλεγχο T# +
`tile_mode={}` στο warning). exe `backup_exe\shadps4_test16_6dbece23_gt7.exe` (SHA256 D651C851…73667A6), PDB `pdb_test16_6dbece23`, profile
`C:\shadps4-test16-gt7` (= TEST15 χωρίς cache/log), launcher `TEST16_GT7_6dbece23_tsharptile_warm.bat` (dry run OK, διαφέρει από TEST15 σε 4 γραμμές).
Upstream (d96278e1, #5126 merged 26 Σεπ) ΔΕΝ έχει έλεγχο tile mode· κανένα issue/PR. Αν πεθάνει ΞΑΝΑ σε tile mode 29 → CB/DB path.
**Τα σπασμένα γράμματα (n→r, b/B→C) ΔΕΝ είναι το catch-all:** TEST11 t0106s έδειξε την ΙΔΙΑ πρόταση αλλιώς σπασμένη («Preee… Putton… Pring…
Pauee») — αλλάζει από run σε run (glyph atlas)· το ίδιο και τα γκρι επίπεδα/μαύρες λωρίδες του flyover (TEST11/12 = ίδια).

⚠⚠⚠ **27 Σεπ ~04:05 — TEST15 runs 4-6 χωρίς debugger: τρία runs, τρία ΔΙΑΦΟΡΕΤΙΚΑ τέλη.**
- **run 4 = ΠΡΩΤΟ catch-all run ΣΤΟΝ ΑΓΩΝΑ** (InRaceRoot 03:56:50) → ~8 s μετά `tiling.cpp:65 GetArrayMode: Unknown tile mode = 29`.
  899 S# + 233 T# απορρίφθηκαν· κανένα παλιό sampler crash. Τα 14 τελευταία μηνύματα του GpuCommandProcessor = `BindTextures` (τελευταίο
  το `:877 Unexpected metadata read`). Ο έλεγχος T# (`vk_rasterizer.cpp:882-899`) ΔΕΝ ελέγχει το `tiling_index`· TileMode = 0..26 + 31,
  άρα τα 27-30 είναι άκυρα → `FindImage` → `ImageInfo(Image,…)` (image_info.cpp:118) → UNREACHABLE. Χωρίς stack = ένδειξη, όχι απόδειξη
  (και τα CB/DB ctors καλούν `GetArrayMode`). Ίδια κατηγορία με τα S#: σκουπίδια σε αχρησιμοποίητο descriptor.
- **run 5 ΧΩΡΙΣ watcher** (ο χρήστης ξαναξεκίνησε στις 03:57:29 πριν ξαναοπλίσω)· log σώθηκε από το `prelaunch` copy του bat. Πριν τον αγώνα
  (μετά το PlayGoPreQuickRoot): `SignalHandler: 0xc0000094` (διαίρεση ακεραίου με 0) στο `0x7ffbe99e7d9b`, GpuCommandProcessor = DLL, όχι exe.
  Κανένα Application Error event. **Αμέσως ΠΡΙΝ (γραμμή 64807, τίποτα ενδιάμεσα):** `image.cpp:170 image format A2B10G10R10SnormPack32
  type 1D is not supported (… Storage | ColorAttachment …)` — το ΜΟΝΑΔΙΚΟ στα runs 4-6· το image.cpp το γράφει και ΠΑΡΟΛΑ ΑΥΤΑ καλεί
  `vkCreateImage` με τον ίδιο συνδυασμό (όρια αόριστα κατά το spec). Η διεύθυνση ΔΕΝ είναι στο exe (σταθερή βάση `0x700000000000`) ούτε σε
  module των minidumps TEST14 r1/TEST15 r2 του ίδιου boot. ⚠ **ΟΙ ΒΑΣΕΙΣ ΤΩΝ DLL ΑΛΛΑΖΟΥΝ ΑΝΑ PROCESS, ΚΑΙ ΣΤΟ ΙΔΙΟ BOOT:** nvoglv64
  `0x7ffbe5990000` (dumps 03:32/03:37) → `0x7ffbe8b10000` (TEST16 04:15), το nvrtum64 μαζί του. Μια διεύθυνση ΔΕΝ λύνεται με το module
  list ΑΛΛΟΥ process (το «HIT RVA 0xed7d9b» του probe είναι άκυρο). Σε κάθε process που είδαμε, στο 0x7ffbd…–0x7ffc2… υπάρχουν ΜΟΝΟ
  nvrtum64+nvoglv64 (driver NVIDIA 591.86) δίπλα-δίπλα → ο run 5 έσκασε σχεδόν σίγουρα ΜΕΣΑ στον driver· DLL/RVA άγνωστα. Για
  ακριβές module χρειάζεται crashcatch (dump του ΙΔΙΟΥ process). `dump_modules.ps1` = module list ενός minidump.
- **run 6 = GPU RESET ΧΩΡΙΣ debugger**: nvlddmkm 153 στις 04:00:10 = το ίδιο δευτερόλεπτο που σταματά το log (BuddyWindowRoot, κανένα
  «Device lost»). Χωρίς debugger τώρα 1/7 resets, με debugger 4/4 → ο debugger ΔΕΝ είναι αναγκαίος για reset.
- ΜΑΘΗΜΑ: ο χρήστης ξαναξεκινά μέσα σε 30 s· αν ο watcher δεν είναι οπλισμένος, το `shad_log_test15_prelaunch_<TS>.txt` είναι η εφεδρεία.
  Ο watcher (`while ! running`) πιάνει ΚΑΙ exe που τρέχει ήδη. Οπλισμένα: TEST15 run 7 + TEST14 run 3, μόνο watcher.

⚠⚠⚠ **27 Σεπ ~03:50 — TEST15 run 3 (χωρίς debugger) = ΟΧΙ device lost, αλλά το ΓΝΩΣΤΟ `liverpool.cpp:256 Unimplemented PM4 type 0,
base reg 0, size 1`** (= μηδενική λέξη στο command stream) στα μενού (AssistPreset), γραμμή 58640. Catch-all: 134 rejections, 0 παλιά.
Ίδιο bug με τα runs 309/313/320 (13-15 Σεπ) και 351/353/356 (22-24 Σεπ): «ανακυκλωμένο cmdbuf» — το παιχνίδι ξαναγεμίζει/μηδενίζει
command buffer ενώ ο CP το διαβάζει ακόμα (run 309: >3000 `[fenceorder]` πριν το θάνατο)· διακοπτόμενο. Ζεστά χωρίς debugger: 1 αγώνας
(TEST14 r2) / 1 PM4 type 0 (TEST15 r3). Οπλισμένα: TEST15 run 4 + TEST14 run 3, μόνο watcher.

⚠⚠⚠ **27 Σεπ ~03:45 — TEST14 run 2 ΧΩΡΙΣ crashcatch ΕΦΤΑΣΕ ΣΤΟΝ ΑΓΩΝΑ: 22 FPS οδηγώντας (44.7 ms), 14 FPS στο pause (TEST12: 1 FPS).**
Τα device lost των μενού = **NVIDIA TDR**: System log `nvlddmkm` id 153 «Error occurred on GPUID: b00» στις 03:32:43 και 03:37:35
(5 s / 0.3 s ΠΡΙΝ τα asserts)· ΚΑΝΕΝΑ στο run 2 χωρίς debugger. 2/2 με crashcatch πέθαναν, 0/1 χωρίς. Υπόθεση (ΟΧΙ απόδειξη): 5-8k
first-chance AV/s του debugger καθυστερούν τη CPU πλευρά και κάποια GPU δουλειά που περιμένει μνήμη της CPU περνά το όριο του driver.
Peer tally (builds ΜΕ το preload fix): 153 με debugger 4/4 (TEST13 r1-2 ΚΡΥΑ, TEST14 r1, TEST15 r2 ζεστά)· χωρίς debugger 0/3
(TEST5 r1-2 πέθαναν νωρίς από άλλο bug, TEST14 r2)· ΑΝΤΙ-στοιχείο: TEST10-12 κρύα ΜΕ debugger χωρίς 153. Τα 153 της 25/26 Σεπ =
preload bug (Invalid Read GPU VA 0x100000, διορθώθηκε 0db8c566/f13bf337), χωρίς debugger (το crashcatch υπάρχει από 26 Σεπ 20:41).
ΕΡΓΑΛΕΙΟ: `Get-WinEvent System, ProviderName nvlddmkm, Id 153` στην ώρα ενός device lost = TDR ή όχι. Το 153 υπάρχει και 09-25/26 και
00:50/00:54. ΚΑΝΟΝΑΣ πρότασης: runs για FPS/πρόοδο ΧΩΡΙΣ crashcatch. Οπτικά (και στο TEST12): αριστερό μισό ξεπλυμένο λευκό, κόκκινο
minimap, μαύρες λωρίδες, flat γκρι καθρέφτης.

⚠⚠⚠ **27 Σεπ ~03:40 — TEST15 run 2: ΤΟ CATCH-ALL ΔΟΥΛΕΥΕΙ, αλλά ΙΔΙΟ device lost στα μενού (03:37:36).** 35 «Rejecting invalid S#»
(γραμμές 59348-66246): mip_filter 3 (τα περισσότερα), max_aniso 5/6/7, filter_mode 3 (×2 — σκουπίδι που δεν crashάρε ποτέ, πιάνεται
κι αυτό), border 3 με base 0 (×3 = η περίπτωση του #5135). 0 MipFilter/MaxAniso Unreachable, 0 per-field warnings, 0 AV σε sampler.cpp.
Device lost = ΙΔΙΟ μονοπάτι με TEST14 run 1 (DetileImage → … → Scheduler::Wait → SubmitExecution:242), KeyAssign dialogs, 0 in-race·
το assert ΔΕΝ πρόλαβε να γραφτεί στο shad_log (async), μόνο στο crashcatch_report_run2. ⇒ 2/2 ζεστά runs πεθαίνουν στα pre-race
dialogs και με per-field fixes ΚΑΙ με catch-all → το device lost ΔΕΝ σχετίζεται με το sampler fix. Ύποπτοι: warm cache ή async log
(το TEST12 κρύο+sync πέρασε). Οπλισμένα: TEST15 run 3 (watcher+crashcatch), TEST14 run 2 (μόνο watcher).

⚠⚠⚠ **27 Σεπ ~03:36 — TEST14 run 1 = DEVICE LOST στα μενού ΠΡΙΝ τον αγώνα (03:32:48, 33 s μετά το EventSelectRoot), κανένα FPS.**
`vk_scheduler.cpp:242 SubmitExecution: Device lost during submit`, stack DrawIndirect → BeginRendering → UpdateImage → RefreshImage →
DetileImage → StagingBufferPool::Request → StreamBuffer … WaitPendingOperations → Scheduler::Wait (σημείο ανίχνευσης, όχι αιτία).
Clamp-log fix ΔΟΥΛΕΥΕΙ (0 γραμμές)· warm cache ΔΟΥΛΕΥΕΙ (845 preloaded, 16 compiles: 14 = ΝΕΕΣ permutations του fs 0x2a265dff από
σκουπίδια· η τελευταία στη γραμμή 75806, device lost στη 77014). mip/aniso/border/T# warnings στις γραμμές 58218-76622 = ΣΤΑ ΜΕΝΟΥ
(το σκουπίδι S# πιάνεται ήδη στο PlayGo). crashcatch 7.818 AV/s (TEST12 5.260). Το TEST12 (κρύο, sync log) ΠΕΡΑΣΕ αυτό το σημείο.
TEST15 run 1 (03:28:50) = πιθανότατα το έκλεισε ο χρήστης στα 15 s (game log έφτασε StartUpSettingProject::TopRoot)· το shad_log
έμεινε 20480 bytes = buffer του async logger, ΟΧΙ κόλλημα. TEST15 run 2 τρέχει από 03:34:09 (watcher + crashcatch)· TEST14 run 2
(χωρίς crashcatch) οπλισμένο για μετά.

⚠⚠⚠ **27 Σεπ ~03:25 — squidbus στο #5135: «whack-a-mole με αχρησιμοποίητους samplers — catch-all dummy sampler;» → TEST15.**
`test15-samplercatchall` **66435d7e** = 10baa842 + revert c3a64010 (183de6eb) + revert 531a5a70 (606f839e) + «vk_rasterizer: Bind a
default sampler for S# with undefined fields»: στο BindTextures, αμέσως μετά το GetSharp, αν `!enum_contains` σε max_aniso /
filter_mode / mip_filter (οι ΜΟΝΕΣ 3 τιμές που το gfx7 header δεν ορίζει: 5-7, 3, 3) ή Custom border με TA_BC_BASE = 0 →
LOG_WARNING «Rejecting invalid S# …» + `ssharp = AmdGpu::Sampler{}` (όλα τα σκουπίδια → ΕΝΑ cached VkSampler). Το LOD εκτός
επίτηδες (αληθινά παιχνίδια). Exe `backup_exe\shadps4_test15_66435d7e_gt7.exe` SHA256 2e5eeda7…6d02, PDB `pdb_test15_66435d7e`
b54e391e…be80a· bat `TEST15_GT7_66435d7e_samplercatchall_warm.bat` 94/94 CRLF, dry-run OK· profile `C:\shadps4-test15-gt7` =
TEST14 profile χωρίς cache/log, ίδιο warm snapshot + save A. GetSampler έχει ΕΝΑΝ caller (BindTextures)· FilterMode κανέναν.
Build 88 βήματα ~3 λεπτά. Ο peer κάνει read-only audit των άλλων μονοπατιών S#.

⚠⚠⚠ **27 Σεπ (αργά) — #5132 = το mip filter PR (το άνοιξε ο χρήστης· τίτλος = όνομα branch «Mip filter point aniso adj»,
το fork branch έχει merge 6e6c5e6e του GitHub). Border PR = **#5135** (ανοιχτό, σωστός τίτλος): `border-color-no-table` 37fc4f76 στο `mine`** = ΕΝΑ commit
πάνω στο upstream main 282f6445, ίδιο patch-id με το c3a64010 (f5381876), φτιαγμένο με προσωρινό GIT_INDEX_FILE (read-tree +
apply --cached + commit-tree) χωρίς να αγγίξει το working tree. sampler.cpp ΙΔΙΟ στο main· clang-format 19.1.5 (VS BuildTools,
= CI clang-format-19) ΚΑΘΑΡΟ — το style είναι `src/.clang-format`, ΟΧΙ στη ρίζα (χωρίς αυτό = ψεύτικο «θέλει αλλαγές»).
- Ισχυρότερη εκδοχή (έλεγχος του entry, όπως το 482b2d1a του gt7-main στις 16 Σεπ) ΑΠΟΡΡΙΦΘΗΚΕ για upstream: το IsMappedMemory
  είναι μόνο του fork· `IsValidGpuMapping` ελέγχει μόνο το όριο 40 bit· `IsValidMapping` διαβάζει το vma_map ΧΩΡΙΣ lock και
  κανένας GPU-thread κώδικας δεν το καλεί. Και τα δύο crashes (fork run 323, TEST9) είχαν base 0.
- Μετά: 103b0976 T# pair, e88a86b9 tess readlane, 10baa842 clamp log.

⚠⚠⚠ **27 Σεπ ~01:45 — TEST14 οπλισμένο (peer), έλεγχος επόμενου PR.** Run 1 ΜΕ crashcatch (= TEST12), run 2 ΙΔΙΟ bat ΧΩΡΙΣ
crashcatch = το μερίδιο του debugger (TEST12: 5.260 first-chance AV/s μέσος όρος, κάθε ένα παγώνει ΟΛΑ τα threads· το 1-7 FPS
μετρήθηκε ΥΠΟ debugger). Το f13bf337 (warm-cache preload) ΕΙΝΑΙ πρόγονος του 10baa842.
- `mip-filter-point-aniso-adj` 9c91a45c: τα 2 αρχεία ΙΔΙΑ byte-byte στο upstream main 282f6445 και στη βάση 41c0fca5 (εφαρμόζεται
  καθαρά)· το main έχει ακόμα UNREACHABLE και στα δύο· κανένα PR/issue. Τιμή 3 = `SQ_TEX_MIP_FILTER_POINT_ANISO_ADJ`
  (linux gfx_8_0_enum.h· στο gfx_7_2 δεν υπάρχει). Ο χρήστης γράφει μόνος του το PR· του έδωσα τίτλο + σημειώσεις στα αγγλικά.
- Τα test builds TEST7-14 περιέχουν το 1ο commit του #5126 (5db8d018, ίδιο SHA) και το #5114 (11d8b765), ΟΧΙ το 21cfc433 (το
  «float mode enum types», μόνο στο TEST13).
- Το `gh` ΔΕΝ είναι logged in σε αυτό το μηχάνημα → curl σε raw.githubusercontent.com και στο δημόσιο api.github.com.

⚠⚠⚠ **27 Σεπ ~01:25 — TEST12: το tess fix ΚΡΑΤΑ και το Music Rally ΤΡΕΧΕΙ (1-7 FPS). Ο δρόμος, το γρασίδι και πολλά
textures λείπουν.** TEST12 σταμάτησε σε GUEST fault (Job#28, rip 0x0e2ca83b, read 0xf423930108, 4 s μετά το TopRootWindow).
Δεν είναι crash D ούτε parked 3· ο χρήστης το ΠΑΡΚΑΡΕ. TEST13 (peer, test12 + commit του #5126): device lost μέσα στον
αγώνα μετά από τον πρώτο cs 0x328363fd, πιο μακριά από το TEST12.
- Census στο rally του TEST12 (γραμμές 55041..335308):
  - 130.637 «BindBuffers: Clamped size» σε LOG_ERROR, σύγχρονα, από το GCP thread (Log.sync = true, κονσόλα wincolor).
  - 689 compiles shaders + 478 pipelines (cold)· ο fs 0x2a265dff 40 permutations από σκουπίδια (τα specs διαβάζουν garbage).
  - 4.364 SRT walker Phi (γραμμή 614, ο ήπιος δρόμος).
- Μαύρο έδαφος = ΟΧΙ texture. Runs 250-257 του fork: το παιχνίδι άλλοτε δεν στέλνει τα draws χρώματος — race μέσα στον
  emulator (run 255 VERDICT). Δύσκολο.
- Επιλογή χρήστη = log fix + warm run. **TEST14** `test14-clamplog` **10baa842** = test12 + «vk_rasterizer: Lower buffer
  clamp log to debug» (το ίδιο γεγονός στο ClampRangeSize έγινε debug στο upstream #4884).
- Profile TEST14: state A + warm cache του TEST12 run 1 (3182 αρχεία, snapshot `warm_cache_from_test12_run1`) + Log.sync =
  false. Το bat επαναφέρει warm cache + save A σε κάθε launch.
- PR σειρά (ερώτηση χρήστη): #5131 = sample_index (ανοιχτό). ΕΠΟΜΕΝΟ = `mip-filter-point-aniso-adj` 9c91a45c (στο
  `mine`, χωρίς PR). Μετά: c3a64010 border, 103b0976 T# pair, e88a86b9 tess readlane, 10baa842 clamp log — branches από
  origin/main ΜΟΝΟ όταν το ζητήσει.

⚠⚠⚠ **27 Σεπ ~00:25 — TEST11 = και τα 3 fixes ΚΡΑΤΑΝΕ (log 20 MB· 75 T# rejects, 18 border, 135 mip, 52 aniso), επόμενο σταμάτημα =
hull shader.** `hull_shader_transform.cpp:479 patch addr non imm` στο compile του hs 0x27d2194a (crashcatch 0x80000003 + dump,
`logs\crashcatch_test11\*_run1`).
- Ρίζα: στο upstream το `ReadLaneEliminationPass` τρέχει ΜΕΤΑ το `HullShaderTransform` (recompiler.cpp). Ο compiler του GT7
  κάνει broadcast το NumPatch με αλυσίδα v_writelane και διαβάζει το lane 0. Το ConstantPropagation δεν βλέπει μέσα από
  ReadLane, οπότε η διεύθυνση του patch constant δεν γίνεται ποτέ immediate.
- Ο ΙΔΙΟΣ shader μετρήθηκε στα runs 248/249 της γραμμής gt7-main (`Documents\GitHub\shadps4\GT7_work\logs\run24[89]*.gz`,
  [tessdump]: 6 stores `…0x18*ReadLane(WriteLane(…))`). Εκεί τον έλυσε το GT_TESSLANEFIX.
- Fix `e88a86b9` «shader_recompiler: Eliminate readlanes before tessellation address analysis» (+1: `ReadLaneEliminationPass`
  στην αρχή του `TessellationPreprocess`, μόνο για TCS/TES) + instrument `94d66f03` GT_TESSDUMP (log-only, δείχνει τη
  διεύθυνση αν ξαναχτυπήσει).
- TEST12 exe `shadps4_test12_94d66f03_gt7.exe` cf6d63e3…, bat `TEST12_GT7_94d66f03_tesslane_cold.bat`, profile
  `C:\shadps4-test12-gt7`.
- ⚠ Στο TEST10 ο χρήστης έτρεξε ΠΡΙΝ οπλιστεί ο crashcatch: λέγε «περίμενε το armed».

⚠⚠⚠ **27 Σεπ ~00:12 — TEST10 launch 1: το border fix ΚΡΑΤΑ (6 warnings), επόμενο σταμάτημα = ίδια κλάση στα T#.** Το launch έγινε
ΠΡΙΝ οπλιστεί ο crashcatch, οπότε δεν υπάρχει dump. Σταμάτημα: `liverpool_to_vk.cpp:792 SurfaceFormat: Unknown data_format=19
num_format=9` (4_4_4_4 + Srgb, δεν υπάρχει στη Vulkan), αμέσως μετά το perm 16 του fs 0x2a265dff.
- Cold = 17 perms σε 9 s (τα σκουπίδια αλλάζουν το key), metas `…9267` έως `…9257`.
- Στο perm 16, flatbuf[24..31] = T# από floats (dword1 `25340000`) σε image slot που δεν γίνεται sample (flatbuf[50] = 0).
- Γιατί πέρασε: το «Rejecting invalid T#» του upstream #4884 (TheTurtle) ελέγχει κάθε enum ΧΩΡΙΣΤΑ.
- Fix: `test11-surfaceformat` **103b0976** = c3a64010 + «vk_rasterizer: Reject unsupported T# data and number format
  combinations» (+9/−1: `LiverpoolToVK::IsSurfaceFormatSupported` = lookup στον πίνακα του SurfaceFormat, ως συνθήκη της
  υπάρχουσας απόρριψης). Κάθε δεσμευμένο T# φτιάχνει `ImageInfo`, που καλεί το SurfaceFormat με το ΙΔΙΟ ζεύγος, άρα αλλάζει
  μόνο ό,τι θα έκανε assert.
- Exe `shadps4_test11_103b0976_gt7.exe` aa8d59d1…, PDB `pdb_test11_103b0976` 6e2d1577….
- Bat `TEST11_GT7_103b0976_tsharpformat_cold.bat` (ίδια λογική reset), profile `C:\shadps4-test11-gt7`.
- ⚠ Το `sed -e … > νέο` στο Git Bash ΧΑΝΕΙ τα CR (το `sed -i 's/\r*$/\r/'` όχι) → μετά από κάθε παραγωγή bat κάνε έλεγχο CRLF.

⚠⚠⚠ **27 Σεπ ~00:00 — TEST10 έτοιμο (COLD), περιμένει launch.** Border branch ΔΕΝ υπήρχε: ο peer και εγώ ψάξαμε όλα τα
worktrees (ένα κοινό ref store) και το `mine`. Το μόνο border fix είναι το 482b2d1a του fork, που καλεί το fork-only
`IsMappedMemory` (από το e5c2634f «Acts 1-5») και δεν μπαίνει στο main. Απόφαση χρήστη: fix πάνω στον κώδικα του TEST9, ΜΟΝΟ
incremental build, cold run ([[feedback-shadps4-test-first-incremental]]).
- `test10-bordercolor` **c3a64010** = 531a5a70 + «sampler: Fall back to black when the border color table is not set» (+4:
  Custom && `ta_bc_base.Address() == 0` → warn + OpaqueBlack, όπως το υπάρχον fallback όταν λείπει το extension). Καλύπτει
  τα μετρημένα TEST9 launches και το run 323 του fork, όλα με base 0.
- Exe `backup_exe\shadps4_test10_c3a64010_gt7.exe` 4ad0c23f…, PDB `pdb_test10_c3a64010` 0596e24a…. Το scm_rev δείχνει ακόμη
  531a5a70 (χωρίς reconfigure).
- Launcher `GT7_upstream\TEST10_GT7_c3a64010_bordercolor_cold.bat`. Σε ΚΑΘΕ launch: αντιγράφει το παλιό log
  (`logs\shad_log_test10_prelaunch_<TS>.txt`), μετακινεί το cache (`C:\shadps4-test10-gt7\cache_before_launch_<TS>`) και
  επαναφέρει το save A (robocopy /MIR). Άρα κάθε launch = save A + cold. Dry-run 2× σε κρυφή κονσόλα: OK.
- ⚠ Το `cmd //c` από Git Bash κολλάει στο `dir | find /c /v ""` μέσα σε for /f (το pipe του MSYS δεν δίνει EOF). Δοκίμαζε bat
  με `Start-Process cmd -WindowStyle Hidden`.
- Μετά από αυτό κάθε πεδίο του S# μετατρέπεται για ΚΑΘΕ τιμή (Filter/Clamp/DepthCompare/BorderColor)· μένουν μόνο Vulkan VU
  (minLod > maxLod, αρνητικό lod bias), όχι crash. PR branch δεν έγινε ακόμα.

⚠⚠⚠ **26 Σεπ ~23:40 — TEST9 ×3: το fix mip/aniso ΚΡΑΤΑ· και τα 3 launches πεθαίνουν στο ΕΠΟΜΕΝΟ πεδίο του ίδιου σκουπιδιού:**
custom border colour (sampler.cpp:27, host 0xC0000005 χωρίς assert, TA_BC_BASE = 0 → launch 1 διάβασε 0x7d10 = ptr 2001×16, ακριβώς όσο
λέει το snapshot `…9263`). Απόφαση χρήστη: PR για το fix → `mip-filter-point-aniso-adj` **9c91a45c** push ΜΟΝΟ στο `mine` (main ακόμη
41c0fca5, clang-format καθαρό)· το border crash το έχει ο peer (TEST10· το bat του αρχειοθετεί μόνο του το log). Το log του launch 2
ΧΑΘΗΚΕ: ο χρήστης ξανάνοιξε μέσα στο ~10 s exit check του watcher. Notes `claude` 1c63b313.

⚠⚠⚠ **26 Σεπ ~23:20 — ΡΙΖΑ του MipFilter: ο sampler ΔΕΝ ΧΡΗΣΙΜΟΠΟΙΕΙΤΑΙ σε εκείνο το draw.** Τα offsets 40-43 είναι ΣΩΣΤΑ (ένα
root s[0:1]=P, flatbuf[16..50]=P[0..34])· τα μόνα samples στο fs_samp0 είναι μέσα σε `if (flatbuf[50] != 0)` και το flatbuf[50]=0 σε
ΚΑΘΕ snapshot → η θέση κρατά ό,τι άλλο έβαλε το draw (union). Το shadPS4 φτιάχνει VkSampler για κάθε δηλωμένο S# σε κάθε draw →
UNREACHABLE. Το βρήκε ο peer· το επιβεβαίωσα byte-exact στα cache metas (TEST8 `…9266.meta`, TEST7 `…9263.meta`, flatbuf από το byte
7441, [48..49] = 1920×1080). Run 2 (ο χρήστης έτρεξε και τα δύο 23:11-23:14· και τα δύο saves bootάρουν): TEST7 → `resource.h:494
MaxAniso: Unreachable` (S# = ⅓,⅓,⅓,0 → mag/min 2 = aniso, ratio 5)· TEST8 → πάλι MipFilter (bf3c1a20…, ΧΩΡΙΣ compile του shader, ήρθε
από το cache → το «μετά από permutation» δεν είναι προϋπόθεση). 5 σταματήματα, 5 διαφορετικές τιμές. Fix (peer, τοπικό, ΟΧΙ push):
`mip-filter-point-aniso-adj` **9c91a45c** «video_core: Handle unknown sampler mip filter and aniso ratio values» +8/−1 (MipFilter 3 →
warn + Point· MaxAniso default → warn + 16.0f). **TEST9** = `test9-mipfilter` 531a5a70 = a3eb4339 + αυτό, νέο profile state A
`C:\shadps4-test9-gt7`, χωρίς GT_SAMPLERDUMP· το χτίζει ο peer, εγώ οπλίζω watcher+crashcatch όταν πει. TEST7/8 run 3 οπλισμένα.
Notes `claude` 238c384d. (Η «λάθος θέση sharp» του 22:50 πιο κάτω ΔΙΑΨΕΥΣΤΗΚΕ.) Launcher TEST9:
`GT7_upstream\TEST9_GT7_531a5a70_samplerfields.bat` (CRLF, = TEST8 env χωρίς GT_SAMPLERDUMP). Εργαλείο χωρίς run: walker + flatbuf
από την ουρά του `.meta` (`HashCombine(pgm_hash, perm)`), έλεγχος ροής από το cached `.spv` με spirv-dis
([[feedback-unused-descriptor-is-not-a-tracking-bug]]).

⚠⚠⚠ **26 Σεπ ~22:50 — PR BRANCH + TEST8.** Το fix του sample_index = `bary-smooth-sample-index` **12d41c22** πάνω στο origin/main
41c0fca5, push ΜΟΝΟ στο `mine` (το έφτιαξε ο peer· PR ανοίγει/γράφει ο χρήστης). Ένα commit μόνο με τίτλο «shader_recompiler: Define SampleId
for BaryCoordSmoothSample on the KHR path», +5/−3, blob 95853db7 = αυτό του TEST7. Ανοιχτό για τον χρήστη: έλεγχος σε 3 παιχνίδια (GoT
run σε αυτό το branch μπορεί να δείξει κάτι· το TEST3 GoT είχε ίδια σιωπηλή υπογραφή fast-fail). **TEST8** (a3eb4339 = TEST7 + #5129 +
GT_SAMPLERDUMP): ίδιο σταμάτημα MipFilter· το S# με mip 3 = 4 floats (3f540000 3c192437 3e5ca3b2 3acbd902 = 0.828/0.0093/0.216/0.0016)
από flatbuf 40-43 του fs 0x2a265dff (permutation) → ΔΕΝ είναι sampler, λάθος θέση sharp· το softclamp απλώς θα το έκρυβε. Και τα 2 profiles
(TEST7/8) έχουν νέο save → όχι ξανά run ως έχουν. Notes `claude` abbd3350.

⚠⚠⚠ **26 Σεπ ~22:12 — TEST7 run 1: ΤΟ FIX ΔΟΥΛΕΥΕΙ.** fs 0xf10530e6: «EmitSPIRV returned, 28362 words» → «CompileModule done»,
pipeline 0xa7aab6555cdf326b, ξεκίνησε το Music Rally. 26 s μετά ΝΕΟ σταμάτημα: `liverpool_to_vk.cpp:394 MipFilter: Unreachable`
(S# με mip_filter == 3· `BindTextures` ← `Draw`, αμέσως μετά από fs 0x2a265dff (permutation) / pipeline 0xce66d4cfbb5f7539). Το ίδιο 3
είχαν δει τα builds 13-14 Σεπ και του άλλου lane 21-22 Σεπ («[softclamp] ... defaulting to Linear», 55-93 φορές/run). Ανοιχτό: γνήσιο S# ή
λάθος fetch. Το #5129 (μόνο commit a099dce8..main) δεν το εξηγεί εδώ: «not flatenned» μόνο για cs 0xad74a520 / 0x40d317f7.
Watcher `test7_gt7_2` + crashcatch ξαναοπλισμένα· notes `claude` e24df914. Επόμενο = απόφαση χρήστη: PR του fix ή/και TEST8
(main 41c0fca5 + fixes + GT_* log-only instrument που γράφει το raw S# και από πού ήρθε).

⚠⚠⚠ **26 Σεπ ~22:07 — TEST7 ΕΤΟΙΜΟ, ΑΝΑΜΕΝΕΙ RUN ΑΠΟ ΤΟΝ ΧΡΗΣΤΗ.** `test7-sampleindex` **738d4095** = TEST6 d4461c4e + ΕΝΑ fix commit
(στο KHR branch: `bary_coord` και `sample_index` ορίζονται ανεξάρτητα)· τοπικό branch, ΔΕΝ έχει γίνει push. Exe
`backup_exe\shadps4_test7_738d4095_gt7.exe` SHA256 1a4ccfac...3615, PDB `backup_exe\pdb_test7_738d4095`· launcher
`GT7_upstream\TEST7_GT7_738d4095_sampleindex.bat` (GT_PASSTRACE=0xf10530e6), profile `C:\shadps4-test7-gt7\user` (save A).
Armed: watcher `RUN=test7_gt7` + crashcatch (out `logs\crashcatch_test7`). Το `C:\shadps4-clean` ελεύθερο (ειπώθηκε στον peer).
Lane notes: `claude` 1179cedf. Μετά το run: ξαναόπλισε watcher+crashcatch, διάβασε passtrace («EmitSPIRV returned» → «CompileModule
done»), crashcatch report, TDR/GPU. Αν καθαρό ΚΑΙ ο χρήστης το αποφασίσει: PR branch από origin/main 41c0fca5, ΕΝΑ title-only commit.

⚠⚠⚠ **26 Σεπ ~21:46 — TEST6 run 4 (save = κατάσταση A): ΠΕΡΝΑ ΤΟ BOOT → το save C ΗΤΑΝ η αιτία των πρόωρων θανάτων.**
Και **η ΡΙΖΑ του 0xC0000409 βρέθηκε** (crashcatch, `logs\crashcatch_test6\crashcatch_report.txt` + `crash_c0000409_tid7844.dmp`):
fast fail 7 = `abort()` από `Sirit Stream::operator<<(Id)` (`stream.h:158-161`: `value==0 → std::abort()`, ΧΩΡΙΣ μήνυμα) ←
`OpLoad` ← `EmitGetAttribute` get_set.cpp:152 = BaryCoordSmoothSample, μη-AMD path: `OpLoad(U32[1], ctx.sample_index)`.
Στο `spirv_emit_context.cpp:411-419` το `sample_index` ορίζεται ΜΟΝΟ αν `!ValidId(bary_coord)` → αν Smooth/PullModel/Centroid
όρισε πρώτο το `bary_coord`, το `sample_index` μένει 0. Upstream bug από το #4401 (ff62c995, 19 Αυγ), ίδιο στο 41c0fca5.
RTX 4070 SUPER: `VK_KHR_fragment_shader_barycentric` ναι, AMD explicit_vertex_parameter όχι. Τελευταίο passtrace:
«TranslateProgram returned, emitting SPIR-V» → όλα τα passes τελείωσαν, τα 16 Phi ΔΕΝ είναι η αιτία. Προτεινόμενο fix: στο
SmoothSample KHR branch ορίζεις `bary_coord` αν λείπει ΚΑΙ `sample_index` αν λείπει, ανεξάρτητα. Save του run 4 = κατάσταση D
στο `C:\shadps4-test6-gt7\stateD_backup_after_test6_run4`· το profile ξαναγύρισε σε A. Αναμένεται TDR μετά (16 ReadConst).
Upstream main = **41c0fca5** «Fix ConstructSharpFetch (#5129)» (26 Σεπ): μεταφέρει το `summary = SingleLoad` μέσα στο block
= το #5112 bug που είχε αναφέρει ο peer → ΔΙΟΡΘΩΜΕΝΟ upstream, βγαίνει από τη λίστα υποψηφίων. PR branch για το fix → από 41c0fca5.

⚠⚠⚠ **26 Σεπ ~21:20 — TEST6 (`test6-passtrace` d4461c4e, GT_PASSTRACE=0xf10530e6, profile `C:\shadps4-test6-gt7\user`):
runs 1-2 ΠΕΘΑΝΑΝ ΣΤΟ BOOT** (BootProject::TopRootWindow, thread Updat, guest 0xc0000005, ίδιο σχετικό σημείο και τις 2 φορές,
μετά από μία γραμμή ADHOC «nil object ... '(nil).np'» στο init_network, που δεν υπάρχει σε κανένα από τα άλλα 10 clean archives).
0 passtrace lines, ο crashcatch δεν έκανε attach. ⚠ Η υπόθεση «φταίει το `flush_level: info`» (δική μου και του peer)
**ΑΝΑΤΡΑΠΗΚΕ**: το run 3 με `""` (config byte-identical με TEST5) πέθανε ΙΔΙΑ. Το PASS_TRACE φλασάρει ΜΟΝΟ ΤΟΥ (sync=true →
`Common::Log::Flush()` = file sink), οπότε το "" μένει. Profile diff TEST5↔TEST6 = ΜΟΝΟ temp/ (σβήνεται σε κάθε boot,
emulator.cpp:604-608) + imgui/play_time. Έναντι της αφετηρίας του TEST5 run 1 (`C:\shadps4-test4-gt7\user_warm_after_runs1to3`
= κατάσταση A): ΜΟΝΟ `archived.log` + save `DRFILEIV.dat` + `sce_sdmemory/memory.dat` (+backup), γραμμένα από το TEST5 run 2
(κατάσταση C). Cache ΙΔΙΟ. Run 4 = ίδιο exe με save επαναφερμένο σε A· το C κρατήθηκε στο
`C:\shadps4-test6-gt7\stateC_backup_after_test5_run2`. Το TEST5 profile έχει ακόμα το C (για A/B «TEST5 exe πάνω σε C»).
Το `APP_DATA/logs/archived.log` είναι το game log του run που το έγραψε· τα TEST6 runs δεν γράφουν δικό τους.
Το `crashcatch` τερματίζει αν η διεργασία πεθάνει πριν το trigger → ΞΑΝΑΞΕΚΙΝΑ ΤΟ μετά από ΚΑΘΕ run, όπως τον watcher.

⚠⚠⚠ **26 Σεπ ~20:30 — TEST5 = TEST4 + preload fix (`test5-preload-bcmacro` f13bf337, exe `backup_exe\
shadps4_test5_f13bf337_gt7.exe`, profile `C:\shadps4-test5-gt7\user` = αντίγραφο του ζεστού).** 2 στα 2 ζεστά runs ΠΕΡΝΟΥΝ το
SDRSettingRoot (0 device lost, 0 GPU events) → το preload fix δουλεύει εδώ. Και τα 2 φτάνουν BuddyWindowRoot → ThinThinPrt_128 →
fs 0xf10530e6: 16 ζεύγη Phi (μόνο γρ. 613, καμία 597) → κανένα άλλο GPU-thread line → θάνατος 0xC0000409 = **3 στα 3** runs που
φτάνουν εκεί. `scratchpad/conread.exe <pid> <out>` διαβάζει (read-only) την κονσόλα του launcher μετά το exit = οι γραμμές που
χάνονται από το αρχείο. Επόμενο προτεινόμενο: GT_-gated pass trace για τον fs 0xf10530e6 (ποιο βήμα μετά το flatten πεθαίνει).

⚠⚠⚠ **26 Σεπ ~19:45 — TEST4 (assert 184 αφαιρεμένο): ΠΕΡΝΑ ΤΟ ASSERT, ΠΕΘΑΙΝΕΙ 3 s ΜΕΤΑ.** Exe `backup_exe\
shadps4_test4_8bc5639f_gt7.exe` (SHA 6ad1b223…10c0, branch `test-bcmacro-a099dce8` 8bc5639f = TEST3r δέντρο + merge a099dce8 +
ΜΟΝΟ η διαγραφή του `ASSERT(!props.is_block)`, τοπικό· PDB στο `backup_exe\pdb_test4_8bc5639f`). **Run 1 (κρύο, 19:31:33)**: 0
Critical· δημιουργείται `ThinThinPrt_128 detiler` + 7 draws με fs 0x74f5f10c· μετά `Compiling fs shader 0xf10530e6` + flatten
«Phi / Failed to compute offset for SRT walker» (γρ. 613, balanced `continue`) → το log κόβεται ΣΤΗ ΜΕΣΗ ΓΡΑΜΜΗΣ, exit
**0xC0000409** (-1073740791)· ο αγώνας είχε στηθεί (game log 19:32:23)· 0 GPU events· 405=405 distinct έναντι TEST3r. BC7 εικόνα:
ΑΚΡΙΤΗ (κανένα frame). ⚠ **Κανένα WER dump/event: `emulator.cpp:75` βάζει `SEM_NOGPFAULTERRORBOX`** → για θέση crash χρειάζεται
δικός μας handler (abort/terminate/invalid-param + MiniDumpWriteDump, GT_*-gated) ή debugger· /GS failure δεν πιάνεται in-process.
Το exe ΔΕΝ είναι CETCOMPAT. Το fs 0xf10530e6 το lab (runs 341-348) το χειριζόταν με 16 windowed ReadConst, 3 loopguards, softclamp
4 GB V# → πιθανότατα επόμενο ΞΕΧΩΡΙΣΤΟ blocker, ΑΝΑΠΟΔΕΙΚΤΟ. **Runs 2+3 (ο χρήστης ξανάτρεξε, ΖΕΣΤΟ: 628 αρχεία, «Preloaded 187»)**:
«Device lost during waiting for a frame» στο StartUpSettingProject::SDRSettingRoot + nvlddmkm 153 στα ίδια δευτερόλεπτα = το
ΠΑΛΙΟ preload bug (ίδιο με clean171_04/04b/06· το clean171_08 ΜΕ το fix πέρασε ζεστό ως BuddyWindowRoot). ⚠ **Το δέντρο
TEST3/TEST4 ΔΕΝ έχει το δικό μας preload fix** (2e767aab / 0db8c566 «Preload: build a pipeline from its own permutation's
flattened user data», μόνο στα instr-imginfo-capture / test-compute-float-mode(-41f2a428) / test-preload-udsnapshot) → ζεστά
runs από αυτό δεν λένε τίποτα· επόμενο test exe να το περιέχει. **A/B 19:53:** το exe του TEST3r (ΧΩΡΙΣ την αλλαγή του
assert) στο ζεστό του profile = ίδιο ακριβώς (Preloaded 187, device lost στο SDRSettingRoot, nvlddmkm 153 19:54:08/10) → το
ζεστό σφάλμα είναι ανεξάρτητο από το 8bc5639f (log `shad_log_test3r_gt7_2_at_exit_195422.txt`). **Run 4 (κρύο, flush info,
19:54:22):** πέθανε ΠΡΙΝ το BuddyWindowRoot, στο PlayGoProject::TopRootWindow: `Unhandled Exception code 0xc0000096 at 0xdb4443d`
(privileged instruction, νήμα Job#8@@Job#008, = eboot+0x26e443d· eboot στο 0xb460000) → ΔΕΝ ανοίγουμε τον κώδικα του παιχνιδιού.
Ίδια φάση με το TEST3 18:20 (0xc0000005, Job#33, με το assert ΠΑΡΟΝ) → 2 στα 5 κρύα runs του δέντρου TEST3/TEST4 πεθαίνουν εκεί,
ενώ τα κρύα clean171_02/03/05/10/11/13 (άλλα δέντρα) 0 στα 6· ανεξάρτητο από την αλλαγή του assert. Profile ξανά κρύο
(+flush info)· το run-4 profile κρατήθηκε στο `user_after_run4`. Log `shad_log_test4_gt7_4_at_exit_195522.txt`. ⚠ **Log κομμένο σε 942×4096**: ο logger είναι σύγχρονος
spdlog χωρίς flush_on (`"flush_level": ""`) → γράφει μόνο όταν γεμίσει το 4 KB buffer του CRT → ως 4 KB ουράς χάνονται σε
crash. Στο TEST4 profile μπήκε `"flush_level": "info"` (μόνο logging). Profile επαναφέρθηκε κρύο· το ζεστό κρατήθηκε στο
`C:\shadps4-test4-gt7\user_warm_after_runs1to3`. Logs `shad_log_test4_gt7{,_2,_3}_at_exit_{193236,193930,194020}.txt`.

⚠⚠⚠ **26 Σεπ ~19:10 — ΤΑ PR ΣΤΟ UPSTREAM.** Ο **Gih-pt** άνοιξε **#5125** (V_MIN_F64) και **#5127** (V_TRUNC_F64) → το δικό
μας `trunc-min-f64` (6487aba7, στο mine) ΔΕΝ γίνεται PR (ο χρήστης: «someone pred vmin vtrunk so we work on next issue»).
Ο χρήστης άνοιξε **#5126 «video_core: Fix compute shader floating-point mode»** = branch `compute-float-mode`, head
**00445ad4** = δικό του «Sync fork» merge (17:56) πάνω στο 5db8d018· diff προς main = 2 αρχεία +14 −1 (regs_shader.h,
vk_pipeline_cache.cpp)· CI 9/10 πράσινο, windows-sdl έτρεχε. Upstream main = **a099dce8** (#5123, μόνο signal_context.cpp).
Επόμενο πρόβλημα = `image_info.cpp:184` (ξεκίνησε μόνο ανάγνωση: μέγεθος 1402880 ξαναεπιβεβαιωμένο στο main· tile mode 16
@128bpp = 64×64 blocks). Upstream: κανένα PR/issue για το assert (το «#5018» δεν βρίσκεται πια — 404 και στα δύο repos).
**Γιατί το 184 (ανάλυση στο a099dce8, χωρίς run):** το assert γεννήθηκε στο **#307** (20 Ιουλ 2024) ως `ASSERT(!is_cube &&
!is_block)` μαζί με `ASSERT(num_bits <= 64)` = «δεν υλοποιήθηκε», όταν δεν υπήρχε macro detiler· #413 το ξανάβαλε, #5001 απλώς
το μετακίνησε. Σήμερα ΟΛΑ υπάρχουν: UpdateSize σε blocks (num_bits = bits ανά block, BC7 = 128), `GetMacroTileExtents` στήλη
128bpp, `DetileImage` διαιρεί pitch/height /4 για is_block, `TILING_MACRO_128` (στοιχείο = 16 bytes = ένα BC7 block), PRT κλάδος
`x %= macro_tile_pitch` στο tiling.comp. Το pipeline key (tile_mode, num_bits, samples) δεν ξέρει καν τι είναι block. **Δεύτερο,
ΠΡΟΫΠΑΡΧΟΝ bug:** `tiling.comp main()` κάνει macro addressing σε ΚΑΘΕ mip, και στα mips που το `ImageSizeMacroTiled` υποβίβασε
σε micro (addrlib `ComputeSurfaceMipLevelTileMode`: PRT_TILED_THIN1 → 1D όταν pitch/height < macro tile) → εδώ τα mips 3-10
θα βγουν ανακατεμένα· αφορά κάθε macro texture με μικρά mips, όχι μόνο BC. Κίνδυνος για μετά: PRT = ίσως sparse (μη mapped 64 KB
σελίδες)· το log δεν δείχνει mappings (φίλτρο).

⚠⚠⚠ **26 Σεπ ~18:50 — ΤΕΣΤ ΚΑΘΑΡΑ ΓΙΑ ΤΟ PR trunc-min-f64.** **TEST3r** (ίδιο binary με το TEST3, φρέσκο run14, κρύο)
18:46-18:47: BuddyWindowRoot 18:47:27 → `image_info.cpp:184`, όπως TEST3b και 12/13 → το 0xc0000005 του TEST3 ΔΕΝ ξαναβγήκε
(1 στα 2 runs του PR exe· δεν προκαλείται από το PR). Και τα 3 GT7 logs: 0 «Unknown opcode», ο cs 0x1c0f802e μεταφράζεται.
**Scanner `scratchpad/f64op_scan.cpp`** (walker του bitcmp_scan, control = cs 0x1c0f802e βρίσκει 1+1): V_TRUNC_F64 / V_MIN_F64
σε GoW 0/51, GoT 0/75 (dumps TEST3), και σε 1080 παλιά dumps του APPDATA ΜΟΝΟ ο ίδιος shader της GT7 1.00 (cs 0xa911a841,
CUSA24769), 0 desyncs → στο GoW/GoT ο κώδικας του PR δεν τρέχει ποτέ. Απόφαση για PR = του χρήστη.
Προηγούμενο A/B: TEST3 (exe e9125614, FPTrunc/FPMin
του PR) πέθανε 18:20 ΠΡΙΝ το BuddyWindowRoot: `0xc0000005 at 0x700000affb65` (host μνήμη, thread Job#33@@Job#063, τελευταία
σκηνή PlayGoProject::TopRootWindow). **TEST3b** (c227b3c7 = ίδιο exe, ΜΟΝΗ διαφορά το bit-exact e93c2ff8) 18:35-18:36, κρύο,
φρέσκο αντίγραφο run14: φτάνει **BuddyWindowRoot 18:36:06** και σταματά στο **`image_info.cpp:184` `ASSERT(!props.is_block)`**
(stage 0x74f5f10c) = ΑΚΡΙΒΩΣ το τέλος των runs 12/13 (upstream #5018). Logs `logs/shad_log_test3b_gt7_at_exit_183621.txt`.
Στατικά για τη διεύθυνση: ΟΧΙ module trampolines (είναι σε guest μνήμη δίπλα σε κάθε module, `module.cpp:133`), ΟΧΙ stubs
του #5109 (κάθε stub = δικό του `Xbyak::CodeGenerator(32, AutoGrow)`, page-aligned, 22 bytes· το crash είναι 0xb65 μέσα στη
σελίδα). Μόνη σημασιολογική διαφορά των δύο: V_MIN_F64 με NaN (`OpFMin` αόριστο), denormal flush, min(-0,+0). **Rerun**
`TEST3r_GT7_e9125614_rerun.bat` = ίδιο binary (αντίγραφο `shadps4_test3r_e9125614_gt7.exe`, SHA 63ceefa6), profile
`C:\shadps4-test3r-gt7\user` = φρέσκο αντίγραφο `C:\shadps4-clean-run14\user` (diff -rq ίδιο, cache 0), watcher RUN=test3r_gt7.
(Έφτασε BuddyWindowRoot → βλ. πάνω.) Αν το 0xc0000005 ξαναβγεί σε άλλο run: ίδιο RIP; ίδιο thread; — log πρώτα.
Watchers: test3_gt7_2/gow_2/got_2, test3b_gt7_2, test3r_gt7_2.

⚠⚠⚠ **26 Σεπ ~18:10 (gtnikos-8f) — PR V_TRUNC_F64/V_MIN_F64 + ΤΕΣΤ 3 ΠΑΙΧΝΙΔΙΩΝ ΠΡΙΝ ΤΟ PR.** Branch `trunc-min-f64`
= **6487aba7** πάνω στο c6b24ec1, **PUSHED ΣΤΟ mine** (τίτλος μόνο στο commit: το σώμα θα γέμιζε την περιγραφή του PR με
κείμενο AI· ίδιο tree με το ce445dd1). Το παλιό τοπικό = `trunc-min-f64-7e0c8111` (f71592ec, exe του run 14, ΑΝΕΚΤΕΛΕΣΤΟ). Το PR
το ανοίγει/γράφει Ο ΧΡΗΣΤΗΣ ([[feedback-shadps4-comments-cleanup-later]]). tests: τα 2 νέα OK· σε c6b24ec1 καθαρό τα 55 άλλα OK.
Test exe = τοπικό `test-3games-c6b24ec1` **e9125614** = c6b24ec1 + #5114 (e591fedd) + compute-float-mode + tests-gcn-storage-buffer
-access + trunc-min-f64: 56/56 gcn OK, 0 validation. `backup_exe/shadps4_test3_e9125614_{gt7,gow,got}.exe` (ΙΔΙΟ, SHA256 63ceefa6…1e55,
ένα αντίγραφο ανά παιχνίδι για τον watcher)· launchers `GT7_upstream/TEST3_{GT7,GOW,GOT}_e9125614.bat`· profiles
`C:\shadps4-test3-{gt7,gow,got}\user` ΚΡΥΑ (gt7 = αντίγραφο run14· gow/got = clean config + γενικό filter + save από APPDATA +
**dump_shaders ON** για τον έλεγχο F64 literals)· watchers v4 RUN=test3_gt7/gow/got. GoW = CUSA07411, GoT = CUSA13323.
**Δύο upstream bugs (στατικά, δεν αφορούν τα fixes μας):** (1) **#5034 (98bc3205, 24 Σεπ)**: `S_BITCMP*_B64` → `UConvert(32,U64)` →
UNREACHABLE «Conversion from U64 to 32 bits»· το δικό του test `bitcmp1_b64_bit32` σκάει 0x80000003 σε c6b24ec1 ΚΑΙ fc5d2cc2· το CI
τρέχει `ctest -E GcnTest`. 0 `S_BITCMP*_B64` σε 1519 dumps (GT7 1.00/1.71, GoW, GoT) → δεν μπλοκάρει. (2) **#5112 EmitPrologue**:
`!fetch_data` → `!fetch_data.Empty()` = ΑΝΤΕΣΤΡΑΜΜΕΝΟ (vertex+instance offset)· το ASSERT_MSG έγινε απρόσιτο. **F64 literals (#5114):**
GoW 0 σε 520 GCN dumps + 1860 cached SPIR-V (κανένα f64 constant), GoT 0 (μόνο 28 modules), GT7 0· scanners `bitcmp_scan`,
`f64lit_scan`, `f64const_scan` (SPIR-V: pre-fix literal = f64 const high=0 low≠0· έλεγχος με συνθετικό control) στο scratchpad.

⚠⚠⚠ **26 Σεπ: upstream main 7e0c8111 → c6b24ec1 (#5112 "Renderer optimizations pt1") ΣΠΑΕΙ ΤΑ ΠΑΛΙΑ PIPELINE CACHES** (στατική
ανάγνωση, όχι run): `VertexAttribute` 9→8 bytes (φεύγει το `semantic`) και `SharpFetch<T>` +4 bytes (`summary` u8 μπροστά από u32 array)
→ `sizeof(InfoPersistent)` μεγαλώνει ~0.5 KB (raw memcpy στο `Info::Serialize`). **ShaderMetaVersion έμεινε 5**, και το WarmUp
ελέγχει μόνο το device Profile → cache από exe πριν το #5112 διαβάζεται μετατοπισμένο (πιθανό assert «corrupted deserialization» ή
σκουπίδια). ΚΑΝΟΝΑΣ: exe σε c6b24ec1+ τρέχει ΜΟΝΟ με κρύο cache ή cache από exe μετά το #5112 (όχι τα run13/run14 profiles).
Upstream δεν έχει PR/issue· fix = bump ShaderMetaVersion, αποφασίζει ο χρήστης. image_info.cpp αμετάβλητο (assert ακόμα :184).
Το 2e767aab εφαρμόζεται καθαρά στο c6b24ec1.
**image_info σύγκριση (26 Σεπ, read-only, c6b24ec1):** ο κανόνας του UpdateSize = addrlib (BC→blocks/128bpp, pow2 σε blocks,
tile_mode 16 @128bpp = 64×64 blocks = ΑΚΡΙΒΩΣ ένα 64 KB PRT tile, degrade σε 1D όταν mip < tile, ίδιο με
`ComputeSurfaceMipLevelTileMode`)· 1402880 επιβεβαιωμένο με το χέρι. Το assert ξε-σχολιάστηκε στο #413 (Αύγ 2024), ΠΡΙΝ υπάρξει
macro detiler· το #3374 (Αύγ 2025) έφερε γενικό macro detiler ανά bpp (TILING_MACRO_128) με block pitch/height και PRT x%=pitch.
Άρα το guard είναι stale → υποψήφιο fix = σβήσιμο της γραμμής 184. Ξεχωριστό, ΠΡΟΫΠΑΡΧΟΝ: ο detiler κάνει macro addressing σε ΟΛΑ
τα mips, και σε όσα το size rule υποβίβασε σε micro (αφορά κάθε macro texture). Δεν υπάρχουν tests για texture_cache στο `tests/`.
Επίσης στο c6b24ec1 (εύρημα gtnikos-8f, επιβεβαιωμένο στατικά): EmitPrologue `!fetch_data` → `!fetch_data.Empty()` ανεστραμμένο.
**TEST3 GoT/GoW (26 Σεπ 18:16-18:17, exe e9125614):** GoW πέθανε σε `Unknown opcode DS_ORDERED_COUNT` → «Shader translation
has failed» (γνωστό κενό upstream, #496· το #2899 έκλεισε χωρίς να μπει). GoT: log κομμένο στα 184320 bytes (unflushed), χωρίς
assert/WER· τελευταίο warning `Sharp source was not flatenned`. **Bug του #5112 στο `ConstructSharpFetch`**: το `Invalid`
ξαναγράφεται ΠΑΝΤΑ σε `SingleLoad` (unconditional γραμμή μετά το if) → `Fetch` κάνει memcpy από `flatbuf + 0xFFFF` αντί να δώσει
Null sharp. + σπάνια τρύπα: dword0 immediate με offsets 1..N-1 περνά ως SingleLoad. Στατικό· ύποπτο για το GoT, όχι αποδεδειγμένο.
0 τέτοια warnings σε 40 GT7 logs.
**26 Σεπ βράδυ:** ο χρήστης άνοιξε **#5126** (compute-float-mode, κείμενο ΧΩΡΙΣ δήλωση AI + «53 GCN tests pass» + typo — του
είπα να το κάνει Edit). Ο Gih-pt άνοιξε upstream **#5125 (V_MIN_F64) και #5127 (V_TRUNC_F64)** → το δικό μας trunc-min-f64 ΔΕΝ
γίνεται PR. Upstream main = **a099dce8** (= c6b24ec1 + #5123 IsExecuteError bits)· τα τρία bugs του #5112 ακόμα εκεί. Ο gtnikos-8f
χτίζει `test-bcmacro-a099dce8` = main + fixes + trunc-min + **σβήσιμο του ASSERT(!props.is_block)** = το test του δικού μου fix·
του έστειλα τα κριτήρια (guest_size 1402880, κρύο cache, detiler-mip περιορισμός).
**TEST4 (19:31, exe 8bc5639f, κρύο): το fix ΔΟΥΛΕΥΕΙ ως εκεί που φτάνει** — κανένα assert, `ThinThinPrt_128 detiler` για ΠΡΩΤΗ
φορά, 7 draws με fs 0x74f5f10c· μετά compile fs **0xf10530e6** (12 flatten Phi errors) → θάνατος **0xC0000409** (fail-fast:
abort/uncaught exception/invalid-param), log = 942×4096 bytes κομμένο (ΑΦΛΟΥΣΤΟ τέλος, η αιτία ΔΕΝ είναι στο αρχείο). Το 0xf10530e6
δεν το είχε μεταφράσει ΠΟΤΕ upstream build· στο gt7-main είχε ειδικό χειρισμό (dynrc window «16 unresolvable ReadConst», loop_wrap_guard
cap 16384) → επόμενος δύσκολος shader. Εργαλείο χωρίς κώδικα: `"flush_level": "info"` στο config (spdlog flush_on). Τα ζεστά 2/3 (device
lost SDR + nvlddmkm 153) = ΤΟ ΠΑΛΙΟ preload bug: το 8bc5639f ΔΕΝ έχει το 2e767aab/0db8c566 (git merge-base) → το TEST3/4 stack λείπει ένα fix μας.

⚠⚠⚠ **clean171_13 (26 Σεπ 00:11, ΚΡΥΟ, exe 21e6a019 = 68d953be + GT_IMGINFO_LOG): capture ΕΤΟΙΜΟ + δύο ευρήματα.**
(1) Το T# του assert: **BC7 sRGB 1024², 11 mips, tile_mode 16 ThinThinPrt / array_mode 5 PrtTiledThin1 (PRT!), pow2pad 1,
fs 0x74f5f10c image 4, addr 0x30041e0000**· ο macro δρόμος θα έδινε guest_size 1402880 (mips 0-2 macro 64×64 blocks,
3+ → micro). Log `logs/shad_log_clean171_13_at_exit_001305.txt`, γραμμές `imginfo_lines_clean171_13_*`.
(2) **ΤΑ ΓΡΑΜΜΑΤΑ ΔΕΝ ΛΕΙΠΟΥΝ — ΛΕΙΠΟΥΝ ΜΟΝΟ ΜΕ ΖΕΣΤΟ CACHE.** Κρύα 10/11/13 (screenshots): κείμενα SDR + Music Rally
ΟΛΑ εκεί· ζεστά 07/08/12: άφαντα. Και **το «massive fps drop» = το κόστος του κειμένου**: με [[gt7-log-frame-counter]]
12 = 57-60 fps παντού, 13 = 5.5-10 στο SDR, 3.6 στο Music Rally (28 s), 56-60 στις μαύρες ενδιάμεσα, pad 30/s σταθερό.
ΟΧΙ compile (2ο SDR: 0 shaders, 7.8 fps), ΟΧΙ CPU font (451 vs 477 glyphs), ΟΧΙ μηχάνημα/instrument (10/11 ίδια).
Το cache του 12 = γραμμένο από το exe του 11· τα serialization versions ΙΔΙΑ ανάμεσα στα δύο exe. Ανοιχτά (ξεχωριστά bugs):
γιατί το preload χάνει το κείμενο, πού πάει ο χρόνος του frame με κείμενο. Το 13 άφησε ζεστό cache ΤΟΥ ΙΔΙΟΥ exe (625 αρχεία).

⚠⚠⚠ **clean171_12 (25 Σεπ 23:57, ζεστό, exe 68d953be): φτάνει στο BuddyWindowRoot = οθόνη Music Rally (εξώφυλλα +
logo ζωγραφισμένα, ΚΕΙΜΕΝΑ ΑΚΟΜΑ ΑΦΑΝΤΑ), σταματά στο `image_info.cpp:184`. compute FLOAT_MODE ΕΠΙΒΕΒΑΙΩΘΗΚΕ: 63/63 cs
runtime == register (denorm64=3)· 0 GPU resets· branch `compute-float-mode` 5db8d018 PUSHED, draft συμπληρωμένο, PR όχι.**

⚠⚠⚠ **26 Σεπ ~00:10 — ΣΥΓΧΡΟΝΙΣΜΟΣ με upstream main `41f2a428` + σχόλιο maintainer στο PR #5114.** Ο χρήστης άνοιξε
μόνος του το **PR #5114** «Fix F64 literal operand decoding» (25 Σεπ 20:08Z, branch `f64-literal-high-dword` = 466af2b1,
δύο «Sync fork» merges δικά του, CI πράσινο). 20:40Z **DanielSvoboda (Member): «στο GTA V η φωτεινότητα γίνεται πολύ
έντονη με το PR»** (screenshots main/PR). Ο χρήστης ΔΕΝ έχει GTA V. Η αλλαγή αγγίζει ΜΟΝΟ literal σε VOP1 `V_CVT_I32/F32_F64`,
`V_FLOOR/FRACT/RCP/FREXP_*_F64` και VOPC `V_CMP_*_F64` (VOP3 δεν παίρνει literal στο GCN2)· πριν = denormal ≈ 0.0. Ο κανόνας
επιβεβαιώθηκε και στο LLVM (`AMDGPUDisassembler::decodeLiteralConstant`: FP64 → `Val <<= 32`). Ανοιχτό: ποιο main
σύγκρινε, ποιος shader του GTA V έχει F64 literal (ζήτα shader dump). Tests στο 41f2a428: main 53/98, runner 53/0, literal
54/102, runner+literal 54/0, negctl αποτυγχάνει, compute 53/98, trunc-min+runner 64/0. Branches: runner 70f538ab
(merge, PUSHED), compute 5db8d018 (τοπικό), trunc-min 474ccb01 (τοπικό), run stack `test-compute-float-mode-41f2a428`
68d953be (exe 2b675f8c, backup `shadps4_clean_68d953be_synced_computefloat_test.exe`). **clean171_12 ΕΤΟΙΜΟ** (ζεστό,
profile = τέλος run 11, αντίγραφο `user_after_clean171_11`, watcher v3). Η άλλη συνεδρία (gtnikos-f5, V_INTERP/
image_info) παίρνει το **13** με ΔΙΚΟ της profile `C:\shadps4-clean-run13\user`· συντονισμός checkout με SendMessage.
Git Bash `sed -i` σε CRLF .bat = σβήνει τα CR (λάθος 44 στις σημειώσεις claude 9f501310).

⚠⚠⚠ **25 Σεπ ~23:30 — V_INTERP_MOV_F32 ΛΥΘΗΚΕ upstream: #5087 merged ως `23356292`, byte-for-byte ίδιο με ό,τι
δοκιμάστηκε στο GT7.** clean171_10 (capture, exe `b17b3fcb` = F64 σειρά 57ab6276/0dd36386/84e32311 + instrument
`GT_INTERP_LOG`): fs 0x74f5f10c off 0x0bd8 raw 0xc81e1e00 = `MOV v7, P10, attr7.z`· `SPI_PS_INPUT_CNTL_7=0x7` (smooth,
όχι default/passthrough)· ο shader κάνει MOV P0/P10/P20 στο attr7.xyz και ΠΡΟΣΘΕΤΕΙ ΠΙΣΩ το P0 → θέλει τις διαφορές του
hardware. clean171_11 (= 10 + #5087, exe `8e358395`, έλεγχος με string μέσα στο binary — ο τίτλος παραθύρου δείχνει
παλιό b17b3fcb): 65/65 VINTRP, 6 FSub στο IR, το draw φτάνει στο binding. **Επόμενο blocker: `image_info.cpp:185`
(184 στο 41f2a428) `ASSERT(!props.is_block)` στο macro-tiled κλαδί του `ImageInfo::UpdateSize`** — BC texture σε
macro-tiled mode στο `BindTextures` του fs 0x74f5f10c (BuddyWindowRoot, 23:28:08)· = upstream issue #5018 (The Swapper) — ⚠ 27 Σεπ: 404 στο shadPS4 ΚΑΙ στο compatibility repo, 0 hits org-wide· ΜΗΝ το αναφέρεις,
χωρίς PR· το assert προϋπήρχε του #5001 (ΟΧΙ regression). Ο ίδιος fs έχει 16 αποτυχίες SRT walker (Phi) αλλά κανένα
«Sharp source was not flatenned» → δεν φταίνε για το T#. Fix ΔΕΝ ξεκίνησε (περιμένει εντολή· πρώτο βήμα = capture του
T#: dfmt/tile mode/array mode/μέγεθος/διεύθυνση). Εξάρτηση: σε σκέτο main το GT7 σταματά νωρίτερα στον cs 0x1c0f802e
(Unknown V_MIN_F64/V_TRUNC_F64, clean171_01). Profiles: `user` = τέλος run 11, `user_after_clean171_10`,
`user_before_clean171_10` (= προϋπόθεση run 09). Watcher `scratchpad/watch_interp.sh` (RUN/EXE από env). Τοπικά
branches, ΚΑΝΕΝΑ push: `instr-interp-capture`, `test-interp-mov-pr5087`, `pr5087-upstream`,
`negctl-pr5087-tests-on-main`. Μάθημα: [[feedback-check-existing-branches-first]] (και upstream PR/issues).

⚠⚠⚠ **25 Σεπ βράδυ — clean171_08: το preload fix 0db8c566 ΚΡΑΤΑΕΙ** (ζεστό cache, SDR δύο φορές, κανένα
nvlddmkm 153, τέλος στο V_INTERP_MOV_F32 όπως τα κρύα)· τα γράμματα λείπουν ακόμα. **Εντολή χρήστη: σειρά F64 σε
ξεχωριστά PR branches πάνω στο upstream e4ca3496**: `tests-gcn-storage-buffer-access` 88b44339 και
`f64-literal-high-dword` 11d8b765 **PUSHED στο mine**· `compute-float-mode` 69818cd1 ΤΟΠΙΚΟ ώσπου να περάσει το
GT7 run 09 (`GT7_clean171_run09_computefloat_warmcache.bat`, exe 9098734f… = test-compute-float-mode 6d36f830)·
`f64-trunc-min` 228bf562 ΤΟΠΙΚΟ, ΟΧΙ για PR (NaN F64, IEEE_MODE/DX10_CLAMP, omod). Drafts στο
`patches_clean/pr_drafts/`, NOTES §17. Ο watcher v2 θέλει 4 συνεχόμενες αποτυχίες του `ps -W` (ο παλιός έκλεισε στα
5 s του 08). Το preload fix ΔΕΝ γίνεται push σε αυτή τη δουλειά.

⚠⚠⚠ **25 Σεπ ~01:00 — σειρά F64 v2, PR ΣΕ ΑΝΑΜΟΝΗ.** Τρία ΤΟΠΙΚΑ commits στο `C:\shadps4-clean` (τίποτα
pushed): `pr-gcn-test-features` 57ab6276 (ο runner ενεργοποιεί storageBuffer8/16BitAccess — 98 VUID 08740 στο
main → 0) → `pr-f64-literal` 0dd36386 (literal = high dword ΜΟΝΟ για IR::F64 + shaderFloat64) →
`pr-f64-trunc-min` 84e32311 (TRUNC/MIN στα bits + `|| operand.type == Float64`· src ίδιο με το v1 65fa8e0c).
v1 = tags `f64-v1-*`. Tests: 62/62, **0 validation messages χωρίς όριο επανάληψης**, αρνητικοί έλεγχοι και για
τα δύο κομμάτια του literal. ⚠ **Το compute FLOAT_MODE ΔΕΝ διαβάζεται ποτέ από τον emulator** (Compute case του
`BuildRuntimeInfo` = memset 0) — το «0x00/flush» ήταν προεπιλογή, όχι μέτρηση. **clean171_04/04b (06:52-06:53):**
50/50 programs FLOAT_MODE 0xC0, DX10_CLAMP 1, IEEE 0· και τα 21 compute παίρνουν denorm64 0 αντί 3 (ζωντανό
bug)· οι fp64 shaders ΔΕΝ εκτελέστηκαν. Και τα δύο πέθαναν στο πρώτο SDRSettingRoot με device lost, ΧΩΡΙΣ κείμενο
στην οθόνη — πρώτα runs με ζεστό cache (Preloaded 186, 0 compiles). Το 03 (άδειο cache) πέρασε.
**clean171_05 (08:11-08:13, άδειο cache): ΚΑΝΕΝΑ device lost** — δύο φορές SDRSettingRoot, PlayGo, τέλος στο γνωστό
V_INTERP_MOV_F32. **Οι fp64 shaders ΜΕΤΡΗΘΗΚΑΝ:** 0x1c0f802e / 0x2b96ae5c = 0xC0 / DX10_CLAMP 1 / IEEE 0, runtime
denorm64 0 αντί 3· 187/187 programs ίδια modes. Κλείνει το «IEEE/DX10 του shader»· το compute FLOAT_MODE fix γίνεται
ΠΡΟΑΠΑΙΤΟΥΜΕΝΟ για να είναι ακριβές το 84e32311 σε αυτόν τον shader. Ανοιχτά για PR: NaN F64 (AMD), output
modifiers. **clean171_06 (08:28, ζεστό cache του 05, ίδιο exe): ξανά device lost στο SDR** → ζεστά 3/3 πέθαναν,
κρύα 2/2 πέρασαν· στο System log **nvlddmkm Event 153 (GPU reset) μέσα στο δευτερόλεπτο που ανοίγει το SDR, σε
κάθε ζεστό run, κανένα στα κρύα**. Ο χρήστης: «στο lab είχαμε το ίδιο και το λύσαμε» → ελέγχθηκε: το device lost
του lab = LDS Commit = ΗΔΗ upstream (#5070)· τα γράμματα του lab = δικό μας GT_STREAM_MEMO· το `4720205e` = δικό
μας GT_DEFER_EOP. Τίποτα από αυτά δεν ισχύει εδώ. Πέντε ελαττώματα του upstream preload (NOTES §15), κανένα ακόμη
αποδεδειγμένα η αιτία — το πιο χειροπιαστό: το preload χάνει το `fetch_shader` σε pipeline με GS (es 0x72d3a762 +
gs 0x227b3323). **clean171_07 (Crash Diagnostic Layer): ΑΙΤΙΑ ΒΡΕΘΗΚΕ** — dump (στον ΠΡΟΕΠΙΛΕΓΜΕΝΟ φάκελο
`%USERPROFILE%\cdl\<stamp>`, οι ρυθμίσεις του shadPS4 δεν έφτασαν στο layer): κόλλησε `vkCmdDispatch` του
cs_0x490b6362, Invalid Read στο GPU VA 0x100000. Τα 4 permutations του έχουν mip array 9/1/7/8 bindings· το preload
στήνει το layout ΟΛΩΝ από το στιγμιότυπο flattened_ud_buf του πρώτου record (`NumBindings`). Fix υπό δοκιμή:
branch `test-preload-udsnapshot` `0db8c566` (μία γραμμή στο `LoadPipelineStage`), exe 930a1b2a…. **clean171_08
ΕΤΟΙΜΟ** = 06 + fixed exe μόνο, profile από `user_after_clean171_05`· watcher `watch_clean171_shots.sh` βγάζει
screenshots μόνος του. Τα γράμματα: ξεχωριστό θέμα, ανοιχτό (ο χρήστης: «still no font» στο 07). ΜΗΝ ξαναχτίσεις το RelWithDebInfo. Όλα στο `GT7_upstream\patches_clean\f64_trunc_min_NOTES.md`
§14. Επόμενο blocker (ΜΗΝ το αγγίξεις χωρίς εντολή): V_INTERP_MOV_F32. Σχόλια/commit messages = drafts για τον χρήστη.

⚠⚠⚠ **24 Σεπ ~23:00 (χρήστης): «we work with 1.71 from now on».** Η καθαρή γραμμή τρέχει πλέον την
**CUSA24767 v01.71** (`ps4games\CUSA24767`, 8.3 `CUSA24~2`) όπως είναι εγκατεστημένη (eboot `8101d76a…` =
τα δύο local-save patches του owner, `app_param_0.sfo` automation — αρχεία του offline lane, ΠΟΤΕ αλλαγές),
σε **ιδιωτικό portable profile `C:\shadps4-clean-run\user`** (αντίγραφο save/config· κενό cache).
Launcher `GT7_upstream\GT7_clean171_run01.bat`, watcher `scratchpad/watch_clean171.sh` (μόνο το καθαρό exe
μετράει, `ps -W`· αρχειοθετεί ΚΑΙ το game log). Το clean01 της 1.00 (crash eboot+0x101aac6 στα 17 s, μετά
από 19 `sceSaveDataGetSaveDataMemory2`) παρκαρίστηκε. ⚠ Στο κοινό profile ο upstream έτρεχε ΧΩΡΙΣ pipeline
cache: βλέπει το profile blob του lab (60 ≠ 64 bytes) και κλείνει όλο το cache.

⚠⚠⚠ **ΝΕΑ ΚΑΤΕΥΘΥΝΣΗ 24 Σεπ 2026 (χρήστης): «remove GT_* and we start from error one for general fix».**
- **Καθαρή γραμμή = το τοπικό branch `main`** (καθαρό upstream, 0 `GT_*`· fast-forward στο 19700eba) στο
  worktree **`C:\shadps4-clean`** με δικό του Build. Build `GT7_upstream\build_clean.bat`, run
  `GT7_upstream\GT7_clean_run01.bat` (καθαρίζει κάθε GT_*, `run_gt7.ps1 -WhatIfOnly` για το config,
  ξεκινά το καθαρό exe), watcher `scratchpad/watch_clean.sh`. Μέθοδος: πρώτο σφάλμα → root cause →
  ΕΝΑ γενικό fix σε δικό του branch από το `main` → επόμενο σφάλμα.
- **Το lab ΜΕΝΕΙ ως backup για παιχνίδι** («keep it saved… have the gt code ready for use»): `gt7-main`
  `f540244b`, tag `gt7-lab-backup-20260924`, exe `GT7_upstream/backup_exe/shadps4_lab_f540244b.exe`.
  Τελευταία ΑΠΟΔΕΔΕΙΓΜΕΝΑ παικτή κατάσταση: `gt7-pre-upstream-5047` (runs 355-358).
- Run 359 (merge 4e0b250f) = OOM στα 65 s επειδή το merge μου πέταξε το buffer-side GT_SOFT_CLAMP·
  επαναφέρθηκε στο f540244b. Λεπτομέρειες στο branch `claude` ([[shadps4-claude-notes-branch]]).

⚠⚠ **ΑΛΛΑΓΗ ΤΡΟΠΟΥ (επιβεβαιωμένη από τον χρήστη 13 Σεπ 2026): η γραμμή δουλεύει πλέον ΠΑΝΩ ΣΤΟ UPSTREAM
MAIN, με ΜΟΝΙΜΑ, γενικά fixes — όχι προσωρινά stubs/GT_* gates.** Τα runs 250-274 παρακάτω (κίτρινο έδαφος,
readbacks, whitewash) είναι ΙΣΤΟΡΙΑ της παλιάς φάσης bring-up στο `gt7-v0.18.0`, όχι η τρέχουσα δουλειά.
Μετρημένο 13 Σεπ: το working tree ήταν ακόμη checked-out στο `gt7-v0.18.0` (259 ahead of origin/main,
τελευταίο commit "Torn descriptors"), αλλά η ζωντανή δουλειά είναι:
- **`gt7-main`** (266 ahead of `origin/main`, τελευταίο 11 Σεπ «Probe 308: reach the Single Race screen»)
  — η γραμμή GT7 ξαναχτισμένη πάνω στο upstream main· `gt7-upstream-sync` = το merge-branch από όπου βγήκε.
- **`pr-general-fixes`** (6 καθαρά upstream-style commits: shader_recompiler loop-exit wrap guard,
  DS_SWIZZLE_B32 → subgroup shuffle, 64-bit compares + F64 ops, buffer_cache write barrier, coroutine
  frame free, pooled-object destroy) και **`pr-descriptor-dword-mask`** (2 ahead, 13 Σεπ) = branches για
  PRs στο upstream. ΕΝΑ γενικό fix ανά PR, χωρίς Co-Authored-By (δες [[feedback-shadps4-comments-cleanup-later]]).
- Νόμος: [[feedback-shadps4-general-fixes-final-build]] — ό,τι δουλεύει γίνεται default-on για κάθε παιχνίδι
  ή φεύγει. 13 Σεπ μετρήθηκαν ακόμη **135 διακριτά `GT_*` ονόματα σε 61 αρχεία του src** (bring-up
  διαγνωστικά που δεν έχουν καθαριστεί ακόμη).
- Η ερώτηση «shadPS4 ή PS5 emulator» απαντήθηκε 13 Σεπ: PS5 emulation (Kyty, Sharp MU) μπουτάρει λίγα
  μικρά παιχνίδια, AAA εκτιμάται 2029-2030+, άρα ΔΕΝ είναι επιλογή· η γραμμή συνεχίζει στο shadPS4 ως
  συνεισφορά γενικών fixes στο upstream.

**ΚΑΤΑΣΤΑΣΗ 13 Σεπ 2026 (runs 309-311, worktree `C:\shadps4-gt7`, branch `gt7-main`):**
- **4720205e «Complete deferred fences in order»** = η πρώτη μόνιμη διόρθωση της νέας φάσης: το
  deferral των EOP/EOS/ReleaseMem έπαιρνε «άδειο ανοιχτό cmdbuf» για «αδρανής GPU» και έγραφε fences
  ΕΚΤΟΣ ΣΕΙΡΑΣ (run 309: >3000 `[fenceorder]` ως τα 180 s, θάνατος σε PM4 type-0 = ανακυκλωμένο cmdbuf).
  Τώρα `FenceWaitTick`: με δουλειά → CurrentTick+Flush, χωρίς → CurrentTick-1 αν δεν έχει ολοκληρωθεί.
  Run 310 (917c4786, όργανο διορθωμένο): **0 `[fenceorder]`**, το type-0 δεν επανήλθε, Music Rally
  ολοκληρώθηκε, **η οθόνη setup του Single Race επέζησε για πρώτη φορά σε 8 runs** και ο αγώνας έτρεξε
  ~4,5 λεπτά. Ο χρήστης το επικύρωσε ανεξάρτητα και ζήτησε: η αλλαγή των fences ΜΕΝΕΙ ΑΝΕΓΓΙΧΤΗ.
- Δύο σχεδιαστικές τρύπες που μένουν για τη φάση PR (ΟΧΙ τώρα): (α) το `HasPendingGpuWork()` μετρά
  μόνο draws/dispatches (RecordGpuWork), όχι DMA copies/uploads/λήψεις εικόνων → fence μπορεί να
  ολοκληρωθεί πριν από copy της ίδιας ουράς, και το `texture_cache.cpp:151` βάζει στο priority FIFO
  πράξη για το ΑΝΟΙΧΤΟ tick χωρίς Flush (head-of-line)· λύση = dirty flag στον scheduler.
  (β) το immediate path έχει παράθυρο ως το ξύπνημα του priority νήματος· λύση = immediate μόνο με
  άδειο FIFO. Το DMA (`-Dma`) ΑΔΟΚΙΜΑΣΤΟ με τη νέα σειρά.
- **Single Race crash (eboot+0x344789e, slot 0x1020473ff8):** hwwatch run 310 = 1608 traps, ΟΛΕΣ οι 64
  εγγραφές του emulator = άμεσο ReleaseMem, 32-bit τιμή 1 στα +4, καμία πάνω σε ζωντανό δείκτη. Το slot
  είναι {32-bit payload, 32-bit label} και τα έξι παλιά crashes διάβασαν κανονικά signalled label
  `{payload,1}` σαν δείκτη από τον **deadline/timeout dispatcher του παιχνιδιού**. Η αιτία είναι ΟΤΙ
  φτάνει σε timeout (run 310: στάσιμο 45,9 s με τρεις ουρές σε WaitRegMem, gfx 0x205d2c27c==1,
  vq2 0x101e32be80==0, vq3 0x102023ffdc==1, λύθηκε μόνο όταν το παιχνίδι ξαναϋπέβαλε), όχι η εγγραφή.
- **Θάνατος run 310 (t≈1300 s, στον αγώνα):** host AV στο διαγνωστικό `GtNoteZpass` διαβάζοντας
  ZPASS results στη guest 0x7fc00 (εκτός VMA). ⚠ Τα «54 φωλιασμένα IndirectBuffer» της στοίβας ΔΕΝ
  είναι απόδειξη σκουπιδιών (διόρθωση 13 Σεπ, run 311a): ο shadPS4 υλοποιεί και τα **chained** IB
  (CHAIN=1 = συνέχεια στο ίδιο επίπεδο, έτσι δένει το Gnm τα chunks ενός command buffer) με αναδρομή,
  άρα 54 frames = μακριά αλυσίδα chunks σε καρέ με 15-18k draws. Η ΜΟΝΗ ένδειξη διαφθοράς στο 310
  είναι ο ένας δείκτης 0x7fc00 μέσα στο EVENT_WRITE — ή διαφθορά μνήμης ή λάθος αποκωδικοποίηση.
  Υποψήφιος (ΜΗ αποδεδειγμένος): stale readback που ξαναγράφει μνήμη την οποία η CPU ήδη ξανάγραψε.
- **Βλάστηση που «πετάει»** (Music Rally): ΑΜΕΤΑΒΛΗΤΗ/χειρότερη με καθαρή σειρά fences → ξεχωριστό
  data-lifetime θέμα, ΟΧΙ fences. Τα `[indargs]` δείχνουν indirect args ΟΧΙ gpu-modified, max index
  count ~1260 (μικρά props) — τα «σεντόνια» δεν είναι indirect draws με τεράστια counts.
- **1-2 fps στον αγώνα = CPU ανά draw** (15-18k draws/frame × ~40 µs στον CP, Music Rally ~240
  draws/frame), όχι fences· 15/16 μεγάλα στάσιμα = shader compile (88-95%). Ο χρήστης: ΜΗΝ το βελτιστοποιήσεις τώρα.
- **Run 311 (05a12e47, exe 13:28)** = μόνο διαγνωστικά, ίδια gates με 310: `[ibchain]` σταματά στην πρώτη
  αδύνατη μετάβαση IB (gfx: nested ≥1 ήδη μέσα σε IB2· compute: ≥2) και τυπώνει αλυσίδα, γονέα ±dwords,
  παιδί (VMA/readable/32 dw/ταξινόμηση), `DescribeTrackedPage` ανά σελίδα και **νέο ring readbacks**
  (`BufferCache::NoteReadback`: copy recorded tick / written back sync-async / withheld gpu-cpu-modified)·
  `[zpass]` δεν αποαναφέρει unmapped. Ο cache ΔΕΝ κρατά πότε έγραψε η CPU μια σελίδα ούτε γενιές —
  μόνο τρέχοντα dirty bits (το λέμε ρητά στην αναφορά). Ζητούμενο του χρήστη: CORRUPTION POINT / IB
  CHAIN / CORRUPTED MEMORY / LAST KNOWN WRITERS / READBACK CHRONOLOGY / CACHE STATE / ROOT CAUSE STATUS /
  NEXT FIX. Logs: `GT7_upstream/logs/shad_log_run309_*_pm4type0_crash.txt`, `shad_log_run310_*_singlerace_crash.txt`.
  **Run 311a (05a12e47, 15:40, patched παιχνίδι, `GT7_probe311_offline.bat`): ΣΚΟΤΩΘΗΚΕ ΑΠΟ ΤΟ ΟΡΓΑΝΟ ΜΟΥ
  στο tick 2 / seq 4, 16 s μετά την εκκίνηση, πριν από καρέ** — ο ανιχνευτής μετρούσε ως επίπεδο τα πακέτα
  με CHAIN=1 (GT7 boot: ACB ring→IB1 267 dw →chain stub 4 dw →chain RELEASE_MEM 7 dw· το DCB ίδιο). Διόρθωση
  0679716a (exe 15:49): chained = ίδιο επίπεδο, δεν μετρά, συν warning `[ibchain] ... leaves N dword(s) after it`
  όταν chain packet δεν είναι το τελευταίο του buffer (το hardware δεν επιστρέφει ποτέ, ο parser μας εκτελεί
  ό,τι ακολουθεί — υποψήφιος μηχανισμός «σκουπιδιών» αν πυροδοτήσει). Το patch του παιχνιδιού ΔΕΝ δοκιμάστηκε
  (log: `pdiWheel_0.prx` λείπει → `app_param_0.sfo` διαβάστηκε, offline mode, 0 fenceorder). Log:
  `logs/shad_log_run311_2026-09-13_offline_crash.txt`. **Επόμενο run = 311b, ίδιο bat.** Launcher: `GT_GAME`
  override + `GT7_probe311_offline.bat` (095e7fd8). Μάθημα: [[feedback-fatal-detector-dry-run-first]].
- **Run 311b (0679716a, 15:54-15:59, patched παιχνίδι, offline): έφτασε στο World Map offline** (πρώτη φορά),
  ο χρήστης το έκλεισε (exit 0) γιατί «δεν υπάρχει κείμενο». **ΖΕΣΤΗ PIPELINE CACHE ⇒ ΧΑΜΕΝΟ ΚΕΙΜΕΝΟ, 3/3, με
  autoshots:** 309 (κρύο, ίδιο probe) = πλήρες HUD Music Rally (τίτλος, «5.72 miles», «BEST RECORD», 45 mph)·
  310 (ζεστό 1936, ΑΠΑΤΣΑΡΙΣΤΟ παιχνίδι) = ίδιο HUD ΑΔΕΙΟ + κάρτες Single Race setup χωρίς ετικέτες (πλοήγηση με
  εικονίδια, μόνο το μενού παύσης Continue/Retry/Settings/Exit σχεδιάζεται)· 311b (ζεστό 6419) = HUD άδειο, στο
  World Map μεμονωμένες γλυφές σε λάθος θέσεις (T, I N S σκόρπια). Άρα ΟΧΙ το patch, ΟΧΙ το -Offline: γλυφές
  με λάθος ΘΕΣΗ μόνο σε ζεστή cache. Ο [cacheverify] του 289 συνέκρινε μόνο blobs (SPIR-V/spec/InfoPersistent
  + μεγέθη srt) → «0 differ» ΔΕΝ αθωώνει την cache: ό,τι παράγει μια μεταγλώττιση ως παρενέργεια και δεν
  παράγει ένα preload (Info προγράμματος από ΟΠΟΙΟ perm record φορτωθεί πρώτο — LoadPipelineStage, walker
  bytes, συμβατότητα deserialized spec) μένει αόρατο. Ελεγμένα και ΑΘΩΑ: `has_readconst` (δεν το διαβάζει
  κανείς στο runtime), RefreshFlatBuf (ανά draw στο GetProgram, και για preloaded), SerializationSupport
  (dynamic vertex input ενεργό στην NVIDIA 591.86). Stream memo ON και στα τρία (309 68%+ hits) → όχι πρώτος
  ύποπτος, αλλά ο χρονισμός δεν αποκλείστηκε. **Run 312 = `GT7_probe312_offline.bat` = 311b + GT_CACHE_VERIFY=1**
  (recompile κάθε preloaded module στην πρώτη χρήση = καθυστερήσεις σαν κρύο, preloaded pipeline ΚΡΑΤΙΕΤΑΙ):
  κείμενο ΟΚ → χρονισμός/αγώνας δεδομένων· κείμενο χαλασμένο → περιεχόμενο/κατάσταση cache → 313 = mode 2.
  Log 311b: `logs/shad_log_run311b_2026-09-13_offline_worldmap_notext.txt`.
- **Run 312 (f679f7f1 probe, exe 0679716a, 16:1x-16:25, warm 6621, GT_CACHE_VERIFY=1): ΚΕΙΜΕΝΟ ΑΚΟΜΗ ΧΑΛΑΣΜΕΝΟ
  με κρύο χρονισμό ⇒ ο χρονισμός ΑΘΩΟΣ, φταίει περιεχόμενο/κατάσταση της cache.** Verifier: 2561 checked, 236
  differ = 3 VS με ΔΙΑΦΟΡΕΤΙΚΟ SPIR-V (0xdc36d859 dw568, 0x7cf53295 dw358 = OpName «ud_4», 0xf22ddaa8 dw574 =
  OpDecorate Binding 27) + ~230 FS «spec DIFF» με ίδιο SPIR-V/Info. Τι ΕΙΝΑΙ το spec DIFF: `spec_same = (record.spec
  == fresh_spec) && (fresh_spec == record.spec)` όπου fresh_spec χτίζεται ΤΩΡΑ από φρέσκο Info (GetSharp = V# από
  `sharp_fetch` + flatbuf) — αφού το runtime βρήκε το cached module με το τρέχον spec, η διαφορά σημαίνει ότι το
  cached Info συναρμολογεί ΑΛΛΟ V#/T# (ή άλλο bitset = null sharp = άδετος buffer) από το φρέσκο για το ΙΔΙΟ draw.
  Ο έλεγχος ανά πεδίο ΔΕΝ συγκρίνει `sharp_fetch`/`post_op`/walker bytes/flatbuf (τα «bytes differ at 29/30/36/37»
  πέφτουν σε padding του SharpFetch<Buffer>: SharpLocation=u16, load_mask@28). Αποκλείστηκαν με κώδικα: has_readconst
  (κανείς δεν το διαβάζει), RefreshFlatBuf (ανά draw και για preloaded, GetProgram), dynamic vertex input (NVIDIA
  591.86 ενεργό), S_GETPC_B64 (ir.GetPcLo, όχι ενσωματωμένη διεύθυνση), pgm_base (μόνο post_op OffsetByProgramBase
  στο bind). Το 312 πέθανε 16:25:50 από **uncaught C++ exception (0xe06d7363) στο GPU thread** αμέσως μετά φρέσκια
  μεταγλώττιση του 0x8b64e3d8 μέσα στον verifier. **Επέκταση 6e258bc6 (exe 19:51):** try/catch γύρω από τη φρέσκια
  μεταγλώττιση + ανά module που διαφέρει: V#/T#/S# cached vs fresh με τη συνταγή sharp_fetch, spec bitset/entries,
  start, runtime_info, walker bytes, flatbuf, SPIR-V λέξεις γύρω από την πρώτη διαφορά, και τα δύο SPIR-V blobs στο
  `%APPDATA%/shadPS4/shader/cacheverify/` (spirv-dis στο C:\VulkanSDK για diff). **Επόμενο run = 313 = ΙΔΙΟ
  `GT7_probe312_offline.bat` με το νέο exe.** Το «go» run 16:49-16:54 (312b, χωρίς verify, warm 6710) έκλεισε καθαρά.
  Logs: `shad_log_run312_2026-09-13_cacheverify1_notext_int3.txt`, `shad_log_run312b_2026-09-13_offline_noverify.txt`.
- **Run 313 (6e258bc6, 20:02-20:03:41, warm 6771, verify 1): ΑΚΟΜΗ χωρίς κείμενο** (screenshot: dialog δικτύου
  με checkerboard στη θέση εικόνας, σκόρπιες γλυφές)· 1242 checked / 50 differ· **πέθανε στα 56 s με PM4 type 0
  «base reg 0, size 1» = ΜΗΔΕΝΙΚΟ dword όπου περιμενόταν header — ΙΔΙΑ υπογραφή με το 309** (0 ibchain, 0
  fenceorder, 0 exceptions). **Τα «spec DIFF» των ~230/49 FS ήταν ΨΕΥΤΙΚΟ ΘΕΤΙΚΟ ΤΟΥ VERIFIER:** ο
  `StageSpecialization::operator==` είναι ΑΣΥΜΜΕΤΡΟΣ (ελέγχει μόνο τα bound του ΔΕΞΙΟΥ operand, `other.bitset`)·
  το runtime lookup `find(modules, spec)` = `cached == fresh` ταιριάζει cached perm που δένει ΠΕΡΙΣΣΟΤΕΡΑ (π.χ.
  `buffers[2]` stride 128) για draw που δεν τα δένει — αφού το SPIR-V είναι ίδιο, το module είναι byte-ίδιο, άρα
  αβλαβές εξ ορισμού (μάθημα [[feedback-verifier-must-use-the-runtimes-own-rule]]). **Μία ΠΡΑΓΜΑΤΙΚΗ διαφορά:**
  cs 0x6421a7b6 p15, cached SPIR-V ΧΩΡΙΣ `OpLoad SubgroupLocalInvocationId`+`OpIAdd` πριν από υπολογισμό
  διεύθυνσης (/16, %16, ×260400) με spec/runtime_info ΙΔΙΑ → ο compiler εξαρτάται από είσοδο που ο verifier δεν
  συγκρίνει (blobs: `%APPDATA%/shadPS4/shader/cacheverify/`). **Μηχανισμός-ύποπτος (από κώδικα):** ένα `Program`
  έχει ΕΝΑ `info` και ΚΑΘΕ permutation δένει descriptors μέσα από αυτό (`infos[stage] = &loaded_program.info`).
  Ζωντανά το info καθιερώνεται από perm 0 και κάθε επόμενο perm καρφώνεται σε αυτό (`CompileModule(new_info,…,&info)`
  → `PinBakedMipCounts`)· στο preload (`LoadPipelineStage`, `try_emplace(pgm_hash)`) το καθιερώνει ΟΠΟΙΟ record
  διαβαστεί πρώτο (τυχαία σειρά αρχείων) και κανένα pin δεν γίνεται για τα υπόλοιπα — το `AddBindings` έχει ήδη
  σχόλιο για ακριβώς αυτό το σύμπτωμα («descriptors landed on the wrong bindings»). **Build 09206dc4 (exe 20:19:30):**
  `[infoshape]` πάντα (WARNING: program καθιερώνεται από perm≠0· ERROR: record και layout διαφωνούν σε σχήμα
  bindings), `GT_INFO_PERM0=1` = αρνείται καθιέρωση από perm≠0 (το pipeline μεταγλωττίζεται ζωντανά), και
  `[badpacket]` report πριν από το type-0/unknown UNREACHABLE (CORRUPTION POINT με μήκος μηδενικής σειράς / IB
  CHAIN / CORRUPTED MEMORY / LAST KNOWN WRITERS = readbacks της σελίδας / CHRONOLOGY). **Run 314 =
  `GT7_probe314_offline.bat` = 313 + GT_INFO_PERM0=1** (μία μεταβλητή). Log 313:
  `shad_log_run313_2026-09-13_cacheverify1_infoshape-none_notext_pm4type0.txt`.
- **Run 314 (09206dc4, 20:25, GT_INFO_PERM0=1 + verify 1): ΚΕΙΜΕΝΟ ΑΚΟΜΗ ΧΑΛΑΣΜΕΝΟ (ίδιο screenshot) ⇒ ο
  ύποπτος «Info από τυχαία permutation» ΑΠΟΡΡΙΠΤΕΤΑΙ ως αιτία.** 4894 preloaded, 1877 records απορρίφθηκαν
  (record άλλης perm πριν την perm 0 = 28% της cache), 0 διαφωνίες σχήματος bindings. Έσκασε σε
  `Shader::Info::PushUd` reading 0x0 — ΔΙΚΟ ΜΟΥ: τα early `return false` των LoadGraphics/ComputePipeline
  άφηναν `infos/modules/fetch_shader` γεμάτα από το μισοφορτωμένο record (λανθάνον upstream bug που η πύλη
  πυροδότησε 1877 φορές)· fix `abandon()` σε κάθε πρόωρη έξοδο (2b7cf784). **ΤΟ ΘΕΜΕΛΙΟ ΤΗΣ ΥΠΟΘΕΣΗΣ «ΖΕΣΤΗ
  CACHE» ΔΕΝ ΕΛΕΓΧΘΗΚΕ ΠΟΤΕ ΣΕ ΜΙΑ ΜΕΤΑΒΛΗΤΗ:** το log του 309 (κείμενο ΟΚ) δεν έχει ΚΑΘΟΛΟΥ «Preloaded» και
  χτίστηκε από commit ≤ e71ff38a (12:26)· το 310 (πρώτο χαλασμένο) = warm 1936 ΚΑΙ build ≥ 4720205e (12:37,
  «Complete deferred fences in order», ΧΩΡΙΣ env gate — το `GT_FENCE_ORDER` είναι μόνο ο logger). Δύο
  μεταβλητές άλλαξαν μαζί ([[feedback-list-every-difference-between-good-and-bad-run]]). **Run 315 =
  `GT7_probe315_offline.bat` = 311b body + `GT_NO_WARMUP=1`** (build 2b7cf784, exe 20:30:09): preload τίποτα,
  store ανοιχτό (σώζει ό,τι μεταγλωττίζει). Κείμενο ΟΚ → φταίει πράγματι το preload· κείμενο χαλασμένο → η
  cache ήταν αθώα 4 runs και ο επόμενος ύποπτος είναι το 4720205e (θέλει gate ή build στο e71ff38a· ο χρήστης
  είπε το 4720205e να ΜΕΙΝΕΙ — ζήτα άδεια πριν το αγγίξεις). Log 314:
  `shad_log_run314_2026-09-13_infoperm0_notext_pushud_crash.txt`.
- **Run 315 (2b7cf784, 20:34-20:38, GT_NO_WARMUP=1, ΚΑΝΕΝΑ preload): ΤΟ ΚΕΙΜΕΝΟ ΥΠΗΡΧΕ** — πλήρες HUD
  Music Rally (autoshot 20:36:23) και πλήρης World Map (20:37:55)· **30 s αργότερα (20:38:25) το ΙΔΙΟ World
  Map γράφει «To t sxt Lsvsl» αντί «To Next Level», «GT Live WeCriœ» αντί «GT Live Website»**: γράμματα
  αντικαθίστανται από ΑΛΛΑ γράμματα ΠΡΟΟΔΕΥΤΙΚΑ μέσα στο ίδιο run. ⇒ **Η pipeline cache είναι ΑΘΩΑ** (η ζεστή
  cache μόνο αφαιρεί τα compile stalls, άρα το παιχνίδι φτάνει στην κατάσταση αυτή αμέσως)· οι shaders είναι
  σωστοί, τα ΔΕΔΟΜΕΝΑ που διαβάζουν παλιώνουν (glyph cache: ο CPU προσθέτει γλυφές σε πίνακα+atlas όσο
  εμφανίζονται νέοι χαρακτήρες και ξαναδένει τον μικρό πίνακα draw-draw). Πρώτος ύποπτος: η τεκμηριωμένη τρύπα
  του `GT_STREAM_MEMO` (CPU rewrite ακατάγραφου read-only range μεταξύ δύο binds του ΙΔΙΟΥ submit ⇒ σερβίρεται
  το πρώτο snapshot) — ήταν ON σε ΟΛΑ τα runs, και το 309 απλώς δεν έμεινε αρκετά σε οθόνη με κείμενο. Δεύτερος:
  `GT_FAST_PROTECT=1` (ανίχνευση CPU writes στο atlas). Ο `GT_STREAM_MEMO_VERIFY` ΔΕΝ πυροδοτεί στα μενού (gated
  σε precise readbacks = μόνο σε αγώνα). **Run 316 = `GT7_probe316_offline.bat` = 315 + GT_STREAM_MEMO=0**
  (μία μεταβλητή, ίδιο exe 2b7cf784): κείμενο σωστό 5+ λεπτά στο World Map ⇒ memo = root cause (γενικό fix:
  page watch στα memoized ranges ή epoch στο tick-free emulated-DMA path, αλλιώς αφαίρεση)· αλλιώς → 317 =
  GT_FAST_PROTECT=0, μετά T#/S#/V# trace στα glyph draws. Το log του 315 ΧΑΘΗΚΕ (βραδινό GoW run το έγραψε
  πάνω, ο GoW launcher δεν αρχειοθετεί)· αποδείξεις = `logs/run315_shots/` (autoshots 000006/000012/000014).
  Ο χρήστης (14 Σεπ): «we have to start working on SPIR-V so every T#/S# etc is read properly from emulator» —
  η κατεύθυνσή του· η απάντηση: οι descriptors διαβάζονται σωστά, τα bytes πίσω τους παλιώνουν, και ο έλεγχος
  που ζητά γίνεται στα glyph draws αν το 316 δεν κλείσει το θέμα.
- **Run 316 (2b7cf784, 14 Σεπ 19:20-19:25, GT_STREAM_MEMO=0, no preload): κείμενο ΣΩΣΤΟ σε όλες τις λήψεις
  (Music Rally 2,5 λεπτά, World Map μόνο 15 s — ΑΝΕΠΑΡΚΕΣ για κρίση, το 315 χάλασε 60 s μετά την εμφάνιση
  του Map)· memo off = 106 ms/καρέ στον αγώνα (9 fps). **ΠΑΓΩΜΑ 99,6 s στα t=103-203 s:** GFX vq0 WaitRegMem
  στο 0x200f6a9bc (==1) ΚΑΙ ASC vq6 στο 0x1020253ffc (==1), flips 3276→3277 με period 99597 ms, ΚΑΝΕΝΑ
  fprof παράθυρο ενδιάμεσα (αυτό ήταν το «stuck» του χρήστη), CPU threads μόνο NetCtl/Timer/sndz waits·
  ξεκόλλησε ΜΟΝΟ ΤΟΥ (κάποιος έγραψε τα labels — άγνωστο ποιος, ο priority-ops runner είναι ξεχωριστό thread
  άρα ΔΕΝ ήταν «κανείς δεν αντλεί»). Ίδια κλάση στο 310 (13 gpuwait, max 40 s, ΑΛΛΕΣ διευθύνσεις:
  0x205d2c27c/0x206affccc/0x101e32be80/0x102023ffdc) — οι διευθύνσεις αλλάζουν ανά run, άρα στατικό
  GT_HWWATCH δεν βοηθά. 311b/312b/313/314: 0 gpuwait. Ο χρήστης το έκλεισε καθαρά 19:25:27 στον World Map.
  **Όργανο 8d6334a1:** `GpuWaitReport` έγινε member· στην ΠΡΩΤΗ αναφορά (10 s) τυπώνει VMA του label,
  αν deferred fence (ring 128, τώρα με addr/value στο `NoteDeferredFence`) στοχεύει το label και αν το tick
  του ολοκληρώθηκε, CurrentTick/KnownGpuTick/HasPendingGpuWork, backlog ανά ουρά, και **οπλίζει hardware
  watch στο label σε runtime** (`Common::GtHwWatchArm`, νέο: atomic g_count/g_generation, sweeper on demand)
  ώστε ο τελικός γραφέας να καταγραφεί ως `[hwwatch] ... written by <module>+<off> | thread`. **Run 317 =
  `GT7_probe317_offline.bat` = 316 + GT_HWWATCH κενό** (ελεύθερα τα 4 DR)· ΜΕΙΝΕ 5+ λεπτά στον World Map
  για την κρίση του memo. Log 316: `shad_log_run316_2026-09-14_memo0_stuck_gpuwait.txt`. Στη λήψη 000008
  του 316 φαίνεται και το γνωστό «μαύρο πολύγωνο/χαμένα barriers» (vegetation issue, ΟΧΙ τώρα).
- **14 Σεπ βράδυ, ΔΥΟ runs στο ΙΔΙΟ exe (8d6334a1, 19:37) — ο emulator ΔΕΝ είναι η μεταβλητή.** 21:22-21:26
  (probe 316 ξανά, παλιό vol): 3,5 λεπτά, κείμενο ΣΩΣΤΟ στον World Map (λήψη 21:26:43), ΕΝΑ πάγωμα **27,7 s**
  (καρέ 2756, gfx-waitregmem 27550 ms = 100%), καθαρή έξοδος. 21:40 (probe 317): **CRASH στα 53 s**.
  Ενδιάμεσα άλλαξε ΜΟΝΟ το patch, και μάλιστα **ΔΥΟ πράγματα** (όχι ένα): 21:24:56 `gt7save.py` P1 handshake
  -> USELOCAL + P2 online data-op (eboot), και 21:36:58 **gt99.vol 65536 -> 196608** (brand dealer 131072 B
  στο sector 32). ⚠ Ό,τι συμπεράνουμε από ΕΝΑ run ονομάζει ζευγάρι, όχι αιτία — το ίδιο λάθος με 309/310.
- **Το crash = GUEST WILD JUMP, ΟΧΙ PM4 type-0** (άλλη κατηγορία από 309/313): `execution at unmapped/NX
  0x57b99f17`, DEP execute violation, thread Job#55 (γενικός worker, ΟΧΙ «το νήμα γραμματοσειρών» — είχε
  καλέσει `sceFontMemoryInit` νωρίτερα αλλά έκανε και dingdong σε 4 ουρές). **Κανένας καταχωρητής δεν κρατούσε
  τον στόχο** ⇒ `call [mem]`, ο δείκτης διαβάστηκε από μνήμη. Αλυσίδα κλήσεων (την τυπώνει ήδη το
  `signals.cpp:293`): eboot+**0x3325680** (η κλήση που ξέφυγε), +0x332193b, +0x331ee14, +0x331800e,
  +0x33179e9, +0x32dc1f0, +0x330eec4, +0x330cee2. **ΤΟ ΙΔΙΟ region 0x330-0x333 είναι αυτό που το hardware
  watch έπιασε να γράφει τα fence labels** (+0x330d80a 253 φορές, +0x3318c0c, +0x3321d3b, +0x333883f) ⇒ είναι
  το GPU submission layer της GT7. Το αντικείμενο στο rbx 0x203605510 έχει **GPU descriptor words** εκεί που
  θα έπρεπε να έχει δικά του πεδία.
- **Όργανο e991e369 (νέο exe 22:10):** σε wild jump το `LogGuestCrashContext` κρατά το ΠΡΩΤΟ guest return
  address που ήδη βρίσκει το stack scan και τυπώνει τα **24 bytes ΠΟΥ ΤΕΛΕΙΩΝΟΥΝ σε αυτό** = την ίδια την
  εντολή call. Το ModRM λέει ποιο register+displacement, άρα **ποιο πεδίο ποιου αντικειμένου** γράφτηκε από
  πάνω. Ψάξε: `the 24 bytes ending AT the innermost return address`. Γενικό, χωρίς gate.
- **Run 318 = `GT7_probe318_offline.bat`** = 317 ΑΚΡΙΒΩΣ (69 set-lines ταυτόσημα, diff κενό) + νέος header +
  καθαρά CRLF. Καμία αλλαγή env επίτηδες: αν ξανακρασάρει, κρασάρει στην ίδια διαμόρφωση και η νέα γραμμή
  απαντά. Αν ΔΕΝ κρασάρει → 5+ λεπτά World Map για την κρίση του memo (ακόμη ανοιχτή από το 315).
- ⚠ **Το probe 317 το ξανάγραψε η γραμμή του offline patch και γύρισε με `\r\r\n` σε ΚΑΘΕ γραμμή** (227
  διπλά CR· γι' αυτό το git έδειξε 227 insertions για 11 γραμμές). **ΑΚΙΝΔΥΝΟ**, ελέγχθηκε: κάθε GT_ gate
  διαβάζει με `atoi(v)` ή `*v && *v!='0'`, **ΜΗΔΕΝ** gate χρησιμοποιεί `strcmp`, άρα το `"0\r"` δίνει 0 και
  το memo ήταν όντως OFF στο 317. Το 318 τα καθάρισε.
- ⚠⚠ **Η υπόθεση «ο runner λιμοκτονεί από στάσιμο KnownGpuTick» ΚΑΤΑΡΡΙΦΘΗΚΕ από τον κώδικα:** το
  `MasterSemaphore::Wait` μπλοκάρει σε αληθινό `waitSemaphores`, που το ξυπνά ο driver — δεν εξαρτάται από
  polling. Αυτό που ΜΕΝΕΙ ύποπτο είναι ότι ο `PriorityPendingOpsThread` είναι **ΕΝΑ νήμα με αυστηρά FIFO**
  ουρά: βγάζει μία πράξη, μπλοκάρει ως το tick της, μετά την επόμενη. Άρα πράξη με tick που ΔΕΝ έχει υποβληθεί
  κρατά πίσω της fences **ολοκληρωμένων** ticks — και το ίδιο το όργανο το τύπωσε: «tick 61809 is COMPLETE,
  so it should have landed». ΑΝΟΙΧΤΟ: ποια από τις 8 κλήσεις `DeferPriorityOperation` χρησιμοποιεί την έκδοση
  ΕΝΟΣ ορίσματος (που παίρνει `CurrentTick()`, δηλαδή μη-υποβληθέν tick). Αυτό κλείνει την απόδειξη.
- ⚠ **Το `DeathCrumb::Finish(true)` καλείται από `Common::Log::Shutdown()` που ΔΕΝ φτάνει στην κανονική
  έξοδο**: το 316 βγήκε καθαρά (Cache dumped + UpdatePlayTime) και το `last_crumb.txt` λέει «DIED». Ψευδώς
  θετικό — μην το εμπιστεύεσαι για να ξεχωρίσεις καθαρή έξοδο από θάνατο. Και το crumb καταγράφει τη φάση του
  **render** νήματος (BindTextures), άρα σε crash ΞΕΝΟΥ νήματος δείχνει άσχετο πράγμα.
- Αρχεία: `logs/shad_log_run317_2026-09-14_newpatch_wildjump_crash.txt`, `guest_crash_run317_2026-09-14.dmp`,
  `last_crumb_run317_2026-09-14.txt`, `build_318.txt`.
- **15 Σεπ: το «μαύρο πολύγωνο / χαμένα barriers» ΔΕΝ είναι μαύρο.** Μέτρησα τα pixel της λήψης 000008
  του 316: όλο το καρέ είναι σκοτεινό (ουρανός 40, άσφαλτος 32)· με gain ×6 φαίνεται ότι οι μπαριέρες
  και οι πινακίδες είναι **ΕΠΙΠΕΔΑ ΓΚΡΙ χωρίς texture**, δίπλα σε πινακίδες (GoPro, ZURICH,
  BRIDGESTONE) που είναι ΣΩΣΤΕΣ, συν ένα παραμορφωμένο μαύρο αντικείμενο. Δέντρα/γκαζόν/δρόμος/
  kerbs/αμάξι σωστά. **Δύο υποθέσεις καταρρίφθηκαν από τα logs:** 0 T# null-binds και στα 316/310
  (άρα όχι ο null descriptor), 0 shader stubs / 0 compile failures (τα 2809 «stub» είναι HLE linker).
- **ΤΟ ΕΥΡΗΜΑ (commit 387baa06): `MappedPrefixAt` μετρούσε λάθος πράγμα.** Το tail-descriptor
  μονοπάτι (`GT_SOFT_CLAMP`, default 1 από `run_gt7.ps1`) ρωτά «πόσα χαρτογραφημένα bytes
  ακολουθούν τη βάση του descriptor». Η συνάρτηση απαιτούσε **το mapping να ΞΕΚΙΝΑ ακριβώς
  στη βάση** (`it->lower() != addr -> 0`) — κάτι που ένα buffer descriptor σχεδόν ποτέ δεν κάνει,
  γιατί δείχνει όπου κάθεται το buffer ΜΕΣΑ σε μια allocation. Ο caller το διάβαζε ως «μη
  χαρτογραφημένο» και null-έδενε. **Διόρθωση: `it->upper() - addr`** (το find εγγυάται
  lower() <= addr < upper(), άρα δεν γίνεται wrap). Υπήρχε από το `cac62b69` και το
  `6566514b` το διατήρησε ρητά («semantics unchanged» — ήταν ήδη λάθος). **ΔΙΚΟ ΜΑΣ bug,
  ΟΧΙ upstream.**
- ⚠⚠ **ΟΙ ΓΡΑΜΜΕΣ LOG ΛΕΝΕ ΨΕΜΑΤΑ ΓΙΑ ΤΗ ΣΥΧΝΟΤΗΤΑ** — κάθε `[softclamp]` έχει budget
  32/64 γραμμών. Το log του 316 έδειχνε 44 περιστατικά· οι αληθινοί μετρητές είναι στη
  γραμμή `[fprof]`: `softclamp: floor N align N tail N untail N maptail N ...` — εκεί φαίνεται
  **tail 22026 / untail 22026 σΕ ΚΑΘΕ παράθυρο 2 s**, δηλαδή 100% null-bind. Γενικός
  κανόνας: πριν κρίνεις συχνότητα από γραμμές log, βρες αν υπάρχει μετρητής.
- Η απόδειξη που ξεχωρίζει «χαλασμένα descriptors» από «χαλασμένο κριτήριο»: οι ΑΛΛΟΙ
  ανιχνευτές σκισμένων descriptor στο ίδιο run χτύπησαν **21 και 2** φορές. 22026 δεν
  είναι πληθυσμός σκισμένων· είναι ο πληθυσμός των κανονικών.
- **Run 319 = `GT7_probe319_offline.bat`** (env ταυτόσημο με 318, 69/69 set-lines). **Κριτήριο:**
  untail πολύ μικρότερο από tail = έπιασε· untail = tail ακόμη = ήταν όντως αχαρτογράφητα
  και η ανάγνωσή μου είναι λάθος. ⚠ Πρόσεχε το `[vram]`: 22026 descriptors/παράθυρο
  που πριν null-έδεναν τώρα φτάνουν στο buffer cache — το έργο έχει κάνει OOM στο παρελθόν.
- Παγίδα οργάνου: το `NoteDeferredFence` κατέγραφε `CurrentTick()` αντί για το tick αναβολής → ψευδώς
  θετικά `[fenceorder]` στη νέα διαδρομή (διορθώθηκε 917c4786 ΠΡΙΝ το run 310).

- **Handoffs (in-repo, ΑΓΓΛΙΚΑ):** `GT7_HANDOFF.md` (runs 1-20) → `GT7_work/HANDOFF_DEVICE_LOST.md`
  → `GT7_work/HANDOFF_RENDERING.md` (42-55) → `GT7_work/HANDOFF_RENDERING_ACT2.md` (Acts 2-14 + runs
  248-251, το ζωντανό, ~1900 γραμμές). Διάβασε το τελευταίο τμήμα πρώτα. Κάθε run έχει
  `GT7_work/GT7_probeNNN.bat` με header ευρημάτων· τα logs αρχειοθετούνται ΧΕΙΡΟΚΙΝΗΤΑ ως
  `GT7_work/logs/runNNN_<tag>.txt` (αντέγραψε το `%APPDATA%\shadPS4\log\shad_log.txt` πριν το επόμενο run).
- **Build:** ΜΟΝΟ Clang, από 8.3 path, `GT7_work\build.bat` — κρίση από `BUILD EXIT 0` ΚΑΙ exe
  timestamp (`Build\x64-Clang-RelWithDebInfo\shadps4.exe`). Δεν γίνεται relink όσο τρέχει το παιχνίδι
  (lld-link permission denied) — background waiter σε `Get-Process shadps4`.
- **Οδηγία χρήστη (25 Αυγ):** ό,τι μπαίνει στο repo στα ΑΓΓΛΙΚΑ· η συνομιλία ελληνικά.
- **Log cap:** το `run_gt7.ps1` γράφει `Log.size_limit` = 1 GiB (ήταν 100 MiB και έκοβε το run 247).
  Το `config.json` έχει UTF-8 BOM (PowerShell) → python `utf-8-sig`. Κλειδί RenderDoc =
  `Vulkan.renderdoc_enabled` (nested).
- **Tess μέτωπο — ΚΛΕΙΣΤΟ (run 249):** `GT_TESS_LANEFIX` (default on) → 0 clamps / 0 drops / 164 folds.
  Οι 311 «κλαμπαρισμένοι» hull shaders ήταν εγγραφές tess factors με count φουσκωμένο από αλυσίδα
  WriteLane (N = 2×links). Κανένας DS δεν διαβάζει patch constants.
- **FPS μέτωπο:** `[fprof]` run 247: GCP thread 91% busy· pipeline compile 31% (sync μέσα στο Draw)·
  bindbuf+bindtex 28%. Το disk cache ακυρώνεται σε κάθε rebuild.

- **HEADLESS RENDERDOC (δουλεύει, 2 Σεπ):** `qrenderdoc.exe --python script.py` με env
  `RDC_CAPTURE/RDC_REPORT/RDC_OUT` (Windows paths με `/`)· το script ανοίγει το capture μόνο του
  (`rd.OpenCaptureFile().OpenFile → OpenCapture`), γράφει report+PNGs και `os._exit(0)` πριν ανοίξει το
  UI. ~1 λεπτό ανά 1.5 GB capture. Scripts `GT7_work/rdc/analyze18_persist.py` (targets χωρίς clear +
  PRE/POST PNG), `analyze19_pixhist.py` (draw census + **PixelHistory** — το αποφασιστικό όργανο),
  `analyze20_geometry.py` (depth pixel history + post-VS/post-tess NDC bounds), `analyze21_indirect.py`
  (indirect args provenance από τα structured chunks). Παγίδες API 1.45: όχι `PipeState.GetDepthState`
  (→ `GetVulkanPipelineState().depthStencil`)· `SDObject` χωρίς `AsUInt64/AsResourceId` (→
  `obj.data.basic.u/.id`, basetype match by NAME). `renderdoccmd thumb --out x.png cap.rdc` = ποιο frame
  πιάστηκε. Captures στο `%APPDATA%\shadPS4\captures\` (ΟΧΙ υποφάκελος CUSA24769).
- **RUN 250 VERDICT (2 captures, Music Rally):** το HDR target (`0x1005000000`, R11G11B10) ξεκινά κάθε
  frame με ΟΛΟ το προηγούμενο frame· pixel history σε 7 pixel δρόμου/εδάφους: ΚΑΝΕΝΑ fragment χρώματος
  εδάφους (μόνο sky quad που κόβεται από depth, identity pass 6570, discard pass 7544). Το ΒΑΘΟΣ εκεί το
  έγραψε το depth-only prepass draw eid 3118 (235k indices, κανονικό mesh). Στο colour pass ΔΕΝ υπάρχει
  αντίστοιχο draw (max 10k indices)· τα 24 indirect `<0,0>` είναι LOD slots που δεν επιλέχθηκαν (props
  ×44 instances) — ΟΧΙ το έδαφος· τα 4 tess draws βγάζουν 2112 vertices το καθένα ΟΛΑ σε ένα sub-pixel
  σημείο (collapse). Άρα το κίτρινο = σύμπτωμα: το χρώμα του εδάφους είτε πετιέται μέσα στον emulator
  (FilterDraw 6 λόγοι με TRACE logs / pipeline null / BindResources false — ΚΑΝΕΝΑ δεν μετριόταν) είτε
  δεν εκδίδεται ποτέ από το παιχνίδι.
- **RUN 251 VERDICT (2 Σεπ, `logs/run251_drawdrop.txt`, 228 s):** `drops: tess 0 fce 2917 fmask 0
  resolve 3117 primnone 0 dscopy 0 pipeline 0 bind 0`, 0 `[drawdrop]`. fce+resolve = ΑΚΡΙΒΩΣ 1 ανά
  submit/frame (νόμιμο ζεύγος FCE+resolve, όχι το έδαφος). ΔΙΟΡΘΩΣΗ: τα 4 tess draws ΔΕΝ καταρρέουν —
  w≈177-181 (≈180 m μακριά), 0.3×1.4 m: τέσσερα μικρά μακρινά αντικείμενα (VSOut μηδενικά = ο LS δεν
  γράφει gl_Position). Audit του parser για CPU-διάβασμα GPU-δεδομένων: DrawIndexIndirectCountMulti →
  vkCmdDrawIndexedIndirectCount (ΟΚ), DmaData mem→mem → CopyBuffer GPU (ΟΚ), SetPredication stub αλλά
  0 κλήσεις, CopyData unhandled αλλά 0 κλήσεις. **Η μόνη ανοιχτή πόρτα: `CondExec` — `*Address() ==
  false`, 1-byte CPU read την ώρα του parsing (η GPU που γράφει τη συνθήκη τρέχει ΜΕΤΑ), χωρίς log,
  χωρίς μετρητή.** Ταιριάζει ακριβώς: prepass βάθους εδάφους (χωρίς όρο) υπάρχει, colour draws (με όρο
  occlusion) λείπουν.
- **RUN 252 (χτίστηκε 2 Σεπ ~22:45, ΔΕΝ έχει τρέξει):** `GT7_probe252.bat` = probe251 + `GT_CONDEXEC=2`
  (never skip). Ο `[fprof]` τελειώνει με `condexec: seen N skip N bytediff N forced N | fce cleared N`,
  τα πρώτα 48 CondExec λογκάρονται `[condexec] addr dword byte_false -> SKIP/run exec_count guarded
  opcode/words/indices registered gpu_modified`, τα πρώτα 32 FCE/resolve draws ως `[filterdraw]`
  (num_indices, MRT0/1, fast_clear, acted). Modes: 0 byte (παλιό), 1 dword (hardware), 2 never skip,
  3 drain GPU (Finish+ReadMemory) then dword = η αληθινή τιμή, πολύ αργό (`GT7_probe253.bat`).
  Verdict: seen 0 → το GT7 δεν χρησιμοποιεί CondExec στο GFX → ψάξε ποια draws εκδίδει καθόλου·
  seen>0 & skip≈seen & δρόμος ορατός → πόρτα βρέθηκε, σωστή λύση = VK_EXT_conditional_rendering ή
  download πριν το read· bytediff>0 → δεύτερο bug (1-byte read). ⚠ Το checkout είναι CRLF: python
  patches με `\n` patterns δεν ταιριάζουν — μετέτρεψε τα patterns.
  **Προσπάθεια 1 (23:24) κράσαρε στο μενού στα 42 s: GUEST WILD JUMP (Job#10, 0x54aca982) — ΓΝΩΣΤΗ
  διαλείπουσα κλάση (10 παλιότερες εμφανίσεις στο αρχείο, στόχοι 0x54..-0x57.. cluster), κανένα
  CondExec δεν είχε παρσαριστεί (seen 0, καμία mode γραμμή) → άσχετο με το knob, ξανατρέξε.** Τα
  `[filterdraw]` έδειξαν ήδη: FCE = quad 4 indices στο HDR target 0x1005000000 (fast_clear=1, cmask
  0x10057f8000), `acted` ΕΝΑΛΛΑΣΣΕΤΑΙ true/false → ο emulator τιμά το per-frame fast clear του HDR
  target μόνο τις μισές φορές (στο race capture ΠΟΤΕ) = το δεύτερο μισό του κίτρινου συμπτώματος
  (τα παλιά pixel επιζούν). Ξεχωριστό bug από τα draws που λείπουν.
- **RUN 252 VERDICT (23:33, 227 s με αγώνα, `logs/run252_condexec.txt`): `condexec: seen 0` σε ΟΛΑ
  τα 107 παράθυρα → το GT7 ΔΕΝ χρησιμοποιεί COND_EXEC στο GFX ring, πόρτα κλειστή οριστικά. Στον
  αγώνα `fce == submits` και `fce cleared 0` σε κάθε παράθυρο → το fast clear του HDR target δεν
  αναγνωρίζεται ΠΟΤΕ (μόνο exact-base FillBuffer ή xor-free CS write στην ίδια βάση ανιχνεύονται).
  Κάθε πόρτα του emulator είναι πλέον μηδέν: τα colour draws του εδάφους ΔΕΝ ΕΚΔΙΔΟΝΤΑΙ από το
  παιχνίδι.** Capture: το ground eid 3118 (235k idx, guest ib 0xf4241221a0, vb 0xf424068180) δεν
  χρησιμοποιείται από κανένα colour draw μέσω κανενός buffer· το HDR target δεν έχει compute writer·
  τα culling dispatches (cs 248/420 readsRT = depth προηγούμενου frame) γράφουν τα indirect args ΠΡΙΝ
  το prepass. ⚠ Το ζευγάρωμα prepass↔colour κατά resource/guest address είναι ΤΥΦΛΟ για ό,τι
  σερβίρει ο 64 MB stream buffer (resource 228, χωρίς guest διεύθυνση) και μπερδεύει shadow maps με
  το κύριο prepass — `analyze24_contentpair.py` ζευγαρώνει με hash ΠΕΡΙΕΧΟΜΕΝΟΥ και depth 22725.
- **RUN 254 (χτίστηκε 23:45:55, launcher core ίδιο, ΔΕΝ έχει τρέξει):** `GT7_probe254.bat` = 252 χωρίς
  CONDEXEC + `GT_WATCH_VA=10057f8000 GT_WATCH_SIZE=40000` ([vawatch]: ποιος γράφει το CMASK) +
  `GT_FCE_FORCE=1` (FCE σβήνει το target κι όταν το CMASK write δεν ανιχνεύθηκε — αν ο δρόμος γίνει
  επίπεδο χρώμα, ο μηχανισμός persistence επιβεβαιώθηκε) + `softclamp: floor align tail untail
  maptail unmapped offpast range` ανά παράθυρο στο [fprof]. Το probe253 (CONDEXEC=3) είναι άχρηστο
  πια (seen 0).
- **RUN 254 VERDICT (23:55, `logs/run254_fceforce_vawatch.txt`): με GT_FCE_FORCE η σκηνή έγινε
  ΜΑΥΡΗ (μενού: αμάξι μαύρο με λίγα cyan highlights· αγώνας: μαύρο) — ΑΝΑΜΕΝΟΜΕΝΟ: ό,τι δεν
  ξαναζωγραφίζεται δείχνει το clear colour, και δεν ξαναζωγραφίζεται ΟΛΗ η αδιαφανής σκηνή. Το
  CMASK γράφτηκε ΜΙΑ φορά σε όλο το run (`[vawatch] buf-fmt shader 0xaaa36b0e 0x10057f8000+0x5000
  WRITE`) → το GT7 ΔΕΝ κάνει fast clear ανά frame ούτε στο PS4, το per-frame FCE είναι no-op και
  εκεί· GT_FCE_FORCE = διαγνωστικό, ΟΧΙ fix. softclamp tail/maptail ≈ 10-13k ανά 2 s (~300/frame,
  tail descriptors clamped στο mapped prefix, πιθανώς αθώο). analyze24 (content pairing, depth
  22725 μόνο): 42/118 prepass draws = **94 % των indices** (έδαφος 235k, terrain 75k, ~30 κομμάτια
  αμαξιού με 4 vertex streams) ΧΩΡΙΣ colour draw· τα prepass draws ΕΧΟΥΝ fragment shader χωρίς colour
  attachment → **υπόθεση: deferred shading — το prepass γράφει G-buffer με storage writes, το
  full-screen pass 6570 (που διαβάζει το HDR target και έγραψε identity) φωτίζει από αυτό**.
  `analyze25_gbuffer.py` το ΔΙΕΨΕΥΣΕ: οι 15 prepass FS δεν έχουν RW resources ούτε colour outputs
  (alpha test μόνο)· το 6570 = volumetric fog (depth + HDR + 2 όγκοι 80×32×40 + exposure 1×1), όχι
  lighting. Άρα ΤΙΠΟΤΑ δεν ζωγραφίζει την αδιαφανή σκηνή: το παιχνίδι ΔΕΝ εκδίδει τα draws.
- **ΤΟ ΕΥΡΗΜΑ (3 Σεπ 00:30): occlusion queries.** `liverpool.cpp` EventWrite: το ψεύτικο zpass
  αποτέλεσμα (αυξανόμενος μετρητής + valid bit) γράφεται ΜΟΝΟ για event_type PixelPipeStatDump
  (57). Το Gnm writeOcclusionQuery στέλνει event_type ZPASS_DONE (21) + index ZPASS_DONE (1) → ο
  parser δεν γράφει ΤΙΠΟΤΑ → το παιχνίδι διαβάζει 0 ορατά pixel → CPU culling παραλείπει το colour
  draw κάθε αντικειμένου που μέτρησε στο prepass (= ακριβώς το σχήμα: prepass πλήρες, colour μόνο
  ουρανός/δέντρα/props/helpers). Το DEBUG log "Encountered EventWrite" φιλτράρεται, γι' αυτό 5 runs
  census δεν το είδαν.
- **RUN 255 (χτίστηκε 3 Σεπ 00:07:24, commit 01fa2cdf, ίδιο binary στον launcher core, ΔΕΝ έχει τρέξει):** `GT7_probe255.bat` = env 252 χωρίς
  CONDEXEC/FCE_FORCE/watch + `GT_ZPASS_FAKE=1` (νέο DEFAULT· =0 παλιά συμπεριφορά): ψεύτικοι
  μετρητές για ΚΑΘΕ ZPASS_DONE event, `[zpass] #n: event_type addr pairs game had X/Y writing Z`
  (πρώτα 16), `[pm4ev] event_write per window: t<type>/i<index>=count` ανά 2 s. Verdict: t21/i1
  παρόν + δρόμος/αμάξι εμφανίζονται → επιβεβαίωση, σωστή λύση = αληθινά Vulkan occlusion queries·
  t21/i1 απόν → NOP census για GPU-γραμμένα draw packets (υπόθεση B).
- **RUN 255 VERDICT (00:14): Η ΣΚΗΝΗ ΕΜΦΑΝΙΣΤΗΚΕ (δρόμος, γρασίδι, δέντρα, ουρανός, αντίπαλο αμάξι)
  ΑΛΛΑ το ZPASS fake ΔΕΝ έδρασε: `[zpass]` 0, census μόνο t44/t46/t49 cache flushes, ΚΑΝΕΝΑ
  ZPASS_DONE — το GT7 δεν κάνει occlusion queries, η υπόθεση (A)-via-queries ΝΕΚΡΗ.** Runs
  252/254/255 = ίδιος κώδικας, ίδιο env (⚠ `run_gt7.ps1 -Net` βάζει ΜΟΝΟ ΤΟΥ GT_DEFER_EOP=1,
  GT_DEFER_RELEASEMEM=1, GT_BINDLESS_STUB=1, GT_STALL_DUMP=1, GT_SOFT_CLAMP=1 κ.ά. πάνω από κάθε
  probe .bat — ο launcher wrapper ΔΕΝ τα έχει, διαφορετική διαμόρφωση), τρεις εικόνες (κίτρινο /
  μαύρο / σκηνή) → **run-time race μέσα στον emulator** αποφασίζει αν το παιχνίδι εκδίδει τα colour
  draws. `[faulthist]` 17350 faults ΟΛΑ writes, 0 reads → η CPU διαβάζει GPU δεδομένα απευθείας
  από imported μνήμη με όποιο χρονισμό τύχει. Κανένα stubbed shader στο 255 → τα κίτρινα/λευκά
  μπλοκ terrain ΔΕΝ είναι bindless stub (streaming state ύποπτο).
- **RUN 256 (commit f8b781d5, `GT7_probe256.bat` = env 255):** `[fprof]` τελειώνει με `bigdraw: depth N
  colour N | middraw: depth N colour N` (draws ≥50k idx / 10k-50k, με ή χωρίς colour target) +
  `[bigdraw]` δείγματα (indices, mrt0, ps/vs).
- **RUN 256 VERDICT (3 Σεπ 00:26-00:29, `logs/run256_bigdraw.txt`, Revision `01fa2cdf-dirty` = το bigdraw
  build πριν το commit του): ΜΕΓΑΛΑ COLOUR DRAWS ΥΠΗΡΧΑΝ ΟΛΟ ΤΟΝ ΑΓΩΝΑ** (colour 31-141 ανά 2 s = 1-4 ανά
  frame· μόνο το πρώτο παράθυρο t=44 s είχε depth 8 / colour 0), ΑΛΛΑ τα δείγματα στο HDR target ήταν
  51924 / 77784 / 57780 indices — ΚΑΝΕΝΑ το έδαφος (235272) ή το terrain (74862). Στο capture 1 (κίτρινο
  frame) το μεγαλύτερο colour draw στο HDR ήταν 10092 → το 256 είχε colour draws που το capture 1 δεν
  είχε. ⚠ Τα per-window draw statistics των 252/254/255/256 είναι ΠΑΝΟΜΟΙΟΤΥΠΑ (35-50k draws,
  fce≈resolve≈30-45): ο ΑΡΙΘΜΟΣ draws δεν ξεχωρίζει κίτρινο από σκηνή. Εικόνα του 256: ΑΓΝΩΣΤΗ (ο
  χρήστης είπε μόνο «game closed»). ⚠ Πιθανό το «κίτρινο χαλί» (252, χωρίς screenshots) και η «σκηνή με
  κίτρινα μπλοκ» (255) να είναι Η ΙΔΙΑ εικόνα → αν το 257 δείξει 235272 στο colour[...] ενώ τα μπλοκ
  μένουν, το πρόβλημα είναι ΠΕΡΙΕΧΟΜΕΝΟ tiles (streaming/virtual texture), όχι draws που λείπουν.
- **RUN 257 (commit 587202c9, `GT7_probe257.bat` = env 256):** μετά από κάθε `[fprof]` μία γραμμή `[bigidx] t=NNs depth[235272x37
  74862x36 ...] colour[51924x35 ...] | indirect draws: depth N (max_count N) colour N (max_count N)` = τα
  ΔΙΑΚΡΙΤΑ index counts των draws ≥50k ανά παράθυρο (×φορές), depth-only vs colour, + DrawIndirect
  κλήσεις ανά colour-target. 235272 μέσα στο colour[...] = το έδαφος ζωγραφίζεται με χρώμα (direct)·
  μόνο άλλα counts + indirect colour > 0 = πιθανό indirect colour pass· τίποτα = απόν.
- **RUN 257 VERDICT (3 Σεπ 00:45-00:49, `logs/run257_bigidx.txt`): ΤΟ ΕΔΑΦΟΣ ΕΙΝΑΙ ΣΤΟ DEPTH PREPASS ΚΑΘΕ
  FRAME ΚΑΙ ΣΕ ΚΑΝΕΝΑ COLOUR PASS, ΠΟΤΕ** — 235272x35 + 74862x35 στο depth[] με fce 35 (1/frame) και ΠΟΤΕ
  στο colour[] σε 87 παράθυρα, με κανένα colour target· ούτε τα camera-dependent αδέρφια (224580, 213885,
  192495, 149718, 139023, 117639, 106941, 96249, 64164, 53469). Το colour pass στο HDR 0x1005000000
  ΤΡΕΧΕΙ σε ΑΛΛΑ meshes: 98304 ~2/frame σε depth ΚΑΙ colour ίσα (ps 0x10496c9200), 66060/57780 ίδιο ps,
  δεκάδες 50k-98k αντικείμενα ζευγαρωμένα, + colour-only (χωρίς prepass) 77784/85926/52764/65871/163196.
  Indirect draws depth≈colour (props σε δύο passes). Άρα ΔΕΝ είναι per-frame race: το colour draw του
  εδάφους ΔΕΝ εκδίδεται σε 3 λεπτά αγώνα. Capture 1 (run 250) δεν είχε ούτε τα 98304/77784 (max 10092) →
  το 250 είχε ΛΙΓΟΤΕΡΟ κόσμο σε χρώμα από τα 256/257. Εικόνα 257: ΑΓΝΩΣΤΗ (2η φορά «game closed»).
  config.json των probes: readbacks_mode 0, readback_linear_images false, direct_memory_access false
  (τα GT_DIRECT_IMPORT/BDA_IMPORT είναι knobs του fork, όχι το upstream DMA)· ο readback hunt (runs
  185/186, Relaxed, «wash unchanged, 1 FPS») κρίθηκε ΜΟΝΟ για το exposure wash, ποτέ για το έδαφος.
- **RUN 258 (`GT7_probe258.bat` = env 257 + `-RenderDoc`, F12 στον αγώνα με τον δρόμο
  στο κάδρο):** νέο .rdc στο `%APPDATA%\shadPS4\captures\` (1/2 = run 250, 3/4 = 27 Αυγ). Ανάλυση
  headless κατά τα analyze22-25: (1) κάθε draw με το ΙΔΙΟ IB/VB resource με το 235272 prepass draw +
  colour targets (direct ή indirect)· (2) ΤΙ είναι το 98304 (ps 0x10496c9200) και το 77784· (3) λίστα
  draws του HDR έναντι των 322 του capture 1. Κρίνει «δεν εκδίδεται ποτέ» (κυνήγι μηχανισμού GPU→CPU)
  έναντι «εκδίδεται με path που ο census δεν βλέπει» (bug του census).
- **RUN 258 VERDICT (3 Σεπ 18:18, `logs/run258_rdc.txt`, 4 captures ΠΑΝΩ στα παλιά ονόματα — τα captures
  του run 250 χάθηκαν, οι αναλύσεις τους μένουν στα `cap1_*.txt`): ⚠⚠ ΚΑΘΕ RENDERDOC CAPTURE ΕΙΝΑΙ ΑΛΛΟΣ
  EMULATOR.** Το layer του RenderDoc δεν δίνει `VK_EXT_external_memory_host` → `[bdaimport] disabled`,
  `[directimport] 0 queries` σε όλο το run (στο 257: ACTIVE, 8448 MiB, ~20k queries/παράθυρο). Το BDA
  import είναι ο ΜΟΝΟΣ δρόμος GPU→CPU (BDA store σε imported guest RAM), άρα capture 1 (run 250) και τα
  4 του 258 δείχνουν τον κόσμο ΧΩΡΙΣ αυτόν. Μέτρηση: τα draws των 98304 indices (ps 0x10496c9200, HDR
  target, ~2/frame σε depth ΚΑΙ colour, μαζί με 66060/57780) υπάρχουν σε ΚΑΘΕ παράθυρο αγώνα του 257 (τα
  14 «κενά» παράθυρα είχαν indirect 0 = camera cuts) και σε ΚΑΝΕΝΑ των 39 του 258 (colour[] = μόνο το
  ζεύγος 164961/81543 του menu/HUD αμαξιού + 77784 x7). Ανάγνωση: 98304 = 128x128 patches = η γεωμετρία
  χρώματος του εδάφους/δρόμου, εκδίδεται από τη CPU από λίστα που εξαρτάται από GPU δεδομένα· το
  235272/74862 (prepass μόνο, ποτέ colour) είναι ΑΛΛΟ mesh (occluder/shadow/collision) — το «χαμένο
  colour pass» του ήταν παραπλάνηση. Ο χρήστης: οι κίτρινες γραμμές = racing-line assist του παιχνιδιού
  (σωστό, όχι bug)· λείπει ο ΔΡΟΜΟΣ από κάτω («χωρίς τη γραμμή δεν βλέπω ούτε την πρώτη στροφή»).
  ΖΗΤΗΘΗΚΕ: επιβεβαίωση ότι στο 257 (χωρίς RenderDoc) ο δρόμος φαίνεται και στο 258 όχι. ⚠ ΝΟΜΟΣ: ποτέ
  RenderDoc για ό,τι εξαρτάται από GPU→CPU· έλεγχος `grep bdaimport shad_log.txt` πριν διαβαστεί capture.
  analyze26 (`c258_1..4_groundpair.txt`) στα 4 captures: ΚΑΝΕΝΑ colour draw ≥50k (μόνο ένα στο cap 4), το
  έδαφος 224580/149718+74862 (vs 4200) ζωγραφίζεται από ΕΝΑ buffer (184564) που ΚΑΜΙΑ έγχρωμη κλήση
  δεν δένει· post-VS: 74862 σε w 0,8-1,6 km, 224580 πανοραμικό (ndc x έως -3287, 4% πίσω από την
  κάμερα) = ΜΑΚΡΙΝΟ ανάγλυφο/occluder, όχι ο δρόμος· **77784 = το ΔΙΚΟ ΜΑΣ ΑΜΑΞΙ** (w 4,5-5,5 m,
  κάτω-αριστερά, textures shadow map 1024² + D16 7424² + reflection 256²)· τα 10k-50k draws του cap 4 =
  αμάξια/props. ⚠ analyze26 διαλέγει prepass/HDR target με ευρετικό (στα cap 1/4 πήρε το shadow map) —
  τα συμπεράσματα δεν εξαρτώνται από αυτό.
- **ΑΠΑΝΤΗΣΗ ΧΡΗΣΤΗ (3 Σεπ): Ο ΔΡΟΜΟΣ ΤΡΕΜΟΠΑΙΖΕΙ ΚΑΙ ΧΩΡΙΣ RENDERDOC** — «δεν ζωγραφίζεται τον περισσότερο
  χρόνο, εμφανίζεται για ένα δευτερόλεπτο και χάνεται, δεν προλαβαίνω screenshot». Άρα το 98304 (2/frame
  ΚΑΘΕ frame) ΔΕΝ είναι «ο δρόμος που ζωγραφίζεται»· ο census μετράει τι ΕΚΔΙΔΕΤΑΙ, το ελάττωμα είναι στο
  ΠΕΡΙΕΧΟΜΕΝΟ. Δύο screenshots του χρήστη (2 Σεπ 21:23, `%APPDATA%\\shadPS4\\screenshots`, Music Rally)
  το δείχνουν: ο δρόμος ΕΙΝΑΙ γεωμετρία = κορδέλα από flat-shaded ΗΜΙΔΙΑΦΑΝΕΣ ΠΛΑΚΕΣ, κάθε μία με
  ομοιόμορφη απόχρωση πορτοκαλί→λευκό με την απόσταση, ο ουρανός φαίνεται ΜΕΣΑ από τις μακρινές· καθόλου
  υφή ασφάλτου· το δεύτερο = ολόκληρο το frame σχεδόν λευκό (exposure flash). Ανάγνωση (ΥΠΟΘΕΣΗ, όχι
  μέτρηση): terrain patches ΧΩΡΙΣ tiles = virtual-texture feedback (GPU→CPU) που δεν φτάνει· «εμφανίζεται
  ένα δευτερόλεπτο» = tiles που έρχονται και πετιούνται.
- **RUN 259 (build 3 Σεπ 18:55, commit 0380589f, ΕΤΡΕΞΕ 19:04 → `logs/run259_autoshot.txt` + 84 PNG· `GT7_probe259.bat` = env 257 +
  `GT_AUTOSHOT=2`, ΧΩΡΙΣ RenderDoc):** ο emulator φωτογραφίζει ΜΟΝΟΣ ΤΟΥ game-only screenshot κάθε 2 s
  (`[autoshot] #n t=..s requested` στο ρολόι του [fprof], μετά `Saved screenshot: <png>`) → ~90 PNG στο
  `%APPDATA%\\shadPS4\\screenshots` που διαβάζω σαν εικόνες. Επίσης `[indargs]` ανά παράθυρο: τι λέει το
  ΠΡΩΤΟ command κάθε colour-target indirect draw (index count zero/max/sum, gpu-modified, count-word).
  Ανάγνωση: PNG δίπλα στο [bigidx]/[indargs] του ίδιου t=· frames με υφή δρόμου vs frames με πλάκες. Ίδιος
  census και στα δύο ⇒ το ελάττωμα είναι στο ΠΕΡΙΕΧΟΜΕΝΟ που δειγματίζουν τα draws (επόμενο όργανο:
  ποιες εικόνες δειγματίζει το pipeline του 98304 και αν γράφτηκαν ποτέ). ⚠ `GtFrameProfSeconds` έπρεπε
  να βγει ΕΞΩ από το ανώνυμο namespace του vk_rasterizer.cpp (πρώτο build: undefined symbol στο link).
- **RUN 259 VERDICT:** contact sheets (PIL 320x180 x42) = ολόκληρο το run σε 2 εικόνες. Chase cam: πλάκες
  πορτοκαλί→λευκό ΠΑΝΤΑ· άλλες κάμερες (#40, #66-68): ΟΛΟ το έδαφος ΜΙΑ επίπεδη γκρι επιφάνεια (το «εμφανίζεται
  για ένα δευτερόλεπτο» = άλλη κάμερα, ΟΧΙ άλλη κατάσταση)· μόνο ο ΜΑΚΡΙΝΟΣ δρόμος έχει σκούρα άσφαλτο (low-res
  resident, high-res δεν έρχεται = streamed texture). **98304 ΑΠΟΝ σε όλο το run** (ίδιο env με 256/257 όπου
  ήταν σε ΚΑΘΕ παράθυρο) → per-run race ΞΑΝΑ ανοιχτό, μη χτίσεις σε «98304 = δρόμος/όχι». **[indargs]: ΚΑΘΕ
  colour indirect draw (~50k στον αγώνα) διαβάζει index count ΜΗΔΕΝ από τη guest RAM, όλα gpu-modified** =
  με readbacks_mode 0 ΤΙΠΟΤΑ από ό,τι γράφει η GPU σε cached buffers δεν γυρίζει στη CPU (μόνο BDA import).
  Relaxed (runs 185/186) κατεβάζει ΜΟΝΟ πριν από guest WRITE· μόνο PRECISE read-protects → guest READ →
  fault → ReadMemory. Άρα το readback hunt ΔΕΝ δοκίμασε ποτέ το feedback buffer.
- **RUN 260 (ΕΤΡΕΞΕ 19:27 → ΚΡΑΣΑΡΕ· `GT7_probe260.bat` = 259 + `run_gt7.ps1 -Readbacks 2` = GPU.readbacks_mode
  PRECISE· ο διακόπτης γράφεται ΚΑΘΕ run, default 0, για να μην κολλάει):** πολύ χαμηλό FPS αναμενόμενο,
  το autoshot απαντά ανεξάρτητα: παίρνει ΠΟΤΕ ο κοντινός δρόμος άσφαλτο? ΝΑΙ → readback πρόβλημα (κάνε το
  feedback path φτηνό)· ΟΧΙ → το περιεχόμενο χάνεται GPU-side ([imgarray] class) → όργανο υφών (ποιες εικόνες
  δειγματίζει το terrain pipeline, γράφτηκαν ποτέ).
- **RUN 260 VERDICT: GUEST WILD JUMP στο t≈82 s (πριν τον αγώνα), `logs/run260_precise_crash.txt`.** Το Precise
  κατεβάζει τη GPU σελίδα ΠΑΝΩ στη guest — σελίδα που γράφει και η CPU χάνει τα δικά της bytes → σκουπίδια
  σε function pointer. Global precise readbacks = ΑΧΡΗΣΤΟ πείραμα στο GT7· η πόρτα GPU→CPU πρέπει να
  είναι ΣΤΟΧΕΥΜΕΝΗ (ένα feedback buffer), όχι καθολική.
- **`F:\\GT7_UNPACKED\\crs\\<cNNN>\\tex_stream` σε ΚΑΘΕ πίστα (100 MB c024 … 2 GB c247)** = οι υφές δρόμου
  είναι STREAMED tiles, όχι στατική texture — η υπόθεση του run 259 έγινε γεγονός των δεδομένων. Music Rally
  = event 1000825, `CourseLabel eifel_01` (ποιος φάκελος cNNN είναι: ΑΓΝΩΣΤΟ, δεν χρειάζεται ακόμα). Το
  παιχνίδι διαβάζει μέσα από `gt*.vol`, άρα file-open logging δεν δείχνει πίστα· το όργανο είναι GPU-side.
- **RUN 261 (build 19:36, commit aaa29f3e, ΕΤΡΕΞΕ 20:04 → `logs/run261_imgcensus.txt` + 179 PNG· `GT7_probe261.bat` = 259 + `GT_IMG_CENSUS=1`):**
  `[imgnew]` (μία φορά ανά εικόνα ≥1 MiB στο RegisterImage) + `[imgup]` κάθε 2 s (εικόνες ≥256 KiB που πήραν
  Image::Upload = CPU→GPU ή CopyImageWithBuffer = GPU copy). Ατλας που υπάρχει και ΔΕΝ ανανεώνεται στον
  αγώνα = τα tiles δεν έρχονται (στοχευμένο readback του feedback buffer)· ατλας που ανανεώνεται κάτω από
  επίπεδο δρόμο = σφάλμα στο sampling ([imgarray] class).
- **RUN 261 VERDICT: ΤΟ TILE CACHE ΥΠΑΡΧΕΙ ΚΑΙ ΔΕΝ ΤΡΟΦΟΔΟΤΕΙΤΑΙ ΠΟΤΕ.** Εικόνα: έδαφος ΜΑΥΡΟ (259: ανοιχτό
  γκρι· 5 frames ΚΟΚΚΙΝΟ) = το terrain shader δειγματίζει ΜΗ ΑΡΧΙΚΟΠΟΙΗΜΕΝΗ μνήμη (ίδια υπογραφή με LUT /
  red track map). Census: στο φόρτωμα (t=185-198) φτιάχνονται 4 arrays 128x128 L488 (Bc7Srgb 0x109dd42800 /
  Bc7 0x109d5a2800 / Bc6H 0x109e4e2800 / R8Uint 0x109ecc2800 = albedo/normal/HDR/id tile cache), R11G11B10
  arrays L1024/L2048/L1536/L256, 1024x1024 L4 R32F (0x10bd200000, indirection?), shadow atlases 7424² D16.
  **Σε 85 παράθυρα αγώνα (80 uncapped) ΚΑΝΕΝΑ από αυτά δεν πήρε Upload ούτε CopyImageWithBuffer.** Τα
  440-700 uploads/παράθυρο είναι ΟΛΑ render targets που ξανα-ανεβαίνουν από guest RAM (0x100a0b0000 sub-views,
  0x100b460000, 0x100a0c8000) = [rtclobber] class, ~10/frame, GT_RT_NOCLOBBER=0 στα probes — ΑΛΛΟ ελάττωμα
  (exposure wash), τώρα μετρημένο.
- **RUN 262 (build 20:14, commit ca20621f, ΕΤΡΕΞΕ 20:17 → `logs/run262_imgcensus2.txt` + 103 PNG· `GT7_probe262.bat` = 261):** census v2 μετράει και
  image→image copies (CopyImage/CopyMip/CopyRect) και shader writes (MarkGpuWritten), `[imgarr]` uncapped γραμμή
  για arrays ≥64 layers. Arrays 0/0/0 όλο τον αγώνα → τα tiles ΔΕΝ φτάνουν ποτέ στη GPU (το παιχνίδι δεν
  ζητάει/δεν αντιγράφει — feedback/BDA line)· cp/st>0 με μαύρο δρόμο → σφάλμα στο SAMPLING (indirection
  0x10bd200000 ή [imgarray] lost writes στο L1024 array).
- **RUN 262 VERDICT: ΤΙΠΟΤΑ δεν τροφοδοτεί τα tile caches (0 up / 0 cp / 0 st σε 101/104 παράθυρα· τα
  R11G11B10 probe arrays πήραν stores ΜΟΝΟ στο φόρτωμα t=69-71, άρα το όργανο βλέπει stores). Τα ~200
  copies/παράθυρο είναι ΟΛΑ 0x100a0b0000 (post-process atlas) = [rtclobber] class (~10/frame).
  **Ο ΧΡΗΣΤΗΣ ΕΙΔΕ GHOST FRAMES** («παλιά frames μένουν στην οθόνη»): frames #66-69 (t=170-176) = το ΙΔΙΟ
  Golf GTI 12 φορές, μικρότερο όσο πιο μακριά (σταθερή κάμερα, το αμάξι φεύγει), ΜΟΝΟ πάνω στο μαύρο
  έδαφος, ΠΟΤΕ πάνω σε ουρανό/δέντρα που ξανασχεδιάζονται. ⇒ το μαύρο/γκρι/κόκκινο «έδαφος» των runs
  259-262 ΔΕΝ είναι shader που δειγματίζει σκουπίδια — είναι το HDR target ΑΓΡΑΦΟ (ποτέ clear, ποτέ
  overdraw). Ένα ρίζωμα, τρία συμπτώματα: ο δρόμος δεν σχεδιάζεται → τα tiles δεν ζητούνται ποτέ → τα
  παλιά frames μένουν. HDR ήταν OFF (`hdr_allowed:false`) σε όλα τα runs — ο χρήστης ρώτησε, δεν φταίει.
- **RUN 263 (build 20:33, commit 4017a9a0, ΕΤΡΕΞΕ 20:37 → `logs/run263_forceclear.txt` + 271 PNG· `GT7_probe263.bat` = 262 + `GT_RT_FORCECLEAR=0x1005000000`):**
  `[clears]` census (colour binds / CMASK clears / depth clears / compute clears / πίνακας ανά RT) +
  αναγκαστικό ΜΑΤΖΕΝΤΑ clear του 1080p HDR target μία φορά ανά presented frame (`GtNotePresentFrame`
  στο PrepareFrame). Ματζέντα έδαφος → ΑΠΟΔΕΙΞΗ ότι δεν γράφεται (πίσω στη γραμμή indirect-args)·
  μαύρο έδαφος → γράφεται μαύρο από shader και τα ghosts είναι από post-process· όλα ματζέντα → λάθος
  target/πέρασμα, δοκίμασε `GT_RT_FORCECLEAR=1`.
- **RUN 263 VERDICT: ΜΑΤΖΕΝΤΑ = ΑΠΟΔΕΙΞΗ, και δεν είναι μόνο ο δρόμος.** Ghosts εξαφανίστηκαν (ο χρήστης το
  επιβεβαίωσε). Στα περισσότερα frames ΟΛΟ το κάτω μισό + μεγάλο μέρος του ουρανού ματζέντα· frame #99 (t=209)
  ΟΛΟ ματζέντα εκτός HUD (ούτε δέντρα). Το παιχνίδι ΔΕΝ καθαρίζει ποτέ το 0x1005000000 (c0 κάθε παράθυρο).
  **Η ΣΥΣΧΕΤΙΣΗ:** colour indirect calls/παράθυρο 3..5830· όταν είναι ΛΙΓΑ (t=219 → 3, t=248-254 → 54-78, race
  restart, camera cuts) η σκηνή ΕΜΦΑΝΙΖΕΤΑΙ με ΓΚΡΙ επίπεδο έδαφος· όταν είναι ΧΙΛΙΑΔΕΣ (t=209 → 3922) η σκηνή
  ΛΕΙΠΕΙ ολόκληρη. Δύο modes: direct-draw (φαίνεται) και GPU-driven indirect (ΔΕΝ βγάζει τίποτα). 98304 =
  128×128×6 quad grid (2-4/frame), ΔΕΝ είναι ο δρόμος. FPS: GpuCommandProcessor κορεσμένο (busy 1938/2000 ms,
  10-16 fps) — άλλο μέτωπο. «Μαύρα σχήματα» = μεγάλα σκούρα πολύγωνα που έρχονται/φεύγουν, αμέτρητα ακόμα.
- **RUN 264 (build 20:54, commit 649544b6, ΕΤΡΕΞΕ 20:58 → device lost t≈282 → `logs/run264_indgpu_crash.txt`· `GT7_probe264.bat` = 263 + `GT_INDARGS_GPU=200`):** `CaptureTableRegion` αντιγράφει τα
  args ΟΠΩΣ ΤΑ ΔΙΑΒΑΖΕΙ Η GPU (≤8 cmds + count word) για ≤200 colour indirect draws/παράθυρο → `[indgpu]`. GPU
  μηδενικά → φταίει το culling/compaction compute upstream (HiZ, miscompile, COND_EXEC, feedback)· GPU με
  πραγματικά counts + ματζέντα → φταίει το ίδιο το draw (vertex/instance fetch per draw-id, count path).
- **RUN 264 VERDICT: ΤΑ INDIRECT DRAWS ΔΕΝ ΕΙΝΑΙ ΤΟ ΠΕΡΙΒΑΛΛΟΝ.** GPU-side args (79 παράθυρα × 200 δείγματα): 65-70 %
  index count 0 ΚΑΙ στη GPU, τα υπόλοιπα ΜΙΚΡΑ instanced meshes (132 idx × 180 inst, 1179 × 34, max 1464), κανένα
  count-buffer. `condexec seen 0` (το GT7 δεν χρησιμοποιεί COND_EXEC), drops όλα 0. ⇒ **Η CPU ΣΤΑΜΑΤΑΕΙ ΝΑ ΔΙΝΕΙ
  τα μεγάλα direct draws του περιβάλλοντος** στη σταθερή κατάσταση και τα ξαναδίνει σε κάθε αλλαγή κάμερας /
  restart = occlusion culling που διαβάζει GPU αποτελέσματα → με readbacks OFF διαβάζει παλιά μηδενικά = «τίποτα
  ορατό». Device lost στο t≈282 (ιστορικό πρόβλημα, το capture ύποπτο όχι αποδεδειγμένο).
- **RUN 265 (build 21:08, commit 2a803a48, ΕΤΡΕΞΕ 21:12 ×2 → assert t=49 → `logs/run265_readbacks_onrace_watchers.txt`· `GT7_probe265.bat` = 263 + `GT_READBACKS_ONRACE=2`):** ξεκινά με readbacks 0 και
  γυρίζει σε PRECISE στο runtime όταν 3 συνεχόμενα παράθυρα έχουν >500 colour indirect draws (`[readbacks]`).
  Γκρι/υφή έδαφος μετά τη μεταγωγή → η πόρτα βρέθηκε (μετά: ποια λέξη, `[faulthist]`, στοχευμένο serve)· wild
  jump → clobber μικτών σελίδων, log τις διευθύνσεις· καμία αλλαγή → BDA/direct-import writes αόρατα στον tracker.
- **RUN 265 VERDICT: Ο ΔΙΑΚΟΠΤΗΣ ΗΤΑΝ ΑΝΑΣΦΑΛΗΣ, όχι το readback.** 13 γραμμές μετά το `[readbacks] t=49s switched
  0 -> 2` → `page_manager.cpp:193 AddDelta: Not enough watchers` (READ watcher bit), δύο φορές. Σε Disabled mode το
  `ChangeRegionState<GPU,true>` ΔΕΝ αγγίζει το read protection (gated `== Precise`), άρα το `readable` έμενε
  όλο-1 για κάθε σελίδα που είχε ήδη γράψει η GPU· η πρώτη εκκαθάριση μετά το flip (`!= Disabled`) έβγαλε
  μάσκα `~gpu ^ readable` που κάλυπτε ΚΑΙ τις ποτέ-προστατευμένες σελίδες με track=false → −1 σε 0. Η ερώτηση
  του readback ΔΕΝ απαντήθηκε (κανένα frame δεν έτρεξε με Precise ενεργό). Το Relaxed έχει τον ίδιο κίνδυνο σε
  runtime flip.
- **RUN 266 (build 21:18, commit 077b4890, ΕΤΡΕΞΕ 21:20 → assert t=60 → `logs/run266_resync_writeonly.txt`· `GT7_probe266.bat` = 265 χωρίς αλλαγή env):** το `Flush` μόνο ΟΠΛΙΖΕΙ
  (`readbacks_pending_mode`), ο rasterizer μετά το Flush καλεί `BufferCache::ResyncReadProtection()` →
  `MemoryTracker` walk του pool → `RegionManager::ResyncReadProtection()` = `UpdateProtection<true,true>()` όπου
  `gpu.Any()` (τότε readable=όλο-1 ⇒ μάσκα = ακριβώς τα gpu bits ⇒ +1 σωστό για όλες) και ΜΕΤΑ `SetReadbacksMode(2)`.
  `[readbacks] ... after read-protecting the GPU-modified pages of N regions`. Δέντρο απόφασης = του run 265·
  ξανά «Not enough watchers» → δεύτερο μονοπάτι που συντηρεί το `readable` εκτός resync.
- **RUN 266 VERDICT: Ο ΕΠΑΝΑΣΥΓΧΡΟΝΙΣΜΟΣ ΖΗΤΗΣΕ WRITE-ONLY ΣΕΛΙΔΑ.** Καμία `[readbacks]` γραμμή· `page_manager.cpp:332
  Protect: write-only is not a valid permission` μέσα στο resync. Write watchers ακολουθούν το `cpu`, read watchers το
  `gpu`: σελίδα με cpu=1 ΚΑΙ gpu=1 → Perms()=Write. Στο Precise δεν συνυπάρχουν ποτέ (InvalidateRegion κατεβάζει ΠΡΙΝ
  αφήσει τη CPU να λερώσει)· στο Disabled το download παραλείπεται και μετά από 50 s χιλιάδες σελίδες έχουν και τα δύο.
  Δύο runs, δύο διαφορετικά asserts, και τα δύο invariants που ο runtime flip δεν σέβεται. Το readback ερώτημα ακόμη
  ΑΝΑΠΑΝΤΗΤΟ.
- **RUN 267 (build 21:24, commit 5095b17f, ΕΤΡΕΞΕ 21:26 → assert t=61 από Job#0 → `logs/run267_resync_race.txt`· `GT7_probe267.bat` = 266 χωρίς αλλαγή env):** `both = gpu & cpu` → μετρημένες
  και σβησμένες από το `gpu` (η CPU κερδίζει — το επόμενο bind την ανεβάζει ούτως ή άλλως, ό,τι έκανε ήδη το Disabled)·
  οι υπόλοιπες gpu σελίδες (cpu clean = write-watched) παίρνουν read watcher → Perms None. Δύο `[readbacks]` γραμμές
  (πριν/μετά το resync, με regions + dropped pages). Δέντρο απόφασης = run 265.
- **RUN 267 VERDICT: RACE resync ↔ guest write fault.** Η πρώτη `[readbacks]` γραμμή βγήκε, η δεύτερη όχι· το assert
  (write-only) ήρθε από **Job#0 = guest thread**: όσο ο GPU-thread walk έβαζε read watchers και το mode ήταν ακόμη
  Disabled, ένα CPU write fault πήρε το Disabled μονοπάτι (χωρίς download) και έβγαλε τον write watcher της ίδιας
  σελίδας. Η αντίστροφη σειρά έχει τον καθρέφτη (run 265). **Τρία runs, τρία asserts, ΕΝΑ ελάττωμα: η read protection
  συντηρείται με μονόδρομα deltas που υποθέτουν ότι ήδη ταιριάζει με τα gpu bits** — αλήθεια μόνο με Precise από την
  εκκίνηση. Runtime switch δεν γίνεται ασφαλής με ΣΕΙΡΑ.
- **RUN 268 (build 21:31, commit 6d6907cc, ΕΤΡΕΞΕ 21:33 → ΧΩΡΙΣ crash → `logs/run268_readbacks_live.txt` + 104 PNG· `GT7_probe268.bat` = 267 χωρίς αλλαγή env):** `UpdateProtection<_,true>`
  αυτοδιορθούμενη ανά σελίδα: unreadable ⇔ gpu && !cpu, δύο passes (add/rem), το `track` αγνοείται· ChangeRegionState<CPU>
  και upload walk ανανεώνουν και τη read πλευρά με σειρά που δεν περνά ποτέ από write-only· όλα τα read calls gated
  `== Precise` (Relaxed δεν άγγιζε ποτέ σωστά τη read πλευρά). Ο rasterizer γυρίζει το mode ΠΡΩΤΑ, μετά eager pass.
  Δέντρο απόφασης = run 265.
- **RUN 268 VERDICT: Η ΠΟΡΤΑ ΒΡΕΘΗΚΕ.** Switch στο t=55 (μενού, fresh-profile flow → Music Rally), 153 regions
  προστατεύτηκαν, 169 διπλές σελίδες → CPU· ΚΑΝΕΝΑ crash σε 200 s με Precise. (1) `[indargs]` διαβάζει ΠΡΑΓΜΑΤΙΚΑ
  args πλέον (zero 60 % / max 1464 / sum ~1M — η κατανομή του run 264 από την CPU), gpu-modified 0 = κατέβηκαν. (2)
  `[bigidx] colour` έχει τα μεγάλα draws περιβάλλοντος (51924, 77784, 96120, 90180… ×8-42) ΣΕ ΚΑΘΕ παράθυρο· τα
  colour indirect calls κυμαίνονται ελεύθερα 8..3792. (3) Frames #83/#91/#93/#100: δρόμος με γραμμές, μπάρες,
  δέντρα, βουνά, ουρανός — πρώτο σχεδιασμένο έδαφος από το run 259. (4) ΚΟΣΤΟΣ: whitewash = ΕΚΘΕΣΗ (τα
  περισσότερα frames λευκά γύρω από bloomed αμάξι, #100 σωστά εκτεθειμένο = ταλαντώνεται)· **20-61k WRITE faults /
  παράθυρο** (Precise: CPU write σε GPU-modified σελίδα = σύγχρονο 512 KB download σε guest thread = «much slower»,
  buckets 0x2xxxxxxxxx heap + 0x101bb00000) έναντι 200-520 READ faults, **80 % των reads στο 0xe40e500000-0xe40e600000**
  (η λέξη που περιμένει το culling), υπόλοιπα 0x202a-0x2036, 0x2040-0x2045. (5) `[imgarr] none` — tile caches ακόμη
  ατροφοδότητα (δρόμος γκρι χωρίς υφή).
- **RUN 269 (build 21:46, commit dc7766dc, ΕΤΡΕΞΕ 21:47 → χωρίς crash → `logs/run269_readtrace.txt` + 65 PNG· `GT7_probe269.bat` = 268 + `GT_READ_TRACE=6`):** `[readtrace] summary` ανά 2 s
  (read faults / write-flush faults, ms total/max, «downloaded nothing») + ≤6 read faults με τα 16 bytes που θα διαβάσει
  ο guest (u32+f32) και buffer base. Ακέραιοι/bitmasks στο 0xe40e500000 → visibility· floats → exposure. Μετά: serve ΜΟΝΟ
  αυτό το buffer αντί για global Precise, και κόψε τα write-flush downloads (Relaxed για writes, Precise για reads).
- **RUN 269 VERDICT: ΤΑ READS ΕΙΝΑΙ Η ΚΑΘΥΣΤΕΡΗΣΗ, ΟΧΙ ΤΑ WRITES.** write-flush faults 6-177/παράθυρο (5-100 ms) — τα
  20-60k του run 268 ήταν φτηνά invalidations χωρίς download. Read faults 200-530/παράθυρο = **300-800 ms σύγχρονο
  download ανά 2 s** στο render thread του παιχνιδιού (max 30-175 ms ένα fault), 0 «downloaded nothing». **Τι διαβάζει
  η CPU:** resource descriptors (`00380010 … 20077fac`), float vectors/transform rows, μετρητές `(N,1,1,0)` στο
  0x1014de8c00 (dispatch args / visible counts), frame counter στο 0x1000fffd80 (0x164→0x1d4), και **64-bit δείκτες**
  (`0e5b7bc0 000000e4`) στα 16 KB buffers 0xe40e5xxxxx (80 % των reads) = GPU-driven scene graph, ΟΧΙ μία λέξη. Έκθεση
  ΔΕΝ ταυτοποιήθηκε (μόνο ένα μοναχικό f32 308.3 στο 0xec03cc8004). Whitewash συνεχίζεται, περιβάλλον σχεδιάζεται.
- **RUN 270 (build 21:55, commit e45d556d, ΕΤΡΕΞΕ 21:57 → χωρίς crash → `logs/run270_readwindow2048.txt` + 65 PNG· `GT7_probe270.bat` = 269 + `GT_READ_WINDOW=2048`):** `DownloadBufferMemory`
  επιστρέφει bytes· summary + `guest wall` (χρόνος στο guest thread — διαφορά από download = ουρά πίσω από τον
  κορεσμένο GpuCommandProcessor), distinct windows, MB copied· παράθυρο 2 MB. Faults↓4× & ms↓ → το παράθυρο είναι ο
  μοχλός (μετά: per-buffer window ή prefetch)· faults↓ ms όχι → κοστίζει η αντιγραφή → prefetch· guest wall ≫ download →
  ουρά → prefetch/dedicated queue. ⚠ Prefetch hazard: async write-back `UnmarkRegionAsGpuModified` σβήνει ΚΑΙ νεότερο
  GPU write στην ίδια σελίδα — unmark μόνο ό,τι αντιγράφηκε.
- **RUN 270 VERDICT: ΤΟ ΠΑΡΑΘΥΡΟ ΔΕΝ ΕΙΝΑΙ Ο ΜΟΧΛΟΣ.** Με παράθυρο 2 MB τα read faults έμειναν 250-520/2 s (269: 200-530) πάνω σε
  μόνο **12-25 ΔΙΑΦΟΡΕΤΙΚΑ παράθυρα** — τα ίδια ~13 παράθυρα ξανα-faultάρουν ΚΑΘΕ frame (η GPU τα ξαναγράφει κάθε frame,
  η read protection ξανα-οπλίζεται). Bytes 30-130 MB/2 s, download 200-660 ms/2 s (ίδιο), guest wall = 1.1-1.3× download
  → η ουρά είναι 15-30 %, το υπόλοιπο είναι το σύγχρονο `Finish()` = GPU drain ανά fault. Δρόμος σχεδιασμένος σε
  #45-53/#58-60 (ο χρήστης το είδε), whitewash παραμένει, fps ίδια (13-35 submits/2 s). Οι αιχμές 80-220 ms στα
  t=61-63/123-129 = `pipe` compile stalls (3.8 s / 9.1 s), όχι readbacks. Κύρια παράθυρα: 0x1014ddc000 (counters),
  0x1000ffc000 (frame counter), 0xec03cc8000 (pointer +0x90 κάθε frame, f32 309.4 στα +0x34/+0x64), 0x1020000000,
  ~12 16 KB pointer buffers 0xe40e5x/0xf429x, 6×2 MB του heap 0x20289c000.
- **RUN 271 (build 22:10, commit 3a7f528a, ΕΤΡΕΞΕ 22:14 → ΚΟΛΛΗΣΕ t=137 → `logs/run271_prefetch_hang.txt` + `logs/stuckstack_20260903_221659.txt`· `GT7_probe271.bat` = 269 + `GT_READ_PREFETCH=12`, παράθυρο πίσω στα 512 KB):**
  `BufferCache::PrefetchReadbacks()` από `Rasterizer::Flush` ΠΡΙΝ το `scheduler.Flush` — για κάθε παράθυρο που fault-άρισε
  τα τελευταία 8 flushes, `DownloadBufferMemory<true>` στο command buffer ΤΟΥ frame (budget 12 MB window-bytes, ο ring
  `download_buffer` είναι 32 MB — αν εξαντληθεί → `[tempdl]` = σύγχρονο drain στο GPU thread). Το fault path κάνει ΠΡΩΤΑ
  `PopPendingOperations()` (αν το παράθυρο έχει ήδη γραφτεί → copied 0, χωρίς Finish = «served») και αν copied 0 αλλά η σελίδα
  ακόμη GPU-modified με prefetch σε πτήση → `scheduler.Wait(tick)` (όχι fault loop). Ο async write-back (και του GC) πλέον
  παραλείπει ranges που η GPU ξανα-σημάδεψε (`gpu_modified_ranges.Intersects` → stale, ΔΕΝ unmark) ή που η CPU έγραψε
  (`IsRegionCpuModified`), unmark μόνο ό,τι έγραψε. Νέες γραμμές `[prefetch]` + «N read faults served, M waited».
  served≈faults & download ms → δεκάδες → πάμε whitewash· served μικρό → ο guest διαβάζει ΠΡΙΝ τελειώσει το tick →
  prefetch μετά το producing dispatch· skipped stale μεγάλο → ξαναγράφονται πιο συχνά από 1 frame· `[tempdl]` → μικρότερο budget.
- **RUN 271 VERDICT: ΚΟΛΛΗΜΑ GPU ΑΠΟ ΤΟ PREFETCH — Ο ASYNC WRITE-BACK ΔΙΑΒΑΖΕ ΑΝΑΚΥΚΛΩΜΕΝΟ STAGING.** Stuckstack: ο
  GpuCommandProcessor σε read-fault `DownloadBufferMemory<0> → Finish → MasterSemaphore::Wait` περιμένοντας GPU που δεν
  τελειώνει, Job#0 100 % spin σε guest κώδικα. Η τελευταία γραμμή πριν το μπλοκ: `HUGE DrawIndexedIndirect fs_0x4bb6fd35:
  919838150 vertices × 15 instances` — ΠΡΩΤΟ τέτοιο σε 268-271 (0/0/0/1), σκουπίδια indirect args = GPU που μασάει 13.8 G
  invocations = hang χωρίς TDR. Αίτιο: το `download_buffer` (32 MB StreamBuffer ring) ξαναχρησιμοποιεί περιοχή ΜΟΛΙΣ
  τελειώσει το tick της, αλλά το deferred op που τη ΔΙΑΒΑΖΕΙ τρέχει στο επόμενο pop (έως 1 frame μετά) → με 5-9 MB
  prefetch + 15-25 MB sync downloads/frame ο ring γυρίζει κάθε 2-3 frames → το op έγραψε ΑΛΛΟΥ download bytes στη
  παλιά διεύθυνση. Λανθάνον και στο buffer GC (ίδιο path). Δεύτερη θεωρητική τρύπα: δύο prefetch του ίδιου παραθύρου
  σε πτήση → διπλό Subtract → το πρώτο op unmark-άρει με stale bytes ενώ τα νεότερα περιμένουν pop που κάνει μόνο το
  GPU thread → spin με GPU thread IDLE. Απόδειξη λειτουργίας: served 23-47/παράθυρο (~5 %), skipped stale/CPU = 0,
  περιβάλλον σχεδιάζεται. Served μικρό γιατί ο guest διαβάζει μετά το δικό του fence ΑΦΟΥ έχει ήδη γραφτεί το mark του
  επόμενου frame → stale skip → drain όπως πριν· μοχλός = write-back ΠΡΙΝ το επόμενο mark (per-dispatch ή priority thread).
- **RUN 272 (build 22:24, commit 562257de, ΕΤΡΕΞΕ 22:27 → ΚΟΛΛΗΣΕ t=172 → `logs/run272_prefetch_refault_storm.txt` + `stuckstack_20260903_223137.txt` + 53 PNG· `GT7_probe272.bat` = 271 ίδιο env):** `prefetch_slots[4]` — δικό του Download
  buffer ανά flush (budget×2), slot ξαναχρησιμοποιείται ΜΟΝΟ όταν `pending==0` (τα ops του έτρεξαν), αλλιώς το flush
  παραλείπεται («slot busy»)· `PrefetchReadbacks` κάνει ΠΡΩΤΑ pop και ΔΕΝ γράφει δεύτερο prefetch σε παράθυρο με tick
  σε πτήση («skipped in flight»)· `DownloadBufferMemory<true>` στοιβάζει στο slot (ring μόνο αν δεν χωρά → «fell back to
  the ring»). Χωρίς hang + 0 HUGE Draw → το staging lifetime ήταν το αίτιο· hang με HUGE Draw → κοίτα ring_fallback·
  slot busy/in flight μεγάλα → GPU >1 frame πίσω → priority write-back.
- **RUN 272 VERDICT: ΚΑΜΙΑ ΔΙΑΦΘΟΡΑ (0 HUGE Draw, 0 ring fallback, 0 slot busy) — ΑΛΛΑ REFAULT STORM.** Στο t=172:
  70606/70968 faults «downloaded nothing», μετά ~800k faults/2 s ΟΛΑ σε ΕΝΑ παράθυρο (0xec03cc8000), 0 MB, 0.01 ms.
  Stuckstack: το GPU thread ΤΟ ΙΔΙΟ σε `KiUserExceptionDispatcher ← CopySparseMemory ← UploadCopies ←
  SynchronizeBuffer ← ConsumeDmaDirtyLog` — fault-άρει ΔΙΑΒΑΖΟΝΤΑΣ read-protected σελίδα στο upload, ο handler τρέχει
  inline (SendCommand στο GPU thread), δεν βρίσκει τίποτα στο gpu_modified_ranges, αφήνει τη σελίδα προστατευμένη →
  retry → fault → για πάντα. ΑΙΤΙΟ: το per-copy unmark του run 271 — σελίδα με tracker gpu bit αλλά ΧΩΡΙΣ range
  (upstream «download found nothing») δεν αντιγράφεται → δεν unmark-άρεται, και ένα re-marked range αλλού στο παράθυρο
  (ο δείκτης +0x90) μπλόκαρε το whole-window unmark. Upstream sync path unmark-άριζε ΠΑΝΤΑ όλο το παράθυρο. Served
  8-51/παράθυρο (~5-10 %), download 200-830 ms/2 s = αμετάβλητο. ΕΙΚΟΝΑ: δρόμος/kerbs/μπάρες/κτήρια/δέντρα πλήρως
  χτισμένα και με textures (#45, #48), ΤΟ ΑΜΑΞΙ = εκτυφλωτική λευκή μάζα με bloom που ασπρίζει το frame, magenta σε
  ουρανό/νερό. Το whitewash είναι στο shading του αμαξιού/φωτισμό, όχι στο περιβάλλον (υπόθεση: readback έκθεσης που
  κατεβάζει stale μηδενικά → «σκοτάδι» → max exposure — αναπόδεικτο).
- **RUN 273 (build 22:35, commit 91bbbb65 [Revision 562257de στο log], ΕΤΡΕΞΕ 22:37 → ΧΩΡΙΣ HANG, αγώνας ως το τέλος → `logs/run273_prefetch_heal.txt` + 70 PNG· `GT7_probe273.bat` = 272 ίδιο env):** ο deferred write-back unmark-άρει το
  παράθυρο ΑΝΑ ΣΕΛΙΔΑ 4 KB (σελίδα χωρίς range στο gpu_modified_ranges και όχι CPU-modified → χάνει το gpu bit)· το
  fault path «θεραπεύει»: copied 0 + σελίδα ακόμη GPU-modified + τίποτα σε πτήση → `UnmarkRegionAsGpuModified` (counted
  «healed», read+write, με ή χωρίς prefetch). healed λίγα → κλείνει η κλάση storm· healed χιλιάδες → συστηματική
  ασυμφωνία tracker/ranges αλλού· hang με «downloaded nothing» → fault έξω από το ReadMemory· HUGE Draw → ring_fallback.
- **RUN 273 VERDICT: Η ΚΛΑΣΗ STORM ΚΛΕΙΝΕΙ — ΚΑΙ Η ΥΠΟΘΕΣΗ ΕΚΘΕΣΗΣ ΠΕΘΑΝΕ.** 0 HUGE Draw, 0 ring fallback, 0 slot busy,
  `healed` 0/0 σε ΟΛΑ τα παράθυρα (ένα 0/1 στο t=141), «downloaded nothing» 0 παντού (272: 70606). Κόστος ίδιο: 240-660 read
  faults/2 s, 250-770 ms download, served ~5-10 %, fps 10-36 submits/2 s. FRAMES (#57/#60/#65/#66): το ΠΕΡΙΒΑΛΛΟΝ ΣΩΣΤΑ
  ΕΚΤΕΘΕΙΜΕΝΟ (σκοτεινά δέντρα, σκοτεινή άσφαλτος, κανονικό HUD, mean luma 89-125, clipped 1-6 %) ΣΤΟ ΙΔΙΟ frame που το ΑΜΑΞΙ
  είναι λευκή σφαίρα με halo· #60 magenta ουρανός (άγραφος) με λευκή ΛΩΡΙΔΑ φωτός πάνω του. Max exposure θα άσπριζε και τα
  δέντρα → ΔΕΝ είναι έκθεση: ΤΟΠΙΚΟΣ εκπομπός με τεράστια HDR τιμή που το bloom απλώνει. Ύποπτοι: (a) υλικό αμαξιού που
  διαβάζει ΑΓΡΑΦΗ ανάκλαση (ο ουρανός ΔΕΝ γράφεται — cube faces 256²×6 B10G11R11 0x10b10b5f00/0x10b07ca600), (b) sun/light-
  shaft pass (η λωρίδα ζωγραφίζεται ΠΑΝΩ στο magenta = additive μετά τον ουρανό), (c) headlight/lens sprites (dusk). Το «1x1
  R8 exposure state» 0x1000e33200 είναι 1x1×449 layers R8 = flags, ΟΧΙ exposure.
- **RUN 274 (build 22:53, commit a057dee2 [Revision 91bbbb65 στο log], ΕΤΡΕΞΕ 22:55 → ΔΥΟ αγώνες, χωρίς hang → `logs/run274_hdrprobe.txt` + 86 PNG· `GT7_probe274.bat` = 273 + `GT_HDR_PROBE=1 GT_HDR_PROBE_S=3`):**
  `Rasterizer::MaybeProbeHdr` στο BeginRendering ΠΡΙΝ το attachment transit — κάθε 3 s, στο ΠΡΩΤΟ bind κάθε float colour
  target (≥480x270, B10G11R11/RGBA16F, ≤16 MB, ≤6 ανά tick) ανά frame (= τελικό περιεχόμενο του ΠΡΟΗΓΟΥΜΕΝΟΥ frame) →
  download + Finish + decode → `[hdrprobe] ... max L at (x,y) rgb | inf/nan/>1e3/>1e2/>10/>1 | mean L | grid 12x6` (ψηφίο
  log10 ανά κελί, I=inf, N=nan). max L 1e3-1e5 σε λίγα px + mean sane → τοπικός εκπομπός, επόμενο = ΠΟΙΟ draw τα γράφει·
  INF/NaN → shader με διαίρεση με άγραφο μηδέν· mean L ψηλό → τελικά έκθεση· bloom targets καυτά ενώ HDR όχι → ο bloom
  pass είναι ο εκπομπός· καμία γραμμή → τα targets γράφονται από compute, πέρνα λίστα διευθύνσεων.
- **RUN 274 VERDICT: Ο ΟΥΡΑΝΟΣ ΓΡΑΦΕΤΑΙ ΚΟΡΕΣΜΕΝΟΣ.** Στα δύο HDR targets 1920x1080 B10G11R11 (0x1005000000 / 0x1006bc8000,
  ping-pong) `max L = 65024 rgb=(65024 65024 64512)` = η ΜΕΓΙΣΤΗ πεπερασμένη τιμή του 11/10-bit ufloat (κορεσμός) σε 40/48
  race frames, INF 0, NaN 0, 2k-750k pixels >1e3, σε ΟΡΙΖΟΝΤΙΑ ΖΩΝΗ grid rows 1-2 (y 180-540 = ουρανός/ορίζοντας) ενώ rows 3-5
  (δρόμος, αμάξι) <10. Το bloom (480x270 στα 1.1e4, 480x540 στα 3.5e4) κουβαλάει τη ζώνη αυτούσια. Η «λευκή σφαίρα = αμάξι»
  του run 273 ήταν το ΣΧΗΜΑ του bloom, όχι η πηγή. Τα 1920x1080 RGBA16F (0x10085f0000/0x1007600000) ΔΕΝ είναι χρώμα (G/B 65504
  στον ουρανό, 100-1000 στο έδαφος = βάθος/velocity) — αγνόησέ τα. Πριν το switch (t=130-134) τα ίδια targets διαβάζουν
  max 0.98 → ο κορεσμός αρχίζει με τη σκηνή του αγώνα. Ύποπτοι: sky/atmosphere draw που διαβάζει άγραφη/σκουπίδια είσοδο
  (sky LUT / equirect 1024x512 0x100d810000, 1024x256 0x100a540000, cube faces 0x10b10b5f00/0x10b07ca600) ή σταθερά έντασης
  ήλιου από stale readback. Ίδιο pass = ο ουρανός που ΑΛΛΕΣ φορές δεν γράφεται καθόλου (magenta).
- **RUN 275 (build 23:09, Revision a057dee2 στο log, ΕΤΡΕΞΕ 23:13 → Music Rally chase cam, χωρίς hang στον αγώνα [κόλλησε ΜΕΤΑ στο «main game», δεν ερευνήθηκε] → `logs/run275_drawprobe.txt` + 60 PNG· `GT7_probe275.bat` = 274 + `GT_HDR_DRAWPROBE=0x1006bc8000,0x1005000000
  GT_HDR_DRAWPROBE_S=20`):** `MaybeDrawProbe` μετά από ΚΑΘΕ draw στο watched target, για ΕΝΑ frame ανά 20 s: πλέγμα 24x12
  (288 texels, Finish ανά draw) → `[drawprobe] frame F draw #k ps 0x.. changed/hot/new, max L | T#s (διευθύνσεις+μέγεθος+
  dfmt, W=γράφεται) | 12 σειρές×24` + summary με το ΠΡΩΤΟ draw που έκανε δείγμα ≥1000. Ένα draw με T#s → sky pass, probe
  τις εισόδους του· full-screen draw που διαβάζει το ίδιο το HDR → composite/light-shaft, ο εκπομπός στην ΑΛΛΗ είσοδο·
  καυτό από το draw #0 → clear/blit· καμία γραμμή παρά το armed → ο ουρανός στο άλλο ping-pong buffer.
- **RUN 275 VERDICT: ΚΑΝΕΝΑ DRAW ΔΕΝ ΓΡΑΦΕΙ ΤΟΝ ΟΥΡΑΝΟ.** Στο frame 2299 (493 draws) οι σειρές 0-2 του πλέγματος (y<270) μένουν `1`
  = το magenta clear (1,0,1) από το draw #0 ως το τελευταίο draw που αλλάζει κάτι (#452)· στο 2691 (1245 draws) οι σειρές 0-6. Το
  screenshot #37 δείχνει magenta ουρανό, και το #20 (t=48, ΠΡΙΝ το switch των readbacks) επίσης → ο ουρανός που λείπει ΔΕΝ είναι
  σύμπτωμα readback. Οι κορεσμένοι (65024) από draws είναι ΜΙΚΡΑ γεωμετρικά draws στον ορίζοντα: #327 ps 0x55ee56bf (870 v),
  #329, #331 ps 0x453b8531 (5040 v), #450/#451 ps 0x59a23308 (924 v, 6 δείγματα το καθένα, αριστερά του ορίζοντα), #452 ps
  0xac6429fe (408 v) → 15/288 καυτά στο τέλος των draws. T#s: 2048x512 BC7 ×3 ή 128²/256² BC7 + 80x32 f6, + το κοινό lighting set
  (shadow 1024²x4 R32, 7424² 16-bit 0x2900000000, probe arrays f6) — ΤΙΠΟΤΑ μοναδικό έναντι των μη-καυτών draws → σταθερά
  (emissive) ή ο ίδιος ο shader. Frame 2691: κανένα draw δεν φτάνει 65024· #1192 ps 0x86c1cee3 (768 v, διαβάζει το ΑΛΛΟ HDR target
  ως T# = γυαλί/αντανάκλαση του προηγούμενου frame) 4.25e4, το #1207 το σκεπάζει → τελικό πλέγμα 0 καυτά. Η ΖΩΝΗ του τελικού frame
  (100k-1M px στο hdrprobe) ΔΕΝ γίνεται από draw: γράφεται ΜΕΤΑ το τελευταίο draw → compute (in-place bloom composite) ή copy.
  Frames 2136/2517 (3 και 2 draws, full-screen ps 0x4d8a5765 / 0x93d12532) = post-process ping-pong με καυτά ήδη μέσα· το αμάξι
  διαβάζει `3` (100-1000) = η λευκή σφαίρα. Το «draw #0 changed 288» ήταν artifact (prev από 20 s πριν)· max L=1 = clear (1,0,1).
- **RUN 276 (build 23:29, commit 386f56ea [Revision 2c3e7ec2 στο log], ΕΤΡΕΞΕ 23:32 → `logs/run276_dispprobe.txt` + 68 PNG· ο χρήστης: «ο ουρανός και τα σύννεφα ΖΩΓΡΑΦΙΖΟΝΤΑΙ σε κάποια frames» — σωστό, #45/#48· `GT7_probe276.bat` = 275 + `GT_DUMP_HASHES=55ee56bf,453b8531,59a23308,ac6429fe,
  4d8a5765,93d12532,86c1cee3,f335b5c7,1185ec50`):** `MaybeDispatchProbe` μετά από ΚΑΘΕ compute dispatch του probed frame (ίδιο
  πλέγμα, `op S` κοινός μετρητής με τα draws, log όταν αλλάζει δείγμα Ή δένει το target ως T#/V# = `BINDS TARGET`, με cs hash,
  T#s, V#s που καλύπτουν το target) + baseline πλέγμα από το download του arm + summary και για τα dispatches. `GT_DUMP_HASHES`
  (`IsForcedDumpShader` στο vk_pipeline_cache.cpp) γράφει GCN .bin + `.forced.irprogram/asl.txt` + .spv στο shader\dumps για τα
  hashes. Verdicts: dispatch που γυρίζει τις πάνω σειρές από `1` σε τιμές → ο ουρανός είναι compute και τρέχει (T#s = είσοδοι)·
  σειρές ακόμα `1` στο summary → το sky pass ΔΕΝ εκδίδεται (grep `substituting a NO-OP module`)· dispatch με BINDS TARGET που
  γυρίζει τα 15 σπόρια σε ζώνη → in-place bloom, οι σπόροι = τα μικρά draws → διάβασε τα dumps· τίποτα δεν αλλάζει το πλέγμα
  αλλά η ζώνη εμφανίζεται → copy/DMA ή draw στο ΑΛΛΟ buffer.
- **RUN 276 VERDICT: ΚΑΝΕΝΑ DISPATCH ΔΕΝ ΑΓΓΙΖΕΙ ΤΟ TARGET, ΤΟ 65024 ΕΙΝΑΙ ΤΟ CLAMP ΤΟΥ ΙΔΙΟΥ ΤΟΥ ΠΑΙΧΝΙΔΙΟΥ.** 65-351 dispatches
  ανά probed frame, `0 changed it`, 0 `BINDS TARGET` (κανένα CS δεν δένει το 0x1005000000 ως T# ούτε V# πάνω του) → το post chain
  είναι pixel shaders και ο γράφων της ζώνης είναι DRAW που δεν έβλεπα: οι 4 dumped hot shaders κάνουν export RenderTarget0 ΚΑΙ
  RenderTarget1 (MRT), άρα το HDR buffer κάθεται σε **cb1** σε ολόκληρα passes ενώ το probe κοιτούσε μόνο cb0 (γι' αυτό «493 draws
  into it» από χιλιάδες). Και οι 4 τελειώνουν ΙΔΙΑ: `FPMedTri32 #65000, (ReadConst #296/#297/#298 × lit colour), #0` = clamp(x*c,
  0, 65000) → 65024 = ο κοντινότερος ufloat11 στο 65000. Δηλαδή το γινόμενο ≥ 65000: είτε το lit colour είναι τεράστιο είτε οι
  σταθερές #296-298 (per-channel πολλαπλασιαστής, pre-exposure/emissive — ό,τι ακριβώς υπολογίζει η CPU ΑΠΟ READBACK ιστογράμματος·
  το whitewash αρχίζει στο switch t=52-53). Ο ουρανός ΖΩΓΡΑΦΙΖΕΤΑΙ σε κάποια frames (#45/#48 σύννεφα, hdrprobe top rows `.`).
  Το `1` στο πλέγμα ήταν διφορούμενο (magenta clear ή ουρανός L 1-10). Μηδέν `substituting a NO-OP module` στο run.
- **RUN 277 (build 23:44, commit 7999b2d0 [Revision 386f56ea στο log], ΕΤΡΕΞΕ 23:47 → `logs/run277_anyslot.txt` + 61 PNG· `GT7_probe277.bat` = 276 ίδιο env):** το draw probe ταιριάζει το target σε ΟΠΟΙΟ
  cb slot (γραμμή `cb<slot>`), γράφει ανά draw τις σταθερές `#296..298` από τη μνήμη (PS user_data SGPR0:1 + 296*4), `m` = magenta
  clear στα πλέγματα, και `FINAL` πλέγμα του probed frame στο πρώτο bind του επόμενου. Verdicts: draws με cb1 που γυρίζουν τις
  πάνω σειρές από `m` σε τιμές → το sky pass· hot draws με σταθερές 1e3-1e6/INF ενώ τα υγιή ~1 → ο πολλαπλασιαστής είναι το λάθος
  (CPU-written → από ποιο readback)· ίδιες υγιείς σταθερές → το lit colour είναι τεράστιο → η βλάβη μέσα στο shading (inputs)·
  FINAL με ζώνη που το τελευταίο op δεν είχε → γράφων ανάμεσα (slot που ακόμα λείπει, ή copy).
- **RUN 277 VERDICT: ΤΟ TARGET ΕΙΝΑΙ ΠΑΝΤΑ cb0, Ο ΠΟΛΛΑΠΛΑΣΙΑΣΤΗΣ ΕΙΝΑΙ ΜΙΚΡΟΣ, Ο ΟΥΡΑΝΟΣ ΕΙΝΑΙ DRAW ΠΟΥ ΛΕΙΠΕΙ.** 0 draws σε cb1..7
  (η θεωρία MRT του 276 ΑΝΑΤΡΕΠΕΤΑΙ· RT1 = ο RGBA16F aux buffer), όλα τα FINAL `changed 0 since last op`. Σταθερές #296..298 στα
  hot draws: 0x59a23308 → 3.07e-05 ×3 (frame 2274) / 1.85e-4 (2127), 0xac6429fe/0xfedb7904 → 3.07e-05, 0x55ee56bf → 0 1.744 1
  (βάση SGPR0:1 επαληθευμένη στα 3 IR dumps) → pre-exposure ΛΟΓΙΚΟ, άρα το lit colour ≥ 65000/3.07e-5 = 2.1e9 ή INF → η βλάβη
  στα shading inputs. Οι hot shaders ΔΕΝ είναι sprites: 23 image ops, 8 shadow Dref lookups, light LUT arrays, pull-model
  interpolation (BaryCoordSmoothSample + GetAttribute Param, comp, vertex), 924/870/408/384 κορυφές· lit = %4260 Phi chain
  (δεν εντοπίστηκε η πηγή). Hot δείγματα ΜΟΝΟ στα frames 2127 (#5) και 2274 (#313/#327/#420-422 → 15/288, σειρές 2-5 = ορίζοντας)·
  τα 2482/2657 ΚΑΘΑΡΑ (FINAL max 46/244). **Ουρανός = ps 0xf335b5c7, direct1188, op 0, αλλάζει 273-279/288 δείγματα σε L≤1:**
  υπάρχει στα 2482/2657, ΛΕΙΠΕΙ στα 2127/2274 (baseline όλο `m`, πρώτο touched op #15 = ο δρόμος 44880 κορυφών, FINAL με τρύπες
  `m` στη ζώνη του ορίζοντα = ίδια ζώνη με τα hot). Οι full-screen #416 0x46f246cd (4 κορυφές)/#417 0x4861092c (3) γεμίζουν μόνο
  τις σειρές 0-1. Screens #41-43 (t=96-101): η ΑΛΗΘΙΝΗ σκηνή = πίστα σούρουπο/νύχτα, σκοτεινός ουρανός, φωτισμένες ταμπέλες, το αμάξι
  μέσα σε λευκή σφαίρα glare. Το wash αρχίζει t=55 (#23) = readback switch t=52 + scene load (30 imgnew t=53) — μη διαχωρίσιμα,
  και προϋπάρχει του readback μηχανισμού. Dynamic resolution 1750x984 → `m` δεξιά στήλη/κάτω σειρά = καλοήθη.
- **RUN 278 (build 00:02, commit a6a8acb8 [Revision 7999b2d0 στο log], ΕΤΡΕΞΕ 00:08 → `logs/run278_stub5.txt` + 67 PNG· `GT7_probe278.bat` = 277 + `GT_STUB_SHADERS=59a23308,55ee56bf,ac6429fe,fedb7904,
  453b8531` + `GT_HDR_DRAWPROBE_PS=f335b5c7,46f246cd,4861092c`):** stub των 5 hot shaders (απόδειξη με αφαίρεση· η cache είναι κρύα,
  τα `Compiling fs shader` του 277 το δείχνουν)· watched ps καταγράφεται σε ΚΑΘΕ draw (`changed 0 samples (watched ps)`), τα πρώτα
  12 draws κάθε frame (`(head)`), κάθε γραμμή με `vs <hash>` + σάρωση constant block PS (512 dwords)/VS (256): nonfinite, |v|>1e4,
  8 πρώτες ανωμαλίες, #0..3, #296..298· summary `watched: ps X: N draws (M touched)`. Verdicts: race hdrprobe max <10 → οι 5 είναι
  η μόνη πηγή, οι screens δείχνουν ποια γεωμετρία λείπει, μετά trace του %4260 στο IR· 65024 μένει → άλλοι γράφοντες· `0 draws`
  του f335b5c7 σε frame με τρύπες → το παιχνίδι ΠΑΡΑΛΕΙΠΕΙ το sky draw (CPU απόφαση/readback)· `1 draw (0 touched)` 1188 κορυφές →
  degenerate/off-screen → ύποπτο το vs-cb (matrix)· `indirect x0` → GPU-written count 0· ανωμαλία σταθεράς μόνο στα hot → αυτή.
- **RUN 278 VERDICT: ΟΙ 5 STUBBED SHADERS ΔΕΝ ΗΤΑΝ Η ΜΟΝΗ ΠΗΓΗ.** Stubs εφαρμόστηκαν (6 substituting lines) και το 65024 έμεινε
  (>1e3 μέχρι 815k pixels). Νέοι γράφοντες: **ps 0x97b39964 `indirect1 x0`** (frame 2693 #533, 13 hot στις σειρές 6-7 = ΤΟ ΑΜΑΞΙ·
  T#s: 2× 1024x2048 BC7 livery + ΤΑ ΙΔΙΑ lighting inputs όλων των hot draws: 0x1000e7b800 128x128 f12, 0x1001800000 128x128x256 f6,
  0x1002800000 64x64x1536 f6, froxel 30x17x16 f11 σε CPU-side 0x2.. διεύθυνση, shadow maps 1024x1024x4 R32 + 7424² R16), και
  **ps 0x4861092c `direct3 cb1`** (frame 2320 #0 = full-screen copy που κουβαλά τη ζώνη στο άλλο HDR buffer, 124 hot). Οι screens:
  με τα stubs φαίνονται πίστα/δέντρα/ταμπέλες/ουρανός με σύννεφα (#46-63) και το αμάξι = λευκή μάζα· τα magenta στο γρασίδι =
  η γεωμετρία που ζωγράφιζαν οι 5 stubbed (0x55ee56bf = terrain strips 2048x512). Σάρωση σταθερών: nonfinite 0 παντού, τα |v|>1e4
  = ίδια packed bit patterns κάθε frame (ΟΧΙ στοιχείο). **Ουρανός = artifact του arming:** τα frames χωρίς f335b5c7 (2066, 2223,
  2320) είναι frames όπου το probed buffer ΔΕΝ ήταν το scene target (2223: 1073 draws, 20 touched, FINAL όλο `m`, opening = menu
  sequence 0x12e89e9c· 2320: op 0 = full-screen copy + post quads cb1)· τα 2516/2693 ανοίγουν με scene geometry (3ebc1bd7 3528,
  b2d26667 7416-10740 κορυφές) και sky dome στο op 0 → τα δύο HDR buffers ΑΛΛΑΖΟΥΝ ΡΟΛΟ ανά frame. **Performance ΑΜΕΤΑΒΛΗΤΗ:**
  fprof submits/2 s t=60-130: run 277 12-29, run 278 10-28, ίδια draws (25-37k)/window, ίδια `pipe` spikes 2-4 s → τα 5-14 fps
  ΠΡΟΫΠΗΡΧΑΝ· ο χρήστης «δεν προλαβαίνω το timer» = το music rally timer τρέχει σε real time.
- **RUN 279 (build 00:21, commit 5f93b625 [Revision a6a8acb8 στο log], ΕΤΡΕΞΕ 00:25 → `logs/run279_texprobe.txt` + 76 PNG· `GT7_probe279.bat` = 278 με `GT_STUB_SHADERS=` ΚΕΝΟ + `GT_HDR_TEXPROBE=1`):**
  `Rasterizer::TexProbe`: όταν draw δημιουργεί ΝΕΑ hot δείγματα, κάθε T# του PS (≤10/frame, μία φορά ανά διεύθυνση) κατεβαίνει
  ΟΛΟΚΛΗΡΟ σε chunks ≤8 MB (layers ή depth slices), decode (B10G11R11, R16/RG16/RGBA16F, R32/RG32/RGBA32F· BC = skipped) →
  `[texprobe] ... max V at (x,y) slice s ch c | inf nan >1e3 >1e2 zero of N | mean | most >1e3 in slice`. Οι διευθύνσεις μένουν
  για όλο το run και κάθε dispatch που ΓΡΑΦΕΙ μία τους → `[texprobe] ... cs X WRITES hot input` (ο producer). Verdicts: LUT/froxel
  με inf ή >1e3 → η είσοδος είναι η βλάβη, ο producer cs ονομάζεται → dump inputs+IR του· όλα sane (<100) → βλάβη στο shader math /
  vertex attribute → bisect του %4260 chain (pull-model interp, `<type error>` image ops)· shadow maps INF → side finding·
  καθόλου census lines → T#s εκτός texture cache (bindless/BDA) → διάβασέ τα από guest memory.
- **RUN 279 VERDICT: ΒΡΕΘΗΚΕ Ο ΦΟΡΕΑΣ — Ο ΠΙΝΑΚΑΣ LIGHT PROBES 64x64x2048 ΕΧΕΙ TEXELS 65024.** Τρία hot draws (0x55ee56bf,
  0x59a23308 ×2, t=91/112/133), ίδιο census κάθε φορά: `0x10a6a1c100` 64x64x2048 B10G11R11 **max 65024 at (43,26) slice 985,
  28 texels >1e3 (25 στο slice 985)**, 99.8% μηδενικά, mean 0.016 = ΣΤΑΤΙΚΟ περιεχόμενο. Ο αδελφός `0x1002800000` 64x64x1536
  (256 cubemaps) max 1040 στο κέντρο face (ήλιος clamped ~1000 από το παιχνίδι) → το 65024 είναι εκτός οικογένειας = INF/τεράστιο
  που έκοψε ο encoder. `0x1001800000` 128x128x256 max 102, RGBA16F 128x128x2 max 2.25 = καθαρά· shadow maps D16/D32 και froxel
  R32G32Uint δεν αποκωδικοποιούνται. Μηχανισμός: lit = probe texel 65024 × specular lobe λείας επιφάνειας (GGX D 1e4-3e5) ≥ 2e9 →
  clamp 65000 → γι' αυτό το ΑΜΑΞΙ (καθρέφτης) είναι λευκή μάζα και frames που δεν κοιτούν το slice 985 βγαίνουν καθαρά. Ποιος
  γράφει: `[imgnew] t=46s 0x10a6a1c100 mips 7 layers 2048`, `[imgarr] up1/st308` (t=46) + `st3514` (t=48) = 3822 storage writes από
  COMPUTE στο φόρτωμα, ποτέ ξανά → ο producer check του 279 (μόνο μέσα σε probed frames μετά το t=91) δεν τον είδε. Whitewash
  «χειρότερο» (mean >1e3 65k→80k px) = απλώς χωρίς stubs· submits ίδια (8-29). Intro: δύο μεγάλες ΜΑΥΡΕΣ σφήνες (culled γεωμετρία,
  άλλο θέμα, σημειωμένο).
- **RUN 280 (build 00:34, commit ee1aad08 [Revision 5f93b625 στο log], ΕΤΡΕΞΕ 00:38 → `logs/run280_texwatch.txt`· `GT7_probe280.bat` = 279 + `GT_HDR_TEXWATCH=0x10a6a1c100,0x1002800000`):**
  `MaybeProducerProbe` σε ΚΑΘΕ dispatch (χωρίς frame gate): η watch list σπέρνει το hot-input set· κάθε dispatch που δένει watched
  image ως WRITTEN → `[texprobe] t= frame producer #N of va: dispatch XxYxZ cs HASH writes ... | T#s | n V#s` (πρώτα 40 + κάθε 500ό)
  και `TexProbe` του πίνακα αμέσως μετά το 1ο και κάθε 500ό write. Verdicts: 65024 από το πρώτο census → ο compute shader το γράφει →
  GT_DUMP_HASHES + inputs του· εμφανίζεται σε μεταγενέστερο count → συγκεκριμένο pass (mip gen/re-light)· sane μετά το τελευταίο
  write → άλλος γράφων (draw attachment/CPU upload, δες `[imgup] up1`)· καθόλου producer lines → bindless/BDA path.
- **RUN 280 VERDICT: Η ΠΟΡΤΑ ΕΙΝΑΙ ΤΟ CPU UPLOAD.** Ίδιος πίνακας, ίδια σκηνή, 2400× περισσότερα σκουπίδια: run 279 `>1e3 28,
  mean 0.016` → run 280 `>1e3 68838, mean 12.05` (slice 57: **12284 από 12288 τιμές >1000** = ολόκληρο slice σκουπίδια· max 65024
  στο ΙΔΙΟ (43,26) slice 985 και στα δύο = μέρος του περιεχομένου είναι ντετερμινιστικό). Οι αδελφοί πίνακες αμετάβλητοι (1040 / 102 /
  2.25). hdrprobe race mean `>1e3`: 79961 → **160499 px** — το «πιο τυφλό φως» του χρήστη είναι αληθινό και μετρημένο.
  **Ο μηχανισμός:** `[imgarr]` δείχνει ΕΝΑ upload από guest RAM ανά session — run 279 `t=46 up1/st308` → `t=48 up0/st3514`
  (το upload στο φόρτωμα, το compute το έγραψε ΜΕΤΑ από πάνω → 28 hot), run 280 `t=101 up1/st1911` → `t=103 up0/st1911`
  (το upload ΜΕΣΑ στον αγώνα, μετά τα writes → κάθε census στο t≥146 διαβάζει τα σκουπίδια). Άρα η σοβαρότητα του whitewash =
  πόσο από το garbage upload πρόλαβε να σκεπάσει το compute. **Αυτό εξηγεί και τη διακύμανση από session σε session από το Act 1.**
  **Ο producer ΔΕΝ ονομάστηκε:** μόνο 2 producer lines, και για άλλη εικόνα (`0x10b18d9700` 80x32x40, cs 0xe3dae865, ΚΑΘΑΡΗ max 0.66)·
  τα 1911 storage writes στον πίνακα ΔΕΝ περνούν από το per-descriptor bind loop → GT7 τα γράφει μέσω του **bindless image-array
  path** (GT_BINDLESS_IMGARRAY=16) → θέλει hook εκεί. Performance: race submits 11-29 (ίδια με 278/279)· ό,τι ένιωσε ο χρήστης
  είναι το ΟΡΓΑΝΟ (Finish ανά draw σε frames με 1073 draws + 60 MB downloads ανά hot draw).
- **RUN 281 (build 18:47, ΔΕΝ έχει τρέξει — ΤΟ FIX· `GT7_probe281.bat` = 280 + `GT_IMGZERO=1`, `GT_HDR_DRAWPROBE=` ΚΕΝΟ,
  `GT_WATCH_VA=0x10a6a1c100 GT_WATCH_SIZE=0x2c00000`):** στο `TextureCache::RefreshImage` (πριν το `RENDERER_TRACE`) μια εικόνα με
  σχήμα probe array (64x64, B10G11R11, `layers>=512`, **`levels>=2`**, όχι volume) **καθαρίζεται σε ΜΗΔΕΝ αντί να ανέβει από guest
  RAM**, μαρκάρεται GpuModified με mip-hash baseline και καταναλώνεται το dirt (ίδιο σκεπτικό με το `GT_LUT_IDENT`: η guest RAM δεν
  είναι ΠΟΤΕ η αλήθεια για εικόνα που γράφει μόνο το compute). Το `levels>=2` αφήνει τον ΥΓΙΗ αδελφό (1 mip) ήσυχο. Το log λέει τι
  κρατούσαν τα bytes που αρνηθήκαμε (decode στη CPU, χωρίς GPU download). Το per-draw probe ΚΛΕΙΣΤΟ → παίζεται και η ΕΙΚΟΝΑ είναι η
  μέτρηση. ⚠ Είναι WORKAROUND: το σωστό είναι να ΜΗΝ ανεβαίνει καθόλου (τρίτη κλάση εικόνων που χτυπά τον κανόνα «dirty image =
  re-upload από guest memory χωρίς ερωτήσεις», μετά το grading LUT και τα render targets). Verdicts: το τυφλό φως καταρρέει (race
  `>1e3` από ~1e5 σε ~1e3) → ο μηχανισμός επιβεβαιώθηκε, μετά «clear ΜΙΑ φορά και μετά μόνο κατανάλωση dirt»· μένει → ή ξανα-clobber
  από refresh που δεν πιάνει το predicate (δες τις νέες `[aewatch] upload 0x10a6a1c100 dw:`) ή δεν είναι ο μόνος φορέας· σκοτεινές
  αντανακλάσεις + μεγάλο `[imgzero] #N` → σβήνει compute content σε κάθε refresh → κάνε το «clear once»· μόνο `NOT zeroing ... GPU
  content pending` → η πόρτα είναι το orphan-GpuDirty → `GT_GPUWRITE_NOCLOBBER=1`.
- **ΚΑΘΑΡΙΣΜΑ ΔΙΣΚΟΥ (3 Σεπ, ζήτημα χρήστη):** σβήστηκαν τα 4 .rdc του run 258 (5,6 GB — ΔΕΝ υπάρχει πια
  κανένα capture στον δίσκο), το `rdc/capture4.zip` (1,1 GB) και 9 `cache_pre_*` (1,4 GB). Τα logs πριν το
  run 255 είναι `.txt.gz` (235 αρχεία, 2504→186 MB) — τα handoffs τα αναφέρουν ως `.txt`, διάβασε με zcat.
- **LAUNCHER PACKAGE «shadps4 0.18.1» (ζήτησε ο χρήστης, 2 Σεπ):** ο «launcher» = `Desktop\shadPS4QtLauncher-win64-qt-2026-08-08-a12b988\shadPS4QtLauncher.exe` (ξεχωριστό Qt GUI που καλεί εξωτερικό exe· το fork ΔΕΝ έχει Qt). Φάκελος `Desktop\shadPS4 0.18.1 - GT7 dev - 2026-09-02\`: `shadps4-core.exe` (το build μας) + `shadps4 0.18.1.exe` = wrapper (`GT7_work/launcher_wrapper/shadps4_gt7_wrapper.cpp`, `build_wrapper.bat`, clang-cl) που βάζει τα 34 GT_ knobs του probe .bat + (3 Σεπ, commit 587202c9) τα 19 που προσθέτει το `run_gt7.ps1 -Net` (DEFER_EOP/RELEASEMEM, BINDLESS_STUB, SOFT_CLAMP, STORE_CLAMP, DYNRC_WINDOW=1, BINDLESS_LOWER/IMG/STORES/IMGARRAY=16, IMGARRAY_SYNC 0/64, INVAL_IMG_ON_SSBO 0, LUT_DUMP 0, IMGWRITE_SCRUB 1, RT_SCRUB 92126594, HASH_BASELINE 1, DISPATCH_BARRIER 0, DYNRC_GPU 0 — ΟΧΙ τις config-εγγραφές του script: DMA flag, network flags, log filter) ΚΑΙ ξεκινά τον PSN stub server (python, 127.0.0.1:31313) ΜΟΝΟ όταν το arg περιέχει CUSA24769/"Gran Turismo"· αλλιώς γυμνός emulator. Καταχωρημένο στο `%APPDATA%\shadPS4QtLauncher\versions.json` (name 0.18.1, type 2; backup `.bak_20260902`). ΟΛΑ τα GT_ knobs είναι OFF όταν λείπουν από το env — γι' αυτό υπάρχει ο wrapper. Μετά από κάθε build για παιχνίδι: αντέγραψε το νέο exe ως `shadps4-core.exe` εκεί.

- **RUN 281 (4 Σεπ): ΤΟ FIX ΑΠΕΤΥΧΕ ΚΑΙ ΤΟ ΠΡΑΓΜΑΤΙΚΟ ΑΠΟΤΥΠΩΜΑ ΕΙΝΑΙ **NaN** — ΚΑΙ ΕΙΝΑΙ Ο ΟΥΡΑΝΟΣ.**
  Το `GT_IMGZERO` δούλεψε μηχανικά αλλά **δεν άλλαξε τίποτα**. Η γραμμή του μέτρησε ΟΛΟ το mip 0
  (8.388.608 texels / 33.554.432 B = 75% των texels του 7-mip array) και το βρήκε εξ ολοκλήρου μηδέν:
  «0 above 1e3, 0 non-zero, max 0». Τα mips 1-6 **δεν σαρώθηκαν**, άρα δεν λέμε πια «όλο το array
  ήταν zero». Το mip 0 είναι όμως εκεί όπου το census βρήκε τα 65024, οπότε το CPU upload δεν ήταν ο
  φορέας αυτών των hot texels. Time-matched παράθυρο 38,7 s: SAT rate 277 57,1% / 278 50,0% /
  279 33,3% / 280 59,3% / 281 53,8% (pooled baseline 50,0%) — **καμία ανιχνεύσιμη βελτίωση**.
- **⚠⚠ ΤΟ ΑΠΟΤΥΠΩΜΑ ΗΤΑΝ ΣΤΟ LOG ΕΞΙ RUNS: NaN.** Κάθε `[hdrprobe]` γραμμή τελειώνει σε `nan N` και
  καμιά συνεδρία δεν το είχε διαβάσει. **ΔΥΟ** targets 1920x1080 RGBA16F (`0x1007600000`,
  `0x10085f0000`) είναι NaN στο **~58%** των ticks — ένα tick με **ΟΛΟ το frame** NaN (2.073.600 px)
  και max **-1** (αρνητική φωτεινότητα = τι επιστρέφει ένα max-tracking όταν κάθε σύγκριση με NaN
  είναι false). **Κανένα άλλο target (15 άλλα, 600+ ticks) δεν είχε ποτέ ούτε ΕΝΑ NaN.** Σε όλα τα
  runs από το 277 με ίδιο ρυθμό, άρα παλιό — καμία πρόσφατη αλλαγή δεν το προκάλεσε. Φτάνουν και στο
  **65504 = το μέγιστο του fp16**, ΑΛΛΟ νούμερο από το 65024 (ufloat11) που κυνηγούσαμε και από το
  65000 που κλαμπάρει το παιχνίδι· κρατούν και **αρνητικές** τιμές· και κορένονται σε frames όπου το
  B10G11R11 scene target είναι **καθαρό** (frame 2132: scene max L 0.9766 ενώ το `0x1007600000` δίνει
  65504 με 21.931 NaN). **Άρα ο κορεσμός δεν διαδίδεται από το scene target — έχει δική του πηγή.**
- **ΚΑΙ ΕΙΝΑΙ Ο ΟΥΡΑΝΟΣ**: **78.7%** των NaN cells σε σειρές 2-4 από 6 του grid (ουρανός + ορίζοντας),
  με κανονικές τιμές σκηνής από κάτω. Ενώνει τρία ευρήματα που δεν είχαν συνδεθεί ποτέ: run 275
  «ΚΑΝΕΝΑ draw δεν γράφει τον ουρανό», run 277 «το sky dome είναι draw που κάποτε λείπει», και τα
  screenshots αυτού του run όπου ο ουρανός είναι το **magenta clear**. **ΕΝΑ defect, τρία συμπτώματα:**
  magenta/NaN ουρανός → το bloom απλώνει το NaN σε όλο το frame (μετρημένο: bloom mips στο 1.1e4 με
  means 235-7050, ένα fp16 composite με **full-frame mean 6490**) → άσπρο· και ο ζεστός πίνακας φωτός
  είναι το ίδιο defect από τρίτη πλευρά (το probe bake ολοκληρώνει τον ίδιο ουρανό). Γι' αυτό δεν
  έκανε τίποτα ούτε το stubbing των 5 shaders (run 278) ούτε το μηδένισμα του πίνακα (run 281) — ήταν
  και τα δύο ΚΑΤΩ από αυτό. ⚠ Ο δρόμος, το γρασίδι και το HUD **σχεδιάζονται ΣΩΣΤΑ** (`zoom281_29.png`).
- **⚠ Το magenta clear είναι (210,0,172) μετά το tonemap, ΟΧΙ (255,0,255).** Ένα τεστ γραμμένο ως
  `b > 200` ανέφερε 0.0% magenta σε frame που ήταν 96% magenta — μου συνέβη με την πρώτη.
- **ΤΟ ΚΟΛΛΗΜΑ ΕΙΝΑΙ SELF-DEADLOCK, πλήρως διαγνωσμένο, ΠΡΟΫΠΑΡΧΟΝ, και διορθώθηκε στο build 282.**
  `tid 11932 GpuCommandProcessor cpu+3219ms/3s Running`, top frame `Common::SpinLock::lock` — **107%
  ενός πυρήνα, spinning**. Υπήρχαν άλλα τρία Running threads (Job#37 3406 ms/3 s,
  tm_ffb_eventHandleThread 3359, SceSndzAudioOutMain 453), αλλά **κανένα άλλο thread δεν εμφανίζεται
  σε SpinLock/MemoryTracker/BufferCache**· αυτό είναι το στοιχείο που αποδεικνύει SELF-deadlock.
  `MemoryTracker::ForEachUploadRange` παίρνει το **non-recursive** region spin lock και,
  όταν `is_written`, **επίτηδες δεν το αφήνει** μέχρι ένα δεύτερο pass ΜΕΤΑ το `on_upload()`
  (memory_tracker.h:184-199) — κι εκεί μέσα το `UploadCopies → CopySparseMemory` διαβάζει guest μνήμη,
  παίρνει page fault **INLINE στο ίδιο thread**, και ο handler ξαναμπαίνει στο tracker
  (memory_tracker.h:207) ζητώντας το ΙΔΙΟ lock. **ΔΕΝ είναι από την αλλαγή μου**, σε τέσσερις
  ανεξάρτητες βάσεις: κανένα `texture_cache` frame στο stack· το commit 62f3e5ef δεν άγγιξε κανένα
  αρχείο του stack· το `[imgzero]` έτρεξε 41 s / ~261 frames πριν· και το ίδιο stack site υπάρχει στο
  `stuckstack_20260903_223137.txt`, από πριν υπάρξει η αλλαγή. Το pattern είναι **upstream** (2d1a2982).
  Προϋπόθεση = το read protection που οπλίζουν τα readbacks μέσα στον αγώνα (`readbacks mode 0 → 2`,
  κάθε run από το 271): εκατοντάδες READ faults ανά 2 s για 31 s πριν πέσει ένα μέσα στο critical
  section. **Fix** = thread_local re-entrancy guard (`src/video_core/buffer_cache/tracker_reentry.h`):
  ο handler **αρνείται** να μπει στον rasterizer όσο `TrackerReentry::Inside()`, με `[reentry]` log.
  ⚠ Το guard είναι το ελάχιστο blocker fix, όχι κατ' ανάγκη το τελικό design. Υπάρχει ήδη
  `common/recursive_lock.h` και καθαρότερο follow-up μπορεί να είναι recursion-aware RegionManager
  lock ή **pre-touch του copy source πριν τα locks**. Κανένα από τα δύο δεν μπήκε ακόμα: μία αλλαγή
  συμπεριφοράς τη φορά, και το `[reentry]` count θα δείξει αν χρειάζεται.
- **⚠ Ξεχώρισε αυτό το κόλλημα από του run 271 με τη ΣΤΗΛΗ CPU, όχι με το stack:** run 271 =
  **0 ms**/3 s στο `MasterSemaphore::Wait` (περιμένει GPU fence), run 281 = **3219 ms**/3 s spinning.
  Ίδια συνάρτηση, αντίθετος μηχανισμός, αντίθετο fix. Δεύτερος διαχωριστής: οι γραμμές μετά την
  τελευταία `GpuCommandProcessor` γραμμή (run 271 16.568, run 281 **5.737**, χωρίς κόλλημα 9-64).
- **⚠ Το `GT_HDR_TEXPROBE=1` έβγαλε ΜΗΔΕΝ γραμμές — και αυτό ΔΕΝ σημαίνει «καθαρός πίνακας».** Το
  producer probe διαβάζει το `g_drawprobe.cs_images`, που το `GtDrawProbeNoteImage` γεμίζει **μόνο**
  όταν `active_frame != 0`, δηλαδή μόνο μέσα σε frame που όπλισε το **per-draw** probe. Κλείνοντας το
  `GT_HDR_DRAWPROBE` για να παίζει το παιχνίδι, έκλεισα και τα μάτια του texture census.
- **⚠ ΜΗΝ αναστήσεις τη θεωρία των null slots.** Το `[imgarray]` δίνει ακόμα 23 γραμμές σε δύο shaders
  (`0x3e50e1` 5/16, `0xa95f906e` 15/16, `late 0/15` — δεν γεμίζουν ποτέ), αλλά η **ACT 11 VERDICT** τη
  σκότωσε με μέτρηση: το `cs_a95f906e` κάνει dispatch 1x1x1, άρα τα slots 1-15 δεν διευθυνσιοδοτούνται
  ποτέ· 18 `GT_IMGARRAY_SYNC` προσπάθειες έδωσαν valid 1/16 → 1/16.
- **AUDIT ΜΕΤΑ ΤΟ COMMIT 24736eea — ΠΕΝΤΕ ΔΙΟΡΘΩΣΕΙΣ:** (1) όχι όλα τα άλλα threads idle·
  (2) zero census μόνο mip 0 / 75%, όχι όλο το array· (3) το SpinLock δεν είναι στον rasterizer και
  υπάρχει ήδη recursive-lock facility· (4) μόνο time-matched SAT rates είναι συγκρίσιμα και δείχνουν
  no detectable change· (5) τα `st` reset ανά 2 s, αθροίζουν 3822 σε κάθε run 277-281 και μετρούν
  write-capable bindings/`MarkGpuWritten`, **όχι texel writes ούτε αποδεδειγμένα compute writes**.
  Επιπλέον: το μεγαλύτερο saturation event είναι draw χωρίς textures· οι shaders γράφουν 231 layers
  ενώ η cache δεσμεύει 2048 (ξεχωριστό mismatch)· run 281 race 14,53 fps έναντι 8,33/8,77 στα
  279/280 αλλά με 31% λιγότερα draws, άρα όχι καθαρό 2x.
- **ΤΟ FIX ΥΠΗΡΧΕ ΗΔΗ ΜΙΣΟ-ΕΝΕΡΓΟ ΣΤΟ TREE.** Το comment στο
  `emit_spirv_image.cpp:376-381` γράφει ήδη τον μηχανισμό: `cs_da05e7f8` διαβάζει μηδενικό dynrc
  direction, `normalize(0)=Inf/NaN`, το συσσωρεύει ανά mip και δηλητηριάζει light probe/bloom.
  `GT_IMGWRITE_SCRUB` είναι ON by default για storage-image writes. `GT_RT_SCRUB` ήταν scoped μόνο
  στο foliage shader `92126594`, ενώ `GT_RT_SCRUB=1` καλύπτει κάθε fragment shader. Επίσης
  `GT_ZERO_VRAM` είναι ήδη ON by default, άρα το run 281 έκανε δεύτερο zeroing σε ήδη-zero εικόνα.
- **RUN 282 (ΕΤΟΙΜΟ, ΔΕΝ ΕΧΕΙ ΤΡΕΞΕΙ):** build 19:19 / deadlock guard πάντα on +
  **`GT_RT_SCRUB=1` για ΚΑΘΕ fragment shader**. `GT_HDR_DRAWPROBE=` ΚΕΝΟ, `_S=30`,
  `GT_IMGZERO=0`, `GT_HDR_TEXPROBE=0`: χωρίς freezes, η εικόνα είναι η μέτρηση. Αν φύγει το wash ή
  γίνει dark/dull, ο fragment-output δρόμος αποδεικνύεται και το run 283 θα στενέψει το scrub στον
  ένοχο hash. Αν δεν αλλάξει τίποτα, run 283 στρέφει το υπάρχον per-draw probe στα
  `0x1007600000,0x10085f0000` για copy/resolve/clear/compute ή already-NaN baseline. Αν κολλήσει,
  νέο `stuckstack.ps1` και διάκριση `SpinLock` με CPU>0 από `MasterSemaphore::Wait` με CPU=0.

- **RUN 282 (5 Σεπ): ΤΟ WHITEWASH ΔΙΟΡΘΩΘΗΚΕ — `GT_RT_SCRUB=1`, μία τιμή env.** NaN σε **0 από 17
  targets** (run 281: 45/76 και 47/81 ticks στα δύο RGBA16F). Κορεσμένα ticks 19/165 (11.5%) αντί
  54-83%, και τα λίγα που μένουν έχουν **28-410 hot pixels** (ήλιος) αντί 70.000-96.000. Screenshots
  ίδια μέθοδος: λευκό **44% → 2%**, WHITEWASH frames **9/16 → 0/63**, καθαρά 2 → 33. Ο χρήστης έφτασε
  στο **World Map του κύριου παιχνιδιού**, σωστά ζωγραφισμένο — το μακρύτερο ποτέ. ⚠ Είναι ΠΕΡΙΟΡΙΣΜΟΣ
  (NaN → 0, clamp ±65504 σε κάθε fragment output), όχι θεραπεία: το `cs_da05e7f8` κάνει ακόμα
  `normalize(0)`. Το **μωβ** = το magenta HDR clear εκεί που ο ουρανός δεν ζωγραφίζεται — ΑΜΕΤΑΒΛΗΤΟ
  (13.7 → 14.9%), προϋπήρχε κάτω από το άσπρο (runs 275/277), τώρα είναι το πρώτο οπτικό ελάττωμα.
  Σε σφήνες (#90, #94) = μερικώς κομμένο mesh· στα #92-#93 ο ουρανός ζωγραφίζεται.
- **ΤΟ CRASH = το fallback του guard.** `[reentry] refused a READ fault at 0x280800000` → 2 γραμμές
  μετά `Unhandled Exception ... reading 0x280800000`. Το `return false` = κανένας άλλος handler
  (`DispatchAccessViolation` signals.cpp:425) = θάνατος. Μετέτρεψα deadlock σε crash. Έπεσε ΜΙΑ φορά
  σε 514 s, στο fade World Map → race events. **Fix στο build 17:27 (run 283):** (1) **pre-touch**
  στο `SynchronizeBufferSpan` — ένα byte ανά σελίδα ΠΡΙΝ τα locks, ώστε το fault να εξυπηρετηθεί
  κανονικά έξω από το critical section (`GT_UPLOAD_PRETOUCH=0` το κλείνει, `[pretouch]` log)·
  (2) το guard **ξεκλειδώνει τη σελίδα** (`ProtectGpuTracked(page, 4K, ReadWrite)`, χωρίς tracker
  lock) και **επιστρέφει true** — μία πιθανώς stale ανάγνωση, μετρημένη, αντί crash.
- **ΤΟ LAG = shader compilation.** Το `GT_RT_SCRUB=1` αλλάζει τον κώδικα ΚΑΘΕ fragment shader
  (vk_pipeline_serialization.cpp:69 το βάζει στο cache key) → 17.894 compile lines αντί 6.982· 0.5-8.9
  fps στον αγώνα. Από τα 4 stuck dumps **ΚΑΝΕΝΑ δεν είναι SpinLock**: δύο μέσα στο `nvgpucomp64.dll`
  (NVIDIA compiler, 3100+ ms/3 s = ΔΟΥΛΕΥΕΙ, όχι κόλλημα), ένα `NtGdiDdDDIWaitForSynchronizationObject`
  (GPU wait), ένα `ProcessCompute`. WS 12.9 → 17.8 GB σε 5 λεπτά. Αν το compile είναι one-time, το
  scrub μένει· αν per-pixel μόνιμο, θέλει στένεμα στο ένοχο shader (χρειάζεται ένα run με scrub OFF +
  per-draw probe στα `0x1007600000,0x10085f0000` για να το ονομάσει).
- **RUN 283 (όπως είχε προ-δηλωθεί — ΞΕΠΕΡΑΣΜΕΝΟ, δες την επόμενη κουκκίδα):** build 17:27, `GT7_probe283.bat` = ίδιο env με το 282 + οι
  δύο αλλαγές κώδικα. Διαδρομή: Music Rally → YES στο «begin GT7» → race events (εκεί έπεσε).
  Κρίση: `[reentry]` count 0 + `[pretouch]` παρόν + όχι crash = κλειστό· fps που ανεβαίνει όσο
  τελειώνουν τα compiles = one-time κόστος.

- **RUN 283 (5 Σεπ, δύο εκκινήσεις): ΠΑΓΩΜΑ ΣΤΟ «INITIALIZING…» ΤΟΥ BOOT, ΚΑΙ ΤΙΣ ΔΥΟ ΦΟΡΕΣ.** Δεν
  έφτασε ούτε στο title. Όχι το deadlock του 281 (κανένα SpinLock), όχι το crash του 282 (0 `[reentry]`,
  το fallback δεν έτρεξε ποτέ): **livelock** — ο GPU thread 100% μέσα στον fault handler
  (`GuestFaultSignalHandler → Rasterizer::ReadMemory → BufferCache::ReadMemory` ×7 φωλιασμένα),
  **~400.000 read faults/s σε ΕΝΑ παράθυρο 512 KB, 0 bytes, 0 healed, όλα «served»**, από το ΠΡΩΤΟ
  read fault της συνεδρίας (t≈41 s στη 2η εκκίνηση, t≈107 στην 1η), τη στιγμή που το παιχνίδι
  καταχωρεί probe-shaped textures (32x128x64 layers, 256x256x6). **Αιτία: το pre-touch μου** — αγγίζει
  ΚΑΘΕ σελίδα του span, όχι μόνο τις CPU-modified που αντιγράφει η πραγματική αντιγραφή, και πέφτει
  σε σελίδα που η CPU δεν επιτρέπεται να διαβάσει (GPU-only mapping): στο boot `readbacksMode: 0`,
  άρα καμία read protection από το buffer cache (στο run 282 το πρώτο read fault ήρθε στο t=125.0 s,
  ακριβώς όταν τα readbacks γύρισαν 0→2). Ο handler «διεκδικεί» (IsMapped) χωρίς να αλλάξει τίποτα →
  retry → για πάντα. Το διαγνωστικό `memcpy` του readtrace ΜΕΣΑ στον handler ξαναπέφτει → 7 επίπεδα,
  και γι' αυτό δεν τυπώθηκε ποτέ η per-fault γραμμή. ⚠ Το log της 1ης εκκίνησης ΧΑΘΗΚΕ: ο χρήστης
  ξανάνοιξε το παιχνίδι και το δεύτερο `cp` μου έγραψε πάνω στο αρχείο — αρχειοθέτηση με PID/ώρα,
  όχι ανά run. Σώθηκαν: `stuckstack_20260905_221006.txt`, `run283b_relaunch.txt`.
- **RUN 284 (5 Σεπ 22:34-22:42): ΠΕΡΑΣΕ. Boot → Music Rally → αγώνας (Porsche 356, δρόμος/δέντρα σωστά, ουρανός
  μωβ = GT_RT_SCRUB clear, αναμενόμενο) → μενού· 480 s, ο χρήστης το έκλεισε, όχι hang, όχι crash.** `[pretouch]` 0
  (το env ίσχυσε), **`[reentry]` = 12 288**, ΟΛΑ μέσα σε 7 s ενός race load (t=305-312 s, write-flush 161,7 MB),
  ~1 fault ανά σελίδα σε εύρος 0x280800000..0x281c00000 + 0x1015…, χωρίς ορατό κόστος (τα autoshots κράτησαν
  τα 2 s). Τα δύο κενά 60 s / 40 s (t=334→395, 405→446) = shader compilation (501 CompileModule), ΟΧΙ faults.
  Log: `GT7_work/logs/shad_log_run284_2026-09-05_2242.txt` (τώρα gitignored ο φάκελος). Κλειστή η κλάση 281/282.
- **RUN 285 (6 Σεπ, build πρωί — δες handoff για ώρα): `GT7_probe285.bat` = 284 χωρίς τη γραμμή PRETOUCH (ο κώδικας
  σβήστηκε).** Κώδικας: (1) pre-touch ΔΙΑΓΡΑΜΜΕΝΟ (`SynchronizeBufferSpan`)· (2) **`[faultloop]`** breaker στον
  `GuestFaultSignalHandler` (thread_local streak ανά σελίδα: 32 faults σε 2 ms Ή 4096 όσο αργά κι αν → log VMA prot
  μέσω νέου lock-free `MemoryManager::MappedProtAt`, tracker perms/watchers, thread, Inside() → αν η VMA δίνει CPU
  πρόσβαση: `ProtectGpuTracked(RW)` και claim, αλλιώς ή δεύτερο break στην ίδια σελίδα: **return false** = crash
  dump με τη διεύθυνση, επίτηδες)· (3) βγήκε το διαγνωστικό memcpy 16 bytes από τον read-fault handler·
  (4) το `[readtrace] summary` τυπώνει `hottest window <addr>: N`, το `served` έγινε `nothing_to_do`. Κρίση 285:
  όπως το 284 + `[faultloop]` ΑΠΩΝ = καθαρό· μία γραμμή `[faultloop]` = πραγματικός βρόχος πιάστηκε, διάβασέ την·
  crash = η τελευταία `[faultloop]` λέει γιατί. Κανόνες: **ο upload path διαβάζει ΜΟΝΟ σελίδες που η CPU θα
  μπορούσε να έχει γράψει**· **«claimed» = «το retry θα πετύχει»**· **ποτέ dereference guest RAM μέσα στον fault
  handler**· **ένα «unprotect» στο address space ΔΕΝ κοιτάζει το prot της VMA** (Impl::Protect εφαρμόζει ό,τι του
  δώσεις — μια GPU-only σελίδα μένει απρόσιτη για CPU).

- **RUN 285 (6 Σεπ 11:10, build 09:01): παίζει, ο ΟΥΡΑΝΟΣ ΖΩΓΡΑΦΙΖΕΤΑΙ (autoshot 142: μπλε με σύννεφα, καθόλου
  μωβ σε εκείνο το frame), δύο αγώνες, και DEADLOCK μπαίνοντας στο World Map.** Ο χρήστης: η εικόνα «σπάει» κάθε frame
  σε άλλα σημεία, το μωβ μετακινείται. `[faultloop]` ×2 και τα δύο ακίνδυνα (WRITE σε σελίδα που ο page manager
  θεωρούσε ήδη RW → forced RW· READ στο 0x0 από guest thread → refused → το πήρε ο ΕΠΟΜΕΝΟΣ handler, όχι crash:
  `return false` σε guest thread ≠ crash). **55 s «INITIALIZING» = 14.501 stale .key του pipeline cache** που
  διαβάζονται και πετιούνται σε κάθε launch (cache dir 36.356 αρχεία / 1,18 GB). **Το deadlock, μετρημένο:** στο
  remap ενός compute queue (slot που ξαναδίνεται από το SlotVector) το `asc_next_offs_dw[slot]` κρατούσε το ΠΑΛΙΟ
  offset (92 / 252 dw)· το πρώτο DingDong του νέου queue (offset 4) διαβάστηκε ως WRAP → υποβλήθηκε [παλιό, τέλος)
  του ΝΕΟΥ ring = άγραφη μνήμη (0xaaaaaaaf / 0xf4f4f4f4 στα «ACB stitch» softclamps) → σκουπίδια ως PM4 → ο guest
  σπινάρει στο read pointer, ο GPU thread κοιμάται στο CondvarWait. Το ΙΔΙΟ έγινε στο run 284 (γραμμές 176150-176432)
  και επέζησε από τύχη. Fix: MapComputeQueue μηδενίζει offset + tmp_dwords, Unmap μηδενίζει + ΛΟΓΚΑΡΕΙ (ήταν σιωπηλό).
  Επίσης: `ForEachBlobPrune` σβήνει τα stale keys στο preload· το stitch log τυπώνει vqueue/μέγεθος/read ptr.
- **RUN 286 (6 Σεπ 11:41-11:45, build 11:32, PID 19820): ΟΛΑ τα fixes κράτησαν — prune 14.549 stale keys, γρήγορο
  boot, 0 «ACB stitch», ΤΟ WORLD MAP ΖΩΓΡΑΦΙΣΤΗΚΕ (autoshot 92, t=201 s, καθαρό) — και CRASH στο t=258 s στο μενού
  Options:** guest read 0x10e342f30 από eboot.bin+0x344789e, thread «PCL Event», UNHANDLED (κανένας handler δεν το
  πήρε → σελίδα unmapped ή προστατευμένη από κάτι που ΔΕΝ είναι ο page manager). Dump: `logs/guest_crash_run286_*.dmp`.
  `[faultloop]` ×4: 3 READ 0x0 refused, 1 WRITE forced RW στο **0x10a2bcf440 — ΙΔΙΑ διεύθυνση με το 285** (ντετερμινιστικό).
  **ΤΟ ΜΩΒ ΗΤΑΝ ΔΙΚΟ ΜΑΣ:** `GT_RT_FORCECLEAR=0x1005000000` (πείραμα του run 263, σε ΚΑΘΕ probe από τότε) σβήνει το
  κύριο 1080p B10G11R11 HDR target σε ΜΑΤΖΕΝΤΑ ανά frame — `[forceclear]` γραμμές, `[clears] ... f == game clears`,
  autoshot 70 = ολόκληρος ουρανός μωβ. Ό,τι δεν ξαναζωγραφίζει το παιχνίδι σε ένα frame μένει μωβ. **FPS μετρημένα
  ([clears] game clears ανά 2 s):** μενού ~60 fps / ~20 draws ανά frame· αγώνας 4-15 fps / 2.000-3.500 draws ανά frame,
  GPU thread 65-90 % busy (~45 µs ανά draw: bindbuf/bindtex/pipeline/state) + ~26.000 guest write faults ανά 2 s.
  Ο αγώνας είναι CPU-bound στον command processor, όχι GPU. **Trashing ΚΑΙ σε 2D:** autoshot 111 (Options) πράσινη
  οριζόντια μπάντα + μετατοπισμένη λωρίδα — όχι δικό μας χρώμα, ανοιχτό.
- **RUN 287 (6 Σεπ 11:55, build 11:32, ΠΡΩΤΟ ΖΕΣΤΟ launch — `Preloaded 2745 pipelines`, 10 compiles): DEVICE LOST
  στο t=58 s στο intro (GPU hang, 8 invocations ενός shader παρκαρισμένα, τελευταίο cs_0xef4a0dc6 = cached module).**
  Ο χρήστης: «τα γράμματα πετάνε/χάνονται κάθε φορά που το ΙΔΙΟ build τρέχει δεύτερη φορά» → η μεταβλητή είναι
  το pipeline cache (κρύο = παίζει, ζεστό = σπάει). Το store είναι ακέραιο (24.560 αρχεία, 0 κολοβά, όλα τα SPIR-V
  magic σωστά). `Info::Serialize` γράφει μόνο `InfoPersistent` + flatbuf + dynrc + srt· τα υπόλοιπα πεδία γυρίζουν
  ΜΗΔΕΝ σε ζεστό run, αλλά κανένα δεν διαβάζεται στο draw time εκτός από `has_bindless_sharp` (συνεπές). ΔΕΝ βρέθηκε
  αιτία με ανάγνωση κώδικα → φτιάχτηκε ΟΡΓΑΝΟ.
- **RUN 288 (ΕΤΟΙΜΟ, build 6 Σεπ 12:11): `GT7_probe288.bat` = 287 + `GT_CACHE_VERIFY=2`.** C++ μέσα στον emulator
  (`PipelineCache::VerifyPreloadedModule`): κάθε module που ήρθε από τον δίσκο ξαναμεταγλωττίζεται από τον ζωντανό
  guest code στην πρώτη χρήση και συγκρίνεται (SPIR-V dword-dword, `InfoPersistent` bytes, spec ==)· `[cacheverify]`
  γραμμή σε κάθε DIFF + μία ανά 256 καθαρούς ελέγχους· mode 2 αντικαθιστά το module και αποσύρει (ΔΕΝ καταστρέφει)
  τα WarmUp pipelines στο πρώτο SPIR-V DIFF. Θέλει ΔΥΟ launches (1ο κρύο/refill, 2ο ζεστό = το τεστ).
  ⚠ Ο χρήστης (6 Σεπ): ΟΛΑ για το shadPS4 σε C++ — δες [[feedback-shadps4-cpp-only]].

- **RUN 288 (6 Σεπ 12:14-12:44, build 12:11):** κρύο = Preloaded 0 (νέο build = νέα γενιά cache), ίδιο guest crash με το 286 (eboot.bin+0x344789e, PCL Event, rbx+0x1560) στην αλλαγή πίστας· ζεστό = Preloaded 3611, γράμματα πετάνε, DEVICE LOST t=484 s, **[cacheverify] 2056/2056 DIFF: spv SAME, spec SAME, Info DIFF στα sharp_idx των buffers** (bytes 0/32/64…). Build 12:46 (`GT7_probe289.bat`, 2 launches): field-by-field dump + HEAL mode 2 (φρέσκο Info, retire WarmUp pipelines), `[copylayers]` για τις 1743 κουρεμένες αντιγραφές layers (1→8, 6→8 = παλιά frames μακριά), guest VMA στο crash report. Λογκ: `shad_log_run288_*_guestcrash`, `shad_log_run288warm_*_devicelost`, `device_fault_run288warm_*`.
**Why:** μια νέα συνεδρία δεν θα έβρισκε ούτε το repo ούτε τη σειρά των handoffs, και τα ευρήματα του
run 250 (ΠΟΥ χάνεται το έδαφος) είναι μετρημένα με όργανα που πήραν ώρες να στηθούν.
- **RUN 289 (6 Σεπ, build 12:46, δύο launches):** κρύο = ίδια εικόνα (θολό μακρινό, μαύρο αμάξι, σπασμένα thumbnails) + 3ο ίδιο guest crash σε FREE VMA· ζεστό = DEVICE LOST x2 στο Settings ("chessboard"): **το HEAL έγραψε το Info του perm 1 (baked 1 mip) πάνω στο program.info (baked 9)** → layout 1 slot κάτω από module TypeArray(9) → ReadInvalid 0x300100000 (cs 0xda05e7f8 cubemap mip-gen). Τα «2056/2056 Info DIFF» του 288 ήταν ΣΚΟΥΠΙΔΙΑ: bytes πέρα από το size() των static_vector. Το cache Info είναι ΙΔΙΟ με fresh compile → το cache ΔΕΝ είναι η αιτία των γραμμάτων που πετάνε. Fix (build 13:20, probe 290): `PinBakedMipCounts` (perm pinned στο layout του perm 0, ΚΑΙ σε κρύο run), verifier ανά πεδίο, HEAL μόνο perm 0, ποτέ μείωση baked. Λογκ: `[mipbake] pinned/raised`, περιοδικό `N checked, 0 differ`.
- **RUN 290 (6 Σεπ 13:20-13:29, κρύο, build 13:20):** `[mipbake] pinned` ΕΠΙΑΣΕ: cs 0x2a0cfcd2 perms με 8/9 mips σε layout 7 θέσεων → τα δύο ΜΙΚΡΟΤΕΡΑ mips λάθος = μακρινά textures τρας. Fix: `kDynamicMipSlots=16` (σταθερές 16 θέσεις για κάθε dynamic-mip storage image, `LiveMipCount` μόνο για το clamp, ShaderMetaVersion 6). `[faultloop] owner`: watcher 1 χωρίς buffer/image = ΟΡΦΑΝΟΣ watcher του texture cache (όχι stale data). `[metaread]`: fs 0xa3fd67d5 διαβάζει CMask addr ως 480x270 float. Crash #4 ίδιο (rbx σε Free gap, το ring 128 δεν είχε τίποτα). Οθόνη Single Race με ΠΡΑΣΙΝΑ πάνελ (65,215,65 σκιασμένο = placeholder του παιχνιδιού) + 50-60 FCE draws/s πεταμένα χωρίς clear. Menu 6 fps = 43 us/draw x 2700 draws (CPU-bound δικός μας draw path, όχι το τρας). Probe 291 ΕΤΟΙΜΟ (build 6 Σεπ 14:09, commit μετά το c8b0714a): 16 slots, copylayers who/slice, ring 1024 + VMA dump, metaread owner/age, faultloop tracked scan, [fce] per RT.
**How to apply:** νέα συνεδρία = διάβασε ΠΡΩΤΑ το GT7_work/HANDOFF_RENDERING_ACT3.md (αυτοτελές, σύντομο· το ACT2 μόνο για ιστορία)· παλιότερη οδηγία: τέλος του ACT2 (**NEW CHAT - START HERE** + **RUN 286 VERDICT**: World Map ΟΚ, μωβ = δικό μας GT_RT_FORCECLEAR, αγώνας CPU-bound 4-15 fps, crash στο Options· **RUN 287** ζεστό cache = DEVICE LOST, «γράμματα πετάνε στο 2ο launch» = το cache· **RUN 288** ζεστό: 2056/2056 Info DIFF (sharp_idx), spv ίδιο· **RUN 289** = `GT7_probe289.bat` (build 12:46, HEAL + field dump), 2 launches· επόμενο: ό,τι πει το HEAL/field dump, μετά 2D trashing, crash/faultloop, performance)· μην
ξαναστήσεις το περιβάλλον· έλεγξε ΠΟΙΟ binary έγραψε το ζωντανό log (Revision γραμμή 2 — 62048c89 = το build 17:27) πριν το διαβάσεις
ως δικό μας run· **αρχειοθέτησε το log με PID/ώρα** (ο χρήστης ξανανοίγει γρήγορα)· **διάβασε ΚΑΘΕ στήλη που τυπώνει ένα όργανο** (το `nan N` ήταν εκεί έξι runs)· **ψάξε για υπάρχοντα διακόπτη πριν γράψεις νέο** (GT_ZERO_VRAM, GT_RT_SCRUB, GT_UPLOAD_PRETOUCH υπήρχαν)· για RenderDoc ερωτήματα γράψε script στο πρότυπο των analyze18-21 και τρέξε το headless.
Σχετικά: [[greek-username-breaks-build-toolchains]], [[gt7-blender-lane]], [[check-mtime-before-writing]].
- RUN 291 (6 Σεπ 14:18, κρύο, crash car select): [mipbake] σιωπηλό (16 slots ΟΚ), τρας μακριά ΑΜΕΤΑΒΛΗΤΟ· [fce] μόνο το main RT (run 254 no-op, κλειστό θέμα)· ΒΡΕΘΗΚΕ: «user-data push overflow (slot 16)» σε 6 shaders = τα UD regs του τελευταίου stage ΠΕΤΙΟΝΤΑΝ ανά draw → γεωμετρία με σκουπίδια σταθερές (κώνοι, gantry/kerbs επαναλαμβανόμενα) → fix NUM_PUSH_UD_REGS=32 (PushData 184 B), commit f7ec625e, build 14:27· crash #5 ίδιο rbx-pattern (0x10f8..-0x10fd.. στο ίδιο Free gap). Probe 292 ΕΤΟΙΜΟ (2 launches).
- RUN 292 (κρύο 15:41-15:50): 0 push overflows· 1-3 fps + «κόλλημα» = NVIDIA driver μεταγλωττίζει ΟΛΑ τα pipelines από το μηδέν (GLCache 920 MB ξαναγράφτηκε, stuckstack μέσα σε nvgpucomp64 υπό vkCreateGraphicsPipelines, pipe 20-65 s/window) γιατί άλλαξε το SPIR-V κάθε shader — ΜΙΑ ΦΟΡΑ, όχι regression· autoshot αγώνα ΚΑΘΑΡΟΤΕΡΟ από 291 (χωρίς επαναλήψεις gantry/kerbs)· crash #6 ίδιο rip. ΕΠΟΜΕΝΟ: ζεστό launch probe 292 ΧΩΡΙΣ rebuild. ⚠ Κάθε αλλαγή push/binding layout = κρύος driver cache = ένα αργό run: προειδοποίησε τον χρήστη ΠΡΙΝ.
- RUN 292 ζεστό (15:57): 2766 preloaded, εικόνα ΙΔΙΑ (push fix ≠ μακρινό τρας), HANG στην οθόνη Single Race (η οθόνη των crash 289-291, πράσινα πάνελ): GPU thread ΑΔΕΙΟ, Job#0 100%, τελευταία DingDong vqid 4 (140,144) — ΟΧΙ το remap bug του 285. Υπόθεση: compute δουλειά της οθόνης δεν ολοκληρώνεται όπως περιμένει το παιχνίδι (skip dispatch / χαμένο fence / loopguard 16384). Build 16:13 GT_ACB_WATCH (ring labels + dispatch counts, dump όταν GPU idle >8 s). Probe 293 ΕΤΟΙΜΟ (1 launch, μείνε στην οθόνη Single Race).
- RUN 293 (6 Σεπ 16:31-16:35, κρύο, build 16:13): ΠΕΘΑΝΕ στην οθόνη Single Race ΧΩΡΙΣ guest crash, χωρίς Windows event· log κόβεται ΜΕΣΑ σε γραμμή ενώ γραφόταν ένα ≥116 MB merge του heap-buffer (0x102e400000..), 14 s μετά από [buffergc] 2043 MB / [graveyard]. ΑΙΤΙΑ ΤΗΣ ΣΙΩΠΗΣ: spdlog async_sink — το Flush() σκούπιζε το αρχείο, ΟΧΙ την ουρά· quick_exit/terminate έχαναν τις τελευταίες γραμμές. Build 294: Flush = flush+wait_all(3 s), Terminate flush, breakpoint flush.
- ΒΡΕΘΗΚΕ (objdump στο SELF, συνταγή στο handoff §ACT3 s.3): τα 5 crashes eboot+0x344789e = `mov rbx,[rdi]; mov rax,[rbx+0x1560]` με rdi=0x1020473ff8 ΣΕ ΚΑΘΕ RUN (slot στο heap του παιχνιδιού, Direct prot 0x33, μέσα στο cached buffer 0x101e310000) που κρατά pointer αντικειμένου με σκουπίδια· το HANG του 292 (Job#0 eboot+0x17fd712, ΟΧΙ 0x1fd712 — λάθος αφαίρεση) = `mov esi,[rax]; cmp rdx,rsi; jne` poll σε u32 label, και αμέσως μετά `rbx=[r15+0x100]; lea rdi,[rbx+8]; esi=1; edx=3; call libc` = η κλήση που κάνει crash. HANG και CRASH = ΙΔΙΟ μονοπάτι (label δεν έρχεται / έρχεται και το αντικείμενο έχει σκουπίδια).
- 294 ΕΤΟΙΜΟ (build 6 Σεπ 16:54, 1 launch): GT_WATCH_VA + 0x1020473ff8 (8 B) → [bufdl]/[bufsync]/[bufcopy] τυπώνουν την τιμή ΣΤΟ slot (now -> new)· [acbwatch] κάνει dump rip+registers+[reg] του spinning Job#· guest crash τυπώνει 64 B σε rdi/rbx/r15/rsp. ΜΕΤΑ ΤΟ 294 ο χρήστης θέλει God of War.
- RUN 294 (6 Σεπ 17:09, κρύο, build 16:54): crash #7 ΙΔΙΟ (rip eboot+0x344789e, rdi 0x1020473ff8, r15 0x1020470000 σε ΟΛΑ τα 7 runs· η βάση του eboot αλλάζει ανά run, μόνο το +offset συγκρίνεται). ΒΡΕΘΗΚΑΝ ΤΑ BYTES: το slot κρατά 64-bit pointer ως δύο dwords· low dword 0x0fd13560 ΣΩΣΤΟ σε 219/219 δείγματα του watch, high dword κυκλώνει 0x0/0x1/0xe4 (rbx=0x1_0fd13560 = free gap → fault)· ο διπλανός {0x20473ff8,0x10}=0x1020473ff8 άθικτος. Οι λάθος τιμές εμφανίζονται στο guest RAM ([bufsync] cur, γραμμές 144177/148109) ΠΡΙΝ από κάθε [bufdl] (πρώτο 150720) και κάθε [bufdl] == το τελευταίο [bufsync] (23/23) → ο GPU shader ΔΕΝ γράφει το slot· ο γράφτης είναι CPU-side (guest code Ή το PM4 WriteData/ReleaseMem του command processor — ίδια εικόνα σε όλα τα όργανα)· το readback μόνο ξαναπαίζει στάσιμο αντίγραφο. Καλούσα αλυσίδα = timer/deadline dispatcher thread eboot+0x3b58fb0→0x3b59180 (item = r15), ΟΧΙ το Job#0 label poll. Μνήμη ΔΕΝ φταίει (buffergc 2119 MB, graveyard 20, vram peak 5.86 GB, καμία αποτυχία). ⚠ Λάθος μου στο 293: «call libc» = eboot PLT stub 0x420ca00 (jmp [0x11ad5798]), όχι το crash function.
- ΕΠΟΜΕΝΟ ΟΡΓΑΝΟ GT7 (build 295, ΔΕΝ χτίστηκε — στροφή): hardware data watchpoint στα 8 B του 0x1020473ff8 (DR0/DR7 σε κάθε thread με sweeper Toolhelp+SetThreadContext CONTEXT_DEBUG_REGISTERS, EXCEPTION_SINGLE_STEP στο signals.cpp VEH, GT_HWWATCH=addr/len,…, rip → eboot+off ή shadps4.exe!Symbol με dbghelp SymFromAddr, budget 4096) → ονομάζει τον γράφτη κάθε 0xe4/0x01 σε ΕΝΑ run. Συν: rdi/rbx/r15 σελίδες στο minidump, [bufdl] cur μέσω BackingBase mirror. Σχέδιο πλήρες στο ACT3 §6.
- ΣΤΡΟΦΗ (οδηγία χρήστη «after this run we try to fix god of war», μετά «i want god of war with our fixes not generic exe»): God of War CUSA07408 (base 01.00 43 GB + CUSA07408-patch 01.35 14 GB· ο emulator κάνει overlay το -patch στο /app0 μόνος του, fs.cpp probe_overlay, και τρέχει το patched eboot → ΠΑΝΤΑ η base διαδρομή) → `GT7_work/GOW_probe001.bat` = `run_game.ps1 CUSA07408` (ο runner ΥΠΗΡΧΕ από 21 Αυγ — μην ξαναγραφτεί) ΜΕ ΤΟ ΔΙΚΟ ΜΑΣ Build\X64-CL~1\shadps4.exe, ΧΩΡΙΣ GT_* gates (είναι GT7 πειράματα, τα fixes είναι compiled in)· αν χρειαστεί ένα gate, GOW_probe002 με ΕΝΑ. Ghost of Tsushima CUSA13323 επίσης εγκατεστημένο. Stock 0.17.0 στο Desktop μόνο ως A/B αν ζητηθεί.
- GOW run 001 (6 Σεπ 17:46): boot ΟΚ, πέθανε στον ΠΡΩΤΟ compute shader (cs 0x38c7b95b) με `V_CMP_U64: Assertion Failed` (ο translator ξερε μόνο το idiom SGPR-mask vs 0/-1). FIX 69ac5fa9 (exe 19:18): γενικό 64-bit compare μέσω GetSrc64 + IR *64 opcodes, 32 opcodes V_CMP[X]_*_{I64,U64} (ήταν 3), GT7 ανέπαφο. ΕΠΟΜΕΝΟ: GOW_probe002.bat (1 launch), περίμενε τον επόμενο άγνωστο opcode· grep: Assertion, Unhandled, guest crash, UNREACHABLE|Unsupported.
- GOW run 002 (19:21): V_CMP_U64 πέρασε, 41 cs + 5 gfx pipelines, ο ΙΔΙΟΣ shader σκόνταψε σε `Unknown opcode DS_ORDERED_COUNT` → BuildASL assert. FIX: GDS atomic add σε dedicated counter (GDS 0xFF00 + idx*4, idx=offset0[3:2]), value από το address VGPR· η σειρά wave-launch ΔΕΝ εξομοιώνεται. GOW_probe003.bat ΕΤΟΙΜΟ.
- GOW run 003 (19:25-19:29): ΤΟ PC ΕΚΑΝΕ REBOOT — Windows bugcheck 0x10E VIDEO_MEMORY_MANAGEMENT_INTERNAL (arg1 0x37), δηλ. ο NVIDIA driver (VidMm) πέθανε στον kernel, ΟΧΙ guest crash/assert. Πριν: DS_ORDERED_COUNT πέρασε, 90 cs + 259 gfx pipelines, πραγματικά draws, VRAM 1.0→1.7 GB (όχι πίεση). Τα τελευταία 90 KB του log = NUL (page cache, δεν έφτασαν στον δίσκο). FIX: LogFileSink::Sync (fflush+FlushFileBuffers) από jthread LogSync κάθε 1 s + στο Flush()· [vram] κάθε 120 submits· run_game.ps1 = παράθυρο 1280x720 (το «fullscreen» ήταν παράθυρο 1920x1080 σε οθόνη 1920x1080; -Fullscreen το γυρίζει). Minidump C:\Windows\Minidump\090626-9546-01.dmp θέλει admin· δεν υπάρχει cdb/kd. GOW_probe004.bat ΕΤΟΙΜΟ (1 launch).
- GOW run 004 (19:39-19:44, build a6b85ea6 με fsync log): DEVICE LOST (nvlddmkm 153 = ίδια οικογένεια με το reboot του 003). Log πλήρες. VK_EXT_device_fault: 0 memory faults, 9 IPs σε 0x80 B = HANG ενός compute shader· checkpoints: seq 11766 = DispatchDirect cs 0xef28ab59 (54x1x1, 64 threads). ΜΗΧΑΝΙΣΜΟΣ: 38 GoW shaders «ReadConst has non-immediate offset» → χωρίς DMA/GT_DYNRC_WINDOW το EmitReadConst διαβάζει flatbuf[0] = σκουπίδια (loop bound από σκουπίδια = dispatch που δεν τελειώνει)· επίσης 68 «Patched SRT walker» (bad pointer 0x20027204, cs 0x5fe5af59). RUN 005 = run_game.ps1 -Dma -DumpShaders (config, ΟΧΙ gate): read_const_dynamic μέσω BDA· GT7 ACT2 run 74 έπαιξε με DMA (αργό). Fallbacks: GT_DYNRC_WINDOW=1 ή GT_STUB_SHADERS=ef28ab59. GOW_probe005.bat ΕΤΟΙΜΟ (1 launch, θα είναι πιο αργό).
- GOW run 005 (19:45-19:51, -Dma -DumpShaders): DEVICE LOST στο ΙΔΙΟ dispatch (cs 0xef28ab59) — ΟΧΙ verdict για DMA: η persistent pipeline cache (cache\CUSA07408 από το run 004, χωρίς DMA) φόρτωσε όλα τα modules (2 CompileModule σε όλο το run, κανένα dump). Το BuildGeneration() ΔΕΝ περιείχε το DMA ούτε τα GT_DYNRC/BINDLESS/LOOP/STUB gates («run-117 law» μόνο στο run_gt7.ps1). FIX (build 19:57): BuildGeneration hashάρει dma=0/1 + name+value 16 gates → flip = prune της cache. GOW_probe006.bat ΕΤΟΙΜΟ (1 launch, θα ξαναμεταγλωττίσει τα πάντα με DMA, αργό). ⚠ ΜΑΘΗΜΑ: μετά από flip ρύθμισης που αλλάζει SPIR-V, δες πόσα «Compiling» έχει το log ΠΡΙΝ βγάλεις συμπέρασμα.
- GOW run 006 (19:59-20:01, DMA πραγματικά εφαρμοσμένο, 543 compiles): ΠΕΡΑΣΕ το hang, έφτασε στην πρώτη οθόνη (ρύθμιση έκθεσης) με ~7 fps, ο χρήστης έκλεισε στο 1:38. Dump του cs 0xef28ab59: inner loop `i < read_const_dynamic(table, idx)` — χωρίς DMA το όριο ήταν flatbuf[0]. ΟΔΗΓΙΑ ΧΡΗΣΤΗ: «fix για ΚΑΘΕ παιχνίδι, ο emulator ως κονσόλα, όχι per-game» → ΓΕΝΙΚΟΣ FIX (build 20:08, commit code + docs): ReadConst με flags 0 (runtime offset, χωρίς window) εκπέμπει ΠΑΝΤΑ read_const_dynamic, και `Info::uses_dynamic_reads` βάζει τον shader στο selective-DMA club (μόνο αυτοί οι shaders κρατούν BDA pagetable/fault buffer + per-dispatch sync)· ShaderBinaryVersion 3→4. GT7 codegen ανέπαφο (0 unassigned dynamic reads στο run 294, όλα windowed) αλλά η cache ξαναγεμίζει μία φορά. GOW_probe007.bat ΕΤΟΙΜΟ: DMA setting ΞΑΝΑ OFF (-Dma:$false), μετράει fps. Επόμενος μοχλός perf: GT_DMA_DIRTY_LOG default OFF (κανένας launcher δεν το θέτει).
- **Run 007 (6 Σεπ, 1η απόπειρα):** ο emulator δεν ξεκίνησε. `GOW_probe007.bat` έδινε `-Dma:$false` σε `powershell -File`, που περνά τα args ως strings → binding error πριν το exe. Fix: `run_game.ps1 -NoDma` (commit 1ede2bd5). Κανόνας: switch-parameters από .bat ΜΟΝΟ ως bare switches, ποτέ `-X:$false`.
- **Run 007 (20:18):** ο γενικός fix (flags-0 ReadConst → read_const_dynamic + selective DMA) ΠΕΡΑΣΕ με DMA off: 48 dynamic shaders, cs 0xef28ab59 retired, no device fault, clean exit 2:27. fps αμέτρητα - ο χρήστης χωρίς pad (Moonlight από κινητό). Default keyboard map: WASD/IJKL sticks, N=cross B=circle V=square C=triangle, Enter=options.
- **Run 008 (6 Σεπ, RenderDoc):** το «σπασμένο» φόντο του μενού = indirect draws με indexCount 8,49M (σκουπίδια). Αλυσίδα: cs 0x5fe5af59 (1ο dispatch του frame) διάβαζε 26 μηδενικές σταθερές γιατί ο CPU SRT walker πήρε τα user SGPR 7:8 (dword3 ενός V#, 0x20027204) για pointer, έσκασε, πατσαρίστηκε σε xor ΚΑΙ ο πατσαρισμένος κώδικας ΣΩΘΗΚΕ στην pipeline cache (ο walker τρέχει πρώτη φορά ΜΕΣΑ στο compile, πριν το RegisterShaderMeta). ΓΕΝΙΚΟΣ FIX (build gow009): αυστηρή επίλυση βάσης (γειτονικά dword pairs) αλλιώς GPU-time read· walker bytes σειριοποιούνται όπως παράχθηκαν· ShaderBinaryVersion 5 / MetaVersion 7.
- **Μέθοδος RenderDoc headless από εδώ:** `qrenderdoc --python script.py` με RDC_CAP/RDC_OUT env (8.3 paths)· το qrenderdoc ΔΕΝ κλείνει μόνο του, wait-loop στο report file + taskkill· scripts `GT7_work/rdc/gow_*.py`· F12 στέλνεται με SendKeys αφού SetForegroundWindow. Τα screenshots του παραθύρου με CopyFromScreen (scratchpad shot.ps1).
- **Run 010 (6 Σεπ):** ο GDS fix έπιασε (indirect counts 42..822, G-buffer/normals σωστά) αλλά η εικόνα ακόμα «έκρηξη»: το half-res FX pass (~230 particle indirect draws) έχει αρνητικό clip w. ΑΙΤΙΑ (GCN decode +0x2f88): `m0 = bfe(TG_SIZE_SGPR,6,11) | (addr<<16)` — η διεύθυνση του μετρητή είναι το ΠΑΝΩ μισό του M0 (bytes 0/4/8), το κάτω = ORDERED_APPEND_TERM από το TG_SIZE SGPR που ΔΕΝ δίναμε (Undef). Και η σειρά των waves μετράει: άλλα waves add, ένα swap-σε-0 (το return = indexCount). ΓΕΝΙΚΟΣ FIX gow011: TG_SIZE SGPR (RSRC2 bit 10), counter = M0>>16, ένα atomic ανά wave (lowest active lane), ticket dword στο GDS+0x10000 με spin σε launch order, κάθε wave σηματοδοτεί στο S_ENDPGM (pre-scan `uses_ordered_count`), rasterizer μηδενίζει το ticket πριν το dispatch. ShaderBinaryVersion 7 / Meta 8. Επίσης: lit image 1,69% NaN (R,B) στον Kratos — ξεχωριστό, ακυνήγητο· το «σκακιέρα» στα PNG = alpha rendering του RenderDoc, όχι data.
- **Παγίδες backend:** το Sirit ΔΕΝ έχει OpGroupNonUniformElect (ballot+FindLSB==lane id)· κάθε IR opcode θέλει Emit* stub έστω UNREACHABLE (το emit_spirv.cpp τα κάνει instantiate όλα)· το `subgroup_local_invocation_id` ορίζεται μόνο με `info.uses_lane_id` (collection pass τρέχει ΜΕΤΑ το resource tracking)· subgroup της κάρτας = 32, «wave» = subgroup.
- **Run 011 (7 Σεπ):** HOST crash μέσα στον NVIDIA driver (nvgpucomp64) στο compile του pipeline του cs 0x38c7b95b (πρώτο shader με DS_ORDERED_COUNT). Η cache του emulator (`%APPDATA%/shadPS4/cache/<CUSA>/<hash>_<perm>.spv`, ΩΜΟ SPIR-V) + `spirv-val` (C:\VulkanSDK.4.357.0\Bin) το έλυσαν offline: το Sirit `OpAtomicStore` βγαίνει με result id (το `OpId{}` ΠΑΝΤΑ κάνει allocate) και `Reserve(5)` για 6 λέξεις → η τιμή χάνεται (0). FIX στο externals/sirit (raw `spv::Op::OpAtomicStore`). Με σωστό store όλο το module validate-άρει → η δομή loop/selection είναι ΟΚ. Διαγραφή του χαλασμένου .spv από την cache, χωρίς version bump. ΚΑΝΟΝΑΣ: driver crash στον compiler ⇒ spirv-val στο cached .spv ΠΡΙΝ αγγίξεις emitter. Minidump modules/stack: `mdmods.py` στο scratchpad.
- **Run 012 (7 Σεπ):** SPIR-V ΟΚ, μετά DEVICE LOST: το GPU κόλλησε στο ticket spin (journal: 2 dispatches του 0x38c7b95b σε εξέλιξη). ΑΙΤΙΑ: και οι δύο DS_ORDERED_COUNT του παιχνιδιού έχουν offset1[1:0]=release+done ⇒ το hardware ελευθερώνει τη θέση ΣΤΗΝ εντολή· εμείς στο S_ENDPGM με σκέτο store launch+1 → waves τελειώνουν άτακτα → το ticket πηδά/γυρνά πίσω → deadlock (ακόμα και με 4 waves). ΓΕΝΙΚΟΣ FIX gow013: release στην εντολή (flags word swap|release), Private bool `ordered_released` (ballot-any) για διπλό release, S_ENDPGM ελευθερώνει ΜΟΝΟ wave που δεν το έκανε ΚΑΙ αφού περιμένει τη σειρά του· ShaderBinaryVersion 8 (όλα ξαναμεταγλωττίζονται). Υπόλοιπο ρίσκο: forward progress σε dispatch μεγαλύτερο από τη residency. Εργαλείο: `GT7_work/tools/dsord.py` (offset0/offset1 των DS_ORDERED_COUNT από .bin).
- **Run 013 (7 Σεπ):** πάλι host crash στον NVIDIA compiler, δικά μου δομικά λάθη SPIR-V στο νέο release path: OpLogicalNot ΑΝΑΜΕΣΑ σε OpSelectionMerge και branch (η συνθήκη υπολογίζεται ΠΡΙΝ το merge), και OpStore πριν το OpPhi του merge block (phi πρώτο). spirv-val στο cached .spv τα βρήκε και τα δύο, το χειροδιορθωμένο module validate-άρει. ΚΑΝΟΝΑΣ: κάθε emitter που ανοίγει blocks → spirv-val στο cached .spv ΠΡΙΝ τον επόμενο run. Build gow014, GOW_probe014.bat.
- **Run 014 (7 Σεπ):** ΠΕΡΑΣΕ (χωρίς crash/device lost), ticket 2/6/402 = το ordering ολοκληρώθηκε· lit image ΣΩΣΤΟ, half-res FX ακόμα λωρίδες. Μόνο το ΠΡΩΤΟ quad κάθε particle draw έχει δεδομένα, τα υπόλοιπα (0,0,0.1,0), ενώ ο culler ΜΕΤΡΗΣΕ ορατά (draw args 72/210/222/444). ⇒ η επιστρεφόμενη τιμή του ordered count (slot base) βγαίνει 0 για τα waves (υπόθεση). Build gow015: `GT_ORDERED_TRACE=1` γράφει {value<<16|result} ανά wave στο GDS 0x10004+4k (RenderDoc το δείχνει) + OpControlBarrier(Subgroup) πριν το BroadcastFirst. Νέα scripts: rdc/gow_bind.py (bindings+dumps), rdc/gow_scan.py (non-zero runs). GCN: s7=TG_SIZE, add value = visible*3*s8, swap flag s79=s80&2 ανά dispatch.
- **Run 015 (7 Σεπ):** ΠΕΡΑΣΕ· το GT_ORDERED_TRACE (rdc/gow_trace.py) απέδειξε ότι το ordered count είναι ΣΩΣΤΟ (βάσεις 0,186,372 → swap 372, μετά reset). Το bug είναι ΓΕΝΙΚΟ του recompiler: thread-mask SGPR pairs (v_cmp sdst) ζουν ως per-lane BIT (`SetThreadBitScalarReg`), αλλά `s_bcnt1_i32_b32 vcc_hi, s12` τα διαβάζει ως DWORD (άλλη SSA μεταβλητή → stale), και `v_mbcnt_lo/hi` με SGPR/exec mask γύριζε prefix 0 → όλα τα ορατά σωματίδια στο slot 0 (μόνο quad 0 με δεδομένα). FIX gow016: `LaneMask(bit)=Ballot(bit&&exec)`, `SetThreadMask` γράφει bit + low/high dword (και vcc_lo/hi), exec_lo/hi ως dwords, `V_MBCNT` ακριβές (popcount(mask & lanes_below)+src1). Cache 8→9 = ΠΛΗΡΗΣ recompile (προειδοποίηση στον χρήστη).
- **Run 016 πρώτη απόπειρα (7 Σεπ):** crash ΔΙΚΟΥ ΜΑΣ compiler, `FindSharpSources` σε fs 0xfed5cec9: το shader κάνει spill sharps σε lanes του v17 (v_writelane) και τα επαναφέρει με `v_readlane s12.., v17, lane`· το `V_READLANE_B32` θεωρεί κάθε readlane σε ΖΥΓΟ SGPR πιθανή επαναφορά thread-mask και καλούσε `SetDst1` → με το νέο SetThreadMask το dword του T# έγινε ballot σκουπιδιών. FIX gow016b: readlane επαναφέρει ΜΟΝΟ το bit· `S_CSELECT_B64` pair/pair επιλέγει και τα δύο dwords χωρίς ballot· `S_MOV_B64` από σταθερά γράφει τη σταθερά. Cache 9→10. ΚΑΝΟΝΑΣ: `SetDst1` μόνο για ΤΙΜΗ ΠΟΥ ΕΙΝΑΙ MASK· αντιγραφή/επιλογή/επαναφορά ζεύγους που μπορεί να είναι sharp μεταφέρει και τις δύο όψεις ανέγγιχτες.
- **Run 016b (7 Σεπ):** το lane-mask fix ΔΟΥΛΕΥΕΙ: λωρίδες ΕΦΥΓΑΝ, trace = αληθινά visible counts, lit image σωστό. Device lost ~30 s μετά το F12: το `OpControlBarrier(Subgroup)` του gow015 κάθεται ΜΕΣΑ στο exec branch του παιχνιδιού (`s_and_saveexec ~s68`) = μερικό subgroup → hang (έγινε divergent μόλις το mask έγινε σωστό). ΑΦΑΙΡΕΘΗΚΕ (gow017)· ΚΑΝΟΝΑΣ: ποτέ OpControlBarrier από εντολή που μπορεί να είναι υπό exec. Οθόνη τώρα: πλυμένο γκρι-μπλε + καρό πλακάκια + μαύροι λεκέδες: το full-res scene colour 0x226c80000 που διαβάζει το tonemap είναι ΜΑΥΡΟ σε όλο το frame (γράφεται μόνο από tile-classified indirect dispatches 7463e726 με λίγα groups, Clear στο BeginRendering, particles)· το tonemap δείχνει μόνο το half-res bloom = θολή εικόνα. ΙΔΙΟ στο capture του 014 → ΠΡΟΫΠΑΡΧΟΝ, όχι regression. Επόμενο: gow_bind.py σε f6282446 (31559 groups, διαβάζει lit) και στο tonemap SRT· έλεγχος αν το Clear είναι δική μας απόφαση.
- **gow018 (7 Σεπ, build 07:58, cache 11):** στο capture του 016 το half-res 0x226380000 έχει ΗΔΗ τα καρό πλακάκια πριν το tonemap. Αίτιο: `ds_swizzle` bitmask mode (xor butterflies, index ΑΝΑ LANE) μεταφραζόταν σε `ReadLane` = `OpGroupNonUniformBroadcast` που θέλει UNIFORM id → undefined. FIX: νέο IR op `Shuffle` → `OpGroupNonUniformShuffle` (Sirit + capability GroupNonUniformShuffle). Δεύτερο: wave64 reductions κάνουν `v_readlane vcc, v, 32` για να ενώσουν τα δύο μισά· σε 32-wide subgroup το lane 32 δεν υπάρχει → `EmitReadLane` κάνει `lane & (subgroup_size-1)` (wave32 model). ΑΝΟΙΧΤΟ: exposure του f6282446 (η ένωση μισών γίνεται διπλή μέτρηση του ίδιου μισού, ×2 φωτεινότητα το πολύ)· fast-clear του 0x226c80000. Probe 017 ΔΕΝ έτρεξε ποτέ - το 018 περιέχει και το barrier removal. ΚΑΝΟΝΑΣ: Broadcast = uniform id, Shuffle = per-lane id· ποτέ ReadLane για ds_swizzle/ds_bpermute.
- **Run 018 (7 Σεπ):** ΚΑΡΟ ΕΦΥΓΕ (shuffle fix επιβεβαιωμένο στην οθόνη). Μένουν: μαύροι λεκέδες = οι έμβερς στο half-res FX pass (0x227c80000, eids 7510/7520/7530, fs 040621e2/e2376d91, 180+186+246 indices = τα 180 particles του culler) βγαίνουν χρώμα 0 / alpha 1· κάθετες μπάντες στο φόντο. Device lost λίγα δευτερόλεπτα μετά το F12, όπως στο 016b: και στα δύο ο τελευταίος compile είναι fs 0xbb876517 και ο θάνατος ~10 s μετά· το 015 (πριν το mask fix) επέζησε στο ίδιο σημείο. ⚠ Το RenderDoc ΚΡΥΒΕΙ τα VK_NV_device_diagnostic_checkpoints + VK_EXT_device_fault ("Extension ... unavailable") → με RenderDoc κανένα device-lost dump δεν ονομάζει shader. Probe 019 = ίδιο build ΧΩΡΙΣ RenderDoc για να μιλήσουν τα checkpoints (ή να αποδειχθεί ότι φταίει το capture). RenderDoc indirect-arg decode (<0, 1>) αναξιόπιστο για BDA-written args.
- **ΤΟ RACE (7 Σεπ, capture 018):** καρό + μαύροι λεκέδες = ΕΝΑ bug. Απόδειξη: `gow_pickhist.py` = PickPixel ανά eid· το ΙΔΙΟ eid 12 replays → 4 διαφορετικές τιμές (0.115/NaN/0.110/0.091), στον ουρανό οι δύο τιμές που εναλλάσσονται = τα δύο χρώματα γειτονικών πλακακιών. Αίτιο: `Buffer::GetBarrier` early-out σε ίδια mask+stage ΧΩΡΙΣ έλεγχο αν η προηγούμενη πρόσβαση έγραφε· κάθε RW binding ζητά ShaderWrite → RW→RW ποτέ barrier → όλο το post chain του GoW (ένα 154 MB buffer RW παντού) έτρεχε χωρίς barriers. Το `Image::GetBarriers` είχε ήδη `is_write`. FIX gow020 (host-side, χωρίς recompile). ΜΕΘΟΔΟΣ: replay-ντετερμινισμός = ο τίμιος έλεγχος για race· PNG export του A2B10G10R10 έχει αλλαγμένα κανάλια.
- **Run 020 (7 Σεπ):** ΔΕΝ περιείχε το barrier fix (edit script έσκασε, το build ήταν no-op) - ανακαλύφθηκε από το capture: κανένα vkCmdPipelineBarrier2 ανάμεσα σε διαδοχικά skinning dispatches. Με τα εργαλεία `gow_racehunt.py` (double-replay κάθε action), `gow_racein.py` (fingerprint εισόδων ανά replay), `gow_bufhist.py`/`gow_bufdiff.py` (hash/diff range ανά eid × replays) η ρίζα καρφώθηκε: skinned vertex range 0x1026f38000+0x3f890f0 (17085 verts × 40 B) γράφεται in-place (RMW) από αλυσίδα skinning dispatches (4cce254e/4939957c/e691125b/7e5599a1, LocalSize 64, χωρίς LDS/subgroup ops) χωρίς barrier μεταξύ τους → racy 890+ dwords ανά replay → G-buffer draws (eid 1493+) κληρονομούν → όλο το frame. Run 020 έζησε 30+ min με RenderDoc (θάνατοι = κρύα cache). gow021 = το ίδιο fix, επαληθευμένο με grep.
- **Run 021 (7 Σεπ):** το barrier fix ΉΤΑΝ μέσα (rev a4c50a19, 0 errors) και η εικόνα ΔΕΝ άλλαξε. ⚠⚠ Η ΔΙΑΓΝΩΣΗ ΤΟΥ 020 ΉΤΑΝ ΛΑΘΟΣ: το race είναι 0.1065 στη χειρότερη περίπτωση, ένας λεκές θέλει 0.4, και κανένα από τα 6 probe points δεν ήταν καν πάνω σε λεκέ ([[feedback-anomaly-magnitude-before-cause]]). Το fix μένει (write-blind early-out = αληθινό bug) αλλά ΔΕΝ εξηγεί το σύμπτωμα. Κυνηγούσα ΛΑΘΟΣ ΕΙΚΟΝΑ: η σκηνή είναι το **0x216ce0000** (0% μαύρο, **3.32% NaN/Inf**), όχι το 0x226c80000 (100% μαύρο). ΛΕΚΕΔΕΣ = NaN που απλώνεται στα blur passes· επιβιώνει από καρέ σε καρέ (3.73% πριν κάθε pass), τα lighting passes το σβήνουν μερικώς (→ 1.87%) και το `cs 0x42ba6f62` το ξαναγράφει (→ 3.32%). Το καρό = πλακίδια **32×32 texel**, ήδη μέσα στη σκηνή πριν από κάθε post pass. Tile classification ΑΘΩΑ: 4605+160+41+1343+22+26229 = 32400 = 240×135 ακριβώς. Το `cs 0x42ba6f62` είναι μέσος όρος wave64 (ds_swizzle butterfly xor 1..16 → readlane 32 → × 1/64)· όλα BitMode, άρα το gow018 fix τα καλύπτει· το readlane 32 δίνει ΛΑΘΟΣ αλλά ΠΕΠΕΡΑΣΜΕΝΗ τιμή — η πηγή του NaN ΠΑΡΑΜΕΝΕΙ ΑΝΟΙΧΤΗ. ΓΕΝΙΚΟ FIX (στον δίσκο, άχτιστο): shaders από ζεστή pipeline cache δεν έπαιρναν ΠΟΤΕ όνομα (`SetObjectName` μόνο στο `CompileModule`) → κάθε capture από ζεστή cache αδιάβαστο, σε κάθε παιχνίδι· προσωρινή λύση = `gow_shaderid.py` (md5 των SPIR-V bytes → αρχείο cache). ΑΝΟΙΧΤΟ, ΜΗ ΔΙΟΡΘΩΜΕΝΟ: σε AMD RDNA το compute pipeline ζητά subgroup 64 αλλά το `profile.subgroup_size` λέει 32 → το gow018 fold θα ΣΠΑΓΕ reduction εκεί· εδώ (NVIDIA 32) σωστό, θέλει per-stage plumbing + AMD κάρτα. ⚠ capture φυλαγμένο ως `captures/gow021_1637.rdc`· το παιχνίδι έφτασε **20.1 GB** στο μενού με RenderDoc — κλείσε το ΠΡΙΝ αναλύσεις. ⚠ screenshots ΔΕΝ κρίνουν build: 13.85% και 10.00% λεκέδες στο ΙΔΙΟ run.
- **ΒΡΕΘΗΚΕ (7 Σεπ, από το ΙΔΙΟ capture του 021):** το `ds_swizzle` σε **QUAD mode** ήταν broadcast ενώ είναι **μετάθεση** — το ίδιο bug που διόρθωσα στο gow018 για το BITMASK mode και άφησα μισό. Το απέδειξε η ΜΑΣΚΑ NaN: δεν είναι ούτε tiles ούτε lanes — είναι η **σιλουέτα του Κράτου** με **κάθε δεύτερο pixel** μολυσμένο στο eid 7324 και ΣΥΜΠΑΓΗΣ στο 7347· καρό ανά quad = χαλασμένη quad εντολή. Το `cs 0x42ba6f62` ΔΕΝ γεννά NaN, το **απλώνει** (διαβάζει γείτονες, 1.80%→3.33%). ΜΕΤΡΗΣΗ (`scan_quadbroadcast.py`, σαρώνει τα cached .spv): **215 shaders, 3519 quad broadcasts, ο δείκτης ανά lane στα 3519 από 3519**, σταθερό σε κανένα. FIX: απόλυτο lane `(lane & ~3) | sel` μέσω `ir.Shuffle`· **cache 12 → πλήρης επαναμεταγλώττιση στο probe 022**. Το `data_share.cpp:317` ήταν ο ΜΟΝΑΔΙΚΟΣ πομπός του `QuadShuffle`. Επίσης χτισμένο: ονομασία shader από ζεστή cache. Το NaN ΔΕΝ έρχεται από είσοδο: στο eid 7179 μόνο τα δύο HDR targets έχουν (3.73% / 0.37%), depth και όλα τα άλλα float 0.00%. ⚠ Έσπασα ΔΥΟ φορές τον κανόνα του heredoc ([[feedback-bash-heredoc-quotes-use-write-tool]]): το `gow_stage.py` δεν μεταγλωττιζόταν καν → 30+ λεπτά αναμονής σε κολλημένο qrenderdoc. **Τρέχε `python -m py_compile` σε κάθε όργανο μετά από κάθε αλλαγή.**
- **run 022 (God of War): το quad fix ΗΤΑΝ αληθινό bug και ΔΕΝ ήταν η αιτία** — ο χρήστης: «visually everything was the same». Ίδιο σχήμα με το barrier του 021· δύο αποδεδειγμένα bug, κανένα η αιτία. ⚠⚠ **Κρίνε το build από το BUILD TIMESTAMP, όχι από το revision string**: το scmRev ανανεώνεται μόνο όταν ξανατρέχει το CMake, οπότε το log έλεγε `0bafd679` (ένα commit πίσω) ενώ το binary ΕΙΧΕ το fix — απόδειξη: build stamp 19:07:51 + 683/775 .spv ξαναγράφτηκαν (cache 12). **ΒΡΕΘΗΚΕ, μετρημένο, χωρίς νέο run** (η εικόνα δεν άλλαξε, άρα το capture του 021 ισχύει ακόμα): το **G-buffer είναι ΤΕΛΕΙΟ** (0x20d0a8000 = όλο το δάσος + ο Κράτος με κάθε λεπτομέρεια) αλλά το **depth του ΙΔΙΟΥ καρέ έχει ΜΟΝΟ τον Κράτο** (17.83% γεωμετρία / 82.17% far plane· ⚠ είναι ΓΡΑΜΜΙΚΟ view depth 1.13..12000, άρα "far" = η ΜΕΓΑΛΥΤΕΡΗ τιμή, όχι 1.0). Diff του normals target μέσα στο καρέ: **15.22% ξαναγράφτηκε και το 99.5% αυτών πέφτει ΑΚΡΙΒΩΣ πάνω στη σιλουέτα του Κράτου** — δηλαδή το καρέ γράφει το G-buffer ΜΟΝΟ εκεί που είναι αυτός και το υπόλοιπο 82% είναι ΠΡΟΗΓΟΥΜΕΝΟ καρέ. Αυτό ΕΙΝΑΙ το «κρατάει πολλά παλιά καρέ μέσα στα νέα» του χρήστη, σε νούμερο. **Αποκλείστηκαν με μέτρηση** (μην ξαναπληρωθούν): το 3D LUT χρωματισμού είναι καθαρή μονότονη ράμπα με σωστές γωνίες (αθώο)· και τα 23 compute shaders με shared memory σε workgroup 64 ΕΧΟΥΝ ήδη control barriers (αθώο)· και τα 118 Shuffle είναι φραγμένα μέσα σε 32 lanes εξ ορισμού (το `ir.Shuffle` το εκπέμπει ΜΟΝΟ το ds_swizzle) — άρα τα δύο ds_swizzle fixes είναι σωστά ΚΑΙ ασφαλή σε κάθε subgroup size. **Ανοιχτά/αληθινά:** 111/117 compute shaders έχουν workgroup 64 ενώ το host λέει `Physical device subgroup size 32`· το `Translator::SetThreadMask` παίρνει `CompositeExtract(mask,1)` ως lanes 32..63 που σε 32-lane subgroup είναι **ΠΑΝΤΑ μηδέν**, άρα το `s_bcnt1_b64` μετράει το μισό wave (και το `WavesPerGroup()` ήδη υπολογίζει 2 waves/group — ασυνέπεια μέσα στον ίδιο κώδικα)· το bloom target 0x21a5b0000 είναι **100% μαύρο**. ⚠ **Ανέλυα MENU capture για in-game παράπονο** — το μενού έχει σχεδόν μηδέν γεωμετρία, δεν είναι δίκαιο τεστ· probe 023 ζητά IN-GAME capture + `GT_FRAME_PROF=1` (υπάρχει ήδη, ΧΩΡΙΣ νέο build) που τυπώνει `[clears] addr:WxH:b<binds>/c<clears>/f<forced>` ανά render target. Νέα όργανα: `gow_lut.py`, `gow_depthmask.py`, `scan_wave64.py` (offline από τα cached .spv).
- **run 023 (God of War): το clear ΔΕΝ πετιέται, και το wave-mask lead ήταν δικό μου λάθος.** Ο χρήστης πάτησε F12 και πέθανε ακαριαία (3η φορά: 016b, 018, 023) — αλλά το run είχε ήδη γράψει 271 s. **ΑΠΑΝΤΗΣΗ:** από τα **19 colour targets μόνο ΕΝΑ** (`0x21a750000`) δέχεται ποτέ clear· το G-buffer `0x20d0a8000` δένεται 1458 φορές ανά 2 s και καθαρίζεται **μηδέν** — που είναι ΣΩΣΤΟ σε deferred renderer, το παιχνίδι δεν το ζητάει. Θεωρία νεκρή, καθαρά. **ΔΟΜΙΚΟ ΕΥΡΗΜΑ:** `[bigidx]` → depth **0 indirect draws**, colour **2242-6747 ανά 2 s** — δηλαδή το depth ζωγραφίζεται ΑΠΕΥΘΕΙΑΣ και το G-buffer ΕΞ ΟΛΟΚΛΗΡΟΥ με GPU-driven indirect. Ίδιο σχήμα με τη γραμμή GT7 (runs 259-264: με χιλιάδες indirect η σκηνή ΕΛΕΙΠΕ, εμφανιζόταν μόνο σε direct-draw mode). ⚠ Το `first-command index count zero` ΔΕΝ αποδεικνύει τίποτα: `TryReadIndirectArgs` κάνει memcpy το **CPU** αντίγραφο και το σφραγίζει `gpu_modified` γι’ αυτόν ακριβώς τον λόγο. **`GT_INDARGS_GPU=N` (υπάρχει από το run 264, ποτέ αναμμένο) διαβάζει τα ΠΡΑΓΜΑΤΙΚΑ bytes που καταναλώνει ο GPU** → probe 024, χωρίς RenderDoc, τίποτα να πατηθεί, χωρίς νέο build. ⚠⚠⚠ **ΔΙΟΡΘΩΣΗ του run 022: το `SetThreadMask` ΔΕΝ είναι bug.** Το shadPS4 μοντελοποιεί ένα guest wave64 ως **ΕΝΑ** 32-lane subgroup, σταθερά (`WavesPerGroup`/`LocalWaveIndex` διαιρούν με `profile.subgroup_size`, `GetExec` είναι per-invocation `U1`, το σχόλιο στο `EmitReadLane` το λέει ρητά). Άρα η μηδενική πάνω λέξη είναι ΣΩΣΤΗ και το `s_bcnt1_b64` μετράει ΟΛΟΚΛΗΡΟ το 32-lane wave. Νέα όργανα `scan_wavemask.py` (24/775 shaders διαβάζουν την πάνω λέξη· οι δύο κορυφαίοι `0x5fe5af59`/`0x38c7b95b` είναι ΟΝΤΩΣ το ζεύγος που γράφει τη λίστα (key,index) των indirect draws — η σύγκλιση στέκει, ο μηχανισμός όχι) και `scan_lane_const.py` (**η αληθινή έκθεση wave64-σε-wave32 σε όλο το παιχνίδι είναι 3 εντολές `Broadcast lane 32` σε ΕΝΑ shader**, `0x59e1a66a`· 3397 runtime lanes είναι ds_swizzle, φραγμένα σε 32). Μην ξοδέψεις άλλη συνεδρία εκεί. **Το F12 crash είναι GPU FAULT, όχι timeout:** Windows System log την ίδια στιγμή → 3x `nvlddmkm Id 13 Graphics Exception` (ESR 0x404000=0x80000002, `Class 0xc00d Subchannel 0x0 Mismatch`) + Id 153, και **ΚΑΝΕΝΑ event 4101** (= κανένα TDR reset), παρότι ο GPU είναι 96% busy και το `TdrDelay` αρύθμιστο (2 s). ⚠ **Δες το Windows event log ΠΡΙΝ θεωρητικολογήσεις για device lost** — τζάμπα, ήδη γραμμένο, και ξεχωρίζει fault από timeout σε μία γραμμή. ⚠⚠ Το shadPS4 ήταν τυφλό επειδή **το RenderDoc κρύβει `VK_EXT_device_fault` ΚΑΙ τα diagnostic checkpoints** — το γράφει στο startup log· γι’ αυτό κάθε device-lost report σε RenderDoc run τελειώνει με «the driver cannot say where or why». Commit `40da489b`.
- **run 024 (God of War): οι μαύροι λεκέδες είναι σφάλμα ΤΕΤΑΡΤΗΣ ΑΝΑΛΥΣΗΣ, όχι κύματος.** Ο χρήστης έστειλε 5 screenshots: Κράτος/Άτρεας/τσεκούρι/UI **τέλεια** παντού, το περιβάλλον μπλοκ-θόρυβος — εκτός από το κινηματογραφικό του δέντρου, όπου το δάσος ΕΙΝΑΙ εκεί αλλά κομματιασμένο. **Η φωτισμένη σκηνή `0x216ce0000` έχει 3,17% NaN** (3,32% όταν πρωτομετρήθηκε — αναπαραγωγή)· **1,75% υπάρχει ΠΡΙΝ από κάθε πέρασμα του καρέ**, άρα επιβιώνει από καρέ σε καρέ. **ΑΠΑΝΤΗΘΗΚΕ η ανοιχτή ερώτηση του run 022** (πλέγμα κυμάτων ή δεδομένα;) με νέο όργανο `scan_nanmask.py`: όλα τα modulo 8/16/32 είναι **επίπεδα (1,01-1,06)** και ο διαχωρισμός μισού-tile **49,7/50,3%** → **ΔΕΝ είναι πλέγμα κύματος/tile· το wave64-σε-wave32 τελείωσε ως θεωρία**. Είναι: **89% των runs ξεκινούν σε πολλαπλάσιο του 4, μήκος 4 px οριζόντια ΚΑΙ 4 px κατακόρυφα** = ένα texel buffer **480x270**. ⚠ Τα modulo histograms ΜΟΝΑ ΤΟΥΣ δεν το βλέπουν (ευθυγραμμισμένα runs των 4 χτυπούν κάθε x%4 εξίσου και διαβάζονται επίπεδα) — χρειάζεται η ευθυγράμμιση των ΑΡΧΩΝ. Ανεβαίνοντας: τα half-res έχουν ΠΕΡΙΣΣΟΤΕΡΟ NaN από τη σκηνή (`0x226380000` **6,36%**, `0x219cb0000` 4,43%, `0x21a130000` 4,40%), και το χειρότερο ανανεώνεται από `vkCmdDispatchIndirect(<0,1,1>)` — **μηδέν workgroups, άρα δεν τρέχει ποτέ** και κουβαλάει το NaN μπροστά. **17 από τα 47 indirect dispatches του καρέ έχουν μηδέν groups.** Τα 6 dispatches φωτισμού ΔΕΝ είναι ανάμεσά τους: 25941+4890+1342+161+46+20 = **32400 = 240x135 = ακριβώς το πλέγμα 8x8** — η ταξινόμηση tiles παραμένει αθώα. ⚠ `gow_targets.py` έχει `RDC_MAXTEX=40` by default και κρατάει μόνο τα ΜΕΓΑΛΥΤΕΡΑ textures — γι’ αυτό κανένα προηγούμενο scan δεν είχε δει τα half/quarter-res buffers. Βάλε 400. **ΔΥΟ ΠΟΡΤΕΣ ΕΚΛΕΙΣΑΝ:** (α) η ίδια μου η γραμμή GT7 (runs 259-268) έχει ετυμηγορία ότι **τα indirect draws ΔΕΝ είναι το περιβάλλον** — τα 2/3 μηδενικά είναι ΦΥΣΙΟΛΟΓΙΚΑ για culled batch list (GT7 65-70%, GoW 66-94%)· (β) η αιτία του GT7 ήταν ότι **η CPU σταματά να στέλνει τα μεγάλα draws** (occlusion culling διαβάζει μπαγιάτικο μηδέν με readbacks off) — **το GoW ΔΕΝ έχει αυτή την υπογραφή**: `colour[98130x28 93642x28]` σε ΚΑΘΕ παράθυρο όλου του 390-δευτ. run. Άρα το readbacks fix του GT7 δεν είναι το fix εδώ· έφτιαξα per-game override (`custom_configs/CUSA07408.json`, `readbacks_mode`, τιμές 0/1/2) και το **αφαίρεσα** για να μη μείνει ενεργή ρύθμιση-έκπληξη. ⚠ Το F12 έγραψε capture 1 GB ΠΡΙΝ πεθάνει — αναλύσιμο χωρίς νέο run. Commit `e135cba6`.

**27 Σεπ ~05:35 — GTA V A/B για το PR #5114 (ο χρήστης τώρα ΕΧΕΙ GTA V).** Dump `F:\PS4_Dumps\GTA_V_CUSA00411_v1.57`
(app 1.00 + patch 1.57). Φάκελος παιχνιδιού = junctions `F:\PS4_Dumps\GTA_V_shadps4\CUSA00411` (→app) και `CUSA00411-patch`
(→patch): το shadPS4 ψάχνει `<base>-UPDATE`/`<base>-patch`, οπότε το `CUSA00411-app` ΔΕΝ θα έβρισκε το patch· το eboot
φορτώνεται από `/app0` μέσω overlay = 1.57. Exes (build στο shadps4-clean, slot από τον peer, ξαναδόθηκε σε
gow-orderedcount 596ed125): `backup_exe/shadps4_gtav_main_d96278e1.exe` (origin/main, 964198c7…) και
`shadps4_gtav_pr5114_88b3286c.exe` (main + merge mine/f64-literal-high-dword, bd0d354c…· μόνο translate.cpp). Launchers
`GT7_upstream/GTAV_A_main_d96278e1.bat` / `GTAV_B_pr5114_88b3286c.bat`, profiles `C:\shadps4-gtav-{main,pr5114}\user`
ΙΔΙΑ config, dump_shaders ON, ΞΕΧΩΡΙΣΤΟ pipeline cache (διαφορετική μετάφραση = ποτέ κοινό cache). Watchers
RUN=gtav_pr5114_1 / gtav_main_1. Μετά: `f64lit_scan.exe` στα dumps (πόσα F64 literals έχει το GTA V) + σύγκριση shots ίδιας
σκηνής. Αν 0 literals, το PR δεν αλλάζει τίποτα στο GTA V και η φωτεινότητα του maintainer ήρθε από άλλη διαφορά του build.
**27 Σεπ ~05:52 — ΑΠΟΤΕΛΕΣΜΑ GTA V A/B: το #5114 ΔΕΝ ευθύνεται.** (1) `f64lit_scan` σε ΟΛΑ τα dumps του PR run 1: 859 shaders,
467.806 εντολές, 0 desyncs, **0 VOP1/VOPC με double source καθόλου** (ούτε literal ούτε register) → το PR δεν αγγίζει κανέναν shader.
(2) Burst 60 καρέ/7 s (`scratchpad/burst.ps1`, luma ανά καρέ): PR 47/60 ΜΑΥΡΑ, main 47/60 ΜΑΥΡΑ (3D σκηνή μαύρη, HUD μένει).
(3) Στο **main** πιάστηκαν και ΥΠΕΡΕΚΤΕΘΕΙΜΕΝΑ καρέ (luma 173, 32% clipped: `logs/burst_gtav_main_1/b043.png`) = ακριβώς το
«PR» screenshot του DanielSvoboda. Η έκθεση αλλάζει καρέ-προς-καρέ (μαύρο / κανονικό / καμένο) → ένα screenshot ανά build δεν
συγκρίνει τίποτα. Ο χρήστης επιβεβαίωσε με το μάτι «its the same». Εκκρεμεί: σύγκριση .spv των δύο profiles (`scratchpad/spvcmp.sh`).
Προσοχή: ο χρήστης ξανάνοιξε το B (05:45) αντί για A — ο watcher του B είχε ήδη τελειώσει· ξαναστήθηκε ως gtav_pr5114_2.
**SPIR-V main vs PR (05:55):** 369 guest shaders κοινά· 355 ίδια σύνολα SPIR-V, 13 γνήσια υποσύνολα (το profile του PR είδε
περισσότερα permutations σε 2 μακρύτερα runs), 1 (`fs_0xa3c115dabc476443`, 48 vs 141 παραλλαγές) με ένα permutation που το PR run
δεν συνάντησε· 0 πλήρως διαφορετικά. Main dumps: 0 F64 VOP1/VOPC επίσης. ΚΑΙ τα δύο runs = σκέτο main d96278e1 (περιέχει τα
συγχωνευμένα #5070 + #5126)· ΔΕΝ περιείχαν τα ανοιχτά #5137 (catch-all sampler), #5131 (SampleId), ούτε το trunc-min-f64.
**27 Σεπ — GoW (lane του peer, εγώ watcher+audit).** GOW1 88c61ea9 (DS_ORDERED_COUNT): cs 0x38c7b95b μεταφράζεται, πέθανε σε
`resource_discover_pass.cpp:257` (T# dw1 = ReadConst & 0xC3FFFFFF, fs 0xcc4267a6· ΔΙΠΛΟΤΥΠΟ του κλειστού #4999 του χρήστη, ο
baggins183 ήθελε λύση στο SRT program). GOW2 8f008d67: το fs περνά· σε 44 s **γυμνό 153** → "Device lost during submit"
(buffer_cache.cpp:424). Audit: κάθε wave εκτελεί ΜΙΑ από τις δύο DS_ORDERED_COUNT (S_CBRANCH_SCC0 στο +0x2f80), άρα όχι
double-wait· ΑΛΛΑ με wave64 lowering (2 host subgroups ανά GCN wave, ballot μέσω shared memory) το op εκλέγεται ανά 32-lane
subgroup → ο μετρητής προχωρά 2T ανά wave, TG_SIZE μετρά host warps. Αν προκαλεί το TDR: αναπόδεικτο.
⚠ **ΔΙΟΡΘΩΣΗ του audit (ίδια μέρα):** το «μετρητής 2T ανά wave» ήταν ΛΑΘΟΣ. Και τα δύο ops είναι μέσα σε `If %4084`
(= LocalInvocationId.x == 0, asl $167) → μόνο το thread 0 του workgroup (64 threads = 1 GCN wave) τα εκτελεί. Έλεγξα μόνο το
scalar branch ΑΝΑΜΕΣΑ στα ops, όχι το If ΠΟΥ ΤΑ ΠΕΡΙΚΛΕΙΕΙ. Το πραγματικό πρόβλημα (peer): το πάνω subgroup έχει δικό του
ticket (2w+1) που απελευθερώνεται μόνο στο S_ENDPGM → το op του workgroup w+1 περιμένει να ΤΕΛΕΙΩΣΕΙ το w → σειριοποίηση,
πιθανή οδός προς TDR. GOW3 = wave index ανά 64 lanes + CAS στο S_ENDPGM signal.
**27 Σεπ 13:24 — GOW3 run 1 (586d0579, watcher+audit του gtnikos-8c): ο τελεστής wave σωστός, το TDR ΔΕΝ μετακινήθηκε.**
bat 13:24:34 → σκέτο nvlddmkm 153 13:25:13.506 (Properties ΙΔΙΑ bit-προς-bit με το 153 του GOW2) → «Device lost during submit»
(`vk_scheduler.cpp:242`). IR: TG_SIZE = WorkgroupIndex + (LII>>6), waves 1· ops + signal με wave = WorkgroupIndex + (LII>>6)· ops μέσα
στο If (LocalInvocationId.x == 0). ΙΔΙΟ ΣΗΜΕΙΟ με GOW2: splash «Sony Interactive Entertainment presents» (16-17 FPS), 27,2 s μετά το
compile του cs 0x38c7b95b (GOW2 26,3 s), ίδιος τελευταίος shader (fs 0x9ec17c26, ΜΕΤΑ το 153), ίδια 3793 dumps / 1307 cache. Το log
δεν ονομάζει submit/dispatch (κανένα device-fault output). Log `logs\shad_log_gow3_1_at_exit_132526.txt`, artifacts
`logs\gow3_1_artifacts`, profile ξανά κρύο. spirv-val (vulkan1.3) στο .spv του cs 0x38c7b95b: VALID (και οι δύο συνεδρίες).
Clamps «0xFFFFFFF0»: 319 γραμμές + 2305 «Skipped» = ≥2624 συμβάντα (GOW2 689 + 3045 = ≥3734). ⚠ ΜΕΘΟΔΟΣ χωρίς timestamps στο log: το όνομα του `shad_log_<x>_prelaunch_<TS>.txt` = ώρα
launch, τα mtimes των dumps = ώρα compile κάθε shader (και ο τελευταίος πριν το τέλος) → σύγκριση με την ώρα του nvlddmkm event.
Το GoW παγώνει (απόφαση χρήστη)· επόμενο = GT7 run που θα ορίσει ο χρήστης.
**27 Σεπ 14:16 — TEST17 runs 5-6 (c48229d2, warm· run 5 ΑΟΠΛΟ, run 6 watcher + exit-code catcher του gtnikos-8c): η ΣΙΩΠΗΛΗ
ΕΞΟΔΟΣ = unhandled access violation στον κώδικα του GT7.** Run 6: 14:14:26.097-14:16:02.387, EXIT CODE 0xC0000005 (από τον
catcher, ίδιο με το paste της κονσόλας από τον χρήστη)· `<Critical> (WorkT) signals.cpp:144 Unhandled Exception code 0xc0000005
at 0xd4aaf37` = eboot+0x18eaf37 (eboot στο 0xbbc0000, το exe στο 0x700000000000), ~10 s μετά το InRaceRoot (Music Rally).
ΝΕΑ διεύθυνση (ο 38 έκανε rebase όλα τα παλιά guest crashes). ΔΕΝ κάνουμε disassemble το eboot. Κανένα nvlddmkm/WER.
TEST17 (zero-size T#): το 0x3f80000000 εμφανίστηκε 1 φορά (key-assign dialogs) και το απέρριψε ο έλεγχος FORMAT (bad format=true)·
ο zero-size έλεγχος έπιασε μόνο το 0x4000000000 στον αγώνα (γρ. 89409)· κανένα menu reset· τίποτα δεν δένει το TEST17 με το
crash. Run 5 (13:44:32-13:45:42, στα key-assign dialogs): 0 Critical, αλλά ΙΔΙΑ υπογραφή αρχείων με το run 6 → πιθανότατα
το ίδιο είδος crash με χαμένη γραμμή. Με Log.sync=false το Log::Flush αδειάζει το file sink, όχι την ουρά του async_sink· το run 5
έχασε ΚΑΙ τις γραμμές του Shutdown, ενώ το play_time.txt αποδεικνύει ότι έτρεξε. ⚠ ΜΕΘΟΔΟΣ «πώς τελείωσε» χωρίς log:
- (A) logs flush → +~100 ms `play_time.txt` → `imgui.ini` ανέγγιχτο = report από το signals.cpp (Critical + Shutdown)· T17 r5/r6, T14 r2.
- (B) τελευταία εγγραφή στο τέλος, χωρίς play_time/imgui, κομμένη γραμμή = ExitProcess χωρίς Shutdown (κονσόλα/kill)· T16 r5,
  T15 r5 (153).
- (C) quick_exit (παράθυρο/hotkey/LoadExec) = γράφει ΚΑΙ το imgui.ini· δεν έχει φανεί.
Logs:
- run 5: `logs\shad_log_test17_gt7_5_unwatched_lastwrite_134542.txt` + `game_log_…_134541.txt` + `test17_gt7_5_end_of_run_file_times.txt`·
- run 6: `logs\shad_log_test17_gt7_6_at_exit_141615.txt` + `game_log_…_141615.txt` + `test17_gt7_6_exit_code.txt`.
Πρόταση 38 (αναποφάσιστη): GT_* log-only όργανο (access type, διεύθυνση-στόχος, κατηγορία στο memory map, guest registers),
που να γράφει ΣΥΓΧΡΟΝΑ.
**27 Σεπ 15:00 — TEST17b (17629545 = c48229d2 + GT_CRASHREC, warm): το όργανο έπιασε το crash.**
Run 1 (14:48:51-~14:51:16) ΑΟΠΛΟ: ο χρήστης το ξεκίνησε πριν από το «armed». Έκλεισε στο Dualshock4SteeringTypeDialog με
υπογραφή (B): χωρίς play_time, χωρίς crash record, 0 Critical, κωδικός εξόδου χαμένος. Run 2 (pid 29748,
14:59:24.493-15:00:43.533) οπλισμένο: **EXIT 0xC0000005**, με πλήρες crash record:
- WRITE στο 0x2075ffffc, δηλαδή στο τελευταίο dword της σελίδας ΚΑΙ του VMA 0x207400000-0x207600000 (direct, prot 0x33,
  committed, "anon").
- Η σελίδα 0x2075ff000 είναι στο host **PAGE_READONLY**, με alloc_protect READWRITE και type MAPPED. Μοιάζει με
  write-watch προστασία, αλλά ούτε το DispatchAccessViolation ούτε το guest DispatchSignal τη χειρίστηκαν
  (report_unhandled 1).
- rip eboot.bin+0x26c0642, thread "Job#21". Το eboot φορτώθηκε στο 0xbcb0000 (στο r6 στο 0xbbc0000), άρα το +0x18eaf37 του r6
  είναι ΑΛΛΟ σημείο.
- Υπογραφή (A), με το record 1 ms πριν από το flush. Το log έχει πάλι 0 Critical (χάθηκαν στην ουρά), ενώ το σύγχρονο record
  σώθηκε.
- Σημείο: μετά τα key-assign και AssistPreset dialogs, 1,1 s μετά το τελευταίο BuddyWindowRoot.

Logs:
- run 1: `logs\{shad_log,shadps4_log}_test17b_gt7_1_unwatched_lastwrite_145116.txt` + `game_log_…_145115.txt`·
- run 2: `logs\shad_log_test17b_gt7_2_at_exit_150055.txt` + `game_log_…_150055.txt` + `test17b_gt7_2_exit_code.txt` +
  `test17b_gt7_2_gt_crashrec_20260927_145924_29748.txt`.

Επόμενο ερώτημα για τον 38: ποιος προστάτεψε τη σελίδα read-only και γιατί το page tracking δεν την αναγνώρισε.
Απάντηση 38 (επαληθευμένη από 8c): το `GuestFaultSignalHandler` ελέγχει 8 bytes και το `IsMapped` θέλει όλο το [addr, addr+8).
Στα τελευταία 7 bytes ενός GPU mapping ο handler απορρίπτει το δικό του fault. Fix 92d09f22:
`size = min(8, GetNextPageAddr(addr) - addr)`.
**27 Σεπ 15:20 — TEST17c r1 (7de6398d = fix + GT_FAULTEND, warm): ΝΕΟ assert, η θεωρία ΑΔΟΚΙΜΑΣΤΗ.**
- Χρόνος: pid 33180, 15:18:15-15:20:45.878. EXIT 0x80000003 = assert path, χωρίς crash record (το assert βγάζει τον VEH πριν
  από το int3).
- Στο GpuCommandProcessor, τρεις διαδοχικές γραμμές: `Rejecting invalid S#` (θόρυβος, 84-374 ανά run) →
  `UpdatePageWatchers: Tracking memory region 0x0 - 0x31000 which is not fully GPU mapped` →
  `address_space.cpp:552 Protect: Assertion Failed! addr 0x0 out of bounds`. Άρα έγινε tracking ενός πόρου στη διεύθυνση 0
  με μέγεθος ≠ 0· ο έλεγχος zero-size του TEST17 δεν τον πιάνει. ⚠ ΟΧΙ πρώτη φορά (διόρθωση 38): το TEST16 r1 τελειώνει με
  `Tracking memory region 0x0 - 0x3201000 …` ως ΤΕΛΕΥΤΑΙΑ γραμμή (η Critical χάθηκε στην ουρά). Το grep του 8c κάλυπτε μόνο τα
  logs test17*. Κατά τον 38 είναι IMAGE με guest_address 0 (μόνο το texture cache καλεί UpdatePageWatchers· το BindTextures
  απορρίπτει T# με address 0), δηλαδή RT/depth/resolve/copy ή FindImageFromRange.
- Σημείο: 0,6 s μετά το AssistPresetSelectDialog, πριν από το σημείο του r2 (7,8 s). 0 γραμμές GT_FAULTEND.
- **Υπογραφή (D) = assert**: flush του shadps4.log τη στιγμή του assert, μετά Shutdown (Cache dumped, play_time +3,1 s),
  imgui ανέγγιχτο, exit 0x80000003. Η γραμμή Critical ΕΠΙΖΕΙ.
- Logs: `logs\{shad_log,game_log}_test17c_gt7_1_at_exit_152059.txt` + `test17c_gt7_1_exit_code.txt`.
**27 Σεπ 15:25 — TEST17c r2: EXIT 0xC0000005 ΧΩΡΙΣ crash record.**
- Χρόνος: pid 28408, 15:24:32-15:25:37.164.
- Υπογραφή (B): 0 Critical, χωρίς Shutdown, χωρίς play_time, 0 GT_FAULTEND.
- Σημείο: ~0,8 s μετά το BuddyWindowRoot που ακολούθησε το PedalType dialog, ΠΡΙΝ από το AssistPreset.
- Νέο γεγονός: **(B) + 0xC0000005 = AV που δεν έφτασε ποτέ στο unhandled μονοπάτι του VEH** (το ίδιο build έγραψε record
  μέσα σε 1 ms στο T17b r2). Πιθανότατα ίδια κλάση με το T17b r1.
- Υπόθεση, αμέτρητη: μη εγγράψιμο RSP (guest stack χωρίς guard page), οπότε ο kernel δεν μπορεί να κάνει dispatch. Dump από
  WER δεν γίνεται με SEM_NOGPFAULTERRORBOX.
- Logs: `logs\{shad_log,game_log}_test17c_gt7_2_at_exit_152552.txt` + `test17c_gt7_2_exit_code.txt`.
- Απολογισμός στο παράθυρο key-assign/assist: T17 r5 (A), T17b r1 (B), T17b r2 (A)+record, T17c r1 (D), T17c r2
  (B)+AV. Τουλάχιστον 3 μηχανισμοί μέσα στα ίδια ~10 s του παιχνιδιού.
**27 Σεπ 15:34 — TEST17c r3: EXIT 0x80000003, assert `image.cpp:259 ASSERT(subres_idx < subresource_states.size())`.**
- Το assert είναι στο Image::Transit, στο GPU thread. Ήρθε ~3,5 s μετά το AssistPreset, πάλι πριν από το σημείο του T17b r2.
- Πριν από αυτό: `Rejecting invalid T# address=0x4e00 … (bad address=false, bad format=false, bad tile mode=false)` →
  `Tracking memory region 0xc001260000 - 0xc006218000 which is not fully GPU mapped` → `Creating tiling pipeline
  Depth2DThin64_8 detiler` → Critical. 0 GT_FAULTEND.
- **Μοτίβο:** και τα δύο asserts του T17c (και το τέλος του T16 r1) έρχονται αμέσως μετά από tracking image σε εύρος «not fully
  GPU mapped». Εύρη που έχουν φανεί στα logs test14-17: 0x3f80000000 (6×), 0x109ed93000-0x11026a0000 (2×),
  0xbfaf669000-…, 0xc001260000-…, 0x0-0x3201000, 0x0-0x31000.
- Προτάθηκε στον 38 ένα γενικό ερώτημα: να δημιουργείται/παρακολουθείται καθόλου image που δεν είναι πλήρως GPU mapped;
- Logs: `logs\{shad_log,game_log}_test17c_gt7_3_at_exit_153433.txt` + `test17c_gt7_3_exit_code.txt`.
**27 Σεπ 15:41 — TEST17c r4: το ΠΙΟ ΜΑΚΡΙΝΟ run της σειράς.**
- Διαδρομή: InRaceRoot 15:40:07, αγώνας, και `replay_a.dat` στις 15:41:12.392.
- Τέλος: EXIT 0x80000003 την ίδια στιγμή που δημιουργήθηκε ένα ΝΕΟ tessellation pipeline, 0xdaad0f7b1d31dae4 (ls 0x64593dcd +
  hs 0x4ada5197 + vs 0xc56c214c). Το .key γράφτηκε στο ίδιο ms με το flush του log. Κανένα από αυτά τα hashes δεν υπάρχει σε
  παλιότερο log.
- Η γραμμή Critical χάθηκε, γιατί το Shutdown κράτησε 0,1 s και η ουρά δεν πρόλαβε να αδειάσει. 0 GT_FAULTEND.
- Αρχεία του pipeline: `logs\test17c_gt7_4_artifacts\`. Logs `logs\*test17c_gt7_4*`.
- ⚠ ΜΕΘΟΔΟΣ: το play_time.txt γράφεται ΚΑΙ περιοδικά ανά 60 s παιχνιδιού (γραμμές `UpdatePlayTime` από το thread «()»). Το
  Shutdown το αναγνωρίζεις από mtime στο τέλος ΚΑΙ τιμή που δεν έχει εμφανιστεί σε καμία γραμμή UpdatePlayTime.
**27 Σεπ 15:50 — TEST17c r5: EXIT 0x80000003, `liverpool.cpp:256 ProcessGraphics: Unimplemented PM4 type 0, base reg: 0, size: 1`.**
- Τέταρτος διαφορετικός τρόπος θανάτου. Το header dword ήταν ακριβώς 0x00000000 (type 0, base 0, count 0) στο DCB του graphics
  ring, αμέσως μετά από `sceGnmSubmitCommandBuffersForWorkload` → `sceGnmSubmitDone`.
- ~3 s μέσα στον αγώνα (RaceCommon_InRaceRoot 15:50:09.538, flush του shadps4.log 15:50:12.241). Το tess key 0xdaad0f7b1d31dae4
  ΔΕΝ εμφανίζεται, άρα πέθανε πριν από το σημείο του r4.
- Υπογραφή (D) με Shutdown 3,9 s, γι' αυτό η Critical επέζησε. play_time 0:20:44 έναντι της περιοδικής 0:20:39.
  Κανένα record, nvlddmkm ή WER.
- **Διόρθωση:** 0 «not fully GPU mapped» και 0 GT_FAULTEND. Το μοτίβο «not fully GPU mapped → assert» ΔΕΝ ισχύει για όλα
  τα asserts.
- Θόρυβος, όχι πρόδρομος:
  - `Rejecting invalid S# … mip_filter=3` υπάρχει σε ΟΛΑ τα runs, 78-813 ανά run;
  - `Unexpected metadata read by a shader (texture)` υπάρχει μόνο στα r4 (614) και r5 (67), δηλαδή στη σκηνή του αγώνα.
- Κώδικας 7de6398d: το `SubmitGfx` κρατά αντίγραφο του DCB/CCB ΜΟΝΟ με `IsCopyGpuBuffers()`. Το profile έχει
  `copy_gpu_buffers=false`, άρα το CP διαβάζει τη μνήμη του guest επί τόπου, ασύγχρονα. Τα IndirectBuffer και το CondExec
  διαβάζονται επί τόπου σε κάθε περίπτωση.
- Υποψήφιες αιτίες, αναπόφαστες:
  - (a) μηδέν μέσα στο buffer;
  - (b) ο guest ξανάγραψε το buffer πριν φτάσει το CP;
  - (c) desync από προηγούμενο πακέτο με λάθος μήκος, που προσγειώνεται σε μηδενικό payload dword.
- Logs `logs\{shad_log,game_log}_test17c_gt7_5_at_exit_155028.txt`, `shadps4_log_test17c_gt7_5_lastwrite_155012.txt`,
  `test17c_gt7_5_exit_code.txt`.
**27 Σεπ 15:58 — TEST17d (6b999dac: GT_IMAGEMAP + GT_BLACKBOX + record ASSERTION) ελέγχθηκε ΟΚ και οπλίστηκε για `test17d_gt7_1`.**
- Το UNREACHABLE καλύπτεται: unreachable_impl → assert_fail_impl → GtCrashRecordAssert.
- Ο catcher αντιγράφει και το `gt_blackbox_*` μετά την έξοδο.
**27 Σεπ 16:02-16:17 — TEST17d r1-r5 (όλα αρχειοθετημένα, cmp IDENTICAL).**
- **Το fix 92d09f22 ΑΠΟΔΕΙΧΤΗΚΕ.** Υπάρχουν 4 γραμμές GT_FAULTEND:
  - r2: 2× στο 0x2075ffffc, το ακριβές σημείο του TEST17b r2;
  - r5: 2× στο 0x2077ffffc.
  Και τα δύο runs συνέχισαν πολύ ώρα μετά.
- **PM4 type 0 = ΓΝΩΣΤΟ, όχι νέο:** 14 παλιά logs (TEST15 r3, runs 309/313/320, 351/353/356).
  - Το fix του Σεπτεμβρίου 4720205e (fences εκτός σειράς) λείπει από το 8151ee25, αλλά ΔΕΝ εφαρμόζεται εδώ. Στο upstream το
    EventWriteEop/Eos/ReleaseMem καλεί το SignalFence αμέσως, κατά την ανάγνωση, χωρίς deferral.
  - Τα assertion records (r2, r3): το μηδέν διαβάζεται ΜΕΣΑ σε nested INDIRECT_BUFFER, βάθος 2 (r3) και ≥43 (r2).
  - Άρα το copy_gpu_buffers ΔΕΝ βοηθά (αντιγράφει μόνο το top-level DCB). Η πρόταση αποσύρθηκε.
  - Ύποπτα του 38, και τα δύο αναπόδεικτα: (A) το chain bit του IB (dw2 bit 20) δεν διαβάζεται ποτέ, οπότε κάθε IB γίνεται
    κλήση που επιστρέφει· (B) πιθανό layout 5 dwords για το COND_EXEC στο GFX7.
  - Το όργανο για το TEST17e περιμένει τον χρήστη.
- r4: AV. Μέσα σε 0,7 ms, 14 job threads διάβασαν τη διεύθυνση 0 και ο Job#37 πήδηξε στο 0x569f320a (unmapped). Ο handler
  μετά έσκασε αποκωδικοποιώντας εκείνο το RIP (Zydis).
- r5: ξανά `Protect addr 0x28000`. Το GT_IMAGEMAP ονόμασε το σκουπίδι T# (0x28600+0xe7148000, 732 layers, pgm 0x2a265dff
  binding 0), μέσα σε ≥12 nested IB.
- r1: κόλλησε στη φόρτωση, EXIT 0. r3: ΑΟΠΛΟ (λάθος του 8c: ανάλυση πριν από νέα όπλιση).
- **COND_EXEC, ΕΠΑΛΗΘΕΥΜΕΝΟ ανεξάρτητα από τον 8c (curl στο torvalds/linux master, 27 Σεπ).** Το `gfx_v7_0.c:3169-3177`
  (`gfx_v7_0_ring_emit_init_cond_exec`) και το `gfx_v8_0.c:6229` γράφουν `PACKET3(COND_EXEC, 3)`, addr lo, addr hi, **0**,
  exec count. Το `pm4_cmds.h:1218` του shadPS4 διαβάζει το exec_count από το 3ο body dword, δηλαδή το 0. Άρα σε ψευδή
  συνθήκη δεν παραλείπεται τίποτα.
  - Fix (όταν το ζητήσει ο χρήστης): διάβασε το ΤΕΛΕΥΤΑΙΟ body dword. Καλύπτει και τη μορφή των 4 και τη μορφή των 5
    dwords.
  - ΑΓΝΩΣΤΟ ακόμα αν το GT7 στέλνει καθόλου COND_EXEC· το πρώτο πράγμα που μετρά το TEST17e.

**27 Σεπ 16:59 — TEST18 χτίστηκε (38): το build του PR, «today's main + our fixes».** Απόφαση χρήστη· ο χρήστης ακύρωσε και
τους ελέγχους GoW/GoT γι' αυτό το PR.
- Branch `test18-prfault` @ b5fa4401 = caeb240d (origin/main 27 Σεπ) + e6643c25 + 19 commits του TEST17d.
- Το e6643c25 (`fault-probe-page`) είναι ΤΟ commit του PR: «page_manager: Keep the fault probe within the faulting page»,
  με patch-id ίδιο με το 92d09f22.
- Έλεγχος 8c: ΟΚ. Τα patch-ids είναι ίδια, το page_manager είναι ίδιο με του test17d, και κανένα upstream PR ή issue δεν
  αφορά το ίδιο σημείο. Λεπτομέρειες στο [[gt7-shadps4-auditor-handoff]].
- Διαφορές από το TEST17d:
  - #5145 (vertex shaders· το warm cache κρατά το παλιό SPIR-V τους)·
  - #5128 vdecsw (εκτός της διαδρομής video του GT7)·
  - #5138 (μόνο macOS)·
  - float-mode με τον κώδικα του upstream (ίδιες τιμές).
- ⚠ Symbolize παλιών runs ΜΟΝΟ από exe + pdb δίπλα-δίπλα. Με το backup exe, το RIP του r4 έδωσε σιωπηλά `XXH3_64bits_digest`
  αντί για `ZydisInputPeek` ([[llvm-symbolizer-pdb-mismatch-silent]]).
- **TEST18 r1-r6 (17:04-17:17).** Όλα αρχειοθετημένα, cmp IDENTICAL. Αναλυτικά στο [[gt7-shadps4-auditor-handoff]].
  - r1: AV στην πλευρά του παιχνιδιού, στο TopRootWindow.
  - r2: PM4 type 0, IB βάθους ≥43.
  - r3: ο handler του emulator έσκασε στο `ZydisInputPeek` (ίδια κατηγορία με το TEST17d r4).
  - r4: PM4 type 0, IB βάθους 6, το backtrace πλήρες (resume στο liverpool.cpp:805, όχι :809).
  - r5: έφτασε στον αγώνα και πέθανε στο ΝΕΟ `liverpool_to_vk.cpp:428 ComponentSwizzle`. Το T# πέρασε όλους τους ελέγχους
    του BindTextures με dst_sel 2 ή 3 (reserved).
  - **r6: GT_FAULTEND ×2 στο 0x2077ffffc στον αγώνα, και το run συνέχισε. ΤΟ COMMIT ΤΟΥ PR e6643c25 ΔΟΥΛΕΥΕΙ ΠΑΝΩ ΣΤΟ
    caeb240d.** Μετά, GPU exception (nvlddmkm 13/13/153) → device lost στο vk_scheduler.cpp:242. Αυτό υπήρχε και πριν από
    το fix.
- **27 Σεπ ~17:25 — fault-probe-page στο `mine` (push από τον 38, με εντολή του χρήστη).** Head = e6643c25 (έλεγχος 8c: ls-remote,
  ένας γονιός caeb240d, clang-format 19.1.5 = 0 αλλαγές στο αρχείο του commit). Τίποτα άλλο δεν έγινε push. Το PR το ανοίγει
  και το γράφει ο χρήστης.
- **27 Σεπ ~17:58 — upstream PR #5150** (το άνοιξε ο χρήστης, με δικό του κείμενο): «page_manager: Keep the fault probe within
  the faulting page». Head e6643c25 = `mine/fault-probe-page`, 1 commit, +4/-2.
  - CI στις 18:04 (8c, public API): 10 check runs, 3 success, 7 σε εξέλιξη, 0 αποτυχίες.
  - Αν ρωτήσει maintainer τι είχε το TEST18: #5114, #5131, #5137, και τρία τοπικά T# guards που δεν ανήκουν σε κανένα PR
    (72320ba4 formats, 494a78d1 tile mode, 5dc75198 zero size). Επαληθευμένα ότι είναι στο test18-prfault.
- **27 Σεπ ~18:20 — review του squidbus στο #5137** (15:21Z, vk_rasterizer.cpp:961): «move this to a function like `Valid()`
  inside `Sampler`». Ο χρήστης απάντησε στο GitHub «ok i will make the changes test and update the pr». Στον 8c: «make it happen
  and test it simultaneously with the other 3 local fixes». ΤΟ ΕΙΧΑΜΕ ΠΡΟΒΛΕΨΕΙ (γρ. ~200: stub `Sampler::Valid()` που επέστρεφε true).
  - Rework (38, πρόταση 8c): **d2a0e3ed** στο e518a651, local `sampler-catch-all`. **PUSHED** (εντολή χρήστη «push the changes to
    pr 5137»): force-with-lease πάνω στο 95b03670 (3 Update-branch merges + a053b271, κανένα commit maintainer)· το API δείχνει
    head d2a0e3ed, 1 commit, 2 αρχεία, +14/-1. Το #5114 (75f39d66) ΔΕΝ ζητήθηκε — μένει unpushed.
    - `Valid()` = `max_aniso <= Sixteen && filter_mode <= Max && mip_filter <= Linear`. Χωρίς magic_enum σε header· ισοδύναμο,
      γιατί τα enums πάνε 0..N χωρίς κενά.
    - Ο έλεγχος Custom + ta_bc_base==0 μένει στο BindTextures (register). +14/-1, μόνο τίτλος, clang-format 0.
  - **#5114: CONFLICT στο GitHub** (dirty) από το #5031 (15:05Z, test_gcn_instructions.cpp). Λύση έτοιμη: το ΕΝΑ λυμένο commit
    75f39d66 (= 65b739ed), με ίδιες όλες τις +/- γραμμές με το 11d8b765. Force-push μόνο με εντολή χρήστη, και fetch mine πρώτα
    (τα local mine/* είναι πίσω από τα Update-branch).
  - **TEST19b** = test19b-prcheck **4ce4d7fb** (main e518a651 + 4 PR + 3 τοπικά), exe B2D44157…5F50, launchers
    `TEST19B_{GT7,GOW,GOT}_4ce4d7fb_{cold,warm}.bat`. Το TEST19 51ae31cf δεν έτρεξε ποτέ. Λεπτομέρειες ελέγχου στο
    [[gt7-shadps4-auditor-handoff]]. ⚠ Η γραμμή έκδοσης στο log λέει ακόμα «test18-prfault gb5fa4401» (χωρίς reconfigure).
- **27 Σεπ 18:38-18:50 — TEST19b, 6 runs.**
  - GT7: r1 (κρύο) έπεσε σε assert SurfaceFormat 19/9 (σκουπίδι T#, αυτό που απέρριπτε το 72320ba4). r2 (ζεστό) έφτασε στον
    αγώνα και τελείωσε σε TDR (13/13/153, το γνωστό). Ο χρήστης: «gt7 warm fixed the fps». Τα 2-8 FPS του r1 ήταν η κρύα
    cache (546 compiles).
  - GoW: σταματά στο DS_ORDERED_COUNT, αναμενόμενο.
  - GoT: περνά τα παλιά crashes (το #5129 του upstream) και φτάνει μετά το splash. Εκεί πέφτει στο cs 0x14906b6a / pipeline
    0x98170c4bfeeeaffe: **άκυρο SPIR-V**, γιατί το `uses_fp64` μπαίνει μόνο για Pack/UnpackDouble2x32
    (shader_info_collection_pass.cpp), άρα κανένας τύπος F64. Ο driver της NVIDIA κάνει AV στο compile. Bug του upstream,
    υποψήφιο PR, αποφασίζει ο χρήστης.
  - **#5137 push** (38): d2a0e3ed, 1 commit, στο e518a651. Το #5114 περιμένει (conflict).
    - GT7 runs: _1 cold 110 s → assert `SurfaceFormat` data_format=19 num_format=9 (μόνο στην κονσόλα, t0107s· το αρχείο κόπηκε)
      στο BuddyWindowRoot — το guard 72320ba4 λείπει εκ σχεδιασμού· ΔΕΝ ξαναβγήκε στο _2 = εξαρτάται από κατάσταση. _2 warm 126 s →
      InRaceRoot, ~62 s αγώνας, μετά nvlddmkm 13/13/153 + 0xC0000005 = το γνωστό device-lost (TEST18 r6). #5137: 352 S# απορρίφθηκαν
      χωρίς πρόβλημα· preload (warm cache) + tess (12 hs) εκτελέστηκαν. FPS 2-9 = race compiles (446/544) + ~1500 clamp log/s (<Error>).
      Επόμενα: GoW/GoT (armed από 8c) + test19b_gt7_3 (επανάληψη warm) — τα διαλέγει ο χρήστης.
- **27 Σεπ 20:30 — TEST20 = τρία leave-one-out του TEST19b, μόνο GT7** (έγκριση χρήστη, μέσω 38). test20a = 4ce4d7fb − BC
  (branch test20a-nobc 4cd5cb68, έλεγχος 8c ΟΚ: ακριβές inverse), test20b = 4ce4d7fb − preload, test20c = 4ce4d7fb − tess.
  Control = test19b_gt7_2, αφού κάθε launcher επαναφέρει save A + `cache_input_warm_20260927_184409` (1520 αρχεία).
  ⚠ Η live cache έχει το hs 0x27d2194a compile-αρισμένο ΜΕ το tess fix, και η cache δεν ξέρει ποιο build έγραψε ένα SPIR-V
  (profile.bin + σταθερές εκδόσεων). Άρα ο restore ΠΡΕΠΕΙ να είναι /MIR, αλλιώς το test20c φορτώνει το διορθωμένο shader
  και «περνά» ψευδώς. Λεπτομέρειες: [[gt7-shadps4-auditor-handoff]].
