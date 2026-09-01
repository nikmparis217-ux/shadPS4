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
#extension GL_EXT_shader_image_load_formatted : require
layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

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

layout(binding = 1, std430) readonly buffer ssbo_2
{
    uint data[];
} ssbo_2_1;

layout(binding = 2, std430) readonly buffer srt_flatbuf
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

layout(binding = 5) uniform image2DArray cs_img58;
layout(binding = 6) uniform writeonly image2DArray cs_img32;
uniform sampler2DArray SPIRV_Cross_Combinedcs_img40cs_sampinline_0xfff00000000036_0x2500000;
uniform sampler2DArray SPIRV_Cross_Combinedcs_img24cs_sampinline_0xfff00000000036_0x2500000;

void main()
{
    uint buf0_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(0u), int(8u)) >> 2u;
    uint buf1_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(8u), int(8u)) >> 2u;
    uint _133 = (gl_WorkGroupID.x << 3u) + gl_LocalInvocationID.x;
    uint _134 = (gl_WorkGroupID.y << 3u) + gl_LocalInvocationID.y;
    bool _142 = srt_flatbuf_1.data[67u] > max(_133, _134);
    if (_142)
    {
        uint _145 = gl_WorkGroupID.z * 12u;
        precise float _158 = 0.5 + float(_133);
        precise float _172 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _158;
        precise float _173 = 0.5 + float(_134);
        float _189 = 1.0 / float(srt_flatbuf_1.data[67u]);
        precise float _191 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _158;
        precise float _199 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _173;
        precise float _200 = _199 + _172;
        precise float _202 = _189 * _200;
        precise float _203 = _202 + uintBitsToFloat(srt_flatbuf_1.data[0u]);
        precise float _205 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _158;
        precise float _211 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _173;
        precise float _212 = _211 + _191;
        precise float _213 = _203 * _203;
        precise float _215 = _189 * _212;
        precise float _216 = _215 + uintBitsToFloat(srt_flatbuf_1.data[0u]);
        precise float _218 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _173;
        precise float _219 = _218 + _205;
        precise float _221 = _189 * _219;
        precise float _222 = _221 + uintBitsToFloat(srt_flatbuf_1.data[0u]);
        precise float _223 = _216 * _216;
        precise float _224 = _223 + _213;
        precise float _242 = _222 * _222;
        precise float _243 = _242 + _224;
        float _244 = inversesqrt(_243);
        precise float _245 = _244 * _203;
        precise float _246 = _244 * _216;
        precise float _247 = _244 * _222;
        precise float _255 = uintBitsToFloat(srt_flatbuf_1.data[51u]) * _245;
        precise float _256 = _255 + uintBitsToFloat(srt_flatbuf_1.data[48u]);
        precise float _259 = uintBitsToFloat(srt_flatbuf_1.data[51u]) * _246;
        precise float _260 = _259 + uintBitsToFloat(srt_flatbuf_1.data[49u]);
        precise float _263 = uintBitsToFloat(srt_flatbuf_1.data[51u]) * _247;
        precise float _264 = _263 + uintBitsToFloat(srt_flatbuf_1.data[50u]);
        uint _491;
        uint _488;
        uint _489;
        uint _490;
        uint _492;
        uint _493;
        uint _494;
        uint _265 = 0u;
        uint _266 = 0u;
        uint _267 = 0u;
        uint _268 = 0u;
        for (;;)
        {
            if (!(int(_268) < int(srt_flatbuf_1.data[52u])))
            {
                _492 = _265;
                _493 = _266;
                _494 = _267;
                break;
            }
            else
            {
                uint _272 = _268 << 6u;
                uint _273 = _272 >> 2u;
                uint _274 = _273 + buf0_dword_off;
                uint _278 = (_273 + 1u) + buf0_dword_off;
                precise float _283 = uintBitsToFloat(ssbo_1_1.data[_274]) - _256;
                uint _285 = ((_272 + 8u) >> 2u) + buf0_dword_off;
                precise float _288 = _245 * _283;
                precise float _290 = uintBitsToFloat(ssbo_1_1.data[_278]) - _260;
                precise float _292 = uintBitsToFloat(ssbo_1_1.data[_285]) - _264;
                uint _293 = floatBitsToUint(_292);
                precise float _294 = _290 * _246;
                precise float _295 = _294 + _288;
                precise float _296 = _292 * _247;
                precise float _297 = _296 + _295;
                bool _299 = _142 && (_297 > 0.0);
                uint _487;
                if (_299)
                {
                    precise float _300 = _283 * _283;
                    precise float _307 = _290 * _290;
                    precise float _308 = _307 + _300;
                    precise float _309 = _292 * _292;
                    precise float _310 = _309 + _308;
                    precise float _312 = uintBitsToFloat(ssbo_1_1.data[(((_268 << 6u) + 12u) >> 2u) + buf0_dword_off]) * _310;
                    uint _483;
                    uint _484;
                    uint _485;
                    uint _486;
                    if (_299 && (_312 <= 1.0))
                    {
                        precise float _317 = uintBitsToFloat(ssbo_1_1.data[_274]) - uintBitsToFloat(srt_flatbuf_1.data[48u]);
                        precise float _320 = uintBitsToFloat(ssbo_1_1.data[_278]) - uintBitsToFloat(srt_flatbuf_1.data[49u]);
                        precise float _323 = uintBitsToFloat(ssbo_1_1.data[_285]) - uintBitsToFloat(srt_flatbuf_1.data[50u]);
                        precise float _325 = _317 * 2.0;
                        precise float _326 = _320 * 2.0;
                        precise float _327 = _323 * 2.0;
                        float _328 = abs(_317);
                        float _329 = abs(_320);
                        float _330 = abs(_323);
                        float _338 = 1.0 / abs(((_330 >= _328) && (_330 >= _329)) ? _327 : ((_329 >= _328) ? _326 : _325));
                        float _345 = abs(_317);
                        float _346 = abs(_320);
                        float _347 = abs(_323);
                        float _355 = -_320;
                        float _358 = abs(_317);
                        float _359 = abs(_320);
                        float _360 = abs(_323);
                        float _379 = abs(_317);
                        float _380 = abs(_320);
                        float _381 = abs(_323);
                        float _387 = ((_381 >= _379) && (_381 >= _380)) ? ((_323 < 0.0) ? 5.0 : 4.0) : ((_380 >= _379) ? ((_320 < 0.0) ? 3.0 : 2.0) : float(_317 < 0.0));
                        precise float _388 = fma(((_347 >= _345) && (_347 >= _346)) ? ((_323 < 0.0) ? (-_317) : _317) : ((_346 >= _345) ? _317 : ((_317 < 0.0) ? _323 : (-_323))), _338, 1.5) - 1.0;
                        precise float _389 = fma(((_360 >= _358) && (_360 >= _359)) ? _355 : ((_359 >= _358) ? ((_320 < 0.0) ? (-_323) : _323) : _355), _338, 1.5) - 1.0;
                        precise float _391 = _387 / 8.0;
                        precise float _410 = _317 * _317;
                        precise float _416 = _320 * _320;
                        precise float _417 = _416 + _410;
                        precise float _423 = _323 * _323;
                        precise float _424 = _423 + _417;
                        float _425 = sqrt(_424);
                        precise float _428 = uintBitsToFloat(srt_flatbuf_1.data[54u]) * textureLod(SPIRV_Cross_Combinedcs_img40cs_sampinline_0xfff00000000036_0x2500000, vec3(_388, _389, fma(floor(_391), -2.0, _387)), 0.0).x;
                        precise float _429 = _428 + uintBitsToFloat(srt_flatbuf_1.data[55u]);
                        precise float _431 = _429 * max(abs(_323), max(abs(_317), abs(_320)));
                        precise float _434 = (1.0 / _431) * _425;
                        precise float _435 = _434 + uintBitsToFloat(srt_flatbuf_1.data[56u]);
                        uint _479;
                        uint _480;
                        uint _481;
                        uint _482;
                        if (!(_425 >= _435))
                        {
                            precise float _439 = _312 * (-_312);
                            precise float _440 = _439 + 1.0;
                            float _441 = clamp(_440, 0.0, 1.0);
                            uint _442 = _268 << 6u;
                            precise float _443 = _441 * _441;
                            precise float _446 = _443 * inversesqrt(_310);
                            float _447 = 1.0 / _310;
                            precise float _450 = _446 * _447;
                            uint _451 = (_442 + 48u) >> 2u;
                            precise float _463 = _450 * _297;
                            precise float _466 = uintBitsToFloat(ssbo_1_1.data[_451 + buf0_dword_off]) * _463;
                            precise float _467 = _466 + uintBitsToFloat(_265);
                            precise float _471 = uintBitsToFloat(ssbo_1_1.data[(_451 + 1u) + buf0_dword_off]) * _463;
                            precise float _472 = _471 + uintBitsToFloat(_267);
                            precise float _476 = uintBitsToFloat(ssbo_1_1.data[((_442 + 56u) >> 2u) + buf0_dword_off]) * _463;
                            precise float _477 = _476 + uintBitsToFloat(_266);
                            _479 = floatBitsToUint(_447);
                            _480 = floatBitsToUint(_467);
                            _481 = floatBitsToUint(_477);
                            _482 = floatBitsToUint(_472);
                        }
                        else
                        {
                            _479 = floatBitsToUint(_429);
                            _480 = _265;
                            _481 = _266;
                            _482 = _267;
                        }
                        _483 = _479;
                        _484 = _480;
                        _485 = _481;
                        _486 = _482;
                    }
                    else
                    {
                        _483 = _293;
                        _484 = _265;
                        _485 = _266;
                        _486 = _267;
                    }
                    _487 = _483;
                    _488 = _484;
                    _489 = _485;
                    _490 = _486;
                }
                else
                {
                    _487 = _293;
                    _488 = _265;
                    _489 = _266;
                    _490 = _267;
                }
                _491 = _268 + 1u;
                if (true)
                {
                    _265 = _488;
                    _266 = _489;
                    _267 = _490;
                    _268 = _491;
                    continue;
                }
                else
                {
                    _492 = _488;
                    _493 = _489;
                    _494 = _490;
                    break;
                }
            }
        }
        uint _861;
        uint _858;
        uint _859;
        uint _860;
        uint _862;
        uint _863;
        uint _864;
        uint _500 = _492;
        uint _501 = _493;
        uint _502 = _494;
        uint _503 = 0u;
        for (;;)
        {
            if (!(int(_503) < int(srt_flatbuf_1.data[53u])))
            {
                _862 = _501;
                _863 = _502;
                _864 = _500;
                break;
            }
            else
            {
                uint _507 = _503 << 7u;
                uint _508 = _507 >> 2u;
                uint _509 = _508 + buf1_dword_off;
                uint _513 = (_508 + 1u) + buf1_dword_off;
                precise float _518 = uintBitsToFloat(ssbo_2_1.data[_509]) - _256;
                uint _520 = ((_507 + 8u) >> 2u) + buf1_dword_off;
                precise float _523 = _245 * _518;
                precise float _525 = uintBitsToFloat(ssbo_2_1.data[_513]) - _260;
                precise float _527 = uintBitsToFloat(ssbo_2_1.data[_520]) - _264;
                uint _528 = floatBitsToUint(_527);
                precise float _529 = _525 * _246;
                precise float _530 = _529 + _523;
                precise float _531 = _527 * _247;
                precise float _532 = _531 + _530;
                bool _534 = _142 && (_532 > 0.0);
                uint _857;
                if (_534)
                {
                    precise float _535 = _518 * _518;
                    precise float _542 = _525 * _525;
                    precise float _543 = _542 + _535;
                    precise float _544 = _527 * _527;
                    precise float _545 = _544 + _543;
                    precise float _547 = uintBitsToFloat(ssbo_2_1.data[(((_503 << 7u) + 12u) >> 2u) + buf1_dword_off]) * _545;
                    bool _549 = _534 && (_547 <= 1.0);
                    uint _853;
                    uint _854;
                    uint _855;
                    uint _856;
                    if (_549)
                    {
                        uint _553 = ((_503 << 7u) + 64u) >> 2u;
                        precise float _625 = uintBitsToFloat(ssbo_2_1.data[(_553 + 3u) + buf1_dword_off]) * _256;
                        precise float _626 = _625 + uintBitsToFloat(ssbo_2_1.data[(_553 + 15u) + buf1_dword_off]);
                        precise float _629 = uintBitsToFloat(ssbo_2_1.data[(_553 + 2u) + buf1_dword_off]) * _256;
                        precise float _630 = _629 + uintBitsToFloat(ssbo_2_1.data[(_553 + 14u) + buf1_dword_off]);
                        precise float _633 = uintBitsToFloat(ssbo_2_1.data[(_553 + 7u) + buf1_dword_off]) * _260;
                        precise float _634 = _633 + _626;
                        precise float _636 = uintBitsToFloat(ssbo_2_1.data[(_553 + 6u) + buf1_dword_off]) * _260;
                        precise float _637 = _636 + _630;
                        precise float _639 = uintBitsToFloat(ssbo_2_1.data[(_553 + 11u) + buf1_dword_off]) * _264;
                        precise float _640 = _639 + _634;
                        precise float _642 = uintBitsToFloat(ssbo_2_1.data[(_553 + 10u) + buf1_dword_off]) * _264;
                        precise float _643 = _642 + _637;
                        uint _849;
                        uint _850;
                        uint _851;
                        uint _852;
                        if (_549 && (!((0.0 > _640) || (_643 < (-_640)))))
                        {
                            precise float _652 = uintBitsToFloat(ssbo_2_1.data[_509]) - uintBitsToFloat(srt_flatbuf_1.data[48u]);
                            precise float _655 = uintBitsToFloat(ssbo_2_1.data[_513]) - uintBitsToFloat(srt_flatbuf_1.data[49u]);
                            precise float _658 = uintBitsToFloat(ssbo_2_1.data[_520]) - uintBitsToFloat(srt_flatbuf_1.data[50u]);
                            precise float _659 = _652 * 2.0;
                            precise float _660 = _655 * 2.0;
                            precise float _661 = _658 * 2.0;
                            float _662 = abs(_652);
                            float _663 = abs(_655);
                            float _664 = abs(_658);
                            float _672 = 1.0 / abs(((_664 >= _662) && (_664 >= _663)) ? _661 : ((_663 >= _662) ? _660 : _659));
                            float _679 = abs(_652);
                            float _680 = abs(_655);
                            float _681 = abs(_658);
                            float _689 = -_655;
                            float _692 = abs(_652);
                            float _693 = abs(_655);
                            float _694 = abs(_658);
                            float _709 = abs(_652);
                            float _710 = abs(_655);
                            float _711 = abs(_658);
                            float _717 = ((_711 >= _709) && (_711 >= _710)) ? ((_658 < 0.0) ? 5.0 : 4.0) : ((_710 >= _709) ? ((_655 < 0.0) ? 3.0 : 2.0) : float(_652 < 0.0));
                            precise float _718 = fma(((_681 >= _679) && (_681 >= _680)) ? ((_658 < 0.0) ? (-_652) : _652) : ((_680 >= _679) ? _652 : ((_652 < 0.0) ? _658 : (-_658))), _672, 1.5) - 1.0;
                            precise float _719 = fma(((_694 >= _692) && (_694 >= _693)) ? _689 : ((_693 >= _692) ? ((_655 < 0.0) ? (-_658) : _658) : _689), _672, 1.5) - 1.0;
                            precise float _720 = _717 / 8.0;
                            precise float _734 = _652 * _652;
                            precise float _740 = _655 * _655;
                            precise float _741 = _740 + _734;
                            precise float _745 = _658 * _658;
                            precise float _746 = _745 + _741;
                            float _747 = sqrt(_746);
                            precise float _750 = uintBitsToFloat(srt_flatbuf_1.data[54u]) * textureLod(SPIRV_Cross_Combinedcs_img40cs_sampinline_0xfff00000000036_0x2500000, vec3(_718, _719, fma(floor(_720), -2.0, _717)), 0.0).x;
                            precise float _751 = _750 + uintBitsToFloat(srt_flatbuf_1.data[55u]);
                            precise float _753 = _751 * max(abs(_658), max(abs(_652), abs(_655)));
                            precise float _756 = (1.0 / _753) * _747;
                            precise float _757 = _756 + uintBitsToFloat(srt_flatbuf_1.data[56u]);
                            uint _845;
                            uint _846;
                            uint _847;
                            uint _848;
                            if (!(_747 >= _757))
                            {
                                precise float _761 = _547 * (-_547);
                                precise float _762 = _761 + 1.0;
                                float _763 = clamp(_762, 0.0, 1.0);
                                uint _764 = _503 << 7u;
                                precise float _767 = uintBitsToFloat(ssbo_2_1.data[(_553 + 1u) + buf1_dword_off]) * _256;
                                precise float _768 = _767 + uintBitsToFloat(ssbo_2_1.data[(_553 + 13u) + buf1_dword_off]);
                                precise float _770 = uintBitsToFloat(ssbo_2_1.data[(_553 + 5u) + buf1_dword_off]) * _260;
                                precise float _771 = _770 + _768;
                                precise float _773 = (1.0 / _640) * 0.5;
                                precise float _775 = uintBitsToFloat(ssbo_2_1.data[(_553 + 9u) + buf1_dword_off]) * _264;
                                precise float _776 = _775 + _771;
                                precise float _777 = _763 * _763;
                                precise float _780 = uintBitsToFloat(ssbo_2_1.data[_553 + buf1_dword_off]) * _256;
                                precise float _781 = _780 + uintBitsToFloat(ssbo_2_1.data[(_553 + 12u) + buf1_dword_off]);
                                precise float _789 = uintBitsToFloat(ssbo_2_1.data[(_553 + 4u) + buf1_dword_off]) * _260;
                                precise float _790 = _789 + _781;
                                precise float _792 = uintBitsToFloat(ssbo_2_1.data[(_553 + 8u) + buf1_dword_off]) * _264;
                                precise float _793 = _792 + _790;
                                precise float _794 = _793 * _773;
                                precise float _795 = _794 + 0.5;
                                precise float _796 = _776 * _773;
                                precise float _797 = _796 + 0.5;
                                vec4 _803 = textureLod(SPIRV_Cross_Combinedcs_img24cs_sampinline_0xfff00000000036_0x2500000, vec3(_795, _797, float(int(ssbo_2_1.data[((_764 + 60u) >> 2u) + buf1_dword_off]))), 0.0);
                                uint _810 = (_764 + 48u) >> 2u;
                                precise float _818 = _777 * inversesqrt(_545);
                                precise float _824 = _818 * (1.0 / _545);
                                precise float _825 = _824 * _532;
                                precise float _827 = uintBitsToFloat(ssbo_2_1.data[_810 + buf1_dword_off]) * _803.x;
                                precise float _829 = uintBitsToFloat(ssbo_2_1.data[(_810 + 1u) + buf1_dword_off]) * _803.y;
                                precise float _832 = uintBitsToFloat(ssbo_2_1.data[((_764 + 56u) >> 2u) + buf1_dword_off]) * _803.z;
                                precise float _834 = _825 * _827;
                                precise float _835 = _834 + uintBitsToFloat(_500);
                                precise float _838 = _825 * _832;
                                precise float _839 = _838 + uintBitsToFloat(_501);
                                precise float _842 = _825 * _829;
                                precise float _843 = _842 + uintBitsToFloat(_502);
                                _845 = floatBitsToUint(_829);
                                _846 = floatBitsToUint(_835);
                                _847 = floatBitsToUint(_839);
                                _848 = floatBitsToUint(_843);
                            }
                            else
                            {
                                _845 = floatBitsToUint(_751);
                                _846 = _500;
                                _847 = _501;
                                _848 = _502;
                            }
                            _849 = _845;
                            _850 = _846;
                            _851 = _847;
                            _852 = _848;
                        }
                        else
                        {
                            _849 = floatBitsToUint(_630);
                            _850 = _500;
                            _851 = _501;
                            _852 = _502;
                        }
                        _853 = _849;
                        _854 = _850;
                        _855 = _851;
                        _856 = _852;
                    }
                    else
                    {
                        _853 = _528;
                        _854 = _500;
                        _855 = _501;
                        _856 = _502;
                    }
                    _857 = _853;
                    _858 = _854;
                    _859 = _855;
                    _860 = _856;
                }
                else
                {
                    _857 = _528;
                    _858 = _500;
                    _859 = _501;
                    _860 = _502;
                }
                _861 = _503 + 1u;
                if (true)
                {
                    _500 = _858;
                    _501 = _859;
                    _502 = _860;
                    _503 = _861;
                    continue;
                }
                else
                {
                    _862 = _859;
                    _863 = _860;
                    _864 = _858;
                    break;
                }
            }
        }
        uint _875 = gl_WorkGroupID.z + (srt_flatbuf_1.data[66u] * 6u);
        vec4 _878 = imageLoad(cs_img58, ivec3(uvec3(_133, _134, _875)));
        vec4 _880 = vec4(_878.x, _878.y, _878.z, vec4(0.0, 1.0, 0.0, 0.0).y);
        precise float _886 = uintBitsToFloat(srt_flatbuf_1.data[57u]) * uintBitsToFloat(_864);
        precise float _889 = uintBitsToFloat(srt_flatbuf_1.data[57u]) * uintBitsToFloat(_863);
        precise float _892 = uintBitsToFloat(srt_flatbuf_1.data[57u]) * uintBitsToFloat(_862);
        precise float _895 = uintBitsToFloat(srt_flatbuf_1.data[57u]) * uintBitsToFloat(_864);
        precise float _896 = _895 + _880.x;
        precise float _899 = uintBitsToFloat(srt_flatbuf_1.data[57u]) * uintBitsToFloat(_862);
        precise float _900 = _899 + _880.z;
        precise float _903 = uintBitsToFloat(srt_flatbuf_1.data[57u]) * uintBitsToFloat(_863);
        precise float _904 = _903 + _880.y;
        vec4 _905 = vec4(_896, _904, _900, 0.0);
        imageStore(cs_img58, ivec3(uvec3(_133, _134, _875)), vec4(_905.x, _905.y, _905.z, vec4(0.0, 1.0, 0.0, 0.0).x));
        vec4 _909 = vec4(_886, _889, _892, 0.0);
        imageStore(cs_img32, ivec3(uvec3(_133, _134, gl_WorkGroupID.z)), vec4(_909.x, _909.y, _909.z, vec4(0.0, 1.0, 0.0, 0.0).x));
    }
}

