"""Writes the trophy files shadPS4 looks for, WITHOUT the Sony trophy key.

Why this exists: the real definitions live in the .trp as *.ESFM entries, which are encrypted
(flag 3) and need a key we do not have. But the TRP ENTRY TABLE IS CLEARTEXT, so the number of
trophies and the icons themselves (flag 0, unencrypted) can be read straight off the disc data.
That is enough to answer the one open question: does the game raise its textless error dialog
because it sees ZERO trophies for a title that has some?

What it writes (paths taken from np_trophy.cpp, not guessed):
  <trophy>/<npCommId>/Xml/TROP.XML          the definitions  (GetTrophyXmlPath fallback)
  <trophy>/<npCommId>/Icons/TROP*.PNG       the real icons, extracted from the .trp
  <home>/<user>/trophy/<npCommId>.xml       the per-user unlock state (all locked)

The trophy NAMES are placeholders and say so - only the count and the ids are real.
"""
import argparse, os, struct, sys, pathlib, glob

ap = argparse.ArgumentParser()
ap.add_argument('--game', default=r'C:\Users\Nikos\Desktop\shadps4-win64-sdl-0.17.0\ps4games\CUSA24769')
ap.add_argument('--user', default='1000')
ap.add_argument('--appdata', default=os.environ.get('APPDATA', '') + r'\shadPS4')
ap.add_argument('--dry', action='store_true')
a = ap.parse_args()

game = pathlib.Path(a.game)
if not game.exists():
    hits = glob.glob(os.path.expandvars(r'%USERPROFILE%\Desktop\shadps4*\ps4games\CUSA24769'))
    if not hits:
        sys.exit('game folder not found: ' + str(game))
    game = pathlib.Path(hits[0])

trp = game / 'sce_sys' / 'trophy' / 'trophy00.trp'
npbind = game / 'sce_sys' / 'npbind.dat'
data = trp.read_bytes()
magic, version = struct.unpack_from('>II', data, 0)
if magic != 0xDCA24D00:
    sys.exit('not a TRP file: magic %08x' % magic)
num, esize, _dev = struct.unpack_from('>III', data, 16)

entries = []
for i in range(num):
    off = 96 + i * esize
    name = data[off:off + 32].split(b'\0')[0].decode('ascii', 'replace')
    pos, length = struct.unpack_from('>QQ', data, off + 32)
    flag, = struct.unpack_from('>I', data, off + 48)
    entries.append((name, pos, length, flag))

icons = sorted(e for e in entries if e[0].upper().startswith('TROP') and e[0].upper().endswith('.PNG'))
count = len(icons)
if count == 0:
    sys.exit('no TROP*.PNG icons in the trp - cannot tell how many trophies there are')

# npCommId out of npbind.dat, which is not encrypted either.
blob = npbind.read_bytes() if npbind.exists() else b''
comm = ''
for i in range(len(blob) - 12):
    if blob[i:i + 4] == b'NPWR':
        cand = blob[i:i + 12].decode('ascii', 'replace')
        if cand[4:9].isdigit() and cand[9] == '_':
            comm = cand
            break
if not comm:
    sys.exit('no NPWR id found in npbind.dat')

root = pathlib.Path(a.appdata)
xml_dir = root / 'trophy' / comm / 'Xml'
icon_dir = root / 'trophy' / comm / 'Icons'
save_xml = root / 'home' / a.user / 'trophy' / (comm + '.xml')

print('%s: TRP version %d, %d entries, %d trophy icons -> %d trophies' %
      (comm, version, num, count, count))
print('  definitions : %s' % (xml_dir / 'TROP.XML'))
print('  icons       : %s' % icon_dir)
print('  unlock state: %s' % save_xml)
if a.dry:
    sys.exit(0)

# One grade layout: id 0 is the platinum (TROP000.PNG is always the platinum icon), the rest are
# bronze apart from a few, because the real grades are inside the encrypted ESFM.
def grade(i):
    if i == 0:
        return 'P'
    if i % 13 == 0:
        return 'G'
    if i % 5 == 0:
        return 'S'
    return 'B'

lines = ['<?xml version="1.0" encoding="utf-8" standalone="yes"?>', '<trophyconf>',
         '  <npcommid>%s</npcommid>' % comm,
         '  <trophyset-version>01.00</trophyset-version>',
         '  <title-name>Gran Turismo 7</title-name>',
         '  <title-detail>Placeholder trophy set written by make_trophy_xml.py - the real names and '
         'descriptions are encrypted inside the trp.</title-detail>']
for i in range(count):
    pid = '-1' if i == 0 else '0'
    lines.append('  <trophy id="%d" hidden="no" ttype="%s" pid="%s" gid="0" unlockstate="false" '
                 'timestamp="0">' % (i, grade(i), pid))
    lines.append('    <name>Trophy %02d</name>' % i)
    lines.append('    <detail>Placeholder - the real description is encrypted.</detail>')
    lines.append('  </trophy>')
lines.append('</trophyconf>')
doc = '\n'.join(lines) + '\n'

xml_dir.mkdir(parents=True, exist_ok=True)
icon_dir.mkdir(parents=True, exist_ok=True)
save_xml.parent.mkdir(parents=True, exist_ok=True)
(xml_dir / 'TROP.XML').write_text(doc, encoding='utf-8', newline='\n')
# TROPCONF.XML as well: emulator.cpp:257 copies THAT file (not TROP.XML) into every user
# folder that has no unlock state yet, and logs an error per user when it is missing.
(xml_dir / 'TROPCONF.XML').write_text(doc, encoding='utf-8', newline=chr(10))
save_xml.write_text(doc, encoding='utf-8', newline='\n')
for udir in sorted((root / 'home').glob('[0-9]*')):
    target = udir / 'trophy' / (comm + '.xml')
    if not target.exists():
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(doc, encoding='utf-8', newline=chr(10))

# The icons are flag 0, i.e. stored as-is - the game data itself, no key involved.
written = 0
for name, pos, length, flag in icons:
    if flag != 0:
        continue
    (icon_dir / name).write_bytes(data[pos:pos + length])
    written += 1
print('wrote TROP.XML (%d trophies), the same file as the unlock state, and %d icons' %
      (count, written))
