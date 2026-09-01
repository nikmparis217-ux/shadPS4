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
layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

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

layout(binding = 1) uniform writeonly image2D cs_img16;
layout(binding = 2) uniform writeonly image2D cs_img24;
uniform sampler2D SPIRV_Cross_Combinedcs_img32SPIRV_Cross_DummySampler;
uniform sampler2D SPIRV_Cross_Combinedcs_img32cs_sampinline_0xfff00000008036_0x2500000;

void main()
{
    uint _79 = (bitfieldExtract(gl_LocalInvocationID.y, int(0u), int(24u)) * 2u) + (gl_WorkGroupID.y << 4u);
    uint _83 = (bitfieldExtract(gl_LocalInvocationID.x, int(0u), int(24u)) * 2u) + (gl_WorkGroupID.x << 4u);
    uint _84 = _83 << 1u;
    uint _85 = _79 << 1u;
    float _89 = float(_84 + 1u);
    float _91 = float(_85 + 1u);
    float _92 = float(_84 + 3u);
    uvec4 _95 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedcs_img32SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
    precise float _98 = _91 / float(_95.y);
    precise float _101 = _89 / float(_95.x);
    vec4 _106 = textureLod(SPIRV_Cross_Combinedcs_img32cs_sampinline_0xfff00000008036_0x2500000, vec2(_101, _98), 0.0);
    float _107 = _106.x;
    uvec4 _113 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedcs_img32SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
    precise float _116 = _91 / float(_113.y);
    precise float _119 = _92 / float(_113.x);
    vec4 _124 = textureLod(SPIRV_Cross_Combinedcs_img32cs_sampinline_0xfff00000008036_0x2500000, vec2(_119, _116), 0.0);
    float _125 = _124.x;
    uint _129 = _79 + 1u;
    uint _130 = _83 + 1u;
    float _132 = float(_85 + 3u);
    uvec4 _135 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedcs_img32SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
    precise float _138 = _132 / float(_135.y);
    precise float _141 = _89 / float(_135.x);
    vec4 _146 = textureLod(SPIRV_Cross_Combinedcs_img32cs_sampinline_0xfff00000008036_0x2500000, vec2(_141, _138), 0.0);
    float _147 = _146.x;
    uvec4 _153 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedcs_img32SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
    precise float _156 = _132 / float(_153.y);
    precise float _159 = _92 / float(_153.x);
    vec4 _164 = textureLod(SPIRV_Cross_Combinedcs_img32cs_sampinline_0xfff00000008036_0x2500000, vec2(_159, _156), 0.0);
    float _165 = _164.x;
    vec4 _171 = vec4(_107, _106.yzw);
    imageStore(cs_img16, ivec2(uvec2(_83, _79)), vec4(_171.x, _171.y, _171.z, vec4(0.0, 1.0, 0.0, 0.0).x));
    precise float _177 = _107 + _125;
    precise float _178 = _106.w + _124.w;
    precise float _179 = _106.z + _124.z;
    precise float _180 = _106.y + _124.y;
    vec4 _181 = vec4(_125, _124.yzw);
    imageStore(cs_img16, ivec2(uvec2(_130, _79)), vec4(_181.x, _181.y, _181.z, vec4(0.0, 1.0, 0.0, 0.0).x));
    precise float _185 = _177 + _147;
    precise float _186 = _178 + _146.w;
    precise float _187 = _179 + _146.z;
    precise float _188 = _180 + _146.y;
    precise float _189 = _185 + _165;
    precise float _190 = _186 + _164.w;
    precise float _191 = _187 + _164.z;
    precise float _192 = _188 + _164.y;
    precise float _194 = 0.25 * _189;
    precise float _195 = 0.25 * _190;
    precise float _196 = 0.25 * _191;
    precise float _197 = 0.25 * _192;
    vec4 _198 = vec4(_147, _146.yzw);
    imageStore(cs_img16, ivec2(uvec2(_83, _129)), vec4(_198.x, _198.y, _198.z, vec4(0.0, 1.0, 0.0, 0.0).x));
    vec4 _202 = vec4(_165, _164.yzw);
    imageStore(cs_img16, ivec2(uvec2(_130, _129)), vec4(_202.x, _202.y, _202.z, vec4(0.0, 1.0, 0.0, 0.0).x));
    vec4 _206 = vec4(_194, _197, _196, _195);
    imageStore(cs_img24, ivec2(uvec2(_83 >> 1u, _79 >> 1u)), vec4(_206.x, _206.y, _206.z, vec4(0.0, 1.0, 0.0, 0.0).x));
}

