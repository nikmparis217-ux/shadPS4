# Act 12, the exposure chain: the scene arrives at the output transform ALREADY blown to
# half-float max (65020), the transform's CB carries only stable color matrices (+INF is a
# constant "no clamp"), and nothing writes the two dead textures in-frame. So the gain is
# applied while RENDERING the scene, and its value lives in whatever the AE compute passes
# write. This script finds every DISPATCH that reads the 1x1 R8 (0x1000e33200) or the scene
# (0x1006bc8000), names its shader (shadPS4 names carry the guest hash), and dumps its
# compute-stage RO+RW buffers and RW images - the exposure state has to be in one of them.
# Paste line (Python Shell inside qrenderdoc):
#   import os; os.environ["RDC_SELF"]=r"C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\rdc\analyze9_exposure.py"; exec(open(os.environ["RDC_SELF"], encoding="utf-8").read())
import os
import struct
import renderdoc as rd

SELF = os.environ["RDC_SELF"]
OUT = os.path.join(os.path.dirname(os.path.abspath(SELF)), "out7")
os.makedirs(OUT, exist_ok=True)
try:
    capname = os.path.splitext(os.path.basename(pyrenderdoc.GetCaptureFilename()))[0]
except Exception:
    capname = "capture_unknown"

ANCHORS = [("r8_1x1", "0x1000e33200"), ("scene", "0x1006bc8000")]

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
                yield b.resource, 0, 0
        elif hasattr(arr, "descriptor"):
            d = arr.descriptor
            yield d.resource, getattr(d, "byteOffset", 0), getattr(d, "byteSize", 0)
        elif hasattr(arr, "resource"):
            yield arr.resource, 0, 0


def dump_buffer(controller, res, offset, nbytes, tag, nm):
    try:
        nbytes = min(max(nbytes, 256), 512)
        data = bytes(controller.GetBufferData(res, offset, nbytes))
        n = len(data) // 4
        words = struct.unpack("<%dI" % n, data[: n * 4])
        floats = struct.unpack("<%df" % n, data[: n * 4])
        log("    %s %s off %d [%s]: %d bytes" % (tag, res, offset, nm(res), len(data)))
        for base in range(0, min(n, 64), 8):
            hexs = " ".join("%08x" % w for w in words[base : base + 8])
            flts = " ".join(("%.4g" % f) if abs(f) < 1e30 and f == f else "nan/inf"
                            for f in floats[base : base + 8])
            log("      dw%03d: %s | %s" % (base, hexs, flts))
    except Exception as e:
        log("    %s %s: dump failed: %s" % (tag, res, e))


def run(controller):
    textures = {t.resourceId: t for t in controller.GetTextures()}
    buffers = {b.resourceId: b for b in controller.GetBuffers()}
    names = {}
    for r in controller.GetResources():
        names[r.resourceId] = r.name

    def nm(res):
        return names.get(res, "?")

    # dispatches touching the anchors, by usage stage
    eids = {}
    for tag, addr in ANCHORS:
        rid = None
        for r, n in names.items():
            if addr in n and r in textures:
                rid = r
                break
        if rid is None:
            log("%s (%s): NOT FOUND" % (tag, addr))
            continue
        for u in controller.GetUsage(rid):
            if str(u.usage).split(".")[-1].startswith("CS_"):
                eids.setdefault(u.eventId, []).append(tag)
    log("capture %s: compute passes touching the AE anchors: %s" % (
        capname, sorted(eids.keys())))

    for eid in sorted(eids.keys()):
        controller.SetFrameEvent(eid, True)
        pipe = controller.GetPipelineState()
        try:
            shader = pipe.GetShader(rd.ShaderStage.Compute)
            shader_name = nm(shader)
        except Exception as e:
            shader_name = "? (%s)" % e
        log("")
        log("eid %d (touches %s) compute shader: %s" % (eid, "+".join(eids[eid]), shader_name))
        try:
            for res, boff, bsz in iter_bindings(pipe.GetReadOnlyResources(rd.ShaderStage.Compute)):
                if res == rd.ResourceId.Null():
                    continue
                if res in textures:
                    t = textures[res]
                    log("  RO TEX %s %dx%dx%d %s [%s] | %s" % (
                        res, t.width, t.height, t.depth, t.format.Name(), nm(res),
                        fmt_mm(controller, res)))
                elif res in buffers:
                    dump_buffer(controller, res, boff, bsz, "RO BUF", nm)
        except Exception as e:
            log("  RO iteration failed: %s" % e)
        try:
            for res, boff, bsz in iter_bindings(pipe.GetReadWriteResources(rd.ShaderStage.Compute)):
                if res == rd.ResourceId.Null():
                    continue
                if res in textures:
                    t = textures[res]
                    log("  RW TEX %s %dx%dx%d %s [%s] | %s  <-- CS OUTPUT" % (
                        res, t.width, t.height, t.depth, t.format.Name(), nm(res),
                        fmt_mm(controller, res)))
                elif res in buffers:
                    dump_buffer(controller, res, boff, bsz, "RW BUF <-- CS OUTPUT", nm)
        except Exception as e:
            log("  RW iteration failed: %s" % e)
        try:
            for res, boff, bsz in iter_bindings(pipe.GetConstantBlocks(rd.ShaderStage.Compute)):
                if res != rd.ResourceId.Null() and res in buffers:
                    dump_buffer(controller, res, boff, bsz, "CB", nm)
        except Exception as e:
            log("  CB iteration failed: %s" % e)

    with open(os.path.join(OUT, "%s_exposure.txt" % capname), "w") as f:
        f.write("\n".join(log_lines))


pyrenderdoc.Replay().BlockInvoke(run)

with open(os.path.join(OUT, "%s_exposure.txt" % capname), "w") as f:
    f.write("\n".join(log_lines))
