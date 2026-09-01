# Act 11: the paused-frame oscillation hunt. For the OPEN capture, find and report:
#  - every 64x64x64 texture (the grading LUT double-buffer pair): full usage list
#    (who writes it, who reads it, at which eids) + end-of-frame min/max content;
#  - every tiny (<=8x8) texture (the 4x4 RGBA16F per-frame bake target, slot 0 of
#    cs_a95f906e): usage + ALL texel values at end of frame;
#  - every wide 1D curve (8192x1): usage + min/max;
#  - the draw that READS the LUT (the output transform): its output target min/max.
# Output: GT7_work/rdc/out6/<capture-name>.txt - run once per capture, diff the files.
# Paste line (Python Shell inside qrenderdoc):
#   import os; os.environ["RDC_SELF"]=r"C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\rdc\analyze6_pair.py"; exec(open(os.environ["RDC_SELF"], encoding="utf-8").read())
import os
import struct
import renderdoc as rd

SELF = os.environ["RDC_SELF"]
OUT = os.path.join(os.path.dirname(os.path.abspath(SELF)), "out6")
os.makedirs(OUT, exist_ok=True)
try:
    capname = os.path.splitext(os.path.basename(pyrenderdoc.GetCaptureFilename()))[0]
except Exception:
    capname = "capture_unknown"
open(os.path.join(OUT, "started_%s.txt" % capname), "w").write("entered")

log_lines = []


def log(s):
    log_lines.append(str(s))


def flatten(actions, out):
    for a in actions:
        out.append(a)
        if len(a.children) > 0:
            flatten(a.children, out)


def fmt_mm(controller, res):
    try:
        mn, mx = controller.GetMinMax(res, rd.Subresource(0, 0, 0), rd.CompType.Typeless)
        return "min(%.4g %.4g %.4g %.4g) max(%.4g %.4g %.4g %.4g)" % (
            mn.floatValue[0], mn.floatValue[1], mn.floatValue[2], mn.floatValue[3],
            mx.floatValue[0], mx.floatValue[1], mx.floatValue[2], mx.floatValue[3])
    except Exception as e:
        return "minmax failed: %s" % e


def run(controller):
    textures = {t.resourceId: t for t in controller.GetTextures()}
    all_actions = []
    flatten(controller.GetRootActions(), all_actions)
    last_eid = max((a.eventId for a in all_actions), default=0)
    log("capture %s: %d actions, last eid %d" % (capname, len(all_actions), last_eid))

    lut_ids, tiny_ids, curve_ids = [], [], []
    for rid, t in textures.items():
        if t.width == 64 and t.height == 64 and t.depth == 64:
            lut_ids.append(rid)
        elif t.width <= 8 and t.height <= 8 and t.depth <= 1 and t.mips <= 1:
            tiny_ids.append(rid)
        elif t.width >= 4096 and t.height == 1:
            curve_ids.append(rid)
    log("found: %d LUT64, %d tiny(<=8x8), %d curve" % (len(lut_ids), len(tiny_ids), len(curve_ids)))

    lut_read_eids = []

    def report(rid, tag, want_read_eids=False):
        t = textures[rid]
        log("")
        log("%s %s %dx%dx%d arr%d %s" % (tag, rid, t.width, t.height, t.depth,
                                         t.arraysize, t.format.Name()))
        try:
            us = controller.GetUsage(rid)
            n_write = 0
            for u in us:
                s = str(u.usage)
                is_write = ("RW" in s) or ("Write" in s) or ("Clear" in s) or \
                           ("CopyDst" in s) or ("ColorTarget" in s) or ("Resolve" in s)
                if is_write:
                    n_write += 1
                if want_read_eids and "Resource" in s and not is_write:
                    lut_read_eids.append(u.eventId)
            log("  usage: %d events, %d WRITE-ish" % (len(us), n_write))
            for u in us[:48]:
                log("    eid %d %s" % (u.eventId, str(u.usage).replace("ResourceUsage.", "")))
            if len(us) > 48:
                log("    ... %d more" % (len(us) - 48))
        except Exception as e:
            log("  usage failed: %s" % e)
        controller.SetFrameEvent(last_eid, True)
        log("  content@end: %s" % fmt_mm(controller, rid))

    for rid in lut_ids:
        report(rid, "LUT64", want_read_eids=True)
    for rid in curve_ids:
        report(rid, "CURVE")
    for rid in tiny_ids:
        t = textures[rid]
        # only float-ish tiny textures are interesting; skip depth/stencil helpers
        name = t.format.Name()
        if "16" not in name and "32" not in name:
            continue
        report(rid, "TINY")
        try:
            controller.SetFrameEvent(last_eid, True)
            data = bytes(controller.GetTextureData(rid, rd.Subresource(0, 0, 0)))
            n = t.width * t.height * 4
            if "R16G16B16A16" in name and len(data) >= n * 2:
                vals = struct.unpack("<%de" % n, data[:n * 2])
                for row in range(t.height):
                    px = []
                    for col in range(t.width):
                        i = (row * t.width + col) * 4
                        px.append("(%.4g %.4g %.4g %.4g)" % tuple(vals[i:i + 4]))
                    log("    px row%d: %s" % (row, " ".join(px)))
            else:
                log("    raw first 64 bytes: %s" % data[:64].hex())
        except Exception as e:
            log("    pixeldump failed: %s" % e)

    # the output transform = the draw(s) that READ a 64^3 LUT
    for eid in sorted(set(lut_read_eids))[:6]:
        try:
            controller.SetFrameEvent(eid, True)
            pipe = controller.GetPipelineState()
            outs = [o for o in pipe.GetOutputTargets() if o.resource != rd.ResourceId.Null()]
            for o in outs[:2]:
                t = textures.get(o.resource)
                dims = "%dx%d %s" % (t.width, t.height, t.format.Name()) if t else "?"
                log("")
                log("TRANSFORM draw eid %d -> out %s %s | %s" % (
                    eid, o.resource, dims, fmt_mm(controller, o.resource)))
        except Exception as e:
            log("transform eid %d failed: %s" % (eid, e))

    with open(os.path.join(OUT, "%s.txt" % capname), "w") as f:
        f.write("\n".join(log_lines))


pyrenderdoc.Replay().BlockInvoke(run)

with open(os.path.join(OUT, "%s.txt" % capname), "w") as f:
    f.write("\n".join(log_lines))
