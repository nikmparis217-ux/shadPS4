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

layout(binding = 0, std430) readonly buffer ssbo_1
{
    uint data[];
} ssbo_1_1;

layout(binding = 1, std430) readonly buffer srt_flatbuf
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

layout(binding = 2) uniform writeonly image2D cs_img22;

void main()
{
    uint buf0_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(0u), int(8u)) >> 2u;
    uint _104 = (gl_WorkGroupID.x << 5u) + gl_LocalInvocationID.x;
    uint _115 = srt_flatbuf_1.data[16u] + 4294967295u;
    uint _117 = (gl_WorkGroupID.y << 5u) + gl_LocalInvocationID.y;
    bool _120 = (srt_flatbuf_1.data[16u] <= _104) || (srt_flatbuf_1.data[17u] <= _117);
    bool _121 = !_120;
    if (!_120)
    {
        bool _123 = _121 && (0u != _104);
        uint _162;
        uint _163;
        if (_123)
        {
            bool _124 = _123 && (_115 != _104);
            uint _142;
            uint _143;
            if (_124)
            {
                uint _125 = srt_flatbuf_1.data[16u] * _117;
                uint _130 = ((_104 + 1u) + _125) + buf0_dword_off;
                precise float _138 = uintBitsToFloat(ssbo_1_1.data[_130]) - uintBitsToFloat(ssbo_1_1.data[((_104 + 4294967295u) + _125) + buf0_dword_off]);
                precise float _140 = _138 * 0.5;
                _142 = ssbo_1_1.data[_130];
                _143 = floatBitsToUint(_140);
            }
            else
            {
                _142 = gl_LocalInvocationID.y;
                _143 = gl_LocalInvocationID.x;
            }
            uint _160;
            uint _161;
            if (_123 && (!_124))
            {
                uint _146 = srt_flatbuf_1.data[16u] * _117;
                uint _149 = ((_104 + 4294967295u) + _146) + buf0_dword_off;
                precise float _157 = uintBitsToFloat(ssbo_1_1.data[_146 + buf0_dword_off]) - uintBitsToFloat(ssbo_1_1.data[_149]);
                precise float _158 = _157 * 0.5;
                _160 = ssbo_1_1.data[_149];
                _161 = floatBitsToUint(_158);
            }
            else
            {
                _160 = _142;
                _161 = _143;
            }
            _162 = _160;
            _163 = _161;
        }
        else
        {
            _162 = gl_LocalInvocationID.y;
            _163 = gl_LocalInvocationID.x;
        }
        uint _181;
        uint _182;
        if (_121 && (!_123))
        {
            uint _166 = srt_flatbuf_1.data[16u] * _117;
            uint _173 = (_115 + _166) + buf0_dword_off;
            precise float _178 = uintBitsToFloat(ssbo_1_1.data[(_166 + 1u) + buf0_dword_off]) - uintBitsToFloat(ssbo_1_1.data[_173]);
            precise float _179 = _178 * 0.5;
            _181 = ssbo_1_1.data[_173];
            _182 = floatBitsToUint(_179);
        }
        else
        {
            _181 = _162;
            _182 = _163;
        }
        uint _184 = srt_flatbuf_1.data[17u] + 4294967295u;
        bool _186 = _121 && (0u != _117);
        uint _223;
        if (_186)
        {
            bool _187 = _186 && (_184 != _117);
            uint _205;
            if (_187)
            {
                precise float _202 = uintBitsToFloat(ssbo_1_1.data[((srt_flatbuf_1.data[16u] + _104) + (srt_flatbuf_1.data[16u] * _117)) + buf0_dword_off]) - uintBitsToFloat(ssbo_1_1.data[(_104 + (srt_flatbuf_1.data[16u] * (_117 + 4294967295u))) + buf0_dword_off]);
                precise float _203 = _202 * 0.5;
                _205 = floatBitsToUint(_203);
            }
            else
            {
                _205 = _181;
            }
            uint _222;
            if (_186 && (!_187))
            {
                precise float _219 = uintBitsToFloat(ssbo_1_1.data[_104 + buf0_dword_off]) - uintBitsToFloat(ssbo_1_1.data[(_104 + (srt_flatbuf_1.data[16u] * (_117 + 4294967295u))) + buf0_dword_off]);
                precise float _220 = _219 * 0.5;
                _222 = floatBitsToUint(_220);
            }
            else
            {
                _222 = _205;
            }
            _223 = _222;
        }
        else
        {
            _223 = _181;
        }
        uint _240;
        if (_121 && (!_186))
        {
            precise float _237 = uintBitsToFloat(ssbo_1_1.data[(srt_flatbuf_1.data[16u] + _104) + buf0_dword_off]) - uintBitsToFloat(ssbo_1_1.data[((srt_flatbuf_1.data[16u] * _184) + _104) + buf0_dword_off]);
            precise float _238 = _237 * 0.5;
            _240 = floatBitsToUint(_238);
        }
        else
        {
            _240 = _223;
        }
        precise float _243 = uintBitsToFloat(_182) * uintBitsToFloat(_182);
        precise float _246 = uintBitsToFloat(_240) * uintBitsToFloat(_240);
        precise float _247 = _246 + _243;
        precise float _249 = 1.0 + _247;
        float _251 = inversesqrt(_249);
        precise float _253 = uintBitsToFloat(_182) * _251;
        precise float _255 = uintBitsToFloat(_240) * _251;
        precise float _257 = 0.49803924560546875 * _253;
        precise float _258 = _257 + 0.49803924560546875;
        precise float _260 = 0.49803924560546875 * _255;
        precise float _261 = _260 + 0.49803924560546875;
        vec4 _265 = vec4(clamp(_258, 0.0, 1.0), clamp(_261, 0.0, 1.0), clamp(fma(_251, 0.49803924560546875, 0.49803924560546875), 0.0, 1.0), 1.0);
        imageStore(cs_img22, ivec2(uvec2(_104, _117)), vec4(_265.x, _265.y, _265.z, _265.w));
    }
}

