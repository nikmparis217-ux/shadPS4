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
layout(location = 2) in vec4 vs_in_attr2;
layout(location = 3) in vec4 vs_in_attr3;
layout(location = 0) out vec4 out_attr0;

void main()
{
    uint buf0_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(0u), int(8u)) >> 2u;
    vec4 _101 = vec4(vs_in_attr0.x, vs_in_attr0.y, vs_in_attr0.z, vs_in_attr0.w);
    vec4 _104 = vec4(_101.x, _101.y, _101.z, vec4(0.0, 1.0, 0.0, 0.0).y);
    vec4 _116 = vec4(vs_in_attr1.x, vs_in_attr1.y, vs_in_attr1.z, vs_in_attr1.w);
    vec4 _117 = vec4(_116.x, _116.y, _116.z, _116.w);
    float _118 = _117.x;
    float _119 = _117.y;
    float _120 = _117.z;
    vec4 _129 = vec4(vs_in_attr2.x, vs_in_attr2.y, vs_in_attr2.z, vs_in_attr2.w);
    vec4 _130 = vec4(_129.x, _129.y, vec4(0.0, 1.0, 0.0, 0.0).x, vec4(0.0, 1.0, 0.0, 0.0).y);
    vec4 _141 = vec4(vs_in_attr3.x, vs_in_attr3.y, vs_in_attr3.z, vs_in_attr3.w);
    vec4 _142 = vec4(_141.x, _141.y, _141.z, vec4(0.0, 1.0, 0.0, 0.0).y);
    float _143 = _142.x;
    float _144 = _142.y;
    float _145 = _142.z;
    precise float _146 = _118 * _118;
    precise float _163 = _119 * _119;
    precise float _164 = _163 + _146;
    precise float _165 = _120 * _120;
    precise float _166 = _165 + _164;
    float _168 = inversesqrt(_166);
    precise float _222 = _168 * _120;
    precise float _240 = _168 * _119;
    precise float _241 = _118 * _168;
    uint _245 = ((uint((gl_InstanceID + SPIRV_Cross_BaseInstance)) * 60u) + 8u) + buf0_dword_off;
    uvec4 _257 = uvec4(ssbo_1_1.data[_245], ssbo_1_1.data[_245 + 1u], ssbo_1_1.data[_245 + 2u], ssbo_1_1.data[_245 + 3u]);
    uint _258 = _257.x;
    uint _259 = _257.y;
    uint _260 = _257.z;
    uint _261 = _257.w;
    uint _264 = ((uint((gl_InstanceID + SPIRV_Cross_BaseInstance)) * 60u) + 4u) + buf0_dword_off;
    uvec4 _276 = uvec4(ssbo_1_1.data[_264], ssbo_1_1.data[_264 + 1u], ssbo_1_1.data[_264 + 2u], ssbo_1_1.data[_264 + 3u]);
    uint _277 = _276.x;
    uint _278 = _276.y;
    uint _279 = _276.z;
    uint _280 = _276.w;
    uint _282 = (uint((gl_InstanceID + SPIRV_Cross_BaseInstance)) * 60u) + buf0_dword_off;
    uvec4 _294 = uvec4(ssbo_1_1.data[_282], ssbo_1_1.data[_282 + 1u], ssbo_1_1.data[_282 + 2u], ssbo_1_1.data[_282 + 3u]);
    uint _295 = _294.x;
    uint _296 = _294.y;
    uint _297 = _294.z;
    uint _298 = _294.w;
    uint _302 = ((uint((gl_InstanceID + SPIRV_Cross_BaseInstance)) * 60u) + 12u) + buf0_dword_off;
    uvec4 _314 = uvec4(ssbo_1_1.data[_302], ssbo_1_1.data[_302 + 1u], ssbo_1_1.data[_302 + 2u], ssbo_1_1.data[_302 + 3u]);
    uint _315 = _314.x;
    uint _316 = _314.y;
    uint _317 = _314.z;
    uint _318 = _314.w;
    precise float _325 = uintBitsToFloat(srt_flatbuf_1.data[22u]) * uintBitsToFloat(_260);
    precise float _328 = uintBitsToFloat(srt_flatbuf_1.data[22u]) * uintBitsToFloat(_279);
    precise float _331 = uintBitsToFloat(srt_flatbuf_1.data[22u]) * uintBitsToFloat(_297);
    precise float _334 = uintBitsToFloat(srt_flatbuf_1.data[21u]) * uintBitsToFloat(_259);
    precise float _335 = _334 + _325;
    precise float _338 = uintBitsToFloat(srt_flatbuf_1.data[20u]) * uintBitsToFloat(_258);
    precise float _339 = _338 + _335;
    precise float _342 = uintBitsToFloat(srt_flatbuf_1.data[21u]) * uintBitsToFloat(_278);
    precise float _343 = _342 + _328;
    precise float _346 = uintBitsToFloat(srt_flatbuf_1.data[21u]) * uintBitsToFloat(_296);
    precise float _347 = _346 + _331;
    precise float _348 = _119 * _339;
    precise float _351 = uintBitsToFloat(srt_flatbuf_1.data[20u]) * uintBitsToFloat(_277);
    precise float _352 = _351 + _343;
    precise float _355 = uintBitsToFloat(srt_flatbuf_1.data[20u]) * uintBitsToFloat(_295);
    precise float _356 = _355 + _347;
    gl_Layer = int(floatBitsToUint(uintBitsToFloat(srt_flatbuf_1.data[24u])));
    precise float _360 = (-_120) * _352;
    precise float _361 = _360 + _348;
    precise float _362 = _120 * _356;
    precise float _363 = _361 * _361;
    precise float _365 = _339 * (-_118);
    precise float _366 = _365 + _362;
    precise float _367 = _118 * _352;
    precise float _368 = _366 * _366;
    precise float _369 = _368 + _363;
    precise float _371 = _356 * (-_119);
    precise float _372 = _371 + _367;
    precise float _373 = _372 * _372;
    precise float _374 = _373 + _369;
    float _375 = inversesqrt(_374);
    precise float _376 = _375 * _366;
    precise float _377 = _376 * _222;
    precise float _378 = _375 * _372;
    precise float _379 = _375 * _361;
    precise float _382 = uintBitsToFloat(srt_flatbuf_1.data[28u]) * uintBitsToFloat(_315);
    precise float _385 = uintBitsToFloat(srt_flatbuf_1.data[28u]) * uintBitsToFloat(_295);
    precise float _386 = _378 * _241;
    precise float _388 = _240 * (-_378);
    precise float _389 = _388 + _377;
    precise float _392 = uintBitsToFloat(_316) * uintBitsToFloat(srt_flatbuf_1.data[32u]);
    precise float _393 = _392 + _382;
    precise float _394 = _379 * _240;
    precise float _395 = _389 * _145;
    precise float _396 = _395 + _104.x;
    precise float _399 = uintBitsToFloat(_296) * uintBitsToFloat(srt_flatbuf_1.data[32u]);
    precise float _400 = _399 + _385;
    precise float _403 = uintBitsToFloat(srt_flatbuf_1.data[28u]) * uintBitsToFloat(_277);
    precise float _405 = _222 * (-_379);
    precise float _406 = _405 + _386;
    precise float _407 = _241 * _144;
    precise float _408 = _407 + _396;
    precise float _411 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(_317);
    precise float _412 = _411 + _393;
    precise float _415 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(_297);
    precise float _416 = _415 + _400;
    precise float _417 = _406 * _145;
    precise float _418 = _417 + _104.y;
    precise float _421 = uintBitsToFloat(srt_flatbuf_1.data[32u]) * uintBitsToFloat(_278);
    precise float _422 = _421 + _403;
    precise float _424 = _241 * (-_376);
    precise float _425 = _424 + _394;
    precise float _428 = uintBitsToFloat(srt_flatbuf_1.data[28u]) * uintBitsToFloat(_258);
    precise float _429 = _379 * _143;
    precise float _430 = _429 + _408;
    precise float _433 = uintBitsToFloat(_318) * uintBitsToFloat(srt_flatbuf_1.data[40u]);
    precise float _434 = _433 + _412;
    precise float _437 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(_298);
    precise float _438 = _437 + _416;
    precise float _439 = _240 * _144;
    precise float _440 = _439 + _418;
    precise float _443 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(_279);
    precise float _444 = _443 + _422;
    precise float _445 = _425 * _145;
    precise float _446 = _445 + _104.z;
    precise float _449 = uintBitsToFloat(srt_flatbuf_1.data[32u]) * uintBitsToFloat(_259);
    precise float _450 = _449 + _428;
    precise float _453 = uintBitsToFloat(_295) * uintBitsToFloat(_315);
    precise float _454 = _438 * _430;
    precise float _455 = _454 + _434;
    precise float _456 = _376 * _143;
    precise float _457 = _456 + _440;
    precise float _460 = uintBitsToFloat(_260) * uintBitsToFloat(srt_flatbuf_1.data[36u]);
    precise float _461 = _460 + _450;
    precise float _464 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(_280);
    precise float _465 = _464 + _444;
    precise float _466 = _222 * _144;
    precise float _467 = _466 + _446;
    precise float _470 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(_295);
    precise float _473 = uintBitsToFloat(_277) * uintBitsToFloat(_315);
    precise float _474 = _465 * _457;
    precise float _475 = _474 + _455;
    precise float _476 = _378 * _143;
    precise float _477 = _476 + _467;
    precise float _480 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(_277);
    precise float _483 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(_261);
    precise float _484 = _483 + _461;
    precise float _487 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(_296);
    precise float _488 = _487 + _470;
    precise float _491 = uintBitsToFloat(_296) * uintBitsToFloat(_316);
    precise float _492 = _491 + _453;
    precise float _493 = _477 * _484;
    precise float _494 = _493 + _475;
    precise float _497 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(_258);
    precise float _500 = uintBitsToFloat(_258) * uintBitsToFloat(_315);
    precise float _503 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(_297);
    precise float _504 = _503 + _488;
    precise float _507 = uintBitsToFloat(_297) * uintBitsToFloat(_317);
    precise float _508 = _507 + _492;
    precise float _511 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(_278);
    precise float _512 = _511 + _480;
    precise float _515 = uintBitsToFloat(_278) * uintBitsToFloat(_316);
    precise float _516 = _515 + _473;
    precise float _518 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * _494;
    precise float _519 = _518 + 1.0;
    precise float _522 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * (-_508);
    precise float _523 = _522 + _504;
    precise float _526 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(_279);
    precise float _527 = _526 + _512;
    precise float _530 = uintBitsToFloat(_279) * uintBitsToFloat(_317);
    precise float _531 = _530 + _516;
    precise float _534 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(_259);
    precise float _535 = _534 + _497;
    precise float _538 = uintBitsToFloat(_259) * uintBitsToFloat(_316);
    precise float _539 = _538 + _500;
    float _540 = 1.0 / _519;
    precise float _541 = _494 * _523;
    precise float _542 = _541 + _430;
    precise float _545 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(_260);
    precise float _546 = _545 + _535;
    precise float _549 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * (-_531);
    precise float _550 = _549 + _527;
    precise float _553 = uintBitsToFloat(_260) * uintBitsToFloat(_317);
    precise float _554 = _553 + _539;
    precise float _556 = _540 * _542;
    precise float _557 = _556 + (-_430);
    precise float _558 = _494 * _550;
    precise float _559 = _558 + _457;
    precise float _562 = uintBitsToFloat(srt_flatbuf_1.data[27u]) * uintBitsToFloat(_295);
    precise float _565 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * (-_554);
    precise float _566 = _565 + _546;
    precise float _569 = uintBitsToFloat(srt_flatbuf_1.data[27u]) * uintBitsToFloat(_315);
    precise float _570 = _557 * _557;
    precise float _572 = _540 * _559;
    precise float _573 = _572 + (-_457);
    precise float _574 = _494 * _566;
    precise float _575 = _574 + _477;
    precise float _578 = uintBitsToFloat(srt_flatbuf_1.data[27u]) * uintBitsToFloat(_277);
    precise float _581 = uintBitsToFloat(srt_flatbuf_1.data[25u]) * uintBitsToFloat(_315);
    precise float _584 = uintBitsToFloat(srt_flatbuf_1.data[25u]) * uintBitsToFloat(_295);
    precise float _587 = uintBitsToFloat(srt_flatbuf_1.data[26u]) * uintBitsToFloat(_315);
    precise float _590 = uintBitsToFloat(srt_flatbuf_1.data[26u]) * uintBitsToFloat(_295);
    precise float _593 = uintBitsToFloat(srt_flatbuf_1.data[31u]) * uintBitsToFloat(_316);
    precise float _594 = _593 + _569;
    precise float _597 = uintBitsToFloat(srt_flatbuf_1.data[31u]) * uintBitsToFloat(_296);
    precise float _598 = _597 + _562;
    precise float _601 = uintBitsToFloat(srt_flatbuf_1.data[27u]) * uintBitsToFloat(_258);
    precise float _604 = uintBitsToFloat(srt_flatbuf_1.data[25u]) * uintBitsToFloat(_277);
    precise float _607 = uintBitsToFloat(srt_flatbuf_1.data[26u]) * uintBitsToFloat(_277);
    precise float _608 = _573 * _573;
    precise float _609 = _608 + _570;
    precise float _611 = _540 * _575;
    precise float _612 = _611 + (-_477);
    precise float _615 = uintBitsToFloat(_317) * uintBitsToFloat(srt_flatbuf_1.data[35u]);
    precise float _616 = _615 + _594;
    precise float _619 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(_297);
    precise float _620 = _619 + _598;
    precise float _623 = uintBitsToFloat(srt_flatbuf_1.data[31u]) * uintBitsToFloat(_278);
    precise float _624 = _623 + _578;
    precise float _627 = uintBitsToFloat(srt_flatbuf_1.data[29u]) * uintBitsToFloat(_316);
    precise float _628 = _627 + _581;
    precise float _631 = uintBitsToFloat(srt_flatbuf_1.data[29u]) * uintBitsToFloat(_296);
    precise float _632 = _631 + _584;
    precise float _635 = uintBitsToFloat(srt_flatbuf_1.data[30u]) * uintBitsToFloat(_316);
    precise float _636 = _635 + _587;
    precise float _639 = uintBitsToFloat(srt_flatbuf_1.data[30u]) * uintBitsToFloat(_296);
    precise float _640 = _639 + _590;
    precise float _643 = uintBitsToFloat(_318) * uintBitsToFloat(srt_flatbuf_1.data[39u]);
    precise float _644 = _643 + _616;
    precise float _647 = uintBitsToFloat(srt_flatbuf_1.data[25u]) * uintBitsToFloat(_258);
    precise float _650 = uintBitsToFloat(srt_flatbuf_1.data[26u]) * uintBitsToFloat(_258);
    precise float _651 = _612 * _612;
    precise float _652 = _651 + _609;
    precise float _655 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(_298);
    precise float _656 = _655 + _620;
    precise float _659 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(_279);
    precise float _660 = _659 + _624;
    precise float _663 = uintBitsToFloat(srt_flatbuf_1.data[31u]) * uintBitsToFloat(_259);
    precise float _664 = _663 + _601;
    precise float _667 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(_317);
    precise float _668 = _667 + _628;
    precise float _671 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(_297);
    precise float _672 = _671 + _632;
    precise float _675 = uintBitsToFloat(srt_flatbuf_1.data[29u]) * uintBitsToFloat(_278);
    precise float _676 = _675 + _604;
    precise float _679 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(_317);
    precise float _680 = _679 + _636;
    precise float _683 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(_297);
    precise float _684 = _683 + _640;
    precise float _687 = uintBitsToFloat(srt_flatbuf_1.data[30u]) * uintBitsToFloat(_278);
    precise float _688 = _687 + _607;
    precise float _690 = _430 * _656;
    precise float _691 = _690 + _644;
    precise float _694 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(_318);
    precise float _695 = _694 + _668;
    precise float _698 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(_280);
    precise float _699 = _698 + _660;
    precise float _702 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(_260);
    precise float _703 = _702 + _664;
    precise float _706 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(_298);
    precise float _707 = _706 + _672;
    precise float _710 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(_279);
    precise float _711 = _710 + _676;
    precise float _714 = uintBitsToFloat(srt_flatbuf_1.data[29u]) * uintBitsToFloat(_259);
    precise float _715 = _714 + _647;
    precise float _718 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(_318);
    precise float _719 = _718 + _680;
    precise float _722 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(_298);
    precise float _723 = _722 + _684;
    precise float _726 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(_279);
    precise float _727 = _726 + _688;
    precise float _730 = uintBitsToFloat(srt_flatbuf_1.data[30u]) * uintBitsToFloat(_259);
    precise float _731 = _730 + _650;
    precise float _733 = 1.9500000476837158203125 * inversesqrt(_652);
    precise float _734 = _457 * _699;
    precise float _735 = _734 + _691;
    precise float _738 = uintBitsToFloat(_260) * uintBitsToFloat(srt_flatbuf_1.data[34u]);
    precise float _739 = _738 + _731;
    precise float _742 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(_261);
    precise float _743 = _742 + _703;
    precise float _744 = _707 * _430;
    precise float _745 = _744 + _695;
    precise float _748 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(_280);
    precise float _749 = _748 + _711;
    precise float _752 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(_260);
    precise float _753 = _752 + _715;
    precise float _754 = _723 * _430;
    precise float _755 = _754 + _719;
    precise float _758 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(_280);
    precise float _759 = _758 + _727;
    float _760 = ((((srt_flatbuf_1.data[23u] >> 3u) & 1u) == 1u) ? true : false) ? _733 : 0.0;
    precise float _761 = _743 * _477;
    precise float _762 = _761 + _735;
    precise float _763 = _749 * _457;
    precise float _764 = _763 + _745;
    precise float _767 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(_261);
    precise float _768 = _767 + _753;
    precise float _769 = _759 * _457;
    precise float _770 = _769 + _755;
    precise float _773 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(_261);
    precise float _774 = _773 + _739;
    precise float _776 = _760 * (-_494);
    precise float _777 = _776 + _762;
    precise float _778 = _768 * _477;
    precise float _779 = _778 + _764;
    precise float _780 = _774 * _477;
    precise float _781 = _780 + _770;
    gl_Position.x = _779;
    gl_Position.y = _781;
    gl_Position.z = _777;
    gl_Position.w = _494;
    out_attr0.x = _130.x;
    out_attr0.y = _130.y;
    out_attr0.z = _760;
    out_attr0.w = 0.0;
}

