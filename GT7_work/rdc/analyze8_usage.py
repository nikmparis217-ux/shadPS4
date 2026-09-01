# Act 12: the wash is auto-exposure railed to the top - all four run-183 captures show the
# scene ENTERING the output transform at half-float max (65020) while two of the transform's
# inputs are dead flat: the 1920x1080 RGBA16F at 0x100ee50000 (all zeros - the suspected
# previous-frame/measurement source) and the 1x1 R8 at 0x1000e33200 (zero). This script asks
# the capture WHO TOUCHES each suspect: every (eventId, usage) pair RenderDoc recorded, with
# the action's name, plus - for the scene - the last writer before the transform and THAT
# pass's fragment inputs (the exposure factor has to come through one of them).
# Paste line (Python Shell inside qrenderdoc):
#   import os; os.environ["RDC_SELF"]=r"C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\rdc\analyze8_usage.py"; exec(open(os.environ["RDC_SELF"], encoding="utf-8").read())
import os
import renderdoc as rd

SELF = os.environ["RDC_SELF"]
OUT = os.path.join(os.path.dirname(os.path.abspath(SELF)), "out7")
os.makedirs(OUT, exist_ok=True)
try:
    capname = os.path.splitext(os.path.basename(pyrenderdoc.GetCaptureFilename()))[0]
except Exception:
    capname = "capture_unknown"

# guest addresses to hunt, as they appear inside shadPS4's resource names
TARGETS = [
    ("prevframe_zeros", "0x100ee50000"),
    ("r8_1x1", "0x1000e33200"),
    ("scene", "0x1006bc8000"),
    ("bloom", "0x1015600000"),
    ("lut", "0x101e400000"),
    ("lut2", "0x101e600000"),
]

log_lines = []


def log(s):
    log_lines.append(str(s))


def fmt_mm(controller, res):
    try:
        mn, mx = controller.GetMinMax(res, rd.Subresource(0, 0, 0), rd.CompType.Typeless)
        return "min(%.4g %.4g %.4g %.4g) max(%.4g %.4g %.4g %.4g)" % (
            mn.floatValue[0], mn.floatValue[1], mn.floatValue[2], mn.floatValue[3],
            mx.floatValue[0], mx.floatValue[1], mx.floatValue[2], mx.floatValue[3])
    except Exception as e:
        return "minmax failed: %s" % e


def iter_bindings(arrs):
    for arr in arrs:
        if hasattr(arr, "resources"):
            for b in arr.resources:
                yield b.resource
        elif hasattr(arr, "descriptor"):
            yield arr.descriptor.resource
        elif hasattr(arr, "resource"):
            yield arr.resource


WRITE_WORDS = ("RW", "ColorTarget", "DepthStencilTarget", "CopyDst", "ResolveDst",
               "Clear", "GenMips", "Discard")


def is_write(usage_str):
    return any(w in usage_str for w in WRITE_WORDS)


def run(controller):
    textures = {t.resourceId: t for t in controller.GetTextures()}
    names = {}
    for r in controller.GetResources():
        names[r.resourceId] = r.name

    # eventId -> action name, walked once over the whole frame
    sf = controller.GetStructuredFile()
    act_name = {}

    def walk(actions):
        for a in actions:
            try:
                act_name[a.eventId] = a.GetName(sf)
            except Exception:
                act_name[a.eventId] = "action"
            walk(a.children)

    walk(controller.GetRootActions())

    # the transform draw eid, for "before/after" orientation (same rule as analyze7)
    lut_rid = None
    for rid, t in textures.items():
        if t.width == 64 and t.height == 64 and t.depth == 64:
            lut_rid = rid
            break
    transform_eid = None
    if lut_rid is not None:
        for u in controller.GetUsage(lut_rid):
            if "Resource" in str(u.usage):
                transform_eid = u.eventId
                break
    log("capture %s: transform eid %s" % (capname, transform_eid))

    scene_last_writer = None
    for tag, addr in TARGETS:
        rid = None
        for r, n in names.items():
            if addr in n and r in textures:
                rid = r
                break
        if rid is None:
            log("%s (%s): NOT FOUND in capture" % (tag, addr))
            continue
        t = textures[rid]
        usages = controller.GetUsage(rid)
        writes = [u for u in usages if is_write(str(u.usage))]
        log("%s (%s) %s %dx%dx%d: %d usage(s), %d write(s)" % (
            tag, addr, rid, t.width, t.height, t.depth, len(usages), len(writes)))
        for u in usages:
            us = str(u.usage).split(".")[-1]
            log("  eid %6d %-22s %s%s" % (
                u.eventId, us, act_name.get(u.eventId, "?"),
                "  <-- WRITE" if is_write(str(u.usage)) else ""))
            if tag == "scene" and is_write(str(u.usage)) and \
               (transform_eid is None or u.eventId < transform_eid):
                scene_last_writer = u.eventId
        if not writes:
            log("  ** NOTHING WRITES %s IN THIS FRAME **" % tag)

    # the pass that produced the 65020: its fragment inputs carry the exposure factor
    if scene_last_writer is not None:
        log("")
        log("scene last writer before transform: eid %d (%s) - its fragment inputs:" % (
            scene_last_writer, act_name.get(scene_last_writer, "?")))
        controller.SetFrameEvent(scene_last_writer, True)
        pipe = controller.GetPipelineState()
        try:
            for res in iter_bindings(pipe.GetReadOnlyResources(rd.ShaderStage.Fragment)):
                if res == rd.ResourceId.Null():
                    continue
                if res in textures:
                    t = textures[res]
                    log("  TEXIN %s %dx%dx%d %s [%s] | %s" % (
                        res, t.width, t.height, t.depth, t.format.Name(),
                        names.get(res, "?"), fmt_mm(controller, res)))
                else:
                    log("  BUF %s [%s]" % (res, names.get(res, "?")))
        except Exception as e:
            log("  input iteration failed: %s" % e)

    with open(os.path.join(OUT, "%s_usage.txt" % capname), "w") as f:
        f.write("\n".join(log_lines))


pyrenderdoc.Replay().BlockInvoke(run)

with open(os.path.join(OUT, "%s_usage.txt" % capname), "w") as f:
    f.write("\n".join(log_lines))
