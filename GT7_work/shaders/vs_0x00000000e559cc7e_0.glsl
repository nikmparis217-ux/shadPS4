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
    vec4 _98 = vec4(vs_in_attr0.x, vs_in_attr0.y, vs_in_attr0.z, vs_in_attr0.w);
    vec4 _101 = vec4(_98.x, _98.y, _98.z, vec4(0.0, 1.0, 0.0, 0.0).y);
    float _102 = _101.x;
    float _103 = _101.y;
    float _104 = _101.z;
    precise float _234 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _237 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _240 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _243 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _244 = _243 + _234;
    precise float _247 = uintBitsToFloat(srt_flatbuf_1.data[49u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _248 = _247 + _244;
    precise float _251 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _254 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _257 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _258 = _257 + _237;
    precise float _261 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _262 = _261 + _240;
    precise float _265 = uintBitsToFloat(srt_flatbuf_1.data[49u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _266 = _265 + _258;
    precise float _269 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _272 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _273 = _272 + _262;
    precise float _276 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _279 = uintBitsToFloat(srt_flatbuf_1.data[53u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _280 = _279 + _248;
    precise float _283 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _284 = _283 + _251;
    precise float _287 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _288 = _287 + _254;
    precise float _289 = _280 * _102;
    precise float _292 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _295 = uintBitsToFloat(srt_flatbuf_1.data[53u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _296 = _295 + _266;
    precise float _299 = uintBitsToFloat(srt_flatbuf_1.data[49u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _300 = _299 + _284;
    precise float _303 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _304 = _303 + _269;
    precise float _307 = uintBitsToFloat(srt_flatbuf_1.data[52u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _308 = _307 + _273;
    precise float _311 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _312 = _311 + _288;
    precise float _315 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _316 = _315 + _276;
    precise float _317 = _103 * _296;
    precise float _318 = _317 + _289;
    precise float _321 = uintBitsToFloat(srt_flatbuf_1.data[49u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _322 = _321 + _304;
    precise float _323 = _308 * _102;
    precise float _326 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _327 = _326 + _316;
    precise float _330 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _331 = _330 + _292;
    precise float _334 = uintBitsToFloat(srt_flatbuf_1.data[53u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _335 = _334 + _300;
    precise float _338 = uintBitsToFloat(srt_flatbuf_1.data[52u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _339 = _338 + _312;
    precise float _340 = _104 * _335;
    precise float _341 = _340 + _318;
    precise float _344 = uintBitsToFloat(srt_flatbuf_1.data[53u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _345 = _344 + _322;
    precise float _346 = _103 * _339;
    precise float _347 = _346 + _323;
    precise float _350 = uintBitsToFloat(srt_flatbuf_1.data[52u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _351 = _350 + _327;
    precise float _354 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _355 = _354 + _331;
    precise float _356 = _341 + _345;
    precise float _357 = _351 * _104;
    precise float _358 = _357 + _347;
    precise float _361 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _364 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _367 = uintBitsToFloat(srt_flatbuf_1.data[52u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _368 = _367 + _355;
    precise float _370 = _358 + _368;
    precise float _374 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _377 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _380 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _381 = _380 + _361;
    precise float _384 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _385 = _384 + _364;
    precise float _386 = _370 * (1.0 / _356);
    precise float _388 = _356 - uintBitsToFloat(srt_flatbuf_1.data[33u]);
    precise float _391 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _394 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _397 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _398 = _397 + _381;
    precise float _401 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _402 = _401 + _374;
    precise float _405 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _406 = _405 + _385;
    precise float _409 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _410 = _409 + _377;
    precise float _416 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _417 = _416 + _402;
    precise float _420 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _423 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _426 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * _386;
    precise float _427 = _426 + uintBitsToFloat(srt_flatbuf_1.data[35u]);
    precise float _431 = uintBitsToFloat(srt_flatbuf_1.data[50u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _432 = _431 + _398;
    precise float _435 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _436 = _435 + _391;
    precise float _439 = uintBitsToFloat(srt_flatbuf_1.data[51u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _440 = _439 + _406;
    precise float _443 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _444 = _443 + _410;
    precise float _447 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _448 = _447 + _394;
    precise float _449 = min(uintBitsToFloat(srt_flatbuf_1.data[36u]), _388) * clamp(_427, 0.0, 1.0);
    precise float _450 = _432 * _102;
    precise float _453 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _454 = _453 + _420;
    precise float _455 = _440 * _102;
    precise float _458 = uintBitsToFloat(srt_flatbuf_1.data[50u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _459 = _458 + _417;
    precise float _462 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _463 = _462 + _436;
    precise float _466 = uintBitsToFloat(srt_flatbuf_1.data[51u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _467 = _466 + _444;
    precise float _470 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _471 = _470 + _448;
    precise float _474 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _475 = _474 + _423;
    precise float _477 = _103 * _459;
    precise float _478 = _477 + _450;
    precise float _481 = uintBitsToFloat(srt_flatbuf_1.data[50u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _482 = _481 + _463;
    precise float _485 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _486 = _485 + _454;
    precise float _487 = _103 * _467;
    precise float _488 = _487 + _455;
    precise float _491 = uintBitsToFloat(srt_flatbuf_1.data[51u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _492 = _491 + _471;
    precise float _495 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _496 = _495 + _475;
    precise float _497 = _104 * _482;
    precise float _498 = _497 + _478;
    precise float _501 = uintBitsToFloat(srt_flatbuf_1.data[50u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _502 = _501 + _486;
    precise float _503 = _104 * _492;
    precise float _504 = _503 + _488;
    precise float _507 = uintBitsToFloat(srt_flatbuf_1.data[51u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _508 = _507 + _496;
    precise float _509 = _498 + _502;
    precise float _510 = _504 + _508;
    uint _524;
    if (0.0 < _449)
    {
        precise float _511 = _449 - _356;
        precise float _518 = _449 * (1.0 / _511);
        precise float _521 = (-uintBitsToFloat(srt_flatbuf_1.data[54u])) * _518;
        precise float _522 = _521 + _370;
        _524 = floatBitsToUint(_522);
    }
    else
    {
        _524 = floatBitsToUint(_370);
    }
    gl_Position.x = _509;
    gl_Position.y = _510;
    gl_Position.z = uintBitsToFloat(_524);
    gl_Position.w = _356;
    gl_Layer = int(floatBitsToUint(uintBitsToFloat(srt_flatbuf_1.data[37u])));
    out_attr0.x = 0.0;
    out_attr0.y = 0.0;
    out_attr0.z = 0.0;
    out_attr0.w = 0.0;
}

