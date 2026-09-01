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

layout(binding = 0, std430) buffer ssbo_1
{
    uint data[];
} ssbo_1_1;

layout(binding = 1, std430) readonly buffer srt_flatbuf
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
    uint _98 = (gl_WorkGroupID.y << 3u) + gl_LocalInvocationID.y;
    uint _103 = srt_flatbuf_1.data[25u];
    uint _112 = srt_flatbuf_1.data[20u];
    uint _118 = _103 * (_98 << 1u);
    uint _119 = (gl_WorkGroupID.x << 3u) + gl_LocalInvocationID.x;
    uint _121 = _119 << 1u;
    uint _123 = (_112 + _118) + _121;
    uint _127 = srt_flatbuf_1.data[18u];
    uint _130 = ((_103 + _112) + _121) + _118;
    uint _133 = (_123 + 1u) + buf0_dword_off;
    uint _135 = ssbo_1_1.data[_133];
    uint _136 = _123 + buf0_dword_off;
    uint _138 = ssbo_1_1.data[_136];
    uint _140 = (_130 + 1u) + buf0_dword_off;
    uint _142 = ssbo_1_1.data[_140];
    uint _143 = _130 + buf0_dword_off;
    uint _145 = ssbo_1_1.data[_143];
    uint _149 = (srt_flatbuf_1.data[21u] + _119) + (srt_flatbuf_1.data[26u] * _98);
    bool _153 = (0u == (1u & _119)) && (0u == (1u & _98));
    float _166 = max(uintBitsToFloat(_142), max(max(uintBitsToFloat(_138), uintBitsToFloat(_135)), uintBitsToFloat(_145)));
    uint _167 = floatBitsToUint(_166);
    uint _173 = subgroupBroadcast(_167, ((gl_SubgroupInvocationID & 255u) | 0u) ^ 1u);
    if (_127 > _149)
    {
        ssbo_1_1.data[_149 + buf0_dword_off] = _167;
    }
    float _190 = max(uintBitsToFloat(subgroupBroadcast(floatBitsToUint(max(uintBitsToFloat(_173), max(max(uintBitsToFloat(_145), max(uintBitsToFloat(_138), uintBitsToFloat(_135))), uintBitsToFloat(_142)))), ((gl_SubgroupInvocationID & 255u) | 0u) ^ 8u)), max(uintBitsToFloat(_173), _166));
    uint _191 = floatBitsToUint(_190);
    if (_153)
    {
        uint _205 = srt_flatbuf_1.data[27u] * _98;
        uint _211 = (srt_flatbuf_1.data[22u] + uint(int(_205 + bitfieldExtract(_205, int(31u), int(1u))) >> int(1u))) + uint(int(_119 + bitfieldExtract(_119, int(31u), int(1u))) >> int(1u));
        uint _216 = subgroupBroadcast(_191, ((gl_SubgroupInvocationID & 255u) | 0u) ^ 2u);
        uint _227 = subgroupBroadcast(floatBitsToUint(max(uintBitsToFloat(_216), _190)), ((gl_SubgroupInvocationID & 255u) | 0u) ^ 16u);
        if (_153 && (_127 > _211))
        {
            ssbo_1_1.data[_211 + buf0_dword_off] = _191;
        }
        float _237 = max(uintBitsToFloat(_227), max(uintBitsToFloat(_216), _190));
        uint _238 = floatBitsToUint(_237);
        uint _239 = uint(int(_119) >> int(31u));
        bool _241 = _153 && ((0u == (3u & _119)) && (0u == (3u & _98)));
        if (_241)
        {
            uint _254 = srt_flatbuf_1.data[28u] * _98;
            uint _261 = (srt_flatbuf_1.data[23u] + uint(int(_254 + (3u & uint(int(_254) >> int(31u)))) >> int(2u))) + uint(int(_119 + (3u & _239)) >> int(2u));
            uint _267 = subgroupBroadcast(_238, ((gl_SubgroupInvocationID & 255u) | 0u) ^ 4u);
            if (_241 && (_127 > _261))
            {
                ssbo_1_1.data[_261 + buf0_dword_off] = _238;
            }
            float _276 = max(uintBitsToFloat(_267), _237);
            uint _279 = subgroupBroadcast(floatBitsToUint(_276), 32u);
            bool _281 = _241 && ((0u == (7u & _119)) && (0u == (7u & _98)));
            if (_281)
            {
                uint _293 = srt_flatbuf_1.data[29u] * _98;
                uint _303 = (srt_flatbuf_1.data[24u] + uint(int(_293 + (7u & uint(int(_293) >> int(31u)))) >> int(3u))) + uint(int(_119 + (7u & _239)) >> int(3u));
                if (_281 && (_127 > _303))
                {
                    ssbo_1_1.data[_303 + buf0_dword_off] = floatBitsToUint(max(uintBitsToFloat(_279), _276));
                }
            }
        }
    }
}

