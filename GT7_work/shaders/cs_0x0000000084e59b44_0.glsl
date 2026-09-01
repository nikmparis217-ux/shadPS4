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

layout(binding = 5, std430) buffer gds_buffer
{
    uint data[];
} gds_buffer_1;

layout(binding = 6, std430) readonly buffer srt_flatbuf
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
    uint buf2_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(16u), int(8u)) >> 2u;
    if (!(gl_WorkGroupID.x >= 10000u))
    {
        uint _139 = srt_flatbuf_1.data[38u];
        uint _145 = gds_buffer_1.data[((_139 << 2u) + 12u) >> 2u];
        uint _150 = (4294967295u - gl_WorkGroupID.x) + min(10000u, _145);
        uint _152 = subgroupBroadcastFirst(_150);
        uint _156 = (((_152 << 4u) + 8u) >> 2u) + buf0_dword_off;
        uint _158 = ssbo_1_1.data[_156];
        uint _163 = srt_flatbuf_1.data[36u];
        uint _171 = (_158 & 255u) + gl_LocalInvocationID.x;
        uint _172 = bitfieldExtract(_158, int(8u), int(8u)) + gl_LocalInvocationID.y;
        bool _175 = (_163 <= _171) || (srt_flatbuf_1.data[37u] <= _172);
        if (!_175)
        {
            uint _179 = _158 >> 16u;
            uint _182 = (_179 * 48u) >> 2u;
            uint _183 = _182 + buf1_dword_off;
            uint _187 = (_182 + 1u) + buf1_dword_off;
            uint _191 = (_182 + 2u) + buf1_dword_off;
            uint _195 = (_182 + 4u) + buf1_dword_off;
            uint _200 = (_182 + 5u) + buf1_dword_off;
            uint _205 = (_182 + 6u) + buf1_dword_off;
            float _212 = float((bitfieldExtract(_172, int(0u), int(24u)) * 8u) + 8u);
            float _213 = float(_172 << 3u);
            float _217 = float(_171 << 3u);
            float _218 = float((bitfieldExtract(_171, int(0u), int(24u)) * 8u) + 8u);
            bool _247 = (!_175) && (!((_218 < min(uintBitsToFloat(ssbo_2_1.data[_191]), min(uintBitsToFloat(ssbo_2_1.data[_183]), uintBitsToFloat(ssbo_2_1.data[_187])))) || ((max(uintBitsToFloat(ssbo_2_1.data[_191]), max(uintBitsToFloat(ssbo_2_1.data[_183]), uintBitsToFloat(ssbo_2_1.data[_187]))) < _217) || ((_212 < min(uintBitsToFloat(ssbo_2_1.data[_205]), min(uintBitsToFloat(ssbo_2_1.data[_195]), uintBitsToFloat(ssbo_2_1.data[_200])))) || (max(uintBitsToFloat(ssbo_2_1.data[_205]), max(uintBitsToFloat(ssbo_2_1.data[_195]), uintBitsToFloat(ssbo_2_1.data[_200]))) < _213)))));
            if (_247)
            {
                bool _284 = _247 && (!((((((uintBitsToFloat(ssbo_2_1.data[_183]) > _217) && (uintBitsToFloat(ssbo_2_1.data[_183]) < _218)) && (uintBitsToFloat(ssbo_2_1.data[_195]) > _213)) && (uintBitsToFloat(ssbo_2_1.data[_195]) < _212)) || ((((uintBitsToFloat(ssbo_2_1.data[_187]) > _217) && (uintBitsToFloat(ssbo_2_1.data[_187]) < _218)) && (uintBitsToFloat(ssbo_2_1.data[_200]) > _213)) && (uintBitsToFloat(ssbo_2_1.data[_200]) < _212))) || ((((uintBitsToFloat(ssbo_2_1.data[_191]) > _217) && (uintBitsToFloat(ssbo_2_1.data[_191]) < _218)) && (uintBitsToFloat(ssbo_2_1.data[_205]) > _213)) && (uintBitsToFloat(ssbo_2_1.data[_205]) < _212))));
                uint _550;
                uint _551;
                if (_284)
                {
                    precise float _287 = uintBitsToFloat(ssbo_2_1.data[_195]) - uintBitsToFloat(ssbo_2_1.data[_200]);
                    precise float _288 = _218 * _287;
                    precise float _291 = uintBitsToFloat(ssbo_2_1.data[_183]) - uintBitsToFloat(ssbo_2_1.data[_187]);
                    precise float _292 = _217 * _287;
                    precise float _294 = _213 * (-_291);
                    precise float _295 = _294 + _288;
                    precise float _297 = (-_291) * _212;
                    precise float _298 = _297 + _288;
                    precise float _301 = uintBitsToFloat(ssbo_2_1.data[_200]) - uintBitsToFloat(ssbo_2_1.data[_205]);
                    uint _305 = ((_179 * 48u) + 32u) >> 2u;
                    uint _306 = _305 + buf1_dword_off;
                    uint _310 = (_305 + 1u) + buf1_dword_off;
                    uint _314 = (_305 + 2u) + buf1_dword_off;
                    precise float _318 = _213 * (-_291);
                    precise float _319 = _318 + _292;
                    precise float _321 = (-_291) * _212;
                    precise float _322 = _321 + _292;
                    precise float _326 = _218 * _301;
                    precise float _338 = uintBitsToFloat(ssbo_2_1.data[_187]) - uintBitsToFloat(ssbo_2_1.data[_191]);
                    precise float _340 = _213 * (-_338);
                    precise float _341 = _340 + _326;
                    precise float _343 = (-_338) * _212;
                    precise float _344 = _343 + _326;
                    precise float _352 = _217 * _301;
                    precise float _354 = _213 * (-_338);
                    precise float _355 = _354 + _352;
                    precise float _357 = (-_338) * _212;
                    precise float _358 = _357 + _352;
                    precise float _364 = uintBitsToFloat(ssbo_2_1.data[_191]) - uintBitsToFloat(ssbo_2_1.data[_183]);
                    precise float _370 = uintBitsToFloat(ssbo_2_1.data[_205]) - uintBitsToFloat(ssbo_2_1.data[_195]);
                    precise float _371 = _218 * _370;
                    precise float _373 = _213 * (-_364);
                    precise float _374 = _373 + _371;
                    precise float _376 = (-_364) * _212;
                    precise float _377 = _376 + _371;
                    precise float _381 = _217 * _370;
                    bool _382 = ((_295 >= (-uintBitsToFloat(ssbo_2_1.data[_306]))) && (_341 >= (-uintBitsToFloat(ssbo_2_1.data[_310])))) && (_374 >= (-uintBitsToFloat(ssbo_2_1.data[_314])));
                    precise float _388 = _213 * (-_364);
                    precise float _389 = _388 + _381;
                    precise float _394 = (-_364) * _212;
                    precise float _395 = _394 + _381;
                    bool _399 = ((_319 >= (-uintBitsToFloat(ssbo_2_1.data[_306]))) && (_355 >= (-uintBitsToFloat(ssbo_2_1.data[_310])))) && (_389 >= (-uintBitsToFloat(ssbo_2_1.data[_314])));
                    bool _402 = ((_322 >= (-uintBitsToFloat(ssbo_2_1.data[_306]))) && (_358 >= (-uintBitsToFloat(ssbo_2_1.data[_310])))) && (_395 >= (-uintBitsToFloat(ssbo_2_1.data[_314])));
                    bool _405 = ((_298 >= (-uintBitsToFloat(ssbo_2_1.data[_306]))) && (_344 >= (-uintBitsToFloat(ssbo_2_1.data[_310])))) && (_377 >= (-uintBitsToFloat(ssbo_2_1.data[_314])));
                    uint _548;
                    uint _549;
                    if (_284 && (!(((_399 || _382) || _402) || _405)))
                    {
                        precise float _416 = _213 - uintBitsToFloat(ssbo_2_1.data[_195]);
                        precise float _417 = _291 * _416;
                        precise float _419 = _217 - uintBitsToFloat(ssbo_2_1.data[_183]);
                        precise float _421 = (-_287) * _419;
                        precise float _422 = _421 + _417;
                        precise float _424 = _291 * 8.0;
                        precise float _425 = _424 + _422;
                        precise float _426 = _422 * _425;
                        precise float _428 = _217 - uintBitsToFloat(ssbo_2_1.data[_187]);
                        precise float _429 = _419 * _428;
                        precise float _432 = _218 - uintBitsToFloat(ssbo_2_1.data[_183]);
                        precise float _434 = _432 * (-_287);
                        precise float _435 = _434 + _417;
                        precise float _436 = _291 * 8.0;
                        precise float _437 = _436 + _435;
                        precise float _439 = _218 - uintBitsToFloat(ssbo_2_1.data[_187]);
                        precise float _440 = _435 * _437;
                        precise float _441 = _432 * _439;
                        precise float _444 = _213 - uintBitsToFloat(ssbo_2_1.data[_200]);
                        precise float _446 = _213 - uintBitsToFloat(ssbo_2_1.data[_205]);
                        precise float _448 = _217 - uintBitsToFloat(ssbo_2_1.data[_191]);
                        precise float _450 = _218 - uintBitsToFloat(ssbo_2_1.data[_191]);
                        precise float _453 = _287 * (-8.0);
                        precise float _454 = _453 + _422;
                        precise float _455 = _422 * _454;
                        precise float _457 = (-_287) * _419;
                        precise float _458 = _416 * _444;
                        precise float _461 = _212 - uintBitsToFloat(ssbo_2_1.data[_195]);
                        precise float _462 = _461 * _291;
                        precise float _463 = _462 + _457;
                        precise float _464 = _287 * (-8.0);
                        precise float _465 = _464 + _463;
                        precise float _466 = _463 * _465;
                        precise float _468 = _212 - uintBitsToFloat(ssbo_2_1.data[_200]);
                        precise float _469 = _439 * _450;
                        precise float _471 = _212 - uintBitsToFloat(ssbo_2_1.data[_205]);
                        precise float _472 = _461 * _468;
                        precise float _474 = _364 * _446;
                        precise float _478 = (-_370) * _448;
                        precise float _479 = _478 + _474;
                        precise float _480 = _419 * _448;
                        precise float _482 = (-_370) * _448;
                        precise float _483 = _428 * _448;
                        precise float _485 = _450 * (-_370);
                        precise float _486 = _485 + _474;
                        precise float _487 = _471 * _364;
                        precise float _488 = _487 + _482;
                        precise float _489 = _432 * _450;
                        precise float _491 = (-_301) * _428;
                        precise float _492 = _468 * _338;
                        precise float _493 = _492 + _491;
                        precise float _494 = _416 * _446;
                        precise float _495 = _444 * _446;
                        precise float _496 = _338 * _444;
                        precise float _498 = (-_301) * _439;
                        precise float _499 = _498 + _496;
                        precise float _501 = _428 * (-_301);
                        precise float _502 = _501 + _496;
                        precise float _503 = _468 * _471;
                        precise float _504 = _461 * _471;
                        precise float _505 = _338 * 8.0;
                        precise float _506 = _505 + _499;
                        precise float _507 = _338 * 8.0;
                        precise float _508 = _507 + _502;
                        precise float _509 = _502 * _508;
                        precise float _510 = _499 * _506;
                        precise float _515 = _301 * (-8.0);
                        precise float _516 = _515 + _502;
                        precise float _517 = _301 * (-8.0);
                        precise float _518 = _517 + _493;
                        precise float _519 = _502 * _516;
                        precise float _520 = _493 * _518;
                        precise float _525 = _364 * 8.0;
                        precise float _526 = _525 + _486;
                        precise float _527 = _364 * 8.0;
                        precise float _528 = _527 + _479;
                        precise float _529 = _479 * _528;
                        precise float _531 = _486 * _526;
                        precise float _535 = _370 * (-8.0);
                        precise float _536 = _535 + _479;
                        precise float _537 = _370 * (-8.0);
                        precise float _538 = _537 + _488;
                        precise float _539 = _479 * _536;
                        precise float _540 = _488 * _538;
                        _548 = 0u;
                        _549 = floatBitsToUint((0.0 >= min(max(_504, _540), min(min(max(_489, _531), min(min(max(_503, _520), min(min(max(_469, _510), min(min(max(_472, _466), min(min(max(_429, _426), max(_441, _440)), max(_458, _455))), max(_483, _509))), max(_495, _519))), max(_480, _529))), max(_494, _539)))) ? 1.4012984643248170709237295832899e-45 : 0.0);
                    }
                    else
                    {
                        _548 = floatBitsToUint((((_399 && _382) && _402) && _405) ? 1.4012984643248170709237295832899e-45 : 0.0);
                        _549 = 1u;
                    }
                    _550 = _548;
                    _551 = _549;
                }
                else
                {
                    _550 = 0u;
                    _551 = 1u;
                }
                bool _553 = _247 && (0u != _551);
                if (_553)
                {
                    uint _554 = subgroupBroadcastFirst(_150);
                    uint _558 = floatBitsToUint((0u != _550) ? 4.2038953929744512127711887498697e-45 : 1.4012984643248170709237295832899e-45);
                    uint _559 = _554 << 4u;
                    uint _560 = _559 >> 2u;
                    uint _561 = _560 + buf0_dword_off;
                    uint _563 = ssbo_1_1.data[_561];
                    uint _565 = (_560 + 1u) + buf0_dword_off;
                    uint _567 = ssbo_1_1.data[_565];
                    uint _609;
                    uint _610;
                    uint _611;
                    if (_553 && (1u >= _558))
                    {
                        uint _573 = srt_flatbuf_1.data[20u];
                        uint _575 = srt_flatbuf_1.data[21u];
                        uint _579 = ssbo_3_1.data[(_171 + (_163 * _172)) + buf2_dword_off];
                        uint _586 = floatBitsToUint((uintBitsToFloat(_563) < uintBitsToFloat(_579)) ? 2.8025969286496341418474591665798e-45 : 5.6051938572992682836949183331597e-45);
                        bool _588 = _553 && (2u >= _586);
                        uint _606;
                        uint _607;
                        uint _608;
                        if (_588)
                        {
                            uint _604;
                            uint _605;
                            if (_588 && _588)
                            {
                                uint _590 = _139 << 2u;
                                uvec2 _593 = unpackUint2x32(packUint2x32(uvec2(_573, _575)));
                                uint _598 = uint(bitCount(_593.x)) + uint(bitCount(_593.y));
                                uint _603 = atomicAdd(gds_buffer_1.data[(_590 + 28u) >> 2u], _598);
                                _604 = _598;
                                _605 = _590;
                            }
                            else
                            {
                                _604 = _559;
                                _605 = _172;
                            }
                            _606 = _604;
                            _607 = _605;
                            _608 = 6u;
                        }
                        else
                        {
                            _606 = _559;
                            _607 = _172;
                            _608 = _586;
                        }
                        _609 = _606;
                        _610 = _607;
                        _611 = _608;
                    }
                    else
                    {
                        _609 = _559;
                        _610 = _172;
                        _611 = _558;
                    }
                    uint _635;
                    if (_553 && (3u >= _611))
                    {
                        uint _615 = _171 + (_163 * _610);
                        uint _617 = floatBitsToUint(uintBitsToFloat(_567));
                        uint _623 = atomicMax(ssbo_3_1.data[_615 + buf2_dword_off], _617);
                        uint _627 = atomicMin(ssbo_3_1.data[_615 + buf2_dword_off], _617);
                        _635 = floatBitsToUint((uintBitsToFloat(_563) < ((bitfieldExtract(_617, int(31u), int(1u)) != 0u) ? uintBitsToFloat(_627) : uintBitsToFloat(_623))) ? 7.0064923216240853546186479164496e-45 : 5.6051938572992682836949183331597e-45);
                    }
                    else
                    {
                        _635 = _611;
                    }
                    bool _637 = _553 && (4u >= _635);
                    uint _695;
                    uint _696;
                    uint _697;
                    if (_637)
                    {
                        uint _655;
                        if (_637 && _637)
                        {
                            uvec2 _642 = unpackUint2x32(packUint2x32(uvec2(_163, _609)));
                            uint _647 = uint(bitCount(_642.x)) + uint(bitCount(_642.y));
                            uint _650 = atomicAdd(ssbo_4_1.data[0u + (bitfieldExtract(push_data.buf_offsets0.x, int(24u), int(8u)) >> 2u)], _647);
                            uint _654 = atomicAdd(gds_buffer_1.data[((_139 << 2u) + 16u) >> 2u], _647);
                            _655 = _654;
                        }
                        else
                        {
                            _655 = 0u;
                        }
                        uint _656 = subgroupBroadcastFirst(_655);
                        uint _693;
                        uint _694;
                        if (_637 && (40000u > _656))
                        {
                            uint _674 = srt_flatbuf_1.data[32u];
                            uint _678 = srt_flatbuf_1.data[33u];
                            uvec4 _679 = uvec4(_563, _567, (bitfieldExtract(255u & _610, int(0u), int(24u)) * 256u) + ((_158 & 4294901760u) | (255u & _171)), floatBitsToUint((0u != _550) ? 1.4012984643248170709237295832899e-45 : 0.0));
                            uint _681 = (_656 * 4u) + (bitfieldExtract(push_data.buf_offsets0.y, int(0u), int(8u)) >> 2u);
                            ssbo_5_1.data[_681] = _679.x;
                            ssbo_5_1.data[_681 + 1u] = _679.y;
                            ssbo_5_1.data[_681 + 2u] = _679.z;
                            ssbo_5_1.data[_681 + 3u] = _679.w;
                            _693 = _678;
                            _694 = _674;
                        }
                        else
                        {
                            _693 = push_data.ud_regs0.y;
                            _694 = push_data.ud_regs0.x;
                        }
                        _695 = _693;
                        _696 = _694;
                        _697 = 6u;
                    }
                    else
                    {
                        _695 = push_data.ud_regs0.y;
                        _696 = push_data.ud_regs0.x;
                        _697 = _635;
                    }
                    bool _699 = _553 && (5u >= _697);
                    if (_699)
                    {
                        if (_699 && _699)
                        {
                            uvec2 _704 = unpackUint2x32(packUint2x32(uvec2(_696, _695)));
                            uint _713 = atomicAdd(gds_buffer_1.data[((_139 << 2u) + 28u) >> 2u], uint(bitCount(_704.x)) + uint(bitCount(_704.y)));
                        }
                    }
                }
            }
        }
    }
}

