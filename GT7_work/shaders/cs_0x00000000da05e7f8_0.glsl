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
layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

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

layout(binding = 0, std430) readonly buffer srt_flatbuf
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

layout(binding = 2) uniform writeonly image2DArray cs_img31[9];
uniform sampler2DArray SPIRV_Cross_Combinedcs_img16cs_sampsgpr_24;

void main()
{
    uint _102 = (gl_WorkGroupID.x << 3u) + gl_LocalInvocationID.x;
    uint _103 = (gl_WorkGroupID.y << 3u) + gl_LocalInvocationID.y;
    if (srt_flatbuf_1.data[30u] > max(_102, _103))
    {
        float _112 = float(_102);
        uint _114 = gl_WorkGroupID.z * 12u;
        float _148 = float(_103);
        precise float _157 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _112;
        precise float _158 = _157 + uintBitsToFloat(srt_flatbuf_1.data[0u]);
        precise float _164 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _148;
        precise float _165 = _164 + _158;
        precise float _168 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _112;
        precise float _169 = _168 + uintBitsToFloat(srt_flatbuf_1.data[0u]);
        precise float _170 = _165 * _165;
        precise float _172 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _148;
        precise float _173 = _172 + _169;
        precise float _176 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _112;
        precise float _177 = _176 + uintBitsToFloat(srt_flatbuf_1.data[0u]);
        precise float _178 = _173 * _173;
        precise float _179 = _178 + _170;
        precise float _181 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _148;
        precise float _182 = _181 + _177;
        precise float _183 = _182 * _182;
        precise float _184 = _183 + _179;
        float _185 = inversesqrt(_184);
        precise float _186 = _185 * _182;
        precise float _187 = _186 * _186;
        precise float _188 = _185 * _165;
        precise float _189 = _185 * _173;
        precise float _190 = _188 * _188;
        precise float _192 = _189 * (-_188);
        precise float _193 = _192 + _187;
        precise float _194 = _193 * _193;
        precise float _195 = _189 * _189;
        precise float _197 = _186 * (-_189);
        precise float _198 = _197 + _190;
        precise float _199 = _198 * _198;
        precise float _200 = _199 + _194;
        precise float _202 = _188 * (-_186);
        precise float _203 = _202 + _195;
        precise float _204 = _203 * _203;
        precise float _205 = _204 + _200;
        float _206 = inversesqrt(_205);
        precise float _207 = _206 * _203;
        precise float _208 = _206 * _198;
        precise float _209 = _206 * _193;
        precise float _210 = _189 * _207;
        precise float _211 = _186 * _209;
        precise float _212 = _188 * _208;
        precise float _214 = _208 * (-_186);
        precise float _215 = _214 + _210;
        precise float _217 = _207 * (-_188);
        precise float _218 = _217 + _211;
        precise float _220 = _209 * (-_189);
        precise float _221 = _220 + _212;
        uint _358;
        bool _360;
        precise float _362;
        uint _363;
        precise float _365;
        uint _366;
        precise float _368;
        uint _369;
        uint _222 = 0u;
        uint _223 = 0u;
        uint _224 = 0u;
        uint _225 = 0u;
        for (;;)
        {
            uint _229 = ((_225 << 4u) + 216u) >> 2u;
            precise float _243 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _207;
            precise float _245 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _208;
            precise float _247 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _209;
            precise float _249 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _218;
            precise float _250 = _249 + _245;
            precise float _252 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _215;
            precise float _253 = _252 + _247;
            precise float _255 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _221;
            precise float _256 = _255 + _243;
            precise float _258 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _186;
            precise float _259 = _258 + _256;
            precise float _261 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _189;
            precise float _262 = _261 + _250;
            precise float _264 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _188;
            precise float _265 = _264 + _253;
            precise float _267 = _265 * 2.0;
            precise float _268 = _262 * 2.0;
            precise float _269 = _259 * 2.0;
            float _270 = abs(_265);
            float _271 = abs(_262);
            float _272 = abs(_259);
            float _281 = 1.0 / abs(((_272 >= _270) && (_272 >= _271)) ? _269 : ((_271 >= _270) ? _268 : _267));
            float _288 = abs(_265);
            float _289 = abs(_262);
            float _290 = abs(_259);
            float _298 = -_262;
            float _301 = abs(_265);
            float _302 = abs(_262);
            float _303 = abs(_259);
            float _317 = max(abs(_259), max(abs(_265), abs(_262)));
            float _327 = abs(_265);
            float _328 = abs(_262);
            float _329 = abs(_259);
            float _335 = ((_329 >= _327) && (_329 >= _328)) ? ((_259 < 0.0) ? 5.0 : 4.0) : ((_328 >= _327) ? ((_262 < 0.0) ? 3.0 : 2.0) : float(_265 < 0.0));
            precise float _336 = _317 * _317;
            precise float _337 = _336 * _317;
            precise float _341 = (-0.5) * log2(_337);
            precise float _342 = _341 + uintBitsToFloat(srt_flatbuf_1.data[0u]);
            precise float _343 = fma(((_290 >= _288) && (_290 >= _289)) ? ((_259 < 0.0) ? (-_265) : _265) : ((_289 >= _288) ? _265 : ((_265 < 0.0) ? _259 : (-_259))), _281, 1.5) - 1.0;
            precise float _344 = fma(((_303 >= _301) && (_303 >= _302)) ? _298 : ((_302 >= _301) ? ((_262 < 0.0) ? (-_259) : _259) : _298), _281, 1.5) - 1.0;
            precise float _346 = _335 / 8.0;
            vec4 _354 = textureLod(SPIRV_Cross_Combinedcs_img16cs_sampsgpr_24, vec3(_343, _344, fma(floor(_346), -2.0, _335)), _342);
            _358 = _225 + 1u;
            _360 = int(_225) < int(31u);
            _362 = _354.z + uintBitsToFloat(_223);
            _363 = floatBitsToUint(_362);
            _365 = _354.y + uintBitsToFloat(_224);
            _366 = floatBitsToUint(_365);
            _368 = _354.x + uintBitsToFloat(_222);
            _369 = floatBitsToUint(_368);
            if (_360)
            {
                _222 = _369;
                _223 = _363;
                _224 = _366;
                _225 = _358;
                continue;
            }
            else
            {
                break;
            }
        }
        precise float _386 = uintBitsToFloat(srt_flatbuf_1.data[28u]) * _368;
        precise float _388 = uintBitsToFloat(srt_flatbuf_1.data[28u]) * _362;
        precise float _390 = uintBitsToFloat(srt_flatbuf_1.data[28u]) * _365;
        vec4 _392 = vec4(_386, _390, _388, 0.0);
        imageStore(cs_img31[srt_flatbuf_1.data[29u]], ivec3(uvec3(_102, _103, gl_WorkGroupID.z + (srt_flatbuf_1.data[39u] * 6u))), vec4(_392.x, _392.y, _392.z, vec4(0.0, 1.0, 0.0, 0.0).x));
    }
}

