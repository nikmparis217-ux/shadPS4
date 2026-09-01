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
layout(local_size_x = 512, local_size_y = 1, local_size_z = 1) in;

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

layout(binding = 1, std430) buffer ssbo_2
{
    uint data[];
} ssbo_2_1;

layout(binding = 2, std430) readonly buffer ssbo_3
{
    uint data[];
} ssbo_3_1;

layout(binding = 3, std430) readonly buffer srt_flatbuf
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

shared uint64_t shared_mem_u64[1024];

void main()
{
    uint buf0_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(0u), int(8u)) >> 2u;
    uint buf1_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(8u), int(8u)) >> 2u;
    uint buf2_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(16u), int(8u)) >> 2u;
    uint _111 = gl_LocalInvocationID.x + 512u;
    uint _115 = srt_flatbuf_1.data[28u];
    uint _119 = srt_flatbuf_1.data[29u];
    uint _121 = _115 * 40u;
    uint _124 = (_121 + 32u) >> 2u;
    uint _127 = ssbo_1_1.data[_124 + buf0_dword_off];
    uint _129 = (_124 + 1u) + buf0_dword_off;
    uint _131 = ssbo_1_1.data[_129];
    uint _132 = _121 >> 2u;
    uint _133 = _132 + buf0_dword_off;
    uint _135 = ssbo_1_1.data[_133];
    uint _137 = (_132 + 1u) + buf0_dword_off;
    uint _139 = ssbo_1_1.data[_137];
    uint _141 = (_132 + 2u) + buf0_dword_off;
    uint _143 = ssbo_1_1.data[_141];
    uint _148 = ssbo_1_1.data[(_132 + 3u) + buf0_dword_off];
    uint _150 = (_132 + 4u) + buf0_dword_off;
    uint _154 = (_132 + 5u) + buf0_dword_off;
    uint _156 = ssbo_1_1.data[_154];
    uint _159 = (_132 + 6u) + buf0_dword_off;
    uint _161 = ssbo_1_1.data[_159];
    uint _164 = (_132 + 7u) + buf0_dword_off;
    uint _166 = ssbo_1_1.data[_164];
    uint _170 = (_127 + gl_WorkGroupID.x) << (_135 & 31u);
    uint _182 = ((1u << bitfieldExtract(_135, int(0u), int(4u))) - 1u) << 0u;
    uint _187 = 0u - (1u << (_135 & 31u));
    uint _193 = ((_170 & (0u - (1u << (_139 & 31u)))) << (_148 & 31u)) | (_170 & (((1u << bitfieldExtract(_139, int(0u), int(4u))) - 1u) << 0u));
    uint _195 = _193 + (((_187 & gl_LocalInvocationID.x) << (_143 & 31u)) | (_182 & gl_LocalInvocationID.x));
    uint _207 = floatBitsToUint((0u != (_166 & _195)) ? uintBitsToFloat(_161 ^ _195) : uintBitsToFloat(_195));
    uint _208 = _193 + (((_187 & _111) << (_143 & 31u)) | (_182 & _111));
    uint _216 = floatBitsToUint((0u != (_166 & _208)) ? uintBitsToFloat(_161 ^ _208) : uintBitsToFloat(_208));
    uint _228;
    uint _229;
    if (_119 > _207)
    {
        uint _219 = ((_207 - _131) * 2u) + buf1_dword_off;
        uvec2 _225 = uvec2(ssbo_2_1.data[_219], ssbo_2_1.data[_219 + 1u]);
        _228 = _225.y;
        _229 = _225.x;
    }
    else
    {
        _228 = 0u;
        _229 = 2139095040u;
    }
    uint _242;
    uint _243;
    if (_119 > _216)
    {
        uint _233 = ((_216 - _131) * 2u) + buf1_dword_off;
        uvec2 _239 = uvec2(ssbo_2_1.data[_233], ssbo_2_1.data[_233 + 1u]);
        _242 = _239.x;
        _243 = _239.y;
    }
    else
    {
        _242 = 2139095040u;
        _243 = 0u;
    }
    uint _244 = gl_LocalInvocationID.x << 3u;
    shared_mem_u64[_244 >> 3u] = packUint2x32(uvec2(_229, _228));
    shared_mem_u64[(_244 + 4096u) >> 3u] = packUint2x32(uvec2(_242, _243));
    uint _264;
    uint _268;
    uint _279;
    uint _284;
    uint _285;
    uint _323;
    uint _303;
    uint _304;
    uint _320;
    uint _321;
    uint _322;
    uint _324;
    uint _325;
    uint _326;
    uint _327;
    uint _328;
    uint _255 = _243;
    uint _256 = _242;
    uint _257 = _228;
    uint _258 = _229;
    uint _259 = ssbo_1_1.data[_150];
    for (;;)
    {
        uint _261 = (_259 << 3u) >> 2u;
        _264 = ssbo_3_1.data[_261 + buf2_dword_off];
        _268 = ssbo_3_1.data[(_261 + 1u) + buf2_dword_off];
        barrier();
        uint _270 = _264 ^ gl_LocalInvocationID.x;
        uint _271 = _264 ^ _111;
        uint64_t _276 = shared_mem_u64[(_270 << 3u) >> 3u];
        uvec2 _277 = unpackUint2x32(_276);
        uint _278 = _277.x;
        _279 = _277.y;
        uvec2 _283 = unpackUint2x32(shared_mem_u64[(_271 << 3u) >> 3u]);
        _284 = _283.x;
        _285 = _283.y;
        if (!(_259 != _156))
        {
            _324 = _255;
            _325 = _256;
            _326 = _278;
            _327 = _257;
            _328 = _258;
            break;
        }
        else
        {
            if (((_268 < (_264 & gl_LocalInvocationID.x)) != (uintBitsToFloat(_258) > uintBitsToFloat(_278))) && (uintBitsToFloat(_258) != uintBitsToFloat(_278)))
            {
                shared_mem_u64[(_270 << 3u) >> 3u] = packUint2x32(uvec2(_258, _257));
                _303 = _279;
                _304 = _278;
            }
            else
            {
                _303 = _257;
                _304 = _258;
            }
            uint _305 = _264 & _111;
            if (((_268 < _305) != (uintBitsToFloat(_256) > uintBitsToFloat(_284))) && (uintBitsToFloat(_256) != uintBitsToFloat(_284)))
            {
                uint _315 = _271 << 3u;
                shared_mem_u64[_315 >> 3u] = packUint2x32(uvec2(_256, _255));
                _320 = _315;
                _321 = _285;
                _322 = _284;
            }
            else
            {
                _320 = _305;
                _321 = _255;
                _322 = _256;
            }
            _323 = _259 + 1u;
            if (true)
            {
                _255 = _321;
                _256 = _322;
                _257 = _303;
                _258 = _304;
                _259 = _323;
                continue;
            }
            else
            {
                _324 = _321;
                _325 = _322;
                _326 = _320;
                _327 = _303;
                _328 = _304;
                break;
            }
        }
    }
    if (_119 > _207)
    {
        bool _340 = ((_268 < (_264 & gl_LocalInvocationID.x)) != (uintBitsToFloat(_328) > uintBitsToFloat(_326))) && (uintBitsToFloat(_328) != uintBitsToFloat(_326));
        uvec2 _349 = uvec2(floatBitsToUint(_340 ? uintBitsToFloat(_326) : uintBitsToFloat(_328)), floatBitsToUint(_340 ? uintBitsToFloat(_279) : uintBitsToFloat(_327)));
        uint _351 = ((_207 - _131) * 2u) + buf1_dword_off;
        ssbo_2_1.data[_351] = _349.x;
        ssbo_2_1.data[_351 + 1u] = _349.y;
    }
    if (_119 > _216)
    {
        bool _368 = ((_268 < (_264 & _111)) != (uintBitsToFloat(_325) > uintBitsToFloat(_284))) && (uintBitsToFloat(_325) != uintBitsToFloat(_284));
        uvec2 _377 = uvec2(floatBitsToUint(_368 ? uintBitsToFloat(_284) : uintBitsToFloat(_325)), floatBitsToUint(_368 ? uintBitsToFloat(_285) : uintBitsToFloat(_324)));
        uint _379 = ((_216 - _131) * 2u) + buf1_dword_off;
        ssbo_2_1.data[_379] = _377.x;
        ssbo_2_1.data[_379 + 1u] = _377.y;
    }
}

