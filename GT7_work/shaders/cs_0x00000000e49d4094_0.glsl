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

#if defined(GL_KHR_shader_subgroup_basic)
#extension GL_KHR_shader_subgroup_basic : require
#elif defined(GL_ARB_shader_ballot) && defined(GL_ARB_shader_int64)
#extension GL_ARB_shader_int64 : enable
#extension GL_ARB_shader_ballot : require
#elif defined(GL_NV_shader_thread_group)
#extension GL_NV_shader_thread_group : require
#else
#error No extensions available to emulate requested subgroup feature.
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

layout(binding = 0, std430) readonly buffer ssbo_1
{
    uint data[];
} ssbo_1_1;

layout(binding = 1, std430) readonly buffer ssbo_2
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

layout(binding = 4, std430) buffer gds_buffer
{
    uint data[];
} gds_buffer_1;

layout(binding = 5, std430) readonly buffer srt_flatbuf
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

#if defined(GL_KHR_shader_subgroup_basic)
#elif defined(GL_ARB_shader_ballot)
#define gl_SubgroupInvocationID gl_SubGroupInvocationARB
#elif defined(GL_NV_shader_thread_group)
#define gl_SubgroupInvocationID gl_ThreadInWarpNV
#endif

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

void main()
{
    uint buf0_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(0u), int(8u)) >> 2u;
    uint buf1_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(8u), int(8u)) >> 2u;
    uint buf2_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(16u), int(8u)) >> 2u;
    uint _126 = (gl_WorkGroupID.x << 4u) >> 2u;
    uint _127 = _126 + buf0_dword_off;
    uint _129 = ssbo_1_1.data[_127];
    uint _131 = (_126 + 1u) + buf0_dword_off;
    uint _133 = ssbo_1_1.data[_131];
    uint _135 = (_126 + 2u) + buf0_dword_off;
    uint _137 = ssbo_1_1.data[_135];
    uint _140 = (_126 + 3u) + buf0_dword_off;
    uint _142 = ssbo_1_1.data[_140];
    uint _144 = _129 & 65535u;
    uint _145 = _129 >> 16u;
    uint _146 = _133 & 65535u;
    uint _147 = _133 >> 16u;
    uint _153;
    uint _154;
    uint _158;
    uint _159;
    uint _160;
    uint _167;
    uint _148 = 0u;
    for (;;)
    {
        _153 = _144 >> (_148 & 31u);
        _154 = (_146 >> (_148 & 31u)) - _153;
        _158 = _145 >> (_148 & 31u);
        _159 = (_147 >> (_148 & 31u)) - _158;
        _160 = _148 + 1u;
        uint _161 = _159 + 1u;
        if (!((_161 + (_154 * _161)) > 64u))
        {
            _167 = _148;
            break;
        }
        else
        {
            if (true)
            {
                _148 = _160;
                continue;
            }
            else
            {
                _167 = _160;
                break;
            }
        }
    }
    uint _168 = _154 + 1u;
    bool _171 = 0u != _167;
    bool _172 = (_168 + (_168 * _159)) > gl_LocalInvocationID.x;
    uint _439;
    uint _440;
    bool _441;
    uint _442;
    uint _443;
    uint _444;
    uint _445;
    uint _446;
    if (_171)
    {
        uint _431;
        uint _432;
        bool _433;
        uint _434;
        uint _435;
        uint _436;
        uint _437;
        uint _438;
        if (_172)
        {
            precise float _178 = 4294967296.0 * (1.0 / float(_168));
            uint _179 = uint(_178);
            uvec2 _184 = unpackUint2x32((uint64_t(_168) * uint64_t(_179)) + 0ul);
            uint _185 = _184.x;
            bool _187 = 0u != _184.y;
            full_result_u32x2 _193;
            umulExtended(floatBitsToUint(_187 ? uintBitsToFloat(_185) : uintBitsToFloat(0u - _185)), _179, _193._m1, _193._m0);
            full_result_u32x2 _201;
            umulExtended(floatBitsToUint(_187 ? uintBitsToFloat(_179 - _193._m1) : uintBitsToFloat(_179 + _193._m1)), gl_LocalInvocationID.x, _201._m1, _201._m0);
            uint _203 = _168 * _201._m1;
            bool _206 = gl_LocalInvocationID.x >= _203;
            full_result_u32x2 _209;
            _209._m0 = uaddCarry(0u, _201._m1, _209._m1);
            full_result_u32x2 _211;
            _211._m0 = uaddCarry(_209._m0, uint(_206 && (_168 <= (gl_LocalInvocationID.x - _203))), _211._m1);
            full_result_u32x2 _215;
            _215._m0 = uaddCarry(4294967295u, _211._m0, _215._m1);
            full_result_u32x2 _217;
            _217._m0 = uaddCarry(_215._m0, uint(_206), _217._m1);
            uint _224 = floatBitsToUint(((4294967295u != _154) ? _172 : false) ? uintBitsToFloat(_217._m0) : uintBitsToFloat(0xffffffffu /* nan */));
            uint _227 = _153 + (gl_LocalInvocationID.x - (_168 * _224));
            uint _234 = _158 + _224;
            uint _245 = srt_flatbuf_1.data[34u];
            uint _260 = srt_flatbuf_1.data[18u];
            uint _262 = srt_flatbuf_1.data[19u];
            uint _265 = _245 * (srt_flatbuf_1.data[35u] << 1u);
            uint _278 = gds_buffer_1.data[((_167 + (_245 * 5u)) << 2u) >> 2u] * _234;
            uint _305 = floatBitsToUint(_172 ? ((uintBitsToFloat(_137) > uintBitsToFloat(ssbo_2_1.data[((gds_buffer_1.data[((_167 + _265) << 2u) >> 2u] + _227) + _278) + buf1_dword_off])) ? (((uintBitsToFloat(_137) > uintBitsToFloat(ssbo_2_1.data[((gds_buffer_1.data[(((_167 + _245) + _265) << 2u) >> 2u] + _227) + _278) + buf1_dword_off])) || ((((_144 <= (_227 << (_167 & 31u))) && (_146 >= (((_227 + 1u) << (_167 & 31u)) + 4294967295u))) && (_145 <= (_234 << (_167 & 31u)))) && (_147 >= (((_234 + 1u) << (_167 & 31u)) + 4294967295u)))) ? 1.4012984643248170709237295832899e-45 : 3.5873240686715317015647477332222e-43) : 0.0) : 0.0);
            uint _311 = subgroupBroadcast(_305, ((gl_SubgroupInvocationID & 255u) | 0u) ^ 16u);
            uint _312 = _305 + _311;
            uint _317 = subgroupBroadcast(_312, ((gl_SubgroupInvocationID & 255u) | 0u) ^ 8u);
            uint _318 = _312 + _317;
            uint _323 = subgroupBroadcast(_318, ((gl_SubgroupInvocationID & 255u) | 0u) ^ 4u);
            uint _324 = _318 + _323;
            uint _329 = subgroupBroadcast(_324, ((gl_SubgroupInvocationID & 255u) | 0u) ^ 2u);
            uint _330 = _324 + _329;
            uint _335 = subgroupBroadcast(_330, ((gl_SubgroupInvocationID & 255u) | 0u) ^ 1u);
            uint _336 = _330 + _335;
            uint _337 = subgroupBroadcast(_336, 31u);
            uint _339 = subgroupBroadcast(_336, 63u);
            uint _340 = _337 + _339;
            bool _342 = _172 && (0u == gl_LocalInvocationID.x);
            uint _426;
            uint _427;
            bool _428;
            uint _429;
            uint _430;
            if (_342)
            {
                uint _348 = ((_340 & 255u) != 0u) ? 2u : ((_340 <= 255u) ? 9u : 0u);
                bool _349 = 0u != _348;
                uint _371;
                uint _372;
                uint _373;
                uint _374;
                uint _375;
                bool _376;
                if (_349)
                {
                    uint _355 = srt_flatbuf_1.data[28u];
                    uint _359 = srt_flatbuf_1.data[29u];
                    uint _363 = srt_flatbuf_1.data[30u];
                    uint _366 = srt_flatbuf_1.data[31u];
                    bool _368 = _342 && (_363 > _142);
                    if (_368)
                    {
                        ssbo_3_1.data[_142 + buf2_dword_off] = _348;
                    }
                    _371 = _348;
                    _372 = _366;
                    _373 = _363;
                    _374 = _359;
                    _375 = _355;
                    _376 = _368;
                }
                else
                {
                    _371 = gl_LocalInvocationID.x;
                    _372 = _144;
                    _373 = push_data.ud_regs0.z;
                    _374 = push_data.ud_regs0.y;
                    _375 = push_data.ud_regs0.x;
                    _376 = _342;
                }
                uint _422;
                uint _423;
                uint _424;
                uint _425;
                if (!_349)
                {
                    uint _396;
                    if (_376 && _342)
                    {
                        uvec2 _385 = unpackUint2x32(packUint2x32(uvec2(_373, _372)));
                        uint _395 = atomicAdd(gds_buffer_1.data[((srt_flatbuf_1.data[33u] << 2u) + 24u) >> 2u], uint(bitCount(_385.x)) + uint(bitCount(_385.y)));
                        _396 = _395;
                    }
                    else
                    {
                        _396 = 0u;
                    }
                    uint _400 = srt_flatbuf_1.data[24u];
                    uint _403 = srt_flatbuf_1.data[25u];
                    uint _407 = srt_flatbuf_1.data[27u];
                    uvec4 _408 = uvec4(_129, _133, _137, _142);
                    uint _410 = (subgroupBroadcastFirst(_396) * 4u) + (bitfieldExtract(push_data.buf_offsets0.x, int(24u), int(8u)) >> 2u);
                    ssbo_4_1.data[_410] = _408.x;
                    ssbo_4_1.data[_410 + 1u] = _408.y;
                    ssbo_4_1.data[_410 + 2u] = _408.z;
                    ssbo_4_1.data[_410 + 3u] = _408.w;
                    _422 = _403;
                    _423 = _400;
                    _424 = _129;
                    _425 = _407;
                }
                else
                {
                    _422 = _374;
                    _423 = _375;
                    _424 = _371;
                    _425 = _372;
                }
                _426 = _422;
                _427 = _423;
                _428 = _376;
                _429 = _424;
                _430 = _425;
            }
            else
            {
                _426 = push_data.ud_regs0.y;
                _427 = push_data.ud_regs0.x;
                _428 = _342;
                _429 = gl_LocalInvocationID.x;
                _430 = _144;
            }
            _431 = _426;
            _432 = _427;
            _433 = _428;
            _434 = _429;
            _435 = _245;
            _436 = _262;
            _437 = _260;
            _438 = _430;
        }
        else
        {
            _431 = push_data.ud_regs0.y;
            _432 = push_data.ud_regs0.x;
            _433 = _172;
            _434 = gl_LocalInvocationID.x;
            _435 = _147;
            _436 = _146;
            _437 = _145;
            _438 = _144;
        }
        _439 = _431;
        _440 = _432;
        _441 = _433;
        _442 = _434;
        _443 = _435;
        _444 = _436;
        _445 = _437;
        _446 = _438;
    }
    else
    {
        _439 = push_data.ud_regs0.y;
        _440 = push_data.ud_regs0.x;
        _441 = true;
        _442 = gl_LocalInvocationID.x;
        _443 = _147;
        _444 = _146;
        _445 = _145;
        _446 = _144;
    }
    if (!_171)
    {
        uint _447 = _444 - _446;
        uint _448 = _447 + 1u;
        bool _453 = _441 && ((_448 + (_448 * (_443 - _445))) > _442);
        if (_453)
        {
            precise float _456 = 4294967296.0 * (1.0 / float(_448));
            uint _457 = uint(_456);
            uvec2 _462 = unpackUint2x32((uint64_t(_448) * uint64_t(_457)) + 0ul);
            uint _463 = _462.x;
            bool _465 = 0u != _462.y;
            full_result_u32x2 _471;
            umulExtended(floatBitsToUint(_465 ? uintBitsToFloat(_463) : uintBitsToFloat(0u - _463)), _457, _471._m1, _471._m0);
            full_result_u32x2 _479;
            umulExtended(floatBitsToUint(_465 ? uintBitsToFloat(_457 - _471._m1) : uintBitsToFloat(_457 + _471._m1)), _442, _479._m1, _479._m0);
            uint _481 = _448 * _479._m1;
            bool _484 = _442 >= _481;
            full_result_u32x2 _487;
            _487._m0 = uaddCarry(0u, _479._m1, _487._m1);
            full_result_u32x2 _489;
            _489._m0 = uaddCarry(_487._m0, uint(_484 && (_448 <= (_442 - _481))), _489._m1);
            full_result_u32x2 _492;
            _492._m0 = uaddCarry(4294967295u, _489._m0, _492._m1);
            full_result_u32x2 _494;
            _494._m0 = uaddCarry(_492._m0, uint(_484), _494._m1);
            uint _505 = floatBitsToUint(((4294967295u != _447) ? _453 : false) ? uintBitsToFloat(_494._m0) : uintBitsToFloat(0xffffffffu /* nan */));
            uint _530 = floatBitsToUint(_453 ? ((uintBitsToFloat(_137) > uintBitsToFloat(ssbo_2_1.data[(((_446 + (_442 - (_448 * _505))) + gds_buffer_1.data[((srt_flatbuf_1.data[34u] * srt_flatbuf_1.data[35u]) << 3u) >> 2u]) + (srt_flatbuf_1.data[32u] * (_445 + _505))) + buf1_dword_off])) ? 1.4012984643248170709237295832899e-45 : 0.0) : 0.0);
            uint _536 = _530 + subgroupBroadcast(_530, ((gl_SubgroupInvocationID & 255u) | 0u) ^ 16u);
            uint _542 = _536 + subgroupBroadcast(_536, ((gl_SubgroupInvocationID & 255u) | 0u) ^ 8u);
            uint _547 = subgroupBroadcast(_542, ((gl_SubgroupInvocationID & 255u) | 0u) ^ 4u);
            uint _548 = _542 + _547;
            uint _553 = subgroupBroadcast(_548, ((gl_SubgroupInvocationID & 255u) | 0u) ^ 2u);
            uint _554 = _548 + _553;
            uint _559 = subgroupBroadcast(_554, ((gl_SubgroupInvocationID & 255u) | 0u) ^ 1u);
            uint _560 = _554 + _559;
            uint _561 = subgroupBroadcast(_560, 31u);
            uint _562 = subgroupBroadcast(_560, 63u);
            bool _565 = _453 && (0u == _442);
            if (_565)
            {
                if (_565 && (srt_flatbuf_1.data[30u] > _142))
                {
                    ssbo_3_1.data[_142 + buf2_dword_off] = (int(_561 + _562) > int(0u)) ? 2u : 9u;
                }
            }
        }
    }
}

