; SPIR-V
; Version: 1.6
; Generator: Khronos; 0
; Bound: 1874
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
        %273 = OpExtInstImport "GLSL.std.450"
               OpMemoryModel Logical GLSL450
               OpEntryPoint GLCompute %69 "main" %push_data %gl_WorkGroupID %gl_NumWorkGroups %gl_LocalInvocationID %ssbo_1 %ssbo_2 %ssbo_shmem %cs_img0
               OpExecutionMode %69 LocalSize 8 8 16
               OpExecutionMode %69 SignedZeroInfNanPreserve 32
          %1 = OpString "0x366177d6"
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
               OpName %cs_img0 "cs_img0"
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
               OpDecorate %cs_img0 Binding 3
               OpDecorate %cs_img0 DescriptorSet 0
               OpDecorate %199 NoContraction
               OpDecorate %201 NoContraction
               OpDecorate %203 NoContraction
               OpDecorate %205 NoContraction
               OpDecorate %206 NoContraction
               OpDecorate %208 NoContraction
               OpDecorate %209 NoContraction
               OpDecorate %211 NoContraction
               OpDecorate %212 NoContraction
               OpDecorate %215 NoContraction
               OpDecorate %216 NoContraction
               OpDecorate %219 NoContraction
               OpDecorate %220 NoContraction
               OpDecorate %223 NoContraction
               OpDecorate %224 NoContraction
               OpDecorate %264 NoContraction
               OpDecorate %267 NoContraction
               OpDecorate %268 NoContraction
               OpDecorate %271 NoContraction
               OpDecorate %272 NoContraction
               OpDecorate %277 NoContraction
               OpDecorate %278 NoContraction
               OpDecorate %280 NoContraction
               OpDecorate %282 NoContraction
               OpDecorate %284 NoContraction
               OpDecorate %285 NoContraction
               OpDecorate %286 NoContraction
               OpDecorate %290 NoContraction
               OpDecorate %294 NoContraction
               OpDecorate %298 NoContraction
               OpDecorate %301 NoContraction
               OpDecorate %302 NoContraction
               OpDecorate %305 NoContraction
               OpDecorate %306 NoContraction
               OpDecorate %309 NoContraction
               OpDecorate %310 NoContraction
               OpDecorate %313 NoContraction
               OpDecorate %314 NoContraction
               OpDecorate %317 NoContraction
               OpDecorate %318 NoContraction
               OpDecorate %321 NoContraction
               OpDecorate %322 NoContraction
               OpDecorate %325 NoContraction
               OpDecorate %326 NoContraction
               OpDecorate %329 NoContraction
               OpDecorate %330 NoContraction
               OpDecorate %333 NoContraction
               OpDecorate %334 NoContraction
               OpDecorate %337 NoContraction
               OpDecorate %338 NoContraction
               OpDecorate %341 NoContraction
               OpDecorate %342 NoContraction
               OpDecorate %345 NoContraction
               OpDecorate %346 NoContraction
               OpDecorate %362 NoContraction
               OpDecorate %367 NoContraction
               OpDecorate %371 NoContraction
               OpDecorate %523 NoContraction
               OpDecorate %527 NoContraction
               OpDecorate %531 NoContraction
               OpDecorate %535 NoContraction
               OpDecorate %539 NoContraction
               OpDecorate %543 NoContraction
               OpDecorate %547 NoContraction
               OpDecorate %551 NoContraction
               OpDecorate %555 NoContraction
               OpDecorate %559 NoContraction
               OpDecorate %563 NoContraction
               OpDecorate %567 NoContraction
               OpDecorate %671 NoContraction
               OpDecorate %674 NoContraction
               OpDecorate %677 NoContraction
               OpDecorate %680 NoContraction
               OpDecorate %682 NoContraction
               OpDecorate %684 NoContraction
               OpDecorate %686 NoContraction
               OpDecorate %688 NoContraction
               OpDecorate %722 NoContraction
               OpDecorate %724 NoContraction
               OpDecorate %726 NoContraction
               OpDecorate %728 NoContraction
               OpDecorate %730 NoContraction
               OpDecorate %732 NoContraction
               OpDecorate %734 NoContraction
               OpDecorate %736 NoContraction
               OpDecorate %770 NoContraction
               OpDecorate %772 NoContraction
               OpDecorate %774 NoContraction
               OpDecorate %776 NoContraction
               OpDecorate %778 NoContraction
               OpDecorate %780 NoContraction
               OpDecorate %782 NoContraction
               OpDecorate %784 NoContraction
               OpDecorate %818 NoContraction
               OpDecorate %820 NoContraction
               OpDecorate %822 NoContraction
               OpDecorate %824 NoContraction
               OpDecorate %826 NoContraction
               OpDecorate %828 NoContraction
               OpDecorate %830 NoContraction
               OpDecorate %832 NoContraction
               OpDecorate %866 NoContraction
               OpDecorate %868 NoContraction
               OpDecorate %870 NoContraction
               OpDecorate %872 NoContraction
               OpDecorate %874 NoContraction
               OpDecorate %876 NoContraction
               OpDecorate %878 NoContraction
               OpDecorate %880 NoContraction
               OpDecorate %922 NoContraction
               OpDecorate %924 NoContraction
               OpDecorate %926 NoContraction
               OpDecorate %928 NoContraction
               OpDecorate %930 NoContraction
               OpDecorate %948 NoContraction
               OpDecorate %950 NoContraction
               OpDecorate %952 NoContraction
               OpDecorate %954 NoContraction
               OpDecorate %956 NoContraction
               OpDecorate %958 NoContraction
               OpDecorate %976 NoContraction
               OpDecorate %982 NoContraction
               OpDecorate %1000 NoContraction
               OpDecorate %1001 NoContraction
               OpDecorate %1003 NoContraction
               OpDecorate %1005 NoContraction
               OpDecorate %1022 NoContraction
               OpDecorate %1025 NoContraction
               OpDecorate %1028 NoContraction
               OpDecorate %1031 NoContraction
               OpDecorate %1034 NoContraction
               OpDecorate %1035 NoContraction
               OpDecorate %1036 NoContraction
               OpDecorate %1054 NoContraction
               OpDecorate %1056 NoContraction
               OpDecorate %1058 NoContraction
               OpDecorate %1060 NoContraction
               OpDecorate %1094 NoContraction
               OpDecorate %1096 NoContraction
               OpDecorate %1098 NoContraction
               OpDecorate %1100 NoContraction
               OpDecorate %1102 NoContraction
               OpDecorate %1104 NoContraction
               OpDecorate %1106 NoContraction
               OpDecorate %1108 NoContraction
               OpDecorate %1142 NoContraction
               OpDecorate %1144 NoContraction
               OpDecorate %1146 NoContraction
               OpDecorate %1148 NoContraction
               OpDecorate %1150 NoContraction
               OpDecorate %1152 NoContraction
               OpDecorate %1154 NoContraction
               OpDecorate %1156 NoContraction
               OpDecorate %1190 NoContraction
               OpDecorate %1192 NoContraction
               OpDecorate %1194 NoContraction
               OpDecorate %1196 NoContraction
               OpDecorate %1198 NoContraction
               OpDecorate %1200 NoContraction
               OpDecorate %1202 NoContraction
               OpDecorate %1204 NoContraction
               OpDecorate %1238 NoContraction
               OpDecorate %1240 NoContraction
               OpDecorate %1242 NoContraction
               OpDecorate %1244 NoContraction
               OpDecorate %1246 NoContraction
               OpDecorate %1248 NoContraction
               OpDecorate %1250 NoContraction
               OpDecorate %1252 NoContraction
               OpDecorate %1286 NoContraction
               OpDecorate %1288 NoContraction
               OpDecorate %1290 NoContraction
               OpDecorate %1292 NoContraction
               OpDecorate %1294 NoContraction
               OpDecorate %1296 NoContraction
               OpDecorate %1298 NoContraction
               OpDecorate %1300 NoContraction
               OpDecorate %1334 NoContraction
               OpDecorate %1336 NoContraction
               OpDecorate %1338 NoContraction
               OpDecorate %1340 NoContraction
               OpDecorate %1342 NoContraction
               OpDecorate %1344 NoContraction
               OpDecorate %1346 NoContraction
               OpDecorate %1348 NoContraction
               OpDecorate %1349 NoContraction
               OpDecorate %1366 NoContraction
               OpDecorate %1367 NoContraction
               OpDecorate %1368 NoContraction
               OpDecorate %1403 NoContraction
               OpDecorate %1406 NoContraction
               OpDecorate %1409 NoContraction
               OpDecorate %1412 NoContraction
               OpDecorate %1414 NoContraction
               OpDecorate %1416 NoContraction
               OpDecorate %1418 NoContraction
               OpDecorate %1420 NoContraction
               OpDecorate %1454 NoContraction
               OpDecorate %1456 NoContraction
               OpDecorate %1458 NoContraction
               OpDecorate %1460 NoContraction
               OpDecorate %1462 NoContraction
               OpDecorate %1464 NoContraction
               OpDecorate %1466 NoContraction
               OpDecorate %1468 NoContraction
               OpDecorate %1502 NoContraction
               OpDecorate %1504 NoContraction
               OpDecorate %1506 NoContraction
               OpDecorate %1508 NoContraction
               OpDecorate %1510 NoContraction
               OpDecorate %1512 NoContraction
               OpDecorate %1514 NoContraction
               OpDecorate %1516 NoContraction
               OpDecorate %1550 NoContraction
               OpDecorate %1552 NoContraction
               OpDecorate %1554 NoContraction
               OpDecorate %1556 NoContraction
               OpDecorate %1558 NoContraction
               OpDecorate %1560 NoContraction
               OpDecorate %1562 NoContraction
               OpDecorate %1564 NoContraction
               OpDecorate %1598 NoContraction
               OpDecorate %1600 NoContraction
               OpDecorate %1602 NoContraction
               OpDecorate %1604 NoContraction
               OpDecorate %1606 NoContraction
               OpDecorate %1608 NoContraction
               OpDecorate %1610 NoContraction
               OpDecorate %1612 NoContraction
               OpDecorate %1646 NoContraction
               OpDecorate %1648 NoContraction
               OpDecorate %1650 NoContraction
               OpDecorate %1652 NoContraction
               OpDecorate %1670 NoContraction
               OpDecorate %1672 NoContraction
               OpDecorate %1674 NoContraction
               OpDecorate %1676 NoContraction
               OpDecorate %1694 NoContraction
               OpDecorate %1696 NoContraction
               OpDecorate %1698 NoContraction
               OpDecorate %1700 NoContraction
               OpDecorate %1702 NoContraction
               OpDecorate %1704 NoContraction
               OpDecorate %1706 NoContraction
               OpDecorate %1708 NoContraction
               OpDecorate %1709 NoContraction
               OpDecorate %1710 NoContraction
               OpDecorate %1711 NoContraction
               OpDecorate %1712 NoContraction
               OpDecorate %1772 NoContraction
               OpDecorate %1773 NoContraction
               OpDecorate %1777 NoContraction
               OpDecorate %1778 NoContraction
               OpDecorate %1782 NoContraction
               OpDecorate %1783 NoContraction
               OpDecorate %1787 NoContraction
               OpDecorate %1788 NoContraction
               OpDecorate %1792 NoContraction
               OpDecorate %1793 NoContraction
               OpDecorate %1797 NoContraction
               OpDecorate %1798 NoContraction
               OpDecorate %1802 NoContraction
               OpDecorate %1803 NoContraction
               OpDecorate %1807 NoContraction
               OpDecorate %1808 NoContraction
               OpDecorate %1826 NoContraction
               OpDecorate %1827 NoContraction
               OpDecorate %1831 NoContraction
               OpDecorate %1832 NoContraction
               OpDecorate %1836 NoContraction
               OpDecorate %1837 NoContraction
               OpDecorate %1841 NoContraction
               OpDecorate %1842 NoContraction
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
         %68 = OpTypeFunction %void_id
   %u32_id_8 = OpConstant %u32_id 8
%_ptr_PushConstant_u32_id = OpTypePointer PushConstant %u32_id
   %u32_id_2 = OpConstant %u32_id 2
  %u32_id_72 = OpConstant %u32_id 72
   %u32_id_3 = OpConstant %u32_id 3
  %u32_id_16 = OpConstant %u32_id 16
  %u32_id_96 = OpConstant %u32_id 96
 %u32_id_192 = OpConstant %u32_id 192
%f32_id_0_125 = OpConstant %f32_id 0.125
   %f32_id_1 = OpConstant %f32_id 1
   %u32_id_6 = OpConstant %u32_id 6
  %u32_id_24 = OpConstant %u32_id 24
  %u32_id_64 = OpConstant %u32_id 64
%u32_id_65536 = OpConstant %u32_id 65536
  %u32_id_32 = OpConstant %u32_id 32
  %u32_id_40 = OpConstant %u32_id 40
  %u32_id_48 = OpConstant %u32_id 48
        %437 = OpConstantComposite %u32vec2_id %u32_id_0 %u32_id_0
  %u32_id_56 = OpConstant %u32_id 56
 %u32_id_264 = OpConstant %u32_id 264
 %u32_id_104 = OpConstant %u32_id 104
  %u32_id_80 = OpConstant %u32_id 80
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
  %u32_id_73 = OpConstant %u32_id 73
  %u32_id_74 = OpConstant %u32_id 74
%u32_id_57344 = OpConstant %u32_id 57344
%u32_id_57352 = OpConstant %u32_id 57352
%u32_id_61440 = OpConstant %u32_id 61440
%u32_id_61448 = OpConstant %u32_id 61448
  %u32_id_75 = OpConstant %u32_id 75
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
   %u32_id_4 = OpConstant %u32_id 4
  %push_data = OpVariable %_ptr_PushConstant_AuxData PushConstant
%gl_WorkGroupID = OpVariable %_ptr_Input_u32vec3_id Input
%gl_NumWorkGroups = OpVariable %_ptr_Input_u32vec3_id Input
%gl_LocalInvocationID = OpVariable %_ptr_Input_u32vec3_id Input
     %ssbo_1 = OpVariable %_ptr_StorageBuffer__struct_53 StorageBuffer
     %ssbo_2 = OpVariable %_ptr_StorageBuffer__struct_53 StorageBuffer
 %ssbo_shmem = OpVariable %_ptr_StorageBuffer__struct_60 StorageBuffer
    %cs_img0 = OpVariable %_ptr_UniformConstant_64 UniformConstant
         %69 = OpFunction %void_id None %68
         %70 = OpLabel
         %94 = OpLoad %u32vec3_id %gl_WorkGroupID
         %95 = OpCompositeExtract %u32_id %94 0
         %96 = OpCompositeExtract %u32_id %94 1
         %97 = OpCompositeExtract %u32_id %94 2
         %98 = OpLoad %u32vec3_id %gl_NumWorkGroups
         %99 = OpCompositeExtract %u32_id %98 0
        %100 = OpCompositeExtract %u32_id %98 1
        %101 = OpIMul %u32_id %99 %100
        %102 = OpIMul %u32_id %97 %101
        %103 = OpIMul %u32_id %96 %99
        %104 = OpIAdd %u32_id %95 %103
%workgroup_index = OpIAdd %u32_id %104 %102
        %108 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
        %109 = OpLoad %u32_id %108
   %buf0_off = OpBitFieldUExtract %u32_id %109 %u32_id_0 %u32_id_8
%buf0_dword_off = OpShiftRightLogical %u32_id %buf0_off %u32_id_2
        %113 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
        %114 = OpLoad %u32_id %113
   %buf1_off = OpBitFieldUExtract %u32_id %114 %u32_id_8 %u32_id_8
%buf1_dword_off = OpShiftRightLogical %u32_id %buf1_off %u32_id_2
        %117 = OpLoad %u32vec3_id %gl_LocalInvocationID
        %118 = OpCompositeExtract %u32_id %117 0
        %119 = OpLoad %u32vec3_id %gl_LocalInvocationID
        %120 = OpCompositeExtract %u32_id %119 1
        %121 = OpLoad %u32vec3_id %gl_LocalInvocationID
        %122 = OpCompositeExtract %u32_id %121 2
        %123 = OpShiftRightLogical %u32_id %122 %u32_id_2
        %125 = OpIAdd %u32_id %u32_id_72 %buf0_dword_off
        %126 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %125
        %127 = OpLoad %u32_id %126
        %129 = OpBitwiseAnd %u32_id %u32_id_3 %122
        %130 = OpShiftLeftLogical %u32_id %127 %u32_id_3
        %131 = OpIMul %u32_id %130 %123
        %132 = OpIMul %u32_id %130 %129
        %133 = OpIAdd %u32_id %118 %131
        %134 = OpIAdd %u32_id %120 %132
        %135 = OpConvertUToF %f32_id %133
        %136 = OpConvertUToF %f32_id %134
               OpBranch %71
         %71 = OpLabel
        %137 = OpPhi %u32_id %u32_id_0 %70 %373 %83
        %138 = OpPhi %u32_id %u32_id_0 %70 %374 %83
        %139 = OpPhi %u32_id %u32_id_0 %70 %375 %83
        %140 = OpPhi %u32_id %u32_id_0 %70 %376 %83
        %141 = OpPhi %u32_id %u32_id_0 %70 %377 %83
        %142 = OpPhi %u32_id %u32_id_0 %70 %378 %83
        %143 = OpPhi %u32_id %u32_id_0 %70 %379 %83
        %144 = OpPhi %u32_id %u32_id_0 %70 %380 %83
        %145 = OpPhi %u32_id %u32_id_0 %70 %381 %83
        %146 = OpPhi %u32_id %u32_id_0 %70 %382 %83
        %147 = OpPhi %u32_id %u32_id_0 %70 %383 %83
        %148 = OpPhi %u32_id %u32_id_0 %70 %384 %83
        %149 = OpPhi %u32_id %u32_id_0 %70 %385 %83
               OpLoopMerge %84 %83 None
               OpBranch %72
         %72 = OpLabel
        %150 = OpCompositeConstruct %u32vec3_id %149 %149 %149
        %151 = OpLoad %64 %cs_img0
        %152 = OpImageFetch %f32vec4_id %151 %150 None
        %153 = OpCompositeExtract %f32_id %152 0
        %154 = OpCompositeExtract %f32_id %152 1
        %155 = OpCompositeExtract %f32_id %152 2
        %157 = OpIMul %u32_id %149 %u32_id_16
        %158 = OpShiftRightLogical %u32_id %157 %u32_id_2
        %159 = OpIAdd %u32_id %158 %buf0_dword_off
        %160 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %159
        %161 = OpLoad %u32_id %160
        %162 = OpIAdd %u32_id %158 %u32_id_1
        %163 = OpIAdd %u32_id %162 %buf0_dword_off
        %164 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %163
        %165 = OpLoad %u32_id %164
        %166 = OpIAdd %u32_id %158 %u32_id_2
        %167 = OpIAdd %u32_id %166 %buf0_dword_off
        %168 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %167
        %169 = OpLoad %u32_id %168
        %171 = OpIAdd %u32_id %157 %u32_id_96
        %173 = OpIAdd %u32_id %157 %u32_id_192
        %174 = OpShiftRightLogical %u32_id %171 %u32_id_2
        %175 = OpIAdd %u32_id %174 %buf0_dword_off
        %176 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %175
        %177 = OpLoad %u32_id %176
        %178 = OpIAdd %u32_id %174 %u32_id_1
        %179 = OpIAdd %u32_id %178 %buf0_dword_off
        %180 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %179
        %181 = OpLoad %u32_id %180
        %182 = OpIAdd %u32_id %174 %u32_id_2
        %183 = OpIAdd %u32_id %182 %buf0_dword_off
        %184 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %183
        %185 = OpLoad %u32_id %184
        %186 = OpShiftRightLogical %u32_id %173 %u32_id_2
        %187 = OpIAdd %u32_id %186 %buf0_dword_off
        %188 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %187
        %189 = OpLoad %u32_id %188
        %190 = OpIAdd %u32_id %186 %u32_id_1
        %191 = OpIAdd %u32_id %190 %buf0_dword_off
        %192 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %191
        %193 = OpLoad %u32_id %192
        %194 = OpIAdd %u32_id %186 %u32_id_2
        %195 = OpIAdd %u32_id %194 %buf0_dword_off
        %196 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %195
        %197 = OpLoad %u32_id %196
        %198 = OpBitcast %f32_id %161
        %199 = OpFMul %f32_id %198 %135
        %200 = OpBitcast %f32_id %165
        %201 = OpFMul %f32_id %200 %135
        %202 = OpBitcast %f32_id %169
        %203 = OpFMul %f32_id %202 %135
        %204 = OpBitcast %f32_id %177
        %205 = OpFMul %f32_id %204 %136
        %206 = OpFAdd %f32_id %205 %199
        %207 = OpBitcast %f32_id %181
        %208 = OpFMul %f32_id %207 %136
        %209 = OpFAdd %f32_id %208 %201
        %210 = OpBitcast %f32_id %185
        %211 = OpFMul %f32_id %210 %136
        %212 = OpFAdd %f32_id %211 %203
        %213 = OpBitcast %f32_id %189
        %215 = OpFMul %f32_id %f32_id_0_125 %206
        %216 = OpFAdd %f32_id %215 %213
        %217 = OpBitcast %u32_id %216
        %218 = OpBitcast %f32_id %193
        %219 = OpFMul %f32_id %f32_id_0_125 %209
        %220 = OpFAdd %f32_id %219 %218
        %221 = OpBitcast %u32_id %220
        %222 = OpBitcast %f32_id %197
        %223 = OpFMul %f32_id %f32_id_0_125 %212
        %224 = OpFAdd %f32_id %223 %222
        %225 = OpBitcast %u32_id %224
               OpBranch %73
         %73 = OpLabel
        %226 = OpPhi %u32_id %137 %72 %348 %81
        %227 = OpPhi %u32_id %138 %72 %349 %81
        %228 = OpPhi %u32_id %139 %72 %350 %81
        %229 = OpPhi %u32_id %140 %72 %351 %81
        %230 = OpPhi %u32_id %141 %72 %352 %81
        %231 = OpPhi %u32_id %142 %72 %353 %81
        %232 = OpPhi %u32_id %143 %72 %354 %81
        %233 = OpPhi %u32_id %144 %72 %355 %81
        %234 = OpPhi %u32_id %145 %72 %356 %81
        %235 = OpPhi %u32_id %146 %72 %357 %81
        %236 = OpPhi %u32_id %147 %72 %358 %81
        %237 = OpPhi %u32_id %148 %72 %359 %81
        %238 = OpPhi %u32_id %225 %72 %372 %81
        %239 = OpPhi %u32_id %221 %72 %368 %81
        %240 = OpPhi %u32_id %217 %72 %363 %81
        %241 = OpPhi %u32_id %u32_id_0 %72 %364 %81
               OpLoopMerge %82 %81 None
               OpBranch %74
         %74 = OpLabel
        %242 = OpULessThan %bool_id %241 %127
        %243 = OpLogicalNot %bool_id %242
               OpBranchConditional %243 %82 %75
         %75 = OpLabel
               OpBranch %76
         %76 = OpLabel
        %244 = OpPhi %u32_id %226 %75 %303 %79
        %245 = OpPhi %u32_id %227 %75 %339 %79
        %246 = OpPhi %u32_id %228 %75 %311 %79
        %247 = OpPhi %u32_id %229 %75 %307 %79
        %248 = OpPhi %u32_id %230 %75 %323 %79
        %249 = OpPhi %u32_id %231 %75 %319 %79
        %250 = OpPhi %u32_id %232 %75 %315 %79
        %251 = OpPhi %u32_id %233 %75 %343 %79
        %252 = OpPhi %u32_id %234 %75 %327 %79
        %253 = OpPhi %u32_id %235 %75 %347 %79
        %254 = OpPhi %u32_id %236 %75 %335 %79
        %255 = OpPhi %u32_id %237 %75 %331 %79
        %256 = OpPhi %u32_id %238 %75 %299 %79
        %257 = OpPhi %u32_id %239 %75 %295 %79
        %258 = OpPhi %u32_id %240 %75 %291 %79
        %259 = OpPhi %u32_id %u32_id_0 %75 %287 %79
               OpLoopMerge %80 %79 None
               OpBranch %77
         %77 = OpLabel
        %260 = OpULessThan %bool_id %259 %127
        %261 = OpLogicalNot %bool_id %260
               OpBranchConditional %261 %80 %78
         %78 = OpLabel
        %262 = OpBitcast %f32_id %258
        %263 = OpBitcast %f32_id %258
        %264 = OpFMul %f32_id %263 %262
        %265 = OpBitcast %f32_id %257
        %266 = OpBitcast %f32_id %257
        %267 = OpFMul %f32_id %265 %266
        %268 = OpFAdd %f32_id %267 %264
        %269 = OpBitcast %f32_id %256
        %270 = OpBitcast %f32_id %256
        %271 = OpFMul %f32_id %269 %270
        %272 = OpFAdd %f32_id %271 %268
        %274 = OpExtInst %f32_id %273 InverseSqrt %272
        %276 = OpFDiv %f32_id %f32_id_1 %272
        %277 = OpFMul %f32_id %274 %276
        %278 = OpFMul %f32_id %153 %277
        %279 = OpBitcast %f32_id %258
        %280 = OpFMul %f32_id %274 %279
        %281 = OpBitcast %f32_id %257
        %282 = OpFMul %f32_id %274 %281
        %283 = OpBitcast %f32_id %256
        %284 = OpFMul %f32_id %274 %283
        %285 = OpFMul %f32_id %154 %277
        %286 = OpFMul %f32_id %155 %277
        %287 = OpIAdd %u32_id %259 %u32_id_1
        %288 = OpBitcast %f32_id %161
        %289 = OpBitcast %f32_id %258
        %290 = OpFAdd %f32_id %288 %289
        %291 = OpBitcast %u32_id %290
        %292 = OpBitcast %f32_id %165
        %293 = OpBitcast %f32_id %257
        %294 = OpFAdd %f32_id %292 %293
        %295 = OpBitcast %u32_id %294
        %296 = OpBitcast %f32_id %169
        %297 = OpBitcast %f32_id %256
        %298 = OpFAdd %f32_id %296 %297
        %299 = OpBitcast %u32_id %298
        %300 = OpBitcast %f32_id %244
        %301 = OpFMul %f32_id %280 %278
        %302 = OpFAdd %f32_id %301 %300
        %303 = OpBitcast %u32_id %302
        %304 = OpBitcast %f32_id %247
        %305 = OpFMul %f32_id %282 %278
        %306 = OpFAdd %f32_id %305 %304
        %307 = OpBitcast %u32_id %306
        %308 = OpBitcast %f32_id %246
        %309 = OpFMul %f32_id %284 %278
        %310 = OpFAdd %f32_id %309 %308
        %311 = OpBitcast %u32_id %310
        %312 = OpBitcast %f32_id %250
        %313 = OpFMul %f32_id %280 %285
        %314 = OpFAdd %f32_id %313 %312
        %315 = OpBitcast %u32_id %314
        %316 = OpBitcast %f32_id %249
        %317 = OpFMul %f32_id %282 %285
        %318 = OpFAdd %f32_id %317 %316
        %319 = OpBitcast %u32_id %318
        %320 = OpBitcast %f32_id %248
        %321 = OpFMul %f32_id %284 %285
        %322 = OpFAdd %f32_id %321 %320
        %323 = OpBitcast %u32_id %322
        %324 = OpBitcast %f32_id %252
        %325 = OpFMul %f32_id %280 %286
        %326 = OpFAdd %f32_id %325 %324
        %327 = OpBitcast %u32_id %326
        %328 = OpBitcast %f32_id %255
        %329 = OpFMul %f32_id %282 %286
        %330 = OpFAdd %f32_id %329 %328
        %331 = OpBitcast %u32_id %330
        %332 = OpBitcast %f32_id %254
        %333 = OpFMul %f32_id %284 %286
        %334 = OpFAdd %f32_id %333 %332
        %335 = OpBitcast %u32_id %334
        %336 = OpBitcast %f32_id %245
        %337 = OpFMul %f32_id %277 %153
        %338 = OpFAdd %f32_id %337 %336
        %339 = OpBitcast %u32_id %338
        %340 = OpBitcast %f32_id %251
        %341 = OpFMul %f32_id %277 %154
        %342 = OpFAdd %f32_id %341 %340
        %343 = OpBitcast %u32_id %342
        %344 = OpBitcast %f32_id %253
        %345 = OpFMul %f32_id %277 %155
        %346 = OpFAdd %f32_id %345 %344
        %347 = OpBitcast %u32_id %346
               OpBranch %79
         %79 = OpLabel
               OpBranchConditional %true %76 %80
         %80 = OpLabel
        %348 = OpPhi %u32_id %244 %77 %303 %79
        %349 = OpPhi %u32_id %245 %77 %339 %79
        %350 = OpPhi %u32_id %246 %77 %311 %79
        %351 = OpPhi %u32_id %247 %77 %307 %79
        %352 = OpPhi %u32_id %248 %77 %323 %79
        %353 = OpPhi %u32_id %249 %77 %319 %79
        %354 = OpPhi %u32_id %250 %77 %315 %79
        %355 = OpPhi %u32_id %251 %77 %343 %79
        %356 = OpPhi %u32_id %252 %77 %327 %79
        %357 = OpPhi %u32_id %253 %77 %347 %79
        %358 = OpPhi %u32_id %254 %77 %335 %79
        %359 = OpPhi %u32_id %255 %77 %331 %79
        %360 = OpBitcast %f32_id %177
        %361 = OpBitcast %f32_id %240
        %362 = OpFAdd %f32_id %360 %361
        %363 = OpBitcast %u32_id %362
        %364 = OpIAdd %u32_id %241 %u32_id_1
        %365 = OpBitcast %f32_id %181
        %366 = OpBitcast %f32_id %239
        %367 = OpFAdd %f32_id %365 %366
        %368 = OpBitcast %u32_id %367
        %369 = OpBitcast %f32_id %185
        %370 = OpBitcast %f32_id %238
        %371 = OpFAdd %f32_id %369 %370
        %372 = OpBitcast %u32_id %371
               OpBranch %81
         %81 = OpLabel
               OpBranchConditional %true %73 %82
         %82 = OpLabel
        %373 = OpPhi %u32_id %226 %74 %348 %81
        %374 = OpPhi %u32_id %227 %74 %349 %81
        %375 = OpPhi %u32_id %228 %74 %350 %81
        %376 = OpPhi %u32_id %229 %74 %351 %81
        %377 = OpPhi %u32_id %230 %74 %352 %81
        %378 = OpPhi %u32_id %231 %74 %353 %81
        %379 = OpPhi %u32_id %232 %74 %354 %81
        %380 = OpPhi %u32_id %233 %74 %355 %81
        %381 = OpPhi %u32_id %234 %74 %356 %81
        %382 = OpPhi %u32_id %235 %74 %357 %81
        %383 = OpPhi %u32_id %236 %74 %358 %81
        %384 = OpPhi %u32_id %237 %74 %359 %81
        %385 = OpIAdd %u32_id %149 %u32_id_1
        %387 = OpULessThan %bool_id %385 %u32_id_6
               OpBranch %83
         %83 = OpLabel
               OpBranchConditional %387 %71 %84
         %84 = OpLabel
        %389 = OpBitFieldUExtract %u32_id %120 %u32_id_0 %u32_id_24
        %390 = OpIMul %u32_id %389 %u32_id_8
        %391 = OpIAdd %u32_id %390 %118
        %392 = OpBitFieldUExtract %u32_id %122 %u32_id_0 %u32_id_24
        %394 = OpIMul %u32_id %392 %u32_id_64
        %395 = OpIAdd %u32_id %394 %391
        %396 = OpShiftLeftLogical %u32_id %395 %u32_id_6
        %397 = OpCompositeConstruct %u32vec2_id %374 %373
        %398 = OpBitcast %u64_id %397
        %400 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %401 = OpIAdd %u32_id %396 %400
        %402 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %401
               OpStore %402 %398
        %403 = OpIAdd %u32_id %396 %u32_id_8
        %404 = OpCompositeConstruct %u32vec2_id %376 %375
        %405 = OpBitcast %u64_id %404
        %406 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %407 = OpIAdd %u32_id %403 %406
        %408 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %407
               OpStore %408 %405
        %409 = OpIAdd %u32_id %396 %u32_id_16
        %410 = OpCompositeConstruct %u32vec2_id %380 %379
        %411 = OpBitcast %u64_id %410
        %412 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %413 = OpIAdd %u32_id %409 %412
        %414 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %413
               OpStore %414 %411
        %415 = OpIAdd %u32_id %396 %u32_id_24
        %416 = OpCompositeConstruct %u32vec2_id %378 %377
        %417 = OpBitcast %u64_id %416
        %418 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %419 = OpIAdd %u32_id %415 %418
        %420 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %419
               OpStore %420 %417
        %422 = OpIAdd %u32_id %396 %u32_id_32
        %423 = OpCompositeConstruct %u32vec2_id %382 %381
        %424 = OpBitcast %u64_id %423
        %425 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %426 = OpIAdd %u32_id %422 %425
        %427 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %426
               OpStore %427 %424
        %429 = OpIAdd %u32_id %396 %u32_id_40
        %430 = OpCompositeConstruct %u32vec2_id %384 %383
        %431 = OpBitcast %u64_id %430
        %432 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %433 = OpIAdd %u32_id %429 %432
        %434 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %433
               OpStore %434 %431
        %436 = OpIAdd %u32_id %396 %u32_id_48
        %438 = OpBitcast %u64_id %437
        %439 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %440 = OpIAdd %u32_id %436 %439
        %441 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %440
               OpStore %441 %438
        %443 = OpIAdd %u32_id %396 %u32_id_56
        %444 = OpBitcast %u64_id %437
        %445 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %446 = OpIAdd %u32_id %443 %445
        %447 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %446
               OpStore %447 %444
               OpControlBarrier %u32_id_2 %u32_id_2 %u32_id_264
        %449 = OpINotEqual %bool_id %u32_id_0 %120
        %450 = OpINotEqual %bool_id %u32_id_0 %118
        %451 = OpLogicalOr %bool_id %450 %449
        %452 = OpLogicalNot %bool_id %451
        %453 = OpLogicalNot %bool_id %451
               OpSelectionMerge %92 None
               OpBranchConditional %453 %85 %92
         %85 = OpLabel
               OpBranch %86
         %86 = OpLabel
        %454 = OpPhi %u32_id %395 %85 %520 %88
        %455 = OpPhi %u32_id %373 %85 %564 %88
        %456 = OpPhi %u32_id %374 %85 %568 %88
        %457 = OpPhi %u32_id %375 %85 %556 %88
        %458 = OpPhi %u32_id %376 %85 %560 %88
        %459 = OpPhi %u32_id %377 %85 %540 %88
        %460 = OpPhi %u32_id %378 %85 %544 %88
        %461 = OpPhi %u32_id %379 %85 %548 %88
        %462 = OpPhi %u32_id %380 %85 %552 %88
        %463 = OpPhi %u32_id %381 %85 %532 %88
        %464 = OpPhi %u32_id %382 %85 %536 %88
        %465 = OpPhi %u32_id %383 %85 %524 %88
        %466 = OpPhi %u32_id %384 %85 %528 %88
        %467 = OpPhi %u32_id %u32_id_1 %85 %569 %88
               OpLoopMerge %89 %88 None
               OpBranch %87
         %87 = OpLabel
        %468 = OpShiftLeftLogical %u32_id %454 %u32_id_6
        %469 = OpIAdd %u32_id %468 %u32_id_96
        %470 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %471 = OpIAdd %u32_id %469 %470
        %472 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %471
        %473 = OpLoad %u64_id %472
        %474 = OpBitcast %u32vec2_id %473
        %475 = OpCompositeExtract %u32_id %474 0
        %476 = OpCompositeExtract %u32_id %474 1
        %478 = OpIAdd %u32_id %468 %u32_id_104
        %479 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %480 = OpIAdd %u32_id %478 %479
        %481 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %480
        %482 = OpLoad %u64_id %481
        %483 = OpBitcast %u32vec2_id %482
        %484 = OpCompositeExtract %u32_id %483 0
        %485 = OpCompositeExtract %u32_id %483 1
        %487 = OpIAdd %u32_id %468 %u32_id_80
        %488 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %489 = OpIAdd %u32_id %487 %488
        %490 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %489
        %491 = OpLoad %u64_id %490
        %492 = OpBitcast %u32vec2_id %491
        %493 = OpCompositeExtract %u32_id %492 0
        %494 = OpCompositeExtract %u32_id %492 1
        %496 = OpIAdd %u32_id %468 %u32_id_88
        %497 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %498 = OpIAdd %u32_id %496 %497
        %499 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %498
        %500 = OpLoad %u64_id %499
        %501 = OpBitcast %u32vec2_id %500
        %502 = OpCompositeExtract %u32_id %501 0
        %503 = OpCompositeExtract %u32_id %501 1
        %504 = OpIAdd %u32_id %468 %u32_id_64
        %505 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %506 = OpIAdd %u32_id %504 %505
        %507 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %506
        %508 = OpLoad %u64_id %507
        %509 = OpBitcast %u32vec2_id %508
        %510 = OpCompositeExtract %u32_id %509 0
        %511 = OpCompositeExtract %u32_id %509 1
        %512 = OpIAdd %u32_id %468 %u32_id_72
        %513 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %514 = OpIAdd %u32_id %512 %513
        %515 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %514
        %516 = OpLoad %u64_id %515
        %517 = OpBitcast %u32vec2_id %516
        %518 = OpCompositeExtract %u32_id %517 0
        %519 = OpCompositeExtract %u32_id %517 1
        %520 = OpIAdd %u32_id %454 %u32_id_1
        %521 = OpBitcast %f32_id %485
        %522 = OpBitcast %f32_id %465
        %523 = OpFAdd %f32_id %521 %522
        %524 = OpBitcast %u32_id %523
        %525 = OpBitcast %f32_id %484
        %526 = OpBitcast %f32_id %466
        %527 = OpFAdd %f32_id %525 %526
        %528 = OpBitcast %u32_id %527
        %529 = OpBitcast %f32_id %476
        %530 = OpBitcast %f32_id %463
        %531 = OpFAdd %f32_id %529 %530
        %532 = OpBitcast %u32_id %531
        %533 = OpBitcast %f32_id %475
        %534 = OpBitcast %f32_id %464
        %535 = OpFAdd %f32_id %533 %534
        %536 = OpBitcast %u32_id %535
        %537 = OpBitcast %f32_id %503
        %538 = OpBitcast %f32_id %459
        %539 = OpFAdd %f32_id %537 %538
        %540 = OpBitcast %u32_id %539
        %541 = OpBitcast %f32_id %502
        %542 = OpBitcast %f32_id %460
        %543 = OpFAdd %f32_id %541 %542
        %544 = OpBitcast %u32_id %543
        %545 = OpBitcast %f32_id %494
        %546 = OpBitcast %f32_id %461
        %547 = OpFAdd %f32_id %545 %546
        %548 = OpBitcast %u32_id %547
        %549 = OpBitcast %f32_id %493
        %550 = OpBitcast %f32_id %462
        %551 = OpFAdd %f32_id %549 %550
        %552 = OpBitcast %u32_id %551
        %553 = OpBitcast %f32_id %519
        %554 = OpBitcast %f32_id %457
        %555 = OpFAdd %f32_id %553 %554
        %556 = OpBitcast %u32_id %555
        %557 = OpBitcast %f32_id %518
        %558 = OpBitcast %f32_id %458
        %559 = OpFAdd %f32_id %557 %558
        %560 = OpBitcast %u32_id %559
        %561 = OpBitcast %f32_id %511
        %562 = OpBitcast %f32_id %455
        %563 = OpFAdd %f32_id %561 %562
        %564 = OpBitcast %u32_id %563
        %565 = OpBitcast %f32_id %510
        %566 = OpBitcast %f32_id %456
        %567 = OpFAdd %f32_id %565 %566
        %568 = OpBitcast %u32_id %567
        %569 = OpIAdd %u32_id %467 %u32_id_1
        %571 = OpSLessThan %bool_id %467 %u32_id_63
               OpBranch %88
         %88 = OpLabel
               OpBranchConditional %571 %86 %89
         %89 = OpLabel
        %573 = OpShiftLeftLogical %u32_id %122 %u32_id_12
        %574 = OpCompositeConstruct %u32vec2_id %568 %564
        %575 = OpBitcast %u64_id %574
        %576 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %577 = OpIAdd %u32_id %573 %576
        %578 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %577
               OpStore %578 %575
        %579 = OpIAdd %u32_id %573 %u32_id_8
        %580 = OpCompositeConstruct %u32vec2_id %560 %556
        %581 = OpBitcast %u64_id %580
        %582 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %583 = OpIAdd %u32_id %579 %582
        %584 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %583
               OpStore %584 %581
        %585 = OpIAdd %u32_id %573 %u32_id_16
        %586 = OpCompositeConstruct %u32vec2_id %552 %548
        %587 = OpBitcast %u64_id %586
        %588 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %589 = OpIAdd %u32_id %585 %588
        %590 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %589
               OpStore %590 %587
        %591 = OpIAdd %u32_id %573 %u32_id_24
        %592 = OpCompositeConstruct %u32vec2_id %544 %540
        %593 = OpBitcast %u64_id %592
        %594 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %595 = OpIAdd %u32_id %591 %594
        %596 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %595
               OpStore %596 %593
        %597 = OpIAdd %u32_id %573 %u32_id_32
        %598 = OpCompositeConstruct %u32vec2_id %536 %532
        %599 = OpBitcast %u64_id %598
        %600 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %601 = OpIAdd %u32_id %597 %600
        %602 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %601
               OpStore %602 %599
        %603 = OpIAdd %u32_id %573 %u32_id_40
        %604 = OpCompositeConstruct %u32vec2_id %528 %524
        %605 = OpBitcast %u64_id %604
        %606 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %607 = OpIAdd %u32_id %603 %606
        %608 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %607
               OpStore %608 %605
        %609 = OpIAdd %u32_id %573 %u32_id_48
        %610 = OpBitcast %u64_id %437
        %611 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %612 = OpIAdd %u32_id %609 %611
        %613 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %612
               OpStore %613 %610
        %614 = OpIAdd %u32_id %573 %u32_id_56
        %615 = OpBitcast %u64_id %437
        %616 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %617 = OpIAdd %u32_id %614 %616
        %618 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %617
               OpStore %618 %615
               OpControlBarrier %u32_id_2 %u32_id_2 %u32_id_264
        %619 = OpIEqual %bool_id %u32_id_0 %122
        %620 = OpLogicalAnd %bool_id %452 %619
               OpSelectionMerge %91 None
               OpBranchConditional %620 %90 %91
         %90 = OpLabel
        %621 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %623 = OpIAdd %u32_id %621 %u32_id_4096
        %624 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %623
        %625 = OpLoad %u64_id %624
        %626 = OpBitcast %u32vec2_id %625
        %627 = OpCompositeExtract %u32_id %626 0
        %628 = OpCompositeExtract %u32_id %626 1
        %629 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %631 = OpIAdd %u32_id %629 %u32_id_4104
        %632 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %631
        %633 = OpLoad %u64_id %632
        %634 = OpBitcast %u32vec2_id %633
        %635 = OpCompositeExtract %u32_id %634 0
        %636 = OpCompositeExtract %u32_id %634 1
        %637 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %639 = OpIAdd %u32_id %637 %u32_id_8192
        %640 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %639
        %641 = OpLoad %u64_id %640
        %642 = OpBitcast %u32vec2_id %641
        %643 = OpCompositeExtract %u32_id %642 0
        %644 = OpCompositeExtract %u32_id %642 1
        %645 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %647 = OpIAdd %u32_id %645 %u32_id_8200
        %648 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %647
        %649 = OpLoad %u64_id %648
        %650 = OpBitcast %u32vec2_id %649
        %651 = OpCompositeExtract %u32_id %650 0
        %652 = OpCompositeExtract %u32_id %650 1
        %653 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %655 = OpIAdd %u32_id %653 %u32_id_12288
        %656 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %655
        %657 = OpLoad %u64_id %656
        %658 = OpBitcast %u32vec2_id %657
        %659 = OpCompositeExtract %u32_id %658 0
        %660 = OpCompositeExtract %u32_id %658 1
        %661 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %663 = OpIAdd %u32_id %661 %u32_id_12296
        %664 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %663
        %665 = OpLoad %u64_id %664
        %666 = OpBitcast %u32vec2_id %665
        %667 = OpCompositeExtract %u32_id %666 0
        %668 = OpCompositeExtract %u32_id %666 1
        %669 = OpBitcast %f32_id %627
        %670 = OpBitcast %f32_id %643
        %671 = OpFAdd %f32_id %669 %670
        %672 = OpBitcast %f32_id %636
        %673 = OpBitcast %f32_id %652
        %674 = OpFAdd %f32_id %672 %673
        %675 = OpBitcast %f32_id %635
        %676 = OpBitcast %f32_id %651
        %677 = OpFAdd %f32_id %675 %676
        %678 = OpBitcast %f32_id %628
        %679 = OpBitcast %f32_id %644
        %680 = OpFAdd %f32_id %678 %679
        %681 = OpBitcast %f32_id %659
        %682 = OpFAdd %f32_id %671 %681
        %683 = OpBitcast %f32_id %668
        %684 = OpFAdd %f32_id %674 %683
        %685 = OpBitcast %f32_id %667
        %686 = OpFAdd %f32_id %677 %685
        %687 = OpBitcast %f32_id %660
        %688 = OpFAdd %f32_id %680 %687
        %689 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %691 = OpIAdd %u32_id %689 %u32_id_16384
        %692 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %691
        %693 = OpLoad %u64_id %692
        %694 = OpBitcast %u32vec2_id %693
        %695 = OpCompositeExtract %u32_id %694 0
        %696 = OpCompositeExtract %u32_id %694 1
        %697 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %699 = OpIAdd %u32_id %697 %u32_id_16392
        %700 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %699
        %701 = OpLoad %u64_id %700
        %702 = OpBitcast %u32vec2_id %701
        %703 = OpCompositeExtract %u32_id %702 0
        %704 = OpCompositeExtract %u32_id %702 1
        %705 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %707 = OpIAdd %u32_id %705 %u32_id_20480
        %708 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %707
        %709 = OpLoad %u64_id %708
        %710 = OpBitcast %u32vec2_id %709
        %711 = OpCompositeExtract %u32_id %710 0
        %712 = OpCompositeExtract %u32_id %710 1
        %713 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %715 = OpIAdd %u32_id %713 %u32_id_20488
        %716 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %715
        %717 = OpLoad %u64_id %716
        %718 = OpBitcast %u32vec2_id %717
        %719 = OpCompositeExtract %u32_id %718 0
        %720 = OpCompositeExtract %u32_id %718 1
        %721 = OpBitcast %f32_id %695
        %722 = OpFAdd %f32_id %682 %721
        %723 = OpBitcast %f32_id %704
        %724 = OpFAdd %f32_id %684 %723
        %725 = OpBitcast %f32_id %703
        %726 = OpFAdd %f32_id %686 %725
        %727 = OpBitcast %f32_id %696
        %728 = OpFAdd %f32_id %688 %727
        %729 = OpBitcast %f32_id %711
        %730 = OpFAdd %f32_id %722 %729
        %731 = OpBitcast %f32_id %720
        %732 = OpFAdd %f32_id %724 %731
        %733 = OpBitcast %f32_id %719
        %734 = OpFAdd %f32_id %726 %733
        %735 = OpBitcast %f32_id %712
        %736 = OpFAdd %f32_id %728 %735
        %737 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %739 = OpIAdd %u32_id %737 %u32_id_24576
        %740 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %739
        %741 = OpLoad %u64_id %740
        %742 = OpBitcast %u32vec2_id %741
        %743 = OpCompositeExtract %u32_id %742 0
        %744 = OpCompositeExtract %u32_id %742 1
        %745 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %747 = OpIAdd %u32_id %745 %u32_id_24584
        %748 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %747
        %749 = OpLoad %u64_id %748
        %750 = OpBitcast %u32vec2_id %749
        %751 = OpCompositeExtract %u32_id %750 0
        %752 = OpCompositeExtract %u32_id %750 1
        %753 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %755 = OpIAdd %u32_id %753 %u32_id_28672
        %756 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %755
        %757 = OpLoad %u64_id %756
        %758 = OpBitcast %u32vec2_id %757
        %759 = OpCompositeExtract %u32_id %758 0
        %760 = OpCompositeExtract %u32_id %758 1
        %761 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %763 = OpIAdd %u32_id %761 %u32_id_28680
        %764 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %763
        %765 = OpLoad %u64_id %764
        %766 = OpBitcast %u32vec2_id %765
        %767 = OpCompositeExtract %u32_id %766 0
        %768 = OpCompositeExtract %u32_id %766 1
        %769 = OpBitcast %f32_id %743
        %770 = OpFAdd %f32_id %730 %769
        %771 = OpBitcast %f32_id %752
        %772 = OpFAdd %f32_id %732 %771
        %773 = OpBitcast %f32_id %751
        %774 = OpFAdd %f32_id %734 %773
        %775 = OpBitcast %f32_id %744
        %776 = OpFAdd %f32_id %736 %775
        %777 = OpBitcast %f32_id %759
        %778 = OpFAdd %f32_id %770 %777
        %779 = OpBitcast %f32_id %768
        %780 = OpFAdd %f32_id %772 %779
        %781 = OpBitcast %f32_id %767
        %782 = OpFAdd %f32_id %774 %781
        %783 = OpBitcast %f32_id %760
        %784 = OpFAdd %f32_id %776 %783
        %785 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %787 = OpIAdd %u32_id %785 %u32_id_32768
        %788 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %787
        %789 = OpLoad %u64_id %788
        %790 = OpBitcast %u32vec2_id %789
        %791 = OpCompositeExtract %u32_id %790 0
        %792 = OpCompositeExtract %u32_id %790 1
        %793 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %795 = OpIAdd %u32_id %793 %u32_id_32776
        %796 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %795
        %797 = OpLoad %u64_id %796
        %798 = OpBitcast %u32vec2_id %797
        %799 = OpCompositeExtract %u32_id %798 0
        %800 = OpCompositeExtract %u32_id %798 1
        %801 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %803 = OpIAdd %u32_id %801 %u32_id_36864
        %804 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %803
        %805 = OpLoad %u64_id %804
        %806 = OpBitcast %u32vec2_id %805
        %807 = OpCompositeExtract %u32_id %806 0
        %808 = OpCompositeExtract %u32_id %806 1
        %809 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %811 = OpIAdd %u32_id %809 %u32_id_36872
        %812 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %811
        %813 = OpLoad %u64_id %812
        %814 = OpBitcast %u32vec2_id %813
        %815 = OpCompositeExtract %u32_id %814 0
        %816 = OpCompositeExtract %u32_id %814 1
        %817 = OpBitcast %f32_id %791
        %818 = OpFAdd %f32_id %778 %817
        %819 = OpBitcast %f32_id %800
        %820 = OpFAdd %f32_id %780 %819
        %821 = OpBitcast %f32_id %799
        %822 = OpFAdd %f32_id %782 %821
        %823 = OpBitcast %f32_id %792
        %824 = OpFAdd %f32_id %784 %823
        %825 = OpBitcast %f32_id %807
        %826 = OpFAdd %f32_id %818 %825
        %827 = OpBitcast %f32_id %816
        %828 = OpFAdd %f32_id %820 %827
        %829 = OpBitcast %f32_id %815
        %830 = OpFAdd %f32_id %822 %829
        %831 = OpBitcast %f32_id %808
        %832 = OpFAdd %f32_id %824 %831
        %833 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %835 = OpIAdd %u32_id %833 %u32_id_40960
        %836 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %835
        %837 = OpLoad %u64_id %836
        %838 = OpBitcast %u32vec2_id %837
        %839 = OpCompositeExtract %u32_id %838 0
        %840 = OpCompositeExtract %u32_id %838 1
        %841 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %843 = OpIAdd %u32_id %841 %u32_id_40968
        %844 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %843
        %845 = OpLoad %u64_id %844
        %846 = OpBitcast %u32vec2_id %845
        %847 = OpCompositeExtract %u32_id %846 0
        %848 = OpCompositeExtract %u32_id %846 1
        %849 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %851 = OpIAdd %u32_id %849 %u32_id_45056
        %852 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %851
        %853 = OpLoad %u64_id %852
        %854 = OpBitcast %u32vec2_id %853
        %855 = OpCompositeExtract %u32_id %854 0
        %856 = OpCompositeExtract %u32_id %854 1
        %857 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %859 = OpIAdd %u32_id %857 %u32_id_45064
        %860 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %859
        %861 = OpLoad %u64_id %860
        %862 = OpBitcast %u32vec2_id %861
        %863 = OpCompositeExtract %u32_id %862 0
        %864 = OpCompositeExtract %u32_id %862 1
        %865 = OpBitcast %f32_id %839
        %866 = OpFAdd %f32_id %826 %865
        %867 = OpBitcast %f32_id %848
        %868 = OpFAdd %f32_id %828 %867
        %869 = OpBitcast %f32_id %847
        %870 = OpFAdd %f32_id %830 %869
        %871 = OpBitcast %f32_id %840
        %872 = OpFAdd %f32_id %832 %871
        %873 = OpBitcast %f32_id %863
        %874 = OpFAdd %f32_id %870 %873
        %875 = OpBitcast %f32_id %856
        %876 = OpFAdd %f32_id %872 %875
        %877 = OpBitcast %f32_id %855
        %878 = OpFAdd %f32_id %866 %877
        %879 = OpBitcast %f32_id %864
        %880 = OpFAdd %f32_id %868 %879
        %881 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %883 = OpIAdd %u32_id %881 %u32_id_49152
        %884 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %883
        %885 = OpLoad %u64_id %884
        %886 = OpBitcast %u32vec2_id %885
        %887 = OpCompositeExtract %u32_id %886 0
        %888 = OpCompositeExtract %u32_id %886 1
        %889 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %891 = OpIAdd %u32_id %889 %u32_id_49160
        %892 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %891
        %893 = OpLoad %u64_id %892
        %894 = OpBitcast %u32vec2_id %893
        %895 = OpCompositeExtract %u32_id %894 0
        %896 = OpCompositeExtract %u32_id %894 1
        %897 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %899 = OpIAdd %u32_id %897 %u32_id_53248
        %900 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %899
        %901 = OpLoad %u64_id %900
        %902 = OpBitcast %u32vec2_id %901
        %903 = OpCompositeExtract %u32_id %902 0
        %904 = OpCompositeExtract %u32_id %902 1
        %905 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %907 = OpIAdd %u32_id %905 %u32_id_53256
        %908 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %907
        %909 = OpLoad %u64_id %908
        %910 = OpBitcast %u32vec2_id %909
        %911 = OpCompositeExtract %u32_id %910 0
        %912 = OpCompositeExtract %u32_id %910 1
        %914 = OpIAdd %u32_id %u32_id_73 %buf0_dword_off
        %915 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %914
        %916 = OpLoad %u32_id %915
        %918 = OpIAdd %u32_id %u32_id_74 %buf0_dword_off
        %919 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %918
        %920 = OpLoad %u32_id %919
        %921 = OpBitcast %f32_id %895
        %922 = OpFAdd %f32_id %874 %921
        %923 = OpBitcast %f32_id %888
        %924 = OpFAdd %f32_id %876 %923
        %925 = OpBitcast %f32_id %904
        %926 = OpFAdd %f32_id %924 %925
        %927 = OpBitcast %f32_id %887
        %928 = OpFAdd %f32_id %878 %927
        %929 = OpBitcast %f32_id %896
        %930 = OpFAdd %f32_id %880 %929
        %931 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %933 = OpIAdd %u32_id %931 %u32_id_57344
        %934 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %933
        %935 = OpLoad %u64_id %934
        %936 = OpBitcast %u32vec2_id %935
        %937 = OpCompositeExtract %u32_id %936 0
        %938 = OpCompositeExtract %u32_id %936 1
        %939 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %941 = OpIAdd %u32_id %939 %u32_id_57352
        %942 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %941
        %943 = OpLoad %u64_id %942
        %944 = OpBitcast %u32vec2_id %943
        %945 = OpCompositeExtract %u32_id %944 0
        %946 = OpCompositeExtract %u32_id %944 1
        %947 = OpBitcast %f32_id %903
        %948 = OpFAdd %f32_id %928 %947
        %949 = OpBitcast %f32_id %912
        %950 = OpFAdd %f32_id %930 %949
        %951 = OpBitcast %f32_id %911
        %952 = OpFAdd %f32_id %922 %951
        %953 = OpBitcast %f32_id %937
        %954 = OpFAdd %f32_id %948 %953
        %955 = OpBitcast %f32_id %946
        %956 = OpFAdd %f32_id %950 %955
        %957 = OpBitcast %f32_id %938
        %958 = OpFAdd %f32_id %926 %957
        %959 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %961 = OpIAdd %u32_id %959 %u32_id_61440
        %962 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %961
        %963 = OpLoad %u64_id %962
        %964 = OpBitcast %u32vec2_id %963
        %965 = OpCompositeExtract %u32_id %964 0
        %966 = OpCompositeExtract %u32_id %964 1
        %967 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %969 = OpIAdd %u32_id %967 %u32_id_61448
        %970 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %969
        %971 = OpLoad %u64_id %970
        %972 = OpBitcast %u32vec2_id %971
        %973 = OpCompositeExtract %u32_id %972 0
        %974 = OpCompositeExtract %u32_id %972 1
        %975 = OpBitcast %f32_id %945
        %976 = OpFAdd %f32_id %952 %975
        %978 = OpIAdd %u32_id %u32_id_75 %buf0_dword_off
        %979 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %978
        %980 = OpLoad %u32_id %979
        %981 = OpBitcast %f32_id %965
        %982 = OpFAdd %f32_id %954 %981
        %983 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %985 = OpIAdd %u32_id %983 %u32_id_4112
        %986 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %985
        %987 = OpLoad %u64_id %986
        %988 = OpBitcast %u32vec2_id %987
        %989 = OpCompositeExtract %u32_id %988 0
        %990 = OpCompositeExtract %u32_id %988 1
        %991 = OpIMul %u32_id %workgroup_index %u32_id_65536
        %993 = OpIAdd %u32_id %991 %u32_id_4120
        %994 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %993
        %995 = OpLoad %u64_id %994
        %996 = OpBitcast %u32vec2_id %995
        %997 = OpCompositeExtract %u32_id %996 0
        %998 = OpCompositeExtract %u32_id %996 1
        %999 = OpBitcast %f32_id %974
       %1000 = OpFAdd %f32_id %956 %999
       %1001 = OpFAdd %f32_id %982 %567
       %1002 = OpBitcast %f32_id %966
       %1003 = OpFAdd %f32_id %958 %1002
       %1004 = OpBitcast %f32_id %973
       %1005 = OpFAdd %f32_id %976 %1004
       %1006 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1008 = OpIAdd %u32_id %1006 %u32_id_8208
       %1009 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1008
       %1010 = OpLoad %u64_id %1009
       %1011 = OpBitcast %u32vec2_id %1010
       %1012 = OpCompositeExtract %u32_id %1011 0
       %1013 = OpCompositeExtract %u32_id %1011 1
       %1014 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1016 = OpIAdd %u32_id %1014 %u32_id_8216
       %1017 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1016
       %1018 = OpLoad %u64_id %1017
       %1019 = OpBitcast %u32vec2_id %1018
       %1020 = OpCompositeExtract %u32_id %1019 0
       %1021 = OpCompositeExtract %u32_id %1019 1
       %1022 = OpFAdd %f32_id %1000 %555
       %1023 = OpBitcast %f32_id %989
       %1024 = OpBitcast %f32_id %1012
       %1025 = OpFAdd %f32_id %1023 %1024
       %1026 = OpBitcast %f32_id %998
       %1027 = OpBitcast %f32_id %1021
       %1028 = OpFAdd %f32_id %1026 %1027
       %1029 = OpBitcast %f32_id %997
       %1030 = OpBitcast %f32_id %1020
       %1031 = OpFAdd %f32_id %1029 %1030
       %1032 = OpBitcast %f32_id %990
       %1033 = OpBitcast %f32_id %1013
       %1034 = OpFAdd %f32_id %1032 %1033
       %1035 = OpFAdd %f32_id %1005 %559
       %1036 = OpFAdd %f32_id %1003 %563
       %1037 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1039 = OpIAdd %u32_id %1037 %u32_id_12304
       %1040 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1039
       %1041 = OpLoad %u64_id %1040
       %1042 = OpBitcast %u32vec2_id %1041
       %1043 = OpCompositeExtract %u32_id %1042 0
       %1044 = OpCompositeExtract %u32_id %1042 1
       %1045 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1047 = OpIAdd %u32_id %1045 %u32_id_12312
       %1048 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1047
       %1049 = OpLoad %u64_id %1048
       %1050 = OpBitcast %u32vec2_id %1049
       %1051 = OpCompositeExtract %u32_id %1050 0
       %1052 = OpCompositeExtract %u32_id %1050 1
       %1053 = OpBitcast %f32_id %1043
       %1054 = OpFAdd %f32_id %1025 %1053
       %1055 = OpBitcast %f32_id %1052
       %1056 = OpFAdd %f32_id %1028 %1055
       %1057 = OpBitcast %f32_id %1051
       %1058 = OpFAdd %f32_id %1031 %1057
       %1059 = OpBitcast %f32_id %1044
       %1060 = OpFAdd %f32_id %1034 %1059
       %1061 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1063 = OpIAdd %u32_id %1061 %u32_id_16400
       %1064 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1063
       %1065 = OpLoad %u64_id %1064
       %1066 = OpBitcast %u32vec2_id %1065
       %1067 = OpCompositeExtract %u32_id %1066 0
       %1068 = OpCompositeExtract %u32_id %1066 1
       %1069 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1071 = OpIAdd %u32_id %1069 %u32_id_16408
       %1072 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1071
       %1073 = OpLoad %u64_id %1072
       %1074 = OpBitcast %u32vec2_id %1073
       %1075 = OpCompositeExtract %u32_id %1074 0
       %1076 = OpCompositeExtract %u32_id %1074 1
       %1077 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1079 = OpIAdd %u32_id %1077 %u32_id_20496
       %1080 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1079
       %1081 = OpLoad %u64_id %1080
       %1082 = OpBitcast %u32vec2_id %1081
       %1083 = OpCompositeExtract %u32_id %1082 0
       %1084 = OpCompositeExtract %u32_id %1082 1
       %1085 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1087 = OpIAdd %u32_id %1085 %u32_id_20504
       %1088 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1087
       %1089 = OpLoad %u64_id %1088
       %1090 = OpBitcast %u32vec2_id %1089
       %1091 = OpCompositeExtract %u32_id %1090 0
       %1092 = OpCompositeExtract %u32_id %1090 1
       %1093 = OpBitcast %f32_id %1067
       %1094 = OpFAdd %f32_id %1054 %1093
       %1095 = OpBitcast %f32_id %1076
       %1096 = OpFAdd %f32_id %1056 %1095
       %1097 = OpBitcast %f32_id %1075
       %1098 = OpFAdd %f32_id %1058 %1097
       %1099 = OpBitcast %f32_id %1068
       %1100 = OpFAdd %f32_id %1060 %1099
       %1101 = OpBitcast %f32_id %1083
       %1102 = OpFAdd %f32_id %1094 %1101
       %1103 = OpBitcast %f32_id %1092
       %1104 = OpFAdd %f32_id %1096 %1103
       %1105 = OpBitcast %f32_id %1091
       %1106 = OpFAdd %f32_id %1098 %1105
       %1107 = OpBitcast %f32_id %1084
       %1108 = OpFAdd %f32_id %1100 %1107
       %1109 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1111 = OpIAdd %u32_id %1109 %u32_id_24592
       %1112 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1111
       %1113 = OpLoad %u64_id %1112
       %1114 = OpBitcast %u32vec2_id %1113
       %1115 = OpCompositeExtract %u32_id %1114 0
       %1116 = OpCompositeExtract %u32_id %1114 1
       %1117 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1119 = OpIAdd %u32_id %1117 %u32_id_24600
       %1120 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1119
       %1121 = OpLoad %u64_id %1120
       %1122 = OpBitcast %u32vec2_id %1121
       %1123 = OpCompositeExtract %u32_id %1122 0
       %1124 = OpCompositeExtract %u32_id %1122 1
       %1125 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1127 = OpIAdd %u32_id %1125 %u32_id_28688
       %1128 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1127
       %1129 = OpLoad %u64_id %1128
       %1130 = OpBitcast %u32vec2_id %1129
       %1131 = OpCompositeExtract %u32_id %1130 0
       %1132 = OpCompositeExtract %u32_id %1130 1
       %1133 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1135 = OpIAdd %u32_id %1133 %u32_id_28696
       %1136 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1135
       %1137 = OpLoad %u64_id %1136
       %1138 = OpBitcast %u32vec2_id %1137
       %1139 = OpCompositeExtract %u32_id %1138 0
       %1140 = OpCompositeExtract %u32_id %1138 1
       %1141 = OpBitcast %f32_id %1115
       %1142 = OpFAdd %f32_id %1102 %1141
       %1143 = OpBitcast %f32_id %1124
       %1144 = OpFAdd %f32_id %1104 %1143
       %1145 = OpBitcast %f32_id %1123
       %1146 = OpFAdd %f32_id %1106 %1145
       %1147 = OpBitcast %f32_id %1116
       %1148 = OpFAdd %f32_id %1108 %1147
       %1149 = OpBitcast %f32_id %1131
       %1150 = OpFAdd %f32_id %1142 %1149
       %1151 = OpBitcast %f32_id %1140
       %1152 = OpFAdd %f32_id %1144 %1151
       %1153 = OpBitcast %f32_id %1139
       %1154 = OpFAdd %f32_id %1146 %1153
       %1155 = OpBitcast %f32_id %1132
       %1156 = OpFAdd %f32_id %1148 %1155
       %1157 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1159 = OpIAdd %u32_id %1157 %u32_id_32784
       %1160 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1159
       %1161 = OpLoad %u64_id %1160
       %1162 = OpBitcast %u32vec2_id %1161
       %1163 = OpCompositeExtract %u32_id %1162 0
       %1164 = OpCompositeExtract %u32_id %1162 1
       %1165 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1167 = OpIAdd %u32_id %1165 %u32_id_32792
       %1168 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1167
       %1169 = OpLoad %u64_id %1168
       %1170 = OpBitcast %u32vec2_id %1169
       %1171 = OpCompositeExtract %u32_id %1170 0
       %1172 = OpCompositeExtract %u32_id %1170 1
       %1173 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1175 = OpIAdd %u32_id %1173 %u32_id_36880
       %1176 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1175
       %1177 = OpLoad %u64_id %1176
       %1178 = OpBitcast %u32vec2_id %1177
       %1179 = OpCompositeExtract %u32_id %1178 0
       %1180 = OpCompositeExtract %u32_id %1178 1
       %1181 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1183 = OpIAdd %u32_id %1181 %u32_id_36888
       %1184 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1183
       %1185 = OpLoad %u64_id %1184
       %1186 = OpBitcast %u32vec2_id %1185
       %1187 = OpCompositeExtract %u32_id %1186 0
       %1188 = OpCompositeExtract %u32_id %1186 1
       %1189 = OpBitcast %f32_id %1163
       %1190 = OpFAdd %f32_id %1150 %1189
       %1191 = OpBitcast %f32_id %1172
       %1192 = OpFAdd %f32_id %1152 %1191
       %1193 = OpBitcast %f32_id %1171
       %1194 = OpFAdd %f32_id %1154 %1193
       %1195 = OpBitcast %f32_id %1164
       %1196 = OpFAdd %f32_id %1156 %1195
       %1197 = OpBitcast %f32_id %1179
       %1198 = OpFAdd %f32_id %1190 %1197
       %1199 = OpBitcast %f32_id %1188
       %1200 = OpFAdd %f32_id %1192 %1199
       %1201 = OpBitcast %f32_id %1187
       %1202 = OpFAdd %f32_id %1194 %1201
       %1203 = OpBitcast %f32_id %1180
       %1204 = OpFAdd %f32_id %1196 %1203
       %1205 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1207 = OpIAdd %u32_id %1205 %u32_id_40976
       %1208 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1207
       %1209 = OpLoad %u64_id %1208
       %1210 = OpBitcast %u32vec2_id %1209
       %1211 = OpCompositeExtract %u32_id %1210 0
       %1212 = OpCompositeExtract %u32_id %1210 1
       %1213 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1215 = OpIAdd %u32_id %1213 %u32_id_40984
       %1216 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1215
       %1217 = OpLoad %u64_id %1216
       %1218 = OpBitcast %u32vec2_id %1217
       %1219 = OpCompositeExtract %u32_id %1218 0
       %1220 = OpCompositeExtract %u32_id %1218 1
       %1221 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1223 = OpIAdd %u32_id %1221 %u32_id_45072
       %1224 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1223
       %1225 = OpLoad %u64_id %1224
       %1226 = OpBitcast %u32vec2_id %1225
       %1227 = OpCompositeExtract %u32_id %1226 0
       %1228 = OpCompositeExtract %u32_id %1226 1
       %1229 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1231 = OpIAdd %u32_id %1229 %u32_id_45080
       %1232 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1231
       %1233 = OpLoad %u64_id %1232
       %1234 = OpBitcast %u32vec2_id %1233
       %1235 = OpCompositeExtract %u32_id %1234 0
       %1236 = OpCompositeExtract %u32_id %1234 1
       %1237 = OpBitcast %f32_id %1211
       %1238 = OpFAdd %f32_id %1198 %1237
       %1239 = OpBitcast %f32_id %1220
       %1240 = OpFAdd %f32_id %1200 %1239
       %1241 = OpBitcast %f32_id %1219
       %1242 = OpFAdd %f32_id %1202 %1241
       %1243 = OpBitcast %f32_id %1212
       %1244 = OpFAdd %f32_id %1204 %1243
       %1245 = OpBitcast %f32_id %1236
       %1246 = OpFAdd %f32_id %1240 %1245
       %1247 = OpBitcast %f32_id %1235
       %1248 = OpFAdd %f32_id %1242 %1247
       %1249 = OpBitcast %f32_id %1228
       %1250 = OpFAdd %f32_id %1244 %1249
       %1251 = OpBitcast %f32_id %1227
       %1252 = OpFAdd %f32_id %1238 %1251
       %1253 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1255 = OpIAdd %u32_id %1253 %u32_id_49168
       %1256 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1255
       %1257 = OpLoad %u64_id %1256
       %1258 = OpBitcast %u32vec2_id %1257
       %1259 = OpCompositeExtract %u32_id %1258 0
       %1260 = OpCompositeExtract %u32_id %1258 1
       %1261 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1263 = OpIAdd %u32_id %1261 %u32_id_49176
       %1264 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1263
       %1265 = OpLoad %u64_id %1264
       %1266 = OpBitcast %u32vec2_id %1265
       %1267 = OpCompositeExtract %u32_id %1266 0
       %1268 = OpCompositeExtract %u32_id %1266 1
       %1269 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1271 = OpIAdd %u32_id %1269 %u32_id_53264
       %1272 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1271
       %1273 = OpLoad %u64_id %1272
       %1274 = OpBitcast %u32vec2_id %1273
       %1275 = OpCompositeExtract %u32_id %1274 0
       %1276 = OpCompositeExtract %u32_id %1274 1
       %1277 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1279 = OpIAdd %u32_id %1277 %u32_id_53272
       %1280 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1279
       %1281 = OpLoad %u64_id %1280
       %1282 = OpBitcast %u32vec2_id %1281
       %1283 = OpCompositeExtract %u32_id %1282 0
       %1284 = OpCompositeExtract %u32_id %1282 1
       %1285 = OpBitcast %f32_id %1267
       %1286 = OpFAdd %f32_id %1248 %1285
       %1287 = OpBitcast %f32_id %1260
       %1288 = OpFAdd %f32_id %1250 %1287
       %1289 = OpBitcast %f32_id %1259
       %1290 = OpFAdd %f32_id %1252 %1289
       %1291 = OpBitcast %f32_id %1268
       %1292 = OpFAdd %f32_id %1246 %1291
       %1293 = OpBitcast %f32_id %1275
       %1294 = OpFAdd %f32_id %1290 %1293
       %1295 = OpBitcast %f32_id %1276
       %1296 = OpFAdd %f32_id %1288 %1295
       %1297 = OpBitcast %f32_id %1284
       %1298 = OpFAdd %f32_id %1292 %1297
       %1299 = OpBitcast %f32_id %1283
       %1300 = OpFAdd %f32_id %1286 %1299
       %1301 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1303 = OpIAdd %u32_id %1301 %u32_id_57360
       %1304 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1303
       %1305 = OpLoad %u64_id %1304
       %1306 = OpBitcast %u32vec2_id %1305
       %1307 = OpCompositeExtract %u32_id %1306 0
       %1308 = OpCompositeExtract %u32_id %1306 1
       %1309 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1311 = OpIAdd %u32_id %1309 %u32_id_57368
       %1312 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1311
       %1313 = OpLoad %u64_id %1312
       %1314 = OpBitcast %u32vec2_id %1313
       %1315 = OpCompositeExtract %u32_id %1314 0
       %1316 = OpCompositeExtract %u32_id %1314 1
       %1317 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1319 = OpIAdd %u32_id %1317 %u32_id_61456
       %1320 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1319
       %1321 = OpLoad %u64_id %1320
       %1322 = OpBitcast %u32vec2_id %1321
       %1323 = OpCompositeExtract %u32_id %1322 0
       %1324 = OpCompositeExtract %u32_id %1322 1
       %1325 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1327 = OpIAdd %u32_id %1325 %u32_id_61464
       %1328 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1327
       %1329 = OpLoad %u64_id %1328
       %1330 = OpBitcast %u32vec2_id %1329
       %1331 = OpCompositeExtract %u32_id %1330 0
       %1332 = OpCompositeExtract %u32_id %1330 1
       %1333 = OpBitcast %f32_id %1307
       %1334 = OpFAdd %f32_id %1294 %1333
       %1335 = OpBitcast %f32_id %1315
       %1336 = OpFAdd %f32_id %1300 %1335
       %1337 = OpBitcast %f32_id %1331
       %1338 = OpFAdd %f32_id %1336 %1337
       %1339 = OpBitcast %f32_id %1323
       %1340 = OpFAdd %f32_id %1334 %1339
       %1341 = OpBitcast %f32_id %1308
       %1342 = OpFAdd %f32_id %1296 %1341
       %1343 = OpBitcast %f32_id %1324
       %1344 = OpFAdd %f32_id %1342 %1343
       %1345 = OpBitcast %f32_id %1316
       %1346 = OpFAdd %f32_id %1298 %1345
       %1347 = OpBitcast %f32_id %1332
       %1348 = OpFAdd %f32_id %1346 %1347
       %1349 = OpFAdd %f32_id %1340 %551
       %1350 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1352 = OpIAdd %u32_id %1350 %u32_id_4128
       %1353 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1352
       %1354 = OpLoad %u64_id %1353
       %1355 = OpBitcast %u32vec2_id %1354
       %1356 = OpCompositeExtract %u32_id %1355 0
       %1357 = OpCompositeExtract %u32_id %1355 1
       %1358 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1360 = OpIAdd %u32_id %1358 %u32_id_4136
       %1361 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1360
       %1362 = OpLoad %u64_id %1361
       %1363 = OpBitcast %u32vec2_id %1362
       %1364 = OpCompositeExtract %u32_id %1363 0
       %1365 = OpCompositeExtract %u32_id %1363 1
       %1366 = OpFAdd %f32_id %1348 %539
       %1367 = OpFAdd %f32_id %1338 %543
       %1368 = OpFAdd %f32_id %1344 %547
       %1369 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1371 = OpIAdd %u32_id %1369 %u32_id_8224
       %1372 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1371
       %1373 = OpLoad %u64_id %1372
       %1374 = OpBitcast %u32vec2_id %1373
       %1375 = OpCompositeExtract %u32_id %1374 0
       %1376 = OpCompositeExtract %u32_id %1374 1
       %1377 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1379 = OpIAdd %u32_id %1377 %u32_id_8232
       %1380 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1379
       %1381 = OpLoad %u64_id %1380
       %1382 = OpBitcast %u32vec2_id %1381
       %1383 = OpCompositeExtract %u32_id %1382 0
       %1384 = OpCompositeExtract %u32_id %1382 1
       %1385 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1387 = OpIAdd %u32_id %1385 %u32_id_12320
       %1388 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1387
       %1389 = OpLoad %u64_id %1388
       %1390 = OpBitcast %u32vec2_id %1389
       %1391 = OpCompositeExtract %u32_id %1390 0
       %1392 = OpCompositeExtract %u32_id %1390 1
       %1393 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1395 = OpIAdd %u32_id %1393 %u32_id_12328
       %1396 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1395
       %1397 = OpLoad %u64_id %1396
       %1398 = OpBitcast %u32vec2_id %1397
       %1399 = OpCompositeExtract %u32_id %1398 0
       %1400 = OpCompositeExtract %u32_id %1398 1
       %1401 = OpBitcast %f32_id %1356
       %1402 = OpBitcast %f32_id %1375
       %1403 = OpFAdd %f32_id %1401 %1402
       %1404 = OpBitcast %f32_id %1365
       %1405 = OpBitcast %f32_id %1384
       %1406 = OpFAdd %f32_id %1404 %1405
       %1407 = OpBitcast %f32_id %1364
       %1408 = OpBitcast %f32_id %1383
       %1409 = OpFAdd %f32_id %1407 %1408
       %1410 = OpBitcast %f32_id %1357
       %1411 = OpBitcast %f32_id %1376
       %1412 = OpFAdd %f32_id %1410 %1411
       %1413 = OpBitcast %f32_id %1391
       %1414 = OpFAdd %f32_id %1403 %1413
       %1415 = OpBitcast %f32_id %1400
       %1416 = OpFAdd %f32_id %1406 %1415
       %1417 = OpBitcast %f32_id %1399
       %1418 = OpFAdd %f32_id %1409 %1417
       %1419 = OpBitcast %f32_id %1392
       %1420 = OpFAdd %f32_id %1412 %1419
       %1421 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1423 = OpIAdd %u32_id %1421 %u32_id_16416
       %1424 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1423
       %1425 = OpLoad %u64_id %1424
       %1426 = OpBitcast %u32vec2_id %1425
       %1427 = OpCompositeExtract %u32_id %1426 0
       %1428 = OpCompositeExtract %u32_id %1426 1
       %1429 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1431 = OpIAdd %u32_id %1429 %u32_id_16424
       %1432 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1431
       %1433 = OpLoad %u64_id %1432
       %1434 = OpBitcast %u32vec2_id %1433
       %1435 = OpCompositeExtract %u32_id %1434 0
       %1436 = OpCompositeExtract %u32_id %1434 1
       %1437 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1439 = OpIAdd %u32_id %1437 %u32_id_20512
       %1440 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1439
       %1441 = OpLoad %u64_id %1440
       %1442 = OpBitcast %u32vec2_id %1441
       %1443 = OpCompositeExtract %u32_id %1442 0
       %1444 = OpCompositeExtract %u32_id %1442 1
       %1445 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1447 = OpIAdd %u32_id %1445 %u32_id_20520
       %1448 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1447
       %1449 = OpLoad %u64_id %1448
       %1450 = OpBitcast %u32vec2_id %1449
       %1451 = OpCompositeExtract %u32_id %1450 0
       %1452 = OpCompositeExtract %u32_id %1450 1
       %1453 = OpBitcast %f32_id %1427
       %1454 = OpFAdd %f32_id %1414 %1453
       %1455 = OpBitcast %f32_id %1436
       %1456 = OpFAdd %f32_id %1416 %1455
       %1457 = OpBitcast %f32_id %1435
       %1458 = OpFAdd %f32_id %1418 %1457
       %1459 = OpBitcast %f32_id %1428
       %1460 = OpFAdd %f32_id %1420 %1459
       %1461 = OpBitcast %f32_id %1443
       %1462 = OpFAdd %f32_id %1454 %1461
       %1463 = OpBitcast %f32_id %1452
       %1464 = OpFAdd %f32_id %1456 %1463
       %1465 = OpBitcast %f32_id %1451
       %1466 = OpFAdd %f32_id %1458 %1465
       %1467 = OpBitcast %f32_id %1444
       %1468 = OpFAdd %f32_id %1460 %1467
       %1469 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1471 = OpIAdd %u32_id %1469 %u32_id_24608
       %1472 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1471
       %1473 = OpLoad %u64_id %1472
       %1474 = OpBitcast %u32vec2_id %1473
       %1475 = OpCompositeExtract %u32_id %1474 0
       %1476 = OpCompositeExtract %u32_id %1474 1
       %1477 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1479 = OpIAdd %u32_id %1477 %u32_id_24616
       %1480 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1479
       %1481 = OpLoad %u64_id %1480
       %1482 = OpBitcast %u32vec2_id %1481
       %1483 = OpCompositeExtract %u32_id %1482 0
       %1484 = OpCompositeExtract %u32_id %1482 1
       %1485 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1487 = OpIAdd %u32_id %1485 %u32_id_28704
       %1488 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1487
       %1489 = OpLoad %u64_id %1488
       %1490 = OpBitcast %u32vec2_id %1489
       %1491 = OpCompositeExtract %u32_id %1490 0
       %1492 = OpCompositeExtract %u32_id %1490 1
       %1493 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1495 = OpIAdd %u32_id %1493 %u32_id_28712
       %1496 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1495
       %1497 = OpLoad %u64_id %1496
       %1498 = OpBitcast %u32vec2_id %1497
       %1499 = OpCompositeExtract %u32_id %1498 0
       %1500 = OpCompositeExtract %u32_id %1498 1
       %1501 = OpBitcast %f32_id %1475
       %1502 = OpFAdd %f32_id %1462 %1501
       %1503 = OpBitcast %f32_id %1484
       %1504 = OpFAdd %f32_id %1464 %1503
       %1505 = OpBitcast %f32_id %1483
       %1506 = OpFAdd %f32_id %1466 %1505
       %1507 = OpBitcast %f32_id %1476
       %1508 = OpFAdd %f32_id %1468 %1507
       %1509 = OpBitcast %f32_id %1491
       %1510 = OpFAdd %f32_id %1502 %1509
       %1511 = OpBitcast %f32_id %1500
       %1512 = OpFAdd %f32_id %1504 %1511
       %1513 = OpBitcast %f32_id %1499
       %1514 = OpFAdd %f32_id %1506 %1513
       %1515 = OpBitcast %f32_id %1492
       %1516 = OpFAdd %f32_id %1508 %1515
       %1517 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1519 = OpIAdd %u32_id %1517 %u32_id_32800
       %1520 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1519
       %1521 = OpLoad %u64_id %1520
       %1522 = OpBitcast %u32vec2_id %1521
       %1523 = OpCompositeExtract %u32_id %1522 0
       %1524 = OpCompositeExtract %u32_id %1522 1
       %1525 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1527 = OpIAdd %u32_id %1525 %u32_id_32808
       %1528 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1527
       %1529 = OpLoad %u64_id %1528
       %1530 = OpBitcast %u32vec2_id %1529
       %1531 = OpCompositeExtract %u32_id %1530 0
       %1532 = OpCompositeExtract %u32_id %1530 1
       %1533 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1535 = OpIAdd %u32_id %1533 %u32_id_36896
       %1536 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1535
       %1537 = OpLoad %u64_id %1536
       %1538 = OpBitcast %u32vec2_id %1537
       %1539 = OpCompositeExtract %u32_id %1538 0
       %1540 = OpCompositeExtract %u32_id %1538 1
       %1541 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1543 = OpIAdd %u32_id %1541 %u32_id_36904
       %1544 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1543
       %1545 = OpLoad %u64_id %1544
       %1546 = OpBitcast %u32vec2_id %1545
       %1547 = OpCompositeExtract %u32_id %1546 0
       %1548 = OpCompositeExtract %u32_id %1546 1
       %1549 = OpBitcast %f32_id %1523
       %1550 = OpFAdd %f32_id %1510 %1549
       %1551 = OpBitcast %f32_id %1532
       %1552 = OpFAdd %f32_id %1512 %1551
       %1553 = OpBitcast %f32_id %1531
       %1554 = OpFAdd %f32_id %1514 %1553
       %1555 = OpBitcast %f32_id %1524
       %1556 = OpFAdd %f32_id %1516 %1555
       %1557 = OpBitcast %f32_id %1539
       %1558 = OpFAdd %f32_id %1550 %1557
       %1559 = OpBitcast %f32_id %1548
       %1560 = OpFAdd %f32_id %1552 %1559
       %1561 = OpBitcast %f32_id %1547
       %1562 = OpFAdd %f32_id %1554 %1561
       %1563 = OpBitcast %f32_id %1540
       %1564 = OpFAdd %f32_id %1556 %1563
       %1565 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1567 = OpIAdd %u32_id %1565 %u32_id_40992
       %1568 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1567
       %1569 = OpLoad %u64_id %1568
       %1570 = OpBitcast %u32vec2_id %1569
       %1571 = OpCompositeExtract %u32_id %1570 0
       %1572 = OpCompositeExtract %u32_id %1570 1
       %1573 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1575 = OpIAdd %u32_id %1573 %u32_id_41000
       %1576 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1575
       %1577 = OpLoad %u64_id %1576
       %1578 = OpBitcast %u32vec2_id %1577
       %1579 = OpCompositeExtract %u32_id %1578 0
       %1580 = OpCompositeExtract %u32_id %1578 1
       %1581 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1583 = OpIAdd %u32_id %1581 %u32_id_45088
       %1584 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1583
       %1585 = OpLoad %u64_id %1584
       %1586 = OpBitcast %u32vec2_id %1585
       %1587 = OpCompositeExtract %u32_id %1586 0
       %1588 = OpCompositeExtract %u32_id %1586 1
       %1589 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1591 = OpIAdd %u32_id %1589 %u32_id_45096
       %1592 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1591
       %1593 = OpLoad %u64_id %1592
       %1594 = OpBitcast %u32vec2_id %1593
       %1595 = OpCompositeExtract %u32_id %1594 0
       %1596 = OpCompositeExtract %u32_id %1594 1
       %1597 = OpBitcast %f32_id %1571
       %1598 = OpFAdd %f32_id %1558 %1597
       %1599 = OpBitcast %f32_id %1580
       %1600 = OpFAdd %f32_id %1560 %1599
       %1601 = OpBitcast %f32_id %1579
       %1602 = OpFAdd %f32_id %1562 %1601
       %1603 = OpBitcast %f32_id %1572
       %1604 = OpFAdd %f32_id %1564 %1603
       %1605 = OpBitcast %f32_id %1587
       %1606 = OpFAdd %f32_id %1598 %1605
       %1607 = OpBitcast %f32_id %1596
       %1608 = OpFAdd %f32_id %1600 %1607
       %1609 = OpBitcast %f32_id %1595
       %1610 = OpFAdd %f32_id %1602 %1609
       %1611 = OpBitcast %f32_id %1588
       %1612 = OpFAdd %f32_id %1604 %1611
       %1613 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1615 = OpIAdd %u32_id %1613 %u32_id_49184
       %1616 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1615
       %1617 = OpLoad %u64_id %1616
       %1618 = OpBitcast %u32vec2_id %1617
       %1619 = OpCompositeExtract %u32_id %1618 0
       %1620 = OpCompositeExtract %u32_id %1618 1
       %1621 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1623 = OpIAdd %u32_id %1621 %u32_id_49192
       %1624 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1623
       %1625 = OpLoad %u64_id %1624
       %1626 = OpBitcast %u32vec2_id %1625
       %1627 = OpCompositeExtract %u32_id %1626 0
       %1628 = OpCompositeExtract %u32_id %1626 1
       %1629 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1631 = OpIAdd %u32_id %1629 %u32_id_53280
       %1632 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1631
       %1633 = OpLoad %u64_id %1632
       %1634 = OpBitcast %u32vec2_id %1633
       %1635 = OpCompositeExtract %u32_id %1634 0
       %1636 = OpCompositeExtract %u32_id %1634 1
       %1637 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1639 = OpIAdd %u32_id %1637 %u32_id_53288
       %1640 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1639
       %1641 = OpLoad %u64_id %1640
       %1642 = OpBitcast %u32vec2_id %1641
       %1643 = OpCompositeExtract %u32_id %1642 0
       %1644 = OpCompositeExtract %u32_id %1642 1
       %1645 = OpBitcast %f32_id %1628
       %1646 = OpFAdd %f32_id %1608 %1645
       %1647 = OpBitcast %f32_id %1619
       %1648 = OpFAdd %f32_id %1606 %1647
       %1649 = OpBitcast %f32_id %1627
       %1650 = OpFAdd %f32_id %1610 %1649
       %1651 = OpBitcast %f32_id %1620
       %1652 = OpFAdd %f32_id %1612 %1651
       %1653 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1655 = OpIAdd %u32_id %1653 %u32_id_57376
       %1656 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1655
       %1657 = OpLoad %u64_id %1656
       %1658 = OpBitcast %u32vec2_id %1657
       %1659 = OpCompositeExtract %u32_id %1658 0
       %1660 = OpCompositeExtract %u32_id %1658 1
       %1661 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1663 = OpIAdd %u32_id %1661 %u32_id_57384
       %1664 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1663
       %1665 = OpLoad %u64_id %1664
       %1666 = OpBitcast %u32vec2_id %1665
       %1667 = OpCompositeExtract %u32_id %1666 0
       %1668 = OpCompositeExtract %u32_id %1666 1
       %1669 = OpBitcast %f32_id %1635
       %1670 = OpFAdd %f32_id %1648 %1669
       %1671 = OpBitcast %f32_id %1643
       %1672 = OpFAdd %f32_id %1650 %1671
       %1673 = OpBitcast %f32_id %1636
       %1674 = OpFAdd %f32_id %1652 %1673
       %1675 = OpBitcast %f32_id %1644
       %1676 = OpFAdd %f32_id %1646 %1675
       %1677 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1679 = OpIAdd %u32_id %1677 %u32_id_61472
       %1680 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1679
       %1681 = OpLoad %u64_id %1680
       %1682 = OpBitcast %u32vec2_id %1681
       %1683 = OpCompositeExtract %u32_id %1682 0
       %1684 = OpCompositeExtract %u32_id %1682 1
       %1685 = OpIMul %u32_id %workgroup_index %u32_id_65536
       %1687 = OpIAdd %u32_id %1685 %u32_id_61480
       %1688 = OpAccessChain %_ptr_StorageBuffer_u64_id %ssbo_shmem %u64_id_0 %1687
       %1689 = OpLoad %u64_id %1688
       %1690 = OpBitcast %u32vec2_id %1689
       %1691 = OpCompositeExtract %u32_id %1690 0
       %1692 = OpCompositeExtract %u32_id %1690 1
       %1693 = OpBitcast %f32_id %1659
       %1694 = OpFAdd %f32_id %1670 %1693
       %1695 = OpBitcast %f32_id %1668
       %1696 = OpFAdd %f32_id %1676 %1695
       %1697 = OpBitcast %f32_id %1667
       %1698 = OpFAdd %f32_id %1672 %1697
       %1699 = OpBitcast %f32_id %1660
       %1700 = OpFAdd %f32_id %1674 %1699
       %1701 = OpBitcast %f32_id %1683
       %1702 = OpFAdd %f32_id %1694 %1701
       %1703 = OpBitcast %f32_id %1692
       %1704 = OpFAdd %f32_id %1696 %1703
       %1705 = OpBitcast %f32_id %1691
       %1706 = OpFAdd %f32_id %1698 %1705
       %1707 = OpBitcast %f32_id %1684
       %1708 = OpFAdd %f32_id %1700 %1707
       %1709 = OpFAdd %f32_id %1702 %535
       %1710 = OpFAdd %f32_id %1704 %523
       %1711 = OpFAdd %f32_id %1706 %527
       %1712 = OpFAdd %f32_id %1708 %531
       %1713 = OpIMul %u32_id %916 %u32_id_16
       %1714 = OpIAdd %u32_id %1713 %buf1_dword_off
       %1715 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %1714
       %1716 = OpLoad %u32_id %1715
       %1717 = OpIAdd %u32_id %1714 %u32_id_1
       %1718 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %1717
       %1719 = OpLoad %u32_id %1718
       %1720 = OpIAdd %u32_id %1714 %u32_id_2
       %1721 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %1720
       %1722 = OpLoad %u32_id %1721
       %1723 = OpIAdd %u32_id %1714 %u32_id_3
       %1724 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %1723
       %1725 = OpLoad %u32_id %1724
       %1726 = OpCompositeConstruct %u32vec4_id %1716 %1719 %1722 %1725
       %1727 = OpCompositeExtract %u32_id %1726 0
       %1728 = OpCompositeExtract %u32_id %1726 1
       %1729 = OpCompositeExtract %u32_id %1726 2
       %1730 = OpCompositeExtract %u32_id %1726 3
       %1731 = OpIMul %u32_id %916 %u32_id_16
       %1733 = OpIAdd %u32_id %1731 %u32_id_4
       %1734 = OpIAdd %u32_id %1733 %buf1_dword_off
       %1735 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %1734
       %1736 = OpLoad %u32_id %1735
       %1737 = OpIAdd %u32_id %1734 %u32_id_1
       %1738 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %1737
       %1739 = OpLoad %u32_id %1738
       %1740 = OpIAdd %u32_id %1734 %u32_id_2
       %1741 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %1740
       %1742 = OpLoad %u32_id %1741
       %1743 = OpIAdd %u32_id %1734 %u32_id_3
       %1744 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %1743
       %1745 = OpLoad %u32_id %1744
       %1746 = OpCompositeConstruct %u32vec4_id %1736 %1739 %1742 %1745
       %1747 = OpCompositeExtract %u32_id %1746 0
       %1748 = OpCompositeExtract %u32_id %1746 1
       %1749 = OpCompositeExtract %u32_id %1746 2
       %1750 = OpCompositeExtract %u32_id %1746 3
       %1751 = OpIMul %u32_id %916 %u32_id_16
       %1752 = OpIAdd %u32_id %1751 %u32_id_8
       %1753 = OpIAdd %u32_id %1752 %buf1_dword_off
       %1754 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %1753
       %1755 = OpLoad %u32_id %1754
       %1756 = OpIAdd %u32_id %1753 %u32_id_1
       %1757 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %1756
       %1758 = OpLoad %u32_id %1757
       %1759 = OpIAdd %u32_id %1753 %u32_id_2
       %1760 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %1759
       %1761 = OpLoad %u32_id %1760
       %1762 = OpIAdd %u32_id %1753 %u32_id_3
       %1763 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %1762
       %1764 = OpLoad %u32_id %1763
       %1765 = OpCompositeConstruct %u32vec4_id %1755 %1758 %1761 %1764
       %1766 = OpCompositeExtract %u32_id %1765 0
       %1767 = OpCompositeExtract %u32_id %1765 1
       %1768 = OpCompositeExtract %u32_id %1765 2
       %1769 = OpCompositeExtract %u32_id %1765 3
       %1770 = OpBitcast %f32_id %920
       %1771 = OpBitcast %f32_id %1727
       %1772 = OpFMul %f32_id %1770 %1001
       %1773 = OpFAdd %f32_id %1772 %1771
       %1774 = OpBitcast %u32_id %1773
       %1775 = OpBitcast %f32_id %980
       %1776 = OpBitcast %f32_id %1730
       %1777 = OpFMul %f32_id %1775 %1022
       %1778 = OpFAdd %f32_id %1777 %1776
       %1779 = OpBitcast %u32_id %1778
       %1780 = OpBitcast %f32_id %980
       %1781 = OpBitcast %f32_id %1729
       %1782 = OpFMul %f32_id %1780 %1035
       %1783 = OpFAdd %f32_id %1782 %1781
       %1784 = OpBitcast %u32_id %1783
       %1785 = OpBitcast %f32_id %980
       %1786 = OpBitcast %f32_id %1728
       %1787 = OpFMul %f32_id %1785 %1036
       %1788 = OpFAdd %f32_id %1787 %1786
       %1789 = OpBitcast %u32_id %1788
       %1790 = OpBitcast %f32_id %920
       %1791 = OpBitcast %f32_id %1766
       %1792 = OpFMul %f32_id %1790 %1709
       %1793 = OpFAdd %f32_id %1792 %1791
       %1794 = OpBitcast %u32_id %1793
       %1795 = OpBitcast %f32_id %980
       %1796 = OpBitcast %f32_id %1769
       %1797 = OpFMul %f32_id %1795 %1710
       %1798 = OpFAdd %f32_id %1797 %1796
       %1799 = OpBitcast %u32_id %1798
       %1800 = OpBitcast %f32_id %980
       %1801 = OpBitcast %f32_id %1768
       %1802 = OpFMul %f32_id %1800 %1711
       %1803 = OpFAdd %f32_id %1802 %1801
       %1804 = OpBitcast %u32_id %1803
       %1805 = OpBitcast %f32_id %980
       %1806 = OpBitcast %f32_id %1767
       %1807 = OpFMul %f32_id %1805 %1712
       %1808 = OpFAdd %f32_id %1807 %1806
       %1809 = OpBitcast %u32_id %1808
       %1810 = OpCompositeConstruct %u32vec4_id %1774 %1789 %1784 %1779
       %1811 = OpIMul %u32_id %916 %u32_id_16
       %1812 = OpIAdd %u32_id %1811 %buf1_dword_off
       %1813 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %1812
       %1814 = OpCompositeExtract %u32_id %1810 0
               OpStore %1813 %1814
       %1815 = OpIAdd %u32_id %1812 %u32_id_1
       %1816 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %1815
       %1817 = OpCompositeExtract %u32_id %1810 1
               OpStore %1816 %1817
       %1818 = OpIAdd %u32_id %1812 %u32_id_2
       %1819 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %1818
       %1820 = OpCompositeExtract %u32_id %1810 2
               OpStore %1819 %1820
       %1821 = OpIAdd %u32_id %1812 %u32_id_3
       %1822 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %1821
       %1823 = OpCompositeExtract %u32_id %1810 3
               OpStore %1822 %1823
       %1824 = OpBitcast %f32_id %920
       %1825 = OpBitcast %f32_id %1747
       %1826 = OpFMul %f32_id %1824 %1349
       %1827 = OpFAdd %f32_id %1826 %1825
       %1828 = OpBitcast %u32_id %1827
       %1829 = OpBitcast %f32_id %980
       %1830 = OpBitcast %f32_id %1750
       %1831 = OpFMul %f32_id %1829 %1366
       %1832 = OpFAdd %f32_id %1831 %1830
       %1833 = OpBitcast %u32_id %1832
       %1834 = OpBitcast %f32_id %980
       %1835 = OpBitcast %f32_id %1749
       %1836 = OpFMul %f32_id %1834 %1367
       %1837 = OpFAdd %f32_id %1836 %1835
       %1838 = OpBitcast %u32_id %1837
       %1839 = OpBitcast %f32_id %980
       %1840 = OpBitcast %f32_id %1748
       %1841 = OpFMul %f32_id %1839 %1368
       %1842 = OpFAdd %f32_id %1841 %1840
       %1843 = OpBitcast %u32_id %1842
       %1844 = OpCompositeConstruct %u32vec4_id %1828 %1843 %1838 %1833
       %1845 = OpIMul %u32_id %916 %u32_id_16
       %1846 = OpIAdd %u32_id %1845 %u32_id_4
       %1847 = OpIAdd %u32_id %1846 %buf1_dword_off
       %1848 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %1847
       %1849 = OpCompositeExtract %u32_id %1844 0
               OpStore %1848 %1849
       %1850 = OpIAdd %u32_id %1847 %u32_id_1
       %1851 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %1850
       %1852 = OpCompositeExtract %u32_id %1844 1
               OpStore %1851 %1852
       %1853 = OpIAdd %u32_id %1847 %u32_id_2
       %1854 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %1853
       %1855 = OpCompositeExtract %u32_id %1844 2
               OpStore %1854 %1855
       %1856 = OpIAdd %u32_id %1847 %u32_id_3
       %1857 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %1856
       %1858 = OpCompositeExtract %u32_id %1844 3
               OpStore %1857 %1858
       %1859 = OpCompositeConstruct %u32vec4_id %1794 %1809 %1804 %1799
       %1860 = OpIMul %u32_id %916 %u32_id_16
       %1861 = OpIAdd %u32_id %1860 %u32_id_8
       %1862 = OpIAdd %u32_id %1861 %buf1_dword_off
       %1863 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %1862
       %1864 = OpCompositeExtract %u32_id %1859 0
               OpStore %1863 %1864
       %1865 = OpIAdd %u32_id %1862 %u32_id_1
       %1866 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %1865
       %1867 = OpCompositeExtract %u32_id %1859 1
               OpStore %1866 %1867
       %1868 = OpIAdd %u32_id %1862 %u32_id_2
       %1869 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %1868
       %1870 = OpCompositeExtract %u32_id %1859 2
               OpStore %1869 %1870
       %1871 = OpIAdd %u32_id %1862 %u32_id_3
       %1872 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %1871
       %1873 = OpCompositeExtract %u32_id %1859 3
               OpStore %1872 %1873
               OpBranch %91
         %91 = OpLabel
               OpBranch %92
         %92 = OpLabel
               OpBranch %93
         %93 = OpLabel
               OpReturn
               OpFunctionEnd
