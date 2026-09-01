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

void main()
{
    uint buf1_off = bitfieldExtract(push_data.buf_offsets0.x, int(8u), int(8u));
    uint buf1_dword_off = buf1_off >> 2u;
    vec4 _105 = vec4(vs_in_attr0.x, vs_in_attr0.y, vs_in_attr0.z, vs_in_attr0.w);
    vec4 _108 = vec4(_105.x, _105.y, vec4(0.0, 1.0, 0.0, 0.0).x, vec4(0.0, 1.0, 0.0, 0.0).y);
    float _109 = _108.x;
    float _110 = _108.y;
    vec4 _119 = vec4(vs_in_attr1.x, vs_in_attr1.y, vs_in_attr1.z, vs_in_attr1.w);
    vec4 _120 = vec4(_119.x, _119.y, _119.z, _119.w);
    uint _126 = uint((gl_InstanceID + SPIRV_Cross_BaseInstance)) << 6u;
    uint _128 = uint(int(_126) >> int(4u));
    uint _130 = 15u & _126;
    uint _137 = ((((_128 + 3u) * 16u) + _130) >> 2u) + buf1_dword_off;
    vec4 _154 = vec4(vec4(ssbo_2_3.data[_137], ssbo_2_3.data[_137 + 1u], ssbo_2_3.data[_137 + 2u], ssbo_2_3.data[_137 + 3u]));
    vec4 _155 = vec4(_154.x, _154.y, _154.z, _154.w);
    uint _163 = (((_128 * 16u) + _130) >> 2u) + buf1_dword_off;
    vec4 _180 = vec4(vec4(ssbo_2_3.data[_163], ssbo_2_3.data[_163 + 1u], ssbo_2_3.data[_163 + 2u], ssbo_2_3.data[_163 + 3u]));
    vec4 _181 = vec4(_180.x, _180.y, _180.z, _180.w);
    uint _191 = ((((_128 + 1u) * 16u) + _130) >> 2u) + buf1_dword_off;
    vec4 _208 = vec4(vec4(ssbo_2_3.data[_191], ssbo_2_3.data[_191 + 1u], ssbo_2_3.data[_191 + 2u], ssbo_2_3.data[_191 + 3u]));
    vec4 _209 = vec4(_208.x, _208.y, _208.z, _208.w);
    precise float _251 = uintBitsToFloat(ssbo_2_1.data[32u + buf1_dword_off]) * _109;
    precise float _253 = uintBitsToFloat(ssbo_2_1.data[33u + buf1_dword_off]) * _109;
    precise float _256 = uintBitsToFloat(ssbo_2_1.data[35u + buf1_dword_off]) * _109;
    precise float _257 = _256 + uintBitsToFloat(ssbo_2_1.data[47u + buf1_dword_off]);
    precise float _259 = uintBitsToFloat(ssbo_2_1.data[39u + buf1_dword_off]) * _110;
    precise float _260 = _259 + _257;
    precise float _262 = uintBitsToFloat(ssbo_2_1.data[36u + buf1_dword_off]) * _110;
    precise float _263 = _262 + _251;
    precise float _265 = uintBitsToFloat(ssbo_2_1.data[37u + buf1_dword_off]) * _110;
    precise float _266 = _265 + _253;
    float _267 = 1.0 / _260;
    precise float _269 = uintBitsToFloat(ssbo_2_1.data[44u + buf1_dword_off]) + _263;
    precise float _271 = uintBitsToFloat(ssbo_2_1.data[45u + buf1_dword_off]) + _266;
    precise float _272 = _267 * _269;
    precise float _273 = _267 * _271;
    precise float _274 = _181.w * _109;
    precise float _275 = _274 + _155.w;
    precise float _276 = _181.z * _109;
    precise float _277 = _276 + _155.z;
    precise float _278 = _181.y * _109;
    precise float _279 = _278 + _155.y;
    precise float _280 = _109 * _181.x;
    precise float _281 = _280 + _155.x;
    precise float _282 = _209.w * _110;
    precise float _283 = _282 + _275;
    precise float _284 = _209.z * _110;
    precise float _285 = _284 + _277;
    precise float _286 = _209.y * _110;
    precise float _287 = _286 + _279;
    precise float _288 = _110 * _209.x;
    precise float _289 = _288 + _281;
    gl_Layer = int(floatBitsToUint(uintBitsToFloat(uint((gl_InstanceID + SPIRV_Cross_BaseInstance)))));
    gl_Position.x = _289;
    gl_Position.y = _287;
    gl_Position.z = _285;
    gl_Position.w = _283;
    out_attr2.x = _289;
    out_attr2.y = _287;
    out_attr2.z = _285;
    out_attr2.w = _283;
    out_attr1.x = _272;
    out_attr1.y = _273;
    out_attr1.z = 0.0;
    out_attr1.w = 0.0;
    out_attr0.x = _120.x;
    out_attr0.y = _120.y;
    out_attr0.z = _120.z;
    out_attr0.w = _120.w;
}

