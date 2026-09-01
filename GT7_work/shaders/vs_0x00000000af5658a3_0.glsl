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
layout(location = 1) in vec4 vs_in_attr1;
layout(location = 0) out vec4 out_attr0;

void main()
{
    vec4 _92 = vec4(vs_in_attr0.x, vs_in_attr0.y, vs_in_attr0.z, vs_in_attr0.w);
    vec4 _95 = vec4(_92.x, _92.y, _92.z, vec4(0.0, 1.0, 0.0, 0.0).y);
    float _96 = _95.x;
    float _97 = _95.y;
    float _98 = _95.z;
    vec4 _107 = vec4(vs_in_attr1.x, vs_in_attr1.y, vs_in_attr1.z, vs_in_attr1.w);
    vec4 _108 = vec4(_107.x, _107.y, _107.z, vec4(0.0, 1.0, 0.0, 0.0).y);
    precise float _112 = _108.x - _96;
    precise float _230 = _108.y - _97;
    precise float _231 = _108.z - _98;
    precise float _234 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _237 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _240 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _243 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _246 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _249 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _252 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _255 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _258 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _259 = _258 + _234;
    precise float _262 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _263 = _262 + _237;
    precise float _266 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _267 = _266 + _240;
    precise float _270 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _271 = _270 + _243;
    precise float _274 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _277 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _278 = _277 + _263;
    precise float _281 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _284 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _287 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _288 = _287 + _259;
    precise float _291 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _292 = _291 + _246;
    precise float _295 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _296 = _295 + _249;
    precise float _299 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _300 = _299 + _267;
    precise float _303 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _304 = _303 + _252;
    precise float _307 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _308 = _307 + _271;
    precise float _311 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _314 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _315 = _314 + _255;
    precise float _317 = uintBitsToFloat(srt_flatbuf_1.data[32u]) * _112;
    precise float _318 = _317 + _96;
    precise float _321 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _322 = _321 + _292;
    precise float _325 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _328 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _331 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _334 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _335 = _334 + _315;
    precise float _338 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _339 = _338 + _311;
    precise float _342 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _345 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _346 = _345 + _288;
    precise float _349 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _350 = _349 + _274;
    precise float _353 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _354 = _353 + _278;
    precise float _357 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _358 = _357 + _296;
    precise float _361 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _362 = _361 + _281;
    precise float _365 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _366 = _365 + _300;
    precise float _369 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _370 = _369 + _304;
    precise float _373 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _374 = _373 + _284;
    precise float _377 = uintBitsToFloat(srt_flatbuf_1.data[49u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _378 = _377 + _308;
    precise float _379 = _346 * _318;
    precise float _381 = uintBitsToFloat(srt_flatbuf_1.data[32u]) * _230;
    precise float _382 = _381 + _97;
    precise float _383 = _354 * _318;
    precise float _386 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _387 = _386 + _362;
    precise float _388 = _366 * _318;
    precise float _391 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _392 = _391 + _374;
    precise float _393 = _378 * _318;
    precise float _396 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _397 = _396 + _322;
    precise float _400 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _401 = _400 + _350;
    precise float _404 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _405 = _404 + _325;
    precise float _408 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _409 = _408 + _358;
    precise float _412 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _413 = _412 + _328;
    precise float _416 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _417 = _416 + _370;
    precise float _420 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _421 = _420 + _331;
    precise float _424 = uintBitsToFloat(srt_flatbuf_1.data[49u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _425 = _424 + _335;
    precise float _428 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _429 = _428 + _339;
    precise float _432 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _433 = _432 + _342;
    precise float _435 = uintBitsToFloat(srt_flatbuf_1.data[32u]) * _231;
    precise float _436 = _435 + _98;
    precise float _437 = _425 * _382;
    precise float _438 = _437 + _393;
    precise float _439 = _382 * _397;
    precise float _440 = _439 + _379;
    precise float _443 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _444 = _443 + _401;
    precise float _447 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _448 = _447 + _405;
    precise float _449 = _382 * _409;
    precise float _450 = _449 + _383;
    precise float _453 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _454 = _453 + _387;
    precise float _457 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _458 = _457 + _413;
    precise float _459 = _382 * _417;
    precise float _460 = _459 + _388;
    precise float _463 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _464 = _463 + _392;
    precise float _467 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _468 = _467 + _421;
    precise float _471 = uintBitsToFloat(srt_flatbuf_1.data[49u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _472 = _471 + _429;
    precise float _475 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _476 = _475 + _433;
    precise float _477 = _436 * _444;
    precise float _478 = _477 + _440;
    precise float _481 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _482 = _481 + _448;
    precise float _483 = _436 * _454;
    precise float _484 = _483 + _450;
    precise float _487 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _488 = _487 + _458;
    precise float _489 = _436 * _464;
    precise float _490 = _489 + _460;
    precise float _493 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _494 = _493 + _468;
    precise float _495 = _436 * _472;
    precise float _496 = _495 + _438;
    precise float _499 = uintBitsToFloat(srt_flatbuf_1.data[49u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _500 = _499 + _476;
    precise float _501 = _478 + _482;
    precise float _502 = _484 + _488;
    precise float _503 = _490 + _494;
    precise float _504 = _496 + _500;
    gl_Position.x = _501;
    gl_Position.y = _502;
    gl_Position.z = _503;
    gl_Position.w = _504;
    gl_Layer = int(floatBitsToUint(uintBitsToFloat(srt_flatbuf_1.data[33u])));
    out_attr0.x = 0.0;
    out_attr0.y = 0.0;
    out_attr0.z = 0.0;
    out_attr0.w = 0.0;
}

