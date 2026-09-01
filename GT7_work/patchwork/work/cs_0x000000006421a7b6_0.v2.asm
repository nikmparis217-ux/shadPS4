; SPIR-V
; Version: 1.6
; Generator: Khronos; 0
; Bound: 1849
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
               OpCapability GroupNonUniformBallot
               OpCapability SignedZeroInfNanPreserve
               OpExtension "SPV_KHR_float_controls"
        %232 = OpExtInstImport "GLSL.std.450"
               OpMemoryModel Logical GLSL450
               OpEntryPoint GLCompute %64 "main" %push_data %gl_WorkGroupID %gl_LocalInvocationID %ssbo_1 %ssbo_2 %ssbo_3 %ssbo_4 %ssbo_5 %ssbo_6 %ssbo_7 %srt_flatbuf
               OpExecutionMode %64 LocalSize 64 1 1
               OpExecutionMode %64 SignedZeroInfNanPreserve 32
          %1 = OpString "0x6421a7b6"
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
               OpName %ssbo_2 "ssbo_2"
               OpName %ssbo_3 "ssbo_3"
               OpName %ssbo_4 "ssbo_4"
               OpName %ssbo_5 "ssbo_5"
               OpName %ssbo_6 "ssbo_6"
               OpName %ssbo_7 "ssbo_7"
               OpName %srt_flatbuf "srt_flatbuf"
               OpName %buf0_off "buf0_off"
               OpName %buf0_dword_off "buf0_dword_off"
               OpName %buf1_off "buf1_off"
               OpName %buf1_dword_off "buf1_dword_off"
               OpName %buf2_off "buf2_off"
               OpName %buf2_dword_off "buf2_dword_off"
               OpName %buf3_off "buf3_off"
               OpName %buf3_dword_off "buf3_dword_off"
               OpName %buf4_off "buf4_off"
               OpName %buf4_dword_off "buf4_dword_off"
               OpName %buf5_off "buf5_off"
               OpName %buf5_dword_off "buf5_dword_off"
               OpName %buf6_off "buf6_off"
               OpName %buf6_dword_off "buf6_dword_off"
               OpName %ud_0 "ud_0"
               OpName %ud_1 "ud_1"
               OpName %ud_2 "ud_2"
               OpName %ud_3 "ud_3"
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
               OpDecorate %ssbo_2 Binding 1
               OpDecorate %ssbo_2 DescriptorSet 0
               OpDecorate %ssbo_2 NonWritable
               OpDecorate %ssbo_3 Binding 2
               OpDecorate %ssbo_3 DescriptorSet 0
               OpDecorate %ssbo_3 NonWritable
               OpDecorate %ssbo_4 Binding 3
               OpDecorate %ssbo_4 DescriptorSet 0
               OpDecorate %ssbo_4 NonWritable
               OpDecorate %ssbo_5 Binding 4
               OpDecorate %ssbo_5 DescriptorSet 0
               OpDecorate %ssbo_5 NonWritable
               OpDecorate %ssbo_6 Binding 5
               OpDecorate %ssbo_6 DescriptorSet 0
               OpDecorate %ssbo_7 Binding 6
               OpDecorate %ssbo_7 DescriptorSet 0
               OpDecorate %srt_flatbuf Binding 7
               OpDecorate %srt_flatbuf DescriptorSet 0
               OpDecorate %srt_flatbuf NonWritable
               OpDecorate %315 NoContraction
               OpDecorate %316 NoContraction
               OpDecorate %320 NoContraction
               OpDecorate %321 NoContraction
               OpDecorate %324 NoContraction
               OpDecorate %325 NoContraction
               OpDecorate %331 NoContraction
               OpDecorate %332 NoContraction
               OpDecorate %335 NoContraction
               OpDecorate %336 NoContraction
               OpDecorate %340 NoContraction
               OpDecorate %341 NoContraction
               OpDecorate %344 NoContraction
               OpDecorate %345 NoContraction
               OpDecorate %348 NoContraction
               OpDecorate %349 NoContraction
               OpDecorate %350 NoContraction
               OpDecorate %353 NoContraction
               OpDecorate %354 NoContraction
               OpDecorate %355 NoContraction
               OpDecorate %356 NoContraction
               OpDecorate %363 NoContraction
               OpDecorate %364 NoContraction
               OpDecorate %368 NoContraction
               OpDecorate %372 NoContraction
               OpDecorate %373 NoContraction
               OpDecorate %384 NoContraction
               OpDecorate %394 NoContraction
               OpDecorate %402 NoContraction
               OpDecorate %403 NoContraction
               OpDecorate %411 NoContraction
               OpDecorate %418 NoContraction
               OpDecorate %663 NoContraction
               OpDecorate %664 NoContraction
               OpDecorate %668 NoContraction
               OpDecorate %669 NoContraction
               OpDecorate %672 NoContraction
               OpDecorate %673 NoContraction
               OpDecorate %677 NoContraction
               OpDecorate %678 NoContraction
               OpDecorate %681 NoContraction
               OpDecorate %682 NoContraction
               OpDecorate %685 NoContraction
               OpDecorate %686 NoContraction
               OpDecorate %688 NoContraction
               OpDecorate %692 NoContraction
               OpDecorate %693 NoContraction
               OpDecorate %695 NoContraction
               OpDecorate %698 NoContraction
               OpDecorate %699 NoContraction
               OpDecorate %702 NoContraction
               OpDecorate %703 NoContraction
               OpDecorate %705 NoContraction
               OpDecorate %707 NoContraction
               OpDecorate %708 NoContraction
               OpDecorate %711 NoContraction
               OpDecorate %712 NoContraction
               OpDecorate %715 NoContraction
               OpDecorate %716 NoContraction
               OpDecorate %718 NoContraction
               OpDecorate %719 NoContraction
               OpDecorate %721 NoContraction
               OpDecorate %722 NoContraction
               OpDecorate %725 NoContraction
               OpDecorate %726 NoContraction
               OpDecorate %728 NoContraction
               OpDecorate %730 NoContraction
               OpDecorate %731 NoContraction
               OpDecorate %733 NoContraction
               OpDecorate %734 NoContraction
               OpDecorate %736 NoContraction
               OpDecorate %737 NoContraction
               OpDecorate %739 NoContraction
               OpDecorate %740 NoContraction
               OpDecorate %742 NoContraction
               OpDecorate %743 NoContraction
               OpDecorate %745 NoContraction
               OpDecorate %746 NoContraction
               OpDecorate %750 NoContraction
               OpDecorate %751 NoContraction
               OpDecorate %753 NoContraction
               OpDecorate %754 NoContraction
               OpDecorate %756 NoContraction
               OpDecorate %757 NoContraction
               OpDecorate %808 NoContraction
               OpDecorate %809 NoContraction
               OpDecorate %813 NoContraction
               OpDecorate %814 NoContraction
               OpDecorate %817 NoContraction
               OpDecorate %818 NoContraction
               OpDecorate %822 NoContraction
               OpDecorate %823 NoContraction
               OpDecorate %826 NoContraction
               OpDecorate %827 NoContraction
               OpDecorate %830 NoContraction
               OpDecorate %831 NoContraction
               OpDecorate %833 NoContraction
               OpDecorate %837 NoContraction
               OpDecorate %838 NoContraction
               OpDecorate %840 NoContraction
               OpDecorate %843 NoContraction
               OpDecorate %844 NoContraction
               OpDecorate %847 NoContraction
               OpDecorate %848 NoContraction
               OpDecorate %850 NoContraction
               OpDecorate %852 NoContraction
               OpDecorate %853 NoContraction
               OpDecorate %856 NoContraction
               OpDecorate %857 NoContraction
               OpDecorate %860 NoContraction
               OpDecorate %861 NoContraction
               OpDecorate %863 NoContraction
               OpDecorate %864 NoContraction
               OpDecorate %866 NoContraction
               OpDecorate %867 NoContraction
               OpDecorate %870 NoContraction
               OpDecorate %871 NoContraction
               OpDecorate %873 NoContraction
               OpDecorate %875 NoContraction
               OpDecorate %876 NoContraction
               OpDecorate %878 NoContraction
               OpDecorate %879 NoContraction
               OpDecorate %881 NoContraction
               OpDecorate %882 NoContraction
               OpDecorate %884 NoContraction
               OpDecorate %885 NoContraction
               OpDecorate %887 NoContraction
               OpDecorate %888 NoContraction
               OpDecorate %890 NoContraction
               OpDecorate %891 NoContraction
               OpDecorate %895 NoContraction
               OpDecorate %896 NoContraction
               OpDecorate %898 NoContraction
               OpDecorate %899 NoContraction
               OpDecorate %901 NoContraction
               OpDecorate %902 NoContraction
               OpDecorate %947 NoContraction
               OpDecorate %948 NoContraction
               OpDecorate %952 NoContraction
               OpDecorate %953 NoContraction
               OpDecorate %956 NoContraction
               OpDecorate %957 NoContraction
               OpDecorate %961 NoContraction
               OpDecorate %962 NoContraction
               OpDecorate %965 NoContraction
               OpDecorate %966 NoContraction
               OpDecorate %969 NoContraction
               OpDecorate %970 NoContraction
               OpDecorate %972 NoContraction
               OpDecorate %976 NoContraction
               OpDecorate %977 NoContraction
               OpDecorate %979 NoContraction
               OpDecorate %982 NoContraction
               OpDecorate %983 NoContraction
               OpDecorate %986 NoContraction
               OpDecorate %987 NoContraction
               OpDecorate %989 NoContraction
               OpDecorate %991 NoContraction
               OpDecorate %992 NoContraction
               OpDecorate %995 NoContraction
               OpDecorate %996 NoContraction
               OpDecorate %999 NoContraction
               OpDecorate %1000 NoContraction
               OpDecorate %1002 NoContraction
               OpDecorate %1003 NoContraction
               OpDecorate %1005 NoContraction
               OpDecorate %1006 NoContraction
               OpDecorate %1009 NoContraction
               OpDecorate %1010 NoContraction
               OpDecorate %1012 NoContraction
               OpDecorate %1014 NoContraction
               OpDecorate %1015 NoContraction
               OpDecorate %1017 NoContraction
               OpDecorate %1018 NoContraction
               OpDecorate %1020 NoContraction
               OpDecorate %1021 NoContraction
               OpDecorate %1023 NoContraction
               OpDecorate %1024 NoContraction
               OpDecorate %1026 NoContraction
               OpDecorate %1027 NoContraction
               OpDecorate %1029 NoContraction
               OpDecorate %1030 NoContraction
               OpDecorate %1034 NoContraction
               OpDecorate %1035 NoContraction
               OpDecorate %1037 NoContraction
               OpDecorate %1038 NoContraction
               OpDecorate %1040 NoContraction
               OpDecorate %1041 NoContraction
               OpDecorate %1086 NoContraction
               OpDecorate %1087 NoContraction
               OpDecorate %1091 NoContraction
               OpDecorate %1092 NoContraction
               OpDecorate %1095 NoContraction
               OpDecorate %1096 NoContraction
               OpDecorate %1100 NoContraction
               OpDecorate %1101 NoContraction
               OpDecorate %1104 NoContraction
               OpDecorate %1105 NoContraction
               OpDecorate %1108 NoContraction
               OpDecorate %1109 NoContraction
               OpDecorate %1111 NoContraction
               OpDecorate %1115 NoContraction
               OpDecorate %1116 NoContraction
               OpDecorate %1118 NoContraction
               OpDecorate %1121 NoContraction
               OpDecorate %1122 NoContraction
               OpDecorate %1125 NoContraction
               OpDecorate %1126 NoContraction
               OpDecorate %1128 NoContraction
               OpDecorate %1130 NoContraction
               OpDecorate %1131 NoContraction
               OpDecorate %1134 NoContraction
               OpDecorate %1135 NoContraction
               OpDecorate %1138 NoContraction
               OpDecorate %1139 NoContraction
               OpDecorate %1141 NoContraction
               OpDecorate %1142 NoContraction
               OpDecorate %1144 NoContraction
               OpDecorate %1145 NoContraction
               OpDecorate %1148 NoContraction
               OpDecorate %1149 NoContraction
               OpDecorate %1151 NoContraction
               OpDecorate %1153 NoContraction
               OpDecorate %1154 NoContraction
               OpDecorate %1156 NoContraction
               OpDecorate %1157 NoContraction
               OpDecorate %1159 NoContraction
               OpDecorate %1160 NoContraction
               OpDecorate %1162 NoContraction
               OpDecorate %1163 NoContraction
               OpDecorate %1165 NoContraction
               OpDecorate %1166 NoContraction
               OpDecorate %1168 NoContraction
               OpDecorate %1169 NoContraction
               OpDecorate %1173 NoContraction
               OpDecorate %1174 NoContraction
               OpDecorate %1176 NoContraction
               OpDecorate %1177 NoContraction
               OpDecorate %1179 NoContraction
               OpDecorate %1180 NoContraction
               OpDecorate %1225 NoContraction
               OpDecorate %1226 NoContraction
               OpDecorate %1230 NoContraction
               OpDecorate %1231 NoContraction
               OpDecorate %1234 NoContraction
               OpDecorate %1235 NoContraction
               OpDecorate %1239 NoContraction
               OpDecorate %1240 NoContraction
               OpDecorate %1243 NoContraction
               OpDecorate %1244 NoContraction
               OpDecorate %1247 NoContraction
               OpDecorate %1248 NoContraction
               OpDecorate %1250 NoContraction
               OpDecorate %1254 NoContraction
               OpDecorate %1255 NoContraction
               OpDecorate %1257 NoContraction
               OpDecorate %1260 NoContraction
               OpDecorate %1261 NoContraction
               OpDecorate %1264 NoContraction
               OpDecorate %1265 NoContraction
               OpDecorate %1267 NoContraction
               OpDecorate %1269 NoContraction
               OpDecorate %1270 NoContraction
               OpDecorate %1273 NoContraction
               OpDecorate %1274 NoContraction
               OpDecorate %1277 NoContraction
               OpDecorate %1278 NoContraction
               OpDecorate %1280 NoContraction
               OpDecorate %1281 NoContraction
               OpDecorate %1283 NoContraction
               OpDecorate %1284 NoContraction
               OpDecorate %1287 NoContraction
               OpDecorate %1288 NoContraction
               OpDecorate %1290 NoContraction
               OpDecorate %1292 NoContraction
               OpDecorate %1293 NoContraction
               OpDecorate %1295 NoContraction
               OpDecorate %1296 NoContraction
               OpDecorate %1298 NoContraction
               OpDecorate %1299 NoContraction
               OpDecorate %1301 NoContraction
               OpDecorate %1302 NoContraction
               OpDecorate %1304 NoContraction
               OpDecorate %1305 NoContraction
               OpDecorate %1307 NoContraction
               OpDecorate %1308 NoContraction
               OpDecorate %1312 NoContraction
               OpDecorate %1313 NoContraction
               OpDecorate %1315 NoContraction
               OpDecorate %1316 NoContraction
               OpDecorate %1318 NoContraction
               OpDecorate %1319 NoContraction
               OpDecorate %1364 NoContraction
               OpDecorate %1365 NoContraction
               OpDecorate %1369 NoContraction
               OpDecorate %1370 NoContraction
               OpDecorate %1373 NoContraction
               OpDecorate %1374 NoContraction
               OpDecorate %1378 NoContraction
               OpDecorate %1379 NoContraction
               OpDecorate %1382 NoContraction
               OpDecorate %1383 NoContraction
               OpDecorate %1386 NoContraction
               OpDecorate %1387 NoContraction
               OpDecorate %1389 NoContraction
               OpDecorate %1393 NoContraction
               OpDecorate %1394 NoContraction
               OpDecorate %1396 NoContraction
               OpDecorate %1399 NoContraction
               OpDecorate %1400 NoContraction
               OpDecorate %1403 NoContraction
               OpDecorate %1404 NoContraction
               OpDecorate %1406 NoContraction
               OpDecorate %1408 NoContraction
               OpDecorate %1409 NoContraction
               OpDecorate %1412 NoContraction
               OpDecorate %1413 NoContraction
               OpDecorate %1416 NoContraction
               OpDecorate %1417 NoContraction
               OpDecorate %1419 NoContraction
               OpDecorate %1420 NoContraction
               OpDecorate %1422 NoContraction
               OpDecorate %1423 NoContraction
               OpDecorate %1426 NoContraction
               OpDecorate %1427 NoContraction
               OpDecorate %1429 NoContraction
               OpDecorate %1431 NoContraction
               OpDecorate %1432 NoContraction
               OpDecorate %1434 NoContraction
               OpDecorate %1435 NoContraction
               OpDecorate %1437 NoContraction
               OpDecorate %1438 NoContraction
               OpDecorate %1440 NoContraction
               OpDecorate %1441 NoContraction
               OpDecorate %1443 NoContraction
               OpDecorate %1444 NoContraction
               OpDecorate %1446 NoContraction
               OpDecorate %1447 NoContraction
               OpDecorate %1451 NoContraction
               OpDecorate %1452 NoContraction
               OpDecorate %1454 NoContraction
               OpDecorate %1455 NoContraction
               OpDecorate %1457 NoContraction
               OpDecorate %1458 NoContraction
               OpDecorate %1504 NoContraction
               OpDecorate %1505 NoContraction
               OpDecorate %1509 NoContraction
               OpDecorate %1510 NoContraction
               OpDecorate %1513 NoContraction
               OpDecorate %1514 NoContraction
               OpDecorate %1518 NoContraction
               OpDecorate %1519 NoContraction
               OpDecorate %1522 NoContraction
               OpDecorate %1523 NoContraction
               OpDecorate %1526 NoContraction
               OpDecorate %1527 NoContraction
               OpDecorate %1529 NoContraction
               OpDecorate %1533 NoContraction
               OpDecorate %1534 NoContraction
               OpDecorate %1536 NoContraction
               OpDecorate %1539 NoContraction
               OpDecorate %1540 NoContraction
               OpDecorate %1543 NoContraction
               OpDecorate %1544 NoContraction
               OpDecorate %1546 NoContraction
               OpDecorate %1548 NoContraction
               OpDecorate %1549 NoContraction
               OpDecorate %1552 NoContraction
               OpDecorate %1553 NoContraction
               OpDecorate %1556 NoContraction
               OpDecorate %1557 NoContraction
               OpDecorate %1559 NoContraction
               OpDecorate %1560 NoContraction
               OpDecorate %1562 NoContraction
               OpDecorate %1563 NoContraction
               OpDecorate %1566 NoContraction
               OpDecorate %1567 NoContraction
               OpDecorate %1569 NoContraction
               OpDecorate %1571 NoContraction
               OpDecorate %1572 NoContraction
               OpDecorate %1574 NoContraction
               OpDecorate %1575 NoContraction
               OpDecorate %1577 NoContraction
               OpDecorate %1578 NoContraction
               OpDecorate %1580 NoContraction
               OpDecorate %1581 NoContraction
               OpDecorate %1583 NoContraction
               OpDecorate %1584 NoContraction
               OpDecorate %1586 NoContraction
               OpDecorate %1587 NoContraction
               OpDecorate %1591 NoContraction
               OpDecorate %1592 NoContraction
               OpDecorate %1594 NoContraction
               OpDecorate %1595 NoContraction
               OpDecorate %1597 NoContraction
               OpDecorate %1598 NoContraction
               OpDecorate %1644 NoContraction
               OpDecorate %1645 NoContraction
               OpDecorate %1648 NoContraction
               OpDecorate %1649 NoContraction
               OpDecorate %1653 NoContraction
               OpDecorate %1654 NoContraction
               OpDecorate %1657 NoContraction
               OpDecorate %1658 NoContraction
               OpDecorate %1661 NoContraction
               OpDecorate %1662 NoContraction
               OpDecorate %1666 NoContraction
               OpDecorate %1667 NoContraction
               OpDecorate %1669 NoContraction
               OpDecorate %1671 NoContraction
               OpDecorate %1674 NoContraction
               OpDecorate %1675 NoContraction
               OpDecorate %1677 NoContraction
               OpDecorate %1680 NoContraction
               OpDecorate %1681 NoContraction
               OpDecorate %1685 NoContraction
               OpDecorate %1686 NoContraction
               OpDecorate %1689 NoContraction
               OpDecorate %1690 NoContraction
               OpDecorate %1692 NoContraction
               OpDecorate %1694 NoContraction
               OpDecorate %1695 NoContraction
               OpDecorate %1698 NoContraction
               OpDecorate %1699 NoContraction
               OpDecorate %1701 NoContraction
               OpDecorate %1702 NoContraction
               OpDecorate %1704 NoContraction
               OpDecorate %1705 NoContraction
               OpDecorate %1707 NoContraction
               OpDecorate %1708 NoContraction
               OpDecorate %1710 NoContraction
               OpDecorate %1711 NoContraction
               OpDecorate %1714 NoContraction
               OpDecorate %1715 NoContraction
               OpDecorate %1717 NoContraction
               OpDecorate %1718 NoContraction
               OpDecorate %1720 NoContraction
               OpDecorate %1721 NoContraction
               OpDecorate %1723 NoContraction
               OpDecorate %1724 NoContraction
               OpDecorate %1726 NoContraction
               OpDecorate %1727 NoContraction
               OpDecorate %1729 NoContraction
               OpDecorate %1730 NoContraction
               OpDecorate %1732 NoContraction
               OpDecorate %1733 NoContraction
               OpDecorate %1739 NoContraction
               OpDecorate %1740 NoContraction
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
 %_struct_52 = OpTypeStruct %_runtimearr_u32_id
%_ptr_StorageBuffer__struct_52 = OpTypePointer StorageBuffer %_struct_52
%_ptr_StorageBuffer_u32_id = OpTypePointer StorageBuffer %u32_id
         %63 = OpTypeFunction %void_id
   %u32_id_8 = OpConstant %u32_id 8
%_ptr_PushConstant_u32_id = OpTypePointer PushConstant %u32_id
   %u32_id_2 = OpConstant %u32_id 2
  %u32_id_16 = OpConstant %u32_id 16
  %u32_id_24 = OpConstant %u32_id 24
   %u32_id_4 = OpConstant %u32_id 4
   %u32_id_3 = OpConstant %u32_id 3
   %u32_id_6 = OpConstant %u32_id 6
  %u32_id_14 = OpConstant %u32_id 14
  %u32_id_90 = OpConstant %u32_id 90
  %u32_id_12 = OpConstant %u32_id 12
  %u32_id_88 = OpConstant %u32_id 88
  %u32_id_62 = OpConstant %u32_id 62
  %u32_id_73 = OpConstant %u32_id 73
  %u32_id_13 = OpConstant %u32_id 13
  %u32_id_32 = OpConstant %u32_id 32
%u32_id_4294967295 = OpConstant %u32_id 4294967295
  %u32_id_15 = OpConstant %u32_id 15
  %u32_id_91 = OpConstant %u32_id 91
 %u32_id_255 = OpConstant %u32_id 255
  %u32_id_25 = OpConstant %u32_id 25
  %u32_id_36 = OpConstant %u32_id 36
  %u32_id_26 = OpConstant %u32_id 26
  %u32_id_37 = OpConstant %u32_id 37
  %u32_id_27 = OpConstant %u32_id 27
  %u32_id_38 = OpConstant %u32_id 38
  %u32_id_29 = OpConstant %u32_id 29
  %u32_id_40 = OpConstant %u32_id 40
  %u32_id_30 = OpConstant %u32_id 30
  %u32_id_41 = OpConstant %u32_id 41
  %u32_id_31 = OpConstant %u32_id 31
  %u32_id_42 = OpConstant %u32_id 42
  %u32_id_33 = OpConstant %u32_id 33
  %u32_id_44 = OpConstant %u32_id 44
  %u32_id_34 = OpConstant %u32_id 34
  %u32_id_45 = OpConstant %u32_id 45
  %u32_id_35 = OpConstant %u32_id 35
  %u32_id_46 = OpConstant %u32_id 46
  %u32_id_48 = OpConstant %u32_id 48
  %u32_id_49 = OpConstant %u32_id 49
  %u32_id_39 = OpConstant %u32_id 39
  %u32_id_50 = OpConstant %u32_id 50
   %u32_id_9 = OpConstant %u32_id 9
  %u32_id_11 = OpConstant %u32_id 11
   %f32_id_1 = OpConstant %f32_id 1
  %u32_id_10 = OpConstant %u32_id 10
%f32_id_3_00000001e_38 = OpConstant %f32_id 3.00000001e+38
  %u32_id_61 = OpConstant %u32_id 61
  %u32_id_72 = OpConstant %u32_id 72
  %u32_id_57 = OpConstant %u32_id 57
  %u32_id_68 = OpConstant %u32_id 68
  %u32_id_58 = OpConstant %u32_id 58
  %u32_id_69 = OpConstant %u32_id 69
  %u32_id_59 = OpConstant %u32_id 59
  %u32_id_70 = OpConstant %u32_id 70
  %u32_id_60 = OpConstant %u32_id 60
  %u32_id_71 = OpConstant %u32_id 71
  %u32_id_28 = OpConstant %u32_id 28
  %u32_id_64 = OpConstant %u32_id 64
  %u32_id_75 = OpConstant %u32_id 75
   %u32_id_5 = OpConstant %u32_id 5
   %u32_id_7 = OpConstant %u32_id 7
  %u32_id_52 = OpConstant %u32_id 52
  %u32_id_53 = OpConstant %u32_id 53
  %u32_id_43 = OpConstant %u32_id 43
  %u32_id_54 = OpConstant %u32_id 54
  %u32_id_55 = OpConstant %u32_id 55
  %u32_id_56 = OpConstant %u32_id 56
  %u32_id_47 = OpConstant %u32_id 47
  %u32_id_51 = OpConstant %u32_id 51
  %u32_id_63 = OpConstant %u32_id 63
  %u32_id_65 = OpConstant %u32_id 65
  %u32_id_66 = OpConstant %u32_id 66
  %u32_id_67 = OpConstant %u32_id 67
%f32_id_0x1pn149 = OpConstant %f32_id 0x1p-149
%f32_id_0x1pn148 = OpConstant %f32_id 0x1p-148
%f32_id_0x1pn147 = OpConstant %f32_id 0x1p-147
%f32_id_0x1pn146 = OpConstant %f32_id 0x1p-146
%f32_id_0x1pn145 = OpConstant %f32_id 0x1p-145
%f32_id_0x1pn144 = OpConstant %f32_id 0x1p-144
  %u32_id_18 = OpConstant %u32_id 18
  %u32_id_21 = OpConstant %u32_id 21
  %u32_id_89 = OpConstant %u32_id 89
       %1783 = OpConstantComposite %u32vec2_id %u32_id_4294967295 %u32_id_0
  %u32_id_74 = OpConstant %u32_id 74
%u32_id_2137108966 = OpConstant %u32_id 2137108966
  %push_data = OpVariable %_ptr_PushConstant_AuxData PushConstant
%gl_WorkGroupID = OpVariable %_ptr_Input_u32vec3_id Input
%gl_LocalInvocationID = OpVariable %_ptr_Input_u32vec3_id Input
     %ssbo_1 = OpVariable %_ptr_StorageBuffer__struct_52 StorageBuffer
     %ssbo_2 = OpVariable %_ptr_StorageBuffer__struct_52 StorageBuffer
     %ssbo_3 = OpVariable %_ptr_StorageBuffer__struct_52 StorageBuffer
     %ssbo_4 = OpVariable %_ptr_StorageBuffer__struct_52 StorageBuffer
     %ssbo_5 = OpVariable %_ptr_StorageBuffer__struct_52 StorageBuffer
     %ssbo_6 = OpVariable %_ptr_StorageBuffer__struct_52 StorageBuffer
     %ssbo_7 = OpVariable %_ptr_StorageBuffer__struct_52 StorageBuffer
%srt_flatbuf = OpVariable %_ptr_StorageBuffer__struct_52 StorageBuffer
         %64 = OpFunction %void_id None %63
         %65 = OpLabel
        %134 = OpUndef %u32_id
        %135 = OpUndef %u32_id
        %138 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
        %139 = OpLoad %u32_id %138
   %buf0_off = OpBitFieldUExtract %u32_id %139 %u32_id_0 %u32_id_8
%buf0_dword_off = OpShiftRightLogical %u32_id %buf0_off %u32_id_2
        %143 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
        %144 = OpLoad %u32_id %143
   %buf1_off = OpBitFieldUExtract %u32_id %144 %u32_id_8 %u32_id_8
%buf1_dword_off = OpShiftRightLogical %u32_id %buf1_off %u32_id_2
        %147 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
        %148 = OpLoad %u32_id %147
   %buf2_off = OpBitFieldUExtract %u32_id %148 %u32_id_16 %u32_id_8
%buf2_dword_off = OpShiftRightLogical %u32_id %buf2_off %u32_id_2
        %152 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
        %153 = OpLoad %u32_id %152
   %buf3_off = OpBitFieldUExtract %u32_id %153 %u32_id_24 %u32_id_8
%buf3_dword_off = OpShiftRightLogical %u32_id %buf3_off %u32_id_2
        %157 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_1
        %158 = OpLoad %u32_id %157
   %buf4_off = OpBitFieldUExtract %u32_id %158 %u32_id_0 %u32_id_8
%buf4_dword_off = OpShiftRightLogical %u32_id %buf4_off %u32_id_2
        %161 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_1
        %162 = OpLoad %u32_id %161
   %buf5_off = OpBitFieldUExtract %u32_id %162 %u32_id_8 %u32_id_8
%buf5_dword_off = OpShiftRightLogical %u32_id %buf5_off %u32_id_2
        %165 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_1
        %166 = OpLoad %u32_id %165
   %buf6_off = OpBitFieldUExtract %u32_id %166 %u32_id_16 %u32_id_8
%buf6_dword_off = OpShiftRightLogical %u32_id %buf6_off %u32_id_2
        %170 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_0
       %ud_0 = OpLoad %u32_id %170
        %172 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_1
       %ud_1 = OpLoad %u32_id %172
        %174 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_2
       %ud_2 = OpLoad %u32_id %174
        %177 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_3
       %ud_3 = OpLoad %u32_id %177
        %179 = OpLoad %u32vec3_id %gl_LocalInvocationID
        %180 = OpCompositeExtract %u32_id %179 0
        %181 = OpLoad %u32vec3_id %gl_WorkGroupID
        %182 = OpCompositeExtract %u32_id %181 0
        %184 = OpShiftLeftLogical %u32_id %182 %u32_id_6
        %185 = OpCompositeConstruct %u32vec2_id %ud_2 %ud_3
        %188 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_90
        %189 = OpLoad %u32_id %188
        %190 = OpIAdd %u32_id %184 %180
        %191 = OpUGreaterThan %bool_id %189 %190
               OpSelectionMerge %132 None
               OpBranchConditional %191 %66 %132
         %66 = OpLabel
        %192 = OpCompositeConstruct %u32vec2_id %ud_2 %ud_3
        %195 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_88
        %196 = OpLoad %u32_id %195
        %197 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %200 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_73
        %201 = OpLoad %u32_id %200
        %202 = OpIMul %u32_id %196 %190
        %203 = OpIAdd %u32_id %202 %u32_id_12
        %205 = OpIAdd %u32_id %202 %u32_id_13
        %206 = OpIAdd %u32_id %202 %u32_id_14
        %207 = OpIAdd %u32_id %202 %u32_id_12
        %208 = OpIAdd %u32_id %207 %buf0_dword_off
        %209 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %208
        %210 = OpLoad %u32_id %209
        %211 = OpIAdd %u32_id %202 %u32_id_13
        %212 = OpIAdd %u32_id %211 %buf0_dword_off
        %213 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %212
        %214 = OpLoad %u32_id %213
        %215 = OpIAdd %u32_id %202 %u32_id_14
        %216 = OpIAdd %u32_id %215 %buf0_dword_off
        %217 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %216
        %218 = OpLoad %u32_id %217
        %219 = OpIAdd %u32_id %190 %buf1_dword_off
        %220 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %219
        %221 = OpLoad %u32_id %220
        %222 = OpSGreaterThanEqual %bool_id %201 %u32_id_0
        %223 = OpLogicalNot %bool_id %222
               OpSelectionMerge %68 None
               OpBranchConditional %222 %67 %68
         %67 = OpLabel
        %225 = OpIMul %u32_id %221 %u32_id_32
        %226 = OpIAdd %u32_id %225 %u32_id_24
        %227 = OpIAdd %u32_id %226 %buf2_dword_off
        %228 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %227
        %229 = OpLoad %u32_id %228
        %231 = OpIAdd %u32_id %229 %u32_id_4294967295
        %233 = OpExtInst %u32_id %232 SMin %201 %231
               OpBranch %68
         %68 = OpLabel
        %234 = OpPhi %u32_id %233 %67 %135 %66
        %235 = OpPhi %u32_id %231 %67 %206 %66
               OpSelectionMerge %99 None
               OpBranchConditional %223 %69 %99
         %69 = OpLabel
        %236 = OpCompositeConstruct %u32vec2_id %ud_2 %ud_3
        %239 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_91
        %240 = OpLoad %u32_id %239
        %241 = OpINotEqual %bool_id %u32_id_0 %240
        %242 = OpLogicalNot %bool_id %241
               OpSelectionMerge %71 None
               OpBranchConditional %241 %70 %71
         %70 = OpLabel
        %244 = OpIMul %u32_id %190 %u32_id_255
        %245 = OpShiftRightLogical %u32_id %244 %u32_id_2
        %246 = OpIAdd %u32_id %245 %buf3_dword_off
        %247 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_4 %u32_id_0 %246
        %248 = OpLoad %u32_id %247
               OpBranch %71
         %71 = OpLabel
        %249 = OpPhi %u32_id %248 %70 %235 %69
               OpSelectionMerge %73 None
               OpBranchConditional %242 %72 %73
         %72 = OpLabel
        %250 = OpIMul %u32_id %221 %u32_id_32
        %252 = OpIAdd %u32_id %250 %u32_id_25
        %253 = OpIAdd %u32_id %252 %buf2_dword_off
        %254 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %253
        %255 = OpLoad %u32_id %254
               OpBranch %73
         %73 = OpLabel
        %256 = OpPhi %u32_id %255 %72 %249 %71
        %257 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %259 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_36
        %260 = OpLoad %u32_id %259
        %263 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_37
        %264 = OpLoad %u32_id %263
        %267 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_38
        %268 = OpLoad %u32_id %267
        %271 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_40
        %272 = OpLoad %u32_id %271
        %275 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_41
        %276 = OpLoad %u32_id %275
        %279 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_42
        %280 = OpLoad %u32_id %279
        %283 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_44
        %284 = OpLoad %u32_id %283
        %287 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_45
        %288 = OpLoad %u32_id %287
        %291 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_46
        %292 = OpLoad %u32_id %291
        %294 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_48
        %295 = OpLoad %u32_id %294
        %297 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_49
        %298 = OpLoad %u32_id %297
        %301 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_50
        %302 = OpLoad %u32_id %301
        %303 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %305 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_24
        %306 = OpLoad %u32_id %305
        %307 = OpIMul %u32_id %221 %u32_id_32
        %308 = OpIAdd %u32_id %307 %u32_id_26
        %309 = OpIAdd %u32_id %308 %buf2_dword_off
        %310 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %309
        %311 = OpLoad %u32_id %310
        %312 = OpBitcast %f32_id %268
        %313 = OpBitcast %f32_id %210
        %314 = OpBitcast %f32_id %302
        %315 = OpFMul %f32_id %312 %313
        %316 = OpFAdd %f32_id %315 %314
        %317 = OpINotEqual %bool_id %u32_id_0 %306
        %318 = OpBitcast %f32_id %280
        %319 = OpBitcast %f32_id %214
        %320 = OpFMul %f32_id %318 %319
        %321 = OpFAdd %f32_id %320 %316
        %322 = OpBitcast %f32_id %292
        %323 = OpBitcast %f32_id %218
        %324 = OpFMul %f32_id %322 %323
        %325 = OpFAdd %f32_id %324 %321
        %326 = OpBitcast %u32_id %325
        %327 = OpLogicalNot %bool_id %317
               OpSelectionMerge %77 None
               OpBranchConditional %317 %74 %77
         %74 = OpLabel
        %328 = OpBitcast %f32_id %260
        %329 = OpBitcast %f32_id %210
        %330 = OpBitcast %f32_id %295
        %331 = OpFMul %f32_id %328 %329
        %332 = OpFAdd %f32_id %331 %330
        %333 = OpBitcast %f32_id %272
        %334 = OpBitcast %f32_id %214
        %335 = OpFMul %f32_id %333 %334
        %336 = OpFAdd %f32_id %335 %332
        %337 = OpBitcast %f32_id %264
        %338 = OpBitcast %f32_id %210
        %339 = OpBitcast %f32_id %298
        %340 = OpFMul %f32_id %337 %338
        %341 = OpFAdd %f32_id %340 %339
        %342 = OpBitcast %f32_id %284
        %343 = OpBitcast %f32_id %218
        %344 = OpFMul %f32_id %342 %343
        %345 = OpFAdd %f32_id %344 %336
        %346 = OpBitcast %f32_id %276
        %347 = OpBitcast %f32_id %214
        %348 = OpFMul %f32_id %346 %347
        %349 = OpFAdd %f32_id %348 %341
        %350 = OpFMul %f32_id %345 %345
        %351 = OpBitcast %f32_id %288
        %352 = OpBitcast %f32_id %218
        %353 = OpFMul %f32_id %351 %352
        %354 = OpFAdd %f32_id %353 %349
        %355 = OpFMul %f32_id %354 %354
        %356 = OpFAdd %f32_id %355 %350
        %357 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %359 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_26
        %360 = OpLoad %u32_id %359
        %361 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_27
        %362 = OpLoad %u32_id %361
        %363 = OpFMul %f32_id %325 %325
        %364 = OpFAdd %f32_id %363 %356
        %365 = OpBitcast %u32_id %364
        %366 = OpExtInst %f32_id %232 Sqrt %364
        %367 = OpBitcast %f32_id %311
        %368 = OpFSub %f32_id %366 %367
        %369 = OpBitcast %f32_id %360
        %370 = OpFNegate %f32_id %369
        %371 = OpBitcast %f32_id %362
        %372 = OpFMul %f32_id %370 %368
        %373 = OpFAdd %f32_id %372 %371
        %374 = OpBitcast %u32_id %373
        %375 = OpFOrdGreaterThan %bool_id %373 %f32_id_0
        %376 = OpLogicalAnd %bool_id %191 %375
               OpSelectionMerge %76 None
               OpBranchConditional %376 %75 %76
         %75 = OpLabel
        %378 = OpFDiv %f32_id %f32_id_1 %373
        %379 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %381 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_25
        %382 = OpLoad %u32_id %381
        %383 = OpBitcast %f32_id %382
        %384 = OpFMul %f32_id %383 %378
        %386 = OpExtInst %f32_id %232 FMin %f32_id_3_00000001e_38 %384
        %387 = OpBitcast %u32_id %386
               OpBranch %76
         %76 = OpLabel
        %388 = OpPhi %u32_id %387 %75 %u32_id_2137108966 %74
               OpBranch %77
         %77 = OpLabel
        %389 = OpPhi %u32_id %365 %76 %234 %73
        %390 = OpPhi %u32_id %374 %76 %326 %73
        %391 = OpPhi %u32_id %388 %76 %311 %73
               OpSelectionMerge %81 None
               OpBranchConditional %327 %78 %81
         %78 = OpLabel
        %392 = OpBitcast %f32_id %391
        %393 = OpBitcast %f32_id %390
        %394 = OpFAdd %f32_id %392 %393
        %395 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %396 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_26
        %397 = OpLoad %u32_id %396
        %398 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_27
        %399 = OpLoad %u32_id %398
        %400 = OpBitcast %f32_id %397
        %401 = OpBitcast %f32_id %399
        %402 = OpFMul %f32_id %400 %394
        %403 = OpFAdd %f32_id %402 %401
        %404 = OpFOrdGreaterThan %bool_id %403 %f32_id_0
        %405 = OpLogicalAnd %bool_id %191 %404
               OpSelectionMerge %80 None
               OpBranchConditional %405 %79 %80
         %79 = OpLabel
        %406 = OpFDiv %f32_id %f32_id_1 %403
        %407 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %408 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_25
        %409 = OpLoad %u32_id %408
        %410 = OpBitcast %f32_id %409
        %411 = OpFMul %f32_id %410 %406
        %412 = OpExtInst %f32_id %232 FMin %f32_id_3_00000001e_38 %411
        %413 = OpBitcast %u32_id %412
               OpBranch %80
         %80 = OpLabel
        %414 = OpPhi %u32_id %413 %79 %u32_id_2137108966 %78
               OpBranch %81
         %81 = OpLabel
        %415 = OpPhi %u32_id %414 %80 %391 %77
        %416 = OpBitcast %f32_id %256
        %417 = OpBitcast %f32_id %415
        %418 = OpFMul %f32_id %417 %416
        %419 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %422 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_72
        %423 = OpLoad %u32_id %422
        %424 = OpUGreaterThan %bool_id %423 %u32_id_0
        %425 = OpLogicalNot %bool_id %424
               OpSelectionMerge %89 None
               OpBranchConditional %424 %82 %89
         %82 = OpLabel
        %426 = OpIMul %u32_id %221 %u32_id_32
        %427 = OpIAdd %u32_id %426 %u32_id_24
        %428 = OpIAdd %u32_id %427 %buf2_dword_off
        %429 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %428
        %430 = OpLoad %u32_id %429
        %431 = OpExtInst %u32_id %232 UMin %423 %430
        %432 = OpIAdd %u32_id %431 %u32_id_4294967295
               OpBranch %83
         %83 = OpLabel
        %433 = OpPhi %u32_id %389 %82 %434 %87
        %434 = OpPhi %u32_id %u32_id_0 %82 %465 %87
        %435 = OpPhi %bool_id %191 %82 %467 %87
               OpLoopMerge %88 %87 None
               OpBranch %84
         %84 = OpLabel
        %436 = OpLogicalNot %bool_id %435
               OpBranchConditional %436 %88 %85
         %85 = OpLabel
        %437 = OpULessThan %bool_id %434 %432
        %438 = OpLogicalAnd %bool_id %435 %437
        %439 = OpLogicalNot %bool_id %438
               OpBranchConditional %439 %88 %86
         %86 = OpLabel
        %440 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %443 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_68
        %444 = OpLoad %u32_id %443
        %447 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_69
        %448 = OpLoad %u32_id %447
        %451 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_70
        %452 = OpLoad %u32_id %451
        %455 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_71
        %456 = OpLoad %u32_id %455
        %457 = OpIEqual %bool_id %434 %u32_id_1
        %458 = OpSelect %u32_id %457 %448 %444
        %459 = OpIEqual %bool_id %434 %u32_id_2
        %460 = OpSelect %u32_id %459 %452 %458
        %461 = OpIEqual %bool_id %434 %u32_id_3
        %462 = OpSelect %u32_id %461 %456 %460
        %463 = OpBitcast %f32_id %462
        %464 = OpFOrdLessThanEqual %bool_id %463 %418
        %465 = OpIAdd %u32_id %434 %u32_id_1
        %466 = OpLogicalNot %bool_id %464
        %467 = OpLogicalAnd %bool_id %438 %466
               OpBranch %87
         %87 = OpLabel
               OpBranchConditional %467 %83 %88
         %88 = OpLabel
        %468 = OpPhi %u32_id %433 %84 %432 %85 %434 %87
               OpBranch %89
         %89 = OpLabel
        %469 = OpPhi %u32_id %468 %88 %389 %81
               OpSelectionMerge %98 None
               OpBranchConditional %425 %90 %98
         %90 = OpLabel
        %470 = OpIMul %u32_id %221 %u32_id_32
        %471 = OpIAdd %u32_id %470 %u32_id_24
        %472 = OpIAdd %u32_id %471 %buf2_dword_off
        %473 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %472
        %474 = OpLoad %u32_id %473
        %475 = OpIAdd %u32_id %474 %u32_id_4294967295
               OpBranch %91
         %91 = OpLabel
        %476 = OpPhi %u32_id %469 %90 %477 %96
        %477 = OpPhi %u32_id %u32_id_0 %90 %509 %96
        %478 = OpPhi %bool_id %191 %90 %519 %96
               OpLoopMerge %97 %96 None
               OpBranch %92
         %92 = OpLabel
        %479 = OpLogicalNot %bool_id %478
               OpBranchConditional %479 %97 %93
         %93 = OpLabel
        %480 = OpULessThan %bool_id %477 %475
        %481 = OpLogicalAnd %bool_id %478 %480
        %482 = OpLogicalNot %bool_id %481
               OpBranchConditional %482 %97 %94
         %94 = OpLabel
        %483 = OpIMul %u32_id %221 %u32_id_32
        %485 = OpIAdd %u32_id %483 %u32_id_28
        %486 = OpIAdd %u32_id %485 %buf2_dword_off
        %487 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %486
        %488 = OpLoad %u32_id %487
        %489 = OpIAdd %u32_id %486 %u32_id_1
        %490 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %489
        %491 = OpLoad %u32_id %490
        %492 = OpIAdd %u32_id %486 %u32_id_2
        %493 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %492
        %494 = OpLoad %u32_id %493
        %495 = OpIAdd %u32_id %486 %u32_id_3
        %496 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %495
        %497 = OpLoad %u32_id %496
        %498 = OpCompositeConstruct %u32vec4_id %488 %491 %494 %497
        %499 = OpCompositeExtract %u32_id %498 0
        %500 = OpCompositeExtract %u32_id %498 1
        %501 = OpCompositeExtract %u32_id %498 2
        %502 = OpCompositeExtract %u32_id %498 3
        %503 = OpIEqual %bool_id %u32_id_1 %477
        %504 = OpSelect %bool_id %503 %481 %false
        %505 = OpIEqual %bool_id %u32_id_2 %477
        %506 = OpSelect %bool_id %505 %481 %false
        %507 = OpIEqual %bool_id %u32_id_3 %477
        %508 = OpSelect %bool_id %507 %481 %false
        %509 = OpIAdd %u32_id %477 %u32_id_1
        %510 = OpBitcast %f32_id %499
        %511 = OpBitcast %f32_id %500
        %512 = OpSelect %f32_id %504 %511 %510
        %513 = OpBitcast %f32_id %501
        %514 = OpSelect %f32_id %506 %513 %512
        %515 = OpBitcast %f32_id %502
        %516 = OpSelect %f32_id %508 %515 %514
        %517 = OpFOrdLessThanEqual %bool_id %516 %418
        %518 = OpLogicalNot %bool_id %517
        %519 = OpLogicalAnd %bool_id %481 %518
        %520 = OpLogicalNot %bool_id %519
               OpBranchConditional %520 %97 %95
         %95 = OpLabel
               OpBranch %96
         %96 = OpLabel
               OpBranchConditional %true %91 %97
         %97 = OpLabel
        %521 = OpPhi %u32_id %476 %92 %475 %93 %477 %94 %477 %96
               OpBranch %98
         %98 = OpLabel
        %522 = OpPhi %u32_id %521 %97 %469 %89
               OpBranch %99
         %99 = OpLabel
        %523 = OpPhi %u32_id %276 %98 %134 %68
        %524 = OpPhi %u32_id %272 %98 %201 %68
        %525 = OpPhi %u32_id %522 %98 %234 %68
        %526 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %529 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_75
        %530 = OpLoad %u32_id %529
        %531 = OpIAdd %u32_id %221 %buf4_dword_off
        %532 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_5 %u32_id_0 %531
        %533 = OpLoad %u32_id %532
        %534 = OpINotEqual %bool_id %u32_id_0 %530
        %535 = OpIAdd %u32_id %533 %525
               OpSelectionMerge %115 None
               OpBranchConditional %534 %100 %115
        %100 = OpLabel
        %536 = OpIAdd %u32_id %202 %u32_id_9
        %537 = OpIAdd %u32_id %202 %u32_id_10
        %538 = OpIAdd %u32_id %202 %u32_id_8
        %539 = OpIAdd %u32_id %202 %buf0_dword_off
        %540 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %539
        %541 = OpLoad %u32_id %540
        %542 = OpIAdd %u32_id %202 %u32_id_8
        %543 = OpIAdd %u32_id %542 %buf0_dword_off
        %544 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %543
        %545 = OpLoad %u32_id %544
        %546 = OpIAdd %u32_id %202 %u32_id_9
        %547 = OpIAdd %u32_id %546 %buf0_dword_off
        %548 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %547
        %549 = OpLoad %u32_id %548
        %550 = OpIAdd %u32_id %202 %u32_id_10
        %551 = OpIAdd %u32_id %550 %buf0_dword_off
        %552 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %551
        %553 = OpLoad %u32_id %552
        %554 = OpIAdd %u32_id %202 %u32_id_4
        %555 = OpIAdd %u32_id %202 %u32_id_6
        %556 = OpIAdd %u32_id %202 %u32_id_3
        %557 = OpIAdd %u32_id %202 %u32_id_4
        %558 = OpIAdd %u32_id %557 %buf0_dword_off
        %559 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %558
        %560 = OpLoad %u32_id %559
        %561 = OpIAdd %u32_id %202 %u32_id_6
        %562 = OpIAdd %u32_id %561 %buf0_dword_off
        %563 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %562
        %564 = OpLoad %u32_id %563
        %565 = OpIAdd %u32_id %202 %u32_id_3
        %566 = OpIAdd %u32_id %565 %buf0_dword_off
        %567 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %566
        %568 = OpLoad %u32_id %567
        %570 = OpIAdd %u32_id %202 %u32_id_5
        %571 = OpIAdd %u32_id %202 %u32_id_2
        %572 = OpIAdd %u32_id %202 %u32_id_15
        %573 = OpIAdd %u32_id %202 %u32_id_5
        %574 = OpIAdd %u32_id %573 %buf0_dword_off
        %575 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %574
        %576 = OpLoad %u32_id %575
        %577 = OpIAdd %u32_id %202 %u32_id_2
        %578 = OpIAdd %u32_id %577 %buf0_dword_off
        %579 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %578
        %580 = OpLoad %u32_id %579
        %581 = OpIAdd %u32_id %202 %u32_id_15
        %582 = OpIAdd %u32_id %581 %buf0_dword_off
        %583 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %582
        %584 = OpLoad %u32_id %583
        %585 = OpIAdd %u32_id %202 %u32_id_1
        %587 = OpIAdd %u32_id %202 %u32_id_7
        %588 = OpIAdd %u32_id %202 %u32_id_1
        %589 = OpIAdd %u32_id %588 %buf0_dword_off
        %590 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %589
        %591 = OpLoad %u32_id %590
        %592 = OpIAdd %u32_id %202 %u32_id_7
        %593 = OpIAdd %u32_id %592 %buf0_dword_off
        %594 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %593
        %595 = OpLoad %u32_id %594
        %596 = OpIAdd %u32_id %202 %u32_id_11
        %597 = OpIAdd %u32_id %202 %u32_id_11
        %598 = OpIAdd %u32_id %597 %buf0_dword_off
        %599 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %598
        %600 = OpLoad %u32_id %599
        %601 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %603 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_52
        %604 = OpLoad %u32_id %603
        %606 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_53
        %607 = OpLoad %u32_id %606
        %610 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_54
        %611 = OpLoad %u32_id %610
        %613 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_55
        %614 = OpLoad %u32_id %613
        %616 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_56
        %617 = OpLoad %u32_id %616
        %618 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_57
        %619 = OpLoad %u32_id %618
        %621 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_58
        %622 = OpLoad %u32_id %621
        %623 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_59
        %624 = OpLoad %u32_id %623
        %625 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_60
        %626 = OpLoad %u32_id %625
        %627 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_61
        %628 = OpLoad %u32_id %627
        %630 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_62
        %631 = OpLoad %u32_id %630
        %633 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_63
        %634 = OpLoad %u32_id %633
        %635 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_64
        %636 = OpLoad %u32_id %635
        %638 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_65
        %639 = OpLoad %u32_id %638
        %641 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_66
        %642 = OpLoad %u32_id %641
        %644 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_67
        %645 = OpLoad %u32_id %644
        %646 = OpIMul %u32_id %221 %u32_id_32
        %647 = OpIAdd %u32_id %646 %buf2_dword_off
        %648 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %647
        %649 = OpLoad %u32_id %648
        %650 = OpIAdd %u32_id %647 %u32_id_1
        %651 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %650
        %652 = OpLoad %u32_id %651
        %653 = OpIAdd %u32_id %647 %u32_id_2
        %654 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %653
        %655 = OpLoad %u32_id %654
        %656 = OpCompositeConstruct %u32vec3_id %649 %652 %655
        %657 = OpCompositeExtract %u32_id %656 0
        %658 = OpCompositeExtract %u32_id %656 1
        %659 = OpCompositeExtract %u32_id %656 2
        %660 = OpBitcast %f32_id %541
        %661 = OpBitcast %f32_id %657
        %662 = OpBitcast %f32_id %210
        %663 = OpFMul %f32_id %660 %661
        %664 = OpFAdd %f32_id %663 %662
        %665 = OpBitcast %f32_id %591
        %666 = OpBitcast %f32_id %657
        %667 = OpBitcast %f32_id %214
        %668 = OpFMul %f32_id %665 %666
        %669 = OpFAdd %f32_id %668 %667
        %670 = OpBitcast %f32_id %658
        %671 = OpBitcast %f32_id %560
        %672 = OpFMul %f32_id %670 %671
        %673 = OpFAdd %f32_id %672 %664
        %674 = OpBitcast %f32_id %580
        %675 = OpBitcast %f32_id %657
        %676 = OpBitcast %f32_id %218
        %677 = OpFMul %f32_id %674 %675
        %678 = OpFAdd %f32_id %677 %676
        %679 = OpBitcast %f32_id %659
        %680 = OpBitcast %f32_id %545
        %681 = OpFMul %f32_id %679 %680
        %682 = OpFAdd %f32_id %681 %673
        %683 = OpBitcast %f32_id %658
        %684 = OpBitcast %f32_id %576
        %685 = OpFMul %f32_id %683 %684
        %686 = OpFAdd %f32_id %685 %669
        %687 = OpBitcast %f32_id %604
        %688 = OpFMul %f32_id %687 %682
        %689 = OpBitcast %f32_id %568
        %690 = OpBitcast %f32_id %657
        %691 = OpBitcast %f32_id %584
        %692 = OpFMul %f32_id %689 %690
        %693 = OpFAdd %f32_id %692 %691
        %694 = OpBitcast %f32_id %614
        %695 = OpFMul %f32_id %694 %682
        %696 = OpBitcast %f32_id %659
        %697 = OpBitcast %f32_id %549
        %698 = OpFMul %f32_id %696 %697
        %699 = OpFAdd %f32_id %698 %686
        %700 = OpBitcast %f32_id %658
        %701 = OpBitcast %f32_id %564
        %702 = OpFMul %f32_id %700 %701
        %703 = OpFAdd %f32_id %702 %678
        %704 = OpBitcast %f32_id %607
        %705 = OpFMul %f32_id %704 %682
        %706 = OpBitcast %f32_id %617
        %707 = OpFMul %f32_id %706 %699
        %708 = OpFAdd %f32_id %707 %688
        %709 = OpBitcast %f32_id %659
        %710 = OpBitcast %f32_id %553
        %711 = OpFMul %f32_id %709 %710
        %712 = OpFAdd %f32_id %711 %703
        %713 = OpBitcast %f32_id %658
        %714 = OpBitcast %f32_id %595
        %715 = OpFMul %f32_id %713 %714
        %716 = OpFAdd %f32_id %715 %693
        %717 = OpBitcast %f32_id %624
        %718 = OpFMul %f32_id %717 %699
        %719 = OpFAdd %f32_id %718 %695
        %720 = OpBitcast %f32_id %626
        %721 = OpFMul %f32_id %720 %712
        %722 = OpFAdd %f32_id %721 %708
        %723 = OpBitcast %f32_id %659
        %724 = OpBitcast %f32_id %600
        %725 = OpFMul %f32_id %723 %724
        %726 = OpFAdd %f32_id %725 %716
        %727 = OpBitcast %f32_id %611
        %728 = OpFMul %f32_id %727 %682
        %729 = OpBitcast %f32_id %634
        %730 = OpFMul %f32_id %729 %712
        %731 = OpFAdd %f32_id %730 %719
        %732 = OpBitcast %f32_id %619
        %733 = OpFMul %f32_id %732 %699
        %734 = OpFAdd %f32_id %733 %705
        %735 = OpBitcast %f32_id %636
        %736 = OpFMul %f32_id %735 %726
        %737 = OpFAdd %f32_id %736 %722
        %738 = OpBitcast %f32_id %645
        %739 = OpFMul %f32_id %738 %726
        %740 = OpFAdd %f32_id %739 %731
        %741 = OpBitcast %f32_id %628
        %742 = OpFMul %f32_id %741 %712
        %743 = OpFAdd %f32_id %742 %734
        %744 = OpBitcast %f32_id %622
        %745 = OpFMul %f32_id %744 %699
        %746 = OpFAdd %f32_id %745 %728
        %747 = OpFNegate %f32_id %737
        %748 = OpFOrdLessThan %bool_id %740 %747
        %749 = OpBitcast %f32_id %639
        %750 = OpFMul %f32_id %749 %726
        %751 = OpFAdd %f32_id %750 %743
        %752 = OpBitcast %f32_id %631
        %753 = OpFMul %f32_id %752 %712
        %754 = OpFAdd %f32_id %753 %746
        %755 = OpBitcast %f32_id %642
        %756 = OpFMul %f32_id %755 %726
        %757 = OpFAdd %f32_id %756 %754
        %759 = OpSelect %f32_id %748 %f32_id_0x1pn149 %f32_id_0
        %760 = OpBitcast %u32_id %759
        %761 = OpFNegate %f32_id %751
        %762 = OpFOrdLessThan %bool_id %740 %761
        %764 = OpSelect %f32_id %762 %f32_id_0x1pn148 %f32_id_0
        %765 = OpBitcast %u32_id %764
        %766 = OpFOrdGreaterThan %bool_id %f32_id_0 %757
        %767 = OpBitwiseOr %u32_id %760 %765
        %769 = OpSelect %f32_id %766 %f32_id_0x1pn147 %f32_id_0
        %770 = OpBitcast %u32_id %769
        %771 = OpFOrdLessThan %bool_id %740 %737
        %772 = OpBitwiseOr %u32_id %767 %770
        %774 = OpSelect %f32_id %771 %f32_id_0x1pn146 %f32_id_0
        %775 = OpBitcast %u32_id %774
        %776 = OpFOrdLessThan %bool_id %740 %751
        %777 = OpBitwiseOr %u32_id %772 %775
        %779 = OpSelect %f32_id %776 %f32_id_0x1pn145 %f32_id_0
        %780 = OpBitcast %u32_id %779
        %781 = OpFOrdLessThan %bool_id %740 %757
        %782 = OpBitwiseOr %u32_id %777 %780
        %784 = OpSelect %f32_id %781 %f32_id_0x1pn144 %f32_id_0
        %785 = OpBitcast %u32_id %784
        %786 = OpBitwiseOr %u32_id %782 %785
        %787 = OpBitwiseAnd %u32_id %530 %786
        %788 = OpINotEqual %bool_id %u32_id_0 %787
        %789 = OpLogicalAnd %bool_id %191 %788
               OpSelectionMerge %114 None
               OpBranchConditional %789 %101 %114
        %101 = OpLabel
        %790 = OpIMul %u32_id %221 %u32_id_32
        %791 = OpIAdd %u32_id %790 %u32_id_3
        %792 = OpIAdd %u32_id %791 %buf2_dword_off
        %793 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %792
        %794 = OpLoad %u32_id %793
        %795 = OpIAdd %u32_id %792 %u32_id_1
        %796 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %795
        %797 = OpLoad %u32_id %796
        %798 = OpIAdd %u32_id %792 %u32_id_2
        %799 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %798
        %800 = OpLoad %u32_id %799
        %801 = OpCompositeConstruct %u32vec3_id %794 %797 %800
        %802 = OpCompositeExtract %u32_id %801 0
        %803 = OpCompositeExtract %u32_id %801 1
        %804 = OpCompositeExtract %u32_id %801 2
        %805 = OpBitcast %f32_id %541
        %806 = OpBitcast %f32_id %802
        %807 = OpBitcast %f32_id %210
        %808 = OpFMul %f32_id %805 %806
        %809 = OpFAdd %f32_id %808 %807
        %810 = OpBitcast %f32_id %591
        %811 = OpBitcast %f32_id %802
        %812 = OpBitcast %f32_id %214
        %813 = OpFMul %f32_id %810 %811
        %814 = OpFAdd %f32_id %813 %812
        %815 = OpBitcast %f32_id %803
        %816 = OpBitcast %f32_id %560
        %817 = OpFMul %f32_id %815 %816
        %818 = OpFAdd %f32_id %817 %809
        %819 = OpBitcast %f32_id %580
        %820 = OpBitcast %f32_id %802
        %821 = OpBitcast %f32_id %218
        %822 = OpFMul %f32_id %819 %820
        %823 = OpFAdd %f32_id %822 %821
        %824 = OpBitcast %f32_id %804
        %825 = OpBitcast %f32_id %545
        %826 = OpFMul %f32_id %824 %825
        %827 = OpFAdd %f32_id %826 %818
        %828 = OpBitcast %f32_id %803
        %829 = OpBitcast %f32_id %576
        %830 = OpFMul %f32_id %828 %829
        %831 = OpFAdd %f32_id %830 %814
        %832 = OpBitcast %f32_id %604
        %833 = OpFMul %f32_id %832 %827
        %834 = OpBitcast %f32_id %568
        %835 = OpBitcast %f32_id %802
        %836 = OpBitcast %f32_id %584
        %837 = OpFMul %f32_id %834 %835
        %838 = OpFAdd %f32_id %837 %836
        %839 = OpBitcast %f32_id %614
        %840 = OpFMul %f32_id %839 %827
        %841 = OpBitcast %f32_id %804
        %842 = OpBitcast %f32_id %549
        %843 = OpFMul %f32_id %841 %842
        %844 = OpFAdd %f32_id %843 %831
        %845 = OpBitcast %f32_id %803
        %846 = OpBitcast %f32_id %564
        %847 = OpFMul %f32_id %845 %846
        %848 = OpFAdd %f32_id %847 %823
        %849 = OpBitcast %f32_id %607
        %850 = OpFMul %f32_id %849 %827
        %851 = OpBitcast %f32_id %617
        %852 = OpFMul %f32_id %851 %844
        %853 = OpFAdd %f32_id %852 %833
        %854 = OpBitcast %f32_id %804
        %855 = OpBitcast %f32_id %553
        %856 = OpFMul %f32_id %854 %855
        %857 = OpFAdd %f32_id %856 %848
        %858 = OpBitcast %f32_id %803
        %859 = OpBitcast %f32_id %595
        %860 = OpFMul %f32_id %858 %859
        %861 = OpFAdd %f32_id %860 %838
        %862 = OpBitcast %f32_id %624
        %863 = OpFMul %f32_id %862 %844
        %864 = OpFAdd %f32_id %863 %840
        %865 = OpBitcast %f32_id %626
        %866 = OpFMul %f32_id %865 %857
        %867 = OpFAdd %f32_id %866 %853
        %868 = OpBitcast %f32_id %804
        %869 = OpBitcast %f32_id %600
        %870 = OpFMul %f32_id %868 %869
        %871 = OpFAdd %f32_id %870 %861
        %872 = OpBitcast %f32_id %611
        %873 = OpFMul %f32_id %872 %827
        %874 = OpBitcast %f32_id %634
        %875 = OpFMul %f32_id %874 %857
        %876 = OpFAdd %f32_id %875 %864
        %877 = OpBitcast %f32_id %619
        %878 = OpFMul %f32_id %877 %844
        %879 = OpFAdd %f32_id %878 %850
        %880 = OpBitcast %f32_id %636
        %881 = OpFMul %f32_id %880 %871
        %882 = OpFAdd %f32_id %881 %867
        %883 = OpBitcast %f32_id %645
        %884 = OpFMul %f32_id %883 %871
        %885 = OpFAdd %f32_id %884 %876
        %886 = OpBitcast %f32_id %628
        %887 = OpFMul %f32_id %886 %857
        %888 = OpFAdd %f32_id %887 %879
        %889 = OpBitcast %f32_id %622
        %890 = OpFMul %f32_id %889 %844
        %891 = OpFAdd %f32_id %890 %873
        %892 = OpFNegate %f32_id %882
        %893 = OpFOrdLessThan %bool_id %885 %892
        %894 = OpBitcast %f32_id %639
        %895 = OpFMul %f32_id %894 %871
        %896 = OpFAdd %f32_id %895 %888
        %897 = OpBitcast %f32_id %631
        %898 = OpFMul %f32_id %897 %857
        %899 = OpFAdd %f32_id %898 %891
        %900 = OpBitcast %f32_id %642
        %901 = OpFMul %f32_id %900 %871
        %902 = OpFAdd %f32_id %901 %899
        %903 = OpSelect %f32_id %893 %f32_id_0x1pn149 %f32_id_0
        %904 = OpBitcast %u32_id %903
        %905 = OpFNegate %f32_id %896
        %906 = OpFOrdLessThan %bool_id %885 %905
        %907 = OpSelect %f32_id %906 %f32_id_0x1pn148 %f32_id_0
        %908 = OpBitcast %u32_id %907
        %909 = OpFOrdGreaterThan %bool_id %f32_id_0 %902
        %910 = OpBitwiseOr %u32_id %904 %908
        %911 = OpSelect %f32_id %909 %f32_id_0x1pn147 %f32_id_0
        %912 = OpBitcast %u32_id %911
        %913 = OpFOrdLessThan %bool_id %885 %882
        %914 = OpBitwiseOr %u32_id %910 %912
        %915 = OpSelect %f32_id %913 %f32_id_0x1pn146 %f32_id_0
        %916 = OpBitcast %u32_id %915
        %917 = OpFOrdLessThan %bool_id %885 %896
        %918 = OpBitwiseOr %u32_id %914 %916
        %919 = OpSelect %f32_id %917 %f32_id_0x1pn145 %f32_id_0
        %920 = OpBitcast %u32_id %919
        %921 = OpFOrdLessThan %bool_id %885 %902
        %922 = OpBitwiseOr %u32_id %918 %920
        %923 = OpSelect %f32_id %921 %f32_id_0x1pn144 %f32_id_0
        %924 = OpBitcast %u32_id %923
        %925 = OpBitwiseOr %u32_id %922 %924
        %926 = OpBitwiseAnd %u32_id %787 %925
        %927 = OpINotEqual %bool_id %u32_id_0 %926
        %928 = OpLogicalAnd %bool_id %789 %927
               OpSelectionMerge %113 None
               OpBranchConditional %928 %102 %113
        %102 = OpLabel
        %929 = OpIMul %u32_id %221 %u32_id_32
        %930 = OpIAdd %u32_id %929 %u32_id_6
        %931 = OpIAdd %u32_id %930 %buf2_dword_off
        %932 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %931
        %933 = OpLoad %u32_id %932
        %934 = OpIAdd %u32_id %931 %u32_id_1
        %935 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %934
        %936 = OpLoad %u32_id %935
        %937 = OpIAdd %u32_id %931 %u32_id_2
        %938 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %937
        %939 = OpLoad %u32_id %938
        %940 = OpCompositeConstruct %u32vec3_id %933 %936 %939
        %941 = OpCompositeExtract %u32_id %940 0
        %942 = OpCompositeExtract %u32_id %940 1
        %943 = OpCompositeExtract %u32_id %940 2
        %944 = OpBitcast %f32_id %541
        %945 = OpBitcast %f32_id %941
        %946 = OpBitcast %f32_id %210
        %947 = OpFMul %f32_id %944 %945
        %948 = OpFAdd %f32_id %947 %946
        %949 = OpBitcast %f32_id %591
        %950 = OpBitcast %f32_id %941
        %951 = OpBitcast %f32_id %214
        %952 = OpFMul %f32_id %949 %950
        %953 = OpFAdd %f32_id %952 %951
        %954 = OpBitcast %f32_id %942
        %955 = OpBitcast %f32_id %560
        %956 = OpFMul %f32_id %954 %955
        %957 = OpFAdd %f32_id %956 %948
        %958 = OpBitcast %f32_id %580
        %959 = OpBitcast %f32_id %941
        %960 = OpBitcast %f32_id %218
        %961 = OpFMul %f32_id %958 %959
        %962 = OpFAdd %f32_id %961 %960
        %963 = OpBitcast %f32_id %943
        %964 = OpBitcast %f32_id %545
        %965 = OpFMul %f32_id %963 %964
        %966 = OpFAdd %f32_id %965 %957
        %967 = OpBitcast %f32_id %942
        %968 = OpBitcast %f32_id %576
        %969 = OpFMul %f32_id %967 %968
        %970 = OpFAdd %f32_id %969 %953
        %971 = OpBitcast %f32_id %604
        %972 = OpFMul %f32_id %971 %966
        %973 = OpBitcast %f32_id %568
        %974 = OpBitcast %f32_id %941
        %975 = OpBitcast %f32_id %584
        %976 = OpFMul %f32_id %973 %974
        %977 = OpFAdd %f32_id %976 %975
        %978 = OpBitcast %f32_id %614
        %979 = OpFMul %f32_id %978 %966
        %980 = OpBitcast %f32_id %943
        %981 = OpBitcast %f32_id %549
        %982 = OpFMul %f32_id %980 %981
        %983 = OpFAdd %f32_id %982 %970
        %984 = OpBitcast %f32_id %942
        %985 = OpBitcast %f32_id %564
        %986 = OpFMul %f32_id %984 %985
        %987 = OpFAdd %f32_id %986 %962
        %988 = OpBitcast %f32_id %607
        %989 = OpFMul %f32_id %988 %966
        %990 = OpBitcast %f32_id %617
        %991 = OpFMul %f32_id %990 %983
        %992 = OpFAdd %f32_id %991 %972
        %993 = OpBitcast %f32_id %943
        %994 = OpBitcast %f32_id %553
        %995 = OpFMul %f32_id %993 %994
        %996 = OpFAdd %f32_id %995 %987
        %997 = OpBitcast %f32_id %942
        %998 = OpBitcast %f32_id %595
        %999 = OpFMul %f32_id %997 %998
       %1000 = OpFAdd %f32_id %999 %977
       %1001 = OpBitcast %f32_id %624
       %1002 = OpFMul %f32_id %1001 %983
       %1003 = OpFAdd %f32_id %1002 %979
       %1004 = OpBitcast %f32_id %626
       %1005 = OpFMul %f32_id %1004 %996
       %1006 = OpFAdd %f32_id %1005 %992
       %1007 = OpBitcast %f32_id %943
       %1008 = OpBitcast %f32_id %600
       %1009 = OpFMul %f32_id %1007 %1008
       %1010 = OpFAdd %f32_id %1009 %1000
       %1011 = OpBitcast %f32_id %611
       %1012 = OpFMul %f32_id %1011 %966
       %1013 = OpBitcast %f32_id %634
       %1014 = OpFMul %f32_id %1013 %996
       %1015 = OpFAdd %f32_id %1014 %1003
       %1016 = OpBitcast %f32_id %619
       %1017 = OpFMul %f32_id %1016 %983
       %1018 = OpFAdd %f32_id %1017 %989
       %1019 = OpBitcast %f32_id %636
       %1020 = OpFMul %f32_id %1019 %1010
       %1021 = OpFAdd %f32_id %1020 %1006
       %1022 = OpBitcast %f32_id %645
       %1023 = OpFMul %f32_id %1022 %1010
       %1024 = OpFAdd %f32_id %1023 %1015
       %1025 = OpBitcast %f32_id %628
       %1026 = OpFMul %f32_id %1025 %996
       %1027 = OpFAdd %f32_id %1026 %1018
       %1028 = OpBitcast %f32_id %622
       %1029 = OpFMul %f32_id %1028 %983
       %1030 = OpFAdd %f32_id %1029 %1012
       %1031 = OpFNegate %f32_id %1021
       %1032 = OpFOrdLessThan %bool_id %1024 %1031
       %1033 = OpBitcast %f32_id %639
       %1034 = OpFMul %f32_id %1033 %1010
       %1035 = OpFAdd %f32_id %1034 %1027
       %1036 = OpBitcast %f32_id %631
       %1037 = OpFMul %f32_id %1036 %996
       %1038 = OpFAdd %f32_id %1037 %1030
       %1039 = OpBitcast %f32_id %642
       %1040 = OpFMul %f32_id %1039 %1010
       %1041 = OpFAdd %f32_id %1040 %1038
       %1042 = OpSelect %f32_id %1032 %f32_id_0x1pn149 %f32_id_0
       %1043 = OpBitcast %u32_id %1042
       %1044 = OpFNegate %f32_id %1035
       %1045 = OpFOrdLessThan %bool_id %1024 %1044
       %1046 = OpSelect %f32_id %1045 %f32_id_0x1pn148 %f32_id_0
       %1047 = OpBitcast %u32_id %1046
       %1048 = OpFOrdGreaterThan %bool_id %f32_id_0 %1041
       %1049 = OpBitwiseOr %u32_id %1043 %1047
       %1050 = OpSelect %f32_id %1048 %f32_id_0x1pn147 %f32_id_0
       %1051 = OpBitcast %u32_id %1050
       %1052 = OpFOrdLessThan %bool_id %1024 %1021
       %1053 = OpBitwiseOr %u32_id %1049 %1051
       %1054 = OpSelect %f32_id %1052 %f32_id_0x1pn146 %f32_id_0
       %1055 = OpBitcast %u32_id %1054
       %1056 = OpFOrdLessThan %bool_id %1024 %1035
       %1057 = OpBitwiseOr %u32_id %1053 %1055
       %1058 = OpSelect %f32_id %1056 %f32_id_0x1pn145 %f32_id_0
       %1059 = OpBitcast %u32_id %1058
       %1060 = OpFOrdLessThan %bool_id %1024 %1041
       %1061 = OpBitwiseOr %u32_id %1057 %1059
       %1062 = OpSelect %f32_id %1060 %f32_id_0x1pn144 %f32_id_0
       %1063 = OpBitcast %u32_id %1062
       %1064 = OpBitwiseOr %u32_id %1061 %1063
       %1065 = OpBitwiseAnd %u32_id %926 %1064
       %1066 = OpINotEqual %bool_id %u32_id_0 %1065
       %1067 = OpLogicalAnd %bool_id %928 %1066
               OpSelectionMerge %112 None
               OpBranchConditional %1067 %103 %112
        %103 = OpLabel
       %1068 = OpIMul %u32_id %221 %u32_id_32
       %1069 = OpIAdd %u32_id %1068 %u32_id_9
       %1070 = OpIAdd %u32_id %1069 %buf2_dword_off
       %1071 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %1070
       %1072 = OpLoad %u32_id %1071
       %1073 = OpIAdd %u32_id %1070 %u32_id_1
       %1074 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %1073
       %1075 = OpLoad %u32_id %1074
       %1076 = OpIAdd %u32_id %1070 %u32_id_2
       %1077 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %1076
       %1078 = OpLoad %u32_id %1077
       %1079 = OpCompositeConstruct %u32vec3_id %1072 %1075 %1078
       %1080 = OpCompositeExtract %u32_id %1079 0
       %1081 = OpCompositeExtract %u32_id %1079 1
       %1082 = OpCompositeExtract %u32_id %1079 2
       %1083 = OpBitcast %f32_id %541
       %1084 = OpBitcast %f32_id %1080
       %1085 = OpBitcast %f32_id %210
       %1086 = OpFMul %f32_id %1083 %1084
       %1087 = OpFAdd %f32_id %1086 %1085
       %1088 = OpBitcast %f32_id %591
       %1089 = OpBitcast %f32_id %1080
       %1090 = OpBitcast %f32_id %214
       %1091 = OpFMul %f32_id %1088 %1089
       %1092 = OpFAdd %f32_id %1091 %1090
       %1093 = OpBitcast %f32_id %1081
       %1094 = OpBitcast %f32_id %560
       %1095 = OpFMul %f32_id %1093 %1094
       %1096 = OpFAdd %f32_id %1095 %1087
       %1097 = OpBitcast %f32_id %580
       %1098 = OpBitcast %f32_id %1080
       %1099 = OpBitcast %f32_id %218
       %1100 = OpFMul %f32_id %1097 %1098
       %1101 = OpFAdd %f32_id %1100 %1099
       %1102 = OpBitcast %f32_id %1082
       %1103 = OpBitcast %f32_id %545
       %1104 = OpFMul %f32_id %1102 %1103
       %1105 = OpFAdd %f32_id %1104 %1096
       %1106 = OpBitcast %f32_id %1081
       %1107 = OpBitcast %f32_id %576
       %1108 = OpFMul %f32_id %1106 %1107
       %1109 = OpFAdd %f32_id %1108 %1092
       %1110 = OpBitcast %f32_id %604
       %1111 = OpFMul %f32_id %1110 %1105
       %1112 = OpBitcast %f32_id %568
       %1113 = OpBitcast %f32_id %1080
       %1114 = OpBitcast %f32_id %584
       %1115 = OpFMul %f32_id %1112 %1113
       %1116 = OpFAdd %f32_id %1115 %1114
       %1117 = OpBitcast %f32_id %614
       %1118 = OpFMul %f32_id %1117 %1105
       %1119 = OpBitcast %f32_id %1082
       %1120 = OpBitcast %f32_id %549
       %1121 = OpFMul %f32_id %1119 %1120
       %1122 = OpFAdd %f32_id %1121 %1109
       %1123 = OpBitcast %f32_id %1081
       %1124 = OpBitcast %f32_id %564
       %1125 = OpFMul %f32_id %1123 %1124
       %1126 = OpFAdd %f32_id %1125 %1101
       %1127 = OpBitcast %f32_id %607
       %1128 = OpFMul %f32_id %1127 %1105
       %1129 = OpBitcast %f32_id %617
       %1130 = OpFMul %f32_id %1129 %1122
       %1131 = OpFAdd %f32_id %1130 %1111
       %1132 = OpBitcast %f32_id %1082
       %1133 = OpBitcast %f32_id %553
       %1134 = OpFMul %f32_id %1132 %1133
       %1135 = OpFAdd %f32_id %1134 %1126
       %1136 = OpBitcast %f32_id %1081
       %1137 = OpBitcast %f32_id %595
       %1138 = OpFMul %f32_id %1136 %1137
       %1139 = OpFAdd %f32_id %1138 %1116
       %1140 = OpBitcast %f32_id %624
       %1141 = OpFMul %f32_id %1140 %1122
       %1142 = OpFAdd %f32_id %1141 %1118
       %1143 = OpBitcast %f32_id %626
       %1144 = OpFMul %f32_id %1143 %1135
       %1145 = OpFAdd %f32_id %1144 %1131
       %1146 = OpBitcast %f32_id %1082
       %1147 = OpBitcast %f32_id %600
       %1148 = OpFMul %f32_id %1146 %1147
       %1149 = OpFAdd %f32_id %1148 %1139
       %1150 = OpBitcast %f32_id %611
       %1151 = OpFMul %f32_id %1150 %1105
       %1152 = OpBitcast %f32_id %634
       %1153 = OpFMul %f32_id %1152 %1135
       %1154 = OpFAdd %f32_id %1153 %1142
       %1155 = OpBitcast %f32_id %619
       %1156 = OpFMul %f32_id %1155 %1122
       %1157 = OpFAdd %f32_id %1156 %1128
       %1158 = OpBitcast %f32_id %636
       %1159 = OpFMul %f32_id %1158 %1149
       %1160 = OpFAdd %f32_id %1159 %1145
       %1161 = OpBitcast %f32_id %645
       %1162 = OpFMul %f32_id %1161 %1149
       %1163 = OpFAdd %f32_id %1162 %1154
       %1164 = OpBitcast %f32_id %628
       %1165 = OpFMul %f32_id %1164 %1135
       %1166 = OpFAdd %f32_id %1165 %1157
       %1167 = OpBitcast %f32_id %622
       %1168 = OpFMul %f32_id %1167 %1122
       %1169 = OpFAdd %f32_id %1168 %1151
       %1170 = OpFNegate %f32_id %1160
       %1171 = OpFOrdLessThan %bool_id %1163 %1170
       %1172 = OpBitcast %f32_id %639
       %1173 = OpFMul %f32_id %1172 %1149
       %1174 = OpFAdd %f32_id %1173 %1166
       %1175 = OpBitcast %f32_id %631
       %1176 = OpFMul %f32_id %1175 %1135
       %1177 = OpFAdd %f32_id %1176 %1169
       %1178 = OpBitcast %f32_id %642
       %1179 = OpFMul %f32_id %1178 %1149
       %1180 = OpFAdd %f32_id %1179 %1177
       %1181 = OpSelect %f32_id %1171 %f32_id_0x1pn149 %f32_id_0
       %1182 = OpBitcast %u32_id %1181
       %1183 = OpFNegate %f32_id %1174
       %1184 = OpFOrdLessThan %bool_id %1163 %1183
       %1185 = OpSelect %f32_id %1184 %f32_id_0x1pn148 %f32_id_0
       %1186 = OpBitcast %u32_id %1185
       %1187 = OpFOrdGreaterThan %bool_id %f32_id_0 %1180
       %1188 = OpBitwiseOr %u32_id %1182 %1186
       %1189 = OpSelect %f32_id %1187 %f32_id_0x1pn147 %f32_id_0
       %1190 = OpBitcast %u32_id %1189
       %1191 = OpFOrdLessThan %bool_id %1163 %1160
       %1192 = OpBitwiseOr %u32_id %1188 %1190
       %1193 = OpSelect %f32_id %1191 %f32_id_0x1pn146 %f32_id_0
       %1194 = OpBitcast %u32_id %1193
       %1195 = OpFOrdLessThan %bool_id %1163 %1174
       %1196 = OpBitwiseOr %u32_id %1192 %1194
       %1197 = OpSelect %f32_id %1195 %f32_id_0x1pn145 %f32_id_0
       %1198 = OpBitcast %u32_id %1197
       %1199 = OpFOrdLessThan %bool_id %1163 %1180
       %1200 = OpBitwiseOr %u32_id %1196 %1198
       %1201 = OpSelect %f32_id %1199 %f32_id_0x1pn144 %f32_id_0
       %1202 = OpBitcast %u32_id %1201
       %1203 = OpBitwiseOr %u32_id %1200 %1202
       %1204 = OpBitwiseAnd %u32_id %1065 %1203
       %1205 = OpINotEqual %bool_id %u32_id_0 %1204
       %1206 = OpLogicalAnd %bool_id %1067 %1205
               OpSelectionMerge %111 None
               OpBranchConditional %1206 %104 %111
        %104 = OpLabel
       %1207 = OpIMul %u32_id %221 %u32_id_32
       %1208 = OpIAdd %u32_id %1207 %u32_id_12
       %1209 = OpIAdd %u32_id %1208 %buf2_dword_off
       %1210 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %1209
       %1211 = OpLoad %u32_id %1210
       %1212 = OpIAdd %u32_id %1209 %u32_id_1
       %1213 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %1212
       %1214 = OpLoad %u32_id %1213
       %1215 = OpIAdd %u32_id %1209 %u32_id_2
       %1216 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %1215
       %1217 = OpLoad %u32_id %1216
       %1218 = OpCompositeConstruct %u32vec3_id %1211 %1214 %1217
       %1219 = OpCompositeExtract %u32_id %1218 0
       %1220 = OpCompositeExtract %u32_id %1218 1
       %1221 = OpCompositeExtract %u32_id %1218 2
       %1222 = OpBitcast %f32_id %541
       %1223 = OpBitcast %f32_id %1219
       %1224 = OpBitcast %f32_id %210
       %1225 = OpFMul %f32_id %1222 %1223
       %1226 = OpFAdd %f32_id %1225 %1224
       %1227 = OpBitcast %f32_id %591
       %1228 = OpBitcast %f32_id %1219
       %1229 = OpBitcast %f32_id %214
       %1230 = OpFMul %f32_id %1227 %1228
       %1231 = OpFAdd %f32_id %1230 %1229
       %1232 = OpBitcast %f32_id %1220
       %1233 = OpBitcast %f32_id %560
       %1234 = OpFMul %f32_id %1232 %1233
       %1235 = OpFAdd %f32_id %1234 %1226
       %1236 = OpBitcast %f32_id %580
       %1237 = OpBitcast %f32_id %1219
       %1238 = OpBitcast %f32_id %218
       %1239 = OpFMul %f32_id %1236 %1237
       %1240 = OpFAdd %f32_id %1239 %1238
       %1241 = OpBitcast %f32_id %1221
       %1242 = OpBitcast %f32_id %545
       %1243 = OpFMul %f32_id %1241 %1242
       %1244 = OpFAdd %f32_id %1243 %1235
       %1245 = OpBitcast %f32_id %1220
       %1246 = OpBitcast %f32_id %576
       %1247 = OpFMul %f32_id %1245 %1246
       %1248 = OpFAdd %f32_id %1247 %1231
       %1249 = OpBitcast %f32_id %604
       %1250 = OpFMul %f32_id %1249 %1244
       %1251 = OpBitcast %f32_id %568
       %1252 = OpBitcast %f32_id %1219
       %1253 = OpBitcast %f32_id %584
       %1254 = OpFMul %f32_id %1251 %1252
       %1255 = OpFAdd %f32_id %1254 %1253
       %1256 = OpBitcast %f32_id %614
       %1257 = OpFMul %f32_id %1256 %1244
       %1258 = OpBitcast %f32_id %1221
       %1259 = OpBitcast %f32_id %549
       %1260 = OpFMul %f32_id %1258 %1259
       %1261 = OpFAdd %f32_id %1260 %1248
       %1262 = OpBitcast %f32_id %1220
       %1263 = OpBitcast %f32_id %564
       %1264 = OpFMul %f32_id %1262 %1263
       %1265 = OpFAdd %f32_id %1264 %1240
       %1266 = OpBitcast %f32_id %607
       %1267 = OpFMul %f32_id %1266 %1244
       %1268 = OpBitcast %f32_id %617
       %1269 = OpFMul %f32_id %1268 %1261
       %1270 = OpFAdd %f32_id %1269 %1250
       %1271 = OpBitcast %f32_id %1221
       %1272 = OpBitcast %f32_id %553
       %1273 = OpFMul %f32_id %1271 %1272
       %1274 = OpFAdd %f32_id %1273 %1265
       %1275 = OpBitcast %f32_id %1220
       %1276 = OpBitcast %f32_id %595
       %1277 = OpFMul %f32_id %1275 %1276
       %1278 = OpFAdd %f32_id %1277 %1255
       %1279 = OpBitcast %f32_id %624
       %1280 = OpFMul %f32_id %1279 %1261
       %1281 = OpFAdd %f32_id %1280 %1257
       %1282 = OpBitcast %f32_id %626
       %1283 = OpFMul %f32_id %1282 %1274
       %1284 = OpFAdd %f32_id %1283 %1270
       %1285 = OpBitcast %f32_id %1221
       %1286 = OpBitcast %f32_id %600
       %1287 = OpFMul %f32_id %1285 %1286
       %1288 = OpFAdd %f32_id %1287 %1278
       %1289 = OpBitcast %f32_id %611
       %1290 = OpFMul %f32_id %1289 %1244
       %1291 = OpBitcast %f32_id %634
       %1292 = OpFMul %f32_id %1291 %1274
       %1293 = OpFAdd %f32_id %1292 %1281
       %1294 = OpBitcast %f32_id %619
       %1295 = OpFMul %f32_id %1294 %1261
       %1296 = OpFAdd %f32_id %1295 %1267
       %1297 = OpBitcast %f32_id %636
       %1298 = OpFMul %f32_id %1297 %1288
       %1299 = OpFAdd %f32_id %1298 %1284
       %1300 = OpBitcast %f32_id %645
       %1301 = OpFMul %f32_id %1300 %1288
       %1302 = OpFAdd %f32_id %1301 %1293
       %1303 = OpBitcast %f32_id %628
       %1304 = OpFMul %f32_id %1303 %1274
       %1305 = OpFAdd %f32_id %1304 %1296
       %1306 = OpBitcast %f32_id %622
       %1307 = OpFMul %f32_id %1306 %1261
       %1308 = OpFAdd %f32_id %1307 %1290
       %1309 = OpFNegate %f32_id %1299
       %1310 = OpFOrdLessThan %bool_id %1302 %1309
       %1311 = OpBitcast %f32_id %639
       %1312 = OpFMul %f32_id %1311 %1288
       %1313 = OpFAdd %f32_id %1312 %1305
       %1314 = OpBitcast %f32_id %631
       %1315 = OpFMul %f32_id %1314 %1274
       %1316 = OpFAdd %f32_id %1315 %1308
       %1317 = OpBitcast %f32_id %642
       %1318 = OpFMul %f32_id %1317 %1288
       %1319 = OpFAdd %f32_id %1318 %1316
       %1320 = OpSelect %f32_id %1310 %f32_id_0x1pn149 %f32_id_0
       %1321 = OpBitcast %u32_id %1320
       %1322 = OpFNegate %f32_id %1313
       %1323 = OpFOrdLessThan %bool_id %1302 %1322
       %1324 = OpSelect %f32_id %1323 %f32_id_0x1pn148 %f32_id_0
       %1325 = OpBitcast %u32_id %1324
       %1326 = OpFOrdGreaterThan %bool_id %f32_id_0 %1319
       %1327 = OpBitwiseOr %u32_id %1321 %1325
       %1328 = OpSelect %f32_id %1326 %f32_id_0x1pn147 %f32_id_0
       %1329 = OpBitcast %u32_id %1328
       %1330 = OpFOrdLessThan %bool_id %1302 %1299
       %1331 = OpBitwiseOr %u32_id %1327 %1329
       %1332 = OpSelect %f32_id %1330 %f32_id_0x1pn146 %f32_id_0
       %1333 = OpBitcast %u32_id %1332
       %1334 = OpFOrdLessThan %bool_id %1302 %1313
       %1335 = OpBitwiseOr %u32_id %1331 %1333
       %1336 = OpSelect %f32_id %1334 %f32_id_0x1pn145 %f32_id_0
       %1337 = OpBitcast %u32_id %1336
       %1338 = OpFOrdLessThan %bool_id %1302 %1319
       %1339 = OpBitwiseOr %u32_id %1335 %1337
       %1340 = OpSelect %f32_id %1338 %f32_id_0x1pn144 %f32_id_0
       %1341 = OpBitcast %u32_id %1340
       %1342 = OpBitwiseOr %u32_id %1339 %1341
       %1343 = OpBitwiseAnd %u32_id %1204 %1342
       %1344 = OpINotEqual %bool_id %u32_id_0 %1343
       %1345 = OpLogicalAnd %bool_id %1206 %1344
               OpSelectionMerge %110 None
               OpBranchConditional %1345 %105 %110
        %105 = OpLabel
       %1346 = OpIMul %u32_id %221 %u32_id_32
       %1347 = OpIAdd %u32_id %1346 %u32_id_15
       %1348 = OpIAdd %u32_id %1347 %buf2_dword_off
       %1349 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %1348
       %1350 = OpLoad %u32_id %1349
       %1351 = OpIAdd %u32_id %1348 %u32_id_1
       %1352 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %1351
       %1353 = OpLoad %u32_id %1352
       %1354 = OpIAdd %u32_id %1348 %u32_id_2
       %1355 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %1354
       %1356 = OpLoad %u32_id %1355
       %1357 = OpCompositeConstruct %u32vec3_id %1350 %1353 %1356
       %1358 = OpCompositeExtract %u32_id %1357 0
       %1359 = OpCompositeExtract %u32_id %1357 1
       %1360 = OpCompositeExtract %u32_id %1357 2
       %1361 = OpBitcast %f32_id %541
       %1362 = OpBitcast %f32_id %1358
       %1363 = OpBitcast %f32_id %210
       %1364 = OpFMul %f32_id %1361 %1362
       %1365 = OpFAdd %f32_id %1364 %1363
       %1366 = OpBitcast %f32_id %591
       %1367 = OpBitcast %f32_id %1358
       %1368 = OpBitcast %f32_id %214
       %1369 = OpFMul %f32_id %1366 %1367
       %1370 = OpFAdd %f32_id %1369 %1368
       %1371 = OpBitcast %f32_id %1359
       %1372 = OpBitcast %f32_id %560
       %1373 = OpFMul %f32_id %1371 %1372
       %1374 = OpFAdd %f32_id %1373 %1365
       %1375 = OpBitcast %f32_id %580
       %1376 = OpBitcast %f32_id %1358
       %1377 = OpBitcast %f32_id %218
       %1378 = OpFMul %f32_id %1375 %1376
       %1379 = OpFAdd %f32_id %1378 %1377
       %1380 = OpBitcast %f32_id %1360
       %1381 = OpBitcast %f32_id %545
       %1382 = OpFMul %f32_id %1380 %1381
       %1383 = OpFAdd %f32_id %1382 %1374
       %1384 = OpBitcast %f32_id %1359
       %1385 = OpBitcast %f32_id %576
       %1386 = OpFMul %f32_id %1384 %1385
       %1387 = OpFAdd %f32_id %1386 %1370
       %1388 = OpBitcast %f32_id %604
       %1389 = OpFMul %f32_id %1388 %1383
       %1390 = OpBitcast %f32_id %568
       %1391 = OpBitcast %f32_id %1358
       %1392 = OpBitcast %f32_id %584
       %1393 = OpFMul %f32_id %1390 %1391
       %1394 = OpFAdd %f32_id %1393 %1392
       %1395 = OpBitcast %f32_id %614
       %1396 = OpFMul %f32_id %1395 %1383
       %1397 = OpBitcast %f32_id %1360
       %1398 = OpBitcast %f32_id %549
       %1399 = OpFMul %f32_id %1397 %1398
       %1400 = OpFAdd %f32_id %1399 %1387
       %1401 = OpBitcast %f32_id %1359
       %1402 = OpBitcast %f32_id %564
       %1403 = OpFMul %f32_id %1401 %1402
       %1404 = OpFAdd %f32_id %1403 %1379
       %1405 = OpBitcast %f32_id %607
       %1406 = OpFMul %f32_id %1405 %1383
       %1407 = OpBitcast %f32_id %617
       %1408 = OpFMul %f32_id %1407 %1400
       %1409 = OpFAdd %f32_id %1408 %1389
       %1410 = OpBitcast %f32_id %1360
       %1411 = OpBitcast %f32_id %553
       %1412 = OpFMul %f32_id %1410 %1411
       %1413 = OpFAdd %f32_id %1412 %1404
       %1414 = OpBitcast %f32_id %1359
       %1415 = OpBitcast %f32_id %595
       %1416 = OpFMul %f32_id %1414 %1415
       %1417 = OpFAdd %f32_id %1416 %1394
       %1418 = OpBitcast %f32_id %624
       %1419 = OpFMul %f32_id %1418 %1400
       %1420 = OpFAdd %f32_id %1419 %1396
       %1421 = OpBitcast %f32_id %626
       %1422 = OpFMul %f32_id %1421 %1413
       %1423 = OpFAdd %f32_id %1422 %1409
       %1424 = OpBitcast %f32_id %1360
       %1425 = OpBitcast %f32_id %600
       %1426 = OpFMul %f32_id %1424 %1425
       %1427 = OpFAdd %f32_id %1426 %1417
       %1428 = OpBitcast %f32_id %611
       %1429 = OpFMul %f32_id %1428 %1383
       %1430 = OpBitcast %f32_id %634
       %1431 = OpFMul %f32_id %1430 %1413
       %1432 = OpFAdd %f32_id %1431 %1420
       %1433 = OpBitcast %f32_id %619
       %1434 = OpFMul %f32_id %1433 %1400
       %1435 = OpFAdd %f32_id %1434 %1406
       %1436 = OpBitcast %f32_id %636
       %1437 = OpFMul %f32_id %1436 %1427
       %1438 = OpFAdd %f32_id %1437 %1423
       %1439 = OpBitcast %f32_id %645
       %1440 = OpFMul %f32_id %1439 %1427
       %1441 = OpFAdd %f32_id %1440 %1432
       %1442 = OpBitcast %f32_id %628
       %1443 = OpFMul %f32_id %1442 %1413
       %1444 = OpFAdd %f32_id %1443 %1435
       %1445 = OpBitcast %f32_id %622
       %1446 = OpFMul %f32_id %1445 %1400
       %1447 = OpFAdd %f32_id %1446 %1429
       %1448 = OpFNegate %f32_id %1438
       %1449 = OpFOrdLessThan %bool_id %1441 %1448
       %1450 = OpBitcast %f32_id %639
       %1451 = OpFMul %f32_id %1450 %1427
       %1452 = OpFAdd %f32_id %1451 %1444
       %1453 = OpBitcast %f32_id %631
       %1454 = OpFMul %f32_id %1453 %1413
       %1455 = OpFAdd %f32_id %1454 %1447
       %1456 = OpBitcast %f32_id %642
       %1457 = OpFMul %f32_id %1456 %1427
       %1458 = OpFAdd %f32_id %1457 %1455
       %1459 = OpSelect %f32_id %1449 %f32_id_0x1pn149 %f32_id_0
       %1460 = OpBitcast %u32_id %1459
       %1461 = OpFNegate %f32_id %1452
       %1462 = OpFOrdLessThan %bool_id %1441 %1461
       %1463 = OpSelect %f32_id %1462 %f32_id_0x1pn148 %f32_id_0
       %1464 = OpBitcast %u32_id %1463
       %1465 = OpFOrdGreaterThan %bool_id %f32_id_0 %1458
       %1466 = OpBitwiseOr %u32_id %1460 %1464
       %1467 = OpSelect %f32_id %1465 %f32_id_0x1pn147 %f32_id_0
       %1468 = OpBitcast %u32_id %1467
       %1469 = OpFOrdLessThan %bool_id %1441 %1438
       %1470 = OpBitwiseOr %u32_id %1466 %1468
       %1471 = OpSelect %f32_id %1469 %f32_id_0x1pn146 %f32_id_0
       %1472 = OpBitcast %u32_id %1471
       %1473 = OpFOrdLessThan %bool_id %1441 %1452
       %1474 = OpBitwiseOr %u32_id %1470 %1472
       %1475 = OpSelect %f32_id %1473 %f32_id_0x1pn145 %f32_id_0
       %1476 = OpBitcast %u32_id %1475
       %1477 = OpFOrdLessThan %bool_id %1441 %1458
       %1478 = OpBitwiseOr %u32_id %1474 %1476
       %1479 = OpSelect %f32_id %1477 %f32_id_0x1pn144 %f32_id_0
       %1480 = OpBitcast %u32_id %1479
       %1481 = OpBitwiseOr %u32_id %1478 %1480
       %1482 = OpBitwiseAnd %u32_id %1343 %1481
       %1483 = OpINotEqual %bool_id %u32_id_0 %1482
       %1484 = OpLogicalAnd %bool_id %1345 %1483
               OpSelectionMerge %109 None
               OpBranchConditional %1484 %106 %109
        %106 = OpLabel
       %1485 = OpIMul %u32_id %221 %u32_id_32
       %1487 = OpIAdd %u32_id %1485 %u32_id_18
       %1488 = OpIAdd %u32_id %1487 %buf2_dword_off
       %1489 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %1488
       %1490 = OpLoad %u32_id %1489
       %1491 = OpIAdd %u32_id %1488 %u32_id_1
       %1492 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %1491
       %1493 = OpLoad %u32_id %1492
       %1494 = OpIAdd %u32_id %1488 %u32_id_2
       %1495 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %1494
       %1496 = OpLoad %u32_id %1495
       %1497 = OpCompositeConstruct %u32vec3_id %1490 %1493 %1496
       %1498 = OpCompositeExtract %u32_id %1497 0
       %1499 = OpCompositeExtract %u32_id %1497 1
       %1500 = OpCompositeExtract %u32_id %1497 2
       %1501 = OpBitcast %f32_id %541
       %1502 = OpBitcast %f32_id %1498
       %1503 = OpBitcast %f32_id %210
       %1504 = OpFMul %f32_id %1501 %1502
       %1505 = OpFAdd %f32_id %1504 %1503
       %1506 = OpBitcast %f32_id %591
       %1507 = OpBitcast %f32_id %1498
       %1508 = OpBitcast %f32_id %214
       %1509 = OpFMul %f32_id %1506 %1507
       %1510 = OpFAdd %f32_id %1509 %1508
       %1511 = OpBitcast %f32_id %1499
       %1512 = OpBitcast %f32_id %560
       %1513 = OpFMul %f32_id %1511 %1512
       %1514 = OpFAdd %f32_id %1513 %1505
       %1515 = OpBitcast %f32_id %580
       %1516 = OpBitcast %f32_id %1498
       %1517 = OpBitcast %f32_id %218
       %1518 = OpFMul %f32_id %1515 %1516
       %1519 = OpFAdd %f32_id %1518 %1517
       %1520 = OpBitcast %f32_id %1500
       %1521 = OpBitcast %f32_id %545
       %1522 = OpFMul %f32_id %1520 %1521
       %1523 = OpFAdd %f32_id %1522 %1514
       %1524 = OpBitcast %f32_id %1499
       %1525 = OpBitcast %f32_id %576
       %1526 = OpFMul %f32_id %1524 %1525
       %1527 = OpFAdd %f32_id %1526 %1510
       %1528 = OpBitcast %f32_id %604
       %1529 = OpFMul %f32_id %1528 %1523
       %1530 = OpBitcast %f32_id %568
       %1531 = OpBitcast %f32_id %1498
       %1532 = OpBitcast %f32_id %584
       %1533 = OpFMul %f32_id %1530 %1531
       %1534 = OpFAdd %f32_id %1533 %1532
       %1535 = OpBitcast %f32_id %614
       %1536 = OpFMul %f32_id %1535 %1523
       %1537 = OpBitcast %f32_id %1500
       %1538 = OpBitcast %f32_id %549
       %1539 = OpFMul %f32_id %1537 %1538
       %1540 = OpFAdd %f32_id %1539 %1527
       %1541 = OpBitcast %f32_id %1499
       %1542 = OpBitcast %f32_id %564
       %1543 = OpFMul %f32_id %1541 %1542
       %1544 = OpFAdd %f32_id %1543 %1519
       %1545 = OpBitcast %f32_id %607
       %1546 = OpFMul %f32_id %1545 %1523
       %1547 = OpBitcast %f32_id %617
       %1548 = OpFMul %f32_id %1547 %1540
       %1549 = OpFAdd %f32_id %1548 %1529
       %1550 = OpBitcast %f32_id %1500
       %1551 = OpBitcast %f32_id %553
       %1552 = OpFMul %f32_id %1550 %1551
       %1553 = OpFAdd %f32_id %1552 %1544
       %1554 = OpBitcast %f32_id %1499
       %1555 = OpBitcast %f32_id %595
       %1556 = OpFMul %f32_id %1554 %1555
       %1557 = OpFAdd %f32_id %1556 %1534
       %1558 = OpBitcast %f32_id %624
       %1559 = OpFMul %f32_id %1558 %1540
       %1560 = OpFAdd %f32_id %1559 %1536
       %1561 = OpBitcast %f32_id %626
       %1562 = OpFMul %f32_id %1561 %1553
       %1563 = OpFAdd %f32_id %1562 %1549
       %1564 = OpBitcast %f32_id %1500
       %1565 = OpBitcast %f32_id %600
       %1566 = OpFMul %f32_id %1564 %1565
       %1567 = OpFAdd %f32_id %1566 %1557
       %1568 = OpBitcast %f32_id %611
       %1569 = OpFMul %f32_id %1568 %1523
       %1570 = OpBitcast %f32_id %634
       %1571 = OpFMul %f32_id %1570 %1553
       %1572 = OpFAdd %f32_id %1571 %1560
       %1573 = OpBitcast %f32_id %619
       %1574 = OpFMul %f32_id %1573 %1540
       %1575 = OpFAdd %f32_id %1574 %1546
       %1576 = OpBitcast %f32_id %636
       %1577 = OpFMul %f32_id %1576 %1567
       %1578 = OpFAdd %f32_id %1577 %1563
       %1579 = OpBitcast %f32_id %645
       %1580 = OpFMul %f32_id %1579 %1567
       %1581 = OpFAdd %f32_id %1580 %1572
       %1582 = OpBitcast %f32_id %628
       %1583 = OpFMul %f32_id %1582 %1553
       %1584 = OpFAdd %f32_id %1583 %1575
       %1585 = OpBitcast %f32_id %622
       %1586 = OpFMul %f32_id %1585 %1540
       %1587 = OpFAdd %f32_id %1586 %1569
       %1588 = OpFNegate %f32_id %1578
       %1589 = OpFOrdLessThan %bool_id %1581 %1588
       %1590 = OpBitcast %f32_id %639
       %1591 = OpFMul %f32_id %1590 %1567
       %1592 = OpFAdd %f32_id %1591 %1584
       %1593 = OpBitcast %f32_id %631
       %1594 = OpFMul %f32_id %1593 %1553
       %1595 = OpFAdd %f32_id %1594 %1587
       %1596 = OpBitcast %f32_id %642
       %1597 = OpFMul %f32_id %1596 %1567
       %1598 = OpFAdd %f32_id %1597 %1595
       %1599 = OpSelect %f32_id %1589 %f32_id_0x1pn149 %f32_id_0
       %1600 = OpBitcast %u32_id %1599
       %1601 = OpFNegate %f32_id %1592
       %1602 = OpFOrdLessThan %bool_id %1581 %1601
       %1603 = OpSelect %f32_id %1602 %f32_id_0x1pn148 %f32_id_0
       %1604 = OpBitcast %u32_id %1603
       %1605 = OpFOrdGreaterThan %bool_id %f32_id_0 %1598
       %1606 = OpBitwiseOr %u32_id %1600 %1604
       %1607 = OpSelect %f32_id %1605 %f32_id_0x1pn147 %f32_id_0
       %1608 = OpBitcast %u32_id %1607
       %1609 = OpFOrdLessThan %bool_id %1581 %1578
       %1610 = OpBitwiseOr %u32_id %1606 %1608
       %1611 = OpSelect %f32_id %1609 %f32_id_0x1pn146 %f32_id_0
       %1612 = OpBitcast %u32_id %1611
       %1613 = OpFOrdLessThan %bool_id %1581 %1592
       %1614 = OpBitwiseOr %u32_id %1610 %1612
       %1615 = OpSelect %f32_id %1613 %f32_id_0x1pn145 %f32_id_0
       %1616 = OpBitcast %u32_id %1615
       %1617 = OpFOrdLessThan %bool_id %1581 %1598
       %1618 = OpBitwiseOr %u32_id %1614 %1616
       %1619 = OpSelect %f32_id %1617 %f32_id_0x1pn144 %f32_id_0
       %1620 = OpBitcast %u32_id %1619
       %1621 = OpBitwiseOr %u32_id %1618 %1620
       %1622 = OpBitwiseAnd %u32_id %1482 %1621
       %1623 = OpINotEqual %bool_id %u32_id_0 %1622
       %1624 = OpLogicalAnd %bool_id %1484 %1623
               OpSelectionMerge %108 None
               OpBranchConditional %1624 %107 %108
        %107 = OpLabel
       %1625 = OpIMul %u32_id %221 %u32_id_32
       %1627 = OpIAdd %u32_id %1625 %u32_id_21
       %1628 = OpIAdd %u32_id %1627 %buf2_dword_off
       %1629 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %1628
       %1630 = OpLoad %u32_id %1629
       %1631 = OpIAdd %u32_id %1628 %u32_id_1
       %1632 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %1631
       %1633 = OpLoad %u32_id %1632
       %1634 = OpIAdd %u32_id %1628 %u32_id_2
       %1635 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %1634
       %1636 = OpLoad %u32_id %1635
       %1637 = OpCompositeConstruct %u32vec3_id %1630 %1633 %1636
       %1638 = OpCompositeExtract %u32_id %1637 0
       %1639 = OpCompositeExtract %u32_id %1637 1
       %1640 = OpCompositeExtract %u32_id %1637 2
       %1641 = OpBitcast %f32_id %1638
       %1642 = OpBitcast %f32_id %541
       %1643 = OpBitcast %f32_id %210
       %1644 = OpFMul %f32_id %1641 %1642
       %1645 = OpFAdd %f32_id %1644 %1643
       %1646 = OpBitcast %f32_id %560
       %1647 = OpBitcast %f32_id %1639
       %1648 = OpFMul %f32_id %1646 %1647
       %1649 = OpFAdd %f32_id %1648 %1645
       %1650 = OpBitcast %f32_id %1638
       %1651 = OpBitcast %f32_id %591
       %1652 = OpBitcast %f32_id %214
       %1653 = OpFMul %f32_id %1650 %1651
       %1654 = OpFAdd %f32_id %1653 %1652
       %1655 = OpBitcast %f32_id %1640
       %1656 = OpBitcast %f32_id %545
       %1657 = OpFMul %f32_id %1655 %1656
       %1658 = OpFAdd %f32_id %1657 %1649
       %1659 = OpBitcast %f32_id %1639
       %1660 = OpBitcast %f32_id %576
       %1661 = OpFMul %f32_id %1659 %1660
       %1662 = OpFAdd %f32_id %1661 %1654
       %1663 = OpBitcast %f32_id %1638
       %1664 = OpBitcast %f32_id %580
       %1665 = OpBitcast %f32_id %218
       %1666 = OpFMul %f32_id %1663 %1664
       %1667 = OpFAdd %f32_id %1666 %1665
       %1668 = OpBitcast %f32_id %604
       %1669 = OpFMul %f32_id %1668 %1658
       %1670 = OpBitcast %f32_id %614
       %1671 = OpFMul %f32_id %1670 %1658
       %1672 = OpBitcast %f32_id %1640
       %1673 = OpBitcast %f32_id %549
       %1674 = OpFMul %f32_id %1672 %1673
       %1675 = OpFAdd %f32_id %1674 %1662
       %1676 = OpBitcast %f32_id %607
       %1677 = OpFMul %f32_id %1676 %1658
       %1678 = OpBitcast %f32_id %1639
       %1679 = OpBitcast %f32_id %564
       %1680 = OpFMul %f32_id %1678 %1679
       %1681 = OpFAdd %f32_id %1680 %1667
       %1682 = OpBitcast %f32_id %1638
       %1683 = OpBitcast %f32_id %568
       %1684 = OpBitcast %f32_id %584
       %1685 = OpFMul %f32_id %1682 %1683
       %1686 = OpFAdd %f32_id %1685 %1684
       %1687 = OpBitcast %f32_id %553
       %1688 = OpBitcast %f32_id %1640
       %1689 = OpFMul %f32_id %1687 %1688
       %1690 = OpFAdd %f32_id %1689 %1681
       %1691 = OpBitcast %f32_id %611
       %1692 = OpFMul %f32_id %1691 %1658
       %1693 = OpBitcast %f32_id %617
       %1694 = OpFMul %f32_id %1693 %1675
       %1695 = OpFAdd %f32_id %1694 %1669
       %1696 = OpBitcast %f32_id %1639
       %1697 = OpBitcast %f32_id %595
       %1698 = OpFMul %f32_id %1696 %1697
       %1699 = OpFAdd %f32_id %1698 %1686
       %1700 = OpBitcast %f32_id %624
       %1701 = OpFMul %f32_id %1700 %1675
       %1702 = OpFAdd %f32_id %1701 %1671
       %1703 = OpBitcast %f32_id %619
       %1704 = OpFMul %f32_id %1703 %1675
       %1705 = OpFAdd %f32_id %1704 %1677
       %1706 = OpBitcast %f32_id %626
       %1707 = OpFMul %f32_id %1706 %1690
       %1708 = OpFAdd %f32_id %1707 %1695
       %1709 = OpBitcast %f32_id %634
       %1710 = OpFMul %f32_id %1709 %1690
       %1711 = OpFAdd %f32_id %1710 %1702
       %1712 = OpBitcast %f32_id %1640
       %1713 = OpBitcast %f32_id %600
       %1714 = OpFMul %f32_id %1712 %1713
       %1715 = OpFAdd %f32_id %1714 %1699
       %1716 = OpBitcast %f32_id %628
       %1717 = OpFMul %f32_id %1716 %1690
       %1718 = OpFAdd %f32_id %1717 %1705
       %1719 = OpBitcast %f32_id %622
       %1720 = OpFMul %f32_id %1719 %1675
       %1721 = OpFAdd %f32_id %1720 %1692
       %1722 = OpBitcast %f32_id %636
       %1723 = OpFMul %f32_id %1722 %1715
       %1724 = OpFAdd %f32_id %1723 %1708
       %1725 = OpBitcast %f32_id %645
       %1726 = OpFMul %f32_id %1725 %1715
       %1727 = OpFAdd %f32_id %1726 %1711
       %1728 = OpBitcast %f32_id %639
       %1729 = OpFMul %f32_id %1728 %1715
       %1730 = OpFAdd %f32_id %1729 %1718
       %1731 = OpBitcast %f32_id %631
       %1732 = OpFMul %f32_id %1731 %1690
       %1733 = OpFAdd %f32_id %1732 %1721
       %1734 = OpFNegate %f32_id %1724
       %1735 = OpFOrdLessThan %bool_id %1727 %1734
       %1736 = OpFNegate %f32_id %1730
       %1737 = OpFOrdLessThan %bool_id %1727 %1736
       %1738 = OpBitcast %f32_id %642
       %1739 = OpFMul %f32_id %1738 %1715
       %1740 = OpFAdd %f32_id %1739 %1733
       %1741 = OpSelect %f32_id %1735 %f32_id_0x1pn149 %f32_id_0
       %1742 = OpBitcast %u32_id %1741
       %1743 = OpSelect %f32_id %1737 %f32_id_0x1pn148 %f32_id_0
       %1744 = OpBitcast %u32_id %1743
       %1745 = OpFOrdGreaterThan %bool_id %f32_id_0 %1740
       %1746 = OpBitwiseOr %u32_id %1742 %1744
       %1747 = OpSelect %f32_id %1745 %f32_id_0x1pn147 %f32_id_0
       %1748 = OpBitcast %u32_id %1747
       %1749 = OpFOrdLessThan %bool_id %1727 %1724
       %1750 = OpBitwiseOr %u32_id %1746 %1748
       %1751 = OpSelect %f32_id %1749 %f32_id_0x1pn146 %f32_id_0
       %1752 = OpBitcast %u32_id %1751
       %1753 = OpFOrdLessThan %bool_id %1727 %1730
       %1754 = OpBitwiseOr %u32_id %1750 %1752
       %1755 = OpSelect %f32_id %1753 %f32_id_0x1pn145 %f32_id_0
       %1756 = OpBitcast %u32_id %1755
       %1757 = OpFOrdLessThan %bool_id %1727 %1740
       %1758 = OpBitwiseOr %u32_id %1754 %1756
       %1759 = OpSelect %f32_id %1757 %f32_id_0x1pn144 %f32_id_0
       %1760 = OpBitcast %u32_id %1759
       %1761 = OpBitwiseOr %u32_id %1758 %1760
       %1762 = OpBitwiseAnd %u32_id %1622 %1761
       %1763 = OpIEqual %bool_id %u32_id_0 %1762
       %1764 = OpSelect %f32_id %1763 %f32_id_0 %f32_id_0x1pn149
       %1765 = OpBitcast %u32_id %1764
               OpBranch %108
        %108 = OpLabel
       %1766 = OpPhi %u32_id %1765 %107 %u32_id_0 %106
               OpBranch %109
        %109 = OpLabel
       %1767 = OpPhi %u32_id %1766 %108 %u32_id_0 %105
               OpBranch %110
        %110 = OpLabel
       %1768 = OpPhi %u32_id %1767 %109 %u32_id_0 %104
               OpBranch %111
        %111 = OpLabel
       %1769 = OpPhi %u32_id %1768 %110 %u32_id_0 %103
               OpBranch %112
        %112 = OpLabel
       %1770 = OpPhi %u32_id %1769 %111 %u32_id_0 %102
               OpBranch %113
        %113 = OpLabel
       %1771 = OpPhi %u32_id %1770 %112 %u32_id_0 %101
               OpBranch %114
        %114 = OpLabel
       %1772 = OpPhi %u32_id %1771 %113 %u32_id_0 %100
               OpBranch %115
        %115 = OpLabel
       %1773 = OpPhi %u32_id %619 %114 %523 %99
       %1774 = OpPhi %u32_id %617 %114 %524 %99
       %1775 = OpPhi %u32_id %1772 %114 %u32_id_0 %99
       %1776 = OpCompositeConstruct %u32vec2_id %ud_2 %ud_3
       %1778 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_89
       %1779 = OpLoad %u32_id %1778
       %1780 = OpINotEqual %bool_id %u32_id_0 %1775
       %1781 = OpIAdd %u32_id %1779 %190
       %1782 = OpLogicalAnd %bool_id %191 %1780
               OpSelectionMerge %117 None
               OpBranchConditional %1782 %116 %117
        %116 = OpLabel
       %1784 = OpIMul %u32_id %1781 %u32_id_2
       %1785 = OpIAdd %u32_id %1784 %buf5_dword_off
       %1786 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_6 %u32_id_0 %1785
       %1787 = OpCompositeExtract %u32_id %1783 0
               OpStore %1786 %1787
       %1788 = OpIAdd %u32_id %1785 %u32_id_1
       %1789 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_6 %u32_id_0 %1788
       %1790 = OpCompositeExtract %u32_id %1783 1
               OpStore %1789 %1790
               OpBranch %117
        %117 = OpLabel
       %1791 = OpLogicalNot %bool_id %1782
       %1792 = OpLogicalAnd %bool_id %191 %1791
               OpSelectionMerge %131 None
               OpBranchConditional %1792 %118 %131
        %118 = OpLabel
       %1793 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
       %1795 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_74
       %1796 = OpLoad %u32_id %1795
       %1797 = OpSGreaterThanEqual %bool_id %1796 %u32_id_0
       %1798 = OpINotEqual %bool_id %1796 %525
       %1799 = OpSelect %bool_id %1797 %1792 %false
       %1800 = OpLogicalAnd %bool_id %1799 %1798
       %1801 = OpLogicalAnd %bool_id %1792 %1800
               OpSelectionMerge %120 None
               OpBranchConditional %1801 %119 %120
        %119 = OpLabel
       %1802 = OpIMul %u32_id %1781 %u32_id_2
       %1803 = OpIAdd %u32_id %1802 %buf5_dword_off
       %1804 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_6 %u32_id_0 %1803
       %1805 = OpCompositeExtract %u32_id %1783 0
               OpStore %1804 %1805
       %1806 = OpIAdd %u32_id %1803 %u32_id_1
       %1807 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_6 %u32_id_0 %1806
       %1808 = OpCompositeExtract %u32_id %1783 1
               OpStore %1807 %1808
               OpBranch %120
        %120 = OpLabel
       %1809 = OpLogicalNot %bool_id %1801
       %1810 = OpLogicalAnd %bool_id %1792 %1809
               OpSelectionMerge %130 None
               OpBranchConditional %1810 %121 %130
        %121 = OpLabel
               OpBranch %122
        %122 = OpLabel
       %1811 = OpPhi %u32_id %u32_id_0 %121 %1836 %128
       %1812 = OpPhi %bool_id %1792 %121 %1835 %128
       %1813 = OpPhi %bool_id %1810 %121 %1839 %128
               OpLoopMerge %129 %128 None
               OpBranch %123
        %123 = OpLabel
       %1814 = OpGroupNonUniformBallot %u32vec4_id %u32_id_3 %1813
       %1815 = OpGroupNonUniformBallotFindLSB %u32_id %u32_id_3 %1814
       %1816 = OpGroupNonUniformBroadcast %u32_id %u32_id_3 %535 %1815
       %1817 = OpIEqual %bool_id %1816 %535
       %1818 = OpLogicalAnd %bool_id %1810 %1817
               OpSelectionMerge %127 None
               OpBranchConditional %1818 %124 %127
        %124 = OpLabel
       %1819 = OpLogicalAnd %bool_id %1818 %1812
               OpSelectionMerge %126 None
               OpBranchConditional %1819 %125 %126
        %125 = OpLabel
       %1820 = OpCompositeConstruct %u32vec2_id %1774 %1773
       %1821 = OpBitcast %u64_id %1820
       %1822 = OpBitcast %u32vec2_id %1821
       %1823 = OpCompositeExtract %u32_id %1822 0
       %1824 = OpCompositeExtract %u32_id %1822 1
       %1825 = OpBitCount %u32_id %1823
       %1826 = OpBitCount %u32_id %1824
       %1827 = OpIAdd %u32_id %1825 %1826
       %1828 = OpIMul %u32_id %1816 %u32_id_2
       %1829 = OpIAdd %u32_id %1828 %buf6_dword_off
       %1830 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_7 %u32_id_0 %1829
       %1831 = OpAtomicIAdd %u32_id %1830 %u32_id_1 %u32_id_0 %1827
               OpBranch %126
        %126 = OpLabel
       %1832 = OpPhi %u32_id %1831 %125 %1811 %124
       %1833 = OpGroupNonUniformBroadcast %u32_id %u32_id_3 %1832 %1815
       %1834 = OpULessThan %bool_id %1833 %1833
               OpBranch %127
        %127 = OpLabel
       %1835 = OpPhi %bool_id %1834 %126 %1812 %123
       %1836 = OpPhi %u32_id %1833 %126 %1811 %123
       %1837 = OpLogicalNot %bool_id %1817
       %1838 = OpLogicalAnd %bool_id %1813 %1837
       %1839 = OpLogicalAnd %bool_id %1838 %1838
               OpBranch %128
        %128 = OpLabel
               OpBranchConditional %1839 %122 %129
        %129 = OpLabel
       %1840 = OpCompositeConstruct %u32vec2_id %535 %1836
       %1841 = OpIMul %u32_id %1781 %u32_id_2
       %1842 = OpIAdd %u32_id %1841 %buf5_dword_off
       %1843 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_6 %u32_id_0 %1842
       %1844 = OpCompositeExtract %u32_id %1840 0
               OpStore %1843 %1844
       %1845 = OpIAdd %u32_id %1842 %u32_id_1
       %1846 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_6 %u32_id_0 %1845
       %1847 = OpCompositeExtract %u32_id %1840 1
               OpStore %1846 %1847
               OpBranch %130
        %130 = OpLabel
               OpBranch %131
        %131 = OpLabel
               OpBranch %132
        %132 = OpLabel
               OpBranch %133
        %133 = OpLabel
               OpReturn
               OpFunctionEnd
