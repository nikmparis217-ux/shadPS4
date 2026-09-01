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
    uint buf1_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(8u), int(8u)) >> 2u;
    uint _94 = gl_WorkGroupID.x << 9u;
    uint _97 = (_94 + 256u) + gl_LocalInvocationID.x;
    uint _98 = _94 + gl_LocalInvocationID.x;
    bool _99 = push_data.ud_regs0.y > _98;
    bool _100 = push_data.ud_regs0.y > _97;
    if (_99)
    {
        uint _105;
        if (_99 && _99)
        {
            _105 = ssbo_1_1.data[_98 + buf0_dword_off];
        }
        else
        {
            _105 = 0u;
        }
        if (_99 && (push_data.ud_regs0.x > _98))
        {
            ssbo_2_1.data[_98 + buf1_dword_off] = _105;
        }
    }
    if (_100)
    {
        uint _114;
        if (_100 && _100)
        {
            _114 = ssbo_1_1.data[_97 + buf0_dword_off];
        }
        else
        {
            _114 = 0u;
        }
        if (_100 && (push_data.ud_regs0.x > _97))
        {
            ssbo_2_1.data[_97 + buf1_dword_off] = _114;
        }
    }
}

