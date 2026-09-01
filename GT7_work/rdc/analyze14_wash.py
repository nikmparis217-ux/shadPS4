# RUN 226 part 2: (a) prove/refute the depth-alias theory - the sampled depth 14685 reads
# constant 1.0 (clear value) while the scene's silhouettes are correct, so the rasterizer's
# depth must live in a DIFFERENT image for the same guest address; (b) the TAA resolve's
# inputs (eid 15347 writes 13746+42974 reading history 13740 - where does the per-channel
# G/B corruption enter?); (c) THE MAP HUNT - every draw into the UI target 4883: which one
# samples red content (the red map square on the Music Rally menu).
#
# Launch: $env:RDC_CAP / $env:RDC_OUT + qrenderdoc --python (same as analyze12/13).
import json
import os

import renderdoc as rd

OUT = os.environ.get("RDC_OUT", r"C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\rdc\out_redmap226")
CAP = os.environ.get("RDC_CAP", "")

log_lines = []


def log(s):
    log_lines.append(str(s))
    print(s)


def run(controller):
    sf = controller.GetStructuredFile()
    textures = {t.resourceId: t for t in controller.GetTextures()}
    res_names = {}
    for r in controller.GetResources():
        res_names[r.resourceId] = r.name

    def rid_str(rid):
        return str(rid).replace("ResourceId::", "")

    def tex_desc(rid):
        t = textures.get(rid)
        if not t:
            return rid_str(rid)
        return "%s %dx%d %s" % (rid_str(rid), t.width, t.height, t.format.Name())

    def usage_str(rid):
        rows = []
        try:
            for u in controller.GetUsage(rid):
                rows.append("%d:%s" % (u.eventId, str(u.usage).split(".")[-1]))
        except Exception as e:
            rows.append("usage failed: %s" % e)
        if len(rows) > 30:
            rows = rows[:15] + ["..%d total.." % len(rows)] + rows[-10:]
        return " ".join(rows)

    # ---- (a) every depth-format texture: guest address (in the name) + usage kinds.
    # The alias theory predicts: 14685 has Clear + PS_Resource but NO DepthStencilTarget,
    # while ANOTHER depth image at the SAME guest address carries the scene's DS usage.
    log("== depth images: name (guest addr) + usage ==")
    for rid, t in textures.items():
        fmt = t.format.Name()
        if not ("D16" in fmt or "D24" in fmt or "D32" in fmt):
            continue
        log("%s %dx%d %s | %s" % (rid_str(rid), t.width, t.height, fmt,
                                  res_names.get(rid, "")[:90]))
        log("    %s" % usage_str(rid))

    # ---- (b) TAA resolve inputs + the scene buffer 42974's writers
    def ps_inputs(eid):
        controller.SetFrameEvent(eid, True)
        pipe = controller.GetPipelineState()
        rows = []
        try:
            ro = pipe.GetReadOnlyResources(rd.ShaderStage.Pixel)
        except Exception as e:
            return ["GetReadOnlyResources failed: %s" % e]
        for u in ro:
            rid = u.descriptor.resource
            if rid == rd.ResourceId.Null():
                continue
            mm = ""
            if rid in textures:
                try:
                    mn, mx = controller.GetMinMax(rid, rd.Subresource(0, 0, 0),
                                                  rd.CompType.Typeless)
                    mm = " min(%.3g %.3g %.3g %.3g) max(%.3g %.3g %.3g %.3g)" % (
                        mn.floatValue[0], mn.floatValue[1], mn.floatValue[2], mn.floatValue[3],
                        mx.floatValue[0], mx.floatValue[1], mx.floatValue[2], mx.floatValue[3])
                except Exception:
                    pass
            sw = ""
            try:
                s = u.descriptor.swizzle
                sw = " swz=%s%s%s%s" % (s.red, s.green, s.blue, s.alpha)
                sw = sw.replace("TextureSwizzle.", "")
            except Exception:
                pass
            rows.append("    ps_tex %s%s%s" % (tex_desc(rid), sw, mm))
        return rows

    log("")
    log("== TAA resolve eid 15347 (writes 13746 + 42974, history 13740) ==")
    for row in ps_inputs(15347):
        log(row)

    log("")
    log("== scene buffer usages ==")
    for target in ("42974", "13728", "13740", "13746"):
        for rid in textures:
            if rid_str(rid) == target:
                log("%s | %s" % (tex_desc(rid), usage_str(rid)))

    # ---- (c) THE MAP HUNT: all draws whose color target is the UI RT 4883.
    flat = []

    def walk(actions):
        for a in actions:
            flat.append(a)
            if a.children:
                walk(a.children)

    walk(controller.GetRootActions())

    ui_rid = None
    for rid in textures:
        if rid_str(rid) == "4883":
            ui_rid = rid
    ui_draws = [a for a in flat
                if (a.flags & rd.ActionFlags.Drawcall) and any(
                    rid_str(o) == "4883" for o in a.outputs)]
    log("")
    log("== UI draws into 4883: %d ==" % len(ui_draws))
    # compact: one line per draw with sampled tex ids; RED VERDICT per texture via minmax
    # (maxR high while maxG and maxB near zero). Constant-white alpha atlases are normal.
    red_cache = {}

    def red_mark(rid):
        if rid in red_cache:
            return red_cache[rid]
        mark = ""
        try:
            mn, mx = controller.GetMinMax(rid, rd.Subresource(0, 0, 0), rd.CompType.Typeless)
            if mx.floatValue[0] > 0.5 and mx.floatValue[1] < 0.1 and mx.floatValue[2] < 0.1:
                mark = "<RED max(%.3g %.3g %.3g)>" % (
                    mx.floatValue[0], mx.floatValue[1], mx.floatValue[2])
        except Exception:
            pass
        red_cache[rid] = mark
        return mark

    for a in ui_draws:
        controller.SetFrameEvent(a.eventId, True)
        pipe = controller.GetPipelineState()
        ids = []
        try:
            for u in pipe.GetReadOnlyResources(rd.ShaderStage.Pixel):
                rid = u.descriptor.resource
                if rid == rd.ResourceId.Null():
                    continue
                t = textures.get(rid)
                dim = "%dx%d" % (t.width, t.height) if t else "?"
                ids.append("%s(%s)%s" % (rid_str(rid), dim, red_mark(rid)))
        except Exception as e:
            ids.append("err:%s" % e)
        log("eid %5d | %s" % (a.eventId, " ".join(ids) if ids else "-"))


if CAP:
    opts = rd.ReplayOptions()
    pyrenderdoc.LoadCapture(CAP, opts, CAP, False, True)
pyrenderdoc.Replay().BlockInvoke(run)

with open(os.path.join(OUT, "analysis14.txt"), "w") as f:
    f.write("\n".join(log_lines))

if os.environ.get("RDC_STAY", "") != "1":
    import PySide2.QtWidgets
    PySide2.QtWidgets.QApplication.instance().quit()
