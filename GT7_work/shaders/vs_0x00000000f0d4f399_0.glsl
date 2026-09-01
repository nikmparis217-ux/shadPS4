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

layout(binding = 0, std430) readonly buffer clip_planes
{
    float data[];
} clip_planes_1;

layout(binding = 1, std430) readonly buffer srt_flatbuf
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
    vec4 _91 = vec4(vs_in_attr0.x, vs_in_attr0.y, vs_in_attr0.z, vs_in_attr0.w);
    vec4 _94 = vec4(_91.x, _91.y, _91.z, vec4(0.0, 1.0, 0.0, 0.0).y);
    float _95 = _94.x;
    float _96 = _94.y;
    float _97 = _94.z;
    precise float _218 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _221 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _224 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _227 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _230 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _233 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _236 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _239 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _242 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _243 = _242 + _218;
    precise float _246 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _247 = _246 + _221;
    precise float _250 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _251 = _250 + _224;
    precise float _254 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _255 = _254 + _227;
    precise float _258 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _261 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _262 = _261 + _247;
    precise float _265 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _266 = _265 + _233;
    precise float _269 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _272 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _275 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _278 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _279 = _278 + _243;
    precise float _282 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _283 = _282 + _230;
    precise float _286 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _287 = _286 + _251;
    precise float _290 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _291 = _290 + _236;
    precise float _294 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _295 = _294 + _255;
    precise float _298 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _299 = _298 + _239;
    precise float _302 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _303 = _302 + _258;
    precise float _306 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _309 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _310 = _309 + _269;
    precise float _313 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _316 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _319 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _322 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _323 = _322 + _279;
    precise float _326 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _327 = _326 + _283;
    precise float _330 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _331 = _330 + _262;
    precise float _334 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _335 = _334 + _266;
    precise float _338 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _339 = _338 + _287;
    precise float _342 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _343 = _342 + _291;
    precise float _346 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _347 = _346 + _272;
    precise float _350 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _351 = _350 + _295;
    precise float _354 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _355 = _354 + _299;
    precise float _358 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _359 = _358 + _275;
    precise float _360 = _323 * _95;
    precise float _363 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _364 = _363 + _303;
    precise float _365 = _331 * _95;
    precise float _366 = _339 * _95;
    precise float _369 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _370 = _369 + _347;
    precise float _371 = _351 * _95;
    precise float _374 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _375 = _374 + _355;
    precise float _378 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _379 = _378 + _359;
    precise float _382 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _383 = _382 + _319;
    precise float _386 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _387 = _386 + _327;
    precise float _390 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _391 = _390 + _306;
    precise float _394 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _395 = _394 + _335;
    precise float _398 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _399 = _398 + _310;
    precise float _402 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _403 = _402 + _313;
    precise float _406 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _407 = _406 + _343;
    precise float _410 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _411 = _410 + _316;
    precise float _412 = _96 * _387;
    precise float _413 = _412 + _360;
    precise float _416 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _417 = _416 + _364;
    precise float _420 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _421 = _420 + _391;
    precise float _422 = _96 * _395;
    precise float _423 = _422 + _365;
    precise float _426 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _427 = _426 + _399;
    precise float _430 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _431 = _430 + _403;
    precise float _432 = _96 * _407;
    precise float _433 = _432 + _366;
    precise float _436 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _437 = _436 + _370;
    precise float _440 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _441 = _440 + _411;
    precise float _442 = _96 * _375;
    precise float _443 = _442 + _371;
    precise float _446 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _447 = _446 + _379;
    precise float _450 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _451 = _450 + _383;
    precise float _452 = _97 * _417;
    precise float _453 = _452 + _413;
    precise float _456 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _457 = _456 + _421;
    precise float _458 = _97 * _427;
    precise float _459 = _458 + _423;
    precise float _462 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _463 = _462 + _431;
    precise float _464 = _97 * _437;
    precise float _465 = _464 + _433;
    precise float _468 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _469 = _468 + _441;
    precise float _470 = _97 * _447;
    precise float _471 = _470 + _443;
    precise float _474 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _475 = _474 + _451;
    precise float _476 = _453 + _457;
    precise float _477 = _459 + _463;
    precise float _478 = _465 + _469;
    precise float _479 = _471 + _475;
    gl_Position.x = _476;
    gl_Position.y = _479;
    gl_Position.z = _478;
    gl_Position.w = _477;
    gl_Layer = int(floatBitsToUint(uintBitsToFloat(srt_flatbuf_1.data[32u])));
    out_attr0.x = 0.0;
    out_attr0.y = 0.0;
    out_attr0.z = 0.0;
    out_attr0.w = 0.0;
}

