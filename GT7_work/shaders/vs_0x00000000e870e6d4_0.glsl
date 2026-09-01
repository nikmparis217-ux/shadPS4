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

layout(binding = 0, std430) readonly buffer clip_planes
{
    float data[];
} clip_planes_1;

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
layout(location = 0) out vec4 out_attr0;

void main()
{
    vec4 _91 = vec4(vs_in_attr0.x, vs_in_attr0.y, vs_in_attr0.z, vs_in_attr0.w);
    vec4 _94 = vec4(_91.x, _91.y, _91.z, vec4(0.0, 1.0, 0.0, 0.0).y);
    float _95 = _94.x;
    float _96 = _94.y;
    float _97 = _94.z;
    precise float _213 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _216 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _219 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _222 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(srt_flatbuf_1.data[16u]);
    precise float _225 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _228 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _231 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _234 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(srt_flatbuf_1.data[20u]);
    precise float _237 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _238 = _237 + _213;
    precise float _241 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _242 = _241 + _216;
    precise float _245 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _246 = _245 + _219;
    precise float _249 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[17u]);
    precise float _250 = _249 + _222;
    precise float _253 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _256 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _257 = _256 + _242;
    precise float _260 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _261 = _260 + _228;
    precise float _264 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _267 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _270 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(srt_flatbuf_1.data[24u]);
    precise float _273 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _274 = _273 + _238;
    precise float _277 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _278 = _277 + _225;
    precise float _281 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _282 = _281 + _246;
    precise float _285 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _286 = _285 + _231;
    precise float _289 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[18u]);
    precise float _290 = _289 + _250;
    precise float _293 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[21u]);
    precise float _294 = _293 + _234;
    precise float _297 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _298 = _297 + _253;
    precise float _301 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _304 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _305 = _304 + _264;
    precise float _308 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _311 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _314 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(srt_flatbuf_1.data[28u]);
    precise float _317 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _318 = _317 + _274;
    precise float _321 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _322 = _321 + _278;
    precise float _325 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _326 = _325 + _257;
    precise float _329 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _330 = _329 + _261;
    precise float _333 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _334 = _333 + _282;
    precise float _337 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _338 = _337 + _286;
    precise float _341 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _342 = _341 + _267;
    precise float _345 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[19u]);
    precise float _346 = _345 + _290;
    precise float _349 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[22u]);
    precise float _350 = _349 + _294;
    precise float _353 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[25u]);
    precise float _354 = _353 + _270;
    precise float _355 = _318 * _95;
    precise float _358 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _359 = _358 + _298;
    precise float _360 = _326 * _95;
    precise float _361 = _334 * _95;
    precise float _364 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _365 = _364 + _342;
    precise float _366 = _346 * _95;
    precise float _369 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _370 = _369 + _350;
    precise float _373 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _374 = _373 + _354;
    precise float _377 = uintBitsToFloat(srt_flatbuf_1.data[38u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _378 = _377 + _314;
    precise float _381 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _382 = _381 + _322;
    precise float _385 = uintBitsToFloat(srt_flatbuf_1.data[37u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _386 = _385 + _301;
    precise float _389 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _390 = _389 + _330;
    precise float _393 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[26u]);
    precise float _394 = _393 + _305;
    precise float _397 = uintBitsToFloat(srt_flatbuf_1.data[40u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _398 = _397 + _308;
    precise float _401 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[23u]);
    precise float _402 = _401 + _338;
    precise float _405 = uintBitsToFloat(srt_flatbuf_1.data[39u]) * uintBitsToFloat(srt_flatbuf_1.data[29u]);
    precise float _406 = _405 + _311;
    precise float _407 = _96 * _382;
    precise float _408 = _407 + _355;
    precise float _411 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _412 = _411 + _359;
    precise float _415 = uintBitsToFloat(srt_flatbuf_1.data[41u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _416 = _415 + _386;
    precise float _417 = _96 * _390;
    precise float _418 = _417 + _360;
    precise float _421 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _422 = _421 + _394;
    precise float _425 = uintBitsToFloat(srt_flatbuf_1.data[44u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _426 = _425 + _398;
    precise float _427 = _96 * _402;
    precise float _428 = _427 + _361;
    precise float _431 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _432 = _431 + _365;
    precise float _435 = uintBitsToFloat(srt_flatbuf_1.data[43u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _436 = _435 + _406;
    precise float _437 = _96 * _370;
    precise float _438 = _437 + _366;
    precise float _441 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[27u]);
    precise float _442 = _441 + _374;
    precise float _445 = uintBitsToFloat(srt_flatbuf_1.data[42u]) * uintBitsToFloat(srt_flatbuf_1.data[30u]);
    precise float _446 = _445 + _378;
    precise float _447 = _97 * _412;
    precise float _448 = _447 + _408;
    precise float _451 = uintBitsToFloat(srt_flatbuf_1.data[45u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _452 = _451 + _416;
    precise float _453 = _97 * _422;
    precise float _454 = _453 + _418;
    precise float _457 = uintBitsToFloat(srt_flatbuf_1.data[48u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _458 = _457 + _426;
    precise float _459 = _97 * _432;
    precise float _460 = _459 + _428;
    precise float _463 = uintBitsToFloat(srt_flatbuf_1.data[47u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _464 = _463 + _436;
    precise float _465 = _97 * _442;
    precise float _466 = _465 + _438;
    precise float _469 = uintBitsToFloat(srt_flatbuf_1.data[46u]) * uintBitsToFloat(srt_flatbuf_1.data[31u]);
    precise float _470 = _469 + _446;
    precise float _471 = _448 + _452;
    precise float _472 = _454 + _458;
    precise float _473 = _460 + _464;
    precise float _474 = _466 + _470;
    gl_Position.x = _471;
    gl_Position.y = _474;
    gl_Position.z = _473;
    gl_Position.w = _472;
    gl_Layer = int(floatBitsToUint(uintBitsToFloat(srt_flatbuf_1.data[32u])));
    out_attr0.x = 0.0;
    out_attr0.y = 0.0;
    out_attr0.z = 0.0;
    out_attr0.w = 0.0;
}

