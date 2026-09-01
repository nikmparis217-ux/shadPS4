#version 450
#if defined(GL_EXT_shader_explicit_arithmetic_types_int8)
#extension GL_EXT_shader_explicit_arithmetic_types_int8 : require
#elif defined(GL_NV_gpu_shader5)
#extension GL_NV_gpu_shader5 : require
#else
#error No extension available for Int8.
#endif
#if defined(GL_EXT_shader_explicit_arithmetic_types_int16)
#extension GL_EXT_shader_explicit_arithmetic_types_int16 : require
#elif defined(GL_AMD_gpu_shader_int16)
#extension GL_AMD_gpu_shader_int16 : require
#elif defined(GL_NV_gpu_shader5)
#extension GL_NV_gpu_shader5 : require
#else
#error No extension available for Int16.
#endif
#if defined(GL_ARB_gpu_shader_int64)
#extension GL_ARB_gpu_shader_int64 : require
#elif defined(GL_NV_gpu_shader5)
#extension GL_NV_gpu_shader5 : require
#else
#error No extension available for 64-bit integers.
#endif
#ifdef GL_ARB_shader_draw_parameters
#extension GL_ARB_shader_draw_parameters : enable
#endif
#extension GL_ARB_shader_viewport_layer_array : require

struct full_result_i32x2
{
    int _m0;
    int _m1;
};

struct full_result_u32x2
{
    uint _m0;
    uint _m1;
};

struct frexp_result_f32
{
    float _m0;
    int _m1;
};

layout(binding = 0, std430) readonly buffer ssbo_1
{
    uint data[];
} ssbo_1_1;

layout(binding = 1, std430) readonly buffer clip_planes
{
    float data[];
} clip_planes_1;

layout(binding = 2, std430) readonly buffer srt_flatbuf
{
    uint data[];
} srt_flatbuf_1;

struct AuxData
{
    float xoffset;
    float yoffset;
    float xscale;
    float yscale;
    uvec4 ud_regs0;
    uvec4 ud_regs1;
    uvec4 ud_regs2;
    uvec4 ud_regs3;
    uvec4 buf_offsets0;
    uvec4 buf_offsets1;
    uvec2 buf_offsets2;
};

uniform AuxData push_data;

#ifdef GL_ARB_shader_draw_parameters
#define SPIRV_Cross_BaseVertex gl_BaseVertexARB
#else
uniform int SPIRV_Cross_BaseVertex;
#endif
#ifdef GL_ARB_shader_draw_parameters
#define SPIRV_Cross_BaseInstance gl_BaseInstanceARB
#else
uniform int SPIRV_Cross_BaseInstance;
#endif
layout(location = 0) in vec4 vs_in_attr0;
layout(location = 0) out vec4 out_attr0;

void main()
{
    uint buf0_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(0u), int(8u)) >> 2u;
    vec4 _94 = vec4(vs_in_attr0.x, vs_in_attr0.y, vs_in_attr0.z, vs_in_attr0.w);
    vec4 _97 = vec4(_94.x, _94.y, _94.z, vec4(0.0, 1.0, 0.0, 0.0).y);
    float _98 = _97.x;
    float _99 = _97.y;
    float _100 = _97.z;
    uint _158 = ((uint((gl_InstanceID + SPIRV_Cross_BaseInstance)) * 60u) + 12u) + buf0_dword_off;
    uvec4 _170 = uvec4(ssbo_1_1.data[_158], ssbo_1_1.data[_158 + 1u], ssbo_1_1.data[_158 + 2u], ssbo_1_1.data[_158 + 3u]);
    uint _171 = _170.x;
    uint _172 = _170.y;
    uint _173 = _170.z;
    uint _174 = _170.w;
    uint _176 = (uint((gl_InstanceID + SPIRV_Cross_BaseInstance)) * 60u) + buf0_dword_off;
    uvec4 _188 = uvec4(ssbo_1_1.data[_176], ssbo_1_1.data[_176 + 1u], ssbo_1_1.data[_176 + 2u], ssbo_1_1.data[_176 + 3u]);
    uint _189 = _188.x;
    uint _190 = _188.y;
    uint _191 = _188.z;
    uint _192 = _188.w;
    uint _195 = ((uint((gl_InstanceID + SPIRV_Cross_BaseInstance)) * 60u) + 4u) + buf0_dword_off;
    uvec4 _207 = uvec4(ssbo_1_1.data[_195], ssbo_1_1.data[_195 + 1u], ssbo_1_1.data[_195 + 2u], ssbo_1_1.data[_195 + 3u]);
    uint _208 = _207.x;
    uint _209 = _207.y;
    uint _210 = _207.z;
    uint _211 = _207.w;
    uint _214 = ((uint((gl_InstanceID + SPIRV_Cross_BaseInstance)) * 60u) + 8u) + buf0_dword_off;
    uvec4 _226 = uvec4(ssbo_1_1.data[_214], ssbo_1_1.data[_214 + 1u], ssbo_1_1.data[_214 + 2u], ssbo_1_1.data[_214 + 3u]);
    uint _227 = _226.x;
    uint _228 = _226.y;
    uint _229 = _226.z;
    uint _230 = _226.w;
    precise float _233 = uintBitsToFloat(srt_flatbuf_1.data[21u]) * uintBitsToFloat(_171);
    precise float _236 = uintBitsToFloat(srt_flatbuf_1.data[21u]) * uintBitsToFloat(_189);
    precise float _239 = uintBitsToFloat(srt_flatbuf_1.data[24u]) * uintBitsToFloat(_171);
    precise float _242 = uintBitsToFloat(srt_flatbuf_1.data[24u]) * uintBitsToFloat(_189);
    precise float _245 = uintBitsToFloat(srt_flatbuf_1.data[23u]) * uintBitsToFloat(_171);
    precise float _248 = uintBitsToFloat(srt_flatbuf_1.data[23u]) * uintBitsToFloat(_189);
    precise float _251 = uintBitsToFloat(srt_flatbuf_1.data[22u]) * uintBitsToFloat(_171);
    precise float _254 = uintBitsToFloat(srt_flatbuf_1.data[22u]) * uintBitsToFloat(_189);
    precise float _257 = uintBitsToFloat(srt_flatbuf_1.data[21u]) * uintBitsToFloat(_208);
    precise float _260 = uintBitsToFloat(srt_flatbuf_1.data[24u]) * uintBitsToFloat(_208);
    precise float _263 = uintBitsToFloat(_172) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _264 = _263 + _245;
    precise float _267 = uintBitsToFloat(_190) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _268 = _267 + _248;
    precise float _271 = uintBitsToFloat(srt_flatbuf_1.data[23u]) * uintBitsToFloat(_208);
    precise float _274 = uintBitsToFloat(srt_flatbuf_1.data[22u]) * uintBitsToFloat(_208);
    precise float _277 = uintBitsToFloat(srt_flatbuf_1.data[25u]) * uintBitsToFloat(_172);
    precise float _278 = _277 + _233;
    precise float _281 = uintBitsToFloat(srt_flatbuf_1.data[25u]) * uintBitsToFloat(_190);
    precise float _282 = _281 + _236;
    precise float _285 = uintBitsToFloat(srt_flatbuf_1.data[28u]) * uintBitsToFloat(_172);
    precise float _286 = _285 + _239;
    precise float _289 = uintBitsToFloat(srt_flatbuf_1.data[28u]) * uintBitsToFloat(_190);
    precise float _290 = _289 + _242;
    precise float _293 = uintBitsToFloat(srt_flatbuf_1.data[26u]) * uintBitsToFloat(_172);
    precise float _294 = _293 + _251;
    precise float _297 = uintBitsToFloat(srt_flatbuf_1.data[26u]) * uintBitsToFloat(_190);
    precise float _298 = _297 + _254;
    gl_Layer = int(floatBitsToUint(uintBitsToFloat(srt_flatbuf_1.data[20u])));
    precise float _303 = uintBitsToFloat(srt_flatbuf_1.data[21u]) * uintBitsToFloat(_227);
    precise float _306 = uintBitsToFloat(srt_flatbuf_1.data[24u]) * uintBitsToFloat(_227);
    precise float _309 = uintBitsToFloat(_173) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _310 = _309 + _264;
    precise float _313 = uintBitsToFloat(_209) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _314 = _313 + _271;
    precise float _317 = uintBitsToFloat(srt_flatbuf_1.data[23u]) * uintBitsToFloat(_227);
    precise float _320 = uintBitsToFloat(srt_flatbuf_1.data[22u]) * uintBitsToFloat(_227);
    precise float _323 = uintBitsToFloat(srt_flatbuf_1.data[29u]) * uintBitsToFloat(_173);
    precise float _324 = _323 + _278;
    precise float _327 = uintBitsToFloat(srt_flatbuf_1.data[29u]) * uintBitsToFloat(_191);
    precise float _328 = _327 + _282;
    precise float _331 = uintBitsToFloat(srt_flatbuf_1.data[25u]) * uintBitsToFloat(_209);
    precise float _332 = _331 + _257;
    precise float _335 = uintBitsToFloat(srt_flatbuf_1.data[32u]) * uintBitsToFloat(_173);
    precise float _336 = _335 + _286;
    precise float _339 = uintBitsToFloat(_173) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _340 = _339 + _294;
    precise float _343 = uintBitsToFloat(srt_flatbuf_1.data[32u]) * uintBitsToFloat(_191);
    precise float _344 = _343 + _290;
    precise float _347 = uintBitsToFloat(srt_flatbuf_1.data[28u]) * uintBitsToFloat(_209);
    precise float _348 = _347 + _260;
    precise float _351 = uintBitsToFloat(srt_flatbuf_1.data[31u]) * uintBitsToFloat(_191);
    precise float _352 = _351 + _268;
    precise float _355 = uintBitsToFloat(srt_flatbuf_1.data[30u]) * uintBitsToFloat(_191);
    precise float _356 = _355 + _298;
    precise float _359 = uintBitsToFloat(srt_flatbuf_1.data[26u]) * uintBitsToFloat(_209);
    precise float _360 = _359 + _274;
    precise float _363 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(_174);
    precise float _364 = _363 + _324;
    precise float _367 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(_192);
    precise float _368 = _367 + _328;
    precise float _371 = uintBitsToFloat(srt_flatbuf_1.data[29u]) * uintBitsToFloat(_210);
    precise float _372 = _371 + _332;
    precise float _375 = uintBitsToFloat(srt_flatbuf_1.data[25u]) * uintBitsToFloat(_228);
    precise float _376 = _375 + _303;
    precise float _379 = uintBitsToFloat(_174) * uintBitsToFloat(srt_flatbuf_1.data[36u]);
    precise float _380 = _379 + _336;
    precise float _383 = uintBitsToFloat(_210) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _384 = _383 + _314;
    precise float _387 = uintBitsToFloat(_174) * uintBitsToFloat(srt_flatbuf_1.data[34u]);
    precise float _388 = _387 + _340;
    precise float _391 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(_192);
    precise float _392 = _391 + _344;
    precise float _395 = uintBitsToFloat(srt_flatbuf_1.data[32u]) * uintBitsToFloat(_210);
    precise float _396 = _395 + _348;
    precise float _399 = uintBitsToFloat(srt_flatbuf_1.data[28u]) * uintBitsToFloat(_228);
    precise float _400 = _399 + _306;
    precise float _403 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(_174);
    precise float _404 = _403 + _310;
    precise float _407 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(_192);
    precise float _408 = _407 + _352;
    precise float _411 = uintBitsToFloat(srt_flatbuf_1.data[27u]) * uintBitsToFloat(_228);
    precise float _412 = _411 + _317;
    precise float _415 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(_192);
    precise float _416 = _415 + _356;
    precise float _419 = uintBitsToFloat(srt_flatbuf_1.data[30u]) * uintBitsToFloat(_210);
    precise float _420 = _419 + _360;
    precise float _423 = uintBitsToFloat(srt_flatbuf_1.data[26u]) * uintBitsToFloat(_228);
    precise float _424 = _423 + _320;
    precise float _427 = uintBitsToFloat(_229) * uintBitsToFloat(srt_flatbuf_1.data[32u]);
    precise float _428 = _427 + _400;
    precise float _429 = _98 * _408;
    precise float _430 = _429 + _404;
    precise float _431 = _368 * _98;
    precise float _432 = _431 + _364;
    precise float _435 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(_211);
    precise float _436 = _435 + _372;
    precise float _439 = uintBitsToFloat(srt_flatbuf_1.data[29u]) * uintBitsToFloat(_229);
    precise float _440 = _439 + _376;
    precise float _441 = _392 * _98;
    precise float _442 = _441 + _380;
    precise float _445 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(_211);
    precise float _446 = _445 + _396;
    precise float _449 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(_211);
    precise float _450 = _449 + _384;
    precise float _453 = uintBitsToFloat(srt_flatbuf_1.data[31u]) * uintBitsToFloat(_229);
    precise float _454 = _453 + _412;
    precise float _455 = _416 * _98;
    precise float _456 = _455 + _388;
    precise float _459 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(_211);
    precise float _460 = _459 + _420;
    precise float _463 = uintBitsToFloat(srt_flatbuf_1.data[30u]) * uintBitsToFloat(_229);
    precise float _464 = _463 + _424;
    precise float _465 = _436 * _99;
    precise float _466 = _465 + _432;
    precise float _469 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(_230);
    precise float _470 = _469 + _440;
    precise float _471 = _446 * _99;
    precise float _472 = _471 + _442;
    precise float _475 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(_230);
    precise float _476 = _475 + _428;
    precise float _477 = _450 * _99;
    precise float _478 = _477 + _430;
    precise float _481 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(_230);
    precise float _482 = _481 + _454;
    precise float _483 = _460 * _99;
    precise float _484 = _483 + _456;
    precise float _487 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(_230);
    precise float _488 = _487 + _464;
    precise float _489 = _470 * _100;
    precise float _490 = _489 + _466;
    precise float _491 = _476 * _100;
    precise float _492 = _491 + _472;
    precise float _493 = _482 * _100;
    precise float _494 = _493 + _478;
    precise float _495 = _488 * _100;
    precise float _496 = _495 + _484;
    gl_Position.x = _490;
    gl_Position.y = _496;
    gl_Position.z = _494;
    gl_Position.w = _492;
    out_attr0.x = 0.0;
    out_attr0.y = 0.0;
    out_attr0.z = 0.0;
    out_attr0.w = 0.0;
}

