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

layout(binding = 5, std430) readonly buffer ssbo_2
{
    uint data[];
} ssbo_2_1;

layout(binding = 6, std430) readonly buffer clip_planes
{
    float data[];
} clip_planes_1;

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

#ifdef GL_ARB_shader_draw_parameters
#define SPIRV_Cross_BaseVertex gl_BaseVertexARB
#else
uniform int SPIRV_Cross_BaseVertex;
#endif
#ifdef GL_ARB_shader_draw_parameters
#define SPIRV_Cross_BaseInstance gl_BaseInstanceARB
#else
uniform int SPIRV_Cross_BaseInstance;
#endif
layout(location = 0) in vec4 vs_in_attr0;
layout(location = 1) in vec4 vs_in_attr1;
layout(location = 0) out vec4 out_attr0;

void main()
{
    uint buf1_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(8u), int(8u)) >> 2u;
    vec4 _87 = vec4(vs_in_attr0.x, vs_in_attr0.y, vs_in_attr0.z, vs_in_attr0.w);
    vec4 _90 = vec4(_87.x, _87.y, vec4(0.0, 1.0, 0.0, 0.0).x, vec4(0.0, 1.0, 0.0, 0.0).y);
    float _91 = _90.x;
    float _92 = _90.y;
    vec4 _101 = vec4(vs_in_attr1.x, vs_in_attr1.y, vs_in_attr1.z, vs_in_attr1.w);
    vec4 _102 = vec4(_101.x, _101.y, vec4(0.0, 1.0, 0.0, 0.0).x, vec4(0.0, 1.0, 0.0, 0.0).y);
    precise float _153 = uintBitsToFloat(ssbo_2_1.data[3u + buf1_dword_off]) * _91;
    precise float _154 = _153 + uintBitsToFloat(ssbo_2_1.data[15u + buf1_dword_off]);
    precise float _157 = uintBitsToFloat(ssbo_2_1.data[2u + buf1_dword_off]) * _91;
    precise float _158 = _157 + uintBitsToFloat(ssbo_2_1.data[14u + buf1_dword_off]);
    precise float _161 = uintBitsToFloat(ssbo_2_1.data[1u + buf1_dword_off]) * _91;
    precise float _162 = _161 + uintBitsToFloat(ssbo_2_1.data[13u + buf1_dword_off]);
    precise float _165 = uintBitsToFloat(ssbo_2_1.data[0u + buf1_dword_off]) * _91;
    precise float _166 = _165 + uintBitsToFloat(ssbo_2_1.data[12u + buf1_dword_off]);
    precise float _168 = uintBitsToFloat(ssbo_2_1.data[7u + buf1_dword_off]) * _92;
    precise float _169 = _168 + _154;
    precise float _171 = uintBitsToFloat(ssbo_2_1.data[6u + buf1_dword_off]) * _92;
    precise float _172 = _171 + _158;
    precise float _174 = uintBitsToFloat(ssbo_2_1.data[5u + buf1_dword_off]) * _92;
    precise float _175 = _174 + _162;
    precise float _177 = uintBitsToFloat(ssbo_2_1.data[4u + buf1_dword_off]) * _92;
    precise float _178 = _177 + _166;
    gl_Position.x = _178;
    gl_Position.y = _175;
    gl_Position.z = _172;
    gl_Position.w = _169;
    out_attr0.x = _102.x;
    out_attr0.y = _102.y;
    out_attr0.z = _102.z;
    out_attr0.w = _102.w;
}

