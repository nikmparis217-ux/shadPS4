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

layout(binding = 0, std430) readonly buffer ssbo_1
{
    uint data[];
} ssbo_1_1;

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
    uint buf0_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(0u), int(8u)) >> 2u;
    uint _83 = 0u + buf0_dword_off;
    uint _86 = 1u + buf0_dword_off;
    uint _89 = 2u + buf0_dword_off;
    uint _92 = 3u + buf0_dword_off;
    uint _96 = 4u + buf0_dword_off;
    uint _100 = 5u + buf0_dword_off;
    uint _104 = 6u + buf0_dword_off;
    uint _108 = 7u + buf0_dword_off;
    precise float _178 = fs_in_attr0_p[1u].x - fs_in_attr0_p[0u].x;
    precise float _185 = fs_in_attr0_p[1u].y - fs_in_attr0_p[0u].y;
    precise float _191 = fs_in_attr0_p[2u].x - fs_in_attr0_p[0u].x;
    precise float _192 = fma(_191, gl_BaryCoordEXT.z, fma(_178, gl_BaryCoordEXT.y, fs_in_attr0_p[0u].x));
    precise float _197 = fs_in_attr0_p[2u].y - fs_in_attr0_p[0u].y;
    precise float _198 = fma(_197, gl_BaryCoordEXT.z, fma(_185, gl_BaryCoordEXT.y, fs_in_attr0_p[0u].y));
    precise float _200 = uintBitsToFloat(ssbo_1_1.data[8u + buf0_dword_off]) + _192;
    precise float _202 = uintBitsToFloat(ssbo_1_1.data[9u + buf0_dword_off]) + _198;
    uvec4 _205 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedfs_img0SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
    precise float _208 = _202 / float(_205.y);
    precise float _211 = _200 / float(_205.x);
    vec4 _216 = texture(SPIRV_Cross_Combinedfs_img0fs_sampsgpr_8, vec2(_211, _208));
    precise float _222 = uintBitsToFloat(ssbo_1_1.data[11u + buf0_dword_off]) + _198;
    precise float _224 = uintBitsToFloat(ssbo_1_1.data[10u + buf0_dword_off]) + _192;
    uvec4 _227 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedfs_img0SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
    precise float _230 = _222 / float(_227.y);
    precise float _233 = _224 / float(_227.x);
    vec4 _238 = texture(SPIRV_Cross_Combinedfs_img0fs_sampsgpr_8, vec2(_233, _230));
    precise float _244 = uintBitsToFloat(ssbo_1_1.data[12u + buf0_dword_off]) + _192;
    precise float _246 = uintBitsToFloat(ssbo_1_1.data[13u + buf0_dword_off]) + _198;
    precise float _248 = uintBitsToFloat(ssbo_1_1.data[16u + buf0_dword_off]) + _192;
    precise float _250 = uintBitsToFloat(ssbo_1_1.data[17u + buf0_dword_off]) + _198;
    precise float _252 = uintBitsToFloat(ssbo_1_1.data[19u + buf0_dword_off]) + _198;
    precise float _254 = uintBitsToFloat(ssbo_1_1.data[18u + buf0_dword_off]) + _192;
    precise float _256 = uintBitsToFloat(ssbo_1_1.data[20u + buf0_dword_off]) + _192;
    precise float _258 = uintBitsToFloat(ssbo_1_1.data[21u + buf0_dword_off]) + _198;
    precise float _260 = uintBitsToFloat(ssbo_1_1.data[_83]) * _216.x;
    precise float _262 = uintBitsToFloat(ssbo_1_1.data[_83]) * _216.y;
    precise float _264 = uintBitsToFloat(ssbo_1_1.data[_83]) * _216.w;
    precise float _266 = uintBitsToFloat(ssbo_1_1.data[_83]) * _216.z;
    precise float _268 = uintBitsToFloat(ssbo_1_1.data[_86]) * _238.x;
    precise float _269 = _268 + _260;
    precise float _271 = uintBitsToFloat(ssbo_1_1.data[_86]) * _238.y;
    precise float _272 = _271 + _262;
    precise float _274 = uintBitsToFloat(ssbo_1_1.data[_86]) * _238.z;
    precise float _275 = _274 + _266;
    precise float _277 = uintBitsToFloat(ssbo_1_1.data[_86]) * _238.w;
    precise float _278 = _277 + _264;
    uvec4 _281 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedfs_img0SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
    precise float _284 = _246 / float(_281.y);
    precise float _287 = _244 / float(_281.x);
    vec4 _292 = texture(SPIRV_Cross_Combinedfs_img0fs_sampsgpr_8, vec2(_287, _284));
    uvec4 _299 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedfs_img0SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
    precise float _302 = _252 / float(_299.y);
    precise float _305 = _254 / float(_299.x);
    vec4 _310 = texture(SPIRV_Cross_Combinedfs_img0fs_sampsgpr_8, vec2(_305, _302));
    precise float _316 = uintBitsToFloat(ssbo_1_1.data[15u + buf0_dword_off]) + _198;
    precise float _318 = uintBitsToFloat(ssbo_1_1.data[14u + buf0_dword_off]) + _192;
    precise float _320 = uintBitsToFloat(ssbo_1_1.data[23u + buf0_dword_off]) + _198;
    precise float _322 = uintBitsToFloat(ssbo_1_1.data[22u + buf0_dword_off]) + _192;
    precise float _324 = uintBitsToFloat(ssbo_1_1.data[_89]) * _292.x;
    precise float _325 = _324 + _269;
    precise float _327 = uintBitsToFloat(ssbo_1_1.data[_89]) * _292.y;
    precise float _328 = _327 + _272;
    precise float _330 = uintBitsToFloat(ssbo_1_1.data[_89]) * _292.z;
    precise float _331 = _330 + _275;
    precise float _333 = uintBitsToFloat(ssbo_1_1.data[_89]) * _292.w;
    precise float _334 = _333 + _278;
    uvec4 _337 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedfs_img0SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
    precise float _340 = _316 / float(_337.y);
    precise float _343 = _318 / float(_337.x);
    vec4 _348 = texture(SPIRV_Cross_Combinedfs_img0fs_sampsgpr_8, vec2(_343, _340));
    uvec4 _355 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedfs_img0SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
    precise float _358 = _250 / float(_355.y);
    precise float _361 = _248 / float(_355.x);
    vec4 _366 = texture(SPIRV_Cross_Combinedfs_img0fs_sampsgpr_8, vec2(_361, _358));
    uvec4 _373 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedfs_img0SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
    precise float _376 = _258 / float(_373.y);
    precise float _379 = _256 / float(_373.x);
    vec4 _384 = texture(SPIRV_Cross_Combinedfs_img0fs_sampsgpr_8, vec2(_379, _376));
    precise float _390 = uintBitsToFloat(ssbo_1_1.data[_92]) * _348.x;
    precise float _391 = _390 + _325;
    precise float _393 = uintBitsToFloat(ssbo_1_1.data[_92]) * _348.y;
    precise float _394 = _393 + _328;
    precise float _396 = uintBitsToFloat(ssbo_1_1.data[_92]) * _348.w;
    precise float _397 = _396 + _334;
    precise float _399 = uintBitsToFloat(ssbo_1_1.data[_92]) * _348.z;
    precise float _400 = _399 + _331;
    uvec4 _403 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedfs_img0SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
    precise float _406 = _320 / float(_403.y);
    precise float _409 = _322 / float(_403.x);
    vec4 _414 = texture(SPIRV_Cross_Combinedfs_img0fs_sampsgpr_8, vec2(_409, _406));
    precise float _420 = uintBitsToFloat(ssbo_1_1.data[_96]) * _366.x;
    precise float _421 = _420 + _391;
    precise float _423 = uintBitsToFloat(ssbo_1_1.data[_96]) * _366.y;
    precise float _424 = _423 + _394;
    precise float _426 = uintBitsToFloat(ssbo_1_1.data[_96]) * _366.w;
    precise float _427 = _426 + _397;
    precise float _429 = uintBitsToFloat(ssbo_1_1.data[_96]) * _366.z;
    precise float _430 = _429 + _400;
    precise float _432 = uintBitsToFloat(ssbo_1_1.data[_100]) * _310.x;
    precise float _433 = _432 + _421;
    precise float _435 = uintBitsToFloat(ssbo_1_1.data[_100]) * _310.y;
    precise float _436 = _435 + _424;
    precise float _438 = uintBitsToFloat(ssbo_1_1.data[_100]) * _310.w;
    precise float _439 = _438 + _427;
    precise float _441 = uintBitsToFloat(ssbo_1_1.data[_100]) * _310.z;
    precise float _442 = _441 + _430;
    precise float _444 = uintBitsToFloat(ssbo_1_1.data[_104]) * _384.x;
    precise float _445 = _444 + _433;
    precise float _447 = uintBitsToFloat(ssbo_1_1.data[_104]) * _384.y;
    precise float _448 = _447 + _436;
    precise float _450 = uintBitsToFloat(ssbo_1_1.data[_104]) * _384.w;
    precise float _451 = _450 + _439;
    precise float _453 = uintBitsToFloat(ssbo_1_1.data[_104]) * _384.z;
    precise float _454 = _453 + _442;
    precise float _456 = uintBitsToFloat(ssbo_1_1.data[_108]) * _414.x;
    precise float _457 = _456 + _445;
    precise float _459 = uintBitsToFloat(ssbo_1_1.data[_108]) * _414.y;
    precise float _460 = _459 + _448;
    precise float _462 = uintBitsToFloat(ssbo_1_1.data[_108]) * _414.w;
    precise float _463 = _462 + _451;
    precise float _465 = uintBitsToFloat(ssbo_1_1.data[_108]) * _414.z;
    precise float _466 = _465 + _454;
    frag_color0.x = _457;
    frag_color0.y = _460;
    frag_color0.z = _466;
    frag_color0.w = _463;
}

