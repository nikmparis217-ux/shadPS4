; SPIR-V
; Version: 1.6
; Generator: Khronos; 0
; Bound: 2361
; Schema: 0
               OpCapability Shader
               OpCapability Image1D
               OpCapability Int64
               OpCapability Sampled1D
               OpCapability UniformAndStorageBuffer8BitAccess
               OpCapability ImageQuery
               OpCapability Int8
               OpCapability Int16
               OpCapability UniformAndStorageBuffer16BitAccess
               OpCapability SignedZeroInfNanPreserve
               OpExtension "SPV_KHR_float_controls"
        %171 = OpExtInstImport "GLSL.std.450"
               OpMemoryModel Logical GLSL450
               OpEntryPoint GLCompute %73 "main" %push_data %gl_WorkGroupID %gl_NumWorkGroups %gl_LocalInvocationID %ssbo_1 %ssbo_2 %ssbo_shmem %cs_img16 %cs_img0 %cs_sampsgpr_24
               OpExecutionMode %73 LocalSize 8 8 16
               OpExecutionMode %73 SignedZeroInfNanPreserve 32
          %1 = OpString "0x7c3468f9"
               OpName %void_id "void_id"
               OpName %bool_id "bool_id"
               OpName %u8_id "u8_id"
               OpName %i8_id "i8_id"
               OpName %u16_id "u16_id"
               OpName %i16_id "i16_id"
               OpName %f32_id "f32_id"
               OpName %i32_id "i32_id"
               OpName %u32_id "u32_id"
               OpName %u64_id "u64_id"
               OpName %f32vec2_id "f32vec2_id"
               OpName %i32vec2_id "i32vec2_id"
               OpName %u32vec2_id "u32vec2_id"
               OpName %bvec2_id "bvec2_id"
               OpName %f32vec3_id "f32vec3_id"
               OpName %i32vec3_id "i32vec3_id"
               OpName %u32vec3_id "u32vec3_id"
               OpName %bvec3_id "bvec3_id"
               OpName %f32vec4_id "f32vec4_id"
               OpName %i32vec4_id "i32vec4_id"
               OpName %u32vec4_id "u32vec4_id"
               OpName %bvec4_id "bvec4_id"
               OpName %input_f32 "input_f32"
               OpName %input_u32 "input_u32"
               OpName %input_s32 "input_s32"
               OpName %output_f32 "output_f32"
               OpName %output_u32 "output_u32"
               OpName %output_s32 "output_s32"
               OpName %full_result_i32x2 "full_result_i32x2"
               OpName %full_result_u32x2 "full_result_u32x2"
               OpName %frexp_result_f32 "frexp_result_f32"
               OpName %AuxData "AuxData"
               OpMemberName %AuxData 0 "xoffset"
               OpMemberName %AuxData 1 "yoffset"
               OpMemberName %AuxData 2 "xscale"
               OpMemberName %AuxData 3 "yscale"
               OpMemberName %AuxData 4 "ud_regs0"
               OpMemberName %AuxData 5 "ud_regs1"
               OpMemberName %AuxData 6 "ud_regs2"
               OpMemberName %AuxData 7 "ud_regs3"
               OpMemberName %AuxData 8 "buf_offsets0"
               OpMemberName %AuxData 9 "buf_offsets1"
               OpMemberName %AuxData 10 "buf_offsets2"
               OpName %push_data "push_data"
               OpMemberName %_struct_53 0 "data"
               OpName %ssbo_1 "ssbo_1"
               OpName %ssbo_2 "ssbo_2"
               OpMemberName %_struct_60 0 "data"
               OpName %ssbo_shmem "ssbo_shmem"
               OpName %cs_img16 "cs_img16"
               OpName %cs_img0 "cs_img0"
               OpName %cs_sampsgpr_24 "cs_sampsgpr:24"
               OpName %workgroup_index "workgroup_index"
               OpName %buf0_off "buf0_off"
               OpName %buf0_dword_off "buf0_dword_off"
               OpName %buf1_off "buf1_off"
               OpName %buf1_dword_off "buf1_dword_off"
               OpDecorate %AuxData Block
               OpMemberDecorate %AuxData 0 Offset 0
               OpMemberDecorate %AuxData 1 Offset 4
               OpMemberDecorate %AuxData 2 Offset 8
               OpMemberDecorate %AuxData 3 Offset 12
               OpMemberDecorate %AuxData 4 Offset 16
               OpMemberDecorate %AuxData 5 Offset 32
               OpMemberDecorate %AuxData 6 Offset 48
               OpMemberDecorate %AuxData 7 Offset 64
               OpMemberDecorate %AuxData 8 Offset 80
               OpMemberDecorate %AuxData 9 Offset 96
               OpMemberDecorate %AuxData 10 Offset 112
               OpDecorate %gl_WorkGroupID BuiltIn WorkgroupId
               OpDecorate %gl_NumWorkGroups BuiltIn NumWorkgroups
               OpDecorate %gl_LocalInvocationID BuiltIn LocalInvocationId
               OpDecorate %_runtimearr_u32_id ArrayStride 4
               OpDecorate %_struct_53 Block
               OpMemberDecorate %_struct_53 0 Offset 0
               OpDecorate %ssbo_1 Binding 0
               OpDecorate %ssbo_1 DescriptorSet 0
               OpDecorate %ssbo_1 NonWritable
               OpDecorate %ssbo_2 Binding 1
               OpDecorate %ssbo_2 DescriptorSet 0
               OpDecorate %_runtimearr_u64_id ArrayStride 8
               OpDecorate %_struct_60 Block
               OpMemberDecorate %_struct_60 0 Offset 0
               OpDecorate %ssbo_shmem Binding 2
               OpDecorate %ssbo_shmem DescriptorSet 0
               OpDecorate %cs_img16 Binding 3
               OpDecorate %cs_img16 DescriptorSet 0
               OpDecorate %cs_img0 Binding 4
               OpDecorate %cs_img0 DescriptorSet 0
               OpDecorate %cs_sampsgpr_24 Binding 5
               OpDecorate %cs_sampsgpr_24 DescriptorSet 0
               OpDecorate %172 NoContraction
               OpDecorate %173 NoContraction
               OpDecorate %175 NoContraction
               OpDecorate %177 NoContraction
               OpDecorate %179 NoContraction
               OpDecorate %180 NoContraction
               OpDecorate %244 NoContraction
               OpDecorate %246 NoContraction
               OpDecorate %248 NoContraction
               OpDecorate %250 NoContraction
               OpDecorate %251 NoContraction
               OpDecorate %253 NoContraction
               OpDecorate %254 NoContraction
               OpDecorate %256 NoContraction
               OpDecorate %257 NoContraction
               OpDecorate %259 NoContraction
               OpDecorate %260 NoContraction
               OpDecorate %263 NoContraction
               OpDecorate %264 NoContraction
               OpDecorate %267 NoContraction
               OpDecorate %268 NoContraction
               OpDecorate %319 NoContraction
               OpDecorate %320 NoContraction
               OpDecorate %322 NoContraction
               OpDecorate %325 NoContraction
               OpDecorate %334 NoContraction
               OpDecorate %335 NoContraction
               OpDecorate %336 NoContraction
               OpDecorate %338 NoContraction
               OpDecorate %349 NoContraction
               OpDecorate %352 NoContraction
               OpDecorate %353 NoContraction
               OpDecorate %356 NoContraction
               OpDecorate %357 NoContraction
               OpDecorate %360 NoContraction
               OpDecorate %362 NoContraction
               OpDecorate %364 NoContraction
               OpDecorate %366 NoContraction
               OpDecorate %369 NoContraction
               OpDecorate %370 NoContraction
               OpDecorate %371 NoContraction
               OpDecorate %373 NoContraction
               OpDecorate %374 NoContraction
               OpDecorate %377 NoContraction
               OpDecorate %378 NoContraction
               OpDecorate %381 NoContraction
               OpDecorate %382 NoContraction
               OpDecorate %385 NoContraction
               OpDecorate %386 NoContraction
               OpDecorate %389 NoContraction
               OpDecorate %390 NoContraction
               OpDecorate %393 NoContraction
               OpDecorate %394 NoContraction
               OpDecorate %397 NoContraction
               OpDecorate %398 NoContraction
               OpDecorate %401 NoContraction
               OpDecorate %402 NoContraction
               OpDecorate %405 NoContraction
               OpDecorate %406 NoContraction
               OpDecorate %409 NoContraction
               OpDecorate %410 NoContraction
               OpDecorate %413 NoContraction
               OpDecorate %414 NoContraction
               OpDecorate %417 NoContraction
               OpDecorate %418 NoContraction
               OpDecorate %421 NoContraction
               OpDecorate %423 NoContraction
               OpDecorate %424 NoContraction
               OpDecorate %426 NoContraction
               OpDecorate %427 NoContraction
               OpDecorate %430 NoContraction
               OpDecorate %432 NoContraction
               OpDecorate %433 NoContraction
               OpDecorate %436 NoContraction
               OpDecorate %437 NoContraction
               OpDecorate %440 NoContraction
               OpDecorate %441 NoContraction
               OpDecorate %444 NoContraction
               OpDecorate %445 NoContraction
               OpDecorate %458 NoContraction
               OpDecorate %462 NoContraction
               OpDecorate %466 NoContraction
               OpDecorate %470 NoContraction
               OpDecorate %490 NoContraction
               OpDecorate %495 NoContraction
               OpDecorate %499 NoContraction
               OpDecorate %503 NoContraction
               OpDecorate %680 NoContraction
               OpDecorate %684 NoContraction
               OpDecorate %688 NoContraction
               OpDecorate %692 NoContraction
               OpDecorate %696 NoContraction
               OpDecorate %700 NoContraction
               OpDecorate %704 NoContraction
               OpDecorate %708 NoContraction
               OpDecorate %712 NoContraction
               OpDecorate %716 NoContraction
               OpDecorate %720 NoContraction
               OpDecorate %724 NoContraction
               OpDecorate %728 NoContraction
               OpDecorate %732 NoContraction
               OpDecorate %736 NoContraction
               OpDecorate %740 NoContraction
               OpDecorate %847 NoContraction
               OpDecorate %850 NoContraction
               OpDecorate %853 NoContraction
               OpDecorate %856 NoContraction
               OpDecorate %858 NoContraction
               OpDecorate %860 NoContraction
               OpDecorate %862 NoContraction
               OpDecorate %864 NoContraction
               OpDecorate %898 NoContraction
               OpDecorate %900 NoContraction
               OpDecorate %902 NoContraction
               OpDecorate %904 NoContraction
               OpDecorate %906 NoContraction
               OpDecorate %908 NoContraction
               OpDecorate %910 NoContraction
               OpDecorate %912 NoContraction
               OpDecorate %946 NoContraction
               OpDecorate %948 NoContraction
               OpDecorate %950 NoContraction
               OpDecorate %952 NoContraction
               OpDecorate %954 NoContraction
               OpDecorate %956 NoContraction
               OpDecorate %958 NoContraction
               OpDecorate %960 NoContraction
               OpDecorate %994 NoContraction
               OpDecorate %996 NoContraction
               OpDecorate %998 NoContraction
               OpDecorate %1000 NoContraction
               OpDecorate %1002 NoContraction
               OpDecorate %1004 NoContraction
               OpDecorate %1006 NoContraction
               OpDecorate %1008 NoContraction
               OpDecorate %1042 NoContraction
               OpDecorate %1044 NoContraction
               OpDecorate %1046 NoContraction
               OpDecorate %1048 NoContraction
               OpDecorate %1050 NoContraction
               OpDecorate %1052 NoContraction
               OpDecorate %1054 NoContraction
               OpDecorate %1056 NoContraction
               OpDecorate %1090 NoContraction
               OpDecorate %1092 NoContraction
               OpDecorate %1094 NoContraction
               OpDecorate %1096 NoContraction
               OpDecorate %1114 NoContraction
               OpDecorate %1116 NoContraction
               OpDecorate %1118 NoContraction
               OpDecorate %1120 NoContraction
               OpDecorate %1122 NoContraction
               OpDecorate %1124 NoContraction
               OpDecorate %1142 NoContraction
               OpDecorate %1144 NoContraction
               OpDecorate %1146 NoContraction
               OpDecorate %1148 NoContraction
               OpDecorate %1166 NoContraction
               OpDecorate %1168 NoContraction
               OpDecorate %1169 NoContraction
               OpDecorate %1170 NoContraction
               OpDecorate %1171 NoContraction
               OpDecorate %1188 NoContraction
               OpDecorate %1207 NoContraction
               OpDecorate %1210 NoContraction
               OpDecorate %1213 NoContraction
               OpDecorate %1216 NoContraction
               OpDecorate %1218 NoContraction
               OpDecorate %1220 NoContraction
               OpDecorate %1222 NoContraction
               OpDecorate %1224 NoContraction
               OpDecorate %1258 NoContraction
               OpDecorate %1260 NoContraction
               OpDecorate %1262 NoContraction
               OpDecorate %1264 NoContraction
               OpDecorate %1266 NoContraction
               OpDecorate %1268 NoContraction
               OpDecorate %1270 NoContraction
               OpDecorate %1272 NoContraction
               OpDecorate %1306 NoContraction
               OpDecorate %1308 NoContraction
               OpDecorate %1310 NoContraction
               OpDecorate %1312 NoContraction
               OpDecorate %1314 NoContraction
               OpDecorate %1316 NoContraction
               OpDecorate %1318 NoContraction
               OpDecorate %1320 NoContraction
               OpDecorate %1354 NoContraction
               OpDecorate %1356 NoContraction
               OpDecorate %1358 NoContraction
               OpDecorate %1360 NoContraction
               OpDecorate %1362 NoContraction
               OpDecorate %1364 NoContraction
               OpDecorate %1366 NoContraction
               OpDecorate %1368 NoContraction
               OpDecorate %1402 NoContraction
               OpDecorate %1404 NoContraction
               OpDecorate %1406 NoContraction
               OpDecorate %1408 NoContraction
               OpDecorate %1410 NoContraction
               OpDecorate %1412 NoContraction
               OpDecorate %1414 NoContraction
               OpDecorate %1416 NoContraction
               OpDecorate %1450 NoContraction
               OpDecorate %1452 NoContraction
               OpDecorate %1454 NoContraction
               OpDecorate %1456 NoContraction
               OpDecorate %1474 NoContraction
               OpDecorate %1476 NoContraction
               OpDecorate %1478 NoContraction
               OpDecorate %1480 NoContraction
               OpDecorate %1482 NoContraction
               OpDecorate %1484 NoContraction
               OpDecorate %1502 NoContraction
               OpDecorate %1504 NoContraction
               OpDecorate %1506 NoContraction
               OpDecorate %1508 NoContraction
               OpDecorate %1526 NoContraction
               OpDecorate %1528 NoContraction
               OpDecorate %1529 NoContraction
               OpDecorate %1530 NoContraction
               OpDecorate %1531 NoContraction
               OpDecorate %1552 NoContraction
               OpDecorate %1571 NoContraction
               OpDecorate %1574 NoContraction
               OpDecorate %1577 NoContraction
               OpDecorate %1580 NoContraction
               OpDecorate %1582 NoContraction
               OpDecorate %1584 NoContraction
               OpDecorate %1586 NoContraction
               OpDecorate %1588 NoContraction
               OpDecorate %1622 NoContraction
               OpDecorate %1624 NoContraction
               OpDecorate %1626 NoContraction
               OpDecorate %1628 NoContraction
               OpDecorate %1630 NoContraction
               OpDecorate %1632 NoContraction
               OpDecorate %1634 NoContraction
               OpDecorate %1636 NoContraction
               OpDecorate %1670 NoContraction
               OpDecorate %1672 NoContraction
               OpDecorate %1674 NoContraction
               OpDecorate %1676 NoContraction
               OpDecorate %1678 NoContraction
               OpDecorate %1680 NoContraction
               OpDecorate %1682 NoContraction
               OpDecorate %1684 NoContraction
               OpDecorate %1718 NoContraction
               OpDecorate %1720 NoContraction
               OpDecorate %1722 NoContraction
               OpDecorate %1724 NoContraction
               OpDecorate %1726 NoContraction
               OpDecorate %1728 NoContraction
               OpDecorate %1730 NoContraction
               OpDecorate %1732 NoContraction
               OpDecorate %1766 NoContraction
               OpDecorate %1768 NoContraction
               OpDecorate %1770 NoContraction
               OpDecorate %1772 NoContraction
               OpDecorate %1774 NoContraction
               OpDecorate %1776 NoContraction
               OpDecorate %1778 NoContraction
               OpDecorate %1780 NoContraction
               OpDecorate %1814 NoContraction
               OpDecorate %1816 NoContraction
               OpDecorate %1818 NoContraction
               OpDecorate %1820 NoContraction
               OpDecorate %1822 NoContraction
               OpDecorate %1824 NoContraction
               OpDecorate %1826 NoContraction
               OpDecorate %1828 NoContraction
               OpDecorate %1874 NoContraction
               OpDecorate %1876 NoContraction
               OpDecorate %1878 NoContraction
               OpDecorate %1880 NoContraction
               OpDecorate %1882 NoContraction
               OpDecorate %1884 NoContraction
               OpDecorate %1886 NoContraction
               OpDecorate %1887 NoContraction
               OpDecorate %1889 NoContraction
               OpDecorate %1907 NoContraction
               OpDecorate %1910 NoContraction
               OpDecorate %1913 NoContraction
               OpDecorate %1916 NoContraction
               OpDecorate %1918 NoContraction
               OpDecorate %1935 NoContraction
               OpDecorate %1936 NoContraction
               OpDecorate %1955 NoContraction
               OpDecorate %1958 NoContraction
               OpDecorate %1961 NoContraction
               OpDecorate %1964 NoContraction
               OpDecorate %1966 NoContraction
               OpDecorate %1968 NoContraction
               OpDecorate %1970 NoContraction
               OpDecorate %1973 NoContraction
               OpDecorate %1975 NoContraction
               OpDecorate %1978 NoContraction
               OpDecorate %1981 NoContraction
               OpDecorate %2015 NoContraction
               OpDecorate %2017 NoContraction
               OpDecorate %2019 NoContraction
               OpDecorate %2021 NoContraction
               OpDecorate %2023 NoContraction
               OpDecorate %2025 NoContraction
               OpDecorate %2027 NoContraction
               OpDecorate %2045 NoContraction
               OpDecorate %2063 NoContraction
               OpDecorate %2065 NoContraction
               OpDecorate %2067 NoContraction
               OpDecorate %2069 NoContraction
               OpDecorate %2071 NoContraction
               OpDecorate %2073 NoContraction
               OpDecorate %2075 NoContraction
               OpDecorate %2093 NoContraction
               OpDecorate %2111 NoContraction
               OpDecorate %2113 NoContraction
               OpDecorate %2115 NoContraction
               OpDecorate %2117 NoContraction
               OpDecorate %2119 NoContraction
               OpDecorate %2121 NoContraction
               OpDecorate %2123 NoContraction
               OpDecorate %2141 NoContraction
               OpDecorate %2159 NoContraction
               OpDecorate %2161 NoContraction
               OpDecorate %2163 NoContraction
               OpDecorate %2165 NoContraction
               OpDecorate %2167 NoContraction
               OpDecorate %2169 NoContraction
               OpDecorate %2171 NoContraction
               OpDecorate %2189 NoContraction
               OpDecorate %2207 NoContraction
               OpDecorate %2209 NoContraction
               OpDecorate %2211 NoContraction
               OpDecorate %2213 NoContraction
               OpDecorate %2215 NoContraction
               OpDecorate %2217 NoContraction
               OpDecorate %2235 NoContraction
               OpDecorate %2237 NoContraction
               OpDecorate %2255 NoContraction
               OpDecorate %2258 NoContraction
               OpDecorate %2260 NoContraction
               OpDecorate %2262 NoContraction
               OpDecorate %2264 NoContraction
               OpDecorate %2266 NoContraction
               OpDecorate %2268 NoContraction
               OpDecorate %2270 NoContraction
               OpDecorate %2272 NoContraction
               OpDecorate %2273 NoContraction
               OpDecorate %2274 NoContraction
               OpDecorate %2275 NoContraction
               OpDecorate %2276 NoContraction
               OpDecorate %2278 NoContraction
               OpDecorate %2281 NoContraction
               OpDecorate %2284 NoContraction
               OpDecorate %2287 NoContraction
               OpDecorate %2304 NoContraction
               OpDecorate %2307 NoContraction
               OpDecorate %2310 NoContraction
               OpDecorate %2313 NoContraction
    %void_id = OpTypeVoid
    %bool_id = OpTypeBool
      %u8_id = OpTypeInt 8 0
      %i8_id = OpTypeInt 8 1
     %u16_id = OpTypeInt 16 0
     %i16_id = OpTypeInt 16 1
     %f32_id = OpTypeFloat 32
     %i32_id = OpTypeInt 32 1
     %u32_id = OpTypeInt 32 0
     %u64_id = OpTypeInt 64 0
 %f32vec2_id = OpTypeVector %f32_id 2
 %i32vec2_id = OpTypeVector %i32_id 2
 %u32vec2_id = OpTypeVector %u32_id 2
   %bvec2_id = OpTypeVector %bool_id 2
 %f32vec3_id = OpTypeVector %f32_id 3
 %i32vec3_id = OpTypeVector %i32_id 3
 %u32vec3_id = OpTypeVector %u32_id 3
   %bvec3_id = OpTypeVector %bool_id 3
 %f32vec4_id = OpTypeVector %f32_id 4
 %i32vec4_id = OpTypeVector %i32_id 4
 %u32vec4_id = OpTypeVector %u32_id 4
   %bvec4_id = OpTypeVector %bool_id 4
       %true = OpConstantTrue %bool_id
      %false = OpConstantFalse %bool_id
    %u8_id_1 = OpConstant %u8_id 1
    %u8_id_0 = OpConstant %u8_id 0
   %u16_id_0 = OpConstant %u16_id 0
   %u32_id_1 = OpConstant %u32_id 1
   %u32_id_0 = OpConstant %u32_id 0
   %f32_id_0 = OpConstant %f32_id 0
   %u64_id_1 = OpConstant %u64_id 1
   %u64_id_0 = OpConstant %u64_id 0
%f32_id_6_28318548 = OpConstant %f32_id 6.28318548
  %input_f32 = OpTypePointer Input %f32_id
  %input_u32 = OpTypePointer Input %u32_id
  %input_s32 = OpTypePointer Input %i32_id
 %output_f32 = OpTypePointer Output %f32_id
 %output_u32 = OpTypePointer Output %u32_id
 %output_s32 = OpTypePointer Output %i32_id
%full_result_i32x2 = OpTypeStruct %i32_id %i32_id
%full_result_u32x2 = OpTypeStruct %u32_id %u32_id
%frexp_result_f32 = OpTypeStruct %f32_id %i32_id
    %AuxData = OpTypeStruct %f32_id %f32_id %f32_id %f32_id %u32vec4_id %u32vec4_id %u32vec4_id %u32vec4_id %u32vec4_id %u32vec4_id %u32vec2_id
%_ptr_PushConstant_AuxData = OpTypePointer PushConstant %AuxData
%_ptr_Input_u32vec3_id = OpTypePointer Input %u32vec3_id
%u32_id_16368 = OpConstant %u32_id 16368
%_runtimearr_u32_id = OpTypeRuntimeArray %u32_id
 %_struct_53 = OpTypeStruct %_runtimearr_u32_id
%_ptr_StorageBuffer__struct_53 = OpTypePointer StorageBuffer %_struct_53
%_ptr_StorageBuffer_u32_id = OpTypePointer StorageBuffer %u32_id
%u32_id_8184 = OpConstant %u32_id 8184
%_runtimearr_u64_id = OpTypeRuntimeArray %u64_id
 %_struct_60 = OpTypeStruct %_runtimearr_u64_id
%_ptr_StorageBuffer__struct_60 = OpTypePointer StorageBuffer %_struct_60
%_ptr_StorageBuffer_u64_id = OpTypePointer StorageBuffer %u64_id
         %64 = OpTypeImage %f32_id 2D 0 1 0 1 Unknown
%_ptr_UniformConstant_64 = OpTypePointer UniformConstant %64
         %67 = OpTypeSampledImage %64
         %69 = OpTypeSampler
%_ptr_UniformConstant_69 = OpTypePointer UniformConstant %69
         %72 = OpTypeFunction %void_id
   %u32_id_8 = OpConstant %u32_id 8
%_ptr_PushConstant_u32_id = OpTypePointer PushConstant %u32_id
   %u32_id_2 = OpConstant %u32_id 2
   %u32_id_3 = OpConstant %u32_id 3
  %u32_id_72 = OpConstant %u32_id 72
  %u32_id_73 = OpConstant %u32_id 73
  %u32_id_75 = OpConstant %u32_id 75
  %u32_id_79 = OpConstant %u32_id 79
  %u32_id_80 = OpConstant %u32_id 80
  %u32_id_81 = OpConstant %u32_id 81
  %u32_id_82 = OpConstant %u32_id 82
%f32_id_0_0625 = OpConstant %f32_id 0.0625
%f32_id_0_125 = OpConstant %f32_id 0.125
   %f32_id_1 = OpConstant %f32_id 1
  %u32_id_16 = OpConstant %u32_id 16
  %u32_id_96 = OpConstant %u32_id 96
 %u32_id_192 = OpConstant %u32_id 192
   %f32_id_8 = OpConstant %f32_id 8
  %f32_id_n2 = OpConstant %f32_id -2
   %u32_id_6 = OpConstant %u32_id 6
  %u32_id_24 = OpConstant %u32_id 24
  %u32_id_64 = OpConstant %u32_id 64
%u32_id_65536 = OpConstant %u32_id 65536
  %u32_id_32 = OpConstant %u32_id 32
  %u32_id_40 = OpConstant %u32_id 40
  %u32_id_48 = OpConstant %u32_id 48
  %u32_id_56 = OpConstant %u32_id 56
 %u32_id_264 = OpConstant %u32_id 264
 %u32_id_112 = OpConstant %u32_id 112
 %u32_id_120 = OpConstant %u32_id 120
 %u32_id_104 = OpConstant %u32_id 104
  %u32_id_88 = OpConstant %u32_id 88
  %u32_id_63 = OpConstant %u32_id 63
  %u32_id_12 = OpConstant %u32_id 12
%u32_id_4096 = OpConstant %u32_id 4096
%u32_id_4104 = OpConstant %u32_id 4104
%u32_id_8192 = OpConstant %u32_id 8192
%u32_id_8200 = OpConstant %u32_id 8200
%u32_id_12288 = OpConstant %u32_id 12288
%u32_id_12296 = OpConstant %u32_id 12296
%u32_id_16384 = OpConstant %u32_id 16384
%u32_id_16392 = OpConstant %u32_id 16392
%u32_id_20480 = OpConstant %u32_id 20480
%u32_id_20488 = OpConstant %u32_id 20488
%u32_id_24576 = OpConstant %u32_id 24576
%u32_id_24584 = OpConstant %u32_id 24584
%u32_id_28672 = OpConstant %u32_id 28672
%u32_id_28680 = OpConstant %u32_id 28680
%u32_id_32768 = OpConstant %u32_id 32768
%u32_id_32776 = OpConstant %u32_id 32776
%u32_id_36864 = OpConstant %u32_id 36864
%u32_id_36872 = OpConstant %u32_id 36872
%u32_id_40960 = OpConstant %u32_id 40960
%u32_id_40968 = OpConstant %u32_id 40968
%u32_id_45056 = OpConstant %u32_id 45056
%u32_id_45064 = OpConstant %u32_id 45064
%u32_id_49152 = OpConstant %u32_id 49152
%u32_id_49160 = OpConstant %u32_id 49160
%u32_id_53248 = OpConstant %u32_id 53248
%u32_id_53256 = OpConstant %u32_id 53256
%u32_id_57344 = OpConstant %u32_id 57344
%u32_id_57352 = OpConstant %u32_id 57352
%u32_id_61440 = OpConstant %u32_id 61440
%u32_id_61448 = OpConstant %u32_id 61448
%u32_id_4112 = OpConstant %u32_id 4112
%u32_id_4120 = OpConstant %u32_id 4120
%u32_id_8208 = OpConstant %u32_id 8208
%u32_id_8216 = OpConstant %u32_id 8216
%u32_id_12304 = OpConstant %u32_id 12304
%u32_id_12312 = OpConstant %u32_id 12312
%u32_id_16400 = OpConstant %u32_id 16400
%u32_id_16408 = OpConstant %u32_id 16408
%u32_id_20496 = OpConstant %u32_id 20496
%u32_id_20504 = OpConstant %u32_id 20504
%u32_id_24592 = OpConstant %u32_id 24592
%u32_id_24600 = OpConstant %u32_id 24600
%u32_id_28688 = OpConstant %u32_id 28688
%u32_id_28696 = OpConstant %u32_id 28696
%u32_id_32784 = OpConstant %u32_id 32784
%u32_id_32792 = OpConstant %u32_id 32792
%u32_id_36880 = OpConstant %u32_id 36880
%u32_id_36888 = OpConstant %u32_id 36888
%u32_id_40976 = OpConstant %u32_id 40976
%u32_id_40984 = OpConstant %u32_id 40984
%u32_id_45072 = OpConstant %u32_id 45072
%u32_id_45080 = OpConstant %u32_id 45080
%u32_id_49168 = OpConstant %u32_id 49168
%u32_id_49176 = OpConstant %u32_id 49176
%u32_id_53264 = OpConstant %u32_id 53264
%u32_id_53272 = OpConstant %u32_id 53272
%u32_id_57360 = OpConstant %u32_id 57360
%u32_id_57368 = OpConstant %u32_id 57368
%u32_id_61456 = OpConstant %u32_id 61456
%u32_id_61464 = OpConstant %u32_id 61464
%u32_id_4128 = OpConstant %u32_id 4128
%u32_id_4136 = OpConstant %u32_id 4136
%u32_id_8224 = OpConstant %u32_id 8224
%u32_id_8232 = OpConstant %u32_id 8232
  %u32_id_74 = OpConstant %u32_id 74
%u32_id_12320 = OpConstant %u32_id 12320
%u32_id_12328 = OpConstant %u32_id 12328
%u32_id_16416 = OpConstant %u32_id 16416
%u32_id_16424 = OpConstant %u32_id 16424
%u32_id_20512 = OpConstant %u32_id 20512
%u32_id_20520 = OpConstant %u32_id 20520
%u32_id_24608 = OpConstant %u32_id 24608
%u32_id_24616 = OpConstant %u32_id 24616
%u32_id_28704 = OpConstant %u32_id 28704
%u32_id_28712 = OpConstant %u32_id 28712
%u32_id_32800 = OpConstant %u32_id 32800
%u32_id_32808 = OpConstant %u32_id 32808
%u32_id_36896 = OpConstant %u32_id 36896
%u32_id_36904 = OpConstant %u32_id 36904
%u32_id_40992 = OpConstant %u32_id 40992
%u32_id_41000 = OpConstant %u32_id 41000
%u32_id_45088 = OpConstant %u32_id 45088
%u32_id_45096 = OpConstant %u32_id 45096
%u32_id_49184 = OpConstant %u32_id 49184
%u32_id_49192 = OpConstant %u32_id 49192
%u32_id_53280 = OpConstant %u32_id 53280
%u32_id_53288 = OpConstant %u32_id 53288
%u32_id_57376 = OpConstant %u32_id 57376
%u32_id_57384 = OpConstant %u32_id 57384
%u32_id_61472 = OpConstant %u32_id 61472
%u32_id_61480 = OpConstant %u32_id 61480
  %u32_id_76 = OpConstant %u32_id 76
  %u32_id_77 = OpConstant %u32_id 77
  %u32_id_78 = OpConstant %u32_id 78
%u32_id_4144 = OpConstant %u32_id 4144
%u32_id_4152 = OpConstant %u32_id 4152
%u32_id_8240 = OpConstant %u32_id 8240
%u32_id_8248 = OpConstant %u32_id 8248
%u32_id_12336 = OpConstant %u32_id 12336
%u32_id_12344 = OpConstant %u32_id 12344
%u32_id_16432 = OpConstant %u32_id 16432
%u32_id_16440 = OpConstant %u32_id 16440
%u32_id_20528 = OpConstant %u32_id 20528
%u32_id_20536 = OpConstant %u32_id 20536
%u32_id_24624 = OpConstant %u32_id 24624
%u32_id_24632 = OpConstant %u32_id 24632
%u32_id_28720 = OpConstant %u32_id 28720
%u32_id_28728 = OpConstant %u32_id 28728
%u32_id_32816 = OpConstant %u32_id 32816
%u32_id_32824 = OpConstant %u32_id 32824
%u32_id_36912 = OpConstant %u32_id 36912
%u32_id_36920 = OpConstant %u32_id 36920
%u32_id_41008 = OpConstant %u32_id 41008
%u32_id_41016 = OpConstant %u32_id 41016
%u32_id_45104 = OpConstant %u32_id 45104
%u32_id_45112 = OpConstant %u32_id 45112
%u32_id_49200 = OpConstant %u32_id 49200
%u32_id_49208 = OpConstant %u32_id 49208
%u32_id_53296 = OpConstant %u32_id 53296
%u32_id_53304 = OpConstant %u32_id 53304
%u32_id_57392 = OpConstant %u32_id 57392
%u32_id_57400 = OpConstant %u32_id 57400
%u32_id_61488 = OpConstant %u32_id 61488
%u32_id_61496 = OpConstant %u32_id 61496
   %u32_id_4 = OpConstant %u32_id 4
  %push_data = OpVariable %_ptr_PushConstant_AuxData PushConstant
%gl_WorkGroupID = OpVariable %_ptr_Input_u32vec3_id Input
%gl_NumWorkGroups = OpVariable %_ptr_Input_u32vec3_id Input
%gl_LocalInvocationID = OpVariable %_ptr_Input_u32vec3_id Input
     %ssbo_1 = OpVariable %_ptr_StorageBuffer__struct_53 StorageBuffer
     %ssbo_2 = OpVariable %_ptr_StorageBuffer__struct_53 StorageBuffer
 %ssbo_shmem = OpVariable %_ptr_StorageBuffer__struct_60 StorageBuffer
   %cs_img16 = OpVariable %_ptr_UniformConstant_64 UniformConstant
    %cs_img0 = OpVariable %_ptr_UniformConstant_64 UniformConstant
%cs_sampsgpr_24 = OpVariable %_ptr_UniformConstant_69 UniformConstant
         %73 = OpFunction %void_id None %72
         %74 = OpLabel
        %102 = OpLoad %u32vec3_id %gl_WorkGroupID
        %103 = OpCompositeExtract %u32_id %102 0
        %104 = OpCompositeExtract %u32_id %102 1
        %105 = OpCompositeExtract %u32_id %102 2
        %106 = OpLoad %u32vec3_id %gl_NumWorkGroups
        %107 = OpCompositeExtract %u32_id %106 0
        %108 = OpCompositeExtract %u32_id %106 1
        %109 = OpIMul %u32_id %107 %108
        %110 = OpIMul %u32_id %105 %109
        %111 = OpIMul %u32_id %104 %107
        %112 = OpIAdd %u32_id %103 %111
%workgroup_index = OpIAdd %u32_id %112 %110
        %116 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
        %117 = OpLoad %u32_id %116
   %buf0_off = OpBitFieldUExtract %u32_id %117 %u32_id_0 %u32_id_8
%buf0_dword_off = OpShiftRightLogical %u32_id %buf0_off %u32_id_2
        %121 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
        %122 = OpLoad %u32_id %121
   %buf1_off = OpBitFieldUExtract %u32_id %122 %u32_id_8 %u32_id_8
%buf1_dword_off = OpShiftRightLogical %u32_id %buf1_off %u32_id_2
        %125 = OpLoad %u32vec3_id %gl_LocalInvocationID
        %126 = OpCompositeExtract %u32_id %125 0
        %127 = OpLoad %u32vec3_id %gl_LocalInvocationID
        %128 = OpCompositeExtract %u32_id %127 1
        %129 = OpLoad %u32vec3_id %gl_LocalInvocationID
        %130 = OpCompositeExtract %u32_id %129 2
        %131 = OpShiftRightLogical %u32_id %130 %u32_id_2
        %133 = OpBitwiseAnd %u32_id %u32_id_3 %130
        %135 = OpIAdd %u32_id %u32_id_72 %buf0_dword_off
        %136 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %135
        %137 = OpLoad %u32_id %136
        %139 = OpIAdd %u32_id %u32_id_73 %buf0_dword_off
        %140 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %139
        %141 = OpLoad %u32_id %140
        %143 = OpIAdd %u32_id %u32_id_75 %buf0_dword_off
        %144 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %143
        %145 = OpLoad %u32_id %144
        %147 = OpIAdd %u32_id %u32_id_79 %buf0_dword_off
        %148 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %147
        %149 = OpLoad %u32_id %148
        %151 = OpIAdd %u32_id %u32_id_80 %buf0_dword_off
        %152 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %151
        %153 = OpLoad %u32_id %152
        %155 = OpIAdd %u32_id %u32_id_81 %buf0_dword_off
        %156 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %155
        %157 = OpLoad %u32_id %156
        %159 = OpIAdd %u32_id %u32_id_82 %buf0_dword_off
        %160 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %159
        %161 = OpLoad %u32_id %160
        %162 = OpShiftLeftLogical %u32_id %137 %u32_id_3
        %163 = OpIMul %u32_id %162 %131
        %164 = OpIMul %u32_id %162 %133
        %165 = OpIAdd %u32_id %126 %163
        %166 = OpIAdd %u32_id %128 %164
        %167 = OpConvertUToF %f32_id %165
        %168 = OpConvertUToF %f32_id %166
        %172 = OpExtInst %f32_id %171 Fma %f32_id_0_125 %167 %f32_id_0_0625
        %173 = OpExtInst %f32_id %171 Fma %f32_id_0_125 %168 %f32_id_0_0625
        %174 = OpBitcast %f32_id %145
        %175 = OpFMul %f32_id %174 %172
        %177 = OpFAdd %f32_id %175 %f32_id_1
        %178 = OpBitcast %f32_id %145
        %179 = OpFMul %f32_id %178 %173
        %180 = OpFAdd %f32_id %179 %f32_id_1
        %181 = OpConvertUToF %f32_id %141
               OpBranch %75
         %75 = OpLabel
        %182 = OpPhi %u32_id %u32_id_0 %74 %517 %91
        %183 = OpPhi %u32_id %u32_id_0 %74 %518 %91
        %184 = OpPhi %u32_id %u32_id_0 %74 %519 %91
        %185 = OpPhi %u32_id %u32_id_0 %74 %520 %91
        %186 = OpPhi %u32_id %u32_id_0 %74 %505 %91
        %187 = OpPhi %u32_id %u32_id_0 %74 %506 %91
        %188 = OpPhi %u32_id %u32_id_0 %74 %507 %91
        %189 = OpPhi %u32_id %u32_id_0 %74 %508 %91
        %190 = OpPhi %u32_id %u32_id_0 %74 %509 %91
        %191 = OpPhi %u32_id %u32_id_0 %74 %510 %91
        %192 = OpPhi %u32_id %u32_id_0 %74 %511 %91
        %193 = OpPhi %u32_id %u32_id_0 %74 %512 %91
        %194 = OpPhi %u32_id %u32_id_0 %74 %513 %91
        %195 = OpPhi %u32_id %u32_id_0 %74 %514 %91
        %196 = OpPhi %u32_id %u32_id_0 %74 %515 %91
        %197 = OpPhi %u32_id %u32_id_0 %74 %516 %91
        %198 = OpPhi %u32_id %u32_id_0 %74 %521 %91
               OpLoopMerge %92 %91 None
               OpBranch %76
         %76 = OpLabel
        %199 = OpConvertUToF %f32_id %198
        %201 = OpIMul %u32_id %198 %u32_id_16
        %203 = OpIAdd %u32_id %201 %u32_id_96
        %205 = OpIAdd %u32_id %201 %u32_id_192
        %206 = OpShiftRightLogical %u32_id %201 %u32_id_2
        %207 = OpIAdd %u32_id %206 %buf0_dword_off
        %208 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %207
        %209 = OpLoad %u32_id %208
        %210 = OpIAdd %u32_id %206 %u32_id_1
        %211 = OpIAdd %u32_id %210 %buf0_dword_off
        %212 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %211
        %213 = OpLoad %u32_id %212
        %214 = OpIAdd %u32_id %206 %u32_id_2
        %215 = OpIAdd %u32_id %214 %buf0_dword_off
        %216 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %215
        %217 = OpLoad %u32_id %216
        %218 = OpShiftRightLogical %u32_id %203 %u32_id_2
        %219 = OpIAdd %u32_id %218 %buf0_dword_off
        %220 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %219
        %221 = OpLoad %u32_id %220
        %222 = OpIAdd %u32_id %218 %u32_id_1
        %223 = OpIAdd %u32_id %222 %buf0_dword_off
        %224 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %223
        %225 = OpLoad %u32_id %224
        %226 = OpIAdd %u32_id %218 %u32_id_2
        %227 = OpIAdd %u32_id %226 %buf0_dword_off
        %228 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %227
        %229 = OpLoad %u32_id %228
        %230 = OpShiftRightLogical %u32_id %205 %u32_id_2
        %231 = OpIAdd %u32_id %230 %buf0_dword_off
        %232 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %231
        %233 = OpLoad %u32_id %232
        %234 = OpIAdd %u32_id %230 %u32_id_1
        %235 = OpIAdd %u32_id %234 %buf0_dword_off
        %236 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %235
        %237 = OpLoad %u32_id %236
        %238 = OpIAdd %u32_id %230 %u32_id_2
        %239 = OpIAdd %u32_id %238 %buf0_dword_off
        %240 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %239
        %241 = OpLoad %u32_id %240
        %242 = OpBitcast %u32_id %180
        %243 = OpBitcast %f32_id %209
        %244 = OpFMul %f32_id %243 %167
        %245 = OpBitcast %f32_id %213
        %246 = OpFMul %f32_id %245 %167
        %247 = OpBitcast %f32_id %217
        %248 = OpFMul %f32_id %247 %167
        %249 = OpBitcast %f32_id %221
        %250 = OpFMul %f32_id %249 %168
        %251 = OpFAdd %f32_id %250 %244
        %252 = OpBitcast %f32_id %225
        %253 = OpFMul %f32_id %252 %168
        %254 = OpFAdd %f32_id %253 %246
        %255 = OpBitcast %f32_id %229
        %256 = OpFMul %f32_id %255 %168
        %257 = OpFAdd %f32_id %256 %248
        %258 = OpBitcast %f32_id %233
        %259 = OpFMul %f32_id %f32_id_0_125 %251
        %260 = OpFAdd %f32_id %259 %258
        %261 = OpBitcast %u32_id %260
        %262 = OpBitcast %f32_id %237
        %263 = OpFMul %f32_id %f32_id_0_125 %254
        %264 = OpFAdd %f32_id %263 %262
        %265 = OpBitcast %u32_id %264
        %266 = OpBitcast %f32_id %241
        %267 = OpFMul %f32_id %f32_id_0_125 %257
        %268 = OpFAdd %f32_id %267 %266
        %269 = OpBitcast %u32_id %268
               OpBranch %77
         %77 = OpLabel
        %270 = OpPhi %u32_id %182 %76 %484 %89
        %271 = OpPhi %u32_id %183 %76 %485 %89
        %272 = OpPhi %u32_id %184 %76 %486 %89
        %273 = OpPhi %u32_id %185 %76 %487 %89
        %274 = OpPhi %u32_id %186 %76 %472 %89
        %275 = OpPhi %u32_id %187 %76 %473 %89
        %276 = OpPhi %u32_id %188 %76 %474 %89
        %277 = OpPhi %u32_id %189 %76 %475 %89
        %278 = OpPhi %u32_id %190 %76 %476 %89
        %279 = OpPhi %u32_id %191 %76 %477 %89
        %280 = OpPhi %u32_id %192 %76 %478 %89
        %281 = OpPhi %u32_id %193 %76 %479 %89
        %282 = OpPhi %u32_id %194 %76 %480 %89
        %283 = OpPhi %u32_id %195 %76 %481 %89
        %284 = OpPhi %u32_id %196 %76 %482 %89
        %285 = OpPhi %u32_id %197 %76 %483 %89
        %286 = OpPhi %u32_id %242 %76 %491 %89
        %287 = OpPhi %u32_id %269 %76 %504 %89
        %288 = OpPhi %u32_id %265 %76 %500 %89
        %289 = OpPhi %u32_id %261 %76 %496 %89
        %290 = OpPhi %u32_id %u32_id_0 %76 %492 %89
               OpLoopMerge %90 %89 None
               OpBranch %78
         %78 = OpLabel
        %291 = OpULessThan %bool_id %290 %137
        %292 = OpLogicalNot %bool_id %291
               OpBranchConditional %292 %90 %79
         %79 = OpLabel
        %293 = OpBitcast %u32_id %177
               OpBranch %80
         %80 = OpLabel
        %294 = OpPhi %u32_id %270 %79 %451 %87
        %295 = OpPhi %u32_id %271 %79 %452 %87
        %296 = OpPhi %u32_id %272 %79 %453 %87
        %297 = OpPhi %u32_id %273 %79 %454 %87
        %298 = OpPhi %u32_id %274 %79 %411 %87
        %299 = OpPhi %u32_id %275 %79 %415 %87
        %300 = OpPhi %u32_id %276 %79 %419 %87
        %301 = OpPhi %u32_id %277 %79 %407 %87
        %302 = OpPhi %u32_id %278 %79 %395 %87
        %303 = OpPhi %u32_id %279 %79 %399 %87
        %304 = OpPhi %u32_id %280 %79 %403 %87
        %305 = OpPhi %u32_id %281 %79 %391 %87
        %306 = OpPhi %u32_id %282 %79 %379 %87
        %307 = OpPhi %u32_id %283 %79 %383 %87
        %308 = OpPhi %u32_id %284 %79 %387 %87
        %309 = OpPhi %u32_id %285 %79 %375 %87
        %310 = OpPhi %u32_id %287 %79 %471 %87
        %311 = OpPhi %u32_id %288 %79 %467 %87
        %312 = OpPhi %u32_id %289 %79 %463 %87
        %313 = OpPhi %u32_id %293 %79 %459 %87
        %314 = OpPhi %u32_id %u32_id_0 %79 %455 %87
               OpLoopMerge %88 %87 None
               OpBranch %81
         %81 = OpLabel
        %315 = OpULessThan %bool_id %314 %137
        %316 = OpLogicalNot %bool_id %315
               OpBranchConditional %316 %88 %82
         %82 = OpLabel
        %317 = OpBitcast %f32_id %286
        %318 = OpBitcast %f32_id %313
        %319 = OpFSub %f32_id %318 %f32_id_1
        %320 = OpFSub %f32_id %317 %f32_id_1
        %322 = OpFDiv %f32_id %199 %f32_id_8
        %323 = OpExtInst %f32_id %171 Floor %322
        %325 = OpExtInst %f32_id %171 Fma %323 %f32_id_n2 %199
        %326 = OpCompositeConstruct %f32vec3_id %319 %320 %325
        %327 = OpLoad %64 %cs_img16
        %328 = OpLoad %69 %cs_sampsgpr_24
        %329 = OpSampledImage %67 %327 %328
        %330 = OpImageSampleExplicitLod %f32vec4_id %329 %326 Lod %f32_id_0
        %331 = OpCompositeExtract %f32_id %330 0
        %332 = OpBitcast %f32_id %286
        %333 = OpBitcast %f32_id %313
        %334 = OpFSub %f32_id %333 %f32_id_1
        %335 = OpFSub %f32_id %332 %f32_id_1
        %336 = OpFDiv %f32_id %199 %f32_id_8
        %337 = OpExtInst %f32_id %171 Floor %336
        %338 = OpExtInst %f32_id %171 Fma %337 %f32_id_n2 %199
        %339 = OpCompositeConstruct %f32vec3_id %334 %335 %338
        %340 = OpLoad %64 %cs_img0
        %341 = OpLoad %69 %cs_sampsgpr_24
        %342 = OpSampledImage %67 %340 %341
        %343 = OpImageSampleExplicitLod %f32vec4_id %342 %339 Lod %181
        %344 = OpCompositeExtract %f32_id %343 0
        %345 = OpCompositeExtract %f32_id %343 1
        %346 = OpCompositeExtract %f32_id %343 2
        %347 = OpBitcast %f32_id %312
        %348 = OpBitcast %f32_id %312
        %349 = OpFMul %f32_id %348 %347
        %350 = OpBitcast %f32_id %311
        %351 = OpBitcast %f32_id %311
        %352 = OpFMul %f32_id %350 %351
        %353 = OpFAdd %f32_id %352 %349
        %354 = OpBitcast %f32_id %310
        %355 = OpBitcast %f32_id %310
        %356 = OpFMul %f32_id %354 %355
        %357 = OpFAdd %f32_id %356 %353
        %358 = OpExtInst %f32_id %171 InverseSqrt %357
        %359 = OpFDiv %f32_id %f32_id_1 %357
        %360 = OpFMul %f32_id %358 %359
        %361 = OpBitcast %f32_id %312
        %362 = OpFMul %f32_id %358 %361
        %363 = OpBitcast %f32_id %311
        %364 = OpFMul %f32_id %358 %363
        %365 = OpBitcast %f32_id %310
        %366 = OpFMul %f32_id %358 %365
        %367 = OpBitcast %f32_id %149
        %368 = OpFOrdGreaterThan %bool_id %367 %331
        %369 = OpFMul %f32_id %344 %360
        %370 = OpFMul %f32_id %345 %360
        %371 = OpFMul %f32_id %346 %360
        %372 = OpBitcast %f32_id %309
        %373 = OpFMul %f32_id %360 %346
        %374 = OpFAdd %f32_id %373 %372
        %375 = OpBitcast %u32_id %374
        %376 = OpBitcast %f32_id %306
        %377 = OpFMul %f32_id %366 %371
        %378 = OpFAdd %f32_id %377 %376
        %379 = OpBitcast %u32_id %378
        %380 = OpBitcast %f32_id %307
        %381 = OpFMul %f32_id %364 %371
        %382 = OpFAdd %f32_id %381 %380
        %383 = OpBitcast %u32_id %382
        %384 = OpBitcast %f32_id %308
        %385 = OpFMul %f32_id %362 %371
        %386 = OpFAdd %f32_id %385 %384
        %387 = OpBitcast %u32_id %386
        %388 = OpBitcast %f32_id %305
        %389 = OpFMul %f32_id %360 %345
        %390 = OpFAdd %f32_id %389 %388
        %391 = OpBitcast %u32_id %390
        %392 = OpBitcast %f32_id %302
        %393 = OpFMul %f32_id %366 %370
        %394 = OpFAdd %f32_id %393 %392
        %395 = OpBitcast %u32_id %394
        %396 = OpBitcast %f32_id %303
        %397 = OpFMul %f32_id %364 %370
        %398 = OpFAdd %f32_id %397 %396
        %399 = OpBitcast %u32_id %398
        %400 = OpBitcast %f32_id %304
        %401 = OpFMul %f32_id %362 %370
        %402 = OpFAdd %f32_id %401 %400
        %403 = OpBitcast %u32_id %402
        %404 = OpBitcast %f32_id %301
        %405 = OpFMul %f32_id %360 %344
        %406 = OpFAdd %f32_id %405 %404
        %407 = OpBitcast %u32_id %406
        %408 = OpBitcast %f32_id %298
        %409 = OpFMul %f32_id %366 %369
        %410 = OpFAdd %f32_id %409 %408
        %411 = OpBitcast %u32_id %410
        %412 = OpBitcast %f32_id %299
        %413 = OpFMul %f32_id %364 %369
        %414 = OpFAdd %f32_id %413 %412
        %415 = OpBitcast %u32_id %414
        %416 = OpBitcast %f32_id %300
        %417 = OpFMul %f32_id %362 %369
        %418 = OpFAdd %f32_id %417 %416
        %419 = OpBitcast %u32_id %418
               OpSelectionMerge %86 None
               OpBranchConditional %368 %83 %86
         %83 = OpLabel
        %420 = OpBitcast %f32_id %153
        %421 = OpFMul %f32_id %420 %362
        %422 = OpBitcast %f32_id %157
        %423 = OpFMul %f32_id %422 %364
        %424 = OpFAdd %f32_id %423 %421
        %425 = OpBitcast %f32_id %161
        %426 = OpFMul %f32_id %425 %366
        %427 = OpFAdd %f32_id %426 %424
        %428 = OpFOrdLessThan %bool_id %f32_id_0 %427
        %429 = OpLogicalAnd %bool_id %368 %428
               OpSelectionMerge %85 None
               OpBranchConditional %429 %84 %85
         %84 = OpLabel
        %430 = OpFMul %f32_id %427 %360
        %431 = OpBitcast %f32_id %297
        %432 = OpFMul %f32_id %360 %427
        %433 = OpFAdd %f32_id %432 %431
        %434 = OpBitcast %u32_id %433
        %435 = OpBitcast %f32_id %294
        %436 = OpFMul %f32_id %366 %430
        %437 = OpFAdd %f32_id %436 %435
        %438 = OpBitcast %u32_id %437
        %439 = OpBitcast %f32_id %295
        %440 = OpFMul %f32_id %364 %430
        %441 = OpFAdd %f32_id %440 %439
        %442 = OpBitcast %u32_id %441
        %443 = OpBitcast %f32_id %296
        %444 = OpFMul %f32_id %362 %430
        %445 = OpFAdd %f32_id %444 %443
        %446 = OpBitcast %u32_id %445
               OpBranch %85
         %85 = OpLabel
        %447 = OpPhi %u32_id %438 %84 %294 %83
        %448 = OpPhi %u32_id %442 %84 %295 %83
        %449 = OpPhi %u32_id %446 %84 %296 %83
        %450 = OpPhi %u32_id %434 %84 %297 %83
               OpBranch %86
         %86 = OpLabel
        %451 = OpPhi %u32_id %447 %85 %294 %82
        %452 = OpPhi %u32_id %448 %85 %295 %82
        %453 = OpPhi %u32_id %449 %85 %296 %82
        %454 = OpPhi %u32_id %450 %85 %297 %82
        %455 = OpIAdd %u32_id %314 %u32_id_1
        %456 = OpBitcast %f32_id %145
        %457 = OpBitcast %f32_id %313
        %458 = OpFAdd %f32_id %456 %457
        %459 = OpBitcast %u32_id %458
        %460 = OpBitcast %f32_id %209
        %461 = OpBitcast %f32_id %312
        %462 = OpFAdd %f32_id %460 %461
        %463 = OpBitcast %u32_id %462
        %464 = OpBitcast %f32_id %213
        %465 = OpBitcast %f32_id %311
        %466 = OpFAdd %f32_id %464 %465
        %467 = OpBitcast %u32_id %466
        %468 = OpBitcast %f32_id %217
        %469 = OpBitcast %f32_id %310
        %470 = OpFAdd %f32_id %468 %469
        %471 = OpBitcast %u32_id %470
               OpBranch %87
         %87 = OpLabel
               OpBranchConditional %true %80 %88
         %88 = OpLabel
        %472 = OpPhi %u32_id %298 %81 %411 %87
        %473 = OpPhi %u32_id %299 %81 %415 %87
        %474 = OpPhi %u32_id %300 %81 %419 %87
        %475 = OpPhi %u32_id %301 %81 %407 %87
        %476 = OpPhi %u32_id %302 %81 %395 %87
        %477 = OpPhi %u32_id %303 %81 %399 %87
        %478 = OpPhi %u32_id %304 %81 %403 %87
        %479 = OpPhi %u32_id %305 %81 %391 %87
        %480 = OpPhi %u32_id %306 %81 %379 %87
        %481 = OpPhi %u32_id %307 %81 %383 %87
        %482 = OpPhi %u32_id %308 %81 %387 %87
        %483 = OpPhi %u32_id %309 %81 %375 %87
        %484 = OpPhi %u32_id %294 %81 %451 %87
        %485 = OpPhi %u32_id %295 %81 %452 %87
        %486 = OpPhi %u32_id %296 %81 %453 %87
        %487 = OpPhi %u32_id %297 %81 %454 %87
        %488 = OpBitcast %f32_id %145
        %489 = OpBitcast %f32_id %286
        %490 = OpFAdd %f32_id %488 %489
        %491 = OpBitcast %u32_id %490
        %492 = OpIAdd %u32_id %290 %u32_id_1
        %493 = OpBitcast %f32_id %221
        %494 = OpBitcast %f32_id %289
        %495 = OpFAdd %f32_id %493 %494
        %496 = OpBitcast %u32_id %495
        %497 = OpBitcast %f32_id %225
        %498 = OpBitcast %f32_id %288
        %499 = OpFAdd %f32_id %497 %498
        %500 = OpBitcast %u32_id %499
        %501 = OpBitcast %f32_id %229
        %502 = OpBitcast %f32_id %287
        %503 = OpFAdd %f32_id %501 %502
        %504 = OpBitcast %u32_id %503
               OpBranch %89
         %89 = OpLabel
               OpBranchConditional %true %77 %90
         %90 = OpLabel
        %505 = OpPhi %u32_id %274 %78 %472 %89
        %506 = OpPhi %u32_id %275 %78 %473 %89
        %507 = OpPhi %u32_id %276 %78 %474 %89
        %508 = OpPhi %u32_id %277 %78 %475 %89
        %509 = OpPhi %u32_id %278 %78 %476 %89
        %510 = OpPhi %u32_id %279 %78 %477 %89
        %511 = OpPhi %u32_id %280 %78 %478 %89
        %512 = OpPhi %u32_id %281 %78 %479 %89
        %513 = OpPhi %u32_id %282 %78 %480 %89
        %514 = OpPhi %u32_id %283 %78 %481 %89
        %515 = OpPhi %u32_id %284 %78 %482 %89
        %516 = OpPhi %u32_id %285 %78 %483 %89
        %517 = OpPhi %u32_id %270 %78 %484 %89
        %518 = OpPhi %u32_id %271 %78 %485 %89
        %519 = OpPhi %u32_id %272 %78 %486 %89
        %520 = OpPhi %u32_id %273 %78 %487 %89
        %521 = OpIAdd %u32_id %198 %u32_id_1
        %523 = OpULessThan %bool_id %521 %u32_id_6
               OpBranch %91
         %91 = OpLabel
               OpBranchConditional %523 %75 %92
         %92 = OpLabel
        %525 = OpBitFieldUExtract %u32_id %128 %u32_id_0 %u32_id_24
        %526 = OpIMul %u32_id %525 %u32_id_8
        %527 = OpIAdd %u32_id %526 %126
        %528 = OpBitFieldUExtract %u32_id %130 %u32_id_0 %u32_id_24
        %530 = OpIMul %u32_id %528 %u32_id_64
        %531 = OpIAdd %u32_id %530 %527
        %532 = OpShiftLeftLogical %u32_id %531 %u32_id_6
        %533 = OpCompositeConstruct %u32vec2_id %508 %507
        %534 = OpBitcast %u64_id %533
        %536 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %537 = OpIAdd %u32_id %532 %536
        %538 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %537
               OpStore %538 %534
        %539 = OpIAdd %u32_id %532 %u32_id_8
        %540 = OpCompositeConstruct %u32vec2_id %506 %505
        %541 = OpBitcast %u64_id %540
        %542 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %543 = OpIAdd %u32_id %539 %542
        %544 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %543
               OpStore %544 %541
        %545 = OpIAdd %u32_id %532 %u32_id_16
        %546 = OpCompositeConstruct %u32vec2_id %512 %511
        %547 = OpBitcast %u64_id %546
        %548 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %549 = OpIAdd %u32_id %545 %548
        %550 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %549
               OpStore %550 %547
        %551 = OpIAdd %u32_id %532 %u32_id_24
        %552 = OpCompositeConstruct %u32vec2_id %510 %509
        %553 = OpBitcast %u64_id %552
        %554 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %555 = OpIAdd %u32_id %551 %554
        %556 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %555
               OpStore %556 %553
        %558 = OpIAdd %u32_id %532 %u32_id_32
        %559 = OpCompositeConstruct %u32vec2_id %516 %515
        %560 = OpBitcast %u64_id %559
        %561 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %562 = OpIAdd %u32_id %558 %561
        %563 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %562
               OpStore %563 %560
        %565 = OpIAdd %u32_id %532 %u32_id_40
        %566 = OpCompositeConstruct %u32vec2_id %514 %513
        %567 = OpBitcast %u64_id %566
        %568 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %569 = OpIAdd %u32_id %565 %568
        %570 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %569
               OpStore %570 %567
        %572 = OpIAdd %u32_id %532 %u32_id_48
        %573 = OpCompositeConstruct %u32vec2_id %520 %519
        %574 = OpBitcast %u64_id %573
        %575 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %576 = OpIAdd %u32_id %572 %575
        %577 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %576
               OpStore %577 %574
        %579 = OpIAdd %u32_id %532 %u32_id_56
        %580 = OpCompositeConstruct %u32vec2_id %518 %517
        %581 = OpBitcast %u64_id %580
        %582 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %583 = OpIAdd %u32_id %579 %582
        %584 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %583
               OpStore %584 %581
               OpControlBarrier %u32_id_2 %u32_id_2 %u32_id_264
        %586 = OpINotEqual %bool_id %u32_id_0 %128
        %587 = OpINotEqual %bool_id %u32_id_0 %126
        %588 = OpLogicalOr %bool_id %587 %586
        %589 = OpLogicalNot %bool_id %588
        %590 = OpLogicalNot %bool_id %588
               OpSelectionMerge %100 None
               OpBranchConditional %590 %93 %100
         %93 = OpLabel
               OpBranch %94
         %94 = OpLabel
        %591 = OpPhi %u32_id %505 %93 %729 %96
        %592 = OpPhi %u32_id %506 %93 %733 %96
        %593 = OpPhi %u32_id %507 %93 %737 %96
        %594 = OpPhi %u32_id %508 %93 %741 %96
        %595 = OpPhi %u32_id %509 %93 %713 %96
        %596 = OpPhi %u32_id %510 %93 %717 %96
        %597 = OpPhi %u32_id %511 %93 %721 %96
        %598 = OpPhi %u32_id %512 %93 %725 %96
        %599 = OpPhi %u32_id %513 %93 %697 %96
        %600 = OpPhi %u32_id %514 %93 %701 %96
        %601 = OpPhi %u32_id %515 %93 %705 %96
        %602 = OpPhi %u32_id %516 %93 %709 %96
        %603 = OpPhi %u32_id %517 %93 %681 %96
        %604 = OpPhi %u32_id %518 %93 %685 %96
        %605 = OpPhi %u32_id %519 %93 %689 %96
        %606 = OpPhi %u32_id %520 %93 %693 %96
        %607 = OpPhi %u32_id %531 %93 %742 %96
        %608 = OpPhi %u32_id %u32_id_1 %93 %743 %96
               OpLoopMerge %97 %96 None
               OpBranch %95
         %95 = OpLabel
        %609 = OpShiftLeftLogical %u32_id %607 %u32_id_6
        %611 = OpIAdd %u32_id %609 %u32_id_112
        %612 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %613 = OpIAdd %u32_id %611 %612
        %614 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %613
        %615 = OpLoad %u64_id %614
        %616 = OpBitcast %u32vec2_id %615
        %617 = OpCompositeExtract %u32_id %616 0
        %618 = OpCompositeExtract %u32_id %616 1
        %620 = OpIAdd %u32_id %609 %u32_id_120
        %621 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %622 = OpIAdd %u32_id %620 %621
        %623 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %622
        %624 = OpLoad %u64_id %623
        %625 = OpBitcast %u32vec2_id %624
        %626 = OpCompositeExtract %u32_id %625 0
        %627 = OpCompositeExtract %u32_id %625 1
        %628 = OpIAdd %u32_id %609 %u32_id_96
        %629 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %630 = OpIAdd %u32_id %628 %629
        %631 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %630
        %632 = OpLoad %u64_id %631
        %633 = OpBitcast %u32vec2_id %632
        %634 = OpCompositeExtract %u32_id %633 0
        %635 = OpCompositeExtract %u32_id %633 1
        %637 = OpIAdd %u32_id %609 %u32_id_104
        %638 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %639 = OpIAdd %u32_id %637 %638
        %640 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %639
        %641 = OpLoad %u64_id %640
        %642 = OpBitcast %u32vec2_id %641
        %643 = OpCompositeExtract %u32_id %642 0
        %644 = OpCompositeExtract %u32_id %642 1
        %645 = OpIAdd %u32_id %609 %u32_id_80
        %646 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %647 = OpIAdd %u32_id %645 %646
        %648 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %647
        %649 = OpLoad %u64_id %648
        %650 = OpBitcast %u32vec2_id %649
        %651 = OpCompositeExtract %u32_id %650 0
        %652 = OpCompositeExtract %u32_id %650 1
        %654 = OpIAdd %u32_id %609 %u32_id_88
        %655 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %656 = OpIAdd %u32_id %654 %655
        %657 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %656
        %658 = OpLoad %u64_id %657
        %659 = OpBitcast %u32vec2_id %658
        %660 = OpCompositeExtract %u32_id %659 0
        %661 = OpCompositeExtract %u32_id %659 1
        %662 = OpIAdd %u32_id %609 %u32_id_64
        %663 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %664 = OpIAdd %u32_id %662 %663
        %665 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %664
        %666 = OpLoad %u64_id %665
        %667 = OpBitcast %u32vec2_id %666
        %668 = OpCompositeExtract %u32_id %667 0
        %669 = OpCompositeExtract %u32_id %667 1
        %670 = OpIAdd %u32_id %609 %u32_id_72
        %671 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %672 = OpIAdd %u32_id %670 %671
        %673 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %672
        %674 = OpLoad %u64_id %673
        %675 = OpBitcast %u32vec2_id %674
        %676 = OpCompositeExtract %u32_id %675 0
        %677 = OpCompositeExtract %u32_id %675 1
        %678 = OpBitcast %f32_id %627
        %679 = OpBitcast %f32_id %603
        %680 = OpFAdd %f32_id %678 %679
        %681 = OpBitcast %u32_id %680
        %682 = OpBitcast %f32_id %626
        %683 = OpBitcast %f32_id %604
        %684 = OpFAdd %f32_id %682 %683
        %685 = OpBitcast %u32_id %684
        %686 = OpBitcast %f32_id %618
        %687 = OpBitcast %f32_id %605
        %688 = OpFAdd %f32_id %686 %687
        %689 = OpBitcast %u32_id %688
        %690 = OpBitcast %f32_id %617
        %691 = OpBitcast %f32_id %606
        %692 = OpFAdd %f32_id %690 %691
        %693 = OpBitcast %u32_id %692
        %694 = OpBitcast %f32_id %644
        %695 = OpBitcast %f32_id %599
        %696 = OpFAdd %f32_id %694 %695
        %697 = OpBitcast %u32_id %696
        %698 = OpBitcast %f32_id %643
        %699 = OpBitcast %f32_id %600
        %700 = OpFAdd %f32_id %698 %699
        %701 = OpBitcast %u32_id %700
        %702 = OpBitcast %f32_id %635
        %703 = OpBitcast %f32_id %601
        %704 = OpFAdd %f32_id %702 %703
        %705 = OpBitcast %u32_id %704
        %706 = OpBitcast %f32_id %634
        %707 = OpBitcast %f32_id %602
        %708 = OpFAdd %f32_id %706 %707
        %709 = OpBitcast %u32_id %708
        %710 = OpBitcast %f32_id %661
        %711 = OpBitcast %f32_id %595
        %712 = OpFAdd %f32_id %710 %711
        %713 = OpBitcast %u32_id %712
        %714 = OpBitcast %f32_id %660
        %715 = OpBitcast %f32_id %596
        %716 = OpFAdd %f32_id %714 %715
        %717 = OpBitcast %u32_id %716
        %718 = OpBitcast %f32_id %652
        %719 = OpBitcast %f32_id %597
        %720 = OpFAdd %f32_id %718 %719
        %721 = OpBitcast %u32_id %720
        %722 = OpBitcast %f32_id %651
        %723 = OpBitcast %f32_id %598
        %724 = OpFAdd %f32_id %722 %723
        %725 = OpBitcast %u32_id %724
        %726 = OpBitcast %f32_id %677
        %727 = OpBitcast %f32_id %591
        %728 = OpFAdd %f32_id %726 %727
        %729 = OpBitcast %u32_id %728
        %730 = OpBitcast %f32_id %676
        %731 = OpBitcast %f32_id %592
        %732 = OpFAdd %f32_id %730 %731
        %733 = OpBitcast %u32_id %732
        %734 = OpBitcast %f32_id %669
        %735 = OpBitcast %f32_id %593
        %736 = OpFAdd %f32_id %734 %735
        %737 = OpBitcast %u32_id %736
        %738 = OpBitcast %f32_id %668
        %739 = OpBitcast %f32_id %594
        %740 = OpFAdd %f32_id %738 %739
        %741 = OpBitcast %u32_id %740
        %742 = OpIAdd %u32_id %607 %u32_id_1
        %743 = OpIAdd %u32_id %608 %u32_id_1
        %745 = OpSLessThan %bool_id %608 %u32_id_63
               OpBranch %96
         %96 = OpLabel
               OpBranchConditional %745 %94 %97
         %97 = OpLabel
        %747 = OpShiftLeftLogical %u32_id %130 %u32_id_12
        %748 = OpCompositeConstruct %u32vec2_id %741 %737
        %749 = OpBitcast %u64_id %748
        %750 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %751 = OpIAdd %u32_id %747 %750
        %752 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %751
               OpStore %752 %749
        %753 = OpIAdd %u32_id %747 %u32_id_8
        %754 = OpCompositeConstruct %u32vec2_id %733 %729
        %755 = OpBitcast %u64_id %754
        %756 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %757 = OpIAdd %u32_id %753 %756
        %758 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %757
               OpStore %758 %755
        %759 = OpIAdd %u32_id %747 %u32_id_16
        %760 = OpCompositeConstruct %u32vec2_id %725 %721
        %761 = OpBitcast %u64_id %760
        %762 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %763 = OpIAdd %u32_id %759 %762
        %764 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %763
               OpStore %764 %761
        %765 = OpIAdd %u32_id %747 %u32_id_24
        %766 = OpCompositeConstruct %u32vec2_id %717 %713
        %767 = OpBitcast %u64_id %766
        %768 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %769 = OpIAdd %u32_id %765 %768
        %770 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %769
               OpStore %770 %767
        %771 = OpIAdd %u32_id %747 %u32_id_32
        %772 = OpCompositeConstruct %u32vec2_id %709 %705
        %773 = OpBitcast %u64_id %772
        %774 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %775 = OpIAdd %u32_id %771 %774
        %776 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %775
               OpStore %776 %773
        %777 = OpIAdd %u32_id %747 %u32_id_40
        %778 = OpCompositeConstruct %u32vec2_id %701 %697
        %779 = OpBitcast %u64_id %778
        %780 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %781 = OpIAdd %u32_id %777 %780
        %782 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %781
               OpStore %782 %779
        %783 = OpIAdd %u32_id %747 %u32_id_48
        %784 = OpCompositeConstruct %u32vec2_id %693 %689
        %785 = OpBitcast %u64_id %784
        %786 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %787 = OpIAdd %u32_id %783 %786
        %788 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %787
               OpStore %788 %785
        %789 = OpIAdd %u32_id %747 %u32_id_56
        %790 = OpCompositeConstruct %u32vec2_id %685 %681
        %791 = OpBitcast %u64_id %790
        %792 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %793 = OpIAdd %u32_id %789 %792
        %794 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %793
               OpStore %794 %791
               OpControlBarrier %u32_id_2 %u32_id_2 %u32_id_264
        %795 = OpIEqual %bool_id %u32_id_0 %130
        %796 = OpLogicalAnd %bool_id %589 %795
               OpSelectionMerge %99 None
               OpBranchConditional %796 %98 %99
         %98 = OpLabel
        %797 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %799 = OpIAdd %u32_id %797 %u32_id_4096
        %800 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %799
        %801 = OpLoad %u64_id %800
        %802 = OpBitcast %u32vec2_id %801
        %803 = OpCompositeExtract %u32_id %802 0
        %804 = OpCompositeExtract %u32_id %802 1
        %805 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %807 = OpIAdd %u32_id %805 %u32_id_4104
        %808 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %807
        %809 = OpLoad %u64_id %808
        %810 = OpBitcast %u32vec2_id %809
        %811 = OpCompositeExtract %u32_id %810 0
        %812 = OpCompositeExtract %u32_id %810 1
        %813 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %815 = OpIAdd %u32_id %813 %u32_id_8192
        %816 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %815
        %817 = OpLoad %u64_id %816
        %818 = OpBitcast %u32vec2_id %817
        %819 = OpCompositeExtract %u32_id %818 0
        %820 = OpCompositeExtract %u32_id %818 1
        %821 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %823 = OpIAdd %u32_id %821 %u32_id_8200
        %824 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %823
        %825 = OpLoad %u64_id %824
        %826 = OpBitcast %u32vec2_id %825
        %827 = OpCompositeExtract %u32_id %826 0
        %828 = OpCompositeExtract %u32_id %826 1
        %829 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %831 = OpIAdd %u32_id %829 %u32_id_12288
        %832 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %831
        %833 = OpLoad %u64_id %832
        %834 = OpBitcast %u32vec2_id %833
        %835 = OpCompositeExtract %u32_id %834 0
        %836 = OpCompositeExtract %u32_id %834 1
        %837 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %839 = OpIAdd %u32_id %837 %u32_id_12296
        %840 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %839
        %841 = OpLoad %u64_id %840
        %842 = OpBitcast %u32vec2_id %841
        %843 = OpCompositeExtract %u32_id %842 0
        %844 = OpCompositeExtract %u32_id %842 1
        %845 = OpBitcast %f32_id %803
        %846 = OpBitcast %f32_id %819
        %847 = OpFAdd %f32_id %845 %846
        %848 = OpBitcast %f32_id %812
        %849 = OpBitcast %f32_id %828
        %850 = OpFAdd %f32_id %848 %849
        %851 = OpBitcast %f32_id %811
        %852 = OpBitcast %f32_id %827
        %853 = OpFAdd %f32_id %851 %852
        %854 = OpBitcast %f32_id %804
        %855 = OpBitcast %f32_id %820
        %856 = OpFAdd %f32_id %854 %855
        %857 = OpBitcast %f32_id %835
        %858 = OpFAdd %f32_id %847 %857
        %859 = OpBitcast %f32_id %844
        %860 = OpFAdd %f32_id %850 %859
        %861 = OpBitcast %f32_id %843
        %862 = OpFAdd %f32_id %853 %861
        %863 = OpBitcast %f32_id %836
        %864 = OpFAdd %f32_id %856 %863
        %865 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %867 = OpIAdd %u32_id %865 %u32_id_16384
        %868 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %867
        %869 = OpLoad %u64_id %868
        %870 = OpBitcast %u32vec2_id %869
        %871 = OpCompositeExtract %u32_id %870 0
        %872 = OpCompositeExtract %u32_id %870 1
        %873 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %875 = OpIAdd %u32_id %873 %u32_id_16392
        %876 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %875
        %877 = OpLoad %u64_id %876
        %878 = OpBitcast %u32vec2_id %877
        %879 = OpCompositeExtract %u32_id %878 0
        %880 = OpCompositeExtract %u32_id %878 1
        %881 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %883 = OpIAdd %u32_id %881 %u32_id_20480
        %884 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %883
        %885 = OpLoad %u64_id %884
        %886 = OpBitcast %u32vec2_id %885
        %887 = OpCompositeExtract %u32_id %886 0
        %888 = OpCompositeExtract %u32_id %886 1
        %889 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %891 = OpIAdd %u32_id %889 %u32_id_20488
        %892 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %891
        %893 = OpLoad %u64_id %892
        %894 = OpBitcast %u32vec2_id %893
        %895 = OpCompositeExtract %u32_id %894 0
        %896 = OpCompositeExtract %u32_id %894 1
        %897 = OpBitcast %f32_id %871
        %898 = OpFAdd %f32_id %858 %897
        %899 = OpBitcast %f32_id %880
        %900 = OpFAdd %f32_id %860 %899
        %901 = OpBitcast %f32_id %879
        %902 = OpFAdd %f32_id %862 %901
        %903 = OpBitcast %f32_id %872
        %904 = OpFAdd %f32_id %864 %903
        %905 = OpBitcast %f32_id %887
        %906 = OpFAdd %f32_id %898 %905
        %907 = OpBitcast %f32_id %896
        %908 = OpFAdd %f32_id %900 %907
        %909 = OpBitcast %f32_id %895
        %910 = OpFAdd %f32_id %902 %909
        %911 = OpBitcast %f32_id %888
        %912 = OpFAdd %f32_id %904 %911
        %913 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %915 = OpIAdd %u32_id %913 %u32_id_24576
        %916 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %915
        %917 = OpLoad %u64_id %916
        %918 = OpBitcast %u32vec2_id %917
        %919 = OpCompositeExtract %u32_id %918 0
        %920 = OpCompositeExtract %u32_id %918 1
        %921 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %923 = OpIAdd %u32_id %921 %u32_id_24584
        %924 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %923
        %925 = OpLoad %u64_id %924
        %926 = OpBitcast %u32vec2_id %925
        %927 = OpCompositeExtract %u32_id %926 0
        %928 = OpCompositeExtract %u32_id %926 1
        %929 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %931 = OpIAdd %u32_id %929 %u32_id_28672
        %932 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %931
        %933 = OpLoad %u64_id %932
        %934 = OpBitcast %u32vec2_id %933
        %935 = OpCompositeExtract %u32_id %934 0
        %936 = OpCompositeExtract %u32_id %934 1
        %937 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %939 = OpIAdd %u32_id %937 %u32_id_28680
        %940 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %939
        %941 = OpLoad %u64_id %940
        %942 = OpBitcast %u32vec2_id %941
        %943 = OpCompositeExtract %u32_id %942 0
        %944 = OpCompositeExtract %u32_id %942 1
        %945 = OpBitcast %f32_id %919
        %946 = OpFAdd %f32_id %906 %945
        %947 = OpBitcast %f32_id %928
        %948 = OpFAdd %f32_id %908 %947
        %949 = OpBitcast %f32_id %927
        %950 = OpFAdd %f32_id %910 %949
        %951 = OpBitcast %f32_id %920
        %952 = OpFAdd %f32_id %912 %951
        %953 = OpBitcast %f32_id %935
        %954 = OpFAdd %f32_id %946 %953
        %955 = OpBitcast %f32_id %944
        %956 = OpFAdd %f32_id %948 %955
        %957 = OpBitcast %f32_id %943
        %958 = OpFAdd %f32_id %950 %957
        %959 = OpBitcast %f32_id %936
        %960 = OpFAdd %f32_id %952 %959
        %961 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %963 = OpIAdd %u32_id %961 %u32_id_32768
        %964 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %963
        %965 = OpLoad %u64_id %964
        %966 = OpBitcast %u32vec2_id %965
        %967 = OpCompositeExtract %u32_id %966 0
        %968 = OpCompositeExtract %u32_id %966 1
        %969 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %971 = OpIAdd %u32_id %969 %u32_id_32776
        %972 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %971
        %973 = OpLoad %u64_id %972
        %974 = OpBitcast %u32vec2_id %973
        %975 = OpCompositeExtract %u32_id %974 0
        %976 = OpCompositeExtract %u32_id %974 1
        %977 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %979 = OpIAdd %u32_id %977 %u32_id_36864
        %980 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %979
        %981 = OpLoad %u64_id %980
        %982 = OpBitcast %u32vec2_id %981
        %983 = OpCompositeExtract %u32_id %982 0
        %984 = OpCompositeExtract %u32_id %982 1
        %985 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %987 = OpIAdd %u32_id %985 %u32_id_36872
        %988 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %987
        %989 = OpLoad %u64_id %988
        %990 = OpBitcast %u32vec2_id %989
        %991 = OpCompositeExtract %u32_id %990 0
        %992 = OpCompositeExtract %u32_id %990 1
        %993 = OpBitcast %f32_id %967
        %994 = OpFAdd %f32_id %954 %993
        %995 = OpBitcast %f32_id %976
        %996 = OpFAdd %f32_id %956 %995
        %997 = OpBitcast %f32_id %975
        %998 = OpFAdd %f32_id %958 %997
        %999 = OpBitcast %f32_id %968
       %1000 = OpFAdd %f32_id %960 %999
       %1001 = OpBitcast %f32_id %983
       %1002 = OpFAdd %f32_id %994 %1001
       %1003 = OpBitcast %f32_id %992
       %1004 = OpFAdd %f32_id %996 %1003
       %1005 = OpBitcast %f32_id %991
       %1006 = OpFAdd %f32_id %998 %1005
       %1007 = OpBitcast %f32_id %984
       %1008 = OpFAdd %f32_id %1000 %1007
       %1009 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1011 = OpIAdd %u32_id %1009 %u32_id_40960
       %1012 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1011
       %1013 = OpLoad %u64_id %1012
       %1014 = OpBitcast %u32vec2_id %1013
       %1015 = OpCompositeExtract %u32_id %1014 0
       %1016 = OpCompositeExtract %u32_id %1014 1
       %1017 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1019 = OpIAdd %u32_id %1017 %u32_id_40968
       %1020 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1019
       %1021 = OpLoad %u64_id %1020
       %1022 = OpBitcast %u32vec2_id %1021
       %1023 = OpCompositeExtract %u32_id %1022 0
       %1024 = OpCompositeExtract %u32_id %1022 1
       %1025 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1027 = OpIAdd %u32_id %1025 %u32_id_45056
       %1028 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1027
       %1029 = OpLoad %u64_id %1028
       %1030 = OpBitcast %u32vec2_id %1029
       %1031 = OpCompositeExtract %u32_id %1030 0
       %1032 = OpCompositeExtract %u32_id %1030 1
       %1033 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1035 = OpIAdd %u32_id %1033 %u32_id_45064
       %1036 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1035
       %1037 = OpLoad %u64_id %1036
       %1038 = OpBitcast %u32vec2_id %1037
       %1039 = OpCompositeExtract %u32_id %1038 0
       %1040 = OpCompositeExtract %u32_id %1038 1
       %1041 = OpBitcast %f32_id %1015
       %1042 = OpFAdd %f32_id %1002 %1041
       %1043 = OpBitcast %f32_id %1024
       %1044 = OpFAdd %f32_id %1004 %1043
       %1045 = OpBitcast %f32_id %1023
       %1046 = OpFAdd %f32_id %1006 %1045
       %1047 = OpBitcast %f32_id %1016
       %1048 = OpFAdd %f32_id %1008 %1047
       %1049 = OpBitcast %f32_id %1031
       %1050 = OpFAdd %f32_id %1042 %1049
       %1051 = OpBitcast %f32_id %1040
       %1052 = OpFAdd %f32_id %1044 %1051
       %1053 = OpBitcast %f32_id %1039
       %1054 = OpFAdd %f32_id %1046 %1053
       %1055 = OpBitcast %f32_id %1032
       %1056 = OpFAdd %f32_id %1048 %1055
       %1057 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1059 = OpIAdd %u32_id %1057 %u32_id_49152
       %1060 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1059
       %1061 = OpLoad %u64_id %1060
       %1062 = OpBitcast %u32vec2_id %1061
       %1063 = OpCompositeExtract %u32_id %1062 0
       %1064 = OpCompositeExtract %u32_id %1062 1
       %1065 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1067 = OpIAdd %u32_id %1065 %u32_id_49160
       %1068 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1067
       %1069 = OpLoad %u64_id %1068
       %1070 = OpBitcast %u32vec2_id %1069
       %1071 = OpCompositeExtract %u32_id %1070 0
       %1072 = OpCompositeExtract %u32_id %1070 1
       %1073 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1075 = OpIAdd %u32_id %1073 %u32_id_53248
       %1076 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1075
       %1077 = OpLoad %u64_id %1076
       %1078 = OpBitcast %u32vec2_id %1077
       %1079 = OpCompositeExtract %u32_id %1078 0
       %1080 = OpCompositeExtract %u32_id %1078 1
       %1081 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1083 = OpIAdd %u32_id %1081 %u32_id_53256
       %1084 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1083
       %1085 = OpLoad %u64_id %1084
       %1086 = OpBitcast %u32vec2_id %1085
       %1087 = OpCompositeExtract %u32_id %1086 0
       %1088 = OpCompositeExtract %u32_id %1086 1
       %1089 = OpBitcast %f32_id %1063
       %1090 = OpFAdd %f32_id %1050 %1089
       %1091 = OpBitcast %f32_id %1072
       %1092 = OpFAdd %f32_id %1052 %1091
       %1093 = OpBitcast %f32_id %1071
       %1094 = OpFAdd %f32_id %1054 %1093
       %1095 = OpBitcast %f32_id %1064
       %1096 = OpFAdd %f32_id %1056 %1095
       %1097 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1099 = OpIAdd %u32_id %1097 %u32_id_57344
       %1100 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1099
       %1101 = OpLoad %u64_id %1100
       %1102 = OpBitcast %u32vec2_id %1101
       %1103 = OpCompositeExtract %u32_id %1102 0
       %1104 = OpCompositeExtract %u32_id %1102 1
       %1105 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1107 = OpIAdd %u32_id %1105 %u32_id_57352
       %1108 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1107
       %1109 = OpLoad %u64_id %1108
       %1110 = OpBitcast %u32vec2_id %1109
       %1111 = OpCompositeExtract %u32_id %1110 0
       %1112 = OpCompositeExtract %u32_id %1110 1
       %1113 = OpBitcast %f32_id %1079
       %1114 = OpFAdd %f32_id %1090 %1113
       %1115 = OpBitcast %f32_id %1087
       %1116 = OpFAdd %f32_id %1094 %1115
       %1117 = OpBitcast %f32_id %1088
       %1118 = OpFAdd %f32_id %1092 %1117
       %1119 = OpBitcast %f32_id %1111
       %1120 = OpFAdd %f32_id %1116 %1119
       %1121 = OpBitcast %f32_id %1103
       %1122 = OpFAdd %f32_id %1114 %1121
       %1123 = OpBitcast %f32_id %1080
       %1124 = OpFAdd %f32_id %1096 %1123
       %1125 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1127 = OpIAdd %u32_id %1125 %u32_id_61440
       %1128 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1127
       %1129 = OpLoad %u64_id %1128
       %1130 = OpBitcast %u32vec2_id %1129
       %1131 = OpCompositeExtract %u32_id %1130 0
       %1132 = OpCompositeExtract %u32_id %1130 1
       %1133 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1135 = OpIAdd %u32_id %1133 %u32_id_61448
       %1136 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1135
       %1137 = OpLoad %u64_id %1136
       %1138 = OpBitcast %u32vec2_id %1137
       %1139 = OpCompositeExtract %u32_id %1138 0
       %1140 = OpCompositeExtract %u32_id %1138 1
       %1141 = OpBitcast %f32_id %1104
       %1142 = OpFAdd %f32_id %1124 %1141
       %1143 = OpBitcast %f32_id %1112
       %1144 = OpFAdd %f32_id %1118 %1143
       %1145 = OpBitcast %f32_id %1131
       %1146 = OpFAdd %f32_id %1122 %1145
       %1147 = OpBitcast %f32_id %1140
       %1148 = OpFAdd %f32_id %1144 %1147
       %1149 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1151 = OpIAdd %u32_id %1149 %u32_id_4112
       %1152 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1151
       %1153 = OpLoad %u64_id %1152
       %1154 = OpBitcast %u32vec2_id %1153
       %1155 = OpCompositeExtract %u32_id %1154 0
       %1156 = OpCompositeExtract %u32_id %1154 1
       %1157 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1159 = OpIAdd %u32_id %1157 %u32_id_4120
       %1160 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1159
       %1161 = OpLoad %u64_id %1160
       %1162 = OpBitcast %u32vec2_id %1161
       %1163 = OpCompositeExtract %u32_id %1162 0
       %1164 = OpCompositeExtract %u32_id %1162 1
       %1165 = OpBitcast %f32_id %1132
       %1166 = OpFAdd %f32_id %1142 %1165
       %1167 = OpBitcast %f32_id %1139
       %1168 = OpFAdd %f32_id %1120 %1167
       %1169 = OpFAdd %f32_id %1146 %740
       %1170 = OpFAdd %f32_id %1148 %728
       %1171 = OpFAdd %f32_id %1168 %732
       %1172 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1174 = OpIAdd %u32_id %1172 %u32_id_8208
       %1175 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1174
       %1176 = OpLoad %u64_id %1175
       %1177 = OpBitcast %u32vec2_id %1176
       %1178 = OpCompositeExtract %u32_id %1177 0
       %1179 = OpCompositeExtract %u32_id %1177 1
       %1180 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1182 = OpIAdd %u32_id %1180 %u32_id_8216
       %1183 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1182
       %1184 = OpLoad %u64_id %1183
       %1185 = OpBitcast %u32vec2_id %1184
       %1186 = OpCompositeExtract %u32_id %1185 0
       %1187 = OpCompositeExtract %u32_id %1185 1
       %1188 = OpFAdd %f32_id %1166 %736
       %1189 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1191 = OpIAdd %u32_id %1189 %u32_id_12304
       %1192 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1191
       %1193 = OpLoad %u64_id %1192
       %1194 = OpBitcast %u32vec2_id %1193
       %1195 = OpCompositeExtract %u32_id %1194 0
       %1196 = OpCompositeExtract %u32_id %1194 1
       %1197 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1199 = OpIAdd %u32_id %1197 %u32_id_12312
       %1200 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1199
       %1201 = OpLoad %u64_id %1200
       %1202 = OpBitcast %u32vec2_id %1201
       %1203 = OpCompositeExtract %u32_id %1202 0
       %1204 = OpCompositeExtract %u32_id %1202 1
       %1205 = OpBitcast %f32_id %1155
       %1206 = OpBitcast %f32_id %1178
       %1207 = OpFAdd %f32_id %1205 %1206
       %1208 = OpBitcast %f32_id %1164
       %1209 = OpBitcast %f32_id %1187
       %1210 = OpFAdd %f32_id %1208 %1209
       %1211 = OpBitcast %f32_id %1163
       %1212 = OpBitcast %f32_id %1186
       %1213 = OpFAdd %f32_id %1211 %1212
       %1214 = OpBitcast %f32_id %1156
       %1215 = OpBitcast %f32_id %1179
       %1216 = OpFAdd %f32_id %1214 %1215
       %1217 = OpBitcast %f32_id %1195
       %1218 = OpFAdd %f32_id %1207 %1217
       %1219 = OpBitcast %f32_id %1204
       %1220 = OpFAdd %f32_id %1210 %1219
       %1221 = OpBitcast %f32_id %1203
       %1222 = OpFAdd %f32_id %1213 %1221
       %1223 = OpBitcast %f32_id %1196
       %1224 = OpFAdd %f32_id %1216 %1223
       %1225 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1227 = OpIAdd %u32_id %1225 %u32_id_16400
       %1228 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1227
       %1229 = OpLoad %u64_id %1228
       %1230 = OpBitcast %u32vec2_id %1229
       %1231 = OpCompositeExtract %u32_id %1230 0
       %1232 = OpCompositeExtract %u32_id %1230 1
       %1233 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1235 = OpIAdd %u32_id %1233 %u32_id_16408
       %1236 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1235
       %1237 = OpLoad %u64_id %1236
       %1238 = OpBitcast %u32vec2_id %1237
       %1239 = OpCompositeExtract %u32_id %1238 0
       %1240 = OpCompositeExtract %u32_id %1238 1
       %1241 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1243 = OpIAdd %u32_id %1241 %u32_id_20496
       %1244 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1243
       %1245 = OpLoad %u64_id %1244
       %1246 = OpBitcast %u32vec2_id %1245
       %1247 = OpCompositeExtract %u32_id %1246 0
       %1248 = OpCompositeExtract %u32_id %1246 1
       %1249 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1251 = OpIAdd %u32_id %1249 %u32_id_20504
       %1252 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1251
       %1253 = OpLoad %u64_id %1252
       %1254 = OpBitcast %u32vec2_id %1253
       %1255 = OpCompositeExtract %u32_id %1254 0
       %1256 = OpCompositeExtract %u32_id %1254 1
       %1257 = OpBitcast %f32_id %1231
       %1258 = OpFAdd %f32_id %1218 %1257
       %1259 = OpBitcast %f32_id %1240
       %1260 = OpFAdd %f32_id %1220 %1259
       %1261 = OpBitcast %f32_id %1239
       %1262 = OpFAdd %f32_id %1222 %1261
       %1263 = OpBitcast %f32_id %1232
       %1264 = OpFAdd %f32_id %1224 %1263
       %1265 = OpBitcast %f32_id %1247
       %1266 = OpFAdd %f32_id %1258 %1265
       %1267 = OpBitcast %f32_id %1256
       %1268 = OpFAdd %f32_id %1260 %1267
       %1269 = OpBitcast %f32_id %1255
       %1270 = OpFAdd %f32_id %1262 %1269
       %1271 = OpBitcast %f32_id %1248
       %1272 = OpFAdd %f32_id %1264 %1271
       %1273 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1275 = OpIAdd %u32_id %1273 %u32_id_24592
       %1276 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1275
       %1277 = OpLoad %u64_id %1276
       %1278 = OpBitcast %u32vec2_id %1277
       %1279 = OpCompositeExtract %u32_id %1278 0
       %1280 = OpCompositeExtract %u32_id %1278 1
       %1281 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1283 = OpIAdd %u32_id %1281 %u32_id_24600
       %1284 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1283
       %1285 = OpLoad %u64_id %1284
       %1286 = OpBitcast %u32vec2_id %1285
       %1287 = OpCompositeExtract %u32_id %1286 0
       %1288 = OpCompositeExtract %u32_id %1286 1
       %1289 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1291 = OpIAdd %u32_id %1289 %u32_id_28688
       %1292 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1291
       %1293 = OpLoad %u64_id %1292
       %1294 = OpBitcast %u32vec2_id %1293
       %1295 = OpCompositeExtract %u32_id %1294 0
       %1296 = OpCompositeExtract %u32_id %1294 1
       %1297 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1299 = OpIAdd %u32_id %1297 %u32_id_28696
       %1300 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1299
       %1301 = OpLoad %u64_id %1300
       %1302 = OpBitcast %u32vec2_id %1301
       %1303 = OpCompositeExtract %u32_id %1302 0
       %1304 = OpCompositeExtract %u32_id %1302 1
       %1305 = OpBitcast %f32_id %1279
       %1306 = OpFAdd %f32_id %1266 %1305
       %1307 = OpBitcast %f32_id %1288
       %1308 = OpFAdd %f32_id %1268 %1307
       %1309 = OpBitcast %f32_id %1287
       %1310 = OpFAdd %f32_id %1270 %1309
       %1311 = OpBitcast %f32_id %1280
       %1312 = OpFAdd %f32_id %1272 %1311
       %1313 = OpBitcast %f32_id %1295
       %1314 = OpFAdd %f32_id %1306 %1313
       %1315 = OpBitcast %f32_id %1304
       %1316 = OpFAdd %f32_id %1308 %1315
       %1317 = OpBitcast %f32_id %1303
       %1318 = OpFAdd %f32_id %1310 %1317
       %1319 = OpBitcast %f32_id %1296
       %1320 = OpFAdd %f32_id %1312 %1319
       %1321 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1323 = OpIAdd %u32_id %1321 %u32_id_32784
       %1324 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1323
       %1325 = OpLoad %u64_id %1324
       %1326 = OpBitcast %u32vec2_id %1325
       %1327 = OpCompositeExtract %u32_id %1326 0
       %1328 = OpCompositeExtract %u32_id %1326 1
       %1329 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1331 = OpIAdd %u32_id %1329 %u32_id_32792
       %1332 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1331
       %1333 = OpLoad %u64_id %1332
       %1334 = OpBitcast %u32vec2_id %1333
       %1335 = OpCompositeExtract %u32_id %1334 0
       %1336 = OpCompositeExtract %u32_id %1334 1
       %1337 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1339 = OpIAdd %u32_id %1337 %u32_id_36880
       %1340 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1339
       %1341 = OpLoad %u64_id %1340
       %1342 = OpBitcast %u32vec2_id %1341
       %1343 = OpCompositeExtract %u32_id %1342 0
       %1344 = OpCompositeExtract %u32_id %1342 1
       %1345 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1347 = OpIAdd %u32_id %1345 %u32_id_36888
       %1348 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1347
       %1349 = OpLoad %u64_id %1348
       %1350 = OpBitcast %u32vec2_id %1349
       %1351 = OpCompositeExtract %u32_id %1350 0
       %1352 = OpCompositeExtract %u32_id %1350 1
       %1353 = OpBitcast %f32_id %1327
       %1354 = OpFAdd %f32_id %1314 %1353
       %1355 = OpBitcast %f32_id %1336
       %1356 = OpFAdd %f32_id %1316 %1355
       %1357 = OpBitcast %f32_id %1335
       %1358 = OpFAdd %f32_id %1318 %1357
       %1359 = OpBitcast %f32_id %1328
       %1360 = OpFAdd %f32_id %1320 %1359
       %1361 = OpBitcast %f32_id %1343
       %1362 = OpFAdd %f32_id %1354 %1361
       %1363 = OpBitcast %f32_id %1352
       %1364 = OpFAdd %f32_id %1356 %1363
       %1365 = OpBitcast %f32_id %1351
       %1366 = OpFAdd %f32_id %1358 %1365
       %1367 = OpBitcast %f32_id %1344
       %1368 = OpFAdd %f32_id %1360 %1367
       %1369 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1371 = OpIAdd %u32_id %1369 %u32_id_40976
       %1372 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1371
       %1373 = OpLoad %u64_id %1372
       %1374 = OpBitcast %u32vec2_id %1373
       %1375 = OpCompositeExtract %u32_id %1374 0
       %1376 = OpCompositeExtract %u32_id %1374 1
       %1377 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1379 = OpIAdd %u32_id %1377 %u32_id_40984
       %1380 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1379
       %1381 = OpLoad %u64_id %1380
       %1382 = OpBitcast %u32vec2_id %1381
       %1383 = OpCompositeExtract %u32_id %1382 0
       %1384 = OpCompositeExtract %u32_id %1382 1
       %1385 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1387 = OpIAdd %u32_id %1385 %u32_id_45072
       %1388 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1387
       %1389 = OpLoad %u64_id %1388
       %1390 = OpBitcast %u32vec2_id %1389
       %1391 = OpCompositeExtract %u32_id %1390 0
       %1392 = OpCompositeExtract %u32_id %1390 1
       %1393 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1395 = OpIAdd %u32_id %1393 %u32_id_45080
       %1396 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1395
       %1397 = OpLoad %u64_id %1396
       %1398 = OpBitcast %u32vec2_id %1397
       %1399 = OpCompositeExtract %u32_id %1398 0
       %1400 = OpCompositeExtract %u32_id %1398 1
       %1401 = OpBitcast %f32_id %1375
       %1402 = OpFAdd %f32_id %1362 %1401
       %1403 = OpBitcast %f32_id %1384
       %1404 = OpFAdd %f32_id %1364 %1403
       %1405 = OpBitcast %f32_id %1383
       %1406 = OpFAdd %f32_id %1366 %1405
       %1407 = OpBitcast %f32_id %1376
       %1408 = OpFAdd %f32_id %1368 %1407
       %1409 = OpBitcast %f32_id %1391
       %1410 = OpFAdd %f32_id %1402 %1409
       %1411 = OpBitcast %f32_id %1400
       %1412 = OpFAdd %f32_id %1404 %1411
       %1413 = OpBitcast %f32_id %1399
       %1414 = OpFAdd %f32_id %1406 %1413
       %1415 = OpBitcast %f32_id %1392
       %1416 = OpFAdd %f32_id %1408 %1415
       %1417 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1419 = OpIAdd %u32_id %1417 %u32_id_49168
       %1420 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1419
       %1421 = OpLoad %u64_id %1420
       %1422 = OpBitcast %u32vec2_id %1421
       %1423 = OpCompositeExtract %u32_id %1422 0
       %1424 = OpCompositeExtract %u32_id %1422 1
       %1425 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1427 = OpIAdd %u32_id %1425 %u32_id_49176
       %1428 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1427
       %1429 = OpLoad %u64_id %1428
       %1430 = OpBitcast %u32vec2_id %1429
       %1431 = OpCompositeExtract %u32_id %1430 0
       %1432 = OpCompositeExtract %u32_id %1430 1
       %1433 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1435 = OpIAdd %u32_id %1433 %u32_id_53264
       %1436 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1435
       %1437 = OpLoad %u64_id %1436
       %1438 = OpBitcast %u32vec2_id %1437
       %1439 = OpCompositeExtract %u32_id %1438 0
       %1440 = OpCompositeExtract %u32_id %1438 1
       %1441 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1443 = OpIAdd %u32_id %1441 %u32_id_53272
       %1444 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1443
       %1445 = OpLoad %u64_id %1444
       %1446 = OpBitcast %u32vec2_id %1445
       %1447 = OpCompositeExtract %u32_id %1446 0
       %1448 = OpCompositeExtract %u32_id %1446 1
       %1449 = OpBitcast %f32_id %1423
       %1450 = OpFAdd %f32_id %1410 %1449
       %1451 = OpBitcast %f32_id %1432
       %1452 = OpFAdd %f32_id %1412 %1451
       %1453 = OpBitcast %f32_id %1431
       %1454 = OpFAdd %f32_id %1414 %1453
       %1455 = OpBitcast %f32_id %1424
       %1456 = OpFAdd %f32_id %1416 %1455
       %1457 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1459 = OpIAdd %u32_id %1457 %u32_id_57360
       %1460 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1459
       %1461 = OpLoad %u64_id %1460
       %1462 = OpBitcast %u32vec2_id %1461
       %1463 = OpCompositeExtract %u32_id %1462 0
       %1464 = OpCompositeExtract %u32_id %1462 1
       %1465 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1467 = OpIAdd %u32_id %1465 %u32_id_57368
       %1468 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1467
       %1469 = OpLoad %u64_id %1468
       %1470 = OpBitcast %u32vec2_id %1469
       %1471 = OpCompositeExtract %u32_id %1470 0
       %1472 = OpCompositeExtract %u32_id %1470 1
       %1473 = OpBitcast %f32_id %1439
       %1474 = OpFAdd %f32_id %1450 %1473
       %1475 = OpBitcast %f32_id %1447
       %1476 = OpFAdd %f32_id %1454 %1475
       %1477 = OpBitcast %f32_id %1448
       %1478 = OpFAdd %f32_id %1452 %1477
       %1479 = OpBitcast %f32_id %1471
       %1480 = OpFAdd %f32_id %1476 %1479
       %1481 = OpBitcast %f32_id %1463
       %1482 = OpFAdd %f32_id %1474 %1481
       %1483 = OpBitcast %f32_id %1440
       %1484 = OpFAdd %f32_id %1456 %1483
       %1485 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1487 = OpIAdd %u32_id %1485 %u32_id_61456
       %1488 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1487
       %1489 = OpLoad %u64_id %1488
       %1490 = OpBitcast %u32vec2_id %1489
       %1491 = OpCompositeExtract %u32_id %1490 0
       %1492 = OpCompositeExtract %u32_id %1490 1
       %1493 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1495 = OpIAdd %u32_id %1493 %u32_id_61464
       %1496 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1495
       %1497 = OpLoad %u64_id %1496
       %1498 = OpBitcast %u32vec2_id %1497
       %1499 = OpCompositeExtract %u32_id %1498 0
       %1500 = OpCompositeExtract %u32_id %1498 1
       %1501 = OpBitcast %f32_id %1464
       %1502 = OpFAdd %f32_id %1484 %1501
       %1503 = OpBitcast %f32_id %1472
       %1504 = OpFAdd %f32_id %1478 %1503
       %1505 = OpBitcast %f32_id %1491
       %1506 = OpFAdd %f32_id %1482 %1505
       %1507 = OpBitcast %f32_id %1500
       %1508 = OpFAdd %f32_id %1504 %1507
       %1509 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1511 = OpIAdd %u32_id %1509 %u32_id_4128
       %1512 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1511
       %1513 = OpLoad %u64_id %1512
       %1514 = OpBitcast %u32vec2_id %1513
       %1515 = OpCompositeExtract %u32_id %1514 0
       %1516 = OpCompositeExtract %u32_id %1514 1
       %1517 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1519 = OpIAdd %u32_id %1517 %u32_id_4136
       %1520 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1519
       %1521 = OpLoad %u64_id %1520
       %1522 = OpBitcast %u32vec2_id %1521
       %1523 = OpCompositeExtract %u32_id %1522 0
       %1524 = OpCompositeExtract %u32_id %1522 1
       %1525 = OpBitcast %f32_id %1492
       %1526 = OpFAdd %f32_id %1502 %1525
       %1527 = OpBitcast %f32_id %1499
       %1528 = OpFAdd %f32_id %1480 %1527
       %1529 = OpFAdd %f32_id %1506 %724
       %1530 = OpFAdd %f32_id %1508 %712
       %1531 = OpFAdd %f32_id %1528 %716
       %1532 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1534 = OpIAdd %u32_id %1532 %u32_id_8224
       %1535 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1534
       %1536 = OpLoad %u64_id %1535
       %1537 = OpBitcast %u32vec2_id %1536
       %1538 = OpCompositeExtract %u32_id %1537 0
       %1539 = OpCompositeExtract %u32_id %1537 1
       %1540 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1542 = OpIAdd %u32_id %1540 %u32_id_8232
       %1543 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1542
       %1544 = OpLoad %u64_id %1543
       %1545 = OpBitcast %u32vec2_id %1544
       %1546 = OpCompositeExtract %u32_id %1545 0
       %1547 = OpCompositeExtract %u32_id %1545 1
       %1549 = OpIAdd %u32_id %u32_id_74 %buf0_dword_off
       %1550 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %1549
       %1551 = OpLoad %u32_id %1550
       %1552 = OpFAdd %f32_id %1526 %720
       %1553 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1555 = OpIAdd %u32_id %1553 %u32_id_12320
       %1556 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1555
       %1557 = OpLoad %u64_id %1556
       %1558 = OpBitcast %u32vec2_id %1557
       %1559 = OpCompositeExtract %u32_id %1558 0
       %1560 = OpCompositeExtract %u32_id %1558 1
       %1561 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1563 = OpIAdd %u32_id %1561 %u32_id_12328
       %1564 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1563
       %1565 = OpLoad %u64_id %1564
       %1566 = OpBitcast %u32vec2_id %1565
       %1567 = OpCompositeExtract %u32_id %1566 0
       %1568 = OpCompositeExtract %u32_id %1566 1
       %1569 = OpBitcast %f32_id %1515
       %1570 = OpBitcast %f32_id %1538
       %1571 = OpFAdd %f32_id %1569 %1570
       %1572 = OpBitcast %f32_id %1524
       %1573 = OpBitcast %f32_id %1547
       %1574 = OpFAdd %f32_id %1572 %1573
       %1575 = OpBitcast %f32_id %1523
       %1576 = OpBitcast %f32_id %1546
       %1577 = OpFAdd %f32_id %1575 %1576
       %1578 = OpBitcast %f32_id %1516
       %1579 = OpBitcast %f32_id %1539
       %1580 = OpFAdd %f32_id %1578 %1579
       %1581 = OpBitcast %f32_id %1559
       %1582 = OpFAdd %f32_id %1571 %1581
       %1583 = OpBitcast %f32_id %1568
       %1584 = OpFAdd %f32_id %1574 %1583
       %1585 = OpBitcast %f32_id %1567
       %1586 = OpFAdd %f32_id %1577 %1585
       %1587 = OpBitcast %f32_id %1560
       %1588 = OpFAdd %f32_id %1580 %1587
       %1589 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1591 = OpIAdd %u32_id %1589 %u32_id_16416
       %1592 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1591
       %1593 = OpLoad %u64_id %1592
       %1594 = OpBitcast %u32vec2_id %1593
       %1595 = OpCompositeExtract %u32_id %1594 0
       %1596 = OpCompositeExtract %u32_id %1594 1
       %1597 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1599 = OpIAdd %u32_id %1597 %u32_id_16424
       %1600 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1599
       %1601 = OpLoad %u64_id %1600
       %1602 = OpBitcast %u32vec2_id %1601
       %1603 = OpCompositeExtract %u32_id %1602 0
       %1604 = OpCompositeExtract %u32_id %1602 1
       %1605 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1607 = OpIAdd %u32_id %1605 %u32_id_20512
       %1608 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1607
       %1609 = OpLoad %u64_id %1608
       %1610 = OpBitcast %u32vec2_id %1609
       %1611 = OpCompositeExtract %u32_id %1610 0
       %1612 = OpCompositeExtract %u32_id %1610 1
       %1613 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1615 = OpIAdd %u32_id %1613 %u32_id_20520
       %1616 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1615
       %1617 = OpLoad %u64_id %1616
       %1618 = OpBitcast %u32vec2_id %1617
       %1619 = OpCompositeExtract %u32_id %1618 0
       %1620 = OpCompositeExtract %u32_id %1618 1
       %1621 = OpBitcast %f32_id %1595
       %1622 = OpFAdd %f32_id %1582 %1621
       %1623 = OpBitcast %f32_id %1604
       %1624 = OpFAdd %f32_id %1584 %1623
       %1625 = OpBitcast %f32_id %1603
       %1626 = OpFAdd %f32_id %1586 %1625
       %1627 = OpBitcast %f32_id %1596
       %1628 = OpFAdd %f32_id %1588 %1627
       %1629 = OpBitcast %f32_id %1611
       %1630 = OpFAdd %f32_id %1622 %1629
       %1631 = OpBitcast %f32_id %1620
       %1632 = OpFAdd %f32_id %1624 %1631
       %1633 = OpBitcast %f32_id %1619
       %1634 = OpFAdd %f32_id %1626 %1633
       %1635 = OpBitcast %f32_id %1612
       %1636 = OpFAdd %f32_id %1628 %1635
       %1637 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1639 = OpIAdd %u32_id %1637 %u32_id_24608
       %1640 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1639
       %1641 = OpLoad %u64_id %1640
       %1642 = OpBitcast %u32vec2_id %1641
       %1643 = OpCompositeExtract %u32_id %1642 0
       %1644 = OpCompositeExtract %u32_id %1642 1
       %1645 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1647 = OpIAdd %u32_id %1645 %u32_id_24616
       %1648 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1647
       %1649 = OpLoad %u64_id %1648
       %1650 = OpBitcast %u32vec2_id %1649
       %1651 = OpCompositeExtract %u32_id %1650 0
       %1652 = OpCompositeExtract %u32_id %1650 1
       %1653 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1655 = OpIAdd %u32_id %1653 %u32_id_28704
       %1656 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1655
       %1657 = OpLoad %u64_id %1656
       %1658 = OpBitcast %u32vec2_id %1657
       %1659 = OpCompositeExtract %u32_id %1658 0
       %1660 = OpCompositeExtract %u32_id %1658 1
       %1661 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1663 = OpIAdd %u32_id %1661 %u32_id_28712
       %1664 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1663
       %1665 = OpLoad %u64_id %1664
       %1666 = OpBitcast %u32vec2_id %1665
       %1667 = OpCompositeExtract %u32_id %1666 0
       %1668 = OpCompositeExtract %u32_id %1666 1
       %1669 = OpBitcast %f32_id %1643
       %1670 = OpFAdd %f32_id %1630 %1669
       %1671 = OpBitcast %f32_id %1652
       %1672 = OpFAdd %f32_id %1632 %1671
       %1673 = OpBitcast %f32_id %1651
       %1674 = OpFAdd %f32_id %1634 %1673
       %1675 = OpBitcast %f32_id %1644
       %1676 = OpFAdd %f32_id %1636 %1675
       %1677 = OpBitcast %f32_id %1659
       %1678 = OpFAdd %f32_id %1670 %1677
       %1679 = OpBitcast %f32_id %1668
       %1680 = OpFAdd %f32_id %1672 %1679
       %1681 = OpBitcast %f32_id %1667
       %1682 = OpFAdd %f32_id %1674 %1681
       %1683 = OpBitcast %f32_id %1660
       %1684 = OpFAdd %f32_id %1676 %1683
       %1685 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1687 = OpIAdd %u32_id %1685 %u32_id_32800
       %1688 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1687
       %1689 = OpLoad %u64_id %1688
       %1690 = OpBitcast %u32vec2_id %1689
       %1691 = OpCompositeExtract %u32_id %1690 0
       %1692 = OpCompositeExtract %u32_id %1690 1
       %1693 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1695 = OpIAdd %u32_id %1693 %u32_id_32808
       %1696 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1695
       %1697 = OpLoad %u64_id %1696
       %1698 = OpBitcast %u32vec2_id %1697
       %1699 = OpCompositeExtract %u32_id %1698 0
       %1700 = OpCompositeExtract %u32_id %1698 1
       %1701 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1703 = OpIAdd %u32_id %1701 %u32_id_36896
       %1704 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1703
       %1705 = OpLoad %u64_id %1704
       %1706 = OpBitcast %u32vec2_id %1705
       %1707 = OpCompositeExtract %u32_id %1706 0
       %1708 = OpCompositeExtract %u32_id %1706 1
       %1709 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1711 = OpIAdd %u32_id %1709 %u32_id_36904
       %1712 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1711
       %1713 = OpLoad %u64_id %1712
       %1714 = OpBitcast %u32vec2_id %1713
       %1715 = OpCompositeExtract %u32_id %1714 0
       %1716 = OpCompositeExtract %u32_id %1714 1
       %1717 = OpBitcast %f32_id %1691
       %1718 = OpFAdd %f32_id %1678 %1717
       %1719 = OpBitcast %f32_id %1700
       %1720 = OpFAdd %f32_id %1680 %1719
       %1721 = OpBitcast %f32_id %1699
       %1722 = OpFAdd %f32_id %1682 %1721
       %1723 = OpBitcast %f32_id %1692
       %1724 = OpFAdd %f32_id %1684 %1723
       %1725 = OpBitcast %f32_id %1707
       %1726 = OpFAdd %f32_id %1718 %1725
       %1727 = OpBitcast %f32_id %1716
       %1728 = OpFAdd %f32_id %1720 %1727
       %1729 = OpBitcast %f32_id %1715
       %1730 = OpFAdd %f32_id %1722 %1729
       %1731 = OpBitcast %f32_id %1708
       %1732 = OpFAdd %f32_id %1724 %1731
       %1733 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1735 = OpIAdd %u32_id %1733 %u32_id_40992
       %1736 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1735
       %1737 = OpLoad %u64_id %1736
       %1738 = OpBitcast %u32vec2_id %1737
       %1739 = OpCompositeExtract %u32_id %1738 0
       %1740 = OpCompositeExtract %u32_id %1738 1
       %1741 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1743 = OpIAdd %u32_id %1741 %u32_id_41000
       %1744 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1743
       %1745 = OpLoad %u64_id %1744
       %1746 = OpBitcast %u32vec2_id %1745
       %1747 = OpCompositeExtract %u32_id %1746 0
       %1748 = OpCompositeExtract %u32_id %1746 1
       %1749 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1751 = OpIAdd %u32_id %1749 %u32_id_45088
       %1752 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1751
       %1753 = OpLoad %u64_id %1752
       %1754 = OpBitcast %u32vec2_id %1753
       %1755 = OpCompositeExtract %u32_id %1754 0
       %1756 = OpCompositeExtract %u32_id %1754 1
       %1757 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1759 = OpIAdd %u32_id %1757 %u32_id_45096
       %1760 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1759
       %1761 = OpLoad %u64_id %1760
       %1762 = OpBitcast %u32vec2_id %1761
       %1763 = OpCompositeExtract %u32_id %1762 0
       %1764 = OpCompositeExtract %u32_id %1762 1
       %1765 = OpBitcast %f32_id %1739
       %1766 = OpFAdd %f32_id %1726 %1765
       %1767 = OpBitcast %f32_id %1748
       %1768 = OpFAdd %f32_id %1728 %1767
       %1769 = OpBitcast %f32_id %1747
       %1770 = OpFAdd %f32_id %1730 %1769
       %1771 = OpBitcast %f32_id %1740
       %1772 = OpFAdd %f32_id %1732 %1771
       %1773 = OpBitcast %f32_id %1764
       %1774 = OpFAdd %f32_id %1768 %1773
       %1775 = OpBitcast %f32_id %1763
       %1776 = OpFAdd %f32_id %1770 %1775
       %1777 = OpBitcast %f32_id %1756
       %1778 = OpFAdd %f32_id %1772 %1777
       %1779 = OpBitcast %f32_id %1755
       %1780 = OpFAdd %f32_id %1766 %1779
       %1781 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1783 = OpIAdd %u32_id %1781 %u32_id_49184
       %1784 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1783
       %1785 = OpLoad %u64_id %1784
       %1786 = OpBitcast %u32vec2_id %1785
       %1787 = OpCompositeExtract %u32_id %1786 0
       %1788 = OpCompositeExtract %u32_id %1786 1
       %1789 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1791 = OpIAdd %u32_id %1789 %u32_id_49192
       %1792 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1791
       %1793 = OpLoad %u64_id %1792
       %1794 = OpBitcast %u32vec2_id %1793
       %1795 = OpCompositeExtract %u32_id %1794 0
       %1796 = OpCompositeExtract %u32_id %1794 1
       %1797 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1799 = OpIAdd %u32_id %1797 %u32_id_53280
       %1800 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1799
       %1801 = OpLoad %u64_id %1800
       %1802 = OpBitcast %u32vec2_id %1801
       %1803 = OpCompositeExtract %u32_id %1802 0
       %1804 = OpCompositeExtract %u32_id %1802 1
       %1805 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1807 = OpIAdd %u32_id %1805 %u32_id_53288
       %1808 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1807
       %1809 = OpLoad %u64_id %1808
       %1810 = OpBitcast %u32vec2_id %1809
       %1811 = OpCompositeExtract %u32_id %1810 0
       %1812 = OpCompositeExtract %u32_id %1810 1
       %1813 = OpBitcast %f32_id %1795
       %1814 = OpFAdd %f32_id %1776 %1813
       %1815 = OpBitcast %f32_id %1788
       %1816 = OpFAdd %f32_id %1778 %1815
       %1817 = OpBitcast %f32_id %1787
       %1818 = OpFAdd %f32_id %1780 %1817
       %1819 = OpBitcast %f32_id %1796
       %1820 = OpFAdd %f32_id %1774 %1819
       %1821 = OpBitcast %f32_id %1803
       %1822 = OpFAdd %f32_id %1818 %1821
       %1823 = OpBitcast %f32_id %1812
       %1824 = OpFAdd %f32_id %1820 %1823
       %1825 = OpBitcast %f32_id %1811
       %1826 = OpFAdd %f32_id %1814 %1825
       %1827 = OpBitcast %f32_id %1804
       %1828 = OpFAdd %f32_id %1816 %1827
       %1829 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1831 = OpIAdd %u32_id %1829 %u32_id_57376
       %1832 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1831
       %1833 = OpLoad %u64_id %1832
       %1834 = OpBitcast %u32vec2_id %1833
       %1835 = OpCompositeExtract %u32_id %1834 0
       %1836 = OpCompositeExtract %u32_id %1834 1
       %1837 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1839 = OpIAdd %u32_id %1837 %u32_id_57384
       %1840 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1839
       %1841 = OpLoad %u64_id %1840
       %1842 = OpBitcast %u32vec2_id %1841
       %1843 = OpCompositeExtract %u32_id %1842 0
       %1844 = OpCompositeExtract %u32_id %1842 1
       %1845 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1847 = OpIAdd %u32_id %1845 %u32_id_61472
       %1848 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1847
       %1849 = OpLoad %u64_id %1848
       %1850 = OpBitcast %u32vec2_id %1849
       %1851 = OpCompositeExtract %u32_id %1850 0
       %1852 = OpCompositeExtract %u32_id %1850 1
       %1853 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1855 = OpIAdd %u32_id %1853 %u32_id_61480
       %1856 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1855
       %1857 = OpLoad %u64_id %1856
       %1858 = OpBitcast %u32vec2_id %1857
       %1859 = OpCompositeExtract %u32_id %1858 0
       %1860 = OpCompositeExtract %u32_id %1858 1
       %1862 = OpIAdd %u32_id %u32_id_76 %buf0_dword_off
       %1863 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %1862
       %1864 = OpLoad %u32_id %1863
       %1866 = OpIAdd %u32_id %u32_id_77 %buf0_dword_off
       %1867 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %1866
       %1868 = OpLoad %u32_id %1867
       %1870 = OpIAdd %u32_id %u32_id_78 %buf0_dword_off
       %1871 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %1870
       %1872 = OpLoad %u32_id %1871
       %1873 = OpBitcast %f32_id %1835
       %1874 = OpFAdd %f32_id %1822 %1873
       %1875 = OpBitcast %f32_id %1851
       %1876 = OpFAdd %f32_id %1874 %1875
       %1877 = OpBitcast %f32_id %1844
       %1878 = OpFAdd %f32_id %1824 %1877
       %1879 = OpBitcast %f32_id %1860
       %1880 = OpFAdd %f32_id %1878 %1879
       %1881 = OpBitcast %f32_id %1836
       %1882 = OpFAdd %f32_id %1828 %1881
       %1883 = OpBitcast %f32_id %1843
       %1884 = OpFAdd %f32_id %1826 %1883
       %1885 = OpBitcast %f32_id %1852
       %1886 = OpFAdd %f32_id %1882 %1885
       %1887 = OpFAdd %f32_id %1876 %708
       %1888 = OpBitcast %f32_id %1859
       %1889 = OpFAdd %f32_id %1884 %1888
       %1890 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1892 = OpIAdd %u32_id %1890 %u32_id_4144
       %1893 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1892
       %1894 = OpLoad %u64_id %1893
       %1895 = OpBitcast %u32vec2_id %1894
       %1896 = OpCompositeExtract %u32_id %1895 0
       %1897 = OpCompositeExtract %u32_id %1895 1
       %1898 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1900 = OpIAdd %u32_id %1898 %u32_id_4152
       %1901 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1900
       %1902 = OpLoad %u64_id %1901
       %1903 = OpBitcast %u32vec2_id %1902
       %1904 = OpCompositeExtract %u32_id %1903 0
       %1905 = OpCompositeExtract %u32_id %1903 1
       %1906 = OpBitcast %f32_id %1864
       %1907 = OpFMul %f32_id %1906 %1169
       %1908 = OpBitcast %u32_id %1907
       %1909 = OpBitcast %f32_id %1868
       %1910 = OpFMul %f32_id %1909 %1170
       %1911 = OpBitcast %u32_id %1910
       %1912 = OpBitcast %f32_id %1868
       %1913 = OpFMul %f32_id %1912 %1171
       %1914 = OpBitcast %u32_id %1913
       %1915 = OpBitcast %f32_id %1868
       %1916 = OpFMul %f32_id %1915 %1188
       %1917 = OpBitcast %u32_id %1916
       %1918 = OpFAdd %f32_id %1880 %696
       %1919 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1921 = OpIAdd %u32_id %1919 %u32_id_8240
       %1922 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1921
       %1923 = OpLoad %u64_id %1922
       %1924 = OpBitcast %u32vec2_id %1923
       %1925 = OpCompositeExtract %u32_id %1924 0
       %1926 = OpCompositeExtract %u32_id %1924 1
       %1927 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1929 = OpIAdd %u32_id %1927 %u32_id_8248
       %1930 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1929
       %1931 = OpLoad %u64_id %1930
       %1932 = OpBitcast %u32vec2_id %1931
       %1933 = OpCompositeExtract %u32_id %1932 0
       %1934 = OpCompositeExtract %u32_id %1932 1
       %1935 = OpFAdd %f32_id %1889 %700
       %1936 = OpFAdd %f32_id %1886 %704
       %1937 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1939 = OpIAdd %u32_id %1937 %u32_id_12336
       %1940 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1939
       %1941 = OpLoad %u64_id %1940
       %1942 = OpBitcast %u32vec2_id %1941
       %1943 = OpCompositeExtract %u32_id %1942 0
       %1944 = OpCompositeExtract %u32_id %1942 1
       %1945 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1947 = OpIAdd %u32_id %1945 %u32_id_12344
       %1948 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1947
       %1949 = OpLoad %u64_id %1948
       %1950 = OpBitcast %u32vec2_id %1949
       %1951 = OpCompositeExtract %u32_id %1950 0
       %1952 = OpCompositeExtract %u32_id %1950 1
       %1953 = OpBitcast %f32_id %1905
       %1954 = OpBitcast %f32_id %1934
       %1955 = OpFAdd %f32_id %1953 %1954
       %1956 = OpBitcast %f32_id %1896
       %1957 = OpBitcast %f32_id %1925
       %1958 = OpFAdd %f32_id %1956 %1957
       %1959 = OpBitcast %f32_id %1904
       %1960 = OpBitcast %f32_id %1933
       %1961 = OpFAdd %f32_id %1959 %1960
       %1962 = OpBitcast %f32_id %1897
       %1963 = OpBitcast %f32_id %1926
       %1964 = OpFAdd %f32_id %1962 %1963
       %1965 = OpBitcast %f32_id %1952
       %1966 = OpFAdd %f32_id %1955 %1965
       %1967 = OpBitcast %f32_id %1943
       %1968 = OpFAdd %f32_id %1958 %1967
       %1969 = OpBitcast %f32_id %1864
       %1970 = OpFMul %f32_id %1969 %1529
       %1971 = OpBitcast %u32_id %1970
       %1972 = OpBitcast %f32_id %1944
       %1973 = OpFAdd %f32_id %1964 %1972
       %1974 = OpBitcast %f32_id %1868
       %1975 = OpFMul %f32_id %1974 %1530
       %1976 = OpBitcast %u32_id %1975
       %1977 = OpBitcast %f32_id %1864
       %1978 = OpFMul %f32_id %1977 %1887
       %1979 = OpBitcast %u32_id %1978
       %1980 = OpBitcast %f32_id %1951
       %1981 = OpFAdd %f32_id %1961 %1980
       %1982 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1984 = OpIAdd %u32_id %1982 %u32_id_16432
       %1985 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1984
       %1986 = OpLoad %u64_id %1985
       %1987 = OpBitcast %u32vec2_id %1986
       %1988 = OpCompositeExtract %u32_id %1987 0
       %1989 = OpCompositeExtract %u32_id %1987 1
       %1990 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1992 = OpIAdd %u32_id %1990 %u32_id_16440
       %1993 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1992
       %1994 = OpLoad %u64_id %1993
       %1995 = OpBitcast %u32vec2_id %1994
       %1996 = OpCompositeExtract %u32_id %1995 0
       %1997 = OpCompositeExtract %u32_id %1995 1
       %1998 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2000 = OpIAdd %u32_id %1998 %u32_id_20528
       %2001 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2000
       %2002 = OpLoad %u64_id %2001
       %2003 = OpBitcast %u32vec2_id %2002
       %2004 = OpCompositeExtract %u32_id %2003 0
       %2005 = OpCompositeExtract %u32_id %2003 1
       %2006 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2008 = OpIAdd %u32_id %2006 %u32_id_20536
       %2009 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2008
       %2010 = OpLoad %u64_id %2009
       %2011 = OpBitcast %u32vec2_id %2010
       %2012 = OpCompositeExtract %u32_id %2011 0
       %2013 = OpCompositeExtract %u32_id %2011 1
       %2014 = OpBitcast %f32_id %1996
       %2015 = OpFAdd %f32_id %1981 %2014
       %2016 = OpBitcast %f32_id %1989
       %2017 = OpFAdd %f32_id %1973 %2016
       %2018 = OpBitcast %f32_id %1988
       %2019 = OpFAdd %f32_id %1968 %2018
       %2020 = OpBitcast %f32_id %1997
       %2021 = OpFAdd %f32_id %1966 %2020
       %2022 = OpBitcast %f32_id %2013
       %2023 = OpFAdd %f32_id %2021 %2022
       %2024 = OpBitcast %f32_id %2012
       %2025 = OpFAdd %f32_id %2015 %2024
       %2026 = OpBitcast %f32_id %2005
       %2027 = OpFAdd %f32_id %2017 %2026
       %2028 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2030 = OpIAdd %u32_id %2028 %u32_id_24624
       %2031 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2030
       %2032 = OpLoad %u64_id %2031
       %2033 = OpBitcast %u32vec2_id %2032
       %2034 = OpCompositeExtract %u32_id %2033 0
       %2035 = OpCompositeExtract %u32_id %2033 1
       %2036 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2038 = OpIAdd %u32_id %2036 %u32_id_24632
       %2039 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2038
       %2040 = OpLoad %u64_id %2039
       %2041 = OpBitcast %u32vec2_id %2040
       %2042 = OpCompositeExtract %u32_id %2041 0
       %2043 = OpCompositeExtract %u32_id %2041 1
       %2044 = OpBitcast %f32_id %2004
       %2045 = OpFAdd %f32_id %2019 %2044
       %2046 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2048 = OpIAdd %u32_id %2046 %u32_id_28720
       %2049 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2048
       %2050 = OpLoad %u64_id %2049
       %2051 = OpBitcast %u32vec2_id %2050
       %2052 = OpCompositeExtract %u32_id %2051 0
       %2053 = OpCompositeExtract %u32_id %2051 1
       %2054 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2056 = OpIAdd %u32_id %2054 %u32_id_28728
       %2057 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2056
       %2058 = OpLoad %u64_id %2057
       %2059 = OpBitcast %u32vec2_id %2058
       %2060 = OpCompositeExtract %u32_id %2059 0
       %2061 = OpCompositeExtract %u32_id %2059 1
       %2062 = OpBitcast %f32_id %2042
       %2063 = OpFAdd %f32_id %2025 %2062
       %2064 = OpBitcast %f32_id %2035
       %2065 = OpFAdd %f32_id %2027 %2064
       %2066 = OpBitcast %f32_id %2053
       %2067 = OpFAdd %f32_id %2065 %2066
       %2068 = OpBitcast %f32_id %2034
       %2069 = OpFAdd %f32_id %2045 %2068
       %2070 = OpBitcast %f32_id %2043
       %2071 = OpFAdd %f32_id %2023 %2070
       %2072 = OpBitcast %f32_id %2061
       %2073 = OpFAdd %f32_id %2071 %2072
       %2074 = OpBitcast %f32_id %2060
       %2075 = OpFAdd %f32_id %2063 %2074
       %2076 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2078 = OpIAdd %u32_id %2076 %u32_id_32816
       %2079 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2078
       %2080 = OpLoad %u64_id %2079
       %2081 = OpBitcast %u32vec2_id %2080
       %2082 = OpCompositeExtract %u32_id %2081 0
       %2083 = OpCompositeExtract %u32_id %2081 1
       %2084 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2086 = OpIAdd %u32_id %2084 %u32_id_32824
       %2087 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2086
       %2088 = OpLoad %u64_id %2087
       %2089 = OpBitcast %u32vec2_id %2088
       %2090 = OpCompositeExtract %u32_id %2089 0
       %2091 = OpCompositeExtract %u32_id %2089 1
       %2092 = OpBitcast %f32_id %2052
       %2093 = OpFAdd %f32_id %2069 %2092
       %2094 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2096 = OpIAdd %u32_id %2094 %u32_id_36912
       %2097 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2096
       %2098 = OpLoad %u64_id %2097
       %2099 = OpBitcast %u32vec2_id %2098
       %2100 = OpCompositeExtract %u32_id %2099 0
       %2101 = OpCompositeExtract %u32_id %2099 1
       %2102 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2104 = OpIAdd %u32_id %2102 %u32_id_36920
       %2105 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2104
       %2106 = OpLoad %u64_id %2105
       %2107 = OpBitcast %u32vec2_id %2106
       %2108 = OpCompositeExtract %u32_id %2107 0
       %2109 = OpCompositeExtract %u32_id %2107 1
       %2110 = OpBitcast %f32_id %2090
       %2111 = OpFAdd %f32_id %2075 %2110
       %2112 = OpBitcast %f32_id %2083
       %2113 = OpFAdd %f32_id %2067 %2112
       %2114 = OpBitcast %f32_id %2108
       %2115 = OpFAdd %f32_id %2111 %2114
       %2116 = OpBitcast %f32_id %2101
       %2117 = OpFAdd %f32_id %2113 %2116
       %2118 = OpBitcast %f32_id %2082
       %2119 = OpFAdd %f32_id %2093 %2118
       %2120 = OpBitcast %f32_id %2091
       %2121 = OpFAdd %f32_id %2073 %2120
       %2122 = OpBitcast %f32_id %2109
       %2123 = OpFAdd %f32_id %2121 %2122
       %2124 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2126 = OpIAdd %u32_id %2124 %u32_id_41008
       %2127 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2126
       %2128 = OpLoad %u64_id %2127
       %2129 = OpBitcast %u32vec2_id %2128
       %2130 = OpCompositeExtract %u32_id %2129 0
       %2131 = OpCompositeExtract %u32_id %2129 1
       %2132 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2134 = OpIAdd %u32_id %2132 %u32_id_41016
       %2135 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2134
       %2136 = OpLoad %u64_id %2135
       %2137 = OpBitcast %u32vec2_id %2136
       %2138 = OpCompositeExtract %u32_id %2137 0
       %2139 = OpCompositeExtract %u32_id %2137 1
       %2140 = OpBitcast %f32_id %2100
       %2141 = OpFAdd %f32_id %2119 %2140
       %2142 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2144 = OpIAdd %u32_id %2142 %u32_id_45104
       %2145 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2144
       %2146 = OpLoad %u64_id %2145
       %2147 = OpBitcast %u32vec2_id %2146
       %2148 = OpCompositeExtract %u32_id %2147 0
       %2149 = OpCompositeExtract %u32_id %2147 1
       %2150 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2152 = OpIAdd %u32_id %2150 %u32_id_45112
       %2153 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2152
       %2154 = OpLoad %u64_id %2153
       %2155 = OpBitcast %u32vec2_id %2154
       %2156 = OpCompositeExtract %u32_id %2155 0
       %2157 = OpCompositeExtract %u32_id %2155 1
       %2158 = OpBitcast %f32_id %2138
       %2159 = OpFAdd %f32_id %2115 %2158
       %2160 = OpBitcast %f32_id %2131
       %2161 = OpFAdd %f32_id %2117 %2160
       %2162 = OpBitcast %f32_id %2156
       %2163 = OpFAdd %f32_id %2159 %2162
       %2164 = OpBitcast %f32_id %2149
       %2165 = OpFAdd %f32_id %2161 %2164
       %2166 = OpBitcast %f32_id %2130
       %2167 = OpFAdd %f32_id %2141 %2166
       %2168 = OpBitcast %f32_id %2139
       %2169 = OpFAdd %f32_id %2123 %2168
       %2170 = OpBitcast %f32_id %2157
       %2171 = OpFAdd %f32_id %2169 %2170
       %2172 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2174 = OpIAdd %u32_id %2172 %u32_id_49200
       %2175 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2174
       %2176 = OpLoad %u64_id %2175
       %2177 = OpBitcast %u32vec2_id %2176
       %2178 = OpCompositeExtract %u32_id %2177 0
       %2179 = OpCompositeExtract %u32_id %2177 1
       %2180 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2182 = OpIAdd %u32_id %2180 %u32_id_49208
       %2183 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2182
       %2184 = OpLoad %u64_id %2183
       %2185 = OpBitcast %u32vec2_id %2184
       %2186 = OpCompositeExtract %u32_id %2185 0
       %2187 = OpCompositeExtract %u32_id %2185 1
       %2188 = OpBitcast %f32_id %2148
       %2189 = OpFAdd %f32_id %2167 %2188
       %2190 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2192 = OpIAdd %u32_id %2190 %u32_id_53296
       %2193 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2192
       %2194 = OpLoad %u64_id %2193
       %2195 = OpBitcast %u32vec2_id %2194
       %2196 = OpCompositeExtract %u32_id %2195 0
       %2197 = OpCompositeExtract %u32_id %2195 1
       %2198 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2200 = OpIAdd %u32_id %2198 %u32_id_53304
       %2201 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2200
       %2202 = OpLoad %u64_id %2201
       %2203 = OpBitcast %u32vec2_id %2202
       %2204 = OpCompositeExtract %u32_id %2203 0
       %2205 = OpCompositeExtract %u32_id %2203 1
       %2206 = OpBitcast %f32_id %2187
       %2207 = OpFAdd %f32_id %2171 %2206
       %2208 = OpBitcast %f32_id %2186
       %2209 = OpFAdd %f32_id %2163 %2208
       %2210 = OpBitcast %f32_id %2179
       %2211 = OpFAdd %f32_id %2165 %2210
       %2212 = OpBitcast %f32_id %2178
       %2213 = OpFAdd %f32_id %2189 %2212
       %2214 = OpBitcast %f32_id %2196
       %2215 = OpFAdd %f32_id %2213 %2214
       %2216 = OpBitcast %f32_id %2205
       %2217 = OpFAdd %f32_id %2207 %2216
       %2218 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2220 = OpIAdd %u32_id %2218 %u32_id_57392
       %2221 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2220
       %2222 = OpLoad %u64_id %2221
       %2223 = OpBitcast %u32vec2_id %2222
       %2224 = OpCompositeExtract %u32_id %2223 0
       %2225 = OpCompositeExtract %u32_id %2223 1
       %2226 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2228 = OpIAdd %u32_id %2226 %u32_id_57400
       %2229 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2228
       %2230 = OpLoad %u64_id %2229
       %2231 = OpBitcast %u32vec2_id %2230
       %2232 = OpCompositeExtract %u32_id %2231 0
       %2233 = OpCompositeExtract %u32_id %2231 1
       %2234 = OpBitcast %f32_id %2204
       %2235 = OpFAdd %f32_id %2209 %2234
       %2236 = OpBitcast %f32_id %2197
       %2237 = OpFAdd %f32_id %2211 %2236
       %2238 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2240 = OpIAdd %u32_id %2238 %u32_id_61488
       %2241 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2240
       %2242 = OpLoad %u64_id %2241
       %2243 = OpBitcast %u32vec2_id %2242
       %2244 = OpCompositeExtract %u32_id %2243 0
       %2245 = OpCompositeExtract %u32_id %2243 1
       %2246 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2248 = OpIAdd %u32_id %2246 %u32_id_61496
       %2249 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2248
       %2250 = OpLoad %u64_id %2249
       %2251 = OpBitcast %u32vec2_id %2250
       %2252 = OpCompositeExtract %u32_id %2251 0
       %2253 = OpCompositeExtract %u32_id %2251 1
       %2254 = OpBitcast %f32_id %1868
       %2255 = OpFMul %f32_id %2254 %1552
       %2256 = OpBitcast %u32_id %2255
       %2257 = OpBitcast %f32_id %2224
       %2258 = OpFAdd %f32_id %2215 %2257
       %2259 = OpBitcast %f32_id %2233
       %2260 = OpFAdd %f32_id %2217 %2259
       %2261 = OpBitcast %f32_id %2225
       %2262 = OpFAdd %f32_id %2237 %2261
       %2263 = OpBitcast %f32_id %2232
       %2264 = OpFAdd %f32_id %2235 %2263
       %2265 = OpBitcast %f32_id %2244
       %2266 = OpFAdd %f32_id %2258 %2265
       %2267 = OpBitcast %f32_id %2253
       %2268 = OpFAdd %f32_id %2260 %2267
       %2269 = OpBitcast %f32_id %2252
       %2270 = OpFAdd %f32_id %2264 %2269
       %2271 = OpBitcast %f32_id %2245
       %2272 = OpFAdd %f32_id %2262 %2271
       %2273 = OpFAdd %f32_id %2266 %692
       %2274 = OpFAdd %f32_id %2268 %680
       %2275 = OpFAdd %f32_id %2270 %684
       %2276 = OpFAdd %f32_id %2272 %688
       %2277 = OpBitcast %f32_id %1868
       %2278 = OpFMul %f32_id %2277 %1531
       %2279 = OpBitcast %u32_id %2278
       %2280 = OpBitcast %f32_id %1868
       %2281 = OpFMul %f32_id %2280 %1918
       %2282 = OpBitcast %u32_id %2281
       %2283 = OpBitcast %f32_id %1868
       %2284 = OpFMul %f32_id %2283 %1935
       %2285 = OpBitcast %u32_id %2284
       %2286 = OpBitcast %f32_id %1868
       %2287 = OpFMul %f32_id %2286 %1936
       %2288 = OpBitcast %u32_id %2287
       %2289 = OpCompositeConstruct %u32vec4_id %1908 %1917 %1914 %1911
       %2290 = OpIMul %u32_id %1551 %u32_id_16
       %2291 = OpIAdd %u32_id %2290 %buf1_dword_off
       %2292 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2291
       %2293 = OpCompositeExtract %u32_id %2289 0
               OpStore %2292 %2293
       %2294 = OpIAdd %u32_id %2291 %u32_id_1
       %2295 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2294
       %2296 = OpCompositeExtract %u32_id %2289 1
               OpStore %2295 %2296
       %2297 = OpIAdd %u32_id %2291 %u32_id_2
       %2298 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2297
       %2299 = OpCompositeExtract %u32_id %2289 2
               OpStore %2298 %2299
       %2300 = OpIAdd %u32_id %2291 %u32_id_3
       %2301 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2300
       %2302 = OpCompositeExtract %u32_id %2289 3
               OpStore %2301 %2302
       %2303 = OpBitcast %f32_id %1872
       %2304 = OpFMul %f32_id %2303 %2273
       %2305 = OpBitcast %u32_id %2304
       %2306 = OpBitcast %f32_id %1872
       %2307 = OpFMul %f32_id %2306 %2274
       %2308 = OpBitcast %u32_id %2307
       %2309 = OpBitcast %f32_id %1872
       %2310 = OpFMul %f32_id %2309 %2275
       %2311 = OpBitcast %u32_id %2310
       %2312 = OpBitcast %f32_id %1872
       %2313 = OpFMul %f32_id %2312 %2276
       %2314 = OpBitcast %u32_id %2313
       %2315 = OpCompositeConstruct %u32vec4_id %1971 %2256 %2279 %1976
       %2316 = OpIMul %u32_id %1551 %u32_id_16
       %2318 = OpIAdd %u32_id %2316 %u32_id_4
       %2319 = OpIAdd %u32_id %2318 %buf1_dword_off
       %2320 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2319
       %2321 = OpCompositeExtract %u32_id %2315 0
               OpStore %2320 %2321
       %2322 = OpIAdd %u32_id %2319 %u32_id_1
       %2323 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2322
       %2324 = OpCompositeExtract %u32_id %2315 1
               OpStore %2323 %2324
       %2325 = OpIAdd %u32_id %2319 %u32_id_2
       %2326 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2325
       %2327 = OpCompositeExtract %u32_id %2315 2
               OpStore %2326 %2327
       %2328 = OpIAdd %u32_id %2319 %u32_id_3
       %2329 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2328
       %2330 = OpCompositeExtract %u32_id %2315 3
               OpStore %2329 %2330
       %2331 = OpCompositeConstruct %u32vec4_id %1979 %2288 %2285 %2282
       %2332 = OpIMul %u32_id %1551 %u32_id_16
       %2333 = OpIAdd %u32_id %2332 %u32_id_8
       %2334 = OpIAdd %u32_id %2333 %buf1_dword_off
       %2335 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2334
       %2336 = OpCompositeExtract %u32_id %2331 0
               OpStore %2335 %2336
       %2337 = OpIAdd %u32_id %2334 %u32_id_1
       %2338 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2337
       %2339 = OpCompositeExtract %u32_id %2331 1
               OpStore %2338 %2339
       %2340 = OpIAdd %u32_id %2334 %u32_id_2
       %2341 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2340
       %2342 = OpCompositeExtract %u32_id %2331 2
               OpStore %2341 %2342
       %2343 = OpIAdd %u32_id %2334 %u32_id_3
       %2344 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2343
       %2345 = OpCompositeExtract %u32_id %2331 3
               OpStore %2344 %2345
       %2346 = OpCompositeConstruct %u32vec4_id %2305 %2314 %2311 %2308
       %2347 = OpIMul %u32_id %1551 %u32_id_16
       %2348 = OpIAdd %u32_id %2347 %u32_id_12
       %2349 = OpIAdd %u32_id %2348 %buf1_dword_off
       %2350 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2349
       %2351 = OpCompositeExtract %u32_id %2346 0
               OpStore %2350 %2351
       %2352 = OpIAdd %u32_id %2349 %u32_id_1
       %2353 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2352
       %2354 = OpCompositeExtract %u32_id %2346 1
               OpStore %2353 %2354
       %2355 = OpIAdd %u32_id %2349 %u32_id_2
       %2356 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2355
       %2357 = OpCompositeExtract %u32_id %2346 2
               OpStore %2356 %2357
       %2358 = OpIAdd %u32_id %2349 %u32_id_3
       %2359 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2358
       %2360 = OpCompositeExtract %u32_id %2346 3
               OpStore %2359 %2360
               OpBranch %99
         %99 = OpLabel
               OpBranch %100
        %100 = OpLabel
               OpBranch %101
        %101 = OpLabel
               OpReturn
               OpFunctionEnd
