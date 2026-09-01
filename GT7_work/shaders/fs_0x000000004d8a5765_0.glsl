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

uniform sampler2D SPIRV_Cross_Combinedfs_img0fs_sampsgpr_8;

layout(location = 0) pervertexEXT in vec4 fs_in_attr0_p[3];
layout(location = 1) pervertexEXT in vec4 fs_in_attr1_p[3];
layout(location = 0) out vec4 frag_color0;

void main()
{
    precise float _76 = fs_in_attr1_p[1u].x - fs_in_attr1_p[0u].x;
    precise float _83 = fs_in_attr1_p[1u].y - fs_in_attr1_p[0u].y;
    precise float _89 = fs_in_attr1_p[2u].x - fs_in_attr1_p[0u].x;
    precise float _95 = fs_in_attr1_p[2u].y - fs_in_attr1_p[0u].y;
    vec4 _101 = texture(SPIRV_Cross_Combinedfs_img0fs_sampsgpr_8, vec2(fma(_89, gl_BaryCoordEXT.z, fma(_76, gl_BaryCoordEXT.y, fs_in_attr1_p[0u].x)), fma(_95, gl_BaryCoordEXT.z, fma(_83, gl_BaryCoordEXT.y, fs_in_attr1_p[0u].y))));
    precise float _110 = fs_in_attr0_p[1u].x - fs_in_attr0_p[0u].x;
    precise float _116 = fs_in_attr0_p[1u].y - fs_in_attr0_p[0u].y;
    precise float _122 = fs_in_attr0_p[1u].w - fs_in_attr0_p[0u].w;
    precise float _128 = fs_in_attr0_p[1u].z - fs_in_attr0_p[0u].z;
    precise float _134 = fs_in_attr0_p[2u].x - fs_in_attr0_p[0u].x;
    precise float _140 = fs_in_attr0_p[2u].y - fs_in_attr0_p[0u].y;
    precise float _146 = fs_in_attr0_p[2u].w - fs_in_attr0_p[0u].w;
    precise float _152 = fs_in_attr0_p[2u].z - fs_in_attr0_p[0u].z;
    precise float _154 = _101.x * fma(_134, gl_BaryCoordEXT.z, fma(_110, gl_BaryCoordEXT.y, fs_in_attr0_p[0u].x));
    precise float _155 = fma(_140, gl_BaryCoordEXT.z, fma(_116, gl_BaryCoordEXT.y, fs_in_attr0_p[0u].y)) * _101.y;
    precise float _156 = fma(_146, gl_BaryCoordEXT.z, fma(_122, gl_BaryCoordEXT.y, fs_in_attr0_p[0u].w)) * _101.w;
    precise float _157 = fma(_152, gl_BaryCoordEXT.z, fma(_128, gl_BaryCoordEXT.y, fs_in_attr0_p[0u].z)) * _101.z;
    frag_color0.x = _154;
    frag_color0.y = _155;
    frag_color0.z = _157;
    frag_color0.w = _156;
}

