# RUN 226 part 3: pixel-level truth for the red map panel.
# 137655 (520x480 RGBA8, the track-preview panel) ALIASES 137585 (1920x1080 R16F, constant
# 1.0) at guest 0x100a0b0000. Replay content of 137655 is CORRECT (black bg + road lines)
# while the live screen shows a RED bg. PixelHistory on the final UI target 4883 at a pixel
# inside the panel tells what the UI draw (eid 16517) actually wrote during replay - if it
# wrote dark, the red is an inter-frame texture-cache aliasing instability invisible in this
# capture; if it wrote red, the shader/swizzle turns good content red and we can see how.
import os

import renderdoc as rd

OUT = os.environ.get("RDC_OUT", r"C:\Users\3E30~1\DOCUME~1\GitHub\shadPS4\GT7_work\rdc\out_redmap226")
CAP = os.environ.get("RDC_CAP", "")

log_lines = []


def log(s):
    log_lines.append(str(s))
    print(s)


def run(controller):
    textures = {str(t.resourceId).replace("ResourceId::", ""): t
                for t in controller.GetTextures()}

    def hist(rid_key, x, y, tag):
        t = textures.get(rid_key)
        if not t:
            log("%s: texture %s not found" % (tag, rid_key))
            return
        log("")
        log("== PixelHistory %s (%s) at (%d,%d) ==" % (rid_key, tag, x, y))
        try:
            mods = controller.PixelHistory(t.resourceId, x, y, rd.Subresource(0, 0, 0),
                                           rd.CompType.Typeless)
        except Exception as e:
            log("  failed: %s" % e)
            return
        for m in mods:
            try:
                so = m.shaderOut.col.floatValue
                po = m.postMod.col.floatValue
                log("  eid %5d passed=%s shaderOut=(%.4g %.4g %.4g %.4g) post=(%.4g %.4g %.4g %.4g)" % (
                    m.eventId, m.Passed(),
                    so[0], so[1], so[2], so[3], po[0], po[1], po[2], po[3]))
            except Exception as e:
                log("  eid %5d (decode failed: %s)" % (m.eventId, e))

    # the red panel on screen: x 1340..1860, y 235..712 -> centre-ish (1500, 400) and a
    # corner well away from any road line (1400, 300). Control: album cover (170, 300).
    hist("4883", 1500, 400, "UI target, inside red panel")
    hist("4883", 1400, 640, "UI target, panel lower-left")
    hist("4883", 170, 300, "UI target, album cover control")
    # inside the panel texture itself: a background pixel + the panel's own writers
    hist("137655", 100, 100, "track preview texture, bg pixel")

    # the descriptor + blend at the panel draw, in full
    controller.SetFrameEvent(16517, True)
    pipe = controller.GetPipelineState()
    log("")
    log("== eid 16517 state ==")
    try:
        for u in pipe.GetReadOnlyResources(rd.ShaderStage.Pixel):
            rid = u.descriptor.resource
            if rid == rd.ResourceId.Null():
                continue
            s = u.descriptor.swizzle
            log("  ps_tex %s fmt=%s swz=%s%s%s%s" % (
                rid, u.descriptor.format.Name(),
                s.red, s.green, s.blue, s.alpha))
    except Exception as e:
        log("  ro failed: %s" % e)
    try:
        blends = pipe.GetColorBlends()
        for i, b in enumerate(blends):
            log("  blend[%d] enabled=%s src=%s dst=%s op=%s" % (
                i, b.enabled, b.colorBlend.source, b.colorBlend.destination,
                b.colorBlend.operation))
    except Exception as e:
        log("  blend failed: %s" % e)


if CAP:
    opts = rd.ReplayOptions()
    pyrenderdoc.LoadCapture(CAP, opts, CAP, False, True)
pyrenderdoc.Replay().BlockInvoke(run)

with open(os.path.join(OUT, "analysis15.txt"), "w") as f:
    f.write("\n".join(log_lines))

if os.environ.get("RDC_STAY", "") != "1":
    import PySide2.QtWidgets
    PySide2.QtWidgets.QApplication.instance().quit()
