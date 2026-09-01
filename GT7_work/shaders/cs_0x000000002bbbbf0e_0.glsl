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
layout(local_size_x = 32, local_size_y = 32, local_size_z = 1) in;

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

layout(binding = 0, std430) readonly buffer ssbo_1_2
{
    float data[];
} ssbo_1_3;

layout(binding = 0, std430) readonly buffer ssbo_1_4
{
    uint16_t data[];
} ssbo_1_5;

layout(binding = 0, std430) readonly buffer ssbo_1_6
{
    uint8_t data[];
} ssbo_1_7;

layout(binding = 1, std430) buffer ssbo_2
{
    uint data[];
} ssbo_2_1;

layout(binding = 2, std430) buffer ssbo_3
{
    uint data[];
} ssbo_3_1;

layout(binding = 3, std430) readonly buffer ssbo_4
{
    uint data[];
} ssbo_4_1;

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

void main()
{
    uint buf0_off = bitfieldExtract(push_data.buf_offsets0.x, int(0u), int(8u));
    uint buf0_dword_off = buf0_off >> 2u;
    uint buf1_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(8u), int(8u)) >> 2u;
    uint buf2_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(16u), int(8u)) >> 2u;
    uint buf3_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(24u), int(8u)) >> 2u;
    uint _132 = srt_flatbuf_1.data[16u];
    uint _135 = srt_flatbuf_1.data[17u];
    uint _136 = (gl_WorkGroupID.x << 5u) + gl_LocalInvocationID.x;
    uint _137 = (gl_WorkGroupID.y << 5u) + gl_LocalInvocationID.y;
    bool _140 = (_132 <= _136) || (_135 <= _137);
    bool _141 = !_140;
    if (!_140)
    {
        uint _144 = floatBitsToUint(float(int(_136)));
        uint _156 = floatBitsToUint(float(int(_137)));
        uint _258;
        uint _542;
        uint _1345;
        uint _1449;
        uint _1718;
        uint _1719;
        uint _157 = 0u;
        uint _158 = _156;
        uint _159 = srt_flatbuf_1.data[19u];
        uint _160 = _144;
        uint _161 = 0u;
        for (;;)
        {
            if (!(int(_161) < int(srt_flatbuf_1.data[23u])))
            {
                _1719 = _157;
                break;
            }
            else
            {
                uint _169 = uint(int(uintBitsToFloat(_158)));
                uint _171 = uint(int(uintBitsToFloat(_159)));
                precise float _173 = uintBitsToFloat(_158) + trunc(-uintBitsToFloat(_158));
                uint _177 = 255u & uint(int(uintBitsToFloat(_160)));
                vec4 _185 = vec4(ssbo_1_3.data[((bitfieldExtract(_177, int(0u), int(24u)) * 4u) >> 2u) + buf0_dword_off], 0.0, 0.0, 0.0);
                vec4 _198 = vec4(ssbo_1_3.data[((bitfieldExtract(255u & (_177 + 1u), int(0u), int(24u)) * 4u) >> 2u) + buf0_dword_off], 0.0, 0.0, 0.0);
                precise float _206 = uintBitsToFloat(_160) + trunc(-uintBitsToFloat(_160));
                precise float _211 = uintBitsToFloat(_159) + trunc(-uintBitsToFloat(_159));
                precise float _213 = (-1.0) + _206;
                precise float _214 = _206 * _206;
                precise float _215 = _214 * _206;
                float _217 = float(int(6u));
                precise float _222 = _215 * fma(fma(_217, _206, -15.0), _206, 10.0);
                precise float _223 = (-1.0) + _173;
                precise float _226 = 2.0 * uintBitsToFloat(_160);
                uint _228 = 255u & uint(int(_226));
                precise float _230 = _173 * _173;
                precise float _232 = _230 * _173;
                precise float _233 = _232 * fma(fma(_217, _173, -15.0), _173, 10.0);
                precise float _235 = 2.0 * uintBitsToFloat(_158);
                precise float _239 = 2.0 * uintBitsToFloat(_160);
                precise float _240 = _239 + trunc(-_226);
                precise float _243 = 4.0 * uintBitsToFloat(_160);
                uint _245 = 255u & uint(int(_243));
                precise float _249 = 4.0 * uintBitsToFloat(_160);
                precise float _250 = _249 + trunc(-_243);
                precise float _253 = 8.0 * uintBitsToFloat(_160);
                _258 = _161 + 1u;
                uint _259 = floatBitsToUint(vec4(_185.x, _185.y, _185.z, _185.x).x) + _169;
                uint _262 = floatBitsToUint(vec4(_198.x, _198.y, _198.z, _198.x).x) + _169;
                vec4 _279 = vec4(ssbo_1_3.data[((bitfieldExtract(255u & _259, int(0u), int(24u)) * 4u) >> 2u) + buf0_dword_off], 0.0, 0.0, 0.0);
                vec4 _287 = vec4(ssbo_1_3.data[((bitfieldExtract(255u & (_259 + 1u), int(0u), int(24u)) * 4u) >> 2u) + buf0_dword_off], 0.0, 0.0, 0.0);
                vec4 _295 = vec4(ssbo_1_3.data[((bitfieldExtract(255u & _262, int(0u), int(24u)) * 4u) >> 2u) + buf0_dword_off], 0.0, 0.0, 0.0);
                vec4 _303 = vec4(ssbo_1_3.data[((bitfieldExtract(255u & (_262 + 1u), int(0u), int(24u)) * 4u) >> 2u) + buf0_dword_off], 0.0, 0.0, 0.0);
                uint _307 = floatBitsToUint(vec4(_279.x, _279.y, _279.z, _279.x).x) + _171;
                uint _312 = bitfieldExtract(15u & _307, int(0u), int(24u)) * 12u;
                uint _313 = floatBitsToUint(vec4(_295.x, _295.y, _295.z, _295.x).x) + _171;
                uint _315 = floatBitsToUint(vec4(_287.x, _287.y, _287.z, _287.x).x) + _171;
                uint _318 = floatBitsToUint(vec4(_303.x, _303.y, _303.z, _303.x).x) + _171;
                uint _321 = bitfieldExtract(15u & _315, int(0u), int(24u)) * 12u;
                uint _324 = bitfieldExtract(15u & _318, int(0u), int(24u)) * 12u;
                uint _328 = bitfieldExtract(15u & (_307 + 1u), int(0u), int(24u)) * 12u;
                uint _333 = ((_312 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _346 = vec4(vec3(ssbo_1_3.data[_333], ssbo_1_3.data[_333 + 1u], ssbo_1_3.data[_333 + 2u]), 0.0);
                vec4 _347 = vec4(_346.x, _346.y, _346.z, _346.w);
                uint _353 = bitfieldExtract(15u & _313, int(0u), int(24u)) * 12u;
                uint _358 = bitfieldExtract(15u & (_315 + 1u), int(0u), int(24u)) * 12u;
                uint _360 = bitfieldExtract(15u & (_313 + 1u), int(0u), int(24u)) * 12u;
                uint _362 = bitfieldExtract(15u & (_318 + 1u), int(0u), int(24u)) * 12u;
                precise float _363 = _347.x * _206;
                precise float _364 = _173 * _347.y;
                precise float _365 = _364 + _363;
                precise float _366 = _347.z * _211;
                precise float _367 = _366 + _365;
                uint _371 = ((_353 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _384 = vec4(vec3(ssbo_1_3.data[_371], ssbo_1_3.data[_371 + 1u], ssbo_1_3.data[_371 + 2u]), 0.0);
                vec4 _385 = vec4(_384.x, _384.y, _384.z, _384.w);
                uint _392 = ((_321 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _405 = vec4(vec3(ssbo_1_3.data[_392], ssbo_1_3.data[_392 + 1u], ssbo_1_3.data[_392 + 2u]), 0.0);
                vec4 _406 = vec4(_405.x, _405.y, _405.z, _405.w);
                precise float _411 = _385.x * _213;
                precise float _412 = _411 + (-_367);
                precise float _413 = _173 * _385.y;
                precise float _414 = _413 + _412;
                precise float _415 = _211 * _385.z;
                precise float _416 = _415 + _414;
                precise float _417 = _406.x * _206;
                precise float _418 = _406.y * _223;
                precise float _419 = _418 + _417;
                precise float _420 = _211 * _406.z;
                precise float _421 = _420 + _419;
                precise float _422 = _416 * _222;
                precise float _423 = _422 + _367;
                uint _427 = ((_324 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _440 = vec4(vec3(ssbo_1_3.data[_427], ssbo_1_3.data[_427 + 1u], ssbo_1_3.data[_427 + 2u]), 0.0);
                vec4 _441 = vec4(_440.x, _440.y, _440.z, _440.w);
                precise float _445 = _421 - _423;
                precise float _446 = (-1.0) + _211;
                precise float _448 = _441.x * _213;
                precise float _449 = _448 + (-_421);
                precise float _450 = _223 * _441.y;
                precise float _451 = _450 + _449;
                precise float _452 = _211 * _441.z;
                precise float _453 = _452 + _451;
                precise float _454 = _453 * _222;
                precise float _455 = _454 + _445;
                precise float _456 = _233 * _455;
                precise float _457 = _456 + _423;
                uint _461 = ((_328 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _474 = vec4(vec3(ssbo_1_3.data[_461], ssbo_1_3.data[_461 + 1u], ssbo_1_3.data[_461 + 2u]), 0.0);
                vec4 _475 = vec4(_474.x, _474.y, _474.z, _474.w);
                uint _482 = ((_358 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _495 = vec4(vec3(ssbo_1_3.data[_482], ssbo_1_3.data[_482 + 1u], ssbo_1_3.data[_482 + 2u]), 0.0);
                vec4 _496 = vec4(_495.x, _495.y, _495.z, _495.w);
                uint _503 = ((_362 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _516 = vec4(vec3(ssbo_1_3.data[_503], ssbo_1_3.data[_503 + 1u], ssbo_1_3.data[_503 + 2u]), 0.0);
                vec4 _517 = vec4(_516.x, _516.y, _516.z, _516.w);
                precise float _523 = _211 * _211;
                precise float _524 = _523 * _211;
                precise float _529 = _524 * fma(fma(_217, _211, -15.0), _211, 10.0);
                uint _533 = 255u & uint(int(_253));
                precise float _537 = uintBitsToFloat(_160) * 8.0;
                precise float _538 = _537 + trunc(-_253);
                precise float _541 = uintBitsToFloat(srt_flatbuf_1.data[24u]) * uintBitsToFloat(_160);
                _542 = floatBitsToUint(_541);
                precise float _543 = _475.x * _206;
                precise float _544 = _173 * _475.y;
                precise float _545 = _544 + _543;
                precise float _546 = _496.x * _206;
                precise float _547 = _446 * _475.z;
                precise float _548 = _547 + _545;
                precise float _549 = _223 * _496.y;
                precise float _550 = _549 + _546;
                precise float _551 = _446 * _496.z;
                precise float _552 = _551 + _550;
                precise float _554 = _517.x * _213;
                precise float _555 = _554 + (-_552);
                precise float _556 = _223 * _517.y;
                precise float _557 = _556 + _555;
                precise float _558 = _446 * _517.z;
                precise float _559 = _558 + _557;
                precise float _561 = 2.0 * uintBitsToFloat(_159);
                precise float _562 = _240 * _240;
                precise float _563 = _562 * _240;
                uint _569 = ((_360 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _582 = vec4(vec3(ssbo_1_3.data[_569], ssbo_1_3.data[_569 + 1u], ssbo_1_3.data[_569 + 2u]), 0.0);
                vec4 _583 = vec4(_582.x, _582.y, _582.z, _582.w);
                vec4 _591 = vec4(ssbo_1_3.data[((bitfieldExtract(_228, int(0u), int(24u)) * 4u) >> 2u) + buf0_dword_off], 0.0, 0.0, 0.0);
                vec4 _599 = vec4(ssbo_1_3.data[((bitfieldExtract(255u & (_228 + 1u), int(0u), int(24u)) * 4u) >> 2u) + buf0_dword_off], 0.0, 0.0, 0.0);
                vec4 _607 = vec4(ssbo_1_3.data[((bitfieldExtract(_245, int(0u), int(24u)) * 4u) >> 2u) + buf0_dword_off], 0.0, 0.0, 0.0);
                precise float _616 = _583.x * _213;
                precise float _617 = _616 + (-_548);
                precise float _618 = _173 * _583.y;
                precise float _619 = _618 + _617;
                precise float _620 = _446 * _583.z;
                precise float _621 = _620 + _619;
                precise float _622 = _621 * _222;
                precise float _623 = _622 + _548;
                precise float _624 = _552 - _623;
                precise float _625 = _559 * _222;
                precise float _626 = _625 + _624;
                precise float _627 = _623 - _457;
                precise float _628 = _626 * _233;
                precise float _629 = _628 + _627;
                uint _630 = uint(int(_561));
                precise float _636 = 2.0 * uintBitsToFloat(_158);
                precise float _637 = _636 + trunc(-_235);
                precise float _639 = 2.0 * uintBitsToFloat(_159);
                precise float _640 = _639 + trunc(-_561);
                precise float _641 = (-1.0) + _637;
                precise float _644 = _563 * fma(fma(_217, _240, -15.0), _240, 10.0);
                precise float _645 = (-1.0) + _640;
                precise float _646 = _629 * _529;
                precise float _647 = _646 + _457;
                uint _648 = uint(int(_235));
                uint _649 = floatBitsToUint(vec4(_591.x, _591.y, _591.z, _591.x).x) + _648;
                uint _655 = floatBitsToUint(vec4(_599.x, _599.y, _599.z, _599.x).x) + _648;
                vec4 _665 = vec4(ssbo_1_3.data[((bitfieldExtract(255u & _649, int(0u), int(24u)) * 4u) >> 2u) + buf0_dword_off], 0.0, 0.0, 0.0);
                vec4 _673 = vec4(ssbo_1_3.data[((bitfieldExtract(255u & (_649 + 1u), int(0u), int(24u)) * 4u) >> 2u) + buf0_dword_off], 0.0, 0.0, 0.0);
                vec4 _681 = vec4(ssbo_1_3.data[((bitfieldExtract(255u & _655, int(0u), int(24u)) * 4u) >> 2u) + buf0_dword_off], 0.0, 0.0, 0.0);
                vec4 _689 = vec4(ssbo_1_3.data[((bitfieldExtract(255u & (_245 + 1u), int(0u), int(24u)) * 4u) >> 2u) + buf0_dword_off], 0.0, 0.0, 0.0);
                precise float _697 = (-1.0) + _240;
                vec4 _710 = vec4(ssbo_1_3.data[((bitfieldExtract(255u & (_655 + 1u), int(0u), int(24u)) * 4u) >> 2u) + buf0_dword_off], 0.0, 0.0, 0.0);
                vec4 _718 = vec4(ssbo_1_3.data[((bitfieldExtract(_533, int(0u), int(24u)) * 4u) >> 2u) + buf0_dword_off], 0.0, 0.0, 0.0);
                vec4 _726 = vec4(ssbo_1_3.data[((bitfieldExtract(255u & (_533 + 1u), int(0u), int(24u)) * 4u) >> 2u) + buf0_dword_off], 0.0, 0.0, 0.0);
                precise float _732 = 0.5 * _647;
                precise float _733 = _732 + uintBitsToFloat(_157);
                precise float _734 = _637 * _637;
                precise float _735 = _734 * _637;
                precise float _736 = _735 * fma(fma(_217, _637, -15.0), _637, 10.0);
                uint _737 = floatBitsToUint(vec4(_665.x, _665.y, _665.z, _665.x).x) + _630;
                uint _740 = bitfieldExtract(15u & _737, int(0u), int(24u)) * 12u;
                uint _741 = floatBitsToUint(vec4(_681.x, _681.y, _681.z, _681.x).x) + _630;
                uint _742 = floatBitsToUint(vec4(_673.x, _673.y, _673.z, _673.x).x) + _630;
                uint _747 = bitfieldExtract(15u & _742, int(0u), int(24u)) * 12u;
                uint _750 = floatBitsToUint(vec4(_710.x, _710.y, _710.z, _710.x).x) + _630;
                uint _754 = bitfieldExtract(15u & _741, int(0u), int(24u)) * 12u;
                uint _757 = bitfieldExtract(15u & (_737 + 1u), int(0u), int(24u)) * 12u;
                uint _759 = bitfieldExtract(15u & (_742 + 1u), int(0u), int(24u)) * 12u;
                uint _762 = bitfieldExtract(15u & _750, int(0u), int(24u)) * 12u;
                uint _765 = bitfieldExtract(15u & (_741 + 1u), int(0u), int(24u)) * 12u;
                uint _769 = ((_740 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _782 = vec4(vec3(ssbo_1_3.data[_769], ssbo_1_3.data[_769 + 1u], ssbo_1_3.data[_769 + 2u]), 0.0);
                vec4 _783 = vec4(_782.x, _782.y, _782.z, _782.w);
                uint _790 = ((_754 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _803 = vec4(vec3(ssbo_1_3.data[_790], ssbo_1_3.data[_790 + 1u], ssbo_1_3.data[_790 + 2u]), 0.0);
                vec4 _804 = vec4(_803.x, _803.y, _803.z, _803.w);
                uint _810 = bitfieldExtract(15u & (_750 + 1u), int(0u), int(24u)) * 12u;
                precise float _811 = _783.x * _240;
                precise float _812 = _637 * _783.y;
                precise float _813 = _812 + _811;
                precise float _814 = _783.z * _640;
                precise float _815 = _814 + _813;
                precise float _817 = _804.x * _697;
                precise float _818 = _817 + (-_815);
                precise float _819 = _637 * _804.y;
                precise float _820 = _819 + _818;
                precise float _821 = _640 * _804.z;
                precise float _822 = _821 + _820;
                precise float _823 = _822 * _644;
                precise float _824 = _823 + _815;
                uint _828 = ((_747 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _841 = vec4(vec3(ssbo_1_3.data[_828], ssbo_1_3.data[_828 + 1u], ssbo_1_3.data[_828 + 2u]), 0.0);
                vec4 _842 = vec4(_841.x, _841.y, _841.z, _841.w);
                uint _849 = ((_762 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _862 = vec4(vec3(ssbo_1_3.data[_849], ssbo_1_3.data[_849 + 1u], ssbo_1_3.data[_849 + 2u]), 0.0);
                vec4 _863 = vec4(_862.x, _862.y, _862.z, _862.w);
                precise float _867 = _842.x * _240;
                precise float _868 = _842.y * _641;
                precise float _869 = _868 + _867;
                precise float _870 = _640 * _842.z;
                precise float _871 = _870 + _869;
                precise float _872 = _871 - _824;
                precise float _874 = _863.x * _697;
                precise float _875 = _874 + (-_871);
                precise float _876 = _641 * _863.y;
                precise float _877 = _876 + _875;
                precise float _878 = _640 * _863.z;
                precise float _879 = _878 + _877;
                precise float _880 = _879 * _644;
                precise float _881 = _880 + _872;
                precise float _882 = _736 * _881;
                precise float _883 = _882 + _824;
                uint _887 = ((_757 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _900 = vec4(vec3(ssbo_1_3.data[_887], ssbo_1_3.data[_887 + 1u], ssbo_1_3.data[_887 + 2u]), 0.0);
                vec4 _901 = vec4(_900.x, _900.y, _900.z, _900.w);
                uint _908 = ((_759 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _921 = vec4(vec3(ssbo_1_3.data[_908], ssbo_1_3.data[_908 + 1u], ssbo_1_3.data[_908 + 2u]), 0.0);
                vec4 _922 = vec4(_921.x, _921.y, _921.z, _921.w);
                uint _929 = ((_765 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _942 = vec4(vec3(ssbo_1_3.data[_929], ssbo_1_3.data[_929 + 1u], ssbo_1_3.data[_929 + 2u]), 0.0);
                vec4 _943 = vec4(_942.x, _942.y, _942.z, _942.w);
                uint _950 = ((_810 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _963 = vec4(vec3(ssbo_1_3.data[_950], ssbo_1_3.data[_950 + 1u], ssbo_1_3.data[_950 + 2u]), 0.0);
                vec4 _964 = vec4(_963.x, _963.y, _963.z, _963.w);
                precise float _970 = _640 * _640;
                precise float _971 = _970 * _640;
                precise float _973 = 4.0 * uintBitsToFloat(_159);
                precise float _974 = _971 * fma(fma(_217, _640, -15.0), _640, 10.0);
                precise float _976 = 4.0 * uintBitsToFloat(_158);
                precise float _977 = _901.x * _240;
                precise float _978 = _637 * _901.y;
                precise float _979 = _978 + _977;
                precise float _980 = _922.x * _240;
                precise float _981 = _645 * _901.z;
                precise float _982 = _981 + _979;
                precise float _984 = _943.x * _697;
                precise float _985 = _984 + (-_982);
                precise float _986 = _641 * _922.y;
                precise float _987 = _986 + _980;
                precise float _988 = _637 * _943.y;
                precise float _989 = _988 + _985;
                precise float _990 = _645 * _922.z;
                precise float _991 = _990 + _987;
                precise float _993 = _964.x * _697;
                precise float _994 = _993 + (-_991);
                precise float _995 = _645 * _943.z;
                precise float _996 = _995 + _989;
                precise float _997 = _996 * _644;
                precise float _998 = _997 + _982;
                precise float _999 = _641 * _964.y;
                precise float _1000 = _999 + _994;
                precise float _1001 = _645 * _964.z;
                precise float _1002 = _1001 + _1000;
                precise float _1003 = _991 - _998;
                precise float _1004 = _1002 * _644;
                precise float _1005 = _1004 + _1003;
                precise float _1006 = _998 - _883;
                precise float _1007 = _1005 * _736;
                precise float _1008 = _1007 + _1006;
                uint _1009 = uint(int(_973));
                precise float _1012 = _250 * _250;
                precise float _1013 = _1012 * _250;
                precise float _1015 = 4.0 * uintBitsToFloat(_158);
                precise float _1016 = _1015 + trunc(-_976);
                precise float _1017 = (-1.0) + _250;
                precise float _1018 = (-1.0) + _1016;
                precise float _1021 = _1013 * fma(fma(_217, _250, -15.0), _250, 10.0);
                precise float _1022 = _1008 * _974;
                precise float _1023 = _1022 + _883;
                uint _1024 = uint(int(_976));
                uint _1025 = floatBitsToUint(vec4(_607.x, _607.y, _607.z, _607.x).x) + _1024;
                uint _1031 = floatBitsToUint(vec4(_689.x, _689.y, _689.z, _689.x).x) + _1024;
                vec4 _1041 = vec4(ssbo_1_3.data[((bitfieldExtract(255u & _1025, int(0u), int(24u)) * 4u) >> 2u) + buf0_dword_off], 0.0, 0.0, 0.0);
                vec4 _1049 = vec4(ssbo_1_3.data[((bitfieldExtract(255u & (_1025 + 1u), int(0u), int(24u)) * 4u) >> 2u) + buf0_dword_off], 0.0, 0.0, 0.0);
                vec4 _1057 = vec4(ssbo_1_3.data[((bitfieldExtract(255u & _1031, int(0u), int(24u)) * 4u) >> 2u) + buf0_dword_off], 0.0, 0.0, 0.0);
                vec4 _1069 = vec4(ssbo_1_3.data[((bitfieldExtract(255u & (_1031 + 1u), int(0u), int(24u)) * 4u) >> 2u) + buf0_dword_off], 0.0, 0.0, 0.0);
                precise float _1076 = 4.0 * uintBitsToFloat(_159);
                precise float _1077 = _1076 + trunc(-_973);
                precise float _1081 = 8.0 * uintBitsToFloat(_158);
                precise float _1083 = 8.0 * uintBitsToFloat(_159);
                precise float _1085 = _1023 * 0.25;
                precise float _1086 = _1085 + _733;
                precise float _1087 = _1016 * _1016;
                precise float _1088 = _1087 * _1016;
                precise float _1089 = _1088 * fma(fma(_217, _1016, -15.0), _1016, 10.0);
                uint _1092 = floatBitsToUint(vec4(_1041.x, _1041.y, _1041.z, _1041.x).x) + _1009;
                uint _1095 = bitfieldExtract(15u & _1092, int(0u), int(24u)) * 12u;
                uint _1096 = floatBitsToUint(vec4(_1057.x, _1057.y, _1057.z, _1057.x).x) + _1009;
                uint _1097 = floatBitsToUint(vec4(_1049.x, _1049.y, _1049.z, _1049.x).x) + _1009;
                uint _1102 = bitfieldExtract(15u & _1097, int(0u), int(24u)) * 12u;
                uint _1103 = floatBitsToUint(vec4(_1069.x, _1069.y, _1069.z, _1069.x).x) + _1009;
                uint _1107 = bitfieldExtract(15u & _1096, int(0u), int(24u)) * 12u;
                uint _1111 = bitfieldExtract(15u & _1103, int(0u), int(24u)) * 12u;
                uint _1114 = bitfieldExtract(15u & (_1092 + 1u), int(0u), int(24u)) * 12u;
                uint _1117 = bitfieldExtract(15u & (_1097 + 1u), int(0u), int(24u)) * 12u;
                uint _1120 = bitfieldExtract(15u & (_1096 + 1u), int(0u), int(24u)) * 12u;
                uint _1124 = ((_1095 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _1137 = vec4(vec3(ssbo_1_3.data[_1124], ssbo_1_3.data[_1124 + 1u], ssbo_1_3.data[_1124 + 2u]), 0.0);
                vec4 _1138 = vec4(_1137.x, _1137.y, _1137.z, _1137.w);
                uint _1145 = ((_1107 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _1158 = vec4(vec3(ssbo_1_3.data[_1145], ssbo_1_3.data[_1145 + 1u], ssbo_1_3.data[_1145 + 2u]), 0.0);
                vec4 _1159 = vec4(_1158.x, _1158.y, _1158.z, _1158.w);
                uint _1165 = bitfieldExtract(15u & (_1103 + 1u), int(0u), int(24u)) * 12u;
                precise float _1166 = _1138.x * _250;
                precise float _1167 = _1016 * _1138.y;
                precise float _1168 = _1167 + _1166;
                precise float _1169 = _1138.z * _1077;
                precise float _1170 = _1169 + _1168;
                precise float _1172 = _1159.x * _1017;
                precise float _1173 = _1172 + (-_1170);
                precise float _1174 = _1016 * _1159.y;
                precise float _1175 = _1174 + _1173;
                precise float _1176 = _1077 * _1159.z;
                precise float _1177 = _1176 + _1175;
                precise float _1178 = _1177 * _1021;
                precise float _1179 = _1178 + _1170;
                uint _1183 = ((_1102 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _1196 = vec4(vec3(ssbo_1_3.data[_1183], ssbo_1_3.data[_1183 + 1u], ssbo_1_3.data[_1183 + 2u]), 0.0);
                vec4 _1197 = vec4(_1196.x, _1196.y, _1196.z, _1196.w);
                uint _1204 = ((_1111 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _1217 = vec4(vec3(ssbo_1_3.data[_1204], ssbo_1_3.data[_1204 + 1u], ssbo_1_3.data[_1204 + 2u]), 0.0);
                vec4 _1218 = vec4(_1217.x, _1217.y, _1217.z, _1217.w);
                precise float _1222 = (-1.0) + _1077;
                precise float _1223 = _1197.x * _250;
                precise float _1224 = _1197.y * _1018;
                precise float _1225 = _1224 + _1223;
                precise float _1226 = _1077 * _1197.z;
                precise float _1227 = _1226 + _1225;
                precise float _1228 = _1227 - _1179;
                precise float _1230 = _1218.x * _1017;
                precise float _1231 = _1230 + (-_1227);
                precise float _1232 = _1018 * _1218.y;
                precise float _1233 = _1232 + _1231;
                precise float _1234 = _1077 * _1218.z;
                precise float _1235 = _1234 + _1233;
                precise float _1236 = _1235 * _1021;
                precise float _1237 = _1236 + _1228;
                precise float _1238 = _1089 * _1237;
                precise float _1239 = _1238 + _1179;
                uint _1243 = ((_1114 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _1256 = vec4(vec3(ssbo_1_3.data[_1243], ssbo_1_3.data[_1243 + 1u], ssbo_1_3.data[_1243 + 2u]), 0.0);
                vec4 _1257 = vec4(_1256.x, _1256.y, _1256.z, _1256.w);
                uint _1264 = ((_1117 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _1277 = vec4(vec3(ssbo_1_3.data[_1264], ssbo_1_3.data[_1264 + 1u], ssbo_1_3.data[_1264 + 2u]), 0.0);
                vec4 _1278 = vec4(_1277.x, _1277.y, _1277.z, _1277.w);
                uint _1285 = ((_1120 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _1298 = vec4(vec3(ssbo_1_3.data[_1285], ssbo_1_3.data[_1285 + 1u], ssbo_1_3.data[_1285 + 2u]), 0.0);
                vec4 _1299 = vec4(_1298.x, _1298.y, _1298.z, _1298.w);
                uint _1306 = ((_1165 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _1319 = vec4(vec3(ssbo_1_3.data[_1306], ssbo_1_3.data[_1306 + 1u], ssbo_1_3.data[_1306 + 2u]), 0.0);
                vec4 _1320 = vec4(_1319.x, _1319.y, _1319.z, _1319.w);
                precise float _1326 = _1077 * _1077;
                precise float _1327 = _1326 * _1077;
                uint _1328 = uint(int(_1083));
                precise float _1329 = _1327 * fma(fma(_217, _1077, -15.0), _1077, 10.0);
                uint _1330 = uint(int(_1081));
                uint _1331 = floatBitsToUint(vec4(_718.x, _718.y, _718.z, _718.x).x) + _1330;
                uint _1332 = floatBitsToUint(vec4(_726.x, _726.y, _726.z, _726.x).x) + _1330;
                precise float _1336 = uintBitsToFloat(_159) * 8.0;
                precise float _1337 = _1336 + trunc(-_1083);
                precise float _1338 = _538 * _538;
                precise float _1339 = _1338 * _538;
                precise float _1340 = _1339 * fma(fma(_217, _538, -15.0), _538, 10.0);
                precise float _1341 = (-1.0) + _1337;
                precise float _1344 = uintBitsToFloat(srt_flatbuf_1.data[24u]) * uintBitsToFloat(_159);
                _1345 = floatBitsToUint(_1344);
                precise float _1346 = _1257.x * _250;
                precise float _1347 = _1016 * _1257.y;
                precise float _1348 = _1347 + _1346;
                precise float _1349 = _1278.x * _250;
                precise float _1350 = _1222 * _1257.z;
                precise float _1351 = _1350 + _1348;
                precise float _1353 = _1299.x * _1017;
                precise float _1354 = _1353 + (-_1351);
                precise float _1355 = _1018 * _1278.y;
                precise float _1356 = _1355 + _1349;
                precise float _1357 = _1016 * _1299.y;
                precise float _1358 = _1357 + _1354;
                precise float _1359 = _1222 * _1278.z;
                precise float _1360 = _1359 + _1356;
                precise float _1362 = _1320.x * _1017;
                precise float _1363 = _1362 + (-_1360);
                precise float _1364 = _1222 * _1299.z;
                precise float _1365 = _1364 + _1358;
                precise float _1366 = _1365 * _1021;
                precise float _1367 = _1366 + _1351;
                precise float _1368 = _1018 * _1320.y;
                precise float _1369 = _1368 + _1363;
                precise float _1370 = _1222 * _1320.z;
                precise float _1371 = _1370 + _1369;
                precise float _1372 = _1360 - _1367;
                precise float _1375 = _1371 * _1021;
                precise float _1376 = _1375 + _1372;
                precise float _1377 = _1367 - _1239;
                precise float _1379 = _1376 * _1089;
                precise float _1380 = _1379 + _1377;
                precise float _1386 = uintBitsToFloat(_158) * 8.0;
                precise float _1387 = _1386 + trunc(-_1081);
                precise float _1389 = _1380 * _1329;
                precise float _1390 = _1389 + _1239;
                vec4 _1403 = vec4(ssbo_1_3.data[((bitfieldExtract(255u & _1331, int(0u), int(24u)) * 4u) >> 2u) + buf0_dword_off], 0.0, 0.0, 0.0);
                vec4 _1411 = vec4(ssbo_1_3.data[((bitfieldExtract(255u & _1332, int(0u), int(24u)) * 4u) >> 2u) + buf0_dword_off], 0.0, 0.0, 0.0);
                vec4 _1419 = vec4(ssbo_1_3.data[((bitfieldExtract(255u & (_1331 + 1u), int(0u), int(24u)) * 4u) >> 2u) + buf0_dword_off], 0.0, 0.0, 0.0);
                vec4 _1427 = vec4(ssbo_1_3.data[((bitfieldExtract(255u & (_1332 + 1u), int(0u), int(24u)) * 4u) >> 2u) + buf0_dword_off], 0.0, 0.0, 0.0);
                precise float _1431 = (-1.0) + _538;
                precise float _1433 = _1387 * _1387;
                precise float _1435 = _1433 * _1387;
                precise float _1436 = _1435 * fma(fma(_217, _1387, -15.0), _1387, 10.0);
                precise float _1438 = _1337 * _1337;
                precise float _1440 = _1438 * _1337;
                precise float _1441 = _1440 * fma(fma(_217, _1337, -15.0), _1337, 10.0);
                precise float _1443 = _1390 * 0.125;
                precise float _1444 = _1443 + _1086;
                precise float _1445 = (-1.0) + _1387;
                precise float _1448 = uintBitsToFloat(srt_flatbuf_1.data[24u]) * uintBitsToFloat(_158);
                _1449 = floatBitsToUint(_1448);
                uint _1450 = floatBitsToUint(vec4(_1403.x, _1403.y, _1403.z, _1403.x).x) + _1328;
                uint _1452 = floatBitsToUint(vec4(_1411.x, _1411.y, _1411.z, _1411.x).x) + _1328;
                uint _1454 = bitfieldExtract(15u & _1450, int(0u), int(24u)) * 12u;
                uint _1458 = bitfieldExtract(15u & _1452, int(0u), int(24u)) * 12u;
                uint _1460 = floatBitsToUint(vec4(_1419.x, _1419.y, _1419.z, _1419.x).x) + _1328;
                uint _1466 = bitfieldExtract(15u & _1460, int(0u), int(24u)) * 12u;
                uint _1468 = floatBitsToUint(vec4(_1427.x, _1427.y, _1427.z, _1427.x).x) + _1328;
                uint _1471 = bitfieldExtract(15u & _1468, int(0u), int(24u)) * 12u;
                uint _1473 = bitfieldExtract(15u & (_1450 + 1u), int(0u), int(24u)) * 12u;
                uint _1475 = bitfieldExtract(15u & (_1460 + 1u), int(0u), int(24u)) * 12u;
                uint _1477 = bitfieldExtract(15u & (_1452 + 1u), int(0u), int(24u)) * 12u;
                uint _1481 = ((_1454 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _1494 = vec4(vec3(ssbo_1_3.data[_1481], ssbo_1_3.data[_1481 + 1u], ssbo_1_3.data[_1481 + 2u]), 0.0);
                vec4 _1495 = vec4(_1494.x, _1494.y, _1494.z, _1494.w);
                uint _1502 = ((_1458 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _1515 = vec4(vec3(ssbo_1_3.data[_1502], ssbo_1_3.data[_1502 + 1u], ssbo_1_3.data[_1502 + 2u]), 0.0);
                vec4 _1516 = vec4(_1515.x, _1515.y, _1515.z, _1515.w);
                uint _1523 = ((_1466 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _1536 = vec4(vec3(ssbo_1_3.data[_1523], ssbo_1_3.data[_1523 + 1u], ssbo_1_3.data[_1523 + 2u]), 0.0);
                vec4 _1537 = vec4(_1536.x, _1536.y, _1536.z, _1536.w);
                uint _1544 = bitfieldExtract(15u & (_1468 + 1u), int(0u), int(24u)) * 12u;
                precise float _1545 = _1495.x * _538;
                precise float _1546 = _1387 * _1495.y;
                precise float _1547 = _1546 + _1545;
                precise float _1548 = _1495.z * _1337;
                precise float _1549 = _1548 + _1547;
                precise float _1551 = _1516.x * _1431;
                precise float _1552 = _1551 + (-_1549);
                precise float _1553 = _1387 * _1516.y;
                precise float _1554 = _1553 + _1552;
                precise float _1555 = _1337 * _1516.z;
                precise float _1556 = _1555 + _1554;
                precise float _1557 = _1537.x * _538;
                precise float _1558 = _1537.y * _1445;
                precise float _1559 = _1558 + _1557;
                precise float _1560 = _1337 * _1537.z;
                precise float _1561 = _1560 + _1559;
                precise float _1562 = _1556 * _1340;
                precise float _1563 = _1562 + _1549;
                uint _1567 = ((_1471 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _1580 = vec4(vec3(ssbo_1_3.data[_1567], ssbo_1_3.data[_1567 + 1u], ssbo_1_3.data[_1567 + 2u]), 0.0);
                vec4 _1581 = vec4(_1580.x, _1580.y, _1580.z, _1580.w);
                uint _1588 = ((_1473 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _1601 = vec4(vec3(ssbo_1_3.data[_1588], ssbo_1_3.data[_1588 + 1u], ssbo_1_3.data[_1588 + 2u]), 0.0);
                vec4 _1602 = vec4(_1601.x, _1601.y, _1601.z, _1601.w);
                precise float _1606 = _1561 - _1563;
                precise float _1608 = _1581.x * _1431;
                precise float _1609 = _1608 + (-_1561);
                precise float _1610 = _1445 * _1581.y;
                precise float _1611 = _1610 + _1609;
                precise float _1612 = _1337 * _1581.z;
                precise float _1613 = _1612 + _1611;
                precise float _1614 = _1613 * _1340;
                precise float _1615 = _1614 + _1606;
                precise float _1616 = _1602.x * _538;
                precise float _1617 = _1602.y * _1387;
                precise float _1618 = _1617 + _1616;
                precise float _1619 = _1341 * _1602.z;
                precise float _1620 = _1619 + _1618;
                precise float _1621 = _1436 * _1615;
                precise float _1622 = _1621 + _1563;
                uint _1626 = ((_1475 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _1639 = vec4(vec3(ssbo_1_3.data[_1626], ssbo_1_3.data[_1626 + 1u], ssbo_1_3.data[_1626 + 2u]), 0.0);
                vec4 _1640 = vec4(_1639.x, _1639.y, _1639.z, _1639.w);
                uint _1647 = ((_1477 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _1660 = vec4(vec3(ssbo_1_3.data[_1647], ssbo_1_3.data[_1647 + 1u], ssbo_1_3.data[_1647 + 2u]), 0.0);
                vec4 _1661 = vec4(_1660.x, _1660.y, _1660.z, _1660.w);
                uint _1668 = ((_1544 + 1024u) >> 2u) + buf0_dword_off;
                vec4 _1681 = vec4(vec3(ssbo_1_3.data[_1668], ssbo_1_3.data[_1668 + 1u], ssbo_1_3.data[_1668 + 2u]), 0.0);
                vec4 _1682 = vec4(_1681.x, _1681.y, _1681.z, _1681.w);
                precise float _1686 = _1640.x * _538;
                precise float _1688 = _1661.x * _1431;
                precise float _1689 = _1688 + (-_1620);
                precise float _1690 = _1445 * _1640.y;
                precise float _1691 = _1690 + _1686;
                precise float _1692 = _1341 * _1640.z;
                precise float _1693 = _1692 + _1691;
                precise float _1694 = _1387 * _1661.y;
                precise float _1695 = _1694 + _1689;
                precise float _1697 = _1682.x * _1431;
                precise float _1698 = _1697 + (-_1693);
                precise float _1699 = _1341 * _1661.z;
                precise float _1700 = _1699 + _1695;
                precise float _1701 = _1445 * _1682.y;
                precise float _1702 = _1701 + _1698;
                precise float _1703 = _1700 * _1340;
                precise float _1704 = _1703 + _1620;
                precise float _1705 = _1341 * _1682.z;
                precise float _1706 = _1705 + _1702;
                precise float _1707 = _1693 - _1704;
                precise float _1708 = _1706 * _1340;
                precise float _1709 = _1708 + _1707;
                precise float _1710 = _1704 - _1622;
                precise float _1711 = _1709 * _1436;
                precise float _1712 = _1711 + _1710;
                precise float _1713 = _1712 * _1441;
                precise float _1714 = _1713 + _1622;
                precise float _1716 = _1714 * 0.0625;
                precise float _1717 = _1716 + _1444;
                _1718 = floatBitsToUint(_1717);
                if (true)
                {
                    _157 = _1718;
                    _158 = _1449;
                    _159 = _1345;
                    _160 = _542;
                    _161 = _258;
                    continue;
                }
                else
                {
                    _1719 = _1718;
                    break;
                }
            }
        }
        uint _1720 = _137 + 1u;
        uint _1723 = _137 + 4294967295u;
        uint _1727 = _136 + 1u;
        uint _1730 = _136 + 4294967295u;
        float _1733 = (int(0u) > int(_1720)) ? uintBitsToFloat(_135 + _1720) : uintBitsToFloat(_1720);
        uint _1734 = floatBitsToUint(_1733);
        float _1739 = (int(0u) > int(_136)) ? uintBitsToFloat(_132 + _136) : uintBitsToFloat(_136);
        uint _1740 = floatBitsToUint(_1739);
        float _1743 = (int(0u) > int(_1723)) ? uintBitsToFloat(_135 + _1723) : uintBitsToFloat(_1723);
        uint _1744 = floatBitsToUint(_1743);
        float _1749 = (int(0u) > int(_137)) ? uintBitsToFloat(_135 + _137) : uintBitsToFloat(_137);
        uint _1750 = floatBitsToUint(_1749);
        float _1758 = (int(0u) > int(_1727)) ? uintBitsToFloat(_132 + _1727) : uintBitsToFloat(_1727);
        uint _1759 = floatBitsToUint(_1758);
        float _1764 = (int(0u) > int(_1730)) ? uintBitsToFloat(_132 + _1730) : uintBitsToFloat(_1730);
        uint _1765 = floatBitsToUint(_1764);
        uint _1785 = floatBitsToUint((int(_132) <= int(_1740)) ? uintBitsToFloat(_1740 - _132) : _1739);
        uint _1790 = _132 * floatBitsToUint((int(_135) <= int(_1750)) ? uintBitsToFloat(_1750 - _135) : _1749);
        uint _1803 = srt_flatbuf_1.data[35u];
        uint _1809 = _136 + (_132 * _137);
        uint _1810 = _1809 + buf1_dword_off;
        uint _1813 = _1809 + buf2_dword_off;
        precise float _1834 = uintBitsToFloat(srt_flatbuf_1.data[22u]) * (1.0 / float(int(srt_flatbuf_1.data[23u])));
        precise float _1836 = _1834 * uintBitsToFloat(_1719);
        precise float _1845 = 1.0 + clamp(_1836, 0.0, 1.0);
        precise float _1851 = uintBitsToFloat(srt_flatbuf_1.data[20u]) * _1845;
        precise float _1853 = uintBitsToFloat(srt_flatbuf_1.data[21u]) * _1845;
        precise float _1856 = (-9.80000019073486328125) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
        precise float _1859 = 0.5 * _1851;
        precise float _1860 = _1859 + (-uintBitsToFloat(ssbo_2_1.data[_1810]));
        precise float _1863 = 0.5 * _1853;
        precise float _1864 = _1863 + (-uintBitsToFloat(ssbo_3_1.data[_1813]));
        precise float _1867 = uintBitsToFloat(srt_flatbuf_1.data[18u]) * _1860;
        precise float _1868 = _1867 + uintBitsToFloat(ssbo_2_1.data[_1810]);
        precise float _1871 = uintBitsToFloat(ssbo_4_1.data[(floatBitsToUint((int(_132) <= int(_1759)) ? uintBitsToFloat(_1759 - _132) : _1758) + _1790) + buf3_dword_off]) - uintBitsToFloat(ssbo_4_1.data[(floatBitsToUint((int(_132) <= int(_1765)) ? uintBitsToFloat(_1765 - _132) : _1764) + _1790) + buf3_dword_off]);
        precise float _1872 = _1871 * 0.5;
        precise float _1875 = uintBitsToFloat(ssbo_4_1.data[(_1785 + (_132 * floatBitsToUint((int(_135) <= int(_1734)) ? uintBitsToFloat(_1734 - _135) : _1733))) + buf3_dword_off]) - uintBitsToFloat(ssbo_4_1.data[(_1785 + (_132 * floatBitsToUint((int(_135) <= int(_1744)) ? uintBitsToFloat(_1744 - _135) : _1743))) + buf3_dword_off]);
        precise float _1876 = _1875 * 0.5;
        precise float _1879 = uintBitsToFloat(srt_flatbuf_1.data[18u]) * _1864;
        precise float _1880 = _1879 + uintBitsToFloat(ssbo_3_1.data[_1813]);
        precise float _1881 = _1872 * _1856;
        precise float _1882 = _1881 + _1868;
        if (_141 && (srt_flatbuf_1.data[31u] > _1809))
        {
            ssbo_2_1.data[_1809 + buf1_dword_off] = floatBitsToUint(_1882);
        }
        precise float _1888 = _1876 * _1856;
        precise float _1889 = _1888 + _1880;
        if (_141 && (_1803 > _1809))
        {
            ssbo_3_1.data[_1809 + buf2_dword_off] = floatBitsToUint(_1889);
        }
    }
}

