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
layout(local_size_x = 256, local_size_y = 1, local_size_z = 1) in;

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

struct frexp_result_f64
{
    double _m0;
    int _m1;
};

uint _160;
uint _161;
uint _162;
uint _163;
uint _164;
uint _165;

layout(binding = 0, std430) readonly buffer ssbo_1
{
    uint data[];
} ssbo_1_1;

layout(binding = 1, std430) readonly buffer ssbo_2
{
    uint data[];
} ssbo_2_1;

layout(binding = 2, std430) readonly buffer ssbo_3
{
    uint data[];
} ssbo_3_1;

layout(binding = 3, std430) readonly buffer ssbo_4
{
    uint data[];
} ssbo_4_1;

layout(binding = 3, std430) readonly buffer ssbo_4_2
{
    float data[];
} ssbo_4_3;

layout(binding = 3, std430) readonly buffer ssbo_4_4
{
    uint16_t data[];
} ssbo_4_5;

layout(binding = 3, std430) readonly buffer ssbo_4_6
{
    uint8_t data[];
} ssbo_4_7;

layout(binding = 4, std430) readonly buffer ssbo_5
{
    uint data[];
} ssbo_5_1;

layout(binding = 5, std430) readonly buffer ssbo_6
{
    uint data[];
} ssbo_6_1;

layout(binding = 6, std430) readonly buffer ssbo_7
{
    uint data[];
} ssbo_7_1;

layout(binding = 7, std430) buffer ssbo_8
{
    uint data[];
} ssbo_8_1;

layout(binding = 8, std430) readonly buffer srt_flatbuf
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

void main()
{
    uint buf1_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(8u), int(8u)) >> 2u;
    uint buf2_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(16u), int(8u)) >> 2u;
    uint buf3_off = bitfieldExtract(push_data.buf_offsets0.x, int(24u), int(8u));
    uint buf3_dword_off = buf3_off >> 2u;
    uint buf4_dword_off = bitfieldExtract(push_data.buf_offsets0.y, int(0u), int(8u)) >> 2u;
    uint buf5_dword_off = bitfieldExtract(push_data.buf_offsets0.y, int(8u), int(8u)) >> 2u;
    uint buf6_dword_off = bitfieldExtract(push_data.buf_offsets0.y, int(16u), int(8u)) >> 2u;
    uint buf7_dword_off = bitfieldExtract(push_data.buf_offsets0.y, int(24u), int(8u)) >> 2u;
    uint _219 = (gl_WorkGroupID.x << 8u) + gl_LocalInvocationID.x;
    bool _220 = srt_flatbuf_1.data[149u] > _219;
    if (_220)
    {
        uint _270 = (_219 * 3u) + (bitfieldExtract(push_data.buf_offsets0.x, int(0u), int(8u)) >> 2u);
        uvec3 _279 = uvec3(ssbo_1_1.data[_270], ssbo_1_1.data[_270 + 1u], ssbo_1_1.data[_270 + 2u]);
        uint _280 = _279.x;
        uint _281 = _279.y;
        uint _282 = _279.z;
        bool _283 = int(srt_flatbuf_1.data[55u]) >= int(0u);
        precise float _286 = uintBitsToFloat(srt_flatbuf_1.data[100u]) + uintBitsToFloat(_280);
        precise float _288 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * _286;
        precise float _291 = uintBitsToFloat(srt_flatbuf_1.data[101u]) + uintBitsToFloat(_282);
        precise float _293 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * _286;
        precise float _296 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * (-_291);
        precise float _297 = _296 + _288;
        precise float _299 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * _291;
        precise float _300 = _299 + _293;
        uvec2 _302 = (double(_297));
        uint _303 = _302.x;
        uvec2 _306 = (double(_300));
        uint _307 = _306.x;
        precise double _313 = (uvec2(_303, _302.y)) + (uvec2(srt_flatbuf_1.data[31u], srt_flatbuf_1.data[32u]));
        uvec2 _314 = (_313);
        uint _315 = _314.x;
        precise double _321 = (uvec2(_307, _306.y)) + (uvec2(srt_flatbuf_1.data[33u], srt_flatbuf_1.data[34u]));
        uvec2 _322 = (_321);
        uint _323 = _322.x;
        float _327 = float((uvec2(_315, _314.y)));
        float _330 = float((uvec2(_323, _322.y)));
        uint _580;
        uint _581;
        uint _582;
        uint _583;
        uint _584;
        uint _585;
        uint _586;
        uint _587;
        if (_283)
        {
            uvec2 _396 = (fma((uvec2(double(uintBitsToFloat(_282)))), (uvec2(srt_flatbuf_1.data[37u], srt_flatbuf_1.data[38u])), (uvec2(fma((uvec2(double(uintBitsToFloat(_280)))), (uvec2(srt_flatbuf_1.data[35u], srt_flatbuf_1.data[36u])), (uvec2(srt_flatbuf_1.data[57u], srt_flatbuf_1.data[58u])))))));
            uint _397 = _396.x;
            uvec2 _403 = (1.0lf / (uvec2(srt_flatbuf_1.data[28u], srt_flatbuf_1.data[29u])));
            uint _404 = _403.x;
            precise double _410 = (uvec2(_404, _403.y)) * (uvec2(_397, _396.y));
            uvec2 _411 = (_410);
            uint _412 = _411.x;
            precise double _424 = 0.0lf + (-(uvec2(_412, _411.y)));
            uvec2 _432 = (min(1.0lf, (uvec2(max(0.0lf, (uvec2(_412, _411.y)))))));
            bool _441 = (1u == srt_flatbuf_1.data[30u]) ? _220 : false;
            uvec2 _453 = (fma((uvec2(_404, _403.y)), (uvec2(_397, _396.y)), (uvec2(trunc((uvec2(_424)))))));
            bool _459 = (2u == srt_flatbuf_1.data[30u]) ? _220 : false;
            float _468 = float((uvec2(floatBitsToUint(_459 ? uintBitsToFloat(_453.x) : (_441 ? uintBitsToFloat(_432.x) : uintBitsToFloat(_412))), floatBitsToUint(_459 ? uintBitsToFloat(_453.y) : (_441 ? uintBitsToFloat(_432.y) : uintBitsToFloat(_411.y))))));
            bool _475;
            uint _480;
            uint _491;
            uint _495;
            uint _496;
            uint _497;
            bool _470 = _220;
            uint _471 = srt_flatbuf_1.data[56u];
            uint _472 = 0u;
            for (;;)
            {
                uint _473 = _472 + 1u;
                _475 = _470 && (int(_471) > int(_473));
                if (!_475)
                {
                    _496 = _472;
                    _497 = _473;
                    break;
                }
                else
                {
                    uint _477 = _471 + _472;
                    _480 = uint(int(_477 + bitfieldExtract(_477, int(31u), int(1u))) >> int(1u));
                    bool _487 = _468 < uintBitsToFloat(ssbo_2_1.data[((srt_flatbuf_1.data[55u] + _480) * 4u) + buf1_dword_off]);
                    _491 = floatBitsToUint(_487 ? uintBitsToFloat(_480) : uintBitsToFloat(_471));
                    _495 = floatBitsToUint(_487 ? uintBitsToFloat(_472) : uintBitsToFloat(_480));
                    if (true)
                    {
                        _470 = _475;
                        _471 = _491;
                        _472 = _495;
                        continue;
                    }
                    else
                    {
                        _496 = _495;
                        _497 = _480;
                        break;
                    }
                }
            }
            uint _504 = ((srt_flatbuf_1.data[55u] + uint(min(int(srt_flatbuf_1.data[56u] + 4294967295u), int(_497)))) * 4u) + buf1_dword_off;
            uvec4 _516 = uvec4(ssbo_2_1.data[_504], ssbo_2_1.data[_504 + 1u], ssbo_2_1.data[_504 + 2u], ssbo_2_1.data[_504 + 3u]);
            uint _517 = _516.x;
            uint _522 = ((srt_flatbuf_1.data[55u] + _496) * 4u) + buf1_dword_off;
            uvec4 _534 = uvec4(ssbo_2_1.data[_522], ssbo_2_1.data[_522 + 1u], ssbo_2_1.data[_522 + 2u], ssbo_2_1.data[_522 + 3u]);
            uint _535 = _534.x;
            uint _536 = _534.y;
            uint _537 = _534.z;
            uint _538 = _534.w;
            uint _553;
            if (_220 && (uintBitsToFloat(_535) < uintBitsToFloat(_517)))
            {
                precise float _545 = uintBitsToFloat(_517) - uintBitsToFloat(_535);
                precise float _549 = _468 - uintBitsToFloat(_535);
                precise float _550 = (1.0 / _545) * _549;
                _553 = floatBitsToUint(clamp(_550, 0.0, 1.0));
            }
            else
            {
                _553 = 0u;
            }
            precise float _556 = uintBitsToFloat(_516.w) - uintBitsToFloat(_538);
            precise float _560 = uintBitsToFloat(_516.z) - uintBitsToFloat(_537);
            precise float _563 = uintBitsToFloat(_516.y) - uintBitsToFloat(_536);
            precise float _567 = uintBitsToFloat(_553) * _556;
            precise float _568 = _567 + uintBitsToFloat(_538);
            precise float _572 = uintBitsToFloat(_553) * _560;
            precise float _573 = _572 + uintBitsToFloat(_537);
            precise float _577 = uintBitsToFloat(_553) * _563;
            precise float _578 = _577 + uintBitsToFloat(_536);
            _580 = _553;
            _581 = floatBitsToUint(_468);
            _582 = floatBitsToUint(_563);
            _583 = floatBitsToUint(_556);
            _584 = floatBitsToUint(_578);
            _585 = floatBitsToUint(_573);
            _586 = floatBitsToUint(_568);
            _587 = _537;
        }
        else
        {
            _580 = _160;
            _581 = _161;
            _582 = _162;
            _583 = _323;
            _584 = _163;
            _585 = _164;
            _586 = _165;
            _587 = _315;
        }
        uint _602;
        uint _603;
        uint _604;
        if (!_283)
        {
            _602 = srt_flatbuf_1.data[59u];
            _603 = srt_flatbuf_1.data[60u];
            _604 = srt_flatbuf_1.data[61u];
        }
        else
        {
            _602 = _584;
            _603 = _585;
            _604 = _586;
        }
        float _607 = float((uvec2(srt_flatbuf_1.data[57u], srt_flatbuf_1.data[58u])));
        bool _623 = 0u != srt_flatbuf_1.data[63u];
        precise float _625 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * _327;
        precise float _627 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * _330;
        precise float _629 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * _607;
        uint _636;
        uint _637;
        if (_623)
        {
            _636 = srt_flatbuf_1.data[62u];
            _637 = srt_flatbuf_1.data[62u];
        }
        else
        {
            _636 = _583;
            _637 = _587;
        }
        uint _1521;
        uint _1522;
        uint _1523;
        uint _1524;
        uint _1525;
        if (!_623)
        {
            uint _716;
            uint _717;
            uint _960;
            uint _962;
            uint _1030;
            uint _1060;
            uint _1064;
            uint _1065;
            uint _1066;
            uint _1067;
            uint _1068;
            uint _638 = _580;
            uint _639 = _581;
            uint _640 = _582;
            uint _641 = 1065353216u;
            uint _642 = 1065353216u;
            uint _643 = 0u;
            uint _644 = 0u;
            for (;;)
            {
                if (!(int(_644) < int(srt_flatbuf_1.data[54u])))
                {
                    _1065 = _638;
                    _1066 = _639;
                    _1067 = _640;
                    _1068 = _643;
                    break;
                }
                else
                {
                    precise float _648 = uintBitsToFloat(_642) * _625;
                    uint _655 = 255u & uint(int(floor(_648)));
                    precise float _665 = uintBitsToFloat(_642) * _629;
                    precise float _667 = _625 * uintBitsToFloat(_642);
                    precise float _668 = _667 + trunc(-floor(_648));
                    precise float _670 = uintBitsToFloat(_642) * _627;
                    uint _673 = uint(int(floor(_670)));
                    uint _677 = uint(int(floor(_665)));
                    precise float _681 = _668 * _668;
                    precise float _683 = _629 * uintBitsToFloat(_642);
                    precise float _684 = _683 + trunc(-floor(_665));
                    precise float _686 = _627 * uintBitsToFloat(_642);
                    precise float _687 = _686 + trunc(-floor(_670));
                    precise float _688 = _681 * _668;
                    float _690 = float(int(6u));
                    precise float _696 = (-1.0) + _668;
                    precise float _697 = (-1.0) + _687;
                    precise float _698 = (-1.0) + _684;
                    precise float _699 = _688 * fma(fma(_690, _668, -15.0), _668, 10.0);
                    precise float _704 = _687 * _687;
                    precise float _705 = _704 * _687;
                    precise float _706 = _705 * fma(fma(_690, _687, -15.0), _687, 10.0);
                    precise float _707 = _684 * _684;
                    precise float _708 = _707 * _684;
                    precise float _712 = _708 * fma(fma(_690, _684, -15.0), _684, 10.0);
                    precise float _715 = 2.0 * uintBitsToFloat(_642);
                    _716 = floatBitsToUint(_715);
                    _717 = _644 + 1u;
                    uint _719 = 255u & (ssbo_3_1.data[_655 + buf2_dword_off] + _673);
                    uint _721 = 255u & (ssbo_3_1.data[(_655 + 1u) + buf2_dword_off] + _673);
                    uint _731 = 255u & (ssbo_3_1.data[_719 + buf2_dword_off] + _677);
                    uint _749 = 255u & (ssbo_3_1.data[(_719 + 1u) + buf2_dword_off] + _677);
                    uint _754 = bitfieldExtract(15u & ssbo_3_1.data[_731 + buf2_dword_off], int(0u), int(24u)) * 12u;
                    uint _758 = 255u & (ssbo_3_1.data[_721 + buf2_dword_off] + _677);
                    uint _765 = 255u & (ssbo_3_1.data[(_721 + 1u) + buf2_dword_off] + _677);
                    uint _786 = bitfieldExtract(15u & ssbo_3_1.data[_758 + buf2_dword_off], int(0u), int(24u)) * 12u;
                    uint _792 = bitfieldExtract(15u & ssbo_3_1.data[_765 + buf2_dword_off], int(0u), int(24u)) * 12u;
                    uint _797 = bitfieldExtract(15u & ssbo_3_1.data[(_758 + 1u) + buf2_dword_off], int(0u), int(24u)) * 12u;
                    uint _803 = ((_754 + 4608u) >> 2u) + buf3_dword_off;
                    vec4 _816 = vec4(vec3(ssbo_4_3.data[_803], ssbo_4_3.data[_803 + 1u], ssbo_4_3.data[_803 + 2u]), 0.0);
                    vec4 _818 = vec4(_816.x, _816.y, _816.z, _816.w);
                    uint _825 = ((_786 + 4800u) >> 2u) + buf3_dword_off;
                    vec4 _838 = vec4(vec3(ssbo_4_3.data[_825], ssbo_4_3.data[_825 + 1u], ssbo_4_3.data[_825 + 2u]), 0.0);
                    vec4 _839 = vec4(_838.x, _838.y, _838.z, _838.w);
                    uint _846 = ((_797 + 5568u) >> 2u) + buf3_dword_off;
                    vec4 _859 = vec4(vec3(ssbo_4_3.data[_846], ssbo_4_3.data[_846 + 1u], ssbo_4_3.data[_846 + 2u]), 0.0);
                    vec4 _860 = vec4(_859.x, _859.y, _859.z, _859.w);
                    uint _866 = bitfieldExtract(15u & ssbo_3_1.data[(_731 + 1u) + buf2_dword_off], int(0u), int(24u)) * 12u;
                    uint _872 = ((_866 + 5376u) >> 2u) + buf3_dword_off;
                    vec4 _885 = vec4(vec3(ssbo_4_3.data[_872], ssbo_4_3.data[_872 + 1u], ssbo_4_3.data[_872 + 2u]), 0.0);
                    vec4 _886 = vec4(_885.x, _885.y, _885.z, _885.w);
                    uint _891 = bitfieldExtract(15u & ssbo_3_1.data[_749 + buf2_dword_off], int(0u), int(24u)) * 12u;
                    uint _898 = ((_891 + 4992u) >> 2u) + buf3_dword_off;
                    vec4 _911 = vec4(vec3(ssbo_4_3.data[_898], ssbo_4_3.data[_898 + 1u], ssbo_4_3.data[_898 + 2u]), 0.0);
                    vec4 _912 = vec4(_911.x, _911.y, _911.z, _911.w);
                    uint _919 = ((_792 + 5184u) >> 2u) + buf3_dword_off;
                    vec4 _932 = vec4(vec3(ssbo_4_3.data[_919], ssbo_4_3.data[_919 + 1u], ssbo_4_3.data[_919 + 2u]), 0.0);
                    vec4 _933 = vec4(_932.x, _932.y, _932.z, _932.w);
                    uint _938 = bitfieldExtract(15u & ssbo_3_1.data[(_749 + 1u) + buf2_dword_off], int(0u), int(24u)) * 12u;
                    uint _944 = ((_938 + 5760u) >> 2u) + buf3_dword_off;
                    vec4 _957 = vec4(vec3(ssbo_4_3.data[_944], ssbo_4_3.data[_944 + 1u], ssbo_4_3.data[_944 + 2u]), 0.0);
                    vec4 _958 = vec4(_957.x, _957.y, _957.z, _957.w);
                    float _959 = _958.x;
                    _960 = floatBitsToUint(_959);
                    float _961 = _958.y;
                    _962 = floatBitsToUint(_961);
                    uint _966 = bitfieldExtract(15u & ssbo_3_1.data[(_765 + 1u) + buf2_dword_off], int(0u), int(24u)) * 12u;
                    uint _972 = ((_966 + 5952u) >> 2u) + buf3_dword_off;
                    vec4 _985 = vec4(vec3(ssbo_4_3.data[_972], ssbo_4_3.data[_972 + 1u], ssbo_4_3.data[_972 + 2u]), 0.0);
                    vec4 _986 = vec4(_985.x, _985.y, _985.z, _985.w);
                    precise float _990 = _818.x * _668;
                    precise float _991 = _818.y * _687;
                    precise float _992 = _991 + _990;
                    precise float _993 = _684 * _818.z;
                    precise float _994 = _993 + _992;
                    precise float _996 = _839.x * _696;
                    precise float _997 = _996 + (-_994);
                    precise float _998 = _687 * _839.y;
                    precise float _999 = _998 + _997;
                    precise float _1000 = _684 * _839.z;
                    precise float _1001 = _1000 + _999;
                    precise float _1002 = _886.x * _668;
                    precise float _1003 = _687 * _886.y;
                    precise float _1004 = _1003 + _1002;
                    precise float _1005 = _698 * _886.z;
                    precise float _1006 = _1005 + _1004;
                    precise float _1007 = _1001 * _699;
                    precise float _1008 = _1007 + _994;
                    precise float _1009 = _912.x * _668;
                    precise float _1010 = _912.y * _697;
                    precise float _1011 = _1010 + _1009;
                    precise float _1012 = _684 * _912.z;
                    precise float _1013 = _1012 + _1011;
                    precise float _1015 = _933.x * _696;
                    precise float _1016 = _1015 + (-_1013);
                    precise float _1017 = _697 * _933.y;
                    precise float _1018 = _1017 + _1016;
                    precise float _1019 = _1013 - _1008;
                    precise float _1021 = _860.x * _696;
                    precise float _1022 = _1021 + (-_1006);
                    precise float _1023 = _687 * _860.y;
                    precise float _1024 = _1023 + _1022;
                    precise float _1025 = _684 * _933.z;
                    precise float _1026 = _1025 + _1018;
                    precise float _1027 = _959 * _668;
                    precise float _1028 = _697 * _961;
                    precise float _1029 = _1028 + _1027;
                    _1030 = floatBitsToUint(_1029);
                    precise float _1031 = _958.z * _698;
                    precise float _1032 = _1031 + _1029;
                    precise float _1033 = _698 * _860.z;
                    precise float _1034 = _1033 + _1024;
                    precise float _1035 = _1026 * _699;
                    precise float _1036 = _1035 + _1019;
                    precise float _1037 = _1034 * _699;
                    precise float _1038 = _1037 + _1006;
                    precise float _1039 = _1032 - _1038;
                    precise float _1041 = _986.x * _696;
                    precise float _1042 = _1041 + (-_1032);
                    precise float _1043 = _697 * _986.y;
                    precise float _1044 = _1043 + _1042;
                    precise float _1045 = _1036 * _706;
                    precise float _1046 = _1045 + _1008;
                    precise float _1047 = _698 * _986.z;
                    precise float _1048 = _1047 + _1044;
                    precise float _1049 = _1038 - _1046;
                    precise float _1050 = _1048 * _699;
                    precise float _1051 = _1050 + _1039;
                    precise float _1052 = _1051 * _706;
                    precise float _1053 = _1052 + _1049;
                    precise float _1054 = _1053 * _712;
                    precise float _1055 = _1054 + _1046;
                    precise float _1058 = _1055 * uintBitsToFloat(_641);
                    precise float _1059 = _1058 + uintBitsToFloat(_643);
                    _1060 = floatBitsToUint(_1059);
                    precise float _1063 = uintBitsToFloat(srt_flatbuf_1.data[52u]) * uintBitsToFloat(_641);
                    _1064 = floatBitsToUint(_1063);
                    if (true)
                    {
                        _638 = _962;
                        _639 = _960;
                        _640 = _1030;
                        _641 = _1064;
                        _642 = _716;
                        _643 = _1060;
                        _644 = _717;
                        continue;
                    }
                    else
                    {
                        _1065 = _962;
                        _1066 = _960;
                        _1067 = _1030;
                        _1068 = _1060;
                        break;
                    }
                }
            }
            precise float _1079 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * _327;
            precise float _1081 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * _330;
            precise float _1083 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * _607;
            uint _1154;
            uint _1157;
            uint _1392;
            uint _1394;
            uint _1462;
            uint _1492;
            uint _1496;
            uint _1497;
            uint _1498;
            uint _1499;
            uint _1500;
            uint _1084 = _1065;
            uint _1085 = _1066;
            uint _1086 = _1067;
            uint _1087 = 1065353216u;
            uint _1088 = 0u;
            uint _1089 = 1065353216u;
            uint _1090 = srt_flatbuf_1.data[54u];
            for (;;)
            {
                if (!(int(_1090) < int(srt_flatbuf_1.data[53u])))
                {
                    _1497 = _1084;
                    _1498 = _1085;
                    _1499 = _1086;
                    _1500 = _1088;
                    break;
                }
                else
                {
                    precise float _1094 = uintBitsToFloat(_1089) * _1079;
                    uint _1100 = 255u & uint(int(floor(_1094)));
                    precise float _1110 = uintBitsToFloat(_1089) * _1083;
                    precise float _1112 = _1079 * uintBitsToFloat(_1089);
                    precise float _1113 = _1112 + trunc(-floor(_1094));
                    precise float _1115 = uintBitsToFloat(_1089) * _1081;
                    uint _1118 = uint(int(floor(_1115)));
                    uint _1122 = uint(int(floor(_1110)));
                    precise float _1126 = _1113 * _1113;
                    precise float _1128 = _1083 * uintBitsToFloat(_1089);
                    precise float _1129 = _1128 + trunc(-floor(_1110));
                    precise float _1131 = _1081 * uintBitsToFloat(_1089);
                    precise float _1132 = _1131 + trunc(-floor(_1115));
                    precise float _1133 = _1126 * _1113;
                    float _1134 = float(int(6u));
                    precise float _1137 = (-1.0) + _1113;
                    precise float _1138 = (-1.0) + _1132;
                    precise float _1139 = (-1.0) + _1129;
                    precise float _1140 = _1133 * fma(fma(_1134, _1113, -15.0), _1113, 10.0);
                    precise float _1145 = _1132 * _1132;
                    precise float _1146 = _1145 * _1132;
                    precise float _1147 = _1146 * fma(fma(_1134, _1132, -15.0), _1132, 10.0);
                    precise float _1148 = _1129 * _1129;
                    precise float _1149 = _1148 * _1129;
                    precise float _1153 = _1149 * fma(fma(_1134, _1129, -15.0), _1129, 10.0);
                    _1154 = _1090 + 1u;
                    precise float _1156 = 2.0 * uintBitsToFloat(_1089);
                    _1157 = floatBitsToUint(_1156);
                    uint _1159 = 255u & (ssbo_3_1.data[_1100 + buf2_dword_off] + _1118);
                    uint _1161 = 255u & (ssbo_3_1.data[(_1100 + 1u) + buf2_dword_off] + _1118);
                    uint _1171 = 255u & (ssbo_3_1.data[_1159 + buf2_dword_off] + _1122);
                    uint _1189 = 255u & (ssbo_3_1.data[(_1159 + 1u) + buf2_dword_off] + _1122);
                    uint _1193 = bitfieldExtract(15u & ssbo_3_1.data[_1171 + buf2_dword_off], int(0u), int(24u)) * 12u;
                    uint _1195 = 255u & (ssbo_3_1.data[_1161 + buf2_dword_off] + _1122);
                    uint _1202 = 255u & (ssbo_3_1.data[(_1161 + 1u) + buf2_dword_off] + _1122);
                    uint _1223 = bitfieldExtract(15u & ssbo_3_1.data[_1195 + buf2_dword_off], int(0u), int(24u)) * 12u;
                    uint _1227 = bitfieldExtract(15u & ssbo_3_1.data[_1202 + buf2_dword_off], int(0u), int(24u)) * 12u;
                    uint _1230 = bitfieldExtract(15u & ssbo_3_1.data[(_1195 + 1u) + buf2_dword_off], int(0u), int(24u)) * 12u;
                    uint _1235 = ((_1193 + 3072u) >> 2u) + buf3_dword_off;
                    vec4 _1248 = vec4(vec3(ssbo_4_3.data[_1235], ssbo_4_3.data[_1235 + 1u], ssbo_4_3.data[_1235 + 2u]), 0.0);
                    vec4 _1249 = vec4(_1248.x, _1248.y, _1248.z, _1248.w);
                    uint _1257 = ((_1223 + 3264u) >> 2u) + buf3_dword_off;
                    vec4 _1270 = vec4(vec3(ssbo_4_3.data[_1257], ssbo_4_3.data[_1257 + 1u], ssbo_4_3.data[_1257 + 2u]), 0.0);
                    vec4 _1271 = vec4(_1270.x, _1270.y, _1270.z, _1270.w);
                    uint _1279 = ((_1230 + 4032u) >> 2u) + buf3_dword_off;
                    vec4 _1292 = vec4(vec3(ssbo_4_3.data[_1279], ssbo_4_3.data[_1279 + 1u], ssbo_4_3.data[_1279 + 2u]), 0.0);
                    vec4 _1293 = vec4(_1292.x, _1292.y, _1292.z, _1292.w);
                    uint _1299 = bitfieldExtract(15u & ssbo_3_1.data[(_1171 + 1u) + buf2_dword_off], int(0u), int(24u)) * 12u;
                    uint _1304 = ((_1299 + 3840u) >> 2u) + buf3_dword_off;
                    vec4 _1317 = vec4(vec3(ssbo_4_3.data[_1304], ssbo_4_3.data[_1304 + 1u], ssbo_4_3.data[_1304 + 2u]), 0.0);
                    vec4 _1318 = vec4(_1317.x, _1317.y, _1317.z, _1317.w);
                    uint _1323 = bitfieldExtract(15u & ssbo_3_1.data[_1189 + buf2_dword_off], int(0u), int(24u)) * 12u;
                    uint _1329 = ((_1323 + 3456u) >> 2u) + buf3_dword_off;
                    vec4 _1342 = vec4(vec3(ssbo_4_3.data[_1329], ssbo_4_3.data[_1329 + 1u], ssbo_4_3.data[_1329 + 2u]), 0.0);
                    vec4 _1343 = vec4(_1342.x, _1342.y, _1342.z, _1342.w);
                    uint _1351 = ((_1227 + 3648u) >> 2u) + buf3_dword_off;
                    vec4 _1364 = vec4(vec3(ssbo_4_3.data[_1351], ssbo_4_3.data[_1351 + 1u], ssbo_4_3.data[_1351 + 2u]), 0.0);
                    vec4 _1365 = vec4(_1364.x, _1364.y, _1364.z, _1364.w);
                    uint _1370 = bitfieldExtract(15u & ssbo_3_1.data[(_1189 + 1u) + buf2_dword_off], int(0u), int(24u)) * 12u;
                    uint _1376 = ((_1370 + 4224u) >> 2u) + buf3_dword_off;
                    vec4 _1389 = vec4(vec3(ssbo_4_3.data[_1376], ssbo_4_3.data[_1376 + 1u], ssbo_4_3.data[_1376 + 2u]), 0.0);
                    vec4 _1390 = vec4(_1389.x, _1389.y, _1389.z, _1389.w);
                    float _1391 = _1390.x;
                    _1392 = floatBitsToUint(_1391);
                    float _1393 = _1390.y;
                    _1394 = floatBitsToUint(_1393);
                    uint _1398 = bitfieldExtract(15u & ssbo_3_1.data[(_1202 + 1u) + buf2_dword_off], int(0u), int(24u)) * 12u;
                    uint _1404 = ((_1398 + 4416u) >> 2u) + buf3_dword_off;
                    vec4 _1417 = vec4(vec3(ssbo_4_3.data[_1404], ssbo_4_3.data[_1404 + 1u], ssbo_4_3.data[_1404 + 2u]), 0.0);
                    vec4 _1418 = vec4(_1417.x, _1417.y, _1417.z, _1417.w);
                    precise float _1422 = _1249.x * _1113;
                    precise float _1423 = _1249.y * _1132;
                    precise float _1424 = _1423 + _1422;
                    precise float _1425 = _1129 * _1249.z;
                    precise float _1426 = _1425 + _1424;
                    precise float _1428 = _1271.x * _1137;
                    precise float _1429 = _1428 + (-_1426);
                    precise float _1430 = _1132 * _1271.y;
                    precise float _1431 = _1430 + _1429;
                    precise float _1432 = _1129 * _1271.z;
                    precise float _1433 = _1432 + _1431;
                    precise float _1434 = _1318.x * _1113;
                    precise float _1435 = _1132 * _1318.y;
                    precise float _1436 = _1435 + _1434;
                    precise float _1437 = _1139 * _1318.z;
                    precise float _1438 = _1437 + _1436;
                    precise float _1439 = _1433 * _1140;
                    precise float _1440 = _1439 + _1426;
                    precise float _1441 = _1343.x * _1113;
                    precise float _1442 = _1343.y * _1138;
                    precise float _1443 = _1442 + _1441;
                    precise float _1444 = _1129 * _1343.z;
                    precise float _1445 = _1444 + _1443;
                    precise float _1447 = _1365.x * _1137;
                    precise float _1448 = _1447 + (-_1445);
                    precise float _1449 = _1138 * _1365.y;
                    precise float _1450 = _1449 + _1448;
                    precise float _1451 = _1445 - _1440;
                    precise float _1453 = _1293.x * _1137;
                    precise float _1454 = _1453 + (-_1438);
                    precise float _1455 = _1132 * _1293.y;
                    precise float _1456 = _1455 + _1454;
                    precise float _1457 = _1129 * _1365.z;
                    precise float _1458 = _1457 + _1450;
                    precise float _1459 = _1391 * _1113;
                    precise float _1460 = _1138 * _1393;
                    precise float _1461 = _1460 + _1459;
                    _1462 = floatBitsToUint(_1461);
                    precise float _1463 = _1390.z * _1139;
                    precise float _1464 = _1463 + _1461;
                    precise float _1465 = _1139 * _1293.z;
                    precise float _1466 = _1465 + _1456;
                    precise float _1467 = _1458 * _1140;
                    precise float _1468 = _1467 + _1451;
                    precise float _1469 = _1466 * _1140;
                    precise float _1470 = _1469 + _1438;
                    precise float _1471 = _1464 - _1470;
                    precise float _1473 = _1418.x * _1137;
                    precise float _1474 = _1473 + (-_1464);
                    precise float _1475 = _1138 * _1418.y;
                    precise float _1476 = _1475 + _1474;
                    precise float _1477 = _1468 * _1147;
                    precise float _1478 = _1477 + _1440;
                    precise float _1479 = _1139 * _1418.z;
                    precise float _1480 = _1479 + _1476;
                    precise float _1481 = _1470 - _1478;
                    precise float _1482 = _1480 * _1140;
                    precise float _1483 = _1482 + _1471;
                    precise float _1484 = _1483 * _1147;
                    precise float _1485 = _1484 + _1481;
                    precise float _1486 = _1485 * _1153;
                    precise float _1487 = _1486 + _1478;
                    precise float _1490 = _1487 * uintBitsToFloat(_1087);
                    precise float _1491 = _1490 + uintBitsToFloat(_1088);
                    _1492 = floatBitsToUint(_1491);
                    precise float _1495 = uintBitsToFloat(srt_flatbuf_1.data[52u]) * uintBitsToFloat(_1087);
                    _1496 = floatBitsToUint(_1495);
                    if (true)
                    {
                        _1084 = _1394;
                        _1085 = _1392;
                        _1086 = _1462;
                        _1087 = _1496;
                        _1088 = _1492;
                        _1089 = _1157;
                        _1090 = _1154;
                        continue;
                    }
                    else
                    {
                        _1497 = _1394;
                        _1498 = _1392;
                        _1499 = _1462;
                        _1500 = _1492;
                        break;
                    }
                }
            }
            precise float _1512 = uintBitsToFloat(srt_flatbuf_1.data[49u]) * uintBitsToFloat(_1500);
            precise float _1513 = _1512 + uintBitsToFloat(_1068);
            precise float _1515 = uintBitsToFloat(srt_flatbuf_1.data[51u]) * _1513;
            precise float _1519 = uintBitsToFloat(srt_flatbuf_1.data[50u]) * uintBitsToFloat(_1068);
            _1521 = _1497;
            _1522 = _1498;
            _1523 = _1499;
            _1524 = floatBitsToUint(_1515);
            _1525 = floatBitsToUint(_1519);
        }
        else
        {
            _1521 = _580;
            _1522 = _581;
            _1523 = _582;
            _1524 = _636;
            _1525 = _637;
        }
        float _1531 = uintBitsToFloat(_1525);
        precise float _1537 = ((0.0 > uintBitsToFloat(_1525)) ? uintBitsToFloat(_603) : uintBitsToFloat(_604)) * max(min(1.0, _1531), min(max(1.0, _1531), -1.0));
        precise float _1538 = _1537 + uintBitsToFloat(_602);
        float _1542 = max(min(1.0, _1538), min(max(1.0, _1538), -1.0));
        precise float _1549 = (-0.5) * _1542;
        precise float _1551 = _1549 + 0.5;
        bool _1554 = 0u != srt_flatbuf_1.data[107u];
        uint _1561;
        if (_1554)
        {
            _1561 = srt_flatbuf_1.data[106u];
        }
        else
        {
            _1561 = _1523;
        }
        uint _2675;
        uint _2676;
        uint _2677;
        uint _2678;
        if (!_1554)
        {
            float _1567 = uintBitsToFloat(_1524);
            precise float _1573 = max(min(1.0, _1567), min(max(1.0, _1567), -1.0)) * ((0.0 > uintBitsToFloat(_1524)) ? uintBitsToFloat(_603) : uintBitsToFloat(_604));
            precise float _1574 = _1573 + uintBitsToFloat(_602);
            bool _1575 = 0.0 > _1574;
            precise float _1601 = uintBitsToFloat(srt_flatbuf_1.data[69u]) * float((uvec2(srt_flatbuf_1.data[75u], srt_flatbuf_1.data[76u])));
            precise float _1603 = uintBitsToFloat(srt_flatbuf_1.data[68u]) * _327;
            precise float _1605 = uintBitsToFloat(srt_flatbuf_1.data[68u]) * _330;
            bool _1606 = _220 && _1575;
            uint _2663;
            uint _2664;
            uint _2665;
            if (_1606)
            {
                uint _1676;
                uint _1679;
                uint _2006;
                uint _2010;
                uint _2019;
                uint _2023;
                uint _2024;
                uint _2025;
                uint _2026;
                uint _2027;
                uint _1607 = _1521;
                uint _1608 = _1522;
                uint _1609 = 1065353216u;
                uint _1610 = 1065353216u;
                uint _1611 = 0u;
                uint _1612 = 0u;
                for (;;)
                {
                    if (!(int(_1612) < int(srt_flatbuf_1.data[72u])))
                    {
                        _2024 = _1607;
                        _2025 = _1608;
                        _2026 = _1610;
                        _2027 = _1611;
                        break;
                    }
                    else
                    {
                        precise float _1616 = uintBitsToFloat(_1609) * _1603;
                        uint _1622 = 255u & uint(int(floor(_1616)));
                        precise float _1632 = uintBitsToFloat(_1609) * _1601;
                        precise float _1634 = _1603 * uintBitsToFloat(_1609);
                        precise float _1635 = _1634 + trunc(-floor(_1616));
                        precise float _1637 = uintBitsToFloat(_1609) * _1605;
                        uint _1640 = uint(int(floor(_1637)));
                        uint _1644 = uint(int(floor(_1632)));
                        precise float _1648 = _1635 * _1635;
                        precise float _1650 = _1601 * uintBitsToFloat(_1609);
                        precise float _1651 = _1650 + trunc(-floor(_1632));
                        precise float _1653 = _1605 * uintBitsToFloat(_1609);
                        precise float _1654 = _1653 + trunc(-floor(_1637));
                        precise float _1655 = _1648 * _1635;
                        float _1656 = float(int(6u));
                        precise float _1659 = (-1.0) + _1635;
                        precise float _1660 = (-1.0) + _1654;
                        precise float _1661 = (-1.0) + _1651;
                        precise float _1662 = _1655 * fma(fma(_1656, _1635, -15.0), _1635, 10.0);
                        precise float _1667 = _1654 * _1654;
                        precise float _1668 = _1667 * _1654;
                        precise float _1669 = _1668 * fma(fma(_1656, _1654, -15.0), _1654, 10.0);
                        precise float _1670 = _1651 * _1651;
                        precise float _1671 = _1670 * _1651;
                        precise float _1675 = _1671 * fma(fma(_1656, _1651, -15.0), _1651, 10.0);
                        _1676 = _1612 + 1u;
                        precise float _1678 = 2.0 * uintBitsToFloat(_1609);
                        _1679 = floatBitsToUint(_1678);
                        uint _1681 = 255u & (ssbo_5_1.data[_1622 + buf4_dword_off] + _1640);
                        uint _1683 = 255u & (ssbo_5_1.data[(_1622 + 1u) + buf4_dword_off] + _1640);
                        uint _1693 = 255u & (ssbo_5_1.data[_1681 + buf4_dword_off] + _1644);
                        uint _1702 = 255u & (ssbo_5_1.data[(_1681 + 1u) + buf4_dword_off] + _1644);
                        uint _1715 = bitfieldExtract(15u & ssbo_5_1.data[_1693 + buf4_dword_off], int(0u), int(24u)) * 12u;
                        uint _1719 = 255u & (ssbo_5_1.data[_1683 + buf4_dword_off] + _1644);
                        uint _1726 = 255u & (ssbo_5_1.data[(_1683 + 1u) + buf4_dword_off] + _1644);
                        uint _1747 = bitfieldExtract(15u & ssbo_5_1.data[(_1693 + 1u) + buf4_dword_off], int(0u), int(24u)) * 12u;
                        uint _1752 = bitfieldExtract(15u & ssbo_5_1.data[_1719 + buf4_dword_off], int(0u), int(24u)) * 12u;
                        uint _1757 = bitfieldExtract(15u & ssbo_5_1.data[_1702 + buf4_dword_off], int(0u), int(24u)) * 12u;
                        uint _1763 = ((_1715 + 6144u) >> 2u) + buf3_dword_off;
                        vec4 _1776 = vec4(vec3(ssbo_4_3.data[_1763], ssbo_4_3.data[_1763 + 1u], ssbo_4_3.data[_1763 + 2u]), 0.0);
                        vec4 _1777 = vec4(_1776.x, _1776.y, _1776.z, _1776.w);
                        uint _1784 = ((_1752 + 6336u) >> 2u) + buf3_dword_off;
                        vec4 _1797 = vec4(vec3(ssbo_4_3.data[_1784], ssbo_4_3.data[_1784 + 1u], ssbo_4_3.data[_1784 + 2u]), 0.0);
                        vec4 _1798 = vec4(_1797.x, _1797.y, _1797.z, _1797.w);
                        uint _1805 = ((_1757 + 6528u) >> 2u) + buf3_dword_off;
                        vec4 _1818 = vec4(vec3(ssbo_4_3.data[_1805], ssbo_4_3.data[_1805 + 1u], ssbo_4_3.data[_1805 + 2u]), 0.0);
                        vec4 _1819 = vec4(_1818.x, _1818.y, _1818.z, _1818.w);
                        uint _1826 = ((_1747 + 6912u) >> 2u) + buf3_dword_off;
                        vec4 _1839 = vec4(vec3(ssbo_4_3.data[_1826], ssbo_4_3.data[_1826 + 1u], ssbo_4_3.data[_1826 + 2u]), 0.0);
                        vec4 _1840 = vec4(_1839.x, _1839.y, _1839.z, _1839.w);
                        uint _1848 = bitfieldExtract(15u & ssbo_5_1.data[_1726 + buf4_dword_off], int(0u), int(24u)) * 12u;
                        uint _1854 = ((_1848 + 6720u) >> 2u) + buf3_dword_off;
                        vec4 _1867 = vec4(vec3(ssbo_4_3.data[_1854], ssbo_4_3.data[_1854 + 1u], ssbo_4_3.data[_1854 + 2u]), 0.0);
                        vec4 _1868 = vec4(_1867.x, _1867.y, _1867.z, _1867.w);
                        uint _1873 = bitfieldExtract(15u & ssbo_5_1.data[(_1719 + 1u) + buf4_dword_off], int(0u), int(24u)) * 12u;
                        uint _1877 = bitfieldExtract(15u & ssbo_5_1.data[(_1702 + 1u) + buf4_dword_off], int(0u), int(24u)) * 12u;
                        uint _1883 = ((_1877 + 7296u) >> 2u) + buf3_dword_off;
                        vec4 _1896 = vec4(vec3(ssbo_4_3.data[_1883], ssbo_4_3.data[_1883 + 1u], ssbo_4_3.data[_1883 + 2u]), 0.0);
                        vec4 _1897 = vec4(_1896.x, _1896.y, _1896.z, _1896.w);
                        uint _1904 = ((_1873 + 7104u) >> 2u) + buf3_dword_off;
                        vec4 _1917 = vec4(vec3(ssbo_4_3.data[_1904], ssbo_4_3.data[_1904 + 1u], ssbo_4_3.data[_1904 + 2u]), 0.0);
                        vec4 _1918 = vec4(_1917.x, _1917.y, _1917.z, _1917.w);
                        uint _1924 = bitfieldExtract(15u & ssbo_5_1.data[(_1726 + 1u) + buf4_dword_off], int(0u), int(24u)) * 12u;
                        uint _1930 = ((_1924 + 7488u) >> 2u) + buf3_dword_off;
                        vec4 _1943 = vec4(vec3(ssbo_4_3.data[_1930], ssbo_4_3.data[_1930 + 1u], ssbo_4_3.data[_1930 + 2u]), 0.0);
                        vec4 _1944 = vec4(_1943.x, _1943.y, _1943.z, _1943.w);
                        precise float _1948 = _1777.x * _1635;
                        precise float _1949 = _1777.y * _1654;
                        precise float _1950 = _1949 + _1948;
                        precise float _1951 = _1651 * _1777.z;
                        precise float _1952 = _1951 + _1950;
                        precise float _1954 = _1798.x * _1659;
                        precise float _1955 = _1954 + (-_1952);
                        precise float _1956 = _1654 * _1798.y;
                        precise float _1957 = _1956 + _1955;
                        precise float _1958 = _1651 * _1798.z;
                        precise float _1959 = _1958 + _1957;
                        precise float _1960 = _1840.x * _1635;
                        precise float _1961 = _1654 * _1840.y;
                        precise float _1962 = _1961 + _1960;
                        precise float _1963 = _1840.z * _1661;
                        precise float _1964 = _1963 + _1962;
                        precise float _1966 = _1918.x * _1659;
                        precise float _1967 = _1966 + (-_1964);
                        precise float _1968 = _1959 * _1662;
                        precise float _1969 = _1968 + _1952;
                        precise float _1970 = _1819.x * _1635;
                        precise float _1971 = _1819.y * _1660;
                        precise float _1972 = _1971 + _1970;
                        precise float _1973 = _1651 * _1819.z;
                        precise float _1974 = _1973 + _1972;
                        precise float _1975 = _1654 * _1918.y;
                        precise float _1976 = _1975 + _1967;
                        precise float _1977 = _1974 - _1969;
                        precise float _1979 = _1868.x * _1659;
                        precise float _1980 = _1979 + (-_1974);
                        precise float _1981 = _1660 * _1868.y;
                        precise float _1982 = _1981 + _1980;
                        precise float _1983 = _1651 * _1868.z;
                        precise float _1984 = _1983 + _1982;
                        precise float _1985 = _1897.x * _1635;
                        precise float _1986 = _1660 * _1897.y;
                        precise float _1987 = _1986 + _1985;
                        precise float _1988 = _1897.z * _1661;
                        precise float _1989 = _1988 + _1987;
                        precise float _1990 = _1661 * _1918.z;
                        precise float _1991 = _1990 + _1976;
                        precise float _1992 = _1984 * _1662;
                        precise float _1993 = _1992 + _1977;
                        precise float _1994 = _1991 * _1662;
                        precise float _1995 = _1994 + _1964;
                        precise float _1996 = _1989 - _1995;
                        precise float _1998 = _1944.x * _1659;
                        precise float _1999 = _1998 + (-_1989);
                        precise float _2000 = _1660 * _1944.y;
                        precise float _2001 = _2000 + _1999;
                        precise float _2002 = _1993 * _1669;
                        precise float _2003 = _2002 + _1969;
                        precise float _2004 = _1661 * _1944.z;
                        precise float _2005 = _2004 + _2001;
                        _2006 = floatBitsToUint(_2005);
                        precise float _2007 = _1995 - _2003;
                        precise float _2008 = _2005 * _1662;
                        precise float _2009 = _2008 + _1996;
                        _2010 = floatBitsToUint(_2009);
                        precise float _2011 = _2009 * _1669;
                        precise float _2012 = _2011 + _2007;
                        precise float _2013 = _2012 * _1675;
                        precise float _2014 = _2013 + _2003;
                        precise float _2017 = _2014 * uintBitsToFloat(_1610);
                        precise float _2018 = _2017 + uintBitsToFloat(_1611);
                        _2019 = floatBitsToUint(_2018);
                        precise float _2022 = uintBitsToFloat(srt_flatbuf_1.data[70u]) * uintBitsToFloat(_1610);
                        _2023 = floatBitsToUint(_2022);
                        if (true)
                        {
                            _1607 = _2010;
                            _1608 = _2006;
                            _1609 = _1679;
                            _1610 = _2023;
                            _1611 = _2019;
                            _1612 = _1676;
                            continue;
                        }
                        else
                        {
                            _2024 = _2010;
                            _2025 = _2006;
                            _2026 = _2023;
                            _2027 = _2019;
                            break;
                        }
                    }
                }
                float _2028 = max(-1.0, _1574);
                uint _2039;
                if (_1606 && _1575)
                {
                    precise float _2036 = uintBitsToFloat(srt_flatbuf_1.data[102u]) * (-_2028);
                    _2039 = floatBitsToUint(clamp(_2036, 0.0, 1.0));
                }
                else
                {
                    _2039 = _2026;
                }
                precise float _2098 = 1.0 + uintBitsToFloat(srt_flatbuf_1.data[74u]);
                precise float _2103 = uintBitsToFloat(srt_flatbuf_1.data[71u]) * uintBitsToFloat(_2027);
                precise float _2104 = _2103 + uintBitsToFloat(srt_flatbuf_1.data[74u]);
                precise float _2105 = (1.0 / _2098) * _2104;
                precise float _2109 = uintBitsToFloat(srt_flatbuf_1.data[73u]) * log2(clamp(_2105, 0.0, 1.0));
                precise float _2114 = exp2(_2109) * uintBitsToFloat(_2039);
                precise float _2116 = uintBitsToFloat(srt_flatbuf_1.data[98u]) * (1.0 / uintBitsToFloat(srt_flatbuf_1.data[99u]));
                precise double _2121 = (uvec2(_303, _302.y)) + (uvec2(srt_flatbuf_1.data[90u], srt_flatbuf_1.data[91u]));
                precise double _2129 = (uvec2(_307, _306.y)) + (uvec2(srt_flatbuf_1.data[92u], srt_flatbuf_1.data[93u]));
                precise float _2135 = _2116 * (-_2114);
                precise float _2136 = _2135 + uintBitsToFloat(srt_flatbuf_1.data[98u]);
                precise float _2148 = uintBitsToFloat(srt_flatbuf_1.data[81u]) * float((uvec2(_2121)));
                precise float _2150 = uintBitsToFloat(srt_flatbuf_1.data[81u]) * float((uvec2(_2129)));
                precise float _2152 = uintBitsToFloat(srt_flatbuf_1.data[82u]) * float((uvec2(srt_flatbuf_1.data[94u], srt_flatbuf_1.data[95u])));
                uint _2225;
                uint _2229;
                uint _2232;
                uint _2236;
                uint _2555;
                uint _2559;
                uint _2568;
                uint _2569;
                uint _2570;
                uint _2571;
                uint _2572;
                uint _2153 = _2024;
                uint _2154 = _2025;
                uint _2155 = 1065353216u;
                uint _2156 = 0u;
                uint _2157 = 0u;
                uint _2158 = 1065353216u;
                uint _2159 = 0u;
                for (;;)
                {
                    if (!(int(_2159) < int(srt_flatbuf_1.data[84u])))
                    {
                        _2569 = _2153;
                        _2570 = _2154;
                        _2571 = _2157;
                        _2572 = _2156;
                        break;
                    }
                    else
                    {
                        precise float _2163 = uintBitsToFloat(_2155) * _2148;
                        uint _2169 = 255u & uint(int(floor(_2163)));
                        precise float _2179 = uintBitsToFloat(_2155) * _2152;
                        precise float _2181 = _2148 * uintBitsToFloat(_2155);
                        precise float _2182 = _2181 + trunc(-floor(_2163));
                        precise float _2184 = uintBitsToFloat(_2155) * _2150;
                        uint _2187 = uint(int(floor(_2184)));
                        uint _2191 = uint(int(floor(_2179)));
                        precise float _2195 = _2182 * _2182;
                        precise float _2197 = _2152 * uintBitsToFloat(_2155);
                        precise float _2198 = _2197 + trunc(-floor(_2179));
                        precise float _2200 = _2150 * uintBitsToFloat(_2155);
                        precise float _2201 = _2200 + trunc(-floor(_2184));
                        precise float _2202 = _2195 * _2182;
                        float _2203 = float(int(6u));
                        precise float _2206 = (-1.0) + _2182;
                        precise float _2207 = (-1.0) + _2201;
                        precise float _2208 = (-1.0) + _2198;
                        precise float _2209 = _2202 * fma(fma(_2203, _2182, -15.0), _2182, 10.0);
                        precise float _2214 = _2201 * _2201;
                        precise float _2215 = _2214 * _2201;
                        precise float _2216 = _2215 * fma(fma(_2203, _2201, -15.0), _2201, 10.0);
                        precise float _2217 = _2198 * _2198;
                        precise float _2218 = _2217 * _2198;
                        precise float _2224 = _2218 * fma(fma(_2203, _2198, -15.0), _2198, 10.0);
                        _2225 = _2159 + 1u;
                        precise float _2228 = uintBitsToFloat(_2156) + uintBitsToFloat(_2158);
                        _2229 = floatBitsToUint(_2228);
                        precise float _2231 = 2.0 * uintBitsToFloat(_2155);
                        _2232 = floatBitsToUint(_2231);
                        precise float _2235 = uintBitsToFloat(srt_flatbuf_1.data[83u]) * uintBitsToFloat(_2158);
                        _2236 = floatBitsToUint(_2235);
                        uint _2238 = 255u & (ssbo_6_1.data[_2169 + buf5_dword_off] + _2187);
                        uint _2240 = 255u & (ssbo_6_1.data[(_2169 + 1u) + buf5_dword_off] + _2187);
                        uint _2250 = 255u & (ssbo_6_1.data[_2238 + buf5_dword_off] + _2191);
                        uint _2259 = 255u & (ssbo_6_1.data[(_2238 + 1u) + buf5_dword_off] + _2191);
                        uint _2272 = bitfieldExtract(15u & ssbo_6_1.data[_2250 + buf5_dword_off], int(0u), int(24u)) * 12u;
                        uint _2274 = 255u & (ssbo_6_1.data[_2240 + buf5_dword_off] + _2191);
                        uint _2281 = 255u & (ssbo_6_1.data[(_2240 + 1u) + buf5_dword_off] + _2191);
                        uint _2302 = bitfieldExtract(15u & ssbo_6_1.data[(_2250 + 1u) + buf5_dword_off], int(0u), int(24u)) * 12u;
                        uint _2305 = bitfieldExtract(15u & ssbo_6_1.data[_2274 + buf5_dword_off], int(0u), int(24u)) * 12u;
                        uint _2308 = bitfieldExtract(15u & ssbo_6_1.data[_2259 + buf5_dword_off], int(0u), int(24u)) * 12u;
                        uint _2313 = ((_2272 + 1536u) >> 2u) + buf3_dword_off;
                        vec4 _2326 = vec4(vec3(ssbo_4_3.data[_2313], ssbo_4_3.data[_2313 + 1u], ssbo_4_3.data[_2313 + 2u]), 0.0);
                        vec4 _2327 = vec4(_2326.x, _2326.y, _2326.z, _2326.w);
                        uint _2335 = ((_2305 + 1728u) >> 2u) + buf3_dword_off;
                        vec4 _2348 = vec4(vec3(ssbo_4_3.data[_2335], ssbo_4_3.data[_2335 + 1u], ssbo_4_3.data[_2335 + 2u]), 0.0);
                        vec4 _2349 = vec4(_2348.x, _2348.y, _2348.z, _2348.w);
                        uint _2357 = ((_2308 + 1920u) >> 2u) + buf3_dword_off;
                        vec4 _2370 = vec4(vec3(ssbo_4_3.data[_2357], ssbo_4_3.data[_2357 + 1u], ssbo_4_3.data[_2357 + 2u]), 0.0);
                        vec4 _2371 = vec4(_2370.x, _2370.y, _2370.z, _2370.w);
                        uint _2379 = ((_2302 + 2304u) >> 2u) + buf3_dword_off;
                        vec4 _2392 = vec4(vec3(ssbo_4_3.data[_2379], ssbo_4_3.data[_2379 + 1u], ssbo_4_3.data[_2379 + 2u]), 0.0);
                        vec4 _2393 = vec4(_2392.x, _2392.y, _2392.z, _2392.w);
                        uint _2401 = bitfieldExtract(15u & ssbo_6_1.data[_2281 + buf5_dword_off], int(0u), int(24u)) * 12u;
                        uint _2406 = ((_2401 + 2112u) >> 2u) + buf3_dword_off;
                        vec4 _2419 = vec4(vec3(ssbo_4_3.data[_2406], ssbo_4_3.data[_2406 + 1u], ssbo_4_3.data[_2406 + 2u]), 0.0);
                        vec4 _2420 = vec4(_2419.x, _2419.y, _2419.z, _2419.w);
                        uint _2425 = bitfieldExtract(15u & ssbo_6_1.data[(_2274 + 1u) + buf5_dword_off], int(0u), int(24u)) * 12u;
                        uint _2427 = bitfieldExtract(15u & ssbo_6_1.data[(_2259 + 1u) + buf5_dword_off], int(0u), int(24u)) * 12u;
                        uint _2432 = ((_2427 + 2688u) >> 2u) + buf3_dword_off;
                        vec4 _2445 = vec4(vec3(ssbo_4_3.data[_2432], ssbo_4_3.data[_2432 + 1u], ssbo_4_3.data[_2432 + 2u]), 0.0);
                        vec4 _2446 = vec4(_2445.x, _2445.y, _2445.z, _2445.w);
                        uint _2454 = ((_2425 + 2496u) >> 2u) + buf3_dword_off;
                        vec4 _2467 = vec4(vec3(ssbo_4_3.data[_2454], ssbo_4_3.data[_2454 + 1u], ssbo_4_3.data[_2454 + 2u]), 0.0);
                        vec4 _2468 = vec4(_2467.x, _2467.y, _2467.z, _2467.w);
                        uint _2474 = bitfieldExtract(15u & ssbo_6_1.data[(_2281 + 1u) + buf5_dword_off], int(0u), int(24u)) * 12u;
                        uint _2479 = ((_2474 + 2880u) >> 2u) + buf3_dword_off;
                        vec4 _2492 = vec4(vec3(ssbo_4_3.data[_2479], ssbo_4_3.data[_2479 + 1u], ssbo_4_3.data[_2479 + 2u]), 0.0);
                        vec4 _2493 = vec4(_2492.x, _2492.y, _2492.z, _2492.w);
                        precise float _2497 = _2327.x * _2182;
                        precise float _2498 = _2327.y * _2201;
                        precise float _2499 = _2498 + _2497;
                        precise float _2500 = _2198 * _2327.z;
                        precise float _2501 = _2500 + _2499;
                        precise float _2503 = _2349.x * _2206;
                        precise float _2504 = _2503 + (-_2501);
                        precise float _2505 = _2201 * _2349.y;
                        precise float _2506 = _2505 + _2504;
                        precise float _2507 = _2198 * _2349.z;
                        precise float _2508 = _2507 + _2506;
                        precise float _2509 = _2393.x * _2182;
                        precise float _2510 = _2201 * _2393.y;
                        precise float _2511 = _2510 + _2509;
                        precise float _2512 = _2393.z * _2208;
                        precise float _2513 = _2512 + _2511;
                        precise float _2515 = _2468.x * _2206;
                        precise float _2516 = _2515 + (-_2513);
                        precise float _2517 = _2508 * _2209;
                        precise float _2518 = _2517 + _2501;
                        precise float _2519 = _2371.x * _2182;
                        precise float _2520 = _2371.y * _2207;
                        precise float _2521 = _2520 + _2519;
                        precise float _2522 = _2198 * _2371.z;
                        precise float _2523 = _2522 + _2521;
                        precise float _2524 = _2201 * _2468.y;
                        precise float _2525 = _2524 + _2516;
                        precise float _2526 = _2523 - _2518;
                        precise float _2528 = _2420.x * _2206;
                        precise float _2529 = _2528 + (-_2523);
                        precise float _2530 = _2207 * _2420.y;
                        precise float _2531 = _2530 + _2529;
                        precise float _2532 = _2198 * _2420.z;
                        precise float _2533 = _2532 + _2531;
                        precise float _2534 = _2446.x * _2182;
                        precise float _2535 = _2207 * _2446.y;
                        precise float _2536 = _2535 + _2534;
                        precise float _2537 = _2446.z * _2208;
                        precise float _2538 = _2537 + _2536;
                        precise float _2539 = _2208 * _2468.z;
                        precise float _2540 = _2539 + _2525;
                        precise float _2541 = _2533 * _2209;
                        precise float _2542 = _2541 + _2526;
                        precise float _2543 = _2540 * _2209;
                        precise float _2544 = _2543 + _2513;
                        precise float _2545 = _2538 - _2544;
                        precise float _2547 = _2493.x * _2206;
                        precise float _2548 = _2547 + (-_2538);
                        precise float _2549 = _2207 * _2493.y;
                        precise float _2550 = _2549 + _2548;
                        precise float _2551 = _2542 * _2216;
                        precise float _2552 = _2551 + _2518;
                        precise float _2553 = _2208 * _2493.z;
                        precise float _2554 = _2553 + _2550;
                        _2555 = floatBitsToUint(_2554);
                        precise float _2556 = _2544 - _2552;
                        precise float _2557 = _2554 * _2209;
                        precise float _2558 = _2557 + _2545;
                        _2559 = floatBitsToUint(_2558);
                        precise float _2560 = _2558 * _2216;
                        precise float _2561 = _2560 + _2556;
                        precise float _2562 = _2561 * _2224;
                        precise float _2563 = _2562 + _2552;
                        precise float _2566 = _2563 * uintBitsToFloat(_2158);
                        precise float _2567 = _2566 + uintBitsToFloat(_2157);
                        _2568 = floatBitsToUint(_2567);
                        if (true)
                        {
                            _2153 = _2559;
                            _2154 = _2555;
                            _2155 = _2232;
                            _2156 = _2229;
                            _2157 = _2568;
                            _2158 = _2236;
                            _2159 = _2225;
                            continue;
                        }
                        else
                        {
                            _2569 = _2559;
                            _2570 = _2555;
                            _2571 = _2568;
                            _2572 = _2229;
                            break;
                        }
                    }
                }
                precise float _2604 = fma(0.60000002384185791015625, uintBitsToFloat(srt_flatbuf_1.data[87u]), 0.20000000298023223876953125);
                precise float _2605 = 1.0 - _2604;
                precise float _2611 = (1.0 / uintBitsToFloat(_2572)) * uintBitsToFloat(_2571);
                precise float _2612 = _2611 + (-_2604);
                precise float _2614 = uintBitsToFloat(srt_flatbuf_1.data[88u]) + max(0.0, _2136);
                precise float _2616 = (1.0 / max(0.0500000007450580596923828125, _2605)) * _2612;
                precise float _2618 = uintBitsToFloat(srt_flatbuf_1.data[86u]) * clamp(_2614, 0.0, 1.0);
                precise float _2619 = 0.5 * _2616;
                precise float _2620 = _2619 + 0.5;
                precise float _2621 = _2618 * _2618;
                precise float _2623 = _2621 * _2618;
                precise float _2624 = _2623 + 1.0;
                precise float _2626 = uintBitsToFloat(srt_flatbuf_1.data[85u]) * max(0.0, _2620);
                precise float _2627 = _2624 * _2624;
                precise float _2630 = _2627 * _2627;
                precise float _2631 = _2630 * log2(abs(_2626));
                precise float _2636 = uintBitsToFloat(srt_flatbuf_1.data[89u]) * log2(clamp(exp2(_2631), 0.0, 1.0));
                float _2637 = exp2(_2636);
                precise float _2639 = uintBitsToFloat(srt_flatbuf_1.data[104u]) - _2028;
                precise float _2642 = uintBitsToFloat(srt_flatbuf_1.data[97u]) * _2637;
                precise float _2643 = _2642 + uintBitsToFloat(srt_flatbuf_1.data[96u]);
                precise float _2644 = (-1.0) + _2639;
                precise float _2647 = (1.0 / uintBitsToFloat(srt_flatbuf_1.data[104u])) * _2644;
                precise float _2651 = uintBitsToFloat(srt_flatbuf_1.data[96u]) * (-_2637);
                precise float _2652 = _2651 + _2643;
                precise float _2655 = (-_2114) * _2652;
                precise float _2656 = _2655 + uintBitsToFloat(srt_flatbuf_1.data[103u]);
                precise float _2657 = _2114 * _2652;
                precise float _2659 = uintBitsToFloat(srt_flatbuf_1.data[105u]) * clamp(_2647, 0.0, 1.0);
                precise float _2660 = _2656 * _2659;
                precise float _2661 = _2660 + _2657;
                _2663 = _2569;
                _2664 = _2570;
                _2665 = floatBitsToUint(_2661);
            }
            else
            {
                _2663 = _1521;
                _2664 = _1522;
                _2665 = 0u;
            }
            _2675 = _2663;
            _2676 = _2664;
            _2677 = _2665;
            _2678 = floatBitsToUint(((0u != srt_flatbuf_1.data[108u]) ? _220 : false) ? 0.0 : uintBitsToFloat(_2665));
        }
        else
        {
            _2675 = _1521;
            _2676 = _1522;
            _2677 = _1524;
            _2678 = _1561;
        }
        bool _2684 = 0u != srt_flatbuf_1.data[112u];
        uint _2691;
        if (_2684)
        {
            _2691 = srt_flatbuf_1.data[111u];
        }
        else
        {
            _2691 = _2677;
        }
        uint _2706;
        if (!_2684)
        {
            precise float _2703 = (-uintBitsToFloat(srt_flatbuf_1.data[110u])) * uintBitsToFloat(_281);
            precise float _2704 = _2703 + uintBitsToFloat(srt_flatbuf_1.data[109u]);
            _2706 = floatBitsToUint(_2704);
        }
        else
        {
            _2706 = _2691;
        }
        precise float _2707 = fma(_1542, 0.5, 0.5);
        precise float _2716 = sqrt(_2707) * _2707;
        precise float _2718 = 2.5 * _2716;
        precise float _2719 = _2718 * _2718;
        precise float _2722 = 0.039999999105930328369140625 * uintBitsToFloat(_2678);
        precise float _2723 = _2722 + 1.0;
        precise float _2725 = (-1.44269502162933349609375) * _2719;
        float _2726 = log2(_2723);
        precise float _2731 = 0.693147182464599609375 * _2726;
        precise float _2732 = _2731 + uintBitsToFloat(srt_flatbuf_1.data[116u]);
        precise float _2734 = uintBitsToFloat(srt_flatbuf_1.data[117u]) * exp2(_2725);
        precise float _2735 = _2734 + _2732;
        precise float _2741 = max(min(1.0, _2735), min(max(1.0, _2735), 0.0)) * 2.0;
        precise float _2742 = 0.693147182464599609375 * _2726;
        bool _2743 = _220 && (0.5 > _2735);
        uint _2748;
        if (_2743)
        {
            _2748 = srt_flatbuf_1.data[114u];
        }
        else
        {
            _2748 = floatBitsToUint(_2726);
        }
        uint _2755;
        if (_220 && (!_2743))
        {
            _2755 = srt_flatbuf_1.data[115u];
        }
        else
        {
            _2755 = _2748;
        }
        precise float _2787 = (-1.0) + _2741;
        float _2790 = float((uvec2(srt_flatbuf_1.data[127u], srt_flatbuf_1.data[128u])));
        uint _2791 = floatBitsToUint(_2790);
        bool _2792 = 0u != srt_flatbuf_1.data[133u];
        precise float _2794 = uintBitsToFloat(srt_flatbuf_1.data[123u]) * _2790;
        precise float _2797 = uintBitsToFloat(_2755) * _2787;
        precise float _2798 = _2797 + uintBitsToFloat(srt_flatbuf_1.data[113u]);
        float _2799 = clamp(_2798, 0.0, 1.0);
        precise float _2803 = uintBitsToFloat(srt_flatbuf_1.data[122u]) * uintBitsToFloat(_280);
        precise float _2806 = uintBitsToFloat(srt_flatbuf_1.data[122u]) * uintBitsToFloat(_282);
        uint _2813;
        if (_2792)
        {
            _2813 = srt_flatbuf_1.data[132u];
        }
        else
        {
            _2813 = _2755;
        }
        uint _3277;
        uint _3278;
        uint _3279;
        uint _3280;
        if (!_2792)
        {
            uint _2887;
            uint _2888;
            uint _3186;
            uint _3205;
            uint _3211;
            uint _3218;
            uint _3222;
            uint _3223;
            uint _3224;
            uint _3225;
            uint _3226;
            uint _2814 = _2675;
            uint _2815 = _2676;
            uint _2816 = _2791;
            uint _2817 = 1065353216u;
            uint _2818 = 1065353216u;
            uint _2819 = 0u;
            uint _2820 = 0u;
            for (;;)
            {
                if (!(int(_2820) < int(srt_flatbuf_1.data[126u])))
                {
                    _3223 = _2814;
                    _3224 = _2815;
                    _3225 = _2816;
                    _3226 = _2819;
                    break;
                }
                else
                {
                    precise float _2824 = uintBitsToFloat(_2818) * _2803;
                    uint _2830 = 255u & uint(int(floor(_2824)));
                    precise float _2840 = uintBitsToFloat(_2818) * _2794;
                    precise float _2842 = _2803 * uintBitsToFloat(_2818);
                    precise float _2843 = _2842 + trunc(-floor(_2824));
                    precise float _2845 = uintBitsToFloat(_2818) * _2806;
                    uint _2848 = uint(int(floor(_2845)));
                    uint _2852 = uint(int(floor(_2840)));
                    precise float _2856 = _2843 * _2843;
                    precise float _2858 = _2794 * uintBitsToFloat(_2818);
                    precise float _2859 = _2858 + trunc(-floor(_2840));
                    precise float _2861 = _2806 * uintBitsToFloat(_2818);
                    precise float _2862 = _2861 + trunc(-floor(_2845));
                    precise float _2863 = _2856 * _2843;
                    float _2864 = float(int(6u));
                    precise float _2867 = (-1.0) + _2843;
                    precise float _2868 = (-1.0) + _2862;
                    precise float _2869 = (-1.0) + _2859;
                    precise float _2870 = _2863 * fma(fma(_2864, _2843, -15.0), _2843, 10.0);
                    precise float _2875 = _2862 * _2862;
                    precise float _2876 = _2875 * _2862;
                    precise float _2877 = _2876 * fma(fma(_2864, _2862, -15.0), _2862, 10.0);
                    precise float _2878 = _2859 * _2859;
                    precise float _2879 = _2878 * _2859;
                    precise float _2884 = _2879 * fma(fma(_2864, _2859, -15.0), _2859, 10.0);
                    precise float _2886 = 2.0 * uintBitsToFloat(_2818);
                    _2887 = floatBitsToUint(_2886);
                    _2888 = _2820 + 1u;
                    uint _2890 = 255u & (ssbo_7_1.data[_2830 + buf6_dword_off] + _2848);
                    uint _2892 = 255u & (ssbo_7_1.data[(_2830 + 1u) + buf6_dword_off] + _2848);
                    uint _2902 = 255u & (ssbo_7_1.data[_2890 + buf6_dword_off] + _2852);
                    uint _2920 = 255u & (ssbo_7_1.data[(_2890 + 1u) + buf6_dword_off] + _2852);
                    uint _2926 = 255u & (ssbo_7_1.data[_2892 + buf6_dword_off] + _2852);
                    uint _2933 = 255u & (ssbo_7_1.data[(_2892 + 1u) + buf6_dword_off] + _2852);
                    uint _2954 = bitfieldExtract(15u & ssbo_7_1.data[_2926 + buf6_dword_off], int(0u), int(24u)) * 12u;
                    uint _2958 = bitfieldExtract(15u & ssbo_7_1.data[_2933 + buf6_dword_off], int(0u), int(24u)) * 12u;
                    uint _2961 = bitfieldExtract(15u & ssbo_7_1.data[(_2926 + 1u) + buf6_dword_off], int(0u), int(24u)) * 12u;
                    uint _2963 = ((bitfieldExtract(15u & ssbo_7_1.data[_2902 + buf6_dword_off], int(0u), int(24u)) * 12u) >> 2u) + buf3_dword_off;
                    vec4 _2976 = vec4(vec3(ssbo_4_3.data[_2963], ssbo_4_3.data[_2963 + 1u], ssbo_4_3.data[_2963 + 2u]), 0.0);
                    vec4 _2977 = vec4(_2976.x, _2976.y, _2976.z, _2976.w);
                    uint _2985 = ((_2954 + 192u) >> 2u) + buf3_dword_off;
                    vec4 _2998 = vec4(vec3(ssbo_4_3.data[_2985], ssbo_4_3.data[_2985 + 1u], ssbo_4_3.data[_2985 + 2u]), 0.0);
                    vec4 _2999 = vec4(_2998.x, _2998.y, _2998.z, _2998.w);
                    uint _3007 = ((_2961 + 960u) >> 2u) + buf3_dword_off;
                    vec4 _3020 = vec4(vec3(ssbo_4_3.data[_3007], ssbo_4_3.data[_3007 + 1u], ssbo_4_3.data[_3007 + 2u]), 0.0);
                    vec4 _3021 = vec4(_3020.x, _3020.y, _3020.z, _3020.w);
                    uint _3027 = bitfieldExtract(15u & ssbo_7_1.data[(_2902 + 1u) + buf6_dword_off], int(0u), int(24u)) * 12u;
                    uint _3032 = ((_3027 + 768u) >> 2u) + buf3_dword_off;
                    vec4 _3045 = vec4(vec3(ssbo_4_3.data[_3032], ssbo_4_3.data[_3032 + 1u], ssbo_4_3.data[_3032 + 2u]), 0.0);
                    vec4 _3046 = vec4(_3045.x, _3045.y, _3045.z, _3045.w);
                    uint _3051 = bitfieldExtract(15u & ssbo_7_1.data[_2920 + buf6_dword_off], int(0u), int(24u)) * 12u;
                    uint _3057 = ((_3051 + 384u) >> 2u) + buf3_dword_off;
                    vec4 _3070 = vec4(vec3(ssbo_4_3.data[_3057], ssbo_4_3.data[_3057 + 1u], ssbo_4_3.data[_3057 + 2u]), 0.0);
                    vec4 _3071 = vec4(_3070.x, _3070.y, _3070.z, _3070.w);
                    uint _3079 = ((_2958 + 576u) >> 2u) + buf3_dword_off;
                    vec4 _3092 = vec4(vec3(ssbo_4_3.data[_3079], ssbo_4_3.data[_3079 + 1u], ssbo_4_3.data[_3079 + 2u]), 0.0);
                    vec4 _3093 = vec4(_3092.x, _3092.y, _3092.z, _3092.w);
                    uint _3098 = bitfieldExtract(15u & ssbo_7_1.data[(_2920 + 1u) + buf6_dword_off], int(0u), int(24u)) * 12u;
                    uint _3103 = ((_3098 + 1152u) >> 2u) + buf3_dword_off;
                    vec4 _3116 = vec4(vec3(ssbo_4_3.data[_3103], ssbo_4_3.data[_3103 + 1u], ssbo_4_3.data[_3103 + 2u]), 0.0);
                    vec4 _3117 = vec4(_3116.x, _3116.y, _3116.z, _3116.w);
                    uint _3123 = bitfieldExtract(15u & ssbo_7_1.data[(_2933 + 1u) + buf6_dword_off], int(0u), int(24u)) * 12u;
                    uint _3128 = ((_3123 + 1344u) >> 2u) + buf3_dword_off;
                    vec4 _3141 = vec4(vec3(ssbo_4_3.data[_3128], ssbo_4_3.data[_3128 + 1u], ssbo_4_3.data[_3128 + 2u]), 0.0);
                    vec4 _3142 = vec4(_3141.x, _3141.y, _3141.z, _3141.w);
                    precise float _3146 = _2977.x * _2843;
                    precise float _3147 = _2977.y * _2862;
                    precise float _3148 = _3147 + _3146;
                    precise float _3149 = _2859 * _2977.z;
                    precise float _3150 = _3149 + _3148;
                    precise float _3152 = _2999.x * _2867;
                    precise float _3153 = _3152 + (-_3150);
                    precise float _3154 = _2862 * _2999.y;
                    precise float _3155 = _3154 + _3153;
                    precise float _3156 = _2859 * _2999.z;
                    precise float _3157 = _3156 + _3155;
                    precise float _3158 = _3046.x * _2843;
                    precise float _3159 = _2862 * _3046.y;
                    precise float _3160 = _3159 + _3158;
                    precise float _3161 = _2869 * _3046.z;
                    precise float _3162 = _3161 + _3160;
                    precise float _3163 = _3157 * _2870;
                    precise float _3164 = _3163 + _3150;
                    precise float _3165 = _3071.x * _2843;
                    precise float _3166 = _3071.y * _2868;
                    precise float _3167 = _3166 + _3165;
                    precise float _3168 = _2859 * _3071.z;
                    precise float _3169 = _3168 + _3167;
                    precise float _3171 = _3093.x * _2867;
                    precise float _3172 = _3171 + (-_3169);
                    precise float _3173 = _2868 * _3093.y;
                    precise float _3174 = _3173 + _3172;
                    precise float _3175 = _3169 - _3164;
                    precise float _3177 = _3021.x * _2867;
                    precise float _3178 = _3177 + (-_3162);
                    precise float _3179 = _2862 * _3021.y;
                    precise float _3180 = _3179 + _3178;
                    precise float _3181 = _2859 * _3093.z;
                    precise float _3182 = _3181 + _3174;
                    precise float _3183 = _3117.x * _2843;
                    precise float _3184 = _2868 * _3117.y;
                    precise float _3185 = _3184 + _3183;
                    _3186 = floatBitsToUint(_3185);
                    precise float _3187 = _3117.z * _2869;
                    precise float _3188 = _3187 + _3185;
                    precise float _3189 = _2869 * _3021.z;
                    precise float _3190 = _3189 + _3180;
                    precise float _3191 = _3182 * _2870;
                    precise float _3192 = _3191 + _3175;
                    precise float _3193 = _3190 * _2870;
                    precise float _3194 = _3193 + _3162;
                    precise float _3195 = _3188 - _3194;
                    precise float _3197 = _3142.x * _2867;
                    precise float _3198 = _3197 + (-_3188);
                    precise float _3199 = _2868 * _3142.y;
                    precise float _3200 = _3199 + _3198;
                    precise float _3201 = _3192 * _2877;
                    precise float _3202 = _3201 + _3164;
                    precise float _3203 = _2869 * _3142.z;
                    precise float _3204 = _3203 + _3200;
                    _3205 = floatBitsToUint(_3204);
                    precise float _3206 = _3194 - _3202;
                    precise float _3207 = _3204 * _2870;
                    precise float _3208 = _3207 + _3195;
                    precise float _3209 = _3208 * _2877;
                    precise float _3210 = _3209 + _3206;
                    _3211 = floatBitsToUint(_3210);
                    precise float _3212 = _3210 * _2884;
                    precise float _3213 = _3212 + _3202;
                    precise float _3216 = _3213 * uintBitsToFloat(_2817);
                    precise float _3217 = _3216 + uintBitsToFloat(_2819);
                    _3218 = floatBitsToUint(_3217);
                    precise float _3221 = uintBitsToFloat(srt_flatbuf_1.data[124u]) * uintBitsToFloat(_2817);
                    _3222 = floatBitsToUint(_3221);
                    if (true)
                    {
                        _2814 = _3186;
                        _2815 = _3205;
                        _2816 = _3211;
                        _2817 = _3222;
                        _2818 = _2887;
                        _2819 = _3218;
                        _2820 = _2888;
                        continue;
                    }
                    else
                    {
                        _3223 = _3186;
                        _3224 = _3205;
                        _3225 = _3211;
                        _3226 = _3218;
                        break;
                    }
                }
            }
            bool _3228 = _220 && (0.0 > _1538);
            uint _3233;
            if (_3228)
            {
                _3233 = srt_flatbuf_1.data[130u];
            }
            else
            {
                _3233 = _3225;
            }
            uint _3240;
            if (_220 && (!_3228))
            {
                _3240 = srt_flatbuf_1.data[131u];
            }
            else
            {
                _3240 = _3233;
            }
            precise float _3255 = uintBitsToFloat(srt_flatbuf_1.data[129u]) + uintBitsToFloat(_281);
            precise float _3263 = 5.255877017974853515625 * log2(max(0.0, fma(-8.4171435446478426456451416015625e-05, _3255, 3.731446743011474609375)));
            precise float _3267 = uintBitsToFloat(srt_flatbuf_1.data[125u]) * uintBitsToFloat(_3226);
            precise float _3270 = uintBitsToFloat(_3240) * ((0.0 > _1538) ? min(-0.5, _1542) : max(0.5, _1542));
            precise float _3274 = _3270 * fma(0.300000011920928955078125, _3267, 0.699999988079071044921875);
            precise float _3275 = _3274 + exp2(_3263);
            _3277 = _3223;
            _3278 = _3224;
            _3279 = 1050253722u;
            _3280 = floatBitsToUint(_3275);
        }
        else
        {
            _3277 = _2675;
            _3278 = _2676;
            _3279 = _281;
            _3280 = _2813;
        }
        uint _3305 = srt_flatbuf_1.data[135u];
        uint _3310 = srt_flatbuf_1.data[136u];
        precise float _3314 = fma(-0.12999999523162841796875, uintBitsToFloat(_2706), 0.920000016689300537109375);
        precise float _3315 = max(fma(-0.23000000417232513427734375, uintBitsToFloat(_2706), 1.35000002384185791015625), fma(-0.12999999523162841796875, uintBitsToFloat(_2706), 0.9700000286102294921875)) - _3314;
        precise float _3318 = (-0.115415595471858978271484375) * uintBitsToFloat(_2678);
        precise float _3324 = _3314 - _2799;
        bool _3328 = ((0u != srt_flatbuf_1.data[146u]) ? _220 : false) && ((0u != srt_flatbuf_1.data[148u]) ? _220 : false);
        precise float _3329 = (1.0 / _3315) * _3324;
        precise float _3330 = _3329 + 1.0;
        precise float _3334 = uintBitsToFloat(srt_flatbuf_1.data[134u]) * exp2(_3318);
        precise float _3335 = _3334 + clamp(max(0.0, _2742), 0.0, 1.0);
        uint _3363;
        uint _3364;
        uint _3365;
        if (_3328)
        {
            precise float _3351 = (-0.15915493667125701904296875) * uintBitsToFloat(srt_flatbuf_1.data[145u]);
            precise float _3354 = 0.15915493667125701904296875 * uintBitsToFloat(srt_flatbuf_1.data[145u]);
            _3363 = srt_flatbuf_1.data[147u];
            _3364 = floatBitsToUint(cos(6.283185482025146484375 * fract(_3354)));
            _3365 = floatBitsToUint(sin(6.283185482025146484375 * fract(_3351)));
        }
        else
        {
            _3363 = _3277;
            _3364 = _3278;
            _3365 = _3279;
        }
        uint _3462;
        uint _3463;
        uint _3464;
        if (!_3328)
        {
            precise float _3397 = uintBitsToFloat(srt_flatbuf_1.data[142u]) - uintBitsToFloat(srt_flatbuf_1.data[143u]);
            precise float _3402 = (-uintBitsToFloat(srt_flatbuf_1.data[143u])) + (-_1542);
            precise float _3403 = (1.0 / _3397) * _3402;
            precise float _3407 = uintBitsToFloat(srt_flatbuf_1.data[144u]) * log2(clamp(_3403, 0.0, 1.0));
            float _3408 = exp2(_3407);
            precise float _3410 = (-0.15915493667125701904296875) * uintBitsToFloat(srt_flatbuf_1.data[141u]);
            precise float _3412 = uintBitsToFloat(srt_flatbuf_1.data[139u]) * _3408;
            precise float _3415 = (-0.15915493667125701904296875) * uintBitsToFloat(srt_flatbuf_1.data[138u]);
            precise float _3418 = uintBitsToFloat(srt_flatbuf_1.data[140u]) * _3408;
            precise float _3419 = _3418 + uintBitsToFloat(srt_flatbuf_1.data[137u]);
            precise float _3421 = 0.15915493667125701904296875 * uintBitsToFloat(srt_flatbuf_1.data[141u]);
            precise float _3422 = _3412 * _3419;
            precise float _3428 = 0.15915493667125701904296875 * uintBitsToFloat(srt_flatbuf_1.data[138u]);
            precise float _3429 = sin(6.283185482025146484375 * fract(_3410)) * _3422;
            precise float _3433 = uintBitsToFloat(srt_flatbuf_1.data[137u]) * (-_3412);
            precise float _3434 = _3433 + uintBitsToFloat(srt_flatbuf_1.data[137u]);
            precise float _3440 = cos(6.283185482025146484375 * fract(_3421)) * _3422;
            precise float _3443 = _3434 * sin(6.283185482025146484375 * fract(_3415));
            precise float _3444 = _3443 + _3429;
            precise float _3445 = _3444 * _3444;
            precise float _3446 = _3434 * cos(6.283185482025146484375 * fract(_3428));
            precise float _3447 = _3446 + _3440;
            precise float _3448 = _3447 * _3447;
            precise float _3449 = _3448 + _3445;
            float _3450 = sqrt(_3449);
            float _3451 = inversesqrt(_3449);
            bool _3452 = 0.0 < _3450;
            precise float _3453 = _3451 * _3444;
            precise float _3454 = _3451 * _3447;
            _3462 = floatBitsToUint(_3452 ? _3453 : 1.0);
            _3463 = floatBitsToUint(min(11.0, _3450));
            _3464 = floatBitsToUint(_3452 ? _3454 : 0.0);
        }
        else
        {
            _3462 = _3365;
            _3463 = _3363;
            _3464 = _3364;
        }
        uint _3468 = srt_flatbuf_1.data[150u];
        uint _3472 = srt_flatbuf_1.data[151u];
        uint _3477 = srt_flatbuf_1.data[152u];
        precise float _3484 = uintBitsToFloat(_3280) * (1.0 / fma(287.0, uintBitsToFloat(_2706), 78394.046875));
        precise float _3486 = 100.0 * _3484;
        precise float _3490 = uintBitsToFloat(_3463) * uintBitsToFloat(_3464);
        precise float _3494 = uintBitsToFloat(_3463) * uintBitsToFloat(_3462);
        uvec4 _3496 = uvec4(floatBitsToUint(_3486), _3468, _3472, _3477);
        uint _3499 = ((_219 * 20u) + 16u) + buf7_dword_off;
        ssbo_8_1.data[_3499] = _3496.x;
        ssbo_8_1.data[_3499 + 1u] = _3496.y;
        ssbo_8_1.data[_3499 + 2u] = _3496.z;
        ssbo_8_1.data[_3499 + 3u] = _3496.w;
        uvec4 _3511 = uvec4(_3463, floatBitsToUint(_3494), 0u, floatBitsToUint(_3490));
        uint _3514 = ((_219 * 20u) + 12u) + buf7_dword_off;
        ssbo_8_1.data[_3514] = _3511.x;
        ssbo_8_1.data[_3514 + 1u] = _3511.y;
        ssbo_8_1.data[_3514 + 2u] = _3511.z;
        ssbo_8_1.data[_3514 + 3u] = _3511.w;
        uvec4 _3526 = uvec4(_2706, _3280, floatBitsToUint(clamp(_1551, 0.0, 1.0)), floatBitsToUint(_2799));
        uint _3528 = (_219 * 20u) + buf7_dword_off;
        ssbo_8_1.data[_3528] = _3526.x;
        ssbo_8_1.data[_3528 + 1u] = _3526.y;
        ssbo_8_1.data[_3528 + 2u] = _3526.z;
        ssbo_8_1.data[_3528 + 3u] = _3526.w;
        uvec4 _3540 = uvec4(floatBitsToUint(clamp(_3335, 0.0, 1.0)), _2678, _3305, floatBitsToUint(clamp(_3330, 0.0, 1.0)));
        uint _3543 = ((_219 * 20u) + 4u) + buf7_dword_off;
        ssbo_8_1.data[_3543] = _3540.x;
        ssbo_8_1.data[_3543 + 1u] = _3540.y;
        ssbo_8_1.data[_3543 + 2u] = _3540.z;
        ssbo_8_1.data[_3543 + 3u] = _3540.w;
        uvec4 _3555 = uvec4(_3310, _3462, 0u, _3464);
        uint _3558 = ((_219 * 20u) + 8u) + buf7_dword_off;
        ssbo_8_1.data[_3558] = _3555.x;
        ssbo_8_1.data[_3558 + 1u] = _3555.y;
        ssbo_8_1.data[_3558 + 2u] = _3555.z;
        ssbo_8_1.data[_3558 + 3u] = _3555.w;
    }
}

