# Stage 2: the flood is made between eid ~12186 (bloom, sane) and 13890 (final, min 0.588).
# Walk every draw in that range: output target + min/max, and for draws that write the
# final image, every bound fragment texture with dims and min/max - the grading LUT will
# show itself as a small 3D/2D texture whose MIN is ~0.588.
import os
import renderdoc as rd

OUT = os.path.join(os.path.dirname(os.path.abspath(os.environ["RDC_SELF"])), "out2")
os.makedirs(OUT, exist_ok=True)
open(os.path.join(OUT, "started.txt"), "w").write("stage2 entered")

log_lines = []


def log(s):
    log_lines.append(str(s))


def flatten(actions, out):
    for a in actions:
        out.append(a)
        if len(a.children) > 0:
            flatten(a.children, out)


def mm(controller, res):
    try:
        mn, mx = controller.GetMinMax(res, rd.Subresource(0, 0, 0), rd.CompType.Typeless)
        return "min(%.4g %.4g %.4g %.4g) max(%.4g %.4g %.4g %.4g)" % (
            mn.floatValue[0], mn.floatValue[1], mn.floatValue[2], mn.floatValue[3],
            mx.floatValue[0], mx.floatValue[1], mx.floatValue[2], mx.floatValue[3])
    except Exception as e:
        return "minmax failed: %s" % e


def run(controller):
    sf = controller.GetStructuredFile()
    textures = {t.resourceId: t for t in controller.GetTextures()}

    all_actions = []
    flatten(controller.GetRootActions(), all_actions)
    draws = [a for a in all_actions if len(a.children) == 0 and
             (a.flags & rd.ActionFlags.Drawcall) and 12000 <= a.eventId <= 14000]
    log("draws in window: %d" % len(draws))

    saved = 0
    for a in draws:
        eid = a.eventId
        controller.SetFrameEvent(eid, True)
        pipe = controller.GetPipelineState()
        outs = [o for o in pipe.GetOutputTargets() if o.resource != rd.ResourceId.Null()]
        if not outs:
            continue
        res = outs[0].resource
        tex = textures.get(res)
        dims = "%dx%dx%d %s" % (tex.width, tex.height, tex.depth,
                                tex.format.Name()) if tex else "?"
        name = a.GetName(sf)
        log("draw eid %d [%s] -> %s %s | %s" % (eid, name[:60], res, dims, mm(controller, res)))
        # its fragment-stage inputs
        try:
            ro = pipe.GetReadOnlyResources(rd.ShaderStage.Fragment)
            n_in = 0
            for arr in ro:
                for b in arr.resources:
                    if b.resource == rd.ResourceId.Null():
                        continue
                    t = textures.get(b.resource)
                    if t is None:
                        continue
                    n_in += 1
                    if n_in > 10:
                        break
                    log("    in %s %dx%dx%d arr%d %s | %s" % (
                        b.resource, t.width, t.height, t.depth, t.arraysize,
                        t.format.Name(), mm(controller, b.resource)))
                    # save the small ones - LUT candidates
                    if t.width <= 1100 and t.height <= 300 and saved < 12:
                        try:
                            ts = rd.TextureSave()
                            ts.resourceId = b.resource
                            ts.mip = 0
                            ts.alpha = rd.AlphaMapping.Discard
                            ts.destType = rd.FileType.PNG
                            controller.SaveTexture(ts, os.path.join(
                                OUT, "in_eid%d_%s.png" % (eid, str(b.resource).replace("::", "_"))))
                            saved += 1
                        except Exception as e:
                            log("    save failed: %s" % e)
                if n_in > 10:
                    break
        except Exception as e:
            log("    inputs failed: %s" % e)

    with open(os.path.join(OUT, "analysis2.txt"), "w") as f:
        f.write("\n".join(log_lines))


pyrenderdoc.Replay().BlockInvoke(run)

with open(os.path.join(OUT, "analysis2.txt"), "w") as f:
    f.write("\n".join(log_lines))
