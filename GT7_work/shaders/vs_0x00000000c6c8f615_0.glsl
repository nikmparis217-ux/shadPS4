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
#extension GL_ARB_shader_viewport_layer_array : require

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

layout(binding = 1, std430) readonly buffer clip_planes
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
    uint buf0_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(0u), int(8u)) >> 2u;
    vec4 _88 = vec4(vs_in_attr0.x, vs_in_attr0.y, vs_in_attr0.z, vs_in_attr0.w);
    vec4 _91 = vec4(_88.x, _88.y, _88.z, vec4(0.0, 1.0, 0.0, 0.0).y);
    float _92 = _91.x;
    float _93 = _91.y;
    float _94 = _91.z;
    vec4 _103 = vec4(vs_in_attr1.x, vs_in_attr1.y, vs_in_attr1.z, vs_in_attr1.w);
    vec4 _104 = vec4(_103.x, _103.y, _103.z, _103.w);
    precise float _174 = uintBitsToFloat(ssbo_1_1.data[3u + buf0_dword_off]) * _92;
    precise float _175 = _174 + uintBitsToFloat(ssbo_1_1.data[15u + buf0_dword_off]);
    precise float _178 = uintBitsToFloat(ssbo_1_1.data[2u + buf0_dword_off]) * _92;
    precise float _179 = _178 + uintBitsToFloat(ssbo_1_1.data[14u + buf0_dword_off]);
    precise float _182 = uintBitsToFloat(ssbo_1_1.data[1u + buf0_dword_off]) * _92;
    precise float _183 = _182 + uintBitsToFloat(ssbo_1_1.data[13u + buf0_dword_off]);
    precise float _186 = _92 * uintBitsToFloat(ssbo_1_1.data[0u + buf0_dword_off]);
    precise float _187 = _186 + uintBitsToFloat(ssbo_1_1.data[12u + buf0_dword_off]);
    precise float _189 = _93 * uintBitsToFloat(ssbo_1_1.data[7u + buf0_dword_off]);
    precise float _190 = _189 + _175;
    precise float _192 = _93 * uintBitsToFloat(ssbo_1_1.data[6u + buf0_dword_off]);
    precise float _193 = _192 + _179;
    precise float _195 = _93 * uintBitsToFloat(ssbo_1_1.data[5u + buf0_dword_off]);
    precise float _196 = _195 + _183;
    precise float _198 = uintBitsToFloat(ssbo_1_1.data[4u + buf0_dword_off]) * _93;
    precise float _199 = _198 + _187;
    precise float _201 = uintBitsToFloat(ssbo_1_1.data[8u + buf0_dword_off]) * _94;
    precise float _202 = _201 + _199;
    precise float _204 = uintBitsToFloat(ssbo_1_1.data[11u + buf0_dword_off]) * _94;
    precise float _205 = _204 + _190;
    precise float _207 = uintBitsToFloat(ssbo_1_1.data[10u + buf0_dword_off]) * _94;
    precise float _208 = _207 + _193;
    precise float _210 = uintBitsToFloat(ssbo_1_1.data[9u + buf0_dword_off]) * _94;
    precise float _211 = _210 + _196;
    gl_Position.x = _202;
    gl_Position.y = _211;
    gl_Position.z = _208;
    gl_Position.w = _205;
    gl_Layer = int(floatBitsToUint(uintBitsToFloat(ssbo_1_1.data[16u + buf0_dword_off])));
    out_attr0.x = _104.x;
    out_attr0.y = _104.y;
    out_attr0.z = _104.z;
    out_attr0.w = _104.w;
}

