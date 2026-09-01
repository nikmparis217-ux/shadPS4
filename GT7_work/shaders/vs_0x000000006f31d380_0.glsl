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

layout(binding = 3, std430) readonly buffer clip_planes
{
    float data[];
} clip_planes_1;

layout(binding = 4, std430) readonly buffer srt_flatbuf
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
    vec4 _106 = vec4(vs_in_attr1.x, vs_in_attr1.y, vs_in_attr1.z, vs_in_attr1.w);
    vec4 _107 = vec4(_106.x, _106.y, _106.z, vec4(0.0, 1.0, 0.0, 0.0).y);
    float _108 = _107.x;
    float _109 = _107.y;
    float _110 = _107.z;
    precise float _296 = uintBitsToFloat(srt_flatbuf_1.data[53u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _299 = uintBitsToFloat(srt_flatbuf_1.data[53u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _302 = uintBitsToFloat(srt_flatbuf_1.data[57u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _303 = _302 + _296;
    precise float _306 = uintBitsToFloat(srt_flatbuf_1.data[53u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _309 = uintBitsToFloat(srt_flatbuf_1.data[61u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _310 = _309 + _303;
    precise float _313 = uintBitsToFloat(srt_flatbuf_1.data[57u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _314 = _313 + _299;
    precise float _317 = uintBitsToFloat(srt_flatbuf_1.data[61u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _318 = _317 + _314;
    precise float _321 = uintBitsToFloat(srt_flatbuf_1.data[53u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _324 = uintBitsToFloat(srt_flatbuf_1.data[65u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _325 = _324 + _310;
    precise float _328 = uintBitsToFloat(srt_flatbuf_1.data[57u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _329 = _328 + _306;
    precise float _330 = _325 * _108;
    precise float _333 = uintBitsToFloat(srt_flatbuf_1.data[61u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _334 = _333 + _329;
    precise float _337 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(srt_flatbuf_1.data[66u]);
    precise float _340 = uintBitsToFloat(srt_flatbuf_1.data[65u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _341 = _340 + _318;
    precise float _344 = uintBitsToFloat(srt_flatbuf_1.data[57u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _345 = _344 + _321;
    precise float _348 = uintBitsToFloat(srt_flatbuf_1.data[32u]) * uintBitsToFloat(srt_flatbuf_1.data[66u]);
    precise float _349 = _109 * _341;
    precise float _350 = _349 + _330;
    precise float _353 = uintBitsToFloat(srt_flatbuf_1.data[65u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _354 = _353 + _334;
    precise float _357 = uintBitsToFloat(srt_flatbuf_1.data[61u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _358 = _357 + _345;
    precise float _361 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[67u]);
    precise float _362 = _361 + _337;
    precise float _363 = _354 * _110;
    precise float _364 = _363 + _350;
    precise float _367 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[68u]);
    precise float _368 = _367 + _362;
    precise float _371 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(srt_flatbuf_1.data[66u]);
    precise float _374 = uintBitsToFloat(srt_flatbuf_1.data[65u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _375 = _374 + _358;
    precise float _378 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(srt_flatbuf_1.data[67u]);
    precise float _379 = _378 + _348;
    precise float _380 = _364 + _375;
    precise float _383 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(srt_flatbuf_1.data[66u]);
    precise float _386 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[69u]);
    precise float _387 = _386 + _368;
    precise float _390 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[68u]);
    precise float _391 = _390 + _379;
    precise float _394 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(srt_flatbuf_1.data[67u]);
    precise float _395 = _394 + _371;
    precise float _396 = _387 * _380;
    precise float _397 = _396 + 1.0;
    precise float _400 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[69u]);
    precise float _401 = _400 + _391;
    precise float _404 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[68u]);
    precise float _405 = _404 + _395;
    precise float _408 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[67u]);
    precise float _409 = _408 + _383;
    float _410 = 1.0 / _397;
    precise float _411 = _401 * _380;
    precise float _412 = _411 + _108;
    precise float _415 = uintBitsToFloat(srt_flatbuf_1.data[52u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _418 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[69u]);
    precise float _419 = _418 + _405;
    precise float _422 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[68u]);
    precise float _423 = _422 + _409;
    precise float _425 = _412 * _410;
    precise float _426 = _425 + (-_108);
    precise float _427 = _419 * _380;
    precise float _428 = _427 + _109;
    precise float _431 = uintBitsToFloat(srt_flatbuf_1.data[52u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _434 = uintBitsToFloat(srt_flatbuf_1.data[50u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _437 = uintBitsToFloat(srt_flatbuf_1.data[51u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _440 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[69u]);
    precise float _441 = _440 + _423;
    precise float _444 = uintBitsToFloat(srt_flatbuf_1.data[56u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _445 = _444 + _415;
    precise float _446 = _426 * _426;
    precise float _448 = _428 * _410;
    precise float _449 = _448 + (-_109);
    precise float _450 = _441 * _380;
    precise float _451 = _450 + _110;
    precise float _454 = uintBitsToFloat(srt_flatbuf_1.data[52u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _457 = uintBitsToFloat(srt_flatbuf_1.data[50u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _460 = uintBitsToFloat(srt_flatbuf_1.data[51u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _463 = uintBitsToFloat(srt_flatbuf_1.data[60u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _464 = _463 + _445;
    precise float _467 = uintBitsToFloat(srt_flatbuf_1.data[56u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _468 = _467 + _431;
    precise float _471 = uintBitsToFloat(srt_flatbuf_1.data[54u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _472 = _471 + _434;
    precise float _475 = uintBitsToFloat(srt_flatbuf_1.data[55u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _476 = _475 + _437;
    precise float _478 = _451 * _410;
    precise float _479 = _478 + (-_110);
    precise float _482 = uintBitsToFloat(srt_flatbuf_1.data[56u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _483 = _482 + _454;
    precise float _486 = uintBitsToFloat(srt_flatbuf_1.data[52u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _489 = uintBitsToFloat(srt_flatbuf_1.data[54u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _490 = _489 + _457;
    precise float _493 = uintBitsToFloat(srt_flatbuf_1.data[55u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _494 = _493 + _460;
    precise float _495 = _449 * _449;
    precise float _496 = _495 + _446;
    precise float _499 = uintBitsToFloat(srt_flatbuf_1.data[64u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _500 = _499 + _464;
    precise float _503 = uintBitsToFloat(srt_flatbuf_1.data[50u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _506 = uintBitsToFloat(srt_flatbuf_1.data[51u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _509 = uintBitsToFloat(srt_flatbuf_1.data[60u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _510 = _509 + _468;
    precise float _513 = uintBitsToFloat(srt_flatbuf_1.data[58u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _514 = _513 + _472;
    precise float _517 = uintBitsToFloat(srt_flatbuf_1.data[59u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _518 = _517 + _476;
    precise float _519 = _479 * _479;
    precise float _520 = _519 + _496;
    precise float _521 = _500 * _108;
    precise float _524 = uintBitsToFloat(srt_flatbuf_1.data[56u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _525 = _524 + _486;
    precise float _528 = uintBitsToFloat(srt_flatbuf_1.data[58u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _529 = _528 + _490;
    precise float _532 = uintBitsToFloat(srt_flatbuf_1.data[50u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _535 = uintBitsToFloat(srt_flatbuf_1.data[55u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _536 = _535 + _506;
    precise float _539 = uintBitsToFloat(srt_flatbuf_1.data[51u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _542 = uintBitsToFloat(srt_flatbuf_1.data[64u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _543 = _542 + _510;
    precise float _546 = uintBitsToFloat(srt_flatbuf_1.data[60u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _547 = _546 + _483;
    precise float _550 = uintBitsToFloat(srt_flatbuf_1.data[62u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _551 = _550 + _514;
    precise float _554 = uintBitsToFloat(srt_flatbuf_1.data[63u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _555 = _554 + _518;
    precise float _558 = uintBitsToFloat(srt_flatbuf_1.data[59u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _559 = _558 + _494;
    precise float _562 = uintBitsToFloat(srt_flatbuf_1.data[54u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _563 = _562 + _503;
    precise float _566 = _551 * _108;
    precise float _569 = uintBitsToFloat(srt_flatbuf_1.data[54u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _570 = _569 + _532;
    precise float _571 = _555 * _108;
    precise float _575 = _109 * _543;
    precise float _576 = _575 + _521;
    precise float _579 = uintBitsToFloat(srt_flatbuf_1.data[64u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _580 = _579 + _547;
    precise float _583 = uintBitsToFloat(srt_flatbuf_1.data[60u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _584 = _583 + _525;
    precise float _587 = uintBitsToFloat(srt_flatbuf_1.data[62u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _588 = _587 + _529;
    precise float _591 = uintBitsToFloat(srt_flatbuf_1.data[58u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _592 = _591 + _563;
    precise float _595 = uintBitsToFloat(srt_flatbuf_1.data[63u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _596 = _595 + _559;
    precise float _599 = uintBitsToFloat(srt_flatbuf_1.data[59u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _600 = _599 + _536;
    precise float _603 = uintBitsToFloat(srt_flatbuf_1.data[55u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _604 = _603 + _539;
    precise float _606 = 2.2999999523162841796875 * inversesqrt(_520);
    precise float _607 = _596 * _109;
    precise float _608 = _607 + _571;
    precise float _610 = _110 * _580;
    precise float _611 = _610 + _576;
    precise float _614 = uintBitsToFloat(srt_flatbuf_1.data[64u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _615 = _614 + _584;
    precise float _616 = _109 * _588;
    precise float _617 = _616 + _566;
    precise float _620 = uintBitsToFloat(srt_flatbuf_1.data[62u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _621 = _620 + _592;
    precise float _624 = uintBitsToFloat(srt_flatbuf_1.data[58u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _625 = _624 + _570;
    precise float _628 = uintBitsToFloat(srt_flatbuf_1.data[63u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _629 = _628 + _600;
    precise float _632 = uintBitsToFloat(srt_flatbuf_1.data[59u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _633 = _632 + _604;
    float _634 = ((((srt_flatbuf_1.data[48u] >> 3u) & 1u) == 1u) ? true : false) ? _606 : 0.0;
    precise float _635 = _611 + _615;
    precise float _636 = _110 * _621;
    precise float _637 = _636 + _617;
    precise float _640 = uintBitsToFloat(srt_flatbuf_1.data[62u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _641 = _640 + _625;
    precise float _642 = _110 * _629;
    precise float _643 = _642 + _608;
    precise float _646 = uintBitsToFloat(srt_flatbuf_1.data[63u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _647 = _646 + _633;
    precise float _648 = _637 + _641;
    precise float _649 = _643 + _647;
    precise float _651 = _634 * (-_380);
    precise float _652 = _651 + _635;
    gl_Position.x = _648;
    gl_Position.y = _649;
    gl_Position.z = _652;
    gl_Position.w = _380;
    gl_Layer = int(floatBitsToUint(uintBitsToFloat(srt_flatbuf_1.data[49u])));
    out_attr0.x = _95.x;
    out_attr0.y = _95.y;
    out_attr0.z = _634;
    out_attr0.w = 0.0;
}

