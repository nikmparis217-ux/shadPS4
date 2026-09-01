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
    if (!(gl_WorkGroupID.x >= 1000u))
    {
        uint _119 = (((gl_WorkGroupID.x << 4u) + 8u) >> 2u) + buf0_dword_off;
        uint _121 = ssbo_1_1.data[_119];
        uint _125 = srt_flatbuf_1.data[32u];
        uint _129 = srt_flatbuf_1.data[33u];
        uint _135 = (bitfieldExtract(gl_LocalInvocationID.x, int(0u), int(24u)) * 8u) + (_121 & 255u);
        uint _138 = (bitfieldExtract(gl_LocalInvocationID.y, int(0u), int(24u)) * 8u) + bitfieldExtract(_121, int(8u), int(8u));
        bool _141 = (_125 <= _135) || (_129 <= _138);
        if (!_141)
        {
            uint _146 = _121 >> 16u;
            uint _149 = (_146 * 48u) >> 2u;
            uint _150 = _149 + buf1_dword_off;
            uint _154 = (_149 + 1u) + buf1_dword_off;
            uint _158 = (_149 + 2u) + buf1_dword_off;
            uint _162 = (_149 + 4u) + buf1_dword_off;
            uint _164 = ssbo_2_1.data[_162];
            uint _167 = (_149 + 5u) + buf1_dword_off;
            uint _169 = ssbo_2_1.data[_167];
            uint _172 = (_149 + 6u) + buf1_dword_off;
            float _179 = float((bitfieldExtract(_138, int(0u), int(24u)) * 8u) + 64u);
            float _181 = float(_138 << 3u);
            float _185 = float(_135 << 3u);
            float _186 = float((bitfieldExtract(_135, int(0u), int(24u)) * 8u) + 64u);
            bool _216 = (!_141) && (!((_186 < min(uintBitsToFloat(ssbo_2_1.data[_158]), min(uintBitsToFloat(ssbo_2_1.data[_150]), uintBitsToFloat(ssbo_2_1.data[_154])))) || ((max(uintBitsToFloat(ssbo_2_1.data[_158]), max(uintBitsToFloat(ssbo_2_1.data[_150]), uintBitsToFloat(ssbo_2_1.data[_154]))) < _185) || ((_179 < min(uintBitsToFloat(ssbo_2_1.data[_172]), min(uintBitsToFloat(_164), uintBitsToFloat(_169)))) || (max(uintBitsToFloat(ssbo_2_1.data[_172]), max(uintBitsToFloat(_164), uintBitsToFloat(_169))) < _181)))));
            if (_216)
            {
                bool _253 = _216 && (!((((((uintBitsToFloat(ssbo_2_1.data[_150]) > _185) && (uintBitsToFloat(ssbo_2_1.data[_150]) < _186)) && (uintBitsToFloat(_164) > _181)) && (uintBitsToFloat(_164) < _179)) || ((((uintBitsToFloat(ssbo_2_1.data[_154]) > _185) && (uintBitsToFloat(ssbo_2_1.data[_154]) < _186)) && (uintBitsToFloat(_169) > _181)) && (uintBitsToFloat(_169) < _179))) || ((((uintBitsToFloat(ssbo_2_1.data[_158]) > _185) && (uintBitsToFloat(ssbo_2_1.data[_158]) < _186)) && (uintBitsToFloat(ssbo_2_1.data[_172]) > _181)) && (uintBitsToFloat(ssbo_2_1.data[_172]) < _179))));
                uint _518;
                uint _519;
                if (_253)
                {
                    precise float _256 = uintBitsToFloat(_164) - uintBitsToFloat(_169);
                    precise float _257 = _186 * _256;
                    precise float _260 = uintBitsToFloat(ssbo_2_1.data[_150]) - uintBitsToFloat(ssbo_2_1.data[_154]);
                    precise float _261 = _185 * _256;
                    precise float _263 = _181 * (-_260);
                    precise float _264 = _263 + _257;
                    precise float _266 = (-_260) * _179;
                    precise float _267 = _266 + _257;
                    precise float _270 = uintBitsToFloat(_169) - uintBitsToFloat(ssbo_2_1.data[_172]);
                    uint _273 = ((_146 * 48u) + 32u) >> 2u;
                    uint _274 = _273 + buf1_dword_off;
                    uint _278 = (_273 + 1u) + buf1_dword_off;
                    uint _282 = (_273 + 2u) + buf1_dword_off;
                    precise float _286 = _181 * (-_260);
                    precise float _287 = _286 + _261;
                    precise float _289 = (-_260) * _179;
                    precise float _290 = _289 + _261;
                    precise float _294 = _186 * _270;
                    precise float _306 = uintBitsToFloat(ssbo_2_1.data[_154]) - uintBitsToFloat(ssbo_2_1.data[_158]);
                    precise float _308 = _181 * (-_306);
                    precise float _309 = _308 + _294;
                    precise float _311 = (-_306) * _179;
                    precise float _312 = _311 + _294;
                    precise float _320 = _185 * _270;
                    precise float _322 = _181 * (-_306);
                    precise float _323 = _322 + _320;
                    precise float _325 = (-_306) * _179;
                    precise float _326 = _325 + _320;
                    precise float _332 = uintBitsToFloat(ssbo_2_1.data[_158]) - uintBitsToFloat(ssbo_2_1.data[_150]);
                    precise float _338 = uintBitsToFloat(ssbo_2_1.data[_172]) - uintBitsToFloat(_164);
                    precise float _339 = _186 * _338;
                    precise float _341 = _181 * (-_332);
                    precise float _342 = _341 + _339;
                    precise float _344 = (-_332) * _179;
                    precise float _345 = _344 + _339;
                    precise float _349 = _185 * _338;
                    bool _350 = ((_264 >= (-uintBitsToFloat(ssbo_2_1.data[_274]))) && (_309 >= (-uintBitsToFloat(ssbo_2_1.data[_278])))) && (_342 >= (-uintBitsToFloat(ssbo_2_1.data[_282])));
                    precise float _356 = _181 * (-_332);
                    precise float _357 = _356 + _349;
                    precise float _362 = (-_332) * _179;
                    precise float _363 = _362 + _349;
                    bool _367 = ((_287 >= (-uintBitsToFloat(ssbo_2_1.data[_274]))) && (_323 >= (-uintBitsToFloat(ssbo_2_1.data[_278])))) && (_357 >= (-uintBitsToFloat(ssbo_2_1.data[_282])));
                    bool _370 = ((_290 >= (-uintBitsToFloat(ssbo_2_1.data[_274]))) && (_326 >= (-uintBitsToFloat(ssbo_2_1.data[_278])))) && (_363 >= (-uintBitsToFloat(ssbo_2_1.data[_282])));
                    bool _373 = ((_267 >= (-uintBitsToFloat(ssbo_2_1.data[_274]))) && (_312 >= (-uintBitsToFloat(ssbo_2_1.data[_278])))) && (_345 >= (-uintBitsToFloat(ssbo_2_1.data[_282])));
                    uint _516;
                    uint _517;
                    if (_253 && (!(((_367 || _350) || _370) || _373)))
                    {
                        precise float _384 = _181 - uintBitsToFloat(_164);
                        precise float _385 = _260 * _384;
                        precise float _387 = _185 - uintBitsToFloat(ssbo_2_1.data[_150]);
                        precise float _389 = (-_256) * _387;
                        precise float _390 = _389 + _385;
                        precise float _392 = _260 * 64.0;
                        precise float _393 = _392 + _390;
                        precise float _394 = _390 * _393;
                        precise float _396 = _185 - uintBitsToFloat(ssbo_2_1.data[_154]);
                        precise float _397 = _387 * _396;
                        precise float _400 = _186 - uintBitsToFloat(ssbo_2_1.data[_150]);
                        precise float _402 = _400 * (-_256);
                        precise float _403 = _402 + _385;
                        precise float _404 = _260 * 64.0;
                        precise float _405 = _404 + _403;
                        precise float _407 = _186 - uintBitsToFloat(ssbo_2_1.data[_154]);
                        precise float _408 = _403 * _405;
                        precise float _409 = _400 * _407;
                        precise float _412 = _181 - uintBitsToFloat(_169);
                        precise float _414 = _181 - uintBitsToFloat(ssbo_2_1.data[_172]);
                        precise float _416 = _185 - uintBitsToFloat(ssbo_2_1.data[_158]);
                        precise float _418 = _186 - uintBitsToFloat(ssbo_2_1.data[_158]);
                        precise float _421 = _256 * (-64.0);
                        precise float _422 = _421 + _390;
                        precise float _423 = _390 * _422;
                        precise float _425 = (-_256) * _387;
                        precise float _426 = _384 * _412;
                        precise float _429 = _179 - uintBitsToFloat(_164);
                        precise float _430 = _429 * _260;
                        precise float _431 = _430 + _425;
                        precise float _432 = _256 * (-64.0);
                        precise float _433 = _432 + _431;
                        precise float _434 = _431 * _433;
                        precise float _436 = _179 - uintBitsToFloat(_169);
                        precise float _437 = _407 * _418;
                        precise float _439 = _179 - uintBitsToFloat(ssbo_2_1.data[_172]);
                        precise float _440 = _429 * _436;
                        precise float _442 = _332 * _414;
                        precise float _446 = (-_338) * _416;
                        precise float _447 = _446 + _442;
                        precise float _448 = _387 * _416;
                        precise float _450 = (-_338) * _416;
                        precise float _451 = _396 * _416;
                        precise float _453 = _418 * (-_338);
                        precise float _454 = _453 + _442;
                        precise float _455 = _439 * _332;
                        precise float _456 = _455 + _450;
                        precise float _457 = _400 * _418;
                        precise float _459 = (-_270) * _396;
                        precise float _460 = _436 * _306;
                        precise float _461 = _460 + _459;
                        precise float _462 = _384 * _414;
                        precise float _463 = _412 * _414;
                        precise float _464 = _306 * _412;
                        precise float _466 = (-_270) * _407;
                        precise float _467 = _466 + _464;
                        precise float _469 = _396 * (-_270);
                        precise float _470 = _469 + _464;
                        precise float _471 = _436 * _439;
                        precise float _472 = _429 * _439;
                        precise float _473 = _306 * 64.0;
                        precise float _474 = _473 + _467;
                        precise float _475 = _306 * 64.0;
                        precise float _476 = _475 + _470;
                        precise float _477 = _470 * _476;
                        precise float _478 = _467 * _474;
                        precise float _483 = _270 * (-64.0);
                        precise float _484 = _483 + _470;
                        precise float _485 = _270 * (-64.0);
                        precise float _486 = _485 + _461;
                        precise float _487 = _470 * _484;
                        precise float _488 = _461 * _486;
                        precise float _493 = _332 * 64.0;
                        precise float _494 = _493 + _454;
                        precise float _495 = _332 * 64.0;
                        precise float _496 = _495 + _447;
                        precise float _497 = _447 * _496;
                        precise float _499 = _454 * _494;
                        precise float _503 = _338 * (-64.0);
                        precise float _504 = _503 + _447;
                        precise float _505 = _338 * (-64.0);
                        precise float _506 = _505 + _456;
                        precise float _507 = _447 * _504;
                        precise float _508 = _456 * _506;
                        _516 = 0u;
                        _517 = floatBitsToUint((0.0 >= min(max(_472, _508), min(min(max(_457, _499), min(min(max(_471, _488), min(min(max(_437, _478), min(min(max(_440, _434), min(min(max(_397, _394), max(_409, _408)), max(_426, _423))), max(_451, _477))), max(_463, _487))), max(_448, _497))), max(_462, _507)))) ? 1.4012984643248170709237295832899e-45 : 0.0);
                    }
                    else
                    {
                        _516 = floatBitsToUint((((_367 && _350) && _370) && _373) ? 1.4012984643248170709237295832899e-45 : 0.0);
                        _517 = 1u;
                    }
                    _518 = _516;
                    _519 = _517;
                }
                else
                {
                    _518 = 0u;
                    _519 = 1u;
                }
                bool _521 = _216 && (0u != _519);
                if (_521)
                {
                    uint _545;
                    if (_521 && _521)
                    {
                        uvec2 _525 = unpackUint2x32(packUint2x32(uvec2(_164, _169)));
                        uint _530 = uint(bitCount(_525.x)) + uint(bitCount(_525.y));
                        uint _533 = atomicAdd(ssbo_3_1.data[0u + (bitfieldExtract(push_data.buf_offsets0.x, int(16u), int(8u)) >> 2u)], _530);
                        uint _544 = atomicAdd(gds_buffer_1.data[((srt_flatbuf_1.data[34u] << 2u) + 12u) >> 2u], _530);
                        _545 = _544;
                    }
                    else
                    {
                        _545 = 0u;
                    }
                    uint _546 = subgroupBroadcastFirst(_545);
                    if (_521 && (10000u > _546))
                    {
                        uint _554 = (gl_WorkGroupID.x << 4u) >> 2u;
                        uint _557 = ssbo_1_1.data[_554 + buf0_dword_off];
                        uint _561 = ssbo_1_1.data[(_554 + 1u) + buf0_dword_off];
                        uvec4 _571 = uvec4(_557, _561, (bitfieldExtract(255u & _138, int(0u), int(24u)) * 256u) + ((_121 & 4294901760u) | (255u & _135)), floatBitsToUint((0u != _518) ? 1.4012984643248170709237295832899e-45 : 0.0));
                        uint _573 = (_546 * 4u) + (bitfieldExtract(push_data.buf_offsets0.x, int(24u), int(8u)) >> 2u);
                        ssbo_4_1.data[_573] = _571.x;
                        ssbo_4_1.data[_573 + 1u] = _571.y;
                        ssbo_4_1.data[_573 + 2u] = _571.z;
                        ssbo_4_1.data[_573 + 3u] = _571.w;
                    }
                }
            }
        }
    }
}

