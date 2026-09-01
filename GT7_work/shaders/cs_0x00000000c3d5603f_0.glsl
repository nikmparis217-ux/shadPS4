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
    uint _95 = (gl_WorkGroupID.x << 6u) + gl_LocalInvocationID.x;
    bool _97 = 64u > _95;
    if (_97)
    {
        uint _98 = bitfieldExtract(_95, int(2u), int(1u));
        uint _104 = bitfieldExtract(_95, int(3u), int(1u));
        uint _107 = (srt_flatbuf_1.data[16u] + 63u) >> 6u;
        uint _108 = bitfieldExtract(_95, int(4u), int(1u));
        uint _110 = bitfieldExtract(_95, int(5u), int(1u));
        uint _111 = 1u & _95;
        uint _112 = bitfieldExtract(_95, int(1u), int(1u));
        uint _210;
        uint _209;
        uint _113 = 0u;
        uint _114 = 0u;
        for (;;)
        {
            uint _116 = (_114 << 6u) + _95;
            if (!(int(_114) < int(_107)))
            {
                break;
            }
            else
            {
                uint _126;
                if (_97 && (srt_flatbuf_1.data[16u] > _116))
                {
                    _126 = ssbo_1_1.data[(_116 * 2u) + buf0_dword_off] + _113;
                }
                else
                {
                    _126 = 0u;
                }
                float _137 = (0u != _111) ? uintBitsToFloat(_126 + subgroupBroadcast(_126, ((gl_SubgroupInvocationID & 254u) | 0u) ^ 0u)) : uintBitsToFloat(_126);
                uint _138 = floatBitsToUint(_137);
                float _148 = (0u != _112) ? uintBitsToFloat(subgroupBroadcast(_138, ((gl_SubgroupInvocationID & 252u) | 1u) ^ 0u) + _138) : _137;
                uint _149 = floatBitsToUint(_148);
                float _159 = (0u != _98) ? uintBitsToFloat(subgroupBroadcast(_149, ((gl_SubgroupInvocationID & 248u) | 3u) ^ 0u) + _149) : _148;
                uint _160 = floatBitsToUint(_159);
                float _171 = (0u != _104) ? uintBitsToFloat(subgroupBroadcast(_160, ((gl_SubgroupInvocationID & 240u) | 7u) ^ 0u) + _160) : _159;
                uint _172 = floatBitsToUint(_171);
                float _183 = (0u != _108) ? uintBitsToFloat(subgroupBroadcast(_172, ((gl_SubgroupInvocationID & 224u) | 15u) ^ 0u) + _172) : _171;
                uint _184 = floatBitsToUint(_183);
                uint _188 = _116 + 1u;
                uint _193 = floatBitsToUint((0u != _110) ? uintBitsToFloat(subgroupBroadcast(_184, 31u) + _184) : _183);
                bool _194 = _97 && (srt_flatbuf_1.data[16u] > _188);
                if (_194)
                {
                    if (_194 && (srt_flatbuf_1.data[19u] > _188))
                    {
                        ssbo_1_1.data[((_188 * 2u) + 1u) + buf0_dword_off] = _193;
                    }
                }
                uint _208 = subgroupBroadcast(_193, 63u);
                if (_97 && (0u == _95))
                {
                    _209 = _208;
                }
                else
                {
                    _209 = _113;
                }
                _210 = _114 + 1u;
                if (true)
                {
                    _113 = _209;
                    _114 = _210;
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

