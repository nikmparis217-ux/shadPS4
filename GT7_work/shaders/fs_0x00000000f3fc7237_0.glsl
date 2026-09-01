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

uniform usampler2D SPIRV_Cross_Combinedfs_img0fs_sampsgpr_8;
uniform usampler2D SPIRV_Cross_Combinedfs_img16fs_sampsgpr_24;

layout(location = 0) pervertexEXT in vec4 fs_in_attr0_p[3];
layout(location = 0) out vec4 frag_color0;

void main()
{
    uint buf0_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(0u), int(8u)) >> 2u;
    precise float _139 = fs_in_attr0_p[1u].x - fs_in_attr0_p[0u].x;
    precise float _146 = fs_in_attr0_p[1u].y - fs_in_attr0_p[0u].y;
    precise float _152 = fs_in_attr0_p[2u].x - fs_in_attr0_p[0u].x;
    precise float _153 = fma(_152, gl_BaryCoordEXT.z, fma(_139, gl_BaryCoordEXT.y, fs_in_attr0_p[0u].x));
    precise float _158 = fs_in_attr0_p[2u].y - fs_in_attr0_p[0u].y;
    precise float _159 = fma(_158, gl_BaryCoordEXT.z, fma(_146, gl_BaryCoordEXT.y, fs_in_attr0_p[0u].y));
    bool _166 = (0.0 > min(_159, _153)) || ((1.0 < _153) || (1.0 < _159));
    bool _167 = !_166;
    uint _1577;
    uint _1578;
    uint _1579;
    if (!_166)
    {
        bool _174 = uintBitsToFloat(ssbo_1_1.data[0u + buf0_dword_off]) > 0.5;
        uint _236;
        uint _237;
        uint _238;
        if (_174)
        {
            vec4 _181 = uintBitsToFloat(texture(SPIRV_Cross_Combinedfs_img0fs_sampsgpr_8, vec2(_153, _159)));
            float _184 = float(floatBitsToUint(_181.x));
            precise float _196 = 0.0009765625 * _184;
            vec4 _202 = uintBitsToFloat(texture(SPIRV_Cross_Combinedfs_img16fs_sampsgpr_24, vec2(_153, _159)));
            float _205 = float(floatBitsToUint(_202.x));
            float _208 = float(floatBitsToUint(_202.y));
            precise float _216 = 0.0009765625 * _205;
            precise float _218 = _216 + (-0.5);
            precise float _220 = _218 * (-0.16455312073230743408203125);
            precise float _221 = _220 + _196;
            precise float _222 = 0.0009765625 * _208;
            precise float _223 = _222 + (-0.5);
            precise float _225 = _223 * (-0.571353137493133544921875);
            precise float _226 = _225 + _221;
            precise float _229 = _223 * 1.47459995746612548828125;
            precise float _230 = _229 + _196;
            precise float _233 = _218 * 1.88139998912811279296875;
            precise float _234 = _233 + _196;
            _236 = floatBitsToUint(_234);
            _237 = floatBitsToUint(_226);
            _238 = floatBitsToUint(_230);
        }
        else
        {
            _236 = 0u;
            _237 = 0u;
            _238 = 0u;
        }
        uint _307;
        uint _308;
        uint _309;
        if (!_174)
        {
            vec4 _244 = uintBitsToFloat(texture(SPIRV_Cross_Combinedfs_img0fs_sampsgpr_8, vec2(_153, _159)));
            float _247 = float(floatBitsToUint(_244.x));
            precise float _259 = 0.00390625 * _247;
            vec4 _268 = uintBitsToFloat(texture(SPIRV_Cross_Combinedfs_img16fs_sampsgpr_24, vec2(_153, _159)));
            float _271 = float(floatBitsToUint(_268.x));
            float _274 = float(floatBitsToUint(_268.y));
            float _287 = (uintBitsToFloat(ssbo_1_1.data[2u + buf0_dword_off]) > 0.5) ? fma(1.16894972324371337890625, _259, -0.073059357702732086181640625) : _259;
            precise float _288 = 0.00390625 * _271;
            precise float _289 = _288 + (-0.5);
            precise float _291 = _289 * (-0.21330000460147857666015625);
            precise float _292 = _291 + _287;
            precise float _293 = 0.00390625 * _274;
            precise float _294 = _293 + (-0.5);
            precise float _296 = _294 * (-0.53289997577667236328125);
            precise float _297 = _296 + _292;
            precise float _300 = _294 * 1.7927000522613525390625;
            precise float _301 = _300 + _287;
            precise float _304 = _289 * 2.112400054931640625;
            precise float _305 = _304 + _287;
            _307 = floatBitsToUint(_301);
            _308 = floatBitsToUint(_305);
            _309 = floatBitsToUint(_297);
        }
        else
        {
            _307 = _238;
            _308 = _236;
            _309 = _237;
        }
        bool _310 = _167 && _174;
        uint _363;
        uint _364;
        uint _365;
        if (_310)
        {
            precise float _322 = 0.0126833133399486541748046875 * log2(abs(uintBitsToFloat(_307)));
            precise float _323 = 0.0126833133399486541748046875 * log2(abs(uintBitsToFloat(_309)));
            precise float _324 = 0.0126833133399486541748046875 * log2(abs(uintBitsToFloat(_308)));
            float _325 = exp2(_322);
            float _326 = exp2(_323);
            float _327 = exp2(_324);
            precise float _335 = (-0.8359375) + _325;
            precise float _337 = (-0.8359375) + _326;
            precise float _339 = (-0.8359375) + _327;
            precise float _340 = (1.0 / fma(-18.6875, _325, 18.8515625)) * _335;
            precise float _341 = (1.0 / fma(-18.6875, _326, 18.8515625)) * _337;
            precise float _342 = (1.0 / fma(-18.6875, _327, 18.8515625)) * _339;
            precise float _350 = 6.277394771575927734375 * log2(abs(_340));
            precise float _351 = 6.277394771575927734375 * log2(abs(_341));
            precise float _352 = 6.277394771575927734375 * log2(abs(_342));
            precise float _357 = 100.0 * exp2(_350);
            precise float _359 = 100.0 * exp2(_351);
            precise float _361 = 100.0 * exp2(_352);
            _363 = floatBitsToUint(_361);
            _364 = floatBitsToUint(_359);
            _365 = floatBitsToUint(_357);
        }
        else
        {
            _363 = _307;
            _364 = _308;
            _365 = _309;
        }
        uint _431;
        uint _432;
        uint _433;
        if (!_310)
        {
            precise float _375 = 2.400000095367431640625 * log2(abs(fma(0.947867333889007568359375, uintBitsToFloat(_363), 0.052132703363895416259765625)));
            precise float _386 = 0.077399380505084991455078125 * uintBitsToFloat(_363);
            precise float _387 = 2.400000095367431640625 * log2(abs(fma(0.947867333889007568359375, uintBitsToFloat(_365), 0.052132703363895416259765625)));
            float _390 = (0.040449999272823333740234375 > uintBitsToFloat(_363)) ? _386 : exp2(_375);
            precise float _395 = 0.077399380505084991455078125 * uintBitsToFloat(_365);
            precise float _396 = 2.400000095367431640625 * log2(abs(fma(0.947867333889007568359375, uintBitsToFloat(_364), 0.052132703363895416259765625)));
            precise float _398 = 0.62750399112701416015625 * _390;
            float _399 = (0.040449999272823333740234375 > uintBitsToFloat(_365)) ? _395 : exp2(_387);
            precise float _404 = 0.077399380505084991455078125 * uintBitsToFloat(_364);
            precise float _406 = 0.069109000265598297119140625 * _390;
            precise float _408 = 0.0163940005004405975341796875 * _390;
            precise float _410 = _399 * 0.32927501201629638671875;
            precise float _411 = _410 + _398;
            float _412 = (0.040449999272823333740234375 > uintBitsToFloat(_364)) ? _404 : exp2(_396);
            precise float _414 = _399 * 0.919519007205963134765625;
            precise float _415 = _414 + _406;
            precise float _417 = _399 * 0.0880109965801239013671875;
            precise float _418 = _417 + _408;
            precise float _420 = _412 * 0.0433030016720294952392578125;
            precise float _421 = _420 + _411;
            precise float _424 = _412 * 0.011358999647200107574462890625;
            precise float _425 = _424 + _415;
            precise float _428 = _412 * 0.8953800201416015625;
            precise float _429 = _428 + _418;
            _431 = floatBitsToUint(_429);
            _432 = floatBitsToUint(_425);
            _433 = floatBitsToUint(_421);
        }
        else
        {
            _431 = _363;
            _432 = _364;
            _433 = _365;
        }
        uint _435 = 4u + buf0_dword_off;
        uint _439 = 5u + buf0_dword_off;
        uint _443 = 6u + buf0_dword_off;
        uint _447 = 7u + buf0_dword_off;
        uint _450 = 8u + buf0_dword_off;
        precise float _461 = uintBitsToFloat(ssbo_1_1.data[_443]) * uintBitsToFloat(_433);
        uint _462 = floatBitsToUint(_461);
        precise float _464 = 0.2626999914646148681640625 * _461;
        precise float _467 = uintBitsToFloat(ssbo_1_1.data[_443]) * uintBitsToFloat(_432);
        uint _468 = floatBitsToUint(_467);
        precise float _470 = _467 * 0.677998006343841552734375;
        precise float _471 = _470 + _464;
        uint _472 = floatBitsToUint(_471);
        precise float _475 = uintBitsToFloat(ssbo_1_1.data[_443]) * uintBitsToFloat(_431);
        uint _476 = floatBitsToUint(_475);
        bool _478 = uintBitsToFloat(ssbo_1_1.data[9u + buf0_dword_off]) > 0.5;
        precise float _480 = _475 * 0.0593019984662532806396484375;
        precise float _481 = _480 + _471;
        uint _609;
        uint _610;
        bool _611;
        uint _612;
        uint _613;
        uint _614;
        if (_478)
        {
            bool _483 = _167 && (0.949999988079071044921875 > _159);
            uint _549;
            uint _550;
            uint _551;
            uint _552;
            uint _553;
            if (_483)
            {
                precise float _484 = 100.0 * _481;
                precise float _488 = 0.20000000298023223876953125 * log2(abs(_484));
                precise float _491 = 0.2511886656284332275390625 * exp2(_488);
                float _492 = clamp(_491, 0.0, 1.0);
                precise float _494 = 1.22818839550018310546875 * _492;
                precise float _495 = _492 * _492;
                precise float _497 = 0.015360518358647823333740234375 * _492;
                precise float _499 = 3.122510433197021484375 * _492;
                precise float _501 = _495 * 0.278906881809234619140625;
                precise float _502 = _501 + _494;
                precise float _503 = _492 * _495;
                precise float _505 = _495 * 1.60539591312408447265625;
                precise float _506 = _505 + _497;
                precise float _508 = _495 * (-5.893222332000732421875);
                precise float _509 = _508 + _499;
                precise float _511 = _503 * 3.892783641815185546875;
                precise float _512 = _511 + _502;
                precise float _513 = _492 * _503;
                precise float _515 = _503 * (-4.821108341217041015625);
                precise float _516 = _515 + _506;
                precise float _518 = _503 * 2.798380374908447265625;
                precise float _519 = _518 + _509;
                precise float _521 = _513 * (-8.4907131195068359375);
                precise float _522 = _521 + _512;
                precise float _523 = _492 * _513;
                precise float _525 = _513 * 8.38931369781494140625;
                precise float _526 = _525 + _516;
                precise float _528 = _513 * (-3.6088845729827880859375);
                precise float _529 = _528 + _519;
                precise float _531 = _523 * 4.0690460205078125;
                precise float _532 = _531 + _522;
                precise float _535 = _523 * (-4.193859100341796875);
                precise float _536 = _535 + _526;
                precise float _538 = _523 * 4.32499599456787109375;
                precise float _539 = _538 + _529;
                precise float _541 = (-0.0277805589139461517333984375) + _532;
                precise float _544 = 0.014065206050872802734375 + _536;
                precise float _547 = (-0.01962838508188724517822265625) + _539;
                _549 = floatBitsToUint(_541);
                _550 = 1048615885u;
                _551 = floatBitsToUint(_547);
                _552 = floatBitsToUint(_532);
                _553 = floatBitsToUint(_544);
            }
            else
            {
                _549 = _472;
                _550 = ssbo_1_1.data[_435];
                _551 = _476;
                _552 = _462;
                _553 = _468;
            }
            bool _555 = _167 && (!_483);
            uint _605;
            uint _606;
            uint _607;
            uint _608;
            if (_555)
            {
                precise float _557 = 50.0 * _153;
                precise float _560 = 20.0 * floor(_557);
                precise float _563 = 0.20000000298023223876953125 * log2(abs(_560));
                precise float _565 = 0.2511886656284332275390625 * exp2(_563);
                float _566 = clamp(_565, 0.0, 1.0);
                precise float _567 = 1.22818839550018310546875 * _566;
                precise float _568 = _566 * _566;
                precise float _569 = 0.015360518358647823333740234375 * _566;
                precise float _570 = 3.122510433197021484375 * _566;
                precise float _571 = _568 * 0.278906881809234619140625;
                precise float _572 = _571 + _567;
                precise float _573 = _566 * _568;
                precise float _574 = _568 * 1.60539591312408447265625;
                precise float _575 = _574 + _569;
                precise float _576 = _568 * (-5.893222332000732421875);
                precise float _577 = _576 + _570;
                precise float _578 = _573 * 3.892783641815185546875;
                precise float _579 = _578 + _572;
                precise float _580 = _566 * _573;
                precise float _581 = _573 * (-4.821108341217041015625);
                precise float _582 = _581 + _575;
                precise float _583 = _573 * 2.798380374908447265625;
                precise float _584 = _583 + _577;
                precise float _585 = _580 * (-8.4907131195068359375);
                precise float _586 = _585 + _579;
                precise float _587 = _566 * _580;
                precise float _588 = _580 * 8.38931369781494140625;
                precise float _589 = _588 + _582;
                precise float _590 = _580 * (-3.6088845729827880859375);
                precise float _591 = _590 + _584;
                precise float _592 = _587 * 4.0690460205078125;
                precise float _593 = _592 + _586;
                precise float _594 = _587 * (-4.193859100341796875);
                precise float _595 = _594 + _589;
                precise float _597 = _587 * 4.32499599456787109375;
                precise float _598 = _597 + _591;
                precise float _599 = (-0.0277805589139461517333984375) + _593;
                precise float _601 = 0.014065206050872802734375 + _595;
                precise float _603 = (-0.01962838508188724517822265625) + _598;
                _605 = floatBitsToUint(_599);
                _606 = floatBitsToUint(_603);
                _607 = floatBitsToUint(_595);
                _608 = floatBitsToUint(_601);
            }
            else
            {
                _605 = _549;
                _606 = _551;
                _607 = _552;
                _608 = _553;
            }
            _609 = _605;
            _610 = _550;
            _611 = _555;
            _612 = _606;
            _613 = _607;
            _614 = _608;
        }
        else
        {
            _609 = _472;
            _610 = ssbo_1_1.data[_435];
            _611 = _167;
            _612 = _476;
            _613 = _462;
            _614 = _468;
        }
        uint _1574;
        uint _1575;
        uint _1576;
        if (!_478)
        {
            precise float _616 = uintBitsToFloat(_613) - _481;
            precise float _618 = uintBitsToFloat(_614) - _481;
            precise float _624 = uintBitsToFloat(_612) - _481;
            bool _627 = uintBitsToFloat(ssbo_1_1.data[1u + buf0_dword_off]) > 0.5;
            precise float _629 = uintBitsToFloat(ssbo_1_1.data[_447]) * _616;
            precise float _630 = _629 + _481;
            precise float _633 = uintBitsToFloat(ssbo_1_1.data[_447]) * _618;
            precise float _634 = _633 + _481;
            precise float _637 = uintBitsToFloat(ssbo_1_1.data[_447]) * _624;
            precise float _638 = _637 + _481;
            uint _1103;
            uint _1104;
            uint _1105;
            uint _1106;
            uint _1107;
            uint _1108;
            if (_627)
            {
                precise float _645 = 0.2199999988079071044921875 + fma(uintBitsToFloat(ssbo_1_1.data[_439]), 0.3300000131130218505859375, -0.072599999606609344482421875);
                float _647 = 1.0 / uintBitsToFloat(ssbo_1_1.data[_439]);
                precise float _648 = _647 * _645;
                precise float _650 = (-1.44269502162933349609375) * _648;
                float _651 = exp2(_650);
                precise float _654 = 0.13533528149127960205078125 - _651;
                precise float _657 = 2.0 * uintBitsToFloat(ssbo_1_1.data[_439]);
                float _658 = 1.0 / _654;
                precise float _661 = _645 - uintBitsToFloat(ssbo_1_1.data[_439]);
                precise float _665 = _658 * _661;
                precise float _666 = _651 * _665;
                precise float _667 = _666 + _645;
                bool _669 = _611 && ((_630 > _657) || (0.0 > _630));
                uint _674;
                if (_669)
                {
                    _674 = floatBitsToUint((0.0 > _630) ? 0.0 : uintBitsToFloat(ssbo_1_1.data[_439]));
                }
                else
                {
                    _674 = floatBitsToUint(_651);
                }
                uint _708;
                uint _709;
                uint _710;
                if (_611 && (!_669))
                {
                    precise float _678 = 4.545454502105712890625 * _630;
                    precise float _679 = _647 * _630;
                    float _681 = clamp(max(0.0, _678), 0.0, 1.0);
                    precise float _682 = (-1.44269502162933349609375) * _679;
                    precise float _687 = (-_681) * _681;
                    bool _689 = _630 < _645;
                    precise float _690 = _687 * fma(-2.0, _681, 3.0);
                    precise float _691 = _690 + 1.0;
                    precise float _693 = exp2(_682) * (-_665);
                    precise float _694 = _693 + _667;
                    float _696 = _689 ? 0.0 : (-1.0);
                    precise float _698 = _678 * _691;
                    precise float _700 = _696 - _691;
                    precise float _701 = _698 * 0.2199999988079071044921875;
                    precise float _702 = _701 + (_689 ? 0.0 : _694);
                    precise float _703 = 1.0 + _700;
                    precise float _705 = _703 * _630;
                    precise float _706 = _705 + _702;
                    _708 = floatBitsToUint(_696);
                    _709 = floatBitsToUint(_703);
                    _710 = floatBitsToUint(_706);
                }
                else
                {
                    _708 = floatBitsToUint(_661);
                    _709 = floatBitsToUint(_658);
                    _710 = _674;
                }
                bool _714 = _611 && ((_634 > _657) || (0.0 > _634));
                uint _719;
                if (_714)
                {
                    _719 = floatBitsToUint((0.0 > _634) ? 0.0 : uintBitsToFloat(ssbo_1_1.data[_439]));
                }
                else
                {
                    _719 = _709;
                }
                uint _748;
                uint _749;
                if (_611 && (!_714))
                {
                    precise float _722 = 4.545454502105712890625 * _634;
                    precise float _723 = _647 * _634;
                    float _725 = clamp(max(0.0, _722), 0.0, 1.0);
                    precise float _726 = (-1.44269502162933349609375) * _723;
                    precise float _729 = (-_725) * _725;
                    bool _731 = _634 < _645;
                    precise float _732 = _729 * fma(-2.0, _725, 3.0);
                    precise float _733 = _732 + 1.0;
                    precise float _735 = exp2(_726) * (-_665);
                    precise float _736 = _735 + _667;
                    precise float _738 = _722 * _733;
                    precise float _740 = (_731 ? 0.0 : (-1.0)) - _733;
                    precise float _741 = _738 * 0.2199999988079071044921875;
                    precise float _742 = _741 + (_731 ? 0.0 : _736);
                    precise float _743 = 1.0 + _740;
                    precise float _745 = _743 * _634;
                    precise float _746 = _745 + _742;
                    _748 = floatBitsToUint(_743);
                    _749 = floatBitsToUint(_746);
                }
                else
                {
                    _748 = _708;
                    _749 = _719;
                }
                bool _753 = _611 && ((_638 > _657) || (0.0 > _638));
                uint _758;
                if (_753)
                {
                    _758 = floatBitsToUint((0.0 > _638) ? 0.0 : uintBitsToFloat(ssbo_1_1.data[_439]));
                }
                else
                {
                    _758 = _748;
                }
                uint _786;
                if (_611 && (!_753))
                {
                    precise float _761 = 4.545454502105712890625 * _638;
                    precise float _762 = _647 * _638;
                    float _764 = clamp(max(0.0, _761), 0.0, 1.0);
                    precise float _765 = (-1.44269502162933349609375) * _762;
                    precise float _768 = (-_764) * _764;
                    bool _770 = _638 < _645;
                    precise float _771 = _768 * fma(-2.0, _764, 3.0);
                    precise float _772 = _771 + 1.0;
                    precise float _774 = exp2(_765) * (-_665);
                    precise float _775 = _774 + _667;
                    precise float _777 = _761 * _772;
                    precise float _779 = (_770 ? 0.0 : (-1.0)) - _772;
                    precise float _780 = _777 * 0.2199999988079071044921875;
                    precise float _781 = _780 + (_770 ? 0.0 : _775);
                    precise float _782 = 1.0 + _779;
                    precise float _783 = _782 * _638;
                    precise float _784 = _783 + _781;
                    _786 = floatBitsToUint(_784);
                }
                else
                {
                    _786 = _758;
                }
                precise float _788 = 0.412109375 * _630;
                precise float _790 = 0.166748046875 * _630;
                precise float _792 = _634 * 0.52392578125;
                precise float _793 = _792 + _788;
                precise float _795 = _634 * 0.720458984375;
                precise float _796 = _795 + _790;
                precise float _798 = _638 * 0.06396484375;
                precise float _799 = _798 + _793;
                precise float _801 = _638 * 0.11279296875;
                precise float _802 = _801 + _796;
                precise float _804 = 0.00999999977648258209228515625 * _799;
                precise float _805 = 0.00999999977648258209228515625 * _802;
                precise float _811 = 0.1593017578125 * log2(abs(_804));
                precise float _812 = 0.1593017578125 * log2(abs(_805));
                float _813 = exp2(_811);
                float _814 = exp2(_812);
                precise float _818 = 18.6875 * _813;
                precise float _819 = _818 + 1.0;
                precise float _821 = 18.6875 * _814;
                precise float _822 = _821 + 1.0;
                precise float _827 = log2(fma(18.8515625, _813, 0.8359375)) - log2(_819);
                precise float _828 = log2(fma(18.8515625, _814, 0.8359375)) - log2(_822);
                precise float _830 = 78.84375 * _827;
                precise float _831 = 78.84375 * _828;
                float _832 = exp2(_830);
                float _833 = exp2(_831);
                precise float _834 = _832 + _833;
                precise float _835 = _834 * 0.5;
                precise float _838 = 0.00999999977648258209228515625 * uintBitsToFloat(ssbo_1_1.data[_439]);
                precise float _839 = 0.0126833133399486541748046875 * log2(_835);
                precise float _843 = 0.024169921875 * _630;
                float _844 = exp2(_839);
                precise float _845 = 0.1593017578125 * log2(abs(_838));
                precise float _847 = _634 * 0.075439453125;
                precise float _848 = _847 + _843;
                float _850 = exp2(_845);
                precise float _852 = _638 * 0.900390625;
                precise float _853 = _852 + _848;
                precise float _855 = (-0.8359375) + _844;
                precise float _857 = 18.6875 * _850;
                precise float _858 = _857 + 1.0;
                precise float _859 = 0.00999999977648258209228515625 * _853;
                precise float _860 = (1.0 / fma(-18.6875, _844, 18.8515625)) * _855;
                precise float _867 = log2(fma(18.8515625, _850, 0.8359375)) - log2(_858);
                precise float _868 = 0.1593017578125 * log2(abs(_859));
                precise float _869 = 6.277394771575927734375 * log2(abs(_860));
                precise float _870 = 78.84375 * _867;
                float _871 = exp2(_868);
                float _872 = exp2(_869);
                precise float _875 = 18.6875 * _871;
                precise float _876 = _875 + 1.0;
                precise float _877 = 100.0 * _872;
                precise float _881 = (1.0 / exp2(_870)) * _835;
                precise float _882 = log2(fma(18.8515625, _871, 0.8359375)) - log2(_876);
                precise float _885 = 1.61376953125 * _832;
                precise float _886 = 78.84375 * _882;
                precise float _888 = 4.378173828125 * _832;
                precise float _890 = 3.333332538604736328125 * _881;
                precise float _892 = _890 + (-2.9999992847442626953125);
                float _893 = clamp(_892, 0.0, 1.0);
                precise float _897 = (-_893) * _893;
                precise float _899 = _833 * (-3.323486328125);
                precise float _900 = _899 + _885;
                float _901 = exp2(_886);
                precise float _903 = _833 * (-4.24560546875);
                precise float _904 = _903 + _888;
                precise float _905 = _897 * fma(-2.0, _893, 3.0);
                precise float _906 = _905 + 1.0;
                precise float _908 = _901 * 1.709716796875;
                precise float _909 = _908 + _900;
                precise float _911 = _901 * (-0.132568359375);
                precise float _912 = _911 + _904;
                uint _940;
                if (_611 && (!(_877 > _657)))
                {
                    precise float _915 = 454.545440673828125 * _872;
                    precise float _916 = _647 * _877;
                    float _918 = clamp(max(0.0, _915), 0.0, 1.0);
                    precise float _919 = (-1.44269502162933349609375) * _916;
                    precise float _922 = (-_918) * _918;
                    bool _924 = _877 < _645;
                    precise float _925 = _922 * fma(-2.0, _918, 3.0);
                    precise float _926 = _925 + 1.0;
                    precise float _928 = (-_665) * exp2(_919);
                    precise float _929 = _928 + _667;
                    precise float _931 = _915 * _926;
                    precise float _933 = (_924 ? 0.0 : (-1.0)) - _926;
                    precise float _934 = _931 * 0.2199999988079071044921875;
                    precise float _935 = _934 + (_924 ? 0.0 : _929);
                    precise float _936 = 1.0 + _933;
                    precise float _937 = _936 * _877;
                    precise float _938 = _937 + _935;
                    _940 = floatBitsToUint(_938);
                }
                else
                {
                    _940 = ssbo_1_1.data[_439];
                }
                precise float _942 = 0.00999999977648258209228515625 * uintBitsToFloat(_940);
                precise float _945 = 0.1593017578125 * log2(abs(_942));
                float _946 = exp2(_945);
                precise float _948 = 18.6875 * _946;
                precise float _949 = _948 + 1.0;
                precise float _952 = log2(fma(18.8515625, _946, 0.8359375)) - log2(_949);
                precise float _953 = 78.84375 * _952;
                float _954 = exp2(_953);
                precise float _955 = _909 * _906;
                precise float _957 = _955 * 0.0089999996125698089599609375;
                precise float _958 = _957 + _954;
                precise float _959 = _912 * _906;
                precise float _961 = _959 * 0.111000001430511474609375;
                precise float _962 = _961 + _958;
                precise float _964 = _955 * (-0.0089999996125698089599609375);
                precise float _965 = _964 + _954;
                precise float _969 = _959 * (-0.111000001430511474609375);
                precise float _970 = _969 + _965;
                precise float _972 = _955 * 0.560000002384185791015625;
                precise float _973 = _972 + _954;
                precise float _974 = 0.0126833133399486541748046875 * log2(abs(_962));
                precise float _978 = _959 * (-0.3210000097751617431640625);
                precise float _979 = _978 + _973;
                float _980 = exp2(_974);
                precise float _981 = 0.0126833133399486541748046875 * log2(abs(_970));
                float _985 = exp2(_981);
                precise float _986 = 0.0126833133399486541748046875 * log2(abs(_979));
                precise float _988 = (-0.8359375) + _980;
                float _990 = exp2(_986);
                precise float _991 = (1.0 / fma(-18.6875, _980, 18.8515625)) * _988;
                precise float _993 = (-0.8359375) + _985;
                precise float _997 = (1.0 / fma(-18.6875, _985, 18.8515625)) * _993;
                precise float _999 = (-0.8359375) + _990;
                precise float _1000 = 6.277394771575927734375 * log2(abs(_991));
                precise float _1003 = (1.0 / fma(-18.6875, _990, 18.8515625)) * _999;
                float _1004 = exp2(_1000);
                precise float _1005 = 6.277394771575927734375 * log2(abs(_997));
                precise float _1011 = 343.6610107421875 * _1004;
                precise float _1012 = _1011 + (-uintBitsToFloat(_710));
                float _1013 = exp2(_1005);
                precise float _1014 = 6.277394771575927734375 * log2(abs(_1003));
                precise float _1018 = (-79.13299560546875) * _1004;
                precise float _1019 = _1018 + (-uintBitsToFloat(_749));
                precise float _1023 = (-2.5949900150299072265625) * _1004;
                precise float _1024 = _1023 + (-uintBitsToFloat(_786));
                precise float _1026 = _1013 * (-250.644989013671875);
                precise float _1027 = _1026 + _1012;
                float _1028 = exp2(_1014);
                precise float _1030 = _1013 * 198.3600006103515625;
                precise float _1031 = _1030 + _1019;
                precise float _1033 = _1013 * (-9.89136981964111328125);
                precise float _1034 = _1033 + _1024;
                precise float _1036 = _1028 * 6.98453998565673828125;
                precise float _1037 = _1036 + _1027;
                precise float _1039 = _1028 * (-19.227100372314453125);
                precise float _1040 = _1039 + _1031;
                precise float _1042 = _1028 * 112.4860076904296875;
                precise float _1043 = _1042 + _1034;
                precise float _1045 = 0.5 * _1037;
                precise float _1046 = _1045 + uintBitsToFloat(_710);
                precise float _1048 = 0.5 * _1040;
                precise float _1049 = _1048 + uintBitsToFloat(_749);
                precise float _1051 = 0.5 * _1043;
                precise float _1052 = _1051 + uintBitsToFloat(_786);
                precise float _1062 = 0.00999999977648258209228515625 * max(0.0, min(uintBitsToFloat(ssbo_1_1.data[_439]), _1046));
                precise float _1063 = 0.00999999977648258209228515625 * max(0.0, min(uintBitsToFloat(ssbo_1_1.data[_439]), _1049));
                precise float _1064 = 0.00999999977648258209228515625 * max(0.0, min(uintBitsToFloat(ssbo_1_1.data[_439]), _1052));
                precise float _1068 = 0.1593017578125 * log2(_1062);
                precise float _1069 = 0.1593017578125 * log2(_1063);
                precise float _1070 = 0.1593017578125 * log2(_1064);
                float _1071 = exp2(_1068);
                float _1072 = exp2(_1069);
                float _1073 = exp2(_1070);
                precise float _1075 = 18.6875 * _1071;
                precise float _1076 = _1075 + 1.0;
                precise float _1078 = 18.6875 * _1072;
                precise float _1079 = _1078 + 1.0;
                precise float _1081 = 18.6875 * _1073;
                precise float _1082 = _1081 + 1.0;
                precise float _1089 = log2(fma(18.8515625, _1071, 0.8359375)) - log2(_1076);
                precise float _1090 = log2(fma(18.8515625, _1072, 0.8359375)) - log2(_1079);
                precise float _1091 = log2(fma(18.8515625, _1073, 0.8359375)) - log2(_1082);
                precise float _1092 = 78.84375 * _1089;
                precise float _1094 = 78.84375 * _1090;
                precise float _1096 = 78.84375 * _1091;
                _1103 = floatBitsToUint(exp2(_1096));
                _1104 = floatBitsToUint(exp2(_1094));
                _1105 = floatBitsToUint(exp2(_1092));
                _1106 = floatBitsToUint(_1092);
                _1107 = floatBitsToUint(_1094);
                _1108 = 1100316672u;
            }
            else
            {
                _1103 = floatBitsToUint(_624);
                _1104 = floatBitsToUint(_618);
                _1105 = _609;
                _1106 = floatBitsToUint(_634);
                _1107 = floatBitsToUint(_630);
                _1108 = _610;
            }
            uint _1571;
            uint _1572;
            uint _1573;
            if (!_627)
            {
                precise float _1111 = 0.2199999988079071044921875 + fma(uintBitsToFloat(_1108), 0.3300000131130218505859375, -0.072599999606609344482421875);
                float _1113 = 1.0 / uintBitsToFloat(_1108);
                precise float _1114 = _1113 * _1111;
                precise float _1115 = (-1.44269502162933349609375) * _1114;
                float _1116 = exp2(_1115);
                precise float _1118 = 0.13533528149127960205078125 - _1116;
                precise float _1120 = 2.0 * uintBitsToFloat(_1108);
                float _1121 = 1.0 / _1118;
                precise float _1124 = _1111 - uintBitsToFloat(_1108);
                precise float _1130 = _1121 * _1124;
                precise float _1131 = _1116 * _1130;
                precise float _1132 = _1131 + _1111;
                bool _1134 = _611 && ((uintBitsToFloat(_1107) > _1120) || (0.0 > uintBitsToFloat(_1107)));
                uint _1140;
                if (_1134)
                {
                    _1140 = floatBitsToUint((0.0 > uintBitsToFloat(_1107)) ? 0.0 : uintBitsToFloat(_1108));
                }
                else
                {
                    _1140 = floatBitsToUint(_1116);
                }
                uint _1174;
                uint _1175;
                uint _1176;
                if (_611 && (!_1134))
                {
                    precise float _1144 = 4.545454502105712890625 * uintBitsToFloat(_1107);
                    precise float _1146 = _1113 * uintBitsToFloat(_1107);
                    float _1148 = clamp(max(0.0, _1144), 0.0, 1.0);
                    precise float _1149 = (-1.44269502162933349609375) * _1146;
                    precise float _1152 = (-_1148) * _1148;
                    bool _1155 = uintBitsToFloat(_1107) < _1111;
                    precise float _1156 = _1152 * fma(-2.0, _1148, 3.0);
                    precise float _1157 = _1156 + 1.0;
                    precise float _1159 = exp2(_1149) * (-_1130);
                    precise float _1160 = _1159 + _1132;
                    float _1161 = _1155 ? 0.0 : (-1.0);
                    precise float _1163 = _1144 * _1157;
                    precise float _1165 = _1161 - _1157;
                    precise float _1166 = _1163 * 0.2199999988079071044921875;
                    precise float _1167 = _1166 + (_1155 ? 0.0 : _1160);
                    precise float _1168 = 1.0 + _1165;
                    precise float _1171 = _1168 * uintBitsToFloat(_1107);
                    precise float _1172 = _1171 + _1167;
                    _1174 = floatBitsToUint(_1161);
                    _1175 = floatBitsToUint(_1168);
                    _1176 = floatBitsToUint(_1172);
                }
                else
                {
                    _1174 = floatBitsToUint(_1124);
                    _1175 = floatBitsToUint(_1121);
                    _1176 = _1140;
                }
                bool _1182 = _611 && ((uintBitsToFloat(_1106) > _1120) || (0.0 > uintBitsToFloat(_1106)));
                uint _1188;
                if (_1182)
                {
                    _1188 = floatBitsToUint((0.0 > uintBitsToFloat(_1106)) ? 0.0 : uintBitsToFloat(_1108));
                }
                else
                {
                    _1188 = _1175;
                }
                uint _1221;
                uint _1222;
                if (_611 && (!_1182))
                {
                    precise float _1192 = 4.545454502105712890625 * uintBitsToFloat(_1106);
                    precise float _1194 = _1113 * uintBitsToFloat(_1106);
                    float _1196 = clamp(max(0.0, _1192), 0.0, 1.0);
                    precise float _1197 = (-1.44269502162933349609375) * _1194;
                    precise float _1200 = (-_1196) * _1196;
                    bool _1203 = uintBitsToFloat(_1106) < _1111;
                    precise float _1204 = _1200 * fma(-2.0, _1196, 3.0);
                    precise float _1205 = _1204 + 1.0;
                    precise float _1207 = exp2(_1197) * (-_1130);
                    precise float _1208 = _1207 + _1132;
                    precise float _1210 = _1192 * _1205;
                    precise float _1212 = (_1203 ? 0.0 : (-1.0)) - _1205;
                    precise float _1213 = _1210 * 0.2199999988079071044921875;
                    precise float _1214 = _1213 + (_1203 ? 0.0 : _1208);
                    precise float _1215 = 1.0 + _1212;
                    precise float _1218 = _1215 * uintBitsToFloat(_1106);
                    precise float _1219 = _1218 + _1214;
                    _1221 = floatBitsToUint(_1215);
                    _1222 = floatBitsToUint(_1219);
                }
                else
                {
                    _1221 = _1174;
                    _1222 = _1188;
                }
                bool _1226 = _611 && ((_638 > _1120) || (0.0 > _638));
                uint _1231;
                if (_1226)
                {
                    _1231 = floatBitsToUint((0.0 > _638) ? 0.0 : uintBitsToFloat(_1108));
                }
                else
                {
                    _1231 = _1221;
                }
                uint _1259;
                if (_611 && (!_1226))
                {
                    precise float _1234 = 4.545454502105712890625 * _638;
                    precise float _1235 = _1113 * _638;
                    float _1237 = clamp(max(0.0, _1234), 0.0, 1.0);
                    precise float _1238 = (-1.44269502162933349609375) * _1235;
                    precise float _1241 = (-_1237) * _1237;
                    bool _1243 = _638 < _1111;
                    precise float _1244 = _1241 * fma(-2.0, _1237, 3.0);
                    precise float _1245 = _1244 + 1.0;
                    precise float _1247 = exp2(_1238) * (-_1130);
                    precise float _1248 = _1247 + _1132;
                    precise float _1250 = _1234 * _1245;
                    precise float _1252 = (_1243 ? 0.0 : (-1.0)) - _1245;
                    precise float _1253 = _1250 * 0.2199999988079071044921875;
                    precise float _1254 = _1253 + (_1243 ? 0.0 : _1248);
                    precise float _1255 = 1.0 + _1252;
                    precise float _1256 = _1255 * _638;
                    precise float _1257 = _1256 + _1254;
                    _1259 = floatBitsToUint(_1257);
                }
                else
                {
                    _1259 = _1231;
                }
                precise float _1261 = 0.412109375 * uintBitsToFloat(_1107);
                precise float _1263 = 0.166748046875 * uintBitsToFloat(_1107);
                precise float _1265 = uintBitsToFloat(_1106) * 0.52392578125;
                precise float _1266 = _1265 + _1261;
                precise float _1268 = uintBitsToFloat(_1106) * 0.720458984375;
                precise float _1269 = _1268 + _1263;
                precise float _1270 = _638 * 0.06396484375;
                precise float _1271 = _1270 + _1266;
                precise float _1272 = _638 * 0.11279296875;
                precise float _1273 = _1272 + _1269;
                precise float _1274 = 0.00999999977648258209228515625 * _1271;
                precise float _1275 = 0.00999999977648258209228515625 * _1273;
                precise float _1280 = 0.1593017578125 * log2(abs(_1274));
                precise float _1281 = 0.1593017578125 * log2(abs(_1275));
                float _1282 = exp2(_1280);
                float _1283 = exp2(_1281);
                precise float _1285 = 18.6875 * _1282;
                precise float _1286 = _1285 + 1.0;
                precise float _1288 = 18.6875 * _1283;
                precise float _1289 = _1288 + 1.0;
                precise float _1294 = log2(fma(18.8515625, _1282, 0.8359375)) - log2(_1286);
                precise float _1295 = log2(fma(18.8515625, _1283, 0.8359375)) - log2(_1289);
                precise float _1296 = 78.84375 * _1294;
                precise float _1297 = 78.84375 * _1295;
                float _1298 = exp2(_1296);
                float _1299 = exp2(_1297);
                precise float _1300 = _1298 + _1299;
                precise float _1301 = _1300 * 0.5;
                precise float _1304 = 0.00999999977648258209228515625 * uintBitsToFloat(_1108);
                precise float _1305 = 0.0126833133399486541748046875 * log2(_1301);
                precise float _1309 = 0.024169921875 * uintBitsToFloat(_1107);
                float _1310 = exp2(_1305);
                precise float _1311 = 0.1593017578125 * log2(abs(_1304));
                precise float _1313 = uintBitsToFloat(_1106) * 0.075439453125;
                precise float _1314 = _1313 + _1309;
                float _1316 = exp2(_1311);
                precise float _1317 = _638 * 0.900390625;
                precise float _1318 = _1317 + _1314;
                precise float _1320 = (-0.8359375) + _1310;
                precise float _1322 = 18.6875 * _1316;
                precise float _1323 = _1322 + 1.0;
                precise float _1324 = 0.00999999977648258209228515625 * _1318;
                precise float _1325 = (1.0 / fma(-18.6875, _1310, 18.8515625)) * _1320;
                precise float _1332 = log2(fma(18.8515625, _1316, 0.8359375)) - log2(_1323);
                precise float _1333 = 0.1593017578125 * log2(abs(_1324));
                precise float _1334 = 6.277394771575927734375 * log2(abs(_1325));
                precise float _1335 = 78.84375 * _1332;
                float _1336 = exp2(_1333);
                float _1337 = exp2(_1334);
                precise float _1340 = 18.6875 * _1336;
                precise float _1341 = _1340 + 1.0;
                precise float _1342 = 100.0 * _1337;
                precise float _1346 = (1.0 / exp2(_1335)) * _1301;
                precise float _1347 = log2(fma(18.8515625, _1336, 0.8359375)) - log2(_1341);
                precise float _1349 = 1.61376953125 * _1298;
                precise float _1350 = 78.84375 * _1347;
                precise float _1351 = 4.378173828125 * _1298;
                precise float _1352 = 3.333332538604736328125 * _1346;
                precise float _1353 = _1352 + (-2.9999992847442626953125);
                float _1354 = clamp(_1353, 0.0, 1.0);
                precise float _1358 = (-_1354) * _1354;
                precise float _1359 = _1299 * (-3.323486328125);
                precise float _1360 = _1359 + _1349;
                float _1361 = exp2(_1350);
                precise float _1362 = _1299 * (-4.24560546875);
                precise float _1363 = _1362 + _1351;
                precise float _1364 = _1358 * fma(-2.0, _1354, 3.0);
                precise float _1365 = _1364 + 1.0;
                precise float _1366 = _1361 * 1.709716796875;
                precise float _1367 = _1366 + _1360;
                precise float _1368 = _1361 * (-0.132568359375);
                precise float _1369 = _1368 + _1363;
                uint _1396;
                if (_611 && (!(_1342 > _1120)))
                {
                    precise float _1371 = 454.545440673828125 * _1337;
                    precise float _1372 = _1113 * _1342;
                    float _1374 = clamp(max(0.0, _1371), 0.0, 1.0);
                    precise float _1375 = (-1.44269502162933349609375) * _1372;
                    precise float _1378 = (-_1374) * _1374;
                    bool _1380 = _1342 < _1111;
                    precise float _1381 = _1378 * fma(-2.0, _1374, 3.0);
                    precise float _1382 = _1381 + 1.0;
                    precise float _1384 = (-_1130) * exp2(_1375);
                    precise float _1385 = _1384 + _1132;
                    precise float _1387 = _1371 * _1382;
                    precise float _1389 = (_1380 ? 0.0 : (-1.0)) - _1382;
                    precise float _1390 = _1387 * 0.2199999988079071044921875;
                    precise float _1391 = _1390 + (_1380 ? 0.0 : _1385);
                    precise float _1392 = 1.0 + _1389;
                    precise float _1393 = _1392 * _1342;
                    precise float _1394 = _1393 + _1391;
                    _1396 = floatBitsToUint(_1394);
                }
                else
                {
                    _1396 = _1108;
                }
                precise float _1398 = 0.00999999977648258209228515625 * uintBitsToFloat(_1396);
                precise float _1401 = 0.1593017578125 * log2(abs(_1398));
                float _1402 = exp2(_1401);
                precise float _1404 = 18.6875 * _1402;
                precise float _1405 = _1404 + 1.0;
                precise float _1408 = log2(fma(18.8515625, _1402, 0.8359375)) - log2(_1405);
                precise float _1409 = 78.84375 * _1408;
                float _1410 = exp2(_1409);
                precise float _1411 = _1367 * _1365;
                precise float _1412 = _1411 * 0.0089999996125698089599609375;
                precise float _1413 = _1412 + _1410;
                precise float _1414 = _1369 * _1365;
                precise float _1415 = _1414 * 0.111000001430511474609375;
                precise float _1416 = _1415 + _1413;
                precise float _1417 = _1411 * (-0.0089999996125698089599609375);
                precise float _1418 = _1417 + _1410;
                precise float _1421 = _1414 * (-0.111000001430511474609375);
                precise float _1422 = _1421 + _1418;
                precise float _1423 = _1411 * 0.560000002384185791015625;
                precise float _1424 = _1423 + _1410;
                precise float _1425 = 0.0126833133399486541748046875 * log2(abs(_1416));
                precise float _1428 = _1414 * (-0.3210000097751617431640625);
                precise float _1429 = _1428 + _1424;
                float _1430 = exp2(_1425);
                precise float _1431 = 0.0126833133399486541748046875 * log2(abs(_1422));
                float _1435 = exp2(_1431);
                precise float _1436 = 0.0126833133399486541748046875 * log2(abs(_1429));
                precise float _1438 = (-0.8359375) + _1430;
                float _1440 = exp2(_1436);
                precise float _1441 = (1.0 / fma(-18.6875, _1430, 18.8515625)) * _1438;
                precise float _1443 = (-0.8359375) + _1435;
                precise float _1447 = (1.0 / fma(-18.6875, _1435, 18.8515625)) * _1443;
                precise float _1449 = (-0.8359375) + _1440;
                precise float _1450 = 6.277394771575927734375 * log2(abs(_1441));
                precise float _1453 = (1.0 / fma(-18.6875, _1440, 18.8515625)) * _1449;
                float _1454 = exp2(_1450);
                precise float _1455 = 6.277394771575927734375 * log2(abs(_1447));
                precise float _1460 = 343.6610107421875 * _1454;
                precise float _1461 = _1460 + (-uintBitsToFloat(_1176));
                float _1462 = exp2(_1455);
                precise float _1463 = 6.277394771575927734375 * log2(abs(_1453));
                precise float _1464 = _1462 * (-250.644989013671875);
                precise float _1465 = _1464 + _1461;
                float _1466 = exp2(_1463);
                precise float _1469 = (-79.13299560546875) * _1454;
                precise float _1470 = _1469 + (-uintBitsToFloat(_1222));
                precise float _1471 = _1466 * 6.98453998565673828125;
                precise float _1472 = _1471 + _1465;
                precise float _1473 = _1462 * 198.3600006103515625;
                precise float _1474 = _1473 + _1470;
                precise float _1477 = (-2.5949900150299072265625) * _1454;
                precise float _1478 = _1477 + (-uintBitsToFloat(_1259));
                precise float _1479 = _1462 * (-9.89136981964111328125);
                precise float _1480 = _1479 + _1478;
                precise float _1482 = 0.5 * _1472;
                precise float _1483 = _1482 + uintBitsToFloat(_1176);
                precise float _1484 = _1466 * (-19.227100372314453125);
                precise float _1485 = _1484 + _1474;
                precise float _1488 = _1466 * 112.4860076904296875;
                precise float _1489 = _1488 + _1480;
                precise float _1491 = 0.5 * _1485;
                precise float _1492 = _1491 + uintBitsToFloat(_1222);
                precise float _1497 = 0.5 * _1489;
                precise float _1498 = _1497 + uintBitsToFloat(_1259);
                precise float _1499 = _1113 * max(0.0, min(uintBitsToFloat(_1108), _1483));
                precise float _1504 = 1.66022694110870361328125 * _1499;
                precise float _1505 = _1113 * max(0.0, min(uintBitsToFloat(_1108), _1492));
                precise float _1508 = (-0.124554000794887542724609375) * _1499;
                precise float _1510 = (-0.01815499924123287200927734375) * _1499;
                precise float _1512 = _1505 * (-0.587547004222869873046875);
                precise float _1513 = _1512 + _1504;
                precise float _1514 = _1113 * max(0.0, min(uintBitsToFloat(_1108), _1498));
                precise float _1516 = _1505 * 1.13292598724365234375;
                precise float _1517 = _1516 + _1508;
                precise float _1519 = _1505 * (-0.10060299932956695556640625);
                precise float _1520 = _1519 + _1510;
                precise float _1522 = (-0.072838999330997467041015625) * _1514;
                precise float _1523 = _1522 + _1513;
                precise float _1526 = (-0.00834899954497814178466796875) * _1514;
                precise float _1527 = _1526 + _1517;
                precise float _1530 = 1.118998050689697265625 * _1514;
                precise float _1531 = _1530 + _1520;
                precise float _1537 = uintBitsToFloat(ssbo_1_1.data[_450]) * log2(clamp(_1523, 0.0, 1.0));
                precise float _1539 = uintBitsToFloat(ssbo_1_1.data[_450]) * log2(clamp(_1527, 0.0, 1.0));
                precise float _1541 = uintBitsToFloat(ssbo_1_1.data[_450]) * log2(clamp(_1531, 0.0, 1.0));
                precise float _1543 = 0.4166666567325592041015625 * _1537;
                precise float _1544 = 0.4166666567325592041015625 * _1539;
                precise float _1545 = 0.4166666567325592041015625 * _1541;
                precise float _1556 = 12.9200000762939453125 * exp2(_1537);
                precise float _1560 = 12.9200000762939453125 * exp2(_1539);
                precise float _1563 = 12.9200000762939453125 * exp2(_1541);
                _1571 = floatBitsToUint(((-8.31925296783447265625) >= _1541) ? _1563 : fma(1.05499994754791259765625, exp2(_1545), -0.054999999701976776123046875));
                _1572 = floatBitsToUint(((-8.31925296783447265625) >= _1539) ? _1560 : fma(1.05499994754791259765625, exp2(_1544), -0.054999999701976776123046875));
                _1573 = floatBitsToUint(((-8.31925296783447265625) >= _1537) ? _1556 : fma(1.05499994754791259765625, exp2(_1543), -0.054999999701976776123046875));
            }
            else
            {
                _1571 = _1103;
                _1572 = _1104;
                _1573 = _1105;
            }
            _1574 = _1571;
            _1575 = _1572;
            _1576 = _1573;
        }
        else
        {
            _1574 = _612;
            _1575 = _614;
            _1576 = _609;
        }
        _1577 = _1574;
        _1578 = _1576;
        _1579 = _1575;
    }
    else
    {
        _1577 = 0u;
        _1578 = 0u;
        _1579 = 0u;
    }
    frag_color0.x = uintBitsToFloat(_1577);
    frag_color0.y = uintBitsToFloat(_1579);
    frag_color0.z = uintBitsToFloat(_1578);
    frag_color0.w = 1.0;
}

