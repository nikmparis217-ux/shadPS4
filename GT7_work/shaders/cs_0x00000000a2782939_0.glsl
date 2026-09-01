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

layout(binding = 1, std430) readonly buffer ssbo_2
{
    uint data[];
} ssbo_2_1;

layout(binding = 2, std430) readonly buffer ssbo_3
{
    uint data[];
} ssbo_3_1;

layout(binding = 3, std430) buffer ssbo_4
{
    uint data[];
} ssbo_4_1;

layout(binding = 4, std430) readonly buffer srt_flatbuf
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
    uint buf3_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(24u), int(8u)) >> 2u;
    uint _109 = srt_flatbuf_1.data[16u];
    uint _112 = srt_flatbuf_1.data[17u];
    uint _113 = (gl_WorkGroupID.x << 5u) + gl_LocalInvocationID.x;
    uint _114 = (gl_WorkGroupID.y << 5u) + gl_LocalInvocationID.y;
    bool _117 = (_109 <= _113) || (_112 <= _114);
    bool _118 = !_117;
    if (!_117)
    {
        uint _120 = _114 + 1u;
        uint _121 = _113 + 1u;
        uint _125 = _113 + 4294967295u;
        uint _128 = _114 + 4294967295u;
        float _133 = (int(0u) > int(_114)) ? uintBitsToFloat(_112 + _114) : uintBitsToFloat(_114);
        uint _134 = floatBitsToUint(_133);
        float _139 = (int(0u) > int(_120)) ? uintBitsToFloat(_112 + _120) : uintBitsToFloat(_120);
        uint _140 = floatBitsToUint(_139);
        float _147 = (int(0u) > int(_121)) ? uintBitsToFloat(_109 + _121) : uintBitsToFloat(_121);
        uint _148 = floatBitsToUint(_147);
        float _153 = (int(0u) > int(_125)) ? uintBitsToFloat(_109 + _125) : uintBitsToFloat(_125);
        uint _154 = floatBitsToUint(_153);
        float _159 = (int(0u) > int(_113)) ? uintBitsToFloat(_109 + _113) : uintBitsToFloat(_113);
        uint _160 = floatBitsToUint(_159);
        float _163 = (int(0u) > int(_128)) ? uintBitsToFloat(_112 + _128) : uintBitsToFloat(_128);
        uint _164 = floatBitsToUint(_163);
        uint _182 = _109 * floatBitsToUint((int(_112) <= int(_134)) ? uintBitsToFloat(_134 - _112) : _133);
        uint _195 = srt_flatbuf_1.data[25u];
        uint _198 = floatBitsToUint((int(_109) <= int(_160)) ? uintBitsToFloat(_160 - _109) : _159);
        uint _202 = floatBitsToUint((int(_109) <= int(_148)) ? uintBitsToFloat(_148 - _109) : _147) + _182;
        uint _203 = floatBitsToUint((int(_109) <= int(_154)) ? uintBitsToFloat(_154 - _109) : _153) + _182;
        uint _204 = _198 + (_109 * floatBitsToUint((int(_112) <= int(_140)) ? uintBitsToFloat(_140 - _112) : _139));
        uint _206 = _198 + (_109 * floatBitsToUint((int(_112) <= int(_164)) ? uintBitsToFloat(_164 - _112) : _163));
        uint _209 = ssbo_1_1.data[_202 + buf0_dword_off];
        uint _212 = ssbo_1_1.data[_203 + buf0_dword_off];
        uint _215 = ssbo_1_1.data[_204 + buf0_dword_off];
        uint _218 = ssbo_1_1.data[_206 + buf0_dword_off];
        uint _220 = _113 + (_109 * _114);
        uint _221 = _220 + buf0_dword_off;
        uint _223 = ssbo_1_1.data[_221];
        uint _226 = ssbo_2_1.data[_202 + buf1_dword_off];
        uint _229 = ssbo_2_1.data[_203 + buf1_dword_off];
        uint _232 = ssbo_3_1.data[_204 + buf2_dword_off];
        uint _235 = ssbo_3_1.data[_206 + buf2_dword_off];
        uint _238 = ssbo_4_1.data[_220 + buf3_dword_off];
        uint _241 = srt_flatbuf_1.data[18u];
        if (_118 && (srt_flatbuf_1.data[21u] > _220))
        {
            ssbo_4_1.data[_220 + buf3_dword_off] = 0u;
        }
        precise float _248 = uintBitsToFloat(_209) + uintBitsToFloat(_212);
        precise float _250 = _248 + uintBitsToFloat(_215);
        precise float _252 = _250 + uintBitsToFloat(_218);
        precise float _255 = (-4.0) * uintBitsToFloat(_223);
        precise float _256 = _255 + _252;
        precise float _259 = uintBitsToFloat(_226) - uintBitsToFloat(_229);
        precise float _261 = uintBitsToFloat(_241) * _256;
        precise float _263 = _259 + uintBitsToFloat(_232);
        precise float _265 = 9.80000019073486328125 * _261;
        precise float _267 = _263 - uintBitsToFloat(_235);
        precise float _269 = (-0.5) * _267;
        precise float _270 = _269 + _265;
        precise float _272 = uintBitsToFloat(_223) * _270;
        precise float _275 = uintBitsToFloat(_223) + uintBitsToFloat(_238);
        precise float _277 = uintBitsToFloat(_241) * _272;
        precise float _278 = _277 + _275;
        if (_118 && (_195 > _220))
        {
            ssbo_1_1.data[_220 + buf0_dword_off] = floatBitsToUint(_278);
        }
    }
}

