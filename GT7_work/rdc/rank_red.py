# Rank analyze12_redmap.py's PNG dump by red-dominance (system python + PIL).
# The red MAP texture reads as: high mean R, low mean G/B, with SOME bright pixels (the
# white roads). Print the top candidates with their manifest usage lines - the writers
# named there are the producer draws the hunt wants.
import json
import os
import sys

from PIL import Image

OUT = sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.path.dirname(__file__), "out_redmap")

with open(os.path.join(OUT, "manifest.json"), encoding="utf-8") as f:
    manifest = json.load(f)

rows = []
for m in manifest:
    p = os.path.join(OUT, m["png"])
    if not m["png"].endswith(".png") or not os.path.exists(p):
        continue
    try:
        im = Image.open(p).convert("RGB").resize((64, 64))
    except Exception as e:
        continue
    px = list(im.getdata())
    n = len(px)
    mr = sum(c[0] for c in px) / n
    mg = sum(c[1] for c in px) / n
    mb = sum(c[2] for c in px) / n
    # red dominance: how much R exceeds the larger of G/B, weighted by absolute R level
    dom = (mr - max(mg, mb)) * (mr / 255.0)
    rows.append((dom, mr, mg, mb, m))

rows.sort(key=lambda r: -r[0])
print(f"{len(rows)} PNGs ranked; top red-dominant:")
for dom, mr, mg, mb, m in rows[:12]:
    print(f"\ndom={dom:7.2f} meanRGB=({mr:5.1f},{mg:5.1f},{mb:5.1f})  {m['dims']}  {m['fmt']}")
    print(f"  id={m['id']}  name='{m['name']}'  png={m['png']}")
    print(f"  minmax: {m['minmax']}")
    print(f"  flags:  {m['flags']}")
    for k, v in m["usage"].items():
        print(f"  usage {k}: {v}")
