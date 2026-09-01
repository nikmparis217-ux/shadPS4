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
#extension GL_EXT_fragment_shader_barycentric : require

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

uniform sampler2D SPIRV_Cross_Combinedfs_img0SPIRV_Cross_DummySampler;
uniform sampler2D SPIRV_Cross_Combinedfs_img0fs_sampsgpr_8;

layout(location = 0) pervertexEXT in vec4 fs_in_attr0_p[3];
layout(location = 0) out vec4 frag_color0;

void main()
{
    precise float _75 = fs_in_attr0_p[1u].x - fs_in_attr0_p[0u].x;
    precise float _82 = fs_in_attr0_p[1u].y - fs_in_attr0_p[0u].y;
    precise float _88 = fs_in_attr0_p[2u].x - fs_in_attr0_p[0u].x;
    precise float _94 = fs_in_attr0_p[2u].y - fs_in_attr0_p[0u].y;
    uvec4 _98 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedfs_img0SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
    precise float _101 = fma(_94, gl_BaryCoordEXT.z, fma(_82, gl_BaryCoordEXT.y, fs_in_attr0_p[0u].y)) / float(_98.y);
    precise float _104 = fma(_88, gl_BaryCoordEXT.z, fma(_75, gl_BaryCoordEXT.y, fs_in_attr0_p[0u].x)) / float(_98.x);
    vec4 _109 = texture(SPIRV_Cross_Combinedfs_img0fs_sampsgpr_8, vec2(_104, _101));
    frag_color0.x = _109.w;
    frag_color0.y = _109.z;
    frag_color0.z = _109.y;
    frag_color0.w = _109.x;
}

