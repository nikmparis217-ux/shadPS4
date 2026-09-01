; SPIR-V
; Version: 1.6
; Generator: Khronos; 0
; Bound: 1895
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
        %166 = OpExtInstImport "GLSL.std.450"
               OpMemoryModel Logical GLSL450
               OpEntryPoint GLCompute %78 "main" %push_data %gl_WorkGroupID %gl_LocalInvocationID %ssbo_1 %ssbo_1_0 %ssbo_1_1 %ssbo_1_2 %ssbo_2 %ssbo_3 %ssbo_4 %srt_flatbuf
               OpExecutionMode %78 LocalSize 32 32 1
               OpExecutionMode %78 SignedZeroInfNanPreserve 32
          %1 = OpString "0x2bbbbf0e"
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
               OpMemberName %_struct_52 0 "data"
               OpName %ssbo_1 "ssbo_1"
               OpMemberName %_struct_57 0 "data"
               OpName %ssbo_1_0 "ssbo_1"
               OpMemberName %_struct_63 0 "data"
               OpName %ssbo_1_1 "ssbo_1"
               OpMemberName %_struct_69 0 "data"
               OpName %ssbo_1_2 "ssbo_1"
               OpName %ssbo_2 "ssbo_2"
               OpName %ssbo_3 "ssbo_3"
               OpName %ssbo_4 "ssbo_4"
               OpName %srt_flatbuf "srt_flatbuf"
               OpName %buf0_off "buf0_off"
               OpName %buf0_word_off "buf0_word_off"
               OpName %buf0_dword_off "buf0_dword_off"
               OpName %buf1_off "buf1_off"
               OpName %buf1_dword_off "buf1_dword_off"
               OpName %buf2_off "buf2_off"
               OpName %buf2_dword_off "buf2_dword_off"
               OpName %buf3_off "buf3_off"
               OpName %buf3_dword_off "buf3_dword_off"
               OpName %ud_0 "ud_0"
               OpName %ud_1 "ud_1"
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
               OpDecorate %gl_LocalInvocationID BuiltIn LocalInvocationId
               OpDecorate %_runtimearr_u32_id ArrayStride 4
               OpDecorate %_struct_52 Block
               OpMemberDecorate %_struct_52 0 Offset 0
               OpDecorate %ssbo_1 Binding 0
               OpDecorate %ssbo_1 DescriptorSet 0
               OpDecorate %ssbo_1 NonWritable
               OpDecorate %_runtimearr_f32_id ArrayStride 4
               OpDecorate %_struct_57 Block
               OpMemberDecorate %_struct_57 0 Offset 0
               OpDecorate %ssbo_1_0 Binding 0
               OpDecorate %ssbo_1_0 DescriptorSet 0
               OpDecorate %ssbo_1_0 NonWritable
               OpDecorate %_runtimearr_u16_id ArrayStride 2
               OpDecorate %_struct_63 Block
               OpMemberDecorate %_struct_63 0 Offset 0
               OpDecorate %ssbo_1_1 Binding 0
               OpDecorate %ssbo_1_1 DescriptorSet 0
               OpDecorate %ssbo_1_1 NonWritable
               OpDecorate %_runtimearr_u8_id ArrayStride 1
               OpDecorate %_struct_69 Block
               OpMemberDecorate %_struct_69 0 Offset 0
               OpDecorate %ssbo_1_2 Binding 0
               OpDecorate %ssbo_1_2 DescriptorSet 0
               OpDecorate %ssbo_1_2 NonWritable
               OpDecorate %ssbo_2 Binding 1
               OpDecorate %ssbo_2 DescriptorSet 0
               OpDecorate %ssbo_3 Binding 2
               OpDecorate %ssbo_3 DescriptorSet 0
               OpDecorate %ssbo_4 Binding 3
               OpDecorate %ssbo_4 DescriptorSet 0
               OpDecorate %ssbo_4 NonWritable
               OpDecorate %srt_flatbuf Binding 4
               OpDecorate %srt_flatbuf DescriptorSet 0
               OpDecorate %srt_flatbuf NonWritable
               OpDecorate %173 NoContraction
               OpDecorate %206 NoContraction
               OpDecorate %211 NoContraction
               OpDecorate %213 NoContraction
               OpDecorate %214 NoContraction
               OpDecorate %215 NoContraction
               OpDecorate %219 NoContraction
               OpDecorate %221 NoContraction
               OpDecorate %222 NoContraction
               OpDecorate %223 NoContraction
               OpDecorate %226 NoContraction
               OpDecorate %229 NoContraction
               OpDecorate %230 NoContraction
               OpDecorate %231 NoContraction
               OpDecorate %232 NoContraction
               OpDecorate %233 NoContraction
               OpDecorate %235 NoContraction
               OpDecorate %239 NoContraction
               OpDecorate %240 NoContraction
               OpDecorate %243 NoContraction
               OpDecorate %249 NoContraction
               OpDecorate %250 NoContraction
               OpDecorate %253 NoContraction
               OpDecorate %363 NoContraction
               OpDecorate %364 NoContraction
               OpDecorate %365 NoContraction
               OpDecorate %366 NoContraction
               OpDecorate %367 NoContraction
               OpDecorate %411 NoContraction
               OpDecorate %412 NoContraction
               OpDecorate %413 NoContraction
               OpDecorate %414 NoContraction
               OpDecorate %415 NoContraction
               OpDecorate %416 NoContraction
               OpDecorate %417 NoContraction
               OpDecorate %418 NoContraction
               OpDecorate %419 NoContraction
               OpDecorate %420 NoContraction
               OpDecorate %421 NoContraction
               OpDecorate %422 NoContraction
               OpDecorate %423 NoContraction
               OpDecorate %445 NoContraction
               OpDecorate %446 NoContraction
               OpDecorate %448 NoContraction
               OpDecorate %449 NoContraction
               OpDecorate %450 NoContraction
               OpDecorate %451 NoContraction
               OpDecorate %452 NoContraction
               OpDecorate %453 NoContraction
               OpDecorate %454 NoContraction
               OpDecorate %455 NoContraction
               OpDecorate %456 NoContraction
               OpDecorate %457 NoContraction
               OpDecorate %521 NoContraction
               OpDecorate %522 NoContraction
               OpDecorate %523 NoContraction
               OpDecorate %524 NoContraction
               OpDecorate %529 NoContraction
               OpDecorate %537 NoContraction
               OpDecorate %538 NoContraction
               OpDecorate %541 NoContraction
               OpDecorate %543 NoContraction
               OpDecorate %544 NoContraction
               OpDecorate %545 NoContraction
               OpDecorate %546 NoContraction
               OpDecorate %547 NoContraction
               OpDecorate %548 NoContraction
               OpDecorate %549 NoContraction
               OpDecorate %550 NoContraction
               OpDecorate %551 NoContraction
               OpDecorate %552 NoContraction
               OpDecorate %554 NoContraction
               OpDecorate %555 NoContraction
               OpDecorate %556 NoContraction
               OpDecorate %557 NoContraction
               OpDecorate %558 NoContraction
               OpDecorate %559 NoContraction
               OpDecorate %561 NoContraction
               OpDecorate %562 NoContraction
               OpDecorate %563 NoContraction
               OpDecorate %616 NoContraction
               OpDecorate %617 NoContraction
               OpDecorate %618 NoContraction
               OpDecorate %619 NoContraction
               OpDecorate %620 NoContraction
               OpDecorate %621 NoContraction
               OpDecorate %622 NoContraction
               OpDecorate %623 NoContraction
               OpDecorate %624 NoContraction
               OpDecorate %625 NoContraction
               OpDecorate %626 NoContraction
               OpDecorate %627 NoContraction
               OpDecorate %628 NoContraction
               OpDecorate %629 NoContraction
               OpDecorate %636 NoContraction
               OpDecorate %637 NoContraction
               OpDecorate %639 NoContraction
               OpDecorate %640 NoContraction
               OpDecorate %641 NoContraction
               OpDecorate %642 NoContraction
               OpDecorate %643 NoContraction
               OpDecorate %644 NoContraction
               OpDecorate %645 NoContraction
               OpDecorate %646 NoContraction
               OpDecorate %647 NoContraction
               OpDecorate %697 NoContraction
               OpDecorate %698 NoContraction
               OpDecorate %699 NoContraction
               OpDecorate %732 NoContraction
               OpDecorate %733 NoContraction
               OpDecorate %734 NoContraction
               OpDecorate %735 NoContraction
               OpDecorate %736 NoContraction
               OpDecorate %811 NoContraction
               OpDecorate %812 NoContraction
               OpDecorate %813 NoContraction
               OpDecorate %814 NoContraction
               OpDecorate %815 NoContraction
               OpDecorate %817 NoContraction
               OpDecorate %818 NoContraction
               OpDecorate %819 NoContraction
               OpDecorate %820 NoContraction
               OpDecorate %821 NoContraction
               OpDecorate %822 NoContraction
               OpDecorate %823 NoContraction
               OpDecorate %824 NoContraction
               OpDecorate %867 NoContraction
               OpDecorate %868 NoContraction
               OpDecorate %869 NoContraction
               OpDecorate %870 NoContraction
               OpDecorate %871 NoContraction
               OpDecorate %872 NoContraction
               OpDecorate %874 NoContraction
               OpDecorate %875 NoContraction
               OpDecorate %876 NoContraction
               OpDecorate %877 NoContraction
               OpDecorate %878 NoContraction
               OpDecorate %879 NoContraction
               OpDecorate %880 NoContraction
               OpDecorate %881 NoContraction
               OpDecorate %882 NoContraction
               OpDecorate %883 NoContraction
               OpDecorate %968 NoContraction
               OpDecorate %969 NoContraction
               OpDecorate %970 NoContraction
               OpDecorate %971 NoContraction
               OpDecorate %973 NoContraction
               OpDecorate %974 NoContraction
               OpDecorate %976 NoContraction
               OpDecorate %977 NoContraction
               OpDecorate %978 NoContraction
               OpDecorate %979 NoContraction
               OpDecorate %980 NoContraction
               OpDecorate %981 NoContraction
               OpDecorate %982 NoContraction
               OpDecorate %984 NoContraction
               OpDecorate %985 NoContraction
               OpDecorate %986 NoContraction
               OpDecorate %987 NoContraction
               OpDecorate %988 NoContraction
               OpDecorate %989 NoContraction
               OpDecorate %990 NoContraction
               OpDecorate %991 NoContraction
               OpDecorate %993 NoContraction
               OpDecorate %994 NoContraction
               OpDecorate %995 NoContraction
               OpDecorate %996 NoContraction
               OpDecorate %997 NoContraction
               OpDecorate %998 NoContraction
               OpDecorate %999 NoContraction
               OpDecorate %1000 NoContraction
               OpDecorate %1001 NoContraction
               OpDecorate %1002 NoContraction
               OpDecorate %1003 NoContraction
               OpDecorate %1004 NoContraction
               OpDecorate %1005 NoContraction
               OpDecorate %1006 NoContraction
               OpDecorate %1007 NoContraction
               OpDecorate %1008 NoContraction
               OpDecorate %1012 NoContraction
               OpDecorate %1013 NoContraction
               OpDecorate %1015 NoContraction
               OpDecorate %1016 NoContraction
               OpDecorate %1017 NoContraction
               OpDecorate %1018 NoContraction
               OpDecorate %1019 NoContraction
               OpDecorate %1020 NoContraction
               OpDecorate %1021 NoContraction
               OpDecorate %1022 NoContraction
               OpDecorate %1023 NoContraction
               OpDecorate %1076 NoContraction
               OpDecorate %1077 NoContraction
               OpDecorate %1078 NoContraction
               OpDecorate %1079 NoContraction
               OpDecorate %1081 NoContraction
               OpDecorate %1083 NoContraction
               OpDecorate %1085 NoContraction
               OpDecorate %1086 NoContraction
               OpDecorate %1087 NoContraction
               OpDecorate %1088 NoContraction
               OpDecorate %1089 NoContraction
               OpDecorate %1090 NoContraction
               OpDecorate %1091 NoContraction
               OpDecorate %1166 NoContraction
               OpDecorate %1167 NoContraction
               OpDecorate %1168 NoContraction
               OpDecorate %1169 NoContraction
               OpDecorate %1170 NoContraction
               OpDecorate %1172 NoContraction
               OpDecorate %1173 NoContraction
               OpDecorate %1174 NoContraction
               OpDecorate %1175 NoContraction
               OpDecorate %1176 NoContraction
               OpDecorate %1177 NoContraction
               OpDecorate %1178 NoContraction
               OpDecorate %1179 NoContraction
               OpDecorate %1222 NoContraction
               OpDecorate %1223 NoContraction
               OpDecorate %1224 NoContraction
               OpDecorate %1225 NoContraction
               OpDecorate %1226 NoContraction
               OpDecorate %1227 NoContraction
               OpDecorate %1228 NoContraction
               OpDecorate %1230 NoContraction
               OpDecorate %1231 NoContraction
               OpDecorate %1232 NoContraction
               OpDecorate %1233 NoContraction
               OpDecorate %1234 NoContraction
               OpDecorate %1235 NoContraction
               OpDecorate %1236 NoContraction
               OpDecorate %1237 NoContraction
               OpDecorate %1238 NoContraction
               OpDecorate %1239 NoContraction
               OpDecorate %1324 NoContraction
               OpDecorate %1325 NoContraction
               OpDecorate %1326 NoContraction
               OpDecorate %1327 NoContraction
               OpDecorate %1329 NoContraction
               OpDecorate %1336 NoContraction
               OpDecorate %1337 NoContraction
               OpDecorate %1338 NoContraction
               OpDecorate %1339 NoContraction
               OpDecorate %1340 NoContraction
               OpDecorate %1341 NoContraction
               OpDecorate %1344 NoContraction
               OpDecorate %1346 NoContraction
               OpDecorate %1347 NoContraction
               OpDecorate %1348 NoContraction
               OpDecorate %1349 NoContraction
               OpDecorate %1350 NoContraction
               OpDecorate %1351 NoContraction
               OpDecorate %1353 NoContraction
               OpDecorate %1354 NoContraction
               OpDecorate %1355 NoContraction
               OpDecorate %1356 NoContraction
               OpDecorate %1357 NoContraction
               OpDecorate %1358 NoContraction
               OpDecorate %1359 NoContraction
               OpDecorate %1360 NoContraction
               OpDecorate %1362 NoContraction
               OpDecorate %1363 NoContraction
               OpDecorate %1364 NoContraction
               OpDecorate %1365 NoContraction
               OpDecorate %1366 NoContraction
               OpDecorate %1367 NoContraction
               OpDecorate %1368 NoContraction
               OpDecorate %1369 NoContraction
               OpDecorate %1370 NoContraction
               OpDecorate %1371 NoContraction
               OpDecorate %1372 NoContraction
               OpDecorate %1375 NoContraction
               OpDecorate %1376 NoContraction
               OpDecorate %1377 NoContraction
               OpDecorate %1379 NoContraction
               OpDecorate %1380 NoContraction
               OpDecorate %1386 NoContraction
               OpDecorate %1387 NoContraction
               OpDecorate %1389 NoContraction
               OpDecorate %1390 NoContraction
               OpDecorate %1431 NoContraction
               OpDecorate %1432 NoContraction
               OpDecorate %1433 NoContraction
               OpDecorate %1434 NoContraction
               OpDecorate %1435 NoContraction
               OpDecorate %1436 NoContraction
               OpDecorate %1437 NoContraction
               OpDecorate %1438 NoContraction
               OpDecorate %1439 NoContraction
               OpDecorate %1440 NoContraction
               OpDecorate %1441 NoContraction
               OpDecorate %1443 NoContraction
               OpDecorate %1444 NoContraction
               OpDecorate %1445 NoContraction
               OpDecorate %1448 NoContraction
               OpDecorate %1545 NoContraction
               OpDecorate %1546 NoContraction
               OpDecorate %1547 NoContraction
               OpDecorate %1548 NoContraction
               OpDecorate %1549 NoContraction
               OpDecorate %1551 NoContraction
               OpDecorate %1552 NoContraction
               OpDecorate %1553 NoContraction
               OpDecorate %1554 NoContraction
               OpDecorate %1555 NoContraction
               OpDecorate %1556 NoContraction
               OpDecorate %1557 NoContraction
               OpDecorate %1558 NoContraction
               OpDecorate %1559 NoContraction
               OpDecorate %1560 NoContraction
               OpDecorate %1561 NoContraction
               OpDecorate %1562 NoContraction
               OpDecorate %1563 NoContraction
               OpDecorate %1606 NoContraction
               OpDecorate %1608 NoContraction
               OpDecorate %1609 NoContraction
               OpDecorate %1610 NoContraction
               OpDecorate %1611 NoContraction
               OpDecorate %1612 NoContraction
               OpDecorate %1613 NoContraction
               OpDecorate %1614 NoContraction
               OpDecorate %1615 NoContraction
               OpDecorate %1616 NoContraction
               OpDecorate %1617 NoContraction
               OpDecorate %1618 NoContraction
               OpDecorate %1619 NoContraction
               OpDecorate %1620 NoContraction
               OpDecorate %1621 NoContraction
               OpDecorate %1622 NoContraction
               OpDecorate %1686 NoContraction
               OpDecorate %1688 NoContraction
               OpDecorate %1689 NoContraction
               OpDecorate %1690 NoContraction
               OpDecorate %1691 NoContraction
               OpDecorate %1692 NoContraction
               OpDecorate %1693 NoContraction
               OpDecorate %1694 NoContraction
               OpDecorate %1695 NoContraction
               OpDecorate %1697 NoContraction
               OpDecorate %1698 NoContraction
               OpDecorate %1699 NoContraction
               OpDecorate %1700 NoContraction
               OpDecorate %1701 NoContraction
               OpDecorate %1702 NoContraction
               OpDecorate %1703 NoContraction
               OpDecorate %1704 NoContraction
               OpDecorate %1705 NoContraction
               OpDecorate %1706 NoContraction
               OpDecorate %1707 NoContraction
               OpDecorate %1708 NoContraction
               OpDecorate %1709 NoContraction
               OpDecorate %1710 NoContraction
               OpDecorate %1711 NoContraction
               OpDecorate %1712 NoContraction
               OpDecorate %1713 NoContraction
               OpDecorate %1714 NoContraction
               OpDecorate %1716 NoContraction
               OpDecorate %1717 NoContraction
               OpDecorate %1834 NoContraction
               OpDecorate %1836 NoContraction
               OpDecorate %1845 NoContraction
               OpDecorate %1851 NoContraction
               OpDecorate %1853 NoContraction
               OpDecorate %1856 NoContraction
               OpDecorate %1859 NoContraction
               OpDecorate %1860 NoContraction
               OpDecorate %1863 NoContraction
               OpDecorate %1864 NoContraction
               OpDecorate %1867 NoContraction
               OpDecorate %1868 NoContraction
               OpDecorate %1871 NoContraction
               OpDecorate %1872 NoContraction
               OpDecorate %1875 NoContraction
               OpDecorate %1876 NoContraction
               OpDecorate %1879 NoContraction
               OpDecorate %1880 NoContraction
               OpDecorate %1881 NoContraction
               OpDecorate %1882 NoContraction
               OpDecorate %1888 NoContraction
               OpDecorate %1889 NoContraction
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
    %gtcap_1000 = OpConstant %u32_id 1000
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
 %_struct_52 = OpTypeStruct %_runtimearr_u32_id
%_ptr_StorageBuffer__struct_52 = OpTypePointer StorageBuffer %_struct_52
%_ptr_StorageBuffer_u32_id = OpTypePointer StorageBuffer %u32_id
%_runtimearr_f32_id = OpTypeRuntimeArray %f32_id
 %_struct_57 = OpTypeStruct %_runtimearr_f32_id
%_ptr_StorageBuffer__struct_57 = OpTypePointer StorageBuffer %_struct_57
%_ptr_StorageBuffer_f32_id = OpTypePointer StorageBuffer %f32_id
%u32_id_32736 = OpConstant %u32_id 32736
%_runtimearr_u16_id = OpTypeRuntimeArray %u16_id
 %_struct_63 = OpTypeStruct %_runtimearr_u16_id
%_ptr_StorageBuffer__struct_63 = OpTypePointer StorageBuffer %_struct_63
%_ptr_StorageBuffer_u16_id = OpTypePointer StorageBuffer %u16_id
%u32_id_65472 = OpConstant %u32_id 65472
%_runtimearr_u8_id = OpTypeRuntimeArray %u8_id
 %_struct_69 = OpTypeStruct %_runtimearr_u8_id
%_ptr_StorageBuffer__struct_69 = OpTypePointer StorageBuffer %_struct_69
%_ptr_StorageBuffer_u8_id = OpTypePointer StorageBuffer %u8_id
         %77 = OpTypeFunction %void_id
   %u32_id_8 = OpConstant %u32_id 8
%_ptr_PushConstant_u32_id = OpTypePointer PushConstant %u32_id
   %u32_id_2 = OpConstant %u32_id 2
  %u32_id_16 = OpConstant %u32_id 16
  %u32_id_24 = OpConstant %u32_id 24
   %u32_id_4 = OpConstant %u32_id 4
   %u32_id_5 = OpConstant %u32_id 5
  %u32_id_17 = OpConstant %u32_id 17
   %u32_id_3 = OpConstant %u32_id 3
  %u32_id_19 = OpConstant %u32_id 19
   %u32_id_9 = OpConstant %u32_id 9
  %u32_id_23 = OpConstant %u32_id 23
 %u32_id_255 = OpConstant %u32_id 255
   %f32_id_1 = OpConstant %f32_id 1
        %187 = OpConstantComposite %f32vec4_id %f32_id_0 %f32_id_1 %f32_id_0 %f32_id_0
  %f32_id_n1 = OpConstant %f32_id -1
   %u32_id_6 = OpConstant %u32_id 6
 %f32_id_n15 = OpConstant %f32_id -15
  %f32_id_10 = OpConstant %f32_id 10
   %f32_id_2 = OpConstant %f32_id 2
   %f32_id_4 = OpConstant %f32_id 4
   %f32_id_8 = OpConstant %f32_id 8
  %u32_id_10 = OpConstant %u32_id 10
  %u32_id_15 = OpConstant %u32_id 15
  %u32_id_12 = OpConstant %u32_id 12
%u32_id_1024 = OpConstant %u32_id 1024
 %f32_id_0_5 = OpConstant %f32_id 0.5
%f32_id_0_25 = OpConstant %f32_id 0.25
%f32_id_0_125 = OpConstant %f32_id 0.125
%f32_id_0_0625 = OpConstant %f32_id 0.0625
%u32_id_4294967295 = OpConstant %u32_id 4294967295
  %u32_id_22 = OpConstant %u32_id 22
  %u32_id_31 = OpConstant %u32_id 31
  %u32_id_26 = OpConstant %u32_id 26
  %u32_id_35 = OpConstant %u32_id 35
  %u32_id_20 = OpConstant %u32_id 20
  %u32_id_21 = OpConstant %u32_id 21
  %u32_id_18 = OpConstant %u32_id 18
%f32_id_n9_80000019 = OpConstant %f32_id -9.80000019
  %push_data = OpVariable %_ptr_PushConstant_AuxData PushConstant
%gl_WorkGroupID = OpVariable %_ptr_Input_u32vec3_id Input
%gl_LocalInvocationID = OpVariable %_ptr_Input_u32vec3_id Input
     %ssbo_1 = OpVariable %_ptr_StorageBuffer__struct_52 StorageBuffer
   %ssbo_1_0 = OpVariable %_ptr_StorageBuffer__struct_57 StorageBuffer
   %ssbo_1_1 = OpVariable %_ptr_StorageBuffer__struct_63 StorageBuffer
   %ssbo_1_2 = OpVariable %_ptr_StorageBuffer__struct_69 StorageBuffer
     %ssbo_2 = OpVariable %_ptr_StorageBuffer__struct_52 StorageBuffer
     %ssbo_3 = OpVariable %_ptr_StorageBuffer__struct_52 StorageBuffer
     %ssbo_4 = OpVariable %_ptr_StorageBuffer__struct_52 StorageBuffer
%srt_flatbuf = OpVariable %_ptr_StorageBuffer__struct_52 StorageBuffer
         %78 = OpFunction %void_id None %77
         %79 = OpLabel
         %94 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
         %95 = OpLoad %u32_id %94
   %buf0_off = OpBitFieldUExtract %u32_id %95 %u32_id_0 %u32_id_8
%buf0_word_off = OpShiftRightLogical %u32_id %buf0_off %u32_id_1
%buf0_dword_off = OpShiftRightLogical %u32_id %buf0_off %u32_id_2
        %100 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
        %101 = OpLoad %u32_id %100
   %buf1_off = OpBitFieldUExtract %u32_id %101 %u32_id_8 %u32_id_8
%buf1_dword_off = OpShiftRightLogical %u32_id %buf1_off %u32_id_2
        %104 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
        %105 = OpLoad %u32_id %104
   %buf2_off = OpBitFieldUExtract %u32_id %105 %u32_id_16 %u32_id_8
%buf2_dword_off = OpShiftRightLogical %u32_id %buf2_off %u32_id_2
        %109 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
        %110 = OpLoad %u32_id %109
   %buf3_off = OpBitFieldUExtract %u32_id %110 %u32_id_24 %u32_id_8
%buf3_dword_off = OpShiftRightLogical %u32_id %buf3_off %u32_id_2
        %115 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_0
       %ud_0 = OpLoad %u32_id %115
        %117 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_1
       %ud_1 = OpLoad %u32_id %117
        %119 = OpLoad %u32vec3_id %gl_LocalInvocationID
        %120 = OpCompositeExtract %u32_id %119 0
        %121 = OpLoad %u32vec3_id %gl_LocalInvocationID
        %122 = OpCompositeExtract %u32_id %121 1
        %123 = OpLoad %u32vec3_id %gl_WorkGroupID
        %124 = OpCompositeExtract %u32_id %123 0
        %125 = OpLoad %u32vec3_id %gl_WorkGroupID
        %126 = OpCompositeExtract %u32_id %125 1
        %128 = OpShiftLeftLogical %u32_id %124 %u32_id_5
        %129 = OpShiftLeftLogical %u32_id %126 %u32_id_5
        %130 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %131 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_16
        %132 = OpLoad %u32_id %131
        %134 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_17
        %135 = OpLoad %u32_id %134
        %136 = OpIAdd %u32_id %128 %120
        %137 = OpIAdd %u32_id %129 %122
        %138 = OpULessThanEqual %bool_id %135 %137
        %139 = OpULessThanEqual %bool_id %132 %136
        %140 = OpLogicalOr %bool_id %139 %138
        %141 = OpLogicalNot %bool_id %140
        %142 = OpLogicalNot %bool_id %140
               OpSelectionMerge %90 None
               OpBranchConditional %142 %80 %90
         %80 = OpLabel
        %143 = OpConvertSToF %f32_id %136
        %144 = OpBitcast %u32_id %143
        %145 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %148 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_19
        %149 = OpLoad %u32_id %148
        %150 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %153 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_23
        %154 = OpLoad %u32_id %153
        %155 = OpConvertSToF %f32_id %137
        %156 = OpBitcast %u32_id %155
               OpBranch %81
         %81 = OpLabel
        %157 = OpPhi %u32_id %u32_id_0 %80 %1718 %84
        %158 = OpPhi %u32_id %156 %80 %1449 %84
        %159 = OpPhi %u32_id %149 %80 %1345 %84
        %160 = OpPhi %u32_id %144 %80 %542 %84
        %161 = OpPhi %u32_id %u32_id_0 %80 %258 %84
       %gtc1895 = OpPhi %u32_id %u32_id_0 %80 %gtc1896 %84
               OpLoopMerge %85 %84 None
               OpBranch %82
         %82 = OpLabel
        %162 = OpSLessThan %bool_id %161 %154
        %163 = OpLogicalNot %bool_id %162
       %gtc1896 = OpIAdd %u32_id %gtc1895 %u32_id_1
       %gtc1897 = OpUGreaterThanEqual %bool_id %gtc1895 %gtcap_1000
       %gtc1898 = OpLogicalOr %bool_id %163 %gtc1897
               OpBranchConditional %gtc1898 %85 %83
         %83 = OpLabel
        %164 = OpBitcast %f32_id %158
        %165 = OpFNegate %f32_id %164
        %167 = OpExtInst %f32_id %166 Trunc %165
        %168 = OpBitcast %f32_id %158
        %169 = OpConvertFToS %u32_id %168
        %170 = OpBitcast %f32_id %159
        %171 = OpConvertFToS %u32_id %170
        %172 = OpBitcast %f32_id %158
        %173 = OpFAdd %f32_id %172 %167
        %174 = OpBitcast %f32_id %160
        %175 = OpConvertFToS %u32_id %174
        %177 = OpBitwiseAnd %u32_id %u32_id_255 %175
        %178 = OpBitFieldUExtract %u32_id %177 %u32_id_0 %u32_id_24
        %179 = OpIMul %u32_id %178 %u32_id_4
        %180 = OpIAdd %u32_id %177 %u32_id_1
        %181 = OpShiftRightLogical %u32_id %179 %u32_id_2
        %182 = OpIAdd %u32_id %181 %buf0_dword_off
        %183 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %182
        %184 = OpLoad %f32_id %183
        %185 = OpCompositeConstruct %f32vec4_id %184 %f32_id_0 %f32_id_0 %f32_id_0
        %188 = OpVectorShuffle %f32vec4_id %187 %185 4 5 6 4
        %189 = OpCompositeExtract %f32_id %188 0
        %190 = OpBitcast %u32_id %189
        %191 = OpBitwiseAnd %u32_id %u32_id_255 %180
        %192 = OpBitFieldUExtract %u32_id %191 %u32_id_0 %u32_id_24
        %193 = OpIMul %u32_id %192 %u32_id_4
        %194 = OpShiftRightLogical %u32_id %193 %u32_id_2
        %195 = OpIAdd %u32_id %194 %buf0_dword_off
        %196 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %195
        %197 = OpLoad %f32_id %196
        %198 = OpCompositeConstruct %f32vec4_id %197 %f32_id_0 %f32_id_0 %f32_id_0
        %199 = OpVectorShuffle %f32vec4_id %187 %198 4 5 6 4
        %200 = OpCompositeExtract %f32_id %199 0
        %201 = OpBitcast %u32_id %200
        %202 = OpBitcast %f32_id %160
        %203 = OpFNegate %f32_id %202
        %204 = OpExtInst %f32_id %166 Trunc %203
        %205 = OpBitcast %f32_id %160
        %206 = OpFAdd %f32_id %205 %204
        %207 = OpBitcast %f32_id %159
        %208 = OpFNegate %f32_id %207
        %209 = OpExtInst %f32_id %166 Trunc %208
        %210 = OpBitcast %f32_id %159
        %211 = OpFAdd %f32_id %210 %209
        %213 = OpFAdd %f32_id %f32_id_n1 %206
        %214 = OpFMul %f32_id %206 %206
        %215 = OpFMul %f32_id %214 %206
        %217 = OpConvertSToF %f32_id %u32_id_6
        %219 = OpExtInst %f32_id %166 Fma %217 %206 %f32_id_n15
        %221 = OpExtInst %f32_id %166 Fma %219 %206 %f32_id_10
        %222 = OpFMul %f32_id %215 %221
        %223 = OpFAdd %f32_id %f32_id_n1 %173
        %224 = OpBitcast %f32_id %160
        %226 = OpFMul %f32_id %f32_id_2 %224
        %227 = OpConvertFToS %u32_id %226
        %228 = OpBitwiseAnd %u32_id %u32_id_255 %227
        %229 = OpExtInst %f32_id %166 Fma %217 %173 %f32_id_n15
        %230 = OpFMul %f32_id %173 %173
        %231 = OpExtInst %f32_id %166 Fma %229 %173 %f32_id_10
        %232 = OpFMul %f32_id %230 %173
        %233 = OpFMul %f32_id %232 %231
        %234 = OpBitcast %f32_id %158
        %235 = OpFMul %f32_id %f32_id_2 %234
        %236 = OpFNegate %f32_id %226
        %237 = OpExtInst %f32_id %166 Trunc %236
        %238 = OpBitcast %f32_id %160
        %239 = OpFMul %f32_id %f32_id_2 %238
        %240 = OpFAdd %f32_id %239 %237
        %241 = OpBitcast %f32_id %160
        %243 = OpFMul %f32_id %f32_id_4 %241
        %244 = OpConvertFToS %u32_id %243
        %245 = OpBitwiseAnd %u32_id %u32_id_255 %244
        %246 = OpFNegate %f32_id %243
        %247 = OpExtInst %f32_id %166 Trunc %246
        %248 = OpBitcast %f32_id %160
        %249 = OpFMul %f32_id %f32_id_4 %248
        %250 = OpFAdd %f32_id %249 %247
        %251 = OpBitcast %f32_id %160
        %253 = OpFMul %f32_id %f32_id_8 %251
        %254 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %256 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_24
        %257 = OpLoad %u32_id %256
        %258 = OpIAdd %u32_id %161 %u32_id_1
        %259 = OpIAdd %u32_id %190 %169
        %260 = OpBitwiseAnd %u32_id %u32_id_255 %259
        %261 = OpIAdd %u32_id %259 %u32_id_1
        %262 = OpIAdd %u32_id %201 %169
        %263 = OpBitFieldUExtract %u32_id %260 %u32_id_0 %u32_id_24
        %264 = OpIMul %u32_id %263 %u32_id_4
        %265 = OpBitwiseAnd %u32_id %u32_id_255 %261
        %266 = OpBitFieldUExtract %u32_id %265 %u32_id_0 %u32_id_24
        %267 = OpIMul %u32_id %266 %u32_id_4
        %268 = OpBitwiseAnd %u32_id %u32_id_255 %262
        %269 = OpBitFieldUExtract %u32_id %268 %u32_id_0 %u32_id_24
        %270 = OpIMul %u32_id %269 %u32_id_4
        %271 = OpIAdd %u32_id %262 %u32_id_1
        %272 = OpBitwiseAnd %u32_id %u32_id_255 %271
        %273 = OpBitFieldUExtract %u32_id %272 %u32_id_0 %u32_id_24
        %274 = OpIMul %u32_id %273 %u32_id_4
        %275 = OpShiftRightLogical %u32_id %264 %u32_id_2
        %276 = OpIAdd %u32_id %275 %buf0_dword_off
        %277 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %276
        %278 = OpLoad %f32_id %277
        %279 = OpCompositeConstruct %f32vec4_id %278 %f32_id_0 %f32_id_0 %f32_id_0
        %280 = OpVectorShuffle %f32vec4_id %187 %279 4 5 6 4
        %281 = OpCompositeExtract %f32_id %280 0
        %282 = OpBitcast %u32_id %281
        %283 = OpShiftRightLogical %u32_id %267 %u32_id_2
        %284 = OpIAdd %u32_id %283 %buf0_dword_off
        %285 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %284
        %286 = OpLoad %f32_id %285
        %287 = OpCompositeConstruct %f32vec4_id %286 %f32_id_0 %f32_id_0 %f32_id_0
        %288 = OpVectorShuffle %f32vec4_id %187 %287 4 5 6 4
        %289 = OpCompositeExtract %f32_id %288 0
        %290 = OpBitcast %u32_id %289
        %291 = OpShiftRightLogical %u32_id %270 %u32_id_2
        %292 = OpIAdd %u32_id %291 %buf0_dword_off
        %293 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %292
        %294 = OpLoad %f32_id %293
        %295 = OpCompositeConstruct %f32vec4_id %294 %f32_id_0 %f32_id_0 %f32_id_0
        %296 = OpVectorShuffle %f32vec4_id %187 %295 4 5 6 4
        %297 = OpCompositeExtract %f32_id %296 0
        %298 = OpBitcast %u32_id %297
        %299 = OpShiftRightLogical %u32_id %274 %u32_id_2
        %300 = OpIAdd %u32_id %299 %buf0_dword_off
        %301 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %300
        %302 = OpLoad %f32_id %301
        %303 = OpCompositeConstruct %f32vec4_id %302 %f32_id_0 %f32_id_0 %f32_id_0
        %304 = OpVectorShuffle %f32vec4_id %187 %303 4 5 6 4
        %305 = OpCompositeExtract %f32_id %304 0
        %306 = OpBitcast %u32_id %305
        %307 = OpIAdd %u32_id %282 %171
        %309 = OpBitwiseAnd %u32_id %u32_id_15 %307
        %310 = OpBitFieldUExtract %u32_id %309 %u32_id_0 %u32_id_24
        %312 = OpIMul %u32_id %310 %u32_id_12
        %313 = OpIAdd %u32_id %298 %171
        %314 = OpBitwiseAnd %u32_id %u32_id_15 %313
        %315 = OpIAdd %u32_id %290 %171
        %316 = OpIAdd %u32_id %307 %u32_id_1
        %317 = OpBitwiseAnd %u32_id %u32_id_15 %316
        %318 = OpIAdd %u32_id %306 %171
        %319 = OpBitwiseAnd %u32_id %u32_id_15 %315
        %320 = OpBitFieldUExtract %u32_id %319 %u32_id_0 %u32_id_24
        %321 = OpIMul %u32_id %320 %u32_id_12
        %322 = OpBitwiseAnd %u32_id %u32_id_15 %318
        %323 = OpBitFieldUExtract %u32_id %322 %u32_id_0 %u32_id_24
        %324 = OpIMul %u32_id %323 %u32_id_12
        %325 = OpIAdd %u32_id %315 %u32_id_1
        %326 = OpIAdd %u32_id %318 %u32_id_1
        %327 = OpBitFieldUExtract %u32_id %317 %u32_id_0 %u32_id_24
        %328 = OpIMul %u32_id %327 %u32_id_12
        %330 = OpIAdd %u32_id %312 %u32_id_1024
        %331 = OpIAdd %u32_id %312 %u32_id_1024
        %332 = OpShiftRightLogical %u32_id %331 %u32_id_2
        %333 = OpIAdd %u32_id %332 %buf0_dword_off
        %334 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %333
        %335 = OpLoad %f32_id %334
        %336 = OpIAdd %u32_id %333 %u32_id_1
        %337 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %336
        %338 = OpLoad %f32_id %337
        %339 = OpIAdd %u32_id %333 %u32_id_2
        %340 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %339
        %341 = OpLoad %f32_id %340
        %342 = OpCompositeConstruct %f32vec3_id %335 %338 %341
        %343 = OpCompositeExtract %f32_id %342 0
        %344 = OpCompositeExtract %f32_id %342 1
        %345 = OpCompositeExtract %f32_id %342 2
        %346 = OpCompositeConstruct %f32vec4_id %343 %344 %345 %f32_id_0
        %347 = OpVectorShuffle %f32vec4_id %187 %346 4 5 6 7
        %348 = OpCompositeExtract %f32_id %347 0
        %349 = OpCompositeExtract %f32_id %347 1
        %350 = OpCompositeExtract %f32_id %347 2
        %351 = OpIAdd %u32_id %313 %u32_id_1
        %352 = OpBitFieldUExtract %u32_id %314 %u32_id_0 %u32_id_24
        %353 = OpIMul %u32_id %352 %u32_id_12
        %354 = OpBitwiseAnd %u32_id %u32_id_15 %351
        %355 = OpBitwiseAnd %u32_id %u32_id_15 %325
        %356 = OpBitwiseAnd %u32_id %u32_id_15 %326
        %357 = OpBitFieldUExtract %u32_id %355 %u32_id_0 %u32_id_24
        %358 = OpIMul %u32_id %357 %u32_id_12
        %359 = OpBitFieldUExtract %u32_id %354 %u32_id_0 %u32_id_24
        %360 = OpIMul %u32_id %359 %u32_id_12
        %361 = OpBitFieldUExtract %u32_id %356 %u32_id_0 %u32_id_24
        %362 = OpIMul %u32_id %361 %u32_id_12
        %363 = OpFMul %f32_id %348 %206
        %364 = OpFMul %f32_id %173 %349
        %365 = OpFAdd %f32_id %364 %363
        %366 = OpFMul %f32_id %350 %211
        %367 = OpFAdd %f32_id %366 %365
        %368 = OpIAdd %u32_id %353 %u32_id_1024
        %369 = OpIAdd %u32_id %353 %u32_id_1024
        %370 = OpShiftRightLogical %u32_id %369 %u32_id_2
        %371 = OpIAdd %u32_id %370 %buf0_dword_off
        %372 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %371
        %373 = OpLoad %f32_id %372
        %374 = OpIAdd %u32_id %371 %u32_id_1
        %375 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %374
        %376 = OpLoad %f32_id %375
        %377 = OpIAdd %u32_id %371 %u32_id_2
        %378 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %377
        %379 = OpLoad %f32_id %378
        %380 = OpCompositeConstruct %f32vec3_id %373 %376 %379
        %381 = OpCompositeExtract %f32_id %380 0
        %382 = OpCompositeExtract %f32_id %380 1
        %383 = OpCompositeExtract %f32_id %380 2
        %384 = OpCompositeConstruct %f32vec4_id %381 %382 %383 %f32_id_0
        %385 = OpVectorShuffle %f32vec4_id %187 %384 4 5 6 7
        %386 = OpCompositeExtract %f32_id %385 0
        %387 = OpCompositeExtract %f32_id %385 1
        %388 = OpCompositeExtract %f32_id %385 2
        %389 = OpIAdd %u32_id %321 %u32_id_1024
        %390 = OpIAdd %u32_id %321 %u32_id_1024
        %391 = OpShiftRightLogical %u32_id %390 %u32_id_2
        %392 = OpIAdd %u32_id %391 %buf0_dword_off
        %393 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %392
        %394 = OpLoad %f32_id %393
        %395 = OpIAdd %u32_id %392 %u32_id_1
        %396 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %395
        %397 = OpLoad %f32_id %396
        %398 = OpIAdd %u32_id %392 %u32_id_2
        %399 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %398
        %400 = OpLoad %f32_id %399
        %401 = OpCompositeConstruct %f32vec3_id %394 %397 %400
        %402 = OpCompositeExtract %f32_id %401 0
        %403 = OpCompositeExtract %f32_id %401 1
        %404 = OpCompositeExtract %f32_id %401 2
        %405 = OpCompositeConstruct %f32vec4_id %402 %403 %404 %f32_id_0
        %406 = OpVectorShuffle %f32vec4_id %187 %405 4 5 6 7
        %407 = OpCompositeExtract %f32_id %406 0
        %408 = OpCompositeExtract %f32_id %406 1
        %409 = OpCompositeExtract %f32_id %406 2
        %410 = OpFNegate %f32_id %367
        %411 = OpFMul %f32_id %386 %213
        %412 = OpFAdd %f32_id %411 %410
        %413 = OpFMul %f32_id %173 %387
        %414 = OpFAdd %f32_id %413 %412
        %415 = OpFMul %f32_id %211 %388
        %416 = OpFAdd %f32_id %415 %414
        %417 = OpFMul %f32_id %407 %206
        %418 = OpFMul %f32_id %408 %223
        %419 = OpFAdd %f32_id %418 %417
        %420 = OpFMul %f32_id %211 %409
        %421 = OpFAdd %f32_id %420 %419
        %422 = OpFMul %f32_id %416 %222
        %423 = OpFAdd %f32_id %422 %367
        %424 = OpIAdd %u32_id %324 %u32_id_1024
        %425 = OpIAdd %u32_id %324 %u32_id_1024
        %426 = OpShiftRightLogical %u32_id %425 %u32_id_2
        %427 = OpIAdd %u32_id %426 %buf0_dword_off
        %428 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %427
        %429 = OpLoad %f32_id %428
        %430 = OpIAdd %u32_id %427 %u32_id_1
        %431 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %430
        %432 = OpLoad %f32_id %431
        %433 = OpIAdd %u32_id %427 %u32_id_2
        %434 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %433
        %435 = OpLoad %f32_id %434
        %436 = OpCompositeConstruct %f32vec3_id %429 %432 %435
        %437 = OpCompositeExtract %f32_id %436 0
        %438 = OpCompositeExtract %f32_id %436 1
        %439 = OpCompositeExtract %f32_id %436 2
        %440 = OpCompositeConstruct %f32vec4_id %437 %438 %439 %f32_id_0
        %441 = OpVectorShuffle %f32vec4_id %187 %440 4 5 6 7
        %442 = OpCompositeExtract %f32_id %441 0
        %443 = OpCompositeExtract %f32_id %441 1
        %444 = OpCompositeExtract %f32_id %441 2
        %445 = OpFSub %f32_id %421 %423
        %446 = OpFAdd %f32_id %f32_id_n1 %211
        %447 = OpFNegate %f32_id %421
        %448 = OpFMul %f32_id %442 %213
        %449 = OpFAdd %f32_id %448 %447
        %450 = OpFMul %f32_id %223 %443
        %451 = OpFAdd %f32_id %450 %449
        %452 = OpFMul %f32_id %211 %444
        %453 = OpFAdd %f32_id %452 %451
        %454 = OpFMul %f32_id %453 %222
        %455 = OpFAdd %f32_id %454 %445
        %456 = OpFMul %f32_id %233 %455
        %457 = OpFAdd %f32_id %456 %423
        %458 = OpIAdd %u32_id %328 %u32_id_1024
        %459 = OpIAdd %u32_id %328 %u32_id_1024
        %460 = OpShiftRightLogical %u32_id %459 %u32_id_2
        %461 = OpIAdd %u32_id %460 %buf0_dword_off
        %462 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %461
        %463 = OpLoad %f32_id %462
        %464 = OpIAdd %u32_id %461 %u32_id_1
        %465 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %464
        %466 = OpLoad %f32_id %465
        %467 = OpIAdd %u32_id %461 %u32_id_2
        %468 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %467
        %469 = OpLoad %f32_id %468
        %470 = OpCompositeConstruct %f32vec3_id %463 %466 %469
        %471 = OpCompositeExtract %f32_id %470 0
        %472 = OpCompositeExtract %f32_id %470 1
        %473 = OpCompositeExtract %f32_id %470 2
        %474 = OpCompositeConstruct %f32vec4_id %471 %472 %473 %f32_id_0
        %475 = OpVectorShuffle %f32vec4_id %187 %474 4 5 6 7
        %476 = OpCompositeExtract %f32_id %475 0
        %477 = OpCompositeExtract %f32_id %475 1
        %478 = OpCompositeExtract %f32_id %475 2
        %479 = OpIAdd %u32_id %358 %u32_id_1024
        %480 = OpIAdd %u32_id %358 %u32_id_1024
        %481 = OpShiftRightLogical %u32_id %480 %u32_id_2
        %482 = OpIAdd %u32_id %481 %buf0_dword_off
        %483 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %482
        %484 = OpLoad %f32_id %483
        %485 = OpIAdd %u32_id %482 %u32_id_1
        %486 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %485
        %487 = OpLoad %f32_id %486
        %488 = OpIAdd %u32_id %482 %u32_id_2
        %489 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %488
        %490 = OpLoad %f32_id %489
        %491 = OpCompositeConstruct %f32vec3_id %484 %487 %490
        %492 = OpCompositeExtract %f32_id %491 0
        %493 = OpCompositeExtract %f32_id %491 1
        %494 = OpCompositeExtract %f32_id %491 2
        %495 = OpCompositeConstruct %f32vec4_id %492 %493 %494 %f32_id_0
        %496 = OpVectorShuffle %f32vec4_id %187 %495 4 5 6 7
        %497 = OpCompositeExtract %f32_id %496 0
        %498 = OpCompositeExtract %f32_id %496 1
        %499 = OpCompositeExtract %f32_id %496 2
        %500 = OpIAdd %u32_id %362 %u32_id_1024
        %501 = OpIAdd %u32_id %362 %u32_id_1024
        %502 = OpShiftRightLogical %u32_id %501 %u32_id_2
        %503 = OpIAdd %u32_id %502 %buf0_dword_off
        %504 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %503
        %505 = OpLoad %f32_id %504
        %506 = OpIAdd %u32_id %503 %u32_id_1
        %507 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %506
        %508 = OpLoad %f32_id %507
        %509 = OpIAdd %u32_id %503 %u32_id_2
        %510 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %509
        %511 = OpLoad %f32_id %510
        %512 = OpCompositeConstruct %f32vec3_id %505 %508 %511
        %513 = OpCompositeExtract %f32_id %512 0
        %514 = OpCompositeExtract %f32_id %512 1
        %515 = OpCompositeExtract %f32_id %512 2
        %516 = OpCompositeConstruct %f32vec4_id %513 %514 %515 %f32_id_0
        %517 = OpVectorShuffle %f32vec4_id %187 %516 4 5 6 7
        %518 = OpCompositeExtract %f32_id %517 0
        %519 = OpCompositeExtract %f32_id %517 1
        %520 = OpCompositeExtract %f32_id %517 2
        %521 = OpExtInst %f32_id %166 Fma %217 %211 %f32_id_n15
        %522 = OpExtInst %f32_id %166 Fma %521 %211 %f32_id_10
        %523 = OpFMul %f32_id %211 %211
        %524 = OpFMul %f32_id %523 %211
        %525 = OpIAdd %u32_id %228 %u32_id_1
        %526 = OpBitwiseAnd %u32_id %u32_id_255 %525
        %527 = OpBitFieldUExtract %u32_id %526 %u32_id_0 %u32_id_24
        %528 = OpIMul %u32_id %527 %u32_id_4
        %529 = OpFMul %f32_id %524 %522
        %530 = OpBitFieldUExtract %u32_id %228 %u32_id_0 %u32_id_24
        %531 = OpIMul %u32_id %530 %u32_id_4
        %532 = OpConvertFToS %u32_id %253
        %533 = OpBitwiseAnd %u32_id %u32_id_255 %532
        %534 = OpFNegate %f32_id %253
        %535 = OpExtInst %f32_id %166 Trunc %534
        %536 = OpBitcast %f32_id %160
        %537 = OpFMul %f32_id %536 %f32_id_8
        %538 = OpFAdd %f32_id %537 %535
        %539 = OpBitcast %f32_id %160
        %540 = OpBitcast %f32_id %257
        %541 = OpFMul %f32_id %540 %539
        %542 = OpBitcast %u32_id %541
        %543 = OpFMul %f32_id %476 %206
        %544 = OpFMul %f32_id %173 %477
        %545 = OpFAdd %f32_id %544 %543
        %546 = OpFMul %f32_id %497 %206
        %547 = OpFMul %f32_id %446 %478
        %548 = OpFAdd %f32_id %547 %545
        %549 = OpFMul %f32_id %223 %498
        %550 = OpFAdd %f32_id %549 %546
        %551 = OpFMul %f32_id %446 %499
        %552 = OpFAdd %f32_id %551 %550
        %553 = OpFNegate %f32_id %552
        %554 = OpFMul %f32_id %518 %213
        %555 = OpFAdd %f32_id %554 %553
        %556 = OpFMul %f32_id %223 %519
        %557 = OpFAdd %f32_id %556 %555
        %558 = OpFMul %f32_id %446 %520
        %559 = OpFAdd %f32_id %558 %557
        %560 = OpBitcast %f32_id %159
        %561 = OpFMul %f32_id %f32_id_2 %560
        %562 = OpFMul %f32_id %240 %240
        %563 = OpFMul %f32_id %562 %240
        %564 = OpBitFieldUExtract %u32_id %245 %u32_id_0 %u32_id_24
        %565 = OpIMul %u32_id %564 %u32_id_4
        %566 = OpIAdd %u32_id %360 %u32_id_1024
        %567 = OpIAdd %u32_id %360 %u32_id_1024
        %568 = OpShiftRightLogical %u32_id %567 %u32_id_2
        %569 = OpIAdd %u32_id %568 %buf0_dword_off
        %570 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %569
        %571 = OpLoad %f32_id %570
        %572 = OpIAdd %u32_id %569 %u32_id_1
        %573 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %572
        %574 = OpLoad %f32_id %573
        %575 = OpIAdd %u32_id %569 %u32_id_2
        %576 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %575
        %577 = OpLoad %f32_id %576
        %578 = OpCompositeConstruct %f32vec3_id %571 %574 %577
        %579 = OpCompositeExtract %f32_id %578 0
        %580 = OpCompositeExtract %f32_id %578 1
        %581 = OpCompositeExtract %f32_id %578 2
        %582 = OpCompositeConstruct %f32vec4_id %579 %580 %581 %f32_id_0
        %583 = OpVectorShuffle %f32vec4_id %187 %582 4 5 6 7
        %584 = OpCompositeExtract %f32_id %583 0
        %585 = OpCompositeExtract %f32_id %583 1
        %586 = OpCompositeExtract %f32_id %583 2
        %587 = OpShiftRightLogical %u32_id %531 %u32_id_2
        %588 = OpIAdd %u32_id %587 %buf0_dword_off
        %589 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %588
        %590 = OpLoad %f32_id %589
        %591 = OpCompositeConstruct %f32vec4_id %590 %f32_id_0 %f32_id_0 %f32_id_0
        %592 = OpVectorShuffle %f32vec4_id %187 %591 4 5 6 4
        %593 = OpCompositeExtract %f32_id %592 0
        %594 = OpBitcast %u32_id %593
        %595 = OpShiftRightLogical %u32_id %528 %u32_id_2
        %596 = OpIAdd %u32_id %595 %buf0_dword_off
        %597 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %596
        %598 = OpLoad %f32_id %597
        %599 = OpCompositeConstruct %f32vec4_id %598 %f32_id_0 %f32_id_0 %f32_id_0
        %600 = OpVectorShuffle %f32vec4_id %187 %599 4 5 6 4
        %601 = OpCompositeExtract %f32_id %600 0
        %602 = OpBitcast %u32_id %601
        %603 = OpShiftRightLogical %u32_id %565 %u32_id_2
        %604 = OpIAdd %u32_id %603 %buf0_dword_off
        %605 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %604
        %606 = OpLoad %f32_id %605
        %607 = OpCompositeConstruct %f32vec4_id %606 %f32_id_0 %f32_id_0 %f32_id_0
        %608 = OpVectorShuffle %f32vec4_id %187 %607 4 5 6 4
        %609 = OpCompositeExtract %f32_id %608 0
        %610 = OpBitcast %u32_id %609
        %611 = OpIAdd %u32_id %245 %u32_id_1
        %612 = OpBitwiseAnd %u32_id %u32_id_255 %611
        %613 = OpBitFieldUExtract %u32_id %612 %u32_id_0 %u32_id_24
        %614 = OpIMul %u32_id %613 %u32_id_4
        %615 = OpFNegate %f32_id %548
        %616 = OpFMul %f32_id %584 %213
        %617 = OpFAdd %f32_id %616 %615
        %618 = OpFMul %f32_id %173 %585
        %619 = OpFAdd %f32_id %618 %617
        %620 = OpFMul %f32_id %446 %586
        %621 = OpFAdd %f32_id %620 %619
        %622 = OpFMul %f32_id %621 %222
        %623 = OpFAdd %f32_id %622 %548
        %624 = OpFSub %f32_id %552 %623
        %625 = OpFMul %f32_id %559 %222
        %626 = OpFAdd %f32_id %625 %624
        %627 = OpFSub %f32_id %623 %457
        %628 = OpFMul %f32_id %626 %233
        %629 = OpFAdd %f32_id %628 %627
        %630 = OpConvertFToS %u32_id %561
        %631 = OpFNegate %f32_id %235
        %632 = OpExtInst %f32_id %166 Trunc %631
        %633 = OpFNegate %f32_id %561
        %634 = OpExtInst %f32_id %166 Trunc %633
        %635 = OpBitcast %f32_id %158
        %636 = OpFMul %f32_id %f32_id_2 %635
        %637 = OpFAdd %f32_id %636 %632
        %638 = OpBitcast %f32_id %159
        %639 = OpFMul %f32_id %f32_id_2 %638
        %640 = OpFAdd %f32_id %639 %634
        %641 = OpFAdd %f32_id %f32_id_n1 %637
        %642 = OpExtInst %f32_id %166 Fma %217 %240 %f32_id_n15
        %643 = OpExtInst %f32_id %166 Fma %642 %240 %f32_id_10
        %644 = OpFMul %f32_id %563 %643
        %645 = OpFAdd %f32_id %f32_id_n1 %640
        %646 = OpFMul %f32_id %629 %529
        %647 = OpFAdd %f32_id %646 %457
        %648 = OpConvertFToS %u32_id %235
        %649 = OpIAdd %u32_id %594 %648
        %650 = OpBitwiseAnd %u32_id %u32_id_255 %649
        %651 = OpIAdd %u32_id %649 %u32_id_1
        %652 = OpBitFieldUExtract %u32_id %650 %u32_id_0 %u32_id_24
        %653 = OpIMul %u32_id %652 %u32_id_4
        %654 = OpBitwiseAnd %u32_id %u32_id_255 %651
        %655 = OpIAdd %u32_id %602 %648
        %656 = OpBitFieldUExtract %u32_id %654 %u32_id_0 %u32_id_24
        %657 = OpIMul %u32_id %656 %u32_id_4
        %658 = OpBitwiseAnd %u32_id %u32_id_255 %655
        %659 = OpBitFieldUExtract %u32_id %658 %u32_id_0 %u32_id_24
        %660 = OpIMul %u32_id %659 %u32_id_4
        %661 = OpShiftRightLogical %u32_id %653 %u32_id_2
        %662 = OpIAdd %u32_id %661 %buf0_dword_off
        %663 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %662
        %664 = OpLoad %f32_id %663
        %665 = OpCompositeConstruct %f32vec4_id %664 %f32_id_0 %f32_id_0 %f32_id_0
        %666 = OpVectorShuffle %f32vec4_id %187 %665 4 5 6 4
        %667 = OpCompositeExtract %f32_id %666 0
        %668 = OpBitcast %u32_id %667
        %669 = OpShiftRightLogical %u32_id %657 %u32_id_2
        %670 = OpIAdd %u32_id %669 %buf0_dword_off
        %671 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %670
        %672 = OpLoad %f32_id %671
        %673 = OpCompositeConstruct %f32vec4_id %672 %f32_id_0 %f32_id_0 %f32_id_0
        %674 = OpVectorShuffle %f32vec4_id %187 %673 4 5 6 4
        %675 = OpCompositeExtract %f32_id %674 0
        %676 = OpBitcast %u32_id %675
        %677 = OpShiftRightLogical %u32_id %660 %u32_id_2
        %678 = OpIAdd %u32_id %677 %buf0_dword_off
        %679 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %678
        %680 = OpLoad %f32_id %679
        %681 = OpCompositeConstruct %f32vec4_id %680 %f32_id_0 %f32_id_0 %f32_id_0
        %682 = OpVectorShuffle %f32vec4_id %187 %681 4 5 6 4
        %683 = OpCompositeExtract %f32_id %682 0
        %684 = OpBitcast %u32_id %683
        %685 = OpShiftRightLogical %u32_id %614 %u32_id_2
        %686 = OpIAdd %u32_id %685 %buf0_dword_off
        %687 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %686
        %688 = OpLoad %f32_id %687
        %689 = OpCompositeConstruct %f32vec4_id %688 %f32_id_0 %f32_id_0 %f32_id_0
        %690 = OpVectorShuffle %f32vec4_id %187 %689 4 5 6 4
        %691 = OpCompositeExtract %f32_id %690 0
        %692 = OpBitcast %u32_id %691
        %693 = OpIAdd %u32_id %655 %u32_id_1
        %694 = OpBitwiseAnd %u32_id %u32_id_255 %693
        %695 = OpBitFieldUExtract %u32_id %694 %u32_id_0 %u32_id_24
        %696 = OpIMul %u32_id %695 %u32_id_4
        %697 = OpFAdd %f32_id %f32_id_n1 %240
        %698 = OpExtInst %f32_id %166 Fma %217 %637 %f32_id_n15
        %699 = OpExtInst %f32_id %166 Fma %698 %637 %f32_id_10
        %700 = OpBitFieldUExtract %u32_id %533 %u32_id_0 %u32_id_24
        %701 = OpIMul %u32_id %700 %u32_id_4
        %702 = OpIAdd %u32_id %533 %u32_id_1
        %703 = OpBitwiseAnd %u32_id %u32_id_255 %702
        %704 = OpBitFieldUExtract %u32_id %703 %u32_id_0 %u32_id_24
        %705 = OpIMul %u32_id %704 %u32_id_4
        %706 = OpShiftRightLogical %u32_id %696 %u32_id_2
        %707 = OpIAdd %u32_id %706 %buf0_dword_off
        %708 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %707
        %709 = OpLoad %f32_id %708
        %710 = OpCompositeConstruct %f32vec4_id %709 %f32_id_0 %f32_id_0 %f32_id_0
        %711 = OpVectorShuffle %f32vec4_id %187 %710 4 5 6 4
        %712 = OpCompositeExtract %f32_id %711 0
        %713 = OpBitcast %u32_id %712
        %714 = OpShiftRightLogical %u32_id %701 %u32_id_2
        %715 = OpIAdd %u32_id %714 %buf0_dword_off
        %716 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %715
        %717 = OpLoad %f32_id %716
        %718 = OpCompositeConstruct %f32vec4_id %717 %f32_id_0 %f32_id_0 %f32_id_0
        %719 = OpVectorShuffle %f32vec4_id %187 %718 4 5 6 4
        %720 = OpCompositeExtract %f32_id %719 0
        %721 = OpBitcast %u32_id %720
        %722 = OpShiftRightLogical %u32_id %705 %u32_id_2
        %723 = OpIAdd %u32_id %722 %buf0_dword_off
        %724 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %723
        %725 = OpLoad %f32_id %724
        %726 = OpCompositeConstruct %f32vec4_id %725 %f32_id_0 %f32_id_0 %f32_id_0
        %727 = OpVectorShuffle %f32vec4_id %187 %726 4 5 6 4
        %728 = OpCompositeExtract %f32_id %727 0
        %729 = OpBitcast %u32_id %728
        %730 = OpBitcast %f32_id %157
        %732 = OpFMul %f32_id %f32_id_0_5 %647
        %733 = OpFAdd %f32_id %732 %730
        %734 = OpFMul %f32_id %637 %637
        %735 = OpFMul %f32_id %734 %637
        %736 = OpFMul %f32_id %735 %699
        %737 = OpIAdd %u32_id %668 %630
        %738 = OpBitwiseAnd %u32_id %u32_id_15 %737
        %739 = OpBitFieldUExtract %u32_id %738 %u32_id_0 %u32_id_24
        %740 = OpIMul %u32_id %739 %u32_id_12
        %741 = OpIAdd %u32_id %684 %630
        %742 = OpIAdd %u32_id %676 %630
        %743 = OpIAdd %u32_id %737 %u32_id_1
        %744 = OpBitwiseAnd %u32_id %u32_id_15 %743
        %745 = OpBitwiseAnd %u32_id %u32_id_15 %742
        %746 = OpBitFieldUExtract %u32_id %745 %u32_id_0 %u32_id_24
        %747 = OpIMul %u32_id %746 %u32_id_12
        %748 = OpIAdd %u32_id %742 %u32_id_1
        %749 = OpBitwiseAnd %u32_id %u32_id_15 %748
        %750 = OpIAdd %u32_id %713 %630
        %751 = OpBitwiseAnd %u32_id %u32_id_15 %741
        %752 = OpIAdd %u32_id %741 %u32_id_1
        %753 = OpBitFieldUExtract %u32_id %751 %u32_id_0 %u32_id_24
        %754 = OpIMul %u32_id %753 %u32_id_12
        %755 = OpBitwiseAnd %u32_id %u32_id_15 %752
        %756 = OpBitFieldUExtract %u32_id %744 %u32_id_0 %u32_id_24
        %757 = OpIMul %u32_id %756 %u32_id_12
        %758 = OpBitFieldUExtract %u32_id %749 %u32_id_0 %u32_id_24
        %759 = OpIMul %u32_id %758 %u32_id_12
        %760 = OpBitwiseAnd %u32_id %u32_id_15 %750
        %761 = OpBitFieldUExtract %u32_id %760 %u32_id_0 %u32_id_24
        %762 = OpIMul %u32_id %761 %u32_id_12
        %763 = OpIAdd %u32_id %750 %u32_id_1
        %764 = OpBitFieldUExtract %u32_id %755 %u32_id_0 %u32_id_24
        %765 = OpIMul %u32_id %764 %u32_id_12
        %766 = OpIAdd %u32_id %740 %u32_id_1024
        %767 = OpIAdd %u32_id %740 %u32_id_1024
        %768 = OpShiftRightLogical %u32_id %767 %u32_id_2
        %769 = OpIAdd %u32_id %768 %buf0_dword_off
        %770 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %769
        %771 = OpLoad %f32_id %770
        %772 = OpIAdd %u32_id %769 %u32_id_1
        %773 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %772
        %774 = OpLoad %f32_id %773
        %775 = OpIAdd %u32_id %769 %u32_id_2
        %776 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %775
        %777 = OpLoad %f32_id %776
        %778 = OpCompositeConstruct %f32vec3_id %771 %774 %777
        %779 = OpCompositeExtract %f32_id %778 0
        %780 = OpCompositeExtract %f32_id %778 1
        %781 = OpCompositeExtract %f32_id %778 2
        %782 = OpCompositeConstruct %f32vec4_id %779 %780 %781 %f32_id_0
        %783 = OpVectorShuffle %f32vec4_id %187 %782 4 5 6 7
        %784 = OpCompositeExtract %f32_id %783 0
        %785 = OpCompositeExtract %f32_id %783 1
        %786 = OpCompositeExtract %f32_id %783 2
        %787 = OpIAdd %u32_id %754 %u32_id_1024
        %788 = OpIAdd %u32_id %754 %u32_id_1024
        %789 = OpShiftRightLogical %u32_id %788 %u32_id_2
        %790 = OpIAdd %u32_id %789 %buf0_dword_off
        %791 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %790
        %792 = OpLoad %f32_id %791
        %793 = OpIAdd %u32_id %790 %u32_id_1
        %794 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %793
        %795 = OpLoad %f32_id %794
        %796 = OpIAdd %u32_id %790 %u32_id_2
        %797 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %796
        %798 = OpLoad %f32_id %797
        %799 = OpCompositeConstruct %f32vec3_id %792 %795 %798
        %800 = OpCompositeExtract %f32_id %799 0
        %801 = OpCompositeExtract %f32_id %799 1
        %802 = OpCompositeExtract %f32_id %799 2
        %803 = OpCompositeConstruct %f32vec4_id %800 %801 %802 %f32_id_0
        %804 = OpVectorShuffle %f32vec4_id %187 %803 4 5 6 7
        %805 = OpCompositeExtract %f32_id %804 0
        %806 = OpCompositeExtract %f32_id %804 1
        %807 = OpCompositeExtract %f32_id %804 2
        %808 = OpBitwiseAnd %u32_id %u32_id_15 %763
        %809 = OpBitFieldUExtract %u32_id %808 %u32_id_0 %u32_id_24
        %810 = OpIMul %u32_id %809 %u32_id_12
        %811 = OpFMul %f32_id %784 %240
        %812 = OpFMul %f32_id %637 %785
        %813 = OpFAdd %f32_id %812 %811
        %814 = OpFMul %f32_id %786 %640
        %815 = OpFAdd %f32_id %814 %813
        %816 = OpFNegate %f32_id %815
        %817 = OpFMul %f32_id %805 %697
        %818 = OpFAdd %f32_id %817 %816
        %819 = OpFMul %f32_id %637 %806
        %820 = OpFAdd %f32_id %819 %818
        %821 = OpFMul %f32_id %640 %807
        %822 = OpFAdd %f32_id %821 %820
        %823 = OpFMul %f32_id %822 %644
        %824 = OpFAdd %f32_id %823 %815
        %825 = OpIAdd %u32_id %747 %u32_id_1024
        %826 = OpIAdd %u32_id %747 %u32_id_1024
        %827 = OpShiftRightLogical %u32_id %826 %u32_id_2
        %828 = OpIAdd %u32_id %827 %buf0_dword_off
        %829 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %828
        %830 = OpLoad %f32_id %829
        %831 = OpIAdd %u32_id %828 %u32_id_1
        %832 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %831
        %833 = OpLoad %f32_id %832
        %834 = OpIAdd %u32_id %828 %u32_id_2
        %835 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %834
        %836 = OpLoad %f32_id %835
        %837 = OpCompositeConstruct %f32vec3_id %830 %833 %836
        %838 = OpCompositeExtract %f32_id %837 0
        %839 = OpCompositeExtract %f32_id %837 1
        %840 = OpCompositeExtract %f32_id %837 2
        %841 = OpCompositeConstruct %f32vec4_id %838 %839 %840 %f32_id_0
        %842 = OpVectorShuffle %f32vec4_id %187 %841 4 5 6 7
        %843 = OpCompositeExtract %f32_id %842 0
        %844 = OpCompositeExtract %f32_id %842 1
        %845 = OpCompositeExtract %f32_id %842 2
        %846 = OpIAdd %u32_id %762 %u32_id_1024
        %847 = OpIAdd %u32_id %762 %u32_id_1024
        %848 = OpShiftRightLogical %u32_id %847 %u32_id_2
        %849 = OpIAdd %u32_id %848 %buf0_dword_off
        %850 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %849
        %851 = OpLoad %f32_id %850
        %852 = OpIAdd %u32_id %849 %u32_id_1
        %853 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %852
        %854 = OpLoad %f32_id %853
        %855 = OpIAdd %u32_id %849 %u32_id_2
        %856 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %855
        %857 = OpLoad %f32_id %856
        %858 = OpCompositeConstruct %f32vec3_id %851 %854 %857
        %859 = OpCompositeExtract %f32_id %858 0
        %860 = OpCompositeExtract %f32_id %858 1
        %861 = OpCompositeExtract %f32_id %858 2
        %862 = OpCompositeConstruct %f32vec4_id %859 %860 %861 %f32_id_0
        %863 = OpVectorShuffle %f32vec4_id %187 %862 4 5 6 7
        %864 = OpCompositeExtract %f32_id %863 0
        %865 = OpCompositeExtract %f32_id %863 1
        %866 = OpCompositeExtract %f32_id %863 2
        %867 = OpFMul %f32_id %843 %240
        %868 = OpFMul %f32_id %844 %641
        %869 = OpFAdd %f32_id %868 %867
        %870 = OpFMul %f32_id %640 %845
        %871 = OpFAdd %f32_id %870 %869
        %872 = OpFSub %f32_id %871 %824
        %873 = OpFNegate %f32_id %871
        %874 = OpFMul %f32_id %864 %697
        %875 = OpFAdd %f32_id %874 %873
        %876 = OpFMul %f32_id %641 %865
        %877 = OpFAdd %f32_id %876 %875
        %878 = OpFMul %f32_id %640 %866
        %879 = OpFAdd %f32_id %878 %877
        %880 = OpFMul %f32_id %879 %644
        %881 = OpFAdd %f32_id %880 %872
        %882 = OpFMul %f32_id %736 %881
        %883 = OpFAdd %f32_id %882 %824
        %884 = OpIAdd %u32_id %757 %u32_id_1024
        %885 = OpIAdd %u32_id %757 %u32_id_1024
        %886 = OpShiftRightLogical %u32_id %885 %u32_id_2
        %887 = OpIAdd %u32_id %886 %buf0_dword_off
        %888 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %887
        %889 = OpLoad %f32_id %888
        %890 = OpIAdd %u32_id %887 %u32_id_1
        %891 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %890
        %892 = OpLoad %f32_id %891
        %893 = OpIAdd %u32_id %887 %u32_id_2
        %894 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %893
        %895 = OpLoad %f32_id %894
        %896 = OpCompositeConstruct %f32vec3_id %889 %892 %895
        %897 = OpCompositeExtract %f32_id %896 0
        %898 = OpCompositeExtract %f32_id %896 1
        %899 = OpCompositeExtract %f32_id %896 2
        %900 = OpCompositeConstruct %f32vec4_id %897 %898 %899 %f32_id_0
        %901 = OpVectorShuffle %f32vec4_id %187 %900 4 5 6 7
        %902 = OpCompositeExtract %f32_id %901 0
        %903 = OpCompositeExtract %f32_id %901 1
        %904 = OpCompositeExtract %f32_id %901 2
        %905 = OpIAdd %u32_id %759 %u32_id_1024
        %906 = OpIAdd %u32_id %759 %u32_id_1024
        %907 = OpShiftRightLogical %u32_id %906 %u32_id_2
        %908 = OpIAdd %u32_id %907 %buf0_dword_off
        %909 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %908
        %910 = OpLoad %f32_id %909
        %911 = OpIAdd %u32_id %908 %u32_id_1
        %912 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %911
        %913 = OpLoad %f32_id %912
        %914 = OpIAdd %u32_id %908 %u32_id_2
        %915 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %914
        %916 = OpLoad %f32_id %915
        %917 = OpCompositeConstruct %f32vec3_id %910 %913 %916
        %918 = OpCompositeExtract %f32_id %917 0
        %919 = OpCompositeExtract %f32_id %917 1
        %920 = OpCompositeExtract %f32_id %917 2
        %921 = OpCompositeConstruct %f32vec4_id %918 %919 %920 %f32_id_0
        %922 = OpVectorShuffle %f32vec4_id %187 %921 4 5 6 7
        %923 = OpCompositeExtract %f32_id %922 0
        %924 = OpCompositeExtract %f32_id %922 1
        %925 = OpCompositeExtract %f32_id %922 2
        %926 = OpIAdd %u32_id %765 %u32_id_1024
        %927 = OpIAdd %u32_id %765 %u32_id_1024
        %928 = OpShiftRightLogical %u32_id %927 %u32_id_2
        %929 = OpIAdd %u32_id %928 %buf0_dword_off
        %930 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %929
        %931 = OpLoad %f32_id %930
        %932 = OpIAdd %u32_id %929 %u32_id_1
        %933 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %932
        %934 = OpLoad %f32_id %933
        %935 = OpIAdd %u32_id %929 %u32_id_2
        %936 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %935
        %937 = OpLoad %f32_id %936
        %938 = OpCompositeConstruct %f32vec3_id %931 %934 %937
        %939 = OpCompositeExtract %f32_id %938 0
        %940 = OpCompositeExtract %f32_id %938 1
        %941 = OpCompositeExtract %f32_id %938 2
        %942 = OpCompositeConstruct %f32vec4_id %939 %940 %941 %f32_id_0
        %943 = OpVectorShuffle %f32vec4_id %187 %942 4 5 6 7
        %944 = OpCompositeExtract %f32_id %943 0
        %945 = OpCompositeExtract %f32_id %943 1
        %946 = OpCompositeExtract %f32_id %943 2
        %947 = OpIAdd %u32_id %810 %u32_id_1024
        %948 = OpIAdd %u32_id %810 %u32_id_1024
        %949 = OpShiftRightLogical %u32_id %948 %u32_id_2
        %950 = OpIAdd %u32_id %949 %buf0_dword_off
        %951 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %950
        %952 = OpLoad %f32_id %951
        %953 = OpIAdd %u32_id %950 %u32_id_1
        %954 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %953
        %955 = OpLoad %f32_id %954
        %956 = OpIAdd %u32_id %950 %u32_id_2
        %957 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %956
        %958 = OpLoad %f32_id %957
        %959 = OpCompositeConstruct %f32vec3_id %952 %955 %958
        %960 = OpCompositeExtract %f32_id %959 0
        %961 = OpCompositeExtract %f32_id %959 1
        %962 = OpCompositeExtract %f32_id %959 2
        %963 = OpCompositeConstruct %f32vec4_id %960 %961 %962 %f32_id_0
        %964 = OpVectorShuffle %f32vec4_id %187 %963 4 5 6 7
        %965 = OpCompositeExtract %f32_id %964 0
        %966 = OpCompositeExtract %f32_id %964 1
        %967 = OpCompositeExtract %f32_id %964 2
        %968 = OpExtInst %f32_id %166 Fma %217 %640 %f32_id_n15
        %969 = OpExtInst %f32_id %166 Fma %968 %640 %f32_id_10
        %970 = OpFMul %f32_id %640 %640
        %971 = OpFMul %f32_id %970 %640
        %972 = OpBitcast %f32_id %159
        %973 = OpFMul %f32_id %f32_id_4 %972
        %974 = OpFMul %f32_id %971 %969
        %975 = OpBitcast %f32_id %158
        %976 = OpFMul %f32_id %f32_id_4 %975
        %977 = OpFMul %f32_id %902 %240
        %978 = OpFMul %f32_id %637 %903
        %979 = OpFAdd %f32_id %978 %977
        %980 = OpFMul %f32_id %923 %240
        %981 = OpFMul %f32_id %645 %904
        %982 = OpFAdd %f32_id %981 %979
        %983 = OpFNegate %f32_id %982
        %984 = OpFMul %f32_id %944 %697
        %985 = OpFAdd %f32_id %984 %983
        %986 = OpFMul %f32_id %641 %924
        %987 = OpFAdd %f32_id %986 %980
        %988 = OpFMul %f32_id %637 %945
        %989 = OpFAdd %f32_id %988 %985
        %990 = OpFMul %f32_id %645 %925
        %991 = OpFAdd %f32_id %990 %987
        %992 = OpFNegate %f32_id %991
        %993 = OpFMul %f32_id %965 %697
        %994 = OpFAdd %f32_id %993 %992
        %995 = OpFMul %f32_id %645 %946
        %996 = OpFAdd %f32_id %995 %989
        %997 = OpFMul %f32_id %996 %644
        %998 = OpFAdd %f32_id %997 %982
        %999 = OpFMul %f32_id %641 %966
       %1000 = OpFAdd %f32_id %999 %994
       %1001 = OpFMul %f32_id %645 %967
       %1002 = OpFAdd %f32_id %1001 %1000
       %1003 = OpFSub %f32_id %991 %998
       %1004 = OpFMul %f32_id %1002 %644
       %1005 = OpFAdd %f32_id %1004 %1003
       %1006 = OpFSub %f32_id %998 %883
       %1007 = OpFMul %f32_id %1005 %736
       %1008 = OpFAdd %f32_id %1007 %1006
       %1009 = OpConvertFToS %u32_id %973
       %1010 = OpFNegate %f32_id %976
       %1011 = OpExtInst %f32_id %166 Trunc %1010
       %1012 = OpFMul %f32_id %250 %250
       %1013 = OpFMul %f32_id %1012 %250
       %1014 = OpBitcast %f32_id %158
       %1015 = OpFMul %f32_id %f32_id_4 %1014
       %1016 = OpFAdd %f32_id %1015 %1011
       %1017 = OpFAdd %f32_id %f32_id_n1 %250
       %1018 = OpFAdd %f32_id %f32_id_n1 %1016
       %1019 = OpExtInst %f32_id %166 Fma %217 %250 %f32_id_n15
       %1020 = OpExtInst %f32_id %166 Fma %1019 %250 %f32_id_10
       %1021 = OpFMul %f32_id %1013 %1020
       %1022 = OpFMul %f32_id %1008 %974
       %1023 = OpFAdd %f32_id %1022 %883
       %1024 = OpConvertFToS %u32_id %976
       %1025 = OpIAdd %u32_id %610 %1024
       %1026 = OpBitwiseAnd %u32_id %u32_id_255 %1025
       %1027 = OpIAdd %u32_id %1025 %u32_id_1
       %1028 = OpBitFieldUExtract %u32_id %1026 %u32_id_0 %u32_id_24
       %1029 = OpIMul %u32_id %1028 %u32_id_4
       %1030 = OpBitwiseAnd %u32_id %u32_id_255 %1027
       %1031 = OpIAdd %u32_id %692 %1024
       %1032 = OpBitFieldUExtract %u32_id %1030 %u32_id_0 %u32_id_24
       %1033 = OpIMul %u32_id %1032 %u32_id_4
       %1034 = OpBitwiseAnd %u32_id %u32_id_255 %1031
       %1035 = OpBitFieldUExtract %u32_id %1034 %u32_id_0 %u32_id_24
       %1036 = OpIMul %u32_id %1035 %u32_id_4
       %1037 = OpShiftRightLogical %u32_id %1029 %u32_id_2
       %1038 = OpIAdd %u32_id %1037 %buf0_dword_off
       %1039 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1038
       %1040 = OpLoad %f32_id %1039
       %1041 = OpCompositeConstruct %f32vec4_id %1040 %f32_id_0 %f32_id_0 %f32_id_0
       %1042 = OpVectorShuffle %f32vec4_id %187 %1041 4 5 6 4
       %1043 = OpCompositeExtract %f32_id %1042 0
       %1044 = OpBitcast %u32_id %1043
       %1045 = OpShiftRightLogical %u32_id %1033 %u32_id_2
       %1046 = OpIAdd %u32_id %1045 %buf0_dword_off
       %1047 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1046
       %1048 = OpLoad %f32_id %1047
       %1049 = OpCompositeConstruct %f32vec4_id %1048 %f32_id_0 %f32_id_0 %f32_id_0
       %1050 = OpVectorShuffle %f32vec4_id %187 %1049 4 5 6 4
       %1051 = OpCompositeExtract %f32_id %1050 0
       %1052 = OpBitcast %u32_id %1051
       %1053 = OpShiftRightLogical %u32_id %1036 %u32_id_2
       %1054 = OpIAdd %u32_id %1053 %buf0_dword_off
       %1055 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1054
       %1056 = OpLoad %f32_id %1055
       %1057 = OpCompositeConstruct %f32vec4_id %1056 %f32_id_0 %f32_id_0 %f32_id_0
       %1058 = OpVectorShuffle %f32vec4_id %187 %1057 4 5 6 4
       %1059 = OpCompositeExtract %f32_id %1058 0
       %1060 = OpBitcast %u32_id %1059
       %1061 = OpIAdd %u32_id %1031 %u32_id_1
       %1062 = OpBitwiseAnd %u32_id %u32_id_255 %1061
       %1063 = OpBitFieldUExtract %u32_id %1062 %u32_id_0 %u32_id_24
       %1064 = OpIMul %u32_id %1063 %u32_id_4
       %1065 = OpShiftRightLogical %u32_id %1064 %u32_id_2
       %1066 = OpIAdd %u32_id %1065 %buf0_dword_off
       %1067 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1066
       %1068 = OpLoad %f32_id %1067
       %1069 = OpCompositeConstruct %f32vec4_id %1068 %f32_id_0 %f32_id_0 %f32_id_0
       %1070 = OpVectorShuffle %f32vec4_id %187 %1069 4 5 6 4
       %1071 = OpCompositeExtract %f32_id %1070 0
       %1072 = OpBitcast %u32_id %1071
       %1073 = OpFNegate %f32_id %973
       %1074 = OpExtInst %f32_id %166 Trunc %1073
       %1075 = OpBitcast %f32_id %159
       %1076 = OpFMul %f32_id %f32_id_4 %1075
       %1077 = OpFAdd %f32_id %1076 %1074
       %1078 = OpExtInst %f32_id %166 Fma %217 %1016 %f32_id_n15
       %1079 = OpExtInst %f32_id %166 Fma %1078 %1016 %f32_id_10
       %1080 = OpBitcast %f32_id %158
       %1081 = OpFMul %f32_id %f32_id_8 %1080
       %1082 = OpBitcast %f32_id %159
       %1083 = OpFMul %f32_id %f32_id_8 %1082
       %1085 = OpFMul %f32_id %1023 %f32_id_0_25
       %1086 = OpFAdd %f32_id %1085 %733
       %1087 = OpFMul %f32_id %1016 %1016
       %1088 = OpFMul %f32_id %1087 %1016
       %1089 = OpFMul %f32_id %1088 %1079
       %1090 = OpExtInst %f32_id %166 Fma %217 %538 %f32_id_n15
       %1091 = OpExtInst %f32_id %166 Fma %1090 %538 %f32_id_10
       %1092 = OpIAdd %u32_id %1044 %1009
       %1093 = OpBitwiseAnd %u32_id %u32_id_15 %1092
       %1094 = OpBitFieldUExtract %u32_id %1093 %u32_id_0 %u32_id_24
       %1095 = OpIMul %u32_id %1094 %u32_id_12
       %1096 = OpIAdd %u32_id %1060 %1009
       %1097 = OpIAdd %u32_id %1052 %1009
       %1098 = OpIAdd %u32_id %1092 %u32_id_1
       %1099 = OpBitwiseAnd %u32_id %u32_id_15 %1098
       %1100 = OpBitwiseAnd %u32_id %u32_id_15 %1097
       %1101 = OpBitFieldUExtract %u32_id %1100 %u32_id_0 %u32_id_24
       %1102 = OpIMul %u32_id %1101 %u32_id_12
       %1103 = OpIAdd %u32_id %1072 %1009
       %1104 = OpBitwiseAnd %u32_id %u32_id_15 %1096
       %1105 = OpIAdd %u32_id %1096 %u32_id_1
       %1106 = OpBitFieldUExtract %u32_id %1104 %u32_id_0 %u32_id_24
       %1107 = OpIMul %u32_id %1106 %u32_id_12
       %1108 = OpBitwiseAnd %u32_id %u32_id_15 %1105
       %1109 = OpBitwiseAnd %u32_id %u32_id_15 %1103
       %1110 = OpBitFieldUExtract %u32_id %1109 %u32_id_0 %u32_id_24
       %1111 = OpIMul %u32_id %1110 %u32_id_12
       %1112 = OpIAdd %u32_id %1097 %u32_id_1
       %1113 = OpBitFieldUExtract %u32_id %1099 %u32_id_0 %u32_id_24
       %1114 = OpIMul %u32_id %1113 %u32_id_12
       %1115 = OpBitwiseAnd %u32_id %u32_id_15 %1112
       %1116 = OpBitFieldUExtract %u32_id %1115 %u32_id_0 %u32_id_24
       %1117 = OpIMul %u32_id %1116 %u32_id_12
       %1118 = OpIAdd %u32_id %1103 %u32_id_1
       %1119 = OpBitFieldUExtract %u32_id %1108 %u32_id_0 %u32_id_24
       %1120 = OpIMul %u32_id %1119 %u32_id_12
       %1121 = OpIAdd %u32_id %1095 %u32_id_1024
       %1122 = OpIAdd %u32_id %1095 %u32_id_1024
       %1123 = OpShiftRightLogical %u32_id %1122 %u32_id_2
       %1124 = OpIAdd %u32_id %1123 %buf0_dword_off
       %1125 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1124
       %1126 = OpLoad %f32_id %1125
       %1127 = OpIAdd %u32_id %1124 %u32_id_1
       %1128 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1127
       %1129 = OpLoad %f32_id %1128
       %1130 = OpIAdd %u32_id %1124 %u32_id_2
       %1131 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1130
       %1132 = OpLoad %f32_id %1131
       %1133 = OpCompositeConstruct %f32vec3_id %1126 %1129 %1132
       %1134 = OpCompositeExtract %f32_id %1133 0
       %1135 = OpCompositeExtract %f32_id %1133 1
       %1136 = OpCompositeExtract %f32_id %1133 2
       %1137 = OpCompositeConstruct %f32vec4_id %1134 %1135 %1136 %f32_id_0
       %1138 = OpVectorShuffle %f32vec4_id %187 %1137 4 5 6 7
       %1139 = OpCompositeExtract %f32_id %1138 0
       %1140 = OpCompositeExtract %f32_id %1138 1
       %1141 = OpCompositeExtract %f32_id %1138 2
       %1142 = OpIAdd %u32_id %1107 %u32_id_1024
       %1143 = OpIAdd %u32_id %1107 %u32_id_1024
       %1144 = OpShiftRightLogical %u32_id %1143 %u32_id_2
       %1145 = OpIAdd %u32_id %1144 %buf0_dword_off
       %1146 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1145
       %1147 = OpLoad %f32_id %1146
       %1148 = OpIAdd %u32_id %1145 %u32_id_1
       %1149 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1148
       %1150 = OpLoad %f32_id %1149
       %1151 = OpIAdd %u32_id %1145 %u32_id_2
       %1152 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1151
       %1153 = OpLoad %f32_id %1152
       %1154 = OpCompositeConstruct %f32vec3_id %1147 %1150 %1153
       %1155 = OpCompositeExtract %f32_id %1154 0
       %1156 = OpCompositeExtract %f32_id %1154 1
       %1157 = OpCompositeExtract %f32_id %1154 2
       %1158 = OpCompositeConstruct %f32vec4_id %1155 %1156 %1157 %f32_id_0
       %1159 = OpVectorShuffle %f32vec4_id %187 %1158 4 5 6 7
       %1160 = OpCompositeExtract %f32_id %1159 0
       %1161 = OpCompositeExtract %f32_id %1159 1
       %1162 = OpCompositeExtract %f32_id %1159 2
       %1163 = OpBitwiseAnd %u32_id %u32_id_15 %1118
       %1164 = OpBitFieldUExtract %u32_id %1163 %u32_id_0 %u32_id_24
       %1165 = OpIMul %u32_id %1164 %u32_id_12
       %1166 = OpFMul %f32_id %1139 %250
       %1167 = OpFMul %f32_id %1016 %1140
       %1168 = OpFAdd %f32_id %1167 %1166
       %1169 = OpFMul %f32_id %1141 %1077
       %1170 = OpFAdd %f32_id %1169 %1168
       %1171 = OpFNegate %f32_id %1170
       %1172 = OpFMul %f32_id %1160 %1017
       %1173 = OpFAdd %f32_id %1172 %1171
       %1174 = OpFMul %f32_id %1016 %1161
       %1175 = OpFAdd %f32_id %1174 %1173
       %1176 = OpFMul %f32_id %1077 %1162
       %1177 = OpFAdd %f32_id %1176 %1175
       %1178 = OpFMul %f32_id %1177 %1021
       %1179 = OpFAdd %f32_id %1178 %1170
       %1180 = OpIAdd %u32_id %1102 %u32_id_1024
       %1181 = OpIAdd %u32_id %1102 %u32_id_1024
       %1182 = OpShiftRightLogical %u32_id %1181 %u32_id_2
       %1183 = OpIAdd %u32_id %1182 %buf0_dword_off
       %1184 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1183
       %1185 = OpLoad %f32_id %1184
       %1186 = OpIAdd %u32_id %1183 %u32_id_1
       %1187 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1186
       %1188 = OpLoad %f32_id %1187
       %1189 = OpIAdd %u32_id %1183 %u32_id_2
       %1190 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1189
       %1191 = OpLoad %f32_id %1190
       %1192 = OpCompositeConstruct %f32vec3_id %1185 %1188 %1191
       %1193 = OpCompositeExtract %f32_id %1192 0
       %1194 = OpCompositeExtract %f32_id %1192 1
       %1195 = OpCompositeExtract %f32_id %1192 2
       %1196 = OpCompositeConstruct %f32vec4_id %1193 %1194 %1195 %f32_id_0
       %1197 = OpVectorShuffle %f32vec4_id %187 %1196 4 5 6 7
       %1198 = OpCompositeExtract %f32_id %1197 0
       %1199 = OpCompositeExtract %f32_id %1197 1
       %1200 = OpCompositeExtract %f32_id %1197 2
       %1201 = OpIAdd %u32_id %1111 %u32_id_1024
       %1202 = OpIAdd %u32_id %1111 %u32_id_1024
       %1203 = OpShiftRightLogical %u32_id %1202 %u32_id_2
       %1204 = OpIAdd %u32_id %1203 %buf0_dword_off
       %1205 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1204
       %1206 = OpLoad %f32_id %1205
       %1207 = OpIAdd %u32_id %1204 %u32_id_1
       %1208 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1207
       %1209 = OpLoad %f32_id %1208
       %1210 = OpIAdd %u32_id %1204 %u32_id_2
       %1211 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1210
       %1212 = OpLoad %f32_id %1211
       %1213 = OpCompositeConstruct %f32vec3_id %1206 %1209 %1212
       %1214 = OpCompositeExtract %f32_id %1213 0
       %1215 = OpCompositeExtract %f32_id %1213 1
       %1216 = OpCompositeExtract %f32_id %1213 2
       %1217 = OpCompositeConstruct %f32vec4_id %1214 %1215 %1216 %f32_id_0
       %1218 = OpVectorShuffle %f32vec4_id %187 %1217 4 5 6 7
       %1219 = OpCompositeExtract %f32_id %1218 0
       %1220 = OpCompositeExtract %f32_id %1218 1
       %1221 = OpCompositeExtract %f32_id %1218 2
       %1222 = OpFAdd %f32_id %f32_id_n1 %1077
       %1223 = OpFMul %f32_id %1198 %250
       %1224 = OpFMul %f32_id %1199 %1018
       %1225 = OpFAdd %f32_id %1224 %1223
       %1226 = OpFMul %f32_id %1077 %1200
       %1227 = OpFAdd %f32_id %1226 %1225
       %1228 = OpFSub %f32_id %1227 %1179
       %1229 = OpFNegate %f32_id %1227
       %1230 = OpFMul %f32_id %1219 %1017
       %1231 = OpFAdd %f32_id %1230 %1229
       %1232 = OpFMul %f32_id %1018 %1220
       %1233 = OpFAdd %f32_id %1232 %1231
       %1234 = OpFMul %f32_id %1077 %1221
       %1235 = OpFAdd %f32_id %1234 %1233
       %1236 = OpFMul %f32_id %1235 %1021
       %1237 = OpFAdd %f32_id %1236 %1228
       %1238 = OpFMul %f32_id %1089 %1237
       %1239 = OpFAdd %f32_id %1238 %1179
       %1240 = OpIAdd %u32_id %1114 %u32_id_1024
       %1241 = OpIAdd %u32_id %1114 %u32_id_1024
       %1242 = OpShiftRightLogical %u32_id %1241 %u32_id_2
       %1243 = OpIAdd %u32_id %1242 %buf0_dword_off
       %1244 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1243
       %1245 = OpLoad %f32_id %1244
       %1246 = OpIAdd %u32_id %1243 %u32_id_1
       %1247 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1246
       %1248 = OpLoad %f32_id %1247
       %1249 = OpIAdd %u32_id %1243 %u32_id_2
       %1250 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1249
       %1251 = OpLoad %f32_id %1250
       %1252 = OpCompositeConstruct %f32vec3_id %1245 %1248 %1251
       %1253 = OpCompositeExtract %f32_id %1252 0
       %1254 = OpCompositeExtract %f32_id %1252 1
       %1255 = OpCompositeExtract %f32_id %1252 2
       %1256 = OpCompositeConstruct %f32vec4_id %1253 %1254 %1255 %f32_id_0
       %1257 = OpVectorShuffle %f32vec4_id %187 %1256 4 5 6 7
       %1258 = OpCompositeExtract %f32_id %1257 0
       %1259 = OpCompositeExtract %f32_id %1257 1
       %1260 = OpCompositeExtract %f32_id %1257 2
       %1261 = OpIAdd %u32_id %1117 %u32_id_1024
       %1262 = OpIAdd %u32_id %1117 %u32_id_1024
       %1263 = OpShiftRightLogical %u32_id %1262 %u32_id_2
       %1264 = OpIAdd %u32_id %1263 %buf0_dword_off
       %1265 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1264
       %1266 = OpLoad %f32_id %1265
       %1267 = OpIAdd %u32_id %1264 %u32_id_1
       %1268 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1267
       %1269 = OpLoad %f32_id %1268
       %1270 = OpIAdd %u32_id %1264 %u32_id_2
       %1271 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1270
       %1272 = OpLoad %f32_id %1271
       %1273 = OpCompositeConstruct %f32vec3_id %1266 %1269 %1272
       %1274 = OpCompositeExtract %f32_id %1273 0
       %1275 = OpCompositeExtract %f32_id %1273 1
       %1276 = OpCompositeExtract %f32_id %1273 2
       %1277 = OpCompositeConstruct %f32vec4_id %1274 %1275 %1276 %f32_id_0
       %1278 = OpVectorShuffle %f32vec4_id %187 %1277 4 5 6 7
       %1279 = OpCompositeExtract %f32_id %1278 0
       %1280 = OpCompositeExtract %f32_id %1278 1
       %1281 = OpCompositeExtract %f32_id %1278 2
       %1282 = OpIAdd %u32_id %1120 %u32_id_1024
       %1283 = OpIAdd %u32_id %1120 %u32_id_1024
       %1284 = OpShiftRightLogical %u32_id %1283 %u32_id_2
       %1285 = OpIAdd %u32_id %1284 %buf0_dword_off
       %1286 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1285
       %1287 = OpLoad %f32_id %1286
       %1288 = OpIAdd %u32_id %1285 %u32_id_1
       %1289 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1288
       %1290 = OpLoad %f32_id %1289
       %1291 = OpIAdd %u32_id %1285 %u32_id_2
       %1292 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1291
       %1293 = OpLoad %f32_id %1292
       %1294 = OpCompositeConstruct %f32vec3_id %1287 %1290 %1293
       %1295 = OpCompositeExtract %f32_id %1294 0
       %1296 = OpCompositeExtract %f32_id %1294 1
       %1297 = OpCompositeExtract %f32_id %1294 2
       %1298 = OpCompositeConstruct %f32vec4_id %1295 %1296 %1297 %f32_id_0
       %1299 = OpVectorShuffle %f32vec4_id %187 %1298 4 5 6 7
       %1300 = OpCompositeExtract %f32_id %1299 0
       %1301 = OpCompositeExtract %f32_id %1299 1
       %1302 = OpCompositeExtract %f32_id %1299 2
       %1303 = OpIAdd %u32_id %1165 %u32_id_1024
       %1304 = OpIAdd %u32_id %1165 %u32_id_1024
       %1305 = OpShiftRightLogical %u32_id %1304 %u32_id_2
       %1306 = OpIAdd %u32_id %1305 %buf0_dword_off
       %1307 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1306
       %1308 = OpLoad %f32_id %1307
       %1309 = OpIAdd %u32_id %1306 %u32_id_1
       %1310 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1309
       %1311 = OpLoad %f32_id %1310
       %1312 = OpIAdd %u32_id %1306 %u32_id_2
       %1313 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1312
       %1314 = OpLoad %f32_id %1313
       %1315 = OpCompositeConstruct %f32vec3_id %1308 %1311 %1314
       %1316 = OpCompositeExtract %f32_id %1315 0
       %1317 = OpCompositeExtract %f32_id %1315 1
       %1318 = OpCompositeExtract %f32_id %1315 2
       %1319 = OpCompositeConstruct %f32vec4_id %1316 %1317 %1318 %f32_id_0
       %1320 = OpVectorShuffle %f32vec4_id %187 %1319 4 5 6 7
       %1321 = OpCompositeExtract %f32_id %1320 0
       %1322 = OpCompositeExtract %f32_id %1320 1
       %1323 = OpCompositeExtract %f32_id %1320 2
       %1324 = OpExtInst %f32_id %166 Fma %217 %1077 %f32_id_n15
       %1325 = OpExtInst %f32_id %166 Fma %1324 %1077 %f32_id_10
       %1326 = OpFMul %f32_id %1077 %1077
       %1327 = OpFMul %f32_id %1326 %1077
       %1328 = OpConvertFToS %u32_id %1083
       %1329 = OpFMul %f32_id %1327 %1325
       %1330 = OpConvertFToS %u32_id %1081
       %1331 = OpIAdd %u32_id %721 %1330
       %1332 = OpIAdd %u32_id %729 %1330
       %1333 = OpFNegate %f32_id %1083
       %1334 = OpExtInst %f32_id %166 Trunc %1333
       %1335 = OpBitcast %f32_id %159
       %1336 = OpFMul %f32_id %1335 %f32_id_8
       %1337 = OpFAdd %f32_id %1336 %1334
       %1338 = OpFMul %f32_id %538 %538
       %1339 = OpFMul %f32_id %1338 %538
       %1340 = OpFMul %f32_id %1339 %1091
       %1341 = OpFAdd %f32_id %f32_id_n1 %1337
       %1342 = OpBitcast %f32_id %159
       %1343 = OpBitcast %f32_id %257
       %1344 = OpFMul %f32_id %1343 %1342
       %1345 = OpBitcast %u32_id %1344
       %1346 = OpFMul %f32_id %1258 %250
       %1347 = OpFMul %f32_id %1016 %1259
       %1348 = OpFAdd %f32_id %1347 %1346
       %1349 = OpFMul %f32_id %1279 %250
       %1350 = OpFMul %f32_id %1222 %1260
       %1351 = OpFAdd %f32_id %1350 %1348
       %1352 = OpFNegate %f32_id %1351
       %1353 = OpFMul %f32_id %1300 %1017
       %1354 = OpFAdd %f32_id %1353 %1352
       %1355 = OpFMul %f32_id %1018 %1280
       %1356 = OpFAdd %f32_id %1355 %1349
       %1357 = OpFMul %f32_id %1016 %1301
       %1358 = OpFAdd %f32_id %1357 %1354
       %1359 = OpFMul %f32_id %1222 %1281
       %1360 = OpFAdd %f32_id %1359 %1356
       %1361 = OpFNegate %f32_id %1360
       %1362 = OpFMul %f32_id %1321 %1017
       %1363 = OpFAdd %f32_id %1362 %1361
       %1364 = OpFMul %f32_id %1222 %1302
       %1365 = OpFAdd %f32_id %1364 %1358
       %1366 = OpFMul %f32_id %1365 %1021
       %1367 = OpFAdd %f32_id %1366 %1351
       %1368 = OpFMul %f32_id %1018 %1322
       %1369 = OpFAdd %f32_id %1368 %1363
       %1370 = OpFMul %f32_id %1222 %1323
       %1371 = OpFAdd %f32_id %1370 %1369
       %1372 = OpFSub %f32_id %1360 %1367
       %1373 = OpFNegate %f32_id %1081
       %1374 = OpExtInst %f32_id %166 Trunc %1373
       %1375 = OpFMul %f32_id %1371 %1021
       %1376 = OpFAdd %f32_id %1375 %1372
       %1377 = OpFSub %f32_id %1367 %1239
       %1378 = OpIAdd %u32_id %1331 %u32_id_1
       %1379 = OpFMul %f32_id %1376 %1089
       %1380 = OpFAdd %f32_id %1379 %1377
       %1381 = OpIAdd %u32_id %1332 %u32_id_1
       %1382 = OpBitwiseAnd %u32_id %u32_id_255 %1381
       %1383 = OpBitFieldUExtract %u32_id %1382 %u32_id_0 %u32_id_24
       %1384 = OpIMul %u32_id %1383 %u32_id_4
       %1385 = OpBitcast %f32_id %158
       %1386 = OpFMul %f32_id %1385 %f32_id_8
       %1387 = OpFAdd %f32_id %1386 %1374
       %1388 = OpBitwiseAnd %u32_id %u32_id_255 %1331
       %1389 = OpFMul %f32_id %1380 %1329
       %1390 = OpFAdd %f32_id %1389 %1239
       %1391 = OpBitFieldUExtract %u32_id %1388 %u32_id_0 %u32_id_24
       %1392 = OpIMul %u32_id %1391 %u32_id_4
       %1393 = OpBitwiseAnd %u32_id %u32_id_255 %1378
       %1394 = OpBitwiseAnd %u32_id %u32_id_255 %1332
       %1395 = OpBitFieldUExtract %u32_id %1394 %u32_id_0 %u32_id_24
       %1396 = OpIMul %u32_id %1395 %u32_id_4
       %1397 = OpBitFieldUExtract %u32_id %1393 %u32_id_0 %u32_id_24
       %1398 = OpIMul %u32_id %1397 %u32_id_4
       %1399 = OpShiftRightLogical %u32_id %1392 %u32_id_2
       %1400 = OpIAdd %u32_id %1399 %buf0_dword_off
       %1401 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1400
       %1402 = OpLoad %f32_id %1401
       %1403 = OpCompositeConstruct %f32vec4_id %1402 %f32_id_0 %f32_id_0 %f32_id_0
       %1404 = OpVectorShuffle %f32vec4_id %187 %1403 4 5 6 4
       %1405 = OpCompositeExtract %f32_id %1404 0
       %1406 = OpBitcast %u32_id %1405
       %1407 = OpShiftRightLogical %u32_id %1396 %u32_id_2
       %1408 = OpIAdd %u32_id %1407 %buf0_dword_off
       %1409 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1408
       %1410 = OpLoad %f32_id %1409
       %1411 = OpCompositeConstruct %f32vec4_id %1410 %f32_id_0 %f32_id_0 %f32_id_0
       %1412 = OpVectorShuffle %f32vec4_id %187 %1411 4 5 6 4
       %1413 = OpCompositeExtract %f32_id %1412 0
       %1414 = OpBitcast %u32_id %1413
       %1415 = OpShiftRightLogical %u32_id %1398 %u32_id_2
       %1416 = OpIAdd %u32_id %1415 %buf0_dword_off
       %1417 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1416
       %1418 = OpLoad %f32_id %1417
       %1419 = OpCompositeConstruct %f32vec4_id %1418 %f32_id_0 %f32_id_0 %f32_id_0
       %1420 = OpVectorShuffle %f32vec4_id %187 %1419 4 5 6 4
       %1421 = OpCompositeExtract %f32_id %1420 0
       %1422 = OpBitcast %u32_id %1421
       %1423 = OpShiftRightLogical %u32_id %1384 %u32_id_2
       %1424 = OpIAdd %u32_id %1423 %buf0_dword_off
       %1425 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1424
       %1426 = OpLoad %f32_id %1425
       %1427 = OpCompositeConstruct %f32vec4_id %1426 %f32_id_0 %f32_id_0 %f32_id_0
       %1428 = OpVectorShuffle %f32vec4_id %187 %1427 4 5 6 4
       %1429 = OpCompositeExtract %f32_id %1428 0
       %1430 = OpBitcast %u32_id %1429
       %1431 = OpFAdd %f32_id %f32_id_n1 %538
       %1432 = OpExtInst %f32_id %166 Fma %217 %1387 %f32_id_n15
       %1433 = OpFMul %f32_id %1387 %1387
       %1434 = OpExtInst %f32_id %166 Fma %1432 %1387 %f32_id_10
       %1435 = OpFMul %f32_id %1433 %1387
       %1436 = OpFMul %f32_id %1435 %1434
       %1437 = OpExtInst %f32_id %166 Fma %217 %1337 %f32_id_n15
       %1438 = OpFMul %f32_id %1337 %1337
       %1439 = OpExtInst %f32_id %166 Fma %1437 %1337 %f32_id_10
       %1440 = OpFMul %f32_id %1438 %1337
       %1441 = OpFMul %f32_id %1440 %1439
       %1443 = OpFMul %f32_id %1390 %f32_id_0_125
       %1444 = OpFAdd %f32_id %1443 %1086
       %1445 = OpFAdd %f32_id %f32_id_n1 %1387
       %1446 = OpBitcast %f32_id %158
       %1447 = OpBitcast %f32_id %257
       %1448 = OpFMul %f32_id %1447 %1446
       %1449 = OpBitcast %u32_id %1448
       %1450 = OpIAdd %u32_id %1406 %1328
       %1451 = OpBitwiseAnd %u32_id %u32_id_15 %1450
       %1452 = OpIAdd %u32_id %1414 %1328
       %1453 = OpBitFieldUExtract %u32_id %1451 %u32_id_0 %u32_id_24
       %1454 = OpIMul %u32_id %1453 %u32_id_12
       %1455 = OpBitwiseAnd %u32_id %u32_id_15 %1452
       %1456 = OpIAdd %u32_id %1452 %u32_id_1
       %1457 = OpBitFieldUExtract %u32_id %1455 %u32_id_0 %u32_id_24
       %1458 = OpIMul %u32_id %1457 %u32_id_12
       %1459 = OpBitwiseAnd %u32_id %u32_id_15 %1456
       %1460 = OpIAdd %u32_id %1422 %1328
       %1461 = OpIAdd %u32_id %1450 %u32_id_1
       %1462 = OpBitwiseAnd %u32_id %u32_id_15 %1461
       %1463 = OpBitwiseAnd %u32_id %u32_id_15 %1460
       %1464 = OpIAdd %u32_id %1460 %u32_id_1
       %1465 = OpBitFieldUExtract %u32_id %1463 %u32_id_0 %u32_id_24
       %1466 = OpIMul %u32_id %1465 %u32_id_12
       %1467 = OpBitwiseAnd %u32_id %u32_id_15 %1464
       %1468 = OpIAdd %u32_id %1430 %1328
       %1469 = OpBitwiseAnd %u32_id %u32_id_15 %1468
       %1470 = OpBitFieldUExtract %u32_id %1469 %u32_id_0 %u32_id_24
       %1471 = OpIMul %u32_id %1470 %u32_id_12
       %1472 = OpBitFieldUExtract %u32_id %1462 %u32_id_0 %u32_id_24
       %1473 = OpIMul %u32_id %1472 %u32_id_12
       %1474 = OpBitFieldUExtract %u32_id %1467 %u32_id_0 %u32_id_24
       %1475 = OpIMul %u32_id %1474 %u32_id_12
       %1476 = OpBitFieldUExtract %u32_id %1459 %u32_id_0 %u32_id_24
       %1477 = OpIMul %u32_id %1476 %u32_id_12
       %1478 = OpIAdd %u32_id %1454 %u32_id_1024
       %1479 = OpIAdd %u32_id %1454 %u32_id_1024
       %1480 = OpShiftRightLogical %u32_id %1479 %u32_id_2
       %1481 = OpIAdd %u32_id %1480 %buf0_dword_off
       %1482 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1481
       %1483 = OpLoad %f32_id %1482
       %1484 = OpIAdd %u32_id %1481 %u32_id_1
       %1485 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1484
       %1486 = OpLoad %f32_id %1485
       %1487 = OpIAdd %u32_id %1481 %u32_id_2
       %1488 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1487
       %1489 = OpLoad %f32_id %1488
       %1490 = OpCompositeConstruct %f32vec3_id %1483 %1486 %1489
       %1491 = OpCompositeExtract %f32_id %1490 0
       %1492 = OpCompositeExtract %f32_id %1490 1
       %1493 = OpCompositeExtract %f32_id %1490 2
       %1494 = OpCompositeConstruct %f32vec4_id %1491 %1492 %1493 %f32_id_0
       %1495 = OpVectorShuffle %f32vec4_id %187 %1494 4 5 6 7
       %1496 = OpCompositeExtract %f32_id %1495 0
       %1497 = OpCompositeExtract %f32_id %1495 1
       %1498 = OpCompositeExtract %f32_id %1495 2
       %1499 = OpIAdd %u32_id %1458 %u32_id_1024
       %1500 = OpIAdd %u32_id %1458 %u32_id_1024
       %1501 = OpShiftRightLogical %u32_id %1500 %u32_id_2
       %1502 = OpIAdd %u32_id %1501 %buf0_dword_off
       %1503 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1502
       %1504 = OpLoad %f32_id %1503
       %1505 = OpIAdd %u32_id %1502 %u32_id_1
       %1506 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1505
       %1507 = OpLoad %f32_id %1506
       %1508 = OpIAdd %u32_id %1502 %u32_id_2
       %1509 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1508
       %1510 = OpLoad %f32_id %1509
       %1511 = OpCompositeConstruct %f32vec3_id %1504 %1507 %1510
       %1512 = OpCompositeExtract %f32_id %1511 0
       %1513 = OpCompositeExtract %f32_id %1511 1
       %1514 = OpCompositeExtract %f32_id %1511 2
       %1515 = OpCompositeConstruct %f32vec4_id %1512 %1513 %1514 %f32_id_0
       %1516 = OpVectorShuffle %f32vec4_id %187 %1515 4 5 6 7
       %1517 = OpCompositeExtract %f32_id %1516 0
       %1518 = OpCompositeExtract %f32_id %1516 1
       %1519 = OpCompositeExtract %f32_id %1516 2
       %1520 = OpIAdd %u32_id %1466 %u32_id_1024
       %1521 = OpIAdd %u32_id %1466 %u32_id_1024
       %1522 = OpShiftRightLogical %u32_id %1521 %u32_id_2
       %1523 = OpIAdd %u32_id %1522 %buf0_dword_off
       %1524 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1523
       %1525 = OpLoad %f32_id %1524
       %1526 = OpIAdd %u32_id %1523 %u32_id_1
       %1527 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1526
       %1528 = OpLoad %f32_id %1527
       %1529 = OpIAdd %u32_id %1523 %u32_id_2
       %1530 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1529
       %1531 = OpLoad %f32_id %1530
       %1532 = OpCompositeConstruct %f32vec3_id %1525 %1528 %1531
       %1533 = OpCompositeExtract %f32_id %1532 0
       %1534 = OpCompositeExtract %f32_id %1532 1
       %1535 = OpCompositeExtract %f32_id %1532 2
       %1536 = OpCompositeConstruct %f32vec4_id %1533 %1534 %1535 %f32_id_0
       %1537 = OpVectorShuffle %f32vec4_id %187 %1536 4 5 6 7
       %1538 = OpCompositeExtract %f32_id %1537 0
       %1539 = OpCompositeExtract %f32_id %1537 1
       %1540 = OpCompositeExtract %f32_id %1537 2
       %1541 = OpIAdd %u32_id %1468 %u32_id_1
       %1542 = OpBitwiseAnd %u32_id %u32_id_15 %1541
       %1543 = OpBitFieldUExtract %u32_id %1542 %u32_id_0 %u32_id_24
       %1544 = OpIMul %u32_id %1543 %u32_id_12
       %1545 = OpFMul %f32_id %1496 %538
       %1546 = OpFMul %f32_id %1387 %1497
       %1547 = OpFAdd %f32_id %1546 %1545
       %1548 = OpFMul %f32_id %1498 %1337
       %1549 = OpFAdd %f32_id %1548 %1547
       %1550 = OpFNegate %f32_id %1549
       %1551 = OpFMul %f32_id %1517 %1431
       %1552 = OpFAdd %f32_id %1551 %1550
       %1553 = OpFMul %f32_id %1387 %1518
       %1554 = OpFAdd %f32_id %1553 %1552
       %1555 = OpFMul %f32_id %1337 %1519
       %1556 = OpFAdd %f32_id %1555 %1554
       %1557 = OpFMul %f32_id %1538 %538
       %1558 = OpFMul %f32_id %1539 %1445
       %1559 = OpFAdd %f32_id %1558 %1557
       %1560 = OpFMul %f32_id %1337 %1540
       %1561 = OpFAdd %f32_id %1560 %1559
       %1562 = OpFMul %f32_id %1556 %1340
       %1563 = OpFAdd %f32_id %1562 %1549
       %1564 = OpIAdd %u32_id %1471 %u32_id_1024
       %1565 = OpIAdd %u32_id %1471 %u32_id_1024
       %1566 = OpShiftRightLogical %u32_id %1565 %u32_id_2
       %1567 = OpIAdd %u32_id %1566 %buf0_dword_off
       %1568 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1567
       %1569 = OpLoad %f32_id %1568
       %1570 = OpIAdd %u32_id %1567 %u32_id_1
       %1571 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1570
       %1572 = OpLoad %f32_id %1571
       %1573 = OpIAdd %u32_id %1567 %u32_id_2
       %1574 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1573
       %1575 = OpLoad %f32_id %1574
       %1576 = OpCompositeConstruct %f32vec3_id %1569 %1572 %1575
       %1577 = OpCompositeExtract %f32_id %1576 0
       %1578 = OpCompositeExtract %f32_id %1576 1
       %1579 = OpCompositeExtract %f32_id %1576 2
       %1580 = OpCompositeConstruct %f32vec4_id %1577 %1578 %1579 %f32_id_0
       %1581 = OpVectorShuffle %f32vec4_id %187 %1580 4 5 6 7
       %1582 = OpCompositeExtract %f32_id %1581 0
       %1583 = OpCompositeExtract %f32_id %1581 1
       %1584 = OpCompositeExtract %f32_id %1581 2
       %1585 = OpIAdd %u32_id %1473 %u32_id_1024
       %1586 = OpIAdd %u32_id %1473 %u32_id_1024
       %1587 = OpShiftRightLogical %u32_id %1586 %u32_id_2
       %1588 = OpIAdd %u32_id %1587 %buf0_dword_off
       %1589 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1588
       %1590 = OpLoad %f32_id %1589
       %1591 = OpIAdd %u32_id %1588 %u32_id_1
       %1592 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1591
       %1593 = OpLoad %f32_id %1592
       %1594 = OpIAdd %u32_id %1588 %u32_id_2
       %1595 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1594
       %1596 = OpLoad %f32_id %1595
       %1597 = OpCompositeConstruct %f32vec3_id %1590 %1593 %1596
       %1598 = OpCompositeExtract %f32_id %1597 0
       %1599 = OpCompositeExtract %f32_id %1597 1
       %1600 = OpCompositeExtract %f32_id %1597 2
       %1601 = OpCompositeConstruct %f32vec4_id %1598 %1599 %1600 %f32_id_0
       %1602 = OpVectorShuffle %f32vec4_id %187 %1601 4 5 6 7
       %1603 = OpCompositeExtract %f32_id %1602 0
       %1604 = OpCompositeExtract %f32_id %1602 1
       %1605 = OpCompositeExtract %f32_id %1602 2
       %1606 = OpFSub %f32_id %1561 %1563
       %1607 = OpFNegate %f32_id %1561
       %1608 = OpFMul %f32_id %1582 %1431
       %1609 = OpFAdd %f32_id %1608 %1607
       %1610 = OpFMul %f32_id %1445 %1583
       %1611 = OpFAdd %f32_id %1610 %1609
       %1612 = OpFMul %f32_id %1337 %1584
       %1613 = OpFAdd %f32_id %1612 %1611
       %1614 = OpFMul %f32_id %1613 %1340
       %1615 = OpFAdd %f32_id %1614 %1606
       %1616 = OpFMul %f32_id %1603 %538
       %1617 = OpFMul %f32_id %1604 %1387
       %1618 = OpFAdd %f32_id %1617 %1616
       %1619 = OpFMul %f32_id %1341 %1605
       %1620 = OpFAdd %f32_id %1619 %1618
       %1621 = OpFMul %f32_id %1436 %1615
       %1622 = OpFAdd %f32_id %1621 %1563
       %1623 = OpIAdd %u32_id %1475 %u32_id_1024
       %1624 = OpIAdd %u32_id %1475 %u32_id_1024
       %1625 = OpShiftRightLogical %u32_id %1624 %u32_id_2
       %1626 = OpIAdd %u32_id %1625 %buf0_dword_off
       %1627 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1626
       %1628 = OpLoad %f32_id %1627
       %1629 = OpIAdd %u32_id %1626 %u32_id_1
       %1630 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1629
       %1631 = OpLoad %f32_id %1630
       %1632 = OpIAdd %u32_id %1626 %u32_id_2
       %1633 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1632
       %1634 = OpLoad %f32_id %1633
       %1635 = OpCompositeConstruct %f32vec3_id %1628 %1631 %1634
       %1636 = OpCompositeExtract %f32_id %1635 0
       %1637 = OpCompositeExtract %f32_id %1635 1
       %1638 = OpCompositeExtract %f32_id %1635 2
       %1639 = OpCompositeConstruct %f32vec4_id %1636 %1637 %1638 %f32_id_0
       %1640 = OpVectorShuffle %f32vec4_id %187 %1639 4 5 6 7
       %1641 = OpCompositeExtract %f32_id %1640 0
       %1642 = OpCompositeExtract %f32_id %1640 1
       %1643 = OpCompositeExtract %f32_id %1640 2
       %1644 = OpIAdd %u32_id %1477 %u32_id_1024
       %1645 = OpIAdd %u32_id %1477 %u32_id_1024
       %1646 = OpShiftRightLogical %u32_id %1645 %u32_id_2
       %1647 = OpIAdd %u32_id %1646 %buf0_dword_off
       %1648 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1647
       %1649 = OpLoad %f32_id %1648
       %1650 = OpIAdd %u32_id %1647 %u32_id_1
       %1651 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1650
       %1652 = OpLoad %f32_id %1651
       %1653 = OpIAdd %u32_id %1647 %u32_id_2
       %1654 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1653
       %1655 = OpLoad %f32_id %1654
       %1656 = OpCompositeConstruct %f32vec3_id %1649 %1652 %1655
       %1657 = OpCompositeExtract %f32_id %1656 0
       %1658 = OpCompositeExtract %f32_id %1656 1
       %1659 = OpCompositeExtract %f32_id %1656 2
       %1660 = OpCompositeConstruct %f32vec4_id %1657 %1658 %1659 %f32_id_0
       %1661 = OpVectorShuffle %f32vec4_id %187 %1660 4 5 6 7
       %1662 = OpCompositeExtract %f32_id %1661 0
       %1663 = OpCompositeExtract %f32_id %1661 1
       %1664 = OpCompositeExtract %f32_id %1661 2
       %1665 = OpIAdd %u32_id %1544 %u32_id_1024
       %1666 = OpIAdd %u32_id %1544 %u32_id_1024
       %1667 = OpShiftRightLogical %u32_id %1666 %u32_id_2
       %1668 = OpIAdd %u32_id %1667 %buf0_dword_off
       %1669 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1668
       %1670 = OpLoad %f32_id %1669
       %1671 = OpIAdd %u32_id %1668 %u32_id_1
       %1672 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1671
       %1673 = OpLoad %f32_id %1672
       %1674 = OpIAdd %u32_id %1668 %u32_id_2
       %1675 = OpAccessChain %_ptr_StorageBuffer_f32_id %ssbo_1_0 %u32_id_0 %1674
       %1676 = OpLoad %f32_id %1675
       %1677 = OpCompositeConstruct %f32vec3_id %1670 %1673 %1676
       %1678 = OpCompositeExtract %f32_id %1677 0
       %1679 = OpCompositeExtract %f32_id %1677 1
       %1680 = OpCompositeExtract %f32_id %1677 2
       %1681 = OpCompositeConstruct %f32vec4_id %1678 %1679 %1680 %f32_id_0
       %1682 = OpVectorShuffle %f32vec4_id %187 %1681 4 5 6 7
       %1683 = OpCompositeExtract %f32_id %1682 0
       %1684 = OpCompositeExtract %f32_id %1682 1
       %1685 = OpCompositeExtract %f32_id %1682 2
       %1686 = OpFMul %f32_id %1641 %538
       %1687 = OpFNegate %f32_id %1620
       %1688 = OpFMul %f32_id %1662 %1431
       %1689 = OpFAdd %f32_id %1688 %1687
       %1690 = OpFMul %f32_id %1445 %1642
       %1691 = OpFAdd %f32_id %1690 %1686
       %1692 = OpFMul %f32_id %1341 %1643
       %1693 = OpFAdd %f32_id %1692 %1691
       %1694 = OpFMul %f32_id %1387 %1663
       %1695 = OpFAdd %f32_id %1694 %1689
       %1696 = OpFNegate %f32_id %1693
       %1697 = OpFMul %f32_id %1683 %1431
       %1698 = OpFAdd %f32_id %1697 %1696
       %1699 = OpFMul %f32_id %1341 %1664
       %1700 = OpFAdd %f32_id %1699 %1695
       %1701 = OpFMul %f32_id %1445 %1684
       %1702 = OpFAdd %f32_id %1701 %1698
       %1703 = OpFMul %f32_id %1700 %1340
       %1704 = OpFAdd %f32_id %1703 %1620
       %1705 = OpFMul %f32_id %1341 %1685
       %1706 = OpFAdd %f32_id %1705 %1702
       %1707 = OpFSub %f32_id %1693 %1704
       %1708 = OpFMul %f32_id %1706 %1340
       %1709 = OpFAdd %f32_id %1708 %1707
       %1710 = OpFSub %f32_id %1704 %1622
       %1711 = OpFMul %f32_id %1709 %1436
       %1712 = OpFAdd %f32_id %1711 %1710
       %1713 = OpFMul %f32_id %1712 %1441
       %1714 = OpFAdd %f32_id %1713 %1622
       %1716 = OpFMul %f32_id %1714 %f32_id_0_0625
       %1717 = OpFAdd %f32_id %1716 %1444
       %1718 = OpBitcast %u32_id %1717
               OpBranch %84
         %84 = OpLabel
               OpBranchConditional %true %81 %85
         %85 = OpLabel
       %1719 = OpPhi %u32_id %157 %82 %1718 %84
       %1720 = OpIAdd %u32_id %137 %u32_id_1
       %1721 = OpSGreaterThan %bool_id %u32_id_0 %1720
       %1723 = OpIAdd %u32_id %137 %u32_id_4294967295
       %1724 = OpIAdd %u32_id %135 %1720
       %1725 = OpSGreaterThan %bool_id %u32_id_0 %1723
       %1726 = OpIAdd %u32_id %135 %1723
       %1727 = OpIAdd %u32_id %136 %u32_id_1
       %1728 = OpSGreaterThan %bool_id %u32_id_0 %137
       %1729 = OpIAdd %u32_id %135 %137
       %1730 = OpIAdd %u32_id %136 %u32_id_4294967295
       %1731 = OpBitcast %f32_id %1720
       %1732 = OpBitcast %f32_id %1724
       %1733 = OpSelect %f32_id %1721 %1732 %1731
       %1734 = OpBitcast %u32_id %1733
       %1735 = OpSGreaterThan %bool_id %u32_id_0 %136
       %1736 = OpIAdd %u32_id %132 %136
       %1737 = OpBitcast %f32_id %136
       %1738 = OpBitcast %f32_id %1736
       %1739 = OpSelect %f32_id %1735 %1738 %1737
       %1740 = OpBitcast %u32_id %1739
       %1741 = OpBitcast %f32_id %1723
       %1742 = OpBitcast %f32_id %1726
       %1743 = OpSelect %f32_id %1725 %1742 %1741
       %1744 = OpBitcast %u32_id %1743
       %1745 = OpSGreaterThan %bool_id %u32_id_0 %1727
       %1746 = OpIAdd %u32_id %132 %1727
       %1747 = OpBitcast %f32_id %137
       %1748 = OpBitcast %f32_id %1729
       %1749 = OpSelect %f32_id %1728 %1748 %1747
       %1750 = OpBitcast %u32_id %1749
       %1751 = OpSGreaterThan %bool_id %u32_id_0 %1730
       %1752 = OpIAdd %u32_id %132 %1730
       %1753 = OpSLessThanEqual %bool_id %135 %1734
       %1754 = OpSLessThanEqual %bool_id %135 %1744
       %1755 = OpISub %u32_id %1744 %135
       %1756 = OpBitcast %f32_id %1727
       %1757 = OpBitcast %f32_id %1746
       %1758 = OpSelect %f32_id %1745 %1757 %1756
       %1759 = OpBitcast %u32_id %1758
       %1760 = OpSLessThanEqual %bool_id %135 %1750
       %1761 = OpISub %u32_id %1750 %135
       %1762 = OpBitcast %f32_id %1730
       %1763 = OpBitcast %f32_id %1752
       %1764 = OpSelect %f32_id %1751 %1763 %1762
       %1765 = OpBitcast %u32_id %1764
       %1766 = OpSLessThanEqual %bool_id %132 %1740
       %1767 = OpISub %u32_id %1734 %135
       %1768 = OpBitcast %f32_id %1755
       %1769 = OpSelect %f32_id %1754 %1768 %1743
       %1770 = OpBitcast %u32_id %1769
       %1771 = OpSLessThanEqual %bool_id %132 %1759
       %1772 = OpISub %u32_id %1759 %132
       %1773 = OpBitcast %f32_id %1761
       %1774 = OpSelect %f32_id %1760 %1773 %1749
       %1775 = OpBitcast %u32_id %1774
       %1776 = OpSLessThanEqual %bool_id %132 %1765
       %1777 = OpISub %u32_id %1765 %132
       %1778 = OpIMul %u32_id %132 %137
       %1779 = OpBitcast %f32_id %1767
       %1780 = OpSelect %f32_id %1753 %1779 %1733
       %1781 = OpBitcast %u32_id %1780
       %1782 = OpISub %u32_id %1740 %132
       %1783 = OpBitcast %f32_id %1782
       %1784 = OpSelect %f32_id %1766 %1783 %1739
       %1785 = OpBitcast %u32_id %1784
       %1786 = OpIMul %u32_id %132 %1770
       %1787 = OpBitcast %f32_id %1772
       %1788 = OpSelect %f32_id %1771 %1787 %1758
       %1789 = OpBitcast %u32_id %1788
       %1790 = OpIMul %u32_id %132 %1775
       %1791 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
       %1794 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_31
       %1795 = OpLoad %u32_id %1794
       %1796 = OpBitcast %f32_id %1777
       %1797 = OpSelect %f32_id %1776 %1796 %1764
       %1798 = OpBitcast %u32_id %1797
       %1799 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
       %1802 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_35
       %1803 = OpLoad %u32_id %1802
       %1804 = OpIMul %u32_id %132 %1781
       %1805 = OpIAdd %u32_id %1785 %1786
       %1806 = OpIAdd %u32_id %1789 %1790
       %1807 = OpIAdd %u32_id %1798 %1790
       %1808 = OpIAdd %u32_id %1785 %1804
       %1809 = OpIAdd %u32_id %136 %1778
       %1810 = OpIAdd %u32_id %1809 %buf1_dword_off
       %1811 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %1810
       %1812 = OpLoad %u32_id %1811
       %1813 = OpIAdd %u32_id %1809 %buf2_dword_off
       %1814 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %1813
       %1815 = OpLoad %u32_id %1814
       %1816 = OpIAdd %u32_id %1808 %buf3_dword_off
       %1817 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_4 %u32_id_0 %1816
       %1818 = OpLoad %u32_id %1817
       %1819 = OpIAdd %u32_id %1805 %buf3_dword_off
       %1820 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_4 %u32_id_0 %1819
       %1821 = OpLoad %u32_id %1820
       %1822 = OpIAdd %u32_id %1806 %buf3_dword_off
       %1823 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_4 %u32_id_0 %1822
       %1824 = OpLoad %u32_id %1823
       %1825 = OpIAdd %u32_id %1807 %buf3_dword_off
       %1826 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_4 %u32_id_0 %1825
       %1827 = OpLoad %u32_id %1826
       %1828 = OpConvertSToF %f32_id %154
       %1829 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
       %1830 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_22
       %1831 = OpLoad %u32_id %1830
       %1832 = OpFDiv %f32_id %f32_id_1 %1828
       %1833 = OpBitcast %f32_id %1831
       %1834 = OpFMul %f32_id %1833 %1832
       %1835 = OpBitcast %f32_id %1719
       %1836 = OpFMul %f32_id %1834 %1835
       %1837 = OpExtInst %f32_id %166 FClamp %1836 %f32_id_0 %f32_id_1
       %1838 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
       %1840 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_20
       %1841 = OpLoad %u32_id %1840
       %1843 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_21
       %1844 = OpLoad %u32_id %1843
       %1845 = OpFAdd %f32_id %f32_id_1 %1837
       %1846 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
       %1848 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_18
       %1849 = OpLoad %u32_id %1848
       %1850 = OpBitcast %f32_id %1841
       %1851 = OpFMul %f32_id %1850 %1845
       %1852 = OpBitcast %f32_id %1844
       %1853 = OpFMul %f32_id %1852 %1845
       %1854 = OpBitcast %f32_id %1849
       %1856 = OpFMul %f32_id %f32_id_n9_80000019 %1854
       %1857 = OpBitcast %f32_id %1812
       %1858 = OpFNegate %f32_id %1857
       %1859 = OpFMul %f32_id %f32_id_0_5 %1851
       %1860 = OpFAdd %f32_id %1859 %1858
       %1861 = OpBitcast %f32_id %1815
       %1862 = OpFNegate %f32_id %1861
       %1863 = OpFMul %f32_id %f32_id_0_5 %1853
       %1864 = OpFAdd %f32_id %1863 %1862
       %1865 = OpBitcast %f32_id %1849
       %1866 = OpBitcast %f32_id %1812
       %1867 = OpFMul %f32_id %1865 %1860
       %1868 = OpFAdd %f32_id %1867 %1866
       %1869 = OpBitcast %f32_id %1824
       %1870 = OpBitcast %f32_id %1827
       %1871 = OpFSub %f32_id %1869 %1870
       %1872 = OpFMul %f32_id %1871 %f32_id_0_5
       %1873 = OpBitcast %f32_id %1818
       %1874 = OpBitcast %f32_id %1821
       %1875 = OpFSub %f32_id %1873 %1874
       %1876 = OpFMul %f32_id %1875 %f32_id_0_5
       %1877 = OpBitcast %f32_id %1849
       %1878 = OpBitcast %f32_id %1815
       %1879 = OpFMul %f32_id %1877 %1864
       %1880 = OpFAdd %f32_id %1879 %1878
       %1881 = OpFMul %f32_id %1872 %1856
       %1882 = OpFAdd %f32_id %1881 %1868
       %1883 = OpBitcast %u32_id %1882
       %1884 = OpUGreaterThan %bool_id %1795 %1809
       %1885 = OpLogicalAnd %bool_id %141 %1884
               OpSelectionMerge %87 None
               OpBranchConditional %1885 %86 %87
         %86 = OpLabel
       %1886 = OpIAdd %u32_id %1809 %buf1_dword_off
       %1887 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %1886
               OpStore %1887 %1883
               OpBranch %87
         %87 = OpLabel
       %1888 = OpFMul %f32_id %1876 %1856
       %1889 = OpFAdd %f32_id %1888 %1880
       %1890 = OpBitcast %u32_id %1889
       %1891 = OpUGreaterThan %bool_id %1803 %1809
       %1892 = OpLogicalAnd %bool_id %141 %1891
               OpSelectionMerge %89 None
               OpBranchConditional %1892 %88 %89
         %88 = OpLabel
       %1893 = OpIAdd %u32_id %1809 %buf2_dword_off
       %1894 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %1893
               OpStore %1894 %1890
               OpBranch %89
         %89 = OpLabel
               OpBranch %90
         %90 = OpLabel
               OpBranch %91
         %91 = OpLabel
               OpReturn
               OpFunctionEnd
