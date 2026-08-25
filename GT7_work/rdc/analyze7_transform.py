# Act 11 step 2: the three paused captures share IDENTICAL LUT/curve/4x4 content but the
# transform output min goes 0.005 -> 0.054 -> 0.42. So the oscillation knob is either the
# scene input or a BUFFER value bound to the transform draw. Dump, at the draw that reads
# the 64^3 LUT: every fragment-stage BUFFER binding (RO + RW + constant blocks), first
# 1 KB each as dwords, plus the scene input textures' min/max. Run on each capture and
# diff the out7/<name>.txt files - the dwords that change between captures are the knob.
# Paste line (Python Shell inside qrenderdoc):
#   import os; os.environ["RDC_SELF"]=r"C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\rdc\analyze7_transform.py"; exec(open(os.environ["RDC_SELF"], encoding="utf-8").read())
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


def dump_buffer(controller, res, offset, tag):
    try:
        data = bytes(controller.GetBufferData(res, offset, 1024))
        n = len(data) // 4
        words = struct.unpack("<%dI" % n, data[: n * 4])
        floats = struct.unpack("<%df" % n, data[: n * 4])
        log("  %s %s off %d: %d bytes" % (tag, res, offset, len(data)))
        for base in range(0, min(n, 256), 8):
            hexs = " ".join("%08x" % w for w in words[base : base + 8])
            flts = " ".join(
                ("%.4g" % f) if abs(f) < 1e30 and f == f else "nan/inf"
                for f in floats[base : base + 8]
            )
            log("    dw%03d: %s | %s" % (base, hexs, flts))
    except Exception as e:
        log("  %s %s: dump failed: %s" % (tag, res, e))


def iter_bindings(arrs):
    # tolerate both RenderDoc binding shapes: BoundResourceArray (.resources)
    # and UsedDescriptor (.descriptor.resource). Yields (resource, byteOffset, byteSize) -
    # the first dump read offset 0 of a RING buffer and compared unrelated old frames.
    for arr in arrs:
        if hasattr(arr, "resources"):
            for b in arr.resources:
                yield b.resource, 0, 0
        elif hasattr(arr, "descriptor"):
            d = arr.descriptor
            yield d.resource, getattr(d, "byteOffset", 0), getattr(d, "byteSize", 0)
        elif hasattr(arr, "resource"):
            yield arr.resource, 0, 0


def run(controller):
    textures = {t.resourceId: t for t in controller.GetTextures()}
    buffers = {b.resourceId: b for b in controller.GetBuffers()}
    # Resource NAMES: shadPS4 names images with their guest address ("Image ... 0x... :0x..."),
    # which is exactly what GT_WATCH_VA needs to hunt a writer emulator-side.
    names = {}
    try:
        for rd_res in controller.GetResources():
            names[rd_res.resourceId] = rd_res.name
    except Exception:
        pass

    def nm(res):
        return names.get(res, "?")

    # the transform draw = the single PS_Resource read of the 64^3 LUT
    lut_id = None
    for rid, t in textures.items():
        if t.width == 64 and t.height == 64 and t.depth == 64:
            lut_id = rid
            break
    if lut_id is None:
        log("no 64^3 texture found")
        return
    eid = None
    for u in controller.GetUsage(lut_id):
        if "Resource" in str(u.usage):
            eid = u.eventId
            break
    if eid is None:
        log("LUT never read in this capture")
        return
    log("capture %s: transform draw eid %d (reads LUT %s)" % (capname, eid, lut_id))

    controller.SetFrameEvent(eid, True)
    pipe = controller.GetPipelineState()

    # output + every fragment texture input's minmax (scene, bloom, ...)
    for o in pipe.GetOutputTargets():
        if o.resource != rd.ResourceId.Null():
            log("OUT %s [%s] | %s" % (o.resource, nm(o.resource), fmt_mm(controller, o.resource)))
    try:
        for res, boff, bsz in iter_bindings(pipe.GetReadOnlyResources(rd.ShaderStage.Fragment)):
            if res == rd.ResourceId.Null():
                continue
            if res in textures:
                t = textures[res]
                log("TEXIN %s %dx%dx%d %s [%s] | %s" % (res, t.width, t.height, t.depth,
                                                        t.format.Name(), nm(res),
                                                        fmt_mm(controller, res)))
            elif res in buffers:
                dump_buffer(controller, res, boff, "ROBUF(sz %d)[%s]" % (bsz, nm(res)))
    except Exception as e:
        log("RO iteration failed: %s" % e)
    try:
        for res, boff, bsz in iter_bindings(pipe.GetReadWriteResources(rd.ShaderStage.Fragment)):
            if res == rd.ResourceId.Null():
                continue
            if res in buffers:
                dump_buffer(controller, res, boff, "RWBUF(sz %d)" % bsz)
            elif res in textures:
                t = textures[res]
                log("RWTEX %s %dx%dx%d %s | %s" % (res, t.width, t.height, t.depth,
                                                   t.format.Name(), fmt_mm(controller, res)))
    except Exception as e:
        log("RW iteration failed: %s" % e)

    # constant blocks: the descriptor-era API (RenderDoc >= 1.33). GetConstantBuffer is gone.
    try:
        for res, boff, bsz in iter_bindings(pipe.GetConstantBlocks(rd.ShaderStage.Fragment)):
            if res != rd.ResourceId.Null() and res in buffers:
                dump_buffer(controller, res, boff, "CB(sz %d)" % bsz)
    except Exception as e:
        log("constant blocks failed: %s" % e)

    with open(os.path.join(OUT, "%s.txt" % capname), "w") as f:
        f.write("\n".join(log_lines))


pyrenderdoc.Replay().BlockInvoke(run)

with open(os.path.join(OUT, "%s.txt" % capname), "w") as f:
    f.write("\n".join(log_lines))
