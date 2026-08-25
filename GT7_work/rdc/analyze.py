# qrenderdoc --python analyze.py
# Walks the capture, dumps the frame structure, saves the bound colour target at ~24
# checkpoints across the frame, and records GetMinMax of each target - the question is
# WHERE the white appears and what scale the HDR buffer really holds.
import os
import renderdoc as rd

OUT = r"C:\Users\-user-\Documents\GitHub\shadPS4\GT7_work\rdc\out"
CAP = os.environ.get("RDC_CAP", r"C:\Users\-user-\AppData\Roaming\shadPS4\captures\CUSA24769_capture.rdc")

# The Greek username survives better fetched from the env than typed into a source file.
OUT = os.path.join(os.path.dirname(os.path.abspath(os.environ.get("RDC_SELF", __file__))), "out")
os.makedirs(OUT, exist_ok=True)

log_lines = []


def log(s):
    log_lines.append(str(s))


def flatten(actions, out):
    for a in actions:
        out.append(a)
        if len(a.children) > 0:
            flatten(a.children, out)


def run(controller):
    sf = controller.GetStructuredFile()
    textures = {t.resourceId: t for t in controller.GetTextures()}

    all_actions = []
    flatten(controller.GetRootActions(), all_actions)
    leaf = [a for a in all_actions if len(a.children) == 0]
    interesting = [a for a in leaf
                   if a.flags & (rd.ActionFlags.Drawcall | rd.ActionFlags.Dispatch |
                                 rd.ActionFlags.Clear | rd.ActionFlags.Copy |
                                 rd.ActionFlags.Present)]
    log("total actions %d, leaves %d, interesting %d" % (
        len(all_actions), len(leaf), len(interesting)))

    # frame structure: markers only
    for a in all_actions:
        if a.flags & rd.ActionFlags.PushMarker:
            log("MARKER eid %d: %s" % (a.eventId, a.GetName(sf)))

    n = len(interesting)
    step = max(1, n // 24)
    picks = interesting[::step]
    if interesting and picks[-1].eventId != interesting[-1].eventId:
        picks.append(interesting[-1])

    for idx, a in enumerate(picks):
        eid = a.eventId
        controller.SetFrameEvent(eid, True)
        pipe = controller.GetPipelineState()
        outs = [o for o in pipe.GetOutputTargets() if o.resource != rd.ResourceId.Null()]
        name = a.GetName(sf)
        if not outs:
            log("chk %02d eid %d [%s] no colour target" % (idx, eid, name[:70]))
            continue
        res = outs[0].resource
        tex = textures.get(res)
        dims = "%dx%d %s" % (tex.width, tex.height, tex.format.Name()) if tex else "?"
        try:
            mn, mx = controller.GetMinMax(res, rd.Subresource(0, 0, 0), rd.CompType.Typeless)
            stat = "min(%.4g %.4g %.4g %.4g) max(%.4g %.4g %.4g %.4g)" % (
                mn.floatValue[0], mn.floatValue[1], mn.floatValue[2], mn.floatValue[3],
                mx.floatValue[0], mx.floatValue[1], mx.floatValue[2], mx.floatValue[3])
        except Exception as e:
            stat = "minmax failed: %s" % e
        log("chk %02d eid %d [%s] target %s %s | %s" % (idx, eid, name[:70], res, dims, stat))
        try:
            ts = rd.TextureSave()
            ts.resourceId = res
            ts.mip = 0
            ts.alpha = rd.AlphaMapping.Discard
            ts.destType = rd.FileType.PNG
            controller.SaveTexture(ts, os.path.join(OUT, "chk_%02d_eid%d.png" % (idx, eid)))
        except Exception as e:
            log("  save failed: %s" % e)

    with open(os.path.join(OUT, "analysis.txt"), "w") as f:
        f.write("\n".join(log_lines))


cap_path = CAP
opts = rd.ReplayOptions()
res = pyrenderdoc.LoadCapture(cap_path, opts, cap_path, False, True)
pyrenderdoc.Replay().BlockInvoke(run)

with open(os.path.join(OUT, "analysis.txt"), "w") as f:
    f.write("\n".join(log_lines))

import PySide2.QtWidgets
PySide2.QtWidgets.QApplication.instance().quit()
