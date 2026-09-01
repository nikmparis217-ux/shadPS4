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
#extension GL_ARB_shader_viewport_layer_array : require

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

layout(binding = 2, std430) readonly buffer clip_planes
{
    float data[];
} clip_planes_1;

layout(binding = 3, std430) readonly buffer srt_flatbuf
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

#ifdef GL_ARB_shader_draw_parameters
#define SPIRV_Cross_BaseVertex gl_BaseVertexARB
#else
uniform int SPIRV_Cross_BaseVertex;
#endif
#ifdef GL_ARB_shader_draw_parameters
#define SPIRV_Cross_BaseInstance gl_BaseInstanceARB
#else
uniform int SPIRV_Cross_BaseInstance;
#endif
layout(location = 0) in vec4 vs_in_attr0;
layout(location = 1) in vec4 vs_in_attr1;
layout(location = 2) in vec4 vs_in_attr2;
layout(location = 3) in vec4 vs_in_attr3;
layout(location = 0) out vec4 out_attr0;

void main()
{
    vec4 _94 = vec4(vs_in_attr0.x, vs_in_attr0.y, vs_in_attr0.z, vs_in_attr0.w);
    vec4 _97 = vec4(_94.x, _94.y, _94.z, vec4(0.0, 1.0, 0.0, 0.0).y);
    vec4 _109 = vec4(vs_in_attr1.x, vs_in_attr1.y, vs_in_attr1.z, vs_in_attr1.w);
    vec4 _110 = vec4(_109.x, _109.y, _109.z, _109.w);
    float _111 = _110.x;
    float _112 = _110.y;
    float _113 = _110.z;
    vec4 _122 = vec4(vs_in_attr2.x, vs_in_attr2.y, vs_in_attr2.z, vs_in_attr2.w);
    vec4 _123 = vec4(_122.x, _122.y, _122.z, vec4(0.0, 1.0, 0.0, 0.0).y);
    vec4 _134 = vec4(vs_in_attr3.x, vs_in_attr3.y, vs_in_attr3.z, vs_in_attr3.w);
    vec4 _135 = vec4(_134.x, _134.y, _134.z, _134.w);
    float _136 = _135.x;
    float _137 = _135.y;
    float _138 = _135.z;
    precise float _139 = _111 * _111;
    precise float _214 = _112 * _112;
    precise float _215 = _214 + _139;
    precise float _216 = _113 * _113;
    precise float _217 = _216 + _215;
    float _266 = inversesqrt(_217);
    precise float _267 = _113 * _266;
    precise float _268 = _112 * _266;
    precise float _269 = _111 * _266;
    precise float _270 = _268 * _137;
    precise float _273 = uintBitsToFloat(srt_flatbuf_1.data[25u]) * uintBitsToFloat(srt_flatbuf_1.data[33u]);
    precise float _276 = uintBitsToFloat(srt_flatbuf_1.data[21u]) * uintBitsToFloat(srt_flatbuf_1.data[33u]);
    precise float _279 = uintBitsToFloat(srt_flatbuf_1.data[17u]) * uintBitsToFloat(srt_flatbuf_1.data[33u]);
    precise float _282 = uintBitsToFloat(srt_flatbuf_1.data[26u]) * uintBitsToFloat(srt_flatbuf_1.data[34u]);
    precise float _283 = _282 + _273;
    precise float _286 = uintBitsToFloat(srt_flatbuf_1.data[18u]) * uintBitsToFloat(srt_flatbuf_1.data[34u]);
    precise float _287 = _286 + _279;
    precise float _290 = uintBitsToFloat(srt_flatbuf_1.data[24u]) * uintBitsToFloat(srt_flatbuf_1.data[32u]);
    precise float _291 = _290 + _283;
    precise float _294 = uintBitsToFloat(srt_flatbuf_1.data[22u]) * uintBitsToFloat(srt_flatbuf_1.data[34u]);
    precise float _295 = _294 + _276;
    precise float _296 = _112 * _291;
    precise float _299 = uintBitsToFloat(srt_flatbuf_1.data[20u]) * uintBitsToFloat(srt_flatbuf_1.data[32u]);
    precise float _300 = _299 + _295;
    precise float _303 = uintBitsToFloat(srt_flatbuf_1.data[16u]) * uintBitsToFloat(srt_flatbuf_1.data[32u]);
    precise float _304 = _303 + _287;
    precise float _305 = _113 * _304;
    precise float _307 = _300 * (-_113);
    precise float _308 = _307 + _296;
    precise float _309 = _308 * _308;
    precise float _311 = _291 * (-_111);
    precise float _312 = _311 + _305;
    precise float _313 = _111 * _300;
    precise float _314 = _312 * _312;
    precise float _315 = _314 + _309;
    precise float _317 = _304 * (-_112);
    precise float _318 = _317 + _313;
    precise float _319 = _318 * _318;
    precise float _320 = _319 + _315;
    float _321 = inversesqrt(_320);
    precise float _322 = _312 * _321;
    precise float _323 = _322 * _267;
    precise float _324 = _318 * _321;
    precise float _325 = _308 * _321;
    precise float _326 = _324 * _269;
    precise float _328 = _268 * (-_324);
    precise float _329 = _328 + _323;
    precise float _330 = _269 * _137;
    precise float _333 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _334 = _325 * _268;
    precise float _337 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _340 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _343 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _345 = _267 * (-_325);
    precise float _346 = _345 + _326;
    precise float _347 = _346 * _138;
    precise float _348 = _347 + _270;
    precise float _351 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _352 = _267 * _137;
    precise float _355 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _358 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _362 = _138 * _329;
    precise float _363 = _362 + _330;
    precise float _366 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _367 = _366 + _333;
    precise float _369 = _269 * (-_322);
    precise float _370 = _369 + _334;
    precise float _373 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _374 = _373 + _337;
    precise float _377 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _378 = _377 + _340;
    precise float _381 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _382 = _381 + _343;
    precise float _385 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _388 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _391 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _392 = _391 + _374;
    precise float _395 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _398 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _399 = _398 + _382;
    precise float _402 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _403 = _402 + _385;
    precise float _406 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _407 = _136 * _325;
    precise float _408 = _407 + _363;
    precise float _411 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _412 = _411 + _367;
    precise float _415 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _416 = _415 + _351;
    precise float _419 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _420 = _419 + _355;
    precise float _423 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _424 = _423 + _358;
    precise float _427 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _428 = _138 * _370;
    precise float _429 = _428 + _352;
    precise float _432 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _433 = _432 + _388;
    precise float _436 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _437 = _436 + _378;
    precise float _438 = _408 + _97.x;
    precise float _441 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _442 = _441 + _412;
    precise float _443 = _322 * _136;
    precise float _444 = _443 + _348;
    precise float _447 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _450 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _451 = _450 + _420;
    precise float _454 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _455 = _454 + _395;
    precise float _458 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _461 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _462 = _461 + _427;
    precise float _465 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _468 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _469 = _468 + _416;
    precise float _472 = uintBitsToFloat(srt_flatbuf_1.data[49u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _473 = _472 + _392;
    precise float _476 = uintBitsToFloat(srt_flatbuf_1.data[50u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _477 = _476 + _437;
    precise float _480 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _481 = _480 + _424;
    precise float _484 = uintBitsToFloat(srt_flatbuf_1.data[51u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _485 = _484 + _399;
    precise float _488 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _489 = _488 + _403;
    precise float _492 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _493 = _492 + _406;
    precise float _496 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _497 = _442 * _438;
    precise float _498 = _444 + _97.y;
    precise float _501 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _502 = _501 + _469;
    precise float _503 = _324 * _136;
    precise float _504 = _503 + _429;
    precise float _507 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _508 = _507 + _433;
    precise float _511 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _512 = _511 + _447;
    precise float _513 = _473 * _438;
    precise float _516 = uintBitsToFloat(srt_flatbuf_1.data[49u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _517 = _516 + _451;
    precise float _520 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _521 = _520 + _455;
    precise float _522 = _477 * _438;
    precise float _525 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _526 = _525 + _462;
    precise float _527 = _485 * _438;
    precise float _530 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _531 = _530 + _458;
    precise float _534 = uintBitsToFloat(srt_flatbuf_1.data[50u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _535 = _534 + _481;
    precise float _538 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _539 = _538 + _465;
    precise float _542 = uintBitsToFloat(srt_flatbuf_1.data[51u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _543 = _542 + _489;
    precise float _546 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _547 = _546 + _493;
    precise float _550 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _551 = _550 + _496;
    precise float _552 = _498 * _502;
    precise float _553 = _552 + _497;
    precise float _554 = _504 + _97.z;
    precise float _555 = _517 * _498;
    precise float _556 = _555 + _513;
    precise float _559 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _560 = _559 + _508;
    precise float _563 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _564 = _563 + _512;
    precise float _567 = uintBitsToFloat(srt_flatbuf_1.data[49u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _568 = _567 + _521;
    precise float _571 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _572 = _571 + _531;
    precise float _573 = _498 * _535;
    precise float _574 = _573 + _522;
    precise float _577 = uintBitsToFloat(srt_flatbuf_1.data[50u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _578 = _577 + _526;
    precise float _581 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _582 = _581 + _539;
    precise float _583 = _498 * _543;
    precise float _584 = _583 + _527;
    precise float _587 = uintBitsToFloat(srt_flatbuf_1.data[51u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _588 = _587 + _547;
    precise float _591 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _592 = _591 + _551;
    precise float _593 = _554 * _560;
    precise float _594 = _593 + _553;
    precise float _597 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _598 = _597 + _564;
    precise float _599 = _554 * _568;
    precise float _600 = _599 + _556;
    precise float _603 = uintBitsToFloat(srt_flatbuf_1.data[49u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _604 = _603 + _572;
    precise float _605 = _554 * _578;
    precise float _606 = _605 + _574;
    precise float _609 = uintBitsToFloat(srt_flatbuf_1.data[50u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _610 = _609 + _582;
    precise float _611 = _554 * _588;
    precise float _612 = _611 + _584;
    precise float _615 = uintBitsToFloat(srt_flatbuf_1.data[51u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _616 = _615 + _592;
    precise float _617 = _594 + _598;
    precise float _618 = _600 + _604;
    precise float _619 = _606 + _610;
    precise float _620 = _612 + _616;
    gl_Position.x = _617;
    gl_Position.y = _618;
    gl_Position.z = _619;
    gl_Position.w = _620;
    gl_Layer = int(floatBitsToUint(uintBitsToFloat(srt_flatbuf_1.data[35u])));
    out_attr0.x = _123.x;
    out_attr0.y = _123.y;
    out_attr0.z = 0.0;
    out_attr0.w = 0.0;
}

