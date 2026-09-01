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

layout(binding = 2, std430) readonly buffer ssbo_3
{
    uint data[];
} ssbo_3_1;

layout(binding = 3, std430) readonly buffer ssbo_4
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

layout(binding = 7, std430) buffer gds_buffer
{
    uint data[];
} gds_buffer_1;

layout(binding = 8, std430) readonly buffer srt_flatbuf
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
    uint buf2_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(16u), int(8u)) >> 2u;
    uint buf3_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(24u), int(8u)) >> 2u;
    uint _139 = (gl_WorkGroupID.x << 6u) + gl_LocalInvocationID.x;
    uint _144 = srt_flatbuf_1.data[63u];
    uint _146 = _139 >> 3u;
    bool _147 = _144 > _146;
    if (_147)
    {
        uint _209 = _146 + (bitfieldExtract(push_data.buf_offsets0.x, int(0u), int(8u)) >> 2u);
        uint _213 = (_139 * 3u) + (bitfieldExtract(push_data.buf_offsets0.x, int(8u), int(8u)) >> 2u);
        uvec3 _222 = uvec3(ssbo_2_1.data[_213], ssbo_2_1.data[_213 + 1u], ssbo_2_1.data[_213 + 2u]);
        uint _223 = _222.x;
        uint _224 = _222.y;
        uint _225 = _222.z;
        bool _226 = 0u != srt_flatbuf_1.data[68u];
        uint _228 = (ssbo_1_1.data[_209] * 16u) + buf2_dword_off;
        uvec4 _240 = uvec4(ssbo_3_1.data[_228], ssbo_3_1.data[_228 + 1u], ssbo_3_1.data[_228 + 2u], ssbo_3_1.data[_228 + 3u]);
        uint _247 = ((ssbo_1_1.data[_209] * 16u) + 12u) + buf2_dword_off;
        uvec4 _259 = uvec4(ssbo_3_1.data[_247], ssbo_3_1.data[_247 + 1u], ssbo_3_1.data[_247 + 2u], ssbo_3_1.data[_247 + 3u]);
        uint _266 = ((ssbo_1_1.data[_209] * 16u) + 4u) + buf2_dword_off;
        uvec4 _278 = uvec4(ssbo_3_1.data[_266], ssbo_3_1.data[_266 + 1u], ssbo_3_1.data[_266 + 2u], ssbo_3_1.data[_266 + 3u]);
        uint _285 = ((ssbo_1_1.data[_209] * 16u) + 8u) + buf2_dword_off;
        uvec4 _297 = uvec4(ssbo_3_1.data[_285], ssbo_3_1.data[_285 + 1u], ssbo_3_1.data[_285 + 2u], ssbo_3_1.data[_285 + 3u]);
        precise float _305 = uintBitsToFloat(_223) * uintBitsToFloat(_240.x);
        precise float _306 = _305 + uintBitsToFloat(_259.x);
        precise float _309 = uintBitsToFloat(_224) * uintBitsToFloat(_278.x);
        precise float _310 = _309 + _306;
        precise float _314 = uintBitsToFloat(_240.y) * uintBitsToFloat(_223);
        precise float _315 = _314 + uintBitsToFloat(_259.y);
        precise float _318 = uintBitsToFloat(_225) * uintBitsToFloat(_297.x);
        precise float _319 = _318 + _310;
        precise float _322 = uintBitsToFloat(_278.y) * uintBitsToFloat(_224);
        precise float _323 = _322 + _315;
        precise float _327 = uintBitsToFloat(_240.z) * uintBitsToFloat(_223);
        precise float _328 = _327 + uintBitsToFloat(_259.z);
        precise float _330 = uintBitsToFloat(srt_flatbuf_1.data[28u]) * _319;
        precise float _333 = uintBitsToFloat(_297.y) * uintBitsToFloat(_225);
        precise float _334 = _333 + _323;
        precise float _337 = uintBitsToFloat(_278.z) * uintBitsToFloat(_224);
        precise float _338 = _337 + _328;
        precise float _342 = uintBitsToFloat(_240.w) * uintBitsToFloat(_223);
        precise float _343 = _342 + uintBitsToFloat(_259.w);
        precise float _345 = uintBitsToFloat(srt_flatbuf_1.data[16u]) * _319;
        precise float _347 = uintBitsToFloat(srt_flatbuf_1.data[17u]) * _334;
        precise float _348 = _347 + _345;
        precise float _351 = uintBitsToFloat(_297.z) * uintBitsToFloat(_225);
        precise float _352 = _351 + _338;
        precise float _355 = uintBitsToFloat(_278.w) * uintBitsToFloat(_224);
        precise float _356 = _355 + _343;
        precise float _358 = uintBitsToFloat(srt_flatbuf_1.data[24u]) * _319;
        precise float _360 = uintBitsToFloat(srt_flatbuf_1.data[25u]) * _334;
        precise float _361 = _360 + _358;
        precise float _363 = uintBitsToFloat(srt_flatbuf_1.data[29u]) * _334;
        precise float _364 = _363 + _330;
        precise float _366 = uintBitsToFloat(srt_flatbuf_1.data[30u]) * _352;
        precise float _367 = _366 + _364;
        precise float _369 = uintBitsToFloat(srt_flatbuf_1.data[18u]) * _352;
        precise float _370 = _369 + _348;
        precise float _374 = uintBitsToFloat(_297.w) * uintBitsToFloat(_225);
        precise float _375 = _374 + _356;
        precise float _377 = uintBitsToFloat(srt_flatbuf_1.data[20u]) * _319;
        precise float _379 = uintBitsToFloat(srt_flatbuf_1.data[21u]) * _334;
        precise float _380 = _379 + _377;
        precise float _382 = uintBitsToFloat(srt_flatbuf_1.data[26u]) * _352;
        precise float _383 = _382 + _361;
        precise float _385 = uintBitsToFloat(srt_flatbuf_1.data[22u]) * _352;
        precise float _386 = _385 + _380;
        precise float _388 = uintBitsToFloat(srt_flatbuf_1.data[19u]) * _375;
        precise float _389 = _388 + _370;
        precise float _391 = uintBitsToFloat(srt_flatbuf_1.data[23u]) * _375;
        precise float _392 = _391 + _386;
        precise float _394 = uintBitsToFloat(srt_flatbuf_1.data[27u]) * _375;
        precise float _395 = _394 + _383;
        precise float _397 = uintBitsToFloat(srt_flatbuf_1.data[31u]) * _375;
        precise float _398 = _397 + _367;
        uint _432;
        if (_226)
        {
            _432 = ((((floatBitsToUint((_398 < (-_389)) ? 1.4012984643248170709237295832899e-45 : 0.0) | floatBitsToUint((_398 < (-_392)) ? 2.8025969286496341418474591665798e-45 : 0.0)) | floatBitsToUint((0.0 > _395) ? 5.6051938572992682836949183331597e-45 : 0.0)) | floatBitsToUint((_398 < _389) ? 1.1210387714598536567389836666319e-44 : 0.0)) | floatBitsToUint((_398 < _392) ? 2.2420775429197073134779673332639e-44 : 0.0)) | floatBitsToUint((_398 < _395) ? 4.4841550858394146269559346665277e-44 : 0.0);
        }
        else
        {
            _432 = floatBitsToUint(_370);
        }
        uint _459;
        if (!_226)
        {
            _459 = ((((floatBitsToUint((_398 < (-_389)) ? 1.4012984643248170709237295832899e-45 : 0.0) | floatBitsToUint((_398 < (-_392)) ? 2.8025969286496341418474591665798e-45 : 0.0)) | floatBitsToUint((_398 < _395) ? 5.6051938572992682836949183331597e-45 : 0.0)) | floatBitsToUint((_398 < _389) ? 1.1210387714598536567389836666319e-44 : 0.0)) | floatBitsToUint((_398 < _392) ? 2.2420775429197073134779673332639e-44 : 0.0)) | floatBitsToUint((_398 < (-_395)) ? 4.4841550858394146269559346665277e-44 : 0.0);
        }
        else
        {
            _459 = _432;
        }
        uint _465 = subgroupBroadcast(_459, ((gl_SubgroupInvocationID & 255u) | 0u) ^ 1u);
        uint _466 = _459 & _465;
        uint _471 = subgroupBroadcast(_466, ((gl_SubgroupInvocationID & 255u) | 0u) ^ 2u);
        uint _472 = _471 & _466;
        uint _477 = subgroupBroadcast(_472, ((gl_SubgroupInvocationID & 255u) | 0u) ^ 4u);
        bool _480 = _147 && (0u == (_477 & _472));
        uint _787;
        if (_480)
        {
            uint _485 = subgroupBroadcast(floatBitsToUint(_398), ((gl_SubgroupInvocationID & 255u) | 0u) ^ 1u);
            float _493 = min(uintBitsToFloat(_485), _398);
            uint _499 = subgroupBroadcast(floatBitsToUint(_493), ((gl_SubgroupInvocationID & 255u) | 0u) ^ 2u);
            uint _509 = subgroupBroadcast(floatBitsToUint(min(uintBitsToFloat(_499), min(uintBitsToFloat(_485), _398))), ((gl_SubgroupInvocationID & 255u) | 0u) ^ 4u);
            float _513 = min(uintBitsToFloat(_509), min(uintBitsToFloat(_499), _493));
            bool _516 = _480 && (_513 > uintBitsToFloat(srt_flatbuf_1.data[60u]));
            uint _786;
            if (_516)
            {
                uint _785;
                if (1u != srt_flatbuf_1.data[67u])
                {
                    float _524 = 1.0 / _398;
                    uint _529 = srt_flatbuf_1.data[61u];
                    uint _533 = srt_flatbuf_1.data[62u];
                    precise float _534 = _389 * _524;
                    float _535 = float(int(_529));
                    float _536 = float(int(_533));
                    precise float _537 = _392 * _524;
                    precise float _538 = _535 * _534;
                    precise float _539 = _538 + _535;
                    precise float _541 = _539 * 0.5;
                    precise float _543 = _536 * _537;
                    precise float _544 = _543 + _536;
                    precise float _545 = _544 * 0.5;
                    uint _551 = subgroupBroadcast(floatBitsToUint(_541), ((gl_SubgroupInvocationID & 255u) | 0u) ^ 1u);
                    uint _556 = subgroupBroadcast(floatBitsToUint(_545), ((gl_SubgroupInvocationID & 255u) | 0u) ^ 1u);
                    uint _573 = subgroupBroadcast(floatBitsToUint(min(uintBitsToFloat(_551), _541)), ((gl_SubgroupInvocationID & 255u) | 0u) ^ 2u);
                    uint _578 = subgroupBroadcast(floatBitsToUint(min(uintBitsToFloat(_556), _545)), ((gl_SubgroupInvocationID & 255u) | 0u) ^ 2u);
                    uint _583 = subgroupBroadcast(floatBitsToUint(max(uintBitsToFloat(_551), _541)), ((gl_SubgroupInvocationID & 255u) | 0u) ^ 2u);
                    uint _588 = subgroupBroadcast(floatBitsToUint(max(uintBitsToFloat(_556), _545)), ((gl_SubgroupInvocationID & 255u) | 0u) ^ 2u);
                    float _592 = min(uintBitsToFloat(_573), min(uintBitsToFloat(_551), _541));
                    float _597 = min(uintBitsToFloat(_578), min(uintBitsToFloat(_556), _545));
                    float _602 = max(uintBitsToFloat(_583), max(uintBitsToFloat(_551), _541));
                    float _607 = max(uintBitsToFloat(_588), max(uintBitsToFloat(_556), _545));
                    uint _614 = subgroupBroadcast(floatBitsToUint(_592), ((gl_SubgroupInvocationID & 255u) | 0u) ^ 4u);
                    uint _619 = subgroupBroadcast(floatBitsToUint(_597), ((gl_SubgroupInvocationID & 255u) | 0u) ^ 4u);
                    uint _624 = subgroupBroadcast(floatBitsToUint(_602), ((gl_SubgroupInvocationID & 255u) | 0u) ^ 4u);
                    uint _629 = subgroupBroadcast(floatBitsToUint(_607), ((gl_SubgroupInvocationID & 255u) | 0u) ^ 4u);
                    bool _631 = _516 && (0u == (7u & _139));
                    uint _784;
                    if (_631)
                    {
                        precise float _637 = (-0.5) + max(uintBitsToFloat(_624), _602);
                        precise float _640 = (-0.5) + max(uintBitsToFloat(_629), _607);
                        precise float _644 = (-0.5) + min(uintBitsToFloat(_614), _592);
                        precise float _646 = (-0.5) + min(uintBitsToFloat(_619), _597);
                        uint _656 = uint(min(int(_529 + 4294967295u), int(uint(int(ceil(_637))))));
                        uint _657 = uint(max(int(0u), int(uint(int(floor(_644))))));
                        uint _658 = uint(min(int(_533 + 4294967295u), int(uint(int(ceil(_640))))));
                        uint _659 = uint(max(int(0u), int(uint(int(floor(_646))))));
                        uint _660 = _657 ^ _656;
                        uint _661 = _659 ^ _658;
                        uint _674 = srt_flatbuf_1.data[65u];
                        uint _678 = srt_flatbuf_1.data[66u];
                        uint _693 = _674 * (_678 << 1u);
                        uint _694 = uint(max(int(floatBitsToUint((0u == _660) ? uintBitsToFloat(0xffffffffu /* nan */) : uintBitsToFloat(31u - ((_660 != 0u) ? (31u - uint(findMSB(_660))) : 4294967295u))) + 1u), int(floatBitsToUint((0u == _661) ? uintBitsToFloat(0xffffffffu /* nan */) : uintBitsToFloat(31u - ((_661 != 0u) ? (31u - uint(findMSB(_661))) : 4294967295u))) + 1u)));
                        uint _696 = _674 + _693;
                        uint _710 = _657 >> (_694 & 31u);
                        float _711 = 1.0 / _513;
                        uint _713 = (_659 >> (_694 & 31u)) * gds_buffer_1.data[(((_674 * 5u) + _694) << 2u) >> 2u];
                        uint _736;
                        if (_631 && (uintBitsToFloat(ssbo_4_1.data[((_710 + gds_buffer_1.data[((_696 + _694) << 2u) >> 2u]) + _713) + buf3_dword_off]) > _711))
                        {
                            _736 = floatBitsToUint((uintBitsToFloat(ssbo_4_1.data[((_710 + gds_buffer_1.data[((_693 + _694) << 2u) >> 2u]) + _713) + buf3_dword_off]) > _711) ? 1.1210387714598536567389836666319e-44 : 0.0);
                        }
                        else
                        {
                            _736 = 1u;
                        }
                        bool _738 = _631 && (0u == _736);
                        if (_738)
                        {
                            uint _768;
                            if (_738 && _738)
                            {
                                uvec2 _749 = unpackUint2x32(packUint2x32(uvec2(push_data.ud_regs0.z, _696)));
                                uint _754 = uint(bitCount(_749.x)) + uint(bitCount(_749.y));
                                uint _757 = atomicAdd(ssbo_5_1.data[0u + (bitfieldExtract(push_data.buf_offsets0.y, int(0u), int(8u)) >> 2u)], _754);
                                uint _767 = atomicAdd(gds_buffer_1.data[((srt_flatbuf_1.data[64u] << 2u) + 20u) >> 2u], _754);
                                _768 = _767;
                            }
                            else
                            {
                                _768 = 0u;
                            }
                            uvec4 _770 = uvec4((65535u & _657) | (_659 << 16u), (65535u & _656) | (_658 << 16u), floatBitsToUint(_711), _146);
                            uint _772 = (subgroupBroadcastFirst(_768) * 4u) + (bitfieldExtract(push_data.buf_offsets0.y, int(8u), int(8u)) >> 2u);
                            ssbo_6_1.data[_772] = _770.x;
                            ssbo_6_1.data[_772 + 1u] = _770.y;
                            ssbo_6_1.data[_772 + 2u] = _770.z;
                            ssbo_6_1.data[_772 + 3u] = _770.w;
                        }
                        _784 = _736;
                    }
                    else
                    {
                        _784 = 0u;
                    }
                    _785 = _784;
                }
                else
                {
                    _785 = 4u;
                }
                _786 = _785;
            }
            else
            {
                _786 = 6u;
            }
            _787 = _786;
        }
        else
        {
            _787 = 7u;
        }
        bool _790 = _147 && (0u == (7u & _139));
        if (_790)
        {
            if (_790 && (srt_flatbuf_1.data[58u] > _146))
            {
                ssbo_7_1.data[_146 + (bitfieldExtract(push_data.buf_offsets0.y, int(16u), int(8u)) >> 2u)] = _787;
            }
        }
    }
}

