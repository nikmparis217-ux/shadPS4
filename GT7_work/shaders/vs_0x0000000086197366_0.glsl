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

layout(binding = 2, std430) readonly buffer clip_planes
{
    float data[];
} clip_planes_1;

layout(binding = 3, std430) readonly buffer srt_flatbuf
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
layout(location = 1) in vec4 vs_in_attr1;
layout(location = 2) in vec4 vs_in_attr2;
layout(location = 0) out vec4 out_attr0;

void main()
{
    vec4 _93 = vec4(vs_in_attr0.x, vs_in_attr0.y, vs_in_attr0.z, vs_in_attr0.w);
    vec4 _96 = vec4(_93.x, _93.y, _93.z, vec4(0.0, 1.0, 0.0, 0.0).y);
    vec4 _107 = vec4(vs_in_attr1.x, vs_in_attr1.y, vs_in_attr1.z, vs_in_attr1.w);
    vec4 _108 = vec4(_107.x, _107.y, _107.z, vec4(0.0, 1.0, 0.0, 0.0).y);
    float _109 = _108.x;
    float _110 = _108.y;
    float _111 = _108.z;
    vec4 _120 = vec4(vs_in_attr2.x, vs_in_attr2.y, vs_in_attr2.z, vs_in_attr2.w);
    vec4 _121 = vec4(_120.x, _120.y, _120.z, vec4(0.0, 1.0, 0.0, 0.0).y);
    precise float _125 = _121.x - _109;
    precise float _243 = _121.y - _110;
    precise float _244 = _121.z - _111;
    precise float _247 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _250 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _253 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _256 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _259 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _262 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _265 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _268 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _271 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _272 = _271 + _247;
    precise float _275 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _276 = _275 + _250;
    precise float _279 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _280 = _279 + _253;
    precise float _283 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _284 = _283 + _256;
    precise float _287 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _290 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _291 = _290 + _276;
    precise float _294 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _297 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _300 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _301 = _300 + _272;
    precise float _304 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _305 = _304 + _259;
    precise float _308 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _309 = _308 + _262;
    precise float _312 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _313 = _312 + _280;
    precise float _316 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _317 = _316 + _265;
    precise float _320 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _321 = _320 + _284;
    precise float _324 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _327 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _328 = _327 + _268;
    precise float _330 = uintBitsToFloat(srt_flatbuf_1.data[32u]) * _125;
    precise float _331 = _330 + _109;
    precise float _334 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _335 = _334 + _305;
    precise float _338 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _339 = _338 + _287;
    precise float _342 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _345 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _348 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _349 = _348 + _313;
    precise float _352 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _353 = _352 + _317;
    precise float _356 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _357 = _356 + _297;
    precise float _360 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _363 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _364 = _363 + _324;
    precise float _367 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _370 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _371 = _370 + _301;
    precise float _374 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _375 = _374 + _291;
    precise float _378 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _379 = _378 + _309;
    precise float _382 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _383 = _382 + _294;
    precise float _386 = uintBitsToFloat(srt_flatbuf_1.data[49u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _387 = _386 + _321;
    precise float _390 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _391 = _390 + _328;
    precise float _392 = _371 * _331;
    precise float _394 = uintBitsToFloat(srt_flatbuf_1.data[32u]) * _243;
    precise float _395 = _394 + _110;
    precise float _398 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _399 = _398 + _342;
    precise float _400 = _375 * _331;
    precise float _403 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _404 = _403 + _383;
    precise float _405 = _349 * _331;
    precise float _408 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _409 = _408 + _357;
    precise float _410 = _387 * _331;
    precise float _413 = uintBitsToFloat(srt_flatbuf_1.data[49u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _414 = _413 + _391;
    precise float _417 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _418 = _417 + _367;
    precise float _421 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _422 = _421 + _335;
    precise float _425 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _426 = _425 + _339;
    precise float _429 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _430 = _429 + _379;
    precise float _433 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _434 = _433 + _345;
    precise float _437 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _438 = _437 + _353;
    precise float _441 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _442 = _441 + _360;
    precise float _445 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _446 = _445 + _364;
    precise float _448 = uintBitsToFloat(srt_flatbuf_1.data[32u]) * _244;
    precise float _449 = _448 + _111;
    precise float _450 = _414 * _395;
    precise float _451 = _450 + _410;
    precise float _452 = _395 * _422;
    precise float _453 = _452 + _392;
    precise float _456 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _457 = _456 + _426;
    precise float _460 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _461 = _460 + _399;
    precise float _462 = _395 * _430;
    precise float _463 = _462 + _400;
    precise float _466 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _467 = _466 + _404;
    precise float _470 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _471 = _470 + _434;
    precise float _472 = _395 * _438;
    precise float _473 = _472 + _405;
    precise float _476 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _477 = _476 + _409;
    precise float _480 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _481 = _480 + _442;
    precise float _484 = uintBitsToFloat(srt_flatbuf_1.data[49u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _485 = _484 + _446;
    precise float _488 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _489 = _488 + _418;
    precise float _490 = _449 * _457;
    precise float _491 = _490 + _453;
    precise float _494 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _495 = _494 + _461;
    precise float _496 = _449 * _467;
    precise float _497 = _496 + _463;
    precise float _500 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _501 = _500 + _471;
    precise float _502 = _449 * _477;
    precise float _503 = _502 + _473;
    precise float _506 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _507 = _506 + _481;
    precise float _508 = _449 * _485;
    precise float _509 = _508 + _451;
    precise float _512 = uintBitsToFloat(srt_flatbuf_1.data[49u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _513 = _512 + _489;
    precise float _514 = _491 + _495;
    precise float _515 = _497 + _501;
    precise float _516 = _503 + _507;
    precise float _517 = _509 + _513;
    gl_Position.x = _514;
    gl_Position.y = _515;
    gl_Position.z = _516;
    gl_Position.w = _517;
    gl_Layer = int(floatBitsToUint(uintBitsToFloat(srt_flatbuf_1.data[33u])));
    out_attr0.x = _96.x;
    out_attr0.y = _96.y;
    out_attr0.z = 0.0;
    out_attr0.w = 0.0;
}

