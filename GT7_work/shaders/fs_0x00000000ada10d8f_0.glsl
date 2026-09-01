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

layout(location = 0) pervertexEXT in vec4 fs_in_attr0_p[3];
layout(location = 0) out vec4 frag_color0;

void main()
{
    precise float _68 = fs_in_attr0_p[1u].x - fs_in_attr0_p[0u].x;
    precise float _75 = fs_in_attr0_p[1u].y - fs_in_attr0_p[0u].y;
    precise float _81 = fs_in_attr0_p[1u].z - fs_in_attr0_p[0u].z;
    precise float _87 = fs_in_attr0_p[1u].w - fs_in_attr0_p[0u].w;
    precise float _93 = fs_in_attr0_p[2u].x - fs_in_attr0_p[0u].x;
    precise float _99 = fs_in_attr0_p[2u].y - fs_in_attr0_p[0u].y;
    precise float _105 = fs_in_attr0_p[2u].z - fs_in_attr0_p[0u].z;
    precise float _111 = fs_in_attr0_p[2u].w - fs_in_attr0_p[0u].w;
    frag_color0.x = fma(_93, gl_BaryCoordEXT.z, fma(_68, gl_BaryCoordEXT.y, fs_in_attr0_p[0u].x));
    frag_color0.y = fma(_99, gl_BaryCoordEXT.z, fma(_75, gl_BaryCoordEXT.y, fs_in_attr0_p[0u].y));
    frag_color0.z = fma(_105, gl_BaryCoordEXT.z, fma(_81, gl_BaryCoordEXT.y, fs_in_attr0_p[0u].z));
    frag_color0.w = fma(_111, gl_BaryCoordEXT.z, fma(_87, gl_BaryCoordEXT.y, fs_in_attr0_p[0u].w));
}

