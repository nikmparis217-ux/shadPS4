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
layout(local_size_x = 8, local_size_y = 8, local_size_z = 8) in;

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

layout(binding = 9) uniform writeonly image2DArray cs_img80;
uniform sampler2DArray SPIRV_Cross_Combinedcs_img16SPIRV_Cross_DummySampler;
uniform sampler2DArray SPIRV_Cross_Combinedcs_img16cs_sampsgpr_0;
uniform sampler2DArray SPIRV_Cross_Combinedcs_img24SPIRV_Cross_DummySampler;
uniform sampler2DArray SPIRV_Cross_Combinedcs_img24cs_sampsgpr_0;
uniform sampler2DArray SPIRV_Cross_Combinedcs_img32SPIRV_Cross_DummySampler;
uniform sampler2DArray SPIRV_Cross_Combinedcs_img32cs_sampsgpr_0;
uniform sampler2D SPIRV_Cross_Combinedcs_img40SPIRV_Cross_DummySampler;
uniform sampler2D SPIRV_Cross_Combinedcs_img40cs_sampsgpr_0;
uniform sampler2D SPIRV_Cross_Combinedcs_img48SPIRV_Cross_DummySampler;
uniform sampler2D SPIRV_Cross_Combinedcs_img48cs_sampsgpr_0;
uniform sampler2D SPIRV_Cross_Combinedcs_img56SPIRV_Cross_DummySampler;
uniform sampler2D SPIRV_Cross_Combinedcs_img56cs_sampsgpr_0;
uniform sampler2D SPIRV_Cross_Combinedcs_img64SPIRV_Cross_DummySampler;
uniform sampler2D SPIRV_Cross_Combinedcs_img64cs_sampsgpr_0;
uniform sampler2D SPIRV_Cross_Combinedcs_img72SPIRV_Cross_DummySampler;
uniform sampler2D SPIRV_Cross_Combinedcs_img72cs_sampsgpr_0;

void main()
{
    uint buf0_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(0u), int(8u)) >> 2u;
    uint _194 = (gl_WorkGroupID.y << 3u) + gl_LocalInvocationID.y;
    uint _195 = (gl_WorkGroupID.z << 3u) + gl_LocalInvocationID.z;
    uint _197 = uint(uintBitsToFloat(ssbo_1_1.data[2u + buf0_dword_off]));
    uint _199 = uint(uintBitsToFloat(ssbo_1_1.data[3u + buf0_dword_off]));
    uint _200 = (gl_WorkGroupID.x << 3u) + gl_LocalInvocationID.x;
    uint _202 = uint(uintBitsToFloat(ssbo_1_1.data[1u + buf0_dword_off]));
    bool _207 = (_200 < _202) && ((_194 < _197) && (_195 < _199));
    if (_207)
    {
        uint _209 = 20u + buf0_dword_off;
        uint _213 = 21u + buf0_dword_off;
        uint _217 = 22u + buf0_dword_off;
        uint _221 = 23u + buf0_dword_off;
        uint _241 = 5u + buf0_dword_off;
        uint _245 = 6u + buf0_dword_off;
        uint _249 = 9u + buf0_dword_off;
        uint _253 = 10u + buf0_dword_off;
        uint _335;
        uint _336;
        uint _337;
        uint _338;
        if (0.0 != uintBitsToFloat(ssbo_1_1.data[_209]))
        {
            bool _262 = (_200 < _202) && ((_194 < _197) && (_195 < _199));
            bool _263 = 1u != ssbo_1_1.data[12u + buf0_dword_off];
            uint _289;
            uint _290;
            uint _291;
            uint _292;
            bool _293;
            if (_263)
            {
                uint _285;
                uint _286;
                uint _287;
                uint _288;
                if (_207 && _262)
                {
                    vec4 _268 = texelFetch(SPIRV_Cross_Combinedcs_img16SPIRV_Cross_DummySampler, ivec3(uvec3(_200, _194, _195)), 0);
                    precise float _274 = uintBitsToFloat(ssbo_1_1.data[_209]) * _268.x;
                    precise float _277 = uintBitsToFloat(ssbo_1_1.data[_209]) * _268.y;
                    precise float _280 = uintBitsToFloat(ssbo_1_1.data[_209]) * _268.z;
                    precise float _283 = uintBitsToFloat(ssbo_1_1.data[_209]) * _268.w;
                    _285 = floatBitsToUint(_283);
                    _286 = floatBitsToUint(_280);
                    _287 = floatBitsToUint(_277);
                    _288 = floatBitsToUint(_274);
                }
                else
                {
                    _285 = 0u;
                    _286 = 0u;
                    _287 = 0u;
                    _288 = 0u;
                }
                _289 = _285;
                _290 = _286;
                _291 = _287;
                _292 = _288;
                _293 = _207;
            }
            else
            {
                _289 = 0u;
                _290 = 0u;
                _291 = 0u;
                _292 = 0u;
                _293 = _262;
            }
            uint _331;
            uint _332;
            uint _333;
            uint _334;
            if (!_263)
            {
                uint _327;
                uint _328;
                uint _329;
                uint _330;
                if (_207 && _293)
                {
                    precise float _299 = uintBitsToFloat(ssbo_1_1.data[_241]) * float(_200);
                    precise float _300 = _299 + uintBitsToFloat(ssbo_1_1.data[_249]);
                    precise float _303 = uintBitsToFloat(ssbo_1_1.data[_245]) * float(_194);
                    precise float _304 = _303 + uintBitsToFloat(ssbo_1_1.data[_253]);
                    vec4 _310 = textureLod(SPIRV_Cross_Combinedcs_img16cs_sampsgpr_0, vec3(_300, _304, float(_195)), 0.0);
                    precise float _316 = uintBitsToFloat(ssbo_1_1.data[_209]) * _310.x;
                    precise float _319 = uintBitsToFloat(ssbo_1_1.data[_209]) * _310.y;
                    precise float _322 = uintBitsToFloat(ssbo_1_1.data[_209]) * _310.z;
                    precise float _325 = uintBitsToFloat(ssbo_1_1.data[_209]) * _310.w;
                    _327 = floatBitsToUint(_325);
                    _328 = floatBitsToUint(_322);
                    _329 = floatBitsToUint(_319);
                    _330 = floatBitsToUint(_316);
                }
                else
                {
                    _327 = _289;
                    _328 = _290;
                    _329 = _291;
                    _330 = _292;
                }
                _331 = _327;
                _332 = _328;
                _333 = _329;
                _334 = _330;
            }
            else
            {
                _331 = _289;
                _332 = _290;
                _333 = _291;
                _334 = _292;
            }
            _335 = _331;
            _336 = _332;
            _337 = _333;
            _338 = _334;
        }
        else
        {
            _335 = 0u;
            _336 = 0u;
            _337 = 0u;
            _338 = 0u;
        }
        uint _434;
        uint _435;
        uint _436;
        uint _437;
        if (0.0 != uintBitsToFloat(ssbo_1_1.data[_213]))
        {
            bool _345 = (_200 < _202) && ((_194 < _197) && (_195 < _199));
            bool _346 = 1u != ssbo_1_1.data[13u + buf0_dword_off];
            uint _380;
            uint _381;
            uint _382;
            uint _383;
            bool _384;
            if (_346)
            {
                uint _376;
                uint _377;
                uint _378;
                uint _379;
                if (_207 && _345)
                {
                    vec4 _351 = texelFetch(SPIRV_Cross_Combinedcs_img24SPIRV_Cross_DummySampler, ivec3(uvec3(_200, _194, _195)), 0);
                    precise float _358 = uintBitsToFloat(ssbo_1_1.data[_213]) * _351.x;
                    precise float _359 = _358 + uintBitsToFloat(_338);
                    precise float _363 = uintBitsToFloat(ssbo_1_1.data[_213]) * _351.y;
                    precise float _364 = _363 + uintBitsToFloat(_337);
                    precise float _368 = uintBitsToFloat(ssbo_1_1.data[_213]) * _351.z;
                    precise float _369 = _368 + uintBitsToFloat(_336);
                    precise float _373 = uintBitsToFloat(ssbo_1_1.data[_213]) * _351.w;
                    precise float _374 = _373 + uintBitsToFloat(_335);
                    _376 = floatBitsToUint(_374);
                    _377 = floatBitsToUint(_369);
                    _378 = floatBitsToUint(_364);
                    _379 = floatBitsToUint(_359);
                }
                else
                {
                    _376 = _335;
                    _377 = _336;
                    _378 = _337;
                    _379 = _338;
                }
                _380 = _376;
                _381 = _377;
                _382 = _378;
                _383 = _379;
                _384 = _207;
            }
            else
            {
                _380 = _335;
                _381 = _336;
                _382 = _337;
                _383 = _338;
                _384 = _345;
            }
            uint _430;
            uint _431;
            uint _432;
            uint _433;
            if (!_346)
            {
                uint _426;
                uint _427;
                uint _428;
                uint _429;
                if (_207 && _384)
                {
                    precise float _390 = uintBitsToFloat(ssbo_1_1.data[_241]) * float(_200);
                    precise float _391 = _390 + uintBitsToFloat(ssbo_1_1.data[_249]);
                    precise float _394 = uintBitsToFloat(ssbo_1_1.data[_245]) * float(_194);
                    precise float _395 = _394 + uintBitsToFloat(ssbo_1_1.data[_253]);
                    vec4 _401 = textureLod(SPIRV_Cross_Combinedcs_img24cs_sampsgpr_0, vec3(_391, _395, float(_195)), 0.0);
                    precise float _408 = uintBitsToFloat(ssbo_1_1.data[_213]) * _401.x;
                    precise float _409 = _408 + uintBitsToFloat(_383);
                    precise float _413 = uintBitsToFloat(ssbo_1_1.data[_213]) * _401.y;
                    precise float _414 = _413 + uintBitsToFloat(_382);
                    precise float _418 = uintBitsToFloat(ssbo_1_1.data[_213]) * _401.z;
                    precise float _419 = _418 + uintBitsToFloat(_381);
                    precise float _423 = uintBitsToFloat(ssbo_1_1.data[_213]) * _401.w;
                    precise float _424 = _423 + uintBitsToFloat(_380);
                    _426 = floatBitsToUint(_424);
                    _427 = floatBitsToUint(_419);
                    _428 = floatBitsToUint(_414);
                    _429 = floatBitsToUint(_409);
                }
                else
                {
                    _426 = _380;
                    _427 = _381;
                    _428 = _382;
                    _429 = _383;
                }
                _430 = _426;
                _431 = _427;
                _432 = _428;
                _433 = _429;
            }
            else
            {
                _430 = _380;
                _431 = _381;
                _432 = _382;
                _433 = _383;
            }
            _434 = _430;
            _435 = _431;
            _436 = _432;
            _437 = _433;
        }
        else
        {
            _434 = _335;
            _435 = _336;
            _436 = _337;
            _437 = _338;
        }
        uint _533;
        uint _534;
        uint _535;
        uint _536;
        if (0.0 != uintBitsToFloat(ssbo_1_1.data[_217]))
        {
            bool _444 = (_200 < _202) && ((_194 < _197) && (_195 < _199));
            bool _445 = 1u != ssbo_1_1.data[14u + buf0_dword_off];
            uint _479;
            uint _480;
            uint _481;
            uint _482;
            bool _483;
            if (_445)
            {
                uint _475;
                uint _476;
                uint _477;
                uint _478;
                if (_207 && _444)
                {
                    vec4 _450 = texelFetch(SPIRV_Cross_Combinedcs_img32SPIRV_Cross_DummySampler, ivec3(uvec3(_200, _194, _195)), 0);
                    precise float _457 = uintBitsToFloat(ssbo_1_1.data[_217]) * _450.x;
                    precise float _458 = _457 + uintBitsToFloat(_437);
                    precise float _462 = uintBitsToFloat(ssbo_1_1.data[_217]) * _450.y;
                    precise float _463 = _462 + uintBitsToFloat(_436);
                    precise float _467 = uintBitsToFloat(ssbo_1_1.data[_217]) * _450.z;
                    precise float _468 = _467 + uintBitsToFloat(_435);
                    precise float _472 = uintBitsToFloat(ssbo_1_1.data[_217]) * _450.w;
                    precise float _473 = _472 + uintBitsToFloat(_434);
                    _475 = floatBitsToUint(_473);
                    _476 = floatBitsToUint(_468);
                    _477 = floatBitsToUint(_463);
                    _478 = floatBitsToUint(_458);
                }
                else
                {
                    _475 = _434;
                    _476 = _435;
                    _477 = _436;
                    _478 = _437;
                }
                _479 = _475;
                _480 = _476;
                _481 = _477;
                _482 = _478;
                _483 = _207;
            }
            else
            {
                _479 = _434;
                _480 = _435;
                _481 = _436;
                _482 = _437;
                _483 = _444;
            }
            uint _529;
            uint _530;
            uint _531;
            uint _532;
            if (!_445)
            {
                uint _525;
                uint _526;
                uint _527;
                uint _528;
                if (_207 && _483)
                {
                    precise float _489 = uintBitsToFloat(ssbo_1_1.data[_241]) * float(_200);
                    precise float _490 = _489 + uintBitsToFloat(ssbo_1_1.data[_249]);
                    precise float _493 = uintBitsToFloat(ssbo_1_1.data[_245]) * float(_194);
                    precise float _494 = _493 + uintBitsToFloat(ssbo_1_1.data[_253]);
                    vec4 _500 = textureLod(SPIRV_Cross_Combinedcs_img32cs_sampsgpr_0, vec3(_490, _494, float(_195)), 0.0);
                    precise float _507 = uintBitsToFloat(ssbo_1_1.data[_217]) * _500.x;
                    precise float _508 = _507 + uintBitsToFloat(_482);
                    precise float _512 = uintBitsToFloat(ssbo_1_1.data[_217]) * _500.y;
                    precise float _513 = _512 + uintBitsToFloat(_481);
                    precise float _517 = uintBitsToFloat(ssbo_1_1.data[_217]) * _500.z;
                    precise float _518 = _517 + uintBitsToFloat(_480);
                    precise float _522 = uintBitsToFloat(ssbo_1_1.data[_217]) * _500.w;
                    precise float _523 = _522 + uintBitsToFloat(_479);
                    _525 = floatBitsToUint(_523);
                    _526 = floatBitsToUint(_518);
                    _527 = floatBitsToUint(_513);
                    _528 = floatBitsToUint(_508);
                }
                else
                {
                    _525 = _479;
                    _526 = _480;
                    _527 = _481;
                    _528 = _482;
                }
                _529 = _525;
                _530 = _526;
                _531 = _527;
                _532 = _528;
            }
            else
            {
                _529 = _479;
                _530 = _480;
                _531 = _481;
                _532 = _482;
            }
            _533 = _529;
            _534 = _530;
            _535 = _531;
            _536 = _532;
        }
        else
        {
            _533 = _434;
            _534 = _435;
            _535 = _436;
            _536 = _437;
        }
        uint _631;
        uint _632;
        uint _633;
        uint _634;
        if (0.0 != uintBitsToFloat(ssbo_1_1.data[_221]))
        {
            bool _543 = (_200 < _202) && ((_194 < _197) && (_195 < _199));
            bool _544 = 1u != ssbo_1_1.data[15u + buf0_dword_off];
            uint _578;
            uint _579;
            uint _580;
            uint _581;
            bool _582;
            if (_544)
            {
                uint _574;
                uint _575;
                uint _576;
                uint _577;
                if (_207 && _543)
                {
                    vec4 _549 = texelFetch(SPIRV_Cross_Combinedcs_img40SPIRV_Cross_DummySampler, ivec2(uvec2(_200, _194)), 0);
                    precise float _556 = uintBitsToFloat(ssbo_1_1.data[_221]) * _549.x;
                    precise float _557 = _556 + uintBitsToFloat(_536);
                    precise float _561 = uintBitsToFloat(ssbo_1_1.data[_221]) * _549.y;
                    precise float _562 = _561 + uintBitsToFloat(_535);
                    precise float _566 = uintBitsToFloat(ssbo_1_1.data[_221]) * _549.z;
                    precise float _567 = _566 + uintBitsToFloat(_534);
                    precise float _571 = uintBitsToFloat(ssbo_1_1.data[_221]) * _549.w;
                    precise float _572 = _571 + uintBitsToFloat(_533);
                    _574 = floatBitsToUint(_572);
                    _575 = floatBitsToUint(_567);
                    _576 = floatBitsToUint(_562);
                    _577 = floatBitsToUint(_557);
                }
                else
                {
                    _574 = _533;
                    _575 = _534;
                    _576 = _535;
                    _577 = _536;
                }
                _578 = _574;
                _579 = _575;
                _580 = _576;
                _581 = _577;
                _582 = _207;
            }
            else
            {
                _578 = _533;
                _579 = _534;
                _580 = _535;
                _581 = _536;
                _582 = _543;
            }
            uint _627;
            uint _628;
            uint _629;
            uint _630;
            if (!_544)
            {
                uint _623;
                uint _624;
                uint _625;
                uint _626;
                if (_207 && _582)
                {
                    precise float _588 = uintBitsToFloat(ssbo_1_1.data[_241]) * float(_200);
                    precise float _589 = _588 + uintBitsToFloat(ssbo_1_1.data[_249]);
                    precise float _592 = uintBitsToFloat(ssbo_1_1.data[_245]) * float(_194);
                    precise float _593 = _592 + uintBitsToFloat(ssbo_1_1.data[_253]);
                    vec4 _598 = textureLod(SPIRV_Cross_Combinedcs_img40cs_sampsgpr_0, vec2(_589, _593), 0.0);
                    precise float _605 = uintBitsToFloat(ssbo_1_1.data[_221]) * _598.x;
                    precise float _606 = _605 + uintBitsToFloat(_581);
                    precise float _610 = uintBitsToFloat(ssbo_1_1.data[_221]) * _598.y;
                    precise float _611 = _610 + uintBitsToFloat(_580);
                    precise float _615 = uintBitsToFloat(ssbo_1_1.data[_221]) * _598.z;
                    precise float _616 = _615 + uintBitsToFloat(_579);
                    precise float _620 = uintBitsToFloat(ssbo_1_1.data[_221]) * _598.w;
                    precise float _621 = _620 + uintBitsToFloat(_578);
                    _623 = floatBitsToUint(_621);
                    _624 = floatBitsToUint(_616);
                    _625 = floatBitsToUint(_611);
                    _626 = floatBitsToUint(_606);
                }
                else
                {
                    _623 = _578;
                    _624 = _579;
                    _625 = _580;
                    _626 = _581;
                }
                _627 = _623;
                _628 = _624;
                _629 = _625;
                _630 = _626;
            }
            else
            {
                _627 = _578;
                _628 = _579;
                _629 = _580;
                _630 = _581;
            }
            _631 = _627;
            _632 = _628;
            _633 = _629;
            _634 = _630;
        }
        else
        {
            _631 = _533;
            _632 = _534;
            _633 = _535;
            _634 = _536;
        }
        uint _636 = 24u + buf0_dword_off;
        uint _640 = 25u + buf0_dword_off;
        uint _644 = 26u + buf0_dword_off;
        uint _648 = 27u + buf0_dword_off;
        uint _761;
        uint _762;
        uint _763;
        uint _764;
        if (0.0 != uintBitsToFloat(ssbo_1_1.data[_636]))
        {
            bool _673 = (_200 < _202) && ((_194 < _197) && (_195 < _199));
            bool _674 = 1u != ssbo_1_1.data[16u + buf0_dword_off];
            uint _708;
            uint _709;
            uint _710;
            uint _711;
            bool _712;
            if (_674)
            {
                uint _704;
                uint _705;
                uint _706;
                uint _707;
                if (_207 && _673)
                {
                    vec4 _679 = texelFetch(SPIRV_Cross_Combinedcs_img48SPIRV_Cross_DummySampler, ivec2(uvec2(_200, _194)), 0);
                    precise float _686 = uintBitsToFloat(ssbo_1_1.data[_636]) * _679.x;
                    precise float _687 = _686 + uintBitsToFloat(_634);
                    precise float _691 = uintBitsToFloat(ssbo_1_1.data[_636]) * _679.y;
                    precise float _692 = _691 + uintBitsToFloat(_633);
                    precise float _696 = uintBitsToFloat(ssbo_1_1.data[_636]) * _679.z;
                    precise float _697 = _696 + uintBitsToFloat(_632);
                    precise float _701 = uintBitsToFloat(ssbo_1_1.data[_636]) * _679.w;
                    precise float _702 = _701 + uintBitsToFloat(_631);
                    _704 = floatBitsToUint(_702);
                    _705 = floatBitsToUint(_697);
                    _706 = floatBitsToUint(_692);
                    _707 = floatBitsToUint(_687);
                }
                else
                {
                    _704 = _631;
                    _705 = _632;
                    _706 = _633;
                    _707 = _634;
                }
                _708 = _704;
                _709 = _705;
                _710 = _706;
                _711 = _707;
                _712 = _207;
            }
            else
            {
                _708 = _631;
                _709 = _632;
                _710 = _633;
                _711 = _634;
                _712 = _673;
            }
            uint _757;
            uint _758;
            uint _759;
            uint _760;
            if (!_674)
            {
                uint _753;
                uint _754;
                uint _755;
                uint _756;
                if (_207 && _712)
                {
                    precise float _718 = uintBitsToFloat(ssbo_1_1.data[_241]) * float(_200);
                    precise float _719 = _718 + uintBitsToFloat(ssbo_1_1.data[_249]);
                    precise float _722 = uintBitsToFloat(ssbo_1_1.data[_245]) * float(_194);
                    precise float _723 = _722 + uintBitsToFloat(ssbo_1_1.data[_253]);
                    vec4 _728 = textureLod(SPIRV_Cross_Combinedcs_img48cs_sampsgpr_0, vec2(_719, _723), 0.0);
                    precise float _735 = uintBitsToFloat(ssbo_1_1.data[_636]) * _728.x;
                    precise float _736 = _735 + uintBitsToFloat(_711);
                    precise float _740 = uintBitsToFloat(ssbo_1_1.data[_636]) * _728.y;
                    precise float _741 = _740 + uintBitsToFloat(_710);
                    precise float _745 = uintBitsToFloat(ssbo_1_1.data[_636]) * _728.z;
                    precise float _746 = _745 + uintBitsToFloat(_709);
                    precise float _750 = uintBitsToFloat(ssbo_1_1.data[_636]) * _728.w;
                    precise float _751 = _750 + uintBitsToFloat(_708);
                    _753 = floatBitsToUint(_751);
                    _754 = floatBitsToUint(_746);
                    _755 = floatBitsToUint(_741);
                    _756 = floatBitsToUint(_736);
                }
                else
                {
                    _753 = _708;
                    _754 = _709;
                    _755 = _710;
                    _756 = _711;
                }
                _757 = _753;
                _758 = _754;
                _759 = _755;
                _760 = _756;
            }
            else
            {
                _757 = _708;
                _758 = _709;
                _759 = _710;
                _760 = _711;
            }
            _761 = _757;
            _762 = _758;
            _763 = _759;
            _764 = _760;
        }
        else
        {
            _761 = _631;
            _762 = _632;
            _763 = _633;
            _764 = _634;
        }
        uint _859;
        uint _860;
        uint _861;
        uint _862;
        if (0.0 != uintBitsToFloat(ssbo_1_1.data[_640]))
        {
            bool _771 = (_200 < _202) && ((_194 < _197) && (_195 < _199));
            bool _772 = 1u != ssbo_1_1.data[17u + buf0_dword_off];
            uint _806;
            uint _807;
            uint _808;
            uint _809;
            bool _810;
            if (_772)
            {
                uint _802;
                uint _803;
                uint _804;
                uint _805;
                if (_207 && _771)
                {
                    vec4 _777 = texelFetch(SPIRV_Cross_Combinedcs_img56SPIRV_Cross_DummySampler, ivec2(uvec2(_200, _194)), 0);
                    precise float _784 = uintBitsToFloat(ssbo_1_1.data[_640]) * _777.x;
                    precise float _785 = _784 + uintBitsToFloat(_764);
                    precise float _789 = uintBitsToFloat(ssbo_1_1.data[_640]) * _777.y;
                    precise float _790 = _789 + uintBitsToFloat(_763);
                    precise float _794 = uintBitsToFloat(ssbo_1_1.data[_640]) * _777.z;
                    precise float _795 = _794 + uintBitsToFloat(_762);
                    precise float _799 = uintBitsToFloat(ssbo_1_1.data[_640]) * _777.w;
                    precise float _800 = _799 + uintBitsToFloat(_761);
                    _802 = floatBitsToUint(_800);
                    _803 = floatBitsToUint(_795);
                    _804 = floatBitsToUint(_790);
                    _805 = floatBitsToUint(_785);
                }
                else
                {
                    _802 = _761;
                    _803 = _762;
                    _804 = _763;
                    _805 = _764;
                }
                _806 = _802;
                _807 = _803;
                _808 = _804;
                _809 = _805;
                _810 = _207;
            }
            else
            {
                _806 = _761;
                _807 = _762;
                _808 = _763;
                _809 = _764;
                _810 = _771;
            }
            uint _855;
            uint _856;
            uint _857;
            uint _858;
            if (!_772)
            {
                uint _851;
                uint _852;
                uint _853;
                uint _854;
                if (_207 && _810)
                {
                    precise float _816 = uintBitsToFloat(ssbo_1_1.data[_241]) * float(_200);
                    precise float _817 = _816 + uintBitsToFloat(ssbo_1_1.data[_249]);
                    precise float _820 = uintBitsToFloat(ssbo_1_1.data[_245]) * float(_194);
                    precise float _821 = _820 + uintBitsToFloat(ssbo_1_1.data[_253]);
                    vec4 _826 = textureLod(SPIRV_Cross_Combinedcs_img56cs_sampsgpr_0, vec2(_817, _821), 0.0);
                    precise float _833 = uintBitsToFloat(ssbo_1_1.data[_640]) * _826.x;
                    precise float _834 = _833 + uintBitsToFloat(_809);
                    precise float _838 = uintBitsToFloat(ssbo_1_1.data[_640]) * _826.y;
                    precise float _839 = _838 + uintBitsToFloat(_808);
                    precise float _843 = uintBitsToFloat(ssbo_1_1.data[_640]) * _826.z;
                    precise float _844 = _843 + uintBitsToFloat(_807);
                    precise float _848 = uintBitsToFloat(ssbo_1_1.data[_640]) * _826.w;
                    precise float _849 = _848 + uintBitsToFloat(_806);
                    _851 = floatBitsToUint(_849);
                    _852 = floatBitsToUint(_844);
                    _853 = floatBitsToUint(_839);
                    _854 = floatBitsToUint(_834);
                }
                else
                {
                    _851 = _806;
                    _852 = _807;
                    _853 = _808;
                    _854 = _809;
                }
                _855 = _851;
                _856 = _852;
                _857 = _853;
                _858 = _854;
            }
            else
            {
                _855 = _806;
                _856 = _807;
                _857 = _808;
                _858 = _809;
            }
            _859 = _855;
            _860 = _856;
            _861 = _857;
            _862 = _858;
        }
        else
        {
            _859 = _761;
            _860 = _762;
            _861 = _763;
            _862 = _764;
        }
        uint _957;
        uint _958;
        uint _959;
        uint _960;
        if (0.0 != uintBitsToFloat(ssbo_1_1.data[_644]))
        {
            bool _869 = (_200 < _202) && ((_194 < _197) && (_195 < _199));
            bool _870 = 1u != ssbo_1_1.data[18u + buf0_dword_off];
            uint _904;
            uint _905;
            uint _906;
            uint _907;
            bool _908;
            if (_870)
            {
                uint _900;
                uint _901;
                uint _902;
                uint _903;
                if (_207 && _869)
                {
                    vec4 _875 = texelFetch(SPIRV_Cross_Combinedcs_img64SPIRV_Cross_DummySampler, ivec2(uvec2(_200, _194)), 0);
                    precise float _882 = uintBitsToFloat(ssbo_1_1.data[_644]) * _875.x;
                    precise float _883 = _882 + uintBitsToFloat(_862);
                    precise float _887 = uintBitsToFloat(ssbo_1_1.data[_644]) * _875.y;
                    precise float _888 = _887 + uintBitsToFloat(_861);
                    precise float _892 = uintBitsToFloat(ssbo_1_1.data[_644]) * _875.z;
                    precise float _893 = _892 + uintBitsToFloat(_860);
                    precise float _897 = uintBitsToFloat(ssbo_1_1.data[_644]) * _875.w;
                    precise float _898 = _897 + uintBitsToFloat(_859);
                    _900 = floatBitsToUint(_898);
                    _901 = floatBitsToUint(_893);
                    _902 = floatBitsToUint(_888);
                    _903 = floatBitsToUint(_883);
                }
                else
                {
                    _900 = _859;
                    _901 = _860;
                    _902 = _861;
                    _903 = _862;
                }
                _904 = _900;
                _905 = _901;
                _906 = _902;
                _907 = _903;
                _908 = _207;
            }
            else
            {
                _904 = _859;
                _905 = _860;
                _906 = _861;
                _907 = _862;
                _908 = _869;
            }
            uint _953;
            uint _954;
            uint _955;
            uint _956;
            if (!_870)
            {
                uint _949;
                uint _950;
                uint _951;
                uint _952;
                if (_207 && _908)
                {
                    precise float _914 = uintBitsToFloat(ssbo_1_1.data[_241]) * float(_200);
                    precise float _915 = _914 + uintBitsToFloat(ssbo_1_1.data[_249]);
                    precise float _918 = uintBitsToFloat(ssbo_1_1.data[_245]) * float(_194);
                    precise float _919 = _918 + uintBitsToFloat(ssbo_1_1.data[_253]);
                    vec4 _924 = textureLod(SPIRV_Cross_Combinedcs_img64cs_sampsgpr_0, vec2(_915, _919), 0.0);
                    precise float _931 = uintBitsToFloat(ssbo_1_1.data[_644]) * _924.x;
                    precise float _932 = _931 + uintBitsToFloat(_907);
                    precise float _936 = uintBitsToFloat(ssbo_1_1.data[_644]) * _924.y;
                    precise float _937 = _936 + uintBitsToFloat(_906);
                    precise float _941 = uintBitsToFloat(ssbo_1_1.data[_644]) * _924.z;
                    precise float _942 = _941 + uintBitsToFloat(_905);
                    precise float _946 = uintBitsToFloat(ssbo_1_1.data[_644]) * _924.w;
                    precise float _947 = _946 + uintBitsToFloat(_904);
                    _949 = floatBitsToUint(_947);
                    _950 = floatBitsToUint(_942);
                    _951 = floatBitsToUint(_937);
                    _952 = floatBitsToUint(_932);
                }
                else
                {
                    _949 = _904;
                    _950 = _905;
                    _951 = _906;
                    _952 = _907;
                }
                _953 = _949;
                _954 = _950;
                _955 = _951;
                _956 = _952;
            }
            else
            {
                _953 = _904;
                _954 = _905;
                _955 = _906;
                _956 = _907;
            }
            _957 = _953;
            _958 = _954;
            _959 = _955;
            _960 = _956;
        }
        else
        {
            _957 = _859;
            _958 = _860;
            _959 = _861;
            _960 = _862;
        }
        uint _1055;
        uint _1056;
        uint _1057;
        uint _1058;
        if (0.0 != uintBitsToFloat(ssbo_1_1.data[_648]))
        {
            bool _967 = (_200 < _202) && ((_194 < _197) && (_195 < _199));
            bool _968 = 1u != ssbo_1_1.data[19u + buf0_dword_off];
            uint _1002;
            uint _1003;
            uint _1004;
            uint _1005;
            bool _1006;
            if (_968)
            {
                uint _998;
                uint _999;
                uint _1000;
                uint _1001;
                if (_207 && _967)
                {
                    vec4 _973 = texelFetch(SPIRV_Cross_Combinedcs_img72SPIRV_Cross_DummySampler, ivec2(uvec2(_200, _194)), 0);
                    precise float _980 = uintBitsToFloat(ssbo_1_1.data[_648]) * _973.w;
                    precise float _981 = _980 + uintBitsToFloat(_957);
                    precise float _985 = uintBitsToFloat(ssbo_1_1.data[_648]) * _973.z;
                    precise float _986 = _985 + uintBitsToFloat(_958);
                    precise float _990 = uintBitsToFloat(ssbo_1_1.data[_648]) * _973.y;
                    precise float _991 = _990 + uintBitsToFloat(_959);
                    precise float _995 = uintBitsToFloat(ssbo_1_1.data[_648]) * _973.x;
                    precise float _996 = _995 + uintBitsToFloat(_960);
                    _998 = floatBitsToUint(_981);
                    _999 = floatBitsToUint(_986);
                    _1000 = floatBitsToUint(_991);
                    _1001 = floatBitsToUint(_996);
                }
                else
                {
                    _998 = _957;
                    _999 = _958;
                    _1000 = _959;
                    _1001 = _960;
                }
                _1002 = _998;
                _1003 = _999;
                _1004 = _1000;
                _1005 = _1001;
                _1006 = _207;
            }
            else
            {
                _1002 = _957;
                _1003 = _958;
                _1004 = _959;
                _1005 = _960;
                _1006 = _967;
            }
            uint _1051;
            uint _1052;
            uint _1053;
            uint _1054;
            if (!_968)
            {
                uint _1047;
                uint _1048;
                uint _1049;
                uint _1050;
                if (_207 && _1006)
                {
                    precise float _1012 = uintBitsToFloat(ssbo_1_1.data[_241]) * float(_200);
                    precise float _1013 = _1012 + uintBitsToFloat(ssbo_1_1.data[_249]);
                    precise float _1016 = uintBitsToFloat(ssbo_1_1.data[_245]) * float(_194);
                    precise float _1017 = _1016 + uintBitsToFloat(ssbo_1_1.data[_253]);
                    vec4 _1022 = textureLod(SPIRV_Cross_Combinedcs_img72cs_sampsgpr_0, vec2(_1013, _1017), 0.0);
                    precise float _1029 = uintBitsToFloat(ssbo_1_1.data[_648]) * _1022.w;
                    precise float _1030 = _1029 + uintBitsToFloat(_1002);
                    precise float _1034 = uintBitsToFloat(ssbo_1_1.data[_648]) * _1022.z;
                    precise float _1035 = _1034 + uintBitsToFloat(_1003);
                    precise float _1039 = uintBitsToFloat(ssbo_1_1.data[_648]) * _1022.y;
                    precise float _1040 = _1039 + uintBitsToFloat(_1004);
                    precise float _1044 = uintBitsToFloat(ssbo_1_1.data[_648]) * _1022.x;
                    precise float _1045 = _1044 + uintBitsToFloat(_1005);
                    _1047 = floatBitsToUint(_1030);
                    _1048 = floatBitsToUint(_1035);
                    _1049 = floatBitsToUint(_1040);
                    _1050 = floatBitsToUint(_1045);
                }
                else
                {
                    _1047 = _1002;
                    _1048 = _1003;
                    _1049 = _1004;
                    _1050 = _1005;
                }
                _1051 = _1047;
                _1052 = _1048;
                _1053 = _1049;
                _1054 = _1050;
            }
            else
            {
                _1051 = _1002;
                _1052 = _1003;
                _1053 = _1004;
                _1054 = _1005;
            }
            _1055 = _1051;
            _1056 = _1052;
            _1057 = _1053;
            _1058 = _1054;
        }
        else
        {
            _1055 = _957;
            _1056 = _958;
            _1057 = _959;
            _1058 = _960;
        }
        vec4 _1063 = vec4(uintBitsToFloat(_1058), uintBitsToFloat(_1057), uintBitsToFloat(_1056), uintBitsToFloat(_1055));
        imageStore(cs_img80, ivec3(uvec3(_200, _194, _195)), vec4(_1063.x, _1063.y, _1063.z, vec4(0.0, 1.0, 0.0, 0.0).x));
    }
}

