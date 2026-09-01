#!/usr/bin/env python3
# test_client.py - mimics shadPS4's shadNet client (src/shadnet/client.cpp) against the
# local server, byte for byte, BEFORE the real game is involved:
#   1. probe: connect, expect ServerInfo v1, disconnect  (= server_probe.cpp)
#   2. client: connect, ServerInfo, Login -> expect Reply/Login NoError + LoginReply blob
#   3. GetToken -> expect token/user_id/npid
#   4. GetServerFeatures -> expect NoError (empty blob ok)
#   5. unknown command (RecordScore 31) -> expect Unsupported (33)
# Exits 0 on PASS, 1 on any mismatch. ASCII only, stdlib only.

import socket
import struct
import sys

HOST, PORT = "127.0.0.1", 31313
HEADER = 15
failures = []


def check(cond, what):
    print(("PASS  " if cond else "FAIL  ") + what, flush=True)
    if not cond:
        failures.append(what)


def enc_varint(v):
    out = bytearray()
    while True:
        b = v & 0x7F
        v >>= 7
        if v:
            out.append(b | 0x80)
        else:
            out.append(b)
            return bytes(out)


def enc_str(fno, s):
    d = s.encode()
    return bytes([(fno << 3) | 2]) + enc_varint(len(d)) + d


def dec_fields(blob):
    out, i = {}, 0
    while i < len(blob):
        key = blob[i]
        i += 1
        fno, wt = key >> 3, key & 7
        if wt == 0:
            v, sh = 0, 0
            while True:
                b = blob[i]
                i += 1
                v |= (b & 0x7F) << sh
                if not (b & 0x80):
                    break
                sh += 7
            out[fno] = v
        elif wt == 2:
            ln = blob[i]
            i += 1
            out[fno] = blob[i:i + ln]
            i += ln
    return out


def packet(ptype, cmd, pkt_id, payload):
    return (bytes([ptype]) + struct.pack("<H", cmd)
            + struct.pack("<I", HEADER + len(payload)) + struct.pack("<Q", pkt_id) + payload)


def recv_exact(s, n):
    buf = b""
    while len(buf) < n:
        c = s.recv(n - len(buf))
        if not c:
            raise ConnectionError("peer closed")
        buf += c
    return buf


def read_packet(s):
    h = recv_exact(s, HEADER)
    ptype = h[0]
    cmd = struct.unpack("<H", h[1:3])[0]
    total = struct.unpack("<I", h[3:7])[0]
    pkt_id = struct.unpack("<Q", h[7:15])[0]
    payload = recv_exact(s, total - HEADER) if total > HEADER else b""
    return ptype, cmd, pkt_id, payload


def expect_serverinfo(s, who):
    ptype, cmd, pkt_id, payload = read_packet(s)
    check(ptype == 3, who + ": server speaks first with ServerInfo (type 3), got type %d" % ptype)
    ver = struct.unpack("<I", payload[:4])[0] if len(payload) >= 4 else -1
    check(ver == 1, who + ": protocol version 1, got %d" % ver)


def connect():
    s = socket.create_connection((HOST, PORT), timeout=5)
    s.settimeout(5)
    return s


def main():
    # 1. the boot-time probe
    s = connect()
    expect_serverinfo(s, "probe")
    s.close()

    # 2. the real client
    s = connect()
    expect_serverinfo(s, "client")

    login = enc_str(1, "Nikos") + enc_str(2, "local") + enc_str(4, "CUSA24769") + enc_str(5, "GT7")
    s.sendall(packet(0, 0, 7, struct.pack("<I", len(login)) + login))
    ptype, cmd, pkt_id, payload = read_packet(s)
    check(ptype == 1 and cmd == 0, "Login reply is Reply/Login (type=%d cmd=%d)" % (ptype, cmd))
    check(pkt_id == 7, "Login reply echoes pkt_id 7, got %d" % pkt_id)
    check(len(payload) >= 5 and payload[0] == 0, "Login reply ErrorType NoError")
    blob_len = struct.unpack("<I", payload[1:5])[0]
    blob = payload[5:5 + blob_len]
    check(len(blob) > 0, "LoginReply blob is non-empty (client requires !blob.empty())")
    f = dec_fields(blob)
    check(f.get(2) == 1000, "LoginReply.user_id == 1000, got %s" % f.get(2))

    # 3. GetToken
    s.sendall(packet(0, 39, 8, b""))
    ptype, cmd, pkt_id, payload = read_packet(s)
    check(cmd == 39 and payload[0] == 0, "GetToken reply NoError")
    blob = payload[5:5 + struct.unpack("<I", payload[1:5])[0]]
    f = dec_fields(blob)
    check(bool(f.get(1)), "GetTokenReply.token present: %r" % f.get(1, b"").decode())
    check(f.get(3, b"").decode() == "Nikos", "GetTokenReply.npid echoes login npid")

    # 4. GetServerFeatures - the reply that releases WaitForAuthenticated()
    s.sendall(packet(0, 12, 9, b""))
    ptype, cmd, pkt_id, payload = read_packet(s)
    check(cmd == 12 and payload[0] == 0, "GetServerFeatures reply NoError (empty blob = defaults)")

    # 5. unknown command -> clean Unsupported, not a hang
    s.sendall(packet(0, 31, 10, b""))
    ptype, cmd, pkt_id, payload = read_packet(s)
    check(cmd == 31 and pkt_id == 10 and payload[0] == 33,
          "unknown cmd 31 -> ErrorType Unsupported (33), got %d" % payload[0])
    s.close()

    print("")
    if failures:
        print("RESULT: %d FAILURE(S)" % len(failures), flush=True)
        return 1
    print("RESULT: ALL PASS", flush=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
