# analyze17_export.py - does the preview-scene draw's PS export shuffle channels?
# The export comp_swap is baked into the SPIR-V (export.cpp applies PsColorBuffer.swizzle),
# so the frag_color0 store at the END of the disassembly shows exactly what permutation the
# pipeline was built with. Dump the disasm TAIL of:
#   16423 - a preview-scene draw into the 2x MSAA 94395 (the surface whose memory order is wrong)
#   16517 - the UI draw that samples the panel (for how it consumes it)
#   11196 - a main-scene draw into 13728 (a KNOWN-GOOD CB write, for comparison)
# plus pixel values of a chromatic pixel in 94395 vs 137655 to verify the resolve is verbatim.
import os
import renderdoc as rd

CAP = os.environ["RDC_CAP"]
OUT = os.environ.get("RDC_OUT", os.path.dirname(CAP))
os.makedirs(OUT, exist_ok=True)
rep = open(os.path.join(OUT, "analysis17.txt"), "w", encoding="utf-8")

def W(s=""):
    rep.write(s + "\n")

res = pyrenderdoc.LoadCapture(CAP, rd.ReplayOptions(), CAP, False, True)

FOCUS = [16423, 16517, 11196]

def run(ctrl):
    textures = {int(t.resourceId): t for t in ctrl.GetTextures()}

    def rid_of(i):
        t = textures.get(i)
        return t.resourceId if t else None

    for eid in FOCUS:
        ctrl.SetFrameEvent(eid, True)
        pipe = ctrl.GetPipelineState()
        W(f"== eid {eid}: PS disassembly TAIL (export code) ==")
        try:
            refl = pipe.GetShaderReflection(rd.ShaderStage.Pixel)
            targets = ctrl.GetDisassemblyTargets(True)
            disasm = ctrl.DisassembleShader(pipe.GetGraphicsPipelineObject(), refl, targets[0])
            lines = disasm.splitlines()
            # find the last mention of frag_color and print context around every store to it
            idxs = [i for i, ln in enumerate(lines) if "frag_color" in ln]
            W(f"  ({len(lines)} lines total; frag_color mentions at {idxs[-8:]})")
            start = max(0, (idxs[-1] if idxs else len(lines)) - 60)
            for ln in lines[start:]:
                W("    " + ln)
        except Exception as e:
            W(f"  disasm: <{e}>")
        W()

    # chromatic pixel check: sample a few points of 94395 (sample 0) vs 137655
    src = rid_of(94395)
    dst = rid_of(137655)
    ctrl.SetFrameEvent(16517, True)
    W("== resolve verbatim check: 94395 (s0) vs 137655 at same coords ==")
    for (x, y) in [(100, 100), (260, 240), (150, 300), (400, 120), (330, 400)]:
        vs = ctrl.PickPixel(src, x, y, rd.Subresource(0, 0, 0), rd.CompType.Typeless)
        vd = ctrl.PickPixel(dst, x, y, rd.Subresource(0, 0, 0), rd.CompType.Typeless)
        W(f"  ({x},{y}) src={tuple(round(v,4) for v in vs.floatValue)} dst={tuple(round(v,4) for v in vd.floatValue)}")
    W()

    # also save PNG of 94395 so we can see the preview scene's own colors
    sd = rd.TextureSave()
    sd.resourceId = src
    sd.destType = rd.FileType.PNG
    sd.mip = 0
    sd.slice.sliceIndex = 0
    sd.sample.sampleIndex = 0
    ctrl.SaveTexture(sd, os.path.join(OUT, "tex_94395_msaa_preview.png"))
    W("saved tex_94395_msaa_preview.png")
    rep.flush()

res  # noqa
def _go(c):
    run(c)
pyrenderdoc.Replay().BlockInvoke(_go)
rep.close()

try:
    import PySide2.QtWidgets as qw
    qw.QApplication.quit()
except Exception:
    pass
