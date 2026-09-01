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

layout(binding = 3, std430) readonly buffer ssbo_2
{
    uint data[];
} ssbo_2_1;

layout(binding = 4, std430) readonly buffer clip_planes
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
layout(location = 2) in vec4 vs_in_attr2;
layout(location = 0) out vec4 out_attr0;
layout(location = 1) out vec4 out_attr1;

void main()
{
    uint buf1_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(8u), int(8u)) >> 2u;
    vec4 _89 = vec4(vs_in_attr0.x, vs_in_attr0.y, vs_in_attr0.z, vs_in_attr0.w);
    vec4 _92 = vec4(_89.x, _89.y, vec4(0.0, 1.0, 0.0, 0.0).x, vec4(0.0, 1.0, 0.0, 0.0).y);
    float _93 = _92.x;
    float _94 = _92.y;
    float _95 = _92.z;
    float _96 = _92.w;
    vec4 _105 = vec4(vs_in_attr1.x, vs_in_attr1.y, vs_in_attr1.z, vs_in_attr1.w);
    vec4 _106 = vec4(_105.x, _105.y, vec4(0.0, 1.0, 0.0, 0.0).x, vec4(0.0, 1.0, 0.0, 0.0).y);
    vec4 _119 = vec4(vs_in_attr2.x, vs_in_attr2.y, vs_in_attr2.z, vs_in_attr2.w);
    vec4 _120 = vec4(_119.x, _119.y, _119.z, _119.w);
    precise float _185 = uintBitsToFloat(ssbo_2_1.data[0u + buf1_dword_off]) * _93;
    precise float _187 = uintBitsToFloat(ssbo_2_1.data[3u + buf1_dword_off]) * _93;
    precise float _189 = uintBitsToFloat(ssbo_2_1.data[2u + buf1_dword_off]) * _93;
    precise float _191 = uintBitsToFloat(ssbo_2_1.data[1u + buf1_dword_off]) * _93;
    precise float _193 = uintBitsToFloat(ssbo_2_1.data[4u + buf1_dword_off]) * _94;
    precise float _194 = _193 + _185;
    precise float _196 = uintBitsToFloat(ssbo_2_1.data[7u + buf1_dword_off]) * _94;
    precise float _197 = _196 + _187;
    precise float _199 = uintBitsToFloat(ssbo_2_1.data[6u + buf1_dword_off]) * _94;
    precise float _200 = _199 + _189;
    precise float _202 = uintBitsToFloat(ssbo_2_1.data[5u + buf1_dword_off]) * _94;
    precise float _203 = _202 + _191;
    precise float _205 = uintBitsToFloat(ssbo_2_1.data[8u + buf1_dword_off]) * _95;
    precise float _206 = _205 + _194;
    precise float _208 = uintBitsToFloat(ssbo_2_1.data[11u + buf1_dword_off]) * _95;
    precise float _209 = _208 + _197;
    precise float _211 = uintBitsToFloat(ssbo_2_1.data[10u + buf1_dword_off]) * _95;
    precise float _212 = _211 + _200;
    precise float _214 = uintBitsToFloat(ssbo_2_1.data[9u + buf1_dword_off]) * _95;
    precise float _215 = _214 + _203;
    precise float _217 = uintBitsToFloat(ssbo_2_1.data[12u + buf1_dword_off]) * _96;
    precise float _218 = _217 + _206;
    precise float _220 = uintBitsToFloat(ssbo_2_1.data[15u + buf1_dword_off]) * _96;
    precise float _221 = _220 + _209;
    precise float _223 = uintBitsToFloat(ssbo_2_1.data[14u + buf1_dword_off]) * _96;
    precise float _224 = _223 + _212;
    precise float _226 = uintBitsToFloat(ssbo_2_1.data[13u + buf1_dword_off]) * _96;
    precise float _227 = _226 + _215;
    gl_Position.x = _218;
    gl_Position.y = _227;
    gl_Position.z = _224;
    gl_Position.w = _221;
    out_attr1.x = _120.x;
    out_attr1.y = _120.y;
    out_attr1.z = _120.z;
    out_attr1.w = _120.w;
    out_attr0.x = _106.x;
    out_attr0.y = _106.y;
    out_attr0.z = _106.z;
    out_attr0.w = _106.w;
}

