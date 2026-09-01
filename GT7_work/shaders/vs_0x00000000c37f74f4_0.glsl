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
layout(location = 0) out vec4 out_attr0;

void main()
{
    vec4 _92 = vec4(vs_in_attr0.x, vs_in_attr0.y, vs_in_attr0.z, vs_in_attr0.w);
    vec4 _95 = vec4(_92.x, _92.y, _92.z, _92.w);
    vec4 _106 = vec4(vs_in_attr1.x, vs_in_attr1.y, vs_in_attr1.z, vs_in_attr1.w);
    vec4 _107 = vec4(_106.x, _106.y, _106.z, vec4(0.0, 1.0, 0.0, 0.0).y);
    float _108 = _107.x;
    float _109 = _107.y;
    float _110 = _107.z;
    precise float _226 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _229 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _232 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _235 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _238 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _241 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _244 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _247 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _250 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _251 = _250 + _226;
    precise float _254 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _255 = _254 + _229;
    precise float _258 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _259 = _258 + _232;
    precise float _262 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _263 = _262 + _235;
    precise float _266 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _269 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _270 = _269 + _255;
    precise float _273 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _276 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _279 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _282 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _283 = _282 + _251;
    precise float _286 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _287 = _286 + _238;
    precise float _290 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _291 = _290 + _241;
    precise float _294 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _295 = _294 + _259;
    precise float _298 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _299 = _298 + _244;
    precise float _302 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _303 = _302 + _263;
    precise float _306 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _307 = _306 + _247;
    precise float _310 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _313 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _314 = _313 + _273;
    precise float _317 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _320 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _323 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _324 = _323 + _307;
    precise float _327 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _328 = _327 + _279;
    precise float _331 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _334 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _335 = _334 + _283;
    precise float _338 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _339 = _338 + _287;
    precise float _342 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _343 = _342 + _266;
    precise float _346 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _347 = _346 + _270;
    precise float _350 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _351 = _350 + _291;
    precise float _354 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _355 = _354 + _295;
    precise float _358 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _359 = _358 + _299;
    precise float _362 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _363 = _362 + _276;
    precise float _366 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _367 = _366 + _303;
    precise float _368 = _335 * _108;
    precise float _369 = _347 * _108;
    precise float _372 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _373 = _372 + _314;
    precise float _374 = _355 * _108;
    precise float _377 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _378 = _377 + _363;
    precise float _379 = _367 * _108;
    precise float _382 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _383 = _382 + _339;
    precise float _386 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _387 = _386 + _343;
    precise float _390 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _391 = _390 + _310;
    precise float _394 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _395 = _394 + _351;
    precise float _398 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _399 = _398 + _317;
    precise float _402 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _403 = _402 + _359;
    precise float _406 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _407 = _406 + _320;
    precise float _410 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _411 = _410 + _324;
    precise float _414 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _415 = _414 + _328;
    precise float _418 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _419 = _418 + _331;
    precise float _420 = _109 * _383;
    precise float _421 = _420 + _368;
    precise float _424 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _425 = _424 + _387;
    precise float _428 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _429 = _428 + _391;
    precise float _430 = _109 * _395;
    precise float _431 = _430 + _369;
    precise float _434 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _435 = _434 + _373;
    precise float _438 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _439 = _438 + _399;
    precise float _440 = _109 * _403;
    precise float _441 = _440 + _374;
    precise float _444 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _445 = _444 + _378;
    precise float _448 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _449 = _448 + _407;
    precise float _450 = _109 * _411;
    precise float _451 = _450 + _379;
    precise float _454 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _455 = _454 + _415;
    precise float _458 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _459 = _458 + _419;
    precise float _460 = _455 * _110;
    precise float _461 = _460 + _451;
    precise float _462 = _110 * _425;
    precise float _463 = _462 + _421;
    precise float _466 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _467 = _466 + _429;
    precise float _468 = _110 * _435;
    precise float _469 = _468 + _431;
    precise float _472 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _473 = _472 + _439;
    precise float _474 = _110 * _445;
    precise float _475 = _474 + _441;
    precise float _478 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _479 = _478 + _449;
    precise float _482 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _483 = _482 + _459;
    precise float _484 = _463 + _467;
    precise float _485 = _469 + _473;
    precise float _486 = _475 + _479;
    precise float _487 = _461 + _483;
    gl_Position.x = _484;
    gl_Position.y = _487;
    gl_Position.z = _486;
    gl_Position.w = _485;
    gl_Layer = int(floatBitsToUint(uintBitsToFloat(srt_flatbuf_1.data[32u])));
    out_attr0.x = _95.x;
    out_attr0.y = _95.y;
    out_attr0.z = 0.0;
    out_attr0.w = 0.0;
}

