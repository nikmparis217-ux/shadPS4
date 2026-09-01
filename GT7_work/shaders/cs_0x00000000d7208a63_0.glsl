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

#if defined(GL_KHR_shader_subgroup_ballot)
#extension GL_KHR_shader_subgroup_ballot : require
#elif defined(GL_NV_shader_thread_shuffle)
#extension GL_NV_shader_thread_shuffle : require
#elif defined(GL_ARB_shader_ballot) && defined(GL_ARB_shader_int64)
#extension GL_ARB_shader_int64 : enable
#extension GL_ARB_shader_ballot : require
#else
#error No extensions available to emulate requested subgroup feature.
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

uint _111;
uint _112;
uint _113;
uint _114;
uint _115;
uint _116;
uint _117;
uint _118;
uint _119;
uint _120;
uint _121;
uint _122;
uint _123;
uint _124;
uint _125;
uint _126;
uint _127;
uint _128;
uint _129;
uint _130;

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

#if defined(GL_KHR_shader_subgroup_ballot)
#elif defined(GL_NV_shader_thread_shuffle)
int subgroupBroadcastFirst(int value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
ivec2 subgroupBroadcastFirst(ivec2 value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
ivec3 subgroupBroadcastFirst(ivec3 value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
ivec4 subgroupBroadcastFirst(ivec4 value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
uint subgroupBroadcastFirst(uint value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
uvec2 subgroupBroadcastFirst(uvec2 value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
uvec3 subgroupBroadcastFirst(uvec3 value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
uvec4 subgroupBroadcastFirst(uvec4 value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
float subgroupBroadcastFirst(float value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
vec2 subgroupBroadcastFirst(vec2 value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
vec3 subgroupBroadcastFirst(vec3 value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
vec4 subgroupBroadcastFirst(vec4 value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
double subgroupBroadcastFirst(double value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
dvec2 subgroupBroadcastFirst(dvec2 value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
dvec3 subgroupBroadcastFirst(dvec3 value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
dvec4 subgroupBroadcastFirst(dvec4 value) { return shuffleNV(value, findLSB(ballotThreadNV(true)), gl_WarpSizeNV); }
int subgroupBroadcast(int value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
ivec2 subgroupBroadcast(ivec2 value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
ivec3 subgroupBroadcast(ivec3 value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
ivec4 subgroupBroadcast(ivec4 value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
uint subgroupBroadcast(uint value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
uvec2 subgroupBroadcast(uvec2 value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
uvec3 subgroupBroadcast(uvec3 value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
uvec4 subgroupBroadcast(uvec4 value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
float subgroupBroadcast(float value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
vec2 subgroupBroadcast(vec2 value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
vec3 subgroupBroadcast(vec3 value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
vec4 subgroupBroadcast(vec4 value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
double subgroupBroadcast(double value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
dvec2 subgroupBroadcast(dvec2 value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
dvec3 subgroupBroadcast(dvec3 value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
dvec4 subgroupBroadcast(dvec4 value, uint id) { return shuffleNV(value, id, gl_WarpSizeNV); }
#elif defined(GL_ARB_shader_ballot)
int subgroupBroadcastFirst(int value) { return readFirstInvocationARB(value); }
ivec2 subgroupBroadcastFirst(ivec2 value) { return readFirstInvocationARB(value); }
ivec3 subgroupBroadcastFirst(ivec3 value) { return readFirstInvocationARB(value); }
ivec4 subgroupBroadcastFirst(ivec4 value) { return readFirstInvocationARB(value); }
uint subgroupBroadcastFirst(uint value) { return readFirstInvocationARB(value); }
uvec2 subgroupBroadcastFirst(uvec2 value) { return readFirstInvocationARB(value); }
uvec3 subgroupBroadcastFirst(uvec3 value) { return readFirstInvocationARB(value); }
uvec4 subgroupBroadcastFirst(uvec4 value) { return readFirstInvocationARB(value); }
float subgroupBroadcastFirst(float value) { return readFirstInvocationARB(value); }
vec2 subgroupBroadcastFirst(vec2 value) { return readFirstInvocationARB(value); }
vec3 subgroupBroadcastFirst(vec3 value) { return readFirstInvocationARB(value); }
vec4 subgroupBroadcastFirst(vec4 value) { return readFirstInvocationARB(value); }
double subgroupBroadcastFirst(double value) { return readFirstInvocationARB(value); }
dvec2 subgroupBroadcastFirst(dvec2 value) { return readFirstInvocationARB(value); }
dvec3 subgroupBroadcastFirst(dvec3 value) { return readFirstInvocationARB(value); }
dvec4 subgroupBroadcastFirst(dvec4 value) { return readFirstInvocationARB(value); }
int subgroupBroadcast(int value, uint id) { return readInvocationARB(value, id); }
ivec2 subgroupBroadcast(ivec2 value, uint id) { return readInvocationARB(value, id); }
ivec3 subgroupBroadcast(ivec3 value, uint id) { return readInvocationARB(value, id); }
ivec4 subgroupBroadcast(ivec4 value, uint id) { return readInvocationARB(value, id); }
uint subgroupBroadcast(uint value, uint id) { return readInvocationARB(value, id); }
uvec2 subgroupBroadcast(uvec2 value, uint id) { return readInvocationARB(value, id); }
uvec3 subgroupBroadcast(uvec3 value, uint id) { return readInvocationARB(value, id); }
uvec4 subgroupBroadcast(uvec4 value, uint id) { return readInvocationARB(value, id); }
float subgroupBroadcast(float value, uint id) { return readInvocationARB(value, id); }
vec2 subgroupBroadcast(vec2 value, uint id) { return readInvocationARB(value, id); }
vec3 subgroupBroadcast(vec3 value, uint id) { return readInvocationARB(value, id); }
vec4 subgroupBroadcast(vec4 value, uint id) { return readInvocationARB(value, id); }
double subgroupBroadcast(double value, uint id) { return readInvocationARB(value, id); }
dvec2 subgroupBroadcast(dvec2 value, uint id) { return readInvocationARB(value, id); }
dvec3 subgroupBroadcast(dvec3 value, uint id) { return readInvocationARB(value, id); }
dvec4 subgroupBroadcast(dvec4 value, uint id) { return readInvocationARB(value, id); }
#endif

void main()
{
    uint buf1_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(8u), int(8u)) >> 2u;
    uint buf2_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(16u), int(8u)) >> 2u;
    uint _175 = (gl_WorkGroupID.x << 6u) + gl_LocalInvocationID.x;
    bool _176 = push_data.ud_regs0.x > _175;
    if (_176)
    {
        uint _179 = (_175 * 21u) + (bitfieldExtract(push_data.buf_offsets0.x, int(0u), int(8u)) >> 2u);
        uvec3 _188 = uvec3(ssbo_1_1.data[_179], ssbo_1_1.data[_179 + 1u], ssbo_1_1.data[_179 + 2u]);
        uint _189 = _188.x;
        uint _190 = _188.y;
        uint _191 = _188.z;
        bool _226;
        uint _878;
        uint _879;
        uint _880;
        uint _881;
        uint _882;
        uint _883;
        uint _884;
        uint _885;
        uint _886;
        uint _887;
        uint _888;
        uint _889;
        uint _890;
        uint _891;
        uint _892;
        uint _893;
        uint _894;
        uint _895;
        uint _896;
        uint _897;
        uint _898;
        uint _899;
        uint _900;
        uint _901;
        uint _902;
        uint _903;
        uint _904;
        uint _905;
        uint _906;
        uint _907;
        uint _908;
        uint _909;
        uint _910;
        uint _911;
        uint _912;
        uint _913;
        uint _914;
        uint _192;
        uint _193;
        uint _194;
        uint _195 = 1073741823u;
        uint _196 = 0u;
        uint _197 = 0u;
        uint _198 = _175;
        uint _199;
        uint _200;
        uint _201 = 1u;
        uint _202 = _191;
        uint _203 = _190;
        uint _204 = _189;
        uint _205;
        uint _206;
        uint _207;
        uint _208;
        uint _209;
        uint _210;
        uint _211;
        uint _212;
        uint _213;
        uint _214;
        uint _215;
        uint _216;
        uint _217;
        uint _218;
        uint _219;
        uint _220 = gl_LocalInvocationID.z;
        uint _221 = gl_LocalInvocationID.y;
        uint _222 = 0u;
        bool _223 = _176;
        uint _224 = 0u;
        for (;;)
        {
            _226 = _223 && (int(0u) <= int(_224));
            if (!_226)
            {
                _909 = _198;
                _910 = _197;
                _911 = _202;
                _912 = _204;
                _913 = _196;
                _914 = _195;
                break;
            }
            else
            {
                bool _235;
                uint _321;
                uint _228 = _194;
                bool _229 = _226;
                bool _230 = _226;
                for (;;)
                {
                    uint _231 = subgroupBroadcastFirst(_224);
                    bool _233 = _229 && (_231 == _224);
                    _235 = _230 && (!_233);
                    if (_233)
                    {
                        _321 = (_231 == 31u) ? _192 : ((_231 == 30u) ? _193 : ((_231 == 29u) ? _228 : ((_231 == 28u) ? _224 : ((_231 == 27u) ? _195 : ((_231 == 26u) ? _196 : ((_231 == 25u) ? _197 : ((_231 == 24u) ? _198 : ((_231 == 23u) ? _199 : ((_231 == 22u) ? _200 : ((_231 == 21u) ? _201 : ((_231 == 20u) ? _202 : ((_231 == 19u) ? _203 : ((_231 == 18u) ? _204 : ((_231 == 17u) ? _205 : ((_231 == 16u) ? _206 : ((_231 == 15u) ? _207 : ((_231 == 14u) ? _208 : ((_231 == 13u) ? _209 : ((_231 == 12u) ? _210 : ((_231 == 11u) ? _211 : ((_231 == 10u) ? _212 : ((_231 == 9u) ? _213 : ((_231 == 8u) ? _214 : ((_231 == 7u) ? _215 : ((_231 == 6u) ? _216 : ((_231 == 5u) ? _217 : ((_231 == 4u) ? _218 : ((_231 == 3u) ? _219 : ((_231 == 2u) ? _220 : ((_231 == 1u) ? _221 : ((_231 == 0u) ? _222 : _222)))))))))))))))))))))))))))))));
                    }
                    else
                    {
                        _321 = _228;
                    }
                    if (_235)
                    {
                        _228 = _321;
                        _229 = _235;
                        _230 = _235;
                        continue;
                    }
                    else
                    {
                        break;
                    }
                }
                uint _322 = _321 >> 16u;
                uint _324 = (_322 * 4u) + buf1_dword_off;
                uvec4 _336 = uvec4(ssbo_2_1.data[_324], ssbo_2_1.data[_324 + 1u], ssbo_2_1.data[_324 + 2u], ssbo_2_1.data[_324 + 3u]);
                uint _337 = _336.x;
                uint _338 = _336.y;
                uint _339 = _336.z;
                uint _340 = _336.w;
                uint _345 = floatBitsToUint((0u != _201) ? 2.8025969286496341418474591665798e-45 : 1.4012984643248170709237295832899e-45);
                uint _347 = _224 + 4294967295u;
                uint _373;
                uint _374;
                bool _375;
                if (_226 && (1u >= _345))
                {
                    precise float _356 = uintBitsToFloat(_339) - ((0u == bitfieldExtract(_337, int(1u), int(1u))) ? uintBitsToFloat(_204) : uintBitsToFloat(_202));
                    precise float _361 = (-uintBitsToFloat(_340)) + abs(_356);
                    precise float _362 = _361 * _361;
                    float _367 = (abs(_356) > uintBitsToFloat(_340)) ? _362 : 0.0;
                    _373 = floatBitsToUint(_367);
                    _374 = floatBitsToUint(_362);
                    _375 = _226 && (!(_367 > uintBitsToFloat(_196)));
                }
                else
                {
                    _373 = _339;
                    _374 = _199;
                    _375 = _226;
                }
                bool _377 = _375 && (2u >= _345);
                if (_377)
                {
                    bool _380 = _377 && (4294967292u > _337);
                    uint _520;
                    uint _521;
                    uint _522;
                    uint _523;
                    uint _524;
                    uint _525;
                    uint _526;
                    uint _527;
                    uint _528;
                    uint _529;
                    if (_380)
                    {
                        uint _381 = _337 >> 2u;
                        uint _384 = ((_381 + 1u) * 4u) + buf2_dword_off;
                        uvec3 _393 = uvec3(ssbo_3_1.data[_384], ssbo_3_1.data[_384 + 1u], ssbo_3_1.data[_384 + 2u]);
                        uint _394 = _393.x;
                        uint _395 = _393.y;
                        uint _396 = _393.z;
                        uint _398 = (_381 * 4u) + buf2_dword_off;
                        uvec3 _407 = uvec3(ssbo_3_1.data[_398], ssbo_3_1.data[_398 + 1u], ssbo_3_1.data[_398 + 2u]);
                        uint _408 = _407.x;
                        uint _409 = _407.y;
                        uint _410 = _407.z;
                        precise float _413 = uintBitsToFloat(_394) - uintBitsToFloat(_408);
                        precise float _416 = uintBitsToFloat(_204) - uintBitsToFloat(_408);
                        precise float _417 = _413 * _416;
                        precise float _420 = uintBitsToFloat(_395) - uintBitsToFloat(_409);
                        precise float _423 = uintBitsToFloat(_203) - uintBitsToFloat(_409);
                        precise float _425 = _413 * _413;
                        precise float _428 = uintBitsToFloat(_396) - uintBitsToFloat(_410);
                        precise float _431 = uintBitsToFloat(_202) - uintBitsToFloat(_410);
                        precise float _433 = _423 * _420;
                        precise float _434 = _433 + _417;
                        precise float _435 = _420 * _420;
                        precise float _436 = _435 + _425;
                        precise float _437 = _431 * _428;
                        precise float _438 = _437 + _434;
                        precise float _439 = _428 * _428;
                        precise float _440 = _439 + _436;
                        bool _445 = _380 && ((0.0 < _438) && (_438 < _440));
                        uint _461;
                        uint _462;
                        uint _463;
                        uint _464;
                        if (_445)
                        {
                            precise float _446 = _416 * _416;
                            precise float _447 = _423 * _423;
                            precise float _448 = _447 + _446;
                            float _450 = 1.0 / _440;
                            precise float _452 = _450 * _438;
                            precise float _454 = _431 * _431;
                            precise float _455 = _454 + _448;
                            precise float _458 = (-_438) * _452;
                            precise float _459 = _458 + _455;
                            _461 = floatBitsToUint(_455);
                            _462 = floatBitsToUint(_450);
                            _463 = floatBitsToUint(_452);
                            _464 = floatBitsToUint(_459);
                        }
                        else
                        {
                            _461 = _396;
                            _462 = _395;
                            _463 = _394;
                            _464 = floatBitsToUint(_431);
                        }
                        bool _466 = _380 && (!_445);
                        uint _499;
                        uint _500;
                        uint _501;
                        if (_466)
                        {
                            bool _467 = _466 && (0.0 >= _438);
                            uint _476;
                            uint _477;
                            if (_467)
                            {
                                precise float _468 = _416 * _416;
                                precise float _469 = _423 * _423;
                                precise float _470 = _469 + _468;
                                precise float _473 = uintBitsToFloat(_464) * uintBitsToFloat(_464);
                                precise float _474 = _473 + _470;
                                _476 = floatBitsToUint(_474);
                                _477 = 0u;
                            }
                            else
                            {
                                _476 = _464;
                                _477 = _463;
                            }
                            uint _496;
                            uint _497;
                            uint _498;
                            if (_466 && (!_467))
                            {
                                precise float _482 = uintBitsToFloat(_204) - uintBitsToFloat(_477);
                                precise float _483 = _482 * _482;
                                precise float _486 = uintBitsToFloat(_203) - uintBitsToFloat(_462);
                                precise float _487 = _486 * _486;
                                precise float _488 = _487 + _483;
                                precise float _491 = uintBitsToFloat(_202) - uintBitsToFloat(_461);
                                precise float _493 = _491 * _491;
                                precise float _494 = _493 + _488;
                                _496 = floatBitsToUint(_491);
                                _497 = floatBitsToUint(_494);
                                _498 = 1065353216u;
                            }
                            else
                            {
                                _496 = _462;
                                _497 = _476;
                                _498 = _477;
                            }
                            _499 = _496;
                            _500 = _498;
                            _501 = _497;
                        }
                        else
                        {
                            _499 = _462;
                            _500 = _463;
                            _501 = _464;
                        }
                        bool _507 = (uintBitsToFloat(_501) < uintBitsToFloat(_196)) || (1073741823u == _195);
                        _520 = _381;
                        _521 = _461;
                        _522 = floatBitsToUint(_507 ? uintBitsToFloat(_381) : uintBitsToFloat(_195));
                        _523 = floatBitsToUint(_507 ? uintBitsToFloat(_501) : uintBitsToFloat(_196));
                        _524 = floatBitsToUint(_507 ? uintBitsToFloat(_500) : uintBitsToFloat(_197));
                        _525 = _501;
                        _526 = floatBitsToUint(_423);
                        _527 = 0u;
                        _528 = _499;
                        _529 = _500;
                    }
                    else
                    {
                        _520 = _340;
                        _521 = _373;
                        _522 = _195;
                        _523 = _196;
                        _524 = _197;
                        _525 = _374;
                        _526 = _345;
                        _527 = _201;
                        _528 = _338;
                        _529 = _337;
                    }
                    bool _531 = _377 && (!_380);
                    uint _847;
                    uint _848;
                    uint _849;
                    uint _850;
                    uint _851;
                    uint _852;
                    uint _853;
                    uint _854;
                    uint _855;
                    uint _856;
                    uint _857;
                    uint _858;
                    uint _859;
                    uint _860;
                    uint _861;
                    uint _862;
                    uint _863;
                    uint _864;
                    uint _865;
                    uint _866;
                    uint _867;
                    uint _868;
                    uint _869;
                    uint _870;
                    uint _871;
                    uint _872;
                    uint _873;
                    uint _874;
                    uint _875;
                    uint _876;
                    uint _877;
                    if (_531)
                    {
                        float _536 = (0u == (1u & _529)) ? uintBitsToFloat(_204) : uintBitsToFloat(_202);
                        uint _539 = _322 + 1u;
                        uint _551;
                        if (_531 && (_536 < uintBitsToFloat(_528)))
                        {
                            _551 = (((1u << bitfieldExtract((srt_flatbuf_1.data[24u] + 31u) - _321, int(0u), int(4u))) - 1u) << 0u) + _539;
                        }
                        else
                        {
                            _551 = _539;
                        }
                        uint _552 = _321 + 1u;
                        uint _553 = _551 << 16u;
                        uint _558 = (65535u & _552) | _553;
                        bool _597;
                        uint _662;
                        uint _663;
                        uint _664;
                        uint _665;
                        uint _666;
                        uint _667;
                        uint _668;
                        uint _669;
                        uint _670;
                        uint _671;
                        uint _672;
                        uint _673;
                        uint _674;
                        uint _675;
                        uint _676;
                        uint _677;
                        uint _678;
                        uint _679;
                        uint _680;
                        uint _681;
                        uint _682;
                        uint _683;
                        uint _684;
                        uint _685;
                        uint _686;
                        uint _687;
                        uint _688;
                        uint _689;
                        uint _690;
                        uint _691;
                        uint _692;
                        uint _693;
                        uint _559 = _347;
                        uint _560 = _322;
                        uint _561 = _321;
                        uint _562 = _522;
                        uint _563 = _523;
                        uint _564 = _524;
                        uint _565 = _198;
                        uint _566 = _525;
                        uint _567 = _526;
                        uint _568 = _527;
                        uint _569 = _202;
                        uint _570 = _203;
                        uint _571 = _204;
                        uint _572 = _552;
                        uint _573 = _553;
                        uint _574 = _528;
                        uint _575 = _558;
                        uint _576 = _209;
                        uint _577 = _210;
                        uint _578 = _211;
                        uint _579 = _212;
                        uint _580 = _213;
                        uint _581 = _214;
                        uint _582 = _215;
                        uint _583 = _216;
                        uint _584 = _217;
                        uint _585 = _218;
                        uint _586 = _219;
                        uint _587 = _220;
                        uint _588 = _221;
                        uint _589 = _222;
                        bool _590 = _531;
                        bool _591 = _531;
                        uint _592 = _224;
                        for (;;)
                        {
                            uint _593 = subgroupBroadcastFirst(_592);
                            bool _595 = _590 && (_593 == _592);
                            _597 = _591 && (!_595);
                            if (_595)
                            {
                                _662 = (_593 == 31u) ? _575 : _559;
                                _663 = (_593 == 30u) ? _575 : _560;
                                _664 = (_593 == 29u) ? _575 : _561;
                                _665 = (_593 == 28u) ? _575 : _592;
                                _666 = (_593 == 27u) ? _575 : _562;
                                _667 = (_593 == 26u) ? _575 : _563;
                                _668 = (_593 == 25u) ? _575 : _564;
                                _669 = (_593 == 24u) ? _575 : _565;
                                _670 = (_593 == 23u) ? _575 : _566;
                                _671 = (_593 == 22u) ? _575 : _567;
                                _672 = (_593 == 21u) ? _575 : _568;
                                _673 = (_593 == 20u) ? _575 : _569;
                                _674 = (_593 == 19u) ? _575 : _570;
                                _675 = (_593 == 18u) ? _575 : _571;
                                _676 = (_593 == 17u) ? _575 : _572;
                                _677 = (_593 == 16u) ? _575 : _573;
                                _678 = (_593 == 15u) ? _575 : _574;
                                _679 = (_593 == 14u) ? _575 : _575;
                                _680 = (_593 == 13u) ? _575 : _576;
                                _681 = (_593 == 12u) ? _575 : _577;
                                _682 = (_593 == 11u) ? _575 : _578;
                                _683 = (_593 == 10u) ? _575 : _579;
                                _684 = (_593 == 9u) ? _575 : _580;
                                _685 = (_593 == 8u) ? _575 : _581;
                                _686 = (_593 == 7u) ? _575 : _582;
                                _687 = (_593 == 6u) ? _575 : _583;
                                _688 = (_593 == 5u) ? _575 : _584;
                                _689 = (_593 == 4u) ? _575 : _585;
                                _690 = (_593 == 3u) ? _575 : _586;
                                _691 = (_593 == 2u) ? _575 : _587;
                                _692 = (_593 == 1u) ? _575 : _588;
                                _693 = (_593 == 0u) ? _575 : _589;
                            }
                            else
                            {
                                _662 = _559;
                                _663 = _560;
                                _664 = _561;
                                _665 = _592;
                                _666 = _562;
                                _667 = _563;
                                _668 = _564;
                                _669 = _565;
                                _670 = _566;
                                _671 = _567;
                                _672 = _568;
                                _673 = _569;
                                _674 = _570;
                                _675 = _571;
                                _676 = _572;
                                _677 = _573;
                                _678 = _574;
                                _679 = _575;
                                _680 = _576;
                                _681 = _577;
                                _682 = _578;
                                _683 = _579;
                                _684 = _580;
                                _685 = _581;
                                _686 = _582;
                                _687 = _583;
                                _688 = _584;
                                _689 = _585;
                                _690 = _586;
                                _691 = _587;
                                _692 = _588;
                                _693 = _589;
                            }
                            if (_597)
                            {
                                _559 = _662;
                                _560 = _663;
                                _561 = _664;
                                _562 = _666;
                                _563 = _667;
                                _564 = _668;
                                _565 = _669;
                                _566 = _670;
                                _567 = _671;
                                _568 = _672;
                                _569 = _673;
                                _570 = _674;
                                _571 = _675;
                                _572 = _676;
                                _573 = _677;
                                _574 = _678;
                                _575 = _679;
                                _576 = _680;
                                _577 = _681;
                                _578 = _682;
                                _579 = _683;
                                _580 = _684;
                                _581 = _685;
                                _582 = _686;
                                _583 = _687;
                                _584 = _688;
                                _585 = _689;
                                _586 = _690;
                                _587 = _691;
                                _588 = _692;
                                _589 = _693;
                                _590 = _597;
                                _591 = _597;
                                _592 = _665;
                                continue;
                            }
                            else
                            {
                                break;
                            }
                        }
                        uint _694 = _663 + 1u;
                        uint _706;
                        if (_531 && (_536 >= uintBitsToFloat(_528)))
                        {
                            _706 = (((1u << bitfieldExtract((srt_flatbuf_1.data[24u] + 31u) - _664, int(0u), int(4u))) - 1u) << 0u) + _694;
                        }
                        else
                        {
                            _706 = _694;
                        }
                        uint _708 = 65535u & (_664 + 1u);
                        uint _710 = _708 | (_706 << 16u);
                        uint _711 = _665 + 1u;
                        bool _750;
                        uint _815;
                        uint _816;
                        uint _817;
                        uint _818;
                        uint _819;
                        uint _820;
                        uint _821;
                        uint _822;
                        uint _823;
                        uint _824;
                        uint _825;
                        uint _826;
                        uint _827;
                        uint _828;
                        uint _829;
                        uint _830;
                        uint _831;
                        uint _832;
                        uint _833;
                        uint _834;
                        uint _835;
                        uint _836;
                        uint _837;
                        uint _838;
                        uint _839;
                        uint _840;
                        uint _841;
                        uint _842;
                        uint _843;
                        uint _844;
                        uint _845;
                        uint _846;
                        uint _712 = _663;
                        uint _713 = _664;
                        uint _714 = _665;
                        uint _715 = _666;
                        uint _716 = _667;
                        uint _717 = _668;
                        uint _718 = _669;
                        uint _719 = _670;
                        uint _720 = _671;
                        uint _721 = _672;
                        uint _722 = _673;
                        uint _723 = _674;
                        uint _724 = _675;
                        uint _725 = _676;
                        uint _726 = _677;
                        uint _727 = _708;
                        uint _728 = _710;
                        uint _729 = _680;
                        uint _730 = _681;
                        uint _731 = _682;
                        uint _732 = _683;
                        uint _733 = _684;
                        uint _734 = _685;
                        uint _735 = _686;
                        uint _736 = _687;
                        uint _737 = _688;
                        uint _738 = _689;
                        uint _739 = _690;
                        uint _740 = _691;
                        uint _741 = _692;
                        uint _742 = _693;
                        bool _743 = _531;
                        bool _744 = _531;
                        uint _745 = _711;
                        for (;;)
                        {
                            uint _746 = subgroupBroadcastFirst(_745);
                            bool _748 = _743 && (_746 == _745);
                            _750 = _744 && (!_748);
                            if (_748)
                            {
                                _815 = (_746 == 31u) ? _728 : _745;
                                _816 = (_746 == 30u) ? _728 : _712;
                                _817 = (_746 == 29u) ? _728 : _713;
                                _818 = (_746 == 28u) ? _728 : _714;
                                _819 = (_746 == 27u) ? _728 : _715;
                                _820 = (_746 == 26u) ? _728 : _716;
                                _821 = (_746 == 25u) ? _728 : _717;
                                _822 = (_746 == 24u) ? _728 : _718;
                                _823 = (_746 == 23u) ? _728 : _719;
                                _824 = (_746 == 22u) ? _728 : _720;
                                _825 = (_746 == 21u) ? _728 : _721;
                                _826 = (_746 == 20u) ? _728 : _722;
                                _827 = (_746 == 19u) ? _728 : _723;
                                _828 = (_746 == 18u) ? _728 : _724;
                                _829 = (_746 == 17u) ? _728 : _725;
                                _830 = (_746 == 16u) ? _728 : _726;
                                _831 = (_746 == 15u) ? _728 : _727;
                                _832 = (_746 == 14u) ? _728 : _728;
                                _833 = (_746 == 13u) ? _728 : _729;
                                _834 = (_746 == 12u) ? _728 : _730;
                                _835 = (_746 == 11u) ? _728 : _731;
                                _836 = (_746 == 10u) ? _728 : _732;
                                _837 = (_746 == 9u) ? _728 : _733;
                                _838 = (_746 == 8u) ? _728 : _734;
                                _839 = (_746 == 7u) ? _728 : _735;
                                _840 = (_746 == 6u) ? _728 : _736;
                                _841 = (_746 == 5u) ? _728 : _737;
                                _842 = (_746 == 4u) ? _728 : _738;
                                _843 = (_746 == 3u) ? _728 : _739;
                                _844 = (_746 == 2u) ? _728 : _740;
                                _845 = (_746 == 1u) ? _728 : _741;
                                _846 = (_746 == 0u) ? _728 : _742;
                            }
                            else
                            {
                                _815 = _745;
                                _816 = _712;
                                _817 = _713;
                                _818 = _714;
                                _819 = _715;
                                _820 = _716;
                                _821 = _717;
                                _822 = _718;
                                _823 = _719;
                                _824 = _720;
                                _825 = _721;
                                _826 = _722;
                                _827 = _723;
                                _828 = _724;
                                _829 = _725;
                                _830 = _726;
                                _831 = _727;
                                _832 = _728;
                                _833 = _729;
                                _834 = _730;
                                _835 = _731;
                                _836 = _732;
                                _837 = _733;
                                _838 = _734;
                                _839 = _735;
                                _840 = _736;
                                _841 = _737;
                                _842 = _738;
                                _843 = _739;
                                _844 = _740;
                                _845 = _741;
                                _846 = _742;
                            }
                            if (_750)
                            {
                                _712 = _816;
                                _713 = _817;
                                _714 = _818;
                                _715 = _819;
                                _716 = _820;
                                _717 = _821;
                                _718 = _822;
                                _719 = _823;
                                _720 = _824;
                                _721 = _825;
                                _722 = _826;
                                _723 = _827;
                                _724 = _828;
                                _725 = _829;
                                _726 = _830;
                                _727 = _831;
                                _728 = _832;
                                _729 = _833;
                                _730 = _834;
                                _731 = _835;
                                _732 = _836;
                                _733 = _837;
                                _734 = _838;
                                _735 = _839;
                                _736 = _840;
                                _737 = _841;
                                _738 = _842;
                                _739 = _843;
                                _740 = _844;
                                _741 = _845;
                                _742 = _846;
                                _743 = _750;
                                _744 = _750;
                                _745 = _815;
                                continue;
                            }
                            else
                            {
                                break;
                            }
                        }
                        _847 = _816;
                        _848 = _817;
                        _849 = _819;
                        _850 = _820;
                        _851 = _821;
                        _852 = _822;
                        _853 = _823;
                        _854 = _824;
                        _855 = 1u;
                        _856 = _826;
                        _857 = _827;
                        _858 = _828;
                        _859 = _829;
                        _860 = _830;
                        _861 = _831;
                        _862 = _832;
                        _863 = _833;
                        _864 = _834;
                        _865 = _835;
                        _866 = _836;
                        _867 = _837;
                        _868 = _838;
                        _869 = _839;
                        _870 = _840;
                        _871 = _841;
                        _872 = _842;
                        _873 = _843;
                        _874 = _844;
                        _875 = _845;
                        _876 = _846;
                        _877 = _815;
                    }
                    else
                    {
                        _847 = _322;
                        _848 = _321;
                        _849 = _522;
                        _850 = _523;
                        _851 = _524;
                        _852 = _198;
                        _853 = _525;
                        _854 = _526;
                        _855 = _527;
                        _856 = _202;
                        _857 = _203;
                        _858 = _204;
                        _859 = _520;
                        _860 = _521;
                        _861 = _528;
                        _862 = _529;
                        _863 = _209;
                        _864 = _210;
                        _865 = _211;
                        _866 = _212;
                        _867 = _213;
                        _868 = _214;
                        _869 = _215;
                        _870 = _216;
                        _871 = _217;
                        _872 = _218;
                        _873 = _219;
                        _874 = _220;
                        _875 = _221;
                        _876 = _222;
                        _877 = _347;
                    }
                    _878 = _847;
                    _879 = _848;
                    _880 = _849;
                    _881 = _850;
                    _882 = _851;
                    _883 = _852;
                    _884 = _853;
                    _885 = _854;
                    _886 = _855;
                    _887 = _856;
                    _888 = _857;
                    _889 = _858;
                    _890 = _859;
                    _891 = _860;
                    _892 = _861;
                    _893 = _862;
                    _894 = _863;
                    _895 = _864;
                    _896 = _865;
                    _897 = _866;
                    _898 = _867;
                    _899 = _868;
                    _900 = _869;
                    _901 = _870;
                    _902 = _871;
                    _903 = _872;
                    _904 = _873;
                    _905 = _874;
                    _906 = _875;
                    _907 = _876;
                    _908 = _877;
                }
                else
                {
                    _878 = _322;
                    _879 = _321;
                    _880 = _195;
                    _881 = _196;
                    _882 = _197;
                    _883 = _198;
                    _884 = _374;
                    _885 = _345;
                    _886 = _201;
                    _887 = _202;
                    _888 = _203;
                    _889 = _204;
                    _890 = _340;
                    _891 = _373;
                    _892 = _338;
                    _893 = _337;
                    _894 = _209;
                    _895 = _210;
                    _896 = _211;
                    _897 = _212;
                    _898 = _213;
                    _899 = _214;
                    _900 = _215;
                    _901 = _216;
                    _902 = _217;
                    _903 = _218;
                    _904 = _219;
                    _905 = _220;
                    _906 = _221;
                    _907 = _222;
                    _908 = _347;
                }
                if (true)
                {
                    _192 = _908;
                    _193 = _878;
                    _194 = _879;
                    _195 = _880;
                    _196 = _881;
                    _197 = _882;
                    _198 = _883;
                    _199 = _884;
                    _200 = _885;
                    _201 = _886;
                    _202 = _887;
                    _203 = _888;
                    _204 = _889;
                    _205 = _890;
                    _206 = _891;
                    _207 = _892;
                    _208 = _893;
                    _209 = _894;
                    _210 = _895;
                    _211 = _896;
                    _212 = _897;
                    _213 = _898;
                    _214 = _899;
                    _215 = _900;
                    _216 = _901;
                    _217 = _902;
                    _218 = _903;
                    _219 = _904;
                    _220 = _905;
                    _221 = _906;
                    _222 = _907;
                    _223 = _226;
                    _224 = _908;
                    continue;
                }
                else
                {
                    _909 = _883;
                    _910 = _882;
                    _911 = _887;
                    _912 = _889;
                    _913 = _881;
                    _914 = _880;
                    break;
                }
            }
        }
        uint _917 = ((_914 + 1u) * 4u) + buf2_dword_off;
        uvec4 _929 = uvec4(ssbo_3_1.data[_917], ssbo_3_1.data[_917 + 1u], ssbo_3_1.data[_917 + 2u], ssbo_3_1.data[_917 + 3u]);
        uint _934 = (_914 * 4u) + buf2_dword_off;
        uvec4 _946 = uvec4(ssbo_3_1.data[_934], ssbo_3_1.data[_934 + 1u], ssbo_3_1.data[_934 + 2u], ssbo_3_1.data[_934 + 3u]);
        uint _947 = _946.x;
        uint _948 = _946.z;
        uint _949 = _946.w;
        precise float _959 = uintBitsToFloat(_929.z) - uintBitsToFloat(_948);
        precise float _962 = uintBitsToFloat(_912) - uintBitsToFloat(_947);
        precise float _965 = uintBitsToFloat(_929.x) - uintBitsToFloat(_947);
        precise float _968 = uintBitsToFloat(_911) - uintBitsToFloat(_948);
        precise float _971 = uintBitsToFloat(_929.w) - uintBitsToFloat(_949);
        precise float _972 = _962 * _959;
        precise float _973 = _965 * _968;
        precise float _976 = uintBitsToFloat(_910) * _971;
        precise float _977 = _976 + uintBitsToFloat(_949);
        bool _978 = _973 < _972;
        precise float _980 = uintBitsToFloat(srt_flatbuf_1.data[26u]) * _977;
        float _982 = _978 ? 3.1415920257568359375 : 0.0;
        precise float _984 = 6.283184051513671875 * _980;
        precise float _986 = _984 * 3.0;
        precise float _987 = _986 + _982;
        precise float _989 = _984 * 7.0;
        precise float _990 = _989 + _982;
        precise float _992 = 0.15915493667125701904296875 * _987;
        precise float _993 = 0.15915493667125701904296875 * _990;
        precise float _1000 = sin(6.283185482025146484375 * fract(_992)) + sin(6.283185482025146484375 * fract(_993));
        precise float _1002 = uintBitsToFloat(srt_flatbuf_1.data[25u]) * _1000;
        precise float _1004 = 0.5 * _1002;
        precise float _1005 = _1004 + sqrt(uintBitsToFloat(_913));
        float _1006 = max(0.0, _1005);
        uint _1009 = uint(_977);
        precise float _1011 = uintBitsToFloat(push_data.ud_regs0.y) * (_978 ? (-_1006) : _1006);
        uint _1014 = uint(int(_1011));
        precise float _1015 = _977 - float(bitfieldExtract(_1009, int(0u), int(8u)));
        precise float _1023 = 256.0 * _1015;
        if (_176 && (push_data.ud_regs1.x > _909))
        {
            ssbo_4_1.data[(_909 * 21u) + (bitfieldExtract(push_data.buf_offsets0.x, int(24u), int(8u)) >> 2u)] = (bitfieldExtract(255u & uint(_1023), int(0u), int(24u)) * 256u) + ((uint(max(int(uint(min(int(32767u), int(_1014)))), int(uint(min(int(uint(max(int(32767u), int(_1014)))), int(4294934530u)))))) << 16u) | (255u & _1009));
        }
    }
}

