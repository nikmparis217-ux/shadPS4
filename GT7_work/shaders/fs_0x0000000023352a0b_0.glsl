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
#extension GL_EXT_fragment_shader_barycentric : require

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

uniform sampler2D SPIRV_Cross_Combinedfs_img32SPIRV_Cross_DummySampler;
uniform sampler2D SPIRV_Cross_Combinedfs_img32fs_sampsgpr_48;
uniform sampler2D SPIRV_Cross_Combinedfs_img24SPIRV_Cross_DummySampler;
uniform sampler2D SPIRV_Cross_Combinedfs_img24fs_sampsgpr_44;
uniform sampler2D SPIRV_Cross_Combinedfs_img0SPIRV_Cross_DummySampler;
uniform sampler2D SPIRV_Cross_Combinedfs_img0fs_sampsgpr_8;
uniform sampler2D SPIRV_Cross_Combinedfs_img0fs_sampsgpr_40;
uniform sampler2D SPIRV_Cross_Combinedfs_img16SPIRV_Cross_DummySampler;
uniform sampler2D SPIRV_Cross_Combinedfs_img16fs_sampsgpr_8;

layout(location = 0) pervertexEXT in vec4 fs_in_attr0_p[3];
layout(location = 0) out vec4 frag_color0;

void main()
{
    uint buf0_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(0u), int(8u)) >> 2u;
    uint _100 = 20u + buf0_dword_off;
    uint _104 = 21u + buf0_dword_off;
    uint _116 = 14u + buf0_dword_off;
    uint _120 = 15u + buf0_dword_off;
    precise float _127 = fs_in_attr0_p[1u].y - fs_in_attr0_p[0u].y;
    precise float _134 = fs_in_attr0_p[1u].x - fs_in_attr0_p[0u].x;
    precise float _140 = fs_in_attr0_p[2u].y - fs_in_attr0_p[0u].y;
    precise float _146 = fs_in_attr0_p[2u].x - fs_in_attr0_p[0u].x;
    precise float _151 = uintBitsToFloat(ssbo_1_1.data[_120]) * (-uintBitsToFloat(ssbo_1_1.data[_104]));
    precise float _152 = _151 + fma(_140, gl_BaryCoordEXT.z, fma(_127, gl_BaryCoordEXT.y, fs_in_attr0_p[0u].y));
    precise float _156 = uintBitsToFloat(ssbo_1_1.data[_116]) * (-uintBitsToFloat(ssbo_1_1.data[_100]));
    precise float _157 = _156 + fma(_146, gl_BaryCoordEXT.z, fma(_134, gl_BaryCoordEXT.y, fs_in_attr0_p[0u].x));
    precise float _159 = 1.0 + _152;
    precise float _161 = 1.0 + _157;
    precise float _163 = (-1.0) + _157;
    precise float _164 = (-1.0) + _152;
    uvec4 _167 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedfs_img32SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
    precise float _170 = _159 / float(_167.y);
    precise float _173 = _161 / float(_167.x);
    vec4 _178 = texture(SPIRV_Cross_Combinedfs_img32fs_sampsgpr_48, vec2(_173, _170));
    float _179 = _178.x;
    uvec4 _182 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedfs_img32SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
    precise float _185 = _152 / float(_182.y);
    precise float _188 = _157 / float(_182.x);
    vec4 _193 = texture(SPIRV_Cross_Combinedfs_img32fs_sampsgpr_48, vec2(_188, _185));
    float _194 = _193.x;
    uvec4 _197 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedfs_img32SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
    precise float _200 = _159 / float(_197.y);
    precise float _203 = _163 / float(_197.x);
    vec4 _208 = texture(SPIRV_Cross_Combinedfs_img32fs_sampsgpr_48, vec2(_203, _200));
    float _209 = _208.x;
    uvec4 _212 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedfs_img32SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
    precise float _215 = _164 / float(_212.y);
    precise float _218 = _161 / float(_212.x);
    vec4 _223 = texture(SPIRV_Cross_Combinedfs_img32fs_sampsgpr_48, vec2(_218, _215));
    float _224 = _223.x;
    uvec4 _227 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedfs_img32SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
    precise float _230 = _164 / float(_227.y);
    precise float _233 = _163 / float(_227.x);
    vec4 _238 = texture(SPIRV_Cross_Combinedfs_img32fs_sampsgpr_48, vec2(_233, _230));
    bool _240 = _179 > _194;
    float _241 = max(_194, _179);
    bool _242 = _209 > _241;
    bool _247 = _224 > max(_209, max(_194, _179));
    bool _251 = _238.x > max(_224, max(_209, _241));
    float _252 = _251 ? _163 : (_247 ? _161 : (_242 ? _163 : (_240 ? _161 : _157)));
    float _256 = _247 ? _164 : (_242 ? _159 : (_240 ? _159 : _152));
    float _258 = _251 ? _164 : _256;
    uvec4 _262 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedfs_img24SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
    precise float _265 = _258 / float(_262.y);
    precise float _268 = _252 / float(_262.x);
    vec4 _273 = texture(SPIRV_Cross_Combinedfs_img24fs_sampsgpr_44, vec2(_268, _265));
    float _274 = _273.x;
    float _275 = _273.y;
    bool _277 = (-1000.0) > _274;
    uint _300;
    uint _301;
    uint _302;
    uint _303;
    if (_277)
    {
        uvec4 _280 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedfs_img0SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
        precise float _283 = _152 / float(_280.y);
        precise float _286 = _157 / float(_280.x);
        vec4 _291 = texture(SPIRV_Cross_Combinedfs_img0fs_sampsgpr_8, vec2(_286, _283));
        _300 = floatBitsToUint(_291.w);
        _301 = floatBitsToUint(_291.z);
        _302 = floatBitsToUint(_291.y);
        _303 = floatBitsToUint(_291.x);
    }
    else
    {
        _300 = floatBitsToUint(_159);
        _301 = floatBitsToUint(_256);
        _302 = floatBitsToUint(_258);
        _303 = floatBitsToUint(_252);
    }
    bool _304 = !_277;
    uint _759;
    uint _760;
    uint _761;
    uint _762;
    if (!_277)
    {
        precise float _308 = (-_275) * uintBitsToFloat(ssbo_1_1.data[_120]);
        precise float _309 = _308 + _152;
        precise float _312 = (-_274) * uintBitsToFloat(ssbo_1_1.data[_116]);
        precise float _313 = _312 + _157;
        precise float _331 = uintBitsToFloat(ssbo_1_1.data[_120]) * _275;
        precise float _333 = uintBitsToFloat(ssbo_1_1.data[19u + buf0_dword_off]) * _309;
        precise float _335 = uintBitsToFloat(ssbo_1_1.data[18u + buf0_dword_off]) * _313;
        precise float _337 = uintBitsToFloat(ssbo_1_1.data[_116]) * _274;
        precise float _343 = _337 * _337;
        precise float _345 = _331 * _331;
        precise float _346 = _345 + _343;
        precise float _349 = uintBitsToFloat(ssbo_1_1.data[12u + buf0_dword_off]) * sqrt(_346);
        uvec4 _361 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedfs_img0SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
        precise float _364 = _152 / float(_361.y);
        precise float _367 = _157 / float(_361.x);
        vec4 _375 = textureOffset(SPIRV_Cross_Combinedfs_img0fs_sampsgpr_40, vec2(_367, _364), ivec2(0, 1));
        float _376 = _375.x;
        float _377 = _375.y;
        float _378 = _375.z;
        vec4 _381 = texelFetch(SPIRV_Cross_Combinedfs_img0SPIRV_Cross_DummySampler, ivec2(uvec2(uint(int(_157)), uint(int(_152)))), 0);
        float _382 = _381.x;
        float _383 = _381.y;
        float _384 = _381.z;
        uvec4 _389 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedfs_img0SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
        precise float _392 = _152 / float(_389.y);
        precise float _395 = _157 / float(_389.x);
        vec4 _402 = textureOffset(SPIRV_Cross_Combinedfs_img0fs_sampsgpr_40, vec2(_395, _392), ivec2(-1, 0));
        float _403 = _402.x;
        float _404 = _402.y;
        float _405 = _402.z;
        uvec4 _409 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedfs_img0SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
        precise float _412 = _152 / float(_409.y);
        precise float _415 = _157 / float(_409.x);
        vec4 _421 = textureOffset(SPIRV_Cross_Combinedfs_img0fs_sampsgpr_40, vec2(_415, _412), ivec2(0, -1));
        float _422 = _421.x;
        float _423 = _421.y;
        float _424 = _421.z;
        uvec4 _428 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedfs_img0SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
        precise float _431 = _152 / float(_428.y);
        precise float _434 = _157 / float(_428.x);
        vec4 _440 = textureOffset(SPIRV_Cross_Combinedfs_img0fs_sampsgpr_40, vec2(_434, _431), ivec2(1, 0));
        float _441 = _440.x;
        float _442 = _440.y;
        float _443 = _440.z;
        uint _460 = 10u + buf0_dword_off;
        precise float _468 = uintBitsToFloat(ssbo_1_1.data[24u + buf0_dword_off]) + _335;
        precise float _470 = uintBitsToFloat(ssbo_1_1.data[25u + buf0_dword_off]) + _333;
        uvec4 _473 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedfs_img16SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
        precise float _476 = _470 / float(_473.y);
        precise float _479 = _468 / float(_473.x);
        vec4 _484 = texture(SPIRV_Cross_Combinedfs_img16fs_sampsgpr_8, vec2(_479, _476));
        float _485 = _484.x;
        float _486 = _484.y;
        float _487 = _484.z;
        float _488 = _484.w;
        precise float _491 = _376 + _378;
        precise float _493 = 2.0 * _377;
        precise float _494 = _493 + _491;
        precise float _495 = 2.0 * _382;
        precise float _496 = 2.0 * _376;
        precise float _498 = (-2.0) * _378;
        precise float _499 = _498 + _496;
        precise float _500 = (-2.0) * _384;
        precise float _501 = _500 + _495;
        precise float _504 = (-_382) + (-_384);
        precise float _507 = (-_376) + (-_378);
        precise float _508 = 1.0 + _494;
        precise float _509 = 2.0 * _383;
        precise float _510 = _509 + _504;
        float _511 = 1.0 / _508;
        precise float _512 = 2.0 * _377;
        precise float _513 = _512 + _507;
        precise float _514 = _511 * _513;
        precise float _515 = _511 * _494;
        precise float _516 = _422 + _424;
        precise float _517 = 2.0 * _423;
        precise float _518 = _517 + _516;
        precise float _519 = _511 * _499;
        precise float _520 = 2.0 * _422;
        precise float _521 = (-2.0) * _424;
        precise float _522 = _521 + _520;
        precise float _525 = (-_422) + (-_424);
        precise float _526 = 1.0 + _518;
        float _527 = 1.0 / _526;
        precise float _528 = 2.0 * _423;
        precise float _529 = _528 + _525;
        precise float _530 = _527 * _529;
        precise float _531 = _527 * _518;
        precise float _532 = _382 + _384;
        precise float _533 = 2.0 * _383;
        precise float _534 = _533 + _532;
        precise float _535 = 1.0 + _534;
        float _536 = 1.0 / _535;
        precise float _537 = _527 * _522;
        precise float _538 = 2.0 * _403;
        precise float _539 = (-2.0) * _405;
        precise float _540 = _539 + _538;
        precise float _541 = _536 * _510;
        precise float _542 = _536 * _534;
        uint _543 = floatBitsToUint(_542);
        precise float _544 = _536 * _501;
        precise float _545 = _403 + _405;
        precise float _546 = 2.0 * _404;
        precise float _547 = _546 + _545;
        precise float _550 = (-_403) + (-_405);
        precise float _551 = 1.0 + _547;
        float _552 = 1.0 / _551;
        precise float _553 = 2.0 * _404;
        precise float _554 = _553 + _550;
        precise float _555 = _552 * _540;
        precise float _556 = _552 * _554;
        precise float _557 = _552 * _547;
        precise float _558 = 2.0 * _441;
        precise float _563 = _441 + _443;
        precise float _564 = 2.0 * _442;
        precise float _565 = _564 + _563;
        precise float _568 = (-_441) + (-_443);
        precise float _569 = (-2.0) * _443;
        precise float _570 = _569 + _558;
        precise float _571 = 2.0 * _442;
        precise float _572 = _571 + _568;
        precise float _573 = 1.0 + _565;
        float _574 = 1.0 / _573;
        precise float _579 = _574 * _570;
        precise float _580 = _574 * _565;
        precise float _581 = _574 * _572;
        precise float _584 = _485 + _487;
        precise float _585 = 2.0 * _486;
        precise float _586 = _585 + _584;
        precise float _593 = 2.0 * _485;
        precise float _594 = (-2.0) * _487;
        precise float _595 = _594 + _593;
        float _597 = min(_515, min(min(_542, min(_531, _557)), _580));
        precise float _600 = 1.0 + _586;
        precise float _603 = (-_485) + (-_487);
        float _606 = 1.0 / _600;
        precise float _607 = 2.0 * _486;
        precise float _608 = _607 + _603;
        float _610 = max(_515, max(max(_542, max(_531, _557)), _580));
        precise float _611 = _606 * _586;
        precise float _612 = _606 * _595;
        precise float _613 = _606 * _608;
        float _616 = max(min(_519, min(min(_544, min(_537, _555)), _579)), min(max(_519, max(max(_544, max(_537, _555)), _579)), _612));
        float _618 = max(_597, min(_610, _611));
        float _619 = max(min(_514, min(min(_541, min(_530, _556)), _581)), min(max(_514, max(max(_541, max(_530, _556)), _581)), _613));
        precise float _620 = _610 - _597;
        uint _644;
        if (uintBitsToFloat(ssbo_1_1.data[3u + buf0_dword_off]) > 0.0)
        {
            precise float _621 = _531 + _557;
            precise float _622 = _621 + _580;
            precise float _623 = _622 + _515;
            precise float _626 = 0.25 * (-_623);
            precise float _627 = _626 + 1.0;
            precise float _629 = 1.0 - _542;
            precise float _630 = 1.0 + (1.0 / _627);
            precise float _633 = 0.25 * _623;
            uint _643;
            if (_304 && (_630 < (1.0 / _629)))
            {
                precise float _635 = _488 * _349;
                precise float _637 = 0.0500000007450580596923828125 * _635;
                precise float _639 = _633 - _542;
                precise float _640 = _639 * clamp(_637, 0.0, 1.0);
                precise float _641 = _640 + _542;
                _643 = floatBitsToUint(_641);
            }
            else
            {
                _643 = _543;
            }
            _644 = _643;
        }
        else
        {
            _644 = _543;
        }
        precise float _645 = _597 - _611;
        precise float _646 = _610 - _611;
        float _649 = min(abs(_645), abs(_646));
        precise float _651 = uintBitsToFloat(ssbo_1_1.data[_100]) + _274;
        precise float _652 = _620 + _649;
        precise float _665 = _651 * _651;
        precise float _667 = uintBitsToFloat(ssbo_1_1.data[_104]) + _275;
        precise float _670 = uintBitsToFloat(ssbo_1_1.data[9u + buf0_dword_off]) * _649;
        precise float _672 = uintBitsToFloat(ssbo_1_1.data[11u + buf0_dword_off]) * _620;
        precise float _675 = 1.0 - uintBitsToFloat(ssbo_1_1.data[_460]);
        precise float _676 = _349 - _488;
        precise float _677 = _667 * _667;
        precise float _678 = _677 + _665;
        precise float _679 = (1.0 / _652) * _670;
        precise float _681 = _675 * clamp(_672, 0.0, 1.0);
        precise float _682 = _681 + uintBitsToFloat(ssbo_1_1.data[_460]);
        precise float _685 = uintBitsToFloat(ssbo_1_1.data[4u + buf0_dword_off]) * abs(_676);
        precise float _688 = _679 * _682;
        precise float _691 = uintBitsToFloat(_644) - _618;
        precise float _692 = _544 - _616;
        precise float _693 = _541 - _619;
        precise float _695 = 0.00999999977648258209228515625 * _685;
        float _696 = clamp(_695, 0.0, 1.0);
        precise float _697 = 0.00999999977648258209228515625 + clamp(_688, 0.0, 1.0);
        float _698 = clamp(_697, 0.0, 1.0);
        precise float _700 = _691 * _696;
        precise float _701 = _700 + _618;
        precise float _702 = _692 * _696;
        precise float _703 = _702 + _616;
        precise float _704 = _693 * _696;
        precise float _705 = _704 + _619;
        uint _717;
        if (_304 && (uintBitsToFloat(ssbo_1_1.data[5u + buf0_dword_off]) >= _678))
        {
            precise float _709 = uintBitsToFloat(ssbo_1_1.data[7u + buf0_dword_off]) * (-_678);
            precise float _711 = (-1.0) + uintBitsToFloat(ssbo_1_1.data[22u + buf0_dword_off]);
            precise float _712 = _711 * _709;
            precise float _713 = _712 + _711;
            precise float _714 = _713 * _698;
            precise float _715 = _714 + _698;
            _717 = floatBitsToUint(_715);
        }
        else
        {
            _717 = floatBitsToUint(_698);
        }
        bool _718 = 0u != floatBitsToUint((((uintBitsToFloat(ssbo_1_1.data[16u + buf0_dword_off]) <= _335) || (uintBitsToFloat(ssbo_1_1.data[17u + buf0_dword_off]) <= _333)) || (0.0 > min(_335, _333))) ? 1.4012984643248170709237295832899e-45 : 0.0);
        float _720 = _718 ? uintBitsToFloat(_644) : _701;
        precise float _722 = uintBitsToFloat(_644) - _720;
        precise float _724 = _722 * uintBitsToFloat(_717);
        precise float _725 = _724 + _720;
        float _726 = _718 ? _541 : _705;
        precise float _727 = 1.0 - _725;
        precise float _728 = _541 - _726;
        float _729 = _718 ? _544 : _703;
        float _730 = 1.0 / _727;
        precise float _731 = _544 - _729;
        precise float _733 = _728 * uintBitsToFloat(_717);
        precise float _734 = _733 + _726;
        precise float _735 = _730 * _734;
        precise float _737 = _731 * uintBitsToFloat(_717);
        precise float _738 = _737 + _729;
        precise float _739 = 0.25 * _735;
        precise float _740 = _730 * _725;
        precise float _741 = _730 * _738;
        precise float _743 = 0.25 * _740;
        precise float _744 = _743 + (-_739);
        precise float _747 = 0.25 * (-_741);
        precise float _748 = _747 + (-_739);
        precise float _749 = 0.25 * _740;
        precise float _750 = _741 * 0.25;
        precise float _751 = _750 + _744;
        precise float _753 = _740 * 0.25;
        precise float _754 = _753 + _748;
        precise float _756 = _735 * 0.25;
        precise float _757 = _756 + _749;
        _759 = floatBitsToUint(_349);
        _760 = floatBitsToUint(_754);
        _761 = floatBitsToUint(_751);
        _762 = floatBitsToUint(_757);
    }
    else
    {
        _759 = _300;
        _760 = _301;
        _761 = _303;
        _762 = _302;
    }
    frag_color0.x = uintBitsToFloat(_759);
    frag_color0.y = uintBitsToFloat(_760);
    frag_color0.z = uintBitsToFloat(_762);
    frag_color0.w = uintBitsToFloat(_761);
}

