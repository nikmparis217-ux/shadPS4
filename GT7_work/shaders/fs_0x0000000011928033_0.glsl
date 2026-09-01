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

uniform sampler2D SPIRV_Cross_Combinedfs_img16fs_sampsgpr_24;

layout(location = 0) pervertexEXT in vec4 fs_in_attr0_p[3];

void main()
{
    precise float _79 = fs_in_attr0_p[1u].x - fs_in_attr0_p[0u].x;
    precise float _88 = fs_in_attr0_p[2u].x - fs_in_attr0_p[0u].x;
    precise float _95 = fs_in_attr0_p[1u].y - fs_in_attr0_p[0u].y;
    precise float _105 = fs_in_attr0_p[2u].y - fs_in_attr0_p[0u].y;
    precise float _118 = fs_in_attr0_p[1u].z - fs_in_attr0_p[0u].z;
    precise float _124 = fs_in_attr0_p[2u].z - fs_in_attr0_p[0u].z;
    precise float _125 = fma(_124, gl_BaryCoordEXT.z, fma(_118, gl_BaryCoordEXT.y, fs_in_attr0_p[0u].z));
    precise float _126 = gl_FragCoord.z + _125;
    precise float _128 = (-texture(SPIRV_Cross_Combinedfs_img16fs_sampsgpr_24, vec2(uintBitsToFloat((1u & bitfieldExtract(uint(gl_SampleID), int(0u), int(1u))) | (4294967294u & floatBitsToUint(fma(_88, gl_BaryCoordEXT.z, fma(_79, gl_BaryCoordEXT.y, fs_in_attr0_p[0u].x))))), fma(_105, gl_BaryCoordEXT.z, fma(_95, gl_BaryCoordEXT.y, fs_in_attr0_p[0u].y)))).w) * _125;
    precise float _129 = _128 + _126;
    gl_FragDepth = _129;
}

