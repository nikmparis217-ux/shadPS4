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

layout(binding = 9) uniform writeonly image2D cs_img80;
uniform sampler2D SPIRV_Cross_Combinedcs_img16SPIRV_Cross_DummySampler;
uniform sampler2D SPIRV_Cross_Combinedcs_img16cs_sampsgpr_0;
uniform sampler2D SPIRV_Cross_Combinedcs_img24SPIRV_Cross_DummySampler;
uniform sampler2D SPIRV_Cross_Combinedcs_img24cs_sampsgpr_0;
uniform sampler2D SPIRV_Cross_Combinedcs_img32SPIRV_Cross_DummySampler;
uniform sampler2D SPIRV_Cross_Combinedcs_img32cs_sampsgpr_0;
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
    uint _183 = (gl_WorkGroupID.y << 3u) + gl_LocalInvocationID.y;
    uint _184 = (gl_WorkGroupID.x << 3u) + gl_LocalInvocationID.x;
    bool _191 = (_184 < uint(uintBitsToFloat(ssbo_1_1.data[1u + buf0_dword_off]))) && (_183 < uint(uintBitsToFloat(ssbo_1_1.data[2u + buf0_dword_off])));
    if (_191)
    {
        uint _209 = 20u + buf0_dword_off;
        uint _213 = 21u + buf0_dword_off;
        uint _217 = 22u + buf0_dword_off;
        uint _221 = 23u + buf0_dword_off;
        uint _225 = 5u + buf0_dword_off;
        uint _229 = 6u + buf0_dword_off;
        uint _233 = 9u + buf0_dword_off;
        uint _237 = 10u + buf0_dword_off;
        uint _314;
        uint _315;
        uint _316;
        uint _317;
        if (0.0 != uintBitsToFloat(ssbo_1_1.data[_209]))
        {
            bool _244 = _191 && ((1u != ssbo_1_1.data[12u + buf0_dword_off]) ? _191 : false);
            uint _270;
            uint _271;
            uint _272;
            uint _273;
            if (_244)
            {
                uint _266;
                uint _267;
                uint _268;
                uint _269;
                if (_191 && _191)
                {
                    vec4 _249 = texelFetch(SPIRV_Cross_Combinedcs_img16SPIRV_Cross_DummySampler, ivec2(uvec2(_184, _183)), 0);
                    precise float _255 = uintBitsToFloat(ssbo_1_1.data[_209]) * _249.x;
                    precise float _258 = uintBitsToFloat(ssbo_1_1.data[_209]) * _249.y;
                    precise float _261 = uintBitsToFloat(ssbo_1_1.data[_209]) * _249.z;
                    precise float _264 = uintBitsToFloat(ssbo_1_1.data[_209]) * _249.w;
                    _266 = floatBitsToUint(_261);
                    _267 = floatBitsToUint(_258);
                    _268 = floatBitsToUint(_255);
                    _269 = floatBitsToUint(_264);
                }
                else
                {
                    _266 = 0u;
                    _267 = 0u;
                    _268 = 0u;
                    _269 = 0u;
                }
                _270 = _266;
                _271 = _267;
                _272 = _268;
                _273 = _269;
            }
            else
            {
                _270 = 0u;
                _271 = 0u;
                _272 = 0u;
                _273 = 0u;
            }
            uint _310;
            uint _311;
            uint _312;
            uint _313;
            if (!_244)
            {
                uint _306;
                uint _307;
                uint _308;
                uint _309;
                if (_191 && _191)
                {
                    precise float _279 = uintBitsToFloat(ssbo_1_1.data[_225]) * float(_184);
                    precise float _280 = _279 + uintBitsToFloat(ssbo_1_1.data[_233]);
                    precise float _283 = uintBitsToFloat(ssbo_1_1.data[_229]) * float(_183);
                    precise float _284 = _283 + uintBitsToFloat(ssbo_1_1.data[_237]);
                    vec4 _289 = textureLod(SPIRV_Cross_Combinedcs_img16cs_sampsgpr_0, vec2(_280, _284), 0.0);
                    precise float _295 = uintBitsToFloat(ssbo_1_1.data[_209]) * _289.x;
                    precise float _298 = uintBitsToFloat(ssbo_1_1.data[_209]) * _289.y;
                    precise float _301 = uintBitsToFloat(ssbo_1_1.data[_209]) * _289.z;
                    precise float _304 = uintBitsToFloat(ssbo_1_1.data[_209]) * _289.w;
                    _306 = floatBitsToUint(_304);
                    _307 = floatBitsToUint(_301);
                    _308 = floatBitsToUint(_298);
                    _309 = floatBitsToUint(_295);
                }
                else
                {
                    _306 = _273;
                    _307 = _270;
                    _308 = _271;
                    _309 = _272;
                }
                _310 = _306;
                _311 = _307;
                _312 = _308;
                _313 = _309;
            }
            else
            {
                _310 = _273;
                _311 = _270;
                _312 = _271;
                _313 = _272;
            }
            _314 = _310;
            _315 = _311;
            _316 = _312;
            _317 = _313;
        }
        else
        {
            _314 = 0u;
            _315 = 0u;
            _316 = 0u;
            _317 = 0u;
        }
        uint _408;
        uint _409;
        uint _410;
        uint _411;
        if (0.0 != uintBitsToFloat(ssbo_1_1.data[_213]))
        {
            bool _322 = _191 && ((1u != ssbo_1_1.data[13u + buf0_dword_off]) ? _191 : false);
            uint _356;
            uint _357;
            uint _358;
            uint _359;
            if (_322)
            {
                uint _352;
                uint _353;
                uint _354;
                uint _355;
                if (_191 && _191)
                {
                    vec4 _327 = texelFetch(SPIRV_Cross_Combinedcs_img24SPIRV_Cross_DummySampler, ivec2(uvec2(_184, _183)), 0);
                    precise float _334 = uintBitsToFloat(ssbo_1_1.data[_213]) * _327.x;
                    precise float _335 = _334 + uintBitsToFloat(_317);
                    precise float _339 = uintBitsToFloat(ssbo_1_1.data[_213]) * _327.y;
                    precise float _340 = _339 + uintBitsToFloat(_316);
                    precise float _344 = uintBitsToFloat(ssbo_1_1.data[_213]) * _327.z;
                    precise float _345 = _344 + uintBitsToFloat(_315);
                    precise float _349 = uintBitsToFloat(ssbo_1_1.data[_213]) * _327.w;
                    precise float _350 = _349 + uintBitsToFloat(_314);
                    _352 = floatBitsToUint(_350);
                    _353 = floatBitsToUint(_345);
                    _354 = floatBitsToUint(_340);
                    _355 = floatBitsToUint(_335);
                }
                else
                {
                    _352 = _314;
                    _353 = _315;
                    _354 = _316;
                    _355 = _317;
                }
                _356 = _352;
                _357 = _353;
                _358 = _354;
                _359 = _355;
            }
            else
            {
                _356 = _314;
                _357 = _315;
                _358 = _316;
                _359 = _317;
            }
            uint _404;
            uint _405;
            uint _406;
            uint _407;
            if (!_322)
            {
                uint _400;
                uint _401;
                uint _402;
                uint _403;
                if (_191 && _191)
                {
                    precise float _365 = uintBitsToFloat(ssbo_1_1.data[_225]) * float(_184);
                    precise float _366 = _365 + uintBitsToFloat(ssbo_1_1.data[_233]);
                    precise float _369 = uintBitsToFloat(ssbo_1_1.data[_229]) * float(_183);
                    precise float _370 = _369 + uintBitsToFloat(ssbo_1_1.data[_237]);
                    vec4 _375 = textureLod(SPIRV_Cross_Combinedcs_img24cs_sampsgpr_0, vec2(_366, _370), 0.0);
                    precise float _382 = uintBitsToFloat(ssbo_1_1.data[_213]) * _375.x;
                    precise float _383 = _382 + uintBitsToFloat(_359);
                    precise float _387 = uintBitsToFloat(ssbo_1_1.data[_213]) * _375.y;
                    precise float _388 = _387 + uintBitsToFloat(_358);
                    precise float _392 = uintBitsToFloat(ssbo_1_1.data[_213]) * _375.z;
                    precise float _393 = _392 + uintBitsToFloat(_357);
                    precise float _397 = uintBitsToFloat(ssbo_1_1.data[_213]) * _375.w;
                    precise float _398 = _397 + uintBitsToFloat(_356);
                    _400 = floatBitsToUint(_398);
                    _401 = floatBitsToUint(_393);
                    _402 = floatBitsToUint(_388);
                    _403 = floatBitsToUint(_383);
                }
                else
                {
                    _400 = _356;
                    _401 = _357;
                    _402 = _358;
                    _403 = _359;
                }
                _404 = _400;
                _405 = _401;
                _406 = _402;
                _407 = _403;
            }
            else
            {
                _404 = _356;
                _405 = _357;
                _406 = _358;
                _407 = _359;
            }
            _408 = _404;
            _409 = _405;
            _410 = _406;
            _411 = _407;
        }
        else
        {
            _408 = _314;
            _409 = _315;
            _410 = _316;
            _411 = _317;
        }
        uint _502;
        uint _503;
        uint _504;
        uint _505;
        if (0.0 != uintBitsToFloat(ssbo_1_1.data[_217]))
        {
            bool _416 = _191 && ((1u != ssbo_1_1.data[14u + buf0_dword_off]) ? _191 : false);
            uint _450;
            uint _451;
            uint _452;
            uint _453;
            if (_416)
            {
                uint _446;
                uint _447;
                uint _448;
                uint _449;
                if (_191 && _191)
                {
                    vec4 _421 = texelFetch(SPIRV_Cross_Combinedcs_img32SPIRV_Cross_DummySampler, ivec2(uvec2(_184, _183)), 0);
                    precise float _428 = uintBitsToFloat(ssbo_1_1.data[_217]) * _421.x;
                    precise float _429 = _428 + uintBitsToFloat(_411);
                    precise float _433 = uintBitsToFloat(ssbo_1_1.data[_217]) * _421.y;
                    precise float _434 = _433 + uintBitsToFloat(_410);
                    precise float _438 = uintBitsToFloat(ssbo_1_1.data[_217]) * _421.z;
                    precise float _439 = _438 + uintBitsToFloat(_409);
                    precise float _443 = uintBitsToFloat(ssbo_1_1.data[_217]) * _421.w;
                    precise float _444 = _443 + uintBitsToFloat(_408);
                    _446 = floatBitsToUint(_444);
                    _447 = floatBitsToUint(_439);
                    _448 = floatBitsToUint(_434);
                    _449 = floatBitsToUint(_429);
                }
                else
                {
                    _446 = _408;
                    _447 = _409;
                    _448 = _410;
                    _449 = _411;
                }
                _450 = _446;
                _451 = _447;
                _452 = _448;
                _453 = _449;
            }
            else
            {
                _450 = _408;
                _451 = _409;
                _452 = _410;
                _453 = _411;
            }
            uint _498;
            uint _499;
            uint _500;
            uint _501;
            if (!_416)
            {
                uint _494;
                uint _495;
                uint _496;
                uint _497;
                if (_191 && _191)
                {
                    precise float _459 = uintBitsToFloat(ssbo_1_1.data[_225]) * float(_184);
                    precise float _460 = _459 + uintBitsToFloat(ssbo_1_1.data[_233]);
                    precise float _463 = uintBitsToFloat(ssbo_1_1.data[_229]) * float(_183);
                    precise float _464 = _463 + uintBitsToFloat(ssbo_1_1.data[_237]);
                    vec4 _469 = textureLod(SPIRV_Cross_Combinedcs_img32cs_sampsgpr_0, vec2(_460, _464), 0.0);
                    precise float _476 = uintBitsToFloat(ssbo_1_1.data[_217]) * _469.x;
                    precise float _477 = _476 + uintBitsToFloat(_453);
                    precise float _481 = uintBitsToFloat(ssbo_1_1.data[_217]) * _469.y;
                    precise float _482 = _481 + uintBitsToFloat(_452);
                    precise float _486 = uintBitsToFloat(ssbo_1_1.data[_217]) * _469.z;
                    precise float _487 = _486 + uintBitsToFloat(_451);
                    precise float _491 = uintBitsToFloat(ssbo_1_1.data[_217]) * _469.w;
                    precise float _492 = _491 + uintBitsToFloat(_450);
                    _494 = floatBitsToUint(_492);
                    _495 = floatBitsToUint(_487);
                    _496 = floatBitsToUint(_482);
                    _497 = floatBitsToUint(_477);
                }
                else
                {
                    _494 = _450;
                    _495 = _451;
                    _496 = _452;
                    _497 = _453;
                }
                _498 = _494;
                _499 = _495;
                _500 = _496;
                _501 = _497;
            }
            else
            {
                _498 = _450;
                _499 = _451;
                _500 = _452;
                _501 = _453;
            }
            _502 = _498;
            _503 = _499;
            _504 = _500;
            _505 = _501;
        }
        else
        {
            _502 = _408;
            _503 = _409;
            _504 = _410;
            _505 = _411;
        }
        uint _596;
        uint _597;
        uint _598;
        uint _599;
        if (0.0 != uintBitsToFloat(ssbo_1_1.data[_221]))
        {
            bool _510 = _191 && ((1u != ssbo_1_1.data[15u + buf0_dword_off]) ? _191 : false);
            uint _544;
            uint _545;
            uint _546;
            uint _547;
            if (_510)
            {
                uint _540;
                uint _541;
                uint _542;
                uint _543;
                if (_191 && _191)
                {
                    vec4 _515 = texelFetch(SPIRV_Cross_Combinedcs_img40SPIRV_Cross_DummySampler, ivec2(uvec2(_184, _183)), 0);
                    precise float _522 = uintBitsToFloat(ssbo_1_1.data[_221]) * _515.x;
                    precise float _523 = _522 + uintBitsToFloat(_505);
                    precise float _527 = uintBitsToFloat(ssbo_1_1.data[_221]) * _515.y;
                    precise float _528 = _527 + uintBitsToFloat(_504);
                    precise float _532 = uintBitsToFloat(ssbo_1_1.data[_221]) * _515.z;
                    precise float _533 = _532 + uintBitsToFloat(_503);
                    precise float _537 = uintBitsToFloat(ssbo_1_1.data[_221]) * _515.w;
                    precise float _538 = _537 + uintBitsToFloat(_502);
                    _540 = floatBitsToUint(_538);
                    _541 = floatBitsToUint(_533);
                    _542 = floatBitsToUint(_528);
                    _543 = floatBitsToUint(_523);
                }
                else
                {
                    _540 = _502;
                    _541 = _503;
                    _542 = _504;
                    _543 = _505;
                }
                _544 = _540;
                _545 = _541;
                _546 = _542;
                _547 = _543;
            }
            else
            {
                _544 = _502;
                _545 = _503;
                _546 = _504;
                _547 = _505;
            }
            uint _592;
            uint _593;
            uint _594;
            uint _595;
            if (!_510)
            {
                uint _588;
                uint _589;
                uint _590;
                uint _591;
                if (_191 && _191)
                {
                    precise float _553 = uintBitsToFloat(ssbo_1_1.data[_225]) * float(_184);
                    precise float _554 = _553 + uintBitsToFloat(ssbo_1_1.data[_233]);
                    precise float _557 = uintBitsToFloat(ssbo_1_1.data[_229]) * float(_183);
                    precise float _558 = _557 + uintBitsToFloat(ssbo_1_1.data[_237]);
                    vec4 _563 = textureLod(SPIRV_Cross_Combinedcs_img40cs_sampsgpr_0, vec2(_554, _558), 0.0);
                    precise float _570 = uintBitsToFloat(ssbo_1_1.data[_221]) * _563.x;
                    precise float _571 = _570 + uintBitsToFloat(_547);
                    precise float _575 = uintBitsToFloat(ssbo_1_1.data[_221]) * _563.y;
                    precise float _576 = _575 + uintBitsToFloat(_546);
                    precise float _580 = uintBitsToFloat(ssbo_1_1.data[_221]) * _563.z;
                    precise float _581 = _580 + uintBitsToFloat(_545);
                    precise float _585 = uintBitsToFloat(ssbo_1_1.data[_221]) * _563.w;
                    precise float _586 = _585 + uintBitsToFloat(_544);
                    _588 = floatBitsToUint(_586);
                    _589 = floatBitsToUint(_581);
                    _590 = floatBitsToUint(_576);
                    _591 = floatBitsToUint(_571);
                }
                else
                {
                    _588 = _544;
                    _589 = _545;
                    _590 = _546;
                    _591 = _547;
                }
                _592 = _588;
                _593 = _589;
                _594 = _590;
                _595 = _591;
            }
            else
            {
                _592 = _544;
                _593 = _545;
                _594 = _546;
                _595 = _547;
            }
            _596 = _592;
            _597 = _593;
            _598 = _594;
            _599 = _595;
        }
        else
        {
            _596 = _502;
            _597 = _503;
            _598 = _504;
            _599 = _505;
        }
        uint _601 = 24u + buf0_dword_off;
        uint _605 = 25u + buf0_dword_off;
        uint _609 = 26u + buf0_dword_off;
        uint _613 = 27u + buf0_dword_off;
        uint _722;
        uint _723;
        uint _724;
        uint _725;
        if (0.0 != uintBitsToFloat(ssbo_1_1.data[_601]))
        {
            bool _636 = _191 && ((1u != ssbo_1_1.data[16u + buf0_dword_off]) ? _191 : false);
            uint _670;
            uint _671;
            uint _672;
            uint _673;
            if (_636)
            {
                uint _666;
                uint _667;
                uint _668;
                uint _669;
                if (_191 && _191)
                {
                    vec4 _641 = texelFetch(SPIRV_Cross_Combinedcs_img48SPIRV_Cross_DummySampler, ivec2(uvec2(_184, _183)), 0);
                    precise float _648 = uintBitsToFloat(ssbo_1_1.data[_601]) * _641.x;
                    precise float _649 = _648 + uintBitsToFloat(_599);
                    precise float _653 = uintBitsToFloat(ssbo_1_1.data[_601]) * _641.y;
                    precise float _654 = _653 + uintBitsToFloat(_598);
                    precise float _658 = uintBitsToFloat(ssbo_1_1.data[_601]) * _641.z;
                    precise float _659 = _658 + uintBitsToFloat(_597);
                    precise float _663 = uintBitsToFloat(ssbo_1_1.data[_601]) * _641.w;
                    precise float _664 = _663 + uintBitsToFloat(_596);
                    _666 = floatBitsToUint(_664);
                    _667 = floatBitsToUint(_659);
                    _668 = floatBitsToUint(_654);
                    _669 = floatBitsToUint(_649);
                }
                else
                {
                    _666 = _596;
                    _667 = _597;
                    _668 = _598;
                    _669 = _599;
                }
                _670 = _666;
                _671 = _667;
                _672 = _668;
                _673 = _669;
            }
            else
            {
                _670 = _596;
                _671 = _597;
                _672 = _598;
                _673 = _599;
            }
            uint _718;
            uint _719;
            uint _720;
            uint _721;
            if (!_636)
            {
                uint _714;
                uint _715;
                uint _716;
                uint _717;
                if (_191 && _191)
                {
                    precise float _679 = uintBitsToFloat(ssbo_1_1.data[_225]) * float(_184);
                    precise float _680 = _679 + uintBitsToFloat(ssbo_1_1.data[_233]);
                    precise float _683 = uintBitsToFloat(ssbo_1_1.data[_229]) * float(_183);
                    precise float _684 = _683 + uintBitsToFloat(ssbo_1_1.data[_237]);
                    vec4 _689 = textureLod(SPIRV_Cross_Combinedcs_img48cs_sampsgpr_0, vec2(_680, _684), 0.0);
                    precise float _696 = uintBitsToFloat(ssbo_1_1.data[_601]) * _689.x;
                    precise float _697 = _696 + uintBitsToFloat(_673);
                    precise float _701 = uintBitsToFloat(ssbo_1_1.data[_601]) * _689.y;
                    precise float _702 = _701 + uintBitsToFloat(_672);
                    precise float _706 = uintBitsToFloat(ssbo_1_1.data[_601]) * _689.z;
                    precise float _707 = _706 + uintBitsToFloat(_671);
                    precise float _711 = uintBitsToFloat(ssbo_1_1.data[_601]) * _689.w;
                    precise float _712 = _711 + uintBitsToFloat(_670);
                    _714 = floatBitsToUint(_712);
                    _715 = floatBitsToUint(_707);
                    _716 = floatBitsToUint(_702);
                    _717 = floatBitsToUint(_697);
                }
                else
                {
                    _714 = _670;
                    _715 = _671;
                    _716 = _672;
                    _717 = _673;
                }
                _718 = _714;
                _719 = _715;
                _720 = _716;
                _721 = _717;
            }
            else
            {
                _718 = _670;
                _719 = _671;
                _720 = _672;
                _721 = _673;
            }
            _722 = _718;
            _723 = _719;
            _724 = _720;
            _725 = _721;
        }
        else
        {
            _722 = _596;
            _723 = _597;
            _724 = _598;
            _725 = _599;
        }
        uint _816;
        uint _817;
        uint _818;
        uint _819;
        if (0.0 != uintBitsToFloat(ssbo_1_1.data[_605]))
        {
            bool _730 = _191 && ((1u != ssbo_1_1.data[17u + buf0_dword_off]) ? _191 : false);
            uint _764;
            uint _765;
            uint _766;
            uint _767;
            if (_730)
            {
                uint _760;
                uint _761;
                uint _762;
                uint _763;
                if (_191 && _191)
                {
                    vec4 _735 = texelFetch(SPIRV_Cross_Combinedcs_img56SPIRV_Cross_DummySampler, ivec2(uvec2(_184, _183)), 0);
                    precise float _742 = uintBitsToFloat(ssbo_1_1.data[_605]) * _735.x;
                    precise float _743 = _742 + uintBitsToFloat(_725);
                    precise float _747 = uintBitsToFloat(ssbo_1_1.data[_605]) * _735.y;
                    precise float _748 = _747 + uintBitsToFloat(_724);
                    precise float _752 = uintBitsToFloat(ssbo_1_1.data[_605]) * _735.z;
                    precise float _753 = _752 + uintBitsToFloat(_723);
                    precise float _757 = uintBitsToFloat(ssbo_1_1.data[_605]) * _735.w;
                    precise float _758 = _757 + uintBitsToFloat(_722);
                    _760 = floatBitsToUint(_758);
                    _761 = floatBitsToUint(_753);
                    _762 = floatBitsToUint(_748);
                    _763 = floatBitsToUint(_743);
                }
                else
                {
                    _760 = _722;
                    _761 = _723;
                    _762 = _724;
                    _763 = _725;
                }
                _764 = _760;
                _765 = _761;
                _766 = _762;
                _767 = _763;
            }
            else
            {
                _764 = _722;
                _765 = _723;
                _766 = _724;
                _767 = _725;
            }
            uint _812;
            uint _813;
            uint _814;
            uint _815;
            if (!_730)
            {
                uint _808;
                uint _809;
                uint _810;
                uint _811;
                if (_191 && _191)
                {
                    precise float _773 = uintBitsToFloat(ssbo_1_1.data[_225]) * float(_184);
                    precise float _774 = _773 + uintBitsToFloat(ssbo_1_1.data[_233]);
                    precise float _777 = uintBitsToFloat(ssbo_1_1.data[_229]) * float(_183);
                    precise float _778 = _777 + uintBitsToFloat(ssbo_1_1.data[_237]);
                    vec4 _783 = textureLod(SPIRV_Cross_Combinedcs_img56cs_sampsgpr_0, vec2(_774, _778), 0.0);
                    precise float _790 = uintBitsToFloat(ssbo_1_1.data[_605]) * _783.x;
                    precise float _791 = _790 + uintBitsToFloat(_767);
                    precise float _795 = uintBitsToFloat(ssbo_1_1.data[_605]) * _783.y;
                    precise float _796 = _795 + uintBitsToFloat(_766);
                    precise float _800 = uintBitsToFloat(ssbo_1_1.data[_605]) * _783.z;
                    precise float _801 = _800 + uintBitsToFloat(_765);
                    precise float _805 = uintBitsToFloat(ssbo_1_1.data[_605]) * _783.w;
                    precise float _806 = _805 + uintBitsToFloat(_764);
                    _808 = floatBitsToUint(_806);
                    _809 = floatBitsToUint(_801);
                    _810 = floatBitsToUint(_796);
                    _811 = floatBitsToUint(_791);
                }
                else
                {
                    _808 = _764;
                    _809 = _765;
                    _810 = _766;
                    _811 = _767;
                }
                _812 = _808;
                _813 = _809;
                _814 = _810;
                _815 = _811;
            }
            else
            {
                _812 = _764;
                _813 = _765;
                _814 = _766;
                _815 = _767;
            }
            _816 = _812;
            _817 = _813;
            _818 = _814;
            _819 = _815;
        }
        else
        {
            _816 = _722;
            _817 = _723;
            _818 = _724;
            _819 = _725;
        }
        uint _910;
        uint _911;
        uint _912;
        uint _913;
        if (0.0 != uintBitsToFloat(ssbo_1_1.data[_609]))
        {
            bool _824 = _191 && ((1u != ssbo_1_1.data[18u + buf0_dword_off]) ? _191 : false);
            uint _858;
            uint _859;
            uint _860;
            uint _861;
            if (_824)
            {
                uint _854;
                uint _855;
                uint _856;
                uint _857;
                if (_191 && _191)
                {
                    vec4 _829 = texelFetch(SPIRV_Cross_Combinedcs_img64SPIRV_Cross_DummySampler, ivec2(uvec2(_184, _183)), 0);
                    precise float _836 = uintBitsToFloat(ssbo_1_1.data[_609]) * _829.x;
                    precise float _837 = _836 + uintBitsToFloat(_819);
                    precise float _841 = uintBitsToFloat(ssbo_1_1.data[_609]) * _829.y;
                    precise float _842 = _841 + uintBitsToFloat(_818);
                    precise float _846 = uintBitsToFloat(ssbo_1_1.data[_609]) * _829.z;
                    precise float _847 = _846 + uintBitsToFloat(_817);
                    precise float _851 = uintBitsToFloat(ssbo_1_1.data[_609]) * _829.w;
                    precise float _852 = _851 + uintBitsToFloat(_816);
                    _854 = floatBitsToUint(_852);
                    _855 = floatBitsToUint(_847);
                    _856 = floatBitsToUint(_842);
                    _857 = floatBitsToUint(_837);
                }
                else
                {
                    _854 = _816;
                    _855 = _817;
                    _856 = _818;
                    _857 = _819;
                }
                _858 = _854;
                _859 = _855;
                _860 = _856;
                _861 = _857;
            }
            else
            {
                _858 = _816;
                _859 = _817;
                _860 = _818;
                _861 = _819;
            }
            uint _906;
            uint _907;
            uint _908;
            uint _909;
            if (!_824)
            {
                uint _902;
                uint _903;
                uint _904;
                uint _905;
                if (_191 && _191)
                {
                    precise float _867 = uintBitsToFloat(ssbo_1_1.data[_225]) * float(_184);
                    precise float _868 = _867 + uintBitsToFloat(ssbo_1_1.data[_233]);
                    precise float _871 = uintBitsToFloat(ssbo_1_1.data[_229]) * float(_183);
                    precise float _872 = _871 + uintBitsToFloat(ssbo_1_1.data[_237]);
                    vec4 _877 = textureLod(SPIRV_Cross_Combinedcs_img64cs_sampsgpr_0, vec2(_868, _872), 0.0);
                    precise float _884 = uintBitsToFloat(ssbo_1_1.data[_609]) * _877.x;
                    precise float _885 = _884 + uintBitsToFloat(_861);
                    precise float _889 = uintBitsToFloat(ssbo_1_1.data[_609]) * _877.y;
                    precise float _890 = _889 + uintBitsToFloat(_860);
                    precise float _894 = uintBitsToFloat(ssbo_1_1.data[_609]) * _877.z;
                    precise float _895 = _894 + uintBitsToFloat(_859);
                    precise float _899 = uintBitsToFloat(ssbo_1_1.data[_609]) * _877.w;
                    precise float _900 = _899 + uintBitsToFloat(_858);
                    _902 = floatBitsToUint(_900);
                    _903 = floatBitsToUint(_895);
                    _904 = floatBitsToUint(_890);
                    _905 = floatBitsToUint(_885);
                }
                else
                {
                    _902 = _858;
                    _903 = _859;
                    _904 = _860;
                    _905 = _861;
                }
                _906 = _902;
                _907 = _903;
                _908 = _904;
                _909 = _905;
            }
            else
            {
                _906 = _858;
                _907 = _859;
                _908 = _860;
                _909 = _861;
            }
            _910 = _906;
            _911 = _907;
            _912 = _908;
            _913 = _909;
        }
        else
        {
            _910 = _816;
            _911 = _817;
            _912 = _818;
            _913 = _819;
        }
        uint _1004;
        uint _1005;
        uint _1006;
        uint _1007;
        if (0.0 != uintBitsToFloat(ssbo_1_1.data[_613]))
        {
            bool _918 = _191 && ((1u != ssbo_1_1.data[19u + buf0_dword_off]) ? _191 : false);
            uint _952;
            uint _953;
            uint _954;
            uint _955;
            if (_918)
            {
                uint _948;
                uint _949;
                uint _950;
                uint _951;
                if (_191 && _191)
                {
                    vec4 _923 = texelFetch(SPIRV_Cross_Combinedcs_img72SPIRV_Cross_DummySampler, ivec2(uvec2(_184, _183)), 0);
                    precise float _930 = uintBitsToFloat(ssbo_1_1.data[_613]) * _923.x;
                    precise float _931 = _930 + uintBitsToFloat(_913);
                    precise float _935 = uintBitsToFloat(ssbo_1_1.data[_613]) * _923.y;
                    precise float _936 = _935 + uintBitsToFloat(_912);
                    precise float _940 = uintBitsToFloat(ssbo_1_1.data[_613]) * _923.z;
                    precise float _941 = _940 + uintBitsToFloat(_911);
                    precise float _945 = uintBitsToFloat(ssbo_1_1.data[_613]) * _923.w;
                    precise float _946 = _945 + uintBitsToFloat(_910);
                    _948 = floatBitsToUint(_946);
                    _949 = floatBitsToUint(_941);
                    _950 = floatBitsToUint(_936);
                    _951 = floatBitsToUint(_931);
                }
                else
                {
                    _948 = _910;
                    _949 = _911;
                    _950 = _912;
                    _951 = _913;
                }
                _952 = _948;
                _953 = _949;
                _954 = _950;
                _955 = _951;
            }
            else
            {
                _952 = _910;
                _953 = _911;
                _954 = _912;
                _955 = _913;
            }
            uint _1000;
            uint _1001;
            uint _1002;
            uint _1003;
            if (!_918)
            {
                uint _996;
                uint _997;
                uint _998;
                uint _999;
                if (_191 && _191)
                {
                    precise float _961 = uintBitsToFloat(ssbo_1_1.data[_225]) * float(_184);
                    precise float _962 = _961 + uintBitsToFloat(ssbo_1_1.data[_233]);
                    precise float _965 = uintBitsToFloat(ssbo_1_1.data[_229]) * float(_183);
                    precise float _966 = _965 + uintBitsToFloat(ssbo_1_1.data[_237]);
                    vec4 _971 = textureLod(SPIRV_Cross_Combinedcs_img72cs_sampsgpr_0, vec2(_962, _966), 0.0);
                    precise float _978 = uintBitsToFloat(ssbo_1_1.data[_613]) * _971.x;
                    precise float _979 = _978 + uintBitsToFloat(_955);
                    precise float _983 = uintBitsToFloat(ssbo_1_1.data[_613]) * _971.y;
                    precise float _984 = _983 + uintBitsToFloat(_954);
                    precise float _988 = uintBitsToFloat(ssbo_1_1.data[_613]) * _971.z;
                    precise float _989 = _988 + uintBitsToFloat(_953);
                    precise float _993 = uintBitsToFloat(ssbo_1_1.data[_613]) * _971.w;
                    precise float _994 = _993 + uintBitsToFloat(_952);
                    _996 = floatBitsToUint(_994);
                    _997 = floatBitsToUint(_989);
                    _998 = floatBitsToUint(_984);
                    _999 = floatBitsToUint(_979);
                }
                else
                {
                    _996 = _952;
                    _997 = _953;
                    _998 = _954;
                    _999 = _955;
                }
                _1000 = _996;
                _1001 = _997;
                _1002 = _998;
                _1003 = _999;
            }
            else
            {
                _1000 = _952;
                _1001 = _953;
                _1002 = _954;
                _1003 = _955;
            }
            _1004 = _1000;
            _1005 = _1001;
            _1006 = _1002;
            _1007 = _1003;
        }
        else
        {
            _1004 = _910;
            _1005 = _911;
            _1006 = _912;
            _1007 = _913;
        }
        vec4 _1012 = vec4(uintBitsToFloat(_1007), uintBitsToFloat(_1006), uintBitsToFloat(_1005), uintBitsToFloat(_1004));
        imageStore(cs_img80, ivec2(uvec2(_184, _183)), vec4(_1012.x, _1012.y, _1012.z, vec4(0.0, 1.0, 0.0, 0.0).x));
    }
}

