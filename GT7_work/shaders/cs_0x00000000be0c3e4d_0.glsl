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
layout(local_size_x = 64, local_size_y = 1, local_size_z = 1) in;

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

layout(binding = 1) uniform writeonly image2D cs_img0;
layout(binding = 2) uniform writeonly image2D cs_img16;

void main()
{
    uint buf0_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(0u), int(8u)) >> 2u;
    uint _84 = 4u + buf0_dword_off;
    uint _90 = ssbo_1_1.data[5u + buf0_dword_off];
    uint _91 = 8u + buf0_dword_off;
    uint _93 = ssbo_1_1.data[_91];
    uint _95 = 9u + buf0_dword_off;
    uint _97 = ssbo_1_1.data[_95];
    uint _99 = 10u + buf0_dword_off;
    uint _101 = ssbo_1_1.data[_99];
    uint _107 = 12u + buf0_dword_off;
    uint _109 = ssbo_1_1.data[_107];
    uint _111 = 15u + buf0_dword_off;
    uint _113 = ssbo_1_1.data[_111];
    uint _116 = (gl_WorkGroupID.x << 6u) + gl_LocalInvocationID.x;
    precise float _123 = float(int(_116)) * (1.0 / float(ssbo_1_1.data[0u + buf0_dword_off] + 4294967295u));
    precise float _124 = _123 * _123;
    precise float _126 = uintBitsToFloat(ssbo_1_1.data[_84]) * _124;
    precise float _128 = (-1.44269502162933349609375) * _126;
    precise float _131 = uintBitsToFloat(_113) * 1.44269502162933349609375;
    precise float _132 = _131 + _128;
    float _134 = 1.0 / uintBitsToFloat(_101);
    float _136 = 1.0 / uintBitsToFloat(_93);
    precise float _137 = _134 * _126;
    uint _143 = 17u + buf0_dword_off;
    uint _145 = ssbo_1_1.data[_143];
    precise float _146 = _136 * _132;
    precise float _149 = uintBitsToFloat(_101) + uintBitsToFloat(ssbo_1_1.data[11u + buf0_dword_off]);
    float _152 = clamp(max(0.0, _137), 0.0, 1.0);
    precise float _154 = uintBitsToFloat(_145) * _146;
    bool _155 = _126 < _149;
    precise float _160 = (-_152) * _152;
    precise float _164 = uintBitsToFloat(ssbo_1_1.data[16u + buf0_dword_off]) - uintBitsToFloat(_93);
    precise float _165 = _160 * fma(-2.0, _152, 3.0);
    precise float _166 = _165 + 1.0;
    precise float _172 = exp2(_154) * _164;
    precise float _173 = _172 + uintBitsToFloat(_93);
    precise float _174 = (_155 ? 0.0 : (-1.0)) - _166;
    precise float _178 = uintBitsToFloat(ssbo_1_1.data[_84]) * _124;
    precise float _179 = _178 + (-uintBitsToFloat(_101));
    precise float _181 = uintBitsToFloat(_109) * log2(abs(_137));
    precise float _183 = 1.0 + _174;
    precise float _185 = uintBitsToFloat(_97) * _179;
    precise float _187 = _183 * _185;
    precise float _188 = _187 + (_155 ? 0.0 : _173);
    precise float _189 = exp2(_181) * _166;
    precise float _190 = _189 + _183;
    precise float _192 = uintBitsToFloat(_101) * _190;
    precise float _193 = _192 + _188;
    precise float _200 = 0.00999999977648258209228515625 * max(min(100.0, _193), min(max(100.0, _193), 0.0));
    precise float _203 = 0.1593017578125 * log2(_200);
    float _204 = exp2(_203);
    precise float _209 = 18.6875 * _204;
    precise float _210 = _209 + 1.0;
    precise float _213 = log2(fma(18.8515625, _204, 0.8359375)) - log2(_210);
    precise float _215 = 78.84375 * _213;
    imageStore(cs_img0, ivec2(uvec2(_116, 0u)), vec4(vec4(clamp(exp2(_215), 0.0, 1.0), 0.0, 0.0, 0.0).x, vec4(0.0, 1.0, 0.0, 0.0).x, vec4(0.0, 1.0, 0.0, 0.0).x, vec4(0.0, 1.0, 0.0, 0.0).x));
    precise float _224 = uintBitsToFloat(_90) * _124;
    precise float _228 = 0.0126833133399486541748046875 * log2(abs(_224));
    float _229 = exp2(_228);
    precise float _234 = (-0.8359375) + _229;
    precise float _235 = (1.0 / fma(-18.6875, _229, 18.8515625)) * _234;
    precise float _239 = 6.277394771575927734375 * log2(abs(_235));
    precise float _241 = 100.0 * exp2(_239);
    float _243 = -uintBitsToFloat(_101);
    float _245 = -uintBitsToFloat(_113);
    precise float _248 = 4.0 * uintBitsToFloat(_93);
    uint _249 = floatBitsToUint(_248);
    uint _261;
    bool _263;
    uint _313;
    uint _316;
    uint _317;
    uint _318;
    bool _250 = true;
    uint _251 = 0u;
    uint _252 = _249;
    uint _253 = 30u;
    for (;;)
    {
        precise float _256 = uintBitsToFloat(_252) - uintBitsToFloat(_251);
        _261 = _253 + 4294967295u;
        _263 = _250 && ((9.9999999747524270787835121154785e-07 <= _256) && ((1u != _253) ? _250 : false));
        if (!_263)
        {
            _317 = _251;
            _318 = _252;
            break;
        }
        else
        {
            precise float _267 = uintBitsToFloat(_252) + uintBitsToFloat(_251);
            precise float _269 = 0.5 * _267;
            precise float _270 = _269 + _245;
            precise float _272 = uintBitsToFloat(_145) * _136;
            precise float _273 = 0.5 * _267;
            precise float _274 = _272 * _270;
            precise float _275 = _134 * _273;
            precise float _276 = (-1.44269502162933349609375) * _274;
            float _278 = clamp(max(0.0, _275), 0.0, 1.0);
            bool _282 = _273 < _149;
            precise float _285 = (-_278) * _278;
            precise float _287 = uintBitsToFloat(_109) * log2(abs(_275));
            precise float _289 = exp2(_276) * _164;
            precise float _290 = _289 + uintBitsToFloat(_93);
            precise float _291 = _285 * fma(-2.0, _278, 3.0);
            precise float _292 = _291 + 1.0;
            precise float _297 = uintBitsToFloat(_101) * exp2(_287);
            precise float _298 = (_282 ? 0.0 : (-1.0)) - _292;
            precise float _299 = 0.5 * _267;
            precise float _300 = _299 + _243;
            precise float _301 = 1.0 + _298;
            precise float _302 = _292 * _297;
            precise float _303 = _302 + (_282 ? 0.0 : _290);
            precise float _306 = uintBitsToFloat(_97) * _300;
            precise float _307 = _306 + uintBitsToFloat(_101);
            precise float _308 = _301 * _307;
            precise float _309 = _308 + _303;
            bool _310 = _309 > _241;
            _313 = floatBitsToUint(_310 ? _273 : uintBitsToFloat(_252));
            _316 = floatBitsToUint(_310 ? uintBitsToFloat(_251) : _273);
            if (true)
            {
                _250 = _263;
                _251 = _316;
                _252 = _313;
                _253 = _261;
                continue;
            }
            else
            {
                _317 = _316;
                _318 = _313;
                break;
            }
        }
    }
    precise float _321 = uintBitsToFloat(_318) + uintBitsToFloat(_317);
    precise float _322 = _321 * 0.5;
    imageStore(cs_img16, ivec2(uvec2(_116, 0u)), vec4(vec4(_322, 0.0, 0.0, 0.0).x, vec4(0.0, 1.0, 0.0, 0.0).x, vec4(0.0, 1.0, 0.0, 0.0).x, vec4(0.0, 1.0, 0.0, 0.0).x));
}

