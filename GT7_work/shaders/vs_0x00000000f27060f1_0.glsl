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

uniform sampler2DArray SPIRV_Cross_Combinedvs_img4vs_sampsgpr_16;

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
    vec4 _95 = vec4(vs_in_attr0.x, vs_in_attr0.y, vs_in_attr0.z, vs_in_attr0.w);
    vec4 _98 = vec4(_95.x, _95.y, _95.z, vec4(0.0, 1.0, 0.0, 0.0).y);
    float _99 = _98.x;
    float _100 = _98.y;
    float _101 = _98.z;
    vec4 _110 = vec4(vs_in_attr1.x, vs_in_attr1.y, vs_in_attr1.z, vs_in_attr1.w);
    vec4 _111 = vec4(_110.x, _110.y, _110.z, _110.w);
    precise float _117 = 1.5 - 1.0;
    precise float _118 = 1.5 - 1.0;
    precise float _121 = 2.0 / 8.0;
    vec4 _130 = textureLod(SPIRV_Cross_Combinedvs_img4vs_sampsgpr_16, vec3(_117, _118, fma(floor(_121), -2.0, 2.0)), 0.0);
    precise float _199 = _99 * uintBitsToFloat(ssbo_1_1.data[3u + buf0_dword_off]);
    precise float _200 = _199 + uintBitsToFloat(ssbo_1_1.data[15u + buf0_dword_off]);
    precise float _203 = _99 * uintBitsToFloat(ssbo_1_1.data[2u + buf0_dword_off]);
    precise float _204 = _203 + uintBitsToFloat(ssbo_1_1.data[14u + buf0_dword_off]);
    precise float _207 = _99 * uintBitsToFloat(ssbo_1_1.data[1u + buf0_dword_off]);
    precise float _208 = _207 + uintBitsToFloat(ssbo_1_1.data[13u + buf0_dword_off]);
    precise float _211 = _99 * uintBitsToFloat(ssbo_1_1.data[0u + buf0_dword_off]);
    precise float _212 = _211 + uintBitsToFloat(ssbo_1_1.data[12u + buf0_dword_off]);
    precise float _214 = uintBitsToFloat(ssbo_1_1.data[7u + buf0_dword_off]) * _100;
    precise float _215 = _214 + _200;
    precise float _217 = uintBitsToFloat(ssbo_1_1.data[6u + buf0_dword_off]) * _100;
    precise float _218 = _217 + _204;
    precise float _220 = uintBitsToFloat(ssbo_1_1.data[5u + buf0_dword_off]) * _100;
    precise float _221 = _220 + _208;
    precise float _223 = uintBitsToFloat(ssbo_1_1.data[4u + buf0_dword_off]) * _100;
    precise float _224 = _223 + _212;
    precise float _226 = _101 * uintBitsToFloat(ssbo_1_1.data[10u + buf0_dword_off]);
    precise float _227 = _226 + _218;
    precise float _229 = uintBitsToFloat(ssbo_1_1.data[11u + buf0_dword_off]) * _101;
    precise float _230 = _229 + _215;
    precise float _232 = uintBitsToFloat(ssbo_1_1.data[9u + buf0_dword_off]) * _101;
    precise float _233 = _232 + _221;
    precise float _235 = uintBitsToFloat(ssbo_1_1.data[8u + buf0_dword_off]) * _101;
    precise float _236 = _235 + _224;
    gl_Position.x = _236;
    gl_Position.y = _233;
    gl_Position.z = _227;
    gl_Position.w = _230;
    gl_Layer = int(floatBitsToUint(uintBitsToFloat(ssbo_1_1.data[16u + buf0_dword_off])));
    float _243 = max(0.0, _130.x);
    float _244 = max(0.0, _130.y);
    float _251 = max(0.0, _130.z);
    bool _262 = (((((isnan(_243) || isnan(_243)) || (isnan(_244) || isnan(_244))) || (isnan(_251) || isnan(_251))) || isinf(_243)) || isinf(_244)) || isinf(_251);
    precise float _266 = _111.x * (_262 ? 0.0 : _243);
    precise float _267 = _111.z * (_262 ? 0.0 : _251);
    precise float _268 = _111.y * (_262 ? 0.0 : _244);
    out_attr0.x = _266;
    out_attr0.y = _268;
    out_attr0.z = _267;
    out_attr0.w = _111.w;
}

