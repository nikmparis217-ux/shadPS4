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

layout(binding = 0, std430) readonly buffer ssbo_1
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

layout(binding = 4, std430) buffer gds_buffer
{
    uint data[];
} gds_buffer_1;

layout(binding = 5, std430) readonly buffer srt_flatbuf
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
    uint buf2_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(16u), int(8u)) >> 2u;
    uint buf3_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(24u), int(8u)) >> 2u;
    if (!(gl_WorkGroupID.x >= 4294941760u))
    {
        uint _116 = gl_WorkGroupID.x << 4u;
        uint _119 = ((_116 + 8u) >> 2u) + buf0_dword_off;
        uint _121 = ssbo_1_1.data[_119];
        uint _125 = srt_flatbuf_1.data[32u];
        uint _129 = ssbo_1_1.data[(_116 >> 2u) + buf0_dword_off];
        uint _131 = _121 & 255u;
        uint _132 = bitfieldExtract(_121, int(8u), int(8u));
        bool _134 = (0u == gl_LocalInvocationID.x) && (0u == gl_LocalInvocationID.y);
        uint _142 = ssbo_2_1.data[(((((_125 * _132) >> 3u) + _131) << 2u) >> 2u) + (bitfieldExtract(push_data.buf_offsets0.x, int(8u), int(8u)) >> 2u)];
        bool _145 = uintBitsToFloat(_142) > uintBitsToFloat(_129);
        bool _160;
        uint _161;
        uint _162;
        uint _163;
        if (_145)
        {
            uint _157;
            uint _158;
            uint _159;
            if (_134)
            {
                uint _151 = srt_flatbuf_1.data[33u];
                uint _152 = _151 << 2u;
                uint _156 = atomicAdd(gds_buffer_1.data[(_152 + 32u) >> 2u], 1u);
                _157 = 1u;
                _158 = _152;
                _159 = _151;
            }
            else
            {
                _157 = gl_LocalInvocationID.y;
                _158 = gl_LocalInvocationID.x;
                _159 = push_data.ud_regs0.x;
            }
            _160 = _134;
            _161 = _157;
            _162 = _158;
            _163 = _159;
        }
        else
        {
            _160 = true;
            _161 = gl_LocalInvocationID.y;
            _162 = gl_LocalInvocationID.x;
            _163 = push_data.ud_regs0.x;
        }
        if (!_145)
        {
            uint _166 = (_121 >> 16u) * 48u;
            uint _176 = ssbo_1_1.data[(((gl_WorkGroupID.x << 4u) + 12u) >> 2u) + buf0_dword_off];
            uint _177 = (_131 << 3u) + _162;
            uint _178 = (_132 << 3u) + _161;
            uint _179 = (_166 + 32u) >> 2u;
            uint _182 = ssbo_3_1.data[_179 + buf2_dword_off];
            uint _186 = ssbo_3_1.data[(_179 + 1u) + buf2_dword_off];
            uint _190 = ssbo_3_1.data[(_179 + 2u) + buf2_dword_off];
            uint _192 = (_179 + 3u) + buf2_dword_off;
            uint _194 = ssbo_3_1.data[_192];
            uint _197 = _166 >> 2u;
            uint _200 = ssbo_3_1.data[_197 + buf2_dword_off];
            uint _204 = ssbo_3_1.data[(_197 + 1u) + buf2_dword_off];
            uint _208 = ssbo_3_1.data[(_197 + 2u) + buf2_dword_off];
            uint _210 = (_197 + 3u) + buf2_dword_off;
            uint _212 = ssbo_3_1.data[_210];
            uint _214 = (_197 + 4u) + buf2_dword_off;
            uint _216 = ssbo_3_1.data[_214];
            uint _219 = (_197 + 5u) + buf2_dword_off;
            uint _221 = ssbo_3_1.data[_219];
            uint _224 = (_197 + 6u) + buf2_dword_off;
            uint _226 = ssbo_3_1.data[_224];
            uint _229 = (_197 + 7u) + buf2_dword_off;
            uint _231 = ssbo_3_1.data[_229];
            bool _232 = 0u != _176;
            precise float _234 = 0.5 + float(_177);
            precise float _236 = 0.5 + float(_178);
            uint _282;
            uint _283;
            uint _284;
            uint _285;
            uint _286;
            uint _287;
            uint _288;
            uint _289;
            if (_232)
            {
                precise float _240 = uintBitsToFloat(_212) * _234;
                uint _245 = srt_flatbuf_1.data[34u];
                uint _247 = _245 + _177;
                uint _251 = srt_flatbuf_1.data[20u];
                uint _254 = srt_flatbuf_1.data[21u];
                uint _257 = srt_flatbuf_1.data[22u];
                uint _260 = srt_flatbuf_1.data[23u];
                precise float _262 = uintBitsToFloat(_231) * _236;
                precise float _263 = _262 + _240;
                precise float _266 = uintBitsToFloat(_194) - _263;
                uint _268 = _247 + (_125 * _178);
                uint _269 = floatBitsToUint(_266);
                uint _275 = atomicMax(ssbo_4_1.data[_268 + buf3_dword_off], _269);
                uint _279 = atomicMin(ssbo_4_1.data[_268 + buf3_dword_off], _269);
                _282 = _247;
                _283 = _268;
                _284 = _260;
                _285 = floatBitsToUint(_263);
                _286 = floatBitsToUint(_266);
                _287 = _257;
                _288 = _254;
                _289 = _251;
            }
            else
            {
                _282 = _177;
                _283 = _178;
                _284 = _212;
                _285 = floatBitsToUint(_234);
                _286 = floatBitsToUint(_236);
                _287 = _208;
                _288 = _204;
                _289 = _200;
            }
            if (!_232)
            {
                precise float _292 = uintBitsToFloat(_226) - uintBitsToFloat(_216);
                precise float _295 = uintBitsToFloat(_221) - uintBitsToFloat(_226);
                precise float _297 = uintBitsToFloat(_285) * _292;
                precise float _300 = uintBitsToFloat(_289) - uintBitsToFloat(_287);
                precise float _302 = uintBitsToFloat(_285) * _295;
                precise float _305 = uintBitsToFloat(_287) - uintBitsToFloat(_288);
                precise float _308 = uintBitsToFloat(_216) - uintBitsToFloat(_221);
                precise float _311 = uintBitsToFloat(_288) - uintBitsToFloat(_289);
                precise float _313 = _300 * uintBitsToFloat(_286);
                precise float _314 = _313 + _297;
                precise float _316 = _305 * uintBitsToFloat(_286);
                precise float _317 = _316 + _302;
                precise float _319 = uintBitsToFloat(_285) * _308;
                precise float _327 = _311 * uintBitsToFloat(_286);
                precise float _328 = _327 + _319;
                if (_160 && ((_328 >= (-uintBitsToFloat(_182))) && ((_317 >= (-uintBitsToFloat(_186))) && (_314 >= (-uintBitsToFloat(_190))))))
                {
                    precise float _337 = uintBitsToFloat(_284) * uintBitsToFloat(_285);
                    uint _340 = srt_flatbuf_1.data[34u];
                    precise float _345 = uintBitsToFloat(_231) * uintBitsToFloat(_286);
                    precise float _346 = _345 + _337;
                    precise float _348 = uintBitsToFloat(_194) - _346;
                    uint _349 = (_340 + _282) + (_125 * _283);
                    uint _350 = floatBitsToUint(_348);
                    uint _355 = atomicMax(ssbo_4_1.data[_349 + buf3_dword_off], _350);
                    uint _359 = atomicMin(ssbo_4_1.data[_349 + buf3_dword_off], _350);
                }
            }
        }
    }
}

