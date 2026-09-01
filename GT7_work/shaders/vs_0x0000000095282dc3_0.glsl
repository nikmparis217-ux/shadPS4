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

layout(binding = 3, std430) readonly buffer ssbo_1
{
    uint data[];
} ssbo_1_1;

layout(binding = 4, std430) readonly buffer clip_planes
{
    float data[];
} clip_planes_1;

layout(binding = 5, std430) readonly buffer srt_flatbuf
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
    uint buf0_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(0u), int(8u)) >> 2u;
    vec4 _99 = vec4(vs_in_attr0.x, vs_in_attr0.y, vs_in_attr0.z, vs_in_attr0.w);
    vec4 _102 = vec4(_99.x, _99.y, vec4(0.0, 1.0, 0.0, 0.0).x, vec4(0.0, 1.0, 0.0, 0.0).y);
    vec4 _113 = vec4(vs_in_attr1.x, vs_in_attr1.y, vs_in_attr1.z, vs_in_attr1.w);
    vec4 _114 = vec4(_113.x, _113.y, _113.z, vec4(0.0, 1.0, 0.0, 0.0).y);
    float _115 = _114.x;
    float _116 = _114.y;
    float _117 = _114.z;
    uint _196 = ((uint((gl_InstanceID + SPIRV_Cross_BaseInstance)) * 60u) + 12u) + buf0_dword_off;
    uvec4 _208 = uvec4(ssbo_1_1.data[_196], ssbo_1_1.data[_196 + 1u], ssbo_1_1.data[_196 + 2u], ssbo_1_1.data[_196 + 3u]);
    uint _209 = _208.x;
    uint _210 = _208.y;
    uint _211 = _208.z;
    uint _212 = _208.w;
    uint _214 = (uint((gl_InstanceID + SPIRV_Cross_BaseInstance)) * 60u) + buf0_dword_off;
    uvec4 _226 = uvec4(ssbo_1_1.data[_214], ssbo_1_1.data[_214 + 1u], ssbo_1_1.data[_214 + 2u], ssbo_1_1.data[_214 + 3u]);
    uint _227 = _226.x;
    uint _228 = _226.y;
    uint _229 = _226.z;
    uint _230 = _226.w;
    uint _233 = ((uint((gl_InstanceID + SPIRV_Cross_BaseInstance)) * 60u) + 4u) + buf0_dword_off;
    uvec4 _245 = uvec4(ssbo_1_1.data[_233], ssbo_1_1.data[_233 + 1u], ssbo_1_1.data[_233 + 2u], ssbo_1_1.data[_233 + 3u]);
    uint _246 = _245.x;
    uint _247 = _245.y;
    uint _248 = _245.z;
    uint _249 = _245.w;
    uint _252 = ((uint((gl_InstanceID + SPIRV_Cross_BaseInstance)) * 60u) + 8u) + buf0_dword_off;
    uvec4 _264 = uvec4(ssbo_1_1.data[_252], ssbo_1_1.data[_252 + 1u], ssbo_1_1.data[_252 + 2u], ssbo_1_1.data[_252 + 3u]);
    uint _265 = _264.x;
    uint _266 = _264.y;
    uint _267 = _264.z;
    uint _268 = _264.w;
    precise float _275 = uintBitsToFloat(srt_flatbuf_1.data[25u]) * uintBitsToFloat(_209);
    precise float _278 = uintBitsToFloat(srt_flatbuf_1.data[25u]) * uintBitsToFloat(_227);
    precise float _281 = uintBitsToFloat(srt_flatbuf_1.data[25u]) * uintBitsToFloat(_246);
    precise float _284 = uintBitsToFloat(srt_flatbuf_1.data[29u]) * uintBitsToFloat(_210);
    precise float _285 = _284 + _275;
    precise float _288 = uintBitsToFloat(srt_flatbuf_1.data[29u]) * uintBitsToFloat(_228);
    precise float _289 = _288 + _278;
    precise float _292 = uintBitsToFloat(srt_flatbuf_1.data[25u]) * uintBitsToFloat(_265);
    precise float _295 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(_211);
    precise float _296 = _295 + _285;
    precise float _299 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(_229);
    precise float _300 = _299 + _289;
    precise float _303 = uintBitsToFloat(srt_flatbuf_1.data[29u]) * uintBitsToFloat(_247);
    precise float _304 = _303 + _281;
    precise float _307 = uintBitsToFloat(_248) * uintBitsToFloat(srt_flatbuf_1.data[33u]);
    precise float _308 = _307 + _304;
    precise float _311 = uintBitsToFloat(_266) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _312 = _311 + _292;
    precise float _315 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(_212);
    precise float _316 = _315 + _296;
    precise float _319 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(_230);
    precise float _320 = _319 + _300;
    precise float _323 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(_227);
    precise float _326 = uintBitsToFloat(_227) * uintBitsToFloat(_209);
    precise float _327 = _320 * _115;
    precise float _328 = _327 + _316;
    precise float _331 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(_249);
    precise float _332 = _331 + _308;
    precise float _335 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(_267);
    precise float _336 = _335 + _312;
    precise float _339 = uintBitsToFloat(_268) * uintBitsToFloat(srt_flatbuf_1.data[37u]);
    precise float _340 = _339 + _336;
    precise float _343 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(_246);
    precise float _344 = _332 * _116;
    precise float _345 = _344 + _328;
    precise float _348 = uintBitsToFloat(_246) * uintBitsToFloat(_209);
    precise float _351 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(_228);
    precise float _352 = _351 + _323;
    precise float _355 = uintBitsToFloat(_210) * uintBitsToFloat(_228);
    precise float _356 = _355 + _326;
    gl_Layer = int(floatBitsToUint(uintBitsToFloat(srt_flatbuf_1.data[21u])));
    precise float _359 = _117 * _340;
    precise float _360 = _359 + _345;
    precise float _363 = uintBitsToFloat(_229) * uintBitsToFloat(srt_flatbuf_1.data[40u]);
    precise float _364 = _363 + _352;
    precise float _367 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(_265);
    precise float _370 = uintBitsToFloat(_265) * uintBitsToFloat(_209);
    precise float _373 = uintBitsToFloat(_211) * uintBitsToFloat(_229);
    precise float _374 = _373 + _356;
    precise float _377 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(_247);
    precise float _378 = _377 + _343;
    precise float _381 = uintBitsToFloat(_210) * uintBitsToFloat(_247);
    precise float _382 = _381 + _348;
    precise float _384 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * _360;
    precise float _385 = _384 + 1.0;
    precise float _388 = uintBitsToFloat(_266) * uintBitsToFloat(_210);
    precise float _389 = _388 + _370;
    precise float _392 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * (-_374);
    precise float _393 = _392 + _364;
    precise float _396 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(_248);
    precise float _397 = _396 + _378;
    precise float _400 = uintBitsToFloat(_211) * uintBitsToFloat(_248);
    precise float _401 = _400 + _382;
    precise float _404 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(_266);
    precise float _405 = _404 + _367;
    float _406 = 1.0 / _385;
    precise float _407 = _360 * _393;
    precise float _408 = _407 + _115;
    precise float _411 = uintBitsToFloat(_267) * uintBitsToFloat(srt_flatbuf_1.data[40u]);
    precise float _412 = _411 + _405;
    precise float _415 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * (-_401);
    precise float _416 = _415 + _397;
    precise float _419 = uintBitsToFloat(_211) * uintBitsToFloat(_267);
    precise float _420 = _419 + _389;
    precise float _422 = _406 * _408;
    precise float _423 = _422 + (-_115);
    precise float _424 = _360 * _416;
    precise float _425 = _424 + _116;
    precise float _428 = uintBitsToFloat(srt_flatbuf_1.data[24u]) * uintBitsToFloat(_209);
    precise float _431 = uintBitsToFloat(srt_flatbuf_1.data[24u]) * uintBitsToFloat(_227);
    precise float _434 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * (-_420);
    precise float _435 = _434 + _412;
    precise float _436 = _423 * _423;
    precise float _438 = _406 * _425;
    precise float _439 = _438 + (-_116);
    precise float _440 = _360 * _435;
    precise float _441 = _440 + _117;
    precise float _444 = uintBitsToFloat(_210) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _445 = _444 + _428;
    precise float _448 = uintBitsToFloat(srt_flatbuf_1.data[24u]) * uintBitsToFloat(_246);
    precise float _451 = uintBitsToFloat(srt_flatbuf_1.data[22u]) * uintBitsToFloat(_209);
    precise float _454 = uintBitsToFloat(srt_flatbuf_1.data[22u]) * uintBitsToFloat(_227);
    precise float _457 = uintBitsToFloat(srt_flatbuf_1.data[23u]) * uintBitsToFloat(_209);
    precise float _460 = uintBitsToFloat(srt_flatbuf_1.data[23u]) * uintBitsToFloat(_227);
    precise float _463 = uintBitsToFloat(srt_flatbuf_1.data[28u]) * uintBitsToFloat(_228);
    precise float _464 = _463 + _431;
    precise float _465 = _439 * _439;
    precise float _466 = _465 + _436;
    precise float _468 = _406 * _441;
    precise float _469 = _468 + (-_117);
    precise float _472 = uintBitsToFloat(_211) * uintBitsToFloat(srt_flatbuf_1.data[32u]);
    precise float _473 = _472 + _445;
    precise float _476 = uintBitsToFloat(_229) * uintBitsToFloat(srt_flatbuf_1.data[32u]);
    precise float _477 = _476 + _464;
    precise float _480 = uintBitsToFloat(_247) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _481 = _480 + _448;
    precise float _484 = uintBitsToFloat(srt_flatbuf_1.data[24u]) * uintBitsToFloat(_265);
    precise float _487 = uintBitsToFloat(srt_flatbuf_1.data[22u]) * uintBitsToFloat(_246);
    precise float _490 = uintBitsToFloat(srt_flatbuf_1.data[23u]) * uintBitsToFloat(_246);
    precise float _493 = uintBitsToFloat(srt_flatbuf_1.data[26u]) * uintBitsToFloat(_210);
    precise float _494 = _493 + _451;
    precise float _497 = uintBitsToFloat(srt_flatbuf_1.data[26u]) * uintBitsToFloat(_228);
    precise float _498 = _497 + _454;
    precise float _501 = uintBitsToFloat(srt_flatbuf_1.data[27u]) * uintBitsToFloat(_210);
    precise float _502 = _501 + _457;
    precise float _505 = uintBitsToFloat(srt_flatbuf_1.data[27u]) * uintBitsToFloat(_228);
    precise float _506 = _505 + _460;
    precise float _507 = _469 * _469;
    precise float _508 = _507 + _466;
    precise float _511 = uintBitsToFloat(_212) * uintBitsToFloat(srt_flatbuf_1.data[36u]);
    precise float _512 = _511 + _473;
    precise float _515 = uintBitsToFloat(_266) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _516 = _515 + _484;
    precise float _519 = uintBitsToFloat(srt_flatbuf_1.data[30u]) * uintBitsToFloat(_211);
    precise float _520 = _519 + _494;
    precise float _523 = uintBitsToFloat(srt_flatbuf_1.data[30u]) * uintBitsToFloat(_229);
    precise float _524 = _523 + _498;
    precise float _527 = uintBitsToFloat(srt_flatbuf_1.data[26u]) * uintBitsToFloat(_247);
    precise float _528 = _527 + _487;
    precise float _531 = uintBitsToFloat(srt_flatbuf_1.data[22u]) * uintBitsToFloat(_265);
    precise float _534 = uintBitsToFloat(srt_flatbuf_1.data[23u]) * uintBitsToFloat(_265);
    precise float _537 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(_230);
    precise float _538 = _537 + _477;
    precise float _541 = uintBitsToFloat(srt_flatbuf_1.data[32u]) * uintBitsToFloat(_248);
    precise float _542 = _541 + _481;
    precise float _545 = uintBitsToFloat(srt_flatbuf_1.data[31u]) * uintBitsToFloat(_211);
    precise float _546 = _545 + _502;
    precise float _549 = uintBitsToFloat(srt_flatbuf_1.data[31u]) * uintBitsToFloat(_229);
    precise float _550 = _549 + _506;
    precise float _553 = uintBitsToFloat(srt_flatbuf_1.data[27u]) * uintBitsToFloat(_247);
    precise float _554 = _553 + _490;
    precise float _559 = uintBitsToFloat(srt_flatbuf_1.data[26u]) * uintBitsToFloat(_266);
    precise float _560 = _559 + _531;
    precise float _563 = uintBitsToFloat(_212) * uintBitsToFloat(srt_flatbuf_1.data[35u]);
    precise float _564 = _563 + _546;
    precise float _565 = _538 * _115;
    precise float _566 = _565 + _512;
    precise float _569 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(_249);
    precise float _570 = _569 + _542;
    precise float _573 = uintBitsToFloat(srt_flatbuf_1.data[32u]) * uintBitsToFloat(_267);
    precise float _574 = _573 + _516;
    precise float _577 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(_212);
    precise float _578 = _577 + _520;
    precise float _581 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(_230);
    precise float _582 = _581 + _524;
    precise float _585 = uintBitsToFloat(srt_flatbuf_1.data[30u]) * uintBitsToFloat(_248);
    precise float _586 = _585 + _528;
    precise float _589 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(_230);
    precise float _590 = _589 + _550;
    precise float _593 = uintBitsToFloat(_266) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _594 = _593 + _534;
    precise float _597 = uintBitsToFloat(srt_flatbuf_1.data[31u]) * uintBitsToFloat(_248);
    precise float _598 = _597 + _554;
    precise float _600 = 0.0500000007450580596923828125 * inversesqrt(_508);
    precise float _601 = _570 * _116;
    precise float _602 = _601 + _566;
    precise float _605 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(_268);
    precise float _606 = _605 + _574;
    precise float _607 = _582 * _115;
    precise float _608 = _607 + _578;
    precise float _611 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(_249);
    precise float _612 = _611 + _586;
    precise float _615 = uintBitsToFloat(srt_flatbuf_1.data[30u]) * uintBitsToFloat(_267);
    precise float _616 = _615 + _560;
    precise float _617 = _590 * _115;
    precise float _618 = _617 + _564;
    precise float _621 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(_249);
    precise float _622 = _621 + _598;
    precise float _625 = uintBitsToFloat(srt_flatbuf_1.data[31u]) * uintBitsToFloat(_267);
    precise float _626 = _625 + _594;
    float _627 = ((((srt_flatbuf_1.data[20u] >> 3u) & 1u) == 1u) ? true : false) ? _600 : 0.0;
    precise float _628 = _606 * _117;
    precise float _629 = _628 + _602;
    precise float _630 = _612 * _116;
    precise float _631 = _630 + _608;
    precise float _634 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(_268);
    precise float _635 = _634 + _616;
    precise float _636 = _622 * _116;
    precise float _637 = _636 + _618;
    precise float _640 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(_268);
    precise float _641 = _640 + _626;
    precise float _643 = _627 * (-_360);
    precise float _644 = _643 + _629;
    precise float _645 = _635 * _117;
    precise float _646 = _645 + _631;
    precise float _647 = _641 * _117;
    precise float _648 = _647 + _637;
    gl_Position.x = _646;
    gl_Position.y = _648;
    gl_Position.z = _644;
    gl_Position.w = _360;
    out_attr0.x = _102.x;
    out_attr0.y = _102.y;
    out_attr0.z = _627;
    out_attr0.w = 0.0;
}

