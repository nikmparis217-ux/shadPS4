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
layout(location = 2) in vec4 vs_in_attr2;
layout(location = 0) out vec4 out_attr0;
layout(location = 1) out vec4 out_attr1;
layout(location = 2) out vec4 out_attr2;
layout(location = 3) out vec4 out_attr3;

void main()
{
    uint buf1_off = bitfieldExtract(push_data.buf_offsets0.x, int(8u), int(8u));
    uint buf1_dword_off = buf1_off >> 2u;
    vec4 _107 = vec4(vs_in_attr0.x, vs_in_attr0.y, vs_in_attr0.z, vs_in_attr0.w);
    vec4 _110 = vec4(_107.x, _107.y, vec4(0.0, 1.0, 0.0, 0.0).x, vec4(0.0, 1.0, 0.0, 0.0).y);
    float _111 = _110.x;
    float _112 = _110.y;
    vec4 _121 = vec4(vs_in_attr1.x, vs_in_attr1.y, vs_in_attr1.z, vs_in_attr1.w);
    vec4 _122 = vec4(_121.x, _121.y, _121.z, _121.w);
    vec4 _135 = vec4(vs_in_attr2.x, vs_in_attr2.y, vs_in_attr2.z, vs_in_attr2.w);
    vec4 _136 = vec4(_135.x, _135.y, vec4(0.0, 1.0, 0.0, 0.0).x, vec4(0.0, 1.0, 0.0, 0.0).y);
    uint _140 = uint((gl_InstanceID + SPIRV_Cross_BaseInstance)) << 6u;
    uint _142 = uint(int(_140) >> int(4u));
    uint _144 = 15u & _140;
    uint _151 = ((((_142 + 3u) * 16u) + _144) >> 2u) + buf1_dword_off;
    vec4 _168 = vec4(vec4(ssbo_2_3.data[_151], ssbo_2_3.data[_151 + 1u], ssbo_2_3.data[_151 + 2u], ssbo_2_3.data[_151 + 3u]));
    vec4 _169 = vec4(_168.x, _168.y, _168.z, _168.w);
    uint _177 = (((_142 * 16u) + _144) >> 2u) + buf1_dword_off;
    vec4 _194 = vec4(vec4(ssbo_2_3.data[_177], ssbo_2_3.data[_177 + 1u], ssbo_2_3.data[_177 + 2u], ssbo_2_3.data[_177 + 3u]));
    vec4 _195 = vec4(_194.x, _194.y, _194.z, _194.w);
    uint _205 = ((((_142 + 1u) * 16u) + _144) >> 2u) + buf1_dword_off;
    vec4 _222 = vec4(vec4(ssbo_2_3.data[_205], ssbo_2_3.data[_205 + 1u], ssbo_2_3.data[_205 + 2u], ssbo_2_3.data[_205 + 3u]));
    vec4 _223 = vec4(_222.x, _222.y, _222.z, _222.w);
    precise float _289 = uintBitsToFloat(ssbo_2_1.data[32u + buf1_dword_off]) * _111;
    precise float _291 = uintBitsToFloat(ssbo_2_1.data[33u + buf1_dword_off]) * _111;
    precise float _294 = uintBitsToFloat(ssbo_2_1.data[35u + buf1_dword_off]) * _111;
    precise float _295 = _294 + uintBitsToFloat(ssbo_2_1.data[47u + buf1_dword_off]);
    precise float _297 = uintBitsToFloat(ssbo_2_1.data[39u + buf1_dword_off]) * _112;
    precise float _298 = _297 + _295;
    precise float _300 = uintBitsToFloat(ssbo_2_1.data[36u + buf1_dword_off]) * _112;
    precise float _301 = _300 + _289;
    precise float _303 = uintBitsToFloat(ssbo_2_1.data[37u + buf1_dword_off]) * _112;
    precise float _304 = _303 + _291;
    float _305 = 1.0 / _298;
    precise float _307 = uintBitsToFloat(ssbo_2_1.data[44u + buf1_dword_off]) + _301;
    precise float _309 = uintBitsToFloat(ssbo_2_1.data[45u + buf1_dword_off]) + _304;
    precise float _312 = uintBitsToFloat(ssbo_2_1.data[49u + buf1_dword_off]) * _111;
    precise float _313 = _312 + uintBitsToFloat(ssbo_2_1.data[61u + buf1_dword_off]);
    precise float _316 = uintBitsToFloat(ssbo_2_1.data[48u + buf1_dword_off]) * _111;
    precise float _317 = _316 + uintBitsToFloat(ssbo_2_1.data[60u + buf1_dword_off]);
    precise float _318 = _305 * _307;
    precise float _319 = _305 * _309;
    precise float _321 = uintBitsToFloat(ssbo_2_1.data[53u + buf1_dword_off]) * _112;
    precise float _322 = _321 + _313;
    precise float _324 = uintBitsToFloat(ssbo_2_1.data[52u + buf1_dword_off]) * _112;
    precise float _325 = _324 + _317;
    precise float _326 = _195.w * _111;
    precise float _327 = _326 + _169.w;
    precise float _328 = _195.z * _111;
    precise float _329 = _328 + _169.z;
    precise float _330 = _195.y * _111;
    precise float _331 = _330 + _169.y;
    precise float _332 = _111 * _195.x;
    precise float _333 = _332 + _169.x;
    precise float _334 = _223.w * _112;
    precise float _335 = _334 + _327;
    precise float _336 = _223.z * _112;
    precise float _337 = _336 + _329;
    precise float _338 = _223.y * _112;
    precise float _339 = _338 + _331;
    precise float _340 = _112 * _223.x;
    precise float _341 = _340 + _333;
    gl_Layer = int(floatBitsToUint(uintBitsToFloat(uint((gl_InstanceID + SPIRV_Cross_BaseInstance)))));
    gl_Position.x = _341;
    gl_Position.y = _339;
    gl_Position.z = _337;
    gl_Position.w = _335;
    out_attr3.x = _341;
    out_attr3.y = _339;
    out_attr3.z = _337;
    out_attr3.w = _335;
    out_attr2.x = _136.x;
    out_attr2.y = _136.y;
    out_attr2.z = _325;
    out_attr2.w = _322;
    out_attr1.x = _318;
    out_attr1.y = _319;
    out_attr1.z = 0.0;
    out_attr1.w = 0.0;
    out_attr0.x = _122.x;
    out_attr0.y = _122.y;
    out_attr0.z = _122.z;
    out_attr0.w = _122.w;
}

