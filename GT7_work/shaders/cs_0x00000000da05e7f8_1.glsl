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

layout(binding = 2) uniform writeonly image2DArray cs_img31[1];
uniform sampler2DArray SPIRV_Cross_Combinedcs_img16cs_sampsgpr_24;

void main()
{
    uint _101 = (gl_WorkGroupID.x << 3u) + gl_LocalInvocationID.x;
    uint _102 = (gl_WorkGroupID.y << 3u) + gl_LocalInvocationID.y;
    if (srt_flatbuf_1.data[30u] > max(_101, _102))
    {
        float _111 = float(_101);
        uint _113 = gl_WorkGroupID.z * 12u;
        float _147 = float(_102);
        precise float _156 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _111;
        precise float _157 = _156 + uintBitsToFloat(srt_flatbuf_1.data[0u]);
        precise float _163 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _147;
        precise float _164 = _163 + _157;
        precise float _167 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _111;
        precise float _168 = _167 + uintBitsToFloat(srt_flatbuf_1.data[0u]);
        precise float _169 = _164 * _164;
        precise float _171 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _147;
        precise float _172 = _171 + _168;
        precise float _175 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _111;
        precise float _176 = _175 + uintBitsToFloat(srt_flatbuf_1.data[0u]);
        precise float _177 = _172 * _172;
        precise float _178 = _177 + _169;
        precise float _180 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _147;
        precise float _181 = _180 + _176;
        precise float _182 = _181 * _181;
        precise float _183 = _182 + _178;
        float _184 = inversesqrt(_183);
        precise float _185 = _184 * _181;
        precise float _186 = _185 * _185;
        precise float _187 = _184 * _164;
        precise float _188 = _184 * _172;
        precise float _189 = _187 * _187;
        precise float _191 = _188 * (-_187);
        precise float _192 = _191 + _186;
        precise float _193 = _192 * _192;
        precise float _194 = _188 * _188;
        precise float _196 = _185 * (-_188);
        precise float _197 = _196 + _189;
        precise float _198 = _197 * _197;
        precise float _199 = _198 + _193;
        precise float _201 = _187 * (-_185);
        precise float _202 = _201 + _194;
        precise float _203 = _202 * _202;
        precise float _204 = _203 + _199;
        float _205 = inversesqrt(_204);
        precise float _206 = _205 * _202;
        precise float _207 = _205 * _197;
        precise float _208 = _205 * _192;
        precise float _209 = _188 * _206;
        precise float _210 = _185 * _208;
        precise float _211 = _187 * _207;
        precise float _213 = _207 * (-_185);
        precise float _214 = _213 + _209;
        precise float _216 = _206 * (-_187);
        precise float _217 = _216 + _210;
        precise float _219 = _208 * (-_188);
        precise float _220 = _219 + _211;
        uint _357;
        bool _359;
        precise float _361;
        uint _362;
        precise float _364;
        uint _365;
        precise float _367;
        uint _368;
        uint _221 = 0u;
        uint _222 = 0u;
        uint _223 = 0u;
        uint _224 = 0u;
        for (;;)
        {
            uint _228 = ((_224 << 4u) + 216u) >> 2u;
            precise float _242 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _206;
            precise float _244 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _207;
            precise float _246 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _208;
            precise float _248 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _217;
            precise float _249 = _248 + _244;
            precise float _251 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _214;
            precise float _252 = _251 + _246;
            precise float _254 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _220;
            precise float _255 = _254 + _242;
            precise float _257 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _185;
            precise float _258 = _257 + _255;
            precise float _260 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _188;
            precise float _261 = _260 + _249;
            precise float _263 = uintBitsToFloat(srt_flatbuf_1.data[0u]) * _187;
            precise float _264 = _263 + _252;
            precise float _266 = _264 * 2.0;
            precise float _267 = _261 * 2.0;
            precise float _268 = _258 * 2.0;
            float _269 = abs(_264);
            float _270 = abs(_261);
            float _271 = abs(_258);
            float _280 = 1.0 / abs(((_271 >= _269) && (_271 >= _270)) ? _268 : ((_270 >= _269) ? _267 : _266));
            float _287 = abs(_264);
            float _288 = abs(_261);
            float _289 = abs(_258);
            float _297 = -_261;
            float _300 = abs(_264);
            float _301 = abs(_261);
            float _302 = abs(_258);
            float _316 = max(abs(_258), max(abs(_264), abs(_261)));
            float _326 = abs(_264);
            float _327 = abs(_261);
            float _328 = abs(_258);
            float _334 = ((_328 >= _326) && (_328 >= _327)) ? ((_258 < 0.0) ? 5.0 : 4.0) : ((_327 >= _326) ? ((_261 < 0.0) ? 3.0 : 2.0) : float(_264 < 0.0));
            precise float _335 = _316 * _316;
            precise float _336 = _335 * _316;
            precise float _340 = (-0.5) * log2(_336);
            precise float _341 = _340 + uintBitsToFloat(srt_flatbuf_1.data[0u]);
            precise float _342 = fma(((_289 >= _287) && (_289 >= _288)) ? ((_258 < 0.0) ? (-_264) : _264) : ((_288 >= _287) ? _264 : ((_264 < 0.0) ? _258 : (-_258))), _280, 1.5) - 1.0;
            precise float _343 = fma(((_302 >= _300) && (_302 >= _301)) ? _297 : ((_301 >= _300) ? ((_261 < 0.0) ? (-_258) : _258) : _297), _280, 1.5) - 1.0;
            precise float _345 = _334 / 8.0;
            vec4 _353 = textureLod(SPIRV_Cross_Combinedcs_img16cs_sampsgpr_24, vec3(_342, _343, fma(floor(_345), -2.0, _334)), _341);
            _357 = _224 + 1u;
            _359 = int(_224) < int(31u);
            _361 = _353.z + uintBitsToFloat(_222);
            _362 = floatBitsToUint(_361);
            _364 = _353.y + uintBitsToFloat(_223);
            _365 = floatBitsToUint(_364);
            _367 = _353.x + uintBitsToFloat(_221);
            _368 = floatBitsToUint(_367);
            if (_359)
            {
                _221 = _368;
                _222 = _362;
                _223 = _365;
                _224 = _357;
                continue;
            }
            else
            {
                break;
            }
        }
        precise float _385 = uintBitsToFloat(srt_flatbuf_1.data[28u]) * _367;
        precise float _387 = uintBitsToFloat(srt_flatbuf_1.data[28u]) * _361;
        precise float _389 = uintBitsToFloat(srt_flatbuf_1.data[28u]) * _364;
        vec4 _391 = vec4(_385, _389, _387, 0.0);
        imageStore(cs_img31[srt_flatbuf_1.data[29u]], ivec3(uvec3(_101, _102, gl_WorkGroupID.z + (srt_flatbuf_1.data[39u] * 6u))), vec4(_391.x, _391.y, _391.z, vec4(0.0, 1.0, 0.0, 0.0).x));
    }
}

