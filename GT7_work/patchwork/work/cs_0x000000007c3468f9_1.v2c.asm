; SPIR-V
; Version: 1.6
; Generator: Khronos; 0
; Bound: 2359
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
        %174 = OpExtInstImport "GLSL.std.450"
               OpMemoryModel Logical GLSL450
               OpEntryPoint GLCompute %76 "main" %push_data %gl_WorkGroupID %gl_NumWorkGroups %gl_LocalInvocationID %ssbo_1 %ssbo_2 %ssbo_shmem %cs_img16 %cs_img0 %cs_sampsgpr_24
               OpExecutionMode %76 LocalSize 8 8 16
               OpExecutionMode %76 SignedZeroInfNanPreserve 32
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
               OpDecorate %175 NoContraction
               OpDecorate %176 NoContraction
               OpDecorate %178 NoContraction
               OpDecorate %180 NoContraction
               OpDecorate %182 NoContraction
               OpDecorate %183 NoContraction
               OpDecorate %247 NoContraction
               OpDecorate %249 NoContraction
               OpDecorate %251 NoContraction
               OpDecorate %253 NoContraction
               OpDecorate %254 NoContraction
               OpDecorate %256 NoContraction
               OpDecorate %257 NoContraction
               OpDecorate %259 NoContraction
               OpDecorate %260 NoContraction
               OpDecorate %262 NoContraction
               OpDecorate %263 NoContraction
               OpDecorate %266 NoContraction
               OpDecorate %267 NoContraction
               OpDecorate %270 NoContraction
               OpDecorate %271 NoContraction
               OpDecorate %330 NoContraction
               OpDecorate %331 NoContraction
               OpDecorate %333 NoContraction
               OpDecorate %336 NoContraction
               OpDecorate %347 NoContraction
               OpDecorate %350 NoContraction
               OpDecorate %351 NoContraction
               OpDecorate %354 NoContraction
               OpDecorate %355 NoContraction
               OpDecorate %358 NoContraction
               OpDecorate %360 NoContraction
               OpDecorate %362 NoContraction
               OpDecorate %364 NoContraction
               OpDecorate %367 NoContraction
               OpDecorate %368 NoContraction
               OpDecorate %369 NoContraction
               OpDecorate %371 NoContraction
               OpDecorate %372 NoContraction
               OpDecorate %375 NoContraction
               OpDecorate %376 NoContraction
               OpDecorate %379 NoContraction
               OpDecorate %380 NoContraction
               OpDecorate %383 NoContraction
               OpDecorate %384 NoContraction
               OpDecorate %387 NoContraction
               OpDecorate %388 NoContraction
               OpDecorate %391 NoContraction
               OpDecorate %392 NoContraction
               OpDecorate %395 NoContraction
               OpDecorate %396 NoContraction
               OpDecorate %399 NoContraction
               OpDecorate %400 NoContraction
               OpDecorate %403 NoContraction
               OpDecorate %404 NoContraction
               OpDecorate %407 NoContraction
               OpDecorate %408 NoContraction
               OpDecorate %411 NoContraction
               OpDecorate %412 NoContraction
               OpDecorate %415 NoContraction
               OpDecorate %416 NoContraction
               OpDecorate %419 NoContraction
               OpDecorate %421 NoContraction
               OpDecorate %422 NoContraction
               OpDecorate %424 NoContraction
               OpDecorate %425 NoContraction
               OpDecorate %428 NoContraction
               OpDecorate %430 NoContraction
               OpDecorate %431 NoContraction
               OpDecorate %434 NoContraction
               OpDecorate %435 NoContraction
               OpDecorate %438 NoContraction
               OpDecorate %439 NoContraction
               OpDecorate %442 NoContraction
               OpDecorate %443 NoContraction
               OpDecorate %456 NoContraction
               OpDecorate %460 NoContraction
               OpDecorate %464 NoContraction
               OpDecorate %468 NoContraction
               OpDecorate %488 NoContraction
               OpDecorate %493 NoContraction
               OpDecorate %497 NoContraction
               OpDecorate %501 NoContraction
               OpDecorate %678 NoContraction
               OpDecorate %682 NoContraction
               OpDecorate %686 NoContraction
               OpDecorate %690 NoContraction
               OpDecorate %694 NoContraction
               OpDecorate %698 NoContraction
               OpDecorate %702 NoContraction
               OpDecorate %706 NoContraction
               OpDecorate %710 NoContraction
               OpDecorate %714 NoContraction
               OpDecorate %718 NoContraction
               OpDecorate %722 NoContraction
               OpDecorate %726 NoContraction
               OpDecorate %730 NoContraction
               OpDecorate %734 NoContraction
               OpDecorate %738 NoContraction
               OpDecorate %845 NoContraction
               OpDecorate %848 NoContraction
               OpDecorate %851 NoContraction
               OpDecorate %854 NoContraction
               OpDecorate %856 NoContraction
               OpDecorate %858 NoContraction
               OpDecorate %860 NoContraction
               OpDecorate %862 NoContraction
               OpDecorate %896 NoContraction
               OpDecorate %898 NoContraction
               OpDecorate %900 NoContraction
               OpDecorate %902 NoContraction
               OpDecorate %904 NoContraction
               OpDecorate %906 NoContraction
               OpDecorate %908 NoContraction
               OpDecorate %910 NoContraction
               OpDecorate %944 NoContraction
               OpDecorate %946 NoContraction
               OpDecorate %948 NoContraction
               OpDecorate %950 NoContraction
               OpDecorate %952 NoContraction
               OpDecorate %954 NoContraction
               OpDecorate %956 NoContraction
               OpDecorate %958 NoContraction
               OpDecorate %992 NoContraction
               OpDecorate %994 NoContraction
               OpDecorate %996 NoContraction
               OpDecorate %998 NoContraction
               OpDecorate %1000 NoContraction
               OpDecorate %1002 NoContraction
               OpDecorate %1004 NoContraction
               OpDecorate %1006 NoContraction
               OpDecorate %1040 NoContraction
               OpDecorate %1042 NoContraction
               OpDecorate %1044 NoContraction
               OpDecorate %1046 NoContraction
               OpDecorate %1048 NoContraction
               OpDecorate %1050 NoContraction
               OpDecorate %1052 NoContraction
               OpDecorate %1054 NoContraction
               OpDecorate %1088 NoContraction
               OpDecorate %1090 NoContraction
               OpDecorate %1092 NoContraction
               OpDecorate %1094 NoContraction
               OpDecorate %1112 NoContraction
               OpDecorate %1114 NoContraction
               OpDecorate %1116 NoContraction
               OpDecorate %1118 NoContraction
               OpDecorate %1120 NoContraction
               OpDecorate %1122 NoContraction
               OpDecorate %1140 NoContraction
               OpDecorate %1142 NoContraction
               OpDecorate %1144 NoContraction
               OpDecorate %1146 NoContraction
               OpDecorate %1164 NoContraction
               OpDecorate %1166 NoContraction
               OpDecorate %1167 NoContraction
               OpDecorate %1168 NoContraction
               OpDecorate %1169 NoContraction
               OpDecorate %1186 NoContraction
               OpDecorate %1205 NoContraction
               OpDecorate %1208 NoContraction
               OpDecorate %1211 NoContraction
               OpDecorate %1214 NoContraction
               OpDecorate %1216 NoContraction
               OpDecorate %1218 NoContraction
               OpDecorate %1220 NoContraction
               OpDecorate %1222 NoContraction
               OpDecorate %1256 NoContraction
               OpDecorate %1258 NoContraction
               OpDecorate %1260 NoContraction
               OpDecorate %1262 NoContraction
               OpDecorate %1264 NoContraction
               OpDecorate %1266 NoContraction
               OpDecorate %1268 NoContraction
               OpDecorate %1270 NoContraction
               OpDecorate %1304 NoContraction
               OpDecorate %1306 NoContraction
               OpDecorate %1308 NoContraction
               OpDecorate %1310 NoContraction
               OpDecorate %1312 NoContraction
               OpDecorate %1314 NoContraction
               OpDecorate %1316 NoContraction
               OpDecorate %1318 NoContraction
               OpDecorate %1352 NoContraction
               OpDecorate %1354 NoContraction
               OpDecorate %1356 NoContraction
               OpDecorate %1358 NoContraction
               OpDecorate %1360 NoContraction
               OpDecorate %1362 NoContraction
               OpDecorate %1364 NoContraction
               OpDecorate %1366 NoContraction
               OpDecorate %1400 NoContraction
               OpDecorate %1402 NoContraction
               OpDecorate %1404 NoContraction
               OpDecorate %1406 NoContraction
               OpDecorate %1408 NoContraction
               OpDecorate %1410 NoContraction
               OpDecorate %1412 NoContraction
               OpDecorate %1414 NoContraction
               OpDecorate %1448 NoContraction
               OpDecorate %1450 NoContraction
               OpDecorate %1452 NoContraction
               OpDecorate %1454 NoContraction
               OpDecorate %1472 NoContraction
               OpDecorate %1474 NoContraction
               OpDecorate %1476 NoContraction
               OpDecorate %1478 NoContraction
               OpDecorate %1480 NoContraction
               OpDecorate %1482 NoContraction
               OpDecorate %1500 NoContraction
               OpDecorate %1502 NoContraction
               OpDecorate %1504 NoContraction
               OpDecorate %1506 NoContraction
               OpDecorate %1524 NoContraction
               OpDecorate %1526 NoContraction
               OpDecorate %1527 NoContraction
               OpDecorate %1528 NoContraction
               OpDecorate %1529 NoContraction
               OpDecorate %1550 NoContraction
               OpDecorate %1569 NoContraction
               OpDecorate %1572 NoContraction
               OpDecorate %1575 NoContraction
               OpDecorate %1578 NoContraction
               OpDecorate %1580 NoContraction
               OpDecorate %1582 NoContraction
               OpDecorate %1584 NoContraction
               OpDecorate %1586 NoContraction
               OpDecorate %1620 NoContraction
               OpDecorate %1622 NoContraction
               OpDecorate %1624 NoContraction
               OpDecorate %1626 NoContraction
               OpDecorate %1628 NoContraction
               OpDecorate %1630 NoContraction
               OpDecorate %1632 NoContraction
               OpDecorate %1634 NoContraction
               OpDecorate %1668 NoContraction
               OpDecorate %1670 NoContraction
               OpDecorate %1672 NoContraction
               OpDecorate %1674 NoContraction
               OpDecorate %1676 NoContraction
               OpDecorate %1678 NoContraction
               OpDecorate %1680 NoContraction
               OpDecorate %1682 NoContraction
               OpDecorate %1716 NoContraction
               OpDecorate %1718 NoContraction
               OpDecorate %1720 NoContraction
               OpDecorate %1722 NoContraction
               OpDecorate %1724 NoContraction
               OpDecorate %1726 NoContraction
               OpDecorate %1728 NoContraction
               OpDecorate %1730 NoContraction
               OpDecorate %1764 NoContraction
               OpDecorate %1766 NoContraction
               OpDecorate %1768 NoContraction
               OpDecorate %1770 NoContraction
               OpDecorate %1772 NoContraction
               OpDecorate %1774 NoContraction
               OpDecorate %1776 NoContraction
               OpDecorate %1778 NoContraction
               OpDecorate %1812 NoContraction
               OpDecorate %1814 NoContraction
               OpDecorate %1816 NoContraction
               OpDecorate %1818 NoContraction
               OpDecorate %1820 NoContraction
               OpDecorate %1822 NoContraction
               OpDecorate %1824 NoContraction
               OpDecorate %1826 NoContraction
               OpDecorate %1872 NoContraction
               OpDecorate %1874 NoContraction
               OpDecorate %1876 NoContraction
               OpDecorate %1878 NoContraction
               OpDecorate %1880 NoContraction
               OpDecorate %1882 NoContraction
               OpDecorate %1884 NoContraction
               OpDecorate %1885 NoContraction
               OpDecorate %1887 NoContraction
               OpDecorate %1905 NoContraction
               OpDecorate %1908 NoContraction
               OpDecorate %1911 NoContraction
               OpDecorate %1914 NoContraction
               OpDecorate %1916 NoContraction
               OpDecorate %1933 NoContraction
               OpDecorate %1934 NoContraction
               OpDecorate %1953 NoContraction
               OpDecorate %1956 NoContraction
               OpDecorate %1959 NoContraction
               OpDecorate %1962 NoContraction
               OpDecorate %1964 NoContraction
               OpDecorate %1966 NoContraction
               OpDecorate %1968 NoContraction
               OpDecorate %1971 NoContraction
               OpDecorate %1973 NoContraction
               OpDecorate %1976 NoContraction
               OpDecorate %1979 NoContraction
               OpDecorate %2013 NoContraction
               OpDecorate %2015 NoContraction
               OpDecorate %2017 NoContraction
               OpDecorate %2019 NoContraction
               OpDecorate %2021 NoContraction
               OpDecorate %2023 NoContraction
               OpDecorate %2025 NoContraction
               OpDecorate %2043 NoContraction
               OpDecorate %2061 NoContraction
               OpDecorate %2063 NoContraction
               OpDecorate %2065 NoContraction
               OpDecorate %2067 NoContraction
               OpDecorate %2069 NoContraction
               OpDecorate %2071 NoContraction
               OpDecorate %2073 NoContraction
               OpDecorate %2091 NoContraction
               OpDecorate %2109 NoContraction
               OpDecorate %2111 NoContraction
               OpDecorate %2113 NoContraction
               OpDecorate %2115 NoContraction
               OpDecorate %2117 NoContraction
               OpDecorate %2119 NoContraction
               OpDecorate %2121 NoContraction
               OpDecorate %2139 NoContraction
               OpDecorate %2157 NoContraction
               OpDecorate %2159 NoContraction
               OpDecorate %2161 NoContraction
               OpDecorate %2163 NoContraction
               OpDecorate %2165 NoContraction
               OpDecorate %2167 NoContraction
               OpDecorate %2169 NoContraction
               OpDecorate %2187 NoContraction
               OpDecorate %2205 NoContraction
               OpDecorate %2207 NoContraction
               OpDecorate %2209 NoContraction
               OpDecorate %2211 NoContraction
               OpDecorate %2213 NoContraction
               OpDecorate %2215 NoContraction
               OpDecorate %2233 NoContraction
               OpDecorate %2235 NoContraction
               OpDecorate %2253 NoContraction
               OpDecorate %2256 NoContraction
               OpDecorate %2258 NoContraction
               OpDecorate %2260 NoContraction
               OpDecorate %2262 NoContraction
               OpDecorate %2264 NoContraction
               OpDecorate %2266 NoContraction
               OpDecorate %2268 NoContraction
               OpDecorate %2270 NoContraction
               OpDecorate %2271 NoContraction
               OpDecorate %2272 NoContraction
               OpDecorate %2273 NoContraction
               OpDecorate %2274 NoContraction
               OpDecorate %2276 NoContraction
               OpDecorate %2279 NoContraction
               OpDecorate %2282 NoContraction
               OpDecorate %2285 NoContraction
               OpDecorate %2302 NoContraction
               OpDecorate %2305 NoContraction
               OpDecorate %2308 NoContraction
               OpDecorate %2311 NoContraction
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
  %gt_lim100000 = OpConstant %u32_id 100000
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
         %64 = OpTypeImage %f32_id 2D 0 0 0 1 Unknown
%_ptr_UniformConstant_64 = OpTypePointer UniformConstant %64
         %67 = OpTypeSampledImage %64
         %68 = OpTypeImage %f32_id 2D 0 1 0 1 Unknown
%_ptr_UniformConstant_68 = OpTypePointer UniformConstant %68
         %71 = OpTypeSampledImage %68
         %72 = OpTypeSampler
%_ptr_UniformConstant_72 = OpTypePointer UniformConstant %72
         %75 = OpTypeFunction %void_id
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
    %cs_img0 = OpVariable %_ptr_UniformConstant_68 UniformConstant
%cs_sampsgpr_24 = OpVariable %_ptr_UniformConstant_72 UniformConstant
         %76 = OpFunction %void_id None %75
         %77 = OpLabel
        %105 = OpLoad %u32vec3_id %gl_WorkGroupID
        %106 = OpCompositeExtract %u32_id %105 0
        %107 = OpCompositeExtract %u32_id %105 1
        %108 = OpCompositeExtract %u32_id %105 2
        %109 = OpLoad %u32vec3_id %gl_NumWorkGroups
        %110 = OpCompositeExtract %u32_id %109 0
        %111 = OpCompositeExtract %u32_id %109 1
        %112 = OpIMul %u32_id %110 %111
        %113 = OpIMul %u32_id %108 %112
        %114 = OpIMul %u32_id %107 %110
        %115 = OpIAdd %u32_id %106 %114
%workgroup_index = OpIAdd %u32_id %115 %113
        %119 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
        %120 = OpLoad %u32_id %119
   %buf0_off = OpBitFieldUExtract %u32_id %120 %u32_id_0 %u32_id_8
%buf0_dword_off = OpShiftRightLogical %u32_id %buf0_off %u32_id_2
        %124 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
        %125 = OpLoad %u32_id %124
   %buf1_off = OpBitFieldUExtract %u32_id %125 %u32_id_8 %u32_id_8
%buf1_dword_off = OpShiftRightLogical %u32_id %buf1_off %u32_id_2
        %128 = OpLoad %u32vec3_id %gl_LocalInvocationID
        %129 = OpCompositeExtract %u32_id %128 0
        %130 = OpLoad %u32vec3_id %gl_LocalInvocationID
        %131 = OpCompositeExtract %u32_id %130 1
        %132 = OpLoad %u32vec3_id %gl_LocalInvocationID
        %133 = OpCompositeExtract %u32_id %132 2
        %134 = OpShiftRightLogical %u32_id %133 %u32_id_2
        %136 = OpBitwiseAnd %u32_id %u32_id_3 %133
        %138 = OpIAdd %u32_id %u32_id_72 %buf0_dword_off
        %139 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %138
        %140 = OpLoad %u32_id %139
        %142 = OpIAdd %u32_id %u32_id_73 %buf0_dword_off
        %143 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %142
        %144 = OpLoad %u32_id %143
        %146 = OpIAdd %u32_id %u32_id_75 %buf0_dword_off
        %147 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %146
        %148 = OpLoad %u32_id %147
        %150 = OpIAdd %u32_id %u32_id_79 %buf0_dword_off
        %151 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %150
        %152 = OpLoad %u32_id %151
        %154 = OpIAdd %u32_id %u32_id_80 %buf0_dword_off
        %155 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %154
        %156 = OpLoad %u32_id %155
        %158 = OpIAdd %u32_id %u32_id_81 %buf0_dword_off
        %159 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %158
        %160 = OpLoad %u32_id %159
        %162 = OpIAdd %u32_id %u32_id_82 %buf0_dword_off
        %163 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %162
        %164 = OpLoad %u32_id %163
        %165 = OpShiftLeftLogical %u32_id %140 %u32_id_3
        %166 = OpIMul %u32_id %165 %134
        %167 = OpIMul %u32_id %165 %136
        %168 = OpIAdd %u32_id %129 %166
        %169 = OpIAdd %u32_id %131 %167
        %170 = OpConvertUToF %f32_id %168
        %171 = OpConvertUToF %f32_id %169
        %175 = OpExtInst %f32_id %174 Fma %f32_id_0_125 %170 %f32_id_0_0625
        %176 = OpExtInst %f32_id %174 Fma %f32_id_0_125 %171 %f32_id_0_0625
        %177 = OpBitcast %f32_id %148
        %178 = OpFMul %f32_id %177 %175
        %180 = OpFAdd %f32_id %178 %f32_id_1
        %181 = OpBitcast %f32_id %148
        %182 = OpFMul %f32_id %181 %176
        %183 = OpFAdd %f32_id %182 %f32_id_1
        %184 = OpConvertUToF %f32_id %144
               OpBranch %78
         %78 = OpLabel
        %185 = OpPhi %u32_id %u32_id_0 %77 %515 %94
        %186 = OpPhi %u32_id %u32_id_0 %77 %516 %94
        %187 = OpPhi %u32_id %u32_id_0 %77 %517 %94
        %188 = OpPhi %u32_id %u32_id_0 %77 %518 %94
        %189 = OpPhi %u32_id %u32_id_0 %77 %503 %94
        %190 = OpPhi %u32_id %u32_id_0 %77 %504 %94
        %191 = OpPhi %u32_id %u32_id_0 %77 %505 %94
        %192 = OpPhi %u32_id %u32_id_0 %77 %506 %94
        %193 = OpPhi %u32_id %u32_id_0 %77 %507 %94
        %194 = OpPhi %u32_id %u32_id_0 %77 %508 %94
        %195 = OpPhi %u32_id %u32_id_0 %77 %509 %94
        %196 = OpPhi %u32_id %u32_id_0 %77 %510 %94
        %197 = OpPhi %u32_id %u32_id_0 %77 %511 %94
        %198 = OpPhi %u32_id %u32_id_0 %77 %512 %94
        %199 = OpPhi %u32_id %u32_id_0 %77 %513 %94
        %200 = OpPhi %u32_id %u32_id_0 %77 %514 %94
        %201 = OpPhi %u32_id %u32_id_0 %77 %519 %94
       %gtc2359 = OpPhi %u32_id %u32_id_0 %77 %gtc2360 %94
               OpLoopMerge %95 %94 None
               OpBranch %79
         %79 = OpLabel
        %202 = OpConvertUToF %f32_id %201
        %204 = OpIMul %u32_id %201 %u32_id_16
        %206 = OpIAdd %u32_id %204 %u32_id_96
        %208 = OpIAdd %u32_id %204 %u32_id_192
        %209 = OpShiftRightLogical %u32_id %204 %u32_id_2
        %210 = OpIAdd %u32_id %209 %buf0_dword_off
        %211 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %210
        %212 = OpLoad %u32_id %211
        %213 = OpIAdd %u32_id %209 %u32_id_1
        %214 = OpIAdd %u32_id %213 %buf0_dword_off
        %215 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %214
        %216 = OpLoad %u32_id %215
        %217 = OpIAdd %u32_id %209 %u32_id_2
        %218 = OpIAdd %u32_id %217 %buf0_dword_off
        %219 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %218
        %220 = OpLoad %u32_id %219
        %221 = OpShiftRightLogical %u32_id %206 %u32_id_2
        %222 = OpIAdd %u32_id %221 %buf0_dword_off
        %223 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %222
        %224 = OpLoad %u32_id %223
        %225 = OpIAdd %u32_id %221 %u32_id_1
        %226 = OpIAdd %u32_id %225 %buf0_dword_off
        %227 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %226
        %228 = OpLoad %u32_id %227
        %229 = OpIAdd %u32_id %221 %u32_id_2
        %230 = OpIAdd %u32_id %229 %buf0_dword_off
        %231 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %230
        %232 = OpLoad %u32_id %231
        %233 = OpShiftRightLogical %u32_id %208 %u32_id_2
        %234 = OpIAdd %u32_id %233 %buf0_dword_off
        %235 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %234
        %236 = OpLoad %u32_id %235
        %237 = OpIAdd %u32_id %233 %u32_id_1
        %238 = OpIAdd %u32_id %237 %buf0_dword_off
        %239 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %238
        %240 = OpLoad %u32_id %239
        %241 = OpIAdd %u32_id %233 %u32_id_2
        %242 = OpIAdd %u32_id %241 %buf0_dword_off
        %243 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %242
        %244 = OpLoad %u32_id %243
        %245 = OpBitcast %u32_id %183
        %246 = OpBitcast %f32_id %212
        %247 = OpFMul %f32_id %246 %170
        %248 = OpBitcast %f32_id %216
        %249 = OpFMul %f32_id %248 %170
        %250 = OpBitcast %f32_id %220
        %251 = OpFMul %f32_id %250 %170
        %252 = OpBitcast %f32_id %224
        %253 = OpFMul %f32_id %252 %171
        %254 = OpFAdd %f32_id %253 %247
        %255 = OpBitcast %f32_id %228
        %256 = OpFMul %f32_id %255 %171
        %257 = OpFAdd %f32_id %256 %249
        %258 = OpBitcast %f32_id %232
        %259 = OpFMul %f32_id %258 %171
        %260 = OpFAdd %f32_id %259 %251
        %261 = OpBitcast %f32_id %236
        %262 = OpFMul %f32_id %f32_id_0_125 %254
        %263 = OpFAdd %f32_id %262 %261
        %264 = OpBitcast %u32_id %263
        %265 = OpBitcast %f32_id %240
        %266 = OpFMul %f32_id %f32_id_0_125 %257
        %267 = OpFAdd %f32_id %266 %265
        %268 = OpBitcast %u32_id %267
        %269 = OpBitcast %f32_id %244
        %270 = OpFMul %f32_id %f32_id_0_125 %260
        %271 = OpFAdd %f32_id %270 %269
        %272 = OpBitcast %u32_id %271
               OpBranch %80
         %80 = OpLabel
        %273 = OpPhi %u32_id %185 %79 %482 %92
        %274 = OpPhi %u32_id %186 %79 %483 %92
        %275 = OpPhi %u32_id %187 %79 %484 %92
        %276 = OpPhi %u32_id %188 %79 %485 %92
        %277 = OpPhi %u32_id %189 %79 %470 %92
        %278 = OpPhi %u32_id %190 %79 %471 %92
        %279 = OpPhi %u32_id %191 %79 %472 %92
        %280 = OpPhi %u32_id %192 %79 %473 %92
        %281 = OpPhi %u32_id %193 %79 %474 %92
        %282 = OpPhi %u32_id %194 %79 %475 %92
        %283 = OpPhi %u32_id %195 %79 %476 %92
        %284 = OpPhi %u32_id %196 %79 %477 %92
        %285 = OpPhi %u32_id %197 %79 %478 %92
        %286 = OpPhi %u32_id %198 %79 %479 %92
        %287 = OpPhi %u32_id %199 %79 %480 %92
        %288 = OpPhi %u32_id %200 %79 %481 %92
        %289 = OpPhi %u32_id %245 %79 %489 %92
        %290 = OpPhi %u32_id %272 %79 %502 %92
        %291 = OpPhi %u32_id %268 %79 %498 %92
        %292 = OpPhi %u32_id %264 %79 %494 %92
        %293 = OpPhi %u32_id %u32_id_0 %79 %490 %92
       %gtc2363 = OpPhi %u32_id %u32_id_0 %79 %gtc2364 %92
               OpLoopMerge %93 %92 None
               OpBranch %81
         %81 = OpLabel
        %294 = OpULessThan %bool_id %293 %140
        %295 = OpLogicalNot %bool_id %294
       %gtc2365 = OpUGreaterThanEqual %bool_id %gtc2363 %gt_lim100000
       %gtc2366 = OpLogicalOr %bool_id %295 %gtc2365
               OpBranchConditional %gtc2366 %93 %82
         %82 = OpLabel
        %296 = OpBitcast %u32_id %180
               OpBranch %83
         %83 = OpLabel
        %297 = OpPhi %u32_id %273 %82 %449 %90
        %298 = OpPhi %u32_id %274 %82 %450 %90
        %299 = OpPhi %u32_id %275 %82 %451 %90
        %300 = OpPhi %u32_id %276 %82 %452 %90
        %301 = OpPhi %u32_id %277 %82 %409 %90
        %302 = OpPhi %u32_id %278 %82 %413 %90
        %303 = OpPhi %u32_id %279 %82 %417 %90
        %304 = OpPhi %u32_id %280 %82 %405 %90
        %305 = OpPhi %u32_id %281 %82 %393 %90
        %306 = OpPhi %u32_id %282 %82 %397 %90
        %307 = OpPhi %u32_id %283 %82 %401 %90
        %308 = OpPhi %u32_id %284 %82 %389 %90
        %309 = OpPhi %u32_id %285 %82 %377 %90
        %310 = OpPhi %u32_id %286 %82 %381 %90
        %311 = OpPhi %u32_id %287 %82 %385 %90
        %312 = OpPhi %u32_id %288 %82 %373 %90
        %313 = OpPhi %u32_id %290 %82 %469 %90
        %314 = OpPhi %u32_id %291 %82 %465 %90
        %315 = OpPhi %u32_id %292 %82 %461 %90
        %316 = OpPhi %u32_id %296 %82 %457 %90
        %317 = OpPhi %u32_id %u32_id_0 %82 %453 %90
       %gtc2367 = OpPhi %u32_id %u32_id_0 %82 %gtc2368 %90
               OpLoopMerge %91 %90 None
               OpBranch %84
         %84 = OpLabel
        %318 = OpULessThan %bool_id %317 %140
        %319 = OpLogicalNot %bool_id %318
       %gtc2369 = OpUGreaterThanEqual %bool_id %gtc2367 %gt_lim100000
       %gtc2370 = OpLogicalOr %bool_id %319 %gtc2369
               OpBranchConditional %gtc2370 %91 %85
         %85 = OpLabel
        %320 = OpBitcast %f32_id %289
        %321 = OpBitcast %f32_id %316
        %322 = OpCompositeConstruct %f32vec2_id %321 %320
        %323 = OpLoad %64 %cs_img16
        %324 = OpLoad %72 %cs_sampsgpr_24
        %325 = OpSampledImage %67 %323 %324
        %326 = OpImageSampleExplicitLod %f32vec4_id %325 %322 Lod %f32_id_0
        %327 = OpCompositeExtract %f32_id %326 0
        %328 = OpBitcast %f32_id %289
        %329 = OpBitcast %f32_id %316
        %330 = OpFSub %f32_id %329 %f32_id_1
        %331 = OpFSub %f32_id %328 %f32_id_1
        %333 = OpFDiv %f32_id %202 %f32_id_8
        %334 = OpExtInst %f32_id %174 Floor %333
        %336 = OpExtInst %f32_id %174 Fma %334 %f32_id_n2 %202
        %337 = OpCompositeConstruct %f32vec3_id %330 %331 %336
        %338 = OpLoad %68 %cs_img0
        %339 = OpLoad %72 %cs_sampsgpr_24
        %340 = OpSampledImage %71 %338 %339
        %341 = OpImageSampleExplicitLod %f32vec4_id %340 %337 Lod %184
        %342 = OpCompositeExtract %f32_id %341 0
        %343 = OpCompositeExtract %f32_id %341 1
        %344 = OpCompositeExtract %f32_id %341 2
        %345 = OpBitcast %f32_id %315
        %346 = OpBitcast %f32_id %315
        %347 = OpFMul %f32_id %346 %345
        %348 = OpBitcast %f32_id %314
        %349 = OpBitcast %f32_id %314
        %350 = OpFMul %f32_id %348 %349
        %351 = OpFAdd %f32_id %350 %347
        %352 = OpBitcast %f32_id %313
        %353 = OpBitcast %f32_id %313
        %354 = OpFMul %f32_id %352 %353
        %355 = OpFAdd %f32_id %354 %351
        %356 = OpExtInst %f32_id %174 InverseSqrt %355
        %357 = OpFDiv %f32_id %f32_id_1 %355
        %358 = OpFMul %f32_id %356 %357
        %359 = OpBitcast %f32_id %315
        %360 = OpFMul %f32_id %356 %359
        %361 = OpBitcast %f32_id %314
        %362 = OpFMul %f32_id %356 %361
        %363 = OpBitcast %f32_id %313
        %364 = OpFMul %f32_id %356 %363
        %365 = OpBitcast %f32_id %152
        %366 = OpFOrdGreaterThan %bool_id %365 %327
        %367 = OpFMul %f32_id %342 %358
        %368 = OpFMul %f32_id %343 %358
        %369 = OpFMul %f32_id %344 %358
        %370 = OpBitcast %f32_id %312
        %371 = OpFMul %f32_id %358 %344
        %372 = OpFAdd %f32_id %371 %370
        %373 = OpBitcast %u32_id %372
        %374 = OpBitcast %f32_id %309
        %375 = OpFMul %f32_id %364 %369
        %376 = OpFAdd %f32_id %375 %374
        %377 = OpBitcast %u32_id %376
        %378 = OpBitcast %f32_id %310
        %379 = OpFMul %f32_id %362 %369
        %380 = OpFAdd %f32_id %379 %378
        %381 = OpBitcast %u32_id %380
        %382 = OpBitcast %f32_id %311
        %383 = OpFMul %f32_id %360 %369
        %384 = OpFAdd %f32_id %383 %382
        %385 = OpBitcast %u32_id %384
        %386 = OpBitcast %f32_id %308
        %387 = OpFMul %f32_id %358 %343
        %388 = OpFAdd %f32_id %387 %386
        %389 = OpBitcast %u32_id %388
        %390 = OpBitcast %f32_id %305
        %391 = OpFMul %f32_id %364 %368
        %392 = OpFAdd %f32_id %391 %390
        %393 = OpBitcast %u32_id %392
        %394 = OpBitcast %f32_id %306
        %395 = OpFMul %f32_id %362 %368
        %396 = OpFAdd %f32_id %395 %394
        %397 = OpBitcast %u32_id %396
        %398 = OpBitcast %f32_id %307
        %399 = OpFMul %f32_id %360 %368
        %400 = OpFAdd %f32_id %399 %398
        %401 = OpBitcast %u32_id %400
        %402 = OpBitcast %f32_id %304
        %403 = OpFMul %f32_id %358 %342
        %404 = OpFAdd %f32_id %403 %402
        %405 = OpBitcast %u32_id %404
        %406 = OpBitcast %f32_id %301
        %407 = OpFMul %f32_id %364 %367
        %408 = OpFAdd %f32_id %407 %406
        %409 = OpBitcast %u32_id %408
        %410 = OpBitcast %f32_id %302
        %411 = OpFMul %f32_id %362 %367
        %412 = OpFAdd %f32_id %411 %410
        %413 = OpBitcast %u32_id %412
        %414 = OpBitcast %f32_id %303
        %415 = OpFMul %f32_id %360 %367
        %416 = OpFAdd %f32_id %415 %414
        %417 = OpBitcast %u32_id %416
               OpSelectionMerge %89 None
               OpBranchConditional %366 %86 %89
         %86 = OpLabel
        %418 = OpBitcast %f32_id %156
        %419 = OpFMul %f32_id %418 %360
        %420 = OpBitcast %f32_id %160
        %421 = OpFMul %f32_id %420 %362
        %422 = OpFAdd %f32_id %421 %419
        %423 = OpBitcast %f32_id %164
        %424 = OpFMul %f32_id %423 %364
        %425 = OpFAdd %f32_id %424 %422
        %426 = OpFOrdLessThan %bool_id %f32_id_0 %425
        %427 = OpLogicalAnd %bool_id %366 %426
               OpSelectionMerge %88 None
               OpBranchConditional %427 %87 %88
         %87 = OpLabel
        %428 = OpFMul %f32_id %425 %358
        %429 = OpBitcast %f32_id %300
        %430 = OpFMul %f32_id %358 %425
        %431 = OpFAdd %f32_id %430 %429
        %432 = OpBitcast %u32_id %431
        %433 = OpBitcast %f32_id %297
        %434 = OpFMul %f32_id %364 %428
        %435 = OpFAdd %f32_id %434 %433
        %436 = OpBitcast %u32_id %435
        %437 = OpBitcast %f32_id %298
        %438 = OpFMul %f32_id %362 %428
        %439 = OpFAdd %f32_id %438 %437
        %440 = OpBitcast %u32_id %439
        %441 = OpBitcast %f32_id %299
        %442 = OpFMul %f32_id %360 %428
        %443 = OpFAdd %f32_id %442 %441
        %444 = OpBitcast %u32_id %443
               OpBranch %88
         %88 = OpLabel
        %445 = OpPhi %u32_id %436 %87 %297 %86
        %446 = OpPhi %u32_id %440 %87 %298 %86
        %447 = OpPhi %u32_id %444 %87 %299 %86
        %448 = OpPhi %u32_id %432 %87 %300 %86
               OpBranch %89
         %89 = OpLabel
        %449 = OpPhi %u32_id %445 %88 %297 %85
        %450 = OpPhi %u32_id %446 %88 %298 %85
        %451 = OpPhi %u32_id %447 %88 %299 %85
        %452 = OpPhi %u32_id %448 %88 %300 %85
        %453 = OpIAdd %u32_id %317 %u32_id_1
        %454 = OpBitcast %f32_id %148
        %455 = OpBitcast %f32_id %316
        %456 = OpFAdd %f32_id %454 %455
        %457 = OpBitcast %u32_id %456
        %458 = OpBitcast %f32_id %212
        %459 = OpBitcast %f32_id %315
        %460 = OpFAdd %f32_id %458 %459
        %461 = OpBitcast %u32_id %460
        %462 = OpBitcast %f32_id %216
        %463 = OpBitcast %f32_id %314
        %464 = OpFAdd %f32_id %462 %463
        %465 = OpBitcast %u32_id %464
        %466 = OpBitcast %f32_id %220
        %467 = OpBitcast %f32_id %313
        %468 = OpFAdd %f32_id %466 %467
        %469 = OpBitcast %u32_id %468
               OpBranch %90
         %90 = OpLabel
       %gtc2368 = OpIAdd %u32_id %gtc2367 %u32_id_1
               OpBranchConditional %true %83 %91
         %91 = OpLabel
        %470 = OpPhi %u32_id %301 %84 %409 %90
        %471 = OpPhi %u32_id %302 %84 %413 %90
        %472 = OpPhi %u32_id %303 %84 %417 %90
        %473 = OpPhi %u32_id %304 %84 %405 %90
        %474 = OpPhi %u32_id %305 %84 %393 %90
        %475 = OpPhi %u32_id %306 %84 %397 %90
        %476 = OpPhi %u32_id %307 %84 %401 %90
        %477 = OpPhi %u32_id %308 %84 %389 %90
        %478 = OpPhi %u32_id %309 %84 %377 %90
        %479 = OpPhi %u32_id %310 %84 %381 %90
        %480 = OpPhi %u32_id %311 %84 %385 %90
        %481 = OpPhi %u32_id %312 %84 %373 %90
        %482 = OpPhi %u32_id %297 %84 %449 %90
        %483 = OpPhi %u32_id %298 %84 %450 %90
        %484 = OpPhi %u32_id %299 %84 %451 %90
        %485 = OpPhi %u32_id %300 %84 %452 %90
        %486 = OpBitcast %f32_id %148
        %487 = OpBitcast %f32_id %289
        %488 = OpFAdd %f32_id %486 %487
        %489 = OpBitcast %u32_id %488
        %490 = OpIAdd %u32_id %293 %u32_id_1
        %491 = OpBitcast %f32_id %224
        %492 = OpBitcast %f32_id %292
        %493 = OpFAdd %f32_id %491 %492
        %494 = OpBitcast %u32_id %493
        %495 = OpBitcast %f32_id %228
        %496 = OpBitcast %f32_id %291
        %497 = OpFAdd %f32_id %495 %496
        %498 = OpBitcast %u32_id %497
        %499 = OpBitcast %f32_id %232
        %500 = OpBitcast %f32_id %290
        %501 = OpFAdd %f32_id %499 %500
        %502 = OpBitcast %u32_id %501
               OpBranch %92
         %92 = OpLabel
       %gtc2364 = OpIAdd %u32_id %gtc2363 %u32_id_1
               OpBranchConditional %true %80 %93
         %93 = OpLabel
        %503 = OpPhi %u32_id %277 %81 %470 %92
        %504 = OpPhi %u32_id %278 %81 %471 %92
        %505 = OpPhi %u32_id %279 %81 %472 %92
        %506 = OpPhi %u32_id %280 %81 %473 %92
        %507 = OpPhi %u32_id %281 %81 %474 %92
        %508 = OpPhi %u32_id %282 %81 %475 %92
        %509 = OpPhi %u32_id %283 %81 %476 %92
        %510 = OpPhi %u32_id %284 %81 %477 %92
        %511 = OpPhi %u32_id %285 %81 %478 %92
        %512 = OpPhi %u32_id %286 %81 %479 %92
        %513 = OpPhi %u32_id %287 %81 %480 %92
        %514 = OpPhi %u32_id %288 %81 %481 %92
        %515 = OpPhi %u32_id %273 %81 %482 %92
        %516 = OpPhi %u32_id %274 %81 %483 %92
        %517 = OpPhi %u32_id %275 %81 %484 %92
        %518 = OpPhi %u32_id %276 %81 %485 %92
        %519 = OpIAdd %u32_id %201 %u32_id_1
        %521 = OpULessThan %bool_id %519 %u32_id_6
               OpBranch %94
         %94 = OpLabel
       %gtc2360 = OpIAdd %u32_id %gtc2359 %u32_id_1
       %gtc2361 = OpULessThan %bool_id %gtc2359 %gt_lim100000
       %gtc2362 = OpLogicalAnd %bool_id %521 %gtc2361
               OpBranchConditional %gtc2362 %78 %95
         %95 = OpLabel
        %523 = OpBitFieldUExtract %u32_id %131 %u32_id_0 %u32_id_24
        %524 = OpIMul %u32_id %523 %u32_id_8
        %525 = OpIAdd %u32_id %524 %129
        %526 = OpBitFieldUExtract %u32_id %133 %u32_id_0 %u32_id_24
        %528 = OpIMul %u32_id %526 %u32_id_64
        %529 = OpIAdd %u32_id %528 %525
        %530 = OpShiftLeftLogical %u32_id %529 %u32_id_6
        %531 = OpCompositeConstruct %u32vec2_id %506 %505
        %532 = OpBitcast %u64_id %531
        %534 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %535 = OpIAdd %u32_id %530 %534
        %536 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %535
               OpStore %536 %532
        %537 = OpIAdd %u32_id %530 %u32_id_8
        %538 = OpCompositeConstruct %u32vec2_id %504 %503
        %539 = OpBitcast %u64_id %538
        %540 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %541 = OpIAdd %u32_id %537 %540
        %542 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %541
               OpStore %542 %539
        %543 = OpIAdd %u32_id %530 %u32_id_16
        %544 = OpCompositeConstruct %u32vec2_id %510 %509
        %545 = OpBitcast %u64_id %544
        %546 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %547 = OpIAdd %u32_id %543 %546
        %548 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %547
               OpStore %548 %545
        %549 = OpIAdd %u32_id %530 %u32_id_24
        %550 = OpCompositeConstruct %u32vec2_id %508 %507
        %551 = OpBitcast %u64_id %550
        %552 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %553 = OpIAdd %u32_id %549 %552
        %554 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %553
               OpStore %554 %551
        %556 = OpIAdd %u32_id %530 %u32_id_32
        %557 = OpCompositeConstruct %u32vec2_id %514 %513
        %558 = OpBitcast %u64_id %557
        %559 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %560 = OpIAdd %u32_id %556 %559
        %561 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %560
               OpStore %561 %558
        %563 = OpIAdd %u32_id %530 %u32_id_40
        %564 = OpCompositeConstruct %u32vec2_id %512 %511
        %565 = OpBitcast %u64_id %564
        %566 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %567 = OpIAdd %u32_id %563 %566
        %568 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %567
               OpStore %568 %565
        %570 = OpIAdd %u32_id %530 %u32_id_48
        %571 = OpCompositeConstruct %u32vec2_id %518 %517
        %572 = OpBitcast %u64_id %571
        %573 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %574 = OpIAdd %u32_id %570 %573
        %575 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %574
               OpStore %575 %572
        %577 = OpIAdd %u32_id %530 %u32_id_56
        %578 = OpCompositeConstruct %u32vec2_id %516 %515
        %579 = OpBitcast %u64_id %578
        %580 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %581 = OpIAdd %u32_id %577 %580
        %582 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %581
               OpStore %582 %579
               OpControlBarrier %u32_id_2 %u32_id_2 %u32_id_264
        %584 = OpINotEqual %bool_id %u32_id_0 %131
        %585 = OpINotEqual %bool_id %u32_id_0 %129
        %586 = OpLogicalOr %bool_id %585 %584
        %587 = OpLogicalNot %bool_id %586
        %588 = OpLogicalNot %bool_id %586
               OpSelectionMerge %103 None
               OpBranchConditional %588 %96 %103
         %96 = OpLabel
               OpBranch %97
         %97 = OpLabel
        %589 = OpPhi %u32_id %503 %96 %727 %99
        %590 = OpPhi %u32_id %504 %96 %731 %99
        %591 = OpPhi %u32_id %505 %96 %735 %99
        %592 = OpPhi %u32_id %506 %96 %739 %99
        %593 = OpPhi %u32_id %507 %96 %711 %99
        %594 = OpPhi %u32_id %508 %96 %715 %99
        %595 = OpPhi %u32_id %509 %96 %719 %99
        %596 = OpPhi %u32_id %510 %96 %723 %99
        %597 = OpPhi %u32_id %511 %96 %695 %99
        %598 = OpPhi %u32_id %512 %96 %699 %99
        %599 = OpPhi %u32_id %513 %96 %703 %99
        %600 = OpPhi %u32_id %514 %96 %707 %99
        %601 = OpPhi %u32_id %515 %96 %679 %99
        %602 = OpPhi %u32_id %516 %96 %683 %99
        %603 = OpPhi %u32_id %517 %96 %687 %99
        %604 = OpPhi %u32_id %518 %96 %691 %99
        %605 = OpPhi %u32_id %529 %96 %740 %99
        %606 = OpPhi %u32_id %u32_id_1 %96 %741 %99
       %gtc2371 = OpPhi %u32_id %u32_id_0 %96 %gtc2372 %99
               OpLoopMerge %100 %99 None
               OpBranch %98
         %98 = OpLabel
        %607 = OpShiftLeftLogical %u32_id %605 %u32_id_6
        %609 = OpIAdd %u32_id %607 %u32_id_112
        %610 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %611 = OpIAdd %u32_id %609 %610
        %612 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %611
        %613 = OpLoad %u64_id %612
        %614 = OpBitcast %u32vec2_id %613
        %615 = OpCompositeExtract %u32_id %614 0
        %616 = OpCompositeExtract %u32_id %614 1
        %618 = OpIAdd %u32_id %607 %u32_id_120
        %619 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %620 = OpIAdd %u32_id %618 %619
        %621 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %620
        %622 = OpLoad %u64_id %621
        %623 = OpBitcast %u32vec2_id %622
        %624 = OpCompositeExtract %u32_id %623 0
        %625 = OpCompositeExtract %u32_id %623 1
        %626 = OpIAdd %u32_id %607 %u32_id_96
        %627 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %628 = OpIAdd %u32_id %626 %627
        %629 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %628
        %630 = OpLoad %u64_id %629
        %631 = OpBitcast %u32vec2_id %630
        %632 = OpCompositeExtract %u32_id %631 0
        %633 = OpCompositeExtract %u32_id %631 1
        %635 = OpIAdd %u32_id %607 %u32_id_104
        %636 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %637 = OpIAdd %u32_id %635 %636
        %638 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %637
        %639 = OpLoad %u64_id %638
        %640 = OpBitcast %u32vec2_id %639
        %641 = OpCompositeExtract %u32_id %640 0
        %642 = OpCompositeExtract %u32_id %640 1
        %643 = OpIAdd %u32_id %607 %u32_id_80
        %644 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %645 = OpIAdd %u32_id %643 %644
        %646 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %645
        %647 = OpLoad %u64_id %646
        %648 = OpBitcast %u32vec2_id %647
        %649 = OpCompositeExtract %u32_id %648 0
        %650 = OpCompositeExtract %u32_id %648 1
        %652 = OpIAdd %u32_id %607 %u32_id_88
        %653 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %654 = OpIAdd %u32_id %652 %653
        %655 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %654
        %656 = OpLoad %u64_id %655
        %657 = OpBitcast %u32vec2_id %656
        %658 = OpCompositeExtract %u32_id %657 0
        %659 = OpCompositeExtract %u32_id %657 1
        %660 = OpIAdd %u32_id %607 %u32_id_64
        %661 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %662 = OpIAdd %u32_id %660 %661
        %663 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %662
        %664 = OpLoad %u64_id %663
        %665 = OpBitcast %u32vec2_id %664
        %666 = OpCompositeExtract %u32_id %665 0
        %667 = OpCompositeExtract %u32_id %665 1
        %668 = OpIAdd %u32_id %607 %u32_id_72
        %669 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %670 = OpIAdd %u32_id %668 %669
        %671 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %670
        %672 = OpLoad %u64_id %671
        %673 = OpBitcast %u32vec2_id %672
        %674 = OpCompositeExtract %u32_id %673 0
        %675 = OpCompositeExtract %u32_id %673 1
        %676 = OpBitcast %f32_id %625
        %677 = OpBitcast %f32_id %601
        %678 = OpFAdd %f32_id %676 %677
        %679 = OpBitcast %u32_id %678
        %680 = OpBitcast %f32_id %624
        %681 = OpBitcast %f32_id %602
        %682 = OpFAdd %f32_id %680 %681
        %683 = OpBitcast %u32_id %682
        %684 = OpBitcast %f32_id %616
        %685 = OpBitcast %f32_id %603
        %686 = OpFAdd %f32_id %684 %685
        %687 = OpBitcast %u32_id %686
        %688 = OpBitcast %f32_id %615
        %689 = OpBitcast %f32_id %604
        %690 = OpFAdd %f32_id %688 %689
        %691 = OpBitcast %u32_id %690
        %692 = OpBitcast %f32_id %642
        %693 = OpBitcast %f32_id %597
        %694 = OpFAdd %f32_id %692 %693
        %695 = OpBitcast %u32_id %694
        %696 = OpBitcast %f32_id %641
        %697 = OpBitcast %f32_id %598
        %698 = OpFAdd %f32_id %696 %697
        %699 = OpBitcast %u32_id %698
        %700 = OpBitcast %f32_id %633
        %701 = OpBitcast %f32_id %599
        %702 = OpFAdd %f32_id %700 %701
        %703 = OpBitcast %u32_id %702
        %704 = OpBitcast %f32_id %632
        %705 = OpBitcast %f32_id %600
        %706 = OpFAdd %f32_id %704 %705
        %707 = OpBitcast %u32_id %706
        %708 = OpBitcast %f32_id %659
        %709 = OpBitcast %f32_id %593
        %710 = OpFAdd %f32_id %708 %709
        %711 = OpBitcast %u32_id %710
        %712 = OpBitcast %f32_id %658
        %713 = OpBitcast %f32_id %594
        %714 = OpFAdd %f32_id %712 %713
        %715 = OpBitcast %u32_id %714
        %716 = OpBitcast %f32_id %650
        %717 = OpBitcast %f32_id %595
        %718 = OpFAdd %f32_id %716 %717
        %719 = OpBitcast %u32_id %718
        %720 = OpBitcast %f32_id %649
        %721 = OpBitcast %f32_id %596
        %722 = OpFAdd %f32_id %720 %721
        %723 = OpBitcast %u32_id %722
        %724 = OpBitcast %f32_id %675
        %725 = OpBitcast %f32_id %589
        %726 = OpFAdd %f32_id %724 %725
        %727 = OpBitcast %u32_id %726
        %728 = OpBitcast %f32_id %674
        %729 = OpBitcast %f32_id %590
        %730 = OpFAdd %f32_id %728 %729
        %731 = OpBitcast %u32_id %730
        %732 = OpBitcast %f32_id %667
        %733 = OpBitcast %f32_id %591
        %734 = OpFAdd %f32_id %732 %733
        %735 = OpBitcast %u32_id %734
        %736 = OpBitcast %f32_id %666
        %737 = OpBitcast %f32_id %592
        %738 = OpFAdd %f32_id %736 %737
        %739 = OpBitcast %u32_id %738
        %740 = OpIAdd %u32_id %605 %u32_id_1
        %741 = OpIAdd %u32_id %606 %u32_id_1
        %743 = OpSLessThan %bool_id %606 %u32_id_63
               OpBranch %99
         %99 = OpLabel
       %gtc2372 = OpIAdd %u32_id %gtc2371 %u32_id_1
       %gtc2373 = OpULessThan %bool_id %gtc2371 %gt_lim100000
       %gtc2374 = OpLogicalAnd %bool_id %743 %gtc2373
               OpBranchConditional %gtc2374 %97 %100
        %100 = OpLabel
        %745 = OpShiftLeftLogical %u32_id %133 %u32_id_12
        %746 = OpCompositeConstruct %u32vec2_id %739 %735
        %747 = OpBitcast %u64_id %746
        %748 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %749 = OpIAdd %u32_id %745 %748
        %750 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %749
               OpStore %750 %747
        %751 = OpIAdd %u32_id %745 %u32_id_8
        %752 = OpCompositeConstruct %u32vec2_id %731 %727
        %753 = OpBitcast %u64_id %752
        %754 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %755 = OpIAdd %u32_id %751 %754
        %756 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %755
               OpStore %756 %753
        %757 = OpIAdd %u32_id %745 %u32_id_16
        %758 = OpCompositeConstruct %u32vec2_id %723 %719
        %759 = OpBitcast %u64_id %758
        %760 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %761 = OpIAdd %u32_id %757 %760
        %762 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %761
               OpStore %762 %759
        %763 = OpIAdd %u32_id %745 %u32_id_24
        %764 = OpCompositeConstruct %u32vec2_id %715 %711
        %765 = OpBitcast %u64_id %764
        %766 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %767 = OpIAdd %u32_id %763 %766
        %768 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %767
               OpStore %768 %765
        %769 = OpIAdd %u32_id %745 %u32_id_32
        %770 = OpCompositeConstruct %u32vec2_id %707 %703
        %771 = OpBitcast %u64_id %770
        %772 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %773 = OpIAdd %u32_id %769 %772
        %774 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %773
               OpStore %774 %771
        %775 = OpIAdd %u32_id %745 %u32_id_40
        %776 = OpCompositeConstruct %u32vec2_id %699 %695
        %777 = OpBitcast %u64_id %776
        %778 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %779 = OpIAdd %u32_id %775 %778
        %780 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %779
               OpStore %780 %777
        %781 = OpIAdd %u32_id %745 %u32_id_48
        %782 = OpCompositeConstruct %u32vec2_id %691 %687
        %783 = OpBitcast %u64_id %782
        %784 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %785 = OpIAdd %u32_id %781 %784
        %786 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %785
               OpStore %786 %783
        %787 = OpIAdd %u32_id %745 %u32_id_56
        %788 = OpCompositeConstruct %u32vec2_id %683 %679
        %789 = OpBitcast %u64_id %788
        %790 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %791 = OpIAdd %u32_id %787 %790
        %792 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %791
               OpStore %792 %789
               OpControlBarrier %u32_id_2 %u32_id_2 %u32_id_264
        %793 = OpIEqual %bool_id %u32_id_0 %133
        %794 = OpLogicalAnd %bool_id %587 %793
               OpSelectionMerge %102 None
               OpBranchConditional %794 %101 %102
        %101 = OpLabel
        %795 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %797 = OpIAdd %u32_id %795 %u32_id_4096
        %798 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %797
        %799 = OpLoad %u64_id %798
        %800 = OpBitcast %u32vec2_id %799
        %801 = OpCompositeExtract %u32_id %800 0
        %802 = OpCompositeExtract %u32_id %800 1
        %803 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %805 = OpIAdd %u32_id %803 %u32_id_4104
        %806 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %805
        %807 = OpLoad %u64_id %806
        %808 = OpBitcast %u32vec2_id %807
        %809 = OpCompositeExtract %u32_id %808 0
        %810 = OpCompositeExtract %u32_id %808 1
        %811 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %813 = OpIAdd %u32_id %811 %u32_id_8192
        %814 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %813
        %815 = OpLoad %u64_id %814
        %816 = OpBitcast %u32vec2_id %815
        %817 = OpCompositeExtract %u32_id %816 0
        %818 = OpCompositeExtract %u32_id %816 1
        %819 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %821 = OpIAdd %u32_id %819 %u32_id_8200
        %822 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %821
        %823 = OpLoad %u64_id %822
        %824 = OpBitcast %u32vec2_id %823
        %825 = OpCompositeExtract %u32_id %824 0
        %826 = OpCompositeExtract %u32_id %824 1
        %827 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %829 = OpIAdd %u32_id %827 %u32_id_12288
        %830 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %829
        %831 = OpLoad %u64_id %830
        %832 = OpBitcast %u32vec2_id %831
        %833 = OpCompositeExtract %u32_id %832 0
        %834 = OpCompositeExtract %u32_id %832 1
        %835 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %837 = OpIAdd %u32_id %835 %u32_id_12296
        %838 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %837
        %839 = OpLoad %u64_id %838
        %840 = OpBitcast %u32vec2_id %839
        %841 = OpCompositeExtract %u32_id %840 0
        %842 = OpCompositeExtract %u32_id %840 1
        %843 = OpBitcast %f32_id %801
        %844 = OpBitcast %f32_id %817
        %845 = OpFAdd %f32_id %843 %844
        %846 = OpBitcast %f32_id %810
        %847 = OpBitcast %f32_id %826
        %848 = OpFAdd %f32_id %846 %847
        %849 = OpBitcast %f32_id %809
        %850 = OpBitcast %f32_id %825
        %851 = OpFAdd %f32_id %849 %850
        %852 = OpBitcast %f32_id %802
        %853 = OpBitcast %f32_id %818
        %854 = OpFAdd %f32_id %852 %853
        %855 = OpBitcast %f32_id %833
        %856 = OpFAdd %f32_id %845 %855
        %857 = OpBitcast %f32_id %842
        %858 = OpFAdd %f32_id %848 %857
        %859 = OpBitcast %f32_id %841
        %860 = OpFAdd %f32_id %851 %859
        %861 = OpBitcast %f32_id %834
        %862 = OpFAdd %f32_id %854 %861
        %863 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %865 = OpIAdd %u32_id %863 %u32_id_16384
        %866 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %865
        %867 = OpLoad %u64_id %866
        %868 = OpBitcast %u32vec2_id %867
        %869 = OpCompositeExtract %u32_id %868 0
        %870 = OpCompositeExtract %u32_id %868 1
        %871 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %873 = OpIAdd %u32_id %871 %u32_id_16392
        %874 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %873
        %875 = OpLoad %u64_id %874
        %876 = OpBitcast %u32vec2_id %875
        %877 = OpCompositeExtract %u32_id %876 0
        %878 = OpCompositeExtract %u32_id %876 1
        %879 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %881 = OpIAdd %u32_id %879 %u32_id_20480
        %882 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %881
        %883 = OpLoad %u64_id %882
        %884 = OpBitcast %u32vec2_id %883
        %885 = OpCompositeExtract %u32_id %884 0
        %886 = OpCompositeExtract %u32_id %884 1
        %887 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %889 = OpIAdd %u32_id %887 %u32_id_20488
        %890 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %889
        %891 = OpLoad %u64_id %890
        %892 = OpBitcast %u32vec2_id %891
        %893 = OpCompositeExtract %u32_id %892 0
        %894 = OpCompositeExtract %u32_id %892 1
        %895 = OpBitcast %f32_id %869
        %896 = OpFAdd %f32_id %856 %895
        %897 = OpBitcast %f32_id %878
        %898 = OpFAdd %f32_id %858 %897
        %899 = OpBitcast %f32_id %877
        %900 = OpFAdd %f32_id %860 %899
        %901 = OpBitcast %f32_id %870
        %902 = OpFAdd %f32_id %862 %901
        %903 = OpBitcast %f32_id %885
        %904 = OpFAdd %f32_id %896 %903
        %905 = OpBitcast %f32_id %894
        %906 = OpFAdd %f32_id %898 %905
        %907 = OpBitcast %f32_id %893
        %908 = OpFAdd %f32_id %900 %907
        %909 = OpBitcast %f32_id %886
        %910 = OpFAdd %f32_id %902 %909
        %911 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %913 = OpIAdd %u32_id %911 %u32_id_24576
        %914 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %913
        %915 = OpLoad %u64_id %914
        %916 = OpBitcast %u32vec2_id %915
        %917 = OpCompositeExtract %u32_id %916 0
        %918 = OpCompositeExtract %u32_id %916 1
        %919 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %921 = OpIAdd %u32_id %919 %u32_id_24584
        %922 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %921
        %923 = OpLoad %u64_id %922
        %924 = OpBitcast %u32vec2_id %923
        %925 = OpCompositeExtract %u32_id %924 0
        %926 = OpCompositeExtract %u32_id %924 1
        %927 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %929 = OpIAdd %u32_id %927 %u32_id_28672
        %930 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %929
        %931 = OpLoad %u64_id %930
        %932 = OpBitcast %u32vec2_id %931
        %933 = OpCompositeExtract %u32_id %932 0
        %934 = OpCompositeExtract %u32_id %932 1
        %935 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %937 = OpIAdd %u32_id %935 %u32_id_28680
        %938 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %937
        %939 = OpLoad %u64_id %938
        %940 = OpBitcast %u32vec2_id %939
        %941 = OpCompositeExtract %u32_id %940 0
        %942 = OpCompositeExtract %u32_id %940 1
        %943 = OpBitcast %f32_id %917
        %944 = OpFAdd %f32_id %904 %943
        %945 = OpBitcast %f32_id %926
        %946 = OpFAdd %f32_id %906 %945
        %947 = OpBitcast %f32_id %925
        %948 = OpFAdd %f32_id %908 %947
        %949 = OpBitcast %f32_id %918
        %950 = OpFAdd %f32_id %910 %949
        %951 = OpBitcast %f32_id %933
        %952 = OpFAdd %f32_id %944 %951
        %953 = OpBitcast %f32_id %942
        %954 = OpFAdd %f32_id %946 %953
        %955 = OpBitcast %f32_id %941
        %956 = OpFAdd %f32_id %948 %955
        %957 = OpBitcast %f32_id %934
        %958 = OpFAdd %f32_id %950 %957
        %959 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %961 = OpIAdd %u32_id %959 %u32_id_32768
        %962 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %961
        %963 = OpLoad %u64_id %962
        %964 = OpBitcast %u32vec2_id %963
        %965 = OpCompositeExtract %u32_id %964 0
        %966 = OpCompositeExtract %u32_id %964 1
        %967 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %969 = OpIAdd %u32_id %967 %u32_id_32776
        %970 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %969
        %971 = OpLoad %u64_id %970
        %972 = OpBitcast %u32vec2_id %971
        %973 = OpCompositeExtract %u32_id %972 0
        %974 = OpCompositeExtract %u32_id %972 1
        %975 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %977 = OpIAdd %u32_id %975 %u32_id_36864
        %978 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %977
        %979 = OpLoad %u64_id %978
        %980 = OpBitcast %u32vec2_id %979
        %981 = OpCompositeExtract %u32_id %980 0
        %982 = OpCompositeExtract %u32_id %980 1
        %983 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %985 = OpIAdd %u32_id %983 %u32_id_36872
        %986 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %985
        %987 = OpLoad %u64_id %986
        %988 = OpBitcast %u32vec2_id %987
        %989 = OpCompositeExtract %u32_id %988 0
        %990 = OpCompositeExtract %u32_id %988 1
        %991 = OpBitcast %f32_id %965
        %992 = OpFAdd %f32_id %952 %991
        %993 = OpBitcast %f32_id %974
        %994 = OpFAdd %f32_id %954 %993
        %995 = OpBitcast %f32_id %973
        %996 = OpFAdd %f32_id %956 %995
        %997 = OpBitcast %f32_id %966
        %998 = OpFAdd %f32_id %958 %997
        %999 = OpBitcast %f32_id %981
       %1000 = OpFAdd %f32_id %992 %999
       %1001 = OpBitcast %f32_id %990
       %1002 = OpFAdd %f32_id %994 %1001
       %1003 = OpBitcast %f32_id %989
       %1004 = OpFAdd %f32_id %996 %1003
       %1005 = OpBitcast %f32_id %982
       %1006 = OpFAdd %f32_id %998 %1005
       %1007 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1009 = OpIAdd %u32_id %1007 %u32_id_40960
       %1010 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1009
       %1011 = OpLoad %u64_id %1010
       %1012 = OpBitcast %u32vec2_id %1011
       %1013 = OpCompositeExtract %u32_id %1012 0
       %1014 = OpCompositeExtract %u32_id %1012 1
       %1015 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1017 = OpIAdd %u32_id %1015 %u32_id_40968
       %1018 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1017
       %1019 = OpLoad %u64_id %1018
       %1020 = OpBitcast %u32vec2_id %1019
       %1021 = OpCompositeExtract %u32_id %1020 0
       %1022 = OpCompositeExtract %u32_id %1020 1
       %1023 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1025 = OpIAdd %u32_id %1023 %u32_id_45056
       %1026 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1025
       %1027 = OpLoad %u64_id %1026
       %1028 = OpBitcast %u32vec2_id %1027
       %1029 = OpCompositeExtract %u32_id %1028 0
       %1030 = OpCompositeExtract %u32_id %1028 1
       %1031 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1033 = OpIAdd %u32_id %1031 %u32_id_45064
       %1034 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1033
       %1035 = OpLoad %u64_id %1034
       %1036 = OpBitcast %u32vec2_id %1035
       %1037 = OpCompositeExtract %u32_id %1036 0
       %1038 = OpCompositeExtract %u32_id %1036 1
       %1039 = OpBitcast %f32_id %1013
       %1040 = OpFAdd %f32_id %1000 %1039
       %1041 = OpBitcast %f32_id %1022
       %1042 = OpFAdd %f32_id %1002 %1041
       %1043 = OpBitcast %f32_id %1021
       %1044 = OpFAdd %f32_id %1004 %1043
       %1045 = OpBitcast %f32_id %1014
       %1046 = OpFAdd %f32_id %1006 %1045
       %1047 = OpBitcast %f32_id %1029
       %1048 = OpFAdd %f32_id %1040 %1047
       %1049 = OpBitcast %f32_id %1038
       %1050 = OpFAdd %f32_id %1042 %1049
       %1051 = OpBitcast %f32_id %1037
       %1052 = OpFAdd %f32_id %1044 %1051
       %1053 = OpBitcast %f32_id %1030
       %1054 = OpFAdd %f32_id %1046 %1053
       %1055 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1057 = OpIAdd %u32_id %1055 %u32_id_49152
       %1058 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1057
       %1059 = OpLoad %u64_id %1058
       %1060 = OpBitcast %u32vec2_id %1059
       %1061 = OpCompositeExtract %u32_id %1060 0
       %1062 = OpCompositeExtract %u32_id %1060 1
       %1063 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1065 = OpIAdd %u32_id %1063 %u32_id_49160
       %1066 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1065
       %1067 = OpLoad %u64_id %1066
       %1068 = OpBitcast %u32vec2_id %1067
       %1069 = OpCompositeExtract %u32_id %1068 0
       %1070 = OpCompositeExtract %u32_id %1068 1
       %1071 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1073 = OpIAdd %u32_id %1071 %u32_id_53248
       %1074 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1073
       %1075 = OpLoad %u64_id %1074
       %1076 = OpBitcast %u32vec2_id %1075
       %1077 = OpCompositeExtract %u32_id %1076 0
       %1078 = OpCompositeExtract %u32_id %1076 1
       %1079 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1081 = OpIAdd %u32_id %1079 %u32_id_53256
       %1082 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1081
       %1083 = OpLoad %u64_id %1082
       %1084 = OpBitcast %u32vec2_id %1083
       %1085 = OpCompositeExtract %u32_id %1084 0
       %1086 = OpCompositeExtract %u32_id %1084 1
       %1087 = OpBitcast %f32_id %1061
       %1088 = OpFAdd %f32_id %1048 %1087
       %1089 = OpBitcast %f32_id %1070
       %1090 = OpFAdd %f32_id %1050 %1089
       %1091 = OpBitcast %f32_id %1069
       %1092 = OpFAdd %f32_id %1052 %1091
       %1093 = OpBitcast %f32_id %1062
       %1094 = OpFAdd %f32_id %1054 %1093
       %1095 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1097 = OpIAdd %u32_id %1095 %u32_id_57344
       %1098 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1097
       %1099 = OpLoad %u64_id %1098
       %1100 = OpBitcast %u32vec2_id %1099
       %1101 = OpCompositeExtract %u32_id %1100 0
       %1102 = OpCompositeExtract %u32_id %1100 1
       %1103 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1105 = OpIAdd %u32_id %1103 %u32_id_57352
       %1106 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1105
       %1107 = OpLoad %u64_id %1106
       %1108 = OpBitcast %u32vec2_id %1107
       %1109 = OpCompositeExtract %u32_id %1108 0
       %1110 = OpCompositeExtract %u32_id %1108 1
       %1111 = OpBitcast %f32_id %1077
       %1112 = OpFAdd %f32_id %1088 %1111
       %1113 = OpBitcast %f32_id %1085
       %1114 = OpFAdd %f32_id %1092 %1113
       %1115 = OpBitcast %f32_id %1086
       %1116 = OpFAdd %f32_id %1090 %1115
       %1117 = OpBitcast %f32_id %1109
       %1118 = OpFAdd %f32_id %1114 %1117
       %1119 = OpBitcast %f32_id %1101
       %1120 = OpFAdd %f32_id %1112 %1119
       %1121 = OpBitcast %f32_id %1078
       %1122 = OpFAdd %f32_id %1094 %1121
       %1123 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1125 = OpIAdd %u32_id %1123 %u32_id_61440
       %1126 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1125
       %1127 = OpLoad %u64_id %1126
       %1128 = OpBitcast %u32vec2_id %1127
       %1129 = OpCompositeExtract %u32_id %1128 0
       %1130 = OpCompositeExtract %u32_id %1128 1
       %1131 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1133 = OpIAdd %u32_id %1131 %u32_id_61448
       %1134 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1133
       %1135 = OpLoad %u64_id %1134
       %1136 = OpBitcast %u32vec2_id %1135
       %1137 = OpCompositeExtract %u32_id %1136 0
       %1138 = OpCompositeExtract %u32_id %1136 1
       %1139 = OpBitcast %f32_id %1102
       %1140 = OpFAdd %f32_id %1122 %1139
       %1141 = OpBitcast %f32_id %1110
       %1142 = OpFAdd %f32_id %1116 %1141
       %1143 = OpBitcast %f32_id %1129
       %1144 = OpFAdd %f32_id %1120 %1143
       %1145 = OpBitcast %f32_id %1138
       %1146 = OpFAdd %f32_id %1142 %1145
       %1147 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1149 = OpIAdd %u32_id %1147 %u32_id_4112
       %1150 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1149
       %1151 = OpLoad %u64_id %1150
       %1152 = OpBitcast %u32vec2_id %1151
       %1153 = OpCompositeExtract %u32_id %1152 0
       %1154 = OpCompositeExtract %u32_id %1152 1
       %1155 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1157 = OpIAdd %u32_id %1155 %u32_id_4120
       %1158 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1157
       %1159 = OpLoad %u64_id %1158
       %1160 = OpBitcast %u32vec2_id %1159
       %1161 = OpCompositeExtract %u32_id %1160 0
       %1162 = OpCompositeExtract %u32_id %1160 1
       %1163 = OpBitcast %f32_id %1130
       %1164 = OpFAdd %f32_id %1140 %1163
       %1165 = OpBitcast %f32_id %1137
       %1166 = OpFAdd %f32_id %1118 %1165
       %1167 = OpFAdd %f32_id %1144 %738
       %1168 = OpFAdd %f32_id %1146 %726
       %1169 = OpFAdd %f32_id %1166 %730
       %1170 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1172 = OpIAdd %u32_id %1170 %u32_id_8208
       %1173 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1172
       %1174 = OpLoad %u64_id %1173
       %1175 = OpBitcast %u32vec2_id %1174
       %1176 = OpCompositeExtract %u32_id %1175 0
       %1177 = OpCompositeExtract %u32_id %1175 1
       %1178 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1180 = OpIAdd %u32_id %1178 %u32_id_8216
       %1181 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1180
       %1182 = OpLoad %u64_id %1181
       %1183 = OpBitcast %u32vec2_id %1182
       %1184 = OpCompositeExtract %u32_id %1183 0
       %1185 = OpCompositeExtract %u32_id %1183 1
       %1186 = OpFAdd %f32_id %1164 %734
       %1187 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1189 = OpIAdd %u32_id %1187 %u32_id_12304
       %1190 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1189
       %1191 = OpLoad %u64_id %1190
       %1192 = OpBitcast %u32vec2_id %1191
       %1193 = OpCompositeExtract %u32_id %1192 0
       %1194 = OpCompositeExtract %u32_id %1192 1
       %1195 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1197 = OpIAdd %u32_id %1195 %u32_id_12312
       %1198 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1197
       %1199 = OpLoad %u64_id %1198
       %1200 = OpBitcast %u32vec2_id %1199
       %1201 = OpCompositeExtract %u32_id %1200 0
       %1202 = OpCompositeExtract %u32_id %1200 1
       %1203 = OpBitcast %f32_id %1153
       %1204 = OpBitcast %f32_id %1176
       %1205 = OpFAdd %f32_id %1203 %1204
       %1206 = OpBitcast %f32_id %1162
       %1207 = OpBitcast %f32_id %1185
       %1208 = OpFAdd %f32_id %1206 %1207
       %1209 = OpBitcast %f32_id %1161
       %1210 = OpBitcast %f32_id %1184
       %1211 = OpFAdd %f32_id %1209 %1210
       %1212 = OpBitcast %f32_id %1154
       %1213 = OpBitcast %f32_id %1177
       %1214 = OpFAdd %f32_id %1212 %1213
       %1215 = OpBitcast %f32_id %1193
       %1216 = OpFAdd %f32_id %1205 %1215
       %1217 = OpBitcast %f32_id %1202
       %1218 = OpFAdd %f32_id %1208 %1217
       %1219 = OpBitcast %f32_id %1201
       %1220 = OpFAdd %f32_id %1211 %1219
       %1221 = OpBitcast %f32_id %1194
       %1222 = OpFAdd %f32_id %1214 %1221
       %1223 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1225 = OpIAdd %u32_id %1223 %u32_id_16400
       %1226 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1225
       %1227 = OpLoad %u64_id %1226
       %1228 = OpBitcast %u32vec2_id %1227
       %1229 = OpCompositeExtract %u32_id %1228 0
       %1230 = OpCompositeExtract %u32_id %1228 1
       %1231 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1233 = OpIAdd %u32_id %1231 %u32_id_16408
       %1234 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1233
       %1235 = OpLoad %u64_id %1234
       %1236 = OpBitcast %u32vec2_id %1235
       %1237 = OpCompositeExtract %u32_id %1236 0
       %1238 = OpCompositeExtract %u32_id %1236 1
       %1239 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1241 = OpIAdd %u32_id %1239 %u32_id_20496
       %1242 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1241
       %1243 = OpLoad %u64_id %1242
       %1244 = OpBitcast %u32vec2_id %1243
       %1245 = OpCompositeExtract %u32_id %1244 0
       %1246 = OpCompositeExtract %u32_id %1244 1
       %1247 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1249 = OpIAdd %u32_id %1247 %u32_id_20504
       %1250 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1249
       %1251 = OpLoad %u64_id %1250
       %1252 = OpBitcast %u32vec2_id %1251
       %1253 = OpCompositeExtract %u32_id %1252 0
       %1254 = OpCompositeExtract %u32_id %1252 1
       %1255 = OpBitcast %f32_id %1229
       %1256 = OpFAdd %f32_id %1216 %1255
       %1257 = OpBitcast %f32_id %1238
       %1258 = OpFAdd %f32_id %1218 %1257
       %1259 = OpBitcast %f32_id %1237
       %1260 = OpFAdd %f32_id %1220 %1259
       %1261 = OpBitcast %f32_id %1230
       %1262 = OpFAdd %f32_id %1222 %1261
       %1263 = OpBitcast %f32_id %1245
       %1264 = OpFAdd %f32_id %1256 %1263
       %1265 = OpBitcast %f32_id %1254
       %1266 = OpFAdd %f32_id %1258 %1265
       %1267 = OpBitcast %f32_id %1253
       %1268 = OpFAdd %f32_id %1260 %1267
       %1269 = OpBitcast %f32_id %1246
       %1270 = OpFAdd %f32_id %1262 %1269
       %1271 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1273 = OpIAdd %u32_id %1271 %u32_id_24592
       %1274 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1273
       %1275 = OpLoad %u64_id %1274
       %1276 = OpBitcast %u32vec2_id %1275
       %1277 = OpCompositeExtract %u32_id %1276 0
       %1278 = OpCompositeExtract %u32_id %1276 1
       %1279 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1281 = OpIAdd %u32_id %1279 %u32_id_24600
       %1282 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1281
       %1283 = OpLoad %u64_id %1282
       %1284 = OpBitcast %u32vec2_id %1283
       %1285 = OpCompositeExtract %u32_id %1284 0
       %1286 = OpCompositeExtract %u32_id %1284 1
       %1287 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1289 = OpIAdd %u32_id %1287 %u32_id_28688
       %1290 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1289
       %1291 = OpLoad %u64_id %1290
       %1292 = OpBitcast %u32vec2_id %1291
       %1293 = OpCompositeExtract %u32_id %1292 0
       %1294 = OpCompositeExtract %u32_id %1292 1
       %1295 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1297 = OpIAdd %u32_id %1295 %u32_id_28696
       %1298 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1297
       %1299 = OpLoad %u64_id %1298
       %1300 = OpBitcast %u32vec2_id %1299
       %1301 = OpCompositeExtract %u32_id %1300 0
       %1302 = OpCompositeExtract %u32_id %1300 1
       %1303 = OpBitcast %f32_id %1277
       %1304 = OpFAdd %f32_id %1264 %1303
       %1305 = OpBitcast %f32_id %1286
       %1306 = OpFAdd %f32_id %1266 %1305
       %1307 = OpBitcast %f32_id %1285
       %1308 = OpFAdd %f32_id %1268 %1307
       %1309 = OpBitcast %f32_id %1278
       %1310 = OpFAdd %f32_id %1270 %1309
       %1311 = OpBitcast %f32_id %1293
       %1312 = OpFAdd %f32_id %1304 %1311
       %1313 = OpBitcast %f32_id %1302
       %1314 = OpFAdd %f32_id %1306 %1313
       %1315 = OpBitcast %f32_id %1301
       %1316 = OpFAdd %f32_id %1308 %1315
       %1317 = OpBitcast %f32_id %1294
       %1318 = OpFAdd %f32_id %1310 %1317
       %1319 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1321 = OpIAdd %u32_id %1319 %u32_id_32784
       %1322 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1321
       %1323 = OpLoad %u64_id %1322
       %1324 = OpBitcast %u32vec2_id %1323
       %1325 = OpCompositeExtract %u32_id %1324 0
       %1326 = OpCompositeExtract %u32_id %1324 1
       %1327 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1329 = OpIAdd %u32_id %1327 %u32_id_32792
       %1330 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1329
       %1331 = OpLoad %u64_id %1330
       %1332 = OpBitcast %u32vec2_id %1331
       %1333 = OpCompositeExtract %u32_id %1332 0
       %1334 = OpCompositeExtract %u32_id %1332 1
       %1335 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1337 = OpIAdd %u32_id %1335 %u32_id_36880
       %1338 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1337
       %1339 = OpLoad %u64_id %1338
       %1340 = OpBitcast %u32vec2_id %1339
       %1341 = OpCompositeExtract %u32_id %1340 0
       %1342 = OpCompositeExtract %u32_id %1340 1
       %1343 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1345 = OpIAdd %u32_id %1343 %u32_id_36888
       %1346 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1345
       %1347 = OpLoad %u64_id %1346
       %1348 = OpBitcast %u32vec2_id %1347
       %1349 = OpCompositeExtract %u32_id %1348 0
       %1350 = OpCompositeExtract %u32_id %1348 1
       %1351 = OpBitcast %f32_id %1325
       %1352 = OpFAdd %f32_id %1312 %1351
       %1353 = OpBitcast %f32_id %1334
       %1354 = OpFAdd %f32_id %1314 %1353
       %1355 = OpBitcast %f32_id %1333
       %1356 = OpFAdd %f32_id %1316 %1355
       %1357 = OpBitcast %f32_id %1326
       %1358 = OpFAdd %f32_id %1318 %1357
       %1359 = OpBitcast %f32_id %1341
       %1360 = OpFAdd %f32_id %1352 %1359
       %1361 = OpBitcast %f32_id %1350
       %1362 = OpFAdd %f32_id %1354 %1361
       %1363 = OpBitcast %f32_id %1349
       %1364 = OpFAdd %f32_id %1356 %1363
       %1365 = OpBitcast %f32_id %1342
       %1366 = OpFAdd %f32_id %1358 %1365
       %1367 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1369 = OpIAdd %u32_id %1367 %u32_id_40976
       %1370 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1369
       %1371 = OpLoad %u64_id %1370
       %1372 = OpBitcast %u32vec2_id %1371
       %1373 = OpCompositeExtract %u32_id %1372 0
       %1374 = OpCompositeExtract %u32_id %1372 1
       %1375 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1377 = OpIAdd %u32_id %1375 %u32_id_40984
       %1378 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1377
       %1379 = OpLoad %u64_id %1378
       %1380 = OpBitcast %u32vec2_id %1379
       %1381 = OpCompositeExtract %u32_id %1380 0
       %1382 = OpCompositeExtract %u32_id %1380 1
       %1383 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1385 = OpIAdd %u32_id %1383 %u32_id_45072
       %1386 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1385
       %1387 = OpLoad %u64_id %1386
       %1388 = OpBitcast %u32vec2_id %1387
       %1389 = OpCompositeExtract %u32_id %1388 0
       %1390 = OpCompositeExtract %u32_id %1388 1
       %1391 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1393 = OpIAdd %u32_id %1391 %u32_id_45080
       %1394 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1393
       %1395 = OpLoad %u64_id %1394
       %1396 = OpBitcast %u32vec2_id %1395
       %1397 = OpCompositeExtract %u32_id %1396 0
       %1398 = OpCompositeExtract %u32_id %1396 1
       %1399 = OpBitcast %f32_id %1373
       %1400 = OpFAdd %f32_id %1360 %1399
       %1401 = OpBitcast %f32_id %1382
       %1402 = OpFAdd %f32_id %1362 %1401
       %1403 = OpBitcast %f32_id %1381
       %1404 = OpFAdd %f32_id %1364 %1403
       %1405 = OpBitcast %f32_id %1374
       %1406 = OpFAdd %f32_id %1366 %1405
       %1407 = OpBitcast %f32_id %1389
       %1408 = OpFAdd %f32_id %1400 %1407
       %1409 = OpBitcast %f32_id %1398
       %1410 = OpFAdd %f32_id %1402 %1409
       %1411 = OpBitcast %f32_id %1397
       %1412 = OpFAdd %f32_id %1404 %1411
       %1413 = OpBitcast %f32_id %1390
       %1414 = OpFAdd %f32_id %1406 %1413
       %1415 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1417 = OpIAdd %u32_id %1415 %u32_id_49168
       %1418 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1417
       %1419 = OpLoad %u64_id %1418
       %1420 = OpBitcast %u32vec2_id %1419
       %1421 = OpCompositeExtract %u32_id %1420 0
       %1422 = OpCompositeExtract %u32_id %1420 1
       %1423 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1425 = OpIAdd %u32_id %1423 %u32_id_49176
       %1426 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1425
       %1427 = OpLoad %u64_id %1426
       %1428 = OpBitcast %u32vec2_id %1427
       %1429 = OpCompositeExtract %u32_id %1428 0
       %1430 = OpCompositeExtract %u32_id %1428 1
       %1431 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1433 = OpIAdd %u32_id %1431 %u32_id_53264
       %1434 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1433
       %1435 = OpLoad %u64_id %1434
       %1436 = OpBitcast %u32vec2_id %1435
       %1437 = OpCompositeExtract %u32_id %1436 0
       %1438 = OpCompositeExtract %u32_id %1436 1
       %1439 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1441 = OpIAdd %u32_id %1439 %u32_id_53272
       %1442 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1441
       %1443 = OpLoad %u64_id %1442
       %1444 = OpBitcast %u32vec2_id %1443
       %1445 = OpCompositeExtract %u32_id %1444 0
       %1446 = OpCompositeExtract %u32_id %1444 1
       %1447 = OpBitcast %f32_id %1421
       %1448 = OpFAdd %f32_id %1408 %1447
       %1449 = OpBitcast %f32_id %1430
       %1450 = OpFAdd %f32_id %1410 %1449
       %1451 = OpBitcast %f32_id %1429
       %1452 = OpFAdd %f32_id %1412 %1451
       %1453 = OpBitcast %f32_id %1422
       %1454 = OpFAdd %f32_id %1414 %1453
       %1455 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1457 = OpIAdd %u32_id %1455 %u32_id_57360
       %1458 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1457
       %1459 = OpLoad %u64_id %1458
       %1460 = OpBitcast %u32vec2_id %1459
       %1461 = OpCompositeExtract %u32_id %1460 0
       %1462 = OpCompositeExtract %u32_id %1460 1
       %1463 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1465 = OpIAdd %u32_id %1463 %u32_id_57368
       %1466 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1465
       %1467 = OpLoad %u64_id %1466
       %1468 = OpBitcast %u32vec2_id %1467
       %1469 = OpCompositeExtract %u32_id %1468 0
       %1470 = OpCompositeExtract %u32_id %1468 1
       %1471 = OpBitcast %f32_id %1437
       %1472 = OpFAdd %f32_id %1448 %1471
       %1473 = OpBitcast %f32_id %1445
       %1474 = OpFAdd %f32_id %1452 %1473
       %1475 = OpBitcast %f32_id %1446
       %1476 = OpFAdd %f32_id %1450 %1475
       %1477 = OpBitcast %f32_id %1469
       %1478 = OpFAdd %f32_id %1474 %1477
       %1479 = OpBitcast %f32_id %1461
       %1480 = OpFAdd %f32_id %1472 %1479
       %1481 = OpBitcast %f32_id %1438
       %1482 = OpFAdd %f32_id %1454 %1481
       %1483 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1485 = OpIAdd %u32_id %1483 %u32_id_61456
       %1486 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1485
       %1487 = OpLoad %u64_id %1486
       %1488 = OpBitcast %u32vec2_id %1487
       %1489 = OpCompositeExtract %u32_id %1488 0
       %1490 = OpCompositeExtract %u32_id %1488 1
       %1491 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1493 = OpIAdd %u32_id %1491 %u32_id_61464
       %1494 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1493
       %1495 = OpLoad %u64_id %1494
       %1496 = OpBitcast %u32vec2_id %1495
       %1497 = OpCompositeExtract %u32_id %1496 0
       %1498 = OpCompositeExtract %u32_id %1496 1
       %1499 = OpBitcast %f32_id %1462
       %1500 = OpFAdd %f32_id %1482 %1499
       %1501 = OpBitcast %f32_id %1470
       %1502 = OpFAdd %f32_id %1476 %1501
       %1503 = OpBitcast %f32_id %1489
       %1504 = OpFAdd %f32_id %1480 %1503
       %1505 = OpBitcast %f32_id %1498
       %1506 = OpFAdd %f32_id %1502 %1505
       %1507 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1509 = OpIAdd %u32_id %1507 %u32_id_4128
       %1510 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1509
       %1511 = OpLoad %u64_id %1510
       %1512 = OpBitcast %u32vec2_id %1511
       %1513 = OpCompositeExtract %u32_id %1512 0
       %1514 = OpCompositeExtract %u32_id %1512 1
       %1515 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1517 = OpIAdd %u32_id %1515 %u32_id_4136
       %1518 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1517
       %1519 = OpLoad %u64_id %1518
       %1520 = OpBitcast %u32vec2_id %1519
       %1521 = OpCompositeExtract %u32_id %1520 0
       %1522 = OpCompositeExtract %u32_id %1520 1
       %1523 = OpBitcast %f32_id %1490
       %1524 = OpFAdd %f32_id %1500 %1523
       %1525 = OpBitcast %f32_id %1497
       %1526 = OpFAdd %f32_id %1478 %1525
       %1527 = OpFAdd %f32_id %1504 %722
       %1528 = OpFAdd %f32_id %1506 %710
       %1529 = OpFAdd %f32_id %1526 %714
       %1530 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1532 = OpIAdd %u32_id %1530 %u32_id_8224
       %1533 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1532
       %1534 = OpLoad %u64_id %1533
       %1535 = OpBitcast %u32vec2_id %1534
       %1536 = OpCompositeExtract %u32_id %1535 0
       %1537 = OpCompositeExtract %u32_id %1535 1
       %1538 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1540 = OpIAdd %u32_id %1538 %u32_id_8232
       %1541 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1540
       %1542 = OpLoad %u64_id %1541
       %1543 = OpBitcast %u32vec2_id %1542
       %1544 = OpCompositeExtract %u32_id %1543 0
       %1545 = OpCompositeExtract %u32_id %1543 1
       %1547 = OpIAdd %u32_id %u32_id_74 %buf0_dword_off
       %1548 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %1547
       %1549 = OpLoad %u32_id %1548
       %1550 = OpFAdd %f32_id %1524 %718
       %1551 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1553 = OpIAdd %u32_id %1551 %u32_id_12320
       %1554 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1553
       %1555 = OpLoad %u64_id %1554
       %1556 = OpBitcast %u32vec2_id %1555
       %1557 = OpCompositeExtract %u32_id %1556 0
       %1558 = OpCompositeExtract %u32_id %1556 1
       %1559 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1561 = OpIAdd %u32_id %1559 %u32_id_12328
       %1562 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1561
       %1563 = OpLoad %u64_id %1562
       %1564 = OpBitcast %u32vec2_id %1563
       %1565 = OpCompositeExtract %u32_id %1564 0
       %1566 = OpCompositeExtract %u32_id %1564 1
       %1567 = OpBitcast %f32_id %1513
       %1568 = OpBitcast %f32_id %1536
       %1569 = OpFAdd %f32_id %1567 %1568
       %1570 = OpBitcast %f32_id %1522
       %1571 = OpBitcast %f32_id %1545
       %1572 = OpFAdd %f32_id %1570 %1571
       %1573 = OpBitcast %f32_id %1521
       %1574 = OpBitcast %f32_id %1544
       %1575 = OpFAdd %f32_id %1573 %1574
       %1576 = OpBitcast %f32_id %1514
       %1577 = OpBitcast %f32_id %1537
       %1578 = OpFAdd %f32_id %1576 %1577
       %1579 = OpBitcast %f32_id %1557
       %1580 = OpFAdd %f32_id %1569 %1579
       %1581 = OpBitcast %f32_id %1566
       %1582 = OpFAdd %f32_id %1572 %1581
       %1583 = OpBitcast %f32_id %1565
       %1584 = OpFAdd %f32_id %1575 %1583
       %1585 = OpBitcast %f32_id %1558
       %1586 = OpFAdd %f32_id %1578 %1585
       %1587 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1589 = OpIAdd %u32_id %1587 %u32_id_16416
       %1590 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1589
       %1591 = OpLoad %u64_id %1590
       %1592 = OpBitcast %u32vec2_id %1591
       %1593 = OpCompositeExtract %u32_id %1592 0
       %1594 = OpCompositeExtract %u32_id %1592 1
       %1595 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1597 = OpIAdd %u32_id %1595 %u32_id_16424
       %1598 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1597
       %1599 = OpLoad %u64_id %1598
       %1600 = OpBitcast %u32vec2_id %1599
       %1601 = OpCompositeExtract %u32_id %1600 0
       %1602 = OpCompositeExtract %u32_id %1600 1
       %1603 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1605 = OpIAdd %u32_id %1603 %u32_id_20512
       %1606 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1605
       %1607 = OpLoad %u64_id %1606
       %1608 = OpBitcast %u32vec2_id %1607
       %1609 = OpCompositeExtract %u32_id %1608 0
       %1610 = OpCompositeExtract %u32_id %1608 1
       %1611 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1613 = OpIAdd %u32_id %1611 %u32_id_20520
       %1614 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1613
       %1615 = OpLoad %u64_id %1614
       %1616 = OpBitcast %u32vec2_id %1615
       %1617 = OpCompositeExtract %u32_id %1616 0
       %1618 = OpCompositeExtract %u32_id %1616 1
       %1619 = OpBitcast %f32_id %1593
       %1620 = OpFAdd %f32_id %1580 %1619
       %1621 = OpBitcast %f32_id %1602
       %1622 = OpFAdd %f32_id %1582 %1621
       %1623 = OpBitcast %f32_id %1601
       %1624 = OpFAdd %f32_id %1584 %1623
       %1625 = OpBitcast %f32_id %1594
       %1626 = OpFAdd %f32_id %1586 %1625
       %1627 = OpBitcast %f32_id %1609
       %1628 = OpFAdd %f32_id %1620 %1627
       %1629 = OpBitcast %f32_id %1618
       %1630 = OpFAdd %f32_id %1622 %1629
       %1631 = OpBitcast %f32_id %1617
       %1632 = OpFAdd %f32_id %1624 %1631
       %1633 = OpBitcast %f32_id %1610
       %1634 = OpFAdd %f32_id %1626 %1633
       %1635 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1637 = OpIAdd %u32_id %1635 %u32_id_24608
       %1638 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1637
       %1639 = OpLoad %u64_id %1638
       %1640 = OpBitcast %u32vec2_id %1639
       %1641 = OpCompositeExtract %u32_id %1640 0
       %1642 = OpCompositeExtract %u32_id %1640 1
       %1643 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1645 = OpIAdd %u32_id %1643 %u32_id_24616
       %1646 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1645
       %1647 = OpLoad %u64_id %1646
       %1648 = OpBitcast %u32vec2_id %1647
       %1649 = OpCompositeExtract %u32_id %1648 0
       %1650 = OpCompositeExtract %u32_id %1648 1
       %1651 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1653 = OpIAdd %u32_id %1651 %u32_id_28704
       %1654 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1653
       %1655 = OpLoad %u64_id %1654
       %1656 = OpBitcast %u32vec2_id %1655
       %1657 = OpCompositeExtract %u32_id %1656 0
       %1658 = OpCompositeExtract %u32_id %1656 1
       %1659 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1661 = OpIAdd %u32_id %1659 %u32_id_28712
       %1662 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1661
       %1663 = OpLoad %u64_id %1662
       %1664 = OpBitcast %u32vec2_id %1663
       %1665 = OpCompositeExtract %u32_id %1664 0
       %1666 = OpCompositeExtract %u32_id %1664 1
       %1667 = OpBitcast %f32_id %1641
       %1668 = OpFAdd %f32_id %1628 %1667
       %1669 = OpBitcast %f32_id %1650
       %1670 = OpFAdd %f32_id %1630 %1669
       %1671 = OpBitcast %f32_id %1649
       %1672 = OpFAdd %f32_id %1632 %1671
       %1673 = OpBitcast %f32_id %1642
       %1674 = OpFAdd %f32_id %1634 %1673
       %1675 = OpBitcast %f32_id %1657
       %1676 = OpFAdd %f32_id %1668 %1675
       %1677 = OpBitcast %f32_id %1666
       %1678 = OpFAdd %f32_id %1670 %1677
       %1679 = OpBitcast %f32_id %1665
       %1680 = OpFAdd %f32_id %1672 %1679
       %1681 = OpBitcast %f32_id %1658
       %1682 = OpFAdd %f32_id %1674 %1681
       %1683 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1685 = OpIAdd %u32_id %1683 %u32_id_32800
       %1686 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1685
       %1687 = OpLoad %u64_id %1686
       %1688 = OpBitcast %u32vec2_id %1687
       %1689 = OpCompositeExtract %u32_id %1688 0
       %1690 = OpCompositeExtract %u32_id %1688 1
       %1691 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1693 = OpIAdd %u32_id %1691 %u32_id_32808
       %1694 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1693
       %1695 = OpLoad %u64_id %1694
       %1696 = OpBitcast %u32vec2_id %1695
       %1697 = OpCompositeExtract %u32_id %1696 0
       %1698 = OpCompositeExtract %u32_id %1696 1
       %1699 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1701 = OpIAdd %u32_id %1699 %u32_id_36896
       %1702 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1701
       %1703 = OpLoad %u64_id %1702
       %1704 = OpBitcast %u32vec2_id %1703
       %1705 = OpCompositeExtract %u32_id %1704 0
       %1706 = OpCompositeExtract %u32_id %1704 1
       %1707 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1709 = OpIAdd %u32_id %1707 %u32_id_36904
       %1710 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1709
       %1711 = OpLoad %u64_id %1710
       %1712 = OpBitcast %u32vec2_id %1711
       %1713 = OpCompositeExtract %u32_id %1712 0
       %1714 = OpCompositeExtract %u32_id %1712 1
       %1715 = OpBitcast %f32_id %1689
       %1716 = OpFAdd %f32_id %1676 %1715
       %1717 = OpBitcast %f32_id %1698
       %1718 = OpFAdd %f32_id %1678 %1717
       %1719 = OpBitcast %f32_id %1697
       %1720 = OpFAdd %f32_id %1680 %1719
       %1721 = OpBitcast %f32_id %1690
       %1722 = OpFAdd %f32_id %1682 %1721
       %1723 = OpBitcast %f32_id %1705
       %1724 = OpFAdd %f32_id %1716 %1723
       %1725 = OpBitcast %f32_id %1714
       %1726 = OpFAdd %f32_id %1718 %1725
       %1727 = OpBitcast %f32_id %1713
       %1728 = OpFAdd %f32_id %1720 %1727
       %1729 = OpBitcast %f32_id %1706
       %1730 = OpFAdd %f32_id %1722 %1729
       %1731 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1733 = OpIAdd %u32_id %1731 %u32_id_40992
       %1734 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1733
       %1735 = OpLoad %u64_id %1734
       %1736 = OpBitcast %u32vec2_id %1735
       %1737 = OpCompositeExtract %u32_id %1736 0
       %1738 = OpCompositeExtract %u32_id %1736 1
       %1739 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1741 = OpIAdd %u32_id %1739 %u32_id_41000
       %1742 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1741
       %1743 = OpLoad %u64_id %1742
       %1744 = OpBitcast %u32vec2_id %1743
       %1745 = OpCompositeExtract %u32_id %1744 0
       %1746 = OpCompositeExtract %u32_id %1744 1
       %1747 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1749 = OpIAdd %u32_id %1747 %u32_id_45088
       %1750 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1749
       %1751 = OpLoad %u64_id %1750
       %1752 = OpBitcast %u32vec2_id %1751
       %1753 = OpCompositeExtract %u32_id %1752 0
       %1754 = OpCompositeExtract %u32_id %1752 1
       %1755 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1757 = OpIAdd %u32_id %1755 %u32_id_45096
       %1758 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1757
       %1759 = OpLoad %u64_id %1758
       %1760 = OpBitcast %u32vec2_id %1759
       %1761 = OpCompositeExtract %u32_id %1760 0
       %1762 = OpCompositeExtract %u32_id %1760 1
       %1763 = OpBitcast %f32_id %1737
       %1764 = OpFAdd %f32_id %1724 %1763
       %1765 = OpBitcast %f32_id %1746
       %1766 = OpFAdd %f32_id %1726 %1765
       %1767 = OpBitcast %f32_id %1745
       %1768 = OpFAdd %f32_id %1728 %1767
       %1769 = OpBitcast %f32_id %1738
       %1770 = OpFAdd %f32_id %1730 %1769
       %1771 = OpBitcast %f32_id %1762
       %1772 = OpFAdd %f32_id %1766 %1771
       %1773 = OpBitcast %f32_id %1761
       %1774 = OpFAdd %f32_id %1768 %1773
       %1775 = OpBitcast %f32_id %1754
       %1776 = OpFAdd %f32_id %1770 %1775
       %1777 = OpBitcast %f32_id %1753
       %1778 = OpFAdd %f32_id %1764 %1777
       %1779 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1781 = OpIAdd %u32_id %1779 %u32_id_49184
       %1782 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1781
       %1783 = OpLoad %u64_id %1782
       %1784 = OpBitcast %u32vec2_id %1783
       %1785 = OpCompositeExtract %u32_id %1784 0
       %1786 = OpCompositeExtract %u32_id %1784 1
       %1787 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1789 = OpIAdd %u32_id %1787 %u32_id_49192
       %1790 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1789
       %1791 = OpLoad %u64_id %1790
       %1792 = OpBitcast %u32vec2_id %1791
       %1793 = OpCompositeExtract %u32_id %1792 0
       %1794 = OpCompositeExtract %u32_id %1792 1
       %1795 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1797 = OpIAdd %u32_id %1795 %u32_id_53280
       %1798 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1797
       %1799 = OpLoad %u64_id %1798
       %1800 = OpBitcast %u32vec2_id %1799
       %1801 = OpCompositeExtract %u32_id %1800 0
       %1802 = OpCompositeExtract %u32_id %1800 1
       %1803 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1805 = OpIAdd %u32_id %1803 %u32_id_53288
       %1806 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1805
       %1807 = OpLoad %u64_id %1806
       %1808 = OpBitcast %u32vec2_id %1807
       %1809 = OpCompositeExtract %u32_id %1808 0
       %1810 = OpCompositeExtract %u32_id %1808 1
       %1811 = OpBitcast %f32_id %1793
       %1812 = OpFAdd %f32_id %1774 %1811
       %1813 = OpBitcast %f32_id %1786
       %1814 = OpFAdd %f32_id %1776 %1813
       %1815 = OpBitcast %f32_id %1785
       %1816 = OpFAdd %f32_id %1778 %1815
       %1817 = OpBitcast %f32_id %1794
       %1818 = OpFAdd %f32_id %1772 %1817
       %1819 = OpBitcast %f32_id %1801
       %1820 = OpFAdd %f32_id %1816 %1819
       %1821 = OpBitcast %f32_id %1810
       %1822 = OpFAdd %f32_id %1818 %1821
       %1823 = OpBitcast %f32_id %1809
       %1824 = OpFAdd %f32_id %1812 %1823
       %1825 = OpBitcast %f32_id %1802
       %1826 = OpFAdd %f32_id %1814 %1825
       %1827 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1829 = OpIAdd %u32_id %1827 %u32_id_57376
       %1830 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1829
       %1831 = OpLoad %u64_id %1830
       %1832 = OpBitcast %u32vec2_id %1831
       %1833 = OpCompositeExtract %u32_id %1832 0
       %1834 = OpCompositeExtract %u32_id %1832 1
       %1835 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1837 = OpIAdd %u32_id %1835 %u32_id_57384
       %1838 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1837
       %1839 = OpLoad %u64_id %1838
       %1840 = OpBitcast %u32vec2_id %1839
       %1841 = OpCompositeExtract %u32_id %1840 0
       %1842 = OpCompositeExtract %u32_id %1840 1
       %1843 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1845 = OpIAdd %u32_id %1843 %u32_id_61472
       %1846 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1845
       %1847 = OpLoad %u64_id %1846
       %1848 = OpBitcast %u32vec2_id %1847
       %1849 = OpCompositeExtract %u32_id %1848 0
       %1850 = OpCompositeExtract %u32_id %1848 1
       %1851 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1853 = OpIAdd %u32_id %1851 %u32_id_61480
       %1854 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1853
       %1855 = OpLoad %u64_id %1854
       %1856 = OpBitcast %u32vec2_id %1855
       %1857 = OpCompositeExtract %u32_id %1856 0
       %1858 = OpCompositeExtract %u32_id %1856 1
       %1860 = OpIAdd %u32_id %u32_id_76 %buf0_dword_off
       %1861 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %1860
       %1862 = OpLoad %u32_id %1861
       %1864 = OpIAdd %u32_id %u32_id_77 %buf0_dword_off
       %1865 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %1864
       %1866 = OpLoad %u32_id %1865
       %1868 = OpIAdd %u32_id %u32_id_78 %buf0_dword_off
       %1869 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %1868
       %1870 = OpLoad %u32_id %1869
       %1871 = OpBitcast %f32_id %1833
       %1872 = OpFAdd %f32_id %1820 %1871
       %1873 = OpBitcast %f32_id %1849
       %1874 = OpFAdd %f32_id %1872 %1873
       %1875 = OpBitcast %f32_id %1842
       %1876 = OpFAdd %f32_id %1822 %1875
       %1877 = OpBitcast %f32_id %1858
       %1878 = OpFAdd %f32_id %1876 %1877
       %1879 = OpBitcast %f32_id %1834
       %1880 = OpFAdd %f32_id %1826 %1879
       %1881 = OpBitcast %f32_id %1841
       %1882 = OpFAdd %f32_id %1824 %1881
       %1883 = OpBitcast %f32_id %1850
       %1884 = OpFAdd %f32_id %1880 %1883
       %1885 = OpFAdd %f32_id %1874 %706
       %1886 = OpBitcast %f32_id %1857
       %1887 = OpFAdd %f32_id %1882 %1886
       %1888 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1890 = OpIAdd %u32_id %1888 %u32_id_4144
       %1891 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1890
       %1892 = OpLoad %u64_id %1891
       %1893 = OpBitcast %u32vec2_id %1892
       %1894 = OpCompositeExtract %u32_id %1893 0
       %1895 = OpCompositeExtract %u32_id %1893 1
       %1896 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1898 = OpIAdd %u32_id %1896 %u32_id_4152
       %1899 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1898
       %1900 = OpLoad %u64_id %1899
       %1901 = OpBitcast %u32vec2_id %1900
       %1902 = OpCompositeExtract %u32_id %1901 0
       %1903 = OpCompositeExtract %u32_id %1901 1
       %1904 = OpBitcast %f32_id %1862
       %1905 = OpFMul %f32_id %1904 %1167
       %1906 = OpBitcast %u32_id %1905
       %1907 = OpBitcast %f32_id %1866
       %1908 = OpFMul %f32_id %1907 %1168
       %1909 = OpBitcast %u32_id %1908
       %1910 = OpBitcast %f32_id %1866
       %1911 = OpFMul %f32_id %1910 %1169
       %1912 = OpBitcast %u32_id %1911
       %1913 = OpBitcast %f32_id %1866
       %1914 = OpFMul %f32_id %1913 %1186
       %1915 = OpBitcast %u32_id %1914
       %1916 = OpFAdd %f32_id %1878 %694
       %1917 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1919 = OpIAdd %u32_id %1917 %u32_id_8240
       %1920 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1919
       %1921 = OpLoad %u64_id %1920
       %1922 = OpBitcast %u32vec2_id %1921
       %1923 = OpCompositeExtract %u32_id %1922 0
       %1924 = OpCompositeExtract %u32_id %1922 1
       %1925 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1927 = OpIAdd %u32_id %1925 %u32_id_8248
       %1928 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1927
       %1929 = OpLoad %u64_id %1928
       %1930 = OpBitcast %u32vec2_id %1929
       %1931 = OpCompositeExtract %u32_id %1930 0
       %1932 = OpCompositeExtract %u32_id %1930 1
       %1933 = OpFAdd %f32_id %1887 %698
       %1934 = OpFAdd %f32_id %1884 %702
       %1935 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1937 = OpIAdd %u32_id %1935 %u32_id_12336
       %1938 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1937
       %1939 = OpLoad %u64_id %1938
       %1940 = OpBitcast %u32vec2_id %1939
       %1941 = OpCompositeExtract %u32_id %1940 0
       %1942 = OpCompositeExtract %u32_id %1940 1
       %1943 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1945 = OpIAdd %u32_id %1943 %u32_id_12344
       %1946 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1945
       %1947 = OpLoad %u64_id %1946
       %1948 = OpBitcast %u32vec2_id %1947
       %1949 = OpCompositeExtract %u32_id %1948 0
       %1950 = OpCompositeExtract %u32_id %1948 1
       %1951 = OpBitcast %f32_id %1903
       %1952 = OpBitcast %f32_id %1932
       %1953 = OpFAdd %f32_id %1951 %1952
       %1954 = OpBitcast %f32_id %1894
       %1955 = OpBitcast %f32_id %1923
       %1956 = OpFAdd %f32_id %1954 %1955
       %1957 = OpBitcast %f32_id %1902
       %1958 = OpBitcast %f32_id %1931
       %1959 = OpFAdd %f32_id %1957 %1958
       %1960 = OpBitcast %f32_id %1895
       %1961 = OpBitcast %f32_id %1924
       %1962 = OpFAdd %f32_id %1960 %1961
       %1963 = OpBitcast %f32_id %1950
       %1964 = OpFAdd %f32_id %1953 %1963
       %1965 = OpBitcast %f32_id %1941
       %1966 = OpFAdd %f32_id %1956 %1965
       %1967 = OpBitcast %f32_id %1862
       %1968 = OpFMul %f32_id %1967 %1527
       %1969 = OpBitcast %u32_id %1968
       %1970 = OpBitcast %f32_id %1942
       %1971 = OpFAdd %f32_id %1962 %1970
       %1972 = OpBitcast %f32_id %1866
       %1973 = OpFMul %f32_id %1972 %1528
       %1974 = OpBitcast %u32_id %1973
       %1975 = OpBitcast %f32_id %1862
       %1976 = OpFMul %f32_id %1975 %1885
       %1977 = OpBitcast %u32_id %1976
       %1978 = OpBitcast %f32_id %1949
       %1979 = OpFAdd %f32_id %1959 %1978
       %1980 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1982 = OpIAdd %u32_id %1980 %u32_id_16432
       %1983 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1982
       %1984 = OpLoad %u64_id %1983
       %1985 = OpBitcast %u32vec2_id %1984
       %1986 = OpCompositeExtract %u32_id %1985 0
       %1987 = OpCompositeExtract %u32_id %1985 1
       %1988 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1990 = OpIAdd %u32_id %1988 %u32_id_16440
       %1991 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1990
       %1992 = OpLoad %u64_id %1991
       %1993 = OpBitcast %u32vec2_id %1992
       %1994 = OpCompositeExtract %u32_id %1993 0
       %1995 = OpCompositeExtract %u32_id %1993 1
       %1996 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1998 = OpIAdd %u32_id %1996 %u32_id_20528
       %1999 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1998
       %2000 = OpLoad %u64_id %1999
       %2001 = OpBitcast %u32vec2_id %2000
       %2002 = OpCompositeExtract %u32_id %2001 0
       %2003 = OpCompositeExtract %u32_id %2001 1
       %2004 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2006 = OpIAdd %u32_id %2004 %u32_id_20536
       %2007 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2006
       %2008 = OpLoad %u64_id %2007
       %2009 = OpBitcast %u32vec2_id %2008
       %2010 = OpCompositeExtract %u32_id %2009 0
       %2011 = OpCompositeExtract %u32_id %2009 1
       %2012 = OpBitcast %f32_id %1994
       %2013 = OpFAdd %f32_id %1979 %2012
       %2014 = OpBitcast %f32_id %1987
       %2015 = OpFAdd %f32_id %1971 %2014
       %2016 = OpBitcast %f32_id %1986
       %2017 = OpFAdd %f32_id %1966 %2016
       %2018 = OpBitcast %f32_id %1995
       %2019 = OpFAdd %f32_id %1964 %2018
       %2020 = OpBitcast %f32_id %2011
       %2021 = OpFAdd %f32_id %2019 %2020
       %2022 = OpBitcast %f32_id %2010
       %2023 = OpFAdd %f32_id %2013 %2022
       %2024 = OpBitcast %f32_id %2003
       %2025 = OpFAdd %f32_id %2015 %2024
       %2026 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2028 = OpIAdd %u32_id %2026 %u32_id_24624
       %2029 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2028
       %2030 = OpLoad %u64_id %2029
       %2031 = OpBitcast %u32vec2_id %2030
       %2032 = OpCompositeExtract %u32_id %2031 0
       %2033 = OpCompositeExtract %u32_id %2031 1
       %2034 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2036 = OpIAdd %u32_id %2034 %u32_id_24632
       %2037 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2036
       %2038 = OpLoad %u64_id %2037
       %2039 = OpBitcast %u32vec2_id %2038
       %2040 = OpCompositeExtract %u32_id %2039 0
       %2041 = OpCompositeExtract %u32_id %2039 1
       %2042 = OpBitcast %f32_id %2002
       %2043 = OpFAdd %f32_id %2017 %2042
       %2044 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2046 = OpIAdd %u32_id %2044 %u32_id_28720
       %2047 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2046
       %2048 = OpLoad %u64_id %2047
       %2049 = OpBitcast %u32vec2_id %2048
       %2050 = OpCompositeExtract %u32_id %2049 0
       %2051 = OpCompositeExtract %u32_id %2049 1
       %2052 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2054 = OpIAdd %u32_id %2052 %u32_id_28728
       %2055 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2054
       %2056 = OpLoad %u64_id %2055
       %2057 = OpBitcast %u32vec2_id %2056
       %2058 = OpCompositeExtract %u32_id %2057 0
       %2059 = OpCompositeExtract %u32_id %2057 1
       %2060 = OpBitcast %f32_id %2040
       %2061 = OpFAdd %f32_id %2023 %2060
       %2062 = OpBitcast %f32_id %2033
       %2063 = OpFAdd %f32_id %2025 %2062
       %2064 = OpBitcast %f32_id %2051
       %2065 = OpFAdd %f32_id %2063 %2064
       %2066 = OpBitcast %f32_id %2032
       %2067 = OpFAdd %f32_id %2043 %2066
       %2068 = OpBitcast %f32_id %2041
       %2069 = OpFAdd %f32_id %2021 %2068
       %2070 = OpBitcast %f32_id %2059
       %2071 = OpFAdd %f32_id %2069 %2070
       %2072 = OpBitcast %f32_id %2058
       %2073 = OpFAdd %f32_id %2061 %2072
       %2074 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2076 = OpIAdd %u32_id %2074 %u32_id_32816
       %2077 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2076
       %2078 = OpLoad %u64_id %2077
       %2079 = OpBitcast %u32vec2_id %2078
       %2080 = OpCompositeExtract %u32_id %2079 0
       %2081 = OpCompositeExtract %u32_id %2079 1
       %2082 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2084 = OpIAdd %u32_id %2082 %u32_id_32824
       %2085 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2084
       %2086 = OpLoad %u64_id %2085
       %2087 = OpBitcast %u32vec2_id %2086
       %2088 = OpCompositeExtract %u32_id %2087 0
       %2089 = OpCompositeExtract %u32_id %2087 1
       %2090 = OpBitcast %f32_id %2050
       %2091 = OpFAdd %f32_id %2067 %2090
       %2092 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2094 = OpIAdd %u32_id %2092 %u32_id_36912
       %2095 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2094
       %2096 = OpLoad %u64_id %2095
       %2097 = OpBitcast %u32vec2_id %2096
       %2098 = OpCompositeExtract %u32_id %2097 0
       %2099 = OpCompositeExtract %u32_id %2097 1
       %2100 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2102 = OpIAdd %u32_id %2100 %u32_id_36920
       %2103 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2102
       %2104 = OpLoad %u64_id %2103
       %2105 = OpBitcast %u32vec2_id %2104
       %2106 = OpCompositeExtract %u32_id %2105 0
       %2107 = OpCompositeExtract %u32_id %2105 1
       %2108 = OpBitcast %f32_id %2088
       %2109 = OpFAdd %f32_id %2073 %2108
       %2110 = OpBitcast %f32_id %2081
       %2111 = OpFAdd %f32_id %2065 %2110
       %2112 = OpBitcast %f32_id %2106
       %2113 = OpFAdd %f32_id %2109 %2112
       %2114 = OpBitcast %f32_id %2099
       %2115 = OpFAdd %f32_id %2111 %2114
       %2116 = OpBitcast %f32_id %2080
       %2117 = OpFAdd %f32_id %2091 %2116
       %2118 = OpBitcast %f32_id %2089
       %2119 = OpFAdd %f32_id %2071 %2118
       %2120 = OpBitcast %f32_id %2107
       %2121 = OpFAdd %f32_id %2119 %2120
       %2122 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2124 = OpIAdd %u32_id %2122 %u32_id_41008
       %2125 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2124
       %2126 = OpLoad %u64_id %2125
       %2127 = OpBitcast %u32vec2_id %2126
       %2128 = OpCompositeExtract %u32_id %2127 0
       %2129 = OpCompositeExtract %u32_id %2127 1
       %2130 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2132 = OpIAdd %u32_id %2130 %u32_id_41016
       %2133 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2132
       %2134 = OpLoad %u64_id %2133
       %2135 = OpBitcast %u32vec2_id %2134
       %2136 = OpCompositeExtract %u32_id %2135 0
       %2137 = OpCompositeExtract %u32_id %2135 1
       %2138 = OpBitcast %f32_id %2098
       %2139 = OpFAdd %f32_id %2117 %2138
       %2140 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2142 = OpIAdd %u32_id %2140 %u32_id_45104
       %2143 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2142
       %2144 = OpLoad %u64_id %2143
       %2145 = OpBitcast %u32vec2_id %2144
       %2146 = OpCompositeExtract %u32_id %2145 0
       %2147 = OpCompositeExtract %u32_id %2145 1
       %2148 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2150 = OpIAdd %u32_id %2148 %u32_id_45112
       %2151 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2150
       %2152 = OpLoad %u64_id %2151
       %2153 = OpBitcast %u32vec2_id %2152
       %2154 = OpCompositeExtract %u32_id %2153 0
       %2155 = OpCompositeExtract %u32_id %2153 1
       %2156 = OpBitcast %f32_id %2136
       %2157 = OpFAdd %f32_id %2113 %2156
       %2158 = OpBitcast %f32_id %2129
       %2159 = OpFAdd %f32_id %2115 %2158
       %2160 = OpBitcast %f32_id %2154
       %2161 = OpFAdd %f32_id %2157 %2160
       %2162 = OpBitcast %f32_id %2147
       %2163 = OpFAdd %f32_id %2159 %2162
       %2164 = OpBitcast %f32_id %2128
       %2165 = OpFAdd %f32_id %2139 %2164
       %2166 = OpBitcast %f32_id %2137
       %2167 = OpFAdd %f32_id %2121 %2166
       %2168 = OpBitcast %f32_id %2155
       %2169 = OpFAdd %f32_id %2167 %2168
       %2170 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2172 = OpIAdd %u32_id %2170 %u32_id_49200
       %2173 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2172
       %2174 = OpLoad %u64_id %2173
       %2175 = OpBitcast %u32vec2_id %2174
       %2176 = OpCompositeExtract %u32_id %2175 0
       %2177 = OpCompositeExtract %u32_id %2175 1
       %2178 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2180 = OpIAdd %u32_id %2178 %u32_id_49208
       %2181 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2180
       %2182 = OpLoad %u64_id %2181
       %2183 = OpBitcast %u32vec2_id %2182
       %2184 = OpCompositeExtract %u32_id %2183 0
       %2185 = OpCompositeExtract %u32_id %2183 1
       %2186 = OpBitcast %f32_id %2146
       %2187 = OpFAdd %f32_id %2165 %2186
       %2188 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2190 = OpIAdd %u32_id %2188 %u32_id_53296
       %2191 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2190
       %2192 = OpLoad %u64_id %2191
       %2193 = OpBitcast %u32vec2_id %2192
       %2194 = OpCompositeExtract %u32_id %2193 0
       %2195 = OpCompositeExtract %u32_id %2193 1
       %2196 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2198 = OpIAdd %u32_id %2196 %u32_id_53304
       %2199 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2198
       %2200 = OpLoad %u64_id %2199
       %2201 = OpBitcast %u32vec2_id %2200
       %2202 = OpCompositeExtract %u32_id %2201 0
       %2203 = OpCompositeExtract %u32_id %2201 1
       %2204 = OpBitcast %f32_id %2185
       %2205 = OpFAdd %f32_id %2169 %2204
       %2206 = OpBitcast %f32_id %2184
       %2207 = OpFAdd %f32_id %2161 %2206
       %2208 = OpBitcast %f32_id %2177
       %2209 = OpFAdd %f32_id %2163 %2208
       %2210 = OpBitcast %f32_id %2176
       %2211 = OpFAdd %f32_id %2187 %2210
       %2212 = OpBitcast %f32_id %2194
       %2213 = OpFAdd %f32_id %2211 %2212
       %2214 = OpBitcast %f32_id %2203
       %2215 = OpFAdd %f32_id %2205 %2214
       %2216 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2218 = OpIAdd %u32_id %2216 %u32_id_57392
       %2219 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2218
       %2220 = OpLoad %u64_id %2219
       %2221 = OpBitcast %u32vec2_id %2220
       %2222 = OpCompositeExtract %u32_id %2221 0
       %2223 = OpCompositeExtract %u32_id %2221 1
       %2224 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2226 = OpIAdd %u32_id %2224 %u32_id_57400
       %2227 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2226
       %2228 = OpLoad %u64_id %2227
       %2229 = OpBitcast %u32vec2_id %2228
       %2230 = OpCompositeExtract %u32_id %2229 0
       %2231 = OpCompositeExtract %u32_id %2229 1
       %2232 = OpBitcast %f32_id %2202
       %2233 = OpFAdd %f32_id %2207 %2232
       %2234 = OpBitcast %f32_id %2195
       %2235 = OpFAdd %f32_id %2209 %2234
       %2236 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2238 = OpIAdd %u32_id %2236 %u32_id_61488
       %2239 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2238
       %2240 = OpLoad %u64_id %2239
       %2241 = OpBitcast %u32vec2_id %2240
       %2242 = OpCompositeExtract %u32_id %2241 0
       %2243 = OpCompositeExtract %u32_id %2241 1
       %2244 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %2246 = OpIAdd %u32_id %2244 %u32_id_61496
       %2247 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %2246
       %2248 = OpLoad %u64_id %2247
       %2249 = OpBitcast %u32vec2_id %2248
       %2250 = OpCompositeExtract %u32_id %2249 0
       %2251 = OpCompositeExtract %u32_id %2249 1
       %2252 = OpBitcast %f32_id %1866
       %2253 = OpFMul %f32_id %2252 %1550
       %2254 = OpBitcast %u32_id %2253
       %2255 = OpBitcast %f32_id %2222
       %2256 = OpFAdd %f32_id %2213 %2255
       %2257 = OpBitcast %f32_id %2231
       %2258 = OpFAdd %f32_id %2215 %2257
       %2259 = OpBitcast %f32_id %2223
       %2260 = OpFAdd %f32_id %2235 %2259
       %2261 = OpBitcast %f32_id %2230
       %2262 = OpFAdd %f32_id %2233 %2261
       %2263 = OpBitcast %f32_id %2242
       %2264 = OpFAdd %f32_id %2256 %2263
       %2265 = OpBitcast %f32_id %2251
       %2266 = OpFAdd %f32_id %2258 %2265
       %2267 = OpBitcast %f32_id %2250
       %2268 = OpFAdd %f32_id %2262 %2267
       %2269 = OpBitcast %f32_id %2243
       %2270 = OpFAdd %f32_id %2260 %2269
       %2271 = OpFAdd %f32_id %2264 %690
       %2272 = OpFAdd %f32_id %2266 %678
       %2273 = OpFAdd %f32_id %2268 %682
       %2274 = OpFAdd %f32_id %2270 %686
       %2275 = OpBitcast %f32_id %1866
       %2276 = OpFMul %f32_id %2275 %1529
       %2277 = OpBitcast %u32_id %2276
       %2278 = OpBitcast %f32_id %1866
       %2279 = OpFMul %f32_id %2278 %1916
       %2280 = OpBitcast %u32_id %2279
       %2281 = OpBitcast %f32_id %1866
       %2282 = OpFMul %f32_id %2281 %1933
       %2283 = OpBitcast %u32_id %2282
       %2284 = OpBitcast %f32_id %1866
       %2285 = OpFMul %f32_id %2284 %1934
       %2286 = OpBitcast %u32_id %2285
       %2287 = OpCompositeConstruct %u32vec4_id %1906 %1915 %1912 %1909
       %2288 = OpIMul %u32_id %1549 %u32_id_16
       %2289 = OpIAdd %u32_id %2288 %buf1_dword_off
       %2290 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2289
       %2291 = OpCompositeExtract %u32_id %2287 0
               OpStore %2290 %2291
       %2292 = OpIAdd %u32_id %2289 %u32_id_1
       %2293 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2292
       %2294 = OpCompositeExtract %u32_id %2287 1
               OpStore %2293 %2294
       %2295 = OpIAdd %u32_id %2289 %u32_id_2
       %2296 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2295
       %2297 = OpCompositeExtract %u32_id %2287 2
               OpStore %2296 %2297
       %2298 = OpIAdd %u32_id %2289 %u32_id_3
       %2299 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2298
       %2300 = OpCompositeExtract %u32_id %2287 3
               OpStore %2299 %2300
       %2301 = OpBitcast %f32_id %1870
       %2302 = OpFMul %f32_id %2301 %2271
       %2303 = OpBitcast %u32_id %2302
       %2304 = OpBitcast %f32_id %1870
       %2305 = OpFMul %f32_id %2304 %2272
       %2306 = OpBitcast %u32_id %2305
       %2307 = OpBitcast %f32_id %1870
       %2308 = OpFMul %f32_id %2307 %2273
       %2309 = OpBitcast %u32_id %2308
       %2310 = OpBitcast %f32_id %1870
       %2311 = OpFMul %f32_id %2310 %2274
       %2312 = OpBitcast %u32_id %2311
       %2313 = OpCompositeConstruct %u32vec4_id %1969 %2254 %2277 %1974
       %2314 = OpIMul %u32_id %1549 %u32_id_16
       %2316 = OpIAdd %u32_id %2314 %u32_id_4
       %2317 = OpIAdd %u32_id %2316 %buf1_dword_off
       %2318 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2317
       %2319 = OpCompositeExtract %u32_id %2313 0
               OpStore %2318 %2319
       %2320 = OpIAdd %u32_id %2317 %u32_id_1
       %2321 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2320
       %2322 = OpCompositeExtract %u32_id %2313 1
               OpStore %2321 %2322
       %2323 = OpIAdd %u32_id %2317 %u32_id_2
       %2324 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2323
       %2325 = OpCompositeExtract %u32_id %2313 2
               OpStore %2324 %2325
       %2326 = OpIAdd %u32_id %2317 %u32_id_3
       %2327 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2326
       %2328 = OpCompositeExtract %u32_id %2313 3
               OpStore %2327 %2328
       %2329 = OpCompositeConstruct %u32vec4_id %1977 %2286 %2283 %2280
       %2330 = OpIMul %u32_id %1549 %u32_id_16
       %2331 = OpIAdd %u32_id %2330 %u32_id_8
       %2332 = OpIAdd %u32_id %2331 %buf1_dword_off
       %2333 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2332
       %2334 = OpCompositeExtract %u32_id %2329 0
               OpStore %2333 %2334
       %2335 = OpIAdd %u32_id %2332 %u32_id_1
       %2336 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2335
       %2337 = OpCompositeExtract %u32_id %2329 1
               OpStore %2336 %2337
       %2338 = OpIAdd %u32_id %2332 %u32_id_2
       %2339 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2338
       %2340 = OpCompositeExtract %u32_id %2329 2
               OpStore %2339 %2340
       %2341 = OpIAdd %u32_id %2332 %u32_id_3
       %2342 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2341
       %2343 = OpCompositeExtract %u32_id %2329 3
               OpStore %2342 %2343
       %2344 = OpCompositeConstruct %u32vec4_id %2303 %2312 %2309 %2306
       %2345 = OpIMul %u32_id %1549 %u32_id_16
       %2346 = OpIAdd %u32_id %2345 %u32_id_12
       %2347 = OpIAdd %u32_id %2346 %buf1_dword_off
       %2348 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2347
       %2349 = OpCompositeExtract %u32_id %2344 0
               OpStore %2348 %2349
       %2350 = OpIAdd %u32_id %2347 %u32_id_1
       %2351 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2350
       %2352 = OpCompositeExtract %u32_id %2344 1
               OpStore %2351 %2352
       %2353 = OpIAdd %u32_id %2347 %u32_id_2
       %2354 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2353
       %2355 = OpCompositeExtract %u32_id %2344 2
               OpStore %2354 %2355
       %2356 = OpIAdd %u32_id %2347 %u32_id_3
       %2357 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %2356
       %2358 = OpCompositeExtract %u32_id %2344 3
               OpStore %2357 %2358
               OpBranch %102
        %102 = OpLabel
               OpBranch %103
        %103 = OpLabel
               OpBranch %104
        %104 = OpLabel
               OpReturn
               OpFunctionEnd
