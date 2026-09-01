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
layout(local_size_x = 32, local_size_y = 32, local_size_z = 1) in;

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

layout(binding = 0, std430) buffer ssbo_1
{
    uint data[];
} ssbo_1_1;

layout(binding = 1, std430) buffer ssbo_2
{
    uint data[];
} ssbo_2_1;

layout(binding = 2, std430) buffer ssbo_3
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

void main()
{
    uint buf0_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(0u), int(8u)) >> 2u;
    uint buf1_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(8u), int(8u)) >> 2u;
    uint buf2_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(16u), int(8u)) >> 2u;
    uint _105 = srt_flatbuf_1.data[16u];
    uint _108 = srt_flatbuf_1.data[17u];
    uint _109 = (gl_WorkGroupID.x << 5u) + gl_LocalInvocationID.x;
    uint _110 = (gl_WorkGroupID.y << 5u) + gl_LocalInvocationID.y;
    bool _113 = (_105 <= _109) || (_108 <= _110);
    bool _114 = !_113;
    if (!_113)
    {
        float _120 = (int(0u) > int(_110)) ? uintBitsToFloat(_108 + _110) : uintBitsToFloat(_110);
        uint _121 = floatBitsToUint(_120);
        float _128 = (int(0u) > int(_109)) ? uintBitsToFloat(_105 + _109) : uintBitsToFloat(_109);
        uint _129 = floatBitsToUint(_128);
        uint _139 = floatBitsToUint((int(_105) <= int(_129)) ? uintBitsToFloat(_129 - _105) : _128) + (_105 * floatBitsToUint((int(_108) <= int(_121)) ? uintBitsToFloat(_121 - _108) : _120));
        uint _145 = srt_flatbuf_1.data[29u];
        uint _150 = srt_flatbuf_1.data[21u];
        precise float _169 = uintBitsToFloat(srt_flatbuf_1.data[18u]) * (-uintBitsToFloat(ssbo_1_1.data[_139 + buf0_dword_off]));
        precise float _170 = _169 + float(_110);
        precise float _174 = uintBitsToFloat(srt_flatbuf_1.data[18u]) * (-uintBitsToFloat(ssbo_2_1.data[_139 + buf1_dword_off]));
        precise float _175 = _174 + float(_109);
        uint _178 = uint(int(floor(_170)));
        float _179 = floor(_170);
        uint _181 = uint(int(floor(_175)));
        float _182 = floor(_175);
        uint _183 = _181 + 1u;
        uint _187 = _178 + 1u;
        float _195 = ((-1.0) >= _179) ? uintBitsToFloat(_108 + _178) : uintBitsToFloat(_178);
        uint _196 = floatBitsToUint(_195);
        float _201 = ((-1.0) >= _182) ? uintBitsToFloat(_105 + _181) : uintBitsToFloat(_181);
        uint _202 = floatBitsToUint(_201);
        float _205 = ((-2.0) >= _182) ? uintBitsToFloat(_105 + _183) : uintBitsToFloat(_183);
        uint _206 = floatBitsToUint(_205);
        float _211 = ((-2.0) >= _179) ? uintBitsToFloat(_108 + _187) : uintBitsToFloat(_187);
        uint _212 = floatBitsToUint(_211);
        uint _224 = floatBitsToUint((int(_105) <= int(_202)) ? uintBitsToFloat(_202 - _105) : _201);
        uint _227 = floatBitsToUint((int(_105) <= int(_206)) ? uintBitsToFloat(_206 - _105) : _205);
        uint _228 = _105 * floatBitsToUint((int(_108) <= int(_196)) ? uintBitsToFloat(_196 - _108) : _195);
        uint _232 = _224 + _228;
        uint _233 = _227 + _228;
        uint _234 = _105 * floatBitsToUint((int(_108) <= int(_212)) ? uintBitsToFloat(_212 - _108) : _211);
        uint _235 = _224 + _234;
        uint _236 = _227 + _234;
        uint _237 = _232 + buf1_dword_off;
        uint _243 = _235 + buf1_dword_off;
        uint _249 = _232 + buf0_dword_off;
        uint _255 = _232 + buf2_dword_off;
        uint _261 = _235 + buf2_dword_off;
        uint _267 = _235 + buf0_dword_off;
        float _273 = fract(_175);
        float _274 = fract(_170);
        uint _275 = _109 + (_105 * _110);
        precise float _278 = uintBitsToFloat(ssbo_2_1.data[_233 + buf1_dword_off]) - uintBitsToFloat(ssbo_2_1.data[_237]);
        precise float _280 = _273 * _278;
        precise float _281 = _280 + uintBitsToFloat(ssbo_2_1.data[_237]);
        precise float _284 = uintBitsToFloat(ssbo_1_1.data[_233 + buf0_dword_off]) - uintBitsToFloat(ssbo_1_1.data[_249]);
        precise float _287 = uintBitsToFloat(ssbo_2_1.data[_236 + buf1_dword_off]) - uintBitsToFloat(ssbo_2_1.data[_243]);
        precise float _289 = uintBitsToFloat(ssbo_2_1.data[_243]) - _281;
        precise float _291 = _273 * _284;
        precise float _292 = _291 + uintBitsToFloat(ssbo_1_1.data[_249]);
        precise float _295 = uintBitsToFloat(ssbo_3_1.data[_233 + buf2_dword_off]) - uintBitsToFloat(ssbo_3_1.data[_255]);
        precise float _296 = _287 * _273;
        precise float _297 = _296 + _289;
        precise float _299 = uintBitsToFloat(ssbo_1_1.data[_267]) - _292;
        precise float _302 = uintBitsToFloat(ssbo_1_1.data[_236 + buf0_dword_off]) - uintBitsToFloat(ssbo_1_1.data[_267]);
        precise float _304 = _295 * _273;
        precise float _305 = _304 + uintBitsToFloat(ssbo_3_1.data[_255]);
        precise float _306 = _297 * _274;
        precise float _307 = _306 + _281;
        precise float _309 = _302 * _273;
        precise float _310 = _309 + _299;
        precise float _312 = uintBitsToFloat(ssbo_3_1.data[_261]) - _305;
        precise float _315 = uintBitsToFloat(ssbo_3_1.data[_236 + buf2_dword_off]) - uintBitsToFloat(ssbo_3_1.data[_261]);
        if (_114 && (srt_flatbuf_1.data[25u] > _275))
        {
            ssbo_2_1.data[_275 + buf1_dword_off] = floatBitsToUint(_307);
        }
        precise float _320 = _310 * _274;
        precise float _321 = _320 + _292;
        precise float _323 = _315 * _273;
        precise float _324 = _323 + _312;
        if (_114 && (_145 > _275))
        {
            ssbo_1_1.data[_275 + buf0_dword_off] = floatBitsToUint(_321);
        }
        precise float _329 = _324 * _274;
        precise float _330 = _329 + _305;
        if (_114 && (_150 > _275))
        {
            ssbo_3_1.data[_275 + buf2_dword_off] = floatBitsToUint(_330);
        }
    }
}

