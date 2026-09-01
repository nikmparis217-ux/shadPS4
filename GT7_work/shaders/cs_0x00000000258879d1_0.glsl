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

layout(binding = 3, std430) buffer ssbo_4
{
    uint data[];
} ssbo_4_1;

layout(binding = 4, std430) readonly buffer srt_flatbuf
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

void main()
{
    uint _112 = (gl_WorkGroupID.x << 6u) + gl_LocalInvocationID.x;
    precise float _117 = 4294967296.0 * (1.0 / float(srt_flatbuf_1.data[32u]));
    uint _118 = uint(_117);
    uvec2 _123 = unpackUint2x32((uint64_t(srt_flatbuf_1.data[32u]) * uint64_t(_118)) + 0ul);
    uint _124 = _123.x;
    bool _126 = 0u != _123.y;
    full_result_u32x2 _132;
    umulExtended(floatBitsToUint(_126 ? uintBitsToFloat(_124) : uintBitsToFloat(0u - _124)), _118, _132._m1, _132._m0);
    full_result_u32x2 _140;
    umulExtended(floatBitsToUint(_126 ? uintBitsToFloat(_118 - _132._m1) : uintBitsToFloat(_118 + _132._m1)), _112, _140._m1, _140._m0);
    uint _142 = srt_flatbuf_1.data[32u] * _140._m1;
    bool _145 = _112 >= _142;
    full_result_u32x2 _148;
    _148._m0 = uaddCarry(0u, _140._m1, _148._m1);
    full_result_u32x2 _150;
    _150._m0 = uaddCarry(_148._m0, uint(_145 && (srt_flatbuf_1.data[32u] <= (_112 - _142))), _150._m1);
    full_result_u32x2 _154;
    _154._m0 = uaddCarry(4294967295u, _150._m0, _154._m1);
    full_result_u32x2 _156;
    _156._m0 = uaddCarry(_154._m0, uint(_145), _156._m1);
    uint _168 = floatBitsToUint(((0u != srt_flatbuf_1.data[32u]) ? true : false) ? uintBitsToFloat(_156._m0) : uintBitsToFloat(0xffffffffu /* nan */));
    bool _169 = srt_flatbuf_1.data[34u] > _168;
    if (_169)
    {
        uint _177 = ((srt_flatbuf_1.data[33u] + _168) * 2u) + (bitfieldExtract(push_data.buf_offsets0.x, int(0u), int(8u)) >> 2u);
        uvec2 _183 = uvec2(ssbo_1_1.data[_177], ssbo_1_1.data[_177 + 1u]);
        uint _184 = _183.x;
        bool _187 = _169 && (4294967295u != _184);
        if (_187)
        {
            uint _205 = (_112 - (srt_flatbuf_1.data[32u] * _168)) + (srt_flatbuf_1.data[32u] * (_183.y + ssbo_2_1.data[((_184 * 2u) + 1u) + (bitfieldExtract(push_data.buf_offsets0.x, int(8u), int(8u)) >> 2u)]));
            if (_187 && (srt_flatbuf_1.data[18u] > _205))
            {
                ssbo_4_1.data[_205 + (bitfieldExtract(push_data.buf_offsets0.x, int(24u), int(8u)) >> 2u)] = ssbo_3_1.data[_112 + (bitfieldExtract(push_data.buf_offsets0.x, int(16u), int(8u)) >> 2u)];
            }
        }
    }
}

