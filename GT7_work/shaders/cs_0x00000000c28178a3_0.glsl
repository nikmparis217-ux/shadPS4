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
layout(local_size_x = 8, local_size_y = 8, local_size_z = 4) in;

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
layout(binding = 3) uniform writeonly image2D cs_img32;
layout(binding = 4) uniform writeonly image2D cs_img40;
layout(binding = 5) uniform writeonly image2D cs_img48;
layout(binding = 6) uniform writeonly image2D cs_img56;
uniform sampler2D SPIRV_Cross_Combinedcs_img64SPIRV_Cross_DummySampler;
uniform sampler2D SPIRV_Cross_Combinedcs_img64cs_sampinline_0xfff00000008036_0x2500000;

shared uint64_t shared_mem_u64[512];

void main()
{
    uint _92 = (bitfieldExtract(1u & gl_LocalInvocationID.z, int(0u), int(24u)) * 8u) + gl_LocalInvocationID.x;
    uint _96 = (bitfieldExtract(gl_LocalInvocationID.z >> 1u, int(0u), int(24u)) * 8u) + gl_LocalInvocationID.y;
    float _101 = float((bitfieldExtract(_96, int(0u), int(24u)) * 4u) + 1u);
    float _109 = float((bitfieldExtract(_92, int(0u), int(24u)) * 4u) + 1u);
    float _110 = float((bitfieldExtract(_92, int(0u), int(24u)) * 4u) + 3u);
    uvec4 _116 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedcs_img64SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
    precise float _119 = _101 / float(_116.y);
    precise float _122 = _109 / float(_116.x);
    vec4 _127 = textureLod(SPIRV_Cross_Combinedcs_img64cs_sampinline_0xfff00000008036_0x2500000, vec2(_122, _119), 0.0);
    float _128 = _127.x;
    uvec4 _134 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedcs_img64SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
    precise float _137 = _101 / float(_134.y);
    precise float _140 = _110 / float(_134.x);
    vec4 _145 = textureLod(SPIRV_Cross_Combinedcs_img64cs_sampinline_0xfff00000008036_0x2500000, vec2(_140, _137), 0.0);
    float _146 = _145.x;
    float _150 = float((bitfieldExtract(_96, int(0u), int(24u)) * 4u) + 3u);
    uvec4 _153 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedcs_img64SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
    precise float _156 = _150 / float(_153.y);
    precise float _159 = _109 / float(_153.x);
    vec4 _164 = textureLod(SPIRV_Cross_Combinedcs_img64cs_sampinline_0xfff00000008036_0x2500000, vec2(_159, _156), 0.0);
    float _165 = _164.x;
    uvec4 _171 = uvec4(uvec2(textureSize(SPIRV_Cross_Combinedcs_img64SPIRV_Cross_DummySampler, int(0u))), 0u, 0u);
    precise float _174 = _150 / float(_171.y);
    precise float _177 = _110 / float(_171.x);
    vec4 _182 = textureLod(SPIRV_Cross_Combinedcs_img64cs_sampinline_0xfff00000008036_0x2500000, vec2(_177, _174), 0.0);
    float _183 = _182.x;
    uint _187 = _96 << 1u;
    uint _188 = _92 << 1u;
    uint _192 = (bitfieldExtract(_92, int(0u), int(24u)) * 2u) + 1u;
    uint _196 = (bitfieldExtract(_96, int(0u), int(24u)) * 16u) + _92;
    uint _197 = _196 << 4u;
    precise float _198 = _127.w + _145.w;
    vec4 _199 = vec4(_128, _127.yzw);
    imageStore(cs_img16, ivec2(uvec2(_188, _187)), vec4(_199.x, _199.y, _199.z, vec4(0.0, 1.0, 0.0, 0.0).x));
    precise float _205 = _128 + _146;
    precise float _206 = _127.z + _145.z;
    precise float _207 = _127.y + _145.y;
    precise float _208 = _205 + _165;
    precise float _209 = _206 + _164.z;
    precise float _210 = _198 + _164.w;
    precise float _211 = _207 + _164.y;
    uint _214 = (bitfieldExtract(_96, int(0u), int(24u)) * 2u) + 1u;
    precise float _215 = _208 + _183;
    precise float _216 = _210 + _182.w;
    precise float _217 = _209 + _182.z;
    precise float _218 = _211 + _182.y;
    precise float _220 = 0.25 * _215;
    precise float _222 = 0.25 * _218;
    precise float _224 = 0.25 * _216;
    precise float _226 = 0.25 * _217;
    vec4 _228 = vec4(_146, _145.yzw);
    imageStore(cs_img16, ivec2(uvec2(_192, _187)), vec4(_228.x, _228.y, _228.z, vec4(0.0, 1.0, 0.0, 0.0).x));
    vec4 _232 = vec4(_165, _164.yzw);
    imageStore(cs_img16, ivec2(uvec2(_188, _214)), vec4(_232.x, _232.y, _232.z, vec4(0.0, 1.0, 0.0, 0.0).x));
    vec4 _236 = vec4(_183, _182.yzw);
    imageStore(cs_img16, ivec2(uvec2(_192, _214)), vec4(_236.x, _236.y, _236.z, vec4(0.0, 1.0, 0.0, 0.0).x));
    vec4 _240 = vec4(_220, _222, _226, _224);
    imageStore(cs_img24, ivec2(uvec2(_92, _96)), vec4(_240.x, _240.y, _240.z, vec4(0.0, 1.0, 0.0, 0.0).x));
    shared_mem_u64[_197 >> 3u] = packUint2x32(uvec2(floatBitsToUint(_220), floatBitsToUint(_222)));
    shared_mem_u64[(_197 + 8u) >> 3u] = packUint2x32(uvec2(floatBitsToUint(_226), floatBitsToUint(_224)));
    barrier();
    bool _254 = 0u == gl_LocalInvocationID.z;
    if (_254)
    {
        uint _256 = _196 << 5u;
        uvec2 _260 = unpackUint2x32(shared_mem_u64[_256 >> 3u]);
        uvec2 _267 = unpackUint2x32(shared_mem_u64[(_256 + 8u) >> 3u]);
        uvec2 _274 = unpackUint2x32(shared_mem_u64[(_256 + 16u) >> 3u]);
        uvec2 _281 = unpackUint2x32(shared_mem_u64[(_256 + 24u) >> 3u]);
        uvec2 _289 = unpackUint2x32(shared_mem_u64[(_256 + 256u) >> 3u]);
        uvec2 _296 = unpackUint2x32(shared_mem_u64[(_256 + 264u) >> 3u]);
        precise float _301 = uintBitsToFloat(_260.x) + uintBitsToFloat(_274.x);
        uvec2 _307 = unpackUint2x32(shared_mem_u64[(_256 + 272u) >> 3u]);
        uvec2 _315 = unpackUint2x32(shared_mem_u64[(_256 + 280u) >> 3u]);
        precise float _320 = uintBitsToFloat(_267.y) + uintBitsToFloat(_281.y);
        precise float _323 = uintBitsToFloat(_267.x) + uintBitsToFloat(_281.x);
        precise float _326 = uintBitsToFloat(_260.y) + uintBitsToFloat(_274.y);
        precise float _328 = _301 + uintBitsToFloat(_289.x);
        precise float _330 = _320 + uintBitsToFloat(_296.y);
        precise float _332 = _323 + uintBitsToFloat(_296.x);
        precise float _334 = _326 + uintBitsToFloat(_289.y);
        precise float _336 = _328 + uintBitsToFloat(_307.x);
        precise float _338 = _330 + uintBitsToFloat(_315.y);
        precise float _340 = _332 + uintBitsToFloat(_315.x);
        precise float _342 = _334 + uintBitsToFloat(_307.y);
        precise float _343 = 0.25 * _336;
        precise float _345 = 0.25 * _338;
        precise float _347 = 0.25 * _340;
        precise float _349 = 0.25 * _342;
        vec4 _351 = vec4(_343, _349, _347, _345);
        imageStore(cs_img32, ivec2(uvec2(_92, _96)), vec4(_351.x, _351.y, _351.z, vec4(0.0, 1.0, 0.0, 0.0).x));
        shared_mem_u64[_256 >> 3u] = packUint2x32(uvec2(floatBitsToUint(_343), floatBitsToUint(_349)));
        shared_mem_u64[(_256 + 8u) >> 3u] = packUint2x32(uvec2(floatBitsToUint(_347), floatBitsToUint(_345)));
        barrier();
        uint _365 = max(_92, _96);
        if (_254 && (4u > _365))
        {
            uint _369 = _196 << 6u;
            uvec2 _373 = unpackUint2x32(shared_mem_u64[_369 >> 3u]);
            uvec2 _380 = unpackUint2x32(shared_mem_u64[(_369 + 8u) >> 3u]);
            uvec2 _388 = unpackUint2x32(shared_mem_u64[(_369 + 32u) >> 3u]);
            uvec2 _396 = unpackUint2x32(shared_mem_u64[(_369 + 40u) >> 3u]);
            uvec2 _403 = unpackUint2x32(shared_mem_u64[(_369 + 512u) >> 3u]);
            uvec2 _411 = unpackUint2x32(shared_mem_u64[(_369 + 520u) >> 3u]);
            precise float _416 = uintBitsToFloat(_373.x) + uintBitsToFloat(_388.x);
            uvec2 _422 = unpackUint2x32(shared_mem_u64[(_369 + 544u) >> 3u]);
            uvec2 _430 = unpackUint2x32(shared_mem_u64[(_369 + 552u) >> 3u]);
            precise float _435 = uintBitsToFloat(_380.y) + uintBitsToFloat(_396.y);
            precise float _438 = uintBitsToFloat(_380.x) + uintBitsToFloat(_396.x);
            precise float _441 = uintBitsToFloat(_373.y) + uintBitsToFloat(_388.y);
            precise float _443 = _416 + uintBitsToFloat(_403.x);
            precise float _445 = _435 + uintBitsToFloat(_411.y);
            precise float _447 = _438 + uintBitsToFloat(_411.x);
            precise float _449 = _441 + uintBitsToFloat(_403.y);
            precise float _451 = _443 + uintBitsToFloat(_422.x);
            precise float _453 = _445 + uintBitsToFloat(_430.y);
            precise float _455 = _447 + uintBitsToFloat(_430.x);
            precise float _457 = _449 + uintBitsToFloat(_422.y);
            precise float _458 = 0.25 * _451;
            precise float _460 = 0.25 * _453;
            precise float _462 = 0.25 * _455;
            precise float _464 = 0.25 * _457;
            vec4 _466 = vec4(_458, _464, _462, _460);
            imageStore(cs_img40, ivec2(uvec2(_92, _96)), vec4(_466.x, _466.y, _466.z, vec4(0.0, 1.0, 0.0, 0.0).x));
            shared_mem_u64[_369 >> 3u] = packUint2x32(uvec2(floatBitsToUint(_458), floatBitsToUint(_464)));
            shared_mem_u64[(_369 + 8u) >> 3u] = packUint2x32(uvec2(floatBitsToUint(_462), floatBitsToUint(_460)));
        }
        barrier();
        if (_254 && (2u > _365))
        {
            uint _482 = _196 << 7u;
            uvec2 _486 = unpackUint2x32(shared_mem_u64[_482 >> 3u]);
            uvec2 _493 = unpackUint2x32(shared_mem_u64[(_482 + 8u) >> 3u]);
            uvec2 _501 = unpackUint2x32(shared_mem_u64[(_482 + 64u) >> 3u]);
            uvec2 _509 = unpackUint2x32(shared_mem_u64[(_482 + 72u) >> 3u]);
            uvec2 _517 = unpackUint2x32(shared_mem_u64[(_482 + 1024u) >> 3u]);
            uvec2 _525 = unpackUint2x32(shared_mem_u64[(_482 + 1032u) >> 3u]);
            precise float _530 = uintBitsToFloat(_486.x) + uintBitsToFloat(_501.x);
            uvec2 _536 = unpackUint2x32(shared_mem_u64[(_482 + 1088u) >> 3u]);
            uvec2 _544 = unpackUint2x32(shared_mem_u64[(_482 + 1096u) >> 3u]);
            precise float _549 = uintBitsToFloat(_493.y) + uintBitsToFloat(_509.y);
            precise float _552 = uintBitsToFloat(_493.x) + uintBitsToFloat(_509.x);
            precise float _555 = uintBitsToFloat(_486.y) + uintBitsToFloat(_501.y);
            precise float _557 = _530 + uintBitsToFloat(_517.x);
            precise float _559 = _549 + uintBitsToFloat(_525.y);
            precise float _561 = _552 + uintBitsToFloat(_525.x);
            precise float _563 = _555 + uintBitsToFloat(_517.y);
            precise float _565 = _557 + uintBitsToFloat(_536.x);
            precise float _567 = _559 + uintBitsToFloat(_544.y);
            precise float _569 = _561 + uintBitsToFloat(_544.x);
            precise float _571 = _563 + uintBitsToFloat(_536.y);
            precise float _572 = 0.25 * _565;
            precise float _574 = 0.25 * _567;
            precise float _576 = 0.25 * _569;
            precise float _578 = 0.25 * _571;
            vec4 _580 = vec4(_572, _578, _576, _574);
            imageStore(cs_img48, ivec2(uvec2(_92, _96)), vec4(_580.x, _580.y, _580.z, vec4(0.0, 1.0, 0.0, 0.0).x));
            shared_mem_u64[_482 >> 3u] = packUint2x32(uvec2(floatBitsToUint(_572), floatBitsToUint(_578)));
            shared_mem_u64[(_482 + 8u) >> 3u] = packUint2x32(uvec2(floatBitsToUint(_576), floatBitsToUint(_574)));
        }
        barrier();
        if (_254 && (1u > _365))
        {
            uint _595 = _196 << 8u;
            uvec2 _599 = unpackUint2x32(shared_mem_u64[_595 >> 3u]);
            uvec2 _606 = unpackUint2x32(shared_mem_u64[(_595 + 8u) >> 3u]);
            uvec2 _614 = unpackUint2x32(shared_mem_u64[(_595 + 128u) >> 3u]);
            uvec2 _622 = unpackUint2x32(shared_mem_u64[(_595 + 136u) >> 3u]);
            uint _626 = bitfieldExtract(_196, int(0u), int(24u)) * 256u;
            uvec2 _632 = unpackUint2x32(shared_mem_u64[(_626 + 2048u) >> 3u]);
            uvec2 _640 = unpackUint2x32(shared_mem_u64[(_626 + 2056u) >> 3u]);
            uint _644 = bitfieldExtract(_196, int(0u), int(24u)) * 256u;
            precise float _647 = uintBitsToFloat(_599.x) + uintBitsToFloat(_614.x);
            uvec2 _653 = unpackUint2x32(shared_mem_u64[(_644 + 2176u) >> 3u]);
            uvec2 _661 = unpackUint2x32(shared_mem_u64[(_644 + 2184u) >> 3u]);
            precise float _666 = uintBitsToFloat(_606.y) + uintBitsToFloat(_622.y);
            precise float _669 = uintBitsToFloat(_606.x) + uintBitsToFloat(_622.x);
            precise float _672 = uintBitsToFloat(_599.y) + uintBitsToFloat(_614.y);
            precise float _674 = _647 + uintBitsToFloat(_632.x);
            precise float _676 = _666 + uintBitsToFloat(_640.y);
            precise float _678 = _669 + uintBitsToFloat(_640.x);
            precise float _680 = _672 + uintBitsToFloat(_632.y);
            precise float _682 = _674 + uintBitsToFloat(_653.x);
            precise float _684 = _676 + uintBitsToFloat(_661.y);
            precise float _686 = _678 + uintBitsToFloat(_661.x);
            precise float _688 = _680 + uintBitsToFloat(_653.y);
            precise float _689 = 0.25 * _682;
            precise float _690 = 0.25 * _684;
            precise float _691 = 0.25 * _686;
            precise float _692 = 0.25 * _688;
            vec4 _693 = vec4(_689, _692, _691, _690);
            imageStore(cs_img56, ivec2(uvec2(0u)), vec4(_693.x, _693.y, _693.z, vec4(0.0, 1.0, 0.0, 0.0).x));
        }
    }
}

