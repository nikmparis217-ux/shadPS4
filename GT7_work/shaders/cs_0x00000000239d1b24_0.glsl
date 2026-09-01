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

layout(binding = 1, std430) buffer ssbo_2
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

shared uint shared_mem_u32[128];

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
    uint _115 = (gl_WorkGroupID.y << 3u) + (gl_LocalInvocationID.x >> 3u);
    uint _120 = srt_flatbuf_1.data[32u];
    uint _124 = srt_flatbuf_1.data[33u];
    uint _126 = _120 * (_115 << 1u);
    uint _127 = _120 + _126;
    uint _135 = (gl_WorkGroupID.x << 3u) + (7u & gl_LocalInvocationID.x);
    uint _140 = srt_flatbuf_1.data[22u];
    uint _145 = ((_135 + uint(int(_127 + bitfieldExtract(_127, int(31u), int(1u))) >> int(1u))) * 2u) + buf0_dword_off;
    uint _147 = ssbo_1_1.data[_145];
    uint _150 = ssbo_1_1.data[_145 + 1u];
    uvec2 _151 = uvec2(_147, _150);
    uint _152 = _151.x;
    uint _153 = _151.y;
    uint _155 = ((_135 + uint(int(_126) >> int(1u))) * 2u) + buf0_dword_off;
    uint _157 = ssbo_1_1.data[_155];
    uint _160 = ssbo_1_1.data[_155 + 1u];
    uvec2 _161 = uvec2(_157, _160);
    uint _162 = _161.x;
    uint _163 = _161.y;
    uint _168 = srt_flatbuf_1.data[28u];
    uint _172 = srt_flatbuf_1.data[24u];
    uint _173 = _124 * _115;
    uint _176 = (_172 + _135) + _173;
    uint _177 = gl_LocalInvocationID.x << 2u;
    uint _178 = (_168 + _135) + _173;
    uint _190 = floatBitsToUint(min(uintBitsToFloat(_153), min(min(uintBitsToFloat(_162), uintBitsToFloat(_152)), uintBitsToFloat(_163))));
    uint _195 = floatBitsToUint(max(uintBitsToFloat(_153), max(max(uintBitsToFloat(_162), uintBitsToFloat(_152)), uintBitsToFloat(_163))));
    shared_mem_u32[_177 >> 2u] = _190;
    shared_mem_u32[(_177 + 256u) >> 2u] = _195;
    barrier();
    if (_140 > _176)
    {
        ssbo_2_1.data[_176 + buf1_dword_off] = _190;
    }
    barrier();
    if (_140 > _178)
    {
        ssbo_2_1.data[_178 + buf1_dword_off] = _195;
    }
    barrier();
    bool _209 = 16u > gl_LocalInvocationID.x;
    if (_209)
    {
        uint _210 = 3u & gl_LocalInvocationID.x;
        uint _212 = gl_LocalInvocationID.x >> 2u;
        uint _219 = ((bitfieldExtract(_212, int(0u), int(24u)) * 16u) + (_210 << 1u)) << 2u;
        uint _223 = _219 >> 2u;
        uint _227 = (_219 + 4u) >> 2u;
        uint _230 = ((bitfieldExtract(_212, int(0u), int(24u)) * 16u) + ((bitfieldExtract(_210, int(0u), int(24u)) * 2u) + 8u)) << 2u;
        uint _233 = (_219 + 256u) >> 2u;
        uint _238 = (_219 + 260u) >> 2u;
        uint _241 = _230 >> 2u;
        uint _245 = (_230 + 4u) >> 2u;
        uint _251 = (_230 + 256u) >> 2u;
        uint _255 = (_230 + 260u) >> 2u;
        uint _261 = (gl_WorkGroupID.x << 2u) + _210;
        uint _266 = srt_flatbuf_1.data[34u];
        uint _276 = srt_flatbuf_1.data[29u];
        uint _283 = _266 * ((gl_WorkGroupID.y << 2u) + _212);
        float _290 = max(uintBitsToFloat(shared_mem_u32[_255]), max(max(uintBitsToFloat(shared_mem_u32[_233]), uintBitsToFloat(shared_mem_u32[_238])), uintBitsToFloat(shared_mem_u32[_251])));
        uint _291 = floatBitsToUint(_290);
        uint _294 = (srt_flatbuf_1.data[25u] + _261) + _283;
        float _299 = min(uintBitsToFloat(shared_mem_u32[_245]), min(min(uintBitsToFloat(shared_mem_u32[_223]), uintBitsToFloat(shared_mem_u32[_227])), uintBitsToFloat(shared_mem_u32[_241])));
        uint _300 = floatBitsToUint(_299);
        uint _311 = subgroupBroadcast(_300, ((gl_SubgroupInvocationID & 255u) | 0u) ^ 1u);
        uint _313 = (_276 + _261) + _283;
        uint _324 = subgroupBroadcast(_291, ((gl_SubgroupInvocationID & 255u) | 0u) ^ 1u);
        uint _329 = subgroupBroadcast(floatBitsToUint(min(uintBitsToFloat(_311), min(min(uintBitsToFloat(shared_mem_u32[_241]), min(uintBitsToFloat(shared_mem_u32[_223]), uintBitsToFloat(shared_mem_u32[_227]))), uintBitsToFloat(shared_mem_u32[_245])))), ((gl_SubgroupInvocationID & 255u) | 0u) ^ 4u);
        uint _339 = subgroupBroadcast(floatBitsToUint(max(uintBitsToFloat(_324), max(max(uintBitsToFloat(shared_mem_u32[_251]), max(uintBitsToFloat(shared_mem_u32[_233]), uintBitsToFloat(shared_mem_u32[_238]))), uintBitsToFloat(shared_mem_u32[_255])))), ((gl_SubgroupInvocationID & 255u) | 0u) ^ 4u);
        if (_209 && (_140 > _294))
        {
            ssbo_2_1.data[_294 + buf1_dword_off] = _300;
        }
        float _348 = min(uintBitsToFloat(_329), min(uintBitsToFloat(_311), _299));
        uint _349 = floatBitsToUint(_348);
        float _353 = max(uintBitsToFloat(_339), max(uintBitsToFloat(_324), _290));
        uint _354 = floatBitsToUint(_353);
        if (_209 && (_140 > _313))
        {
            ssbo_2_1.data[_313 + buf1_dword_off] = _291;
        }
        bool _359 = _209 && ((0u == bitfieldExtract(gl_LocalInvocationID.x, int(2u), int(1u))) && (0u == (1u & _210)));
        if (_359)
        {
            uint _366 = srt_flatbuf_1.data[35u];
            uint _373 = srt_flatbuf_1.data[30u];
            uint _375 = (gl_WorkGroupID.x << 1u) + uint(int(_210) >> int(1u));
            uint _381 = _366 * ((gl_WorkGroupID.y << 1u) + uint(int(_212) >> int(1u)));
            uint _384 = (srt_flatbuf_1.data[26u] + _375) + _381;
            uint _385 = (_373 + _375) + _381;
            uint _390 = subgroupBroadcast(_349, ((gl_SubgroupInvocationID & 255u) | 0u) ^ 2u);
            if (_359 && (_140 > _384))
            {
                ssbo_2_1.data[_384 + buf1_dword_off] = _349;
            }
            float _396 = min(uintBitsToFloat(_390), _348);
            uint _402 = subgroupBroadcast(floatBitsToUint(_396), ((gl_SubgroupInvocationID & 255u) | 0u) ^ 8u);
            if (_359 && (_140 > _385))
            {
                ssbo_2_1.data[_385 + buf1_dword_off] = _354;
            }
            float _413 = max(uintBitsToFloat(subgroupBroadcast(_354, ((gl_SubgroupInvocationID & 255u) | 0u) ^ 2u)), _353);
            uint _419 = subgroupBroadcast(floatBitsToUint(_413), ((gl_SubgroupInvocationID & 255u) | 0u) ^ 8u);
            bool _421 = _359 && (0u == gl_LocalInvocationID.x);
            if (_421)
            {
                uint _429 = srt_flatbuf_1.data[36u];
                uint _438 = srt_flatbuf_1.data[31u];
                uint _442 = _429 * gl_WorkGroupID.y;
                uint _444 = (srt_flatbuf_1.data[27u] + gl_WorkGroupID.x) + _442;
                if (_421 && (_140 > _444))
                {
                    ssbo_2_1.data[_444 + buf1_dword_off] = floatBitsToUint(min(uintBitsToFloat(_402), _396));
                }
                uint _450 = (_438 + gl_WorkGroupID.x) + _442;
                if (_421 && (_140 > _450))
                {
                    ssbo_2_1.data[_450 + buf1_dword_off] = floatBitsToUint(max(uintBitsToFloat(_419), _413));
                }
            }
        }
    }
    barrier();
}

