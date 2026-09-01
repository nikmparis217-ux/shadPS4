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
layout(local_size_x = 8, local_size_y = 8, local_size_z = 16) in;

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

layout(binding = 2, std430) buffer ssbo_shmem
{
    uint64_t data[];
} ssbo_shmem_1;

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

uniform sampler2DArray SPIRV_Cross_Combinedcs_img16cs_sampsgpr_24;
uniform sampler2DArray SPIRV_Cross_Combinedcs_img0cs_sampsgpr_24;

void main()
{
    uint workgroup_index = (gl_WorkGroupID.x + (gl_WorkGroupID.y * gl_NumWorkGroups.x)) + (gl_WorkGroupID.z * (gl_NumWorkGroups.x * gl_NumWorkGroups.y));
    uint buf0_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(0u), int(8u)) >> 2u;
    uint buf1_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(8u), int(8u)) >> 2u;
    uint _135 = 72u + buf0_dword_off;
    uint _143 = 75u + buf0_dword_off;
    uint _147 = 79u + buf0_dword_off;
    uint _151 = 80u + buf0_dword_off;
    uint _155 = 81u + buf0_dword_off;
    uint _159 = 82u + buf0_dword_off;
    uint _162 = ssbo_1_1.data[_135] << 3u;
    float _167 = float(gl_LocalInvocationID.x + (_162 * (gl_LocalInvocationID.z >> 2u)));
    float _168 = float(gl_LocalInvocationID.y + (_162 * (3u & gl_LocalInvocationID.z)));
    precise float _175 = uintBitsToFloat(ssbo_1_1.data[_143]) * fma(0.125, _167, 0.0625);
    precise float _177 = _175 + 1.0;
    precise float _179 = uintBitsToFloat(ssbo_1_1.data[_143]) * fma(0.125, _168, 0.0625);
    precise float _180 = _179 + 1.0;
    float _181 = float(ssbo_1_1.data[73u + buf0_dword_off]);
    uint _521;
    bool _523;
    uint _505;
    uint _506;
    uint _507;
    uint _508;
    uint _509;
    uint _510;
    uint _511;
    uint _512;
    uint _513;
    uint _514;
    uint _515;
    uint _516;
    uint _517;
    uint _518;
    uint _519;
    uint _520;
    uint _182 = 0u;
    uint _183 = 0u;
    uint _184 = 0u;
    uint _185 = 0u;
    uint _186 = 0u;
    uint _187 = 0u;
    uint _188 = 0u;
    uint _189 = 0u;
    uint _190 = 0u;
    uint _191 = 0u;
    uint _192 = 0u;
    uint _193 = 0u;
    uint _194 = 0u;
    uint _195 = 0u;
    uint _196 = 0u;
    uint _197 = 0u;
    uint _198 = 0u;
    for (;;)
    {
        float _199 = float(_198);
        uint _201 = _198 * 16u;
        uint _206 = _201 >> 2u;
        uint _207 = _206 + buf0_dword_off;
        uint _211 = (_206 + 1u) + buf0_dword_off;
        uint _215 = (_206 + 2u) + buf0_dword_off;
        uint _218 = (_201 + 96u) >> 2u;
        uint _219 = _218 + buf0_dword_off;
        uint _223 = (_218 + 1u) + buf0_dword_off;
        uint _227 = (_218 + 2u) + buf0_dword_off;
        uint _230 = (_201 + 192u) >> 2u;
        uint _242 = floatBitsToUint(_180);
        precise float _244 = uintBitsToFloat(ssbo_1_1.data[_207]) * _167;
        precise float _246 = uintBitsToFloat(ssbo_1_1.data[_211]) * _167;
        precise float _248 = uintBitsToFloat(ssbo_1_1.data[_215]) * _167;
        precise float _250 = uintBitsToFloat(ssbo_1_1.data[_219]) * _168;
        precise float _251 = _250 + _244;
        precise float _253 = uintBitsToFloat(ssbo_1_1.data[_223]) * _168;
        precise float _254 = _253 + _246;
        precise float _256 = uintBitsToFloat(ssbo_1_1.data[_227]) * _168;
        precise float _257 = _256 + _248;
        precise float _259 = 0.125 * _251;
        precise float _260 = _259 + uintBitsToFloat(ssbo_1_1.data[_230 + buf0_dword_off]);
        uint _261 = floatBitsToUint(_260);
        precise float _263 = 0.125 * _254;
        precise float _264 = _263 + uintBitsToFloat(ssbo_1_1.data[(_230 + 1u) + buf0_dword_off]);
        uint _265 = floatBitsToUint(_264);
        precise float _267 = 0.125 * _257;
        precise float _268 = _267 + uintBitsToFloat(ssbo_1_1.data[(_230 + 2u) + buf0_dword_off]);
        uint _269 = floatBitsToUint(_268);
        uint _491;
        uint _492;
        uint _496;
        uint _500;
        uint _504;
        uint _472;
        uint _473;
        uint _474;
        uint _475;
        uint _476;
        uint _477;
        uint _478;
        uint _479;
        uint _480;
        uint _481;
        uint _482;
        uint _483;
        uint _484;
        uint _485;
        uint _486;
        uint _487;
        uint _270 = _182;
        uint _271 = _183;
        uint _272 = _184;
        uint _273 = _185;
        uint _274 = _186;
        uint _275 = _187;
        uint _276 = _188;
        uint _277 = _189;
        uint _278 = _190;
        uint _279 = _191;
        uint _280 = _192;
        uint _281 = _193;
        uint _282 = _194;
        uint _283 = _195;
        uint _284 = _196;
        uint _285 = _197;
        uint _286 = _242;
        uint _287 = _269;
        uint _288 = _265;
        uint _289 = _261;
        uint _290 = 0u;
        for (;;)
        {
            if (!(_290 < ssbo_1_1.data[_135]))
            {
                _505 = _274;
                _506 = _275;
                _507 = _276;
                _508 = _277;
                _509 = _278;
                _510 = _279;
                _511 = _280;
                _512 = _281;
                _513 = _282;
                _514 = _283;
                _515 = _284;
                _516 = _285;
                _517 = _270;
                _518 = _271;
                _519 = _272;
                _520 = _273;
                break;
            }
            else
            {
                uint _293 = floatBitsToUint(_177);
                uint _375;
                uint _379;
                uint _383;
                uint _387;
                uint _391;
                uint _395;
                uint _399;
                uint _403;
                uint _407;
                uint _411;
                uint _415;
                uint _419;
                uint _455;
                uint _459;
                uint _463;
                uint _467;
                uint _471;
                uint _451;
                uint _452;
                uint _453;
                uint _454;
                uint _294 = _270;
                uint _295 = _271;
                uint _296 = _272;
                uint _297 = _273;
                uint _298 = _274;
                uint _299 = _275;
                uint _300 = _276;
                uint _301 = _277;
                uint _302 = _278;
                uint _303 = _279;
                uint _304 = _280;
                uint _305 = _281;
                uint _306 = _282;
                uint _307 = _283;
                uint _308 = _284;
                uint _309 = _285;
                uint _310 = _287;
                uint _311 = _288;
                uint _312 = _289;
                uint _313 = _293;
                uint _314 = 0u;
                for (;;)
                {
                    if (!(_314 < ssbo_1_1.data[_135]))
                    {
                        _472 = _298;
                        _473 = _299;
                        _474 = _300;
                        _475 = _301;
                        _476 = _302;
                        _477 = _303;
                        _478 = _304;
                        _479 = _305;
                        _480 = _306;
                        _481 = _307;
                        _482 = _308;
                        _483 = _309;
                        _484 = _294;
                        _485 = _295;
                        _486 = _296;
                        _487 = _297;
                        break;
                    }
                    else
                    {
                        precise float _319 = uintBitsToFloat(_313) - 1.0;
                        precise float _320 = uintBitsToFloat(_286) - 1.0;
                        precise float _322 = _199 / 8.0;
                        precise float _334 = uintBitsToFloat(_313) - 1.0;
                        precise float _335 = uintBitsToFloat(_286) - 1.0;
                        precise float _336 = _199 / 8.0;
                        vec4 _343 = textureLod(SPIRV_Cross_Combinedcs_img0cs_sampsgpr_24, vec3(_334, _335, fma(floor(_336), -2.0, _199)), _181);
                        float _344 = _343.x;
                        float _345 = _343.y;
                        float _346 = _343.z;
                        precise float _349 = uintBitsToFloat(_312) * uintBitsToFloat(_312);
                        precise float _352 = uintBitsToFloat(_311) * uintBitsToFloat(_311);
                        precise float _353 = _352 + _349;
                        precise float _356 = uintBitsToFloat(_310) * uintBitsToFloat(_310);
                        precise float _357 = _356 + _353;
                        float _358 = inversesqrt(_357);
                        precise float _360 = _358 * (1.0 / _357);
                        precise float _362 = _358 * uintBitsToFloat(_312);
                        precise float _364 = _358 * uintBitsToFloat(_311);
                        precise float _366 = _358 * uintBitsToFloat(_310);
                        bool _368 = uintBitsToFloat(ssbo_1_1.data[_147]) > textureLod(SPIRV_Cross_Combinedcs_img16cs_sampsgpr_24, vec3(_319, _320, fma(floor(_322), -2.0, _199)), 0.0).x;
                        precise float _369 = _344 * _360;
                        precise float _370 = _345 * _360;
                        precise float _371 = _346 * _360;
                        precise float _373 = _360 * _346;
                        precise float _374 = _373 + uintBitsToFloat(_309);
                        _375 = floatBitsToUint(_374);
                        precise float _377 = _366 * _371;
                        precise float _378 = _377 + uintBitsToFloat(_306);
                        _379 = floatBitsToUint(_378);
                        precise float _381 = _364 * _371;
                        precise float _382 = _381 + uintBitsToFloat(_307);
                        _383 = floatBitsToUint(_382);
                        precise float _385 = _362 * _371;
                        precise float _386 = _385 + uintBitsToFloat(_308);
                        _387 = floatBitsToUint(_386);
                        precise float _389 = _360 * _345;
                        precise float _390 = _389 + uintBitsToFloat(_305);
                        _391 = floatBitsToUint(_390);
                        precise float _393 = _366 * _370;
                        precise float _394 = _393 + uintBitsToFloat(_302);
                        _395 = floatBitsToUint(_394);
                        precise float _397 = _364 * _370;
                        precise float _398 = _397 + uintBitsToFloat(_303);
                        _399 = floatBitsToUint(_398);
                        precise float _401 = _362 * _370;
                        precise float _402 = _401 + uintBitsToFloat(_304);
                        _403 = floatBitsToUint(_402);
                        precise float _405 = _360 * _344;
                        precise float _406 = _405 + uintBitsToFloat(_301);
                        _407 = floatBitsToUint(_406);
                        precise float _409 = _366 * _369;
                        precise float _410 = _409 + uintBitsToFloat(_298);
                        _411 = floatBitsToUint(_410);
                        precise float _413 = _364 * _369;
                        precise float _414 = _413 + uintBitsToFloat(_299);
                        _415 = floatBitsToUint(_414);
                        precise float _417 = _362 * _369;
                        precise float _418 = _417 + uintBitsToFloat(_300);
                        _419 = floatBitsToUint(_418);
                        if (_368)
                        {
                            precise float _421 = uintBitsToFloat(ssbo_1_1.data[_151]) * _362;
                            precise float _423 = uintBitsToFloat(ssbo_1_1.data[_155]) * _364;
                            precise float _424 = _423 + _421;
                            precise float _426 = uintBitsToFloat(ssbo_1_1.data[_159]) * _366;
                            precise float _427 = _426 + _424;
                            uint _447;
                            uint _448;
                            uint _449;
                            uint _450;
                            if (_368 && (0.0 < _427))
                            {
                                precise float _430 = _427 * _360;
                                precise float _432 = _360 * _427;
                                precise float _433 = _432 + uintBitsToFloat(_297);
                                precise float _436 = _366 * _430;
                                precise float _437 = _436 + uintBitsToFloat(_294);
                                precise float _440 = _364 * _430;
                                precise float _441 = _440 + uintBitsToFloat(_295);
                                precise float _444 = _362 * _430;
                                precise float _445 = _444 + uintBitsToFloat(_296);
                                _447 = floatBitsToUint(_437);
                                _448 = floatBitsToUint(_441);
                                _449 = floatBitsToUint(_445);
                                _450 = floatBitsToUint(_433);
                            }
                            else
                            {
                                _447 = _294;
                                _448 = _295;
                                _449 = _296;
                                _450 = _297;
                            }
                            _451 = _447;
                            _452 = _448;
                            _453 = _449;
                            _454 = _450;
                        }
                        else
                        {
                            _451 = _294;
                            _452 = _295;
                            _453 = _296;
                            _454 = _297;
                        }
                        _455 = _314 + 1u;
                        precise float _458 = uintBitsToFloat(ssbo_1_1.data[_143]) + uintBitsToFloat(_313);
                        _459 = floatBitsToUint(_458);
                        precise float _462 = uintBitsToFloat(ssbo_1_1.data[_207]) + uintBitsToFloat(_312);
                        _463 = floatBitsToUint(_462);
                        precise float _466 = uintBitsToFloat(ssbo_1_1.data[_211]) + uintBitsToFloat(_311);
                        _467 = floatBitsToUint(_466);
                        precise float _470 = uintBitsToFloat(ssbo_1_1.data[_215]) + uintBitsToFloat(_310);
                        _471 = floatBitsToUint(_470);
                        if (true)
                        {
                            _294 = _451;
                            _295 = _452;
                            _296 = _453;
                            _297 = _454;
                            _298 = _411;
                            _299 = _415;
                            _300 = _419;
                            _301 = _407;
                            _302 = _395;
                            _303 = _399;
                            _304 = _403;
                            _305 = _391;
                            _306 = _379;
                            _307 = _383;
                            _308 = _387;
                            _309 = _375;
                            _310 = _471;
                            _311 = _467;
                            _312 = _463;
                            _313 = _459;
                            _314 = _455;
                            continue;
                        }
                        else
                        {
                            _472 = _411;
                            _473 = _415;
                            _474 = _419;
                            _475 = _407;
                            _476 = _395;
                            _477 = _399;
                            _478 = _403;
                            _479 = _391;
                            _480 = _379;
                            _481 = _383;
                            _482 = _387;
                            _483 = _375;
                            _484 = _451;
                            _485 = _452;
                            _486 = _453;
                            _487 = _454;
                            break;
                        }
                    }
                }
                precise float _490 = uintBitsToFloat(ssbo_1_1.data[_143]) + uintBitsToFloat(_286);
                _491 = floatBitsToUint(_490);
                _492 = _290 + 1u;
                precise float _495 = uintBitsToFloat(ssbo_1_1.data[_219]) + uintBitsToFloat(_289);
                _496 = floatBitsToUint(_495);
                precise float _499 = uintBitsToFloat(ssbo_1_1.data[_223]) + uintBitsToFloat(_288);
                _500 = floatBitsToUint(_499);
                precise float _503 = uintBitsToFloat(ssbo_1_1.data[_227]) + uintBitsToFloat(_287);
                _504 = floatBitsToUint(_503);
                if (true)
                {
                    _270 = _484;
                    _271 = _485;
                    _272 = _486;
                    _273 = _487;
                    _274 = _472;
                    _275 = _473;
                    _276 = _474;
                    _277 = _475;
                    _278 = _476;
                    _279 = _477;
                    _280 = _478;
                    _281 = _479;
                    _282 = _480;
                    _283 = _481;
                    _284 = _482;
                    _285 = _483;
                    _286 = _491;
                    _287 = _504;
                    _288 = _500;
                    _289 = _496;
                    _290 = _492;
                    continue;
                }
                else
                {
                    _505 = _472;
                    _506 = _473;
                    _507 = _474;
                    _508 = _475;
                    _509 = _476;
                    _510 = _477;
                    _511 = _478;
                    _512 = _479;
                    _513 = _480;
                    _514 = _481;
                    _515 = _482;
                    _516 = _483;
                    _517 = _484;
                    _518 = _485;
                    _519 = _486;
                    _520 = _487;
                    break;
                }
            }
        }
        _521 = _198 + 1u;
        _523 = _521 < 6u;
        if (_523)
        {
            _182 = _517;
            _183 = _518;
            _184 = _519;
            _185 = _520;
            _186 = _505;
            _187 = _506;
            _188 = _507;
            _189 = _508;
            _190 = _509;
            _191 = _510;
            _192 = _511;
            _193 = _512;
            _194 = _513;
            _195 = _514;
            _196 = _515;
            _197 = _516;
            _198 = _521;
            continue;
        }
        else
        {
            break;
        }
    }
    uint _531 = (bitfieldExtract(gl_LocalInvocationID.z, int(0u), int(24u)) * 64u) + ((bitfieldExtract(gl_LocalInvocationID.y, int(0u), int(24u)) * 8u) + gl_LocalInvocationID.x);
    uint _532 = _531 << 6u;
    ssbo_shmem_1.data[_532 + (workgroup_index * 65536u)] = packUint2x32(uvec2(_508, _507));
    ssbo_shmem_1.data[(_532 + 8u) + (workgroup_index * 65536u)] = packUint2x32(uvec2(_506, _505));
    ssbo_shmem_1.data[(_532 + 16u) + (workgroup_index * 65536u)] = packUint2x32(uvec2(_512, _511));
    ssbo_shmem_1.data[(_532 + 24u) + (workgroup_index * 65536u)] = packUint2x32(uvec2(_510, _509));
    ssbo_shmem_1.data[(_532 + 32u) + (workgroup_index * 65536u)] = packUint2x32(uvec2(_516, _515));
    ssbo_shmem_1.data[(_532 + 40u) + (workgroup_index * 65536u)] = packUint2x32(uvec2(_514, _513));
    ssbo_shmem_1.data[(_532 + 48u) + (workgroup_index * 65536u)] = packUint2x32(uvec2(_520, _519));
    ssbo_shmem_1.data[(_532 + 56u) + (workgroup_index * 65536u)] = packUint2x32(uvec2(_518, _517));
    barrier();
    bool _588 = (0u != gl_LocalInvocationID.x) || (0u != gl_LocalInvocationID.y);
    if (!_588)
    {
        precise float _680;
        uint _681;
        precise float _684;
        uint _685;
        precise float _688;
        uint _689;
        precise float _692;
        uint _693;
        precise float _696;
        uint _697;
        precise float _700;
        uint _701;
        precise float _704;
        uint _705;
        precise float _708;
        uint _709;
        precise float _712;
        uint _713;
        precise float _716;
        uint _717;
        precise float _720;
        uint _721;
        precise float _724;
        uint _725;
        precise float _728;
        uint _729;
        precise float _732;
        uint _733;
        precise float _736;
        uint _737;
        precise float _740;
        uint _741;
        uint _742;
        uint _743;
        bool _745;
        uint _591 = _505;
        uint _592 = _506;
        uint _593 = _507;
        uint _594 = _508;
        uint _595 = _509;
        uint _596 = _510;
        uint _597 = _511;
        uint _598 = _512;
        uint _599 = _513;
        uint _600 = _514;
        uint _601 = _515;
        uint _602 = _516;
        uint _603 = _517;
        uint _604 = _518;
        uint _605 = _519;
        uint _606 = _520;
        uint _607 = _531;
        uint _608 = 1u;
        for (;;)
        {
            uint _609 = _607 << 6u;
            uvec2 _616 = unpackUint2x32(ssbo_shmem_1.data[(_609 + 112u) + (workgroup_index * 65536u)]);
            uvec2 _625 = unpackUint2x32(ssbo_shmem_1.data[(_609 + 120u) + (workgroup_index * 65536u)]);
            uvec2 _633 = unpackUint2x32(ssbo_shmem_1.data[(_609 + 96u) + (workgroup_index * 65536u)]);
            uvec2 _642 = unpackUint2x32(ssbo_shmem_1.data[(_609 + 104u) + (workgroup_index * 65536u)]);
            uvec2 _650 = unpackUint2x32(ssbo_shmem_1.data[(_609 + 80u) + (workgroup_index * 65536u)]);
            uvec2 _659 = unpackUint2x32(ssbo_shmem_1.data[(_609 + 88u) + (workgroup_index * 65536u)]);
            uvec2 _667 = unpackUint2x32(ssbo_shmem_1.data[(_609 + 64u) + (workgroup_index * 65536u)]);
            uvec2 _675 = unpackUint2x32(ssbo_shmem_1.data[(_609 + 72u) + (workgroup_index * 65536u)]);
            _680 = uintBitsToFloat(_625.y) + uintBitsToFloat(_603);
            _681 = floatBitsToUint(_680);
            _684 = uintBitsToFloat(_625.x) + uintBitsToFloat(_604);
            _685 = floatBitsToUint(_684);
            _688 = uintBitsToFloat(_616.y) + uintBitsToFloat(_605);
            _689 = floatBitsToUint(_688);
            _692 = uintBitsToFloat(_616.x) + uintBitsToFloat(_606);
            _693 = floatBitsToUint(_692);
            _696 = uintBitsToFloat(_642.y) + uintBitsToFloat(_599);
            _697 = floatBitsToUint(_696);
            _700 = uintBitsToFloat(_642.x) + uintBitsToFloat(_600);
            _701 = floatBitsToUint(_700);
            _704 = uintBitsToFloat(_633.y) + uintBitsToFloat(_601);
            _705 = floatBitsToUint(_704);
            _708 = uintBitsToFloat(_633.x) + uintBitsToFloat(_602);
            _709 = floatBitsToUint(_708);
            _712 = uintBitsToFloat(_659.y) + uintBitsToFloat(_595);
            _713 = floatBitsToUint(_712);
            _716 = uintBitsToFloat(_659.x) + uintBitsToFloat(_596);
            _717 = floatBitsToUint(_716);
            _720 = uintBitsToFloat(_650.y) + uintBitsToFloat(_597);
            _721 = floatBitsToUint(_720);
            _724 = uintBitsToFloat(_650.x) + uintBitsToFloat(_598);
            _725 = floatBitsToUint(_724);
            _728 = uintBitsToFloat(_675.y) + uintBitsToFloat(_591);
            _729 = floatBitsToUint(_728);
            _732 = uintBitsToFloat(_675.x) + uintBitsToFloat(_592);
            _733 = floatBitsToUint(_732);
            _736 = uintBitsToFloat(_667.y) + uintBitsToFloat(_593);
            _737 = floatBitsToUint(_736);
            _740 = uintBitsToFloat(_667.x) + uintBitsToFloat(_594);
            _741 = floatBitsToUint(_740);
            _742 = _607 + 1u;
            _743 = _608 + 1u;
            _745 = int(_608) < int(63u);
            if (_745)
            {
                _591 = _729;
                _592 = _733;
                _593 = _737;
                _594 = _741;
                _595 = _713;
                _596 = _717;
                _597 = _721;
                _598 = _725;
                _599 = _697;
                _600 = _701;
                _601 = _705;
                _602 = _709;
                _603 = _681;
                _604 = _685;
                _605 = _689;
                _606 = _693;
                _607 = _742;
                _608 = _743;
                continue;
            }
            else
            {
                break;
            }
        }
        uint _747 = gl_LocalInvocationID.z << 12u;
        ssbo_shmem_1.data[_747 + (workgroup_index * 65536u)] = packUint2x32(uvec2(_741, _737));
        ssbo_shmem_1.data[(_747 + 8u) + (workgroup_index * 65536u)] = packUint2x32(uvec2(_733, _729));
        ssbo_shmem_1.data[(_747 + 16u) + (workgroup_index * 65536u)] = packUint2x32(uvec2(_725, _721));
        ssbo_shmem_1.data[(_747 + 24u) + (workgroup_index * 65536u)] = packUint2x32(uvec2(_717, _713));
        ssbo_shmem_1.data[(_747 + 32u) + (workgroup_index * 65536u)] = packUint2x32(uvec2(_709, _705));
        ssbo_shmem_1.data[(_747 + 40u) + (workgroup_index * 65536u)] = packUint2x32(uvec2(_701, _697));
        ssbo_shmem_1.data[(_747 + 48u) + (workgroup_index * 65536u)] = packUint2x32(uvec2(_693, _689));
        ssbo_shmem_1.data[(_747 + 56u) + (workgroup_index * 65536u)] = packUint2x32(uvec2(_685, _681));
        barrier();
        if ((!_588) && (0u == gl_LocalInvocationID.z))
        {
            uvec2 _802 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 4096u]);
            uvec2 _810 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 4104u]);
            uvec2 _818 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 8192u]);
            uvec2 _826 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 8200u]);
            uvec2 _834 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 12288u]);
            uvec2 _842 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 12296u]);
            precise float _847 = uintBitsToFloat(_802.x) + uintBitsToFloat(_818.x);
            precise float _850 = uintBitsToFloat(_810.y) + uintBitsToFloat(_826.y);
            precise float _853 = uintBitsToFloat(_810.x) + uintBitsToFloat(_826.x);
            precise float _856 = uintBitsToFloat(_802.y) + uintBitsToFloat(_818.y);
            precise float _858 = _847 + uintBitsToFloat(_834.x);
            precise float _860 = _850 + uintBitsToFloat(_842.y);
            precise float _862 = _853 + uintBitsToFloat(_842.x);
            precise float _864 = _856 + uintBitsToFloat(_834.y);
            uvec2 _870 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 16384u]);
            uvec2 _878 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 16392u]);
            uvec2 _886 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 20480u]);
            uvec2 _894 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 20488u]);
            precise float _898 = _858 + uintBitsToFloat(_870.x);
            precise float _900 = _860 + uintBitsToFloat(_878.y);
            precise float _902 = _862 + uintBitsToFloat(_878.x);
            precise float _904 = _864 + uintBitsToFloat(_870.y);
            precise float _906 = _898 + uintBitsToFloat(_886.x);
            precise float _908 = _900 + uintBitsToFloat(_894.y);
            precise float _910 = _902 + uintBitsToFloat(_894.x);
            precise float _912 = _904 + uintBitsToFloat(_886.y);
            uvec2 _918 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 24576u]);
            uvec2 _926 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 24584u]);
            uvec2 _934 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 28672u]);
            uvec2 _942 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 28680u]);
            precise float _946 = _906 + uintBitsToFloat(_918.x);
            precise float _948 = _908 + uintBitsToFloat(_926.y);
            precise float _950 = _910 + uintBitsToFloat(_926.x);
            precise float _952 = _912 + uintBitsToFloat(_918.y);
            precise float _954 = _946 + uintBitsToFloat(_934.x);
            precise float _956 = _948 + uintBitsToFloat(_942.y);
            precise float _958 = _950 + uintBitsToFloat(_942.x);
            precise float _960 = _952 + uintBitsToFloat(_934.y);
            uvec2 _966 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 32768u]);
            uvec2 _974 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 32776u]);
            uvec2 _982 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 36864u]);
            uvec2 _990 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 36872u]);
            precise float _994 = _954 + uintBitsToFloat(_966.x);
            precise float _996 = _956 + uintBitsToFloat(_974.y);
            precise float _998 = _958 + uintBitsToFloat(_974.x);
            precise float _1000 = _960 + uintBitsToFloat(_966.y);
            precise float _1002 = _994 + uintBitsToFloat(_982.x);
            precise float _1004 = _996 + uintBitsToFloat(_990.y);
            precise float _1006 = _998 + uintBitsToFloat(_990.x);
            precise float _1008 = _1000 + uintBitsToFloat(_982.y);
            uvec2 _1014 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 40960u]);
            uvec2 _1022 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 40968u]);
            uvec2 _1030 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 45056u]);
            uvec2 _1038 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 45064u]);
            precise float _1042 = _1002 + uintBitsToFloat(_1014.x);
            precise float _1044 = _1004 + uintBitsToFloat(_1022.y);
            precise float _1046 = _1006 + uintBitsToFloat(_1022.x);
            precise float _1048 = _1008 + uintBitsToFloat(_1014.y);
            precise float _1050 = _1042 + uintBitsToFloat(_1030.x);
            precise float _1052 = _1044 + uintBitsToFloat(_1038.y);
            precise float _1054 = _1046 + uintBitsToFloat(_1038.x);
            precise float _1056 = _1048 + uintBitsToFloat(_1030.y);
            uvec2 _1062 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 49152u]);
            uvec2 _1070 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 49160u]);
            uvec2 _1078 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 53248u]);
            uvec2 _1086 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 53256u]);
            precise float _1090 = _1050 + uintBitsToFloat(_1062.x);
            precise float _1092 = _1052 + uintBitsToFloat(_1070.y);
            precise float _1094 = _1054 + uintBitsToFloat(_1070.x);
            precise float _1096 = _1056 + uintBitsToFloat(_1062.y);
            uvec2 _1102 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 57344u]);
            uvec2 _1110 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 57352u]);
            precise float _1114 = _1090 + uintBitsToFloat(_1078.x);
            precise float _1116 = _1094 + uintBitsToFloat(_1086.x);
            precise float _1118 = _1092 + uintBitsToFloat(_1086.y);
            precise float _1120 = _1116 + uintBitsToFloat(_1110.x);
            precise float _1122 = _1114 + uintBitsToFloat(_1102.x);
            precise float _1124 = _1096 + uintBitsToFloat(_1078.y);
            uvec2 _1130 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 61440u]);
            uvec2 _1138 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 61448u]);
            precise float _1142 = _1124 + uintBitsToFloat(_1102.y);
            precise float _1144 = _1118 + uintBitsToFloat(_1110.y);
            precise float _1146 = _1122 + uintBitsToFloat(_1130.x);
            precise float _1148 = _1144 + uintBitsToFloat(_1138.y);
            uvec2 _1154 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 4112u]);
            uvec2 _1162 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 4120u]);
            precise float _1166 = _1142 + uintBitsToFloat(_1130.y);
            precise float _1168 = _1120 + uintBitsToFloat(_1138.x);
            precise float _1169 = _1146 + _740;
            precise float _1170 = _1148 + _728;
            precise float _1171 = _1168 + _732;
            uvec2 _1177 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 8208u]);
            uvec2 _1185 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 8216u]);
            precise float _1188 = _1166 + _736;
            uvec2 _1194 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 12304u]);
            uvec2 _1202 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 12312u]);
            precise float _1207 = uintBitsToFloat(_1154.x) + uintBitsToFloat(_1177.x);
            precise float _1210 = uintBitsToFloat(_1162.y) + uintBitsToFloat(_1185.y);
            precise float _1213 = uintBitsToFloat(_1162.x) + uintBitsToFloat(_1185.x);
            precise float _1216 = uintBitsToFloat(_1154.y) + uintBitsToFloat(_1177.y);
            precise float _1218 = _1207 + uintBitsToFloat(_1194.x);
            precise float _1220 = _1210 + uintBitsToFloat(_1202.y);
            precise float _1222 = _1213 + uintBitsToFloat(_1202.x);
            precise float _1224 = _1216 + uintBitsToFloat(_1194.y);
            uvec2 _1230 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 16400u]);
            uvec2 _1238 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 16408u]);
            uvec2 _1246 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 20496u]);
            uvec2 _1254 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 20504u]);
            precise float _1258 = _1218 + uintBitsToFloat(_1230.x);
            precise float _1260 = _1220 + uintBitsToFloat(_1238.y);
            precise float _1262 = _1222 + uintBitsToFloat(_1238.x);
            precise float _1264 = _1224 + uintBitsToFloat(_1230.y);
            precise float _1266 = _1258 + uintBitsToFloat(_1246.x);
            precise float _1268 = _1260 + uintBitsToFloat(_1254.y);
            precise float _1270 = _1262 + uintBitsToFloat(_1254.x);
            precise float _1272 = _1264 + uintBitsToFloat(_1246.y);
            uvec2 _1278 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 24592u]);
            uvec2 _1286 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 24600u]);
            uvec2 _1294 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 28688u]);
            uvec2 _1302 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 28696u]);
            precise float _1306 = _1266 + uintBitsToFloat(_1278.x);
            precise float _1308 = _1268 + uintBitsToFloat(_1286.y);
            precise float _1310 = _1270 + uintBitsToFloat(_1286.x);
            precise float _1312 = _1272 + uintBitsToFloat(_1278.y);
            precise float _1314 = _1306 + uintBitsToFloat(_1294.x);
            precise float _1316 = _1308 + uintBitsToFloat(_1302.y);
            precise float _1318 = _1310 + uintBitsToFloat(_1302.x);
            precise float _1320 = _1312 + uintBitsToFloat(_1294.y);
            uvec2 _1326 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 32784u]);
            uvec2 _1334 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 32792u]);
            uvec2 _1342 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 36880u]);
            uvec2 _1350 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 36888u]);
            precise float _1354 = _1314 + uintBitsToFloat(_1326.x);
            precise float _1356 = _1316 + uintBitsToFloat(_1334.y);
            precise float _1358 = _1318 + uintBitsToFloat(_1334.x);
            precise float _1360 = _1320 + uintBitsToFloat(_1326.y);
            precise float _1362 = _1354 + uintBitsToFloat(_1342.x);
            precise float _1364 = _1356 + uintBitsToFloat(_1350.y);
            precise float _1366 = _1358 + uintBitsToFloat(_1350.x);
            precise float _1368 = _1360 + uintBitsToFloat(_1342.y);
            uvec2 _1374 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 40976u]);
            uvec2 _1382 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 40984u]);
            uvec2 _1390 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 45072u]);
            uvec2 _1398 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 45080u]);
            precise float _1402 = _1362 + uintBitsToFloat(_1374.x);
            precise float _1404 = _1364 + uintBitsToFloat(_1382.y);
            precise float _1406 = _1366 + uintBitsToFloat(_1382.x);
            precise float _1408 = _1368 + uintBitsToFloat(_1374.y);
            precise float _1410 = _1402 + uintBitsToFloat(_1390.x);
            precise float _1412 = _1404 + uintBitsToFloat(_1398.y);
            precise float _1414 = _1406 + uintBitsToFloat(_1398.x);
            precise float _1416 = _1408 + uintBitsToFloat(_1390.y);
            uvec2 _1422 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 49168u]);
            uvec2 _1430 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 49176u]);
            uvec2 _1438 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 53264u]);
            uvec2 _1446 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 53272u]);
            precise float _1450 = _1410 + uintBitsToFloat(_1422.x);
            precise float _1452 = _1412 + uintBitsToFloat(_1430.y);
            precise float _1454 = _1414 + uintBitsToFloat(_1430.x);
            precise float _1456 = _1416 + uintBitsToFloat(_1422.y);
            uvec2 _1462 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 57360u]);
            uvec2 _1470 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 57368u]);
            precise float _1474 = _1450 + uintBitsToFloat(_1438.x);
            precise float _1476 = _1454 + uintBitsToFloat(_1446.x);
            precise float _1478 = _1452 + uintBitsToFloat(_1446.y);
            precise float _1480 = _1476 + uintBitsToFloat(_1470.x);
            precise float _1482 = _1474 + uintBitsToFloat(_1462.x);
            precise float _1484 = _1456 + uintBitsToFloat(_1438.y);
            uvec2 _1490 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 61456u]);
            uvec2 _1498 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 61464u]);
            precise float _1502 = _1484 + uintBitsToFloat(_1462.y);
            precise float _1504 = _1478 + uintBitsToFloat(_1470.y);
            precise float _1506 = _1482 + uintBitsToFloat(_1490.x);
            precise float _1508 = _1504 + uintBitsToFloat(_1498.y);
            uvec2 _1514 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 4128u]);
            uvec2 _1522 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 4136u]);
            precise float _1526 = _1502 + uintBitsToFloat(_1490.y);
            precise float _1528 = _1480 + uintBitsToFloat(_1498.x);
            precise float _1529 = _1506 + _724;
            precise float _1530 = _1508 + _712;
            precise float _1531 = _1528 + _716;
            uvec2 _1537 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 8224u]);
            uvec2 _1545 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 8232u]);
            uint _1549 = 74u + buf0_dword_off;
            uint _1551 = ssbo_1_1.data[_1549];
            precise float _1552 = _1526 + _720;
            uvec2 _1558 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 12320u]);
            uvec2 _1566 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 12328u]);
            precise float _1571 = uintBitsToFloat(_1514.x) + uintBitsToFloat(_1537.x);
            precise float _1574 = uintBitsToFloat(_1522.y) + uintBitsToFloat(_1545.y);
            precise float _1577 = uintBitsToFloat(_1522.x) + uintBitsToFloat(_1545.x);
            precise float _1580 = uintBitsToFloat(_1514.y) + uintBitsToFloat(_1537.y);
            precise float _1582 = _1571 + uintBitsToFloat(_1558.x);
            precise float _1584 = _1574 + uintBitsToFloat(_1566.y);
            precise float _1586 = _1577 + uintBitsToFloat(_1566.x);
            precise float _1588 = _1580 + uintBitsToFloat(_1558.y);
            uvec2 _1594 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 16416u]);
            uvec2 _1602 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 16424u]);
            uvec2 _1610 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 20512u]);
            uvec2 _1618 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 20520u]);
            precise float _1622 = _1582 + uintBitsToFloat(_1594.x);
            precise float _1624 = _1584 + uintBitsToFloat(_1602.y);
            precise float _1626 = _1586 + uintBitsToFloat(_1602.x);
            precise float _1628 = _1588 + uintBitsToFloat(_1594.y);
            precise float _1630 = _1622 + uintBitsToFloat(_1610.x);
            precise float _1632 = _1624 + uintBitsToFloat(_1618.y);
            precise float _1634 = _1626 + uintBitsToFloat(_1618.x);
            precise float _1636 = _1628 + uintBitsToFloat(_1610.y);
            uvec2 _1642 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 24608u]);
            uvec2 _1650 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 24616u]);
            uvec2 _1658 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 28704u]);
            uvec2 _1666 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 28712u]);
            precise float _1670 = _1630 + uintBitsToFloat(_1642.x);
            precise float _1672 = _1632 + uintBitsToFloat(_1650.y);
            precise float _1674 = _1634 + uintBitsToFloat(_1650.x);
            precise float _1676 = _1636 + uintBitsToFloat(_1642.y);
            precise float _1678 = _1670 + uintBitsToFloat(_1658.x);
            precise float _1680 = _1672 + uintBitsToFloat(_1666.y);
            precise float _1682 = _1674 + uintBitsToFloat(_1666.x);
            precise float _1684 = _1676 + uintBitsToFloat(_1658.y);
            uvec2 _1690 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 32800u]);
            uvec2 _1698 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 32808u]);
            uvec2 _1706 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 36896u]);
            uvec2 _1714 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 36904u]);
            precise float _1718 = _1678 + uintBitsToFloat(_1690.x);
            precise float _1720 = _1680 + uintBitsToFloat(_1698.y);
            precise float _1722 = _1682 + uintBitsToFloat(_1698.x);
            precise float _1724 = _1684 + uintBitsToFloat(_1690.y);
            precise float _1726 = _1718 + uintBitsToFloat(_1706.x);
            precise float _1728 = _1720 + uintBitsToFloat(_1714.y);
            precise float _1730 = _1722 + uintBitsToFloat(_1714.x);
            precise float _1732 = _1724 + uintBitsToFloat(_1706.y);
            uvec2 _1738 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 40992u]);
            uvec2 _1746 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 41000u]);
            uvec2 _1754 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 45088u]);
            uvec2 _1762 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 45096u]);
            precise float _1766 = _1726 + uintBitsToFloat(_1738.x);
            precise float _1768 = _1728 + uintBitsToFloat(_1746.y);
            precise float _1770 = _1730 + uintBitsToFloat(_1746.x);
            precise float _1772 = _1732 + uintBitsToFloat(_1738.y);
            precise float _1774 = _1768 + uintBitsToFloat(_1762.y);
            precise float _1776 = _1770 + uintBitsToFloat(_1762.x);
            precise float _1778 = _1772 + uintBitsToFloat(_1754.y);
            precise float _1780 = _1766 + uintBitsToFloat(_1754.x);
            uvec2 _1786 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 49184u]);
            uvec2 _1794 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 49192u]);
            uvec2 _1802 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 53280u]);
            uvec2 _1810 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 53288u]);
            precise float _1814 = _1776 + uintBitsToFloat(_1794.x);
            precise float _1816 = _1778 + uintBitsToFloat(_1786.y);
            precise float _1818 = _1780 + uintBitsToFloat(_1786.x);
            precise float _1820 = _1774 + uintBitsToFloat(_1794.y);
            precise float _1822 = _1818 + uintBitsToFloat(_1802.x);
            precise float _1824 = _1820 + uintBitsToFloat(_1810.y);
            precise float _1826 = _1814 + uintBitsToFloat(_1810.x);
            precise float _1828 = _1816 + uintBitsToFloat(_1802.y);
            uvec2 _1834 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 57376u]);
            uvec2 _1842 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 57384u]);
            uvec2 _1850 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 61472u]);
            uvec2 _1858 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 61480u]);
            uint _1862 = 76u + buf0_dword_off;
            uint _1866 = 77u + buf0_dword_off;
            uint _1870 = 78u + buf0_dword_off;
            uint _1872 = ssbo_1_1.data[_1870];
            precise float _1874 = _1822 + uintBitsToFloat(_1834.x);
            precise float _1876 = _1874 + uintBitsToFloat(_1850.x);
            precise float _1878 = _1824 + uintBitsToFloat(_1842.y);
            precise float _1880 = _1878 + uintBitsToFloat(_1858.y);
            precise float _1882 = _1828 + uintBitsToFloat(_1834.y);
            precise float _1884 = _1826 + uintBitsToFloat(_1842.x);
            precise float _1886 = _1882 + uintBitsToFloat(_1850.y);
            precise float _1887 = _1876 + _708;
            precise float _1889 = _1884 + uintBitsToFloat(_1858.x);
            uvec2 _1895 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 4144u]);
            uvec2 _1903 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 4152u]);
            precise float _1907 = uintBitsToFloat(ssbo_1_1.data[_1862]) * _1169;
            precise float _1910 = uintBitsToFloat(ssbo_1_1.data[_1866]) * _1170;
            precise float _1913 = uintBitsToFloat(ssbo_1_1.data[_1866]) * _1171;
            precise float _1916 = uintBitsToFloat(ssbo_1_1.data[_1866]) * _1188;
            precise float _1918 = _1880 + _696;
            uvec2 _1924 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 8240u]);
            uvec2 _1932 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 8248u]);
            precise float _1935 = _1889 + _700;
            precise float _1936 = _1886 + _704;
            uvec2 _1942 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 12336u]);
            uvec2 _1950 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 12344u]);
            precise float _1955 = uintBitsToFloat(_1903.y) + uintBitsToFloat(_1932.y);
            precise float _1958 = uintBitsToFloat(_1895.x) + uintBitsToFloat(_1924.x);
            precise float _1961 = uintBitsToFloat(_1903.x) + uintBitsToFloat(_1932.x);
            precise float _1964 = uintBitsToFloat(_1895.y) + uintBitsToFloat(_1924.y);
            precise float _1966 = _1955 + uintBitsToFloat(_1950.y);
            precise float _1968 = _1958 + uintBitsToFloat(_1942.x);
            precise float _1970 = uintBitsToFloat(ssbo_1_1.data[_1862]) * _1529;
            precise float _1973 = _1964 + uintBitsToFloat(_1942.y);
            precise float _1975 = uintBitsToFloat(ssbo_1_1.data[_1866]) * _1530;
            precise float _1978 = uintBitsToFloat(ssbo_1_1.data[_1862]) * _1887;
            precise float _1981 = _1961 + uintBitsToFloat(_1950.x);
            uvec2 _1987 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 16432u]);
            uvec2 _1995 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 16440u]);
            uvec2 _2003 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 20528u]);
            uvec2 _2011 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 20536u]);
            precise float _2015 = _1981 + uintBitsToFloat(_1995.x);
            precise float _2017 = _1973 + uintBitsToFloat(_1987.y);
            precise float _2019 = _1968 + uintBitsToFloat(_1987.x);
            precise float _2021 = _1966 + uintBitsToFloat(_1995.y);
            precise float _2023 = _2021 + uintBitsToFloat(_2011.y);
            precise float _2025 = _2015 + uintBitsToFloat(_2011.x);
            precise float _2027 = _2017 + uintBitsToFloat(_2003.y);
            uvec2 _2033 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 24624u]);
            uvec2 _2041 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 24632u]);
            precise float _2045 = _2019 + uintBitsToFloat(_2003.x);
            uvec2 _2051 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 28720u]);
            uvec2 _2059 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 28728u]);
            precise float _2063 = _2025 + uintBitsToFloat(_2041.x);
            precise float _2065 = _2027 + uintBitsToFloat(_2033.y);
            precise float _2067 = _2065 + uintBitsToFloat(_2051.y);
            precise float _2069 = _2045 + uintBitsToFloat(_2033.x);
            precise float _2071 = _2023 + uintBitsToFloat(_2041.y);
            precise float _2073 = _2071 + uintBitsToFloat(_2059.y);
            precise float _2075 = _2063 + uintBitsToFloat(_2059.x);
            uvec2 _2081 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 32816u]);
            uvec2 _2089 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 32824u]);
            precise float _2093 = _2069 + uintBitsToFloat(_2051.x);
            uvec2 _2099 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 36912u]);
            uvec2 _2107 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 36920u]);
            precise float _2111 = _2075 + uintBitsToFloat(_2089.x);
            precise float _2113 = _2067 + uintBitsToFloat(_2081.y);
            precise float _2115 = _2111 + uintBitsToFloat(_2107.x);
            precise float _2117 = _2113 + uintBitsToFloat(_2099.y);
            precise float _2119 = _2093 + uintBitsToFloat(_2081.x);
            precise float _2121 = _2073 + uintBitsToFloat(_2089.y);
            precise float _2123 = _2121 + uintBitsToFloat(_2107.y);
            uvec2 _2129 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 41008u]);
            uvec2 _2137 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 41016u]);
            precise float _2141 = _2119 + uintBitsToFloat(_2099.x);
            uvec2 _2147 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 45104u]);
            uvec2 _2155 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 45112u]);
            precise float _2159 = _2115 + uintBitsToFloat(_2137.x);
            precise float _2161 = _2117 + uintBitsToFloat(_2129.y);
            precise float _2163 = _2159 + uintBitsToFloat(_2155.x);
            precise float _2165 = _2161 + uintBitsToFloat(_2147.y);
            precise float _2167 = _2141 + uintBitsToFloat(_2129.x);
            precise float _2169 = _2123 + uintBitsToFloat(_2137.y);
            precise float _2171 = _2169 + uintBitsToFloat(_2155.y);
            uvec2 _2177 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 49200u]);
            uvec2 _2185 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 49208u]);
            precise float _2189 = _2167 + uintBitsToFloat(_2147.x);
            uvec2 _2195 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 53296u]);
            uvec2 _2203 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 53304u]);
            precise float _2207 = _2171 + uintBitsToFloat(_2185.y);
            precise float _2209 = _2163 + uintBitsToFloat(_2185.x);
            precise float _2211 = _2165 + uintBitsToFloat(_2177.y);
            precise float _2213 = _2189 + uintBitsToFloat(_2177.x);
            precise float _2215 = _2213 + uintBitsToFloat(_2195.x);
            precise float _2217 = _2207 + uintBitsToFloat(_2203.y);
            uvec2 _2223 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 57392u]);
            uvec2 _2231 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 57400u]);
            precise float _2235 = _2209 + uintBitsToFloat(_2203.x);
            precise float _2237 = _2211 + uintBitsToFloat(_2195.y);
            uvec2 _2243 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 61488u]);
            uvec2 _2251 = unpackUint2x32(ssbo_shmem_1.data[(workgroup_index * 65536u) + 61496u]);
            precise float _2255 = uintBitsToFloat(ssbo_1_1.data[_1866]) * _1552;
            precise float _2258 = _2215 + uintBitsToFloat(_2223.x);
            precise float _2260 = _2217 + uintBitsToFloat(_2231.y);
            precise float _2262 = _2237 + uintBitsToFloat(_2223.y);
            precise float _2264 = _2235 + uintBitsToFloat(_2231.x);
            precise float _2266 = _2258 + uintBitsToFloat(_2243.x);
            precise float _2268 = _2260 + uintBitsToFloat(_2251.y);
            precise float _2270 = _2264 + uintBitsToFloat(_2251.x);
            precise float _2272 = _2262 + uintBitsToFloat(_2243.y);
            precise float _2273 = _2266 + _692;
            precise float _2274 = _2268 + _680;
            precise float _2275 = _2270 + _684;
            precise float _2276 = _2272 + _688;
            precise float _2278 = uintBitsToFloat(ssbo_1_1.data[_1866]) * _1531;
            precise float _2281 = uintBitsToFloat(ssbo_1_1.data[_1866]) * _1918;
            precise float _2284 = uintBitsToFloat(ssbo_1_1.data[_1866]) * _1935;
            precise float _2287 = uintBitsToFloat(ssbo_1_1.data[_1866]) * _1936;
            uvec4 _2289 = uvec4(floatBitsToUint(_1907), floatBitsToUint(_1916), floatBitsToUint(_1913), floatBitsToUint(_1910));
            uint _2291 = (_1551 * 16u) + buf1_dword_off;
            ssbo_2_1.data[_2291] = _2289.x;
            ssbo_2_1.data[_2291 + 1u] = _2289.y;
            ssbo_2_1.data[_2291 + 2u] = _2289.z;
            ssbo_2_1.data[_2291 + 3u] = _2289.w;
            precise float _2304 = uintBitsToFloat(_1872) * _2273;
            precise float _2307 = uintBitsToFloat(_1872) * _2274;
            precise float _2310 = uintBitsToFloat(_1872) * _2275;
            precise float _2313 = uintBitsToFloat(_1872) * _2276;
            uvec4 _2315 = uvec4(floatBitsToUint(_1970), floatBitsToUint(_2255), floatBitsToUint(_2278), floatBitsToUint(_1975));
            uint _2319 = ((_1551 * 16u) + 4u) + buf1_dword_off;
            ssbo_2_1.data[_2319] = _2315.x;
            ssbo_2_1.data[_2319 + 1u] = _2315.y;
            ssbo_2_1.data[_2319 + 2u] = _2315.z;
            ssbo_2_1.data[_2319 + 3u] = _2315.w;
            uvec4 _2331 = uvec4(floatBitsToUint(_1978), floatBitsToUint(_2287), floatBitsToUint(_2284), floatBitsToUint(_2281));
            uint _2334 = ((_1551 * 16u) + 8u) + buf1_dword_off;
            ssbo_2_1.data[_2334] = _2331.x;
            ssbo_2_1.data[_2334 + 1u] = _2331.y;
            ssbo_2_1.data[_2334 + 2u] = _2331.z;
            ssbo_2_1.data[_2334 + 3u] = _2331.w;
            uvec4 _2346 = uvec4(floatBitsToUint(_2304), floatBitsToUint(_2313), floatBitsToUint(_2310), floatBitsToUint(_2307));
            uint _2349 = ((_1551 * 16u) + 12u) + buf1_dword_off;
            ssbo_2_1.data[_2349] = _2346.x;
            ssbo_2_1.data[_2349 + 1u] = _2346.y;
            ssbo_2_1.data[_2349 + 2u] = _2346.z;
            ssbo_2_1.data[_2349 + 3u] = _2346.w;
        }
    }
}

