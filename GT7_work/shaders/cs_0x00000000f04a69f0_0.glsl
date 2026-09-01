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
layout(local_size_x = 4, local_size_y = 4, local_size_z = 4) in;

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

layout(binding = 1) uniform writeonly image3D cs_img0;

void main()
{
    uint buf0_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(0u), int(8u)) >> 2u;
    uint _230 = 4u + buf0_dword_off;
    uint _234 = 5u + buf0_dword_off;
    uint _236 = ssbo_1_1.data[_234];
    uint _240 = ssbo_1_1.data[6u + buf0_dword_off];
    uint _247 = (gl_WorkGroupID.x << 2u) + gl_LocalInvocationID.x;
    precise float _249 = (-1.0) + float(ssbo_1_1.data[0u + buf0_dword_off]);
    precise float _253 = float(_247) * (1.0 / _249);
    precise float _258 = _253 * _253;
    uint _259 = (gl_WorkGroupID.y << 2u) + gl_LocalInvocationID.y;
    precise float _260 = (-1.0) + float(ssbo_1_1.data[1u + buf0_dword_off]);
    uint _261 = (gl_WorkGroupID.z << 2u) + gl_LocalInvocationID.z;
    precise float _262 = (-1.0) + float(ssbo_1_1.data[2u + buf0_dword_off]);
    precise float _263 = _258 * _258;
    uint _269 = 12u + buf0_dword_off;
    uint _273 = 13u + buf0_dword_off;
    uint _277 = 14u + buf0_dword_off;
    precise float _281 = uintBitsToFloat(ssbo_1_1.data[_230]) * _263;
    precise float _283 = float(_259) * (1.0 / _260);
    precise float _284 = float(_261) * (1.0 / _262);
    precise float _285 = _283 * _283;
    precise float _286 = _284 * _284;
    precise float _289 = _285 * _285;
    precise float _290 = _286 * _286;
    precise float _292 = uintBitsToFloat(ssbo_1_1.data[_230]) * _289;
    precise float _295 = uintBitsToFloat(ssbo_1_1.data[_230]) * _290;
    uint _306;
    if (uintBitsToFloat(ssbo_1_1.data[_269]) > _281)
    {
        precise float _301 = uintBitsToFloat(ssbo_1_1.data[_273]) * log2(abs(_281));
        precise float _304 = uintBitsToFloat(ssbo_1_1.data[_277]) * exp2(_301);
        _306 = floatBitsToUint(_304);
    }
    else
    {
        _306 = floatBitsToUint(_281);
    }
    uint _317;
    if (uintBitsToFloat(ssbo_1_1.data[_269]) > _292)
    {
        precise float _312 = uintBitsToFloat(ssbo_1_1.data[_273]) * log2(abs(_292));
        precise float _315 = uintBitsToFloat(ssbo_1_1.data[_277]) * exp2(_312);
        _317 = floatBitsToUint(_315);
    }
    else
    {
        _317 = floatBitsToUint(_292);
    }
    uint _328;
    if (uintBitsToFloat(ssbo_1_1.data[_269]) > _295)
    {
        precise float _323 = uintBitsToFloat(ssbo_1_1.data[_273]) * log2(abs(_295));
        precise float _326 = uintBitsToFloat(ssbo_1_1.data[_277]) * exp2(_323);
        _328 = floatBitsToUint(_326);
    }
    else
    {
        _328 = floatBitsToUint(_295);
    }
    bool _330 = uintBitsToFloat(_236) < 1.0;
    bool _332 = uintBitsToFloat(_240) < 1.0;
    bool _335 = uintBitsToFloat(_236) < 2.0;
    bool _338 = uintBitsToFloat(_236) < 8.0;
    bool _345 = !_330;
    uint _366;
    uint _367;
    uint _368;
    bool _369;
    if (_330)
    {
        uint _363;
        uint _364;
        uint _365;
        if (_332)
        {
            float _348 = 1.0 / uintBitsToFloat(ssbo_1_1.data[7u + buf0_dword_off]);
            precise float _350 = _348 * uintBitsToFloat(_328);
            precise float _353 = _348 * uintBitsToFloat(_317);
            precise float _356 = _348 * uintBitsToFloat(_306);
            vec4 _358 = vec4(_356, _353, _350, _348);
            imageStore(cs_img0, ivec3(uvec3(_247, _259, _261)), vec4(_358.w, _358.z, _358.y, _358.x));
            _363 = floatBitsToUint(_350);
            _364 = floatBitsToUint(_353);
            _365 = floatBitsToUint(_356);
        }
        else
        {
            _363 = _328;
            _364 = _317;
            _365 = _306;
        }
        _366 = _363;
        _367 = _364;
        _368 = _365;
        _369 = !_332;
    }
    else
    {
        _366 = _328;
        _367 = _317;
        _368 = _306;
        _369 = false;
    }
    if (_345 || _369)
    {
        if (_330)
        {
            vec4 _374 = vec4(uintBitsToFloat(_368), uintBitsToFloat(_367), uintBitsToFloat(_366), 1.0);
            imageStore(cs_img0, ivec3(uvec3(_247, _259, _261)), vec4(_374.w, _374.z, _374.y, _374.x));
        }
        if (_345)
        {
            bool _945;
            uint _946;
            uint _947;
            uint _948;
            uint _949;
            if (_335)
            {
                bool _380 = 0.0 > uintBitsToFloat(_368);
                uint _382 = 16u + buf0_dword_off;
                uint _390 = 18u + buf0_dword_off;
                uint _394 = 19u + buf0_dword_off;
                uint _398 = 20u + buf0_dword_off;
                uint _406 = 22u + buf0_dword_off;
                uint _410 = 23u + buf0_dword_off;
                precise float _415 = uintBitsToFloat(ssbo_1_1.data[_382]) * uintBitsToFloat(ssbo_1_1.data[17u + buf0_dword_off]);
                uint _423 = 24u + buf0_dword_off;
                uint _427 = 25u + buf0_dword_off;
                uint _429 = ssbo_1_1.data[_427];
                uint _431 = 26u + buf0_dword_off;
                uint _435 = 27u + buf0_dword_off;
                uint _485;
                if (!((uintBitsToFloat(_368) > _415) || _380))
                {
                    precise float _442 = (1.0 / uintBitsToFloat(ssbo_1_1.data[_406])) * uintBitsToFloat(_368);
                    precise float _445 = uintBitsToFloat(ssbo_1_1.data[_435]) * uintBitsToFloat(_368);
                    float _447 = clamp(max(0.0, _442), 0.0, 1.0);
                    precise float _450 = uintBitsToFloat(ssbo_1_1.data[_406]) + uintBitsToFloat(ssbo_1_1.data[_410]);
                    precise float _452 = (-1.44269502162933349609375) * _445;
                    precise float _459 = (-_447) * _447;
                    bool _461 = uintBitsToFloat(_368) < _450;
                    precise float _464 = uintBitsToFloat(ssbo_1_1.data[_423]) * log2(abs(_442));
                    precise float _465 = _459 * fma(-2.0, _447, 3.0);
                    precise float _466 = _465 + 1.0;
                    precise float _472 = (-uintBitsToFloat(ssbo_1_1.data[_431])) * exp2(_452);
                    precise float _473 = _472 + uintBitsToFloat(_429);
                    precise float _474 = (_461 ? 0.0 : (-1.0)) - _466;
                    precise float _477 = uintBitsToFloat(ssbo_1_1.data[_406]) * exp2(_464);
                    precise float _478 = 1.0 + _474;
                    precise float _479 = _466 * _477;
                    precise float _480 = _479 + (_461 ? 0.0 : _473);
                    precise float _482 = uintBitsToFloat(_368) * _478;
                    precise float _483 = _482 + _480;
                    _485 = floatBitsToUint(_483);
                }
                else
                {
                    _485 = floatBitsToUint(_380 ? 0.0 : uintBitsToFloat(ssbo_1_1.data[_382]));
                }
                bool _487 = 0.0 > uintBitsToFloat(_367);
                uint _538;
                if (!((uintBitsToFloat(_367) > _415) || _487))
                {
                    precise float _498 = (1.0 / uintBitsToFloat(ssbo_1_1.data[_406])) * uintBitsToFloat(_367);
                    precise float _501 = uintBitsToFloat(ssbo_1_1.data[_435]) * uintBitsToFloat(_367);
                    float _503 = clamp(max(0.0, _498), 0.0, 1.0);
                    precise float _506 = uintBitsToFloat(ssbo_1_1.data[_406]) + uintBitsToFloat(ssbo_1_1.data[_410]);
                    precise float _507 = (-1.44269502162933349609375) * _501;
                    precise float _512 = (-_503) * _503;
                    bool _514 = uintBitsToFloat(_367) < _506;
                    precise float _517 = uintBitsToFloat(ssbo_1_1.data[_423]) * log2(abs(_498));
                    precise float _518 = _512 * fma(-2.0, _503, 3.0);
                    precise float _519 = _518 + 1.0;
                    precise float _525 = (-uintBitsToFloat(ssbo_1_1.data[_431])) * exp2(_507);
                    precise float _526 = _525 + uintBitsToFloat(_429);
                    precise float _527 = (_514 ? 0.0 : (-1.0)) - _519;
                    precise float _530 = uintBitsToFloat(ssbo_1_1.data[_406]) * exp2(_517);
                    precise float _531 = 1.0 + _527;
                    precise float _532 = _519 * _530;
                    precise float _533 = _532 + (_514 ? 0.0 : _526);
                    precise float _535 = uintBitsToFloat(_367) * _531;
                    precise float _536 = _535 + _533;
                    _538 = floatBitsToUint(_536);
                }
                else
                {
                    _538 = floatBitsToUint(_487 ? 0.0 : uintBitsToFloat(ssbo_1_1.data[_382]));
                }
                bool _540 = 0.0 > uintBitsToFloat(_366);
                uint _591;
                if (!((uintBitsToFloat(_366) > _415) || _540))
                {
                    precise float _551 = (1.0 / uintBitsToFloat(ssbo_1_1.data[_406])) * uintBitsToFloat(_366);
                    precise float _554 = uintBitsToFloat(ssbo_1_1.data[_435]) * uintBitsToFloat(_366);
                    float _556 = clamp(max(0.0, _551), 0.0, 1.0);
                    precise float _559 = uintBitsToFloat(ssbo_1_1.data[_406]) + uintBitsToFloat(ssbo_1_1.data[_410]);
                    precise float _560 = (-1.44269502162933349609375) * _554;
                    precise float _565 = (-_556) * _556;
                    bool _567 = uintBitsToFloat(_366) < _559;
                    precise float _570 = uintBitsToFloat(ssbo_1_1.data[_423]) * log2(abs(_551));
                    precise float _571 = _565 * fma(-2.0, _556, 3.0);
                    precise float _572 = _571 + 1.0;
                    precise float _578 = (-uintBitsToFloat(ssbo_1_1.data[_431])) * exp2(_560);
                    precise float _579 = _578 + uintBitsToFloat(_429);
                    precise float _580 = (_567 ? 0.0 : (-1.0)) - _572;
                    precise float _583 = uintBitsToFloat(ssbo_1_1.data[_406]) * exp2(_570);
                    precise float _584 = 1.0 + _580;
                    precise float _585 = _572 * _583;
                    precise float _586 = _585 + (_567 ? 0.0 : _579);
                    precise float _588 = uintBitsToFloat(_366) * _584;
                    precise float _589 = _588 + _586;
                    _591 = floatBitsToUint(_589);
                }
                else
                {
                    _591 = floatBitsToUint(_540 ? 0.0 : uintBitsToFloat(ssbo_1_1.data[_382]));
                }
                precise float _594 = 0.412109375 * uintBitsToFloat(_368);
                precise float _597 = 0.166748046875 * uintBitsToFloat(_368);
                precise float _600 = uintBitsToFloat(_367) * 0.52392578125;
                precise float _601 = _600 + _594;
                precise float _604 = uintBitsToFloat(_367) * 0.720458984375;
                precise float _605 = _604 + _597;
                precise float _608 = uintBitsToFloat(_366) * 0.06396484375;
                precise float _609 = _608 + _601;
                precise float _612 = uintBitsToFloat(_366) * 0.11279296875;
                precise float _613 = _612 + _605;
                precise float _615 = 0.00999999977648258209228515625 * _609;
                precise float _616 = 0.00999999977648258209228515625 * _613;
                precise float _622 = 0.1593017578125 * log2(abs(_615));
                precise float _623 = 0.1593017578125 * log2(abs(_616));
                float _624 = exp2(_622);
                float _625 = exp2(_623);
                precise float _630 = 18.6875 * _624;
                precise float _631 = _630 + 1.0;
                precise float _633 = 18.6875 * _625;
                precise float _634 = _633 + 1.0;
                precise float _639 = log2(fma(18.8515625, _624, 0.8359375)) - log2(_631);
                precise float _640 = log2(fma(18.8515625, _625, 0.8359375)) - log2(_634);
                precise float _642 = 78.84375 * _639;
                precise float _643 = 78.84375 * _640;
                float _644 = exp2(_642);
                float _645 = exp2(_643);
                precise float _646 = _644 + _645;
                precise float _648 = _646 * 0.5;
                precise float _651 = 0.0126833133399486541748046875 * log2(_648);
                precise float _653 = 0.00999999977648258209228515625 * uintBitsToFloat(ssbo_1_1.data[_382]);
                precise float _658 = 0.024169921875 * uintBitsToFloat(_368);
                float _659 = exp2(_651);
                precise float _660 = 0.1593017578125 * log2(abs(_653));
                precise float _663 = uintBitsToFloat(_367) * 0.075439453125;
                precise float _664 = _663 + _658;
                float _667 = exp2(_660);
                precise float _671 = uintBitsToFloat(_366) * 0.900390625;
                precise float _672 = _671 + _664;
                precise float _674 = (-0.8359375) + _659;
                precise float _675 = 0.00999999977648258209228515625 * _672;
                precise float _676 = (1.0 / fma(-18.6875, _659, 18.8515625)) * _674;
                precise float _678 = 18.6875 * _667;
                precise float _679 = _678 + 1.0;
                precise float _686 = log2(fma(18.8515625, _667, 0.8359375)) - log2(_679);
                precise float _687 = 0.1593017578125 * log2(abs(_675));
                precise float _689 = 6.277394771575927734375 * log2(abs(_676));
                precise float _690 = 78.84375 * _686;
                float _691 = exp2(_687);
                precise float _695 = 18.6875 * _691;
                precise float _696 = _695 + 1.0;
                precise float _698 = 100.0 * exp2(_689);
                precise float _702 = uintBitsToFloat(ssbo_1_1.data[21u + buf0_dword_off]) - uintBitsToFloat(ssbo_1_1.data[_398]);
                precise float _707 = _648 * (1.0 / exp2(_690));
                precise float _708 = _707 + (-uintBitsToFloat(ssbo_1_1.data[_398]));
                precise float _710 = log2(fma(18.8515625, _691, 0.8359375)) - log2(_696);
                precise float _712 = (1.0 / _702) * _708;
                float _713 = clamp(_712, 0.0, 1.0);
                precise float _715 = 1.61376953125 * _644;
                precise float _716 = 78.84375 * _710;
                precise float _718 = 4.378173828125 * _644;
                precise float _721 = (-_713) * _713;
                precise float _723 = _645 * (-3.323486328125);
                precise float _724 = _723 + _715;
                float _725 = exp2(_716);
                precise float _727 = _645 * (-4.24560546875);
                precise float _728 = _727 + _718;
                precise float _729 = _721 * fma(-2.0, _713, 3.0);
                precise float _730 = _729 + 1.0;
                precise float _732 = _725 * 1.709716796875;
                precise float _733 = _732 + _724;
                precise float _735 = _725 * (-0.132568359375);
                precise float _736 = _735 + _728;
                uint _777;
                if (!(_698 > _415))
                {
                    precise float _740 = (1.0 / uintBitsToFloat(ssbo_1_1.data[_406])) * _698;
                    precise float _742 = uintBitsToFloat(ssbo_1_1.data[_435]) * _698;
                    float _744 = clamp(max(0.0, _740), 0.0, 1.0);
                    precise float _747 = uintBitsToFloat(ssbo_1_1.data[_406]) + uintBitsToFloat(ssbo_1_1.data[_410]);
                    precise float _748 = (-1.44269502162933349609375) * _742;
                    precise float _753 = (-_744) * _744;
                    bool _754 = _698 < _747;
                    precise float _757 = uintBitsToFloat(ssbo_1_1.data[_423]) * log2(abs(_740));
                    precise float _758 = _753 * fma(-2.0, _744, 3.0);
                    precise float _759 = _758 + 1.0;
                    precise float _765 = (-uintBitsToFloat(ssbo_1_1.data[_431])) * exp2(_748);
                    precise float _766 = _765 + uintBitsToFloat(_429);
                    precise float _767 = (_754 ? 0.0 : (-1.0)) - _759;
                    precise float _770 = uintBitsToFloat(ssbo_1_1.data[_406]) * exp2(_757);
                    precise float _771 = 1.0 + _767;
                    precise float _772 = _759 * _770;
                    precise float _773 = _772 + (_754 ? 0.0 : _766);
                    precise float _774 = _771 * _698;
                    precise float _775 = _774 + _773;
                    _777 = floatBitsToUint(_775);
                }
                else
                {
                    _777 = ssbo_1_1.data[_382];
                }
                precise float _779 = 0.00999999977648258209228515625 * uintBitsToFloat(_777);
                precise float _782 = 0.1593017578125 * log2(abs(_779));
                float _783 = exp2(_782);
                precise float _785 = 18.6875 * _783;
                precise float _786 = _785 + 1.0;
                precise float _789 = log2(fma(18.8515625, _783, 0.8359375)) - log2(_786);
                precise float _790 = 78.84375 * _789;
                float _791 = exp2(_790);
                precise float _792 = _733 * _730;
                precise float _794 = _792 * 0.0089999996125698089599609375;
                precise float _795 = _794 + _791;
                precise float _796 = _736 * _730;
                precise float _798 = _796 * 0.111000001430511474609375;
                precise float _799 = _798 + _795;
                precise float _801 = _792 * (-0.0089999996125698089599609375);
                precise float _802 = _801 + _791;
                precise float _806 = _796 * (-0.111000001430511474609375);
                precise float _807 = _806 + _802;
                precise float _809 = _792 * 0.560000002384185791015625;
                precise float _810 = _809 + _791;
                precise float _811 = 0.0126833133399486541748046875 * log2(abs(_799));
                precise float _815 = _796 * (-0.3210000097751617431640625);
                precise float _816 = _815 + _810;
                float _817 = exp2(_811);
                precise float _818 = 0.0126833133399486541748046875 * log2(abs(_807));
                float _822 = exp2(_818);
                precise float _823 = 0.0126833133399486541748046875 * log2(abs(_816));
                precise float _825 = (-0.8359375) + _817;
                float _827 = exp2(_823);
                precise float _828 = (1.0 / fma(-18.6875, _817, 18.8515625)) * _825;
                precise float _830 = (-0.8359375) + _822;
                precise float _834 = (1.0 / fma(-18.6875, _822, 18.8515625)) * _830;
                precise float _836 = (-0.8359375) + _827;
                precise float _837 = 6.277394771575927734375 * log2(abs(_828));
                precise float _840 = (1.0 / fma(-18.6875, _827, 18.8515625)) * _836;
                float _841 = exp2(_837);
                precise float _842 = 6.277394771575927734375 * log2(abs(_834));
                precise float _848 = 343.6610107421875 * _841;
                precise float _849 = _848 + (-uintBitsToFloat(_485));
                float _850 = exp2(_842);
                precise float _851 = 6.277394771575927734375 * log2(abs(_840));
                precise float _855 = (-79.13299560546875) * _841;
                precise float _856 = _855 + (-uintBitsToFloat(_538));
                precise float _860 = (-2.5949900150299072265625) * _841;
                precise float _861 = _860 + (-uintBitsToFloat(_591));
                precise float _863 = _850 * (-250.644989013671875);
                precise float _864 = _863 + _849;
                float _865 = exp2(_851);
                precise float _867 = _850 * 198.3600006103515625;
                precise float _868 = _867 + _856;
                precise float _870 = _850 * (-9.89136981964111328125);
                precise float _871 = _870 + _861;
                precise float _873 = _865 * 6.98453998565673828125;
                precise float _874 = _873 + _864;
                precise float _876 = _865 * (-19.227100372314453125);
                precise float _877 = _876 + _868;
                precise float _879 = _865 * 112.4860076904296875;
                precise float _880 = _879 + _871;
                precise float _883 = uintBitsToFloat(ssbo_1_1.data[_390]) * _874;
                precise float _884 = _883 + uintBitsToFloat(_485);
                precise float _887 = uintBitsToFloat(ssbo_1_1.data[_390]) * _877;
                precise float _888 = _887 + uintBitsToFloat(_538);
                precise float _891 = uintBitsToFloat(ssbo_1_1.data[_390]) * _880;
                precise float _892 = _891 + uintBitsToFloat(_591);
                precise float _903 = uintBitsToFloat(ssbo_1_1.data[_394]) * max(0.0, min(uintBitsToFloat(ssbo_1_1.data[_382]), _884));
                precise float _906 = uintBitsToFloat(ssbo_1_1.data[_394]) * max(0.0, min(uintBitsToFloat(ssbo_1_1.data[_382]), _888));
                precise float _909 = uintBitsToFloat(ssbo_1_1.data[_394]) * max(0.0, min(uintBitsToFloat(ssbo_1_1.data[_382]), _892));
                uint _935;
                uint _936;
                uint _937;
                if (_332)
                {
                    uint _917 = 8u + buf0_dword_off;
                    precise float _924 = uintBitsToFloat(ssbo_1_1.data[_917]) * log2(clamp(max(0.0, _903), 0.0, 1.0));
                    precise float _926 = uintBitsToFloat(ssbo_1_1.data[_917]) * log2(clamp(max(0.0, _906), 0.0, 1.0));
                    precise float _928 = uintBitsToFloat(ssbo_1_1.data[_917]) * log2(clamp(max(0.0, _909), 0.0, 1.0));
                    _935 = floatBitsToUint(exp2(_928));
                    _936 = floatBitsToUint(exp2(_926));
                    _937 = floatBitsToUint(exp2(_924));
                }
                else
                {
                    _935 = floatBitsToUint(_909);
                    _936 = floatBitsToUint(_906);
                    _937 = floatBitsToUint(_903);
                }
                vec4 _941 = vec4(uintBitsToFloat(_937), uintBitsToFloat(_936), uintBitsToFloat(_935), 1.0);
                imageStore(cs_img0, ivec3(uvec3(_247, _259, _261)), vec4(_941.w, _941.z, _941.y, _941.x));
                _945 = true;
                _946 = _429;
                _947 = _935;
                _948 = _936;
                _949 = _937;
            }
            else
            {
                _945 = uintBitsToFloat(_236) < 9.0;
                _946 = _236;
                _947 = _366;
                _948 = _367;
                _949 = _368;
            }
            if (!_335)
            {
                uint _1783;
                uint _1784;
                uint _1785;
                bool _1786;
                if (_338)
                {
                    bool _952 = 0.0 > uintBitsToFloat(_949);
                    uint _953 = 16u + buf0_dword_off;
                    uint _959 = 18u + buf0_dword_off;
                    uint _962 = 19u + buf0_dword_off;
                    uint _965 = 20u + buf0_dword_off;
                    uint _971 = 22u + buf0_dword_off;
                    uint _974 = 23u + buf0_dword_off;
                    uint _977 = 24u + buf0_dword_off;
                    uint _980 = 25u + buf0_dword_off;
                    uint _983 = 26u + buf0_dword_off;
                    uint _986 = 27u + buf0_dword_off;
                    precise float _991 = uintBitsToFloat(ssbo_1_1.data[_953]) * uintBitsToFloat(ssbo_1_1.data[17u + buf0_dword_off]);
                    uint _1042;
                    if (!((uintBitsToFloat(_949) > _991) || _952))
                    {
                        precise float _1002 = (1.0 / uintBitsToFloat(ssbo_1_1.data[_971])) * uintBitsToFloat(_949);
                        precise float _1005 = uintBitsToFloat(ssbo_1_1.data[_986]) * uintBitsToFloat(_949);
                        float _1007 = clamp(max(0.0, _1002), 0.0, 1.0);
                        precise float _1010 = uintBitsToFloat(ssbo_1_1.data[_971]) + uintBitsToFloat(ssbo_1_1.data[_974]);
                        precise float _1011 = (-1.44269502162933349609375) * _1005;
                        precise float _1016 = (-_1007) * _1007;
                        bool _1018 = uintBitsToFloat(_949) < _1010;
                        precise float _1021 = uintBitsToFloat(ssbo_1_1.data[_977]) * log2(abs(_1002));
                        precise float _1022 = _1016 * fma(-2.0, _1007, 3.0);
                        precise float _1023 = _1022 + 1.0;
                        precise float _1029 = (-uintBitsToFloat(ssbo_1_1.data[_983])) * exp2(_1011);
                        precise float _1030 = _1029 + uintBitsToFloat(ssbo_1_1.data[_980]);
                        precise float _1031 = (_1018 ? 0.0 : (-1.0)) - _1023;
                        precise float _1034 = uintBitsToFloat(ssbo_1_1.data[_971]) * exp2(_1021);
                        precise float _1035 = 1.0 + _1031;
                        precise float _1036 = _1023 * _1034;
                        precise float _1037 = _1036 + (_1018 ? 0.0 : _1030);
                        precise float _1039 = uintBitsToFloat(_949) * _1035;
                        precise float _1040 = _1039 + _1037;
                        _1042 = floatBitsToUint(_1040);
                    }
                    else
                    {
                        _1042 = floatBitsToUint(_952 ? 0.0 : uintBitsToFloat(ssbo_1_1.data[_953]));
                    }
                    bool _1044 = 0.0 > uintBitsToFloat(_948);
                    uint _1095;
                    if (!((uintBitsToFloat(_948) > _991) || _1044))
                    {
                        precise float _1055 = (1.0 / uintBitsToFloat(ssbo_1_1.data[_971])) * uintBitsToFloat(_948);
                        precise float _1058 = uintBitsToFloat(ssbo_1_1.data[_986]) * uintBitsToFloat(_948);
                        float _1060 = clamp(max(0.0, _1055), 0.0, 1.0);
                        precise float _1063 = uintBitsToFloat(ssbo_1_1.data[_971]) + uintBitsToFloat(ssbo_1_1.data[_974]);
                        precise float _1064 = (-1.44269502162933349609375) * _1058;
                        precise float _1069 = (-_1060) * _1060;
                        bool _1071 = uintBitsToFloat(_948) < _1063;
                        precise float _1074 = uintBitsToFloat(ssbo_1_1.data[_977]) * log2(abs(_1055));
                        precise float _1075 = _1069 * fma(-2.0, _1060, 3.0);
                        precise float _1076 = _1075 + 1.0;
                        precise float _1082 = (-uintBitsToFloat(ssbo_1_1.data[_983])) * exp2(_1064);
                        precise float _1083 = _1082 + uintBitsToFloat(ssbo_1_1.data[_980]);
                        precise float _1084 = (_1071 ? 0.0 : (-1.0)) - _1076;
                        precise float _1087 = uintBitsToFloat(ssbo_1_1.data[_971]) * exp2(_1074);
                        precise float _1088 = 1.0 + _1084;
                        precise float _1089 = _1076 * _1087;
                        precise float _1090 = _1089 + (_1071 ? 0.0 : _1083);
                        precise float _1092 = _1088 * uintBitsToFloat(_948);
                        precise float _1093 = _1092 + _1090;
                        _1095 = floatBitsToUint(_1093);
                    }
                    else
                    {
                        _1095 = floatBitsToUint(_1044 ? 0.0 : uintBitsToFloat(ssbo_1_1.data[_953]));
                    }
                    bool _1097 = 0.0 > uintBitsToFloat(_947);
                    uint _1148;
                    if (!((uintBitsToFloat(_947) > _991) || _1097))
                    {
                        precise float _1108 = (1.0 / uintBitsToFloat(ssbo_1_1.data[_971])) * uintBitsToFloat(_947);
                        precise float _1111 = uintBitsToFloat(ssbo_1_1.data[_986]) * uintBitsToFloat(_947);
                        float _1113 = clamp(max(0.0, _1108), 0.0, 1.0);
                        precise float _1116 = uintBitsToFloat(ssbo_1_1.data[_971]) + uintBitsToFloat(ssbo_1_1.data[_974]);
                        precise float _1117 = (-1.44269502162933349609375) * _1111;
                        precise float _1122 = (-_1113) * _1113;
                        bool _1124 = uintBitsToFloat(_947) < _1116;
                        precise float _1127 = uintBitsToFloat(ssbo_1_1.data[_977]) * log2(abs(_1108));
                        precise float _1128 = _1122 * fma(-2.0, _1113, 3.0);
                        precise float _1129 = _1128 + 1.0;
                        precise float _1135 = (-uintBitsToFloat(ssbo_1_1.data[_983])) * exp2(_1117);
                        precise float _1136 = _1135 + uintBitsToFloat(ssbo_1_1.data[_980]);
                        precise float _1137 = (_1124 ? 0.0 : (-1.0)) - _1129;
                        precise float _1140 = uintBitsToFloat(ssbo_1_1.data[_971]) * exp2(_1127);
                        precise float _1141 = 1.0 + _1137;
                        precise float _1142 = _1129 * _1140;
                        precise float _1143 = _1142 + (_1124 ? 0.0 : _1136);
                        precise float _1145 = _1141 * uintBitsToFloat(_947);
                        precise float _1146 = _1145 + _1143;
                        _1148 = floatBitsToUint(_1146);
                    }
                    else
                    {
                        _1148 = floatBitsToUint(_1097 ? 0.0 : uintBitsToFloat(ssbo_1_1.data[_953]));
                    }
                    precise float _1150 = 0.412109375 * uintBitsToFloat(_949);
                    precise float _1152 = 0.166748046875 * uintBitsToFloat(_949);
                    precise float _1154 = uintBitsToFloat(_948) * 0.52392578125;
                    precise float _1155 = _1154 + _1150;
                    precise float _1157 = uintBitsToFloat(_948) * 0.720458984375;
                    precise float _1158 = _1157 + _1152;
                    precise float _1160 = uintBitsToFloat(_947) * 0.06396484375;
                    precise float _1161 = _1160 + _1155;
                    precise float _1163 = uintBitsToFloat(_947) * 0.11279296875;
                    precise float _1164 = _1163 + _1158;
                    precise float _1165 = 0.00999999977648258209228515625 * _1161;
                    precise float _1166 = 0.00999999977648258209228515625 * _1164;
                    precise float _1171 = 0.1593017578125 * log2(abs(_1165));
                    precise float _1172 = 0.1593017578125 * log2(abs(_1166));
                    float _1173 = exp2(_1171);
                    float _1174 = exp2(_1172);
                    precise float _1176 = 18.6875 * _1173;
                    precise float _1177 = _1176 + 1.0;
                    precise float _1179 = 18.6875 * _1174;
                    precise float _1180 = _1179 + 1.0;
                    precise float _1185 = log2(fma(18.8515625, _1173, 0.8359375)) - log2(_1177);
                    precise float _1186 = log2(fma(18.8515625, _1174, 0.8359375)) - log2(_1180);
                    precise float _1187 = 78.84375 * _1185;
                    precise float _1188 = 78.84375 * _1186;
                    float _1189 = exp2(_1187);
                    float _1190 = exp2(_1188);
                    precise float _1191 = _1189 + _1190;
                    precise float _1192 = _1191 * 0.5;
                    precise float _1194 = 0.0126833133399486541748046875 * log2(_1192);
                    precise float _1196 = 0.00999999977648258209228515625 * uintBitsToFloat(ssbo_1_1.data[_953]);
                    precise float _1200 = 0.024169921875 * uintBitsToFloat(_949);
                    float _1201 = exp2(_1194);
                    precise float _1202 = 0.1593017578125 * log2(abs(_1196));
                    precise float _1204 = uintBitsToFloat(_948) * 0.075439453125;
                    precise float _1205 = _1204 + _1200;
                    float _1207 = exp2(_1202);
                    precise float _1210 = uintBitsToFloat(_947) * 0.900390625;
                    precise float _1211 = _1210 + _1205;
                    precise float _1212 = (-0.8359375) + _1201;
                    precise float _1213 = 0.00999999977648258209228515625 * _1211;
                    precise float _1214 = (1.0 / fma(-18.6875, _1201, 18.8515625)) * _1212;
                    precise float _1216 = 18.6875 * _1207;
                    precise float _1217 = _1216 + 1.0;
                    precise float _1224 = log2(fma(18.8515625, _1207, 0.8359375)) - log2(_1217);
                    precise float _1225 = 0.1593017578125 * log2(abs(_1213));
                    precise float _1226 = 6.277394771575927734375 * log2(abs(_1214));
                    precise float _1227 = 78.84375 * _1224;
                    float _1228 = exp2(_1225);
                    precise float _1232 = 18.6875 * _1228;
                    precise float _1233 = _1232 + 1.0;
                    precise float _1234 = 100.0 * exp2(_1226);
                    precise float _1238 = uintBitsToFloat(ssbo_1_1.data[21u + buf0_dword_off]) - uintBitsToFloat(ssbo_1_1.data[_965]);
                    precise float _1243 = _1192 * (1.0 / exp2(_1227));
                    precise float _1244 = _1243 + (-uintBitsToFloat(ssbo_1_1.data[_965]));
                    precise float _1246 = log2(fma(18.8515625, _1228, 0.8359375)) - log2(_1233);
                    precise float _1248 = (1.0 / _1238) * _1244;
                    float _1249 = clamp(_1248, 0.0, 1.0);
                    precise float _1250 = 1.61376953125 * _1189;
                    precise float _1251 = 78.84375 * _1246;
                    precise float _1252 = 4.378173828125 * _1189;
                    precise float _1255 = (-_1249) * _1249;
                    precise float _1256 = _1190 * (-3.323486328125);
                    precise float _1257 = _1256 + _1250;
                    float _1258 = exp2(_1251);
                    precise float _1259 = _1190 * (-4.24560546875);
                    precise float _1260 = _1259 + _1252;
                    precise float _1261 = _1255 * fma(-2.0, _1249, 3.0);
                    precise float _1262 = _1261 + 1.0;
                    precise float _1263 = _1258 * 1.709716796875;
                    precise float _1264 = _1263 + _1257;
                    precise float _1265 = _1258 * (-0.132568359375);
                    precise float _1266 = _1265 + _1260;
                    uint _1307;
                    if (!(_1234 > _991))
                    {
                        precise float _1270 = (1.0 / uintBitsToFloat(ssbo_1_1.data[_971])) * _1234;
                        precise float _1272 = uintBitsToFloat(ssbo_1_1.data[_986]) * _1234;
                        float _1274 = clamp(max(0.0, _1270), 0.0, 1.0);
                        precise float _1277 = uintBitsToFloat(ssbo_1_1.data[_971]) + uintBitsToFloat(ssbo_1_1.data[_974]);
                        precise float _1278 = (-1.44269502162933349609375) * _1272;
                        precise float _1283 = (-_1274) * _1274;
                        bool _1284 = _1234 < _1277;
                        precise float _1287 = uintBitsToFloat(ssbo_1_1.data[_977]) * log2(abs(_1270));
                        precise float _1288 = _1283 * fma(-2.0, _1274, 3.0);
                        precise float _1289 = _1288 + 1.0;
                        precise float _1295 = (-uintBitsToFloat(ssbo_1_1.data[_983])) * exp2(_1278);
                        precise float _1296 = _1295 + uintBitsToFloat(ssbo_1_1.data[_980]);
                        precise float _1297 = (_1284 ? 0.0 : (-1.0)) - _1289;
                        precise float _1300 = uintBitsToFloat(ssbo_1_1.data[_971]) * exp2(_1287);
                        precise float _1301 = 1.0 + _1297;
                        precise float _1302 = _1289 * _1300;
                        precise float _1303 = _1302 + (_1284 ? 0.0 : _1296);
                        precise float _1304 = _1301 * _1234;
                        precise float _1305 = _1304 + _1303;
                        _1307 = floatBitsToUint(_1305);
                    }
                    else
                    {
                        _1307 = ssbo_1_1.data[_953];
                    }
                    precise float _1309 = 0.00999999977648258209228515625 * uintBitsToFloat(_1307);
                    precise float _1312 = 0.1593017578125 * log2(abs(_1309));
                    float _1313 = exp2(_1312);
                    precise float _1315 = 18.6875 * _1313;
                    precise float _1316 = _1315 + 1.0;
                    precise float _1319 = log2(fma(18.8515625, _1313, 0.8359375)) - log2(_1316);
                    precise float _1320 = 78.84375 * _1319;
                    float _1321 = exp2(_1320);
                    precise float _1322 = _1264 * _1262;
                    precise float _1323 = _1322 * 0.0089999996125698089599609375;
                    precise float _1324 = _1323 + _1321;
                    precise float _1325 = _1266 * _1262;
                    precise float _1326 = _1325 * 0.111000001430511474609375;
                    precise float _1327 = _1326 + _1324;
                    precise float _1328 = _1322 * (-0.0089999996125698089599609375);
                    precise float _1329 = _1328 + _1321;
                    precise float _1332 = _1325 * (-0.111000001430511474609375);
                    precise float _1333 = _1332 + _1329;
                    precise float _1334 = _1322 * 0.560000002384185791015625;
                    precise float _1335 = _1334 + _1321;
                    precise float _1336 = 0.0126833133399486541748046875 * log2(abs(_1327));
                    precise float _1339 = _1325 * (-0.3210000097751617431640625);
                    precise float _1340 = _1339 + _1335;
                    float _1341 = exp2(_1336);
                    precise float _1342 = 0.0126833133399486541748046875 * log2(abs(_1333));
                    float _1346 = exp2(_1342);
                    precise float _1347 = 0.0126833133399486541748046875 * log2(abs(_1340));
                    precise float _1349 = (-0.8359375) + _1341;
                    float _1351 = exp2(_1347);
                    precise float _1352 = (1.0 / fma(-18.6875, _1341, 18.8515625)) * _1349;
                    precise float _1354 = (-0.8359375) + _1346;
                    precise float _1358 = (1.0 / fma(-18.6875, _1346, 18.8515625)) * _1354;
                    precise float _1360 = (-0.8359375) + _1351;
                    precise float _1361 = 6.277394771575927734375 * log2(abs(_1352));
                    precise float _1364 = (1.0 / fma(-18.6875, _1351, 18.8515625)) * _1360;
                    float _1365 = exp2(_1361);
                    precise float _1366 = 6.277394771575927734375 * log2(abs(_1358));
                    precise float _1371 = 343.6610107421875 * _1365;
                    precise float _1372 = _1371 + (-uintBitsToFloat(_1042));
                    float _1373 = exp2(_1366);
                    precise float _1374 = 6.277394771575927734375 * log2(abs(_1364));
                    precise float _1377 = (-79.13299560546875) * _1365;
                    precise float _1378 = _1377 + (-uintBitsToFloat(_1095));
                    precise float _1381 = (-2.5949900150299072265625) * _1365;
                    precise float _1382 = _1381 + (-uintBitsToFloat(_1148));
                    precise float _1383 = _1373 * (-250.644989013671875);
                    precise float _1384 = _1383 + _1372;
                    float _1385 = exp2(_1374);
                    precise float _1386 = _1373 * 198.3600006103515625;
                    precise float _1387 = _1386 + _1378;
                    precise float _1388 = _1373 * (-9.89136981964111328125);
                    precise float _1389 = _1388 + _1382;
                    precise float _1390 = _1385 * 6.98453998565673828125;
                    precise float _1391 = _1390 + _1384;
                    precise float _1392 = _1385 * (-19.227100372314453125);
                    precise float _1393 = _1392 + _1387;
                    precise float _1394 = _1385 * 112.4860076904296875;
                    precise float _1395 = _1394 + _1389;
                    precise float _1398 = uintBitsToFloat(ssbo_1_1.data[_959]) * _1391;
                    precise float _1399 = _1398 + uintBitsToFloat(_1042);
                    precise float _1402 = uintBitsToFloat(ssbo_1_1.data[_959]) * _1393;
                    precise float _1403 = _1402 + uintBitsToFloat(_1095);
                    precise float _1406 = uintBitsToFloat(ssbo_1_1.data[_959]) * _1395;
                    precise float _1407 = _1406 + uintBitsToFloat(_1148);
                    precise float _1418 = uintBitsToFloat(ssbo_1_1.data[_962]) * max(0.0, min(uintBitsToFloat(ssbo_1_1.data[_953]), _1399));
                    precise float _1421 = uintBitsToFloat(ssbo_1_1.data[_962]) * max(0.0, min(uintBitsToFloat(ssbo_1_1.data[_953]), _1403));
                    precise float _1424 = uintBitsToFloat(ssbo_1_1.data[_962]) * max(0.0, min(uintBitsToFloat(ssbo_1_1.data[_953]), _1407));
                    uint _1450;
                    uint _1451;
                    uint _1452;
                    if (_332)
                    {
                        uint _1432 = 8u + buf0_dword_off;
                        precise float _1439 = uintBitsToFloat(ssbo_1_1.data[_1432]) * log2(clamp(max(0.0, _1418), 0.0, 1.0));
                        precise float _1441 = uintBitsToFloat(ssbo_1_1.data[_1432]) * log2(clamp(max(0.0, _1421), 0.0, 1.0));
                        precise float _1443 = uintBitsToFloat(ssbo_1_1.data[_1432]) * log2(clamp(max(0.0, _1424), 0.0, 1.0));
                        _1450 = floatBitsToUint(exp2(_1439));
                        _1451 = floatBitsToUint(exp2(_1441));
                        _1452 = floatBitsToUint(exp2(_1443));
                    }
                    else
                    {
                        _1450 = floatBitsToUint(_1418);
                        _1451 = floatBitsToUint(_1421);
                        _1452 = floatBitsToUint(_1424);
                    }
                    bool _1455 = uintBitsToFloat(_946) < 4.0;
                    precise float _1494 = uintBitsToFloat(ssbo_1_1.data[30u + buf0_dword_off]) * uintBitsToFloat(_1452);
                    precise float _1498 = uintBitsToFloat(ssbo_1_1.data[38u + buf0_dword_off]) * uintBitsToFloat(_1452);
                    precise float _1501 = uintBitsToFloat(_1451) * uintBitsToFloat(ssbo_1_1.data[37u + buf0_dword_off]);
                    precise float _1502 = _1501 + _1498;
                    bool _1504 = uintBitsToFloat(_946) < 3.0;
                    precise float _1507 = uintBitsToFloat(ssbo_1_1.data[34u + buf0_dword_off]) * uintBitsToFloat(_1452);
                    precise float _1510 = uintBitsToFloat(_1451) * uintBitsToFloat(ssbo_1_1.data[29u + buf0_dword_off]);
                    precise float _1511 = _1510 + _1494;
                    precise float _1514 = uintBitsToFloat(ssbo_1_1.data[33u + buf0_dword_off]) * uintBitsToFloat(_1451);
                    precise float _1515 = _1514 + _1507;
                    precise float _1518 = uintBitsToFloat(ssbo_1_1.data[32u + buf0_dword_off]) * uintBitsToFloat(_1450);
                    precise float _1519 = _1518 + _1515;
                    precise float _1523 = uintBitsToFloat(ssbo_1_1.data[28u + buf0_dword_off]) * uintBitsToFloat(_1450);
                    precise float _1524 = _1523 + _1511;
                    precise float _1528 = uintBitsToFloat(ssbo_1_1.data[36u + buf0_dword_off]) * uintBitsToFloat(_1450);
                    precise float _1529 = _1528 + _1502;
                    uint _1557;
                    uint _1558;
                    uint _1559;
                    uint _1560;
                    if (_1504)
                    {
                        precise float _1544 = 0.454545438289642333984375 * uintBitsToFloat(ssbo_1_1.data[9u + buf0_dword_off]);
                        precise float _1547 = log2(clamp(max(0.0, _1524), 0.0, 1.0)) * _1544;
                        precise float _1549 = log2(clamp(max(0.0, _1519), 0.0, 1.0)) * _1544;
                        precise float _1550 = log2(clamp(max(0.0, _1529), 0.0, 1.0)) * _1544;
                        _1557 = floatBitsToUint(exp2(_1550));
                        _1558 = floatBitsToUint(_1547);
                        _1559 = floatBitsToUint(exp2(_1549));
                        _1560 = floatBitsToUint(exp2(_1547));
                    }
                    else
                    {
                        _1557 = floatBitsToUint(_1494);
                        _1558 = floatBitsToUint(_1524);
                        _1559 = floatBitsToUint(_1519);
                        _1560 = 1100402688u;
                    }
                    uint _1764;
                    uint _1765;
                    uint _1766;
                    if (!_1504)
                    {
                        uint _1610;
                        uint _1611;
                        uint _1612;
                        uint _1613;
                        if (_1455)
                        {
                            precise float _1563 = 0.00999999977648258209228515625 * uintBitsToFloat(_1558);
                            precise float _1565 = 0.00999999977648258209228515625 * uintBitsToFloat(_1559);
                            precise float _1566 = 0.00999999977648258209228515625 * _1529;
                            precise float _1573 = 0.1593017578125 * log2(abs(_1563));
                            precise float _1574 = 0.1593017578125 * log2(abs(_1565));
                            precise float _1575 = 0.1593017578125 * log2(abs(_1566));
                            float _1576 = exp2(_1573);
                            float _1577 = exp2(_1574);
                            float _1578 = exp2(_1575);
                            precise float _1581 = 18.6875 * _1576;
                            precise float _1582 = _1581 + 1.0;
                            precise float _1585 = 18.6875 * _1577;
                            precise float _1586 = _1585 + 1.0;
                            precise float _1589 = 18.6875 * _1578;
                            precise float _1590 = _1589 + 1.0;
                            precise float _1597 = log2(fma(uintBitsToFloat(_1560), _1576, 0.8359375)) - log2(_1582);
                            precise float _1598 = log2(fma(uintBitsToFloat(_1560), _1577, 0.8359375)) - log2(_1586);
                            precise float _1599 = log2(fma(uintBitsToFloat(_1560), _1578, 0.8359375)) - log2(_1590);
                            precise float _1600 = 78.84375 * _1597;
                            precise float _1601 = 78.84375 * _1598;
                            precise float _1602 = 78.84375 * _1599;
                            _1610 = floatBitsToUint(exp2(_1602));
                            _1611 = floatBitsToUint(exp2(_1600));
                            _1612 = floatBitsToUint(exp2(_1601));
                            _1613 = floatBitsToUint(_1602);
                        }
                        else
                        {
                            _1610 = _1557;
                            _1611 = _1560;
                            _1612 = _1559;
                            _1613 = _1558;
                        }
                        uint _1761;
                        uint _1762;
                        uint _1763;
                        if (!_1455)
                        {
                            precise float _1616 = 4.5 * uintBitsToFloat(_1613);
                            bool _1620 = uintBitsToFloat(_946) < 5.0;
                            bool _1623 = uintBitsToFloat(_946) < 6.0;
                            precise float _1629 = 12.9200000762939453125 * uintBitsToFloat(_1613);
                            uint _1630 = floatBitsToUint(_1629);
                            uint _1671;
                            uint _1672;
                            uint _1673;
                            uint _1674;
                            if (_1620)
                            {
                                uint _1648;
                                if (!(0.003130800090730190277099609375 >= uintBitsToFloat(_1613)))
                                {
                                    precise float _1642 = 0.4166666567325592041015625 * log2(uintBitsToFloat(_1613));
                                    _1648 = floatBitsToUint(fma(1.05499994754791259765625, exp2(_1642), -0.054999999701976776123046875));
                                }
                                else
                                {
                                    _1648 = _1630;
                                }
                                precise float _1652 = 12.9200000762939453125 * uintBitsToFloat(_1612);
                                uint _1660;
                                if (uintBitsToFloat(_1612) > 0.003130800090730190277099609375)
                                {
                                    precise float _1656 = 0.4166666567325592041015625 * log2(uintBitsToFloat(_1612));
                                    _1660 = floatBitsToUint(fma(1.05499994754791259765625, exp2(_1656), -0.054999999701976776123046875));
                                }
                                else
                                {
                                    _1660 = floatBitsToUint(_1652);
                                }
                                precise float _1662 = 12.9200000762939453125 * _1529;
                                uint _1669;
                                uint _1670;
                                if (_1529 > 0.003130800090730190277099609375)
                                {
                                    precise float _1665 = 0.4166666567325592041015625 * log2(_1529);
                                    _1669 = floatBitsToUint(fma(1.05499994754791259765625, exp2(_1665), -0.054999999701976776123046875));
                                    _1670 = 1065814589u;
                                }
                                else
                                {
                                    _1669 = floatBitsToUint(_1662);
                                    _1670 = _1660;
                                }
                                _1671 = _1669;
                                _1672 = _1648;
                                _1673 = _1660;
                                _1674 = _1670;
                            }
                            else
                            {
                                _1671 = _1610;
                                _1672 = _1630;
                                _1673 = _1612;
                                _1674 = _1613;
                            }
                            uint _1758;
                            uint _1759;
                            uint _1760;
                            if (!_1620)
                            {
                                uint _1709;
                                uint _1710;
                                uint _1711;
                                uint _1712;
                                if (_1623)
                                {
                                    uint _1686;
                                    if (!(0.017999999225139617919921875 > uintBitsToFloat(_1613)))
                                    {
                                        precise float _1680 = 0.449999988079071044921875 * log2(uintBitsToFloat(_1674));
                                        _1686 = floatBitsToUint(fma(1.09899997711181640625, exp2(_1680), -0.098999999463558197021484375));
                                    }
                                    else
                                    {
                                        _1686 = floatBitsToUint(_1616);
                                    }
                                    precise float _1690 = 4.5 * uintBitsToFloat(_1673);
                                    uint _1698;
                                    if (uintBitsToFloat(_1673) >= 0.017999999225139617919921875)
                                    {
                                        precise float _1694 = 0.449999988079071044921875 * log2(uintBitsToFloat(_1673));
                                        _1698 = floatBitsToUint(fma(1.09899997711181640625, exp2(_1694), -0.098999999463558197021484375));
                                    }
                                    else
                                    {
                                        _1698 = floatBitsToUint(_1690);
                                    }
                                    precise float _1700 = 4.5 * _1529;
                                    uint _1707;
                                    uint _1708;
                                    if (_1529 >= 0.017999999225139617919921875)
                                    {
                                        precise float _1703 = 0.449999988079071044921875 * log2(_1529);
                                        _1707 = floatBitsToUint(fma(1.09899997711181640625, exp2(_1703), -0.098999999463558197021484375));
                                        _1708 = 1066183688u;
                                    }
                                    else
                                    {
                                        _1707 = floatBitsToUint(_1700);
                                        _1708 = _1698;
                                    }
                                    _1709 = _1707;
                                    _1710 = _1686;
                                    _1711 = _1698;
                                    _1712 = _1708;
                                }
                                else
                                {
                                    _1709 = _1671;
                                    _1710 = _1672;
                                    _1711 = _1673;
                                    _1712 = _1674;
                                }
                                uint _1755;
                                uint _1756;
                                uint _1757;
                                if (!_1623)
                                {
                                    uint _1752;
                                    uint _1753;
                                    uint _1754;
                                    if (uintBitsToFloat(_946) < 7.0)
                                    {
                                        precise float _1728 = 2.400000095367431640625 * log2(abs(fma(0.947867333889007568359375, uintBitsToFloat(_1712), 0.052132703363895416259765625)));
                                        precise float _1729 = 2.400000095367431640625 * log2(abs(fma(0.947867333889007568359375, uintBitsToFloat(_1711), 0.052132703363895416259765625)));
                                        precise float _1730 = 2.400000095367431640625 * log2(abs(fma(0.947867333889007568359375, _1529, 0.052132703363895416259765625)));
                                        precise float _1737 = 0.077399380505084991455078125 * uintBitsToFloat(_1712);
                                        precise float _1742 = 0.077399380505084991455078125 * uintBitsToFloat(_1711);
                                        precise float _1745 = 0.077399380505084991455078125 * _1529;
                                        _1752 = floatBitsToUint((0.040449999272823333740234375 > _1529) ? _1745 : exp2(_1730));
                                        _1753 = floatBitsToUint((0.040449999272823333740234375 > uintBitsToFloat(_1711)) ? _1742 : exp2(_1729));
                                        _1754 = floatBitsToUint((0.040449999272823333740234375 > uintBitsToFloat(_1712)) ? _1737 : exp2(_1728));
                                    }
                                    else
                                    {
                                        _1752 = floatBitsToUint(_1529);
                                        _1753 = _1711;
                                        _1754 = _1712;
                                    }
                                    _1755 = _1752;
                                    _1756 = _1753;
                                    _1757 = _1754;
                                }
                                else
                                {
                                    _1755 = _1709;
                                    _1756 = _1711;
                                    _1757 = _1710;
                                }
                                _1758 = _1755;
                                _1759 = _1756;
                                _1760 = _1757;
                            }
                            else
                            {
                                _1758 = _1671;
                                _1759 = _1673;
                                _1760 = _1672;
                            }
                            _1761 = _1758;
                            _1762 = _1759;
                            _1763 = _1760;
                        }
                        else
                        {
                            _1761 = _1610;
                            _1762 = _1612;
                            _1763 = _1611;
                        }
                        _1764 = _1763;
                        _1765 = _1761;
                        _1766 = _1762;
                    }
                    else
                    {
                        _1764 = _1560;
                        _1765 = _1557;
                        _1766 = _1559;
                    }
                    float _1769 = clamp(max(0.0, uintBitsToFloat(_1766)), 0.0, 1.0);
                    float _1773 = clamp(max(0.0, uintBitsToFloat(_1765)), 0.0, 1.0);
                    float _1777 = clamp(max(0.0, uintBitsToFloat(_1764)), 0.0, 1.0);
                    vec4 _1779 = vec4(_1777, _1769, _1773, 1.0);
                    imageStore(cs_img0, ivec3(uvec3(_247, _259, _261)), vec4(_1779.w, _1779.z, _1779.y, _1779.x));
                    _1783 = floatBitsToUint(_1773);
                    _1784 = floatBitsToUint(_1769);
                    _1785 = floatBitsToUint(_1777);
                    _1786 = true;
                }
                else
                {
                    _1783 = _947;
                    _1784 = _948;
                    _1785 = _949;
                    _1786 = _945;
                }
                if (!_338)
                {
                    uint _2285;
                    uint _2286;
                    uint _2287;
                    if (_1786)
                    {
                        bool _1789 = 0.0 > uintBitsToFloat(_1785);
                        uint _1790 = 16u + buf0_dword_off;
                        uint _1793 = 17u + buf0_dword_off;
                        uint _1799 = 19u + buf0_dword_off;
                        uint _1802 = 20u + buf0_dword_off;
                        uint _1805 = 21u + buf0_dword_off;
                        uint _1808 = 22u + buf0_dword_off;
                        uint _1814 = 24u + buf0_dword_off;
                        precise float _1818 = (-1.0) + uintBitsToFloat(ssbo_1_1.data[18u + buf0_dword_off]);
                        float _1819 = 1.0 / _1818;
                        precise float _1821 = (-1.0) + uintBitsToFloat(ssbo_1_1.data[_1802]);
                        precise float _1823 = _1819 * _1821;
                        precise float _1824 = _1823 + uintBitsToFloat(ssbo_1_1.data[_1802]);
                        precise float _1826 = (-1.0) + _1824;
                        precise float _1827 = (1.0 / _1821) * _1818;
                        precise float _1828 = _1827 * _1826;
                        precise float _1829 = _1819 * _1821;
                        precise float _1832 = uintBitsToFloat(ssbo_1_1.data[_1790]) * _1829;
                        precise float _1833 = log2(_1828) * _1832;
                        precise float _1836 = uintBitsToFloat(ssbo_1_1.data[_1790]) * uintBitsToFloat(ssbo_1_1.data[_1802]);
                        precise float _1838 = _1833 * (-0.693147182464599609375);
                        precise float _1839 = _1838 + _1836;
                        bool _1845 = (uintBitsToFloat(_1785) >= _1839) || _1789;
                        uint _1891;
                        if (!_1845)
                        {
                            precise float _1849 = 1.44269502162933349609375 * _1836;
                            precise float _1851 = uintBitsToFloat(_1785) * (-1.44269502162933349609375);
                            precise float _1852 = _1851 + _1849;
                            precise float _1856 = (1.0 / _1832) * _1852;
                            precise float _1858 = (1.0 / uintBitsToFloat(ssbo_1_1.data[_1799])) * uintBitsToFloat(_1785);
                            float _1861 = clamp(max(0.0, _1858), 0.0, 1.0);
                            precise float _1863 = (-exp2(_1856)) * _1829;
                            precise float _1864 = _1863 + _1829;
                            precise float _1866 = _1861 * _1861;
                            precise float _1868 = uintBitsToFloat(ssbo_1_1.data[_1802]) + _1864;
                            precise float _1869 = _1866 * fma(-2.0, _1861, 3.0);
                            precise float _1871 = uintBitsToFloat(ssbo_1_1.data[_1790]) * _1868;
                            uint _1890;
                            if ((!_1845) && (uintBitsToFloat(_1785) < _1836))
                            {
                                precise float _1880 = uintBitsToFloat(ssbo_1_1.data[_1805]) * log2(abs(_1858));
                                precise float _1883 = uintBitsToFloat(ssbo_1_1.data[_1799]) * exp2(_1880);
                                precise float _1884 = _1883 * (-_1869);
                                precise float _1885 = _1884 + _1883;
                                precise float _1887 = _1869 * uintBitsToFloat(_1785);
                                precise float _1888 = _1887 + _1885;
                                _1890 = floatBitsToUint(_1888);
                            }
                            else
                            {
                                _1890 = floatBitsToUint(_1871);
                            }
                            _1891 = _1890;
                        }
                        else
                        {
                            _1891 = floatBitsToUint(_1789 ? 0.0 : uintBitsToFloat(ssbo_1_1.data[_1790]));
                        }
                        bool _1893 = 0.0 > uintBitsToFloat(_1784);
                        bool _1899 = (uintBitsToFloat(_1784) >= _1839) || _1893;
                        uint _1944;
                        if (!_1899)
                        {
                            precise float _1902 = 1.44269502162933349609375 * _1836;
                            precise float _1904 = uintBitsToFloat(_1784) * (-1.44269502162933349609375);
                            precise float _1905 = _1904 + _1902;
                            precise float _1909 = (1.0 / _1832) * _1905;
                            precise float _1911 = (1.0 / uintBitsToFloat(ssbo_1_1.data[_1799])) * uintBitsToFloat(_1784);
                            float _1914 = clamp(max(0.0, _1911), 0.0, 1.0);
                            precise float _1916 = (-exp2(_1909)) * _1829;
                            precise float _1917 = _1916 + _1829;
                            precise float _1919 = _1914 * _1914;
                            precise float _1921 = uintBitsToFloat(ssbo_1_1.data[_1802]) + _1917;
                            precise float _1922 = _1919 * fma(-2.0, _1914, 3.0);
                            precise float _1924 = uintBitsToFloat(ssbo_1_1.data[_1790]) * _1921;
                            uint _1943;
                            if ((!_1899) && (uintBitsToFloat(_1784) < _1836))
                            {
                                precise float _1933 = uintBitsToFloat(ssbo_1_1.data[_1805]) * log2(abs(_1911));
                                precise float _1936 = uintBitsToFloat(ssbo_1_1.data[_1799]) * exp2(_1933);
                                precise float _1937 = _1936 * (-_1922);
                                precise float _1938 = _1937 + _1936;
                                precise float _1940 = _1922 * uintBitsToFloat(_1784);
                                precise float _1941 = _1940 + _1938;
                                _1943 = floatBitsToUint(_1941);
                            }
                            else
                            {
                                _1943 = floatBitsToUint(_1924);
                            }
                            _1944 = _1943;
                        }
                        else
                        {
                            _1944 = floatBitsToUint(_1893 ? 0.0 : uintBitsToFloat(ssbo_1_1.data[_1790]));
                        }
                        bool _1946 = 0.0 > uintBitsToFloat(_1783);
                        bool _1952 = (uintBitsToFloat(_1783) >= _1839) || _1946;
                        uint _1997;
                        if (!_1952)
                        {
                            precise float _1955 = 1.44269502162933349609375 * _1836;
                            precise float _1957 = uintBitsToFloat(_1783) * (-1.44269502162933349609375);
                            precise float _1958 = _1957 + _1955;
                            precise float _1962 = (1.0 / _1832) * _1958;
                            precise float _1964 = (1.0 / uintBitsToFloat(ssbo_1_1.data[_1799])) * uintBitsToFloat(_1783);
                            float _1967 = clamp(max(0.0, _1964), 0.0, 1.0);
                            precise float _1969 = _1967 * _1967;
                            precise float _1971 = _1829 * (-exp2(_1962));
                            precise float _1972 = _1971 + _1829;
                            precise float _1974 = uintBitsToFloat(ssbo_1_1.data[_1802]) + _1972;
                            precise float _1975 = _1969 * fma(-2.0, _1967, 3.0);
                            precise float _1977 = uintBitsToFloat(ssbo_1_1.data[_1790]) * _1974;
                            uint _1996;
                            if ((!_1952) && (uintBitsToFloat(_1783) < _1836))
                            {
                                precise float _1986 = uintBitsToFloat(ssbo_1_1.data[_1805]) * log2(abs(_1964));
                                precise float _1989 = uintBitsToFloat(ssbo_1_1.data[_1799]) * exp2(_1986);
                                precise float _1990 = _1989 * (-_1975);
                                precise float _1991 = _1990 + _1989;
                                precise float _1993 = _1975 * uintBitsToFloat(_1783);
                                precise float _1994 = _1993 + _1991;
                                _1996 = floatBitsToUint(_1994);
                            }
                            else
                            {
                                _1996 = floatBitsToUint(_1977);
                            }
                            _1997 = _1996;
                        }
                        else
                        {
                            _1997 = floatBitsToUint(_1946 ? 0.0 : uintBitsToFloat(ssbo_1_1.data[_1790]));
                        }
                        precise float _1999 = 0.412109375 * uintBitsToFloat(_1785);
                        precise float _2001 = 0.166748046875 * uintBitsToFloat(_1785);
                        precise float _2003 = uintBitsToFloat(_1784) * 0.52392578125;
                        precise float _2004 = _2003 + _1999;
                        precise float _2006 = uintBitsToFloat(_1784) * 0.720458984375;
                        precise float _2007 = _2006 + _2001;
                        precise float _2009 = uintBitsToFloat(_1783) * 0.06396484375;
                        precise float _2010 = _2009 + _2004;
                        precise float _2012 = uintBitsToFloat(_1783) * 0.11279296875;
                        precise float _2013 = _2012 + _2007;
                        precise float _2014 = 0.00999999977648258209228515625 * _2010;
                        precise float _2015 = 0.00999999977648258209228515625 * _2013;
                        precise float _2017 = 0.00999999977648258209228515625 * uintBitsToFloat(ssbo_1_1.data[_1790]);
                        precise float _2025 = 0.024169921875 * uintBitsToFloat(_1785);
                        precise float _2026 = 0.1593017578125 * log2(abs(_2014));
                        precise float _2027 = 0.1593017578125 * log2(abs(_2015));
                        precise float _2028 = 0.1593017578125 * log2(abs(_2017));
                        float _2029 = exp2(_2026);
                        float _2030 = exp2(_2028);
                        precise float _2032 = uintBitsToFloat(_1784) * 0.075439453125;
                        precise float _2033 = _2032 + _2025;
                        precise float _2035 = 0.166748046875 * uintBitsToFloat(_1891);
                        precise float _2036 = 18.6875 * _2029;
                        precise float _2037 = _2036 + 1.0;
                        float _2038 = exp2(_2027);
                        precise float _2040 = 0.412109375 * uintBitsToFloat(_1891);
                        precise float _2041 = 18.6875 * _2030;
                        precise float _2042 = _2041 + 1.0;
                        precise float _2044 = uintBitsToFloat(_1783) * 0.900390625;
                        precise float _2045 = _2044 + _2033;
                        precise float _2047 = uintBitsToFloat(_1944) * 0.52392578125;
                        precise float _2048 = _2047 + _2040;
                        precise float _2050 = uintBitsToFloat(_1944) * 0.720458984375;
                        precise float _2051 = _2050 + _2035;
                        precise float _2056 = 18.6875 * _2038;
                        precise float _2057 = _2056 + 1.0;
                        precise float _2060 = 0.00999999977648258209228515625 * _2045;
                        precise float _2062 = uintBitsToFloat(_1997) * 0.06396484375;
                        precise float _2063 = _2062 + _2048;
                        precise float _2065 = uintBitsToFloat(_1997) * 0.11279296875;
                        precise float _2066 = _2065 + _2051;
                        precise float _2067 = log2(fma(18.8515625, _2029, 0.8359375)) - log2(_2037);
                        precise float _2071 = 0.00999999977648258209228515625 * _2063;
                        precise float _2072 = 0.00999999977648258209228515625 * _2066;
                        precise float _2073 = log2(fma(18.8515625, _2030, 0.8359375)) - log2(_2042);
                        precise float _2076 = 0.1593017578125 * log2(abs(_2060));
                        precise float _2079 = 78.84375 * _2067;
                        precise float _2080 = log2(fma(18.8515625, _2038, 0.8359375)) - log2(_2057);
                        precise float _2083 = 78.84375 * _2080;
                        precise float _2084 = 78.84375 * _2073;
                        float _2085 = exp2(_2076);
                        precise float _2086 = 0.1593017578125 * log2(abs(_2071));
                        precise float _2087 = 0.1593017578125 * log2(abs(_2072));
                        float _2088 = exp2(_2079);
                        float _2089 = exp2(_2083);
                        precise float _2092 = 18.6875 * _2085;
                        precise float _2093 = _2092 + 1.0;
                        float _2094 = exp2(_2086);
                        float _2095 = exp2(_2087);
                        precise float _2096 = _2088 + _2089;
                        precise float _2097 = _2096 * 0.5;
                        precise float _2101 = uintBitsToFloat(ssbo_1_1.data[23u + buf0_dword_off]) - uintBitsToFloat(ssbo_1_1.data[_1808]);
                        precise float _2105 = 18.6875 * _2094;
                        precise float _2106 = _2105 + 1.0;
                        precise float _2108 = 18.6875 * _2095;
                        precise float _2109 = _2108 + 1.0;
                        precise float _2112 = _2097 * (1.0 / exp2(_2084));
                        precise float _2113 = _2112 + (-uintBitsToFloat(ssbo_1_1.data[_1808]));
                        precise float _2115 = log2(fma(18.8515625, _2085, 0.8359375)) - log2(_2093);
                        precise float _2120 = (1.0 / _2101) * _2113;
                        float _2121 = clamp(_2120, 0.0, 1.0);
                        precise float _2122 = 1.61376953125 * _2088;
                        precise float _2123 = 78.84375 * _2115;
                        precise float _2124 = log2(fma(18.8515625, _2094, 0.8359375)) - log2(_2106);
                        precise float _2125 = log2(fma(18.8515625, _2095, 0.8359375)) - log2(_2109);
                        precise float _2128 = (-_2121) * _2121;
                        precise float _2129 = _2089 * (-3.323486328125);
                        precise float _2130 = _2129 + _2122;
                        float _2131 = exp2(_2123);
                        precise float _2132 = 78.84375 * _2124;
                        precise float _2133 = 78.84375 * _2125;
                        precise float _2134 = 4.378173828125 * _2088;
                        precise float _2135 = _2128 * fma(-2.0, _2121, 3.0);
                        precise float _2136 = _2135 + 1.0;
                        precise float _2137 = _2131 * 1.709716796875;
                        precise float _2138 = _2137 + _2130;
                        precise float _2141 = _2089 * (-4.24560546875);
                        precise float _2142 = _2141 + _2134;
                        precise float _2143 = _2138 * _2136;
                        precise float _2144 = exp2(_2132) + exp2(_2133);
                        precise float _2145 = _2144 * 0.5;
                        precise float _2146 = _2131 * (-0.132568359375);
                        precise float _2147 = _2146 + _2142;
                        precise float _2148 = _2143 * 0.0089999996125698089599609375;
                        precise float _2149 = _2148 + _2145;
                        precise float _2150 = _2147 * _2136;
                        precise float _2151 = _2150 * 0.111000001430511474609375;
                        precise float _2152 = _2151 + _2149;
                        precise float _2153 = _2143 * (-0.0089999996125698089599609375);
                        precise float _2154 = _2153 + _2145;
                        precise float _2157 = _2150 * (-0.111000001430511474609375);
                        precise float _2158 = _2157 + _2154;
                        precise float _2159 = _2143 * 0.560000002384185791015625;
                        precise float _2160 = _2159 + _2145;
                        precise float _2161 = 0.0126833133399486541748046875 * log2(abs(_2152));
                        precise float _2164 = _2150 * (-0.3210000097751617431640625);
                        precise float _2165 = _2164 + _2160;
                        float _2166 = exp2(_2161);
                        precise float _2167 = 0.0126833133399486541748046875 * log2(abs(_2158));
                        float _2171 = exp2(_2167);
                        precise float _2172 = 0.0126833133399486541748046875 * log2(abs(_2165));
                        precise float _2174 = (-0.8359375) + _2166;
                        float _2176 = exp2(_2172);
                        precise float _2177 = (1.0 / fma(-18.6875, _2166, 18.8515625)) * _2174;
                        precise float _2179 = (-0.8359375) + _2171;
                        precise float _2183 = (1.0 / fma(-18.6875, _2171, 18.8515625)) * _2179;
                        precise float _2185 = (-0.8359375) + _2176;
                        precise float _2186 = 6.277394771575927734375 * log2(abs(_2177));
                        precise float _2189 = (1.0 / fma(-18.6875, _2176, 18.8515625)) * _2185;
                        float _2190 = exp2(_2186);
                        precise float _2191 = 6.277394771575927734375 * log2(abs(_2183));
                        precise float _2196 = 343.6610107421875 * _2190;
                        precise float _2197 = _2196 + (-uintBitsToFloat(_1891));
                        float _2198 = exp2(_2191);
                        precise float _2199 = 6.277394771575927734375 * log2(abs(_2189));
                        precise float _2202 = (-79.13299560546875) * _2190;
                        precise float _2203 = _2202 + (-uintBitsToFloat(_1944));
                        precise float _2206 = (-2.5949900150299072265625) * _2190;
                        precise float _2207 = _2206 + (-uintBitsToFloat(_1997));
                        precise float _2208 = _2198 * (-250.644989013671875);
                        precise float _2209 = _2208 + _2197;
                        float _2210 = exp2(_2199);
                        precise float _2211 = _2198 * 198.3600006103515625;
                        precise float _2212 = _2211 + _2203;
                        precise float _2213 = _2198 * (-9.89136981964111328125);
                        precise float _2214 = _2213 + _2207;
                        precise float _2215 = _2210 * 6.98453998565673828125;
                        precise float _2216 = _2215 + _2209;
                        precise float _2217 = _2210 * (-19.227100372314453125);
                        precise float _2218 = _2217 + _2212;
                        precise float _2219 = _2210 * 112.4860076904296875;
                        precise float _2220 = _2219 + _2214;
                        precise float _2223 = uintBitsToFloat(ssbo_1_1.data[_1814]) * _2216;
                        precise float _2224 = _2223 + uintBitsToFloat(_1891);
                        precise float _2227 = uintBitsToFloat(ssbo_1_1.data[_1814]) * _2218;
                        precise float _2228 = _2227 + uintBitsToFloat(_1944);
                        precise float _2231 = uintBitsToFloat(ssbo_1_1.data[_1814]) * _2220;
                        precise float _2232 = _2231 + uintBitsToFloat(_1997);
                        precise float _2243 = uintBitsToFloat(ssbo_1_1.data[_1793]) * max(0.0, min(uintBitsToFloat(ssbo_1_1.data[_1790]), _2224));
                        precise float _2246 = uintBitsToFloat(ssbo_1_1.data[_1793]) * max(0.0, min(uintBitsToFloat(ssbo_1_1.data[_1790]), _2228));
                        precise float _2249 = uintBitsToFloat(ssbo_1_1.data[_1793]) * max(0.0, min(uintBitsToFloat(ssbo_1_1.data[_1790]), _2232));
                        uint _2275;
                        uint _2276;
                        uint _2277;
                        if (_332)
                        {
                            uint _2257 = 8u + buf0_dword_off;
                            precise float _2264 = uintBitsToFloat(ssbo_1_1.data[_2257]) * log2(clamp(max(0.0, _2243), 0.0, 1.0));
                            precise float _2266 = uintBitsToFloat(ssbo_1_1.data[_2257]) * log2(clamp(max(0.0, _2246), 0.0, 1.0));
                            precise float _2268 = uintBitsToFloat(ssbo_1_1.data[_2257]) * log2(clamp(max(0.0, _2249), 0.0, 1.0));
                            _2275 = floatBitsToUint(exp2(_2268));
                            _2276 = floatBitsToUint(exp2(_2266));
                            _2277 = floatBitsToUint(exp2(_2264));
                        }
                        else
                        {
                            _2275 = floatBitsToUint(_2249);
                            _2276 = floatBitsToUint(_2246);
                            _2277 = floatBitsToUint(_2243);
                        }
                        vec4 _2281 = vec4(uintBitsToFloat(_2277), uintBitsToFloat(_2276), uintBitsToFloat(_2275), 1.0);
                        imageStore(cs_img0, ivec3(uvec3(_247, _259, _261)), vec4(_2281.w, _2281.z, _2281.y, _2281.x));
                        _2285 = _2275;
                        _2286 = _2276;
                        _2287 = _2277;
                    }
                    else
                    {
                        _2285 = _1783;
                        _2286 = _1784;
                        _2287 = _1785;
                    }
                    if (!_1786)
                    {
                        if (uintBitsToFloat(_236) < 15.0)
                        {
                            bool _2289 = 0.0 > uintBitsToFloat(_2287);
                            uint _2290 = 16u + buf0_dword_off;
                            uint _2293 = 17u + buf0_dword_off;
                            uint _2299 = 19u + buf0_dword_off;
                            uint _2302 = 20u + buf0_dword_off;
                            uint _2305 = 21u + buf0_dword_off;
                            uint _2308 = 22u + buf0_dword_off;
                            uint _2314 = 24u + buf0_dword_off;
                            precise float _2318 = (-1.0) + uintBitsToFloat(ssbo_1_1.data[18u + buf0_dword_off]);
                            float _2319 = 1.0 / _2318;
                            precise float _2321 = (-1.0) + uintBitsToFloat(ssbo_1_1.data[_2302]);
                            precise float _2323 = _2319 * _2321;
                            precise float _2324 = _2323 + uintBitsToFloat(ssbo_1_1.data[_2302]);
                            precise float _2326 = (-1.0) + _2324;
                            precise float _2327 = (1.0 / _2321) * _2318;
                            precise float _2328 = _2327 * _2326;
                            precise float _2329 = _2319 * _2321;
                            precise float _2332 = uintBitsToFloat(ssbo_1_1.data[_2290]) * _2329;
                            precise float _2333 = log2(_2328) * _2332;
                            precise float _2336 = uintBitsToFloat(ssbo_1_1.data[_2290]) * uintBitsToFloat(ssbo_1_1.data[_2302]);
                            precise float _2337 = _2333 * (-0.693147182464599609375);
                            precise float _2338 = _2337 + _2336;
                            bool _2344 = (uintBitsToFloat(_2287) >= _2338) || _2289;
                            uint _2389;
                            if (!_2344)
                            {
                                precise float _2347 = 1.44269502162933349609375 * _2336;
                                precise float _2349 = uintBitsToFloat(_2287) * (-1.44269502162933349609375);
                                precise float _2350 = _2349 + _2347;
                                precise float _2354 = (1.0 / _2332) * _2350;
                                precise float _2356 = (1.0 / uintBitsToFloat(ssbo_1_1.data[_2299])) * uintBitsToFloat(_2287);
                                float _2359 = clamp(max(0.0, _2356), 0.0, 1.0);
                                precise float _2361 = (-exp2(_2354)) * _2329;
                                precise float _2362 = _2361 + _2329;
                                precise float _2364 = _2359 * _2359;
                                precise float _2366 = uintBitsToFloat(ssbo_1_1.data[_2302]) + _2362;
                                precise float _2367 = _2364 * fma(-2.0, _2359, 3.0);
                                precise float _2369 = uintBitsToFloat(ssbo_1_1.data[_2290]) * _2366;
                                uint _2388;
                                if ((!_2344) && (uintBitsToFloat(_2287) < _2336))
                                {
                                    precise float _2378 = uintBitsToFloat(ssbo_1_1.data[_2305]) * log2(abs(_2356));
                                    precise float _2381 = uintBitsToFloat(ssbo_1_1.data[_2299]) * exp2(_2378);
                                    precise float _2382 = (-_2367) * _2381;
                                    precise float _2383 = _2382 + _2381;
                                    precise float _2385 = _2367 * uintBitsToFloat(_2287);
                                    precise float _2386 = _2385 + _2383;
                                    _2388 = floatBitsToUint(_2386);
                                }
                                else
                                {
                                    _2388 = floatBitsToUint(_2369);
                                }
                                _2389 = _2388;
                            }
                            else
                            {
                                _2389 = floatBitsToUint(_2289 ? 0.0 : uintBitsToFloat(ssbo_1_1.data[_2290]));
                            }
                            bool _2391 = 0.0 > uintBitsToFloat(_2286);
                            bool _2397 = (uintBitsToFloat(_2286) >= _2338) || _2391;
                            uint _2442;
                            if (!_2397)
                            {
                                precise float _2400 = 1.44269502162933349609375 * _2336;
                                precise float _2402 = uintBitsToFloat(_2286) * (-1.44269502162933349609375);
                                precise float _2403 = _2402 + _2400;
                                precise float _2407 = (1.0 / _2332) * _2403;
                                precise float _2409 = (1.0 / uintBitsToFloat(ssbo_1_1.data[_2299])) * uintBitsToFloat(_2286);
                                float _2412 = clamp(max(0.0, _2409), 0.0, 1.0);
                                precise float _2414 = (-exp2(_2407)) * _2329;
                                precise float _2415 = _2414 + _2329;
                                precise float _2417 = _2412 * _2412;
                                precise float _2419 = uintBitsToFloat(ssbo_1_1.data[_2302]) + _2415;
                                precise float _2420 = _2417 * fma(-2.0, _2412, 3.0);
                                precise float _2422 = uintBitsToFloat(ssbo_1_1.data[_2290]) * _2419;
                                uint _2441;
                                if ((!_2397) && (uintBitsToFloat(_2286) < _2336))
                                {
                                    precise float _2431 = uintBitsToFloat(ssbo_1_1.data[_2305]) * log2(abs(_2409));
                                    precise float _2434 = uintBitsToFloat(ssbo_1_1.data[_2299]) * exp2(_2431);
                                    precise float _2435 = (-_2420) * _2434;
                                    precise float _2436 = _2435 + _2434;
                                    precise float _2438 = _2420 * uintBitsToFloat(_2286);
                                    precise float _2439 = _2438 + _2436;
                                    _2441 = floatBitsToUint(_2439);
                                }
                                else
                                {
                                    _2441 = floatBitsToUint(_2422);
                                }
                                _2442 = _2441;
                            }
                            else
                            {
                                _2442 = floatBitsToUint(_2391 ? 0.0 : uintBitsToFloat(ssbo_1_1.data[_2290]));
                            }
                            bool _2444 = 0.0 > uintBitsToFloat(_2285);
                            bool _2450 = (uintBitsToFloat(_2285) >= _2338) || _2444;
                            uint _2495;
                            if (!_2450)
                            {
                                precise float _2453 = 1.44269502162933349609375 * _2336;
                                precise float _2455 = uintBitsToFloat(_2285) * (-1.44269502162933349609375);
                                precise float _2456 = _2455 + _2453;
                                precise float _2460 = (1.0 / _2332) * _2456;
                                precise float _2462 = (1.0 / uintBitsToFloat(ssbo_1_1.data[_2299])) * uintBitsToFloat(_2285);
                                float _2465 = clamp(max(0.0, _2462), 0.0, 1.0);
                                precise float _2467 = _2465 * _2465;
                                precise float _2469 = _2329 * (-exp2(_2460));
                                precise float _2470 = _2469 + _2329;
                                precise float _2472 = uintBitsToFloat(ssbo_1_1.data[_2302]) + _2470;
                                precise float _2473 = _2467 * fma(-2.0, _2465, 3.0);
                                precise float _2475 = uintBitsToFloat(ssbo_1_1.data[_2290]) * _2472;
                                uint _2494;
                                if ((!_2450) && (uintBitsToFloat(_2285) < _2336))
                                {
                                    precise float _2484 = uintBitsToFloat(ssbo_1_1.data[_2305]) * log2(abs(_2462));
                                    precise float _2487 = uintBitsToFloat(ssbo_1_1.data[_2299]) * exp2(_2484);
                                    precise float _2488 = (-_2473) * _2487;
                                    precise float _2489 = _2488 + _2487;
                                    precise float _2491 = _2473 * uintBitsToFloat(_2285);
                                    precise float _2492 = _2491 + _2489;
                                    _2494 = floatBitsToUint(_2492);
                                }
                                else
                                {
                                    _2494 = floatBitsToUint(_2475);
                                }
                                _2495 = _2494;
                            }
                            else
                            {
                                _2495 = floatBitsToUint(_2444 ? 0.0 : uintBitsToFloat(ssbo_1_1.data[_2290]));
                            }
                            precise float _2497 = 0.412109375 * uintBitsToFloat(_2287);
                            precise float _2499 = 0.166748046875 * uintBitsToFloat(_2287);
                            precise float _2501 = uintBitsToFloat(_2286) * 0.52392578125;
                            precise float _2502 = _2501 + _2497;
                            precise float _2504 = uintBitsToFloat(_2286) * 0.720458984375;
                            precise float _2505 = _2504 + _2499;
                            precise float _2507 = uintBitsToFloat(_2285) * 0.06396484375;
                            precise float _2508 = _2507 + _2502;
                            precise float _2510 = uintBitsToFloat(_2285) * 0.11279296875;
                            precise float _2511 = _2510 + _2505;
                            precise float _2512 = 0.00999999977648258209228515625 * _2508;
                            precise float _2513 = 0.00999999977648258209228515625 * _2511;
                            precise float _2515 = 0.00999999977648258209228515625 * uintBitsToFloat(ssbo_1_1.data[_2290]);
                            precise float _2523 = 0.024169921875 * uintBitsToFloat(_2287);
                            precise float _2524 = 0.1593017578125 * log2(abs(_2512));
                            precise float _2525 = 0.1593017578125 * log2(abs(_2513));
                            precise float _2526 = 0.1593017578125 * log2(abs(_2515));
                            precise float _2528 = uintBitsToFloat(_2286) * 0.075439453125;
                            precise float _2529 = _2528 + _2523;
                            precise float _2531 = 0.412109375 * uintBitsToFloat(_2389);
                            precise float _2533 = 0.166748046875 * uintBitsToFloat(_2389);
                            float _2534 = exp2(_2524);
                            float _2535 = exp2(_2525);
                            float _2536 = exp2(_2526);
                            precise float _2538 = uintBitsToFloat(_2285) * 0.900390625;
                            precise float _2539 = _2538 + _2529;
                            precise float _2541 = uintBitsToFloat(_2442) * 0.52392578125;
                            precise float _2542 = _2541 + _2531;
                            precise float _2544 = uintBitsToFloat(_2442) * 0.720458984375;
                            precise float _2545 = _2544 + _2533;
                            precise float _2547 = 18.6875 * _2534;
                            precise float _2548 = _2547 + 1.0;
                            precise float _2550 = 18.6875 * _2535;
                            precise float _2551 = _2550 + 1.0;
                            precise float _2553 = 18.6875 * _2536;
                            precise float _2554 = _2553 + 1.0;
                            precise float _2555 = 0.00999999977648258209228515625 * _2539;
                            precise float _2557 = uintBitsToFloat(_2495) * 0.06396484375;
                            precise float _2558 = _2557 + _2542;
                            precise float _2560 = uintBitsToFloat(_2495) * 0.11279296875;
                            precise float _2561 = _2560 + _2545;
                            precise float _2570 = 0.00999999977648258209228515625 * _2558;
                            precise float _2571 = 0.00999999977648258209228515625 * _2561;
                            precise float _2572 = log2(fma(18.8515625, _2534, 0.8359375)) - log2(_2548);
                            precise float _2573 = log2(fma(18.8515625, _2535, 0.8359375)) - log2(_2551);
                            precise float _2574 = log2(fma(18.8515625, _2536, 0.8359375)) - log2(_2554);
                            precise float _2575 = 0.1593017578125 * log2(abs(_2555));
                            precise float _2580 = 78.84375 * _2572;
                            precise float _2581 = 78.84375 * _2573;
                            precise float _2582 = 78.84375 * _2574;
                            float _2583 = exp2(_2575);
                            precise float _2584 = 0.1593017578125 * log2(abs(_2570));
                            precise float _2585 = 0.1593017578125 * log2(abs(_2571));
                            float _2586 = exp2(_2580);
                            float _2587 = exp2(_2581);
                            precise float _2590 = 18.6875 * _2583;
                            precise float _2591 = _2590 + 1.0;
                            float _2592 = exp2(_2584);
                            float _2593 = exp2(_2585);
                            precise float _2594 = _2586 + _2587;
                            precise float _2595 = _2594 * 0.5;
                            precise float _2599 = uintBitsToFloat(ssbo_1_1.data[23u + buf0_dword_off]) - uintBitsToFloat(ssbo_1_1.data[_2308]);
                            precise float _2603 = 18.6875 * _2592;
                            precise float _2604 = _2603 + 1.0;
                            precise float _2606 = 18.6875 * _2593;
                            precise float _2607 = _2606 + 1.0;
                            precise float _2610 = _2595 * (1.0 / exp2(_2582));
                            precise float _2611 = _2610 + (-uintBitsToFloat(ssbo_1_1.data[_2308]));
                            precise float _2613 = log2(fma(18.8515625, _2583, 0.8359375)) - log2(_2591);
                            precise float _2618 = (1.0 / _2599) * _2611;
                            float _2619 = clamp(_2618, 0.0, 1.0);
                            precise float _2620 = 1.61376953125 * _2586;
                            precise float _2621 = 78.84375 * _2613;
                            precise float _2622 = log2(fma(18.8515625, _2592, 0.8359375)) - log2(_2604);
                            precise float _2623 = log2(fma(18.8515625, _2593, 0.8359375)) - log2(_2607);
                            precise float _2626 = (-_2619) * _2619;
                            precise float _2627 = _2587 * (-3.323486328125);
                            precise float _2628 = _2627 + _2620;
                            float _2629 = exp2(_2621);
                            precise float _2630 = 78.84375 * _2622;
                            precise float _2631 = 78.84375 * _2623;
                            precise float _2632 = 4.378173828125 * _2586;
                            precise float _2633 = _2626 * fma(-2.0, _2619, 3.0);
                            precise float _2634 = _2633 + 1.0;
                            precise float _2635 = _2629 * 1.709716796875;
                            precise float _2636 = _2635 + _2628;
                            precise float _2639 = _2587 * (-4.24560546875);
                            precise float _2640 = _2639 + _2632;
                            precise float _2641 = _2636 * _2634;
                            precise float _2642 = exp2(_2630) + exp2(_2631);
                            precise float _2643 = _2642 * 0.5;
                            precise float _2644 = _2629 * (-0.132568359375);
                            precise float _2645 = _2644 + _2640;
                            precise float _2646 = _2641 * 0.0089999996125698089599609375;
                            precise float _2647 = _2646 + _2643;
                            precise float _2648 = _2645 * _2634;
                            precise float _2649 = _2648 * 0.111000001430511474609375;
                            precise float _2650 = _2649 + _2647;
                            precise float _2651 = _2641 * (-0.0089999996125698089599609375);
                            precise float _2652 = _2651 + _2643;
                            precise float _2655 = _2648 * (-0.111000001430511474609375);
                            precise float _2656 = _2655 + _2652;
                            precise float _2657 = _2641 * 0.560000002384185791015625;
                            precise float _2658 = _2657 + _2643;
                            precise float _2659 = 0.0126833133399486541748046875 * log2(abs(_2650));
                            precise float _2662 = _2648 * (-0.3210000097751617431640625);
                            precise float _2663 = _2662 + _2658;
                            float _2664 = exp2(_2659);
                            precise float _2665 = 0.0126833133399486541748046875 * log2(abs(_2656));
                            float _2669 = exp2(_2665);
                            precise float _2670 = 0.0126833133399486541748046875 * log2(abs(_2663));
                            precise float _2672 = (-0.8359375) + _2664;
                            float _2674 = exp2(_2670);
                            precise float _2675 = (1.0 / fma(-18.6875, _2664, 18.8515625)) * _2672;
                            precise float _2677 = (-0.8359375) + _2669;
                            precise float _2681 = (1.0 / fma(-18.6875, _2669, 18.8515625)) * _2677;
                            precise float _2683 = (-0.8359375) + _2674;
                            precise float _2684 = 6.277394771575927734375 * log2(abs(_2675));
                            precise float _2687 = (1.0 / fma(-18.6875, _2674, 18.8515625)) * _2683;
                            float _2688 = exp2(_2684);
                            precise float _2689 = 6.277394771575927734375 * log2(abs(_2681));
                            precise float _2694 = 343.6610107421875 * _2688;
                            precise float _2695 = _2694 + (-uintBitsToFloat(_2389));
                            float _2696 = exp2(_2689);
                            precise float _2697 = 6.277394771575927734375 * log2(abs(_2687));
                            precise float _2700 = (-79.13299560546875) * _2688;
                            precise float _2701 = _2700 + (-uintBitsToFloat(_2442));
                            precise float _2704 = (-2.5949900150299072265625) * _2688;
                            precise float _2705 = _2704 + (-uintBitsToFloat(_2495));
                            precise float _2706 = _2696 * (-250.644989013671875);
                            precise float _2707 = _2706 + _2695;
                            float _2708 = exp2(_2697);
                            precise float _2709 = _2696 * 198.3600006103515625;
                            precise float _2710 = _2709 + _2701;
                            precise float _2711 = _2696 * (-9.89136981964111328125);
                            precise float _2712 = _2711 + _2705;
                            precise float _2713 = _2708 * 6.98453998565673828125;
                            precise float _2714 = _2713 + _2707;
                            precise float _2715 = _2708 * (-19.227100372314453125);
                            precise float _2716 = _2715 + _2710;
                            precise float _2717 = _2708 * 112.4860076904296875;
                            precise float _2718 = _2717 + _2712;
                            precise float _2721 = uintBitsToFloat(ssbo_1_1.data[_2314]) * _2714;
                            precise float _2722 = _2721 + uintBitsToFloat(_2389);
                            precise float _2725 = uintBitsToFloat(ssbo_1_1.data[_2314]) * _2716;
                            precise float _2726 = _2725 + uintBitsToFloat(_2442);
                            precise float _2729 = uintBitsToFloat(ssbo_1_1.data[_2314]) * _2718;
                            precise float _2730 = _2729 + uintBitsToFloat(_2495);
                            precise float _2741 = uintBitsToFloat(ssbo_1_1.data[_2293]) * max(0.0, min(uintBitsToFloat(ssbo_1_1.data[_2290]), _2722));
                            precise float _2744 = uintBitsToFloat(ssbo_1_1.data[_2293]) * max(0.0, min(uintBitsToFloat(ssbo_1_1.data[_2290]), _2726));
                            precise float _2747 = uintBitsToFloat(ssbo_1_1.data[_2293]) * max(0.0, min(uintBitsToFloat(ssbo_1_1.data[_2290]), _2730));
                            uint _2773;
                            uint _2774;
                            uint _2775;
                            if (_332)
                            {
                                uint _2755 = 8u + buf0_dword_off;
                                precise float _2762 = uintBitsToFloat(ssbo_1_1.data[_2755]) * log2(clamp(max(0.0, _2741), 0.0, 1.0));
                                precise float _2764 = uintBitsToFloat(ssbo_1_1.data[_2755]) * log2(clamp(max(0.0, _2744), 0.0, 1.0));
                                precise float _2766 = uintBitsToFloat(ssbo_1_1.data[_2755]) * log2(clamp(max(0.0, _2747), 0.0, 1.0));
                                _2773 = floatBitsToUint(exp2(_2762));
                                _2774 = floatBitsToUint(exp2(_2764));
                                _2775 = floatBitsToUint(exp2(_2766));
                            }
                            else
                            {
                                _2773 = floatBitsToUint(_2741);
                                _2774 = floatBitsToUint(_2744);
                                _2775 = floatBitsToUint(_2747);
                            }
                            precise float _2805 = uintBitsToFloat(ssbo_1_1.data[30u + buf0_dword_off]) * uintBitsToFloat(_2775);
                            precise float _2809 = uintBitsToFloat(ssbo_1_1.data[38u + buf0_dword_off]) * uintBitsToFloat(_2775);
                            precise float _2812 = uintBitsToFloat(_2774) * uintBitsToFloat(ssbo_1_1.data[37u + buf0_dword_off]);
                            precise float _2813 = _2812 + _2809;
                            bool _2816 = uintBitsToFloat(_946) < 10.0;
                            bool _2819 = uintBitsToFloat(_946) < 11.0;
                            precise float _2822 = uintBitsToFloat(ssbo_1_1.data[34u + buf0_dword_off]) * uintBitsToFloat(_2775);
                            precise float _2825 = uintBitsToFloat(_2774) * uintBitsToFloat(ssbo_1_1.data[29u + buf0_dword_off]);
                            precise float _2826 = _2825 + _2805;
                            precise float _2829 = uintBitsToFloat(ssbo_1_1.data[33u + buf0_dword_off]) * uintBitsToFloat(_2774);
                            precise float _2830 = _2829 + _2822;
                            precise float _2833 = uintBitsToFloat(ssbo_1_1.data[32u + buf0_dword_off]) * uintBitsToFloat(_2773);
                            precise float _2834 = _2833 + _2830;
                            precise float _2838 = uintBitsToFloat(ssbo_1_1.data[36u + buf0_dword_off]) * uintBitsToFloat(_2773);
                            precise float _2839 = _2838 + _2813;
                            precise float _2842 = uintBitsToFloat(ssbo_1_1.data[28u + buf0_dword_off]) * uintBitsToFloat(_2773);
                            precise float _2843 = _2842 + _2826;
                            uint _2870;
                            uint _2871;
                            uint _2872;
                            uint _2873;
                            if (_2816)
                            {
                                precise float _2857 = 0.454545438289642333984375 * uintBitsToFloat(ssbo_1_1.data[9u + buf0_dword_off]);
                                precise float _2860 = log2(clamp(max(0.0, _2843), 0.0, 1.0)) * _2857;
                                precise float _2862 = log2(clamp(max(0.0, _2834), 0.0, 1.0)) * _2857;
                                precise float _2863 = log2(clamp(max(0.0, _2839), 0.0, 1.0)) * _2857;
                                _2870 = floatBitsToUint(exp2(_2863));
                                _2871 = floatBitsToUint(_2860);
                                _2872 = floatBitsToUint(exp2(_2862));
                                _2873 = floatBitsToUint(exp2(_2860));
                            }
                            else
                            {
                                _2870 = floatBitsToUint(_2805);
                                _2871 = floatBitsToUint(_2843);
                                _2872 = floatBitsToUint(_2834);
                                _2873 = 1100402688u;
                            }
                            uint _3062;
                            uint _3063;
                            uint _3064;
                            if (!_2816)
                            {
                                uint _2923;
                                uint _2924;
                                uint _2925;
                                uint _2926;
                                if (_2819)
                                {
                                    precise float _2876 = 0.00999999977648258209228515625 * uintBitsToFloat(_2871);
                                    precise float _2878 = 0.00999999977648258209228515625 * uintBitsToFloat(_2872);
                                    precise float _2879 = 0.00999999977648258209228515625 * _2839;
                                    precise float _2886 = 0.1593017578125 * log2(abs(_2876));
                                    precise float _2887 = 0.1593017578125 * log2(abs(_2878));
                                    precise float _2888 = 0.1593017578125 * log2(abs(_2879));
                                    float _2889 = exp2(_2886);
                                    float _2890 = exp2(_2887);
                                    float _2891 = exp2(_2888);
                                    precise float _2894 = 18.6875 * _2889;
                                    precise float _2895 = _2894 + 1.0;
                                    precise float _2898 = 18.6875 * _2890;
                                    precise float _2899 = _2898 + 1.0;
                                    precise float _2902 = 18.6875 * _2891;
                                    precise float _2903 = _2902 + 1.0;
                                    precise float _2910 = log2(fma(uintBitsToFloat(_2873), _2889, 0.8359375)) - log2(_2895);
                                    precise float _2911 = log2(fma(uintBitsToFloat(_2873), _2890, 0.8359375)) - log2(_2899);
                                    precise float _2912 = log2(fma(uintBitsToFloat(_2873), _2891, 0.8359375)) - log2(_2903);
                                    precise float _2913 = 78.84375 * _2910;
                                    precise float _2914 = 78.84375 * _2911;
                                    precise float _2915 = 78.84375 * _2912;
                                    _2923 = floatBitsToUint(exp2(_2915));
                                    _2924 = floatBitsToUint(exp2(_2913));
                                    _2925 = floatBitsToUint(exp2(_2914));
                                    _2926 = floatBitsToUint(_2915);
                                }
                                else
                                {
                                    _2923 = _2870;
                                    _2924 = _2873;
                                    _2925 = _2872;
                                    _2926 = _2871;
                                }
                                uint _3059;
                                uint _3060;
                                uint _3061;
                                if (!_2819)
                                {
                                    precise float _2928 = 4.5 * uintBitsToFloat(_2926);
                                    bool _2932 = uintBitsToFloat(_946) < 12.0;
                                    bool _2935 = uintBitsToFloat(_946) < 13.0;
                                    precise float _2940 = 12.9200000762939453125 * uintBitsToFloat(_2926);
                                    uint _2941 = floatBitsToUint(_2940);
                                    uint _2977;
                                    uint _2978;
                                    uint _2979;
                                    uint _2980;
                                    if (_2932)
                                    {
                                        uint _2954;
                                        if (!(0.003130800090730190277099609375 >= uintBitsToFloat(_2926)))
                                        {
                                            precise float _2950 = 0.4166666567325592041015625 * log2(uintBitsToFloat(_2926));
                                            _2954 = floatBitsToUint(fma(1.05499994754791259765625, exp2(_2950), -0.054999999701976776123046875));
                                        }
                                        else
                                        {
                                            _2954 = _2941;
                                        }
                                        precise float _2958 = 12.9200000762939453125 * uintBitsToFloat(_2925);
                                        uint _2966;
                                        if (uintBitsToFloat(_2925) > 0.003130800090730190277099609375)
                                        {
                                            precise float _2962 = 0.4166666567325592041015625 * log2(uintBitsToFloat(_2925));
                                            _2966 = floatBitsToUint(fma(1.05499994754791259765625, exp2(_2962), -0.054999999701976776123046875));
                                        }
                                        else
                                        {
                                            _2966 = floatBitsToUint(_2958);
                                        }
                                        precise float _2968 = 12.9200000762939453125 * _2839;
                                        uint _2975;
                                        uint _2976;
                                        if (_2839 > 0.003130800090730190277099609375)
                                        {
                                            precise float _2971 = 0.4166666567325592041015625 * log2(_2839);
                                            _2975 = floatBitsToUint(fma(1.05499994754791259765625, exp2(_2971), -0.054999999701976776123046875));
                                            _2976 = 1065814589u;
                                        }
                                        else
                                        {
                                            _2975 = floatBitsToUint(_2968);
                                            _2976 = _2966;
                                        }
                                        _2977 = _2975;
                                        _2978 = _2954;
                                        _2979 = _2966;
                                        _2980 = _2976;
                                    }
                                    else
                                    {
                                        _2977 = _2923;
                                        _2978 = _2941;
                                        _2979 = _2925;
                                        _2980 = _2926;
                                    }
                                    uint _3056;
                                    uint _3057;
                                    uint _3058;
                                    if (!_2932)
                                    {
                                        uint _3012;
                                        uint _3013;
                                        uint _3014;
                                        uint _3015;
                                        if (_2935)
                                        {
                                            uint _2989;
                                            if (!(0.017999999225139617919921875 > uintBitsToFloat(_2926)))
                                            {
                                                precise float _2985 = 0.449999988079071044921875 * log2(uintBitsToFloat(_2980));
                                                _2989 = floatBitsToUint(fma(1.09899997711181640625, exp2(_2985), -0.098999999463558197021484375));
                                            }
                                            else
                                            {
                                                _2989 = floatBitsToUint(_2928);
                                            }
                                            precise float _2993 = 4.5 * uintBitsToFloat(_2979);
                                            uint _3001;
                                            if (uintBitsToFloat(_2979) >= 0.017999999225139617919921875)
                                            {
                                                precise float _2997 = 0.449999988079071044921875 * log2(uintBitsToFloat(_2979));
                                                _3001 = floatBitsToUint(fma(1.09899997711181640625, exp2(_2997), -0.098999999463558197021484375));
                                            }
                                            else
                                            {
                                                _3001 = floatBitsToUint(_2993);
                                            }
                                            precise float _3003 = 4.5 * _2839;
                                            uint _3010;
                                            uint _3011;
                                            if (_2839 >= 0.017999999225139617919921875)
                                            {
                                                precise float _3006 = 0.449999988079071044921875 * log2(_2839);
                                                _3010 = floatBitsToUint(fma(1.09899997711181640625, exp2(_3006), -0.098999999463558197021484375));
                                                _3011 = 1066183688u;
                                            }
                                            else
                                            {
                                                _3010 = floatBitsToUint(_3003);
                                                _3011 = _3001;
                                            }
                                            _3012 = _3010;
                                            _3013 = _2989;
                                            _3014 = _3001;
                                            _3015 = _3011;
                                        }
                                        else
                                        {
                                            _3012 = _2977;
                                            _3013 = _2978;
                                            _3014 = _2979;
                                            _3015 = _2980;
                                        }
                                        uint _3053;
                                        uint _3054;
                                        uint _3055;
                                        if (!_2935)
                                        {
                                            uint _3050;
                                            uint _3051;
                                            uint _3052;
                                            if (uintBitsToFloat(_946) < 14.0)
                                            {
                                                precise float _3028 = 2.400000095367431640625 * log2(abs(fma(0.947867333889007568359375, uintBitsToFloat(_3015), 0.052132703363895416259765625)));
                                                precise float _3029 = 2.400000095367431640625 * log2(abs(fma(0.947867333889007568359375, uintBitsToFloat(_3014), 0.052132703363895416259765625)));
                                                precise float _3030 = 2.400000095367431640625 * log2(abs(fma(0.947867333889007568359375, _2839, 0.052132703363895416259765625)));
                                                precise float _3035 = 0.077399380505084991455078125 * uintBitsToFloat(_3015);
                                                precise float _3040 = 0.077399380505084991455078125 * uintBitsToFloat(_3014);
                                                precise float _3043 = 0.077399380505084991455078125 * _2839;
                                                _3050 = floatBitsToUint((0.040449999272823333740234375 > _2839) ? _3043 : exp2(_3030));
                                                _3051 = floatBitsToUint((0.040449999272823333740234375 > uintBitsToFloat(_3014)) ? _3040 : exp2(_3029));
                                                _3052 = floatBitsToUint((0.040449999272823333740234375 > uintBitsToFloat(_3015)) ? _3035 : exp2(_3028));
                                            }
                                            else
                                            {
                                                _3050 = floatBitsToUint(_2839);
                                                _3051 = _3014;
                                                _3052 = _3015;
                                            }
                                            _3053 = _3050;
                                            _3054 = _3051;
                                            _3055 = _3052;
                                        }
                                        else
                                        {
                                            _3053 = _3012;
                                            _3054 = _3014;
                                            _3055 = _3013;
                                        }
                                        _3056 = _3053;
                                        _3057 = _3054;
                                        _3058 = _3055;
                                    }
                                    else
                                    {
                                        _3056 = _2977;
                                        _3057 = _2979;
                                        _3058 = _2978;
                                    }
                                    _3059 = _3056;
                                    _3060 = _3057;
                                    _3061 = _3058;
                                }
                                else
                                {
                                    _3059 = _2923;
                                    _3060 = _2925;
                                    _3061 = _2924;
                                }
                                _3062 = _3061;
                                _3063 = _3059;
                                _3064 = _3060;
                            }
                            else
                            {
                                _3062 = _2873;
                                _3063 = _2870;
                                _3064 = _2872;
                            }
                            vec4 _3074 = vec4(clamp(max(0.0, uintBitsToFloat(_3062)), 0.0, 1.0), clamp(max(0.0, uintBitsToFloat(_3064)), 0.0, 1.0), clamp(max(0.0, uintBitsToFloat(_3063)), 0.0, 1.0), 1.0);
                            imageStore(cs_img0, ivec3(uvec3(_247, _259, _261)), vec4(_3074.w, _3074.z, _3074.y, _3074.x));
                        }
                    }
                }
            }
        }
    }
}

