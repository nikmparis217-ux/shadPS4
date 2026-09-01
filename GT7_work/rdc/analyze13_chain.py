# RUN 226: name the red-map producer and the wash mechanism.
# analyze12 found (a) an R16F chain (137585 1080p -> 43945 960x540, content CONSTANT 1.0;
# plus 43223 720x540 constant -0.00883) and (b) the capture-4 accumulator pair
# (13740/13746 RGBA16F) still oscillating with channels at the FP16 ceiling.
# This script answers: what WRITES the constant 1.0, what the readers DRAW INTO, and which
# texture the on-screen MAP quad samples (via the last swapchain-writing draws' PS inputs).
#
# Launch: $env:RDC_CAP / $env:RDC_OUT + qrenderdoc --python (same as analyze12).
import json
import os

import renderdoc as rd

OUT = os.environ.get("RDC_OUT", r"C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\rdc\out_redmap226")
CAP = os.environ.get("RDC_CAP", "")

log_lines = []


def log(s):
    log_lines.append(str(s))
    print(s)


# the R16F chain + accumulator usage points from analyze12's manifest
FOCUS = [15183, 15192, 15245, 15349, 15350, 15354, 15355, 15357, 15358,
         15372, 15379, 15384, 15396, 15407, 15456, 15466]
SUSPECTS = {"43223", "43945", "137585", "13740", "13746"}


def run(controller):
    sf = controller.GetStructuredFile()
    res_names = {}
    for r in controller.GetResources():
        res_names[r.resourceId] = r.name

    textures = {t.resourceId: t for t in controller.GetTextures()}

    def rid_str(rid):
        return str(rid).replace("ResourceId::", "")

    def tex_desc(rid):
        t = textures.get(rid)
        if not t:
            return rid_str(rid)
        return "%s %dx%d %s" % (rid_str(rid), t.width, t.height, t.format.Name())

    # ---- 1. flat action list; find the frame slice containing FOCUS, plus the frame tail
    flat = []

    def walk(actions):
        for a in actions:
            flat.append(a)
            if a.children:
                walk(a.children)

    walk(controller.GetRootActions())
    log("total actions: %d, last eid: %d" % (len(flat), flat[-1].eventId if flat else -1))

    # swapchain / presented texture: creationFlags has SwapBuffer
    swap_ids = [rid for rid, t in textures.items()
                if t.creationFlags & rd.TextureCategory.SwapBuffer]
    log("swapchain textures: %s" % [rid_str(r) for r in swap_ids])

    # ---- 2. context dump around the focus window (no SetFrameEvent: cheap fields only)
    log("")
    log("== action window eid 15150..15500 ==")
    for a in flat:
        if a.eventId < 15150 or a.eventId > 15500:
            continue
        name = a.GetName(sf)
        outs = [rid_str(o) for o in a.outputs if o != rd.ResourceId.Null()]
        extra = ""
        if a.copySource != rd.ResourceId.Null() or a.copyDestination != rd.ResourceId.Null():
            extra = " copy %s -> %s" % (tex_desc(a.copySource), tex_desc(a.copyDestination))
        mark = " <<<" if a.eventId in FOCUS else ""
        log("eid %5d %-24s out=%s%s | %s%s" % (
            a.eventId, str(a.flags).replace("ActionFlags.", ""), outs, extra, name[:110], mark))

    # ---- 3. deep state at the focus eids: viewport, outputs, PS-bound textures (+minmax)
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
            t = textures.get(rid)
            mm = ""
            if t is not None:
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

    def dump_state(eid, tag):
        log("")
        log("-- eid %d (%s) --" % (eid, tag))
        controller.SetFrameEvent(eid, True)
        pipe = controller.GetPipelineState()
        try:
            vp = pipe.GetViewport(0)
            log("  viewport: %.0f,%.0f %dx%d" % (vp.x, vp.y, vp.width, vp.height))
        except Exception as e:
            log("  viewport: n/a (%s)" % e)
        try:
            outs = pipe.GetOutputTargets()
            for o in outs:
                if o.resource != rd.ResourceId.Null():
                    log("  out: %s" % tex_desc(o.resource))
        except Exception as e:
            log("  outputs failed: %s" % e)
        try:
            ps = pipe.GetShader(rd.ShaderStage.Pixel)
            log("  ps: %s entry=%s" % (rid_str(ps), pipe.GetShaderEntryPoint(rd.ShaderStage.Pixel)))
        except Exception:
            pass
        for row in ps_inputs(eid):
            log(row)

    log("")
    log("== deep state at focus eids ==")
    for eid in [15192, 15245, 15372, 15379, 15407, 15466]:
        dump_state(eid, "R16F chain")

    # ---- 4. the frame tail: last 40 draws — the UI composite. Which draw samples a red tex?
    log("")
    log("== frame tail: last 40 draws, PS inputs ==")
    draws = [a for a in flat if a.flags & rd.ActionFlags.Drawcall]
    for a in draws[-40:]:
        outs = [rid_str(o) for o in a.outputs if o != rd.ResourceId.Null()]
        log("")
        log("eid %5d out=%s | %s" % (a.eventId, outs, a.GetName(sf)[:100]))
        for row in ps_inputs(a.eventId):
            log(row)

    # ---- 5. who reads the accumulator pair late in the frame
    log("")
    log("== accumulator readers (13740 / 13746) ==")
    for rid, t in textures.items():
        if rid_str(rid) not in ("13740", "13746"):
            continue
        try:
            for u in controller.GetUsage(rid):
                log("  %s: eid %d %s" % (rid_str(rid), u.eventId,
                                         str(u.usage).split(".")[-1]))
        except Exception as e:
            log("  usage failed: %s" % e)


if CAP:
    opts = rd.ReplayOptions()
    pyrenderdoc.LoadCapture(CAP, opts, CAP, False, True)
pyrenderdoc.Replay().BlockInvoke(run)

with open(os.path.join(OUT, "analysis13.txt"), "w") as f:
    f.write("\n".join(log_lines))

if os.environ.get("RDC_STAY", "") != "1":
    import PySide2.QtWidgets
    PySide2.QtWidgets.QApplication.instance().quit()
