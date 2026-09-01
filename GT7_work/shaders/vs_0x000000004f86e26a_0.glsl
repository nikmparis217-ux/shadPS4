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

layout(binding = 2, std430) readonly buffer ssbo_1
{
    uint data[];
} ssbo_1_1;

layout(binding = 3, std430) readonly buffer clip_planes
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
    vec4 _87 = vec4(vs_in_attr0.x, vs_in_attr0.y, vs_in_attr0.z, vs_in_attr0.w);
    vec4 _90 = vec4(_87.x, _87.y, vec4(0.0, 1.0, 0.0, 0.0).x, vec4(0.0, 1.0, 0.0, 0.0).y);
    float _91 = _90.x;
    float _92 = _90.y;
    float _93 = _90.z;
    float _94 = _90.w;
    vec4 _103 = vec4(vs_in_attr1.x, vs_in_attr1.y, vs_in_attr1.z, vs_in_attr1.w);
    vec4 _104 = vec4(_103.x, _103.y, vec4(0.0, 1.0, 0.0, 0.0).x, vec4(0.0, 1.0, 0.0, 0.0).y);
    precise float _167 = uintBitsToFloat(ssbo_1_1.data[0u + buf0_dword_off]) * _91;
    precise float _169 = uintBitsToFloat(ssbo_1_1.data[3u + buf0_dword_off]) * _91;
    precise float _171 = uintBitsToFloat(ssbo_1_1.data[2u + buf0_dword_off]) * _91;
    precise float _173 = uintBitsToFloat(ssbo_1_1.data[1u + buf0_dword_off]) * _91;
    precise float _175 = uintBitsToFloat(ssbo_1_1.data[4u + buf0_dword_off]) * _92;
    precise float _176 = _175 + _167;
    precise float _178 = uintBitsToFloat(ssbo_1_1.data[7u + buf0_dword_off]) * _92;
    precise float _179 = _178 + _169;
    precise float _181 = uintBitsToFloat(ssbo_1_1.data[6u + buf0_dword_off]) * _92;
    precise float _182 = _181 + _171;
    precise float _184 = uintBitsToFloat(ssbo_1_1.data[5u + buf0_dword_off]) * _92;
    precise float _185 = _184 + _173;
    precise float _187 = uintBitsToFloat(ssbo_1_1.data[8u + buf0_dword_off]) * _93;
    precise float _188 = _187 + _176;
    precise float _190 = uintBitsToFloat(ssbo_1_1.data[11u + buf0_dword_off]) * _93;
    precise float _191 = _190 + _179;
    precise float _193 = uintBitsToFloat(ssbo_1_1.data[10u + buf0_dword_off]) * _93;
    precise float _194 = _193 + _182;
    precise float _196 = uintBitsToFloat(ssbo_1_1.data[9u + buf0_dword_off]) * _93;
    precise float _197 = _196 + _185;
    precise float _199 = uintBitsToFloat(ssbo_1_1.data[12u + buf0_dword_off]) * _94;
    precise float _200 = _199 + _188;
    precise float _202 = uintBitsToFloat(ssbo_1_1.data[15u + buf0_dword_off]) * _94;
    precise float _203 = _202 + _191;
    precise float _205 = uintBitsToFloat(ssbo_1_1.data[14u + buf0_dword_off]) * _94;
    precise float _206 = _205 + _194;
    precise float _208 = uintBitsToFloat(ssbo_1_1.data[13u + buf0_dword_off]) * _94;
    precise float _209 = _208 + _197;
    gl_Position.x = _200;
    gl_Position.y = _209;
    gl_Position.z = _206;
    gl_Position.w = _203;
    out_attr0.x = _104.x;
    out_attr0.y = _104.y;
    out_attr0.z = 0.0;
    out_attr0.w = 0.0;
}

