# THE RED MAP HUNT (run 226 lane). Dump EVERY plausible 2D color texture of the capture as a
# PNG + one manifest line (dims, format, creation flags, and the compressed GetUsage list:
# who clears/writes/reads it, at which eids). rank_red.py (system python + PIL) then ranks
# the PNGs by red-dominance; the red MAP texture's manifest line names its producer draws.
#
# Launch (PowerShell):
#   $env:RDC_CAP = "<capture.rdc>"; $env:RDC_OUT = "<out dir>"
#   & "C:\Program Files\RenderDoc\qrenderdoc.exe" --python analyze12_redmap.py
# or paste into qrenderdoc's Interactive Python Shell with the capture open:
#   import os; os.environ["RDC_OUT"]=r"...out dir..."; exec(open(r"...this file...", encoding="utf-8").read())
#
# API notes (RenderDoc 1.45, learned by analyze1-11): GetReadOnlyResources returns
# UsedDescriptor; resource names come from GetResources(); os.environ.get's DEFAULT ARG must
# never touch __file__ (eager eval NameErrors in exec context).
import json
import os

import renderdoc as rd

OUT = os.environ.get("RDC_OUT", r"C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\rdc\out_redmap")
CAP = os.environ.get("RDC_CAP", "")
os.makedirs(OUT, exist_ok=True)

log_lines = []


def log(s):
    log_lines.append(str(s))
    print(s)


def run(controller):
    res_names = {}
    for r in controller.GetResources():
        res_names[r.resourceId] = r.name

    manifest = []
    textures = controller.GetTextures()
    log("textures in capture: %d" % len(textures))

    saved = 0
    for t in textures:
        # 2D, color-plausible, UI/map-sized. Depth formats and 3D volumes are not the map.
        # ⚠ the type field is `.type` (TextureType enum); `.dimension` is a bare int and the
        # first run compared it against the enum - 790 textures, 0 candidates, no error.
        tt = getattr(t, "type", None)
        if tt not in (rd.TextureType.Texture2D, rd.TextureType.Texture2DArray,
                      rd.TextureType.Texture2DMS, rd.TextureType.Texture2DMSArray):
            continue
        if t.width < 32 or t.height < 32 or t.width > 4096 or t.height > 4096:
            continue
        fmt = t.format.Name()
        if "D16" in fmt or "D24" in fmt or "D32" in fmt or "S8" in fmt:
            continue

        # usage census: the manifest's real payload. Compressed: usage kind -> [eids...]
        usage = {}
        try:
            for u in controller.GetUsage(t.resourceId):
                k = str(u.usage).split(".")[-1]
                usage.setdefault(k, []).append(u.eventId)
        except Exception as e:
            usage = {"usage_failed": [str(e)]}
        for k in usage:
            if isinstance(usage[k], list) and len(usage[k]) > 12:
                usage[k] = usage[k][:6] + ["..%d total.." % len(usage[k])] + usage[k][-2:]

        # minmax on mip 0 - cheap red hint straight in the manifest
        mm = ""
        try:
            mn, mx = controller.GetMinMax(t.resourceId, rd.Subresource(0, 0, 0),
                                          rd.CompType.Typeless)
            mm = "min(%.3g %.3g %.3g %.3g) max(%.3g %.3g %.3g %.3g)" % (
                mn.floatValue[0], mn.floatValue[1], mn.floatValue[2], mn.floatValue[3],
                mx.floatValue[0], mx.floatValue[1], mx.floatValue[2], mx.floatValue[3])
        except Exception as e:
            mm = "minmax failed: %s" % e

        # pick the mip that fits <=512 px so the PNG stays small but roads stay visible
        mip = 0
        w, h = t.width, t.height
        while max(w, h) > 512 and mip + 1 < t.mips:
            mip += 1
            w //= 2
            h //= 2
        png = "tex_%s.png" % str(t.resourceId).replace("::", "_").replace(" ", "")
        try:
            ts = rd.TextureSave()
            ts.resourceId = t.resourceId
            ts.mip = mip
            ts.alpha = rd.AlphaMapping.Discard
            ts.destType = rd.FileType.PNG
            controller.SaveTexture(ts, os.path.join(OUT, png))
            saved += 1
        except Exception as e:
            png = "save failed: %s" % e

        manifest.append({
            "id": str(t.resourceId),
            "name": res_names.get(t.resourceId, ""),
            "dims": "%dx%dx%d ms%d mips%d" % (t.width, t.height, t.arraysize, t.msSamp, t.mips),
            "fmt": fmt,
            "flags": str(t.creationFlags),
            "minmax": mm,
            "png": png,
            "usage": usage,
        })

    log("candidates: %d, PNGs saved: %d" % (len(manifest), saved))
    with open(os.path.join(OUT, "manifest.json"), "w") as f:
        json.dump(manifest, f, indent=1)


if CAP:
    opts = rd.ReplayOptions()
    pyrenderdoc.LoadCapture(CAP, opts, CAP, False, True)
pyrenderdoc.Replay().BlockInvoke(run)

with open(os.path.join(OUT, "analysis12.txt"), "w") as f:
    f.write("\n".join(log_lines))

# command-line runs exit; a pasted run keeps the app (RDC_STAY=1 to keep it either way)
if os.environ.get("RDC_STAY", "") != "1":
    import PySide2.QtWidgets
    PySide2.QtWidgets.QApplication.instance().quit()
