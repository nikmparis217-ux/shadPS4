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

#if defined(GL_KHR_shader_subgroup_ballot)
#extension GL_KHR_shader_subgroup_ballot : require
#elif defined(GL_NV_shader_thread_shuffle)
#extension GL_NV_shader_thread_shuffle : require
#elif defined(GL_ARB_shader_ballot) && defined(GL_ARB_shader_int64)
#extension GL_ARB_shader_int64 : enable
#extension GL_ARB_shader_ballot : require
#else
#error No extensions available to emulate requested subgroup feature.
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

uint _340;

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

layout(binding = 19) uniform writeonly image2DArray cs_img4;
uniform sampler2D SPIRV_Cross_Combinedcs_img72cs_sampsgpr_156;
uniform sampler2D SPIRV_Cross_Combinedcs_img80cs_sampsgpr_156;
uniform sampler2D SPIRV_Cross_Combinedcs_img56cs_sampsgpr_152;
uniform sampler2D SPIRV_Cross_Combinedcs_img64cs_sampsgpr_152;
uniform sampler2D SPIRV_Cross_Combinedcs_img120cs_sampsgpr_160;
uniform sampler2D SPIRV_Cross_Combinedcs_img128cs_sampsgpr_160;
uniform sampler2DArray SPIRV_Cross_Combinedcs_img112cs_sampsgpr_164;
uniform sampler2D SPIRV_Cross_Combinedcs_img136cs_sampsgpr_168;
uniform sampler2D SPIRV_Cross_Combinedcs_img88cs_sampinline_0xfff00000000000_0xa500000;
uniform sampler2D SPIRV_Cross_Combinedcs_img96cs_sampinline_0xfff00000000060_0x2500000;
uniform sampler2D SPIRV_Cross_Combinedcs_img104cs_sampinline_0xfff00000000060_0x2500000;
uniform sampler3D SPIRV_Cross_Combinedcs_img16cs_sampinline_0xfff00000000190_0x8000000002500000;
uniform sampler2D SPIRV_Cross_Combinedcs_img48cs_sampsgpr_148;
uniform sampler2DArray SPIRV_Cross_Combinedcs_img24cs_sampsgpr_144;
uniform sampler2D SPIRV_Cross_Combinedcs_img40cs_sampinline_0xfff00000000024_0x2500000;
uniform sampler2DArray SPIRV_Cross_Combinedcs_img32cs_sampsgpr_144;
uniform sampler3D SPIRV_Cross_Combinedcs_img16cs_sampinline_0xfff00000000190_0x8000000001000000;

#if defined(GL_KHR_shader_subgroup_ballot)
#elif defined(GL_NV_shader_thread_shuffle)
int subgroupBroadcastFirst(int value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
ivec2 subgroupBroadcastFirst(ivec2 value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
ivec3 subgroupBroadcastFirst(ivec3 value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
ivec4 subgroupBroadcastFirst(ivec4 value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
uint subgroupBroadcastFirst(uint value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
uvec2 subgroupBroadcastFirst(uvec2 value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
uvec3 subgroupBroadcastFirst(uvec3 value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
uvec4 subgroupBroadcastFirst(uvec4 value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
float subgroupBroadcastFirst(float value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
vec2 subgroupBroadcastFirst(vec2 value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
vec3 subgroupBroadcastFirst(vec3 value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
vec4 subgroupBroadcastFirst(vec4 value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
double subgroupBroadcastFirst(double value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
dvec2 subgroupBroadcastFirst(dvec2 value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
dvec3 subgroupBroadcastFirst(dvec3 value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
dvec4 subgroupBroadcastFirst(dvec4 value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
int subgroupBroadcast(int value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
ivec2 subgroupBroadcast(ivec2 value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
ivec3 subgroupBroadcast(ivec3 value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
ivec4 subgroupBroadcast(ivec4 value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
uint subgroupBroadcast(uint value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
uvec2 subgroupBroadcast(uvec2 value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
uvec3 subgroupBroadcast(uvec3 value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
uvec4 subgroupBroadcast(uvec4 value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
float subgroupBroadcast(float value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
vec2 subgroupBroadcast(vec2 value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
vec3 subgroupBroadcast(vec3 value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
vec4 subgroupBroadcast(vec4 value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
double subgroupBroadcast(double value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
dvec2 subgroupBroadcast(dvec2 value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
dvec3 subgroupBroadcast(dvec3 value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
dvec4 subgroupBroadcast(dvec4 value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
#elif defined(GL_ARB_shader_ballot)
int subgroupBroadcastFirst(int value) { return readFirstInvocationARB(value); }
ivec2 subgroupBroadcastFirst(ivec2 value) { return readFirstInvocationARB(value); }
ivec3 subgroupBroadcastFirst(ivec3 value) { return readFirstInvocationARB(value); }
ivec4 subgroupBroadcastFirst(ivec4 value) { return readFirstInvocationARB(value); }
uint subgroupBroadcastFirst(uint value) { return readFirstInvocationARB(value); }
uvec2 subgroupBroadcastFirst(uvec2 value) { return readFirstInvocationARB(value); }
uvec3 subgroupBroadcastFirst(uvec3 value) { return readFirstInvocationARB(value); }
uvec4 subgroupBroadcastFirst(uvec4 value) { return readFirstInvocationARB(value); }
float subgroupBroadcastFirst(float value) { return readFirstInvocationARB(value); }
vec2 subgroupBroadcastFirst(vec2 value) { return readFirstInvocationARB(value); }
vec3 subgroupBroadcastFirst(vec3 value) { return readFirstInvocationARB(value); }
vec4 subgroupBroadcastFirst(vec4 value) { return readFirstInvocationARB(value); }
double subgroupBroadcastFirst(double value) { return readFirstInvocationARB(value); }
dvec2 subgroupBroadcastFirst(dvec2 value) { return readFirstInvocationARB(value); }
dvec3 subgroupBroadcastFirst(dvec3 value) { return readFirstInvocationARB(value); }
dvec4 subgroupBroadcastFirst(dvec4 value) { return readFirstInvocationARB(value); }
int subgroupBroadcast(int value, uint id) { return readInvocationARB(value, id); }
ivec2 subgroupBroadcast(ivec2 value, uint id) { return readInvocationARB(value, id); }
ivec3 subgroupBroadcast(ivec3 value, uint id) { return readInvocationARB(value, id); }
ivec4 subgroupBroadcast(ivec4 value, uint id) { return readInvocationARB(value, id); }
uint subgroupBroadcast(uint value, uint id) { return readInvocationARB(value, id); }
uvec2 subgroupBroadcast(uvec2 value, uint id) { return readInvocationARB(value, id); }
uvec3 subgroupBroadcast(uvec3 value, uint id) { return readInvocationARB(value, id); }
uvec4 subgroupBroadcast(uvec4 value, uint id) { return readInvocationARB(value, id); }
float subgroupBroadcast(float value, uint id) { return readInvocationARB(value, id); }
vec2 subgroupBroadcast(vec2 value, uint id) { return readInvocationARB(value, id); }
vec3 subgroupBroadcast(vec3 value, uint id) { return readInvocationARB(value, id); }
vec4 subgroupBroadcast(vec4 value, uint id) { return readInvocationARB(value, id); }
double subgroupBroadcast(double value, uint id) { return readInvocationARB(value, id); }
dvec2 subgroupBroadcast(dvec2 value, uint id) { return readInvocationARB(value, id); }
dvec3 subgroupBroadcast(dvec3 value, uint id) { return readInvocationARB(value, id); }
dvec4 subgroupBroadcast(dvec4 value, uint id) { return readInvocationARB(value, id); }
#endif

void main()
{
    uint buf0_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(0u), int(8u)) >> 2u;
    uint buf1_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(8u), int(8u)) >> 2u;
    uint _371 = 176u + buf0_dword_off;
    uint _375 = 177u + buf0_dword_off;
    uint _378 = (gl_WorkGroupID.x << 3u) + gl_LocalInvocationID.x;
    uint _379 = (gl_WorkGroupID.y << 3u) + gl_LocalInvocationID.y;
    bool _382 = (ssbo_1_1.data[_375] < _379) || (ssbo_1_1.data[_371] < _378);
    bool _383 = !_382;
    if (!_382)
    {
        uint _387 = 188u + buf0_dword_off;
        float _397 = 1.0 / float(ssbo_1_1.data[_371]);
        float _399 = 1.0 / float(ssbo_1_1.data[_375]);
        precise float _402 = uintBitsToFloat(ssbo_1_1.data[189u + buf0_dword_off]) + float(int(gl_WorkGroupID.z));
        precise float _403 = float(int(_378)) * _397;
        precise float _404 = float(int(_379)) * _399;
        uint _405 = uint(int(_402));
        uint _406 = subgroupBroadcastFirst(_405);
        precise float _408 = 2.0 * _403;
        precise float _409 = _408 + _397;
        precise float _410 = 2.0 * _404;
        precise float _411 = _410 + _399;
        precise float _413 = (-1.0) + _409;
        precise float _414 = (-1.0) + _411;
        uint _469;
        uint _470;
        uint _471;
        if (0u != _406)
        {
            uint _424 = uint(2u == _406) | uint(1u == _406);
            uint _429 = uint(3u == _406) | uint(_424 != 0u);
            bool _431 = 1u == _406;
            bool _437 = 5u == _406;
            bool _446 = (0u != _424) ? _383 : false;
            bool _450 = (0u != _429) ? _383 : false;
            bool _459 = 0u != (uint(4u == _406) | uint(_429 != 0u));
            _469 = floatBitsToUint(_459 ? (_450 ? (_446 ? (_431 ? _413 : _414) : (-_414)) : 1.0) : uintBitsToFloat((5u == _406) ? 3212836864u : 0u));
            _470 = floatBitsToUint(_459 ? (_450 ? (_446 ? (_431 ? (-_414) : 1.0) : (-1.0)) : (-_414)) : (_437 ? (-_414) : 0.0));
            _471 = floatBitsToUint(_459 ? (_450 ? (_446 ? (_431 ? (-1.0) : _413) : _413) : _413) : (_437 ? (-_413) : 0.0));
        }
        else
        {
            _469 = floatBitsToUint(-_413);
            _470 = floatBitsToUint(-_414);
            _471 = 1065353216u;
        }
        precise float _474 = uintBitsToFloat(_471) * uintBitsToFloat(_471);
        precise float _477 = uintBitsToFloat(_470) * uintBitsToFloat(_470);
        precise float _478 = _477 + _474;
        precise float _481 = uintBitsToFloat(_469) * uintBitsToFloat(_469);
        precise float _482 = _481 + _478;
        float _484 = inversesqrt(_482);
        precise float _486 = uintBitsToFloat(_471) * _484;
        precise float _488 = uintBitsToFloat(_469) * _484;
        precise float _496 = (1.0 / max(abs(_488), abs(_486))) * min(abs(_488), abs(_486));
        precise float _497 = _496 * _496;
        precise float _507 = (-abs(uintBitsToFloat(_470))) * abs(_484);
        precise float _508 = _507 + 1.0;
        precise float _511 = _508 * _508;
        precise float _513 = fma(fma(fma(fma(0.02083499915897846221923828125, _497, -0.08513300120830535888671875), _497, 0.1801410019397735595703125), _497, -0.3302989900112152099609375), _497, 0.999866008758544921875);
        uint _514 = floatBitsToUint(_513);
        precise float _515 = _508 * _511;
        precise float _518 = (-0.000988719053566455841064453125) * _511;
        precise float _520 = (-0.117851130664348602294921875) * _508;
        precise float _521 = _496 * _513;
        precise float _523 = _515 * (-0.0003834455274045467376708984375);
        precise float _524 = _523 + _518;
        precise float _525 = _511 * _511;
        precise float _527 = _511 * (-0.026516504585742950439453125);
        precise float _528 = _527 + _520;
        precise float _543 = _525 * (-0.00015429117775056511163711547851562);
        precise float _544 = _543 + _524;
        precise float _546 = _525 * (-0.00268540973775088787078857421875);
        precise float _547 = _546 + _528;
        precise float _555 = _484 * min(uintBitsToFloat(_471), uintBitsToFloat(_469));
        precise float _556 = _484 * max(uintBitsToFloat(_471), uintBitsToFloat(_469));
        precise float _558 = (-0.00789181701838970184326171875) + _544;
        uint _559 = floatBitsToUint(_558);
        precise float _561 = (-1.41421353816986083984375) + _547;
        precise float _563 = uintBitsToFloat(_470) * _484;
        precise float _564 = ((abs(_486) < abs(_488)) ? fma(-2.0, _521, 1.57079637050628662109375) : 0.0) + ((0.0 > _486) ? (-3.1415927410125732421875) : 0.0);
        float _569 = sqrt(_508);
        precise float _574 = _558 * _515;
        precise float _575 = _574 + _561;
        precise float _576 = _569 * _575;
        precise float _578 = _513 * _496;
        precise float _579 = _578 + _564;
        precise float _581 = fma(_569, _575, 3.1415927410125732421875);
        float _585 = ((_555 < (-_555)) && (_556 >= (-_556))) ? (-_579) : _579;
        float _587 = (0.0 >= _563) ? _581 : (-_576);
        uint _1373;
        uint _1374;
        uint _1375;
        uint _1376;
        uint _1377;
        uint _1378;
        uint _1379;
        uint _1380;
        if (uintBitsToFloat(ssbo_1_1.data[359u + buf0_dword_off]) > 0.0)
        {
            bool _605 = _383 && (!((0.0 > _563) || ((uintBitsToFloat(ssbo_1_1.data[311u + buf0_dword_off]) > 0.0) || (!(uintBitsToFloat(ssbo_1_1.data[252u + buf0_dword_off]) > 0.0)))));
            uint _1365;
            uint _1366;
            uint _1367;
            uint _1368;
            uint _1369;
            uint _1370;
            uint _1371;
            uint _1372;
            if (_605)
            {
                bool _615 = uintBitsToFloat(ssbo_1_1.data[126u + buf0_dword_off]) > 0.0;
                bool _616 = !_615;
                uint _947;
                uint _948;
                uint _949;
                uint _950;
                uint _951;
                uint _952;
                bool _953;
                if (_615)
                {
                    precise float _619 = uintBitsToFloat(ssbo_1_1.data[127u + buf0_dword_off]) * (1.0 / _563);
                    float _621 = (0.0 == _563) ? 0.0 : _619;
                    precise float _622 = _621 * _486;
                    uint _637 = 131u + buf0_dword_off;
                    precise float _656 = _621 * _563;
                    precise float _660 = _621 * _486;
                    precise float _661 = _660 + (-uintBitsToFloat(ssbo_1_1.data[128u + buf0_dword_off]));
                    precise float _662 = _661 * _661;
                    precise float _665 = _621 * _563;
                    precise float _666 = _665 + (-uintBitsToFloat(ssbo_1_1.data[129u + buf0_dword_off]));
                    precise float _669 = _621 * _488;
                    precise float _670 = _669 + (-uintBitsToFloat(ssbo_1_1.data[130u + buf0_dword_off]));
                    precise float _671 = _666 * _666;
                    precise float _672 = _671 + _662;
                    precise float _673 = _670 * _670;
                    precise float _674 = _673 + _672;
                    float _675 = inversesqrt(_674);
                    precise float _676 = _675 * _661;
                    precise float _677 = _675 * _670;
                    precise float _685 = (1.0 / max(abs(_677), abs(_676))) * min(abs(_677), abs(_676));
                    precise float _686 = _685 * _685;
                    precise float _691 = (-abs(_675)) * abs(_666);
                    precise float _692 = _691 + 1.0;
                    precise float _694 = _692 * _692;
                    precise float _696 = _692 * _694;
                    precise float _697 = (-0.000988719053566455841064453125) * _694;
                    precise float _698 = (-0.117851130664348602294921875) * _692;
                    precise float _699 = fma(fma(fma(fma(0.02083499915897846221923828125, _686, -0.08513300120830535888671875), _686, 0.1801410019397735595703125), _686, -0.3302989900112152099609375), _686, 0.999866008758544921875);
                    precise float _700 = _696 * (-0.0003834455274045467376708984375);
                    precise float _701 = _700 + _697;
                    precise float _702 = _694 * _694;
                    precise float _703 = _694 * (-0.026516504585742950439453125);
                    precise float _704 = _703 + _698;
                    precise float _705 = _685 * _699;
                    precise float _707 = _702 * (-0.00015429117775056511163711547851562);
                    precise float _708 = _707 + _701;
                    precise float _709 = _702 * (-0.00268540973775088787078857421875);
                    precise float _710 = _709 + _704;
                    precise float _718 = (-0.00789181701838970184326171875) + _708;
                    precise float _719 = (-1.41421353816986083984375) + _710;
                    precise float _722 = _675 * min(_661, _670);
                    precise float _723 = _675 * max(_661, _670);
                    float _724 = sqrt(_692);
                    precise float _725 = _675 * _666;
                    precise float _726 = _718 * _696;
                    precise float _727 = _726 + _719;
                    precise float _728 = ((abs(_676) < abs(_677)) ? fma(-2.0, _705, 1.57079637050628662109375) : 0.0) + ((0.0 > _676) ? (-3.1415927410125732421875) : 0.0);
                    precise float _734 = _724 * _727;
                    bool _739 = uintBitsToFloat(ssbo_1_1.data[135u + buf0_dword_off]) > 0.0;
                    precise float _740 = _699 * _685;
                    precise float _741 = _740 + _728;
                    precise float _743 = 0.636619746685028076171875 * ((0.0 >= _725) ? fma(_724, _727, 3.1415927410125732421875) : (-_734));
                    precise float _744 = _743 * _743;
                    precise float _746 = _675 * _621;
                    float _750 = ((_722 < (-_722)) && (_723 >= (-_723))) ? (-_741) : _741;
                    precise float _751 = 1.57079637050628662109375 + _750;
                    precise float _752 = _621 * _488;
                    uint _770;
                    if (_739)
                    {
                        precise float _757 = 8.6393795013427734375 + _750;
                        precise float _759 = trunc(fma(_750, 0.636619746685028076171875, 5.499999523162841796875)) * (-1.57079637050628662109375);
                        precise float _760 = _759 + _757;
                        precise float _768 = (1.0 / cos(6.283185482025146484375 * fract(fma(_760, 0.15915493667125701904296875, -0.125)))) * _744;
                        _770 = floatBitsToUint(_768);
                    }
                    else
                    {
                        _770 = floatBitsToUint(_744);
                    }
                    precise float _771 = 0.15915493667125701904296875 * _751;
                    float _772 = fract(_771);
                    precise float _777 = 0.5 * uintBitsToFloat(_770);
                    bool _781 = uintBitsToFloat(ssbo_1_1.data[_637]) > 0.0;
                    precise float _782 = cos(6.283185482025146484375 * _772) * _777;
                    precise float _783 = _782 + 0.5;
                    precise float _785 = sin(6.283185482025146484375 * _772) * _777;
                    precise float _786 = _785 + 0.5;
                    uint _941;
                    uint _942;
                    uint _943;
                    uint _944;
                    uint _945;
                    uint _946;
                    if (_781)
                    {
                        precise float _790 = _622 - uintBitsToFloat(ssbo_1_1.data[132u + buf0_dword_off]);
                        precise float _791 = _790 * _790;
                        precise float _793 = _656 - uintBitsToFloat(ssbo_1_1.data[133u + buf0_dword_off]);
                        vec4 _798 = textureLod(SPIRV_Cross_Combinedcs_img72cs_sampsgpr_156, vec2(_783, _786), 0.0);
                        float _799 = _798.x;
                        float _801 = _798.z;
                        float _802 = _798.w;
                        precise float _804 = _752 - uintBitsToFloat(ssbo_1_1.data[134u + buf0_dword_off]);
                        precise float _805 = _793 * _793;
                        precise float _806 = _805 + _791;
                        precise float _807 = _804 * _804;
                        precise float _808 = _807 + _806;
                        float _809 = inversesqrt(_808);
                        precise float _810 = _809 * _790;
                        precise float _811 = _809 * _804;
                        precise float _819 = (1.0 / max(abs(_811), abs(_810))) * min(abs(_811), abs(_810));
                        precise float _820 = _819 * _819;
                        precise float _825 = (-abs(_809)) * abs(_793);
                        precise float _826 = _825 + 1.0;
                        precise float _828 = _826 * _826;
                        precise float _830 = _826 * _828;
                        precise float _831 = (-0.000988719053566455841064453125) * _828;
                        precise float _832 = (-0.117851130664348602294921875) * _826;
                        precise float _833 = fma(fma(fma(fma(0.02083499915897846221923828125, _820, -0.08513300120830535888671875), _820, 0.1801410019397735595703125), _820, -0.3302989900112152099609375), _820, 0.999866008758544921875);
                        precise float _834 = _830 * (-0.0003834455274045467376708984375);
                        precise float _835 = _834 + _831;
                        precise float _836 = _828 * _828;
                        precise float _837 = _828 * (-0.026516504585742950439453125);
                        precise float _838 = _837 + _832;
                        precise float _839 = _819 * _833;
                        precise float _840 = _836 * (-0.00015429117775056511163711547851562);
                        precise float _841 = _840 + _835;
                        precise float _842 = _836 * (-0.00268540973775088787078857421875);
                        precise float _843 = _842 + _838;
                        precise float _844 = fma(-2.0, _839, 1.57079637050628662109375);
                        precise float _852 = (-0.00789181701838970184326171875) + _841;
                        precise float _853 = (-1.41421353816986083984375) + _843;
                        precise float _856 = _809 * min(_790, _804);
                        precise float _857 = _809 * max(_790, _804);
                        float _858 = sqrt(_826);
                        precise float _859 = _809 * _793;
                        precise float _860 = _852 * _830;
                        precise float _861 = _860 + _853;
                        precise float _862 = ((abs(_810) < abs(_811)) ? _844 : 0.0) + ((0.0 > _810) ? (-3.1415927410125732421875) : 0.0);
                        precise float _868 = _858 * _861;
                        precise float _872 = _833 * _819;
                        precise float _873 = _872 + _862;
                        precise float _874 = 0.636619746685028076171875 * ((0.0 >= _859) ? fma(_858, _861, 3.1415927410125732421875) : (-_868));
                        precise float _875 = _874 * _874;
                        float _880 = ((_856 < (-_856)) && (_857 >= (-_857))) ? (-_873) : _873;
                        precise float _881 = 1.57079637050628662109375 + _880;
                        precise float _882 = _809 * _621;
                        precise float _883 = _798.y * _746;
                        uint _896;
                        if (_605 && _739)
                        {
                            precise float _884 = 8.6393795013427734375 + _880;
                            precise float _887 = trunc(fma(_880, 0.636619746685028076171875, 5.499999523162841796875)) * (-1.57079637050628662109375);
                            precise float _888 = _887 + _884;
                            precise float _894 = (1.0 / cos(6.283185482025146484375 * fract(fma(_888, 0.15915493667125701904296875, -0.125)))) * _875;
                            _896 = floatBitsToUint(_894);
                        }
                        else
                        {
                            _896 = floatBitsToUint(_875);
                        }
                        precise float _897 = 0.15915493667125701904296875 * _881;
                        float _898 = fract(_897);
                        precise float _902 = 0.5 * uintBitsToFloat(_896);
                        precise float _905 = cos(6.283185482025146484375 * _898) * _902;
                        precise float _906 = _905 + 0.5;
                        precise float _907 = sin(6.283185482025146484375 * _898) * _902;
                        precise float _908 = _907 + 0.5;
                        vec4 _913 = textureLod(SPIRV_Cross_Combinedcs_img80cs_sampsgpr_156, vec2(_906, _908), 0.0);
                        precise float _918 = _913.x - _799;
                        precise float _920 = _913.y * _882;
                        precise float _921 = _920 + (-_883);
                        precise float _922 = _913.z - _801;
                        precise float _923 = _913.w - _802;
                        precise float _926 = uintBitsToFloat(ssbo_1_1.data[_637]) * _918;
                        precise float _927 = _926 + _799;
                        precise float _930 = uintBitsToFloat(ssbo_1_1.data[_637]) * _921;
                        precise float _931 = _930 + _883;
                        precise float _934 = uintBitsToFloat(ssbo_1_1.data[_637]) * _922;
                        precise float _935 = _934 + _801;
                        precise float _938 = uintBitsToFloat(ssbo_1_1.data[_637]) * _923;
                        precise float _939 = _938 + _802;
                        _941 = floatBitsToUint(_844);
                        _942 = floatBitsToUint(_923);
                        _943 = floatBitsToUint(_939);
                        _944 = floatBitsToUint(_935);
                        _945 = floatBitsToUint(_931);
                        _946 = floatBitsToUint(_927);
                    }
                    else
                    {
                        _941 = floatBitsToUint(_705);
                        _942 = floatBitsToUint(_746);
                        _943 = floatBitsToUint(_622);
                        _944 = floatBitsToUint(_656);
                        _945 = floatBitsToUint(_786);
                        _946 = floatBitsToUint(_783);
                    }
                    _947 = _941;
                    _948 = _942;
                    _949 = _943;
                    _950 = _944;
                    _951 = _945;
                    _952 = _946;
                    _953 = !_781;
                }
                else
                {
                    _947 = _340;
                    _948 = floatBitsToUint(_515);
                    _949 = floatBitsToUint(_569);
                    _950 = floatBitsToUint(_576);
                    _951 = floatBitsToUint(_581);
                    _952 = 1065353216u;
                    _953 = false;
                }
                uint _1085;
                uint _1086;
                uint _1087;
                uint _1088;
                if (_616 || _953)
                {
                    uint _972;
                    uint _973;
                    uint _974;
                    uint _975;
                    if (_615)
                    {
                        vec4 _961 = textureLod(SPIRV_Cross_Combinedcs_img72cs_sampsgpr_156, vec2(uintBitsToFloat(_952), uintBitsToFloat(_951)), 0.0);
                        precise float _970 = _961.y * uintBitsToFloat(_948);
                        _972 = floatBitsToUint(_961.x);
                        _973 = floatBitsToUint(_961.w);
                        _974 = floatBitsToUint(_961.z);
                        _975 = floatBitsToUint(_970);
                    }
                    else
                    {
                        _972 = _952;
                        _973 = _949;
                        _974 = _950;
                        _975 = _951;
                    }
                    uint _1081;
                    uint _1082;
                    uint _1083;
                    uint _1084;
                    if (_616)
                    {
                        precise float _976 = 0.636619746685028076171875 * _587;
                        precise float _980 = _976 * _976;
                        precise float _984 = 1.57079637050628662109375 + _585;
                        uint _997;
                        if (uintBitsToFloat(ssbo_1_1.data[135u + buf0_dword_off]) > 0.0)
                        {
                            precise float _985 = 8.6393795013427734375 + _585;
                            precise float _988 = trunc(fma(_585, 0.636619746685028076171875, 5.499999523162841796875)) * (-1.57079637050628662109375);
                            precise float _989 = _988 + _985;
                            precise float _995 = (1.0 / cos(6.283185482025146484375 * fract(fma(_989, 0.15915493667125701904296875, -0.125)))) * _980;
                            _997 = floatBitsToUint(_995);
                        }
                        else
                        {
                            _997 = floatBitsToUint(_980);
                        }
                        precise float _998 = 0.15915493667125701904296875 * _984;
                        uint _999 = 131u + buf0_dword_off;
                        float _1002 = fract(_998);
                        precise float _1006 = 0.5 * uintBitsToFloat(_997);
                        float _1009 = sin(6.283185482025146484375 * _1002);
                        bool _1012 = uintBitsToFloat(ssbo_1_1.data[_999]) > 0.0;
                        precise float _1013 = cos(6.283185482025146484375 * _1002) * _1006;
                        precise float _1014 = _1013 + 0.5;
                        precise float _1016 = _1009 * _1006;
                        precise float _1017 = _1016 + 0.5;
                        uint _1058;
                        uint _1059;
                        uint _1060;
                        uint _1061;
                        if (_1012)
                        {
                            vec4 _1024 = textureLod(SPIRV_Cross_Combinedcs_img80cs_sampsgpr_156, vec2(_1014, _1017), 0.0);
                            vec4 _1033 = textureLod(SPIRV_Cross_Combinedcs_img72cs_sampsgpr_156, vec2(_1014, _1017), 0.0);
                            float _1034 = _1033.x;
                            float _1035 = _1033.y;
                            float _1036 = _1033.z;
                            float _1037 = _1033.w;
                            precise float _1038 = _1024.x - _1034;
                            precise float _1039 = _1024.y - _1035;
                            precise float _1040 = _1024.z - _1036;
                            precise float _1041 = _1024.w - _1037;
                            precise float _1043 = uintBitsToFloat(ssbo_1_1.data[_999]) * _1038;
                            precise float _1044 = _1043 + _1034;
                            precise float _1047 = uintBitsToFloat(ssbo_1_1.data[_999]) * _1039;
                            precise float _1048 = _1047 + _1035;
                            precise float _1051 = uintBitsToFloat(ssbo_1_1.data[_999]) * _1040;
                            precise float _1052 = _1051 + _1036;
                            precise float _1055 = uintBitsToFloat(ssbo_1_1.data[_999]) * _1041;
                            precise float _1056 = _1055 + _1037;
                            _1058 = floatBitsToUint(_1056);
                            _1059 = floatBitsToUint(_1052);
                            _1060 = floatBitsToUint(_1048);
                            _1061 = floatBitsToUint(_1044);
                        }
                        else
                        {
                            _1058 = floatBitsToUint(_1009);
                            _1059 = floatBitsToUint(_1006);
                            _1060 = floatBitsToUint(_1017);
                            _1061 = floatBitsToUint(_1014);
                        }
                        uint _1077;
                        uint _1078;
                        uint _1079;
                        uint _1080;
                        if (!_1012)
                        {
                            vec4 _1068 = textureLod(SPIRV_Cross_Combinedcs_img72cs_sampsgpr_156, vec2(uintBitsToFloat(_1061), uintBitsToFloat(_1060)), 0.0);
                            _1077 = floatBitsToUint(_1068.x);
                            _1078 = floatBitsToUint(_1068.w);
                            _1079 = floatBitsToUint(_1068.z);
                            _1080 = floatBitsToUint(_1068.y);
                        }
                        else
                        {
                            _1077 = _1061;
                            _1078 = _1058;
                            _1079 = _1059;
                            _1080 = _1060;
                        }
                        _1081 = _1077;
                        _1082 = _1078;
                        _1083 = _1079;
                        _1084 = _1080;
                    }
                    else
                    {
                        _1081 = _972;
                        _1082 = _973;
                        _1083 = _974;
                        _1084 = _975;
                    }
                    _1085 = _1081;
                    _1086 = _1082;
                    _1087 = _1083;
                    _1088 = _1084;
                }
                else
                {
                    _1085 = _952;
                    _1086 = _949;
                    _1087 = _950;
                    _1088 = _951;
                }
                precise float _1091 = 1024.0 * uintBitsToFloat(_1088);
                uint _1106 = 107u + buf0_dword_off;
                uint _1110 = 111u + buf0_dword_off;
                precise float _1113 = _486 * _1091;
                precise float _1128 = uintBitsToFloat(ssbo_1_1.data[_1106]) + uintBitsToFloat(ssbo_1_1.data[106u + buf0_dword_off]);
                precise float _1129 = _1113 * _1113;
                precise float _1130 = _1091 * _563;
                precise float _1131 = _1130 + _1128;
                precise float _1133 = uintBitsToFloat(ssbo_1_1.data[344u + buf0_dword_off]) * _1113;
                precise float _1134 = _488 * _1091;
                precise float _1135 = _1131 * _1131;
                precise float _1136 = _1135 + _1129;
                precise float _1138 = _1131 * uintBitsToFloat(ssbo_1_1.data[345u + buf0_dword_off]);
                precise float _1139 = _1138 + _1133;
                precise float _1140 = _1134 * _1134;
                precise float _1141 = _1140 + _1136;
                precise float _1144 = uintBitsToFloat(ssbo_1_1.data[346u + buf0_dword_off]) * _1134;
                precise float _1145 = _1144 + _1139;
                precise float _1146 = inversesqrt(_1141) * _1145;
                float _1150 = max(min(1.0, _1146), min(max(1.0, _1146), -1.0));
                precise float _1153 = 1.0 + (-abs(_1150));
                precise float _1154 = _1153 * _1153;
                precise float _1155 = _1153 * _1154;
                precise float _1156 = (-0.000988719053566455841064453125) * _1154;
                precise float _1160 = _1155 * (-0.0003834455274045467376708984375);
                precise float _1161 = _1160 + _1156;
                precise float _1162 = _1154 * _1154;
                precise float _1163 = _1154 * (-0.026516504585742950439453125);
                precise float _1164 = _1163 + fma(-abs(_1150), -0.117851130664348602294921875, -0.117851130664348602294921875);
                precise float _1165 = _1162 * (-0.00015429117775056511163711547851562);
                precise float _1166 = _1165 + _1161;
                precise float _1167 = _1162 * (-0.00268540973775088787078857421875);
                precise float _1168 = _1167 + _1164;
                precise float _1169 = (-0.00789181701838970184326171875) + _1166;
                precise float _1170 = (-1.41421353816986083984375) + _1168;
                uint _1172 = 120u + buf0_dword_off;
                uint _1176 = 121u + buf0_dword_off;
                float _1183 = sqrt(_1153);
                precise float _1184 = _1169 * _1155;
                precise float _1185 = _1184 + _1170;
                precise float _1187 = _1183 * _1185;
                precise float _1191 = 0.0174532942473888397216796875 * uintBitsToFloat(ssbo_1_1.data[122u + buf0_dword_off]);
                float _1193 = (0.0 >= _1146) ? fma(_1183, _1185, 3.1415927410125732421875) : (-_1187);
                precise float _1195 = uintBitsToFloat(ssbo_1_1.data[_1172]) * 0.0174532942473888397216796875;
                precise float _1196 = _1195 + _1191;
                bool _1197 = _1193 < _1191;
                bool _1198 = _1196 < _1193;
                float _1199 = float(_1197);
                precise float _1204 = sqrt(_1141) - uintBitsToFloat(ssbo_1_1.data[_1106]);
                precise float _1209 = 0.0174532942473888397216796875 * uintBitsToFloat(ssbo_1_1.data[_1172]);
                uint _1221;
                if (_605 && (!(_1198 || _1197)))
                {
                    precise float _1211 = _1193 - _1191;
                    precise float _1213 = (1.0 / _1209) * _1211;
                    precise float _1217 = uintBitsToFloat(ssbo_1_1.data[_1176]) * log2(abs(_1213));
                    precise float _1219 = 1.0 - exp2(_1217);
                    _1221 = floatBitsToUint(_1219);
                }
                else
                {
                    _1221 = floatBitsToUint(_1199);
                }
                uint _1223 = 100u + buf0_dword_off;
                precise float _1235 = _1204 - uintBitsToFloat(ssbo_1_1.data[_1223]);
                precise float _1238 = uintBitsToFloat(ssbo_1_1.data[101u + buf0_dword_off]) - uintBitsToFloat(ssbo_1_1.data[_1223]);
                float _1242 = 1.0 / uintBitsToFloat(ssbo_1_1.data[105u + buf0_dword_off]);
                float _1246 = 1.0 / uintBitsToFloat(ssbo_1_1.data[104u + buf0_dword_off]);
                precise float _1247 = (1.0 / _1238) * max(0.0, _1235);
                precise float _1248 = 1.0 - _1242;
                precise float _1249 = (1.0 / uintBitsToFloat(ssbo_1_1.data[102u + buf0_dword_off])) * _1193;
                precise float _1250 = 1.0 - _1246;
                precise float _1251 = _1247 * _1248;
                precise float _1252 = _1249 * _1250;
                precise float _1253 = 0.5 * _1242;
                precise float _1254 = _1253 + _1251;
                precise float _1255 = 0.5 * _1246;
                precise float _1256 = _1255 + _1252;
                precise float _1258 = _1256 * _1256;
                vec4 _1263 = textureLod(SPIRV_Cross_Combinedcs_img56cs_sampsgpr_152, vec2(_1258, sqrt(_1254)), 0.0);
                float _1277 = 1.0 / uintBitsToFloat(ssbo_1_1.data[117u + buf0_dword_off]);
                precise float _1278 = 1.0 - _1277;
                precise float _1279 = _1249 * _1278;
                precise float _1280 = 0.5 * _1277;
                precise float _1281 = _1280 + _1279;
                precise float _1282 = _1281 * _1281;
                precise float _1284 = _1263.x * uintBitsToFloat(_1221);
                precise float _1286 = uintBitsToFloat(_1221) * _1263.y;
                precise float _1288 = uintBitsToFloat(_1221) * _1263.z;
                precise float _1290 = uintBitsToFloat(ssbo_1_1.data[_1110]) * _1284;
                precise float _1292 = uintBitsToFloat(ssbo_1_1.data[_1110]) * _1286;
                precise float _1294 = uintBitsToFloat(ssbo_1_1.data[_1110]) * _1288;
                uint _1306;
                if (_605 && (!(_1198 || _1197)))
                {
                    precise float _1296 = _1193 - _1191;
                    precise float _1298 = (1.0 / _1209) * _1296;
                    precise float _1302 = uintBitsToFloat(ssbo_1_1.data[_1176]) * log2(abs(_1298));
                    precise float _1304 = 1.0 - exp2(_1302);
                    _1306 = floatBitsToUint(_1304);
                }
                else
                {
                    _1306 = floatBitsToUint(_1199);
                }
                precise float _1309 = uintBitsToFloat(ssbo_1_1.data[118u + buf0_dword_off]) * uintBitsToFloat(ssbo_1_1.data[_1110]);
                vec4 _1314 = textureLod(SPIRV_Cross_Combinedcs_img64cs_sampsgpr_152, vec2(_1282, 0.5), 0.0);
                precise float _1331 = _1309 * uintBitsToFloat(_1306);
                precise float _1333 = uintBitsToFloat(_1087) * _1292;
                precise float _1335 = uintBitsToFloat(_1087) * _1294;
                precise float _1337 = uintBitsToFloat(_1087) * _1290;
                precise float _1338 = _1309 * _1314.y;
                precise float _1339 = _1309 * _1314.z;
                precise float _1343 = _1338 * uintBitsToFloat(_1306);
                precise float _1344 = _1343 + uintBitsToFloat(ssbo_1_1.data[114u + buf0_dword_off]);
                precise float _1348 = _1339 * uintBitsToFloat(_1306);
                precise float _1349 = _1348 + uintBitsToFloat(ssbo_1_1.data[115u + buf0_dword_off]);
                precise float _1351 = _1331 * _1314.x;
                precise float _1352 = _1351 + uintBitsToFloat(ssbo_1_1.data[113u + buf0_dword_off]);
                precise float _1354 = uintBitsToFloat(_1086) * _1349;
                precise float _1355 = _1354 + _1335;
                precise float _1358 = _1344 * uintBitsToFloat(_1086);
                precise float _1359 = _1358 + _1333;
                precise float _1362 = _1352 * uintBitsToFloat(_1086);
                precise float _1363 = _1362 + _1337;
                _1365 = _947;
                _1366 = floatBitsToUint(_1359);
                _1367 = floatBitsToUint(_1363);
                _1368 = floatBitsToUint(_1355);
                _1369 = floatBitsToUint(_1091);
                _1370 = floatBitsToUint(_1344);
                _1371 = _1085;
                _1372 = floatBitsToUint(_1339);
            }
            else
            {
                _1365 = _340;
                _1366 = 0u;
                _1367 = 0u;
                _1368 = 0u;
                _1369 = 0u;
                _1370 = _514;
                _1371 = 1065353216u;
                _1372 = _559;
            }
            _1373 = _1365;
            _1374 = _1366;
            _1375 = _1367;
            _1376 = _1368;
            _1377 = _1369;
            _1378 = _1370;
            _1379 = _1371;
            _1380 = _1372;
        }
        else
        {
            _1373 = _340;
            _1374 = 0u;
            _1375 = 0u;
            _1376 = 0u;
            _1377 = 0u;
            _1378 = _514;
            _1379 = 1065353216u;
            _1380 = _559;
        }
        uint _1382 = 196u + buf0_dword_off;
        uint _1386 = 197u + buf0_dword_off;
        precise float _1402 = 1.57079637050628662109375 - uintBitsToFloat(ssbo_1_1.data[_1386]);
        precise float _1408 = uintBitsToFloat(ssbo_1_1.data[202u + buf0_dword_off]) + _585;
        precise float _1409 = 1.57079637050628662109375 + _1408;
        bool _1413 = _383 && (((1.57079637050628662109375 >= _587) && (_1402 <= _587)) || (uintBitsToFloat(ssbo_1_1.data[_1386]) <= 0.0));
        uint _1418;
        if (_1413)
        {
            _1418 = floatBitsToUint((uintBitsToFloat(ssbo_1_1.data[_1386]) > 0.0) ? _1402 : _587);
        }
        else
        {
            _1418 = _1380;
        }
        uint _1428;
        if (_383 && (!_1413))
        {
            precise float _1422 = 1.57079637050628662109375 + uintBitsToFloat(ssbo_1_1.data[_1386]);
            _1428 = floatBitsToUint(((1.57079637050628662109375 <= _587) && (_587 <= _1422)) ? _1422 : _587);
        }
        else
        {
            _1428 = _1418;
        }
        uint _1438 = 206u + buf0_dword_off;
        uint _1442 = 208u + buf0_dword_off;
        uint _1450 = 210u + buf0_dword_off;
        precise float _1454 = 0.15915493667125701904296875 * uintBitsToFloat(_1428);
        precise float _1455 = 0.15915493667125701904296875 * _1409;
        float _1456 = fract(_1454);
        float _1458 = fract(_1455);
        bool _1460 = uintBitsToFloat(ssbo_1_1.data[_1450]) <= 0.0;
        float _1464 = sin(6.283185482025146484375 * _1456);
        float _1466 = cos(6.283185482025146484375 * _1458);
        float _1469 = sin(6.283185482025146484375 * _1458);
        precise float _1471 = _1464 * _1466;
        uint _1472 = floatBitsToUint(_1471);
        precise float _1474 = _1464 * _1469;
        float _1476 = cos(6.283185482025146484375 * _1456);
        uint _1477 = floatBitsToUint(_1476);
        uint _2119;
        uint _2120;
        uint _2121;
        uint _2122;
        uint _2123;
        if (!((uintBitsToFloat(ssbo_1_1.data[_1438]) <= 0.0) && _1460))
        {
            uint _1499;
            uint _1500;
            uint _1501;
            uint _1502;
            if (_383 && (uintBitsToFloat(ssbo_1_1.data[_1382]) > 0.0))
            {
                precise float _1482 = 0.15915493667125701904296875 * _1409;
                precise float _1485 = trunc(_1482) * (-6.283185482025146484375);
                precise float _1486 = _1485 + _1409;
                precise float _1489 = 1.57079637050628662109375 - uintBitsToFloat(ssbo_1_1.data[_1382]);
                precise float _1492 = 1.57079637050628662109375 + uintBitsToFloat(ssbo_1_1.data[_1382]);
                _1499 = floatBitsToUint(_1492);
                _1500 = floatBitsToUint(_1486);
                _1501 = floatBitsToUint(_1489);
                _1502 = floatBitsToUint(((_1489 <= _1486) && (_1486 <= _1492)) ? _1489 : _1409);
            }
            else
            {
                _1499 = floatBitsToUint(_1456);
                _1500 = floatBitsToUint(_1466);
                _1501 = floatBitsToUint(_1469);
                _1502 = floatBitsToUint(_1409);
            }
            uint _1508 = 186u + buf0_dword_off;
            uint _1512 = 187u + buf0_dword_off;
            bool _1516 = uintBitsToFloat(ssbo_1_1.data[184u + buf0_dword_off]) > 0.0;
            uint _1601;
            uint _1602;
            uint _1603;
            uint _1604;
            uint _1605;
            uint _1606;
            uint _1607;
            if (_1516)
            {
                precise float _1524 = 4.7123889923095703125 + uintBitsToFloat(_1502);
                precise float _1525 = trunc(fma(uintBitsToFloat(_1502), 0.15915493667125701904296875, 0.75)) * (-6.283185482025146484375);
                precise float _1526 = _1525 + _1524;
                precise float _1528 = 6.283185482025146484375 - _1526;
                precise float _1532 = 0.3183098733425140380859375 * uintBitsToFloat(_1428);
                precise float _1534 = 0.3183098733425140380859375 * ((3.1415927410125732421875 < _1526) ? _1528 : _1526);
                precise float _1540 = uintBitsToFloat(ssbo_1_1.data[_1512]) * sqrt(_1534);
                precise float _1541 = _1540 + uintBitsToFloat(ssbo_1_1.data[_387]);
                bool _1542 = _383 && (uintBitsToFloat(ssbo_1_1.data[_1508]) >= _1532);
                uint _1553;
                if (_1542)
                {
                    precise float _1545 = uintBitsToFloat(ssbo_1_1.data[_1508]) * uintBitsToFloat(ssbo_1_1.data[_1508]);
                    precise float _1547 = _1532 * (-_1532);
                    precise float _1548 = _1547 + _1545;
                    precise float _1551 = uintBitsToFloat(ssbo_1_1.data[_1508]) - sqrt(_1548);
                    _1553 = floatBitsToUint(_1551);
                }
                else
                {
                    _1553 = floatBitsToUint(_1532);
                }
                uint _1568;
                if (_383 && (!_1542))
                {
                    precise float _1557 = 1.0 - uintBitsToFloat(ssbo_1_1.data[_1508]);
                    precise float _1558 = _1557 * _1557;
                    precise float _1560 = (-1.0) + uintBitsToFloat(_1553);
                    precise float _1562 = _1560 * (-_1560);
                    precise float _1563 = _1562 + _1558;
                    precise float _1566 = uintBitsToFloat(ssbo_1_1.data[_1508]) + sqrt(_1563);
                    _1568 = floatBitsToUint(_1566);
                }
                else
                {
                    _1568 = _1553;
                }
                precise float _1581 = uintBitsToFloat(ssbo_1_1.data[_1512]) * uintBitsToFloat(_1568);
                precise float _1582 = _1581 + uintBitsToFloat(ssbo_1_1.data[_387]);
                vec4 _1587 = textureLod(SPIRV_Cross_Combinedcs_img120cs_sampsgpr_160, vec2(_1541, _1582), 0.0);
                vec4 _1596 = textureLod(SPIRV_Cross_Combinedcs_img128cs_sampsgpr_160, vec2(_1541, _1582), 0.0);
                _1601 = floatBitsToUint(_1596.y);
                _1602 = floatBitsToUint(_1587.y);
                _1603 = floatBitsToUint(_1587.x);
                _1604 = floatBitsToUint(_1596.x);
                _1605 = srt_flatbuf_1.data[125u];
                _1606 = srt_flatbuf_1.data[124u];
                _1607 = 1086918619u;
            }
            else
            {
                _1601 = _1499;
                _1602 = _1501;
                _1603 = _1500;
                _1604 = _1502;
                _1605 = ssbo_1_1.data[201u + buf0_dword_off];
                _1606 = ssbo_1_1.data[200u + buf0_dword_off];
                _1607 = ssbo_1_1.data[204u + buf0_dword_off];
            }
            uint _2052;
            uint _2053;
            uint _2054;
            uint _2055;
            uint _2056;
            uint _2057;
            if (!_1516)
            {
                precise float _1645 = uintBitsToFloat(ssbo_1_1.data[216u + buf0_dword_off]) * _1471;
                precise float _1647 = uintBitsToFloat(ssbo_1_1.data[217u + buf0_dword_off]) * _1476;
                precise float _1648 = _1647 + _1645;
                precise float _1650 = uintBitsToFloat(ssbo_1_1.data[218u + buf0_dword_off]) * _1474;
                precise float _1651 = _1650 + _1648;
                precise float _1655 = uintBitsToFloat(ssbo_1_1.data[212u + buf0_dword_off]) * _1471;
                precise float _1657 = uintBitsToFloat(ssbo_1_1.data[213u + buf0_dword_off]) * _1476;
                precise float _1658 = _1657 + _1655;
                precise float _1660 = uintBitsToFloat(ssbo_1_1.data[214u + buf0_dword_off]) * _1474;
                precise float _1661 = _1660 + _1658;
                precise float _1664 = 1.0 + (-abs(_1661));
                precise float _1665 = _1664 * _1664;
                precise float _1666 = _1664 * _1665;
                precise float _1667 = (-0.000988719053566455841064453125) * _1665;
                precise float _1671 = _1666 * (-0.0003834455274045467376708984375);
                precise float _1672 = _1671 + _1667;
                precise float _1673 = _1665 * _1665;
                precise float _1674 = _1665 * (-0.026516504585742950439453125);
                precise float _1675 = _1674 + fma(-abs(_1661), -0.117851130664348602294921875, -0.117851130664348602294921875);
                precise float _1676 = _1673 * (-0.00015429117775056511163711547851562);
                precise float _1677 = _1676 + _1672;
                precise float _1678 = _1673 * (-0.00268540973775088787078857421875);
                precise float _1679 = _1678 + _1675;
                precise float _1680 = (-0.00789181701838970184326171875) + _1677;
                precise float _1681 = (-1.41421353816986083984375) + _1679;
                float _1682 = sqrt(_1664);
                precise float _1683 = _1680 * _1666;
                precise float _1684 = _1683 + _1681;
                precise float _1685 = _1682 * _1684;
                precise float _1689 = 0.3183098733425140380859375 * uintBitsToFloat(_1428);
                float _1692 = (0.0 >= _1661) ? fma(_1682, _1684, 3.1415927410125732421875) : (-_1685);
                precise float _1695 = uintBitsToFloat(ssbo_1_1.data[220u + buf0_dword_off]) * _1471;
                precise float _1697 = uintBitsToFloat(ssbo_1_1.data[221u + buf0_dword_off]) * _1476;
                precise float _1698 = _1697 + _1695;
                precise float _1700 = uintBitsToFloat(ssbo_1_1.data[222u + buf0_dword_off]) * _1474;
                precise float _1701 = _1700 + _1698;
                precise float _1709 = (1.0 / max(abs(_1701), abs(_1651))) * min(abs(_1701), abs(_1651));
                precise float _1710 = _1709 * _1709;
                precise float _1714 = fma(fma(fma(fma(0.02083499915897846221923828125, _1710, -0.08513300120830535888671875), _1710, 0.1801410019397735595703125), _1710, -0.3302989900112152099609375), _1710, 0.999866008758544921875);
                precise float _1715 = _1709 * _1714;
                precise float _1721 = ((abs(_1651) < abs(_1701)) ? fma(-2.0, _1715, 1.57079637050628662109375) : 0.0) + ((0.0 > _1651) ? (-3.1415927410125732421875) : 0.0);
                float _1722 = min(_1651, _1701);
                float _1723 = max(_1651, _1701);
                precise float _1728 = _1714 * _1709;
                precise float _1729 = _1728 + _1721;
                precise float _1731 = (-_1689) * _1689;
                precise float _1737 = 4.7123889923095703125 + uintBitsToFloat(_1604);
                precise float _1739 = trunc(fma(uintBitsToFloat(_1604), 0.15915493667125701904296875, 0.75)) * (-6.283185482025146484375);
                precise float _1740 = _1739 + _1737;
                float _1742 = ((_1722 < (-_1722)) && (_1723 >= (-_1723))) ? (-_1729) : _1729;
                precise float _1750 = uintBitsToFloat(_1606) * sin(6.283185482025146484375 * fract(fma(-_1742, 0.15915493667125701904296875, 0.25)));
                float _1756 = (abs(_1750) < 1.0) ? abs(_1750) : (1.0 / abs(_1750));
                precise float _1757 = _1756 * _1756;
                precise float _1762 = _1756 * _1757;
                bool _1765 = uintBitsToFloat(_1607) <= uintBitsToFloat(_1605);
                precise float _1766 = fma(0.087292902171611785888671875, _1757, -0.3018949925899505615234375) * _1762;
                precise float _1767 = _1766 + _1756;
                precise float _1769 = 0.3183098733425140380859375 * (-_1740);
                precise float _1770 = _1769 + 2.0;
                precise float _1771 = 0.3183098733425140380859375 * _1740;
                precise float _1774 = 0.3183098733425140380859375 * uintBitsToFloat(_1607);
                float _1775 = min(0.5, _1774);
                precise float _1777 = 1.57079637050628662109375 - _1767;
                precise float _1778 = 0.3183098733425140380859375 * _1742;
                uint _1779 = floatBitsToUint(_1778);
                float _1780 = sqrt((3.1415927410125732421875 < _1740) ? _1770 : _1771);
                precise float _1783 = 0.3183098733425140380859375 * uintBitsToFloat(_1428);
                precise float _1784 = _1783 + (-1.0);
                precise float _1788 = (-_1784) * _1784;
                uint _1893;
                uint _1894;
                if (_1765)
                {
                    precise float _1792 = uintBitsToFloat(_1607) - uintBitsToFloat(_1605);
                    float _1797 = max(min(0.034906588494777679443359375, _1792), min(max(0.034906588494777679443359375, _1792), 0.0));
                    float _1800 = (abs(_1750) < 1.0) ? _1767 : _1777;
                    precise float _1804 = 1.57079637050628662109375 - ((0.0 > _1750) ? (-_1800) : _1800);
                    precise float _1808 = 28.6478862762451171875 * (-_1797);
                    precise float _1809 = _1808 + 1.0;
                    precise float _1811 = _1804 * _1809;
                    precise float _1813 = _1797 * 44.999996185302734375;
                    precise float _1814 = _1813 + _1811;
                    bool _1816 = _383 && (_1692 <= _1814);
                    uint _1825;
                    uint _1826;
                    if (_1816)
                    {
                        precise float _1817 = 2.0 * _1811;
                        precise float _1819 = _1797 * 89.99999237060546875;
                        precise float _1820 = _1819 + _1817;
                        float _1821 = 1.0 / _1820;
                        precise float _1823 = _1821 * _1692;
                        _1825 = floatBitsToUint(_1823);
                        _1826 = floatBitsToUint(_1821);
                    }
                    else
                    {
                        _1825 = floatBitsToUint(_1804);
                        _1826 = floatBitsToUint(_1809);
                    }
                    uint _1843;
                    if (_383 && (!_1816))
                    {
                        precise float _1831 = 89.99999237060546875 * _1797;
                        precise float _1835 = fma(-2.0, uintBitsToFloat(_1825), 6.283185482025146484375) * uintBitsToFloat(_1826);
                        precise float _1836 = _1835 + _1831;
                        precise float _1839 = uintBitsToFloat(_1826) * fma(-2.0, uintBitsToFloat(_1825), 3.1415927410125732421875);
                        precise float _1840 = _1839 + _1692;
                        precise float _1841 = (1.0 / _1836) * _1840;
                        _1843 = floatBitsToUint(_1841);
                    }
                    else
                    {
                        _1843 = _1825;
                    }
                    uint _1851 = floatBitsToUint(sqrt(uintBitsToFloat(_1843)));
                    uint _1892;
                    if (_383 && _1765)
                    {
                        bool _1853 = _383 && (0.25 >= uintBitsToFloat(_1843));
                        uint _1862;
                        if (_1853)
                        {
                            precise float _1856 = (-4.0) * uintBitsToFloat(_1843);
                            precise float _1857 = _1856 + 1.0;
                            precise float _1858 = 1.0 - _1857;
                            precise float _1860 = sqrt(_1858) * 0.5;
                            _1862 = floatBitsToUint(_1860);
                        }
                        else
                        {
                            _1862 = _1851;
                        }
                        bool _1864 = _383 && (!_1853);
                        uint _1891;
                        if (_1864)
                        {
                            bool _1865 = _1864 && (0.5 >= uintBitsToFloat(_1843));
                            uint _1876;
                            uint _1877;
                            if (_1865)
                            {
                                precise float _1868 = 4.0 * uintBitsToFloat(_1843);
                                precise float _1869 = _1868 + (-1.0);
                                precise float _1870 = 1.0 - _1869;
                                _1876 = floatBitsToUint(fma(-0.300000011920928955078125, sqrt(_1870), 0.800000011920928955078125));
                                _1877 = 3197737370u;
                            }
                            else
                            {
                                _1876 = _1862;
                                _1877 = _1843;
                            }
                            uint _1890;
                            if (_1864 && (!_1865))
                            {
                                precise float _1881 = 2.0 * uintBitsToFloat(_1877);
                                precise float _1882 = _1881 + (-2.0);
                                precise float _1884 = (-_1882) * _1882;
                                precise float _1885 = _1884 + 1.0;
                                _1890 = floatBitsToUint(fma(0.199999988079071044921875, sqrt(_1885), 0.800000011920928955078125));
                            }
                            else
                            {
                                _1890 = _1876;
                            }
                            _1891 = _1890;
                        }
                        else
                        {
                            _1891 = _1862;
                        }
                        _1892 = _1891;
                    }
                    else
                    {
                        _1892 = _1851;
                    }
                    _1893 = _1892;
                    _1894 = floatBitsToUint(_1778);
                }
                else
                {
                    _1893 = floatBitsToUint(_1784);
                    _1894 = floatBitsToUint(_1775);
                }
                uint _1920;
                uint _1921;
                if (!_1765)
                {
                    bool _1895 = _383 && (_1689 <= _1775);
                    uint _1905;
                    uint _1906;
                    if (_1895)
                    {
                        precise float _1898 = uintBitsToFloat(_1894) * uintBitsToFloat(_1894);
                        precise float _1899 = _1898 + _1731;
                        precise float _1902 = uintBitsToFloat(_1894) - sqrt(_1899);
                        _1905 = floatBitsToUint(_1902);
                        _1906 = floatBitsToUint(_1780);
                    }
                    else
                    {
                        _1905 = _1893;
                        _1906 = _1894;
                    }
                    uint _1918;
                    uint _1919;
                    if (_383 && (!_1895))
                    {
                        precise float _1910 = 1.0 - uintBitsToFloat(_1906);
                        precise float _1911 = _1910 * _1910;
                        precise float _1912 = _1911 + _1788;
                        precise float _1915 = sqrt(_1912) + uintBitsToFloat(_1906);
                        _1918 = floatBitsToUint(_1915);
                        _1919 = floatBitsToUint(_1780);
                    }
                    else
                    {
                        _1918 = _1905;
                        _1919 = _1906;
                    }
                    _1920 = _1918;
                    _1921 = _1919;
                }
                else
                {
                    _1920 = _1893;
                    _1921 = _1894;
                }
                precise float _1923 = 0.3183098733425140380859375 * uintBitsToFloat(ssbo_1_1.data[_1442]);
                bool _1926 = uintBitsToFloat(ssbo_1_1.data[_1442]) <= uintBitsToFloat(_1605);
                float _1927 = min(0.5, _1923);
                uint _2025;
                uint _2026;
                uint _2027;
                bool _2028;
                if (_1926)
                {
                    float _1932 = (abs(_1750) < 1.0) ? _1767 : _1777;
                    precise float _1936 = uintBitsToFloat(ssbo_1_1.data[_1442]) - uintBitsToFloat(_1605);
                    precise float _1939 = 1.57079637050628662109375 - ((0.0 > _1750) ? (-_1932) : _1932);
                    float _1944 = max(min(0.034906588494777679443359375, _1936), min(max(0.034906588494777679443359375, _1936), 0.0));
                    precise float _1946 = 28.6478862762451171875 * (-_1944);
                    precise float _1947 = _1946 + 1.0;
                    precise float _1949 = _1939 * _1947;
                    precise float _1950 = _1944 * 44.999996185302734375;
                    precise float _1951 = _1950 + _1949;
                    bool _1953 = _383 && (_1692 <= _1951);
                    uint _1960;
                    if (_1953)
                    {
                        precise float _1954 = 2.0 * _1949;
                        precise float _1955 = _1944 * 89.99999237060546875;
                        precise float _1956 = _1955 + _1954;
                        precise float _1958 = (1.0 / _1956) * _1692;
                        _1960 = floatBitsToUint(_1958);
                    }
                    else
                    {
                        _1960 = floatBitsToUint(_1947);
                    }
                    uint _1976;
                    uint _1977;
                    if (_383 && (!_1953))
                    {
                        precise float _1964 = 89.99999237060546875 * _1944;
                        precise float _1965 = fma(-2.0, _1939, 3.1415927410125732421875);
                        precise float _1968 = fma(-2.0, _1939, 6.283185482025146484375) * uintBitsToFloat(_1960);
                        precise float _1969 = _1968 + _1964;
                        precise float _1972 = _1965 * uintBitsToFloat(_1960);
                        precise float _1973 = _1972 + _1692;
                        precise float _1974 = (1.0 / _1969) * _1973;
                        _1976 = floatBitsToUint(_1965);
                        _1977 = floatBitsToUint(_1974);
                    }
                    else
                    {
                        _1976 = floatBitsToUint(_1939);
                        _1977 = _1960;
                    }
                    bool _1980 = 0.25 >= uintBitsToFloat(_1977);
                    uint _1985 = floatBitsToUint(sqrt(uintBitsToFloat(_1977)));
                    uint _2022;
                    uint _2023;
                    bool _2024;
                    if (_383 && _1926)
                    {
                        bool _1986 = _383 && _1980;
                        uint _1994;
                        if (_1986)
                        {
                            precise float _1988 = (-4.0) * uintBitsToFloat(_1977);
                            precise float _1989 = _1988 + 1.0;
                            precise float _1990 = 1.0 - _1989;
                            precise float _1992 = sqrt(_1990) * 0.5;
                            _1994 = floatBitsToUint(_1992);
                        }
                        else
                        {
                            _1994 = _1985;
                        }
                        bool _1996 = _383 && (!_1986);
                        uint _2020;
                        uint _2021;
                        if (_1996)
                        {
                            bool _1997 = _1996 && (0.5 >= uintBitsToFloat(_1977));
                            uint _2005;
                            uint _2006;
                            if (_1997)
                            {
                                precise float _1999 = 4.0 * uintBitsToFloat(_1977);
                                precise float _2000 = _1999 + (-1.0);
                                precise float _2001 = 1.0 - _2000;
                                _2005 = floatBitsToUint(fma(-0.300000011920928955078125, sqrt(_2001), 0.800000011920928955078125));
                                _2006 = 3197737370u;
                            }
                            else
                            {
                                _2005 = _1994;
                                _2006 = _1977;
                            }
                            uint _2018;
                            uint _2019;
                            if (_1996 && (!_1997))
                            {
                                precise float _2010 = 2.0 * uintBitsToFloat(_2006);
                                precise float _2011 = _2010 + (-2.0);
                                precise float _2013 = (-_2011) * _2011;
                                precise float _2014 = _2013 + 1.0;
                                _2018 = 1045220556u;
                                _2019 = floatBitsToUint(fma(0.199999988079071044921875, sqrt(_2014), 0.800000011920928955078125));
                            }
                            else
                            {
                                _2018 = _2006;
                                _2019 = _2005;
                            }
                            _2020 = _2018;
                            _2021 = _2019;
                        }
                        else
                        {
                            _2020 = _1977;
                            _2021 = _1994;
                        }
                        _2022 = _2020;
                        _2023 = _2021;
                        _2024 = _383;
                    }
                    else
                    {
                        _2022 = _1977;
                        _2023 = _1985;
                        _2024 = _1980;
                    }
                    _2025 = _2022;
                    _2026 = _2023;
                    _2027 = _1976;
                    _2028 = _2024;
                }
                else
                {
                    _2025 = floatBitsToUint(_1689);
                    _2026 = floatBitsToUint(_1692);
                    _2027 = floatBitsToUint(_1731);
                    _2028 = _1689 <= _1927;
                }
                uint _2050;
                uint _2051;
                if (!_1926)
                {
                    bool _2029 = _383 && _2028;
                    uint _2037;
                    uint _2038;
                    if (_2029)
                    {
                        precise float _2031 = _1927 * _1927;
                        precise float _2032 = _2031 + uintBitsToFloat(_2027);
                        precise float _2034 = _1927 - sqrt(_2032);
                        _2037 = floatBitsToUint(_2034);
                        _2038 = floatBitsToUint(_1780);
                    }
                    else
                    {
                        _2037 = _2026;
                        _2038 = _1779;
                    }
                    uint _2048;
                    uint _2049;
                    if (_383 && (!_2029))
                    {
                        precise float _2041 = 1.0 - _1927;
                        precise float _2042 = _2041 * _2041;
                        precise float _2043 = _2042 + _1788;
                        precise float _2045 = sqrt(_2043) + _1927;
                        _2048 = floatBitsToUint(_2045);
                        _2049 = floatBitsToUint(_1780);
                    }
                    else
                    {
                        _2048 = _2037;
                        _2049 = _2038;
                    }
                    _2050 = _2048;
                    _2051 = _2049;
                }
                else
                {
                    _2050 = _2026;
                    _2051 = _1779;
                }
                _2052 = floatBitsToUint(_1780);
                _2053 = _2025;
                _2054 = _2050;
                _2055 = _2051;
                _2056 = _1920;
                _2057 = _1921;
            }
            else
            {
                _2052 = _1373;
                _2053 = _1378;
                _2054 = _1601;
                _2055 = _1604;
                _2056 = _1602;
                _2057 = _1603;
            }
            uint _2083;
            uint _2084;
            uint _2085;
            uint _2086;
            if (!(uintBitsToFloat(ssbo_1_1.data[_1438]) <= 0.0))
            {
                vec4 _2069 = textureLod(SPIRV_Cross_Combinedcs_img112cs_sampsgpr_164, vec3(uintBitsToFloat(_2057), uintBitsToFloat(_2056), roundEven(uintBitsToFloat(ssbo_1_1.data[205u + buf0_dword_off]))), 0.0);
                float _2072 = _2069.z;
                precise float _2075 = uintBitsToFloat(ssbo_1_1.data[_1438]) * _2069.x;
                precise float _2078 = uintBitsToFloat(ssbo_1_1.data[_1438]) * _2069.y;
                precise float _2081 = uintBitsToFloat(ssbo_1_1.data[_1438]) * _2072;
                _2083 = floatBitsToUint(_2072);
                _2084 = floatBitsToUint(_2075);
                _2085 = floatBitsToUint(_2078);
                _2086 = floatBitsToUint(_2081);
            }
            else
            {
                _2083 = _2053;
                _2084 = 0u;
                _2085 = 0u;
                _2086 = 0u;
            }
            uint _2116;
            uint _2117;
            uint _2118;
            if (!(_383 && _1460))
            {
                vec4 _2097 = textureLod(SPIRV_Cross_Combinedcs_img112cs_sampsgpr_164, vec3(uintBitsToFloat(_2055), uintBitsToFloat(_2054), roundEven(uintBitsToFloat(ssbo_1_1.data[209u + buf0_dword_off]))), 0.0);
                precise float _2103 = uintBitsToFloat(ssbo_1_1.data[_1450]) * _2097.z;
                precise float _2104 = _2103 + uintBitsToFloat(_2086);
                precise float _2108 = uintBitsToFloat(ssbo_1_1.data[_1450]) * _2097.y;
                precise float _2109 = _2108 + uintBitsToFloat(_2085);
                precise float _2113 = uintBitsToFloat(ssbo_1_1.data[_1450]) * _2097.x;
                precise float _2114 = _2113 + uintBitsToFloat(_2084);
                _2116 = floatBitsToUint(_2114);
                _2117 = floatBitsToUint(_2109);
                _2118 = floatBitsToUint(_2104);
            }
            else
            {
                _2116 = _2084;
                _2117 = _2085;
                _2118 = _2086;
            }
            _2119 = _2052;
            _2120 = _2083;
            _2121 = _2116;
            _2122 = _2117;
            _2123 = _2118;
        }
        else
        {
            _2119 = _1373;
            _2120 = _1378;
            _2121 = 0u;
            _2122 = 0u;
            _2123 = 0u;
        }
        uint _2125 = 224u + buf0_dword_off;
        uint _2789;
        uint _2790;
        uint _2791;
        uint _2792;
        uint _2793;
        uint _2794;
        uint _2795;
        uint _2796;
        if (0.0 != uintBitsToFloat(ssbo_1_1.data[_2125]))
        {
            bool _2134 = _383 && (1.0 != uintBitsToFloat(ssbo_1_1.data[_2125]));
            uint _2203;
            uint _2204;
            uint _2205;
            if (_2134)
            {
                uint _2200;
                uint _2201;
                uint _2202;
                if (!(_383 && (2.0 != uintBitsToFloat(ssbo_1_1.data[_2125]))))
                {
                    precise float _2138 = _1471 * 2.0;
                    precise float _2139 = _1476 * 2.0;
                    precise float _2140 = _1474 * 2.0;
                    float _2141 = abs(_1471);
                    float _2142 = abs(_1476);
                    float _2143 = abs(_1474);
                    float _2151 = 1.0 / abs(((_2143 >= _2141) && (_2143 >= _2142)) ? _2140 : ((_2142 >= _2141) ? _2139 : _2138));
                    float _2158 = abs(_1471);
                    float _2159 = abs(_1476);
                    float _2160 = abs(_1474);
                    float _2168 = -_1476;
                    float _2171 = abs(_1471);
                    float _2172 = abs(_1476);
                    float _2173 = abs(_1474);
                    vec4 _2187 = textureLod(SPIRV_Cross_Combinedcs_img136cs_sampsgpr_168, vec2(fma(((_2160 >= _2158) && (_2160 >= _2159)) ? ((_1474 < 0.0) ? (-_1471) : _1471) : ((_2159 >= _2158) ? _1471 : ((_1471 < 0.0) ? _1474 : (-_1474))), _2151, 1.5), fma(((_2173 >= _2171) && (_2173 >= _2172)) ? _2168 : ((_2172 >= _2171) ? ((_1476 < 0.0) ? (-_1474) : _1474) : _2168), _2151, 1.5)), 0.0);
                    precise float _2192 = _2187.z + uintBitsToFloat(_2123);
                    precise float _2195 = _2187.y + uintBitsToFloat(_2122);
                    precise float _2198 = _2187.x + uintBitsToFloat(_2121);
                    _2200 = floatBitsToUint(_2198);
                    _2201 = floatBitsToUint(_2195);
                    _2202 = floatBitsToUint(_2192);
                }
                else
                {
                    _2200 = _2121;
                    _2201 = _2122;
                    _2202 = _2123;
                }
                _2203 = _2200;
                _2204 = _2201;
                _2205 = _2202;
            }
            else
            {
                _2203 = _2121;
                _2204 = _2122;
                _2205 = _2123;
            }
            uint _2781;
            uint _2782;
            uint _2783;
            uint _2784;
            uint _2785;
            uint _2786;
            uint _2787;
            uint _2788;
            if (!_2134)
            {
                uint _2207 = 232u + buf0_dword_off;
                uint _2215 = 234u + buf0_dword_off;
                uint _2219 = 236u + buf0_dword_off;
                uint _2227 = 238u + buf0_dword_off;
                bool _2231 = uintBitsToFloat(ssbo_1_1.data[_2227]) <= 0.0;
                uint _2773;
                uint _2774;
                uint _2775;
                uint _2776;
                uint _2777;
                uint _2778;
                uint _2779;
                uint _2780;
                if (!((uintBitsToFloat(ssbo_1_1.data[_2215]) <= 0.0) && _2231))
                {
                    uint _2241 = 229u + buf0_dword_off;
                    precise float _2249 = uintBitsToFloat(ssbo_1_1.data[230u + buf0_dword_off]) + _585;
                    float _2251 = fract(fma(_2249, 0.15915493667125701904296875, 0.25));
                    precise float _2290 = _1464 * cos(6.283185482025146484375 * _2251);
                    precise float _2294 = uintBitsToFloat(ssbo_1_1.data[248u + buf0_dword_off]) * _2290;
                    precise float _2295 = _1464 * sin(6.283185482025146484375 * _2251);
                    precise float _2297 = uintBitsToFloat(ssbo_1_1.data[244u + buf0_dword_off]) * _2290;
                    precise float _2299 = uintBitsToFloat(ssbo_1_1.data[249u + buf0_dword_off]) * _1476;
                    precise float _2300 = _2299 + _2294;
                    precise float _2302 = uintBitsToFloat(ssbo_1_1.data[245u + buf0_dword_off]) * _1476;
                    precise float _2303 = _2302 + _2297;
                    precise float _2305 = uintBitsToFloat(ssbo_1_1.data[250u + buf0_dword_off]) * _2295;
                    precise float _2306 = _2305 + _2300;
                    precise float _2308 = uintBitsToFloat(ssbo_1_1.data[246u + buf0_dword_off]) * _2295;
                    precise float _2309 = _2308 + _2303;
                    precise float _2315 = uintBitsToFloat(ssbo_1_1.data[240u + buf0_dword_off]) * _2290;
                    precise float _2317 = _1476 * uintBitsToFloat(ssbo_1_1.data[241u + buf0_dword_off]);
                    precise float _2318 = _2317 + _2315;
                    precise float _2322 = (1.0 / max(abs(_2306), abs(_2309))) * min(abs(_2306), abs(_2309));
                    precise float _2323 = _2322 * _2322;
                    precise float _2327 = fma(fma(fma(fma(0.02083499915897846221923828125, _2323, -0.08513300120830535888671875), _2323, 0.1801410019397735595703125), _2323, -0.3302989900112152099609375), _2323, 0.999866008758544921875);
                    precise float _2328 = _2322 * _2327;
                    precise float _2331 = uintBitsToFloat(ssbo_1_1.data[242u + buf0_dword_off]) * _2295;
                    precise float _2332 = _2331 + _2318;
                    precise float _2333 = 1.57079637050628662109375 + _2249;
                    precise float _2340 = ((abs(_2309) < abs(_2306)) ? fma(-2.0, _2328, 1.57079637050628662109375) : 0.0) + ((0.0 > _2309) ? (-3.1415927410125732421875) : 0.0);
                    precise float _2341 = _2327 * _2322;
                    precise float _2342 = _2341 + _2340;
                    float _2343 = min(_2309, _2306);
                    float _2344 = max(_2309, _2306);
                    precise float _2355 = 1.0 + (-abs(_2332));
                    precise float _2358 = 4.7123889923095703125 + _2333;
                    precise float _2359 = _2355 * _2355;
                    precise float _2360 = trunc(fma(_2333, 0.15915493667125701904296875, 0.75)) * (-6.283185482025146484375);
                    precise float _2361 = _2360 + _2358;
                    precise float _2362 = 0.3183098733425140380859375 * _2361;
                    precise float _2363 = _2359 * (-0.026516504585742950439453125);
                    precise float _2364 = _2363 + fma(-abs(_2332), -0.117851130664348602294921875, -0.117851130664348602294921875);
                    float _2366 = ((_2343 < (-_2343)) && (_2344 >= (-_2344))) ? (-_2342) : _2342;
                    precise float _2369 = 0.3183098733425140380859375 * _2366;
                    uint _2370 = floatBitsToUint(_2369);
                    precise float _2375 = uintBitsToFloat(ssbo_1_1.data[228u + buf0_dword_off]) * sin(6.283185482025146484375 * fract(fma(-_2366, 0.15915493667125701904296875, 0.25)));
                    uint _2376 = floatBitsToUint(_2375);
                    float _2382 = (abs(_2375) < 1.0) ? abs(_2375) : (1.0 / abs(_2375));
                    precise float _2383 = _2382 * _2382;
                    precise float _2384 = _2382 * _2383;
                    precise float _2386 = _2359 * _2359;
                    precise float _2388 = (-0.000988719053566455841064453125) * _2359;
                    precise float _2389 = fma(0.087292902171611785888671875, _2383, -0.3018949925899505615234375) * _2384;
                    precise float _2390 = _2389 + _2382;
                    precise float _2391 = _2355 * _2359;
                    precise float _2392 = _2391 * (-0.0003834455274045467376708984375);
                    precise float _2393 = _2392 + _2388;
                    precise float _2394 = _2386 * (-0.00268540973775088787078857421875);
                    precise float _2395 = _2394 + _2364;
                    precise float _2396 = _2386 * (-0.00015429117775056511163711547851562);
                    precise float _2397 = _2396 + _2393;
                    precise float _2398 = (-0.00789181701838970184326171875) + _2397;
                    precise float _2399 = (-1.41421353816986083984375) + _2395;
                    float _2400 = sqrt(_2355);
                    precise float _2401 = _2398 * _2391;
                    precise float _2402 = _2401 + _2399;
                    precise float _2404 = _2400 * _2402;
                    precise float _2405 = 1.57079637050628662109375 - _2390;
                    float _2407 = (0.0 >= _2332) ? fma(_2400, _2402, 3.1415927410125732421875) : (-_2404);
                    uint _2408 = floatBitsToUint(_2407);
                    precise float _2411 = 0.3183098733425140380859375 * (-_2361);
                    precise float _2412 = _2411 + 2.0;
                    float _2417 = sqrt((3.1415927410125732421875 < _2361) ? _2412 : _2362);
                    precise float _2419 = 0.3183098733425140380859375 * uintBitsToFloat(_1428);
                    precise float _2420 = _2419 + (-1.0);
                    precise float _2422 = 0.3183098733425140380859375 * uintBitsToFloat(_1428);
                    uint _2423 = floatBitsToUint(_2422);
                    precise float _2425 = (-_2420) * _2420;
                    uint _2426 = floatBitsToUint(_2425);
                    precise float _2428 = 0.3183098733425140380859375 * uintBitsToFloat(ssbo_1_1.data[_2207]);
                    float _2429 = min(0.5, _2428);
                    precise float _2433 = (-_2422) * _2422;
                    bool _2436 = uintBitsToFloat(ssbo_1_1.data[_2207]) <= uintBitsToFloat(ssbo_1_1.data[_2241]);
                    uint _2590;
                    uint _2591;
                    uint _2592;
                    if (!(uintBitsToFloat(ssbo_1_1.data[_2215]) <= 0.0))
                    {
                        bool _2438 = _383 && _2436;
                        uint _2533;
                        uint _2534;
                        bool _2535;
                        if (_2438)
                        {
                            float _2442 = (abs(_2375) < 1.0) ? _2390 : _2405;
                            precise float _2446 = uintBitsToFloat(ssbo_1_1.data[_2207]) - uintBitsToFloat(ssbo_1_1.data[_2241]);
                            precise float _2449 = 1.57079637050628662109375 - ((0.0 > _2375) ? (-_2442) : _2442);
                            float _2454 = max(min(0.034906588494777679443359375, _2446), min(max(0.034906588494777679443359375, _2446), 0.0));
                            precise float _2457 = 28.6478862762451171875 * (-_2454);
                            precise float _2458 = _2457 + 1.0;
                            precise float _2459 = _2449 * _2458;
                            precise float _2460 = _2454 * 44.999996185302734375;
                            precise float _2461 = _2460 + _2459;
                            bool _2463 = _383 && (_2407 <= _2461);
                            uint _2471;
                            uint _2472;
                            if (_2463)
                            {
                                precise float _2464 = 2.0 * _2459;
                                precise float _2465 = _2454 * 89.99999237060546875;
                                precise float _2466 = _2465 + _2464;
                                float _2467 = 1.0 / _2466;
                                precise float _2469 = _2467 * _2407;
                                _2471 = floatBitsToUint(_2469);
                                _2472 = floatBitsToUint(_2467);
                            }
                            else
                            {
                                _2471 = floatBitsToUint(_2454);
                                _2472 = floatBitsToUint(_2449);
                            }
                            uint _2488;
                            if (_383 && (!_2463))
                            {
                                precise float _2478 = 89.99999237060546875 * uintBitsToFloat(_2471);
                                precise float _2481 = fma(-2.0, uintBitsToFloat(_2472), 6.283185482025146484375) * _2458;
                                precise float _2482 = _2481 + _2478;
                                precise float _2483 = _2458 * fma(-2.0, uintBitsToFloat(_2472), 3.1415927410125732421875);
                                precise float _2484 = _2483 + _2407;
                                precise float _2486 = (1.0 / _2482) * _2484;
                                _2488 = floatBitsToUint(_2486);
                            }
                            else
                            {
                                _2488 = _2471;
                            }
                            bool _2493 = 0.5 >= uintBitsToFloat(_2488);
                            uint _2496 = floatBitsToUint(sqrt(uintBitsToFloat(_2488)));
                            uint _2532;
                            if (_383 && _2436)
                            {
                                bool _2498 = _383 && (0.25 >= uintBitsToFloat(_2488));
                                uint _2506;
                                if (_2498)
                                {
                                    precise float _2500 = (-4.0) * uintBitsToFloat(_2488);
                                    precise float _2501 = _2500 + 1.0;
                                    precise float _2502 = 1.0 - _2501;
                                    precise float _2504 = sqrt(_2502) * 0.5;
                                    _2506 = floatBitsToUint(_2504);
                                }
                                else
                                {
                                    _2506 = _2496;
                                }
                                bool _2508 = _383 && (!_2498);
                                uint _2531;
                                if (_2508)
                                {
                                    bool _2509 = _2508 && _2493;
                                    uint _2517;
                                    uint _2518;
                                    if (_2509)
                                    {
                                        precise float _2511 = 4.0 * uintBitsToFloat(_2488);
                                        precise float _2512 = _2511 + (-1.0);
                                        precise float _2513 = 1.0 - _2512;
                                        _2517 = floatBitsToUint(fma(-0.300000011920928955078125, sqrt(_2513), 0.800000011920928955078125));
                                        _2518 = 3197737370u;
                                    }
                                    else
                                    {
                                        _2517 = _2506;
                                        _2518 = _2488;
                                    }
                                    uint _2530;
                                    if (_2508 && (!_2509))
                                    {
                                        precise float _2522 = 2.0 * uintBitsToFloat(_2518);
                                        precise float _2523 = _2522 + (-2.0);
                                        precise float _2525 = (-_2523) * _2523;
                                        precise float _2526 = _2525 + 1.0;
                                        _2530 = floatBitsToUint(fma(0.199999988079071044921875, sqrt(_2526), 0.800000011920928955078125));
                                    }
                                    else
                                    {
                                        _2530 = _2517;
                                    }
                                    _2531 = _2530;
                                }
                                else
                                {
                                    _2531 = _2506;
                                }
                                _2532 = _2531;
                            }
                            else
                            {
                                _2532 = _2496;
                            }
                            _2533 = _2532;
                            _2534 = floatBitsToUint(_2369);
                            _2535 = _2493;
                        }
                        else
                        {
                            _2533 = floatBitsToUint(_2412);
                            _2534 = floatBitsToUint(_2429);
                            _2535 = _2422 <= _2429;
                        }
                        uint _2561;
                        uint _2562;
                        if (!_2438)
                        {
                            bool _2536 = _383 && _2535;
                            uint _2546;
                            uint _2547;
                            if (_2536)
                            {
                                precise float _2539 = uintBitsToFloat(_2534) * uintBitsToFloat(_2534);
                                precise float _2540 = _2539 + _2433;
                                precise float _2543 = uintBitsToFloat(_2534) - sqrt(_2540);
                                _2546 = floatBitsToUint(_2543);
                                _2547 = floatBitsToUint(_2417);
                            }
                            else
                            {
                                _2546 = _2533;
                                _2547 = _2534;
                            }
                            uint _2559;
                            uint _2560;
                            if (_383 && (!_2536))
                            {
                                precise float _2551 = 1.0 - uintBitsToFloat(_2547);
                                precise float _2552 = _2551 * _2551;
                                precise float _2553 = _2552 + _2425;
                                precise float _2556 = sqrt(_2553) + uintBitsToFloat(_2547);
                                _2559 = floatBitsToUint(_2556);
                                _2560 = floatBitsToUint(_2417);
                            }
                            else
                            {
                                _2559 = _2546;
                                _2560 = _2547;
                            }
                            _2561 = _2560;
                            _2562 = _2559;
                        }
                        else
                        {
                            _2561 = _2534;
                            _2562 = _2533;
                        }
                        vec4 _2571 = textureLod(SPIRV_Cross_Combinedcs_img112cs_sampsgpr_164, vec3(uintBitsToFloat(_2561), uintBitsToFloat(_2562), roundEven(uintBitsToFloat(ssbo_1_1.data[233u + buf0_dword_off]))), 0.0);
                        precise float _2577 = uintBitsToFloat(ssbo_1_1.data[_2215]) * _2571.x;
                        precise float _2578 = _2577 + uintBitsToFloat(_2203);
                        precise float _2582 = uintBitsToFloat(ssbo_1_1.data[_2215]) * _2571.y;
                        precise float _2583 = _2582 + uintBitsToFloat(_2204);
                        precise float _2587 = uintBitsToFloat(ssbo_1_1.data[_2215]) * _2571.z;
                        precise float _2588 = _2587 + uintBitsToFloat(_2205);
                        _2590 = floatBitsToUint(_2578);
                        _2591 = floatBitsToUint(_2583);
                        _2592 = floatBitsToUint(_2588);
                    }
                    else
                    {
                        _2590 = _2203;
                        _2591 = _2204;
                        _2592 = _2205;
                    }
                    precise float _2594 = 0.3183098733425140380859375 * uintBitsToFloat(ssbo_1_1.data[_2219]);
                    float _2595 = min(0.5, _2594);
                    bool _2601 = uintBitsToFloat(ssbo_1_1.data[_2219]) <= uintBitsToFloat(ssbo_1_1.data[_2241]);
                    uint _2766;
                    uint _2767;
                    uint _2768;
                    uint _2769;
                    uint _2770;
                    uint _2771;
                    uint _2772;
                    if (!(_383 && _2231))
                    {
                        bool _2603 = _383 && _2601;
                        uint _2704;
                        uint _2705;
                        uint _2706;
                        uint _2707;
                        bool _2708;
                        if (_2603)
                        {
                            float _2607 = (abs(_2375) < 1.0) ? _2390 : _2405;
                            precise float _2611 = uintBitsToFloat(ssbo_1_1.data[_2219]) - uintBitsToFloat(ssbo_1_1.data[_2241]);
                            precise float _2614 = 1.57079637050628662109375 - ((0.0 > _2375) ? (-_2607) : _2607);
                            float _2619 = max(min(0.034906588494777679443359375, _2611), min(max(0.034906588494777679443359375, _2611), 0.0));
                            precise float _2621 = 28.6478862762451171875 * (-_2619);
                            precise float _2622 = _2621 + 1.0;
                            precise float _2624 = _2614 * _2622;
                            precise float _2626 = _2619 * 44.999996185302734375;
                            precise float _2627 = _2626 + _2624;
                            bool _2630 = _383 && (_2407 <= _2627);
                            uint _2638;
                            uint _2639;
                            if (_2630)
                            {
                                precise float _2631 = 2.0 * _2624;
                                precise float _2632 = _2619 * 89.99999237060546875;
                                precise float _2633 = _2632 + _2631;
                                float _2634 = 1.0 / _2633;
                                precise float _2636 = _2634 * _2407;
                                _2638 = floatBitsToUint(_2636);
                                _2639 = floatBitsToUint(_2634);
                            }
                            else
                            {
                                _2638 = floatBitsToUint(_2614);
                                _2639 = floatBitsToUint(_2622);
                            }
                            uint _2658;
                            uint _2659;
                            uint _2660;
                            if (_383 && (!_2630))
                            {
                                precise float _2643 = fma(-2.0, uintBitsToFloat(_2638), 6.283185482025146484375);
                                precise float _2645 = 89.99999237060546875 * _2619;
                                precise float _2649 = _2643 * uintBitsToFloat(_2639);
                                precise float _2650 = _2649 + _2645;
                                precise float _2653 = fma(-2.0, uintBitsToFloat(_2638), 3.1415927410125732421875) * uintBitsToFloat(_2639);
                                precise float _2654 = _2653 + _2407;
                                precise float _2656 = (1.0 / _2650) * _2654;
                                _2658 = floatBitsToUint(_2654);
                                _2659 = floatBitsToUint(_2643);
                                _2660 = floatBitsToUint(_2656);
                            }
                            else
                            {
                                _2658 = _2408;
                                _2659 = floatBitsToUint(_2624);
                                _2660 = _2638;
                            }
                            bool _2665 = 0.5 >= uintBitsToFloat(_2660);
                            uint _2668 = floatBitsToUint(sqrt(uintBitsToFloat(_2660)));
                            uint _2703;
                            if (_383 && _2601)
                            {
                                bool _2669 = _383 && (0.25 >= uintBitsToFloat(_2660));
                                uint _2677;
                                if (_2669)
                                {
                                    precise float _2671 = (-4.0) * uintBitsToFloat(_2660);
                                    precise float _2672 = _2671 + 1.0;
                                    precise float _2673 = 1.0 - _2672;
                                    precise float _2675 = sqrt(_2673) * 0.5;
                                    _2677 = floatBitsToUint(_2675);
                                }
                                else
                                {
                                    _2677 = _2668;
                                }
                                bool _2679 = _383 && (!_2669);
                                uint _2702;
                                if (_2679)
                                {
                                    bool _2680 = _2679 && _2665;
                                    uint _2688;
                                    uint _2689;
                                    if (_2680)
                                    {
                                        precise float _2682 = 4.0 * uintBitsToFloat(_2660);
                                        precise float _2683 = _2682 + (-1.0);
                                        precise float _2684 = 1.0 - _2683;
                                        _2688 = floatBitsToUint(fma(-0.300000011920928955078125, sqrt(_2684), 0.800000011920928955078125));
                                        _2689 = 3197737370u;
                                    }
                                    else
                                    {
                                        _2688 = _2677;
                                        _2689 = _2660;
                                    }
                                    uint _2701;
                                    if (_2679 && (!_2680))
                                    {
                                        precise float _2693 = 2.0 * uintBitsToFloat(_2689);
                                        precise float _2694 = _2693 + (-2.0);
                                        precise float _2696 = (-_2694) * _2694;
                                        precise float _2697 = _2696 + 1.0;
                                        _2701 = floatBitsToUint(fma(0.199999988079071044921875, sqrt(_2697), 0.800000011920928955078125));
                                    }
                                    else
                                    {
                                        _2701 = _2688;
                                    }
                                    _2702 = _2701;
                                }
                                else
                                {
                                    _2702 = _2677;
                                }
                                _2703 = _2702;
                            }
                            else
                            {
                                _2703 = _2668;
                            }
                            _2704 = _2658;
                            _2705 = floatBitsToUint(_2627);
                            _2706 = _2659;
                            _2707 = _2703;
                            _2708 = _2665;
                        }
                        else
                        {
                            _2704 = _2408;
                            _2705 = _2423;
                            _2706 = _2376;
                            _2707 = floatBitsToUint(_2595);
                            _2708 = _2422 <= _2595;
                        }
                        uint _2736;
                        uint _2737;
                        uint _2738;
                        if (!_2603)
                        {
                            bool _2709 = _383 && _2708;
                            uint _2719;
                            uint _2720;
                            if (_2709)
                            {
                                precise float _2712 = uintBitsToFloat(_2707) * uintBitsToFloat(_2707);
                                precise float _2713 = _2712 + _2433;
                                precise float _2716 = uintBitsToFloat(_2707) - sqrt(_2713);
                                _2719 = floatBitsToUint(_2417);
                                _2720 = floatBitsToUint(_2716);
                            }
                            else
                            {
                                _2719 = _2370;
                                _2720 = _2707;
                            }
                            uint _2733;
                            uint _2734;
                            uint _2735;
                            if (_383 && (!_2709))
                            {
                                precise float _2724 = 1.0 - uintBitsToFloat(_2720);
                                precise float _2725 = _2724 * _2724;
                                precise float _2726 = _2725 + _2425;
                                precise float _2730 = sqrt(_2726) + uintBitsToFloat(_2720);
                                _2733 = floatBitsToUint(_2726);
                                _2734 = floatBitsToUint(_2730);
                                _2735 = floatBitsToUint(_2417);
                            }
                            else
                            {
                                _2733 = _2426;
                                _2734 = _2720;
                                _2735 = _2719;
                            }
                            _2736 = _2733;
                            _2737 = _2735;
                            _2738 = _2734;
                        }
                        else
                        {
                            _2736 = _2426;
                            _2737 = _2370;
                            _2738 = _2707;
                        }
                        vec4 _2747 = textureLod(SPIRV_Cross_Combinedcs_img112cs_sampsgpr_164, vec3(uintBitsToFloat(_2737), uintBitsToFloat(_2738), roundEven(uintBitsToFloat(ssbo_1_1.data[237u + buf0_dword_off]))), 0.0);
                        precise float _2753 = uintBitsToFloat(ssbo_1_1.data[_2227]) * _2747.z;
                        precise float _2754 = _2753 + uintBitsToFloat(_2592);
                        precise float _2758 = uintBitsToFloat(ssbo_1_1.data[_2227]) * _2747.y;
                        precise float _2759 = _2758 + uintBitsToFloat(_2591);
                        precise float _2763 = uintBitsToFloat(ssbo_1_1.data[_2227]) * _2747.x;
                        precise float _2764 = _2763 + uintBitsToFloat(_2590);
                        _2766 = _2736;
                        _2767 = _2704;
                        _2768 = _2705;
                        _2769 = floatBitsToUint(_2764);
                        _2770 = floatBitsToUint(_2759);
                        _2771 = floatBitsToUint(_2754);
                        _2772 = _2706;
                    }
                    else
                    {
                        _2766 = _2426;
                        _2767 = _2408;
                        _2768 = _2423;
                        _2769 = _2590;
                        _2770 = _2591;
                        _2771 = _2592;
                        _2772 = _2376;
                    }
                    _2773 = _2766;
                    _2774 = _2767;
                    _2775 = _2768;
                    _2776 = _2769;
                    _2777 = _2770;
                    _2778 = _2771;
                    _2779 = ssbo_1_1.data[_2241];
                    _2780 = _2772;
                }
                else
                {
                    _2773 = _2119;
                    _2774 = _1477;
                    _2775 = _1428;
                    _2776 = _2203;
                    _2777 = _2204;
                    _2778 = _2205;
                    _2779 = _1472;
                    _2780 = _2120;
                }
                _2781 = _2773;
                _2782 = _2774;
                _2783 = _2775;
                _2784 = _2776;
                _2785 = _2777;
                _2786 = _2778;
                _2787 = _2779;
                _2788 = _2780;
            }
            else
            {
                _2781 = _2119;
                _2782 = _1477;
                _2783 = _1428;
                _2784 = _2203;
                _2785 = _2204;
                _2786 = _2205;
                _2787 = _1472;
                _2788 = _2120;
            }
            _2789 = _2781;
            _2790 = _2782;
            _2791 = _2783;
            _2792 = _2784;
            _2793 = _2785;
            _2794 = _2786;
            _2795 = _2787;
            _2796 = _2788;
        }
        else
        {
            _2789 = _2119;
            _2790 = _1477;
            _2791 = _1428;
            _2792 = _2121;
            _2793 = _2122;
            _2794 = _2123;
            _2795 = _1472;
            _2796 = _2120;
        }
        bool _2812 = _383 && (!((9.9999997473787516355514526367188e-06 >= uintBitsToFloat(_1379)) || (uintBitsToFloat(ssbo_1_1.data[152u + buf0_dword_off]) <= 0.0)));
        uint _3561;
        uint _3562;
        uint _3563;
        uint _3564;
        uint _3565;
        uint _3566;
        uint _3567;
        uint _3568;
        uint _3569;
        if (_2812)
        {
            uint _2818 = 137u + buf0_dword_off;
            uint _2826 = 139u + buf0_dword_off;
            uint _2997;
            uint _2998;
            if (0.0 != uintBitsToFloat(ssbo_1_1.data[_2826]))
            {
                float _2831 = 1.0 / _563;
                bool _2837 = uintBitsToFloat(ssbo_1_1.data[149u + buf0_dword_off]) > 0.0;
                uint _2874;
                if (_2837)
                {
                    precise float _2840 = (-6378000.0) * _563;
                    precise float _2841 = _2840 * _2840;
                    precise float _2844 = 6378000.0 + uintBitsToFloat(ssbo_1_1.data[_2818]);
                    precise float _2846 = _2844 * _2844;
                    precise float _2847 = _2846 + _2841;
                    uint _2858;
                    uint _2859;
                    uint _2860;
                    if (_2812 && (40678885163008.0 <= _2847))
                    {
                        precise float _2852 = (-40678885163008.0) + _2847;
                        float _2853 = sqrt(_2852);
                        precise float _2854 = _2840 - _2853;
                        precise float _2856 = _2853 + _2840;
                        _2858 = 1u;
                        _2859 = floatBitsToUint(_2854);
                        _2860 = floatBitsToUint(_2856);
                    }
                    else
                    {
                        _2858 = 0u;
                        _2859 = floatBitsToUint(_2844);
                        _2860 = _2796;
                    }
                    float _2863 = min(uintBitsToFloat(_2860), uintBitsToFloat(_2859));
                    float _2866 = max(uintBitsToFloat(_2860), uintBitsToFloat(_2859));
                    _2874 = floatBitsToUint(((0u == _2858) || (0.0 > _2866)) ? 0.0 : ((0.0 > _2863) ? _2866 : _2863));
                }
                else
                {
                    _2874 = 0u;
                }
                uint _2880;
                if (!_2837)
                {
                    precise float _2877 = uintBitsToFloat(ssbo_1_1.data[_2818]) * _2831;
                    _2880 = floatBitsToUint((0.0 == _563) ? 0.0 : _2877);
                }
                else
                {
                    _2880 = _2874;
                }
                precise float _2882 = uintBitsToFloat(_2880) * _486;
                uint _2892 = 142u + buf0_dword_off;
                precise float _2904 = uintBitsToFloat(_2880) * _488;
                precise float _2907 = uintBitsToFloat(ssbo_1_1.data[140u + buf0_dword_off]) * _2882;
                precise float _2908 = _2907 + uintBitsToFloat(ssbo_1_1.data[136u + buf0_dword_off]);
                precise float _2911 = uintBitsToFloat(ssbo_1_1.data[141u + buf0_dword_off]) * _2904;
                precise float _2912 = _2911 + uintBitsToFloat(ssbo_1_1.data[138u + buf0_dword_off]);
                uint _2920 = 168u + buf0_dword_off;
                bool _2936 = 0.0 != uintBitsToFloat(ssbo_1_1.data[171u + buf0_dword_off]);
                precise float _2939 = uintBitsToFloat(ssbo_1_1.data[_2826]) * textureLod(SPIRV_Cross_Combinedcs_img88cs_sampinline_0xfff00000000000_0xa500000, vec2(_2908, _2912), 0.0).x;
                precise float _2940 = _2939 + uintBitsToFloat(ssbo_1_1.data[147u + buf0_dword_off]);
                uint _2951;
                if (_2936)
                {
                    precise float _2949 = uintBitsToFloat(ssbo_1_1.data[173u + buf0_dword_off]) * _587;
                    _2951 = floatBitsToUint(_2949);
                }
                else
                {
                    _2951 = floatBitsToUint(_2940);
                }
                uint _2960;
                if (!_2936)
                {
                    precise float _2952 = (-1.0) + _2831;
                    precise float _2958 = uintBitsToFloat(ssbo_1_1.data[172u + buf0_dword_off]) * _2952;
                    _2960 = floatBitsToUint(_2958);
                }
                else
                {
                    _2960 = _2951;
                }
                precise float _2965 = _2882 * _2882;
                precise float _2967 = uintBitsToFloat(ssbo_1_1.data[170u + buf0_dword_off]) * log2(clamp(max(0.0, uintBitsToFloat(_2960)), 0.0, 1.0));
                precise float _2968 = _2904 * _2904;
                precise float _2969 = _2968 + _2965;
                precise float _2973 = uintBitsToFloat(ssbo_1_1.data[169u + buf0_dword_off]) - uintBitsToFloat(ssbo_1_1.data[_2920]);
                precise float _2977 = uintBitsToFloat(ssbo_1_1.data[143u + buf0_dword_off]) - uintBitsToFloat(ssbo_1_1.data[_2892]);
                precise float _2979 = _2973 * exp2(_2967);
                precise float _2980 = _2979 + uintBitsToFloat(ssbo_1_1.data[_2920]);
                precise float _2983 = sqrt(_2969) - uintBitsToFloat(ssbo_1_1.data[_2892]);
                precise float _2985 = log2(max(0.0, _2940)) * _2980;
                precise float _2986 = (1.0 / _2977) * _2983;
                float _2987 = clamp(_2986, 0.0, 1.0);
                float _2988 = exp2(_2985);
                precise float _2990 = (-_2987) * _2987;
                precise float _2991 = _2988 * _2990;
                precise float _2994 = fma(-2.0, _2987, 3.0) * _2991;
                precise float _2995 = _2994 + _2988;
                _2997 = _2880;
                _2998 = floatBitsToUint(_2995);
            }
            else
            {
                _2997 = 0u;
                _2998 = 0u;
            }
            bool _3001 = _2812 && (uintBitsToFloat(_2998) > 0.0);
            uint _3553;
            uint _3554;
            uint _3555;
            uint _3556;
            uint _3557;
            uint _3558;
            uint _3559;
            uint _3560;
            if (_3001)
            {
                precise float _3003 = uintBitsToFloat(_2997) * _486;
                uint _3013 = 107u + buf0_dword_off;
                uint _3016 = 111u + buf0_dword_off;
                uint _3019 = 344u + buf0_dword_off;
                uint _3022 = 345u + buf0_dword_off;
                uint _3025 = 346u + buf0_dword_off;
                precise float _3028 = _3003 * _3003;
                precise float _3031 = uintBitsToFloat(ssbo_1_1.data[_3013]) + uintBitsToFloat(ssbo_1_1.data[106u + buf0_dword_off]);
                precise float _3033 = _563 * uintBitsToFloat(_2997);
                precise float _3034 = _3033 + _3031;
                precise float _3036 = uintBitsToFloat(ssbo_1_1.data[_3019]) * _3003;
                precise float _3038 = uintBitsToFloat(_2997) * _488;
                precise float _3039 = _3034 * _3034;
                precise float _3040 = _3039 + _3028;
                precise float _3042 = _3034 * uintBitsToFloat(ssbo_1_1.data[_3022]);
                precise float _3043 = _3042 + _3036;
                precise float _3044 = _3038 * _3038;
                precise float _3045 = _3044 + _3040;
                precise float _3048 = uintBitsToFloat(ssbo_1_1.data[_3025]) * _3038;
                precise float _3049 = _3048 + _3043;
                precise float _3050 = inversesqrt(_3045) * _3049;
                float _3054 = max(min(1.0, _3050), min(max(1.0, _3050), -1.0));
                precise float _3057 = 1.0 + (-abs(_3054));
                precise float _3058 = _3057 * _3057;
                precise float _3059 = _3057 * _3058;
                precise float _3060 = (-0.000988719053566455841064453125) * _3058;
                precise float _3064 = _3059 * (-0.0003834455274045467376708984375);
                precise float _3065 = _3064 + _3060;
                precise float _3066 = _3058 * _3058;
                precise float _3067 = _3058 * (-0.026516504585742950439453125);
                precise float _3068 = _3067 + fma(-abs(_3054), -0.117851130664348602294921875, -0.117851130664348602294921875);
                precise float _3069 = _3066 * (-0.00015429117775056511163711547851562);
                precise float _3070 = _3069 + _3065;
                precise float _3071 = _3066 * (-0.00268540973775088787078857421875);
                precise float _3072 = _3071 + _3068;
                uint _3073 = 120u + buf0_dword_off;
                uint _3076 = 121u + buf0_dword_off;
                precise float _3082 = (-0.00789181701838970184326171875) + _3070;
                precise float _3083 = (-1.41421353816986083984375) + _3072;
                float _3084 = sqrt(_3057);
                precise float _3085 = _3082 * _3059;
                precise float _3086 = _3085 + _3083;
                precise float _3088 = _3084 * _3086;
                precise float _3091 = 0.0174532942473888397216796875 * uintBitsToFloat(ssbo_1_1.data[122u + buf0_dword_off]);
                float _3093 = (0.0 >= _3050) ? fma(_3084, _3086, 3.1415927410125732421875) : (-_3088);
                precise float _3095 = uintBitsToFloat(ssbo_1_1.data[_3073]) * 0.0174532942473888397216796875;
                precise float _3096 = _3095 + _3091;
                bool _3097 = _3093 < _3091;
                bool _3098 = _3096 < _3093;
                float _3099 = float(_3097);
                precise float _3104 = sqrt(_3045) - uintBitsToFloat(ssbo_1_1.data[_3013]);
                precise float _3109 = 0.0174532942473888397216796875 * uintBitsToFloat(ssbo_1_1.data[_3073]);
                uint _3121;
                if (_3001 && (!(_3098 || _3097)))
                {
                    precise float _3111 = _3093 - _3091;
                    precise float _3113 = (1.0 / _3109) * _3111;
                    precise float _3117 = uintBitsToFloat(ssbo_1_1.data[_3076]) * log2(abs(_3113));
                    precise float _3119 = 1.0 - exp2(_3117);
                    _3121 = floatBitsToUint(_3119);
                }
                else
                {
                    _3121 = floatBitsToUint(_3099);
                }
                uint _3122 = 100u + buf0_dword_off;
                precise float _3132 = _3104 - uintBitsToFloat(ssbo_1_1.data[_3122]);
                precise float _3135 = uintBitsToFloat(ssbo_1_1.data[101u + buf0_dword_off]) - uintBitsToFloat(ssbo_1_1.data[_3122]);
                precise float _3138 = (1.0 / _3135) * max(0.0, _3132);
                float _3140 = 1.0 / uintBitsToFloat(ssbo_1_1.data[105u + buf0_dword_off]);
                float _3142 = 1.0 / uintBitsToFloat(ssbo_1_1.data[104u + buf0_dword_off]);
                precise float _3143 = 1.0 - _3140;
                precise float _3144 = 1.0 - _3142;
                precise float _3145 = _3138 * _3143;
                precise float _3148 = (1.0 / uintBitsToFloat(ssbo_1_1.data[102u + buf0_dword_off])) * _3093;
                precise float _3149 = _3148 * _3144;
                precise float _3150 = 0.5 * _3140;
                precise float _3151 = _3150 + _3145;
                precise float _3152 = 0.5 * _3142;
                precise float _3153 = _3152 + _3149;
                precise float _3155 = _3153 * _3153;
                vec4 _3160 = textureLod(SPIRV_Cross_Combinedcs_img56cs_sampsgpr_152, vec2(_3155, sqrt(_3151)), 0.0);
                float _3172 = 1.0 / uintBitsToFloat(ssbo_1_1.data[117u + buf0_dword_off]);
                precise float _3173 = 1.0 - _3172;
                precise float _3174 = _3148 * _3173;
                precise float _3175 = 0.5 * _3172;
                precise float _3176 = _3175 + _3174;
                precise float _3177 = _3176 * _3176;
                precise float _3180 = _3160.x * uintBitsToFloat(_3121);
                precise float _3182 = uintBitsToFloat(_3121) * _3160.y;
                precise float _3184 = uintBitsToFloat(_3121) * _3160.z;
                precise float _3186 = uintBitsToFloat(ssbo_1_1.data[_3016]) * _3180;
                precise float _3188 = uintBitsToFloat(ssbo_1_1.data[_3016]) * _3182;
                precise float _3191 = uintBitsToFloat(ssbo_1_1.data[_3016]) * _3184;
                uint _3203;
                if (_3001 && (!(_3098 || _3097)))
                {
                    precise float _3193 = _3093 - _3091;
                    precise float _3195 = (1.0 / _3109) * _3193;
                    precise float _3199 = uintBitsToFloat(ssbo_1_1.data[_3076]) * log2(abs(_3195));
                    precise float _3201 = 1.0 - exp2(_3199);
                    _3203 = floatBitsToUint(_3201);
                }
                else
                {
                    _3203 = floatBitsToUint(_3099);
                }
                uint _3205 = 156u + buf0_dword_off;
                precise float _3214 = uintBitsToFloat(ssbo_1_1.data[118u + buf0_dword_off]) * uintBitsToFloat(ssbo_1_1.data[_3016]);
                vec4 _3219 = textureLod(SPIRV_Cross_Combinedcs_img64cs_sampsgpr_152, vec2(_3177, 0.5), 0.0);
                bool _3233 = 0.0 != uintBitsToFloat(ssbo_1_1.data[_3205]);
                precise float _3235 = _3219.x * uintBitsToFloat(_3203);
                precise float _3238 = uintBitsToFloat(_3203) * _3219.y;
                precise float _3241 = uintBitsToFloat(_3203) * _3219.z;
                precise float _3243 = _3235 * _3214;
                precise float _3244 = _3238 * _3214;
                precise float _3245 = _3241 * _3214;
                uint _3368;
                uint _3369;
                uint _3370;
                uint _3371;
                uint _3372;
                uint _3373;
                uint _3374;
                if (_3233)
                {
                    precise float _3258 = (1.0 / max(abs(uintBitsToFloat(ssbo_1_1.data[_3025])), abs(uintBitsToFloat(ssbo_1_1.data[_3019])))) * min(abs(uintBitsToFloat(ssbo_1_1.data[_3025])), abs(uintBitsToFloat(ssbo_1_1.data[_3019])));
                    precise float _3259 = _3258 * _3258;
                    precise float _3263 = fma(_3259, fma(_3259, fma(_3259, fma(0.02083499915897846221923828125, _3259, -0.08513300120830535888671875), 0.1801410019397735595703125), -0.3302989900112152099609375), 0.999866008758544921875);
                    precise float _3264 = _3258 * _3263;
                    precise float _3275 = ((abs(uintBitsToFloat(ssbo_1_1.data[_3019])) < abs(uintBitsToFloat(ssbo_1_1.data[_3025]))) ? fma(-2.0, _3264, 1.57079637050628662109375) : 0.0) + ((uintBitsToFloat(ssbo_1_1.data[_3019]) < 0.0) ? (-3.1415927410125732421875) : 0.0);
                    precise float _3276 = _3263 * _3258;
                    precise float _3277 = _3276 + _3275;
                    float _3280 = min(uintBitsToFloat(ssbo_1_1.data[_3019]), uintBitsToFloat(ssbo_1_1.data[_3025]));
                    float _3285 = max(uintBitsToFloat(ssbo_1_1.data[_3019]), uintBitsToFloat(ssbo_1_1.data[_3025]));
                    precise float _3291 = _585 - (((_3280 < (-_3280)) && (_3285 >= (-_3285))) ? (-_3277) : _3277);
                    precise float _3292 = 1.57079637050628662109375 + _3291;
                    precise float _3315 = uintBitsToFloat(ssbo_1_1.data[_3205]) * _3292;
                    precise float _3316 = _3315 + uintBitsToFloat(ssbo_1_1.data[160u + buf0_dword_off]);
                    precise float _3319 = uintBitsToFloat(ssbo_1_1.data[157u + buf0_dword_off]) * _587;
                    precise float _3320 = _3319 + uintBitsToFloat(ssbo_1_1.data[161u + buf0_dword_off]);
                    vec4 _3325 = textureLod(SPIRV_Cross_Combinedcs_img96cs_sampinline_0xfff00000000060_0x2500000, vec2(_3316, _3320), 0.0);
                    precise float _3331 = uintBitsToFloat(ssbo_1_1.data[164u + buf0_dword_off]) * _587;
                    precise float _3332 = _3331 + uintBitsToFloat(ssbo_1_1.data[166u + buf0_dword_off]);
                    precise float _3346 = uintBitsToFloat(ssbo_1_1.data[146u + buf0_dword_off]) * uintBitsToFloat(_2998);
                    precise float _3348 = 100.0 * _3346;
                    precise float _3350 = _3325.x * uintBitsToFloat(_2998);
                    precise float _3352 = uintBitsToFloat(_2998) * _3325.y;
                    precise float _3354 = uintBitsToFloat(_2998) * _3325.z;
                    precise float _3355 = _3350 * _3186;
                    precise float _3356 = _3352 * _3188;
                    precise float _3357 = _3354 * _3191;
                    precise float _3358 = (-1.0) + textureLod(SPIRV_Cross_Combinedcs_img104cs_sampinline_0xfff00000000060_0x2500000, vec2(_3332, uintBitsToFloat(ssbo_1_1.data[167u + buf0_dword_off])), 0.0).x;
                    precise float _3359 = 100.0 * _3355;
                    precise float _3361 = 100.0 * _3356;
                    precise float _3363 = 100.0 * _3357;
                    precise float _3365 = _3348 * _3358;
                    precise float _3366 = _3365 + 1.0;
                    _3368 = floatBitsToUint(_3366);
                    _3369 = floatBitsToUint(_3363);
                    _3370 = floatBitsToUint(_3361);
                    _3371 = floatBitsToUint(_3359);
                    _3372 = 38797312u;
                    _3373 = 16773120u;
                    _3374 = 96u;
                }
                else
                {
                    _3368 = floatBitsToUint(_3177);
                    _3369 = floatBitsToUint(_3241);
                    _3370 = floatBitsToUint(_3238);
                    _3371 = floatBitsToUint(_3235);
                    _3372 = ssbo_1_1.data[_3025];
                    _3373 = ssbo_1_1.data[_3022];
                    _3374 = ssbo_1_1.data[_3019];
                }
                uint _3499;
                uint _3500;
                uint _3501;
                uint _3502;
                uint _3503;
                if (!_3233)
                {
                    precise float _3376 = uintBitsToFloat(_3374) * _486;
                    uint _3378 = 144u + buf0_dword_off;
                    uint _3389 = 150u + buf0_dword_off;
                    uint _3393 = 151u + buf0_dword_off;
                    precise float _3397 = uintBitsToFloat(_2998) * _3186;
                    precise float _3401 = (-uintBitsToFloat(ssbo_1_1.data[_3389])) * uintBitsToFloat(ssbo_1_1.data[_3389]);
                    precise float _3402 = _3401 + 1.0;
                    precise float _3404 = uintBitsToFloat(_2998) * _3188;
                    precise float _3406 = uintBitsToFloat(_3373) * _563;
                    precise float _3407 = _3406 + _3376;
                    precise float _3409 = uintBitsToFloat(_3372) * _488;
                    precise float _3410 = _3409 + _3407;
                    precise float _3412 = uintBitsToFloat(ssbo_1_1.data[_3389]) * _3410;
                    precise float _3413 = _3410 * _3410;
                    precise float _3414 = _3413 + 1.0;
                    precise float _3415 = _3402 * _3414;
                    precise float _3417 = 0.238732397556304931640625 * _3415;
                    precise float _3419 = uintBitsToFloat(_2998) * _3191;
                    precise float _3422 = uintBitsToFloat(ssbo_1_1.data[_3389]) * uintBitsToFloat(ssbo_1_1.data[_3389]);
                    precise float _3423 = (-2.0) * _3412;
                    precise float _3424 = _3423 + _3422;
                    precise float _3425 = 1.0 + _3424;
                    precise float _3429 = sqrt(abs(_3425)) * abs(_3425);
                    precise float _3432 = uintBitsToFloat(ssbo_1_1.data[_3389]) * uintBitsToFloat(ssbo_1_1.data[_3389]);
                    precise float _3433 = _3432 + 2.0;
                    precise float _3434 = _3433 * 2.0;
                    precise float _3435 = _3434 * _3429;
                    precise float _3438 = uintBitsToFloat(ssbo_1_1.data[_3393]) * _3410;
                    precise float _3441 = uintBitsToFloat(ssbo_1_1.data[_3393]) * uintBitsToFloat(ssbo_1_1.data[_3393]);
                    precise float _3442 = (-2.0) * _3438;
                    precise float _3443 = _3442 + _3441;
                    precise float _3444 = 1.0 + _3443;
                    precise float _3448 = sqrt(abs(_3444)) * abs(_3444);
                    precise float _3451 = uintBitsToFloat(ssbo_1_1.data[_3393]) * uintBitsToFloat(ssbo_1_1.data[_3393]);
                    precise float _3452 = _3451 + 2.0;
                    precise float _3453 = _3452 * 2.0;
                    precise float _3454 = _3453 * _3448;
                    precise float _3458 = (-uintBitsToFloat(ssbo_1_1.data[_3393])) * uintBitsToFloat(ssbo_1_1.data[_3393]);
                    precise float _3459 = _3458 + 1.0;
                    precise float _3461 = _3414 * _3459;
                    precise float _3462 = _3417 * (1.0 / _3435);
                    precise float _3464 = 0.238732397556304931640625 * _3461;
                    precise float _3466 = _3464 * (1.0 / _3454);
                    precise float _3467 = _3466 + (-_3462);
                    precise float _3471 = uintBitsToFloat(ssbo_1_1.data[145u + buf0_dword_off]) * _3467;
                    precise float _3472 = _3471 + _3462;
                    precise float _3473 = _3397 * _3472;
                    precise float _3475 = _3404 * _3472;
                    precise float _3477 = _3419 * _3472;
                    uint _3498;
                    if (!(uintBitsToFloat(ssbo_1_1.data[_3378]) <= 0.0))
                    {
                        precise float _3480 = 0.15915493667125701904296875 * _587;
                        precise float _3488 = uintBitsToFloat(ssbo_1_1.data[_3378]) * uintBitsToFloat(_2998);
                        precise float _3489 = _3488 * (1.0 / max(9.9999997473787516355514526367188e-06, cos(6.283185482025146484375 * fract(_3480))));
                        precise float _3491 = (-1.44269502162933349609375) * _3489;
                        precise float _3493 = (-1.0) + exp2(_3491);
                        precise float _3495 = uintBitsToFloat(ssbo_1_1.data[146u + buf0_dword_off]) * _3493;
                        precise float _3496 = _3495 + 1.0;
                        _3498 = floatBitsToUint(_3496);
                    }
                    else
                    {
                        _3498 = 1065353216u;
                    }
                    _3499 = floatBitsToUint(_3459);
                    _3500 = _3498;
                    _3501 = floatBitsToUint(_3477);
                    _3502 = floatBitsToUint(_3475);
                    _3503 = floatBitsToUint(_3473);
                }
                else
                {
                    _3499 = floatBitsToUint(_3188);
                    _3500 = _3368;
                    _3501 = _3369;
                    _3502 = _3370;
                    _3503 = _3371;
                }
                precise float _3505 = uintBitsToFloat(ssbo_1_1.data[113u + buf0_dword_off]) + _3243;
                precise float _3508 = uintBitsToFloat(ssbo_1_1.data[153u + buf0_dword_off]) * uintBitsToFloat(_2998);
                precise float _3510 = uintBitsToFloat(ssbo_1_1.data[114u + buf0_dword_off]) + _3244;
                precise float _3512 = uintBitsToFloat(ssbo_1_1.data[115u + buf0_dword_off]) + _3245;
                precise float _3513 = _3508 * _3505;
                precise float _3515 = _3508 * _3510;
                precise float _3517 = _3508 * _3512;
                precise float _3519 = _3513 * 100.0;
                precise float _3520 = _3519 + uintBitsToFloat(_3503);
                precise float _3523 = (-9.9999997473787516355514526367188e-06) + uintBitsToFloat(_1379);
                precise float _3525 = _3515 * 100.0;
                precise float _3526 = _3525 + uintBitsToFloat(_3502);
                precise float _3528 = _3517 * 100.0;
                precise float _3529 = _3528 + uintBitsToFloat(_3501);
                precise float _3532 = uintBitsToFloat(_2997) - uintBitsToFloat(_1377);
                precise float _3535 = uintBitsToFloat(_3500) * uintBitsToFloat(_1379);
                precise float _3538 = _3520 * _3523;
                precise float _3539 = _3538 + uintBitsToFloat(_1375);
                precise float _3542 = _3526 * _3523;
                precise float _3543 = _3542 + uintBitsToFloat(_1374);
                precise float _3546 = _3529 * _3523;
                precise float _3547 = _3546 + uintBitsToFloat(_1376);
                precise float _3550 = _3532 * _3523;
                precise float _3551 = _3550 + uintBitsToFloat(_1377);
                _3553 = _3499;
                _3554 = floatBitsToUint(_3515);
                _3555 = floatBitsToUint(_3543);
                _3556 = floatBitsToUint(_3539);
                _3557 = floatBitsToUint(_3547);
                _3558 = floatBitsToUint(_3535);
                _3559 = floatBitsToUint(_3513);
                _3560 = floatBitsToUint(_3551);
            }
            else
            {
                _3553 = _2789;
                _3554 = _2998;
                _3555 = _1374;
                _3556 = _1375;
                _3557 = _1376;
                _3558 = _1379;
                _3559 = _2795;
                _3560 = _1377;
            }
            _3561 = _3553;
            _3562 = _3554;
            _3563 = _2997;
            _3564 = _3555;
            _3565 = _3556;
            _3566 = _3557;
            _3567 = _3558;
            _3568 = _3559;
            _3569 = _3560;
        }
        else
        {
            _3561 = _2789;
            _3562 = _2790;
            _3563 = _2791;
            _3564 = _1374;
            _3565 = _1375;
            _3566 = _1376;
            _3567 = _1379;
            _3568 = _2795;
            _3569 = _1377;
        }
        uint _3575 = 79u + buf0_dword_off;
        bool _3579 = 0.0 != uintBitsToFloat(ssbo_1_1.data[76u + buf0_dword_off]);
        uint _4409;
        uint _4410;
        uint _4411;
        uint _4412;
        uint _4413;
        uint _4414;
        uint _4415;
        if (_3579)
        {
            uint _3586 = 12u + buf0_dword_off;
            uint _4206;
            uint _4207;
            uint _4208;
            uint _4209;
            uint _4210;
            uint _4211;
            uint _4212;
            uint _4213;
            uint _4214;
            if (uintBitsToFloat(ssbo_1_1.data[9u + buf0_dword_off]) > 0.0)
            {
                precise float _3601 = uintBitsToFloat(ssbo_1_1.data[_3586]) + uintBitsToFloat(ssbo_1_1.data[13u + buf0_dword_off]);
                precise float _3603 = (-_3601) * _563;
                precise float _3604 = _3603 * _3603;
                precise float _3607 = 100000.0 + uintBitsToFloat(ssbo_1_1.data[_3586]);
                precise float _3609 = _3601 * (-_3601);
                precise float _3610 = _3609 + _3604;
                precise float _3611 = _3607 * _3607;
                precise float _3612 = _3611 + _3610;
                uint _3620;
                uint _3621;
                uint _3622;
                if (_383 && (0.0 <= _3612))
                {
                    float _3615 = sqrt(_3612);
                    precise float _3616 = _3603 - _3615;
                    precise float _3618 = _3615 + _3603;
                    _3620 = 1u;
                    _3621 = floatBitsToUint(_3618);
                    _3622 = floatBitsToUint(_3616);
                }
                else
                {
                    _3620 = 0u;
                    _3621 = _3568;
                    _3622 = 0u;
                }
                precise float _3637 = uintBitsToFloat(ssbo_1_1.data[_3586]) + uintBitsToFloat(ssbo_1_1.data[3u + buf0_dword_off]);
                precise float _3638 = _3637 * _3637;
                precise float _3639 = _3638 + _3610;
                uint _3647;
                uint _3648;
                uint _3649;
                if (_383 && (0.0 <= _3639))
                {
                    float _3642 = sqrt(_3639);
                    precise float _3643 = _3603 - _3642;
                    precise float _3645 = _3642 + _3603;
                    _3647 = floatBitsToUint(_3645);
                    _3648 = floatBitsToUint(_3643);
                    _3649 = 1u;
                }
                else
                {
                    _3647 = 1232348160u;
                    _3648 = 0u;
                    _3649 = 0u;
                }
                uint _3659 = 82u + buf0_dword_off;
                uint _3663 = 83u + buf0_dword_off;
                precise float _3672 = uintBitsToFloat(ssbo_1_1.data[80u + buf0_dword_off]) + uintBitsToFloat(_3569);
                float _3674 = max(uintBitsToFloat(ssbo_1_1.data[_3575]), _587);
                float _3676 = 1.0 / uintBitsToFloat(ssbo_1_1.data[_3663]);
                float _3678 = 1.0 / uintBitsToFloat(ssbo_1_1.data[81u + buf0_dword_off]);
                bool _3680 = uintBitsToFloat(ssbo_1_1.data[84u + buf0_dword_off]) > 0.0;
                precise float _3681 = 0.3183098733425140380859375 * _3674;
                uint _3682 = floatBitsToUint(_3681);
                uint _3683 = floatBitsToUint(_3681);
                bool _3684 = 1.57079637050628662109375 > _3674;
                precise float _3686 = _3672 - uintBitsToFloat(ssbo_1_1.data[_3659]);
                precise float _3687 = _3676 * _3686;
                precise float _3690 = log2(clamp(_3687, 0.0, 1.0)) * _3678;
                precise float _3692 = 0.15915493667125701904296875 * _585;
                uint _3711;
                if (_3680)
                {
                    bool _3693 = _383 && _3684;
                    uint _3700;
                    if (_3693)
                    {
                        precise float _3695 = (-_3681) * _3681;
                        precise float _3696 = _3695 + 0.25;
                        precise float _3698 = 0.5 - sqrt(_3696);
                        _3700 = floatBitsToUint(_3698);
                    }
                    else
                    {
                        _3700 = _3683;
                    }
                    uint _3710;
                    if (_383 && (!_3693))
                    {
                        precise float _3703 = (-1.0) + _3681;
                        precise float _3705 = (-_3703) * _3703;
                        precise float _3706 = _3705 + 0.25;
                        precise float _3708 = 0.5 + sqrt(_3706);
                        _3710 = floatBitsToUint(_3708);
                    }
                    else
                    {
                        _3710 = _3700;
                    }
                    _3711 = _3710;
                }
                else
                {
                    _3711 = _3683;
                }
                uint _3720 = 52u + buf0_dword_off;
                uint _3724 = 53u + buf0_dword_off;
                uint _3728 = 54u + buf0_dword_off;
                uint _3740 = 27u + buf0_dword_off;
                bool _3744 = 0.0 != uintBitsToFloat(ssbo_1_1.data[_3720]);
                uint _3777;
                if (_3744)
                {
                    precise float _3747 = uintBitsToFloat(ssbo_1_1.data[_3728]) - uintBitsToFloat(ssbo_1_1.data[_3724]);
                    precise float _3749 = _3672 - uintBitsToFloat(ssbo_1_1.data[_3724]);
                    precise float _3751 = (1.0 / _3747) * _3749;
                    float _3752 = clamp(_3751, 0.0, 1.0);
                    precise float _3754 = _3752 * _3752;
                    precise float _3756 = uintBitsToFloat(ssbo_1_1.data[_3720]) * _3754;
                    precise float _3757 = _3756 * fma(-2.0, _3752, 3.0);
                    uint _3776;
                    if (_383 && (0.0 != _3757))
                    {
                        precise float _3765 = _3692 - uintBitsToFloat(ssbo_1_1.data[17u + buf0_dword_off]);
                        precise float _3773 = _3757 * textureLod(SPIRV_Cross_Combinedcs_img48cs_sampsgpr_148, vec2(_3765, 0.5), 0.0).x;
                        precise float _3774 = _3773 + uintBitsToFloat(ssbo_1_1.data[_3740]);
                        _3776 = floatBitsToUint(_3774);
                    }
                    else
                    {
                        _3776 = ssbo_1_1.data[_3740];
                    }
                    _3777 = _3776;
                }
                else
                {
                    _3777 = ssbo_1_1.data[_3740];
                }
                float _3780 = max(uintBitsToFloat(_3647), uintBitsToFloat(_3648));
                bool _3790 = uintBitsToFloat(ssbo_1_1.data[18u + buf0_dword_off]) > 0.0;
                precise float _3792 = uintBitsToFloat(_3777) + textureLod(SPIRV_Cross_Combinedcs_img16cs_sampinline_0xfff00000000190_0x8000000002500000, vec3(_3692, uintBitsToFloat(_3711), exp2(_3690)), 0.0).x;
                float _3793 = clamp(_3792, 0.0, 1.0);
                float _3796 = min(uintBitsToFloat(_3647), uintBitsToFloat(_3648));
                precise float _3800 = 0.636619746685028076171875 * _587;
                uint _3802 = 4u + buf0_dword_off;
                uint _3805 = 5u + buf0_dword_off;
                uint _3809 = 6u + buf0_dword_off;
                uint _3813 = 7u + buf0_dword_off;
                float _3816 = ((0u == _3649) || (0.0 > _3780)) ? 0.0 : ((0.0 > _3796) ? _3780 : _3796);
                uint _3852;
                if (!_3790)
                {
                    precise float _3830 = uintBitsToFloat(ssbo_1_1.data[45u + buf0_dword_off]) * log2(abs(_3800));
                    precise float _3833 = uintBitsToFloat(ssbo_1_1.data[25u + buf0_dword_off]) * exp2(_3830);
                    float _3836 = max(9.9999997473787516355514526367188e-06, _3833);
                    precise float _3839 = (-1.44269502162933349609375) * _3836;
                    precise float _3840 = ((uintBitsToFloat(ssbo_1_1.data[43u + buf0_dword_off]) > 0.0) ? (1.0 / _3816) : 0.001000000047497451305389404296875) * _3672;
                    precise float _3843 = _3836 * clamp(_3840, 0.0, 1.0);
                    precise float _3844 = 1.0 - exp2(_3839);
                    precise float _3845 = (-1.44269502162933349609375) * _3843;
                    float _3846 = 1.0 / _3844;
                    precise float _3849 = _3846 * (-exp2(_3845));
                    precise float _3850 = _3849 + _3846;
                    _3852 = floatBitsToUint(_3850);
                }
                else
                {
                    _3852 = 1065353216u;
                }
                float _3859 = abs(_486);
                float _3860 = abs(_563);
                float _3861 = abs(_488);
                float _3869 = -_563;
                float _3872 = abs(_486);
                float _3873 = abs(_563);
                float _3874 = abs(_488);
                float _3888 = abs(_486);
                float _3889 = abs(_563);
                float _3890 = abs(_488);
                float _3896 = ((_3890 >= _3888) && (_3890 >= _3889)) ? ((_488 < 0.0) ? 5.0 : 4.0) : ((_3889 >= _3888) ? ((_563 < 0.0) ? 3.0 : 2.0) : float(_486 < 0.0));
                precise float _3897 = _486 * 2.0;
                precise float _3898 = _563 * 2.0;
                precise float _3899 = _488 * 2.0;
                float _3900 = abs(_486);
                float _3901 = abs(_563);
                float _3902 = abs(_488);
                float _3910 = 1.0 / abs(((_3902 >= _3900) && (_3902 >= _3901)) ? _3899 : ((_3901 >= _3900) ? _3898 : _3897));
                precise float _3911 = fma(((_3861 >= _3859) && (_3861 >= _3860)) ? ((_488 < 0.0) ? (-_486) : _486) : ((_3860 >= _3859) ? _486 : ((_486 < 0.0) ? _488 : (-_488))), _3910, 1.5);
                precise float _3912 = fma(((_3874 >= _3872) && (_3874 >= _3873)) ? _3869 : ((_3873 >= _3872) ? ((_563 < 0.0) ? (-_488) : _488) : _3869), _3910, 1.5);
                float _3925 = min(uintBitsToFloat(_3621), uintBitsToFloat(_3622));
                float _3928 = max(uintBitsToFloat(_3621), uintBitsToFloat(_3622));
                precise float _3929 = _3911 - 1.0;
                precise float _3930 = _3912 - 1.0;
                precise float _3932 = _3896 / 8.0;
                vec4 _3939 = textureLod(SPIRV_Cross_Combinedcs_img24cs_sampsgpr_144, vec3(_3929, _3930, fma(floor(_3932), -2.0, _3896)), 0.0);
                uint _3952 = 31u + buf0_dword_off;
                precise float _3956 = uintBitsToFloat(ssbo_1_1.data[46u + buf0_dword_off]) * log2(abs(_3800));
                float _3960 = exp2(_3956);
                precise float _3962 = uintBitsToFloat(ssbo_1_1.data[49u + buf0_dword_off]) * _3672;
                precise float _3968 = (1.0 / uintBitsToFloat(ssbo_1_1.data[0u + buf0_dword_off])) * _587;
                precise float _3973 = uintBitsToFloat(ssbo_1_1.data[_3809]) * uintBitsToFloat(_3852);
                precise float _3974 = _3973 + uintBitsToFloat(ssbo_1_1.data[_3813]);
                precise float _3977 = _3962 * max(9.9999997473787516355514526367188e-06, _3960);
                precise float _3979 = uintBitsToFloat(ssbo_1_1.data[29u + buf0_dword_off]) * _3793;
                precise float _3980 = _3979 * clamp(_3974, 0.0, 1.0);
                precise float _3983 = 0.001000000047497451305389404296875 * (((0u == _3620) || (0.0 > _3928)) ? 0.0 : ((0.0 > _3925) ? _3928 : _3925));
                precise float _3984 = 0.001000000047497451305389404296875 * _3977;
                precise float _3985 = _3939.x * _3980;
                precise float _3986 = _3939.y * _3980;
                precise float _3987 = _3939.z * _3980;
                bool _3988 = _383 && (0.5 >= _3968);
                uint _3996;
                uint _3997;
                if (_3988)
                {
                    precise float _3989 = (-2.0) * _3968;
                    precise float _3990 = _3989 + 1.0;
                    float _3991 = sqrt(_3990);
                    _3996 = floatBitsToUint(fma(-_3991, 0.5, 0.5));
                    _3997 = floatBitsToUint(_3991);
                }
                else
                {
                    _3996 = floatBitsToUint(_3980);
                    _3997 = floatBitsToUint(_3968);
                }
                uint _4006;
                if (_383 && (!_3988))
                {
                    precise float _4001 = 2.0 * uintBitsToFloat(_3997);
                    precise float _4002 = _4001 + (-1.0);
                    _4006 = floatBitsToUint(fma(sqrt(_4002), 0.5, 0.5));
                }
                else
                {
                    _4006 = _3996;
                }
                precise float _4008 = (1.0 / _3983) * _3984;
                precise float _4012 = 0.3333333432674407958984375 * log2(clamp(_4008, 0.0, 1.0));
                float _4014 = 1.0 / uintBitsToFloat(ssbo_1_1.data[2u + buf0_dword_off]);
                precise float _4016 = 1.0 - _4014;
                precise float _4017 = exp2(_4012) * _4016;
                precise float _4018 = 0.5 * _4014;
                precise float _4019 = _4018 + _4017;
                float _4021 = 1.0 / uintBitsToFloat(ssbo_1_1.data[1u + buf0_dword_off]);
                precise float _4022 = 1.0 - _4021;
                precise float _4024 = uintBitsToFloat(_4006) * _4022;
                precise float _4025 = 0.5 * _4021;
                precise float _4026 = _4025 + _4024;
                vec4 _4031 = textureLod(SPIRV_Cross_Combinedcs_img40cs_sampinline_0xfff00000000024_0x2500000, vec2(_4019, _4026), 0.0);
                precise float _4038 = uintBitsToFloat(ssbo_1_1.data[_3802]) * _4031.x;
                precise float _4039 = _4038 + uintBitsToFloat(ssbo_1_1.data[_3805]);
                precise float _4044 = uintBitsToFloat(ssbo_1_1.data[_3802]) * _4031.z;
                precise float _4045 = _4044 + uintBitsToFloat(ssbo_1_1.data[_3805]);
                precise float _4050 = uintBitsToFloat(ssbo_1_1.data[_3802]) * _4031.y;
                precise float _4051 = _4050 + uintBitsToFloat(ssbo_1_1.data[_3805]);
                uint _4078;
                if (!(_383 && _3790))
                {
                    precise float _4060 = uintBitsToFloat(ssbo_1_1.data[26u + buf0_dword_off]) * _3960;
                    float _4064 = max(9.9999997473787516355514526367188e-06, _4060);
                    precise float _4065 = ((uintBitsToFloat(ssbo_1_1.data[43u + buf0_dword_off]) > 0.0) ? (1.0 / _3816) : 0.001000000047497451305389404296875) * _3672;
                    precise float _4067 = (-1.44269502162933349609375) * _4064;
                    precise float _4068 = _4064 * clamp(_4065, 0.0, 1.0);
                    precise float _4070 = (-1.44269502162933349609375) * _4068;
                    precise float _4071 = 1.0 - exp2(_4067);
                    float _4073 = 1.0 / _4071;
                    precise float _4075 = _4073 * (-exp2(_4070));
                    precise float _4076 = _4075 + _4073;
                    _4078 = floatBitsToUint(_4076);
                }
                else
                {
                    _4078 = 1065353216u;
                }
                precise float _4082 = uintBitsToFloat(ssbo_1_1.data[_3952]) * _3793;
                precise float _4083 = _4082 + (-uintBitsToFloat(ssbo_1_1.data[_3952]));
                precise float _4084 = _3911 - 1.0;
                precise float _4085 = _3912 - 1.0;
                precise float _4086 = _3896 / 8.0;
                vec4 _4093 = textureLod(SPIRV_Cross_Combinedcs_img32cs_sampsgpr_144, vec3(_4084, _4085, fma(floor(_4086), -2.0, _3896)), 0.0);
                precise float _4097 = 1.0 + _4083;
                precise float _4105 = uintBitsToFloat(ssbo_1_1.data[_3809]) * uintBitsToFloat(_4078);
                precise float _4106 = _4105 + uintBitsToFloat(ssbo_1_1.data[_3813]);
                precise float _4109 = uintBitsToFloat(ssbo_1_1.data[30u + buf0_dword_off]) * clamp(_4106, 0.0, 1.0);
                precise float _4111 = _4097 * (-_3793);
                precise float _4112 = _4111 + _4097;
                precise float _4113 = _4109 * _4112;
                precise float _4116 = _4093.x * _4113;
                precise float _4117 = _4116 + _3985;
                precise float _4119 = _4093.y * _4113;
                precise float _4120 = _4119 + _3986;
                precise float _4122 = _4093.z * _4113;
                precise float _4123 = _4122 + _3987;
                uint _4203;
                uint _4204;
                uint _4205;
                if (uintBitsToFloat(ssbo_1_1.data[23u + buf0_dword_off]) > 0.0)
                {
                    precise float _4127 = uintBitsToFloat(ssbo_1_1.data[_3663]) - uintBitsToFloat(ssbo_1_1.data[_3659]);
                    precise float _4128 = _3676 * _4127;
                    precise float _4131 = log2(clamp(_4128, 0.0, 1.0)) * _3678;
                    uint _4153;
                    if (_383 && _3680)
                    {
                        bool _4134 = _383 && _3684;
                        uint _4141;
                        if (_4134)
                        {
                            precise float _4136 = (-_3681) * _3681;
                            precise float _4137 = _4136 + 0.25;
                            precise float _4139 = 0.5 - sqrt(_4137);
                            _4141 = floatBitsToUint(_4139);
                        }
                        else
                        {
                            _4141 = _3682;
                        }
                        uint _4152;
                        if (_383 && (!_4134))
                        {
                            precise float _4145 = (-1.0) + uintBitsToFloat(_4141);
                            precise float _4147 = (-_4145) * _4145;
                            precise float _4148 = _4147 + 0.25;
                            precise float _4150 = 0.5 + sqrt(_4148);
                            _4152 = floatBitsToUint(_4150);
                        }
                        else
                        {
                            _4152 = _4141;
                        }
                        _4153 = _4152;
                    }
                    else
                    {
                        _4153 = _3682;
                    }
                    uint _4190;
                    if (_383 && _3744)
                    {
                        precise float _4164 = uintBitsToFloat(ssbo_1_1.data[_3728]) - uintBitsToFloat(ssbo_1_1.data[_3724]);
                        precise float _4168 = uintBitsToFloat(ssbo_1_1.data[_3663]) - uintBitsToFloat(ssbo_1_1.data[_3724]);
                        precise float _4169 = (1.0 / _4164) * _4168;
                        float _4170 = clamp(_4169, 0.0, 1.0);
                        precise float _4171 = _4170 * _4170;
                        precise float _4173 = uintBitsToFloat(ssbo_1_1.data[_3720]) * _4171;
                        precise float _4175 = _4173 * fma(-2.0, _4170, 3.0);
                        uint _4189;
                        if (0.0 != _4175)
                        {
                            precise float _4178 = _3692 - uintBitsToFloat(ssbo_1_1.data[17u + buf0_dword_off]);
                            precise float _4186 = _4175 * textureLod(SPIRV_Cross_Combinedcs_img48cs_sampsgpr_148, vec2(_4178, 0.5), 0.0).x;
                            precise float _4187 = _4186 + uintBitsToFloat(ssbo_1_1.data[_3740]);
                            _4189 = floatBitsToUint(_4187);
                        }
                        else
                        {
                            _4189 = ssbo_1_1.data[_3740];
                        }
                        _4190 = _4189;
                    }
                    else
                    {
                        _4190 = ssbo_1_1.data[_3740];
                    }
                    precise float _4192 = uintBitsToFloat(_4190) + textureLod(SPIRV_Cross_Combinedcs_img16cs_sampinline_0xfff00000000190_0x8000000002500000, vec3(_3692, uintBitsToFloat(_4153), exp2(_4131)), 0.0).x;
                    float _4193 = clamp(_4192, 0.0, 1.0);
                    precise float _4195 = uintBitsToFloat(_2792) * _4193;
                    precise float _4198 = uintBitsToFloat(_2793) * _4193;
                    precise float _4201 = uintBitsToFloat(_2794) * _4193;
                    _4203 = floatBitsToUint(_4195);
                    _4204 = floatBitsToUint(_4198);
                    _4205 = floatBitsToUint(_4201);
                }
                else
                {
                    _4203 = _2792;
                    _4204 = _2793;
                    _4205 = _2794;
                }
                _4206 = floatBitsToUint(_4117);
                _4207 = _4203;
                _4208 = _4204;
                _4209 = _4205;
                _4210 = floatBitsToUint(_4123);
                _4211 = floatBitsToUint(_4120);
                _4212 = floatBitsToUint(clamp(_4051, 0.0, 1.0));
                _4213 = floatBitsToUint(clamp(_4039, 0.0, 1.0));
                _4214 = floatBitsToUint(clamp(_4045, 0.0, 1.0));
            }
            else
            {
                _4206 = 0u;
                _4207 = _2792;
                _4208 = _2793;
                _4209 = _2794;
                _4210 = 1232348160u;
                _4211 = 0u;
                _4212 = 0u;
                _4213 = 0u;
                _4214 = 0u;
            }
            uint _4216 = 20u + buf0_dword_off;
            uint _4248;
            uint _4249;
            uint _4250;
            if (uintBitsToFloat(ssbo_1_1.data[_4216]) > 0.0)
            {
                precise float _4230 = uintBitsToFloat(ssbo_1_1.data[_4216]) * _587;
                precise float _4232 = 1.44269502162933349609375 * _4230;
                precise float _4236 = uintBitsToFloat(ssbo_1_1.data[22u + buf0_dword_off]) * exp2(_4232);
                precise float _4237 = _4236 + uintBitsToFloat(ssbo_1_1.data[21u + buf0_dword_off]);
                float _4238 = clamp(_4237, 0.0, 1.0);
                precise float _4240 = uintBitsToFloat(_4213) * _4238;
                precise float _4243 = uintBitsToFloat(_4212) * _4238;
                precise float _4246 = uintBitsToFloat(_4214) * _4238;
                _4248 = floatBitsToUint(_4246);
                _4249 = floatBitsToUint(_4243);
                _4250 = floatBitsToUint(_4240);
            }
            else
            {
                _4248 = _4214;
                _4249 = _4212;
                _4250 = _4213;
            }
            precise float _4253 = uintBitsToFloat(_4207) - uintBitsToFloat(_4206);
            precise float _4256 = uintBitsToFloat(_4208) - uintBitsToFloat(_4211);
            precise float _4259 = uintBitsToFloat(_4209) - uintBitsToFloat(_4210);
            precise float _4264 = _4253 * uintBitsToFloat(_3567);
            precise float _4265 = _4264 + uintBitsToFloat(_4206);
            precise float _4268 = _4256 * uintBitsToFloat(_3567);
            precise float _4269 = _4268 + uintBitsToFloat(_4211);
            precise float _4272 = _4259 * uintBitsToFloat(_3567);
            precise float _4273 = _4272 + uintBitsToFloat(_4210);
            precise float _4276 = uintBitsToFloat(_4250) * uintBitsToFloat(_3565);
            precise float _4277 = _4276 + _4265;
            precise float _4281 = uintBitsToFloat(_4249) * uintBitsToFloat(_3564);
            precise float _4282 = _4281 + _4269;
            precise float _4286 = uintBitsToFloat(_4248) * uintBitsToFloat(_3566);
            precise float _4287 = _4286 + _4273;
            uint _4405;
            uint _4406;
            uint _4407;
            uint _4408;
            if (uintBitsToFloat(ssbo_1_1.data[14u + buf0_dword_off]) > 0.0)
            {
                precise float _4303 = uintBitsToFloat(_3569) - uintBitsToFloat(ssbo_1_1.data[82u + buf0_dword_off]);
                precise float _4306 = (1.0 / uintBitsToFloat(ssbo_1_1.data[83u + buf0_dword_off])) * _4303;
                precise float _4311 = log2(clamp(_4306, 0.0, 1.0)) * (1.0 / uintBitsToFloat(ssbo_1_1.data[81u + buf0_dword_off]));
                float _4313 = max(uintBitsToFloat(ssbo_1_1.data[_3575]), _587);
                precise float _4315 = 0.3183098733425140380859375 * _4313;
                uint _4316 = floatBitsToUint(_4315);
                precise float _4320 = 0.15915493667125701904296875 * _585;
                uint _4321 = floatBitsToUint(_4320);
                uint _4341;
                if (uintBitsToFloat(ssbo_1_1.data[84u + buf0_dword_off]) > 0.0)
                {
                    bool _4322 = _383 && (1.57079637050628662109375 > _4313);
                    uint _4329;
                    if (_4322)
                    {
                        precise float _4324 = (-_4315) * _4315;
                        precise float _4325 = _4324 + 0.25;
                        precise float _4327 = 0.5 - sqrt(_4325);
                        _4329 = floatBitsToUint(_4327);
                    }
                    else
                    {
                        _4329 = _4316;
                    }
                    uint _4340;
                    if (_383 && (!_4322))
                    {
                        precise float _4333 = (-1.0) + uintBitsToFloat(_4329);
                        precise float _4335 = (-_4333) * _4333;
                        precise float _4336 = _4335 + 0.25;
                        precise float _4338 = 0.5 + sqrt(_4336);
                        _4340 = floatBitsToUint(_4338);
                    }
                    else
                    {
                        _4340 = _4329;
                    }
                    _4341 = _4340;
                }
                else
                {
                    _4341 = _4316;
                }
                uint _4349 = 52u + buf0_dword_off;
                uint _4352 = 53u + buf0_dword_off;
                uint _4358 = 27u + buf0_dword_off;
                uint _4397;
                uint _4398;
                if (0.0 != uintBitsToFloat(ssbo_1_1.data[_4349]))
                {
                    precise float _4365 = uintBitsToFloat(ssbo_1_1.data[54u + buf0_dword_off]) - uintBitsToFloat(ssbo_1_1.data[_4352]);
                    precise float _4368 = uintBitsToFloat(_3569) - uintBitsToFloat(ssbo_1_1.data[_4352]);
                    precise float _4370 = (1.0 / _4365) * _4368;
                    float _4371 = clamp(_4370, 0.0, 1.0);
                    precise float _4372 = _4371 * _4371;
                    precise float _4374 = uintBitsToFloat(ssbo_1_1.data[_4349]) * _4372;
                    precise float _4376 = _4374 * fma(-2.0, _4371, 3.0);
                    uint _4395;
                    uint _4396;
                    if (_383 && (0.0 != _4376))
                    {
                        precise float _4383 = _4320 - uintBitsToFloat(ssbo_1_1.data[17u + buf0_dword_off]);
                        vec4 _4388 = textureLod(SPIRV_Cross_Combinedcs_img48cs_sampsgpr_148, vec2(_4383, 0.5), 0.0);
                        float _4389 = _4388.x;
                        precise float _4392 = _4376 * _4389;
                        precise float _4393 = _4392 + uintBitsToFloat(ssbo_1_1.data[_4358]);
                        _4395 = floatBitsToUint(_4389);
                        _4396 = floatBitsToUint(_4393);
                    }
                    else
                    {
                        _4395 = _4321;
                        _4396 = ssbo_1_1.data[_4358];
                    }
                    _4397 = _4395;
                    _4398 = _4396;
                }
                else
                {
                    _4397 = _4321;
                    _4398 = ssbo_1_1.data[_4358];
                }
                precise float _4400 = uintBitsToFloat(_4398) + textureLod(SPIRV_Cross_Combinedcs_img16cs_sampinline_0xfff00000000190_0x8000000001000000, vec3(_4320, uintBitsToFloat(_4341), exp2(_4311)), 0.0).x;
                float _4401 = clamp(_4400, 0.0, 1.0);
                _4405 = floatBitsToUint(_4401);
                _4406 = floatBitsToUint(_4401);
                _4407 = floatBitsToUint(_4401);
                _4408 = _4397;
            }
            else
            {
                _4405 = floatBitsToUint(_4277);
                _4406 = floatBitsToUint(_4287);
                _4407 = floatBitsToUint(_4282);
                _4408 = _3567;
            }
            _4409 = _4405;
            _4410 = _4406;
            _4411 = _4407;
            _4412 = _4207;
            _4413 = _4208;
            _4414 = _4209;
            _4415 = _4408;
        }
        else
        {
            _4409 = _3561;
            _4410 = _3562;
            _4411 = _3563;
            _4412 = _2792;
            _4413 = _2793;
            _4414 = _2794;
            _4415 = _3567;
        }
        uint _4434;
        uint _4435;
        uint _4436;
        if (!_3579)
        {
            precise float _4419 = uintBitsToFloat(_4415) * uintBitsToFloat(_4412);
            precise float _4420 = _4419 + uintBitsToFloat(_3565);
            precise float _4425 = uintBitsToFloat(_4415) * uintBitsToFloat(_4413);
            precise float _4426 = _4425 + uintBitsToFloat(_3564);
            precise float _4431 = uintBitsToFloat(_4415) * uintBitsToFloat(_4414);
            precise float _4432 = _4431 + uintBitsToFloat(_3566);
            _4434 = floatBitsToUint(_4420);
            _4435 = floatBitsToUint(_4432);
            _4436 = floatBitsToUint(_4426);
        }
        else
        {
            _4434 = _4409;
            _4435 = _4410;
            _4436 = _4411;
        }
        uint _4456;
        uint _4457;
        uint _4458;
        if (0u != ssbo_1_1.data[406u + buf0_dword_off])
        {
            uint _4444 = (subgroupBroadcastFirst(_405) * 12u) >> 2u;
            _4456 = ssbo_2_1.data[(_4444 + 2u) + buf1_dword_off];
            _4457 = ssbo_2_1.data[(_4444 + 1u) + buf1_dword_off];
            _4458 = ssbo_2_1.data[_4444 + buf1_dword_off];
        }
        else
        {
            _4456 = _4435;
            _4457 = _4436;
            _4458 = _4434;
        }
        bool _4464 = (0u != ssbo_1_1.data[408u + buf0_dword_off]) ? _383 : false;
        vec4 _4471 = vec4(_4464 ? 1.0 : uintBitsToFloat(_4458), _4464 ? 1.0 : uintBitsToFloat(_4457), _4464 ? 1.0 : uintBitsToFloat(_4456), 1.0);
        imageStore(cs_img4, ivec3(uvec3(_378, _379, _405)), vec4(_4471.x, _4471.y, _4471.z, vec4(0.0, 1.0, 0.0, 0.0).x));
    }
}

