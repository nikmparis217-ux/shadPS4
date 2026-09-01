# Act 12: run 184 proved NOTHING ever produces the exposure/transmittance state (zero WRITE
# binds session-wide, every upload carries zeros) - so the AE chain is broken UPSTREAM of
# those textures, and the break is somewhere in the graph of SMALL textures the adaptation
# pipeline ping-pongs through (we know cs_a95f906e writes a 4x4 RGBA16F at 0x101e32a700
# every frame through its windowed table). This script maps that graph inside one capture:
# every small AE-plausible texture (<= 64x64, float/unorm single-or-quad channel formats),
# its content (raw texels for tiny ones, minmax otherwise), and who reads/writes it.
# Paste line (Python Shell inside qrenderdoc):
#   import os; os.environ["RDC_SELF"]=r"C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\rdc\analyze10_smalltex.py"; exec(open(os.environ["RDC_SELF"], encoding="utf-8").read())
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

# extra textures pulled in by guest address regardless of size (the measure-chain heads)
EXTRA_ADDRS = ["0x100a770000", "0x101e32a700", "0x10b19a1700", "0x1000e33200"]
FMT_OK = ("R8_UNORM", "R16_FLOAT", "R32_FLOAT", "R16G16B16A16_FLOAT", "R11G11B10_FLOAT",
          "R16_UNORM", "R32_UINT", "R16G16_FLOAT", "R8G8B8A8_UNORM")

WRITE_WORDS = ("RW", "ColorTarget", "DepthStencilTarget", "CopyDst", "ResolveDst",
               "Clear", "GenMips", "Discard")

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


def raw_texels(controller, t):
    # raw dump for tiny textures - the actual adapted-exposure numbers, not just a range
    try:
        n_texels = t.width * t.height * max(t.depth, 1)
        if n_texels > 64:
            return None
        data = bytes(controller.GetTextureData(t.resourceId, rd.Subresource(0, 0, 0)))
        name = t.format.Name()
        vals = []
        if name == "R8_UNORM":
            vals = ["%.3f" % (b / 255.0) for b in data[:n_texels]]
        elif name in ("R16_FLOAT",):
            vals = ["%.4g" % struct.unpack_from("<e", data, i * 2)[0]
                    for i in range(min(n_texels, len(data) // 2))]
        elif name in ("R32_FLOAT",):
            vals = ["%.4g" % struct.unpack_from("<f", data, i * 4)[0]
                    for i in range(min(n_texels, len(data) // 4))]
        elif name == "R16G16B16A16_FLOAT":
            for i in range(min(n_texels, len(data) // 8)):
                v = struct.unpack_from("<4e", data, i * 8)
                vals.append("(%.4g %.4g %.4g %.4g)" % v)
        else:
            return None
        return " ".join(vals[:32])
    except Exception as e:
        return "raw failed: %s" % e


def run(controller):
    textures = {t.resourceId: t for t in controller.GetTextures()}
    names = {}
    for r in controller.GetResources():
        names[r.resourceId] = r.name

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

    picked = []
    for rid, t in textures.items():
        nm = names.get(rid, "")
        if any(a in nm for a in EXTRA_ADDRS):
            picked.append((rid, t))
            continue
        if t.width <= 64 and t.height <= 64 and t.format.Name() in FMT_OK:
            picked.append((rid, t))

    log("capture %s: %d small/AE textures picked of %d total" % (
        capname, len(picked), len(textures)))
    # guest address prefix sorts related state together
    picked.sort(key=lambda p: names.get(p[0], ""))

    for rid, t in picked:
        usages = controller.GetUsage(rid)
        if not usages:
            continue
        writes = [u for u in usages if any(w in str(u.usage) for w in WRITE_WORDS)]
        reads = len(usages) - len(writes)
        log("")
        log("%s %dx%dx%d %s [%s]" % (rid, t.width, t.height, t.depth, t.format.Name(),
                                     names.get(rid, "?")))
        log("  %s" % fmt_mm(controller, t.resourceId))
        raw = raw_texels(controller, t)
        if raw:
            log("  texels: %s" % raw)
        log("  %d read(s), %d write(s)" % (reads, len(writes)))
        shown = 0
        for u in usages:
            us = str(u.usage).split(".")[-1]
            wr = any(w in str(u.usage) for w in WRITE_WORDS)
            if wr or shown < 6:
                log("    eid %6d %-22s %s%s" % (u.eventId, us,
                                                act_name.get(u.eventId, "?"),
                                                "  <-- WRITE" if wr else ""))
                shown += 1
        if len(usages) > shown:
            log("    ... %d more usage(s) elided" % (len(usages) - shown))

    with open(os.path.join(OUT, "%s_smalltex.txt" % capname), "w") as f:
        f.write("\n".join(log_lines))


pyrenderdoc.Replay().BlockInvoke(run)

with open(os.path.join(OUT, "%s_smalltex.txt" % capname), "w") as f:
    f.write("\n".join(log_lines))
