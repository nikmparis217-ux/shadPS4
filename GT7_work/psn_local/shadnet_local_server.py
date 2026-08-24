#!/usr/bin/env python3
# shadnet_local_server.py - minimal LOCAL shadNet server so shadPS4 signs in to "PSN".
#
# ASCII only, pure stdlib (no protobuf package needed - replies are hand-encoded proto3).
# The emulator already contains a full shadNet CLIENT (src/shadnet/client.cpp); it only
# lacks a server. This speaks its wire protocol, protocol version 1:
#
#   header, 15 bytes, all little-endian:
#     [0]     PacketType u8   (Request=0, Reply=1, Notification=2, ServerInfo=3)
#     [1:3]   command    u16
#     [3:7]   total size u32  (INCLUDING the 15-byte header)
#     [7:15]  packet id  u64
#
#   - On every accepted connection the SERVER speaks first: a ServerInfo packet whose
#     payload begins with LE32 protocol version (= 1). The emulator's boot-time probe
#     (server_probe.cpp) connects, reads this, and disconnects; the real client then
#     connects again and sends Login.
#   - Request payloads are: LE32 blob length + protobuf blob.
#   - Reply payloads are:   [ErrorType u8] + LE32 blob length + protobuf blob.
#     (An error reply may be the single ErrorType byte with no blob.)
#
#   The client releases WaitForAuthenticated() ONLY after this exact chain completes:
#     Login reply (NoError, non-empty LoginReply blob)
#       -> client fires GetToken (39)        -> we reply GetTokenReply
#       -> client fires GetServerFeatures(12)-> we reply (empty blob = matching2 off)
#   Miss any of the three and the emulator boot BLOCKS in NpHandler::Initialize.
#
# Anything else gets ErrorType::Unsupported (33) so the client's onAsyncReply sees a
# clean failure instead of a request that never completes.
#
# Log: psn_local/server_log.txt (next to this file) + stdout.

import os
import socket
import struct
import sys
import threading
import time

HOST = "127.0.0.1"
PORT = 31313
PROTOCOL_VERSION = 1
HEADER_SIZE = 15
MAX_PACKET = 0x800000  # 8 MiB, same cap as the client

# LoginReply.user_id becomes the PSN "account id" (sceNpGetAccountId). Any non-zero works.
ACCOUNT_ID = 1000
BEARER_TOKEN = "shadnet-local-bearer"

TYPE_REQUEST = 0
TYPE_REPLY = 1
TYPE_NOTIFICATION = 2
TYPE_SERVERINFO = 3

ERR_NO_ERROR = 0
ERR_UNSUPPORTED = 33

CMD_LOGIN = 0
CMD_TERMINATE = 1
CMD_GET_SERVER_FEATURES = 12
CMD_GET_TOKEN = 39
CMD_SET_APPEAR_OFFLINE = 40

CMD_NAMES = {
    0: "Login", 1: "Terminate", 2: "Create", 3: "Delete", 4: "SendToken",
    5: "SendResetToken", 6: "ResetPassword", 7: "ResetState", 8: "AddFriend",
    9: "RemoveFriend", 10: "AddBlock", 11: "RemoveBlock", 12: "GetServerFeatures",
    30: "GetBoardInfos", 31: "RecordScore", 32: "RecordScoreData", 33: "GetScoreData",
    34: "GetScoreRange", 35: "GetScoreFriends", 36: "GetScoreNpid",
    37: "GetScoreAccountId", 38: "GetScoreGameDataByAccId", 39: "GetToken",
    40: "SetAppearOffline",
    100: "ContextStart", 101: "CreateRoom", 102: "JoinRoom", 103: "LeaveRoom",
    104: "SearchRoom", 105: "RequestSignalingInfos", 106: "ContextStop",
    107: "SetUserInfo", 108: "SetRoomDataInternal", 109: "SetRoomDataExternal",
    110: "KickoutRoomMember", 111: "GetWorldInfoList", 112: "GetRoomDataExternalList",
    113: "GetUserInfoList", 114: "GetRoomMemberDataExternalList", 115: "SendRoomMessage",
    201: "TusSetData", 202: "TusGetData", 203: "TusSetMultiSlotVariable",
    204: "TusGetMultiSlotVariable", 205: "TusAddAndGetVariable",
    206: "TusGetMultiSlotDataStatus", 207: "TusGetMultiUserDataStatus",
    208: "TusGetFriendsDataStatus", 209: "TusDeleteMultiSlotData",
    210: "TusGetMultiUserVariable", 211: "TusTryAndSetVariable",
    212: "TusGetFriendsVariable", 213: "TusDeleteMultiSlotVariable",
}

_log_lock = threading.Lock()
_log_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "server_log.txt")


def log(msg):
    line = time.strftime("%H:%M:%S") + " " + msg
    with _log_lock:
        print(line, flush=True)
        try:
            with open(_log_path, "a", encoding="ascii", errors="replace") as f:
                f.write(line + "\n")
        except OSError:
            pass


# ---- minimal proto3 helpers (only what the shadnet.proto replies need) ----------------

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


def enc_str(field_no, s):
    data = s.encode("utf-8")
    return bytes([(field_no << 3) | 2]) + enc_varint(len(data)) + data


def enc_uint(field_no, v):
    if v == 0:
        return b""  # proto3 omits zero scalars
    return bytes([(field_no << 3) | 0]) + enc_varint(v)


def dec_varint(blob, i):
    v = 0
    shift = 0
    while i < len(blob):
        b = blob[i]
        i += 1
        v |= (b & 0x7F) << shift
        if not (b & 0x80):
            return v, i
        shift += 7
    return v, i


def dec_fields(blob):
    """Walk a proto3 blob -> {field_no: last value} (bytes for len-delimited, int for varint)."""
    out = {}
    i = 0
    try:
        while i < len(blob):
            key, i = dec_varint(blob, i)
            fno, wt = key >> 3, key & 7
            if wt == 0:
                out[fno], i = dec_varint(blob, i)
            elif wt == 2:
                ln, i = dec_varint(blob, i)
                out[fno] = blob[i:i + ln]
                i += ln
            elif wt == 5:
                out[fno] = blob[i:i + 4]
                i += 4
            elif wt == 1:
                out[fno] = blob[i:i + 8]
                i += 8
            else:
                break
    except (IndexError, ValueError):
        pass
    return out


# ---- wire helpers ----------------------------------------------------------------------

def packet(ptype, cmd, pkt_id, payload):
    total = HEADER_SIZE + len(payload)
    return (bytes([ptype]) + struct.pack("<H", cmd) + struct.pack("<I", total)
            + struct.pack("<Q", pkt_id) + payload)


def reply_ok(cmd, pkt_id, blob):
    return packet(TYPE_REPLY, cmd, pkt_id, bytes([ERR_NO_ERROR])
                  + struct.pack("<I", len(blob)) + blob)


def reply_err(cmd, pkt_id, err):
    return packet(TYPE_REPLY, cmd, pkt_id, bytes([err]))


def recv_exact(conn, n):
    buf = b""
    while len(buf) < n:
        chunk = conn.recv(n - len(buf))
        if not chunk:
            return None
        buf += chunk
    return buf


def extract_request_blob(payload):
    """Request payload = LE32 blob length + blob."""
    if len(payload) < 4:
        return b""
    ln = struct.unpack("<I", payload[:4])[0]
    return payload[4:4 + ln]


# ---- per-connection handler ------------------------------------------------------------

def handle(conn, addr, conn_no):
    tag = "conn#%d" % conn_no
    npid = ""
    try:
        conn.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
        # The server speaks first: ServerInfo with LE32 protocol version.
        conn.sendall(packet(TYPE_SERVERINFO, 0, 0, struct.pack("<I", PROTOCOL_VERSION)))
        log("%s open from %s:%d - ServerInfo v%d sent" % (tag, addr[0], addr[1], PROTOCOL_VERSION))

        while True:
            hdr = recv_exact(conn, HEADER_SIZE)
            if hdr is None:
                log("%s closed by peer" % tag)
                return
            ptype = hdr[0]
            cmd = struct.unpack("<H", hdr[1:3])[0]
            total = struct.unpack("<I", hdr[3:7])[0]
            pkt_id = struct.unpack("<Q", hdr[7:15])[0]
            if total < HEADER_SIZE or total > MAX_PACKET:
                log("%s corrupt packet (total=%d) - dropping connection" % (tag, total))
                return
            payload = b""
            if total > HEADER_SIZE:
                payload = recv_exact(conn, total - HEADER_SIZE)
                if payload is None:
                    log("%s truncated payload - peer gone" % tag)
                    return

            name = CMD_NAMES.get(cmd, "cmd%d" % cmd)
            if ptype != TYPE_REQUEST:
                log("%s ignoring non-request packet type=%d cmd=%s" % (tag, ptype, name))
                continue

            if cmd == CMD_LOGIN:
                fields = dec_fields(extract_request_blob(payload))
                npid = fields.get(1, b"").decode("utf-8", "replace")
                title_id = fields.get(4, b"").decode("utf-8", "replace")
                title_name = fields.get(5, b"").decode("utf-8", "replace")
                log("%s Login npid='%s' title_id='%s' title='%s' -> NoError (account id %d)"
                    % (tag, npid, title_id, title_name, ACCOUNT_ID))
                blob = enc_uint(2, ACCOUNT_ID)  # LoginReply{user_id}; must be non-empty
                conn.sendall(reply_ok(cmd, pkt_id, blob))
            elif cmd == CMD_GET_TOKEN:
                blob = (enc_str(1, BEARER_TOKEN) + enc_uint(2, ACCOUNT_ID)
                        + enc_str(3, npid or "Nikos"))
                log("%s GetToken -> bearer for npid='%s'" % (tag, npid))
                conn.sendall(reply_ok(cmd, pkt_id, blob))
            elif cmd == CMD_GET_SERVER_FEATURES:
                # Empty blob = ServerFeaturesReply defaults: matching2_enabled=false.
                # This reply is what releases the client's WaitForAuthenticated().
                log("%s GetServerFeatures -> defaults (matching2 off)" % tag)
                conn.sendall(reply_ok(cmd, pkt_id, b""))
            elif cmd in (CMD_SET_APPEAR_OFFLINE, CMD_TERMINATE):
                log("%s %s -> NoError" % (tag, name))
                conn.sendall(reply_err(cmd, pkt_id, ERR_NO_ERROR))
            else:
                log("%s %s (pkt_id=%d, %d bytes) -> Unsupported" % (tag, name, pkt_id, len(payload)))
                conn.sendall(reply_err(cmd, pkt_id, ERR_UNSUPPORTED))
    except (ConnectionError, OSError) as e:
        log("%s socket error: %s" % (tag, e))
    finally:
        try:
            conn.close()
        except OSError:
            pass


# ---- main ------------------------------------------------------------------------------

WEBAPI_PORT = 31315


# The three NP WebAPI calls GT7 makes right after sign-in, answered with the REAL empty
# shapes instead of 404 (24 Aug, run 133): the game froze on the black GT loading screen
# polling sceNpCheckCallback forever after this trio 404'd - a signed-in console whose
# social queries FAIL is a state the game's init flow does not model, while "signed in,
# zero friends, zero blocks, not restricted" is an ordinary Tuesday.
_WEBAPI_ROUTES = (
    ("/friends",   b'{"friends":[],"start":0,"size":0,"totalItemCount":0}'),
    ("/communication/restriction/status", b'{"restricted":false}'),
    ("/blocks",    b'{"blocks":[],"start":0,"size":0,"totalItemCount":0}'),
)


def handle_webapi(conn, addr):
    """Minimal HTTP responder for NP WebAPI calls: the three known GT7 sign-in queries get
    real 200 answers with empty-but-well-formed bodies; anything unknown gets a REAL 404
    response instead of an instantly-refused connect. GT7's downloader worker races
    its own init when a connect is refused in microseconds (the FWRKR null-read)."""
    try:
        conn.settimeout(5)
        data = b""
        while b"\r\n\r\n" not in data and len(data) < 65536:
            chunk = conn.recv(4096)
            if not chunk:
                break
            data += chunk
        first = data.split(b"\r\n", 1)[0].decode("ascii", "replace") if data else "(empty)"
        path = first.split(" ")[1] if len(first.split(" ")) > 1 else ""
        status, body = b"404 Not Found", b"{}"
        for needle, answer in _WEBAPI_ROUTES:
            if needle in path.split("?")[0]:
                status, body = b"200 OK", answer
                break
        log("webapi: %s -> %s" % (first, status.decode("ascii")))
        conn.sendall(b"HTTP/1.1 " + status + b"\r\nContent-Type: application/json\r\n"
                     b"Content-Length: " + str(len(body)).encode() + b"\r\n"
                     b"Connection: close\r\n\r\n" + body)
    except OSError:
        pass
    finally:
        try:
            conn.close()
        except OSError:
            pass


def webapi_listener():
    srv = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    try:
        srv.bind((HOST, WEBAPI_PORT))
    except OSError as e:
        log("webapi bind %s:%d failed (%s) - skipping HTTP responder" % (HOST, WEBAPI_PORT, e))
        return
    srv.listen(8)
    log("webapi HTTP responder listening on %s:%d" % (HOST, WEBAPI_PORT))
    while True:
        conn, addr = srv.accept()
        threading.Thread(target=handle_webapi, args=(conn, addr), daemon=True).start()


def main():
    srv = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    # NO SO_REUSEADDR on purpose: on Windows it would allow a second instance to bind the
    # same port; a plain bind failing IS our single-instance guard.
    try:
        srv.bind((HOST, PORT))
    except OSError as e:
        log("bind %s:%d failed (%s) - another instance is probably running; exiting quietly"
            % (HOST, PORT, e))
        return 0
    srv.listen(8)
    log("shadNet local server listening on %s:%d (protocol v%d, account id %d)"
        % (HOST, PORT, PROTOCOL_VERSION, ACCOUNT_ID))
    threading.Thread(target=webapi_listener, daemon=True).start()

    conn_no = 0
    while True:
        conn, addr = srv.accept()
        conn_no += 1
        threading.Thread(target=handle, args=(conn, addr, conn_no), daemon=True).start()


if __name__ == "__main__":
    sys.exit(main())
