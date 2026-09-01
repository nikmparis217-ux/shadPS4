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

layout(binding = 5, std430) readonly buffer ssbo_2
{
    uint data[];
} ssbo_2_1;

layout(binding = 5, std430) readonly buffer ssbo_2_2
{
    float data[];
} ssbo_2_3;

layout(binding = 5, std430) readonly buffer ssbo_2_4
{
    uint16_t data[];
} ssbo_2_5;

layout(binding = 5, std430) readonly buffer ssbo_2_6
{
    uint8_t data[];
} ssbo_2_7;

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
    precise float _276 = uintBitsToFloat(ssbo_2_1.data[32u + buf1_dword_off]) * _110;
    precise float _278 = uintBitsToFloat(ssbo_2_1.data[33u + buf1_dword_off]) * _110;
    precise float _281 = uintBitsToFloat(ssbo_2_1.data[35u + buf1_dword_off]) * _110;
    precise float _282 = _281 + uintBitsToFloat(ssbo_2_1.data[47u + buf1_dword_off]);
    precise float _284 = uintBitsToFloat(ssbo_2_1.data[39u + buf1_dword_off]) * _111;
    precise float _285 = _284 + _282;
    precise float _287 = uintBitsToFloat(ssbo_2_1.data[36u + buf1_dword_off]) * _111;
    precise float _288 = _287 + _276;
    precise float _290 = uintBitsToFloat(ssbo_2_1.data[37u + buf1_dword_off]) * _111;
    precise float _291 = _290 + _278;
    float _292 = 1.0 / _285;
    precise float _294 = uintBitsToFloat(ssbo_2_1.data[44u + buf1_dword_off]) + _288;
    precise float _296 = uintBitsToFloat(ssbo_2_1.data[45u + buf1_dword_off]) + _291;
    precise float _299 = uintBitsToFloat(ssbo_2_1.data[49u + buf1_dword_off]) * _110;
    precise float _300 = _299 + uintBitsToFloat(ssbo_2_1.data[61u + buf1_dword_off]);
    precise float _303 = uintBitsToFloat(ssbo_2_1.data[48u + buf1_dword_off]) * _110;
    precise float _304 = _303 + uintBitsToFloat(ssbo_2_1.data[60u + buf1_dword_off]);
    precise float _305 = _292 * _294;
    precise float _306 = _292 * _296;
    precise float _308 = uintBitsToFloat(ssbo_2_1.data[53u + buf1_dword_off]) * _111;
    precise float _309 = _308 + _300;
    precise float _311 = uintBitsToFloat(ssbo_2_1.data[52u + buf1_dword_off]) * _111;
    precise float _312 = _311 + _304;
    precise float _313 = _182.w * _110;
    precise float _314 = _313 + _156.w;
    precise float _315 = _182.z * _110;
    precise float _316 = _315 + _156.z;
    precise float _317 = _182.y * _110;
    precise float _318 = _317 + _156.y;
    precise float _319 = _182.x * _110;
    precise float _320 = _319 + _156.x;
    precise float _321 = _210.w * _111;
    precise float _322 = _321 + _314;
    precise float _323 = _210.z * _111;
    precise float _324 = _323 + _316;
    precise float _325 = _210.y * _111;
    precise float _326 = _325 + _318;
    precise float _327 = _111 * _210.x;
    precise float _328 = _327 + _320;
    gl_Layer = int(floatBitsToUint(uintBitsToFloat(uint((gl_InstanceID + SPIRV_Cross_BaseInstance)))));
    gl_Position.x = _328;
    gl_Position.y = _326;
    gl_Position.z = _324;
    gl_Position.w = _322;
    out_attr3.x = _328;
    out_attr3.y = _326;
    out_attr3.z = _324;
    out_attr3.w = _322;
    out_attr2.x = _110;
    out_attr2.y = _111;
    out_attr2.z = _312;
    out_attr2.w = _309;
    out_attr1.x = _305;
    out_attr1.y = _306;
    out_attr1.z = 0.0;
    out_attr1.w = 0.0;
    out_attr0.x = _121.x;
    out_attr0.y = _121.y;
    out_attr0.z = _121.z;
    out_attr0.w = _121.w;
}

