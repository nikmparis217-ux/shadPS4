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

layout(binding = 0, std430) readonly buffer srt_flatbuf
{
    uint data[];
} srt_flatbuf_1;

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

layout(binding = 2) uniform writeonly image2DArray cs_img16[9];
uniform sampler2DArray SPIRV_Cross_Combinedcs_img24SPIRV_Cross_DummySampler;

void main()
{
    uint _97 = srt_flatbuf_1.data[32u];
    uint _101 = srt_flatbuf_1.data[33u];
    uint _105 = srt_flatbuf_1.data[34u];
    uint _109 = srt_flatbuf_1.data[35u];
    uint _115 = srt_flatbuf_1.data[36u];
    uint _119 = srt_flatbuf_1.data[37u];
    uint _120 = (gl_WorkGroupID.y << 4u) + gl_LocalInvocationID.y;
    bool _124 = _119 > _120;
    uint _125 = gl_WorkGroupID.z + (_105 * 6u);
    uint _126 = gl_WorkGroupID.z + (_97 * 6u);
    uint _128 = (gl_WorkGroupID.x << 4u) + gl_LocalInvocationID.x;
    if ((_115 > _128) && _124)
    {
        vec4 _138 = vec4(texelFetch(SPIRV_Cross_Combinedcs_img24SPIRV_Cross_DummySampler, ivec3(uvec3(_128, _120, _125)), int(_109)));
        imageStore(cs_img16[_101], ivec3(uvec3(_128, _120, _126)), vec4(_138.x, _138.y, _138.z, vec4(0.0, 1.0, 0.0, 0.0).x));
    }
    uint _147 = _128 + 8u;
    if ((_115 > _147) && _124)
    {
        vec4 _157 = vec4(texelFetch(SPIRV_Cross_Combinedcs_img24SPIRV_Cross_DummySampler, ivec3(uvec3(_147, _120, _125)), int(_109)));
        imageStore(cs_img16[_101], ivec3(uvec3(_147, _120, _126)), vec4(_157.x, _157.y, _157.z, vec4(0.0, 1.0, 0.0, 0.0).x));
    }
    uint _162 = _120 + 8u;
    bool _163 = _119 > _162;
    if ((_115 > _128) && _163)
    {
        vec4 _173 = vec4(texelFetch(SPIRV_Cross_Combinedcs_img24SPIRV_Cross_DummySampler, ivec3(uvec3(_128, _162, _125)), int(_109)));
        imageStore(cs_img16[_101], ivec3(uvec3(_128, _162, _126)), vec4(_173.x, _173.y, _173.z, vec4(0.0, 1.0, 0.0, 0.0).x));
    }
    if ((_115 > _147) && _163)
    {
        vec4 _187 = vec4(texelFetch(SPIRV_Cross_Combinedcs_img24SPIRV_Cross_DummySampler, ivec3(uvec3(_147, _162, _125)), int(_109)));
        imageStore(cs_img16[_101], ivec3(uvec3(_147, _162, _126)), vec4(_187.x, _187.y, _187.z, vec4(0.0, 1.0, 0.0, 0.0).x));
    }
}

