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
#ifdef GL_ARB_shader_draw_parameters
#extension GL_ARB_shader_draw_parameters : enable
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

layout(binding = 2, std430) readonly buffer ssbo_1
{
    uint data[];
} ssbo_1_1;

layout(binding = 3, std430) readonly buffer clip_planes
{
    float data[];
} clip_planes_1;

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
layout(location = 0) out vec4 out_attr0;

void main()
{
    uint buf0_dword_off = bitfieldExtract(push_data.buf_offsets0.x, int(0u), int(8u)) >> 2u;
    vec4 _95 = vec4(vs_in_attr0.x, vs_in_attr0.y, vs_in_attr0.z, vs_in_attr0.w);
    vec4 _98 = vec4(_95.x, _95.y, vec4(0.0, 1.0, 0.0, 0.0).x, vec4(0.0, 1.0, 0.0, 0.0).y);
    vec4 _109 = vec4(vs_in_attr1.x, vs_in_attr1.y, vs_in_attr1.z, vs_in_attr1.w);
    vec4 _110 = vec4(_109.x, _109.y, _109.z, vec4(0.0, 1.0, 0.0, 0.0).y);
    float _111 = _110.x;
    float _112 = _110.y;
    float _113 = _110.z;
    uint _169 = (uint((gl_InstanceID + SPIRV_Cross_BaseInstance)) * 60u) + buf0_dword_off;
    uvec4 _181 = uvec4(ssbo_1_1.data[_169], ssbo_1_1.data[_169 + 1u], ssbo_1_1.data[_169 + 2u], ssbo_1_1.data[_169 + 3u]);
    uint _182 = _181.x;
    uint _183 = _181.y;
    uint _184 = _181.z;
    uint _185 = _181.w;
    uint _188 = ((uint((gl_InstanceID + SPIRV_Cross_BaseInstance)) * 60u) + 4u) + buf0_dword_off;
    uvec4 _200 = uvec4(ssbo_1_1.data[_188], ssbo_1_1.data[_188 + 1u], ssbo_1_1.data[_188 + 2u], ssbo_1_1.data[_188 + 3u]);
    uint _201 = _200.x;
    uint _202 = _200.y;
    uint _203 = _200.z;
    uint _204 = _200.w;
    uint _207 = ((uint((gl_InstanceID + SPIRV_Cross_BaseInstance)) * 60u) + 8u) + buf0_dword_off;
    uvec4 _219 = uvec4(ssbo_1_1.data[_207], ssbo_1_1.data[_207 + 1u], ssbo_1_1.data[_207 + 2u], ssbo_1_1.data[_207 + 3u]);
    uint _220 = _219.x;
    uint _221 = _219.y;
    uint _222 = _219.z;
    uint _223 = _219.w;
    uint _227 = ((uint((gl_InstanceID + SPIRV_Cross_BaseInstance)) * 60u) + 12u) + buf0_dword_off;
    uvec4 _239 = uvec4(ssbo_1_1.data[_227], ssbo_1_1.data[_227 + 1u], ssbo_1_1.data[_227 + 2u], ssbo_1_1.data[_227 + 3u]);
    uint _240 = _239.x;
    uint _241 = _239.y;
    uint _242 = _239.z;
    uint _243 = _239.w;
    precise float _246 = uintBitsToFloat(srt_flatbuf_1.data[21u]) * uintBitsToFloat(_182);
    precise float _249 = uintBitsToFloat(srt_flatbuf_1.data[24u]) * uintBitsToFloat(_182);
    precise float _252 = uintBitsToFloat(srt_flatbuf_1.data[23u]) * uintBitsToFloat(_182);
    precise float _255 = uintBitsToFloat(srt_flatbuf_1.data[22u]) * uintBitsToFloat(_182);
    precise float _258 = uintBitsToFloat(srt_flatbuf_1.data[21u]) * uintBitsToFloat(_201);
    precise float _261 = uintBitsToFloat(srt_flatbuf_1.data[24u]) * uintBitsToFloat(_201);
    precise float _264 = uintBitsToFloat(srt_flatbuf_1.data[23u]) * uintBitsToFloat(_201);
    precise float _267 = uintBitsToFloat(srt_flatbuf_1.data[22u]) * uintBitsToFloat(_201);
    precise float _270 = uintBitsToFloat(srt_flatbuf_1.data[25u]) * uintBitsToFloat(_183);
    precise float _271 = _270 + _246;
    precise float _274 = uintBitsToFloat(srt_flatbuf_1.data[28u]) * uintBitsToFloat(_183);
    precise float _275 = _274 + _249;
    precise float _278 = uintBitsToFloat(srt_flatbuf_1.data[27u]) * uintBitsToFloat(_183);
    precise float _279 = _278 + _252;
    precise float _282 = uintBitsToFloat(srt_flatbuf_1.data[26u]) * uintBitsToFloat(_183);
    precise float _283 = _282 + _255;
    precise float _286 = uintBitsToFloat(srt_flatbuf_1.data[21u]) * uintBitsToFloat(_220);
    precise float _289 = uintBitsToFloat(srt_flatbuf_1.data[24u]) * uintBitsToFloat(_220);
    precise float _292 = uintBitsToFloat(srt_flatbuf_1.data[31u]) * uintBitsToFloat(_184);
    precise float _293 = _292 + _279;
    gl_Layer = int(floatBitsToUint(uintBitsToFloat(srt_flatbuf_1.data[20u])));
    precise float _298 = uintBitsToFloat(srt_flatbuf_1.data[23u]) * uintBitsToFloat(_220);
    precise float _301 = uintBitsToFloat(srt_flatbuf_1.data[26u]) * uintBitsToFloat(_202);
    precise float _302 = _301 + _267;
    precise float _305 = uintBitsToFloat(srt_flatbuf_1.data[22u]) * uintBitsToFloat(_220);
    precise float _308 = uintBitsToFloat(srt_flatbuf_1.data[29u]) * uintBitsToFloat(_184);
    precise float _309 = _308 + _271;
    precise float _312 = uintBitsToFloat(srt_flatbuf_1.data[25u]) * uintBitsToFloat(_202);
    precise float _313 = _312 + _258;
    precise float _316 = uintBitsToFloat(srt_flatbuf_1.data[32u]) * uintBitsToFloat(_184);
    precise float _317 = _316 + _275;
    precise float _320 = uintBitsToFloat(srt_flatbuf_1.data[28u]) * uintBitsToFloat(_202);
    precise float _321 = _320 + _261;
    precise float _324 = uintBitsToFloat(srt_flatbuf_1.data[27u]) * uintBitsToFloat(_202);
    precise float _325 = _324 + _264;
    precise float _328 = uintBitsToFloat(srt_flatbuf_1.data[30u]) * uintBitsToFloat(_184);
    precise float _329 = _328 + _283;
    precise float _332 = uintBitsToFloat(srt_flatbuf_1.data[29u]) * uintBitsToFloat(_203);
    precise float _333 = _332 + _313;
    precise float _336 = uintBitsToFloat(srt_flatbuf_1.data[25u]) * uintBitsToFloat(_221);
    precise float _337 = _336 + _286;
    precise float _340 = uintBitsToFloat(srt_flatbuf_1.data[21u]) * uintBitsToFloat(_240);
    precise float _343 = uintBitsToFloat(srt_flatbuf_1.data[24u]) * uintBitsToFloat(_240);
    precise float _346 = uintBitsToFloat(srt_flatbuf_1.data[31u]) * uintBitsToFloat(_203);
    precise float _347 = _346 + _325;
    precise float _350 = uintBitsToFloat(srt_flatbuf_1.data[27u]) * uintBitsToFloat(_221);
    precise float _351 = _350 + _298;
    precise float _354 = uintBitsToFloat(srt_flatbuf_1.data[23u]) * uintBitsToFloat(_240);
    precise float _357 = uintBitsToFloat(srt_flatbuf_1.data[22u]) * uintBitsToFloat(_240);
    precise float _360 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(_185);
    precise float _361 = _360 + _309;
    precise float _364 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(_185);
    precise float _365 = _364 + _317;
    precise float _368 = uintBitsToFloat(srt_flatbuf_1.data[32u]) * uintBitsToFloat(_203);
    precise float _369 = _368 + _321;
    precise float _372 = uintBitsToFloat(srt_flatbuf_1.data[28u]) * uintBitsToFloat(_221);
    precise float _373 = _372 + _289;
    precise float _376 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(_185);
    precise float _377 = _376 + _293;
    precise float _380 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(_185);
    precise float _381 = _380 + _329;
    precise float _384 = uintBitsToFloat(srt_flatbuf_1.data[30u]) * uintBitsToFloat(_203);
    precise float _385 = _384 + _302;
    precise float _388 = uintBitsToFloat(srt_flatbuf_1.data[26u]) * uintBitsToFloat(_221);
    precise float _389 = _388 + _305;
    precise float _390 = _361 * _111;
    precise float _393 = uintBitsToFloat(srt_flatbuf_1.data[25u]) * uintBitsToFloat(_241);
    precise float _394 = _393 + _340;
    precise float _395 = _365 * _111;
    precise float _398 = uintBitsToFloat(srt_flatbuf_1.data[32u]) * uintBitsToFloat(_222);
    precise float _399 = _398 + _373;
    precise float _400 = _377 * _111;
    precise float _403 = uintBitsToFloat(srt_flatbuf_1.data[27u]) * uintBitsToFloat(_241);
    precise float _404 = _403 + _354;
    precise float _405 = _381 * _111;
    precise float _408 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(_204);
    precise float _409 = _408 + _385;
    precise float _412 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(_204);
    precise float _413 = _412 + _333;
    precise float _416 = uintBitsToFloat(srt_flatbuf_1.data[29u]) * uintBitsToFloat(_222);
    precise float _417 = _416 + _337;
    precise float _420 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(_204);
    precise float _421 = _420 + _369;
    precise float _424 = uintBitsToFloat(srt_flatbuf_1.data[28u]) * uintBitsToFloat(_241);
    precise float _425 = _424 + _343;
    precise float _428 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(_204);
    precise float _429 = _428 + _347;
    precise float _432 = uintBitsToFloat(srt_flatbuf_1.data[31u]) * uintBitsToFloat(_222);
    precise float _433 = _432 + _351;
    precise float _436 = uintBitsToFloat(srt_flatbuf_1.data[30u]) * uintBitsToFloat(_222);
    precise float _437 = _436 + _389;
    precise float _440 = uintBitsToFloat(srt_flatbuf_1.data[26u]) * uintBitsToFloat(_241);
    precise float _441 = _440 + _357;
    precise float _442 = _429 * _112;
    precise float _443 = _442 + _400;
    precise float _446 = uintBitsToFloat(srt_flatbuf_1.data[31u]) * uintBitsToFloat(_242);
    precise float _447 = _446 + _404;
    precise float _448 = _409 * _112;
    precise float _449 = _448 + _405;
    precise float _450 = _112 * _413;
    precise float _451 = _450 + _390;
    precise float _454 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(_223);
    precise float _455 = _454 + _417;
    precise float _458 = uintBitsToFloat(srt_flatbuf_1.data[29u]) * uintBitsToFloat(_242);
    precise float _459 = _458 + _394;
    precise float _460 = _112 * _421;
    precise float _461 = _460 + _395;
    precise float _464 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(_223);
    precise float _465 = _464 + _399;
    precise float _468 = uintBitsToFloat(srt_flatbuf_1.data[32u]) * uintBitsToFloat(_242);
    precise float _469 = _468 + _425;
    precise float _472 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(_223);
    precise float _473 = _472 + _433;
    precise float _476 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(_223);
    precise float _477 = _476 + _437;
    precise float _480 = uintBitsToFloat(srt_flatbuf_1.data[30u]) * uintBitsToFloat(_242);
    precise float _481 = _480 + _441;
    precise float _482 = _455 * _113;
    precise float _483 = _482 + _451;
    precise float _486 = uintBitsToFloat(srt_flatbuf_1.data[35u]) * uintBitsToFloat(_243);
    precise float _487 = _486 + _447;
    precise float _490 = uintBitsToFloat(srt_flatbuf_1.data[33u]) * uintBitsToFloat(_243);
    precise float _491 = _490 + _459;
    precise float _492 = _113 * _465;
    precise float _493 = _492 + _461;
    precise float _496 = uintBitsToFloat(srt_flatbuf_1.data[36u]) * uintBitsToFloat(_243);
    precise float _497 = _496 + _469;
    precise float _498 = _113 * _473;
    precise float _499 = _498 + _443;
    precise float _500 = _113 * _477;
    precise float _501 = _500 + _449;
    precise float _504 = uintBitsToFloat(srt_flatbuf_1.data[34u]) * uintBitsToFloat(_243);
    precise float _505 = _504 + _481;
    precise float _506 = _483 + _491;
    precise float _507 = _493 + _497;
    precise float _508 = _499 + _487;
    precise float _509 = _501 + _505;
    gl_Position.x = _506;
    gl_Position.y = _509;
    gl_Position.z = _508;
    gl_Position.w = _507;
    out_attr0.x = _98.x;
    out_attr0.y = _98.y;
    out_attr0.z = 0.0;
    out_attr0.w = 0.0;
}

