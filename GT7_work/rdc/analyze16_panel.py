# analyze16_panel.py - the REAL producer of the track-preview panel (137655).
# Run 226 capture. PixelHistory showed the panel bg is written by DRAWS 16502/16505,
# not by vkCmdResolveImage - so dump everything about those draws:
#   - action window 16478..16520 (between the MSAA preview scene and the UI sample)
#   - full GetUsage of 137655 and of the MSAA color target of the preview scene
#   - deep state at 16502/16505: outputs, blend, write mask, viewport, PS textures
#     (incl. sample counts - is the source the 2x MSAA color image?), shader resource
#     swizzles, and the pixel shader disassembly head.
# Usage:  qrenderdoc --python analyze16_panel.py   with RDC_CAP / RDC_OUT set.
import os
import renderdoc as rd

CAP = os.environ["RDC_CAP"]
OUT = os.environ.get("RDC_OUT", os.path.dirname(CAP))
os.makedirs(OUT, exist_ok=True)
rep = open(os.path.join(OUT, "analysis16.txt"), "w", encoding="utf-8")

def W(s=""):
    rep.write(s + "\n")

res = pyrenderdoc.LoadCapture(CAP, rd.ReplayOptions(), CAP, False, True)

PANEL = 137655
FOCUS = [16502, 16505, 16517]

def run(ctrl):
    sdfile = ctrl.GetStructuredFile()
    actions = ctrl.GetRootActions()
    flat = []
    def rec(acts):
        for a in acts:
            flat.append(a)
            rec(a.children)
    rec(actions)

    textures = {int(t.resourceId): t for t in ctrl.GetTextures()}
    resnames = {int(r.resourceId): r.name for r in ctrl.GetResources()}

    def rid_of(i):
        for t in ctrl.GetTextures():
            if int(t.resourceId) == i:
                return t.resourceId
        return None

    # ---- 1. action window ----
    W("== action window 16478..16525 ==")
    for a in flat:
        if 16478 <= a.eventId <= 16525:
            outs = [str(int(o)) for o in a.outputs if int(o) != 0]
            name = a.GetName(sdfile)
            W(f"eid {a.eventId} {str(a.flags)} out={outs} | {name}")
    W()

    # ---- 2. usage of the panel + hunt the MSAA color image of the preview scene ----
    panel_rid = rid_of(PANEL)
    W("== GetUsage(137655) ==")
    for u in ctrl.GetUsage(panel_rid):
        W(f"  {u.eventId}: {str(u.usage)}")
    W()

    # find 520x480 textures (all candidates for the preview scene MRTs)
    W("== all 520x480 textures ==")
    for i, t in sorted(textures.items()):
        if t.width == 520 and t.height == 480:
            W(f"  {i} {t.width}x{t.height} fmt={t.format.Name()} samples={t.msSamp} | {resnames.get(i,'')}")
    W()

    # usage of each 520x480 MSAA color image
    for i, t in sorted(textures.items()):
        if t.width == 520 and t.height == 480 and t.msSamp > 1 and not (t.format.compType == rd.CompType.Depth):
            W(f"== GetUsage({i}) [{t.format.Name()} s{t.msSamp}] ==")
            for u in ctrl.GetUsage(t.resourceId):
                W(f"  {u.eventId}: {str(u.usage)}")
            W()

    # ---- 3. deep state at the focus draws ----
    for eid in FOCUS:
        ctrl.SetFrameEvent(eid, True)
        pipe = ctrl.GetPipelineState()
        vk = ctrl.GetVulkanPipelineState()
        W(f"== deep state at eid {eid} ==")

        # viewport & scissor
        try:
            vp = vk.viewportScissor.viewportScissors[0].vp
            W(f"  viewport: x={vp.x} y={vp.y} w={vp.width} h={vp.height} minD={vp.minDepth} maxD={vp.maxDepth}")
        except Exception as e:
            W(f"  viewport: <{e}>")

        # color targets + blend + write mask
        try:
            for idx, att in enumerate(vk.currentPass.framebuffer.attachments):
                rid = int(att.resource)
                if rid == 0:
                    continue
                t = textures.get(rid)
                fmt = t.format.Name() if t else "?"
                W(f"  fb att[{idx}]: {rid} {fmt} samples={t.msSamp if t else '?'}")
        except Exception as e:
            W(f"  fb: <{e}>")
        try:
            for bi, b in enumerate(vk.colorBlend.blends):
                W(f"  blend[{bi}] en={b.enabled} src={str(b.colorBlend.source)} dst={str(b.colorBlend.destination)} op={str(b.colorBlend.operation)} "
                  f"srcA={str(b.alphaBlend.source)} dstA={str(b.alphaBlend.destination)} opA={str(b.alphaBlend.operation)} mask={b.writeMask:#x}")
        except Exception as e:
            W(f"  blend: <{e}>")

        # PS input textures with swizzle + sample count
        try:
            ps = pipe.GetShaderReflection(rd.ShaderStage.Pixel)
            mapping = pipe.GetBindpointMapping(rd.ShaderStage.Pixel)
            ro = pipe.GetReadOnlyResources(rd.ShaderStage.Pixel)
            for r in ro:
                for b in r.resources:
                    rid = int(b.resourceId)
                    if rid == 0:
                        continue
                    t = textures.get(rid)
                    if t is None:
                        continue
                    swz = "".join(str(c).split(".")[-1][0] for c in [b.swizzle.red, b.swizzle.green, b.swizzle.blue, b.swizzle.alpha])
                    W(f"  ps_tex {rid} {t.width}x{t.height} s{t.msSamp} {t.format.Name()} swz={swz}")
        except Exception as e:
            W(f"  ps_tex: <{e}>")

        # shader disassembly head (look for texelFetch/sample of the MSAA src and any channel shuffle)
        try:
            ps_refl = pipe.GetShaderReflection(rd.ShaderStage.Pixel)
            if ps_refl is not None:
                targets = ctrl.GetDisassemblyTargets(True)
                disasm = ctrl.DisassembleShader(pipe.GetGraphicsPipelineObject(), ps_refl, targets[0])
                lines = disasm.splitlines()
                W(f"  -- PS disasm ({len(lines)} lines, head 60) --")
                for ln in lines[:60]:
                    W("    " + ln)
        except Exception as e:
            W(f"  disasm: <{e}>")
        W()

    # ---- 4. sample the panel + MSAA source pixel values ----
    # panel content at a road pixel and a bg pixel through picked values
    for (x, y) in [(100, 100), (260, 240)]:
        v = ctrl.PickPixel(panel_rid, x, y, rd.Subresource(0, 0, 0), rd.CompType.Typeless)
        W(f"panel(137655) at ({x},{y}) = {tuple(v.floatValue)}")
    W()
    rep.flush()

res  # noqa
ctrl = pyrenderdoc.Replay()
def _go(c):
    run(c)
ctrl.BlockInvoke(_go)
rep.close()

# quit qrenderdoc
try:
    import PySide2.QtWidgets as qw
    qw.QApplication.quit()
except Exception:
    pass
