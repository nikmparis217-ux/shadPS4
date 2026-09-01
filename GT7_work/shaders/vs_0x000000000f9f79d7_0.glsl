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
    vec4 _129 = vec4(vs_in_attr2.x, vs_in_attr2.y, vs_in_attr2.z, vs_in_attr2.w);
    vec4 _130 = vec4(_129.x, _129.y, vec4(0.0, 1.0, 0.0, 0.0).x, vec4(0.0, 1.0, 0.0, 0.0).y);
    vec4 _141 = vec4(vs_in_attr3.x, vs_in_attr3.y, vs_in_attr3.z, vs_in_attr3.w);
    vec4 _142 = vec4(_141.x, _141.y, _141.z, vec4(0.0, 1.0, 0.0, 0.0).y);
    float _143 = _142.x;
    float _144 = _142.y;
    float _145 = _142.z;
    uint _253 = ((uint((gl_InstanceID + SPIRV_Cross_BaseInstance)) * 60u) + 4u) + buf0_dword_off;
    uvec4 _265 = uvec4(ssbo_1_1.data[_253], ssbo_1_1.data[_253 + 1u], ssbo_1_1.data[_253 + 2u], ssbo_1_1.data[_253 + 3u]);
    uint _266 = _265.x;
    uint _267 = _265.y;
    uint _268 = _265.z;
    uint _269 = _265.w;
    uint _272 = ((uint((gl_InstanceID + SPIRV_Cross_BaseInstance)) * 60u) + 8u) + buf0_dword_off;
    uvec4 _284 = uvec4(ssbo_1_1.data[_272], ssbo_1_1.data[_272 + 1u], ssbo_1_1.data[_272 + 2u], ssbo_1_1.data[_272 + 3u]);
    uint _285 = _284.x;
    uint _286 = _284.y;
    uint _287 = _284.z;
    uint _288 = _284.w;
    uint _290 = (uint((gl_InstanceID + SPIRV_Cross_BaseInstance)) * 60u) + buf0_dword_off;
    uvec4 _302 = uvec4(ssbo_1_1.data[_290], ssbo_1_1.data[_290 + 1u], ssbo_1_1.data[_290 + 2u], ssbo_1_1.data[_290 + 3u]);
    uint _303 = _302.x;
    uint _304 = _302.y;
    uint _305 = _302.z;
    uint _306 = _302.w;
    uint _310 = ((uint((gl_InstanceID + SPIRV_Cross_BaseInstance)) * 60u) + 12u) + buf0_dword_off;
    uvec4 _322 = uvec4(ssbo_1_1.data[_310], ssbo_1_1.data[_310 + 1u], ssbo_1_1.data[_310 + 2u], ssbo_1_1.data[_310 + 3u]);
    uint _323 = _322.x;
    uint _324 = _322.y;
    uint _325 = _322.z;
    uint _326 = _322.w;
    bool _328 = (0u == srt_flatbuf_1.data[23u]) ? true : false;
    precise float _335 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(_266);
    precise float _338 = uintBitsToFloat(_267) * uintBitsToFloat(srt_flatbuf_1.data[47u]);
    precise float _339 = _338 + _335;
    precise float _342 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(_285);
    precise float _345 = uintBitsToFloat(srt_flatbuf_1.data[22u]) * uintBitsToFloat(_287);
    precise float _348 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(_303);
    precise float _351 = uintBitsToFloat(srt_flatbuf_1.data[51u]) * uintBitsToFloat(_268);
    precise float _352 = _351 + _339;
    precise float _355 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(_286);
    precise float _356 = _355 + _342;
    precise float _359 = uintBitsToFloat(_287) * uintBitsToFloat(srt_flatbuf_1.data[51u]);
    precise float _360 = _359 + _356;
    precise float _363 = uintBitsToFloat(srt_flatbuf_1.data[22u]) * uintBitsToFloat(_268);
    precise float _366 = uintBitsToFloat(srt_flatbuf_1.data[22u]) * uintBitsToFloat(_305);
    precise float _369 = uintBitsToFloat(_304) * uintBitsToFloat(srt_flatbuf_1.data[47u]);
    precise float _370 = _369 + _348;
    precise float _373 = uintBitsToFloat(srt_flatbuf_1.data[55u]) * uintBitsToFloat(_269);
    precise float _374 = _373 + _352;
    precise float _377 = uintBitsToFloat(srt_flatbuf_1.data[21u]) * uintBitsToFloat(_286);
    precise float _378 = _377 + _345;
    float _379 = _328 ? _374 : _117.y;
    gl_Layer = int(floatBitsToUint(uintBitsToFloat(srt_flatbuf_1.data[25u])));
    precise float _384 = uintBitsToFloat(srt_flatbuf_1.data[20u]) * uintBitsToFloat(_285);
    precise float _385 = _384 + _378;
    precise float _388 = uintBitsToFloat(srt_flatbuf_1.data[55u]) * uintBitsToFloat(_288);
    precise float _389 = _388 + _360;
    precise float _392 = uintBitsToFloat(srt_flatbuf_1.data[21u]) * uintBitsToFloat(_267);
    precise float _393 = _392 + _363;
    precise float _396 = uintBitsToFloat(srt_flatbuf_1.data[21u]) * uintBitsToFloat(_304);
    precise float _397 = _396 + _366;
    precise float _400 = uintBitsToFloat(srt_flatbuf_1.data[51u]) * uintBitsToFloat(_305);
    precise float _401 = _400 + _370;
    precise float _402 = _379 * _385;
    float _403 = _328 ? _389 : _117.z;
    precise float _406 = uintBitsToFloat(srt_flatbuf_1.data[20u]) * uintBitsToFloat(_266);
    precise float _407 = _406 + _393;
    precise float _410 = uintBitsToFloat(srt_flatbuf_1.data[20u]) * uintBitsToFloat(_303);
    precise float _411 = _410 + _397;
    precise float _414 = uintBitsToFloat(srt_flatbuf_1.data[55u]) * uintBitsToFloat(_306);
    precise float _415 = _414 + _401;
    precise float _416 = _403 * _411;
    float _417 = _328 ? _415 : _117.x;
    precise float _419 = _407 * (-_403);
    precise float _420 = _419 + _402;
    precise float _421 = _420 * _420;
    precise float _422 = _417 * _407;
    precise float _424 = _385 * (-_417);
    precise float _425 = _424 + _416;
    precise float _426 = _411 * _411;
    precise float _427 = _425 * _425;
    precise float _428 = _427 + _421;
    precise float _430 = _411 * (-_379);
    precise float _431 = _430 + _422;
    precise float _432 = _407 * _407;
    precise float _433 = _432 + _426;
    precise float _434 = _431 * _431;
    precise float _435 = _434 + _428;
    precise float _436 = _385 * _385;
    precise float _437 = _436 + _433;
    float _439 = inversesqrt(_435);
    float _440 = inversesqrt(_437);
    precise float _441 = _439 * _431;
    precise float _442 = _440 * _407;
    precise float _443 = _441 * _442;
    precise float _444 = _439 * _425;
    precise float _445 = _440 * _385;
    precise float _446 = _440 * _411;
    precise float _447 = _439 * _420;
    precise float _450 = uintBitsToFloat(srt_flatbuf_1.data[29u]) * uintBitsToFloat(_323);
    precise float _453 = uintBitsToFloat(srt_flatbuf_1.data[29u]) * uintBitsToFloat(_303);
    precise float _455 = (-_445) * _444;
    precise float _456 = _455 + _443;
    precise float _457 = _447 * _445;
    precise float _460 = uintBitsToFloat(srt_flatbuf_1.data[29u]) * uintBitsToFloat(_266);
    precise float _461 = _446 * _145;
    precise float _462 = _461 + _104.x;
    precise float _465 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(_324);
    precise float _466 = _465 + _450;
    precise float _469 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(_304);
    precise float _470 = _469 + _453;
    precise float _471 = _456 * _144;
    precise float _472 = _471 + _462;
    precise float _475 = uintBitsToFloat(_325) * uintBitsToFloat(srt_flatbuf_1.data[37u]);
    precise float _476 = _475 + _466;
    precise float _479 = uintBitsToFloat(_305) * uintBitsToFloat(srt_flatbuf_1.data[37u]);
    precise float _480 = _479 + _470;
    precise float _481 = _145 * _442;
    precise float _482 = _481 + _104.y;
    precise float _485 = uintBitsToFloat(srt_flatbuf_1.data[29u]) * uintBitsToFloat(_285);
    precise float _487 = _441 * (-_446);
    precise float _488 = _487 + _457;
    precise float _489 = _444 * _446;
    precise float _492 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(_267);
    precise float _493 = _492 + _460;
    precise float _494 = _145 * _445;
    precise float _495 = _494 + _104.z;
    precise float _496 = _447 * _143;
    precise float _497 = _496 + _472;
    precise float _500 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(_326);
    precise float _501 = _500 + _476;
    precise float _504 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(_306);
    precise float _505 = _504 + _480;
    precise float _506 = _488 * _144;
    precise float _507 = _506 + _482;
    precise float _510 = uintBitsToFloat(_268) * uintBitsToFloat(srt_flatbuf_1.data[37u]);
    precise float _511 = _510 + _493;
    precise float _513 = _447 * (-_442);
    precise float _514 = _513 + _489;
    precise float _517 = uintBitsToFloat(_286) * uintBitsToFloat(srt_flatbuf_1.data[33u]);
    precise float _518 = _517 + _485;
    precise float _519 = _497 * _505;
    precise float _520 = _519 + _501;
    precise float _523 = uintBitsToFloat(srt_flatbuf_1.data[58u]) * uintBitsToFloat(_303);
    precise float _524 = _444 * _143;
    precise float _525 = _524 + _507;
    precise float _528 = uintBitsToFloat(_287) * uintBitsToFloat(srt_flatbuf_1.data[37u]);
    precise float _529 = _528 + _518;
    precise float _532 = uintBitsToFloat(_303) * uintBitsToFloat(_323);
    precise float _535 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(_269);
    precise float _536 = _535 + _511;
    precise float _537 = _514 * _144;
    precise float _538 = _537 + _495;
    precise float _539 = _143 * _441;
    precise float _540 = _539 + _538;
    precise float _543 = uintBitsToFloat(srt_flatbuf_1.data[58u]) * uintBitsToFloat(_266);
    precise float _546 = uintBitsToFloat(_266) * uintBitsToFloat(_323);
    precise float _547 = _536 * _525;
    precise float _548 = _547 + _520;
    precise float _551 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(_288);
    precise float _552 = _551 + _529;
    precise float _555 = uintBitsToFloat(srt_flatbuf_1.data[59u]) * uintBitsToFloat(_304);
    precise float _556 = _555 + _523;
    precise float _559 = uintBitsToFloat(_324) * uintBitsToFloat(_304);
    precise float _560 = _559 + _532;
    precise float _563 = uintBitsToFloat(_305) * uintBitsToFloat(srt_flatbuf_1.data[60u]);
    precise float _564 = _563 + _556;
    precise float _567 = uintBitsToFloat(srt_flatbuf_1.data[58u]) * uintBitsToFloat(_285);
    precise float _570 = uintBitsToFloat(_285) * uintBitsToFloat(_323);
    precise float _571 = _552 * _540;
    precise float _572 = _571 + _548;
    precise float _575 = uintBitsToFloat(_325) * uintBitsToFloat(_305);
    precise float _576 = _575 + _560;
    precise float _579 = uintBitsToFloat(srt_flatbuf_1.data[59u]) * uintBitsToFloat(_267);
    precise float _580 = _579 + _543;
    precise float _583 = uintBitsToFloat(_324) * uintBitsToFloat(_267);
    precise float _584 = _583 + _546;
    precise float _586 = uintBitsToFloat(srt_flatbuf_1.data[61u]) * _572;
    precise float _587 = _586 + 1.0;
    precise float _590 = (-_576) * uintBitsToFloat(srt_flatbuf_1.data[61u]);
    precise float _591 = _590 + _564;
    precise float _594 = uintBitsToFloat(srt_flatbuf_1.data[60u]) * uintBitsToFloat(_268);
    precise float _595 = _594 + _580;
    precise float _598 = uintBitsToFloat(_325) * uintBitsToFloat(_268);
    precise float _599 = _598 + _584;
    precise float _602 = uintBitsToFloat(srt_flatbuf_1.data[59u]) * uintBitsToFloat(_286);
    precise float _603 = _602 + _567;
    precise float _606 = uintBitsToFloat(_324) * uintBitsToFloat(_286);
    precise float _607 = _606 + _570;
    float _608 = 1.0 / _587;
    precise float _609 = _572 * _591;
    precise float _610 = _609 + _497;
    precise float _613 = uintBitsToFloat(srt_flatbuf_1.data[61u]) * (-_599);
    precise float _614 = _613 + _595;
    precise float _617 = uintBitsToFloat(_287) * uintBitsToFloat(srt_flatbuf_1.data[60u]);
    precise float _618 = _617 + _603;
    precise float _621 = uintBitsToFloat(_325) * uintBitsToFloat(_287);
    precise float _622 = _621 + _607;
    precise float _624 = _608 * _610;
    precise float _625 = _624 + (-_497);
    precise float _626 = _572 * _614;
    precise float _627 = _626 + _525;
    precise float _630 = uintBitsToFloat(srt_flatbuf_1.data[28u]) * uintBitsToFloat(_323);
    precise float _633 = uintBitsToFloat(srt_flatbuf_1.data[28u]) * uintBitsToFloat(_303);
    precise float _636 = uintBitsToFloat(srt_flatbuf_1.data[61u]) * (-_622);
    precise float _637 = _636 + _618;
    precise float _638 = _625 * _625;
    precise float _640 = _608 * _627;
    precise float _641 = _640 + (-_525);
    precise float _642 = _572 * _637;
    precise float _643 = _642 + _540;
    precise float _646 = uintBitsToFloat(srt_flatbuf_1.data[28u]) * uintBitsToFloat(_266);
    precise float _649 = uintBitsToFloat(srt_flatbuf_1.data[26u]) * uintBitsToFloat(_323);
    precise float _652 = uintBitsToFloat(srt_flatbuf_1.data[26u]) * uintBitsToFloat(_303);
    precise float _655 = uintBitsToFloat(srt_flatbuf_1.data[27u]) * uintBitsToFloat(_323);
    precise float _658 = uintBitsToFloat(srt_flatbuf_1.data[27u]) * uintBitsToFloat(_303);
    precise float _661 = uintBitsToFloat(srt_flatbuf_1.data[32u]) * uintBitsToFloat(_324);
    precise float _662 = _661 + _630;
    precise float _665 = uintBitsToFloat(srt_flatbuf_1.data[32u]) * uintBitsToFloat(_304);
    precise float _666 = _665 + _633;
    precise float _669 = uintBitsToFloat(srt_flatbuf_1.data[28u]) * uintBitsToFloat(_285);
    precise float _672 = uintBitsToFloat(srt_flatbuf_1.data[26u]) * uintBitsToFloat(_266);
    precise float _675 = uintBitsToFloat(srt_flatbuf_1.data[27u]) * uintBitsToFloat(_266);
    precise float _676 = _641 * _641;
    precise float _677 = _676 + _638;
    precise float _679 = _608 * _643;
    precise float _680 = _679 + (-_540);
    precise float _683 = uintBitsToFloat(_305) * uintBitsToFloat(srt_flatbuf_1.data[36u]);
    precise float _684 = _683 + _666;
    precise float _687 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(_325);
    precise float _688 = _687 + _662;
    precise float _691 = uintBitsToFloat(srt_flatbuf_1.data[32u]) * uintBitsToFloat(_267);
    precise float _692 = _691 + _646;
    precise float _695 = uintBitsToFloat(srt_flatbuf_1.data[30u]) * uintBitsToFloat(_324);
    precise float _696 = _695 + _649;
    precise float _699 = uintBitsToFloat(srt_flatbuf_1.data[30u]) * uintBitsToFloat(_304);
    precise float _700 = _699 + _652;
    precise float _703 = uintBitsToFloat(srt_flatbuf_1.data[31u]) * uintBitsToFloat(_324);
    precise float _704 = _703 + _655;
    precise float _707 = uintBitsToFloat(srt_flatbuf_1.data[31u]) * uintBitsToFloat(_304);
    precise float _708 = _707 + _658;
    precise float _711 = uintBitsToFloat(srt_flatbuf_1.data[26u]) * uintBitsToFloat(_285);
    precise float _714 = uintBitsToFloat(srt_flatbuf_1.data[27u]) * uintBitsToFloat(_285);
    precise float _715 = _680 * _680;
    precise float _716 = _715 + _677;
    precise float _719 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(_326);
    precise float _720 = _719 + _688;
    precise float _723 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(_306);
    precise float _724 = _723 + _684;
    precise float _727 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(_268);
    precise float _728 = _727 + _692;
    precise float _731 = uintBitsToFloat(srt_flatbuf_1.data[32u]) * uintBitsToFloat(_286);
    precise float _732 = _731 + _669;
    precise float _735 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(_325);
    precise float _736 = _735 + _696;
    precise float _739 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(_305);
    precise float _740 = _739 + _700;
    precise float _743 = uintBitsToFloat(srt_flatbuf_1.data[30u]) * uintBitsToFloat(_267);
    precise float _744 = _743 + _672;
    precise float _747 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(_325);
    precise float _748 = _747 + _704;
    precise float _751 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(_305);
    precise float _752 = _751 + _708;
    precise float _755 = uintBitsToFloat(srt_flatbuf_1.data[31u]) * uintBitsToFloat(_267);
    precise float _756 = _755 + _675;
    precise float _760 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(_326);
    precise float _761 = _760 + _736;
    precise float _762 = _724 * _497;
    precise float _763 = _762 + _720;
    precise float _766 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(_269);
    precise float _767 = _766 + _728;
    precise float _770 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(_287);
    precise float _771 = _770 + _732;
    precise float _774 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(_306);
    precise float _775 = _774 + _740;
    precise float _778 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(_268);
    precise float _779 = _778 + _744;
    precise float _782 = uintBitsToFloat(srt_flatbuf_1.data[30u]) * uintBitsToFloat(_286);
    precise float _783 = _782 + _711;
    precise float _786 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(_326);
    precise float _787 = _786 + _748;
    precise float _790 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(_306);
    precise float _791 = _790 + _752;
    precise float _794 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(_268);
    precise float _795 = _794 + _756;
    precise float _798 = uintBitsToFloat(srt_flatbuf_1.data[31u]) * uintBitsToFloat(_286);
    precise float _799 = _798 + _714;
    precise float _801 = 0.64999997615814208984375 * inversesqrt(_716);
    precise float _804 = uintBitsToFloat(_287) * uintBitsToFloat(srt_flatbuf_1.data[35u]);
    precise float _805 = _804 + _799;
    precise float _806 = _767 * _525;
    precise float _807 = _806 + _763;
    precise float _810 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(_288);
    precise float _811 = _810 + _771;
    precise float _812 = _775 * _497;
    precise float _813 = _812 + _761;
    precise float _816 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(_269);
    precise float _817 = _816 + _779;
    precise float _820 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(_287);
    precise float _821 = _820 + _783;
    precise float _822 = _791 * _497;
    precise float _823 = _822 + _787;
    precise float _826 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(_269);
    precise float _827 = _826 + _795;
    float _828 = ((((srt_flatbuf_1.data[24u] >> 3u) & 1u) == 1u) ? true : false) ? _801 : 0.0;
    precise float _829 = _811 * _540;
    precise float _830 = _829 + _807;
    precise float _831 = _817 * _525;
    precise float _832 = _831 + _813;
    precise float _835 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(_288);
    precise float _836 = _835 + _821;
    precise float _837 = _827 * _525;
    precise float _838 = _837 + _823;
    precise float _841 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(_288);
    precise float _842 = _841 + _805;
    precise float _844 = _828 * (-_572);
    precise float _845 = _844 + _830;
    precise float _846 = _836 * _540;
    precise float _847 = _846 + _832;
    precise float _848 = _842 * _540;
    precise float _849 = _848 + _838;
    gl_Position.x = _847;
    gl_Position.y = _849;
    gl_Position.z = _845;
    gl_Position.w = _572;
    out_attr0.x = _130.x;
    out_attr0.y = _130.y;
    out_attr0.z = _828;
    out_attr0.w = 0.0;
}

