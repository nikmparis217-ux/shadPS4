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
layout(local_size_x = 256, local_size_y = 1, local_size_z = 1) in;

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

layout(binding = 1, std430) buffer ssbo_2_2
{
    float data[];
} ssbo_2_3;

layout(binding = 1, std430) buffer ssbo_2_4
{
    uint16_t data[];
} ssbo_2_5;

layout(binding = 1, std430) buffer ssbo_2_6
{
    uint8_t data[];
} ssbo_2_7;

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
    uint buf0_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(0u), int(8u)) >> 2u;
    uint buf1_off = bitfieldExtract(push_data.buf_offsets0.x, int(8u), int(8u));
    uint buf1_dword_off = buf1_off >> 2u;
    uint _114 = gl_WorkGroupID.x << 9u;
    uint _115 = 2u + buf0_dword_off;
    uint _117 = ssbo_1_1.data[_115];
    uint _118 = _114 + gl_LocalInvocationID.x;
    bool _119 = _117 > _118;
    uint _120 = 1u & _118;
    if (_119)
    {
        bool _122 = _119 && (0u != _120);
        uint _126;
        if (_122)
        {
            _126 = ssbo_1_1.data[1u + buf0_dword_off];
        }
        else
        {
            _126 = _120;
        }
        uint _132;
        if (_119 && (!_122))
        {
            _132 = ssbo_1_1.data[0u + buf0_dword_off];
        }
        else
        {
            _132 = _126;
        }
        if (_119 && (push_data.ud_regs0.x > _118))
        {
            ssbo_2_3.data[_118 + buf1_dword_off] = vec4(vec4(uintBitsToFloat(_132), 0.0, 0.0, 0.0).x, vec4(0.0, 1.0, 0.0, 0.0).x, vec4(0.0, 1.0, 0.0, 0.0).x, vec4(0.0, 1.0, 0.0, 0.0).x).x;
        }
    }
    uint _145 = (_114 + 256u) + gl_LocalInvocationID.x;
    uint _146 = 1u & _145;
    bool _148 = _117 > _145;
    if (_148)
    {
        bool _149 = _148 && (0u != _146);
        uint _153;
        if (_149)
        {
            _153 = ssbo_1_1.data[1u + buf0_dword_off];
        }
        else
        {
            _153 = _146;
        }
        uint _159;
        if (_148 && (!_149))
        {
            _159 = ssbo_1_1.data[0u + buf0_dword_off];
        }
        else
        {
            _159 = _153;
        }
        if (_148 && (push_data.ud_regs0.x > _145))
        {
            ssbo_2_3.data[_145 + buf1_dword_off] = vec4(vec4(uintBitsToFloat(_159), 0.0, 0.0, 0.0).x, vec4(0.0, 1.0, 0.0, 0.0).x, vec4(0.0, 1.0, 0.0, 0.0).x, vec4(0.0, 1.0, 0.0, 0.0).x).x;
        }
    }
}

