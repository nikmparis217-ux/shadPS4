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
layout(local_size_x = 32, local_size_y = 1, local_size_z = 1) in;

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

uint _168;
uint _169;
uint _170;
uint _171;
uint _172;

layout(binding = 0, std430) readonly buffer ssbo_1
{
    uint data[];
} ssbo_1_1;

layout(binding = 1, std430) buffer ssbo_2
{
    uint data[];
} ssbo_2_1;

layout(binding = 2, std430) buffer ssbo_3
{
    uint data[];
} ssbo_3_1;

layout(binding = 3, std430) buffer ssbo_4
{
    uint data[];
} ssbo_4_1;

layout(binding = 4, std430) buffer ssbo_5
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

layout(binding = 7, std430) buffer ssbo_8
{
    uint data[];
} ssbo_8_1;

layout(binding = 8, std430) buffer gds_buffer
{
    uint data[];
} gds_buffer_1;

layout(binding = 9, std430) readonly buffer srt_flatbuf
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

shared uint shared_mem_u32[128];

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
    uint buf1_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(8u), int(8u)) >> 2u;
    uint buf2_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(16u), int(8u)) >> 2u;
    uint buf3_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(24u), int(8u)) >> 2u;
    uint buf4_dword_off = bitfieldExtract(push_data.buf_offsets0.y, int(0u), int(8u)) >> 2u;
    uint buf5_dword_off = bitfieldExtract(push_data.buf_offsets0.y, int(8u), int(8u)) >> 2u;
    uint buf6_dword_off = bitfieldExtract(push_data.buf_offsets0.y, int(16u), int(8u)) >> 2u;
    uint buf7_dword_off = bitfieldExtract(push_data.buf_offsets0.y, int(24u), int(8u)) >> 2u;
    if (!(gl_WorkGroupID.x >= 300u))
    {
        uint _250;
        uint _251;
        uint _252;
        uint _253;
        if (12u > gl_LocalInvocationID.x)
        {
            shared_mem_u32[(gl_LocalInvocationID.x << 2u) >> 2u] = ssbo_1_1.data[((gl_WorkGroupID.x * 12u) + gl_LocalInvocationID.x) + (bitfieldExtract(push_data.buf_offsets0.x, int(0u), int(8u)) >> 2u)];
            _250 = srt_flatbuf_1.data[51u];
            _251 = srt_flatbuf_1.data[50u];
            _252 = srt_flatbuf_1.data[48u];
            _253 = srt_flatbuf_1.data[49u];
        }
        else
        {
            _250 = _168;
            _251 = _169;
            _252 = _170;
            _253 = _172;
        }
        uint _254 = gl_LocalInvocationID.x >> 2u;
        uint _255 = 3u & gl_LocalInvocationID.x;
        uint _256 = _254 + 1u;
        bool _257 = 3u == _255;
        uint _259 = 28u & gl_LocalInvocationID.x;
        uint _1130;
        uint _1230;
        uint _1357;
        uint _1117;
        bool _1118;
        uint _1121;
        uint _1123;
        uint _1124;
        bool _1125;
        uint _1126;
        uint _1127;
        uint _1128;
        uint _1211;
        uint _1353;
        uint _1354;
        uint _1355;
        uint _1356;
        uint _260 = _255;
        bool _261 = _257;
        uint _262 = _250;
        uint _263 = _251;
        uint _264 = _252;
        uint _265 = _259;
        uint _266 = _256;
        uint _267 = _254;
        uint _268 = _253;
        uint _269 = 352u;
        uint _270 = 32u;
        uint _271 = push_data.ud_regs0.x;
        uint _272 = 0u;
        bool _273 = true;
        uint _274 = gl_LocalInvocationID.x;
        uint _275 = 3u;
        uint _276 = 0u;
        for (;;)
        {
            uint _1116;
            uint _1119;
            uint _1120;
            uint _1122;
            if (!(_276 < 5u))
            {
                bool _282 = _273 && ((_275 << 2u) > _274);
                uint _339;
                uint _340;
                if (_282)
                {
                    uint _287 = ((_272 + (3u | _274)) << 2u) >> 2u;
                    uint _292 = ((_272 + _274) << 2u) >> 2u;
                    uint _295 = 1u & _274;
                    float _299 = 1.0 / uintBitsToFloat(shared_mem_u32[_287]);
                    bool _301 = _282 && (0u != (2u & _274));
                    uint _306;
                    if (_301)
                    {
                        _306 = floatBitsToUint((0u == _295) ? _299 : uintBitsToFloat(shared_mem_u32[_292]));
                    }
                    else
                    {
                        _306 = shared_mem_u32[_292];
                    }
                    bool _308 = _282 && (!_301);
                    uint _333;
                    uint _334;
                    if (_308)
                    {
                        bool _309 = _308 && (0u != _295);
                        uint _315;
                        uint _316;
                        if (_309)
                        {
                            _315 = srt_flatbuf_1.data[45u];
                            _316 = srt_flatbuf_1.data[45u];
                        }
                        else
                        {
                            _315 = _264;
                            _316 = shared_mem_u32[_287];
                        }
                        uint _323;
                        uint _324;
                        if (_308 && (!_309))
                        {
                            _323 = srt_flatbuf_1.data[44u];
                            _324 = srt_flatbuf_1.data[44u];
                        }
                        else
                        {
                            _323 = _315;
                            _324 = _316;
                        }
                        precise float _326 = 0.5 * _299;
                        precise float _328 = _326 * uintBitsToFloat(_306);
                        precise float _329 = _328 + 0.5;
                        precise float _331 = float(int(_324)) * _329;
                        _333 = _323;
                        _334 = floatBitsToUint(_331);
                    }
                    else
                    {
                        _333 = _264;
                        _334 = _306;
                    }
                    shared_mem_u32[((_270 + _274) << 2u) >> 2u] = _334;
                    _339 = _333;
                    _340 = _295;
                }
                else
                {
                    _339 = _264;
                    _340 = _267;
                }
                uint _341 = _274 + 2u;
                bool _343 = _273 && (_275 > _341);
                uint _1103;
                uint _1104;
                bool _1105;
                uint _1106;
                uint _1107;
                uint _1108;
                uint _1109;
                uint _1110;
                uint _1111;
                bool _1112;
                uint _1113;
                uint _1114;
                uint _1115;
                if (_343)
                {
                    uint _347 = (bitfieldExtract(_274 + 1u, int(0u), int(24u)) * 4u) + _270;
                    uint _350 = (bitfieldExtract(_341, int(0u), int(24u)) * 4u) + _270;
                    uint _354 = (_347 << 2u) >> 2u;
                    uint _356 = shared_mem_u32[_354];
                    uint _357 = (_350 << 2u) >> 2u;
                    uint _359 = shared_mem_u32[_357];
                    uint _360 = (_270 << 2u) >> 2u;
                    uint _362 = shared_mem_u32[_360];
                    uint _365 = srt_flatbuf_1.data[44u];
                    float _378 = max(0.0, min(uintBitsToFloat(_359), min(uintBitsToFloat(_362), uintBitsToFloat(_356))));
                    float _379 = min(float(int(_365)), max(uintBitsToFloat(_359), max(uintBitsToFloat(_362), uintBitsToFloat(_356))));
                    precise float _380 = _379 - _378;
                    uint _385 = floatBitsToUint((1.0 > _380) ? 1.4012984643248170709237295832899e-45 : 2.8025969286496341418474591665798e-45);
                    uint _402;
                    uint _403;
                    uint _404;
                    if (_343 && (1u >= _385))
                    {
                        precise float _389 = _379 - floor(_378);
                        float _391 = fract(_378);
                        _402 = floatBitsToUint(_391);
                        _403 = floatBitsToUint(_389);
                        _404 = floatBitsToUint(((0.5 > _389) || ((0.5 < _391) && (1.5 > _389))) ? 4.2038953929744512127711887498697e-45 : 2.8025969286496341418474591665798e-45);
                    }
                    else
                    {
                        _402 = _340;
                        _403 = _274;
                        _404 = _385;
                    }
                    bool _406 = _343 && (2u >= _404);
                    uint _1067;
                    uint _1068;
                    uint _1069;
                    uint _1070;
                    uint _1071;
                    uint _1072;
                    uint _1073;
                    uint _1074;
                    uint _1075;
                    uint _1076;
                    uint _1077;
                    if (_406)
                    {
                        uint _411 = ((_270 << 2u) + 4u) >> 2u;
                        uint _413 = shared_mem_u32[_411];
                        uint _415 = ((_347 << 2u) + 4u) >> 2u;
                        uint _417 = shared_mem_u32[_415];
                        uint _419 = ((_350 << 2u) + 4u) >> 2u;
                        uint _421 = shared_mem_u32[_419];
                        uint _424 = srt_flatbuf_1.data[45u];
                        float _436 = max(0.0, min(uintBitsToFloat(_421), min(uintBitsToFloat(_413), uintBitsToFloat(_417))));
                        float _437 = min(float(int(_424)), max(uintBitsToFloat(_421), max(uintBitsToFloat(_413), uintBitsToFloat(_417))));
                        precise float _438 = _437 - _436;
                        uint _441 = floatBitsToUint((1.0 > _438) ? 1.4012984643248170709237295832899e-45 : 2.8025969286496341418474591665798e-45);
                        uint _456;
                        uint _457;
                        uint _458;
                        if (_406 && (1u >= _441))
                        {
                            precise float _445 = _437 - floor(_436);
                            float _447 = fract(_436);
                            _456 = floatBitsToUint(_447);
                            _457 = floatBitsToUint(_445);
                            _458 = floatBitsToUint(((0.5 > _445) || ((0.5 < _447) && (1.5 > _445))) ? 4.2038953929744512127711887498697e-45 : 2.8025969286496341418474591665798e-45);
                        }
                        else
                        {
                            _456 = _402;
                            _457 = _403;
                            _458 = _441;
                        }
                        bool _460 = _406 && (2u >= _458);
                        uint _1033;
                        uint _1034;
                        uint _1035;
                        uint _1036;
                        uint _1037;
                        uint _1038;
                        uint _1039;
                        uint _1040;
                        uint _1041;
                        uint _1042;
                        uint _1043;
                        if (_460)
                        {
                            uvec4 _461 = subgroupBallot(_460);
                            uint _462 = subgroupBallotFindLSB(_461);
                            uvec2 _468 = unpackUint2x32(1ul << (packUint2x32(uvec2(_462, _269)) & 63ul));
                            uint _469 = _468.y;
                            uint _474 = srt_flatbuf_1.data[47u];
                            uint _488;
                            uint _489;
                            if (_460 && _460)
                            {
                                uvec2 _479 = unpackUint2x32(packUint2x32(uvec2(_424, _268)));
                                uint _484 = uint(bitCount(_479.x)) + uint(bitCount(_479.y));
                                uint _487 = atomicAdd(gds_buffer_1.data[(_474 << 2u) >> 2u], _484);
                                _488 = _484;
                                _489 = _487;
                            }
                            else
                            {
                                _488 = _263;
                                _489 = 0u;
                            }
                            uint _490 = subgroupBroadcastFirst(_489);
                            bool _493 = _460 && (10000u > _490);
                            uint _1023;
                            uint _1024;
                            uint _1025;
                            uint _1026;
                            uint _1027;
                            uint _1028;
                            uint _1029;
                            uint _1030;
                            uint _1031;
                            uint _1032;
                            if (_493)
                            {
                                precise float _495 = 0.125 * _379;
                                precise float _496 = 0.125 * _437;
                                uint _501 = ((_347 << 2u) + 8u) >> 2u;
                                uint _503 = shared_mem_u32[_501];
                                precise float _506 = uintBitsToFloat(_362) - uintBitsToFloat(_356);
                                precise float _510 = uintBitsToFloat(_359) - uintBitsToFloat(_362);
                                precise float _512 = uintBitsToFloat(_413) * _506;
                                uint _515 = srt_flatbuf_1.data[16u];
                                uint _518 = srt_flatbuf_1.data[17u];
                                uint _521 = srt_flatbuf_1.data[18u];
                                uint _524 = srt_flatbuf_1.data[19u];
                                precise float _525 = 0.125 * _378;
                                uint _530 = ((_270 << 2u) + 8u) >> 2u;
                                uint _532 = shared_mem_u32[_530];
                                uint _534 = ((_350 << 2u) + 8u) >> 2u;
                                uint _536 = shared_mem_u32[_534];
                                precise float _539 = uintBitsToFloat(_532) - uintBitsToFloat(_503);
                                precise float _542 = uintBitsToFloat(_421) - uintBitsToFloat(_413);
                                precise float _545 = uintBitsToFloat(_536) - uintBitsToFloat(_532);
                                precise float _547 = (-_539) * _510;
                                precise float _548 = _545 * _506;
                                precise float _549 = _548 + _547;
                                precise float _550 = 0.125 * _436;
                                uint _551 = uint(int(_525));
                                uint _552 = uint(int(_550));
                                uint _553 = uint(int(ceil(_495))) - _551;
                                precise float _556 = uintBitsToFloat(_413) - uintBitsToFloat(_417);
                                uint _557 = uint(int(ceil(_496))) - _552;
                                precise float _559 = (-_556) * _545;
                                precise float _560 = _542 * _539;
                                precise float _561 = _560 + _559;
                                precise float _563 = (-_506) * _542;
                                precise float _564 = _510 * _556;
                                precise float _565 = _564 + _563;
                                float _566 = 1.0 / _565;
                                precise float _568 = uintBitsToFloat(_421) * _510;
                                precise float _571 = uintBitsToFloat(_356) - uintBitsToFloat(_359);
                                precise float _572 = _566 * _549;
                                uint _573 = floatBitsToUint(_572);
                                precise float _576 = uintBitsToFloat(_362) * (-_556);
                                precise float _577 = _576 + _512;
                                precise float _580 = uintBitsToFloat(_417) * _571;
                                precise float _583 = uintBitsToFloat(_359) * (-_542);
                                precise float _584 = _583 + _568;
                                precise float _586 = _566 * _561;
                                uint _587 = floatBitsToUint(_586);
                                precise float _590 = uintBitsToFloat(_362) * _586;
                                precise float _591 = _590 + uintBitsToFloat(_532);
                                precise float _594 = uintBitsToFloat(_421) - uintBitsToFloat(_417);
                                precise float _596 = uintBitsToFloat(_356) * _594;
                                precise float _597 = _596 + _580;
                                uint _598 = floatBitsToUint(_597);
                                precise float _600 = _572 * uintBitsToFloat(_413);
                                precise float _601 = _600 + _591;
                                uvec4 _603 = uvec4(floatBitsToUint(_577), _598, floatBitsToUint(_584), floatBitsToUint(_601));
                                uint _606 = ((_490 * 12u) + 8u) + buf1_dword_off;
                                ssbo_2_1.data[_606] = _603.x;
                                ssbo_2_1.data[_606 + 1u] = _603.y;
                                ssbo_2_1.data[_606 + 2u] = _603.z;
                                ssbo_2_1.data[_606 + 3u] = _603.w;
                                uvec4 _618 = uvec4(_362, _356, _359, _587);
                                uint _620 = (_490 * 12u) + buf1_dword_off;
                                ssbo_2_1.data[_620] = _618.x;
                                ssbo_2_1.data[_620 + 1u] = _618.y;
                                ssbo_2_1.data[_620 + 2u] = _618.z;
                                ssbo_2_1.data[_620 + 3u] = _618.w;
                                uvec4 _632 = uvec4(_413, _417, _421, _573);
                                uint _635 = ((_490 * 12u) + 4u) + buf1_dword_off;
                                ssbo_2_1.data[_635] = _632.x;
                                ssbo_2_1.data[_635 + 1u] = _632.y;
                                ssbo_2_1.data[_635 + 2u] = _632.z;
                                ssbo_2_1.data[_635 + 3u] = _632.w;
                                uint _649 = uint(max(int(_553), int(_557)));
                                uint _656 = floatBitsToUint(max(uintBitsToFloat(_536), max(uintBitsToFloat(_532), uintBitsToFloat(_503))));
                                uint _662 = floatBitsToUint(min(uintBitsToFloat(_536), min(uintBitsToFloat(_532), uintBitsToFloat(_503))));
                                bool _663 = (1u == _553) && (1u == _557);
                                bool _664 = _493 && _663;
                                uint _757;
                                uint _758;
                                uint _759;
                                uint _760;
                                uint _761;
                                uint _762;
                                uint _763;
                                uint _764;
                                bool _765;
                                if (_664)
                                {
                                    uvec4 _665 = subgroupBallot(_664);
                                    uint _666 = subgroupBallotFindLSB(_665);
                                    uint _706;
                                    uint _707;
                                    uint _708;
                                    uint _709;
                                    uint _710;
                                    uint _711;
                                    if (_664 && _663)
                                    {
                                        uvec2 _677 = unpackUint2x32(packUint2x32(uvec2(_275, _171)));
                                        uint _682 = uint(bitCount(_677.x)) + uint(bitCount(_677.y));
                                        uint _686 = srt_flatbuf_1.data[40u];
                                        uint _690 = srt_flatbuf_1.data[41u];
                                        uint _694 = srt_flatbuf_1.data[42u];
                                        uint _698 = srt_flatbuf_1.data[43u];
                                        uint _701 = atomicAdd(ssbo_3_1.data[0u + buf2_dword_off], _682);
                                        uint _705 = atomicAdd(gds_buffer_1.data[((_474 << 2u) + 16u) >> 2u], _682);
                                        _706 = _682;
                                        _707 = _698;
                                        _708 = _694;
                                        _709 = _690;
                                        _710 = _686;
                                        _711 = _705;
                                    }
                                    else
                                    {
                                        _706 = _270;
                                        _707 = _524;
                                        _708 = _521;
                                        _709 = _518;
                                        _710 = _515;
                                        _711 = 0u;
                                    }
                                    uint _712 = subgroupBroadcastFirst(_711);
                                    uint _752;
                                    uint _753;
                                    uint _754;
                                    uint _755;
                                    uint _756;
                                    if (_664 && (40000u > _712))
                                    {
                                        uint _726 = srt_flatbuf_1.data[28u];
                                        uint _729 = srt_flatbuf_1.data[29u];
                                        uint _733 = srt_flatbuf_1.data[30u];
                                        uint _736 = srt_flatbuf_1.data[31u];
                                        uvec4 _738 = uvec4(_656, _662, ((bitfieldExtract(255u & _552, int(0u), int(24u)) * 256u) + (255u & _551)) | (_490 << 16u), 0u);
                                        uint _740 = (_712 * 4u) + buf3_dword_off;
                                        ssbo_4_1.data[_740] = _738.x;
                                        ssbo_4_1.data[_740 + 1u] = _738.y;
                                        ssbo_4_1.data[_740 + 2u] = _738.z;
                                        ssbo_4_1.data[_740 + 3u] = _738.w;
                                        _752 = 256u;
                                        _753 = _736;
                                        _754 = _733;
                                        _755 = _729;
                                        _756 = _726;
                                    }
                                    else
                                    {
                                        _752 = _706;
                                        _753 = _707;
                                        _754 = _708;
                                        _755 = _709;
                                        _756 = _710;
                                    }
                                    _757 = _752;
                                    _758 = _753;
                                    _759 = _754;
                                    _760 = _712;
                                    _761 = _711;
                                    _762 = _755;
                                    _763 = _756;
                                    _764 = unpackUint2x32(1ul << (packUint2x32(uvec2(_666, _469)) & 63ul)).y;
                                    _765 = _664;
                                }
                                else
                                {
                                    _757 = _270;
                                    _758 = _524;
                                    _759 = _521;
                                    _760 = _587;
                                    _761 = _503;
                                    _762 = _518;
                                    _763 = _515;
                                    _764 = _469;
                                    _765 = _663;
                                }
                                bool _767 = _493 && (!_664);
                                uint _1016;
                                uint _1017;
                                uint _1018;
                                uint _1019;
                                uint _1020;
                                uint _1021;
                                uint _1022;
                                if (_767)
                                {
                                    bool _768 = _767 && (int(8u) >= int(_649));
                                    uint _858;
                                    uint _859;
                                    uint _860;
                                    uint _861;
                                    uint _862;
                                    uint _863;
                                    uint _864;
                                    uint _865;
                                    if (_768)
                                    {
                                        uvec4 _769 = subgroupBallot(_768);
                                        uint _770 = subgroupBallotFindLSB(_769);
                                        uint _811;
                                        uint _812;
                                        uint _813;
                                        uint _814;
                                        uint _815;
                                        uint _816;
                                        if (_768 && _765)
                                        {
                                            uvec2 _781 = unpackUint2x32(packUint2x32(uvec2(_272, _276)));
                                            uint _786 = uint(bitCount(_781.x)) + uint(bitCount(_781.y));
                                            uint _791 = srt_flatbuf_1.data[36u];
                                            uint _795 = srt_flatbuf_1.data[37u];
                                            uint _799 = srt_flatbuf_1.data[38u];
                                            uint _803 = srt_flatbuf_1.data[39u];
                                            uint _806 = atomicAdd(ssbo_5_1.data[0u + buf4_dword_off], _786);
                                            uint _810 = atomicAdd(gds_buffer_1.data[((_474 << 2u) + 12u) >> 2u], _786);
                                            _811 = _786;
                                            _812 = _803;
                                            _813 = _799;
                                            _814 = _795;
                                            _815 = _791;
                                            _816 = _810;
                                        }
                                        else
                                        {
                                            _811 = _757;
                                            _812 = _758;
                                            _813 = _759;
                                            _814 = _762;
                                            _815 = _763;
                                            _816 = 0u;
                                        }
                                        uint _817 = subgroupBroadcastFirst(_816);
                                        uint _853;
                                        uint _854;
                                        uint _855;
                                        uint _856;
                                        uint _857;
                                        if (_768 && (10000u > _817))
                                        {
                                            uint _828 = srt_flatbuf_1.data[24u];
                                            uint _831 = srt_flatbuf_1.data[25u];
                                            uint _834 = srt_flatbuf_1.data[26u];
                                            uint _837 = srt_flatbuf_1.data[27u];
                                            uvec4 _839 = uvec4(_656, _662, ((bitfieldExtract(255u & _552, int(0u), int(24u)) * 256u) + (255u & _551)) | (_490 << 16u), 0u);
                                            uint _841 = (_817 * 4u) + buf5_dword_off;
                                            ssbo_6_1.data[_841] = _839.x;
                                            ssbo_6_1.data[_841 + 1u] = _839.y;
                                            ssbo_6_1.data[_841 + 2u] = _839.z;
                                            ssbo_6_1.data[_841 + 3u] = _839.w;
                                            _853 = 256u;
                                            _854 = _837;
                                            _855 = _834;
                                            _856 = _831;
                                            _857 = _828;
                                        }
                                        else
                                        {
                                            _853 = _811;
                                            _854 = _812;
                                            _855 = _813;
                                            _856 = _814;
                                            _857 = _815;
                                        }
                                        _858 = _853;
                                        _859 = _854;
                                        _860 = _855;
                                        _861 = _817;
                                        _862 = _816;
                                        _863 = _856;
                                        _864 = _857;
                                        _865 = unpackUint2x32(1ul << (packUint2x32(uvec2(_770, _764)) & 63ul)).y;
                                    }
                                    else
                                    {
                                        _858 = _757;
                                        _859 = _758;
                                        _860 = _759;
                                        _861 = _760;
                                        _862 = _761;
                                        _863 = _762;
                                        _864 = _763;
                                        _865 = _764;
                                    }
                                    bool _867 = _767 && (!_768);
                                    uint _1009;
                                    uint _1010;
                                    uint _1011;
                                    uint _1012;
                                    uint _1013;
                                    uint _1014;
                                    uint _1015;
                                    if (_867)
                                    {
                                        uint _868 = _490 << 16u;
                                        uint _1002;
                                        uint _991;
                                        uint _992;
                                        uint _993;
                                        uint _994;
                                        uint _995;
                                        uint _996;
                                        bool _998;
                                        uint _1003;
                                        uint _1004;
                                        uint _1005;
                                        uint _1006;
                                        uint _1007;
                                        uint _1008;
                                        uint _869 = _859;
                                        uint _870 = _860;
                                        uint _871 = _862;
                                        uint _872 = _863;
                                        uint _873 = _864;
                                        uint _874 = _865;
                                        uint _875 = 0u;
                                        bool _876 = _867;
                                        uint _877 = 0u;
                                        for (;;)
                                        {
                                            bool _879 = _876 && (0u >= _877);
                                            if (!_879)
                                            {
                                                _1003 = _875;
                                                _1004 = _869;
                                                _1005 = _870;
                                                _1006 = _871;
                                                _1007 = _872;
                                                _1008 = _873;
                                                break;
                                            }
                                            else
                                            {
                                                uint _884 = (255u & (_875 + _552)) << 8u;
                                                bool _886 = (int(_875) < int(_557)) || (!_879);
                                                bool _887 = _876 && _886;
                                                if (!(_879 && _886))
                                                {
                                                    _1003 = _875;
                                                    _1004 = _869;
                                                    _1005 = _870;
                                                    _1006 = _871;
                                                    _1007 = _872;
                                                    _1008 = _873;
                                                    break;
                                                }
                                                else
                                                {
                                                    uint _916;
                                                    bool _956;
                                                    uint _965;
                                                    uint _967;
                                                    uint _970;
                                                    uint _973;
                                                    uint _990;
                                                    uint _951;
                                                    uint _997;
                                                    uint _890 = _869;
                                                    uint _891 = _870;
                                                    uint _892 = _871;
                                                    uint _893 = _872;
                                                    uint _894 = _873;
                                                    uint _895 = _874;
                                                    uint _896 = 0u;
                                                    bool _897 = _887;
                                                    uint _898 = _877;
                                                    for (;;)
                                                    {
                                                        if (!(_897 && (2u >= _898)))
                                                        {
                                                            _991 = _890;
                                                            _992 = _891;
                                                            _993 = _892;
                                                            _994 = _893;
                                                            _995 = _894;
                                                            _996 = _895;
                                                            _997 = _898;
                                                            _998 = _897;
                                                            break;
                                                        }
                                                        else
                                                        {
                                                            uint _905 = floatBitsToUint((int(_896) < int(_553)) ? 4.2038953929744512127711887498697e-45 : 7.0064923216240853546186479164496e-45);
                                                            bool _907 = _897 && (3u >= _905);
                                                            if (!_907)
                                                            {
                                                                _991 = _890;
                                                                _992 = _891;
                                                                _993 = _892;
                                                                _994 = _893;
                                                                _995 = _894;
                                                                _996 = _895;
                                                                _997 = _905;
                                                                _998 = _897;
                                                                break;
                                                            }
                                                            else
                                                            {
                                                                _916 = unpackUint2x32(1ul << (packUint2x32(uvec2(subgroupBallotFindLSB(subgroupBallot(_907)), _895)) & 63ul)).y;
                                                                uint _947;
                                                                uint _948;
                                                                uint _949;
                                                                uint _950;
                                                                if (_907 && _907)
                                                                {
                                                                    uvec2 _921 = unpackUint2x32(packUint2x32(uvec2(_272, _276)));
                                                                    uint _926 = uint(bitCount(_921.x)) + uint(bitCount(_921.y));
                                                                    uint _930 = srt_flatbuf_1.data[32u];
                                                                    uint _933 = srt_flatbuf_1.data[33u];
                                                                    uint _936 = srt_flatbuf_1.data[34u];
                                                                    uint _939 = srt_flatbuf_1.data[35u];
                                                                    uint _942 = atomicAdd(ssbo_7_1.data[0u + buf6_dword_off], _926);
                                                                    uint _946 = atomicAdd(gds_buffer_1.data[((_474 << 2u) + 8u) >> 2u], _926);
                                                                    _947 = _939;
                                                                    _948 = _936;
                                                                    _949 = _933;
                                                                    _950 = _930;
                                                                    _951 = _946;
                                                                }
                                                                else
                                                                {
                                                                    _947 = _890;
                                                                    _948 = _891;
                                                                    _949 = _893;
                                                                    _950 = _894;
                                                                    _951 = 0u;
                                                                }
                                                                uint _952 = subgroupBroadcastFirst(_951);
                                                                bool _954 = 1000u <= _952;
                                                                _956 = _897 && (!_954);
                                                                if (!(_907 && (!_954)))
                                                                {
                                                                    _991 = _947;
                                                                    _992 = _948;
                                                                    _993 = _951;
                                                                    _994 = _949;
                                                                    _995 = _950;
                                                                    _996 = _916;
                                                                    _997 = _905;
                                                                    _998 = _956;
                                                                    break;
                                                                }
                                                                else
                                                                {
                                                                    _965 = srt_flatbuf_1.data[20u];
                                                                    _967 = srt_flatbuf_1.data[21u];
                                                                    _970 = srt_flatbuf_1.data[22u];
                                                                    _973 = srt_flatbuf_1.data[23u];
                                                                    uvec4 _975 = uvec4(_656, _662, (_868 | _884) | (255u & (_896 + _551)), 0u);
                                                                    uint _977 = (_952 * 4u) + buf7_dword_off;
                                                                    ssbo_8_1.data[_977] = _975.x;
                                                                    ssbo_8_1.data[_977 + 1u] = _975.y;
                                                                    ssbo_8_1.data[_977 + 2u] = _975.z;
                                                                    ssbo_8_1.data[_977 + 3u] = _975.w;
                                                                    _990 = _896 + 64u;
                                                                    if (true)
                                                                    {
                                                                        _890 = _973;
                                                                        _891 = _970;
                                                                        _892 = _951;
                                                                        _893 = _967;
                                                                        _894 = _965;
                                                                        _895 = _916;
                                                                        _896 = _990;
                                                                        _897 = _956;
                                                                        _898 = 2u;
                                                                        continue;
                                                                    }
                                                                    else
                                                                    {
                                                                        _991 = _973;
                                                                        _992 = _970;
                                                                        _993 = _951;
                                                                        _994 = _967;
                                                                        _995 = _965;
                                                                        _996 = _916;
                                                                        _997 = 2u;
                                                                        _998 = _956;
                                                                        break;
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                    if (!(_998 && (5u >= _997)))
                                                    {
                                                        _1003 = _875;
                                                        _1004 = _991;
                                                        _1005 = _992;
                                                        _1006 = _993;
                                                        _1007 = _994;
                                                        _1008 = _995;
                                                        break;
                                                    }
                                                    else
                                                    {
                                                        _1002 = _875 + 64u;
                                                        if (true)
                                                        {
                                                            _869 = _991;
                                                            _870 = _992;
                                                            _871 = _993;
                                                            _872 = _994;
                                                            _873 = _995;
                                                            _874 = _996;
                                                            _875 = _1002;
                                                            _876 = _998;
                                                            _877 = 0u;
                                                            continue;
                                                        }
                                                        else
                                                        {
                                                            _1003 = _1002;
                                                            _1004 = _991;
                                                            _1005 = _992;
                                                            _1006 = _993;
                                                            _1007 = _994;
                                                            _1008 = _995;
                                                            break;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        _1009 = _1003;
                                        _1010 = _1004;
                                        _1011 = _1005;
                                        _1012 = _868;
                                        _1013 = _1006;
                                        _1014 = _1007;
                                        _1015 = _1008;
                                    }
                                    else
                                    {
                                        _1009 = _858;
                                        _1010 = _859;
                                        _1011 = _860;
                                        _1012 = _861;
                                        _1013 = _862;
                                        _1014 = _863;
                                        _1015 = _864;
                                    }
                                    _1016 = _1009;
                                    _1017 = _1010;
                                    _1018 = _1011;
                                    _1019 = _1012;
                                    _1020 = _1013;
                                    _1021 = _1014;
                                    _1022 = _1015;
                                }
                                else
                                {
                                    _1016 = _757;
                                    _1017 = _758;
                                    _1018 = _759;
                                    _1019 = _760;
                                    _1020 = _761;
                                    _1021 = _762;
                                    _1022 = _763;
                                }
                                _1023 = _1016;
                                _1024 = _573;
                                _1025 = _1017;
                                _1026 = _1018;
                                _1027 = _598;
                                _1028 = _649;
                                _1029 = _1019;
                                _1030 = _1020;
                                _1031 = _1021;
                                _1032 = _1022;
                            }
                            else
                            {
                                _1023 = _270;
                                _1024 = _260;
                                _1025 = _262;
                                _1026 = _488;
                                _1027 = _265;
                                _1028 = _266;
                                _1029 = 0u;
                                _1030 = _489;
                                _1031 = _268;
                                _1032 = _424;
                            }
                            _1033 = _1023;
                            _1034 = _1024;
                            _1035 = _1025;
                            _1036 = _1026;
                            _1037 = _1027;
                            _1038 = _1028;
                            _1039 = _1029;
                            _1040 = _1030;
                            _1041 = _1031;
                            _1042 = _1032;
                            _1043 = 4u;
                        }
                        else
                        {
                            _1033 = _270;
                            _1034 = _260;
                            _1035 = _262;
                            _1036 = _263;
                            _1037 = _265;
                            _1038 = _266;
                            _1039 = _456;
                            _1040 = _457;
                            _1041 = _268;
                            _1042 = _424;
                            _1043 = _458;
                        }
                        bool _1045 = _406 && (3u >= _1043);
                        uint _1065;
                        uint _1066;
                        if (_1045)
                        {
                            uint _1063;
                            uint _1064;
                            if (_1045 && _1045)
                            {
                                uint _1049 = srt_flatbuf_1.data[47u];
                                uvec2 _1052 = unpackUint2x32(packUint2x32(uvec2(_1042, _1041)));
                                uint _1058 = _1049 << 2u;
                                uint _1062 = atomicAdd(gds_buffer_1.data[(_1058 + 48u) >> 2u], uint(bitCount(_1052.x)) + uint(bitCount(_1052.y)));
                                _1063 = _1049;
                                _1064 = _1058;
                            }
                            else
                            {
                                _1063 = _1033;
                                _1064 = _1040;
                            }
                            _1065 = _1063;
                            _1066 = _1064;
                        }
                        else
                        {
                            _1065 = _1033;
                            _1066 = _1040;
                        }
                        _1067 = _1065;
                        _1068 = _1034;
                        _1069 = _1035;
                        _1070 = _1036;
                        _1071 = _1041;
                        _1072 = _1042;
                        _1073 = _1037;
                        _1074 = _1038;
                        _1075 = _1039;
                        _1076 = _1066;
                        _1077 = 4u;
                    }
                    else
                    {
                        _1067 = _270;
                        _1068 = _260;
                        _1069 = _262;
                        _1070 = _263;
                        _1071 = _268;
                        _1072 = _339;
                        _1073 = _265;
                        _1074 = _266;
                        _1075 = _402;
                        _1076 = _403;
                        _1077 = _404;
                    }
                    bool _1079 = _343 && (3u >= _1077);
                    bool _1099;
                    uint _1100;
                    bool _1101;
                    uint _1102;
                    if (_1079)
                    {
                        bool _1080 = _1079 && _1079;
                        uint _1097;
                        uint _1098;
                        if (_1080)
                        {
                            uint _1083 = srt_flatbuf_1.data[47u];
                            uvec2 _1086 = unpackUint2x32(packUint2x32(uvec2(push_data.ud_regs0.z, push_data.ud_regs0.w)));
                            uint _1092 = _1083 << 2u;
                            uint _1096 = atomicAdd(gds_buffer_1.data[(_1092 + 48u) >> 2u], uint(bitCount(_1086.x)) + uint(bitCount(_1086.y)));
                            _1097 = _1083;
                            _1098 = _1092;
                        }
                        else
                        {
                            _1097 = _271;
                            _1098 = _1076;
                        }
                        _1099 = _1079;
                        _1100 = _1097;
                        _1101 = _1080;
                        _1102 = _1098;
                    }
                    else
                    {
                        _1099 = _343;
                        _1100 = _271;
                        _1101 = _1079;
                        _1102 = _1076;
                    }
                    _1103 = _1067;
                    _1104 = _1068;
                    _1105 = _1099;
                    _1106 = _1069;
                    _1107 = _1070;
                    _1108 = _1071;
                    _1109 = _1072;
                    _1110 = _1073;
                    _1111 = _1100;
                    _1112 = _1101;
                    _1113 = _1074;
                    _1114 = _1075;
                    _1115 = _1102;
                }
                else
                {
                    _1103 = _270;
                    _1104 = _260;
                    _1105 = _273;
                    _1106 = _262;
                    _1107 = _263;
                    _1108 = _268;
                    _1109 = _339;
                    _1110 = _265;
                    _1111 = _271;
                    _1112 = _343;
                    _1113 = _266;
                    _1114 = _340;
                    _1115 = _274;
                }
                if (true)
                {
                    break;
                }
                else
                {
                    _1116 = _1103;
                    _1117 = _1104;
                    _1118 = _1105;
                    _1119 = _1106;
                    _1120 = _1107;
                    _1121 = _1108;
                    _1122 = _1109;
                    _1123 = _1110;
                    _1124 = _1111;
                    _1125 = _1112;
                    _1126 = _1113;
                    _1127 = _1114;
                    _1128 = _1115;
                }
            }
            else
            {
                _1116 = _270;
                _1117 = _260;
                _1118 = _261;
                _1119 = _262;
                _1120 = _263;
                _1121 = _268;
                _1122 = _264;
                _1123 = _265;
                _1124 = _271;
                _1125 = _273;
                _1126 = _266;
                _1127 = _267;
                _1128 = _274;
            }
            _1130 = _275 + 4294967295u;
            uint _1136 = floatBitsToUint((_1130 == _1127) ? 0.0 : uintBitsToFloat(_1126));
            bool _1137 = _1125 && ((_275 << 2u) > _1128);
            uint _1207;
            uint _1208;
            uint _1209;
            uint _1210;
            uint _1212;
            uint _1213;
            if (_1137)
            {
                uint _1139 = _272 + (_1136 << 2u);
                uint _1140 = _276 >> 1u;
                uint _1141 = _272 + _1123;
                uint _1152 = ((_1140 + _1139) << 2u) >> 2u;
                uint _1156 = ((_1139 << 2u) + 12u) >> 2u;
                uint _1159 = ((_1140 + _1141) << 2u) >> 2u;
                uint _1163 = ((_1141 << 2u) + 12u) >> 2u;
                bool _1172 = uintBitsToFloat(shared_mem_u32[_1152]) <= uintBitsToFloat(shared_mem_u32[_1156]);
                bool _1175 = uintBitsToFloat(shared_mem_u32[_1159]) <= uintBitsToFloat(shared_mem_u32[_1163]);
                uint _1205;
                uint _1206;
                if (!(((4u == _276) ? _1137 : false) && ((0u != srt_flatbuf_1.data[46u]) ? _1137 : false)))
                {
                    bool _1192 = (0u == (_276 & 1u)) ? _1137 : false;
                    _1205 = floatBitsToUint(((_1175 && (!_1192)) || (((-uintBitsToFloat(shared_mem_u32[_1163])) <= uintBitsToFloat(shared_mem_u32[_1159])) && _1192)) ? 1.4012984643248170709237295832899e-45 : 0.0);
                    _1206 = floatBitsToUint(((_1172 && (!_1192)) || (((-uintBitsToFloat(shared_mem_u32[_1156])) <= uintBitsToFloat(shared_mem_u32[_1152])) && _1192)) ? 1.4012984643248170709237295832899e-45 : 0.0);
                }
                else
                {
                    _1205 = floatBitsToUint(_1175 ? 1.4012984643248170709237295832899e-45 : 0.0);
                    _1206 = floatBitsToUint(_1172 ? 1.4012984643248170709237295832899e-45 : 0.0);
                }
                _1207 = shared_mem_u32[_1156];
                _1208 = shared_mem_u32[_1163];
                _1209 = shared_mem_u32[_1159];
                _1210 = shared_mem_u32[_1152];
                _1211 = srt_flatbuf_1.data[46u];
                _1212 = _1205;
                _1213 = _1206;
            }
            else
            {
                _1207 = 0u;
                _1208 = 0u;
                _1209 = 0u;
                _1210 = 0u;
                _1211 = _1122;
                _1212 = 0u;
                _1213 = 0u;
            }
            uvec2 _1216 = unpackUint2x32(packUint2x32(uvec2(_1211, _1121)));
            uvec2 _1224 = unpackUint2x32(packUint2x32(uvec2(_1120, _1119)));
            uint _1229 = uint(bitCount(_1224.x)) + uint(bitCount(_1224.y));
            _1230 = _1229 + (uint(bitCount(_1216.x)) + uint(bitCount(_1216.y)));
            if (!(0u != _1230))
            {
                break;
            }
            else
            {
                if (!(_1125 && (((_275 == _1230) ? _1125 : false) && ((0u == _1229) ? _1125 : false))))
                {
                    bool _1241 = _1125 && (_1212 != _1213);
                    uint _1335;
                    uint _1336;
                    uint _1337;
                    if (_1241)
                    {
                        uint _1249 = _276 & 1u;
                        bool _1250 = ((4u == _276) ? _1241 : false) && ((0u != srt_flatbuf_1.data[46u]) ? _1241 : false);
                        uint _1271;
                        uint _1272;
                        uint _1273;
                        if (_1250)
                        {
                            precise float _1258 = (-uintBitsToFloat(_1209)) + (-uintBitsToFloat(_1208));
                            precise float _1260 = _1258 + uintBitsToFloat(_1207);
                            precise float _1263 = _1260 + uintBitsToFloat(_1210);
                            precise float _1267 = uintBitsToFloat(_1208) - uintBitsToFloat(_1209);
                            precise float _1269 = (1.0 / _1263) * _1267;
                            _1271 = floatBitsToUint(_1260);
                            _1272 = floatBitsToUint(_1267);
                            _1273 = floatBitsToUint(_1269);
                        }
                        else
                        {
                            _1271 = _1207;
                            _1272 = _1209;
                            _1273 = _1210;
                        }
                        uint _1309;
                        if (!_1250)
                        {
                            bool _1274 = _1241 && ((0u != _1249) ? _1241 : false);
                            uint _1293;
                            uint _1294;
                            uint _1295;
                            if (_1274)
                            {
                                precise float _1280 = (-uintBitsToFloat(_1272)) + (-uintBitsToFloat(_1271));
                                precise float _1282 = _1280 + uintBitsToFloat(_1208);
                                precise float _1285 = _1282 + uintBitsToFloat(_1273);
                                precise float _1289 = uintBitsToFloat(_1208) - uintBitsToFloat(_1272);
                                precise float _1291 = (1.0 / _1285) * _1289;
                                _1293 = floatBitsToUint(_1282);
                                _1294 = floatBitsToUint(_1289);
                                _1295 = floatBitsToUint(_1291);
                            }
                            else
                            {
                                _1293 = _1271;
                                _1294 = _1272;
                                _1295 = _1273;
                            }
                            uint _1308;
                            if (!_1274)
                            {
                                precise float _1300 = (-uintBitsToFloat(_1208)) + (-uintBitsToFloat(_1294));
                                precise float _1302 = _1300 + uintBitsToFloat(_1293);
                                precise float _1304 = _1302 + uintBitsToFloat(_1295);
                                precise float _1306 = (1.0 / _1304) * _1300;
                                _1308 = floatBitsToUint(_1306);
                            }
                            else
                            {
                                _1308 = _1295;
                            }
                            _1309 = _1308;
                        }
                        else
                        {
                            _1309 = _1273;
                        }
                        uint _1310 = _272 + _1117;
                        uint _1316 = ((_1310 + _1123) << 2u) >> 2u;
                        precise float _1325 = uintBitsToFloat(shared_mem_u32[((_1310 + (_1136 << 2u)) << 2u) >> 2u]) - uintBitsToFloat(shared_mem_u32[_1316]);
                        precise float _1330 = _1325 * uintBitsToFloat(_1309);
                        precise float _1331 = _1330 + uintBitsToFloat(shared_mem_u32[_1316]);
                        shared_mem_u32[((_1116 + _1117) << 2u) >> 2u] = floatBitsToUint(_1331);
                        _1335 = _1249;
                        _1336 = srt_flatbuf_1.data[46u];
                        _1337 = _1117 + 4u;
                    }
                    else
                    {
                        _1335 = _1119;
                        _1336 = _1120;
                        _1337 = _1117;
                    }
                    if (_1125 && (0u != _1213))
                    {
                        shared_mem_u32[((_1116 + _1337) << 2u) >> 2u] = shared_mem_u32[(((_272 + _1117) + (_1136 << 2u)) << 2u) >> 2u];
                    }
                    _1353 = _272 ^ 32u;
                    _1354 = _1335;
                    _1355 = _1336;
                    _1356 = _1116 ^ 32u;
                }
                else
                {
                    _1353 = _272;
                    _1354 = _1119;
                    _1355 = _1120;
                    _1356 = _1116;
                }
                _1357 = _276 + 1u;
                if (true)
                {
                    _260 = _1117;
                    _261 = _1118;
                    _262 = _1354;
                    _263 = _1355;
                    _264 = _1211;
                    _265 = _1123;
                    _266 = _1126;
                    _267 = _1127;
                    _268 = _1121;
                    _269 = _1130;
                    _270 = _1356;
                    _271 = _1124;
                    _272 = _1353;
                    _273 = _1125;
                    _274 = _1128;
                    _275 = _1230;
                    _276 = _1357;
                    continue;
                }
                else
                {
                    break;
                }
            }
        }
    }
}

