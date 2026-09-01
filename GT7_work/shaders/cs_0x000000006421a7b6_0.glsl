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
#elif defined(GL_ARB_shader_ballot) && defined(GL_ARB_shader_int64)
#extension GL_ARB_shader_int64 : enable
#extension GL_ARB_shader_ballot : require
#elif defined(GL_NV_shader_thread_shuffle)
#extension GL_NV_shader_thread_shuffle : require
#else
#error No extensions available to emulate requested subgroup feature.
#endif

#if defined(GL_KHR_shader_subgroup_ballot)
#extension GL_KHR_shader_subgroup_ballot : require
#elif defined(GL_NV_shader_thread_group)
#extension GL_NV_shader_thread_group : require
#endif

#if defined(GL_KHR_shader_subgroup_ballot)
#extension GL_KHR_shader_subgroup_ballot : require
#elif defined(GL_NV_shader_thread_group)
#extension GL_NV_shader_thread_group : require
#elif defined(GL_ARB_shader_ballot) && defined(GL_ARB_shader_int64)
#extension GL_ARB_shader_int64 : enable
#extension GL_ARB_shader_ballot : require
#else
#error No extensions available to emulate requested subgroup feature.
#endif
layout(local_size_x = 64, local_size_y = 1, local_size_z = 1) in;

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

uint _134;
uint _135;

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

layout(binding = 4, std430) readonly buffer ssbo_5
{
    uint data[];
} ssbo_5_1;

layout(binding = 5, std430) buffer ssbo_6
{
    uint data[];
} ssbo_6_1;

layout(binding = 6, std430) buffer ssbo_7
{
    uint data[];
} ssbo_7_1;

layout(binding = 7, std430) readonly buffer srt_flatbuf
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

#if defined(GL_KHR_shader_subgroup_ballot)
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
#endif

#if defined(GL_KHR_shader_subgroup_ballot)
#elif defined(GL_NV_shader_thread_group)
uint subgroupBallotFindLSB(uvec4 value) { return findLSB(value.x); }
uint subgroupBallotFindMSB(uvec4 value) { return findMSB(value.x); }
#else
uint subgroupBallotFindLSB(uvec4 value)
{
    int firstLive = findLSB(value.x);
    return uint(firstLive != -1 ? firstLive : (findLSB(value.y) + 32));
}
uint subgroupBallotFindMSB(uvec4 value)
{
    int firstLive = findMSB(value.y);
    return uint(firstLive != -1 ? (firstLive + 32) : findMSB(value.x));
}
#endif

#if defined(GL_KHR_shader_subgroup_ballot)
#elif defined(GL_NV_shader_thread_group)
uvec4 subgroupBallot(bool v) { return uvec4(ballotThreadNV(v), 0u, 0u, 0u); }
#elif defined(GL_ARB_shader_ballot)
uvec4 subgroupBallot(bool v) { return uvec4(unpackUint2x32(ballotARB(v)), 0u, 0u); }
#endif

void main()
{
    uint buf0_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(0u), int(8u)) >> 2u;
    uint buf2_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(16u), int(8u)) >> 2u;
    uint buf5_dword_off = bitfieldExtract(push_data.buf_offsets0.y, int(8u), int(8u)) >> 2u;
    uint buf6_dword_off = bitfieldExtract(push_data.buf_offsets0.y, int(16u), int(8u)) >> 2u;
    uint _189 = srt_flatbuf_1.data[90u];
    uint _190 = (gl_WorkGroupID.x << 6u) + gl_LocalInvocationID.x;
    bool _191 = _189 > _190;
    if (_191)
    {
        uint _202 = srt_flatbuf_1.data[88u] * _190;
        uint _208 = (_202 + 12u) + buf0_dword_off;
        uint _212 = (_202 + 13u) + buf0_dword_off;
        uint _216 = (_202 + 14u) + buf0_dword_off;
        uint _219 = _190 + (bitfieldExtract(push_data.buf_offsets0.x, int(8u), int(8u)) >> 2u);
        uint _221 = ssbo_2_1.data[_219];
        bool _222 = int(srt_flatbuf_1.data[73u]) >= int(0u);
        uint _234;
        uint _235;
        if (_222)
        {
            uint _231 = ssbo_3_1.data[((_221 * 32u) + 24u) + buf2_dword_off] + 4294967295u;
            _234 = uint(min(int(srt_flatbuf_1.data[73u]), int(_231)));
            _235 = _231;
        }
        else
        {
            _234 = _135;
            _235 = _202 + 14u;
        }
        uint _523;
        uint _524;
        uint _525;
        if (!_222)
        {
            bool _241 = 0u != srt_flatbuf_1.data[91u];
            uint _249;
            if (_241)
            {
                _249 = ssbo_4_1.data[((_190 * 255u) >> 2u) + (bitfieldExtract(push_data.buf_offsets0.x, int(24u), int(8u)) >> 2u)];
            }
            else
            {
                _249 = _235;
            }
            uint _256;
            if (!_241)
            {
                _256 = ssbo_3_1.data[((_221 * 32u) + 25u) + buf2_dword_off];
            }
            else
            {
                _256 = _249;
            }
            uint _309 = ((_221 * 32u) + 26u) + buf2_dword_off;
            precise float _315 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(ssbo_1_1.data[_208]);
            precise float _316 = _315 + uintBitsToFloat(srt_flatbuf_1.data[50u]);
            bool _317 = 0u != srt_flatbuf_1.data[24u];
            precise float _320 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(ssbo_1_1.data[_212]);
            precise float _321 = _320 + _316;
            precise float _324 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(ssbo_1_1.data[_216]);
            precise float _325 = _324 + _321;
            uint _389;
            uint _390;
            uint _391;
            if (_317)
            {
                precise float _331 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(ssbo_1_1.data[_208]);
                precise float _332 = _331 + uintBitsToFloat(srt_flatbuf_1.data[48u]);
                precise float _335 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(ssbo_1_1.data[_212]);
                precise float _336 = _335 + _332;
                precise float _340 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(ssbo_1_1.data[_208]);
                precise float _341 = _340 + uintBitsToFloat(srt_flatbuf_1.data[49u]);
                precise float _344 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(ssbo_1_1.data[_216]);
                precise float _345 = _344 + _336;
                precise float _348 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(ssbo_1_1.data[_212]);
                precise float _349 = _348 + _341;
                precise float _350 = _345 * _345;
                precise float _353 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(ssbo_1_1.data[_216]);
                precise float _354 = _353 + _349;
                precise float _355 = _354 * _354;
                precise float _356 = _355 + _350;
                precise float _363 = _325 * _325;
                precise float _364 = _363 + _356;
                precise float _368 = sqrt(_364) - uintBitsToFloat(ssbo_3_1.data[_309]);
                precise float _372 = (-uintBitsToFloat(srt_flatbuf_1.data[26u])) * _368;
                precise float _373 = _372 + uintBitsToFloat(srt_flatbuf_1.data[27u]);
                uint _388;
                if (_191 && (_373 > 0.0))
                {
                    precise float _384 = uintBitsToFloat(srt_flatbuf_1.data[25u]) * (1.0 / _373);
                    _388 = floatBitsToUint(min(3.0000000054977557577780399428115e+38, _384));
                }
                else
                {
                    _388 = 2137108966u;
                }
                _389 = floatBitsToUint(_364);
                _390 = floatBitsToUint(_373);
                _391 = _388;
            }
            else
            {
                _389 = _234;
                _390 = floatBitsToUint(_325);
                _391 = ssbo_3_1.data[_309];
            }
            uint _415;
            if (!_317)
            {
                precise float _394 = uintBitsToFloat(_391) + uintBitsToFloat(_390);
                precise float _402 = uintBitsToFloat(srt_flatbuf_1.data[26u]) * _394;
                precise float _403 = _402 + uintBitsToFloat(srt_flatbuf_1.data[27u]);
                uint _414;
                if (_191 && (_403 > 0.0))
                {
                    precise float _411 = uintBitsToFloat(srt_flatbuf_1.data[25u]) * (1.0 / _403);
                    _414 = floatBitsToUint(min(3.0000000054977557577780399428115e+38, _411));
                }
                else
                {
                    _414 = 2137108966u;
                }
                _415 = _414;
            }
            else
            {
                _415 = _391;
            }
            precise float _418 = uintBitsToFloat(_415) * uintBitsToFloat(_256);
            bool _424 = srt_flatbuf_1.data[72u] > 0u;
            uint _469;
            if (_424)
            {
                uint _432 = min(srt_flatbuf_1.data[72u], ssbo_3_1.data[((_221 * 32u) + 24u) + buf2_dword_off]) + 4294967295u;
                uint _465;
                bool _467;
                uint _468;
                uint _433 = _389;
                uint _434 = 0u;
                bool _435 = _191;
                for (;;)
                {
                    if (!_435)
                    {
                        _468 = _433;
                        break;
                    }
                    else
                    {
                        bool _438 = _435 && (_434 < _432);
                        if (!_438)
                        {
                            _468 = _432;
                            break;
                        }
                        else
                        {
                            _465 = _434 + 1u;
                            _467 = _438 && (!(uintBitsToFloat((_434 == 3u) ? srt_flatbuf_1.data[71u] : ((_434 == 2u) ? srt_flatbuf_1.data[70u] : ((_434 == 1u) ? srt_flatbuf_1.data[69u] : srt_flatbuf_1.data[68u]))) <= _418));
                            if (_467)
                            {
                                _433 = _434;
                                _434 = _465;
                                _435 = _467;
                                continue;
                            }
                            else
                            {
                                _468 = _434;
                                break;
                            }
                        }
                    }
                }
                _469 = _468;
            }
            else
            {
                _469 = _389;
            }
            uint _522;
            if (!_424)
            {
                uint _475 = ssbo_3_1.data[((_221 * 32u) + 24u) + buf2_dword_off] + 4294967295u;
                uint _509;
                bool _519;
                uint _521;
                uint _476 = _469;
                uint _477 = 0u;
                bool _478 = _191;
                for (;;)
                {
                    if (!_478)
                    {
                        _521 = _476;
                        break;
                    }
                    else
                    {
                        bool _481 = _478 && (_477 < _475);
                        if (!_481)
                        {
                            _521 = _475;
                            break;
                        }
                        else
                        {
                            uint _486 = ((_221 * 32u) + 28u) + buf2_dword_off;
                            uvec4 _498 = uvec4(ssbo_3_1.data[_486], ssbo_3_1.data[_486 + 1u], ssbo_3_1.data[_486 + 2u], ssbo_3_1.data[_486 + 3u]);
                            _509 = _477 + 1u;
                            _519 = _481 && (!((((3u == _477) ? _481 : false) ? uintBitsToFloat(_498.w) : (((2u == _477) ? _481 : false) ? uintBitsToFloat(_498.z) : (((1u == _477) ? _481 : false) ? uintBitsToFloat(_498.y) : uintBitsToFloat(_498.x)))) <= _418));
                            if (!_519)
                            {
                                _521 = _477;
                                break;
                            }
                            else
                            {
                                if (true)
                                {
                                    _476 = _477;
                                    _477 = _509;
                                    _478 = _519;
                                    continue;
                                }
                                else
                                {
                                    _521 = _477;
                                    break;
                                }
                            }
                        }
                    }
                }
                _522 = _521;
            }
            else
            {
                _522 = _469;
            }
            _523 = srt_flatbuf_1.data[41u];
            _524 = srt_flatbuf_1.data[40u];
            _525 = _522;
        }
        else
        {
            _523 = _134;
            _524 = srt_flatbuf_1.data[73u];
            _525 = _234;
        }
        uint _533 = ssbo_5_1.data[_221 + (bitfieldExtract(push_data.buf_offsets0.y, int(0u), int(8u)) >> 2u)];
        uint _535 = _533 + _525;
        uint _1773;
        uint _1774;
        uint _1775;
        if (0u != srt_flatbuf_1.data[75u])
        {
            uint _539 = _202 + buf0_dword_off;
            uint _543 = (_202 + 8u) + buf0_dword_off;
            uint _547 = (_202 + 9u) + buf0_dword_off;
            uint _551 = (_202 + 10u) + buf0_dword_off;
            uint _558 = (_202 + 4u) + buf0_dword_off;
            uint _562 = (_202 + 6u) + buf0_dword_off;
            uint _566 = (_202 + 3u) + buf0_dword_off;
            uint _574 = (_202 + 5u) + buf0_dword_off;
            uint _578 = (_202 + 2u) + buf0_dword_off;
            uint _582 = (_202 + 15u) + buf0_dword_off;
            uint _589 = (_202 + 1u) + buf0_dword_off;
            uint _593 = (_202 + 7u) + buf0_dword_off;
            uint _598 = (_202 + 11u) + buf0_dword_off;
            uint _647 = (_221 * 32u) + buf2_dword_off;
            uvec3 _656 = uvec3(ssbo_3_1.data[_647], ssbo_3_1.data[_647 + 1u], ssbo_3_1.data[_647 + 2u]);
            uint _657 = _656.x;
            uint _658 = _656.y;
            uint _659 = _656.z;
            precise float _663 = uintBitsToFloat(ssbo_1_1.data[_539]) * uintBitsToFloat(_657);
            precise float _664 = _663 + uintBitsToFloat(ssbo_1_1.data[_208]);
            precise float _668 = uintBitsToFloat(ssbo_1_1.data[_589]) * uintBitsToFloat(_657);
            precise float _669 = _668 + uintBitsToFloat(ssbo_1_1.data[_212]);
            precise float _672 = uintBitsToFloat(_658) * uintBitsToFloat(ssbo_1_1.data[_558]);
            precise float _673 = _672 + _664;
            precise float _677 = uintBitsToFloat(ssbo_1_1.data[_578]) * uintBitsToFloat(_657);
            precise float _678 = _677 + uintBitsToFloat(ssbo_1_1.data[_216]);
            precise float _681 = uintBitsToFloat(_659) * uintBitsToFloat(ssbo_1_1.data[_543]);
            precise float _682 = _681 + _673;
            precise float _685 = uintBitsToFloat(_658) * uintBitsToFloat(ssbo_1_1.data[_574]);
            precise float _686 = _685 + _669;
            precise float _688 = uintBitsToFloat(srt_flatbuf_1.data[52u]) * _682;
            precise float _692 = uintBitsToFloat(ssbo_1_1.data[_566]) * uintBitsToFloat(_657);
            precise float _693 = _692 + uintBitsToFloat(ssbo_1_1.data[_582]);
            precise float _695 = uintBitsToFloat(srt_flatbuf_1.data[55u]) * _682;
            precise float _698 = uintBitsToFloat(_659) * uintBitsToFloat(ssbo_1_1.data[_547]);
            precise float _699 = _698 + _686;
            precise float _702 = uintBitsToFloat(_658) * uintBitsToFloat(ssbo_1_1.data[_562]);
            precise float _703 = _702 + _678;
            precise float _705 = uintBitsToFloat(srt_flatbuf_1.data[53u]) * _682;
            precise float _707 = uintBitsToFloat(srt_flatbuf_1.data[56u]) * _699;
            precise float _708 = _707 + _688;
            precise float _711 = uintBitsToFloat(_659) * uintBitsToFloat(ssbo_1_1.data[_551]);
            precise float _712 = _711 + _703;
            precise float _715 = uintBitsToFloat(_658) * uintBitsToFloat(ssbo_1_1.data[_593]);
            precise float _716 = _715 + _693;
            precise float _718 = uintBitsToFloat(srt_flatbuf_1.data[59u]) * _699;
            precise float _719 = _718 + _695;
            precise float _721 = uintBitsToFloat(srt_flatbuf_1.data[60u]) * _712;
            precise float _722 = _721 + _708;
            precise float _725 = uintBitsToFloat(_659) * uintBitsToFloat(ssbo_1_1.data[_598]);
            precise float _726 = _725 + _716;
            precise float _728 = uintBitsToFloat(srt_flatbuf_1.data[54u]) * _682;
            precise float _730 = uintBitsToFloat(srt_flatbuf_1.data[63u]) * _712;
            precise float _731 = _730 + _719;
            precise float _733 = uintBitsToFloat(srt_flatbuf_1.data[57u]) * _699;
            precise float _734 = _733 + _705;
            precise float _736 = uintBitsToFloat(srt_flatbuf_1.data[64u]) * _726;
            precise float _737 = _736 + _722;
            precise float _739 = uintBitsToFloat(srt_flatbuf_1.data[67u]) * _726;
            precise float _740 = _739 + _731;
            precise float _742 = uintBitsToFloat(srt_flatbuf_1.data[61u]) * _712;
            precise float _743 = _742 + _734;
            precise float _745 = uintBitsToFloat(srt_flatbuf_1.data[58u]) * _699;
            precise float _746 = _745 + _728;
            precise float _750 = uintBitsToFloat(srt_flatbuf_1.data[65u]) * _726;
            precise float _751 = _750 + _743;
            precise float _753 = uintBitsToFloat(srt_flatbuf_1.data[62u]) * _712;
            precise float _754 = _753 + _746;
            precise float _756 = uintBitsToFloat(srt_flatbuf_1.data[66u]) * _726;
            precise float _757 = _756 + _754;
            uint _787 = srt_flatbuf_1.data[75u] & (((((floatBitsToUint((_740 < (-_737)) ? 1.4012984643248170709237295832899e-45 : 0.0) | floatBitsToUint((_740 < (-_751)) ? 2.8025969286496341418474591665798e-45 : 0.0)) | floatBitsToUint((0.0 > _757) ? 5.6051938572992682836949183331597e-45 : 0.0)) | floatBitsToUint((_740 < _737) ? 1.1210387714598536567389836666319e-44 : 0.0)) | floatBitsToUint((_740 < _751) ? 2.2420775429197073134779673332639e-44 : 0.0)) | floatBitsToUint((_740 < _757) ? 4.4841550858394146269559346665277e-44 : 0.0));
            bool _789 = _191 && (0u != _787);
            uint _1772;
            if (_789)
            {
                uint _792 = ((_221 * 32u) + 3u) + buf2_dword_off;
                uvec3 _801 = uvec3(ssbo_3_1.data[_792], ssbo_3_1.data[_792 + 1u], ssbo_3_1.data[_792 + 2u]);
                uint _802 = _801.x;
                uint _803 = _801.y;
                uint _804 = _801.z;
                precise float _808 = uintBitsToFloat(ssbo_1_1.data[_539]) * uintBitsToFloat(_802);
                precise float _809 = _808 + uintBitsToFloat(ssbo_1_1.data[_208]);
                precise float _813 = uintBitsToFloat(ssbo_1_1.data[_589]) * uintBitsToFloat(_802);
                precise float _814 = _813 + uintBitsToFloat(ssbo_1_1.data[_212]);
                precise float _817 = uintBitsToFloat(_803) * uintBitsToFloat(ssbo_1_1.data[_558]);
                precise float _818 = _817 + _809;
                precise float _822 = uintBitsToFloat(ssbo_1_1.data[_578]) * uintBitsToFloat(_802);
                precise float _823 = _822 + uintBitsToFloat(ssbo_1_1.data[_216]);
                precise float _826 = uintBitsToFloat(_804) * uintBitsToFloat(ssbo_1_1.data[_543]);
                precise float _827 = _826 + _818;
                precise float _830 = uintBitsToFloat(_803) * uintBitsToFloat(ssbo_1_1.data[_574]);
                precise float _831 = _830 + _814;
                precise float _833 = uintBitsToFloat(srt_flatbuf_1.data[52u]) * _827;
                precise float _837 = uintBitsToFloat(ssbo_1_1.data[_566]) * uintBitsToFloat(_802);
                precise float _838 = _837 + uintBitsToFloat(ssbo_1_1.data[_582]);
                precise float _840 = uintBitsToFloat(srt_flatbuf_1.data[55u]) * _827;
                precise float _843 = uintBitsToFloat(_804) * uintBitsToFloat(ssbo_1_1.data[_547]);
                precise float _844 = _843 + _831;
                precise float _847 = uintBitsToFloat(_803) * uintBitsToFloat(ssbo_1_1.data[_562]);
                precise float _848 = _847 + _823;
                precise float _850 = uintBitsToFloat(srt_flatbuf_1.data[53u]) * _827;
                precise float _852 = uintBitsToFloat(srt_flatbuf_1.data[56u]) * _844;
                precise float _853 = _852 + _833;
                precise float _856 = uintBitsToFloat(_804) * uintBitsToFloat(ssbo_1_1.data[_551]);
                precise float _857 = _856 + _848;
                precise float _860 = uintBitsToFloat(_803) * uintBitsToFloat(ssbo_1_1.data[_593]);
                precise float _861 = _860 + _838;
                precise float _863 = uintBitsToFloat(srt_flatbuf_1.data[59u]) * _844;
                precise float _864 = _863 + _840;
                precise float _866 = uintBitsToFloat(srt_flatbuf_1.data[60u]) * _857;
                precise float _867 = _866 + _853;
                precise float _870 = uintBitsToFloat(_804) * uintBitsToFloat(ssbo_1_1.data[_598]);
                precise float _871 = _870 + _861;
                precise float _873 = uintBitsToFloat(srt_flatbuf_1.data[54u]) * _827;
                precise float _875 = uintBitsToFloat(srt_flatbuf_1.data[63u]) * _857;
                precise float _876 = _875 + _864;
                precise float _878 = uintBitsToFloat(srt_flatbuf_1.data[57u]) * _844;
                precise float _879 = _878 + _850;
                precise float _881 = uintBitsToFloat(srt_flatbuf_1.data[64u]) * _871;
                precise float _882 = _881 + _867;
                precise float _884 = uintBitsToFloat(srt_flatbuf_1.data[67u]) * _871;
                precise float _885 = _884 + _876;
                precise float _887 = uintBitsToFloat(srt_flatbuf_1.data[61u]) * _857;
                precise float _888 = _887 + _879;
                precise float _890 = uintBitsToFloat(srt_flatbuf_1.data[58u]) * _844;
                precise float _891 = _890 + _873;
                precise float _895 = uintBitsToFloat(srt_flatbuf_1.data[65u]) * _871;
                precise float _896 = _895 + _888;
                precise float _898 = uintBitsToFloat(srt_flatbuf_1.data[62u]) * _857;
                precise float _899 = _898 + _891;
                precise float _901 = uintBitsToFloat(srt_flatbuf_1.data[66u]) * _871;
                precise float _902 = _901 + _899;
                uint _926 = _787 & (((((floatBitsToUint((_885 < (-_882)) ? 1.4012984643248170709237295832899e-45 : 0.0) | floatBitsToUint((_885 < (-_896)) ? 2.8025969286496341418474591665798e-45 : 0.0)) | floatBitsToUint((0.0 > _902) ? 5.6051938572992682836949183331597e-45 : 0.0)) | floatBitsToUint((_885 < _882) ? 1.1210387714598536567389836666319e-44 : 0.0)) | floatBitsToUint((_885 < _896) ? 2.2420775429197073134779673332639e-44 : 0.0)) | floatBitsToUint((_885 < _902) ? 4.4841550858394146269559346665277e-44 : 0.0));
                bool _928 = _789 && (0u != _926);
                uint _1771;
                if (_928)
                {
                    uint _931 = ((_221 * 32u) + 6u) + buf2_dword_off;
                    uvec3 _940 = uvec3(ssbo_3_1.data[_931], ssbo_3_1.data[_931 + 1u], ssbo_3_1.data[_931 + 2u]);
                    uint _941 = _940.x;
                    uint _942 = _940.y;
                    uint _943 = _940.z;
                    precise float _947 = uintBitsToFloat(ssbo_1_1.data[_539]) * uintBitsToFloat(_941);
                    precise float _948 = _947 + uintBitsToFloat(ssbo_1_1.data[_208]);
                    precise float _952 = uintBitsToFloat(ssbo_1_1.data[_589]) * uintBitsToFloat(_941);
                    precise float _953 = _952 + uintBitsToFloat(ssbo_1_1.data[_212]);
                    precise float _956 = uintBitsToFloat(_942) * uintBitsToFloat(ssbo_1_1.data[_558]);
                    precise float _957 = _956 + _948;
                    precise float _961 = uintBitsToFloat(ssbo_1_1.data[_578]) * uintBitsToFloat(_941);
                    precise float _962 = _961 + uintBitsToFloat(ssbo_1_1.data[_216]);
                    precise float _965 = uintBitsToFloat(_943) * uintBitsToFloat(ssbo_1_1.data[_543]);
                    precise float _966 = _965 + _957;
                    precise float _969 = uintBitsToFloat(_942) * uintBitsToFloat(ssbo_1_1.data[_574]);
                    precise float _970 = _969 + _953;
                    precise float _972 = uintBitsToFloat(srt_flatbuf_1.data[52u]) * _966;
                    precise float _976 = uintBitsToFloat(ssbo_1_1.data[_566]) * uintBitsToFloat(_941);
                    precise float _977 = _976 + uintBitsToFloat(ssbo_1_1.data[_582]);
                    precise float _979 = uintBitsToFloat(srt_flatbuf_1.data[55u]) * _966;
                    precise float _982 = uintBitsToFloat(_943) * uintBitsToFloat(ssbo_1_1.data[_547]);
                    precise float _983 = _982 + _970;
                    precise float _986 = uintBitsToFloat(_942) * uintBitsToFloat(ssbo_1_1.data[_562]);
                    precise float _987 = _986 + _962;
                    precise float _989 = uintBitsToFloat(srt_flatbuf_1.data[53u]) * _966;
                    precise float _991 = uintBitsToFloat(srt_flatbuf_1.data[56u]) * _983;
                    precise float _992 = _991 + _972;
                    precise float _995 = uintBitsToFloat(_943) * uintBitsToFloat(ssbo_1_1.data[_551]);
                    precise float _996 = _995 + _987;
                    precise float _999 = uintBitsToFloat(_942) * uintBitsToFloat(ssbo_1_1.data[_593]);
                    precise float _1000 = _999 + _977;
                    precise float _1002 = uintBitsToFloat(srt_flatbuf_1.data[59u]) * _983;
                    precise float _1003 = _1002 + _979;
                    precise float _1005 = uintBitsToFloat(srt_flatbuf_1.data[60u]) * _996;
                    precise float _1006 = _1005 + _992;
                    precise float _1009 = uintBitsToFloat(_943) * uintBitsToFloat(ssbo_1_1.data[_598]);
                    precise float _1010 = _1009 + _1000;
                    precise float _1012 = uintBitsToFloat(srt_flatbuf_1.data[54u]) * _966;
                    precise float _1014 = uintBitsToFloat(srt_flatbuf_1.data[63u]) * _996;
                    precise float _1015 = _1014 + _1003;
                    precise float _1017 = uintBitsToFloat(srt_flatbuf_1.data[57u]) * _983;
                    precise float _1018 = _1017 + _989;
                    precise float _1020 = uintBitsToFloat(srt_flatbuf_1.data[64u]) * _1010;
                    precise float _1021 = _1020 + _1006;
                    precise float _1023 = uintBitsToFloat(srt_flatbuf_1.data[67u]) * _1010;
                    precise float _1024 = _1023 + _1015;
                    precise float _1026 = uintBitsToFloat(srt_flatbuf_1.data[61u]) * _996;
                    precise float _1027 = _1026 + _1018;
                    precise float _1029 = uintBitsToFloat(srt_flatbuf_1.data[58u]) * _983;
                    precise float _1030 = _1029 + _1012;
                    precise float _1034 = uintBitsToFloat(srt_flatbuf_1.data[65u]) * _1010;
                    precise float _1035 = _1034 + _1027;
                    precise float _1037 = uintBitsToFloat(srt_flatbuf_1.data[62u]) * _996;
                    precise float _1038 = _1037 + _1030;
                    precise float _1040 = uintBitsToFloat(srt_flatbuf_1.data[66u]) * _1010;
                    precise float _1041 = _1040 + _1038;
                    uint _1065 = _926 & (((((floatBitsToUint((_1024 < (-_1021)) ? 1.4012984643248170709237295832899e-45 : 0.0) | floatBitsToUint((_1024 < (-_1035)) ? 2.8025969286496341418474591665798e-45 : 0.0)) | floatBitsToUint((0.0 > _1041) ? 5.6051938572992682836949183331597e-45 : 0.0)) | floatBitsToUint((_1024 < _1021) ? 1.1210387714598536567389836666319e-44 : 0.0)) | floatBitsToUint((_1024 < _1035) ? 2.2420775429197073134779673332639e-44 : 0.0)) | floatBitsToUint((_1024 < _1041) ? 4.4841550858394146269559346665277e-44 : 0.0));
                    bool _1067 = _928 && (0u != _1065);
                    uint _1770;
                    if (_1067)
                    {
                        uint _1070 = ((_221 * 32u) + 9u) + buf2_dword_off;
                        uvec3 _1079 = uvec3(ssbo_3_1.data[_1070], ssbo_3_1.data[_1070 + 1u], ssbo_3_1.data[_1070 + 2u]);
                        uint _1080 = _1079.x;
                        uint _1081 = _1079.y;
                        uint _1082 = _1079.z;
                        precise float _1086 = uintBitsToFloat(ssbo_1_1.data[_539]) * uintBitsToFloat(_1080);
                        precise float _1087 = _1086 + uintBitsToFloat(ssbo_1_1.data[_208]);
                        precise float _1091 = uintBitsToFloat(ssbo_1_1.data[_589]) * uintBitsToFloat(_1080);
                        precise float _1092 = _1091 + uintBitsToFloat(ssbo_1_1.data[_212]);
                        precise float _1095 = uintBitsToFloat(_1081) * uintBitsToFloat(ssbo_1_1.data[_558]);
                        precise float _1096 = _1095 + _1087;
                        precise float _1100 = uintBitsToFloat(ssbo_1_1.data[_578]) * uintBitsToFloat(_1080);
                        precise float _1101 = _1100 + uintBitsToFloat(ssbo_1_1.data[_216]);
                        precise float _1104 = uintBitsToFloat(_1082) * uintBitsToFloat(ssbo_1_1.data[_543]);
                        precise float _1105 = _1104 + _1096;
                        precise float _1108 = uintBitsToFloat(_1081) * uintBitsToFloat(ssbo_1_1.data[_574]);
                        precise float _1109 = _1108 + _1092;
                        precise float _1111 = uintBitsToFloat(srt_flatbuf_1.data[52u]) * _1105;
                        precise float _1115 = uintBitsToFloat(ssbo_1_1.data[_566]) * uintBitsToFloat(_1080);
                        precise float _1116 = _1115 + uintBitsToFloat(ssbo_1_1.data[_582]);
                        precise float _1118 = uintBitsToFloat(srt_flatbuf_1.data[55u]) * _1105;
                        precise float _1121 = uintBitsToFloat(_1082) * uintBitsToFloat(ssbo_1_1.data[_547]);
                        precise float _1122 = _1121 + _1109;
                        precise float _1125 = uintBitsToFloat(_1081) * uintBitsToFloat(ssbo_1_1.data[_562]);
                        precise float _1126 = _1125 + _1101;
                        precise float _1128 = uintBitsToFloat(srt_flatbuf_1.data[53u]) * _1105;
                        precise float _1130 = uintBitsToFloat(srt_flatbuf_1.data[56u]) * _1122;
                        precise float _1131 = _1130 + _1111;
                        precise float _1134 = uintBitsToFloat(_1082) * uintBitsToFloat(ssbo_1_1.data[_551]);
                        precise float _1135 = _1134 + _1126;
                        precise float _1138 = uintBitsToFloat(_1081) * uintBitsToFloat(ssbo_1_1.data[_593]);
                        precise float _1139 = _1138 + _1116;
                        precise float _1141 = uintBitsToFloat(srt_flatbuf_1.data[59u]) * _1122;
                        precise float _1142 = _1141 + _1118;
                        precise float _1144 = uintBitsToFloat(srt_flatbuf_1.data[60u]) * _1135;
                        precise float _1145 = _1144 + _1131;
                        precise float _1148 = uintBitsToFloat(_1082) * uintBitsToFloat(ssbo_1_1.data[_598]);
                        precise float _1149 = _1148 + _1139;
                        precise float _1151 = uintBitsToFloat(srt_flatbuf_1.data[54u]) * _1105;
                        precise float _1153 = uintBitsToFloat(srt_flatbuf_1.data[63u]) * _1135;
                        precise float _1154 = _1153 + _1142;
                        precise float _1156 = uintBitsToFloat(srt_flatbuf_1.data[57u]) * _1122;
                        precise float _1157 = _1156 + _1128;
                        precise float _1159 = uintBitsToFloat(srt_flatbuf_1.data[64u]) * _1149;
                        precise float _1160 = _1159 + _1145;
                        precise float _1162 = uintBitsToFloat(srt_flatbuf_1.data[67u]) * _1149;
                        precise float _1163 = _1162 + _1154;
                        precise float _1165 = uintBitsToFloat(srt_flatbuf_1.data[61u]) * _1135;
                        precise float _1166 = _1165 + _1157;
                        precise float _1168 = uintBitsToFloat(srt_flatbuf_1.data[58u]) * _1122;
                        precise float _1169 = _1168 + _1151;
                        precise float _1173 = uintBitsToFloat(srt_flatbuf_1.data[65u]) * _1149;
                        precise float _1174 = _1173 + _1166;
                        precise float _1176 = uintBitsToFloat(srt_flatbuf_1.data[62u]) * _1135;
                        precise float _1177 = _1176 + _1169;
                        precise float _1179 = uintBitsToFloat(srt_flatbuf_1.data[66u]) * _1149;
                        precise float _1180 = _1179 + _1177;
                        uint _1204 = _1065 & (((((floatBitsToUint((_1163 < (-_1160)) ? 1.4012984643248170709237295832899e-45 : 0.0) | floatBitsToUint((_1163 < (-_1174)) ? 2.8025969286496341418474591665798e-45 : 0.0)) | floatBitsToUint((0.0 > _1180) ? 5.6051938572992682836949183331597e-45 : 0.0)) | floatBitsToUint((_1163 < _1160) ? 1.1210387714598536567389836666319e-44 : 0.0)) | floatBitsToUint((_1163 < _1174) ? 2.2420775429197073134779673332639e-44 : 0.0)) | floatBitsToUint((_1163 < _1180) ? 4.4841550858394146269559346665277e-44 : 0.0));
                        bool _1206 = _1067 && (0u != _1204);
                        uint _1769;
                        if (_1206)
                        {
                            uint _1209 = ((_221 * 32u) + 12u) + buf2_dword_off;
                            uvec3 _1218 = uvec3(ssbo_3_1.data[_1209], ssbo_3_1.data[_1209 + 1u], ssbo_3_1.data[_1209 + 2u]);
                            uint _1219 = _1218.x;
                            uint _1220 = _1218.y;
                            uint _1221 = _1218.z;
                            precise float _1225 = uintBitsToFloat(ssbo_1_1.data[_539]) * uintBitsToFloat(_1219);
                            precise float _1226 = _1225 + uintBitsToFloat(ssbo_1_1.data[_208]);
                            precise float _1230 = uintBitsToFloat(ssbo_1_1.data[_589]) * uintBitsToFloat(_1219);
                            precise float _1231 = _1230 + uintBitsToFloat(ssbo_1_1.data[_212]);
                            precise float _1234 = uintBitsToFloat(_1220) * uintBitsToFloat(ssbo_1_1.data[_558]);
                            precise float _1235 = _1234 + _1226;
                            precise float _1239 = uintBitsToFloat(ssbo_1_1.data[_578]) * uintBitsToFloat(_1219);
                            precise float _1240 = _1239 + uintBitsToFloat(ssbo_1_1.data[_216]);
                            precise float _1243 = uintBitsToFloat(_1221) * uintBitsToFloat(ssbo_1_1.data[_543]);
                            precise float _1244 = _1243 + _1235;
                            precise float _1247 = uintBitsToFloat(_1220) * uintBitsToFloat(ssbo_1_1.data[_574]);
                            precise float _1248 = _1247 + _1231;
                            precise float _1250 = uintBitsToFloat(srt_flatbuf_1.data[52u]) * _1244;
                            precise float _1254 = uintBitsToFloat(ssbo_1_1.data[_566]) * uintBitsToFloat(_1219);
                            precise float _1255 = _1254 + uintBitsToFloat(ssbo_1_1.data[_582]);
                            precise float _1257 = uintBitsToFloat(srt_flatbuf_1.data[55u]) * _1244;
                            precise float _1260 = uintBitsToFloat(_1221) * uintBitsToFloat(ssbo_1_1.data[_547]);
                            precise float _1261 = _1260 + _1248;
                            precise float _1264 = uintBitsToFloat(_1220) * uintBitsToFloat(ssbo_1_1.data[_562]);
                            precise float _1265 = _1264 + _1240;
                            precise float _1267 = uintBitsToFloat(srt_flatbuf_1.data[53u]) * _1244;
                            precise float _1269 = uintBitsToFloat(srt_flatbuf_1.data[56u]) * _1261;
                            precise float _1270 = _1269 + _1250;
                            precise float _1273 = uintBitsToFloat(_1221) * uintBitsToFloat(ssbo_1_1.data[_551]);
                            precise float _1274 = _1273 + _1265;
                            precise float _1277 = uintBitsToFloat(_1220) * uintBitsToFloat(ssbo_1_1.data[_593]);
                            precise float _1278 = _1277 + _1255;
                            precise float _1280 = uintBitsToFloat(srt_flatbuf_1.data[59u]) * _1261;
                            precise float _1281 = _1280 + _1257;
                            precise float _1283 = uintBitsToFloat(srt_flatbuf_1.data[60u]) * _1274;
                            precise float _1284 = _1283 + _1270;
                            precise float _1287 = uintBitsToFloat(_1221) * uintBitsToFloat(ssbo_1_1.data[_598]);
                            precise float _1288 = _1287 + _1278;
                            precise float _1290 = uintBitsToFloat(srt_flatbuf_1.data[54u]) * _1244;
                            precise float _1292 = uintBitsToFloat(srt_flatbuf_1.data[63u]) * _1274;
                            precise float _1293 = _1292 + _1281;
                            precise float _1295 = uintBitsToFloat(srt_flatbuf_1.data[57u]) * _1261;
                            precise float _1296 = _1295 + _1267;
                            precise float _1298 = uintBitsToFloat(srt_flatbuf_1.data[64u]) * _1288;
                            precise float _1299 = _1298 + _1284;
                            precise float _1301 = uintBitsToFloat(srt_flatbuf_1.data[67u]) * _1288;
                            precise float _1302 = _1301 + _1293;
                            precise float _1304 = uintBitsToFloat(srt_flatbuf_1.data[61u]) * _1274;
                            precise float _1305 = _1304 + _1296;
                            precise float _1307 = uintBitsToFloat(srt_flatbuf_1.data[58u]) * _1261;
                            precise float _1308 = _1307 + _1290;
                            precise float _1312 = uintBitsToFloat(srt_flatbuf_1.data[65u]) * _1288;
                            precise float _1313 = _1312 + _1305;
                            precise float _1315 = uintBitsToFloat(srt_flatbuf_1.data[62u]) * _1274;
                            precise float _1316 = _1315 + _1308;
                            precise float _1318 = uintBitsToFloat(srt_flatbuf_1.data[66u]) * _1288;
                            precise float _1319 = _1318 + _1316;
                            uint _1343 = _1204 & (((((floatBitsToUint((_1302 < (-_1299)) ? 1.4012984643248170709237295832899e-45 : 0.0) | floatBitsToUint((_1302 < (-_1313)) ? 2.8025969286496341418474591665798e-45 : 0.0)) | floatBitsToUint((0.0 > _1319) ? 5.6051938572992682836949183331597e-45 : 0.0)) | floatBitsToUint((_1302 < _1299) ? 1.1210387714598536567389836666319e-44 : 0.0)) | floatBitsToUint((_1302 < _1313) ? 2.2420775429197073134779673332639e-44 : 0.0)) | floatBitsToUint((_1302 < _1319) ? 4.4841550858394146269559346665277e-44 : 0.0));
                            bool _1345 = _1206 && (0u != _1343);
                            uint _1768;
                            if (_1345)
                            {
                                uint _1348 = ((_221 * 32u) + 15u) + buf2_dword_off;
                                uvec3 _1357 = uvec3(ssbo_3_1.data[_1348], ssbo_3_1.data[_1348 + 1u], ssbo_3_1.data[_1348 + 2u]);
                                uint _1358 = _1357.x;
                                uint _1359 = _1357.y;
                                uint _1360 = _1357.z;
                                precise float _1364 = uintBitsToFloat(ssbo_1_1.data[_539]) * uintBitsToFloat(_1358);
                                precise float _1365 = _1364 + uintBitsToFloat(ssbo_1_1.data[_208]);
                                precise float _1369 = uintBitsToFloat(ssbo_1_1.data[_589]) * uintBitsToFloat(_1358);
                                precise float _1370 = _1369 + uintBitsToFloat(ssbo_1_1.data[_212]);
                                precise float _1373 = uintBitsToFloat(_1359) * uintBitsToFloat(ssbo_1_1.data[_558]);
                                precise float _1374 = _1373 + _1365;
                                precise float _1378 = uintBitsToFloat(ssbo_1_1.data[_578]) * uintBitsToFloat(_1358);
                                precise float _1379 = _1378 + uintBitsToFloat(ssbo_1_1.data[_216]);
                                precise float _1382 = uintBitsToFloat(_1360) * uintBitsToFloat(ssbo_1_1.data[_543]);
                                precise float _1383 = _1382 + _1374;
                                precise float _1386 = uintBitsToFloat(_1359) * uintBitsToFloat(ssbo_1_1.data[_574]);
                                precise float _1387 = _1386 + _1370;
                                precise float _1389 = uintBitsToFloat(srt_flatbuf_1.data[52u]) * _1383;
                                precise float _1393 = uintBitsToFloat(ssbo_1_1.data[_566]) * uintBitsToFloat(_1358);
                                precise float _1394 = _1393 + uintBitsToFloat(ssbo_1_1.data[_582]);
                                precise float _1396 = uintBitsToFloat(srt_flatbuf_1.data[55u]) * _1383;
                                precise float _1399 = uintBitsToFloat(_1360) * uintBitsToFloat(ssbo_1_1.data[_547]);
                                precise float _1400 = _1399 + _1387;
                                precise float _1403 = uintBitsToFloat(_1359) * uintBitsToFloat(ssbo_1_1.data[_562]);
                                precise float _1404 = _1403 + _1379;
                                precise float _1406 = uintBitsToFloat(srt_flatbuf_1.data[53u]) * _1383;
                                precise float _1408 = uintBitsToFloat(srt_flatbuf_1.data[56u]) * _1400;
                                precise float _1409 = _1408 + _1389;
                                precise float _1412 = uintBitsToFloat(_1360) * uintBitsToFloat(ssbo_1_1.data[_551]);
                                precise float _1413 = _1412 + _1404;
                                precise float _1416 = uintBitsToFloat(_1359) * uintBitsToFloat(ssbo_1_1.data[_593]);
                                precise float _1417 = _1416 + _1394;
                                precise float _1419 = uintBitsToFloat(srt_flatbuf_1.data[59u]) * _1400;
                                precise float _1420 = _1419 + _1396;
                                precise float _1422 = uintBitsToFloat(srt_flatbuf_1.data[60u]) * _1413;
                                precise float _1423 = _1422 + _1409;
                                precise float _1426 = uintBitsToFloat(_1360) * uintBitsToFloat(ssbo_1_1.data[_598]);
                                precise float _1427 = _1426 + _1417;
                                precise float _1429 = uintBitsToFloat(srt_flatbuf_1.data[54u]) * _1383;
                                precise float _1431 = uintBitsToFloat(srt_flatbuf_1.data[63u]) * _1413;
                                precise float _1432 = _1431 + _1420;
                                precise float _1434 = uintBitsToFloat(srt_flatbuf_1.data[57u]) * _1400;
                                precise float _1435 = _1434 + _1406;
                                precise float _1437 = uintBitsToFloat(srt_flatbuf_1.data[64u]) * _1427;
                                precise float _1438 = _1437 + _1423;
                                precise float _1440 = uintBitsToFloat(srt_flatbuf_1.data[67u]) * _1427;
                                precise float _1441 = _1440 + _1432;
                                precise float _1443 = uintBitsToFloat(srt_flatbuf_1.data[61u]) * _1413;
                                precise float _1444 = _1443 + _1435;
                                precise float _1446 = uintBitsToFloat(srt_flatbuf_1.data[58u]) * _1400;
                                precise float _1447 = _1446 + _1429;
                                precise float _1451 = uintBitsToFloat(srt_flatbuf_1.data[65u]) * _1427;
                                precise float _1452 = _1451 + _1444;
                                precise float _1454 = uintBitsToFloat(srt_flatbuf_1.data[62u]) * _1413;
                                precise float _1455 = _1454 + _1447;
                                precise float _1457 = uintBitsToFloat(srt_flatbuf_1.data[66u]) * _1427;
                                precise float _1458 = _1457 + _1455;
                                uint _1482 = _1343 & (((((floatBitsToUint((_1441 < (-_1438)) ? 1.4012984643248170709237295832899e-45 : 0.0) | floatBitsToUint((_1441 < (-_1452)) ? 2.8025969286496341418474591665798e-45 : 0.0)) | floatBitsToUint((0.0 > _1458) ? 5.6051938572992682836949183331597e-45 : 0.0)) | floatBitsToUint((_1441 < _1438) ? 1.1210387714598536567389836666319e-44 : 0.0)) | floatBitsToUint((_1441 < _1452) ? 2.2420775429197073134779673332639e-44 : 0.0)) | floatBitsToUint((_1441 < _1458) ? 4.4841550858394146269559346665277e-44 : 0.0));
                                bool _1484 = _1345 && (0u != _1482);
                                uint _1767;
                                if (_1484)
                                {
                                    uint _1488 = ((_221 * 32u) + 18u) + buf2_dword_off;
                                    uvec3 _1497 = uvec3(ssbo_3_1.data[_1488], ssbo_3_1.data[_1488 + 1u], ssbo_3_1.data[_1488 + 2u]);
                                    uint _1498 = _1497.x;
                                    uint _1499 = _1497.y;
                                    uint _1500 = _1497.z;
                                    precise float _1504 = uintBitsToFloat(ssbo_1_1.data[_539]) * uintBitsToFloat(_1498);
                                    precise float _1505 = _1504 + uintBitsToFloat(ssbo_1_1.data[_208]);
                                    precise float _1509 = uintBitsToFloat(ssbo_1_1.data[_589]) * uintBitsToFloat(_1498);
                                    precise float _1510 = _1509 + uintBitsToFloat(ssbo_1_1.data[_212]);
                                    precise float _1513 = uintBitsToFloat(_1499) * uintBitsToFloat(ssbo_1_1.data[_558]);
                                    precise float _1514 = _1513 + _1505;
                                    precise float _1518 = uintBitsToFloat(ssbo_1_1.data[_578]) * uintBitsToFloat(_1498);
                                    precise float _1519 = _1518 + uintBitsToFloat(ssbo_1_1.data[_216]);
                                    precise float _1522 = uintBitsToFloat(_1500) * uintBitsToFloat(ssbo_1_1.data[_543]);
                                    precise float _1523 = _1522 + _1514;
                                    precise float _1526 = uintBitsToFloat(_1499) * uintBitsToFloat(ssbo_1_1.data[_574]);
                                    precise float _1527 = _1526 + _1510;
                                    precise float _1529 = uintBitsToFloat(srt_flatbuf_1.data[52u]) * _1523;
                                    precise float _1533 = uintBitsToFloat(ssbo_1_1.data[_566]) * uintBitsToFloat(_1498);
                                    precise float _1534 = _1533 + uintBitsToFloat(ssbo_1_1.data[_582]);
                                    precise float _1536 = uintBitsToFloat(srt_flatbuf_1.data[55u]) * _1523;
                                    precise float _1539 = uintBitsToFloat(_1500) * uintBitsToFloat(ssbo_1_1.data[_547]);
                                    precise float _1540 = _1539 + _1527;
                                    precise float _1543 = uintBitsToFloat(_1499) * uintBitsToFloat(ssbo_1_1.data[_562]);
                                    precise float _1544 = _1543 + _1519;
                                    precise float _1546 = uintBitsToFloat(srt_flatbuf_1.data[53u]) * _1523;
                                    precise float _1548 = uintBitsToFloat(srt_flatbuf_1.data[56u]) * _1540;
                                    precise float _1549 = _1548 + _1529;
                                    precise float _1552 = uintBitsToFloat(_1500) * uintBitsToFloat(ssbo_1_1.data[_551]);
                                    precise float _1553 = _1552 + _1544;
                                    precise float _1556 = uintBitsToFloat(_1499) * uintBitsToFloat(ssbo_1_1.data[_593]);
                                    precise float _1557 = _1556 + _1534;
                                    precise float _1559 = uintBitsToFloat(srt_flatbuf_1.data[59u]) * _1540;
                                    precise float _1560 = _1559 + _1536;
                                    precise float _1562 = uintBitsToFloat(srt_flatbuf_1.data[60u]) * _1553;
                                    precise float _1563 = _1562 + _1549;
                                    precise float _1566 = uintBitsToFloat(_1500) * uintBitsToFloat(ssbo_1_1.data[_598]);
                                    precise float _1567 = _1566 + _1557;
                                    precise float _1569 = uintBitsToFloat(srt_flatbuf_1.data[54u]) * _1523;
                                    precise float _1571 = uintBitsToFloat(srt_flatbuf_1.data[63u]) * _1553;
                                    precise float _1572 = _1571 + _1560;
                                    precise float _1574 = uintBitsToFloat(srt_flatbuf_1.data[57u]) * _1540;
                                    precise float _1575 = _1574 + _1546;
                                    precise float _1577 = uintBitsToFloat(srt_flatbuf_1.data[64u]) * _1567;
                                    precise float _1578 = _1577 + _1563;
                                    precise float _1580 = uintBitsToFloat(srt_flatbuf_1.data[67u]) * _1567;
                                    precise float _1581 = _1580 + _1572;
                                    precise float _1583 = uintBitsToFloat(srt_flatbuf_1.data[61u]) * _1553;
                                    precise float _1584 = _1583 + _1575;
                                    precise float _1586 = uintBitsToFloat(srt_flatbuf_1.data[58u]) * _1540;
                                    precise float _1587 = _1586 + _1569;
                                    precise float _1591 = uintBitsToFloat(srt_flatbuf_1.data[65u]) * _1567;
                                    precise float _1592 = _1591 + _1584;
                                    precise float _1594 = uintBitsToFloat(srt_flatbuf_1.data[62u]) * _1553;
                                    precise float _1595 = _1594 + _1587;
                                    precise float _1597 = uintBitsToFloat(srt_flatbuf_1.data[66u]) * _1567;
                                    precise float _1598 = _1597 + _1595;
                                    uint _1622 = _1482 & (((((floatBitsToUint((_1581 < (-_1578)) ? 1.4012984643248170709237295832899e-45 : 0.0) | floatBitsToUint((_1581 < (-_1592)) ? 2.8025969286496341418474591665798e-45 : 0.0)) | floatBitsToUint((0.0 > _1598) ? 5.6051938572992682836949183331597e-45 : 0.0)) | floatBitsToUint((_1581 < _1578) ? 1.1210387714598536567389836666319e-44 : 0.0)) | floatBitsToUint((_1581 < _1592) ? 2.2420775429197073134779673332639e-44 : 0.0)) | floatBitsToUint((_1581 < _1598) ? 4.4841550858394146269559346665277e-44 : 0.0));
                                    uint _1766;
                                    if (_1484 && (0u != _1622))
                                    {
                                        uint _1628 = ((_221 * 32u) + 21u) + buf2_dword_off;
                                        uvec3 _1637 = uvec3(ssbo_3_1.data[_1628], ssbo_3_1.data[_1628 + 1u], ssbo_3_1.data[_1628 + 2u]);
                                        uint _1638 = _1637.x;
                                        uint _1639 = _1637.y;
                                        uint _1640 = _1637.z;
                                        precise float _1644 = uintBitsToFloat(_1638) * uintBitsToFloat(ssbo_1_1.data[_539]);
                                        precise float _1645 = _1644 + uintBitsToFloat(ssbo_1_1.data[_208]);
                                        precise float _1648 = uintBitsToFloat(ssbo_1_1.data[_558]) * uintBitsToFloat(_1639);
                                        precise float _1649 = _1648 + _1645;
                                        precise float _1653 = uintBitsToFloat(_1638) * uintBitsToFloat(ssbo_1_1.data[_589]);
                                        precise float _1654 = _1653 + uintBitsToFloat(ssbo_1_1.data[_212]);
                                        precise float _1657 = uintBitsToFloat(_1640) * uintBitsToFloat(ssbo_1_1.data[_543]);
                                        precise float _1658 = _1657 + _1649;
                                        precise float _1661 = uintBitsToFloat(_1639) * uintBitsToFloat(ssbo_1_1.data[_574]);
                                        precise float _1662 = _1661 + _1654;
                                        precise float _1666 = uintBitsToFloat(_1638) * uintBitsToFloat(ssbo_1_1.data[_578]);
                                        precise float _1667 = _1666 + uintBitsToFloat(ssbo_1_1.data[_216]);
                                        precise float _1669 = uintBitsToFloat(srt_flatbuf_1.data[52u]) * _1658;
                                        precise float _1671 = uintBitsToFloat(srt_flatbuf_1.data[55u]) * _1658;
                                        precise float _1674 = uintBitsToFloat(_1640) * uintBitsToFloat(ssbo_1_1.data[_547]);
                                        precise float _1675 = _1674 + _1662;
                                        precise float _1677 = uintBitsToFloat(srt_flatbuf_1.data[53u]) * _1658;
                                        precise float _1680 = uintBitsToFloat(_1639) * uintBitsToFloat(ssbo_1_1.data[_562]);
                                        precise float _1681 = _1680 + _1667;
                                        precise float _1685 = uintBitsToFloat(_1638) * uintBitsToFloat(ssbo_1_1.data[_566]);
                                        precise float _1686 = _1685 + uintBitsToFloat(ssbo_1_1.data[_582]);
                                        precise float _1689 = uintBitsToFloat(ssbo_1_1.data[_551]) * uintBitsToFloat(_1640);
                                        precise float _1690 = _1689 + _1681;
                                        precise float _1692 = uintBitsToFloat(srt_flatbuf_1.data[54u]) * _1658;
                                        precise float _1694 = uintBitsToFloat(srt_flatbuf_1.data[56u]) * _1675;
                                        precise float _1695 = _1694 + _1669;
                                        precise float _1698 = uintBitsToFloat(_1639) * uintBitsToFloat(ssbo_1_1.data[_593]);
                                        precise float _1699 = _1698 + _1686;
                                        precise float _1701 = uintBitsToFloat(srt_flatbuf_1.data[59u]) * _1675;
                                        precise float _1702 = _1701 + _1671;
                                        precise float _1704 = uintBitsToFloat(srt_flatbuf_1.data[57u]) * _1675;
                                        precise float _1705 = _1704 + _1677;
                                        precise float _1707 = uintBitsToFloat(srt_flatbuf_1.data[60u]) * _1690;
                                        precise float _1708 = _1707 + _1695;
                                        precise float _1710 = uintBitsToFloat(srt_flatbuf_1.data[63u]) * _1690;
                                        precise float _1711 = _1710 + _1702;
                                        precise float _1714 = uintBitsToFloat(_1640) * uintBitsToFloat(ssbo_1_1.data[_598]);
                                        precise float _1715 = _1714 + _1699;
                                        precise float _1717 = uintBitsToFloat(srt_flatbuf_1.data[61u]) * _1690;
                                        precise float _1718 = _1717 + _1705;
                                        precise float _1720 = uintBitsToFloat(srt_flatbuf_1.data[58u]) * _1675;
                                        precise float _1721 = _1720 + _1692;
                                        precise float _1723 = uintBitsToFloat(srt_flatbuf_1.data[64u]) * _1715;
                                        precise float _1724 = _1723 + _1708;
                                        precise float _1726 = uintBitsToFloat(srt_flatbuf_1.data[67u]) * _1715;
                                        precise float _1727 = _1726 + _1711;
                                        precise float _1729 = uintBitsToFloat(srt_flatbuf_1.data[65u]) * _1715;
                                        precise float _1730 = _1729 + _1718;
                                        precise float _1732 = uintBitsToFloat(srt_flatbuf_1.data[62u]) * _1690;
                                        precise float _1733 = _1732 + _1721;
                                        precise float _1739 = uintBitsToFloat(srt_flatbuf_1.data[66u]) * _1715;
                                        precise float _1740 = _1739 + _1733;
                                        _1766 = floatBitsToUint((0u == (_1622 & (((((floatBitsToUint((_1727 < (-_1724)) ? 1.4012984643248170709237295832899e-45 : 0.0) | floatBitsToUint((_1727 < (-_1730)) ? 2.8025969286496341418474591665798e-45 : 0.0)) | floatBitsToUint((0.0 > _1740) ? 5.6051938572992682836949183331597e-45 : 0.0)) | floatBitsToUint((_1727 < _1724) ? 1.1210387714598536567389836666319e-44 : 0.0)) | floatBitsToUint((_1727 < _1730) ? 2.2420775429197073134779673332639e-44 : 0.0)) | floatBitsToUint((_1727 < _1740) ? 4.4841550858394146269559346665277e-44 : 0.0)))) ? 0.0 : 1.4012984643248170709237295832899e-45);
                                    }
                                    else
                                    {
                                        _1766 = 0u;
                                    }
                                    _1767 = _1766;
                                }
                                else
                                {
                                    _1767 = 0u;
                                }
                                _1768 = _1767;
                            }
                            else
                            {
                                _1768 = 0u;
                            }
                            _1769 = _1768;
                        }
                        else
                        {
                            _1769 = 0u;
                        }
                        _1770 = _1769;
                    }
                    else
                    {
                        _1770 = 0u;
                    }
                    _1771 = _1770;
                }
                else
                {
                    _1771 = 0u;
                }
                _1772 = _1771;
            }
            else
            {
                _1772 = 0u;
            }
            _1773 = srt_flatbuf_1.data[57u];
            _1774 = srt_flatbuf_1.data[56u];
            _1775 = _1772;
        }
        else
        {
            _1773 = _523;
            _1774 = _524;
            _1775 = 0u;
        }
        uint _1779 = srt_flatbuf_1.data[89u];
        uint _1781 = _1779 + _190;
        bool _1782 = _191 && (0u != _1775);
        if (_1782)
        {
            uint _1785 = (_1781 * 2u) + buf5_dword_off;
            ssbo_6_1.data[_1785] = 4294967295u;
            ssbo_6_1.data[_1785 + 1u] = 0u;
        }
        bool _1792 = _191 && (!_1782);
        if (_1792)
        {
            uint _1796 = srt_flatbuf_1.data[74u];
            bool _1801 = _1792 && (((int(_1796) >= int(0u)) ? _1792 : false) && (_1796 != _525));
            if (_1801)
            {
                uint _1803 = (_1781 * 2u) + buf5_dword_off;
                ssbo_6_1.data[_1803] = 4294967295u;
                ssbo_6_1.data[_1803 + 1u] = 0u;
            }
            bool _1810 = _1792 && (!_1801);
            if (_1810)
            {
                bool _1839;
                bool _1835;
                uint _1836;
                uint _1811 = 0u;
                bool _1812 = _1792;
                bool _1813 = _1810;
                for (;;)
                {
                    uvec4 _1814 = subgroupBallot(_1813);
                    uint _1815 = subgroupBallotFindLSB(_1814);
                    uint _1816 = subgroupBroadcast(_535, _1815);
                    bool _1817 = _1816 == _535;
                    bool _1818 = _1810 && _1817;
                    if (_1818)
                    {
                        uint _1832;
                        if (_1818 && _1812)
                        {
                            uvec2 _1822 = unpackUint2x32(packUint2x32(uvec2(_1774, _1773)));
                            uint _1831 = atomicAdd(ssbo_7_1.data[(_1816 * 2u) + buf6_dword_off], uint(bitCount(_1822.x)) + uint(bitCount(_1822.y)));
                            _1832 = _1831;
                        }
                        else
                        {
                            _1832 = _1811;
                        }
                        uint _1833 = subgroupBroadcast(_1832, _1815);
                        _1835 = _1833 < _1833;
                        _1836 = _1833;
                    }
                    else
                    {
                        _1835 = _1812;
                        _1836 = _1811;
                    }
                    bool _1838 = _1813 && (!_1817);
                    _1839 = _1838 && _1838;
                    if (_1839)
                    {
                        _1811 = _1836;
                        _1812 = _1835;
                        _1813 = _1839;
                        continue;
                    }
                    else
                    {
                        break;
                    }
                }
                uvec2 _1840 = uvec2(_535, _1836);
                uint _1842 = (_1781 * 2u) + buf5_dword_off;
                ssbo_6_1.data[_1842] = _1840.x;
                ssbo_6_1.data[_1842 + 1u] = _1840.y;
            }
        }
    }
}

