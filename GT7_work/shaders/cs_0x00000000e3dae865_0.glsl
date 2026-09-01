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

layout(binding = 6) uniform writeonly image3D cs_img56;
layout(binding = 7) uniform writeonly image3D cs_img64;
uniform sampler2D SPIRV_Cross_Combinedcs_img48cs_sampsgpr_8;
uniform sampler2D SPIRV_Cross_Combinedcs_img16cs_sampinline_0xfff00000000190_0x8000000002500000;
uniform sampler2DArray SPIRV_Cross_Combinedcs_img24cs_sampsgpr_4;
uniform sampler2DArray SPIRV_Cross_Combinedcs_img32cs_sampsgpr_4;
uniform sampler2D SPIRV_Cross_Combinedcs_img40cs_sampinline_0xfff00000000024_0x2500000;

void main()
{
    uint buf0_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(0u), int(8u)) >> 2u;
    uint _121 = 100u + buf0_dword_off;
    uint _125 = 101u + buf0_dword_off;
    uint _129 = 102u + buf0_dword_off;
    uint _136 = (gl_WorkGroupID.x << 3u) + gl_LocalInvocationID.x;
    uint _137 = (gl_WorkGroupID.y << 3u) + gl_LocalInvocationID.y;
    bool _146 = (0u != (uint(ssbo_1_1.data[_129] < gl_WorkGroupID.z) | floatBitsToUint((ssbo_1_1.data[_125] < _137) ? 1.4012984643248170709237295832899e-45 : 0.0))) || (ssbo_1_1.data[_121] < _136);
    bool _147 = !_146;
    if (!_146)
    {
        bool _156 = uintBitsToFloat(ssbo_1_1.data[84u + buf0_dword_off]) > 0.0;
        precise float _158 = 0.5 + float(int(_137));
        precise float _161 = (1.0 / float(ssbo_1_1.data[_125])) * _158;
        uint _175;
        if (_156)
        {
            precise float _164 = (-0.5) + _161;
            precise float _166 = (-_164) * _164;
            precise float _168 = _166 + 0.25;
            float _170 = sqrt(_168);
            precise float _171 = 1.0 - _170;
            _175 = floatBitsToUint((_161 >= 0.5) ? _171 : _170);
        }
        else
        {
            _175 = floatBitsToUint(_161);
        }
        uint _857;
        uint _858;
        uint _859;
        uint _860;
        uint _861;
        uint _862;
        if (0.0 != uintBitsToFloat(ssbo_1_1.data[76u + buf0_dword_off]))
        {
            float _183 = 1.0 / float(ssbo_1_1.data[_121]);
            precise float _184 = 0.5 * _183;
            precise float _187 = 0.5 * uintBitsToFloat(_175);
            precise float _188 = _183 * float(int(_136));
            precise float _189 = _188 + _184;
            float _190 = fract(_189);
            float _191 = fract(_187);
            float _195 = sin(6.283185482025146484375 * _191);
            precise float _228 = _195 * cos(6.283185482025146484375 * _190);
            float _232 = cos(6.283185482025146484375 * _191);
            precise float _233 = _195 * sin(6.283185482025146484375 * _190);
            precise float _235 = uintBitsToFloat(ssbo_1_1.data[88u + buf0_dword_off]) * _228;
            precise float _237 = uintBitsToFloat(ssbo_1_1.data[91u + buf0_dword_off]) * _228;
            precise float _239 = uintBitsToFloat(ssbo_1_1.data[89u + buf0_dword_off]) * _232;
            precise float _240 = _239 + _235;
            precise float _242 = uintBitsToFloat(ssbo_1_1.data[94u + buf0_dword_off]) * _228;
            precise float _248 = uintBitsToFloat(ssbo_1_1.data[90u + buf0_dword_off]) * _233;
            precise float _249 = _248 + _240;
            precise float _251 = uintBitsToFloat(ssbo_1_1.data[92u + buf0_dword_off]) * _232;
            precise float _252 = _251 + _237;
            precise float _253 = _249 * _249;
            precise float _255 = uintBitsToFloat(ssbo_1_1.data[93u + buf0_dword_off]) * _233;
            precise float _256 = _255 + _252;
            precise float _258 = uintBitsToFloat(ssbo_1_1.data[95u + buf0_dword_off]) * _232;
            precise float _259 = _258 + _242;
            precise float _260 = _256 * _256;
            precise float _261 = _260 + _253;
            precise float _263 = uintBitsToFloat(ssbo_1_1.data[96u + buf0_dword_off]) * _233;
            precise float _264 = _263 + _259;
            precise float _265 = _264 * _264;
            precise float _266 = _265 + _261;
            float _267 = inversesqrt(_266);
            precise float _271 = (-abs(_267)) * abs(_256);
            precise float _272 = _271 + 1.0;
            precise float _273 = _272 * _272;
            precise float _274 = _272 * _273;
            precise float _276 = (-0.000988719053566455841064453125) * _273;
            precise float _278 = (-0.117851130664348602294921875) * _272;
            precise float _280 = _274 * (-0.0003834455274045467376708984375);
            precise float _281 = _280 + _276;
            precise float _282 = _273 * _273;
            precise float _284 = _273 * (-0.026516504585742950439453125);
            precise float _285 = _284 + _278;
            precise float _287 = _282 * (-0.00015429117775056511163711547851562);
            precise float _288 = _287 + _281;
            precise float _290 = _282 * (-0.00268540973775088787078857421875);
            precise float _291 = _290 + _285;
            precise float _293 = (-0.00789181701838970184326171875) + _288;
            precise float _295 = (-1.41421353816986083984375) + _291;
            precise float _296 = _267 * _256;
            float _309 = sqrt(_272);
            precise float _311 = _293 * _274;
            precise float _312 = _311 + _295;
            precise float _315 = _309 * _312;
            float _317 = (0.0 >= _296) ? fma(_309, _312, 3.1415927410125732421875) : (-_315);
            precise float _320 = 1.57079637050628662109375 - uintBitsToFloat(ssbo_1_1.data[44u + buf0_dword_off]);
            float _321 = min(_317, _320);
            precise float _323 = 0.15915493667125701904296875 * _321;
            float _326 = cos(6.283185482025146484375 * fract(_323));
            uint _337;
            if (_147 && (0.07999999821186065673828125 > _326))
            {
                precise float _332 = 6.25 * _326;
                precise float _333 = _332 + 0.5;
                precise float _335 = 0.07999999821186065673828125 * clamp(_333, 0.0, 1.0);
                _337 = floatBitsToUint(_335);
            }
            else
            {
                _337 = floatBitsToUint(_326);
            }
            precise float _340 = 0.3183098733425140380859375 * _321;
            uint _341 = floatBitsToUint(_340);
            uint _363;
            if (_147 && _156)
            {
                bool _343 = _147 && (1.57079637050628662109375 > _321);
                uint _350;
                if (_343)
                {
                    precise float _345 = (-_340) * _340;
                    precise float _346 = _345 + 0.25;
                    precise float _348 = 0.5 - sqrt(_346);
                    _350 = floatBitsToUint(_348);
                }
                else
                {
                    _350 = _341;
                }
                uint _362;
                if (_147 && (!_343))
                {
                    precise float _355 = (-1.0) + uintBitsToFloat(_350);
                    precise float _357 = (-_355) * _355;
                    precise float _358 = _357 + 0.25;
                    precise float _360 = 0.5 + sqrt(_358);
                    _362 = floatBitsToUint(_360);
                }
                else
                {
                    _362 = _350;
                }
                _363 = _362;
            }
            else
            {
                _363 = _341;
            }
            precise float _364 = _267 * _249;
            precise float _365 = _267 * _264;
            precise float _373 = (1.0 / max(abs(_365), abs(_364))) * min(abs(_365), abs(_364));
            precise float _374 = _373 * _373;
            precise float _383 = fma(fma(fma(fma(0.02083499915897846221923828125, _374, -0.08513300120830535888671875), _374, 0.1801410019397735595703125), _374, -0.3302989900112152099609375), _374, 0.999866008758544921875);
            precise float _386 = _373 * _383;
            precise float _390 = 0.5 + float(int(gl_WorkGroupID.z));
            precise float _396 = (1.0 / float(ssbo_1_1.data[_129])) * _390;
            precise float _418 = _267 * min(_249, _264);
            precise float _419 = _267 * max(_249, _264);
            precise float _422 = ((abs(_364) < abs(_365)) ? fma(-2.0, _386, 1.57079637050628662109375) : 0.0) + ((0.0 > _364) ? (-3.1415927410125732421875) : 0.0);
            precise float _428 = uintBitsToFloat(ssbo_1_1.data[81u + buf0_dword_off]) * log2(abs(_396));
            precise float _430 = _383 * _373;
            precise float _431 = _430 + _422;
            uint _433 = 52u + buf0_dword_off;
            uint _437 = 53u + buf0_dword_off;
            uint _454 = 27u + buf0_dword_off;
            float _458 = ((_418 < (-_418)) && (_419 >= (-_419))) ? (-_431) : _431;
            precise float _463 = uintBitsToFloat(ssbo_1_1.data[83u + buf0_dword_off]) * exp2(_428);
            precise float _464 = _463 + uintBitsToFloat(ssbo_1_1.data[82u + buf0_dword_off]);
            precise float _465 = 0.15915493667125701904296875 * _458;
            precise float _467 = uintBitsToFloat(ssbo_1_1.data[80u + buf0_dword_off]) + _464;
            uint _502;
            uint _503;
            if (0.0 != uintBitsToFloat(ssbo_1_1.data[_433]))
            {
                precise float _470 = uintBitsToFloat(ssbo_1_1.data[54u + buf0_dword_off]) - uintBitsToFloat(ssbo_1_1.data[_437]);
                precise float _472 = _467 - uintBitsToFloat(ssbo_1_1.data[_437]);
                precise float _474 = (1.0 / _470) * _472;
                float _475 = clamp(_474, 0.0, 1.0);
                precise float _476 = _475 * _475;
                precise float _478 = uintBitsToFloat(ssbo_1_1.data[_433]) * _476;
                precise float _482 = _478 * fma(-2.0, _475, 3.0);
                uint _500;
                uint _501;
                if (0.0 != _482)
                {
                    precise float _489 = _465 - uintBitsToFloat(ssbo_1_1.data[17u + buf0_dword_off]);
                    precise float _497 = _482 * textureLod(SPIRV_Cross_Combinedcs_img48cs_sampsgpr_8, vec2(_489, 0.5), 0.0).x;
                    precise float _498 = _497 + uintBitsToFloat(ssbo_1_1.data[_454]);
                    _500 = floatBitsToUint(_498);
                    _501 = 1056964608u;
                }
                else
                {
                    _500 = ssbo_1_1.data[_454];
                    _501 = floatBitsToUint(_478);
                }
                _502 = _500;
                _503 = _501;
            }
            else
            {
                _502 = ssbo_1_1.data[_454];
                _503 = floatBitsToUint(_396);
            }
            precise float _515 = (1.0 / uintBitsToFloat(ssbo_1_1.data[0u + buf0_dword_off])) * _321;
            bool _518 = _147 && (0.5 >= _515);
            uint _526;
            uint _527;
            if (_518)
            {
                precise float _519 = (-2.0) * _515;
                precise float _520 = _519 + 1.0;
                float _521 = sqrt(_520);
                _526 = floatBitsToUint(fma(-_521, 0.5, 0.5));
                _527 = floatBitsToUint(_521);
            }
            else
            {
                _526 = _503;
                _527 = floatBitsToUint(_515);
            }
            uint _537;
            if (_147 && (!_518))
            {
                precise float _532 = 2.0 * uintBitsToFloat(_527);
                precise float _533 = _532 + (-1.0);
                _537 = floatBitsToUint(fma(sqrt(_533), 0.5, 0.5));
            }
            else
            {
                _537 = _526;
            }
            uint _539 = 56u + buf0_dword_off;
            uint _543 = 57u + buf0_dword_off;
            uint _559 = 63u + buf0_dword_off;
            precise float _563 = 0.636619746685028076171875 * _317;
            precise float _564 = _563 + (-1.0);
            uint _568 = 28u + buf0_dword_off;
            uint _580 = 31u + buf0_dword_off;
            precise float _585 = uintBitsToFloat(_337) * uintBitsToFloat(_337);
            precise float _592 = uintBitsToFloat(ssbo_1_1.data[_543]) * _585;
            precise float _593 = _592 + uintBitsToFloat(ssbo_1_1.data[59u + buf0_dword_off]);
            precise float _602 = uintBitsToFloat(ssbo_1_1.data[_559]) + _458;
            precise float _605 = 6.283185482025146484375 + _602;
            precise float _607 = uintBitsToFloat(ssbo_1_1.data[62u + buf0_dword_off]) * log2(clamp(_564, 0.0, 1.0));
            precise float _609 = trunc(fma(_602, 0.15915493667125701904296875, 1.0)) * (-6.283185482025146484375);
            precise float _610 = _609 + _605;
            float _611 = exp2(_607);
            precise float _612 = (-3.1415927410125732421875) + _610;
            precise float _615 = uintBitsToFloat(ssbo_1_1.data[_543]) * _585;
            precise float _616 = _615 + uintBitsToFloat(ssbo_1_1.data[58u + buf0_dword_off]);
            precise float _617 = 0.636619746685028076171875 * _321;
            precise float _620 = (-uintBitsToFloat(ssbo_1_1.data[_568])) * _611;
            precise float _621 = _620 + 3.1415927410125732421875;
            precise float _623 = uintBitsToFloat(ssbo_1_1.data[_568]) * _611;
            float _629 = log2(abs(_617));
            precise float _631 = ((abs(_612) < _623) ? _621 : _610) - uintBitsToFloat(ssbo_1_1.data[_559]);
            precise float _635 = (-uintBitsToFloat(ssbo_1_1.data[_539])) * uintBitsToFloat(_337);
            precise float _636 = _635 + sqrt(_616);
            precise float _637 = 0.15915493667125701904296875 * _631;
            precise float _643 = (-uintBitsToFloat(ssbo_1_1.data[_539])) * uintBitsToFloat(_337);
            precise float _644 = _643 + sqrt(_593);
            precise float _645 = 0.15915493667125701904296875 * _321;
            precise float _647 = 0.001000000047497451305389404296875 * _644;
            precise float _649 = (1.0 / _636) * _467;
            float _650 = clamp(_649, 0.0, 1.0);
            precise float _652 = uintBitsToFloat(ssbo_1_1.data[49u + buf0_dword_off]) * _467;
            float _654 = fract(_637);
            precise float _656 = uintBitsToFloat(ssbo_1_1.data[45u + buf0_dword_off]) * _629;
            precise float _658 = uintBitsToFloat(ssbo_1_1.data[46u + buf0_dword_off]) * _629;
            float _659 = exp2(_658);
            precise float _662 = uintBitsToFloat(ssbo_1_1.data[25u + buf0_dword_off]) * exp2(_656);
            precise float _664 = uintBitsToFloat(ssbo_1_1.data[26u + buf0_dword_off]) * _659;
            precise float _667 = _652 * max(9.9999997473787516355514526367188e-06, _659);
            precise float _668 = 0.001000000047497451305389404296875 * _667;
            precise float _669 = (1.0 / _647) * _668;
            float _671 = max(9.9999997473787516355514526367188e-06, _664);
            float _672 = max(9.9999997473787516355514526367188e-06, _662);
            precise float _674 = _671 * _650;
            precise float _675 = _672 * _650;
            precise float _677 = (-1.44269502162933349609375) * _672;
            float _679 = sin(6.283185482025146484375 * fract(_645));
            precise float _680 = (-1.44269502162933349609375) * _674;
            precise float _682 = (-1.44269502162933349609375) * _675;
            precise float _684 = 0.3333333432674407958984375 * log2(clamp(_669, 0.0, 1.0));
            precise float _689 = _679 * cos(6.283185482025146484375 * _654);
            precise float _690 = (-1.44269502162933349609375) * _671;
            precise float _692 = _679 * sin(6.283185482025146484375 * _654);
            precise float _693 = 1.0 - exp2(_690);
            precise float _694 = 1.0 - exp2(_677);
            float _699 = 1.0 / uintBitsToFloat(ssbo_1_1.data[2u + buf0_dword_off]);
            precise float _700 = 1.0 - _699;
            precise float _701 = exp2(_684) * _700;
            precise float _702 = 0.5 * _699;
            precise float _703 = _702 + _701;
            float _712 = abs(_689);
            float _713 = abs(_326);
            float _714 = abs(_692);
            float _720 = ((_714 >= _712) && (_714 >= _713)) ? ((_692 < 0.0) ? 5.0 : 4.0) : ((_713 >= _712) ? ((_326 < 0.0) ? 3.0 : 2.0) : float(_689 < 0.0));
            float _721 = 1.0 / _694;
            float _728 = abs(_689);
            float _729 = abs(_326);
            float _730 = abs(_692);
            float _737 = 1.0 / _693;
            float _739 = 1.0 / uintBitsToFloat(ssbo_1_1.data[1u + buf0_dword_off]);
            precise float _740 = 1.0 - _739;
            precise float _742 = uintBitsToFloat(_537) * _740;
            precise float _743 = _689 * 2.0;
            precise float _744 = _326 * 2.0;
            precise float _745 = _692 * 2.0;
            float _746 = abs(_689);
            float _747 = abs(_326);
            float _748 = abs(_692);
            float _756 = 1.0 / abs(((_748 >= _746) && (_748 >= _747)) ? _745 : ((_747 >= _746) ? _744 : _743));
            float _758 = -_326;
            float _761 = abs(_689);
            float _762 = abs(_326);
            float _763 = abs(_692);
            precise float _771 = fma(((_730 >= _728) && (_730 >= _729)) ? ((_692 < 0.0) ? (-_689) : _689) : ((_729 >= _728) ? _689 : ((_689 < 0.0) ? _692 : (-_692))), _756, 1.5);
            precise float _772 = fma(((_763 >= _761) && (_763 >= _762)) ? _758 : ((_762 >= _761) ? ((_326 < 0.0) ? (-_692) : _692) : _758), _756, 1.5);
            precise float _773 = _771 - 1.0;
            precise float _774 = _772 - 1.0;
            precise float _776 = _720 / 8.0;
            vec4 _783 = textureLod(SPIRV_Cross_Combinedcs_img24cs_sampsgpr_4, vec3(_773, _774, fma(floor(_776), -2.0, _720)), 0.0);
            precise float _787 = 0.5 * _739;
            precise float _788 = _787 + _742;
            precise float _790 = _721 * (-exp2(_682));
            precise float _791 = _790 + _721;
            precise float _794 = _737 * (-exp2(_680));
            precise float _795 = _794 + _737;
            precise float _797 = _771 - 1.0;
            precise float _798 = _772 - 1.0;
            precise float _799 = _720 / 8.0;
            vec4 _806 = textureLod(SPIRV_Cross_Combinedcs_img32cs_sampsgpr_4, vec3(_797, _798, fma(floor(_799), -2.0, _720)), 0.0);
            vec4 _814 = textureLod(SPIRV_Cross_Combinedcs_img40cs_sampinline_0xfff00000000024_0x2500000, vec2(_703, _788), 0.0);
            precise float _819 = uintBitsToFloat(_502) + textureLod(SPIRV_Cross_Combinedcs_img16cs_sampinline_0xfff00000000190_0x8000000002500000, vec2(_465, uintBitsToFloat(_363)), 0.0).x;
            float _820 = clamp(_819, 0.0, 1.0);
            precise float _824 = uintBitsToFloat(ssbo_1_1.data[_580]) * _820;
            precise float _825 = _824 + (-uintBitsToFloat(ssbo_1_1.data[_580]));
            precise float _826 = 1.0 + _825;
            precise float _828 = uintBitsToFloat(ssbo_1_1.data[29u + buf0_dword_off]) * _820;
            precise float _829 = _828 * clamp(_791, 0.0, 1.0);
            precise float _831 = uintBitsToFloat(ssbo_1_1.data[30u + buf0_dword_off]) * clamp(_795, 0.0, 1.0);
            precise float _833 = _826 * (-_820);
            precise float _834 = _833 + _826;
            precise float _835 = _831 * _834;
            precise float _836 = _783.x * _829;
            precise float _837 = _783.y * _829;
            precise float _838 = _783.z * _829;
            precise float _839 = _835 * _806.x;
            precise float _840 = _839 + _836;
            precise float _851 = _835 * _806.y;
            precise float _852 = _851 + _837;
            precise float _854 = _835 * _806.z;
            precise float _855 = _854 + _838;
            _857 = floatBitsToUint(_855);
            _858 = floatBitsToUint(_852);
            _859 = floatBitsToUint(_840);
            _860 = floatBitsToUint(clamp(max(0.0, _814.z), 0.0, 1.0));
            _861 = floatBitsToUint(clamp(max(0.0, _814.y), 0.0, 1.0));
            _862 = floatBitsToUint(clamp(max(0.0, _814.x), 0.0, 1.0));
        }
        else
        {
            _857 = 0u;
            _858 = 0u;
            _859 = 0u;
            _860 = 1065353216u;
            _861 = 1065353216u;
            _862 = 1065353216u;
        }
        vec4 _866 = vec4(uintBitsToFloat(_862), uintBitsToFloat(_861), uintBitsToFloat(_860), 0.0);
        imageStore(cs_img56, ivec3(uvec3(_136, _137, gl_WorkGroupID.z)), vec4(_866.x, _866.y, _866.z, vec4(0.0, 1.0, 0.0, 0.0).x));
        vec4 _874 = vec4(uintBitsToFloat(_859), uintBitsToFloat(_858), uintBitsToFloat(_857), 0.0);
        imageStore(cs_img64, ivec3(uvec3(_136, _137, gl_WorkGroupID.z)), vec4(_874.x, _874.y, _874.z, vec4(0.0, 1.0, 0.0, 0.0).x));
    }
}

