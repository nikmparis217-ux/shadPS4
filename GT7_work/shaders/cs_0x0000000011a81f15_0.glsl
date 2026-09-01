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

layout(binding = 7) uniform writeonly image2DArray cs_img40;
uniform sampler2D SPIRV_Cross_Combinedcs_img16cs_sampsgpr_8;
uniform sampler2D SPIRV_Cross_Combinedcs_img24cs_sampsgpr_8;
uniform sampler2DArray SPIRV_Cross_Combinedcs_img0cs_sampsgpr_48;
uniform sampler2D SPIRV_Cross_Combinedcs_img32cs_sampsgpr_52;

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
    uint _237 = (gl_WorkGroupID.x << 3u) + gl_LocalInvocationID.x;
    uint _238 = (gl_WorkGroupID.y << 3u) + gl_LocalInvocationID.y;
    uint _239 = 0u + buf0_dword_off;
    uint _242 = 1u + buf0_dword_off;
    bool _247 = (ssbo_1_1.data[_242] < _238) || (ssbo_1_1.data[_239] < _237);
    bool _248 = !_247;
    if (!_247)
    {
        uint _253 = 12u + buf0_dword_off;
        float _262 = 1.0 / float(ssbo_1_1.data[_239]);
        float _264 = 1.0 / float(ssbo_1_1.data[_242]);
        precise float _267 = uintBitsToFloat(ssbo_1_1.data[13u + buf0_dword_off]) + float(int(gl_WorkGroupID.z));
        precise float _268 = float(int(_237)) * _262;
        precise float _269 = float(int(_238)) * _264;
        uint _270 = uint(int(_267));
        uint _271 = subgroupBroadcastFirst(_270);
        precise float _273 = 2.0 * _268;
        precise float _274 = _273 + _262;
        precise float _275 = 2.0 * _269;
        precise float _276 = _275 + _264;
        precise float _278 = (-1.0) + _274;
        precise float _279 = (-1.0) + _276;
        uint _334;
        uint _335;
        uint _336;
        if (0u != _271)
        {
            uint _289 = uint(2u == _271) | uint(1u == _271);
            uint _294 = uint(3u == _271) | uint(_289 != 0u);
            bool _296 = 1u == _271;
            bool _302 = 5u == _271;
            bool _311 = (0u != _289) ? _248 : false;
            bool _318 = (0u != _294) ? _248 : false;
            bool _322 = 0u != (uint(4u == _271) | uint(_294 != 0u));
            _334 = floatBitsToUint(_322 ? (_318 ? (_311 ? (_296 ? _278 : _279) : (-_279)) : 1.0) : uintBitsToFloat((5u == _271) ? 3212836864u : 0u));
            _335 = floatBitsToUint(_322 ? (_318 ? (_311 ? (_296 ? (-_279) : 1.0) : (-1.0)) : (-_279)) : (_302 ? (-_279) : 0.0));
            _336 = floatBitsToUint(_322 ? (_318 ? (_311 ? (_296 ? (-1.0) : _278) : _278) : _278) : (_302 ? (-_278) : 0.0));
        }
        else
        {
            _334 = floatBitsToUint(-_278);
            _335 = floatBitsToUint(-_279);
            _336 = 1065353216u;
        }
        precise float _339 = uintBitsToFloat(_336) * uintBitsToFloat(_336);
        precise float _342 = uintBitsToFloat(_335) * uintBitsToFloat(_335);
        precise float _343 = _342 + _339;
        precise float _346 = uintBitsToFloat(_334) * uintBitsToFloat(_334);
        precise float _347 = _346 + _343;
        float _349 = inversesqrt(_347);
        precise float _351 = uintBitsToFloat(_336) * _349;
        precise float _353 = uintBitsToFloat(_334) * _349;
        precise float _361 = (1.0 / max(abs(_353), abs(_351))) * min(abs(_353), abs(_351));
        precise float _362 = _361 * _361;
        precise float _367 = (-abs(uintBitsToFloat(_335))) * abs(_349);
        precise float _368 = _367 + 1.0;
        precise float _372 = _368 * _368;
        precise float _375 = _368 * _372;
        precise float _377 = (-0.000988719053566455841064453125) * _372;
        precise float _379 = (-0.117851130664348602294921875) * _368;
        precise float _392 = _375 * (-0.0003834455274045467376708984375);
        precise float _393 = _392 + _377;
        precise float _394 = _372 * _372;
        precise float _396 = _372 * (-0.026516504585742950439453125);
        precise float _397 = _396 + _379;
        precise float _399 = fma(fma(fma(fma(0.02083499915897846221923828125, _362, -0.08513300120830535888671875), _362, 0.1801410019397735595703125), _362, -0.3302989900112152099609375), _362, 0.999866008758544921875);
        precise float _401 = _349 * min(uintBitsToFloat(_336), uintBitsToFloat(_334));
        precise float _402 = _349 * max(uintBitsToFloat(_336), uintBitsToFloat(_334));
        precise float _404 = _394 * (-0.00015429117775056511163711547851562);
        precise float _405 = _404 + _393;
        precise float _407 = _394 * (-0.00268540973775088787078857421875);
        precise float _408 = _407 + _397;
        precise float _409 = _361 * _399;
        precise float _413 = (-0.00789181701838970184326171875) + _405;
        precise float _415 = (-1.41421353816986083984375) + _408;
        float _419 = sqrt(_368);
        uint _421 = 20u + buf0_dword_off;
        uint _425 = 21u + buf0_dword_off;
        precise float _441 = uintBitsToFloat(_335) * _349;
        precise float _442 = _413 * _375;
        precise float _443 = _442 + _415;
        precise float _452 = _419 * _443;
        precise float _453 = ((abs(_351) < abs(_353)) ? fma(-2.0, _409, 1.57079637050628662109375) : 0.0) + ((0.0 > _351) ? (-3.1415927410125732421875) : 0.0);
        precise float _456 = 1.57079637050628662109375 - uintBitsToFloat(ssbo_1_1.data[_425]);
        precise float _458 = _399 * _361;
        precise float _459 = _458 + _453;
        float _461 = ((_401 < (-_401)) && (_402 >= (-_402))) ? (-_459) : _459;
        float _464 = (0.0 >= _441) ? fma(_419, _443, 3.1415927410125732421875) : (-_452);
        precise float _470 = uintBitsToFloat(ssbo_1_1.data[26u + buf0_dword_off]) + _461;
        precise float _471 = 1.57079637050628662109375 + _470;
        bool _475 = _248 && (((1.57079637050628662109375 >= _464) && (_456 <= _464)) || (uintBitsToFloat(ssbo_1_1.data[_425]) <= 0.0));
        uint _480;
        if (_475)
        {
            _480 = floatBitsToUint((uintBitsToFloat(ssbo_1_1.data[_425]) > 0.0) ? _456 : _464);
        }
        else
        {
            _480 = floatBitsToUint(_456);
        }
        uint _490;
        if (_248 && (!_475))
        {
            precise float _484 = 1.57079637050628662109375 + uintBitsToFloat(ssbo_1_1.data[_425]);
            _490 = floatBitsToUint(((1.57079637050628662109375 <= _464) && (_464 <= _484)) ? _484 : _464);
        }
        else
        {
            _490 = _480;
        }
        uint _500 = 30u + buf0_dword_off;
        uint _504 = 32u + buf0_dword_off;
        uint _512 = 34u + buf0_dword_off;
        precise float _517 = 0.15915493667125701904296875 * uintBitsToFloat(_490);
        precise float _518 = 0.15915493667125701904296875 * _471;
        float _519 = fract(_517);
        float _521 = fract(_518);
        bool _523 = uintBitsToFloat(ssbo_1_1.data[_512]) <= 0.0;
        float _527 = sin(6.283185482025146484375 * _519);
        float _531 = sin(6.283185482025146484375 * _521);
        precise float _533 = _527 * cos(6.283185482025146484375 * _521);
        precise float _535 = _527 * _531;
        float _537 = cos(6.283185482025146484375 * _519);
        uint _1162;
        uint _1163;
        uint _1164;
        if (!((uintBitsToFloat(ssbo_1_1.data[_500]) <= 0.0) && _523))
        {
            uint _558;
            uint _559;
            uint _560;
            if (_248 && (uintBitsToFloat(ssbo_1_1.data[_421]) > 0.0))
            {
                precise float _542 = 0.15915493667125701904296875 * _471;
                precise float _545 = trunc(_542) * (-6.283185482025146484375);
                precise float _546 = _545 + _471;
                precise float _548 = 1.57079637050628662109375 - uintBitsToFloat(ssbo_1_1.data[_421]);
                precise float _551 = 1.57079637050628662109375 + uintBitsToFloat(ssbo_1_1.data[_421]);
                _558 = floatBitsToUint(_551);
                _559 = floatBitsToUint(_548);
                _560 = floatBitsToUint(((_548 <= _546) && (_546 <= _551)) ? _548 : _471);
            }
            else
            {
                _558 = floatBitsToUint(_519);
                _559 = floatBitsToUint(_531);
                _560 = floatBitsToUint(_471);
            }
            uint _565 = 10u + buf0_dword_off;
            uint _569 = 11u + buf0_dword_off;
            bool _573 = uintBitsToFloat(ssbo_1_1.data[8u + buf0_dword_off]) > 0.0;
            uint _654;
            uint _655;
            uint _656;
            uint _657;
            uint _658;
            uint _659;
            uint _660;
            if (_573)
            {
                precise float _581 = 4.7123889923095703125 + uintBitsToFloat(_560);
                precise float _582 = trunc(fma(uintBitsToFloat(_560), 0.15915493667125701904296875, 0.75)) * (-6.283185482025146484375);
                precise float _583 = _582 + _581;
                precise float _585 = 6.283185482025146484375 - _583;
                precise float _589 = 0.3183098733425140380859375 * uintBitsToFloat(_490);
                precise float _591 = 0.3183098733425140380859375 * ((3.1415927410125732421875 < _583) ? _585 : _583);
                precise float _597 = uintBitsToFloat(ssbo_1_1.data[_569]) * sqrt(_591);
                precise float _598 = _597 + uintBitsToFloat(ssbo_1_1.data[_253]);
                bool _599 = _248 && (uintBitsToFloat(ssbo_1_1.data[_565]) >= _589);
                uint _610;
                if (_599)
                {
                    precise float _602 = uintBitsToFloat(ssbo_1_1.data[_565]) * uintBitsToFloat(ssbo_1_1.data[_565]);
                    precise float _604 = _589 * (-_589);
                    precise float _605 = _604 + _602;
                    precise float _608 = uintBitsToFloat(ssbo_1_1.data[_565]) - sqrt(_605);
                    _610 = floatBitsToUint(_608);
                }
                else
                {
                    _610 = floatBitsToUint(_589);
                }
                uint _625;
                if (_248 && (!_599))
                {
                    precise float _614 = 1.0 - uintBitsToFloat(ssbo_1_1.data[_565]);
                    precise float _615 = _614 * _614;
                    precise float _617 = (-1.0) + uintBitsToFloat(_610);
                    precise float _619 = _617 * (-_617);
                    precise float _620 = _619 + _615;
                    precise float _623 = uintBitsToFloat(ssbo_1_1.data[_565]) + sqrt(_620);
                    _625 = floatBitsToUint(_623);
                }
                else
                {
                    _625 = _610;
                }
                precise float _634 = uintBitsToFloat(ssbo_1_1.data[_569]) * uintBitsToFloat(_625);
                precise float _635 = _634 + uintBitsToFloat(ssbo_1_1.data[_253]);
                vec4 _640 = textureLod(SPIRV_Cross_Combinedcs_img16cs_sampsgpr_8, vec2(_598, _635), 0.0);
                vec4 _649 = textureLod(SPIRV_Cross_Combinedcs_img24cs_sampsgpr_8, vec2(_598, _635), 0.0);
                _654 = floatBitsToUint(_649.x);
                _655 = floatBitsToUint(_640.y);
                _656 = floatBitsToUint(_640.x);
                _657 = floatBitsToUint(_649.y);
                _658 = srt_flatbuf_1.data[29u];
                _659 = srt_flatbuf_1.data[28u];
                _660 = 1086918619u;
            }
            else
            {
                _654 = _558;
                _655 = floatBitsToUint(_399);
                _656 = _559;
                _657 = _560;
                _658 = ssbo_1_1.data[25u + buf0_dword_off];
                _659 = ssbo_1_1.data[24u + buf0_dword_off];
                _660 = ssbo_1_1.data[28u + buf0_dword_off];
            }
            uint _1099;
            uint _1100;
            uint _1101;
            uint _1102;
            if (!_573)
            {
                precise float _698 = uintBitsToFloat(ssbo_1_1.data[44u + buf0_dword_off]) * _533;
                precise float _700 = uintBitsToFloat(ssbo_1_1.data[40u + buf0_dword_off]) * _533;
                precise float _702 = _537 * uintBitsToFloat(ssbo_1_1.data[45u + buf0_dword_off]);
                precise float _703 = _702 + _698;
                precise float _705 = uintBitsToFloat(ssbo_1_1.data[41u + buf0_dword_off]) * _537;
                precise float _706 = _705 + _700;
                precise float _708 = uintBitsToFloat(ssbo_1_1.data[42u + buf0_dword_off]) * _535;
                precise float _709 = _708 + _706;
                precise float _711 = uintBitsToFloat(ssbo_1_1.data[46u + buf0_dword_off]) * _535;
                precise float _712 = _711 + _703;
                precise float _720 = (1.0 / max(abs(_712), abs(_709))) * min(abs(_712), abs(_709));
                precise float _721 = _720 * _720;
                precise float _725 = fma(fma(fma(fma(0.02083499915897846221923828125, _721, -0.08513300120830535888671875), _721, 0.1801410019397735595703125), _721, -0.3302989900112152099609375), _721, 0.999866008758544921875);
                precise float _726 = _720 * _725;
                precise float _734 = ((abs(_709) < abs(_712)) ? fma(-2.0, _726, 1.57079637050628662109375) : 0.0) + ((0.0 > _709) ? (-3.1415927410125732421875) : 0.0);
                precise float _735 = _725 * _720;
                precise float _736 = _735 + _734;
                float _737 = min(_709, _712);
                float _738 = max(_709, _712);
                precise float _744 = uintBitsToFloat(ssbo_1_1.data[36u + buf0_dword_off]) * _533;
                precise float _746 = _537 * uintBitsToFloat(ssbo_1_1.data[37u + buf0_dword_off]);
                precise float _747 = _746 + _744;
                precise float _749 = uintBitsToFloat(ssbo_1_1.data[38u + buf0_dword_off]) * _535;
                precise float _750 = _749 + _747;
                float _753 = ((_737 < (-_737)) && (_738 >= (-_738))) ? (-_736) : _736;
                precise float _761 = uintBitsToFloat(_659) * sin(6.283185482025146484375 * fract(fma(-_753, 0.15915493667125701904296875, 0.25)));
                float _767 = (abs(_761) < 1.0) ? abs(_761) : (1.0 / abs(_761));
                precise float _768 = _767 * _767;
                precise float _769 = _767 * _768;
                precise float _774 = 4.7123889923095703125 + uintBitsToFloat(_657);
                precise float _778 = 1.0 + (-abs(_750));
                precise float _779 = _778 * _778;
                precise float _783 = _779 * (-0.026516504585742950439453125);
                precise float _784 = _783 + fma(-abs(_750), -0.117851130664348602294921875, -0.117851130664348602294921875);
                precise float _785 = _778 * _779;
                float _786 = sqrt(_778);
                precise float _787 = _769 * fma(0.087292902171611785888671875, _768, -0.3018949925899505615234375);
                precise float _788 = _787 + _767;
                precise float _789 = (-0.000988719053566455841064453125) * _779;
                precise float _790 = _779 * _779;
                precise float _791 = _785 * (-0.0003834455274045467376708984375);
                precise float _792 = _791 + _789;
                precise float _793 = _790 * (-0.00268540973775088787078857421875);
                precise float _794 = _793 + _784;
                precise float _795 = _790 * (-0.00015429117775056511163711547851562);
                precise float _796 = _795 + _792;
                precise float _797 = (-0.00789181701838970184326171875) + _796;
                precise float _798 = (-1.41421353816986083984375) + _794;
                precise float _799 = _797 * _785;
                precise float _800 = _799 + _798;
                precise float _802 = _786 * _800;
                precise float _804 = 0.3183098733425140380859375 * uintBitsToFloat(_490);
                precise float _805 = 0.3183098733425140380859375 * _753;
                uint _806 = floatBitsToUint(_805);
                float _808 = (0.0 >= _750) ? fma(_786, _800, 3.1415927410125732421875) : (-_802);
                precise float _812 = trunc(fma(uintBitsToFloat(_657), 0.15915493667125701904296875, 0.75)) * (-6.283185482025146484375);
                precise float _813 = _812 + _774;
                precise float _814 = 0.3183098733425140380859375 * _813;
                precise float _817 = 0.3183098733425140380859375 * (-_813);
                precise float _818 = _817 + 2.0;
                bool _821 = uintBitsToFloat(_660) <= uintBitsToFloat(_658);
                float _822 = (3.1415927410125732421875 < _813) ? _818 : _814;
                precise float _825 = 0.3183098733425140380859375 * uintBitsToFloat(_490);
                precise float _826 = _825 + (-1.0);
                float _827 = sqrt(_822);
                precise float _830 = (-_826) * _826;
                precise float _832 = 0.3183098733425140380859375 * uintBitsToFloat(_660);
                float _834 = min(0.5, _832);
                precise float _836 = 1.57079637050628662109375 - _788;
                precise float _839 = (-_804) * _804;
                uint _944;
                uint _945;
                if (_821)
                {
                    precise float _843 = uintBitsToFloat(_660) - uintBitsToFloat(_658);
                    float _848 = max(min(0.034906588494777679443359375, _843), min(max(0.034906588494777679443359375, _843), 0.0));
                    float _851 = (abs(_761) < 1.0) ? _788 : _836;
                    precise float _855 = 1.57079637050628662109375 - ((0.0 > _761) ? (-_851) : _851);
                    precise float _859 = 28.6478862762451171875 * (-_848);
                    precise float _860 = _859 + 1.0;
                    precise float _862 = _855 * _860;
                    precise float _864 = _848 * 44.999996185302734375;
                    precise float _865 = _864 + _862;
                    bool _867 = _248 && (_808 <= _865);
                    uint _876;
                    uint _877;
                    if (_867)
                    {
                        precise float _868 = 2.0 * _862;
                        precise float _870 = _848 * 89.99999237060546875;
                        precise float _871 = _870 + _868;
                        float _872 = 1.0 / _871;
                        precise float _874 = _872 * _808;
                        _876 = floatBitsToUint(_874);
                        _877 = floatBitsToUint(_872);
                    }
                    else
                    {
                        _876 = floatBitsToUint(_855);
                        _877 = floatBitsToUint(_860);
                    }
                    uint _894;
                    if (_248 && (!_867))
                    {
                        precise float _882 = 89.99999237060546875 * _848;
                        precise float _886 = fma(-2.0, uintBitsToFloat(_876), 6.283185482025146484375) * uintBitsToFloat(_877);
                        precise float _887 = _886 + _882;
                        precise float _890 = uintBitsToFloat(_877) * fma(-2.0, uintBitsToFloat(_876), 3.1415927410125732421875);
                        precise float _891 = _890 + _808;
                        precise float _892 = (1.0 / _887) * _891;
                        _894 = floatBitsToUint(_892);
                    }
                    else
                    {
                        _894 = _876;
                    }
                    uint _902 = floatBitsToUint(sqrt(uintBitsToFloat(_894)));
                    uint _943;
                    if (_248 && _821)
                    {
                        bool _904 = _248 && (0.25 >= uintBitsToFloat(_894));
                        uint _913;
                        if (_904)
                        {
                            precise float _907 = (-4.0) * uintBitsToFloat(_894);
                            precise float _908 = _907 + 1.0;
                            precise float _909 = 1.0 - _908;
                            precise float _911 = sqrt(_909) * 0.5;
                            _913 = floatBitsToUint(_911);
                        }
                        else
                        {
                            _913 = _902;
                        }
                        bool _915 = _248 && (!_904);
                        uint _942;
                        if (_915)
                        {
                            bool _916 = _915 && (0.5 >= uintBitsToFloat(_894));
                            uint _927;
                            uint _928;
                            if (_916)
                            {
                                precise float _919 = 4.0 * uintBitsToFloat(_894);
                                precise float _920 = _919 + (-1.0);
                                precise float _921 = 1.0 - _920;
                                _927 = floatBitsToUint(fma(-0.300000011920928955078125, sqrt(_921), 0.800000011920928955078125));
                                _928 = 3197737370u;
                            }
                            else
                            {
                                _927 = _913;
                                _928 = _894;
                            }
                            uint _941;
                            if (_915 && (!_916))
                            {
                                precise float _932 = 2.0 * uintBitsToFloat(_928);
                                precise float _933 = _932 + (-2.0);
                                precise float _935 = (-_933) * _933;
                                precise float _936 = _935 + 1.0;
                                _941 = floatBitsToUint(fma(0.199999988079071044921875, sqrt(_936), 0.800000011920928955078125));
                            }
                            else
                            {
                                _941 = _927;
                            }
                            _942 = _941;
                        }
                        else
                        {
                            _942 = _913;
                        }
                        _943 = _942;
                    }
                    else
                    {
                        _943 = _902;
                    }
                    _944 = _943;
                    _945 = floatBitsToUint(_805);
                }
                else
                {
                    _944 = floatBitsToUint(_822);
                    _945 = floatBitsToUint(_834);
                }
                uint _971;
                uint _972;
                if (!_821)
                {
                    bool _946 = _248 && (_804 <= _834);
                    uint _956;
                    uint _957;
                    if (_946)
                    {
                        precise float _949 = uintBitsToFloat(_945) * uintBitsToFloat(_945);
                        precise float _950 = _949 + _839;
                        precise float _953 = uintBitsToFloat(_945) - sqrt(_950);
                        _956 = floatBitsToUint(_953);
                        _957 = floatBitsToUint(_827);
                    }
                    else
                    {
                        _956 = _944;
                        _957 = _945;
                    }
                    uint _969;
                    uint _970;
                    if (_248 && (!_946))
                    {
                        precise float _961 = 1.0 - uintBitsToFloat(_957);
                        precise float _962 = _961 * _961;
                        precise float _963 = _962 + _830;
                        precise float _966 = sqrt(_963) + uintBitsToFloat(_957);
                        _969 = floatBitsToUint(_966);
                        _970 = floatBitsToUint(_827);
                    }
                    else
                    {
                        _969 = _956;
                        _970 = _957;
                    }
                    _971 = _969;
                    _972 = _970;
                }
                else
                {
                    _971 = _944;
                    _972 = _945;
                }
                precise float _974 = 0.3183098733425140380859375 * uintBitsToFloat(ssbo_1_1.data[_504]);
                bool _977 = uintBitsToFloat(ssbo_1_1.data[_504]) <= uintBitsToFloat(_658);
                float _978 = min(0.5, _974);
                uint _1076;
                uint _1077;
                bool _1078;
                if (_977)
                {
                    float _983 = (abs(_761) < 1.0) ? _788 : _836;
                    precise float _987 = uintBitsToFloat(ssbo_1_1.data[_504]) - uintBitsToFloat(_658);
                    precise float _990 = 1.57079637050628662109375 - ((0.0 > _761) ? (-_983) : _983);
                    float _995 = max(min(0.034906588494777679443359375, _987), min(max(0.034906588494777679443359375, _987), 0.0));
                    precise float _997 = 28.6478862762451171875 * (-_995);
                    precise float _998 = _997 + 1.0;
                    precise float _1000 = _990 * _998;
                    precise float _1001 = _995 * 44.999996185302734375;
                    precise float _1002 = _1001 + _1000;
                    bool _1005 = _248 && (_808 <= _1002);
                    uint _1013;
                    uint _1014;
                    if (_1005)
                    {
                        precise float _1006 = 2.0 * _1000;
                        precise float _1007 = _995 * 89.99999237060546875;
                        precise float _1008 = _1007 + _1006;
                        float _1009 = 1.0 / _1008;
                        precise float _1011 = _1009 * _808;
                        _1013 = floatBitsToUint(_1011);
                        _1014 = floatBitsToUint(_1009);
                    }
                    else
                    {
                        _1013 = floatBitsToUint(_990);
                        _1014 = floatBitsToUint(_998);
                    }
                    uint _1031;
                    if (_248 && (!_1005))
                    {
                        precise float _1019 = 89.99999237060546875 * _995;
                        precise float _1023 = fma(-2.0, uintBitsToFloat(_1013), 6.283185482025146484375) * uintBitsToFloat(_1014);
                        precise float _1024 = _1023 + _1019;
                        precise float _1027 = fma(-2.0, uintBitsToFloat(_1013), 3.1415927410125732421875) * uintBitsToFloat(_1014);
                        precise float _1028 = _1027 + _808;
                        precise float _1029 = (1.0 / _1024) * _1028;
                        _1031 = floatBitsToUint(_1029);
                    }
                    else
                    {
                        _1031 = _1013;
                    }
                    bool _1034 = 0.25 >= uintBitsToFloat(_1031);
                    uint _1039 = floatBitsToUint(sqrt(uintBitsToFloat(_1031)));
                    uint _1074;
                    bool _1075;
                    if (_248 && _977)
                    {
                        bool _1040 = _248 && _1034;
                        uint _1048;
                        if (_1040)
                        {
                            precise float _1042 = (-4.0) * uintBitsToFloat(_1031);
                            precise float _1043 = _1042 + 1.0;
                            precise float _1044 = 1.0 - _1043;
                            precise float _1046 = sqrt(_1044) * 0.5;
                            _1048 = floatBitsToUint(_1046);
                        }
                        else
                        {
                            _1048 = _1039;
                        }
                        bool _1050 = _248 && (!_1040);
                        uint _1073;
                        if (_1050)
                        {
                            bool _1051 = _1050 && (0.5 >= uintBitsToFloat(_1031));
                            uint _1059;
                            uint _1060;
                            if (_1051)
                            {
                                precise float _1053 = 4.0 * uintBitsToFloat(_1031);
                                precise float _1054 = _1053 + (-1.0);
                                precise float _1055 = 1.0 - _1054;
                                _1059 = floatBitsToUint(fma(-0.300000011920928955078125, sqrt(_1055), 0.800000011920928955078125));
                                _1060 = 3197737370u;
                            }
                            else
                            {
                                _1059 = _1048;
                                _1060 = _1031;
                            }
                            uint _1072;
                            if (_1050 && (!_1051))
                            {
                                precise float _1064 = 2.0 * uintBitsToFloat(_1060);
                                precise float _1065 = _1064 + (-2.0);
                                precise float _1067 = (-_1065) * _1065;
                                precise float _1068 = _1067 + 1.0;
                                _1072 = floatBitsToUint(fma(0.199999988079071044921875, sqrt(_1068), 0.800000011920928955078125));
                            }
                            else
                            {
                                _1072 = _1059;
                            }
                            _1073 = _1072;
                        }
                        else
                        {
                            _1073 = _1048;
                        }
                        _1074 = _1073;
                        _1075 = _248;
                    }
                    else
                    {
                        _1074 = _1039;
                        _1075 = _1034;
                    }
                    _1076 = _1074;
                    _1077 = floatBitsToUint(_1002);
                    _1078 = _1075;
                }
                else
                {
                    _1076 = _658;
                    _1077 = floatBitsToUint(_827);
                    _1078 = _804 <= _978;
                }
                uint _1097;
                uint _1098;
                if (!_977)
                {
                    bool _1079 = _248 && _1078;
                    uint _1085;
                    uint _1086;
                    if (_1079)
                    {
                        precise float _1080 = _978 * _978;
                        precise float _1081 = _1080 + _839;
                        precise float _1083 = _978 - sqrt(_1081);
                        _1085 = floatBitsToUint(_1083);
                        _1086 = _1077;
                    }
                    else
                    {
                        _1085 = _1076;
                        _1086 = _806;
                    }
                    uint _1095;
                    uint _1096;
                    if (_248 && (!_1079))
                    {
                        precise float _1089 = 1.0 - _978;
                        precise float _1090 = _1089 * _1089;
                        precise float _1091 = _1090 + _830;
                        precise float _1093 = sqrt(_1091) + _978;
                        _1095 = floatBitsToUint(_1093);
                        _1096 = _1077;
                    }
                    else
                    {
                        _1095 = _1085;
                        _1096 = _1086;
                    }
                    _1097 = _1095;
                    _1098 = _1096;
                }
                else
                {
                    _1097 = _1076;
                    _1098 = _806;
                }
                _1099 = _1097;
                _1100 = _1098;
                _1101 = _971;
                _1102 = _972;
            }
            else
            {
                _1099 = _657;
                _1100 = _654;
                _1101 = _655;
                _1102 = _656;
            }
            uint _1127;
            uint _1128;
            uint _1129;
            if (!(uintBitsToFloat(ssbo_1_1.data[_500]) <= 0.0))
            {
                vec4 _1114 = textureLod(SPIRV_Cross_Combinedcs_img0cs_sampsgpr_48, vec3(uintBitsToFloat(_1102), uintBitsToFloat(_1101), roundEven(uintBitsToFloat(ssbo_1_1.data[29u + buf0_dword_off]))), 0.0);
                precise float _1119 = uintBitsToFloat(ssbo_1_1.data[_500]) * _1114.x;
                precise float _1122 = uintBitsToFloat(ssbo_1_1.data[_500]) * _1114.y;
                precise float _1125 = uintBitsToFloat(ssbo_1_1.data[_500]) * _1114.z;
                _1127 = floatBitsToUint(_1119);
                _1128 = floatBitsToUint(_1122);
                _1129 = floatBitsToUint(_1125);
            }
            else
            {
                _1127 = 0u;
                _1128 = 0u;
                _1129 = 0u;
            }
            uint _1159;
            uint _1160;
            uint _1161;
            if (!(_248 && _523))
            {
                vec4 _1140 = textureLod(SPIRV_Cross_Combinedcs_img0cs_sampsgpr_48, vec3(uintBitsToFloat(_1100), uintBitsToFloat(_1099), roundEven(uintBitsToFloat(ssbo_1_1.data[33u + buf0_dword_off]))), 0.0);
                precise float _1146 = uintBitsToFloat(ssbo_1_1.data[_512]) * _1140.z;
                precise float _1147 = _1146 + uintBitsToFloat(_1129);
                precise float _1151 = uintBitsToFloat(ssbo_1_1.data[_512]) * _1140.y;
                precise float _1152 = _1151 + uintBitsToFloat(_1128);
                precise float _1156 = uintBitsToFloat(ssbo_1_1.data[_512]) * _1140.x;
                precise float _1157 = _1156 + uintBitsToFloat(_1127);
                _1159 = floatBitsToUint(_1157);
                _1160 = floatBitsToUint(_1152);
                _1161 = floatBitsToUint(_1147);
            }
            else
            {
                _1159 = _1127;
                _1160 = _1128;
                _1161 = _1129;
            }
            _1162 = _1159;
            _1163 = _1160;
            _1164 = _1161;
        }
        else
        {
            _1162 = 0u;
            _1163 = 0u;
            _1164 = 0u;
        }
        uint _1166 = 48u + buf0_dword_off;
        uint _1799;
        uint _1800;
        uint _1801;
        if (0.0 != uintBitsToFloat(ssbo_1_1.data[_1166]))
        {
            bool _1175 = _248 && (1.0 != uintBitsToFloat(ssbo_1_1.data[_1166]));
            uint _1244;
            uint _1245;
            uint _1246;
            if (_1175)
            {
                uint _1241;
                uint _1242;
                uint _1243;
                if (!(_248 && (2.0 != uintBitsToFloat(ssbo_1_1.data[_1166]))))
                {
                    precise float _1179 = _533 * 2.0;
                    precise float _1180 = _537 * 2.0;
                    precise float _1181 = _535 * 2.0;
                    float _1182 = abs(_533);
                    float _1183 = abs(_537);
                    float _1184 = abs(_535);
                    float _1192 = 1.0 / abs(((_1184 >= _1182) && (_1184 >= _1183)) ? _1181 : ((_1183 >= _1182) ? _1180 : _1179));
                    float _1199 = abs(_533);
                    float _1200 = abs(_537);
                    float _1201 = abs(_535);
                    float _1209 = -_537;
                    float _1212 = abs(_533);
                    float _1213 = abs(_537);
                    float _1214 = abs(_535);
                    vec4 _1228 = textureLod(SPIRV_Cross_Combinedcs_img32cs_sampsgpr_52, vec2(fma(((_1201 >= _1199) && (_1201 >= _1200)) ? ((_535 < 0.0) ? (-_533) : _533) : ((_1200 >= _1199) ? _533 : ((_533 < 0.0) ? _535 : (-_535))), _1192, 1.5), fma(((_1214 >= _1212) && (_1214 >= _1213)) ? _1209 : ((_1213 >= _1212) ? ((_537 < 0.0) ? (-_535) : _535) : _1209), _1192, 1.5)), 0.0);
                    precise float _1233 = _1228.z + uintBitsToFloat(_1164);
                    precise float _1236 = _1228.y + uintBitsToFloat(_1163);
                    precise float _1239 = _1228.x + uintBitsToFloat(_1162);
                    _1241 = floatBitsToUint(_1239);
                    _1242 = floatBitsToUint(_1236);
                    _1243 = floatBitsToUint(_1233);
                }
                else
                {
                    _1241 = _1162;
                    _1242 = _1163;
                    _1243 = _1164;
                }
                _1244 = _1241;
                _1245 = _1242;
                _1246 = _1243;
            }
            else
            {
                _1244 = _1162;
                _1245 = _1163;
                _1246 = _1164;
            }
            uint _1796;
            uint _1797;
            uint _1798;
            if (!_1175)
            {
                uint _1248 = 56u + buf0_dword_off;
                uint _1256 = 58u + buf0_dword_off;
                uint _1260 = 60u + buf0_dword_off;
                uint _1268 = 62u + buf0_dword_off;
                bool _1272 = uintBitsToFloat(ssbo_1_1.data[_1268]) <= 0.0;
                uint _1793;
                uint _1794;
                uint _1795;
                if (!((uintBitsToFloat(ssbo_1_1.data[_1256]) <= 0.0) && _1272))
                {
                    uint _1282 = 53u + buf0_dword_off;
                    precise float _1290 = uintBitsToFloat(ssbo_1_1.data[54u + buf0_dword_off]) + _461;
                    float _1292 = fract(fma(_1290, 0.15915493667125701904296875, 0.25));
                    precise float _1331 = _527 * cos(6.283185482025146484375 * _1292);
                    precise float _1333 = uintBitsToFloat(ssbo_1_1.data[72u + buf0_dword_off]) * _1331;
                    precise float _1337 = uintBitsToFloat(ssbo_1_1.data[68u + buf0_dword_off]) * _1331;
                    precise float _1338 = _527 * sin(6.283185482025146484375 * _1292);
                    precise float _1340 = uintBitsToFloat(ssbo_1_1.data[73u + buf0_dword_off]) * _537;
                    precise float _1341 = _1340 + _1333;
                    precise float _1343 = uintBitsToFloat(ssbo_1_1.data[69u + buf0_dword_off]) * _537;
                    precise float _1344 = _1343 + _1337;
                    precise float _1346 = uintBitsToFloat(ssbo_1_1.data[74u + buf0_dword_off]) * _1338;
                    precise float _1347 = _1346 + _1341;
                    precise float _1349 = uintBitsToFloat(ssbo_1_1.data[64u + buf0_dword_off]) * _1331;
                    precise float _1351 = uintBitsToFloat(ssbo_1_1.data[70u + buf0_dword_off]) * _1338;
                    precise float _1352 = _1351 + _1344;
                    precise float _1360 = uintBitsToFloat(ssbo_1_1.data[65u + buf0_dword_off]) * _537;
                    precise float _1361 = _1360 + _1349;
                    precise float _1366 = (1.0 / max(abs(_1347), abs(_1352))) * min(abs(_1347), abs(_1352));
                    precise float _1367 = _1366 * _1366;
                    precise float _1371 = fma(fma(fma(fma(0.02083499915897846221923828125, _1367, -0.08513300120830535888671875), _1367, 0.1801410019397735595703125), _1367, -0.3302989900112152099609375), _1367, 0.999866008758544921875);
                    precise float _1372 = _1366 * _1371;
                    precise float _1377 = ((abs(_1352) < abs(_1347)) ? fma(-2.0, _1372, 1.57079637050628662109375) : 0.0) + ((0.0 > _1352) ? (-3.1415927410125732421875) : 0.0);
                    precise float _1378 = _1371 * _1366;
                    precise float _1379 = _1378 + _1377;
                    float _1380 = min(_1352, _1347);
                    float _1381 = max(_1352, _1347);
                    precise float _1387 = uintBitsToFloat(ssbo_1_1.data[66u + buf0_dword_off]) * _1338;
                    precise float _1388 = _1387 + _1361;
                    precise float _1391 = 1.0 + (-abs(_1388));
                    precise float _1392 = _1391 * _1391;
                    precise float _1393 = 1.57079637050628662109375 + _1290;
                    float _1396 = ((_1380 < (-_1380)) && (_1381 >= (-_1381))) ? (-_1379) : _1379;
                    precise float _1402 = _1392 * (-0.026516504585742950439453125);
                    precise float _1403 = _1402 + fma(-abs(_1388), -0.117851130664348602294921875, -0.117851130664348602294921875);
                    precise float _1404 = 0.3183098733425140380859375 * _1396;
                    uint _1405 = floatBitsToUint(_1404);
                    precise float _1410 = uintBitsToFloat(ssbo_1_1.data[52u + buf0_dword_off]) * sin(6.283185482025146484375 * fract(fma(-_1396, 0.15915493667125701904296875, 0.25)));
                    float _1416 = (abs(_1410) < 1.0) ? abs(_1410) : (1.0 / abs(_1410));
                    precise float _1417 = _1416 * _1416;
                    precise float _1418 = _1416 * _1417;
                    precise float _1419 = _1392 * _1392;
                    precise float _1421 = _1391 * _1392;
                    float _1422 = sqrt(_1391);
                    precise float _1424 = fma(0.087292902171611785888671875, _1417, -0.3018949925899505615234375) * _1418;
                    precise float _1425 = _1424 + _1416;
                    precise float _1426 = (-0.000988719053566455841064453125) * _1392;
                    precise float _1427 = _1421 * (-0.0003834455274045467376708984375);
                    precise float _1428 = _1427 + _1426;
                    precise float _1429 = _1419 * (-0.00268540973775088787078857421875);
                    precise float _1430 = _1429 + _1403;
                    precise float _1431 = _1419 * (-0.00015429117775056511163711547851562);
                    precise float _1432 = _1431 + _1428;
                    precise float _1433 = (-0.00789181701838970184326171875) + _1432;
                    precise float _1434 = (-1.41421353816986083984375) + _1430;
                    precise float _1435 = _1433 * _1421;
                    precise float _1436 = _1435 + _1434;
                    precise float _1438 = _1422 * _1436;
                    precise float _1440 = 0.3183098733425140380859375 * uintBitsToFloat(_490);
                    precise float _1441 = 1.57079637050628662109375 - _1425;
                    float _1443 = (0.0 >= _1388) ? fma(_1422, _1436, 3.1415927410125732421875) : (-_1438);
                    precise float _1444 = 4.7123889923095703125 + _1393;
                    precise float _1447 = trunc(fma(_1393, 0.15915493667125701904296875, 0.75)) * (-6.283185482025146484375);
                    precise float _1448 = _1447 + _1444;
                    precise float _1450 = 0.3183098733425140380859375 * _1448;
                    precise float _1452 = 0.3183098733425140380859375 * (-_1448);
                    precise float _1453 = _1452 + 2.0;
                    float _1458 = sqrt((3.1415927410125732421875 < _1448) ? _1453 : _1450);
                    precise float _1460 = 0.3183098733425140380859375 * uintBitsToFloat(_490);
                    precise float _1461 = _1460 + (-1.0);
                    precise float _1463 = (-_1461) * _1461;
                    precise float _1465 = 0.3183098733425140380859375 * uintBitsToFloat(ssbo_1_1.data[_1248]);
                    float _1466 = min(0.5, _1465);
                    precise float _1470 = (-_1440) * _1440;
                    bool _1473 = uintBitsToFloat(ssbo_1_1.data[_1248]) <= uintBitsToFloat(ssbo_1_1.data[_1282]);
                    uint _1626;
                    uint _1627;
                    uint _1628;
                    if (!(uintBitsToFloat(ssbo_1_1.data[_1256]) <= 0.0))
                    {
                        bool _1475 = _248 && _1473;
                        uint _1570;
                        uint _1571;
                        if (_1475)
                        {
                            float _1479 = (abs(_1410) < 1.0) ? _1425 : _1441;
                            precise float _1483 = uintBitsToFloat(ssbo_1_1.data[_1248]) - uintBitsToFloat(ssbo_1_1.data[_1282]);
                            precise float _1486 = 1.57079637050628662109375 - ((0.0 > _1410) ? (-_1479) : _1479);
                            float _1491 = max(min(0.034906588494777679443359375, _1483), min(max(0.034906588494777679443359375, _1483), 0.0));
                            precise float _1494 = 28.6478862762451171875 * (-_1491);
                            precise float _1495 = _1494 + 1.0;
                            precise float _1496 = _1486 * _1495;
                            precise float _1497 = _1491 * 44.999996185302734375;
                            precise float _1498 = _1497 + _1496;
                            bool _1500 = _248 && (_1443 <= _1498);
                            uint _1508;
                            uint _1509;
                            if (_1500)
                            {
                                precise float _1501 = 2.0 * _1496;
                                precise float _1502 = _1491 * 89.99999237060546875;
                                precise float _1503 = _1502 + _1501;
                                float _1504 = 1.0 / _1503;
                                precise float _1506 = _1504 * _1443;
                                _1508 = floatBitsToUint(_1506);
                                _1509 = floatBitsToUint(_1504);
                            }
                            else
                            {
                                _1508 = floatBitsToUint(_1491);
                                _1509 = floatBitsToUint(_1486);
                            }
                            uint _1525;
                            if (_248 && (!_1500))
                            {
                                precise float _1515 = 89.99999237060546875 * uintBitsToFloat(_1508);
                                precise float _1518 = fma(-2.0, uintBitsToFloat(_1509), 6.283185482025146484375) * _1495;
                                precise float _1519 = _1518 + _1515;
                                precise float _1520 = _1495 * fma(-2.0, uintBitsToFloat(_1509), 3.1415927410125732421875);
                                precise float _1521 = _1520 + _1443;
                                precise float _1523 = (1.0 / _1519) * _1521;
                                _1525 = floatBitsToUint(_1523);
                            }
                            else
                            {
                                _1525 = _1508;
                            }
                            uint _1533 = floatBitsToUint(sqrt(uintBitsToFloat(_1525)));
                            uint _1569;
                            if (_248 && _1473)
                            {
                                bool _1535 = _248 && (0.25 >= uintBitsToFloat(_1525));
                                uint _1543;
                                if (_1535)
                                {
                                    precise float _1537 = (-4.0) * uintBitsToFloat(_1525);
                                    precise float _1538 = _1537 + 1.0;
                                    precise float _1539 = 1.0 - _1538;
                                    precise float _1541 = sqrt(_1539) * 0.5;
                                    _1543 = floatBitsToUint(_1541);
                                }
                                else
                                {
                                    _1543 = _1533;
                                }
                                bool _1545 = _248 && (!_1535);
                                uint _1568;
                                if (_1545)
                                {
                                    bool _1546 = _1545 && (0.5 >= uintBitsToFloat(_1525));
                                    uint _1554;
                                    uint _1555;
                                    if (_1546)
                                    {
                                        precise float _1548 = 4.0 * uintBitsToFloat(_1525);
                                        precise float _1549 = _1548 + (-1.0);
                                        precise float _1550 = 1.0 - _1549;
                                        _1554 = floatBitsToUint(fma(-0.300000011920928955078125, sqrt(_1550), 0.800000011920928955078125));
                                        _1555 = 3197737370u;
                                    }
                                    else
                                    {
                                        _1554 = _1543;
                                        _1555 = _1525;
                                    }
                                    uint _1567;
                                    if (_1545 && (!_1546))
                                    {
                                        precise float _1559 = 2.0 * uintBitsToFloat(_1555);
                                        precise float _1560 = _1559 + (-2.0);
                                        precise float _1562 = (-_1560) * _1560;
                                        precise float _1563 = _1562 + 1.0;
                                        _1567 = floatBitsToUint(fma(0.199999988079071044921875, sqrt(_1563), 0.800000011920928955078125));
                                    }
                                    else
                                    {
                                        _1567 = _1554;
                                    }
                                    _1568 = _1567;
                                }
                                else
                                {
                                    _1568 = _1543;
                                }
                                _1569 = _1568;
                            }
                            else
                            {
                                _1569 = _1533;
                            }
                            _1570 = _1569;
                            _1571 = floatBitsToUint(_1404);
                        }
                        else
                        {
                            _1570 = floatBitsToUint(_1453);
                            _1571 = floatBitsToUint(_1466);
                        }
                        uint _1597;
                        uint _1598;
                        if (!_1475)
                        {
                            bool _1572 = _248 && (_1440 <= _1466);
                            uint _1582;
                            uint _1583;
                            if (_1572)
                            {
                                precise float _1575 = uintBitsToFloat(_1571) * uintBitsToFloat(_1571);
                                precise float _1576 = _1575 + _1470;
                                precise float _1579 = uintBitsToFloat(_1571) - sqrt(_1576);
                                _1582 = floatBitsToUint(_1579);
                                _1583 = floatBitsToUint(_1458);
                            }
                            else
                            {
                                _1582 = _1570;
                                _1583 = _1571;
                            }
                            uint _1595;
                            uint _1596;
                            if (_248 && (!_1572))
                            {
                                precise float _1587 = 1.0 - uintBitsToFloat(_1583);
                                precise float _1588 = _1587 * _1587;
                                precise float _1589 = _1588 + _1463;
                                precise float _1592 = sqrt(_1589) + uintBitsToFloat(_1583);
                                _1595 = floatBitsToUint(_1592);
                                _1596 = floatBitsToUint(_1458);
                            }
                            else
                            {
                                _1595 = _1582;
                                _1596 = _1583;
                            }
                            _1597 = _1596;
                            _1598 = _1595;
                        }
                        else
                        {
                            _1597 = _1571;
                            _1598 = _1570;
                        }
                        vec4 _1607 = textureLod(SPIRV_Cross_Combinedcs_img0cs_sampsgpr_48, vec3(uintBitsToFloat(_1597), uintBitsToFloat(_1598), roundEven(uintBitsToFloat(ssbo_1_1.data[57u + buf0_dword_off]))), 0.0);
                        precise float _1613 = uintBitsToFloat(ssbo_1_1.data[_1256]) * _1607.x;
                        precise float _1614 = _1613 + uintBitsToFloat(_1244);
                        precise float _1618 = uintBitsToFloat(ssbo_1_1.data[_1256]) * _1607.z;
                        precise float _1619 = _1618 + uintBitsToFloat(_1246);
                        precise float _1623 = uintBitsToFloat(ssbo_1_1.data[_1256]) * _1607.y;
                        precise float _1624 = _1623 + uintBitsToFloat(_1245);
                        _1626 = floatBitsToUint(_1614);
                        _1627 = floatBitsToUint(_1624);
                        _1628 = floatBitsToUint(_1619);
                    }
                    else
                    {
                        _1626 = _1244;
                        _1627 = _1245;
                        _1628 = _1246;
                    }
                    precise float _1630 = 0.3183098733425140380859375 * uintBitsToFloat(ssbo_1_1.data[_1260]);
                    float _1631 = min(0.5, _1630);
                    bool _1637 = uintBitsToFloat(ssbo_1_1.data[_1260]) <= uintBitsToFloat(ssbo_1_1.data[_1282]);
                    uint _1790;
                    uint _1791;
                    uint _1792;
                    if (!(_248 && _1272))
                    {
                        bool _1639 = _248 && _1637;
                        uint _1734;
                        bool _1735;
                        if (_1639)
                        {
                            float _1643 = (abs(_1410) < 1.0) ? _1425 : _1441;
                            precise float _1647 = uintBitsToFloat(ssbo_1_1.data[_1260]) - uintBitsToFloat(ssbo_1_1.data[_1282]);
                            precise float _1650 = 1.57079637050628662109375 - ((0.0 > _1410) ? (-_1643) : _1643);
                            float _1655 = max(min(0.034906588494777679443359375, _1647), min(max(0.034906588494777679443359375, _1647), 0.0));
                            precise float _1657 = 28.6478862762451171875 * (-_1655);
                            precise float _1658 = _1657 + 1.0;
                            precise float _1660 = _1650 * _1658;
                            precise float _1661 = _1655 * 44.999996185302734375;
                            precise float _1662 = _1661 + _1660;
                            bool _1664 = _248 && (_1443 <= _1662);
                            uint _1672;
                            uint _1673;
                            if (_1664)
                            {
                                precise float _1665 = 2.0 * _1660;
                                precise float _1666 = _1655 * 89.99999237060546875;
                                precise float _1667 = _1666 + _1665;
                                float _1668 = 1.0 / _1667;
                                precise float _1670 = _1668 * _1443;
                                _1672 = floatBitsToUint(_1670);
                                _1673 = floatBitsToUint(_1668);
                            }
                            else
                            {
                                _1672 = floatBitsToUint(_1650);
                                _1673 = floatBitsToUint(_1658);
                            }
                            uint _1690;
                            if (_248 && (!_1664))
                            {
                                precise float _1678 = 89.99999237060546875 * _1655;
                                precise float _1682 = fma(-2.0, uintBitsToFloat(_1672), 6.283185482025146484375) * uintBitsToFloat(_1673);
                                precise float _1683 = _1682 + _1678;
                                precise float _1686 = fma(-2.0, uintBitsToFloat(_1672), 3.1415927410125732421875) * uintBitsToFloat(_1673);
                                precise float _1687 = _1686 + _1443;
                                precise float _1688 = (1.0 / _1683) * _1687;
                                _1690 = floatBitsToUint(_1688);
                            }
                            else
                            {
                                _1690 = _1672;
                            }
                            bool _1695 = 0.5 >= uintBitsToFloat(_1690);
                            uint _1698 = floatBitsToUint(sqrt(uintBitsToFloat(_1690)));
                            uint _1733;
                            if (_248 && _1637)
                            {
                                bool _1699 = _248 && (0.25 >= uintBitsToFloat(_1690));
                                uint _1707;
                                if (_1699)
                                {
                                    precise float _1701 = (-4.0) * uintBitsToFloat(_1690);
                                    precise float _1702 = _1701 + 1.0;
                                    precise float _1703 = 1.0 - _1702;
                                    precise float _1705 = sqrt(_1703) * 0.5;
                                    _1707 = floatBitsToUint(_1705);
                                }
                                else
                                {
                                    _1707 = _1698;
                                }
                                bool _1709 = _248 && (!_1699);
                                uint _1732;
                                if (_1709)
                                {
                                    bool _1710 = _1709 && _1695;
                                    uint _1718;
                                    uint _1719;
                                    if (_1710)
                                    {
                                        precise float _1712 = 4.0 * uintBitsToFloat(_1690);
                                        precise float _1713 = _1712 + (-1.0);
                                        precise float _1714 = 1.0 - _1713;
                                        _1718 = floatBitsToUint(fma(-0.300000011920928955078125, sqrt(_1714), 0.800000011920928955078125));
                                        _1719 = 3197737370u;
                                    }
                                    else
                                    {
                                        _1718 = _1707;
                                        _1719 = _1690;
                                    }
                                    uint _1731;
                                    if (_1709 && (!_1710))
                                    {
                                        precise float _1723 = 2.0 * uintBitsToFloat(_1719);
                                        precise float _1724 = _1723 + (-2.0);
                                        precise float _1726 = (-_1724) * _1724;
                                        precise float _1727 = _1726 + 1.0;
                                        _1731 = floatBitsToUint(fma(0.199999988079071044921875, sqrt(_1727), 0.800000011920928955078125));
                                    }
                                    else
                                    {
                                        _1731 = _1718;
                                    }
                                    _1732 = _1731;
                                }
                                else
                                {
                                    _1732 = _1707;
                                }
                                _1733 = _1732;
                            }
                            else
                            {
                                _1733 = _1698;
                            }
                            _1734 = _1733;
                            _1735 = _1695;
                        }
                        else
                        {
                            _1734 = floatBitsToUint(_1631);
                            _1735 = _1440 <= _1631;
                        }
                        uint _1761;
                        uint _1762;
                        if (!_1639)
                        {
                            bool _1736 = _248 && _1735;
                            uint _1746;
                            uint _1747;
                            if (_1736)
                            {
                                precise float _1739 = uintBitsToFloat(_1734) * uintBitsToFloat(_1734);
                                precise float _1740 = _1739 + _1470;
                                precise float _1743 = uintBitsToFloat(_1734) - sqrt(_1740);
                                _1746 = floatBitsToUint(_1458);
                                _1747 = floatBitsToUint(_1743);
                            }
                            else
                            {
                                _1746 = _1405;
                                _1747 = _1734;
                            }
                            uint _1759;
                            uint _1760;
                            if (_248 && (!_1736))
                            {
                                precise float _1751 = 1.0 - uintBitsToFloat(_1747);
                                precise float _1752 = _1751 * _1751;
                                precise float _1753 = _1752 + _1463;
                                precise float _1756 = sqrt(_1753) + uintBitsToFloat(_1747);
                                _1759 = floatBitsToUint(_1756);
                                _1760 = floatBitsToUint(_1458);
                            }
                            else
                            {
                                _1759 = _1747;
                                _1760 = _1746;
                            }
                            _1761 = _1760;
                            _1762 = _1759;
                        }
                        else
                        {
                            _1761 = _1405;
                            _1762 = _1734;
                        }
                        vec4 _1771 = textureLod(SPIRV_Cross_Combinedcs_img0cs_sampsgpr_48, vec3(uintBitsToFloat(_1761), uintBitsToFloat(_1762), roundEven(uintBitsToFloat(ssbo_1_1.data[61u + buf0_dword_off]))), 0.0);
                        precise float _1777 = uintBitsToFloat(ssbo_1_1.data[_1268]) * _1771.z;
                        precise float _1778 = _1777 + uintBitsToFloat(_1628);
                        precise float _1782 = uintBitsToFloat(ssbo_1_1.data[_1268]) * _1771.y;
                        precise float _1783 = _1782 + uintBitsToFloat(_1627);
                        precise float _1787 = uintBitsToFloat(ssbo_1_1.data[_1268]) * _1771.x;
                        precise float _1788 = _1787 + uintBitsToFloat(_1626);
                        _1790 = floatBitsToUint(_1788);
                        _1791 = floatBitsToUint(_1783);
                        _1792 = floatBitsToUint(_1778);
                    }
                    else
                    {
                        _1790 = _1626;
                        _1791 = _1627;
                        _1792 = _1628;
                    }
                    _1793 = _1790;
                    _1794 = _1791;
                    _1795 = _1792;
                }
                else
                {
                    _1793 = _1244;
                    _1794 = _1245;
                    _1795 = _1246;
                }
                _1796 = _1793;
                _1797 = _1794;
                _1798 = _1795;
            }
            else
            {
                _1796 = _1244;
                _1797 = _1245;
                _1798 = _1246;
            }
            _1799 = _1796;
            _1800 = _1797;
            _1801 = _1798;
        }
        else
        {
            _1799 = _1162;
            _1800 = _1163;
            _1801 = _1164;
        }
        uint _1821;
        uint _1822;
        uint _1823;
        if (0u != ssbo_1_1.data[78u + buf0_dword_off])
        {
            uint _1809 = (subgroupBroadcastFirst(_270) * 12u) >> 2u;
            _1821 = ssbo_2_1.data[(_1809 + 2u) + buf1_dword_off];
            _1822 = ssbo_2_1.data[(_1809 + 1u) + buf1_dword_off];
            _1823 = ssbo_2_1.data[_1809 + buf1_dword_off];
        }
        else
        {
            _1821 = _1801;
            _1822 = _1800;
            _1823 = _1799;
        }
        bool _1829 = (0u != ssbo_1_1.data[80u + buf0_dword_off]) ? _248 : false;
        vec4 _1836 = vec4(_1829 ? 1.0 : uintBitsToFloat(_1823), _1829 ? 1.0 : uintBitsToFloat(_1822), _1829 ? 1.0 : uintBitsToFloat(_1821), 1.0);
        imageStore(cs_img40, ivec3(uvec3(_237, _238, _270)), vec4(_1836.x, _1836.y, _1836.z, vec4(0.0, 1.0, 0.0, 0.0).x));
    }
}

