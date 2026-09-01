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
#ifdef GL_ARB_shader_draw_parameters
#extension GL_ARB_shader_draw_parameters : enable
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

layout(binding = 3, std430) readonly buffer ssbo_2
{
    uint data[];
} ssbo_2_1;

layout(binding = 3, std430) readonly buffer ssbo_2_2
{
    float data[];
} ssbo_2_3;

layout(binding = 3, std430) readonly buffer ssbo_2_4
{
    uint16_t data[];
} ssbo_2_5;

layout(binding = 3, std430) readonly buffer ssbo_2_6
{
    uint8_t data[];
} ssbo_2_7;

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
layout(location = 0) out vec4 out_attr0;
layout(location = 1) out vec4 out_attr1;
layout(location = 2) out vec4 out_attr2;
layout(location = 3) out vec4 out_attr3;

void main()
{
    uint buf1_off = bitfieldExtract(push_data.buf_offsets0.x, int(8u), int(8u));
    uint buf1_dword_off = buf1_off >> 2u;
    vec4 _106 = vec4(vs_in_attr0.x, vs_in_attr0.y, vs_in_attr0.z, vs_in_attr0.w);
    vec4 _109 = vec4(_106.x, _106.y, vec4(0.0, 1.0, 0.0, 0.0).x, vec4(0.0, 1.0, 0.0, 0.0).y);
    float _110 = _109.x;
    float _111 = _109.y;
    vec4 _120 = vec4(vs_in_attr1.x, vs_in_attr1.y, vs_in_attr1.z, vs_in_attr1.w);
    vec4 _121 = vec4(_120.x, _120.y, _120.z, _120.w);
    uint _127 = uint((gl_InstanceID + SPIRV_Cross_BaseInstance)) << 6u;
    uint _129 = uint(int(_127) >> int(4u));
    uint _131 = 15u & _127;
    uint _138 = ((((_129 + 3u) * 16u) + _131) >> 2u) + buf1_dword_off;
    vec4 _155 = vec4(vec4(ssbo_2_3.data[_138], ssbo_2_3.data[_138 + 1u], ssbo_2_3.data[_138 + 2u], ssbo_2_3.data[_138 + 3u]));
    vec4 _156 = vec4(_155.x, _155.y, _155.z, _155.w);
    uint _164 = (((_129 * 16u) + _131) >> 2u) + buf1_dword_off;
    vec4 _181 = vec4(vec4(ssbo_2_3.data[_164], ssbo_2_3.data[_164 + 1u], ssbo_2_3.data[_164 + 2u], ssbo_2_3.data[_164 + 3u]));
    vec4 _182 = vec4(_181.x, _181.y, _181.z, _181.w);
    uint _192 = ((((_129 + 1u) * 16u) + _131) >> 2u) + buf1_dword_off;
    vec4 _209 = vec4(vec4(ssbo_2_3.data[_192], ssbo_2_3.data[_192 + 1u], ssbo_2_3.data[_192 + 2u], ssbo_2_3.data[_192 + 3u]));
    vec4 _210 = vec4(_209.x, _209.y, _209.z, _209.w);
    precise float _252 = uintBitsToFloat(ssbo_2_1.data[32u + buf1_dword_off]) * _110;
    precise float _254 = uintBitsToFloat(ssbo_2_1.data[33u + buf1_dword_off]) * _110;
    precise float _257 = uintBitsToFloat(ssbo_2_1.data[35u + buf1_dword_off]) * _110;
    precise float _258 = _257 + uintBitsToFloat(ssbo_2_1.data[47u + buf1_dword_off]);
    precise float _260 = uintBitsToFloat(ssbo_2_1.data[39u + buf1_dword_off]) * _111;
    precise float _261 = _260 + _258;
    precise float _263 = uintBitsToFloat(ssbo_2_1.data[36u + buf1_dword_off]) * _111;
    precise float _264 = _263 + _252;
    precise float _266 = uintBitsToFloat(ssbo_2_1.data[37u + buf1_dword_off]) * _111;
    precise float _267 = _266 + _254;
    float _268 = 1.0 / _261;
    precise float _270 = uintBitsToFloat(ssbo_2_1.data[44u + buf1_dword_off]) + _264;
    precise float _272 = uintBitsToFloat(ssbo_2_1.data[45u + buf1_dword_off]) + _267;
    precise float _273 = _268 * _270;
    precise float _274 = _268 * _272;
    precise float _275 = _182.w * _110;
    precise float _276 = _275 + _156.w;
    precise float _277 = _182.z * _110;
    precise float _278 = _277 + _156.z;
    precise float _279 = _182.y * _110;
    precise float _280 = _279 + _156.y;
    precise float _281 = _182.x * _110;
    precise float _282 = _281 + _156.x;
    precise float _283 = _210.w * _111;
    precise float _284 = _283 + _276;
    precise float _285 = _210.z * _111;
    precise float _286 = _285 + _278;
    precise float _287 = _210.y * _111;
    precise float _288 = _287 + _280;
    precise float _289 = _111 * _210.x;
    precise float _290 = _289 + _282;
    gl_Layer = int(floatBitsToUint(uintBitsToFloat(uint((gl_InstanceID + SPIRV_Cross_BaseInstance)))));
    gl_Position.x = _290;
    gl_Position.y = _288;
    gl_Position.z = _286;
    gl_Position.w = _284;
    out_attr3.x = _290;
    out_attr3.y = _288;
    out_attr3.z = _286;
    out_attr3.w = _284;
    out_attr2.x = _110;
    out_attr2.y = _111;
    out_attr2.z = 0.0;
    out_attr2.w = 0.0;
    out_attr1.x = _273;
    out_attr1.y = _274;
    out_attr1.z = 0.0;
    out_attr1.w = 0.0;
    out_attr0.x = _121.x;
    out_attr0.y = _121.y;
    out_attr0.z = _121.z;
    out_attr0.w = _121.w;
}

