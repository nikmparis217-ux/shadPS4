# Headless RenderDoc replay for GT7 Act 12.
#
# Run through qrenderdoc --python. The script opens the capture itself, inspects the three
# draws that write the HDR scene immediately before fs_ae20a0bc, writes a compact report,
# then terminates qrenderdoc before its UI opens.

import os
import math
import struct
import sys
import traceback

import renderdoc as rd


CAPTURE = os.environ["RDC_CAPTURE"]
REPORT = os.environ["RDC_REPORT"]
TARGET_EIDS = tuple(
    int(value, 0)
    for value in os.environ.get("RDC_EIDS", "16605,17790,18254,18266,18275,18286").split(",")
    if value.strip()
)

lines = []
current_event_id = 0


def log(value=""):
    lines.append(str(value))


def resource_name_map(controller):
    return {r.resourceId: r.name for r in controller.GetResources()}


def resource_from_token(names, value):
    wanted = "resourceid::%d" % int(value, 0)
    return next((resource for resource in names if str(resource).lower() == wanted), None)


def minmax(controller, resource):
    try:
        mn, mx = controller.GetMinMax(
            resource, rd.Subresource(0, 0, 0), rd.CompType.Typeless
        )
        return "min(%g %g %g %g) max(%g %g %g %g)" % tuple(
            list(mn.floatValue[:4]) + list(mx.floatValue[:4])
        )
    except Exception as exc:
        return "minmax failed: %s" % exc


def decode_ufloat(bits, mantissa_bits):
    exponent = (bits >> mantissa_bits) & 0x1F
    mantissa = bits & ((1 << mantissa_bits) - 1)
    if exponent == 0:
        return (mantissa / float(1 << mantissa_bits)) * (2.0 ** -14)
    if exponent == 0x1F:
        return float("inf") if mantissa == 0 else float("nan")
    return (1.0 + mantissa / float(1 << mantissa_bits)) * (2.0 ** (exponent - 15))


def export_r11_previews(data, texture):
    output_dir = os.environ.get("RDC_EXPORT_R11_DIR", "").strip()
    if not output_dir:
        return
    os.makedirs(output_dir, exist_ok=True)
    exposure = float(os.environ.get("RDC_EXPORT_R11_EXPOSURE", "1.0"))
    color = bytearray()
    mask = bytearray()
    for packed, in struct.iter_unpack("<I", data):
        values = (
            decode_ufloat(packed & 0x7FF, 6),
            decode_ufloat((packed >> 11) & 0x7FF, 6),
            decode_ufloat((packed >> 22) & 0x3FF, 5),
        )
        saturated = any((not math.isfinite(value)) or value >= 60000.0 for value in values)
        for value in values:
            mapped = 1.0 if not math.isfinite(value) else 1.0 - math.exp(-max(value, 0.0) * exposure)
            color.append(max(0, min(255, int((mapped ** (1.0 / 2.2)) * 255.0 + 0.5))))
        mask.extend((255, 255, 255) if saturated else (0, 0, 0))
    header = "P6\n%d %d\n255\n" % (texture.width, texture.height)
    stem = "eid_%d_id_%s" % (current_event_id, str(texture.resourceId).split("::")[-1])
    for suffix, payload in (("color", color), ("saturated", mask)):
        with open(os.path.join(output_dir, "%s_%s.ppm" % (stem, suffix)), "wb") as output:
            output.write(header.encode("ascii"))
            output.write(payload)


def dump_texture_stats(controller, texture, label):
    try:
        data = bytes(
            controller.GetTextureData(texture.resourceId, rd.Subresource(0, 0, 0))
        )
        format_name = texture.format.Name()
        log("STATS %s %s %dx%dx%d bytes=%d" % (
            label, format_name, texture.width, texture.height, texture.depth, len(data)
        ))
        if format_name == "R11G11B10_FLOAT":
            export_r11_previews(data, texture)
            thresholds = tuple(
                float(value)
                for value in os.environ.get(
                    "RDC_STATS_THRESHOLDS", "1,10,100,1000,60000"
                ).split(",")
                if value.strip()
            )
            total = texture.width * texture.height * max(texture.depth, 1)
            log("  pixels=%d" % total)
            for threshold in thresholds:
                channel_counts = []
                for channel in range(3):
                    channels = [False, False, False, False]
                    channels[channel] = True
                    histogram = controller.GetHistogram(
                        texture.resourceId,
                        rd.Subresource(0, 0, 0),
                        rd.CompType.Typeless,
                        threshold,
                        65536.0,
                        channels,
                    )
                    channel_counts.append(sum(histogram))
                log(
                    "  >=%-7g rgb=%s pct=%s"
                    % (
                        threshold,
                        "/".join(str(count) for count in channel_counts),
                        "/".join(
                            "%.5f" % (100.0 * count / float(total or 1))
                            for count in channel_counts
                        ),
                    )
                )
            if os.environ.get("RDC_STATS_LOCATIONS", "1") == "1":
                r_cut = next(
                    value for value in range(0x800)
                    if decode_ufloat(value, 6) >= 60000.0
                )
                b_cut = next(
                    value for value in range(0x400)
                    if decode_ufloat(value, 5) >= 60000.0
                )
                locations = []
                for index, (packed,) in enumerate(struct.iter_unpack("<I", data)):
                    red = packed & 0x7FF
                    green = (packed >> 11) & 0x7FF
                    blue = (packed >> 22) & 0x3FF
                    if red >= r_cut or green >= r_cut or blue >= b_cut:
                        if len(locations) < 32:
                            locations.append(
                                "%d,%d=(%.0f %.0f %.0f)"
                                % (
                                    index % texture.width,
                                    index // texture.width,
                                    decode_ufloat(red, 6),
                                    decode_ufloat(green, 6),
                                    decode_ufloat(blue, 5),
                                )
                            )
                log("  saturated locations: %s" % " ".join(locations))
        elif format_name == "R32_FLOAT":
            count = len(data) // 4
            values = struct.unpack("<%df" % count, data[: count * 4])
            indices = sorted(set(
                [0, 1, 2, 3, 4, 8, 16, 32, 64, 128, 256, 512, 1024,
                 2048, 4096, 6144, count - 2, count - 1]
            ))
            log("  samples: %s" % " ".join(
                "%d=%.9g" % (index, values[index])
                for index in indices if 0 <= index < count
            ))
            log("  nonzero=%d first_nonzero=%s last=%.9g" % (
                sum(value != 0.0 for value in values),
                next((index for index, value in enumerate(values) if value != 0.0), "none"),
                values[-1] if values else 0.0,
            ))
        else:
            log("  raw stats unsupported for this format")
    except Exception as exc:
        log("STATS %s failed: %s" % (label, exc))


def debug_pixel(controller, resource, x, y, sample):
    log("DEBUG_PIXEL resource=%s xy=%d,%d sample=%d" % (resource, x, y, sample))
    primitive = 0xFFFFFFFF
    try:
        history = controller.PixelHistory(
            resource, x, y, rd.Subresource(0, 0, sample), rd.CompType.Typeless
        )
        log("  history modifications=%d" % len(history))
        for modification in history:
            attrs = []
            for name in (
                "eventId", "primitiveID", "fragIndex", "sampleMasked", "backfaceCulled",
                "depthTestFailed", "stencilTestFailed", "shaderDiscarded",
            ):
                if hasattr(modification, name):
                    attrs.append("%s=%s" % (name, getattr(modification, name)))
            log("  HISTORY " + " ".join(attrs))
            if getattr(modification, "eventId", -1) == int(os.environ.get("RDC_DEBUG_EID", "-1")):
                primitive = getattr(modification, "primitiveID", primitive)
    except Exception as exc:
        log("  pixel history failed: %s" % exc)

    inputs = rd.DebugPixelInputs()
    inputs.sample = sample
    inputs.primitive = primitive
    inputs.view = 0
    trace = controller.DebugPixel(x, y, inputs)
    if trace is None or trace.debugger is None:
        log("  shader debugging returned no trace")
        if trace is not None:
    controller.FreeTrace(trace)


def unpack_regular_value(var_type, comp_count, data, offset):
    byte_width = rd.VarTypeByteSize(var_type)
    comp_type = rd.VarTypeCompType(var_type)
    chars = {
        rd.CompType.UInt: "xBHxIxxxL",
        rd.CompType.SInt: "xbhxixxxl",
        rd.CompType.Float: "xxexfxxxd",
    }
    char = chars.get(comp_type, chars[rd.CompType.Float])[byte_width]
    return struct.unpack_from(str(comp_count) + char, data, offset)


def dump_postvs_primitive(controller, primitive):
    try:
        postvs = controller.GetPostVSData(0, 0, rd.MeshDataStage.VSOut)
        log(
            "POSTVS primitive=%d vertices=%s stride=%s indices=%s indexStride=%s"
            % (
                primitive,
                postvs.vertexResourceId,
                postvs.vertexByteStride,
                postvs.indexResourceId,
                postvs.indexByteStride,
            )
        )
        first_index = primitive * 3
        if postvs.indexResourceId != rd.ResourceId.Null():
            index_data = bytes(
                controller.GetBufferData(postvs.indexResourceId, postvs.indexByteOffset, 0)
            )
            index_char = {1: "B", 2: "H", 4: "I"}[postvs.indexByteStride]
            indices = struct.unpack_from(
                "<3" + index_char,
                index_data,
                first_index * postvs.indexByteStride,
            )
            indices = tuple(index + postvs.baseVertex for index in indices)
        else:
            indices = (first_index, first_index + 1, first_index + 2)

        reflection = controller.GetPipelineState().GetShaderReflection(rd.ShaderStage.Vertex)
        signatures = list(reflection.outputSignature)
        position_index = next(
            (
                index
                for index, attr in enumerate(signatures)
                if attr.systemValue == rd.ShaderBuiltin.Position
            ),
            0,
        )
        if position_index:
            signatures.insert(0, signatures.pop(position_index))
        offsets = []
        running_offset = 0
        for attr in signatures:
            offsets.append(running_offset)
            byte_width = rd.VarTypeByteSize(attr.varType)
            running_offset += (8 if byte_width > 4 else 4) * attr.compCount

        for corner, vertex_index in enumerate(indices):
            vertex_data = bytes(
                controller.GetBufferData(
                    postvs.vertexResourceId,
                    postvs.vertexByteOffset + postvs.vertexByteStride * vertex_index,
                    postvs.vertexByteStride,
                )
            )
            log("  POSTVS corner=%d index=%d raw=%s" % (corner, vertex_index, vertex_data.hex()))
            for attr, offset in zip(signatures, offsets):
                name = attr.varName or attr.semanticIdxName
                try:
                    values = unpack_regular_value(attr.varType, attr.compCount, vertex_data, offset)
                    bad = any(
                        isinstance(value, float) and not math.isfinite(value) for value in values
                    )
                    log("    %s off=%d values=%s%s" % (name, offset, values, " BAD" if bad else ""))
                except Exception as exc:
                    log("    %s off=%d decode failed: %s" % (name, offset, exc))
    except Exception as exc:
        log("POSTVS failed: %s" % exc)
        return

    log("  trace stage=%s primitive=%s inputs=%d" % (
        trace.stage, primitive, len(trace.inputs)
    ))

    inst_info = sorted(trace.instInfo, key=lambda info: info.instruction)

    def disassembly_line(instruction):
        selected = None
        for info in inst_info:
            if info.instruction > instruction:
                break
            selected = info
        return selected.lineInfo.disassemblyLine if selected is not None else 0

    suspicious_count = 0
    total_states = 0
    batches = 0
    try:
        while batches < 10000:
            states = controller.ContinueDebug(trace.debugger)
            batches += 1
            if not states:
                break
            for state in states:
                total_states += 1
                for change in state.changes:
                    variable = change.after
                    if variable.rows == 0 or variable.columns == 0:
                        continue
                    if variable.type != rd.VarType.Float:
                        continue
                    count = max(1, int(variable.rows) * int(variable.columns))
                    values = list(variable.value.f32v[:count])
                    suspicious = any(
                        not math.isfinite(value) or abs(value) >= 10000.0
                        for value in values
                    )
                    is_output = "frag_color" in variable.name
                    if (suspicious or is_output) and suspicious_count < 512:
                        suspicious_count += 1
                        log(
                            "  STEP %d next=%d line=%d var=%s values=%s flags=%s"
                            % (
                                state.stepIndex,
                                state.nextInstruction,
                                disassembly_line(max(0, state.nextInstruction - 1)),
                                variable.name,
                                ",".join("%.9g" % value for value in values),
                                state.flags,
                            )
                        )
        log(
            "  debug complete states=%d batches=%d suspicious=%d"
            % (total_states, batches, suspicious_count)
        )
    finally:
        controller.FreeTrace(trace)


def binding_resources(arrays):
    for array in arrays:
        if hasattr(array, "resources"):
            for bound in array.resources:
                yield bound.resource, 0, 0
        elif hasattr(array, "descriptor"):
            desc = array.descriptor
            yield (
                desc.resource,
                getattr(desc, "byteOffset", 0),
                getattr(desc, "byteSize", 0),
            )
        elif hasattr(array, "resource"):
            yield array.resource, 0, 0


def dump_words(controller, resource, offset, size, label):
    try:
        raw = bytes(controller.GetBufferData(resource, offset, min(max(size, 64), 512)))
        count = len(raw) // 4
        words = struct.unpack("<%dI" % count, raw[: count * 4])
        floats = struct.unpack("<%df" % count, raw[: count * 4])
        log("  %s %s off=%d bytes=%d" % (label, resource, offset, len(raw)))
        for base in range(0, count, 8):
            hs = " ".join("%08x" % x for x in words[base : base + 8])
            fs = " ".join(
                ("%g" % x) if x == x and abs(x) < 1.0e30 else "nan/inf"
                for x in floats[base : base + 8]
            )
            log("    dw%03d %s | %s" % (base, hs, fs))
    except Exception as exc:
        log("  %s dump failed: %s" % (label, exc))


def action_map(controller):
    found = {}

    def walk(actions):
        for action in actions:
            found[action.eventId] = action
            walk(action.children)

    walk(controller.GetRootActions())
    return found


def inspect_event(controller, event_id, actions, names, textures, buffers):
    global current_event_id
    current_event_id = event_id
    action = actions.get(event_id)
    log("\n=== eid %d %s ===" % (event_id, action.GetName(controller.GetStructuredFile()) if action else "?"))
    if action is not None:
        for attr in ("copySource", "copyDestination", "outputs", "depthOut", "flags"):
            if hasattr(action, attr):
                log("ACTION %s=%s" % (attr, getattr(action, attr)))
    controller.SetFrameEvent(event_id, True)
    pipe = controller.GetPipelineState()

    postvs_spec = os.environ.get("RDC_POSTVS_PRIMITIVE", "").strip()
    if postvs_spec and event_id == int(os.environ.get("RDC_POSTVS_EID", "-1"), 0):
        dump_postvs_primitive(controller, int(postvs_spec, 0))

    if action is not None:
        for attr in ("copySource", "copyDestination"):
            resource = getattr(action, attr, rd.ResourceId.Null())
            if resource != rd.ResourceId.Null():
                if resource in textures:
                    texture = textures[resource]
                    log(
                        "COPY %s %s %dx%dx%d %s [%s] %s"
                        % (
                            attr,
                            resource,
                            texture.width,
                            texture.height,
                            texture.depth,
                            texture.format.Name(),
                            names.get(resource, "?"),
                            minmax(controller, resource),
                        )
                    )
                else:
                    log("COPY %s %s [%s]" % (attr, resource, names.get(resource, "?")))

    for address in os.environ.get(
        "RDC_WATCH_ADDRS", "0x1005000000,0x1006bc8000,0x1007600000"
    ).split(","):
        address = address.strip().lower()
        if not address:
            continue
        for resource, name in names.items():
            if address in name.lower() and resource in textures:
                log("WATCH %s %s [%s] %s" % (address, resource, name, minmax(controller, resource)))
                break

    for value in os.environ.get("RDC_WATCH_IDS", "").split(","):
        value = value.strip()
        if not value:
            continue
        resource = resource_from_token(names, value)
        if resource is not None:
            log("WATCH id:%s %s [%s] %s" % (
                value, resource, names.get(resource, "?"), minmax(controller, resource)
            ))

    for address in os.environ.get("RDC_TEXTURE_STATS_ADDRS", "").split(","):
        address = address.strip().lower()
        if not address:
            continue
        for resource, name in names.items():
            if address in name.lower() and resource in textures:
                dump_texture_stats(controller, textures[resource], "%s %s" % (address, resource))
                break
    for value in os.environ.get("RDC_TEXTURE_STATS_IDS", "").split(","):
        value = value.strip()
        if not value:
            continue
        resource = resource_from_token(names, value)
        if resource in textures:
            dump_texture_stats(controller, textures[resource], "id:%s %s" % (value, resource))

    debug_spec = os.environ.get("RDC_DEBUG_PIXEL", "").strip()
    if debug_spec and event_id == int(os.environ.get("RDC_DEBUG_EID", "-1"), 0):
        x, y, sample = (int(value, 0) for value in debug_spec.split(","))
        resource_value = os.environ.get("RDC_DEBUG_RESOURCE", "").strip()
        resource = resource_from_token(names, resource_value)
        if resource is not None:
            reflection = pipe.GetShaderReflection(rd.ShaderStage.Fragment)
            if reflection is not None:
                log(
                    "DEBUG_STATUS debuggable=%s source=%s reason=%s"
                    % (
                        reflection.debugInfo.debuggable,
                        reflection.debugInfo.sourceDebugInformation,
                        reflection.debugInfo.debugStatus,
                    )
                )
            debug_pixel(controller, resource, x, y, sample)
        else:
            log("DEBUG_PIXEL resource not found: %s" % resource_value)

    if os.environ.get("RDC_MINMAX_ONLY", "0") == "1":
        return

    try:
        pipeline = pipe.GetGraphicsPipelineObject()
        log("pipeline %s [%s]" % (pipeline, names.get(pipeline, "?")))
    except Exception as exc:
        log("pipeline lookup failed: %s" % exc)

    try:
        reflection = pipe.GetShaderReflection(rd.ShaderStage.Fragment)
        if reflection is not None:
            shader_id = getattr(reflection, "resourceId", rd.ResourceId.Null())
            log(
                "fragment shader %s [%s] entry=%s"
                % (shader_id, names.get(shader_id, "?"), getattr(reflection, "entryPoint", "?"))
            )
            if os.environ.get("RDC_DISASSEMBLE", "0") == "1":
                targets = controller.GetDisassemblyTargets(True)
                log("disassembly targets: %s" % ", ".join(str(target) for target in targets))
                if targets:
                    disassembly = controller.DisassembleShader(
                        pipe.GetGraphicsPipelineObject(), reflection, targets[0]
                    )
                    log("--- fragment disassembly (%s) ---" % targets[0])
                    log(disassembly)
                    log("--- end fragment disassembly ---")
    except Exception as exc:
        log("fragment reflection failed: %s" % exc)

    if os.environ.get("RDC_DISASSEMBLE", "0") == "1":
        try:
            reflection = pipe.GetShaderReflection(rd.ShaderStage.Vertex)
            if reflection is not None:
                shader_id = getattr(reflection, "resourceId", rd.ResourceId.Null())
                log(
                    "vertex shader %s [%s] entry=%s"
                    % (shader_id, names.get(shader_id, "?"), getattr(reflection, "entryPoint", "?"))
                )
                targets = controller.GetDisassemblyTargets(True)
                if targets:
                    disassembly = controller.DisassembleShader(
                        pipe.GetGraphicsPipelineObject(), reflection, targets[0]
                    )
                    log("--- vertex disassembly (%s) ---" % targets[0])
                    log(disassembly)
                    log("--- end vertex disassembly ---")
        except Exception as exc:
            log("vertex disassembly failed: %s" % exc)

    for label, getter_name in (
        ("depth", "GetDepthState"),
        ("rasterizer", "GetRasterizerState"),
        ("color blends", "GetColorBlends"),
    ):
        try:
            getter = getattr(pipe, getter_name, None)
            if getter is not None:
                log("%s state: %s" % (label, getter()))
        except Exception as exc:
            log("%s state failed: %s" % (label, exc))

    for target in pipe.GetOutputTargets():
        if target.resource != rd.ResourceId.Null():
            log(
                "OUT %s [%s] %s"
                % (target.resource, names.get(target.resource, "?"), minmax(controller, target.resource))
            )

    try:
        for resource, offset, size in binding_resources(
            pipe.GetReadOnlyResources(rd.ShaderStage.Fragment)
        ):
            if resource == rd.ResourceId.Null():
                continue
            if resource in textures:
                texture = textures[resource]
                log(
                    "TEX %s %dx%dx%d %s [%s] %s"
                    % (
                        resource,
                        texture.width,
                        texture.height,
                        texture.depth,
                        texture.format.Name(),
                        names.get(resource, "?"),
                        minmax(controller, resource),
                    )
                )
            elif resource in buffers:
                dump_words(controller, resource, offset, size or 256, "FRAG RO")
    except Exception as exc:
        log("fragment resource iteration failed: %s" % exc)

    for stage, stage_name in (
        (rd.ShaderStage.Vertex, "VERT"),
        (rd.ShaderStage.Fragment, "FRAG"),
    ):
        for access_name, getter in (
            ("RO", pipe.GetReadOnlyResources),
            ("RW", pipe.GetReadWriteResources),
        ):
            try:
                for resource, offset, size in binding_resources(getter(stage)):
                    if resource in buffers:
                        dump_words(
                            controller,
                            resource,
                            offset,
                            size or 256,
                            "%s %s" % (stage_name, access_name),
                        )
            except Exception as exc:
                log("%s %s buffers failed: %s" % (stage_name, access_name, exc))

    try:
        vbuffers = pipe.GetVBuffers()
        log("vertex buffers: %d" % len(vbuffers))
        for index, vb in enumerate(vbuffers):
            resource = getattr(vb, "resourceId", getattr(vb, "resource", rd.ResourceId.Null()))
            offset = getattr(vb, "byteOffset", 0)
            stride = getattr(vb, "byteStride", 0)
            size = getattr(vb, "byteSize", 256)
            log(
                "  VB%d %s [%s] off=%d stride=%d size=%d"
                % (index, resource, names.get(resource, "?"), offset, stride, size)
            )
            if resource != rd.ResourceId.Null():
                dump_words(controller, resource, offset, min(size or 256, 256), "VB%d" % index)
    except Exception as exc:
        log("vertex buffers failed: %s" % exc)

    try:
        inputs = pipe.GetVertexInputs()
        log("vertex inputs: %d" % len(inputs))
        for inp in inputs:
            log("  %s" % inp)
            attrs = []
            for name in ("name", "vertexBuffer", "byteOffset", "perInstance", "instanceRate"):
                if hasattr(inp, name):
                    attrs.append("%s=%s" % (name, getattr(inp, name)))
            if hasattr(inp, "format"):
                attrs.append("format=%s" % inp.format.Name())
            log("    " + " ".join(attrs))
    except Exception as exc:
        log("vertex inputs failed: %s" % exc)


def run():
    capture = rd.OpenCaptureFile()
    result = capture.OpenFile(CAPTURE, "", None)
    if result != rd.ResultCode.Succeeded:
        raise RuntimeError("OpenFile failed: %s" % result)
    result, controller = capture.OpenCapture(rd.ReplayOptions(), None)
    if result != rd.ResultCode.Succeeded:
        raise RuntimeError("OpenCapture failed: %s" % result)
    try:
        names = resource_name_map(controller)
        textures = {t.resourceId: t for t in controller.GetTextures()}
        buffers = {b.resourceId: b for b in controller.GetBuffers()}
        actions = action_map(controller)
        write_words = ("RW", "ColorTarget", "DepthStencilTarget", "CopyDst", "ResolveDst", "Clear")
        usage_resources = []
        for address in os.environ.get("RDC_USAGE_ADDRS", "0x1005000000").split(","):
            address = address.strip().lower()
            if not address:
                continue
            for resource, name in names.items():
                if address in name.lower() and resource in textures:
                    usage_resources.append((address, resource, name))
                    break
        for value in os.environ.get("RDC_USAGE_IDS", "").split(","):
            value = value.strip()
            if not value:
                continue
            resource = resource_from_token(names, value)
            if resource is not None:
                usage_resources.append(("id:%s" % value, resource, names.get(resource, "?")))
        for label, resource, name in usage_resources:
            log("USAGE %s %s [%s]" % (label, resource, name))
            for usage in controller.GetUsage(resource):
                usage_name = str(usage.usage)
                if any(word in usage_name for word in write_words):
                    action = actions.get(usage.eventId)
                    action_name = action.GetName(controller.GetStructuredFile()) if action else "?"
                    log("  WRITE eid %d %s %s" % (usage.eventId, usage_name, action_name))
        scan_range = os.environ.get("RDC_SCAN_EID_RANGE", "").strip()
        if scan_range:
            first, last = (int(value, 0) for value in scan_range.split(","))
            log("SCAN EIDS %d..%d" % (first, last))
            for event_id in sorted(eid for eid in actions if first <= eid <= last):
                action = actions[event_id]
                if not (action.flags & rd.ActionFlags.Drawcall):
                    continue
                controller.SetFrameEvent(event_id, True)
                pipe = controller.GetPipelineState()
                reflection = pipe.GetShaderReflection(rd.ShaderStage.Fragment)
                shader_id = (
                    getattr(reflection, "resourceId", rd.ResourceId.Null())
                    if reflection is not None
                    else rd.ResourceId.Null()
                )
                attrs = []
                for attr in ("numIndices", "numInstances", "indexOffset", "vertexOffset"):
                    if hasattr(action, attr):
                        attrs.append("%s=%s" % (attr, getattr(action, attr)))
                log(
                    "  DRAW eid %d fs=%s [%s] %s"
                    % (event_id, shader_id, names.get(shader_id, "?"), " ".join(attrs))
                )
        for event_id in TARGET_EIDS:
            inspect_event(controller, event_id, actions, names, textures, buffers)
    finally:
        controller.Shutdown()
        capture.Shutdown()


try:
    run()
except BaseException:
    log(traceback.format_exc())

with open(REPORT, "w", encoding="utf-8") as report:
    report.write("\n".join(lines))
    report.flush()

os._exit(0)
