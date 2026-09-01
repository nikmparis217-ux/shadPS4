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

uint _154;

layout(binding = 0, std430) readonly buffer ssbo_1
{
    uint data[];
} ssbo_1_1;

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

uniform sampler2D SPIRV_Cross_Combinedfs_img40fs_sampsgpr_8;
uniform sampler2D SPIRV_Cross_Combinedfs_img48fs_sampsgpr_8;
uniform sampler2D SPIRV_Cross_Combinedfs_img0fs_sampsgpr_56;
uniform sampler2D SPIRV_Cross_Combinedfs_img16fs_sampsgpr_56;
uniform sampler3D SPIRV_Cross_Combinedfs_img24fs_sampsgpr_56;
uniform sampler2D SPIRV_Cross_Combinedfs_img32fs_sampsgpr_56;

layout(location = 0) pervertexEXT in vec4 fs_in_attr0_p[3];
layout(location = 0) out vec4 frag_color0;

void main()
{
    uint buf0_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(0u), int(8u)) >> 2u;
    uint _174 = 80u + buf0_dword_off;
    uint _178 = 81u + buf0_dword_off;
    uint _182 = 82u + buf0_dword_off;
    precise float _189 = fs_in_attr0_p[1u].x - fs_in_attr0_p[0u].x;
    precise float _196 = fs_in_attr0_p[1u].y - fs_in_attr0_p[0u].y;
    bool _199 = uintBitsToFloat(ssbo_1_1.data[_174]) > 0.0;
    precise float _204 = fs_in_attr0_p[2u].x - fs_in_attr0_p[0u].x;
    precise float _205 = fma(_204, gl_BaryCoordEXT.z, fma(_189, gl_BaryCoordEXT.y, fs_in_attr0_p[0u].x));
    precise float _210 = fs_in_attr0_p[2u].y - fs_in_attr0_p[0u].y;
    precise float _211 = fma(_210, gl_BaryCoordEXT.z, fma(_196, gl_BaryCoordEXT.y, fs_in_attr0_p[0u].y));
    uint _433;
    uint _434;
    uint _435;
    if (_199)
    {
        precise float _214 = (-0.5) + _205;
        precise float _218 = (1.0 / uintBitsToFloat(ssbo_1_1.data[_174])) * _214;
        precise float _219 = (-0.5) + _211;
        precise float _223 = uintBitsToFloat(ssbo_1_1.data[_178]) * _218;
        precise float _224 = (1.0 / uintBitsToFloat(ssbo_1_1.data[_182])) * _219;
        precise float _237 = _223 * _223;
        precise float _239 = uintBitsToFloat(ssbo_1_1.data[_178]) * _224;
        precise float _240 = _239 * _239;
        precise float _241 = _240 + _237;
        uint _243 = 73u + buf0_dword_off;
        precise float _259 = uintBitsToFloat(ssbo_1_1.data[_182]) * _239;
        precise float _262 = uintBitsToFloat(ssbo_1_1.data[86u + buf0_dword_off]) * _241;
        precise float _263 = _262 + uintBitsToFloat(ssbo_1_1.data[85u + buf0_dword_off]);
        precise float _265 = _241 * _263;
        precise float _266 = _265 + uintBitsToFloat(ssbo_1_1.data[84u + buf0_dword_off]);
        precise float _267 = _241 * _266;
        precise float _268 = _267 + 1.0;
        precise float _270 = uintBitsToFloat(ssbo_1_1.data[_174]) * _223;
        precise float _271 = _259 * _268;
        precise float _273 = _271 + 0.5;
        precise float _274 = _270 * _268;
        precise float _275 = _274 + 0.5;
        precise float _277 = uintBitsToFloat(ssbo_1_1.data[77u + buf0_dword_off]) * _273;
        precise float _279 = uintBitsToFloat(ssbo_1_1.data[76u + buf0_dword_off]) * _275;
        vec4 _284 = texture(SPIRV_Cross_Combinedfs_img40fs_sampsgpr_8, vec2(_279, _277));
        float _285 = _284.x;
        float _287 = _284.y;
        float _289 = _284.z;
        uint _389;
        uint _390;
        uint _391;
        if (0.0 < uintBitsToFloat(ssbo_1_1.data[_243]))
        {
            vec4 _301 = textureOffset(SPIRV_Cross_Combinedfs_img40fs_sampsgpr_8, vec2(_279, _277), ivec2(1, 0));
            vec4 _313 = textureOffset(SPIRV_Cross_Combinedfs_img40fs_sampsgpr_8, vec2(_279, _277), ivec2(0, -1));
            vec4 _323 = textureOffset(SPIRV_Cross_Combinedfs_img40fs_sampsgpr_8, vec2(_279, _277), ivec2(-1, 0));
            vec4 _333 = textureOffset(SPIRV_Cross_Combinedfs_img40fs_sampsgpr_8, vec2(_279, _277), ivec2(0, 1));
            precise float _337 = 0.5 * _287;
            precise float _338 = _285 + _289;
            precise float _340 = _338 * 0.25;
            precise float _341 = _340 + _337;
            precise float _343 = _338 * (-0.25);
            precise float _344 = _343 + _337;
            precise float _345 = 0.5 * _285;
            precise float _346 = (-0.5) * _289;
            precise float _347 = _346 + _345;
            precise float _348 = _323.x + _301.x;
            precise float _349 = _323.z + _301.z;
            precise float _350 = _348 + _313.x;
            precise float _351 = _349 + _313.z;
            precise float _352 = _323.y + _301.y;
            precise float _353 = _350 + _333.x;
            precise float _354 = _352 + _313.y;
            precise float _357 = 5.0 * _285;
            precise float _358 = _357 + (-_353);
            precise float _359 = _351 + _333.z;
            precise float _361 = 5.0 * _289;
            precise float _362 = _361 + (-_359);
            precise float _363 = _354 + _333.y;
            precise float _364 = _358 + _362;
            precise float _366 = 5.0 * _287;
            precise float _367 = _366 + (-_363);
            precise float _368 = _367 * 0.5;
            precise float _369 = _364 * 0.25;
            precise float _370 = _369 + _368;
            precise float _371 = _341 - _370;
            precise float _375 = uintBitsToFloat(ssbo_1_1.data[74u + buf0_dword_off]) + (-abs(_371));
            precise float _378 = uintBitsToFloat(ssbo_1_1.data[_243]) * clamp(_375, 0.0, 1.0);
            precise float _379 = _370 - _341;
            precise float _380 = _379 * _378;
            precise float _381 = _380 + _341;
            precise float _382 = _381 - _344;
            precise float _383 = _347 + _382;
            precise float _385 = _382 - _347;
            precise float _387 = _344 + _381;
            _389 = floatBitsToUint(_385);
            _390 = floatBitsToUint(_387);
            _391 = floatBitsToUint(_383);
        }
        else
        {
            _389 = floatBitsToUint(_289);
            _390 = floatBitsToUint(_287);
            _391 = floatBitsToUint(_285);
        }
        precise float _410 = uintBitsToFloat(ssbo_1_1.data[91u + buf0_dword_off]) * _273;
        precise float _411 = _410 + uintBitsToFloat(ssbo_1_1.data[89u + buf0_dword_off]);
        precise float _414 = uintBitsToFloat(ssbo_1_1.data[90u + buf0_dword_off]) * _275;
        precise float _415 = _414 + uintBitsToFloat(ssbo_1_1.data[88u + buf0_dword_off]);
        vec4 _420 = texture(SPIRV_Cross_Combinedfs_img48fs_sampsgpr_8, vec2(_415, _411));
        precise float _425 = _420.x + uintBitsToFloat(_391);
        precise float _428 = uintBitsToFloat(_390) + _420.y;
        precise float _431 = uintBitsToFloat(_389) + _420.z;
        _433 = floatBitsToUint(_431);
        _434 = floatBitsToUint(_428);
        _435 = floatBitsToUint(_425);
    }
    else
    {
        _433 = _154;
        _434 = floatBitsToUint(gl_BaryCoordEXT.z);
        _435 = floatBitsToUint(gl_BaryCoordEXT.y);
    }
    uint _586;
    uint _587;
    uint _588;
    if (!_199)
    {
        uint _436 = 73u + buf0_dword_off;
        precise float _449 = uintBitsToFloat(ssbo_1_1.data[76u + buf0_dword_off]) * _205;
        precise float _451 = uintBitsToFloat(ssbo_1_1.data[77u + buf0_dword_off]) * _211;
        vec4 _456 = texture(SPIRV_Cross_Combinedfs_img40fs_sampsgpr_8, vec2(_449, _451));
        float _457 = _456.x;
        float _459 = _456.y;
        float _461 = _456.z;
        uint _546;
        uint _547;
        uint _548;
        if (0.0 < uintBitsToFloat(ssbo_1_1.data[_436]))
        {
            vec4 _469 = textureOffset(SPIRV_Cross_Combinedfs_img40fs_sampsgpr_8, vec2(_449, _451), ivec2(1, 0));
            vec4 _477 = textureOffset(SPIRV_Cross_Combinedfs_img40fs_sampsgpr_8, vec2(_449, _451), ivec2(-1, 0));
            vec4 _485 = textureOffset(SPIRV_Cross_Combinedfs_img40fs_sampsgpr_8, vec2(_449, _451), ivec2(0, -1));
            vec4 _493 = textureOffset(SPIRV_Cross_Combinedfs_img40fs_sampsgpr_8, vec2(_449, _451), ivec2(0, 1));
            precise float _497 = 0.5 * _459;
            precise float _498 = _457 + _461;
            precise float _499 = _498 * 0.25;
            precise float _500 = _499 + _497;
            precise float _501 = _498 * (-0.25);
            precise float _502 = _501 + _497;
            precise float _503 = 0.5 * _457;
            precise float _504 = (-0.5) * _461;
            precise float _505 = _504 + _503;
            precise float _506 = _477.x + _469.x;
            precise float _507 = _477.z + _469.z;
            precise float _508 = _506 + _485.x;
            precise float _509 = _507 + _485.z;
            precise float _510 = _477.y + _469.y;
            precise float _511 = _508 + _493.x;
            precise float _512 = _510 + _485.y;
            precise float _514 = 5.0 * _457;
            precise float _515 = _514 + (-_511);
            precise float _516 = _509 + _493.z;
            precise float _518 = 5.0 * _461;
            precise float _519 = _518 + (-_516);
            precise float _520 = _512 + _493.y;
            precise float _521 = _515 + _519;
            precise float _523 = 5.0 * _459;
            precise float _524 = _523 + (-_520);
            precise float _525 = _524 * 0.5;
            precise float _526 = _521 * 0.25;
            precise float _527 = _526 + _525;
            precise float _528 = _500 - _527;
            precise float _532 = uintBitsToFloat(ssbo_1_1.data[74u + buf0_dword_off]) + (-abs(_528));
            precise float _535 = uintBitsToFloat(ssbo_1_1.data[_436]) * clamp(_532, 0.0, 1.0);
            precise float _536 = _527 - _500;
            precise float _537 = _536 * _535;
            precise float _538 = _537 + _500;
            precise float _539 = _538 - _502;
            precise float _540 = _505 + _539;
            precise float _542 = _539 - _505;
            precise float _544 = _502 + _538;
            _546 = floatBitsToUint(_542);
            _547 = floatBitsToUint(_544);
            _548 = floatBitsToUint(_540);
        }
        else
        {
            _546 = floatBitsToUint(_461);
            _547 = floatBitsToUint(_459);
            _548 = floatBitsToUint(_457);
        }
        precise float _563 = uintBitsToFloat(ssbo_1_1.data[91u + buf0_dword_off]) * _211;
        precise float _564 = _563 + uintBitsToFloat(ssbo_1_1.data[89u + buf0_dword_off]);
        precise float _567 = uintBitsToFloat(ssbo_1_1.data[90u + buf0_dword_off]) * _205;
        precise float _568 = _567 + uintBitsToFloat(ssbo_1_1.data[88u + buf0_dword_off]);
        vec4 _573 = texture(SPIRV_Cross_Combinedfs_img48fs_sampsgpr_8, vec2(_568, _564));
        precise float _578 = _573.x + uintBitsToFloat(_548);
        precise float _581 = uintBitsToFloat(_547) + _573.y;
        precise float _584 = uintBitsToFloat(_546) + _573.z;
        _586 = floatBitsToUint(_578);
        _587 = floatBitsToUint(_581);
        _588 = floatBitsToUint(_584);
    }
    else
    {
        _586 = _435;
        _587 = _434;
        _588 = _433;
    }
    uint _624 = 1u + buf0_dword_off;
    precise float _635 = uintBitsToFloat(ssbo_1_1.data[10u + buf0_dword_off]) * uintBitsToFloat(_588);
    precise float _638 = uintBitsToFloat(ssbo_1_1.data[14u + buf0_dword_off]) * uintBitsToFloat(_588);
    precise float _641 = uintBitsToFloat(ssbo_1_1.data[18u + buf0_dword_off]) * uintBitsToFloat(_588);
    precise float _644 = uintBitsToFloat(_587) * uintBitsToFloat(ssbo_1_1.data[9u + buf0_dword_off]);
    precise float _645 = _644 + _635;
    precise float _648 = uintBitsToFloat(ssbo_1_1.data[13u + buf0_dword_off]) * uintBitsToFloat(_587);
    precise float _649 = _648 + _638;
    precise float _652 = uintBitsToFloat(ssbo_1_1.data[17u + buf0_dword_off]) * uintBitsToFloat(_587);
    precise float _653 = _652 + _641;
    precise float _658 = uintBitsToFloat(ssbo_1_1.data[8u + buf0_dword_off]) * uintBitsToFloat(_586);
    precise float _659 = _658 + _645;
    precise float _662 = uintBitsToFloat(ssbo_1_1.data[12u + buf0_dword_off]) * uintBitsToFloat(_586);
    precise float _663 = _662 + _649;
    precise float _666 = uintBitsToFloat(ssbo_1_1.data[16u + buf0_dword_off]) * uintBitsToFloat(_586);
    precise float _667 = _666 + _653;
    float _669 = max(0.0, _659);
    float _671 = max(0.0, _663);
    float _673 = max(0.0, _667);
    uint _730;
    uint _731;
    uint _732;
    uint _733;
    if (!(uintBitsToFloat(ssbo_1_1.data[_624]) <= 0.0))
    {
        precise float _677 = 0.2626999914646148681640625 * _669;
        precise float _679 = _671 * 0.677998006343841552734375;
        precise float _680 = _679 + _677;
        precise float _682 = _673 * 0.0593019984662532806396484375;
        precise float _683 = _682 + _680;
        precise float _684 = 1.0 - _683;
        precise float _688 = uintBitsToFloat(ssbo_1_1.data[2u + buf0_dword_off]) * log2(clamp(_684, 0.0, 1.0));
        precise float _698 = uintBitsToFloat(ssbo_1_1.data[5u + buf0_dword_off]) * _211;
        precise float _700 = (-1.0) + exp2(_688);
        precise float _702 = uintBitsToFloat(ssbo_1_1.data[4u + buf0_dword_off]) * _205;
        vec4 _707 = texture(SPIRV_Cross_Combinedfs_img0fs_sampsgpr_56, vec2(_702, _698));
        precise float _713 = uintBitsToFloat(ssbo_1_1.data[_624]) * uintBitsToFloat(ssbo_1_1.data[3u + buf0_dword_off]);
        precise float _715 = _713 * _700;
        precise float _716 = _715 + uintBitsToFloat(ssbo_1_1.data[_624]);
        precise float _717 = (-0.5) + _707.x;
        precise float _718 = (-0.5) + _707.y;
        precise float _719 = (-0.5) + _707.z;
        precise float _721 = _717 * _716;
        precise float _722 = _721 + _669;
        precise float _724 = _718 * _716;
        precise float _725 = _724 + _671;
        precise float _727 = _719 * _716;
        precise float _728 = _727 + _673;
        _730 = floatBitsToUint(_719);
        _731 = floatBitsToUint(_728);
        _732 = floatBitsToUint(_725);
        _733 = floatBitsToUint(_722);
    }
    else
    {
        _730 = floatBitsToUint(_667);
        _731 = floatBitsToUint(_673);
        _732 = floatBitsToUint(_671);
        _733 = floatBitsToUint(_669);
    }
    uint _735 = 40u + buf0_dword_off;
    bool _747 = uintBitsToFloat(ssbo_1_1.data[_735]) < 1.0;
    bool _750 = uintBitsToFloat(ssbo_1_1.data[_735]) < 4.0;
    bool _753 = uintBitsToFloat(ssbo_1_1.data[_735]) < 2.0;
    bool _756 = uintBitsToFloat(ssbo_1_1.data[_735]) < 3.0;
    uint _808;
    uint _809;
    uint _810;
    uint _811;
    uint _812;
    uint _813;
    uint _814;
    if (_747)
    {
        precise float _762 = 0.00200000009499490261077880859375 * uintBitsToFloat(_733);
        precise float _765 = 0.00200000009499490261077880859375 * uintBitsToFloat(_732);
        precise float _768 = 0.00200000009499490261077880859375 * uintBitsToFloat(_731);
        precise float _784 = fma(0.9998779296875, sqrt(clamp(_768, 0.0, 1.0)), 6.103515625e-05);
        _808 = floatBitsToUint(_784);
        _809 = floatBitsToUint(_784);
        _810 = floatBitsToUint(texture(SPIRV_Cross_Combinedfs_img16fs_sampsgpr_56, vec2(_784)).x);
        _811 = floatBitsToUint(texture(SPIRV_Cross_Combinedfs_img16fs_sampsgpr_56, vec2(fma(0.9998779296875, sqrt(clamp(_765, 0.0, 1.0)), 6.103515625e-05))).x);
        _812 = floatBitsToUint(texture(SPIRV_Cross_Combinedfs_img16fs_sampsgpr_56, vec2(fma(0.9998779296875, sqrt(clamp(_762, 0.0, 1.0)), 6.103515625e-05))).x);
        _813 = srt_flatbuf_1.data[58u];
        _814 = srt_flatbuf_1.data[57u];
    }
    else
    {
        _808 = _730;
        _809 = 1084227584u;
        _810 = _731;
        _811 = _732;
        _812 = _733;
        _813 = ssbo_1_1.data[42u + buf0_dword_off];
        _814 = ssbo_1_1.data[41u + buf0_dword_off];
    }
    uint _1948;
    uint _1949;
    uint _1950;
    if (!_747)
    {
        uint _858;
        uint _859;
        uint _860;
        uint _861;
        if (_753)
        {
            float _817 = 1.0 / uintBitsToFloat(_814);
            precise float _819 = uintBitsToFloat(_810) * _817;
            precise float _822 = uintBitsToFloat(_811) * _817;
            precise float _825 = uintBitsToFloat(_812) * _817;
            precise float _833 = (-2.0) * uintBitsToFloat(_813);
            precise float _834 = _833 + 1.0;
            float _836 = inversesqrt(inversesqrt(clamp(_825, 0.0, 1.0)));
            precise float _839 = inversesqrt(inversesqrt(clamp(_819, 0.0, 1.0))) * _834;
            precise float _840 = _839 + uintBitsToFloat(_813);
            precise float _842 = inversesqrt(inversesqrt(clamp(_822, 0.0, 1.0))) * _834;
            precise float _843 = _842 + uintBitsToFloat(_813);
            precise float _845 = _836 * _834;
            precise float _846 = _845 + uintBitsToFloat(_813);
            vec4 _851 = texture(SPIRV_Cross_Combinedfs_img24fs_sampsgpr_56, vec3(_846, _843, _840));
            _858 = floatBitsToUint(_836);
            _859 = floatBitsToUint(_851.z);
            _860 = floatBitsToUint(_851.y);
            _861 = floatBitsToUint(_851.x);
        }
        else
        {
            _858 = _809;
            _859 = _810;
            _860 = _811;
            _861 = _812;
        }
        uint _1945;
        uint _1946;
        uint _1947;
        if (!_753)
        {
            uint _1407;
            uint _1408;
            uint _1409;
            uint _1410;
            uint _1411;
            if (_756)
            {
                uint _866 = 44u + buf0_dword_off;
                uint _870 = 45u + buf0_dword_off;
                uint _874 = 46u + buf0_dword_off;
                uint _878 = 47u + buf0_dword_off;
                uint _882 = 48u + buf0_dword_off;
                uint _890 = 50u + buf0_dword_off;
                uint _894 = 51u + buf0_dword_off;
                uint _898 = 52u + buf0_dword_off;
                uint _902 = 53u + buf0_dword_off;
                uint _906 = 54u + buf0_dword_off;
                uint _910 = 55u + buf0_dword_off;
                precise float _915 = uintBitsToFloat(ssbo_1_1.data[_866]) * uintBitsToFloat(ssbo_1_1.data[_870]);
                bool _918 = (uintBitsToFloat(_861) > _915) || (0.0 > uintBitsToFloat(_861));
                uint _924;
                if (_918)
                {
                    _924 = floatBitsToUint((0.0 > uintBitsToFloat(_861)) ? 0.0 : uintBitsToFloat(ssbo_1_1.data[_866]));
                }
                else
                {
                    _924 = ssbo_1_1.data[_870];
                }
                uint _972;
                uint _973;
                uint _974;
                if (!_918)
                {
                    precise float _929 = uintBitsToFloat(_861) * (1.0 / uintBitsToFloat(ssbo_1_1.data[_890]));
                    precise float _932 = uintBitsToFloat(ssbo_1_1.data[_910]) * uintBitsToFloat(_861);
                    float _934 = clamp(max(0.0, _929), 0.0, 1.0);
                    precise float _937 = uintBitsToFloat(ssbo_1_1.data[_890]) + uintBitsToFloat(ssbo_1_1.data[_894]);
                    precise float _939 = (-1.44269502162933349609375) * _932;
                    precise float _944 = (-_934) * _934;
                    bool _946 = uintBitsToFloat(_861) < _937;
                    precise float _949 = uintBitsToFloat(ssbo_1_1.data[_898]) * log2(abs(_929));
                    precise float _950 = _944 * fma(-2.0, _934, 3.0);
                    precise float _951 = _950 + 1.0;
                    precise float _957 = (-uintBitsToFloat(ssbo_1_1.data[_906])) * exp2(_939);
                    precise float _958 = _957 + uintBitsToFloat(ssbo_1_1.data[_902]);
                    precise float _959 = (_946 ? 0.0 : (-1.0)) - _951;
                    precise float _962 = uintBitsToFloat(ssbo_1_1.data[_890]) * exp2(_949);
                    precise float _963 = 1.0 + _959;
                    precise float _965 = _951 * _962;
                    precise float _966 = _965 + (_946 ? 0.0 : _958);
                    precise float _969 = uintBitsToFloat(_861) * _963;
                    precise float _970 = _969 + _966;
                    _972 = floatBitsToUint(_966);
                    _973 = floatBitsToUint(_963);
                    _974 = floatBitsToUint(_970);
                }
                else
                {
                    _972 = _808;
                    _973 = _858;
                    _974 = _924;
                }
                bool _979 = (uintBitsToFloat(_860) > _915) || (0.0 > uintBitsToFloat(_860));
                uint _985;
                if (_979)
                {
                    _985 = floatBitsToUint((0.0 > uintBitsToFloat(_860)) ? 0.0 : uintBitsToFloat(ssbo_1_1.data[_866]));
                }
                else
                {
                    _985 = _973;
                }
                uint _1031;
                uint _1032;
                if (!_979)
                {
                    precise float _990 = uintBitsToFloat(_860) * (1.0 / uintBitsToFloat(ssbo_1_1.data[_890]));
                    precise float _993 = uintBitsToFloat(ssbo_1_1.data[_910]) * uintBitsToFloat(_860);
                    float _995 = clamp(max(0.0, _990), 0.0, 1.0);
                    precise float _998 = uintBitsToFloat(ssbo_1_1.data[_890]) + uintBitsToFloat(ssbo_1_1.data[_894]);
                    precise float _999 = (-1.44269502162933349609375) * _993;
                    precise float _1004 = (-_995) * _995;
                    bool _1006 = uintBitsToFloat(_860) < _998;
                    precise float _1009 = uintBitsToFloat(ssbo_1_1.data[_898]) * log2(abs(_990));
                    precise float _1010 = _1004 * fma(-2.0, _995, 3.0);
                    precise float _1011 = _1010 + 1.0;
                    precise float _1017 = (-uintBitsToFloat(ssbo_1_1.data[_906])) * exp2(_999);
                    precise float _1018 = _1017 + uintBitsToFloat(ssbo_1_1.data[_902]);
                    precise float _1019 = (_1006 ? 0.0 : (-1.0)) - _1011;
                    precise float _1022 = uintBitsToFloat(ssbo_1_1.data[_890]) * exp2(_1009);
                    precise float _1023 = 1.0 + _1019;
                    precise float _1025 = _1011 * _1022;
                    precise float _1026 = _1025 + (_1006 ? 0.0 : _1018);
                    precise float _1028 = uintBitsToFloat(_860) * _1023;
                    precise float _1029 = _1028 + _1026;
                    _1031 = floatBitsToUint(_1023);
                    _1032 = floatBitsToUint(_1029);
                }
                else
                {
                    _1031 = _972;
                    _1032 = _985;
                }
                bool _1037 = (uintBitsToFloat(_859) > _915) || (0.0 > uintBitsToFloat(_859));
                uint _1043;
                if (_1037)
                {
                    _1043 = floatBitsToUint((0.0 > uintBitsToFloat(_859)) ? 0.0 : uintBitsToFloat(ssbo_1_1.data[_866]));
                }
                else
                {
                    _1043 = _1031;
                }
                uint _1088;
                if (!_1037)
                {
                    precise float _1048 = uintBitsToFloat(_859) * (1.0 / uintBitsToFloat(ssbo_1_1.data[_890]));
                    precise float _1051 = uintBitsToFloat(ssbo_1_1.data[_910]) * uintBitsToFloat(_859);
                    float _1053 = clamp(max(0.0, _1048), 0.0, 1.0);
                    precise float _1056 = uintBitsToFloat(ssbo_1_1.data[_890]) + uintBitsToFloat(ssbo_1_1.data[_894]);
                    precise float _1057 = (-1.44269502162933349609375) * _1051;
                    precise float _1062 = (-_1053) * _1053;
                    bool _1064 = uintBitsToFloat(_859) < _1056;
                    precise float _1067 = uintBitsToFloat(ssbo_1_1.data[_898]) * log2(abs(_1048));
                    precise float _1068 = _1062 * fma(-2.0, _1053, 3.0);
                    precise float _1069 = _1068 + 1.0;
                    precise float _1075 = (-uintBitsToFloat(ssbo_1_1.data[_906])) * exp2(_1057);
                    precise float _1076 = _1075 + uintBitsToFloat(ssbo_1_1.data[_902]);
                    precise float _1077 = (_1064 ? 0.0 : (-1.0)) - _1069;
                    precise float _1080 = uintBitsToFloat(ssbo_1_1.data[_890]) * exp2(_1067);
                    precise float _1081 = 1.0 + _1077;
                    precise float _1082 = _1069 * _1080;
                    precise float _1083 = _1082 + (_1064 ? 0.0 : _1076);
                    precise float _1085 = uintBitsToFloat(_859) * _1081;
                    precise float _1086 = _1085 + _1083;
                    _1088 = floatBitsToUint(_1086);
                }
                else
                {
                    _1088 = _1043;
                }
                precise float _1091 = 0.412109375 * uintBitsToFloat(_861);
                precise float _1094 = 0.166748046875 * uintBitsToFloat(_861);
                precise float _1097 = uintBitsToFloat(_860) * 0.52392578125;
                precise float _1098 = _1097 + _1091;
                precise float _1101 = uintBitsToFloat(_860) * 0.720458984375;
                precise float _1102 = _1101 + _1094;
                precise float _1105 = uintBitsToFloat(_859) * 0.06396484375;
                precise float _1106 = _1105 + _1098;
                precise float _1109 = uintBitsToFloat(_859) * 0.11279296875;
                precise float _1110 = _1109 + _1102;
                precise float _1112 = 0.00999999977648258209228515625 * _1106;
                precise float _1113 = 0.00999999977648258209228515625 * _1110;
                precise float _1119 = 0.1593017578125 * log2(abs(_1112));
                precise float _1120 = 0.1593017578125 * log2(abs(_1113));
                float _1121 = exp2(_1119);
                float _1122 = exp2(_1120);
                precise float _1127 = 18.6875 * _1121;
                precise float _1128 = _1127 + 1.0;
                precise float _1130 = 18.6875 * _1122;
                precise float _1131 = _1130 + 1.0;
                precise float _1136 = log2(fma(18.8515625, _1121, 0.8359375)) - log2(_1128);
                precise float _1137 = log2(fma(18.8515625, _1122, 0.8359375)) - log2(_1131);
                precise float _1139 = 78.84375 * _1136;
                precise float _1140 = 78.84375 * _1137;
                float _1141 = exp2(_1139);
                float _1142 = exp2(_1140);
                precise float _1143 = _1141 + _1142;
                precise float _1144 = _1143 * 0.5;
                precise float _1147 = 0.0126833133399486541748046875 * log2(_1144);
                float _1148 = exp2(_1147);
                precise float _1153 = (-0.8359375) + _1148;
                precise float _1154 = (1.0 / fma(-18.6875, _1148, 18.8515625)) * _1153;
                precise float _1158 = 6.277394771575927734375 * log2(abs(_1154));
                precise float _1161 = 100.0 * exp2(_1158);
                uint _1203;
                if (!(_1161 > _915))
                {
                    precise float _1166 = (1.0 / uintBitsToFloat(ssbo_1_1.data[_890])) * _1161;
                    precise float _1168 = uintBitsToFloat(ssbo_1_1.data[_910]) * _1161;
                    float _1170 = clamp(max(0.0, _1166), 0.0, 1.0);
                    precise float _1173 = uintBitsToFloat(ssbo_1_1.data[_890]) + uintBitsToFloat(ssbo_1_1.data[_894]);
                    precise float _1174 = (-1.44269502162933349609375) * _1168;
                    precise float _1179 = (-_1170) * _1170;
                    bool _1180 = _1161 < _1173;
                    precise float _1183 = uintBitsToFloat(ssbo_1_1.data[_898]) * log2(abs(_1166));
                    precise float _1184 = _1179 * fma(-2.0, _1170, 3.0);
                    precise float _1185 = _1184 + 1.0;
                    precise float _1191 = (-uintBitsToFloat(ssbo_1_1.data[_906])) * exp2(_1174);
                    precise float _1192 = _1191 + uintBitsToFloat(ssbo_1_1.data[_902]);
                    precise float _1193 = (_1180 ? 0.0 : (-1.0)) - _1185;
                    precise float _1196 = uintBitsToFloat(ssbo_1_1.data[_890]) * exp2(_1183);
                    precise float _1197 = 1.0 + _1193;
                    precise float _1198 = _1185 * _1196;
                    precise float _1199 = _1198 + (_1180 ? 0.0 : _1192);
                    precise float _1200 = _1197 * _1161;
                    precise float _1201 = _1200 + _1199;
                    _1203 = floatBitsToUint(_1201);
                }
                else
                {
                    _1203 = ssbo_1_1.data[_866];
                }
                precise float _1205 = 0.00999999977648258209228515625 * uintBitsToFloat(ssbo_1_1.data[_866]);
                precise float _1210 = 0.024169921875 * uintBitsToFloat(_861);
                precise float _1211 = 0.1593017578125 * log2(abs(_1205));
                precise float _1214 = uintBitsToFloat(_860) * 0.075439453125;
                precise float _1215 = _1214 + _1210;
                float _1216 = exp2(_1211);
                precise float _1219 = uintBitsToFloat(_859) * 0.900390625;
                precise float _1220 = _1219 + _1215;
                precise float _1222 = 18.6875 * _1216;
                precise float _1223 = _1222 + 1.0;
                precise float _1224 = 0.00999999977648258209228515625 * _1220;
                precise float _1229 = log2(fma(18.8515625, _1216, 0.8359375)) - log2(_1223);
                precise float _1230 = 0.1593017578125 * log2(abs(_1224));
                precise float _1232 = 0.00999999977648258209228515625 * uintBitsToFloat(_1203);
                precise float _1233 = 78.84375 * _1229;
                float _1234 = exp2(_1230);
                precise float _1239 = 18.6875 * _1234;
                precise float _1240 = _1239 + 1.0;
                precise float _1241 = 0.1593017578125 * log2(abs(_1232));
                precise float _1245 = uintBitsToFloat(ssbo_1_1.data[49u + buf0_dword_off]) - uintBitsToFloat(ssbo_1_1.data[_882]);
                float _1248 = exp2(_1241);
                precise float _1251 = _1144 * (1.0 / exp2(_1233));
                precise float _1252 = _1251 + (-uintBitsToFloat(ssbo_1_1.data[_882]));
                precise float _1254 = log2(fma(18.8515625, _1234, 0.8359375)) - log2(_1240);
                precise float _1256 = 18.6875 * _1248;
                precise float _1257 = _1256 + 1.0;
                precise float _1258 = (1.0 / _1245) * _1252;
                float _1259 = clamp(_1258, 0.0, 1.0);
                precise float _1260 = 78.84375 * _1254;
                precise float _1262 = 1.61376953125 * _1141;
                precise float _1267 = (-_1259) * _1259;
                float _1268 = exp2(_1260);
                precise float _1270 = _1142 * (-3.323486328125);
                precise float _1271 = _1270 + _1262;
                precise float _1272 = log2(fma(18.8515625, _1248, 0.8359375)) - log2(_1257);
                precise float _1274 = 4.378173828125 * _1141;
                precise float _1275 = _1267 * fma(-2.0, _1259, 3.0);
                precise float _1276 = _1275 + 1.0;
                precise float _1278 = _1268 * 1.709716796875;
                precise float _1279 = _1278 + _1271;
                precise float _1280 = 78.84375 * _1272;
                precise float _1282 = _1142 * (-4.24560546875);
                precise float _1283 = _1282 + _1274;
                precise float _1284 = _1279 * _1276;
                float _1285 = exp2(_1280);
                precise float _1287 = _1268 * (-0.132568359375);
                precise float _1288 = _1287 + _1283;
                precise float _1290 = _1284 * 0.0089999996125698089599609375;
                precise float _1291 = _1290 + _1285;
                precise float _1292 = _1288 * _1276;
                precise float _1294 = _1292 * 0.111000001430511474609375;
                precise float _1295 = _1294 + _1291;
                precise float _1297 = _1284 * (-0.0089999996125698089599609375);
                precise float _1298 = _1297 + _1285;
                precise float _1302 = _1292 * (-0.111000001430511474609375);
                precise float _1303 = _1302 + _1298;
                precise float _1305 = _1284 * 0.560000002384185791015625;
                precise float _1306 = _1305 + _1285;
                precise float _1307 = 0.0126833133399486541748046875 * log2(abs(_1295));
                precise float _1311 = _1292 * (-0.3210000097751617431640625);
                precise float _1312 = _1311 + _1306;
                float _1313 = exp2(_1307);
                precise float _1314 = 0.0126833133399486541748046875 * log2(abs(_1303));
                float _1318 = exp2(_1314);
                precise float _1319 = 0.0126833133399486541748046875 * log2(abs(_1312));
                precise float _1321 = (-0.8359375) + _1313;
                float _1323 = exp2(_1319);
                precise float _1324 = (1.0 / fma(-18.6875, _1313, 18.8515625)) * _1321;
                precise float _1326 = (-0.8359375) + _1318;
                precise float _1330 = (1.0 / fma(-18.6875, _1318, 18.8515625)) * _1326;
                precise float _1332 = (-0.8359375) + _1323;
                precise float _1333 = 6.277394771575927734375 * log2(abs(_1324));
                precise float _1336 = (1.0 / fma(-18.6875, _1323, 18.8515625)) * _1332;
                float _1337 = exp2(_1333);
                precise float _1338 = 6.277394771575927734375 * log2(abs(_1330));
                precise float _1344 = 343.6610107421875 * _1337;
                precise float _1345 = _1344 + (-uintBitsToFloat(_974));
                float _1346 = exp2(_1338);
                precise float _1347 = 6.277394771575927734375 * log2(abs(_1336));
                precise float _1351 = (-79.13299560546875) * _1337;
                precise float _1352 = _1351 + (-uintBitsToFloat(_1032));
                precise float _1356 = (-2.5949900150299072265625) * _1337;
                precise float _1357 = _1356 + (-uintBitsToFloat(_1088));
                precise float _1359 = _1346 * (-250.644989013671875);
                precise float _1360 = _1359 + _1345;
                float _1361 = exp2(_1347);
                precise float _1363 = _1346 * 198.3600006103515625;
                precise float _1364 = _1363 + _1352;
                precise float _1366 = _1346 * (-9.89136981964111328125);
                precise float _1367 = _1366 + _1357;
                precise float _1369 = _1361 * 6.98453998565673828125;
                precise float _1370 = _1369 + _1360;
                precise float _1372 = _1361 * (-19.227100372314453125);
                precise float _1373 = _1372 + _1364;
                precise float _1375 = _1361 * 112.4860076904296875;
                precise float _1376 = _1375 + _1367;
                precise float _1379 = uintBitsToFloat(ssbo_1_1.data[_874]) * _1370;
                precise float _1380 = _1379 + uintBitsToFloat(_974);
                precise float _1383 = uintBitsToFloat(ssbo_1_1.data[_874]) * _1373;
                precise float _1384 = _1383 + uintBitsToFloat(_1032);
                precise float _1387 = uintBitsToFloat(ssbo_1_1.data[_874]) * _1376;
                precise float _1388 = _1387 + uintBitsToFloat(_1088);
                precise float _1399 = uintBitsToFloat(ssbo_1_1.data[_878]) * max(0.0, min(uintBitsToFloat(ssbo_1_1.data[_866]), _1380));
                precise float _1402 = uintBitsToFloat(ssbo_1_1.data[_878]) * max(0.0, min(uintBitsToFloat(ssbo_1_1.data[_866]), _1384));
                precise float _1405 = uintBitsToFloat(ssbo_1_1.data[_878]) * max(0.0, min(uintBitsToFloat(ssbo_1_1.data[_866]), _1388));
                _1407 = ssbo_1_1.data[_906];
                _1408 = ssbo_1_1.data[_902];
                _1409 = floatBitsToUint(_1405);
                _1410 = floatBitsToUint(_1402);
                _1411 = floatBitsToUint(_1399);
            }
            else
            {
                _1407 = _813;
                _1408 = _814;
                _1409 = _859;
                _1410 = _860;
                _1411 = _861;
            }
            uint _1942;
            uint _1943;
            uint _1944;
            if (!_756)
            {
                uint _1893;
                uint _1894;
                uint _1895;
                if (_750)
                {
                    uint _1415 = 44u + buf0_dword_off;
                    uint _1418 = 45u + buf0_dword_off;
                    uint _1424 = 47u + buf0_dword_off;
                    uint _1427 = 48u + buf0_dword_off;
                    uint _1430 = 49u + buf0_dword_off;
                    uint _1433 = 50u + buf0_dword_off;
                    precise float _1440 = (-1.0) + uintBitsToFloat(ssbo_1_1.data[46u + buf0_dword_off]);
                    float _1441 = 1.0 / _1440;
                    precise float _1443 = (-1.0) + uintBitsToFloat(ssbo_1_1.data[_1427]);
                    precise float _1445 = _1441 * _1443;
                    precise float _1446 = _1445 + uintBitsToFloat(ssbo_1_1.data[_1427]);
                    precise float _1448 = (-1.0) + _1446;
                    precise float _1449 = (1.0 / _1443) * _1440;
                    precise float _1450 = _1449 * _1448;
                    precise float _1451 = _1441 * _1443;
                    precise float _1455 = uintBitsToFloat(ssbo_1_1.data[_1415]) * _1451;
                    precise float _1456 = log2(_1450) * _1455;
                    precise float _1460 = uintBitsToFloat(ssbo_1_1.data[_1415]) * uintBitsToFloat(ssbo_1_1.data[_1427]);
                    precise float _1462 = _1456 * (-0.693147182464599609375);
                    precise float _1463 = _1462 + _1460;
                    bool _1466 = (uintBitsToFloat(_1411) >= _1463) || (0.0 > uintBitsToFloat(_1411));
                    uint _1472;
                    if (_1466)
                    {
                        _1472 = floatBitsToUint((0.0 > uintBitsToFloat(_1411)) ? 0.0 : uintBitsToFloat(ssbo_1_1.data[_1415]));
                    }
                    else
                    {
                        _1472 = ssbo_1_1.data[_1427];
                    }
                    uint _1521;
                    uint _1522;
                    if (!_1466)
                    {
                        precise float _1476 = 1.44269502162933349609375 * _1460;
                        precise float _1478 = uintBitsToFloat(_1411) * (-1.44269502162933349609375);
                        precise float _1479 = _1478 + _1476;
                        float _1480 = 1.0 / _1455;
                        precise float _1482 = _1480 * _1479;
                        precise float _1485 = (-exp2(_1482)) * _1451;
                        precise float _1486 = _1485 + _1451;
                        precise float _1488 = uintBitsToFloat(ssbo_1_1.data[_1427]) + _1486;
                        precise float _1490 = uintBitsToFloat(ssbo_1_1.data[_1415]) * _1488;
                        uint _1519;
                        uint _1520;
                        if ((!_1466) && (uintBitsToFloat(_1411) < _1460))
                        {
                            precise float _1498 = uintBitsToFloat(_1411) * (1.0 / uintBitsToFloat(ssbo_1_1.data[_1424]));
                            float _1502 = clamp(max(0.0, _1498), 0.0, 1.0);
                            precise float _1504 = uintBitsToFloat(ssbo_1_1.data[_1430]) * log2(abs(_1498));
                            precise float _1506 = _1502 * _1502;
                            precise float _1508 = _1506 * fma(-2.0, _1502, 3.0);
                            precise float _1510 = uintBitsToFloat(ssbo_1_1.data[_1424]) * exp2(_1504);
                            precise float _1512 = _1510 * (-_1508);
                            precise float _1513 = _1512 + _1510;
                            precise float _1516 = uintBitsToFloat(_1411) * _1508;
                            precise float _1517 = _1516 + _1513;
                            _1519 = floatBitsToUint(_1513);
                            _1520 = floatBitsToUint(_1517);
                        }
                        else
                        {
                            _1519 = floatBitsToUint(_1480);
                            _1520 = floatBitsToUint(_1490);
                        }
                        _1521 = _1519;
                        _1522 = _1520;
                    }
                    else
                    {
                        _1521 = floatBitsToUint(_1456);
                        _1522 = _1472;
                    }
                    bool _1527 = (uintBitsToFloat(_1410) >= _1463) || (0.0 > uintBitsToFloat(_1410));
                    uint _1533;
                    if (_1527)
                    {
                        _1533 = floatBitsToUint((0.0 > uintBitsToFloat(_1410)) ? 0.0 : uintBitsToFloat(ssbo_1_1.data[_1415]));
                    }
                    else
                    {
                        _1533 = _1521;
                    }
                    uint _1578;
                    if (!_1527)
                    {
                        precise float _1536 = 1.44269502162933349609375 * _1460;
                        precise float _1538 = uintBitsToFloat(_1410) * (-1.44269502162933349609375);
                        precise float _1539 = _1538 + _1536;
                        precise float _1541 = (1.0 / _1455) * _1539;
                        precise float _1544 = (-exp2(_1541)) * _1451;
                        precise float _1545 = _1544 + _1451;
                        precise float _1547 = uintBitsToFloat(ssbo_1_1.data[_1427]) + _1545;
                        precise float _1549 = uintBitsToFloat(ssbo_1_1.data[_1415]) * _1547;
                        uint _1577;
                        if ((!_1527) && (uintBitsToFloat(_1410) < _1460))
                        {
                            precise float _1557 = uintBitsToFloat(_1410) * (1.0 / uintBitsToFloat(ssbo_1_1.data[_1424]));
                            float _1561 = clamp(max(0.0, _1557), 0.0, 1.0);
                            precise float _1563 = uintBitsToFloat(ssbo_1_1.data[_1430]) * log2(abs(_1557));
                            precise float _1565 = _1561 * _1561;
                            precise float _1567 = _1565 * fma(-2.0, _1561, 3.0);
                            precise float _1569 = uintBitsToFloat(ssbo_1_1.data[_1424]) * exp2(_1563);
                            precise float _1571 = _1569 * (-_1567);
                            precise float _1572 = _1571 + _1569;
                            precise float _1574 = uintBitsToFloat(_1410) * _1567;
                            precise float _1575 = _1574 + _1572;
                            _1577 = floatBitsToUint(_1575);
                        }
                        else
                        {
                            _1577 = floatBitsToUint(_1549);
                        }
                        _1578 = _1577;
                    }
                    else
                    {
                        _1578 = _1533;
                    }
                    bool _1583 = (uintBitsToFloat(_1409) >= _1463) || (0.0 > uintBitsToFloat(_1409));
                    uint _1589;
                    if (_1583)
                    {
                        _1589 = floatBitsToUint((0.0 > uintBitsToFloat(_1409)) ? 0.0 : uintBitsToFloat(ssbo_1_1.data[_1415]));
                    }
                    else
                    {
                        _1589 = floatBitsToUint(_1451);
                    }
                    uint _1636;
                    if (!_1583)
                    {
                        precise float _1592 = 1.44269502162933349609375 * _1460;
                        precise float _1594 = uintBitsToFloat(_1409) * (-1.44269502162933349609375);
                        precise float _1595 = _1594 + _1592;
                        precise float _1597 = (1.0 / _1455) * _1595;
                        precise float _1602 = uintBitsToFloat(_1589) * (-exp2(_1597));
                        precise float _1603 = _1602 + uintBitsToFloat(_1589);
                        precise float _1605 = uintBitsToFloat(ssbo_1_1.data[_1427]) + _1603;
                        precise float _1607 = uintBitsToFloat(ssbo_1_1.data[_1415]) * _1605;
                        uint _1635;
                        if ((!_1583) && (uintBitsToFloat(_1409) < _1460))
                        {
                            precise float _1615 = uintBitsToFloat(_1409) * (1.0 / uintBitsToFloat(ssbo_1_1.data[_1424]));
                            float _1619 = clamp(max(0.0, _1615), 0.0, 1.0);
                            precise float _1621 = uintBitsToFloat(ssbo_1_1.data[_1430]) * log2(abs(_1615));
                            precise float _1623 = _1619 * _1619;
                            precise float _1625 = _1623 * fma(-2.0, _1619, 3.0);
                            precise float _1627 = uintBitsToFloat(ssbo_1_1.data[_1424]) * exp2(_1621);
                            precise float _1629 = _1627 * (-_1625);
                            precise float _1630 = _1629 + _1627;
                            precise float _1632 = uintBitsToFloat(_1409) * _1625;
                            precise float _1633 = _1632 + _1630;
                            _1635 = floatBitsToUint(_1633);
                        }
                        else
                        {
                            _1635 = floatBitsToUint(_1607);
                        }
                        _1636 = _1635;
                    }
                    else
                    {
                        _1636 = _1589;
                    }
                    precise float _1638 = 0.412109375 * uintBitsToFloat(_1411);
                    precise float _1640 = 0.166748046875 * uintBitsToFloat(_1411);
                    precise float _1642 = uintBitsToFloat(_1410) * 0.52392578125;
                    precise float _1643 = _1642 + _1638;
                    precise float _1645 = uintBitsToFloat(_1410) * 0.720458984375;
                    precise float _1646 = _1645 + _1640;
                    precise float _1648 = uintBitsToFloat(_1409) * 0.06396484375;
                    precise float _1649 = _1648 + _1643;
                    precise float _1651 = uintBitsToFloat(_1409) * 0.11279296875;
                    precise float _1652 = _1651 + _1646;
                    precise float _1653 = 0.00999999977648258209228515625 * _1649;
                    precise float _1654 = 0.00999999977648258209228515625 * _1652;
                    precise float _1656 = 0.00999999977648258209228515625 * uintBitsToFloat(ssbo_1_1.data[_1415]);
                    precise float _1664 = 0.024169921875 * uintBitsToFloat(_1411);
                    precise float _1665 = 0.1593017578125 * log2(abs(_1653));
                    precise float _1666 = 0.1593017578125 * log2(abs(_1654));
                    precise float _1667 = 0.1593017578125 * log2(abs(_1656));
                    precise float _1669 = uintBitsToFloat(_1410) * 0.075439453125;
                    precise float _1670 = _1669 + _1664;
                    precise float _1672 = 0.412109375 * uintBitsToFloat(_1522);
                    precise float _1674 = 0.166748046875 * uintBitsToFloat(_1522);
                    float _1675 = exp2(_1665);
                    float _1676 = exp2(_1666);
                    float _1677 = exp2(_1667);
                    precise float _1679 = uintBitsToFloat(_1409) * 0.900390625;
                    precise float _1680 = _1679 + _1670;
                    precise float _1682 = uintBitsToFloat(_1578) * 0.52392578125;
                    precise float _1683 = _1682 + _1672;
                    precise float _1685 = uintBitsToFloat(_1578) * 0.720458984375;
                    precise float _1686 = _1685 + _1674;
                    precise float _1688 = 18.6875 * _1675;
                    precise float _1689 = _1688 + 1.0;
                    precise float _1691 = 18.6875 * _1676;
                    precise float _1692 = _1691 + 1.0;
                    precise float _1694 = 18.6875 * _1677;
                    precise float _1695 = _1694 + 1.0;
                    precise float _1696 = 0.00999999977648258209228515625 * _1680;
                    precise float _1698 = uintBitsToFloat(_1636) * 0.06396484375;
                    precise float _1699 = _1698 + _1683;
                    precise float _1701 = uintBitsToFloat(_1636) * 0.11279296875;
                    precise float _1702 = _1701 + _1686;
                    precise float _1711 = 0.00999999977648258209228515625 * _1699;
                    precise float _1712 = 0.00999999977648258209228515625 * _1702;
                    precise float _1713 = log2(fma(18.8515625, _1675, 0.8359375)) - log2(_1689);
                    precise float _1714 = log2(fma(18.8515625, _1676, 0.8359375)) - log2(_1692);
                    precise float _1715 = log2(fma(18.8515625, _1677, 0.8359375)) - log2(_1695);
                    precise float _1716 = 0.1593017578125 * log2(abs(_1696));
                    precise float _1721 = 78.84375 * _1713;
                    precise float _1722 = 78.84375 * _1714;
                    precise float _1723 = 78.84375 * _1715;
                    float _1724 = exp2(_1716);
                    precise float _1725 = 0.1593017578125 * log2(abs(_1711));
                    precise float _1726 = 0.1593017578125 * log2(abs(_1712));
                    float _1727 = exp2(_1721);
                    float _1728 = exp2(_1722);
                    precise float _1731 = 18.6875 * _1724;
                    precise float _1732 = _1731 + 1.0;
                    float _1733 = exp2(_1725);
                    float _1734 = exp2(_1726);
                    precise float _1735 = _1727 + _1728;
                    precise float _1736 = _1735 * 0.5;
                    precise float _1740 = uintBitsToFloat(ssbo_1_1.data[51u + buf0_dword_off]) - uintBitsToFloat(ssbo_1_1.data[_1433]);
                    precise float _1744 = 18.6875 * _1733;
                    precise float _1745 = _1744 + 1.0;
                    precise float _1747 = 18.6875 * _1734;
                    precise float _1748 = _1747 + 1.0;
                    precise float _1751 = _1736 * (1.0 / exp2(_1723));
                    precise float _1752 = _1751 + (-uintBitsToFloat(ssbo_1_1.data[_1433]));
                    precise float _1754 = log2(fma(18.8515625, _1724, 0.8359375)) - log2(_1732);
                    precise float _1759 = (1.0 / _1740) * _1752;
                    float _1760 = clamp(_1759, 0.0, 1.0);
                    precise float _1761 = 1.61376953125 * _1727;
                    precise float _1762 = 78.84375 * _1754;
                    precise float _1763 = log2(fma(18.8515625, _1733, 0.8359375)) - log2(_1745);
                    precise float _1764 = log2(fma(18.8515625, _1734, 0.8359375)) - log2(_1748);
                    precise float _1767 = (-_1760) * _1760;
                    precise float _1768 = _1728 * (-3.323486328125);
                    precise float _1769 = _1768 + _1761;
                    float _1770 = exp2(_1762);
                    precise float _1771 = 78.84375 * _1763;
                    precise float _1772 = 78.84375 * _1764;
                    precise float _1773 = 4.378173828125 * _1727;
                    precise float _1774 = _1767 * fma(-2.0, _1760, 3.0);
                    precise float _1775 = _1774 + 1.0;
                    precise float _1776 = _1770 * 1.709716796875;
                    precise float _1777 = _1776 + _1769;
                    precise float _1780 = _1728 * (-4.24560546875);
                    precise float _1781 = _1780 + _1773;
                    precise float _1782 = _1777 * _1775;
                    precise float _1783 = exp2(_1771) + exp2(_1772);
                    precise float _1784 = _1783 * 0.5;
                    precise float _1785 = _1770 * (-0.132568359375);
                    precise float _1786 = _1785 + _1781;
                    precise float _1787 = _1782 * 0.0089999996125698089599609375;
                    precise float _1788 = _1787 + _1784;
                    precise float _1789 = _1786 * _1775;
                    precise float _1790 = _1789 * 0.111000001430511474609375;
                    precise float _1791 = _1790 + _1788;
                    precise float _1792 = _1782 * (-0.0089999996125698089599609375);
                    precise float _1793 = _1792 + _1784;
                    precise float _1796 = _1789 * (-0.111000001430511474609375);
                    precise float _1797 = _1796 + _1793;
                    precise float _1798 = _1782 * 0.560000002384185791015625;
                    precise float _1799 = _1798 + _1784;
                    precise float _1800 = 0.0126833133399486541748046875 * log2(abs(_1791));
                    precise float _1803 = _1789 * (-0.3210000097751617431640625);
                    precise float _1804 = _1803 + _1799;
                    float _1805 = exp2(_1800);
                    precise float _1806 = 0.0126833133399486541748046875 * log2(abs(_1797));
                    float _1810 = exp2(_1806);
                    precise float _1811 = 0.0126833133399486541748046875 * log2(abs(_1804));
                    precise float _1813 = (-0.8359375) + _1805;
                    float _1815 = exp2(_1811);
                    precise float _1816 = (1.0 / fma(-18.6875, _1805, 18.8515625)) * _1813;
                    precise float _1818 = (-0.8359375) + _1810;
                    precise float _1822 = (1.0 / fma(-18.6875, _1810, 18.8515625)) * _1818;
                    precise float _1824 = (-0.8359375) + _1815;
                    precise float _1825 = 6.277394771575927734375 * log2(abs(_1816));
                    precise float _1828 = (1.0 / fma(-18.6875, _1815, 18.8515625)) * _1824;
                    float _1829 = exp2(_1825);
                    precise float _1830 = 6.277394771575927734375 * log2(abs(_1822));
                    precise float _1835 = 343.6610107421875 * _1829;
                    precise float _1836 = _1835 + (-uintBitsToFloat(_1522));
                    float _1837 = exp2(_1830);
                    precise float _1838 = 6.277394771575927734375 * log2(abs(_1828));
                    precise float _1841 = (-79.13299560546875) * _1829;
                    precise float _1842 = _1841 + (-uintBitsToFloat(_1578));
                    precise float _1845 = (-2.5949900150299072265625) * _1829;
                    precise float _1846 = _1845 + (-uintBitsToFloat(_1636));
                    precise float _1847 = _1837 * (-250.644989013671875);
                    precise float _1848 = _1847 + _1836;
                    float _1849 = exp2(_1838);
                    precise float _1850 = _1837 * 198.3600006103515625;
                    precise float _1851 = _1850 + _1842;
                    precise float _1852 = _1837 * (-9.89136981964111328125);
                    precise float _1853 = _1852 + _1846;
                    uint _1854 = 52u + buf0_dword_off;
                    precise float _1857 = _1849 * 6.98453998565673828125;
                    precise float _1858 = _1857 + _1848;
                    precise float _1859 = _1849 * (-19.227100372314453125);
                    precise float _1860 = _1859 + _1851;
                    precise float _1861 = _1849 * 112.4860076904296875;
                    precise float _1862 = _1861 + _1853;
                    precise float _1865 = uintBitsToFloat(ssbo_1_1.data[_1854]) * _1858;
                    precise float _1866 = _1865 + uintBitsToFloat(_1522);
                    precise float _1869 = uintBitsToFloat(ssbo_1_1.data[_1854]) * _1860;
                    precise float _1870 = _1869 + uintBitsToFloat(_1578);
                    precise float _1873 = uintBitsToFloat(ssbo_1_1.data[_1854]) * _1862;
                    precise float _1874 = _1873 + uintBitsToFloat(_1636);
                    precise float _1885 = uintBitsToFloat(ssbo_1_1.data[_1418]) * max(0.0, min(uintBitsToFloat(ssbo_1_1.data[_1415]), _1866));
                    precise float _1888 = uintBitsToFloat(ssbo_1_1.data[_1418]) * max(0.0, min(uintBitsToFloat(ssbo_1_1.data[_1415]), _1870));
                    precise float _1891 = uintBitsToFloat(ssbo_1_1.data[_1418]) * max(0.0, min(uintBitsToFloat(ssbo_1_1.data[_1415]), _1874));
                    _1893 = floatBitsToUint(_1891);
                    _1894 = floatBitsToUint(_1888);
                    _1895 = floatBitsToUint(_1885);
                }
                else
                {
                    _1893 = _1409;
                    _1894 = _1410;
                    _1895 = _1411;
                }
                uint _1939;
                uint _1940;
                uint _1941;
                if (!_750)
                {
                    uint _1936;
                    uint _1937;
                    uint _1938;
                    if (uintBitsToFloat(ssbo_1_1.data[_735]) < 5.0)
                    {
                        float _1897 = 1.0 / uintBitsToFloat(_1408);
                        precise float _1899 = uintBitsToFloat(_1893) * _1897;
                        precise float _1902 = uintBitsToFloat(_1894) * _1897;
                        precise float _1905 = uintBitsToFloat(_1895) * _1897;
                        precise float _1912 = (-2.0) * uintBitsToFloat(_1407);
                        precise float _1913 = _1912 + 1.0;
                        precise float _1917 = inversesqrt(inversesqrt(clamp(_1899, 0.0, 1.0))) * _1913;
                        precise float _1918 = _1917 + uintBitsToFloat(_1407);
                        precise float _1920 = inversesqrt(inversesqrt(clamp(_1902, 0.0, 1.0))) * _1913;
                        precise float _1921 = _1920 + uintBitsToFloat(_1407);
                        precise float _1923 = inversesqrt(inversesqrt(clamp(_1905, 0.0, 1.0))) * _1913;
                        precise float _1924 = _1923 + uintBitsToFloat(_1407);
                        vec4 _1929 = texture(SPIRV_Cross_Combinedfs_img24fs_sampsgpr_56, vec3(_1924, _1921, _1918));
                        _1936 = floatBitsToUint(_1929.z);
                        _1937 = floatBitsToUint(_1929.y);
                        _1938 = floatBitsToUint(_1929.x);
                    }
                    else
                    {
                        _1936 = _1893;
                        _1937 = _1894;
                        _1938 = _1895;
                    }
                    _1939 = _1936;
                    _1940 = _1937;
                    _1941 = _1938;
                }
                else
                {
                    _1939 = _1893;
                    _1940 = _1894;
                    _1941 = _1895;
                }
                _1942 = _1939;
                _1943 = _1940;
                _1944 = _1941;
            }
            else
            {
                _1942 = _1409;
                _1943 = _1410;
                _1944 = _1411;
            }
            _1945 = _1942;
            _1946 = _1943;
            _1947 = _1944;
        }
        else
        {
            _1945 = _859;
            _1946 = _860;
            _1947 = _861;
        }
        _1948 = _1945;
        _1949 = _1946;
        _1950 = _1947;
    }
    else
    {
        _1948 = _810;
        _1949 = _811;
        _1950 = _812;
    }
    uint _2074;
    uint _2075;
    uint _2076;
    if (!(uintBitsToFloat(ssbo_1_1.data[72u + buf0_dword_off]) > 0.5))
    {
        uint _2059;
        uint _2060;
        uint _2061;
        if (_750)
        {
            precise float _1972 = uintBitsToFloat(ssbo_1_1.data[26u + buf0_dword_off]) * uintBitsToFloat(_1948);
            precise float _1975 = uintBitsToFloat(ssbo_1_1.data[25u + buf0_dword_off]) * uintBitsToFloat(_1949);
            precise float _1976 = _1975 + _1972;
            precise float _1979 = uintBitsToFloat(ssbo_1_1.data[24u + buf0_dword_off]) * uintBitsToFloat(_1950);
            precise float _1980 = _1979 + _1976;
            precise float _1984 = 12.9200000762939453125 * _1980;
            uint _1994;
            if (_1980 > 0.003130800090730190277099609375)
            {
                precise float _1988 = 0.4166666567325592041015625 * log2(_1980);
                _1994 = floatBitsToUint(fma(1.05499994754791259765625, exp2(_1988), -0.054999999701976776123046875));
            }
            else
            {
                _1994 = floatBitsToUint(_1984);
            }
            precise float _2009 = uintBitsToFloat(ssbo_1_1.data[30u + buf0_dword_off]) * uintBitsToFloat(_1948);
            precise float _2012 = uintBitsToFloat(ssbo_1_1.data[29u + buf0_dword_off]) * uintBitsToFloat(_1949);
            precise float _2013 = _2012 + _2009;
            precise float _2016 = uintBitsToFloat(ssbo_1_1.data[28u + buf0_dword_off]) * uintBitsToFloat(_1950);
            precise float _2017 = _2016 + _2013;
            precise float _2019 = 12.9200000762939453125 * _2017;
            uint _2026;
            if (_2017 > 0.003130800090730190277099609375)
            {
                precise float _2022 = 0.4166666567325592041015625 * log2(_2017);
                _2026 = floatBitsToUint(fma(1.05499994754791259765625, exp2(_2022), -0.054999999701976776123046875));
            }
            else
            {
                _2026 = floatBitsToUint(_2019);
            }
            precise float _2041 = uintBitsToFloat(ssbo_1_1.data[34u + buf0_dword_off]) * uintBitsToFloat(_1948);
            precise float _2044 = uintBitsToFloat(ssbo_1_1.data[33u + buf0_dword_off]) * uintBitsToFloat(_1949);
            precise float _2045 = _2044 + _2041;
            precise float _2048 = uintBitsToFloat(ssbo_1_1.data[32u + buf0_dword_off]) * uintBitsToFloat(_1950);
            precise float _2049 = _2048 + _2045;
            precise float _2051 = 12.9200000762939453125 * _2049;
            uint _2058;
            if (_2049 > 0.003130800090730190277099609375)
            {
                precise float _2054 = 0.4166666567325592041015625 * log2(_2049);
                _2058 = floatBitsToUint(fma(1.05499994754791259765625, exp2(_2054), -0.054999999701976776123046875));
            }
            else
            {
                _2058 = floatBitsToUint(_2051);
            }
            _2059 = _2058;
            _2060 = _2026;
            _2061 = _1994;
        }
        else
        {
            _2059 = _1948;
            _2060 = _1949;
            _2061 = _1950;
        }
        _2074 = floatBitsToUint(clamp(max(0.0, uintBitsToFloat(_2059)), 0.0, 1.0));
        _2075 = floatBitsToUint(clamp(max(0.0, uintBitsToFloat(_2060)), 0.0, 1.0));
        _2076 = floatBitsToUint(clamp(max(0.0, uintBitsToFloat(_2061)), 0.0, 1.0));
    }
    else
    {
        _2074 = _1948;
        _2075 = _1949;
        _2076 = _1950;
    }
    uint _2078 = 64u + buf0_dword_off;
    uint _2136;
    uint _2137;
    uint _2138;
    if (uintBitsToFloat(ssbo_1_1.data[_2078]) > 0.0)
    {
        precise float _2101 = uintBitsToFloat(ssbo_1_1.data[71u + buf0_dword_off]) * _211;
        precise float _2102 = _2101 + uintBitsToFloat(ssbo_1_1.data[69u + buf0_dword_off]);
        precise float _2105 = uintBitsToFloat(ssbo_1_1.data[70u + buf0_dword_off]) * _205;
        precise float _2106 = _2105 + uintBitsToFloat(ssbo_1_1.data[68u + buf0_dword_off]);
        vec4 _2111 = texture(SPIRV_Cross_Combinedfs_img32fs_sampsgpr_56, vec2(_2106, _2102));
        precise float _2116 = _2111.x - uintBitsToFloat(_2076);
        precise float _2118 = _2111.y - uintBitsToFloat(_2075);
        precise float _2120 = _2111.z - uintBitsToFloat(_2074);
        precise float _2123 = uintBitsToFloat(ssbo_1_1.data[_2078]) * _2116;
        precise float _2124 = _2123 + uintBitsToFloat(_2076);
        precise float _2128 = uintBitsToFloat(ssbo_1_1.data[_2078]) * _2118;
        precise float _2129 = _2128 + uintBitsToFloat(_2075);
        precise float _2133 = uintBitsToFloat(ssbo_1_1.data[_2078]) * _2120;
        precise float _2134 = _2133 + uintBitsToFloat(_2074);
        _2136 = floatBitsToUint(_2134);
        _2137 = floatBitsToUint(_2129);
        _2138 = floatBitsToUint(_2124);
    }
    else
    {
        _2136 = _2074;
        _2137 = _2075;
        _2138 = _2076;
    }
    uint _2150 = 60u + buf0_dword_off;
    uint _2154 = 61u + buf0_dword_off;
    precise float _2159 = uintBitsToFloat(ssbo_1_1.data[56u + buf0_dword_off]) - uintBitsToFloat(_2138);
    precise float _2162 = uintBitsToFloat(ssbo_1_1.data[57u + buf0_dword_off]) - uintBitsToFloat(_2137);
    precise float _2165 = uintBitsToFloat(ssbo_1_1.data[58u + buf0_dword_off]) - uintBitsToFloat(_2136);
    precise float _2168 = uintBitsToFloat(ssbo_1_1.data[_2150]) * _2159;
    precise float _2169 = _2168 + uintBitsToFloat(_2138);
    precise float _2172 = uintBitsToFloat(ssbo_1_1.data[_2150]) * _2162;
    precise float _2173 = _2172 + uintBitsToFloat(_2137);
    precise float _2176 = uintBitsToFloat(ssbo_1_1.data[_2150]) * _2165;
    precise float _2177 = _2176 + uintBitsToFloat(_2136);
    precise float _2179 = uintBitsToFloat(ssbo_1_1.data[_2154]) * _2169;
    precise float _2181 = uintBitsToFloat(ssbo_1_1.data[_2154]) * _2173;
    precise float _2183 = uintBitsToFloat(ssbo_1_1.data[_2154]) * _2177;
    frag_color0.x = _2183;
    frag_color0.y = _2181;
    frag_color0.z = _2179;
    frag_color0.w = 1.0;
}

