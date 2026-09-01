; SPIR-V
; Version: 1.6
; Generator: Khronos; 0
; Bound: 918
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
               OpCapability StorageImageExtendedFormats
               OpCapability StorageImageReadWithoutFormat
               OpCapability StorageImageWriteWithoutFormat
               OpCapability SignedZeroInfNanPreserve
               OpExtension "SPV_KHR_float_controls"
        %140 = OpExtInstImport "GLSL.std.450"
               OpMemoryModel Logical GLSL450
               OpEntryPoint GLCompute %73 "main" %push_data %gl_WorkGroupID %gl_LocalInvocationID %ssbo_1 %ssbo_2 %srt_flatbuf %cs_img32 %cs_img24 %cs_img50 %cs_img50_0 %cs_sampinline_0xfff00000000036_0x2500000
               OpExecutionMode %73 LocalSize 8 8 1
               OpExecutionMode %73 SignedZeroInfNanPreserve 32
          %1 = OpString "0x2a0cfcd2"
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
               OpName %srt_flatbuf "srt_flatbuf"
               OpName %cs_img32 "cs_img32"
               OpName %cs_img24 "cs_img24"
               OpName %cs_img50 "cs_img50"
               OpName %cs_img50_0 "cs_img50"
               OpName %cs_sampinline_0xfff00000000036_0x2500000 "cs_sampinline:0xfff00000000036:0x2500000"
               OpName %buf0_off "buf0_off"
               OpName %buf0_dword_off "buf0_dword_off"
               OpName %buf1_off "buf1_off"
               OpName %buf1_dword_off "buf1_dword_off"
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
               OpDecorate %srt_flatbuf Binding 2
               OpDecorate %srt_flatbuf DescriptorSet 0
               OpDecorate %srt_flatbuf NonWritable
               OpDecorate %cs_img32 Binding 3
               OpDecorate %cs_img32 DescriptorSet 0
               OpDecorate %cs_img24 Binding 4
               OpDecorate %cs_img24 DescriptorSet 0
               OpDecorate %cs_img50 Binding 5
               OpDecorate %cs_img50 DescriptorSet 0
               OpDecorate %cs_img50_0 Binding 6
               OpDecorate %cs_img50_0 DescriptorSet 0
               OpDecorate %cs_sampinline_0xfff00000000036_0x2500000 Binding 13
               OpDecorate %cs_sampinline_0xfff00000000036_0x2500000 DescriptorSet 0
               OpDecorate %150 NoContraction
               OpDecorate %176 NoContraction
               OpDecorate %178 NoContraction
               OpDecorate %196 NoContraction
               OpDecorate %204 NoContraction
               OpDecorate %205 NoContraction
               OpDecorate %207 NoContraction
               OpDecorate %208 NoContraction
               OpDecorate %210 NoContraction
               OpDecorate %216 NoContraction
               OpDecorate %217 NoContraction
               OpDecorate %218 NoContraction
               OpDecorate %220 NoContraction
               OpDecorate %221 NoContraction
               OpDecorate %223 NoContraction
               OpDecorate %224 NoContraction
               OpDecorate %226 NoContraction
               OpDecorate %227 NoContraction
               OpDecorate %228 NoContraction
               OpDecorate %229 NoContraction
               OpDecorate %247 NoContraction
               OpDecorate %248 NoContraction
               OpDecorate %250 NoContraction
               OpDecorate %251 NoContraction
               OpDecorate %252 NoContraction
               OpDecorate %260 NoContraction
               OpDecorate %261 NoContraction
               OpDecorate %264 NoContraction
               OpDecorate %265 NoContraction
               OpDecorate %268 NoContraction
               OpDecorate %269 NoContraction
               OpDecorate %292 NoContraction
               OpDecorate %293 NoContraction
               OpDecorate %295 NoContraction
               OpDecorate %297 NoContraction
               OpDecorate %298 NoContraction
               OpDecorate %299 NoContraction
               OpDecorate %300 NoContraction
               OpDecorate %301 NoContraction
               OpDecorate %304 NoContraction
               OpDecorate %311 NoContraction
               OpDecorate %312 NoContraction
               OpDecorate %313 NoContraction
               OpDecorate %314 NoContraction
               OpDecorate %316 NoContraction
               OpDecorate %321 NoContraction
               OpDecorate %324 NoContraction
               OpDecorate %327 NoContraction
               OpDecorate %329 NoContraction
               OpDecorate %330 NoContraction
               OpDecorate %331 NoContraction
               OpDecorate %372 NoContraction
               OpDecorate %373 NoContraction
               OpDecorate %392 NoContraction
               OpDecorate %393 NoContraction
               OpDecorate %395 NoContraction
               OpDecorate %398 NoContraction
               OpDecorate %419 NoContraction
               OpDecorate %420 NoContraction
               OpDecorate %421 NoContraction
               OpDecorate %427 NoContraction
               OpDecorate %428 NoContraction
               OpDecorate %432 NoContraction
               OpDecorate %433 NoContraction
               OpDecorate %434 NoContraction
               OpDecorate %437 NoContraction
               OpDecorate %438 NoContraction
               OpDecorate %450 NoContraction
               OpDecorate %454 NoContraction
               OpDecorate %455 NoContraction
               OpDecorate %456 NoContraction
               OpDecorate %458 NoContraction
               OpDecorate %459 NoContraction
               OpDecorate %462 NoContraction
               OpDecorate %463 NoContraction
               OpDecorate %467 NoContraction
               OpDecorate %480 NoContraction
               OpDecorate %483 NoContraction
               OpDecorate %484 NoContraction
               OpDecorate %488 NoContraction
               OpDecorate %489 NoContraction
               OpDecorate %493 NoContraction
               OpDecorate %494 NoContraction
               OpDecorate %531 NoContraction
               OpDecorate %536 NoContraction
               OpDecorate %538 NoContraction
               OpDecorate %540 NoContraction
               OpDecorate %541 NoContraction
               OpDecorate %542 NoContraction
               OpDecorate %543 NoContraction
               OpDecorate %544 NoContraction
               OpDecorate %547 NoContraction
               OpDecorate %554 NoContraction
               OpDecorate %555 NoContraction
               OpDecorate %556 NoContraction
               OpDecorate %557 NoContraction
               OpDecorate %559 NoContraction
               OpDecorate %635 NoContraction
               OpDecorate %636 NoContraction
               OpDecorate %639 NoContraction
               OpDecorate %640 NoContraction
               OpDecorate %642 NoContraction
               OpDecorate %643 NoContraction
               OpDecorate %645 NoContraction
               OpDecorate %646 NoContraction
               OpDecorate %648 NoContraction
               OpDecorate %649 NoContraction
               OpDecorate %651 NoContraction
               OpDecorate %652 NoContraction
               OpDecorate %661 NoContraction
               OpDecorate %664 NoContraction
               OpDecorate %667 NoContraction
               OpDecorate %668 NoContraction
               OpDecorate %669 NoContraction
               OpDecorate %670 NoContraction
               OpDecorate %710 NoContraction
               OpDecorate %711 NoContraction
               OpDecorate %727 NoContraction
               OpDecorate %728 NoContraction
               OpDecorate %729 NoContraction
               OpDecorate %731 NoContraction
               OpDecorate %748 NoContraction
               OpDecorate %749 NoContraction
               OpDecorate %750 NoContraction
               OpDecorate %754 NoContraction
               OpDecorate %755 NoContraction
               OpDecorate %759 NoContraction
               OpDecorate %760 NoContraction
               OpDecorate %761 NoContraction
               OpDecorate %764 NoContraction
               OpDecorate %765 NoContraction
               OpDecorate %769 NoContraction
               OpDecorate %770 NoContraction
               OpDecorate %775 NoContraction
               OpDecorate %776 NoContraction
               OpDecorate %778 NoContraction
               OpDecorate %779 NoContraction
               OpDecorate %781 NoContraction
               OpDecorate %783 NoContraction
               OpDecorate %784 NoContraction
               OpDecorate %791 NoContraction
               OpDecorate %794 NoContraction
               OpDecorate %795 NoContraction
               OpDecorate %803 NoContraction
               OpDecorate %804 NoContraction
               OpDecorate %806 NoContraction
               OpDecorate %807 NoContraction
               OpDecorate %808 NoContraction
               OpDecorate %809 NoContraction
               OpDecorate %810 NoContraction
               OpDecorate %811 NoContraction
               OpDecorate %821 NoContraction
               OpDecorate %836 NoContraction
               OpDecorate %839 NoContraction
               OpDecorate %840 NoContraction
               OpDecorate %841 NoContraction
               OpDecorate %842 NoContraction
               OpDecorate %844 NoContraction
               OpDecorate %846 NoContraction
               OpDecorate %848 NoContraction
               OpDecorate %850 NoContraction
               OpDecorate %852 NoContraction
               OpDecorate %853 NoContraction
               OpDecorate %856 NoContraction
               OpDecorate %857 NoContraction
               OpDecorate %860 NoContraction
               OpDecorate %861 NoContraction
               OpDecorate %901 NoContraction
               OpDecorate %902 NoContraction
               OpDecorate %905 NoContraction
               OpDecorate %906 NoContraction
               OpDecorate %909 NoContraction
               OpDecorate %910 NoContraction
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
         %58 = OpTypeImage %f32_id 2D 0 1 0 1 Unknown
%_ptr_UniformConstant_58 = OpTypePointer UniformConstant %58
         %61 = OpTypeSampledImage %58
         %64 = OpTypeImage %f32_id 2D 0 1 0 2 Unknown
   %u32_id_7 = OpConstant %u32_id 7
%_arr_64_u32_id_7 = OpTypeArray %64 %u32_id_7
%_ptr_UniformConstant__arr_64_u32_id_7 = OpTypePointer UniformConstant %_arr_64_u32_id_7
         %69 = OpTypeSampler
%_ptr_UniformConstant_69 = OpTypePointer UniformConstant %69
         %72 = OpTypeFunction %void_id
   %u32_id_8 = OpConstant %u32_id 8
%_ptr_PushConstant_u32_id = OpTypePointer PushConstant %u32_id
   %u32_id_2 = OpConstant %u32_id 2
   %u32_id_4 = OpConstant %u32_id 4
   %u32_id_3 = OpConstant %u32_id 3
  %u32_id_13 = OpConstant %u32_id 13
  %u32_id_63 = OpConstant %u32_id 63
  %u32_id_11 = OpConstant %u32_id 11
  %u32_id_61 = OpConstant %u32_id 61
 %f32_id_0_5 = OpConstant %f32_id 0.5
  %u32_id_12 = OpConstant %u32_id 12
 %u32_id_160 = OpConstant %u32_id 160
 %u32_id_232 = OpConstant %u32_id 232
 %u32_id_304 = OpConstant %u32_id 304
 %u32_id_168 = OpConstant %u32_id 168
 %u32_id_240 = OpConstant %u32_id 240
   %f32_id_1 = OpConstant %f32_id 1
 %u32_id_312 = OpConstant %u32_id 312
  %u32_id_94 = OpConstant %u32_id 94
  %u32_id_40 = OpConstant %u32_id 40
  %u32_id_95 = OpConstant %u32_id 95
  %u32_id_41 = OpConstant %u32_id 41
  %u32_id_96 = OpConstant %u32_id 96
  %u32_id_42 = OpConstant %u32_id 42
  %u32_id_97 = OpConstant %u32_id 97
  %u32_id_43 = OpConstant %u32_id 43
  %u32_id_98 = OpConstant %u32_id 98
  %u32_id_44 = OpConstant %u32_id 44
   %u32_id_6 = OpConstant %u32_id 6
   %f32_id_2 = OpConstant %f32_id 2
 %f32_id_1_5 = OpConstant %f32_id 1.5
   %f32_id_3 = OpConstant %f32_id 3
   %f32_id_4 = OpConstant %f32_id 4
   %f32_id_5 = OpConstant %f32_id 5
   %f32_id_8 = OpConstant %f32_id 8
  %f32_id_n2 = OpConstant %f32_id -2
 %u32_id_100 = OpConstant %u32_id 100
  %u32_id_46 = OpConstant %u32_id 46
 %u32_id_101 = OpConstant %u32_id 101
  %u32_id_47 = OpConstant %u32_id 47
 %u32_id_102 = OpConstant %u32_id 102
  %u32_id_48 = OpConstant %u32_id 48
  %u32_id_58 = OpConstant %u32_id 58
   %u32_id_9 = OpConstant %u32_id 9
  %u32_id_59 = OpConstant %u32_id 59
  %u32_id_56 = OpConstant %u32_id 56
  %u32_id_99 = OpConstant %u32_id 99
  %u32_id_45 = OpConstant %u32_id 45
  %u32_id_64 = OpConstant %u32_id 64
   %u32_id_5 = OpConstant %u32_id 5
  %u32_id_10 = OpConstant %u32_id 10
  %u32_id_14 = OpConstant %u32_id 14
  %u32_id_15 = OpConstant %u32_id 15
  %u32_id_60 = OpConstant %u32_id 60
  %u32_id_62 = OpConstant %u32_id 62
 %u32_id_103 = OpConstant %u32_id 103
  %u32_id_49 = OpConstant %u32_id 49
        %913 = OpConstantComposite %f32vec4_id %f32_id_0 %f32_id_1 %f32_id_0 %f32_id_0
%_ptr_UniformConstant_64 = OpTypePointer UniformConstant %64
  %push_data = OpVariable %_ptr_PushConstant_AuxData PushConstant
%gl_WorkGroupID = OpVariable %_ptr_Input_u32vec3_id Input
%gl_LocalInvocationID = OpVariable %_ptr_Input_u32vec3_id Input
     %ssbo_1 = OpVariable %_ptr_StorageBuffer__struct_52 StorageBuffer
     %ssbo_2 = OpVariable %_ptr_StorageBuffer__struct_52 StorageBuffer
%srt_flatbuf = OpVariable %_ptr_StorageBuffer__struct_52 StorageBuffer
   %cs_img32 = OpVariable %_ptr_UniformConstant_58 UniformConstant
   %cs_img24 = OpVariable %_ptr_UniformConstant_58 UniformConstant
   %cs_img50 = OpVariable %_ptr_UniformConstant_58 UniformConstant
 %cs_img50_0 = OpVariable %_ptr_UniformConstant__arr_64_u32_id_7 UniformConstant
%cs_sampinline_0xfff00000000036_0x2500000 = OpVariable %_ptr_UniformConstant_69 UniformConstant
         %73 = OpFunction %void_id None %72
         %74 = OpLabel
        %104 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
        %105 = OpLoad %u32_id %104
   %buf0_off = OpBitFieldUExtract %u32_id %105 %u32_id_0 %u32_id_8
%buf0_dword_off = OpShiftRightLogical %u32_id %buf0_off %u32_id_2
        %109 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
        %110 = OpLoad %u32_id %109
   %buf1_off = OpBitFieldUExtract %u32_id %110 %u32_id_8 %u32_id_8
%buf1_dword_off = OpShiftRightLogical %u32_id %buf1_off %u32_id_2
        %114 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_0
       %ud_0 = OpLoad %u32_id %114
        %116 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_1
       %ud_1 = OpLoad %u32_id %116
        %118 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_2
       %ud_2 = OpLoad %u32_id %118
        %121 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_3
       %ud_3 = OpLoad %u32_id %121
        %123 = OpLoad %u32vec3_id %gl_LocalInvocationID
        %124 = OpCompositeExtract %u32_id %123 0
        %125 = OpLoad %u32vec3_id %gl_LocalInvocationID
        %126 = OpCompositeExtract %u32_id %125 1
        %127 = OpLoad %u32vec3_id %gl_WorkGroupID
        %128 = OpCompositeExtract %u32_id %127 0
        %129 = OpLoad %u32vec3_id %gl_WorkGroupID
        %130 = OpCompositeExtract %u32_id %129 1
        %131 = OpShiftLeftLogical %u32_id %128 %u32_id_3
        %132 = OpShiftLeftLogical %u32_id %130 %u32_id_3
        %133 = OpIAdd %u32_id %131 %124
        %134 = OpIAdd %u32_id %132 %126
        %135 = OpCompositeConstruct %u32vec2_id %ud_2 %ud_3
        %138 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_63
        %139 = OpLoad %u32_id %138
        %141 = OpExtInst %u32_id %140 UMax %133 %134
        %142 = OpUGreaterThan %bool_id %139 %141
               OpSelectionMerge %100 None
               OpBranchConditional %142 %75 %100
         %75 = OpLabel
        %143 = OpConvertUToF %f32_id %133
        %144 = OpCompositeConstruct %u32vec2_id %ud_2 %ud_3
        %147 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_61
        %148 = OpLoad %u32_id %147
        %150 = OpFAdd %f32_id %f32_id_0_5 %143
        %152 = OpIMul %u32_id %148 %u32_id_12
        %154 = OpIAdd %u32_id %152 %u32_id_160
        %155 = OpShiftRightLogical %u32_id %154 %u32_id_2
        %156 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %157 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %158 = OpLoad %u32_id %157
        %159 = OpIAdd %u32_id %155 %u32_id_1
        %160 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %161 = OpLoad %u32_id %160
        %163 = OpIAdd %u32_id %152 %u32_id_232
        %164 = OpConvertUToF %f32_id %134
        %165 = OpShiftRightLogical %u32_id %163 %u32_id_2
        %166 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %167 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %168 = OpLoad %u32_id %167
        %169 = OpIAdd %u32_id %165 %u32_id_1
        %170 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %171 = OpLoad %u32_id %170
        %173 = OpIAdd %u32_id %152 %u32_id_304
        %175 = OpIAdd %u32_id %152 %u32_id_168
        %176 = OpFAdd %f32_id %f32_id_0_5 %164
        %177 = OpBitcast %f32_id %158
        %178 = OpFMul %f32_id %177 %150
        %179 = OpConvertUToF %f32_id %139
        %180 = OpShiftRightLogical %u32_id %173 %u32_id_2
        %181 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %182 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %183 = OpLoad %u32_id %182
        %184 = OpIAdd %u32_id %180 %u32_id_1
        %185 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %186 = OpLoad %u32_id %185
        %187 = OpShiftRightLogical %u32_id %175 %u32_id_2
        %188 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %189 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %190 = OpLoad %u32_id %189
        %192 = OpIAdd %u32_id %152 %u32_id_240
        %194 = OpFDiv %f32_id %f32_id_1 %179
        %195 = OpBitcast %f32_id %161
        %196 = OpFMul %f32_id %195 %150
        %197 = OpShiftRightLogical %u32_id %192 %u32_id_2
        %198 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %199 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %200 = OpLoad %u32_id %199
        %202 = OpIAdd %u32_id %152 %u32_id_312
        %203 = OpBitcast %f32_id %168
        %204 = OpFMul %f32_id %203 %176
        %205 = OpFAdd %f32_id %204 %178
        %206 = OpBitcast %f32_id %183
        %207 = OpFMul %f32_id %194 %205
        %208 = OpFAdd %f32_id %207 %206
        %209 = OpBitcast %f32_id %190
        %210 = OpFMul %f32_id %209 %150
        %211 = OpShiftRightLogical %u32_id %202 %u32_id_2
        %212 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %213 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %214 = OpLoad %u32_id %213
        %215 = OpBitcast %f32_id %171
        %216 = OpFMul %f32_id %215 %176
        %217 = OpFAdd %f32_id %216 %196
        %218 = OpFMul %f32_id %208 %208
        %219 = OpBitcast %f32_id %186
        %220 = OpFMul %f32_id %194 %217
        %221 = OpFAdd %f32_id %220 %219
        %222 = OpBitcast %f32_id %200
        %223 = OpFMul %f32_id %222 %176
        %224 = OpFAdd %f32_id %223 %210
        %225 = OpBitcast %f32_id %214
        %226 = OpFMul %f32_id %194 %224
        %227 = OpFAdd %f32_id %226 %225
        %228 = OpFMul %f32_id %221 %221
        %229 = OpFAdd %f32_id %228 %218
        %230 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %233 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_40
        %234 = OpLoad %u32_id %233
        %237 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_41
        %238 = OpLoad %u32_id %237
        %241 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_42
        %242 = OpLoad %u32_id %241
        %245 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_43
        %246 = OpLoad %u32_id %245
        %247 = OpFMul %f32_id %227 %227
        %248 = OpFAdd %f32_id %247 %229
        %249 = OpExtInst %f32_id %140 InverseSqrt %248
        %250 = OpFMul %f32_id %249 %208
        %251 = OpFMul %f32_id %249 %221
        %252 = OpFMul %f32_id %249 %227
        %253 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %256 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_44
        %257 = OpLoad %u32_id %256
        %258 = OpBitcast %f32_id %246
        %259 = OpBitcast %f32_id %234
        %260 = OpFMul %f32_id %258 %250
        %261 = OpFAdd %f32_id %260 %259
        %262 = OpBitcast %f32_id %246
        %263 = OpBitcast %f32_id %238
        %264 = OpFMul %f32_id %262 %251
        %265 = OpFAdd %f32_id %264 %263
        %266 = OpBitcast %f32_id %246
        %267 = OpBitcast %f32_id %242
        %268 = OpFMul %f32_id %266 %252
        %269 = OpFAdd %f32_id %268 %267
               OpBranch %76
         %76 = OpLabel
        %270 = OpPhi %u32_id %u32_id_0 %75 %502 %85
        %271 = OpPhi %u32_id %u32_id_0 %75 %503 %85
        %272 = OpPhi %u32_id %u32_id_0 %75 %504 %85
        %273 = OpPhi %u32_id %u32_id_0 %75 %505 %85
               OpLoopMerge %86 %85 None
               OpBranch %77
         %77 = OpLabel
        %274 = OpSLessThan %bool_id %273 %257
        %275 = OpLogicalNot %bool_id %274
               OpBranchConditional %275 %86 %78
         %78 = OpLabel
        %277 = OpShiftLeftLogical %u32_id %273 %u32_id_6
        %278 = OpIAdd %u32_id %277 %u32_id_8
        %279 = OpShiftRightLogical %u32_id %277 %u32_id_2
        %280 = OpIAdd %u32_id %279 %buf0_dword_off
        %281 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %280
        %282 = OpLoad %u32_id %281
        %283 = OpIAdd %u32_id %279 %u32_id_1
        %284 = OpIAdd %u32_id %283 %buf0_dword_off
        %285 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %284
        %286 = OpLoad %u32_id %285
        %287 = OpShiftRightLogical %u32_id %278 %u32_id_2
        %288 = OpIAdd %u32_id %287 %buf0_dword_off
        %289 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %288
        %290 = OpLoad %u32_id %289
        %291 = OpBitcast %f32_id %282
        %292 = OpFSub %f32_id %291 %261
        %293 = OpFMul %f32_id %250 %292
        %294 = OpBitcast %f32_id %286
        %295 = OpFSub %f32_id %294 %265
        %296 = OpBitcast %f32_id %290
        %297 = OpFSub %f32_id %296 %269
        %298 = OpFMul %f32_id %295 %251
        %299 = OpFAdd %f32_id %298 %293
        %300 = OpFMul %f32_id %297 %252
        %301 = OpFAdd %f32_id %300 %299
        %302 = OpFOrdGreaterThan %bool_id %301 %f32_id_0
        %303 = OpLogicalAnd %bool_id %142 %302
               OpSelectionMerge %84 None
               OpBranchConditional %303 %79 %84
         %79 = OpLabel
        %304 = OpFMul %f32_id %292 %292
        %305 = OpShiftLeftLogical %u32_id %273 %u32_id_6
        %306 = OpIAdd %u32_id %305 %u32_id_12
        %307 = OpShiftRightLogical %u32_id %306 %u32_id_2
        %308 = OpIAdd %u32_id %307 %buf0_dword_off
        %309 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %308
        %310 = OpLoad %u32_id %309
        %311 = OpFMul %f32_id %295 %295
        %312 = OpFAdd %f32_id %311 %304
        %313 = OpFMul %f32_id %297 %297
        %314 = OpFAdd %f32_id %313 %312
        %315 = OpBitcast %f32_id %310
        %316 = OpFMul %f32_id %315 %314
        %317 = OpFOrdLessThanEqual %bool_id %316 %f32_id_1
        %318 = OpLogicalAnd %bool_id %303 %317
               OpSelectionMerge %83 None
               OpBranchConditional %318 %80 %83
         %80 = OpLabel
        %319 = OpBitcast %f32_id %282
        %320 = OpBitcast %f32_id %234
        %321 = OpFSub %f32_id %319 %320
        %322 = OpBitcast %f32_id %286
        %323 = OpBitcast %f32_id %238
        %324 = OpFSub %f32_id %322 %323
        %325 = OpBitcast %f32_id %290
        %326 = OpBitcast %f32_id %242
        %327 = OpFSub %f32_id %325 %326
        %329 = OpFMul %f32_id %321 %f32_id_2
        %330 = OpFMul %f32_id %324 %f32_id_2
        %331 = OpFMul %f32_id %327 %f32_id_2
        %332 = OpExtInst %f32_id %140 FAbs %321
        %333 = OpExtInst %f32_id %140 FAbs %324
        %334 = OpExtInst %f32_id %140 FAbs %327
        %335 = OpFOrdGreaterThanEqual %bool_id %334 %333
        %336 = OpFOrdGreaterThanEqual %bool_id %334 %332
        %337 = OpLogicalAnd %bool_id %336 %335
        %338 = OpFOrdGreaterThanEqual %bool_id %333 %332
        %339 = OpSelect %f32_id %338 %330 %329
        %340 = OpSelect %f32_id %337 %331 %339
        %341 = OpExtInst %f32_id %140 FAbs %340
        %342 = OpFDiv %f32_id %f32_id_1 %341
        %343 = OpFOrdLessThan %bool_id %321 %f32_id_0
        %344 = OpFOrdLessThan %bool_id %327 %f32_id_0
        %345 = OpFNegate %f32_id %327
        %346 = OpSelect %f32_id %343 %327 %345
        %347 = OpFNegate %f32_id %321
        %348 = OpSelect %f32_id %344 %347 %321
        %349 = OpExtInst %f32_id %140 FAbs %321
        %350 = OpExtInst %f32_id %140 FAbs %324
        %351 = OpExtInst %f32_id %140 FAbs %327
        %352 = OpFOrdGreaterThanEqual %bool_id %351 %350
        %353 = OpFOrdGreaterThanEqual %bool_id %351 %349
        %354 = OpLogicalAnd %bool_id %353 %352
        %355 = OpFOrdGreaterThanEqual %bool_id %350 %349
        %356 = OpSelect %f32_id %355 %321 %346
        %357 = OpSelect %f32_id %354 %348 %356
        %358 = OpFOrdLessThan %bool_id %324 %f32_id_0
        %359 = OpFNegate %f32_id %324
        %360 = OpFNegate %f32_id %327
        %361 = OpSelect %f32_id %358 %360 %327
        %362 = OpExtInst %f32_id %140 FAbs %321
        %363 = OpExtInst %f32_id %140 FAbs %324
        %364 = OpExtInst %f32_id %140 FAbs %327
        %365 = OpFOrdGreaterThanEqual %bool_id %364 %363
        %366 = OpFOrdGreaterThanEqual %bool_id %364 %362
        %367 = OpLogicalAnd %bool_id %366 %365
        %368 = OpFOrdGreaterThanEqual %bool_id %363 %362
        %369 = OpSelect %f32_id %368 %361 %359
        %370 = OpSelect %f32_id %367 %359 %369
        %372 = OpExtInst %f32_id %140 Fma %357 %342 %f32_id_1_5
        %373 = OpExtInst %f32_id %140 Fma %370 %342 %f32_id_1_5
        %374 = OpFOrdLessThan %bool_id %321 %f32_id_0
        %375 = OpFOrdLessThan %bool_id %324 %f32_id_0
        %376 = OpFOrdLessThan %bool_id %327 %f32_id_0
        %377 = OpSelect %f32_id %374 %f32_id_1 %f32_id_0
        %379 = OpSelect %f32_id %375 %f32_id_3 %f32_id_2
        %382 = OpSelect %f32_id %376 %f32_id_5 %f32_id_4
        %383 = OpExtInst %f32_id %140 FAbs %321
        %384 = OpExtInst %f32_id %140 FAbs %324
        %385 = OpExtInst %f32_id %140 FAbs %327
        %386 = OpFOrdGreaterThanEqual %bool_id %385 %384
        %387 = OpFOrdGreaterThanEqual %bool_id %385 %383
        %388 = OpLogicalAnd %bool_id %387 %386
        %389 = OpFOrdGreaterThanEqual %bool_id %384 %383
        %390 = OpSelect %f32_id %389 %379 %377
        %391 = OpSelect %f32_id %388 %382 %390
        %392 = OpFSub %f32_id %372 %f32_id_1
        %393 = OpFSub %f32_id %373 %f32_id_1
        %395 = OpFDiv %f32_id %391 %f32_id_8
        %396 = OpExtInst %f32_id %140 Floor %395
        %398 = OpExtInst %f32_id %140 Fma %396 %f32_id_n2 %391
        %399 = OpCompositeConstruct %f32vec3_id %392 %393 %398
        %400 = OpLoad %58 %cs_img32
        %401 = OpLoad %69 %cs_sampinline_0xfff00000000036_0x2500000
        %402 = OpSampledImage %61 %400 %401
        %403 = OpImageSampleExplicitLod %f32vec4_id %402 %399 Lod %f32_id_0
        %404 = OpCompositeExtract %f32_id %403 0
        %405 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %408 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_46
        %409 = OpLoad %u32_id %408
        %412 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_47
        %413 = OpLoad %u32_id %412
        %414 = OpExtInst %f32_id %140 FAbs %327
        %415 = OpExtInst %f32_id %140 FAbs %321
        %416 = OpExtInst %f32_id %140 FAbs %324
        %417 = OpExtInst %f32_id %140 FMax %415 %416
        %418 = OpExtInst %f32_id %140 FMax %414 %417
        %419 = OpFMul %f32_id %321 %321
        %420 = OpFMul %f32_id %324 %324
        %421 = OpFAdd %f32_id %420 %419
        %422 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %425 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_48
        %426 = OpLoad %u32_id %425
        %427 = OpFMul %f32_id %327 %327
        %428 = OpFAdd %f32_id %427 %421
        %429 = OpExtInst %f32_id %140 Sqrt %428
        %430 = OpBitcast %f32_id %409
        %431 = OpBitcast %f32_id %413
        %432 = OpFMul %f32_id %430 %404
        %433 = OpFAdd %f32_id %432 %431
        %434 = OpFMul %f32_id %433 %418
        %435 = OpFDiv %f32_id %f32_id_1 %434
        %436 = OpBitcast %f32_id %426
        %437 = OpFMul %f32_id %435 %429
        %438 = OpFAdd %f32_id %437 %436
        %439 = OpFOrdGreaterThanEqual %bool_id %429 %438
        %440 = OpLogicalNot %bool_id %439
               OpSelectionMerge %82 None
               OpBranchConditional %440 %81 %82
         %81 = OpLabel
        %441 = OpExtInst %f32_id %140 InverseSqrt %314
        %442 = OpCompositeConstruct %u32vec2_id %ud_2 %ud_3
        %444 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_58
        %445 = OpLoad %u32_id %444
        %448 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_59
        %449 = OpLoad %u32_id %448
        %450 = OpFMul %f32_id %441 %301
        %451 = OpShiftLeftLogical %u32_id %273 %u32_id_6
        %452 = OpBitcast %f32_id %445
        %453 = OpBitcast %f32_id %449
        %454 = OpFMul %f32_id %452 %450
        %455 = OpFAdd %f32_id %454 %453
        %456 = OpFMul %f32_id %455 %455
        %457 = OpFNegate %f32_id %316
        %458 = OpFMul %f32_id %316 %457
        %459 = OpFAdd %f32_id %458 %f32_id_1
        %460 = OpExtInst %f32_id %140 FClamp %459 %f32_id_0 %f32_id_1
        %461 = OpIAdd %u32_id %451 %u32_id_48
        %462 = OpFMul %f32_id %456 %314
        %463 = OpFMul %f32_id %460 %460
        %465 = OpIAdd %u32_id %451 %u32_id_56
        %466 = OpFDiv %f32_id %f32_id_1 %462
        %467 = OpFMul %f32_id %463 %450
        %468 = OpShiftRightLogical %u32_id %461 %u32_id_2
        %469 = OpIAdd %u32_id %468 %buf0_dword_off
        %470 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %469
        %471 = OpLoad %u32_id %470
        %472 = OpIAdd %u32_id %468 %u32_id_1
        %473 = OpIAdd %u32_id %472 %buf0_dword_off
        %474 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %473
        %475 = OpLoad %u32_id %474
        %476 = OpShiftRightLogical %u32_id %465 %u32_id_2
        %477 = OpIAdd %u32_id %476 %buf0_dword_off
        %478 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %477
        %479 = OpLoad %u32_id %478
        %480 = OpFMul %f32_id %467 %466
        %481 = OpBitcast %f32_id %471
        %482 = OpBitcast %f32_id %270
        %483 = OpFMul %f32_id %481 %480
        %484 = OpFAdd %f32_id %483 %482
        %485 = OpBitcast %u32_id %484
        %486 = OpBitcast %f32_id %475
        %487 = OpBitcast %f32_id %272
        %488 = OpFMul %f32_id %486 %480
        %489 = OpFAdd %f32_id %488 %487
        %490 = OpBitcast %u32_id %489
        %491 = OpBitcast %f32_id %479
        %492 = OpBitcast %f32_id %271
        %493 = OpFMul %f32_id %491 %480
        %494 = OpFAdd %f32_id %493 %492
        %495 = OpBitcast %u32_id %494
               OpBranch %82
         %82 = OpLabel
        %496 = OpPhi %u32_id %485 %81 %270 %80
        %497 = OpPhi %u32_id %495 %81 %271 %80
        %498 = OpPhi %u32_id %490 %81 %272 %80
               OpBranch %83
         %83 = OpLabel
        %499 = OpPhi %u32_id %496 %82 %270 %79
        %500 = OpPhi %u32_id %497 %82 %271 %79
        %501 = OpPhi %u32_id %498 %82 %272 %79
               OpBranch %84
         %84 = OpLabel
        %502 = OpPhi %u32_id %499 %83 %270 %78
        %503 = OpPhi %u32_id %500 %83 %271 %78
        %504 = OpPhi %u32_id %501 %83 %272 %78
        %505 = OpIAdd %u32_id %273 %u32_id_1
               OpBranch %85
         %85 = OpLabel
               OpBranchConditional %true %76 %86
         %86 = OpLabel
        %506 = OpPhi %u32_id %270 %77 %502 %85
        %507 = OpPhi %u32_id %271 %77 %503 %85
        %508 = OpPhi %u32_id %272 %77 %504 %85
        %509 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %512 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_45
        %513 = OpLoad %u32_id %512
               OpBranch %87
         %87 = OpLabel
        %514 = OpPhi %u32_id %506 %86 %872 %98
        %515 = OpPhi %u32_id %507 %86 %873 %98
        %516 = OpPhi %u32_id %508 %86 %874 %98
        %517 = OpPhi %u32_id %u32_id_0 %86 %875 %98
               OpLoopMerge %99 %98 None
               OpBranch %88
         %88 = OpLabel
        %518 = OpSLessThan %bool_id %517 %513
        %519 = OpLogicalNot %bool_id %518
               OpBranchConditional %519 %99 %89
         %89 = OpLabel
        %520 = OpShiftLeftLogical %u32_id %517 %u32_id_7
        %521 = OpShiftRightLogical %u32_id %520 %u32_id_2
        %522 = OpIAdd %u32_id %521 %buf1_dword_off
        %523 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %522
        %524 = OpLoad %u32_id %523
        %525 = OpIAdd %u32_id %521 %u32_id_1
        %526 = OpIAdd %u32_id %525 %buf1_dword_off
        %527 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %526
        %528 = OpLoad %u32_id %527
        %529 = OpIAdd %u32_id %520 %u32_id_8
        %530 = OpBitcast %f32_id %524
        %531 = OpFSub %f32_id %530 %261
        %532 = OpShiftRightLogical %u32_id %529 %u32_id_2
        %533 = OpIAdd %u32_id %532 %buf1_dword_off
        %534 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %533
        %535 = OpLoad %u32_id %534
        %536 = OpFMul %f32_id %250 %531
        %537 = OpBitcast %f32_id %528
        %538 = OpFSub %f32_id %537 %265
        %539 = OpBitcast %f32_id %535
        %540 = OpFSub %f32_id %539 %269
        %541 = OpFMul %f32_id %538 %251
        %542 = OpFAdd %f32_id %541 %536
        %543 = OpFMul %f32_id %540 %252
        %544 = OpFAdd %f32_id %543 %542
        %545 = OpFOrdGreaterThan %bool_id %544 %f32_id_0
        %546 = OpLogicalAnd %bool_id %142 %545
               OpSelectionMerge %97 None
               OpBranchConditional %546 %90 %97
         %90 = OpLabel
        %547 = OpFMul %f32_id %531 %531
        %548 = OpShiftLeftLogical %u32_id %517 %u32_id_7
        %549 = OpIAdd %u32_id %548 %u32_id_12
        %550 = OpShiftRightLogical %u32_id %549 %u32_id_2
        %551 = OpIAdd %u32_id %550 %buf1_dword_off
        %552 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %551
        %553 = OpLoad %u32_id %552
        %554 = OpFMul %f32_id %538 %538
        %555 = OpFAdd %f32_id %554 %547
        %556 = OpFMul %f32_id %540 %540
        %557 = OpFAdd %f32_id %556 %555
        %558 = OpBitcast %f32_id %553
        %559 = OpFMul %f32_id %558 %557
        %560 = OpFOrdLessThanEqual %bool_id %559 %f32_id_1
        %561 = OpLogicalAnd %bool_id %546 %560
               OpSelectionMerge %96 None
               OpBranchConditional %561 %91 %96
         %91 = OpLabel
        %562 = OpShiftLeftLogical %u32_id %517 %u32_id_7
        %564 = OpIAdd %u32_id %562 %u32_id_64
        %565 = OpShiftRightLogical %u32_id %564 %u32_id_2
        %566 = OpIAdd %u32_id %565 %buf1_dword_off
        %567 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %566
        %568 = OpLoad %u32_id %567
        %569 = OpIAdd %u32_id %565 %u32_id_1
        %570 = OpIAdd %u32_id %569 %buf1_dword_off
        %571 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %570
        %572 = OpLoad %u32_id %571
        %573 = OpIAdd %u32_id %565 %u32_id_2
        %574 = OpIAdd %u32_id %573 %buf1_dword_off
        %575 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %574
        %576 = OpLoad %u32_id %575
        %577 = OpIAdd %u32_id %565 %u32_id_3
        %578 = OpIAdd %u32_id %577 %buf1_dword_off
        %579 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %578
        %580 = OpLoad %u32_id %579
        %581 = OpIAdd %u32_id %565 %u32_id_4
        %582 = OpIAdd %u32_id %581 %buf1_dword_off
        %583 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %582
        %584 = OpLoad %u32_id %583
        %586 = OpIAdd %u32_id %565 %u32_id_5
        %587 = OpIAdd %u32_id %586 %buf1_dword_off
        %588 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %587
        %589 = OpLoad %u32_id %588
        %590 = OpIAdd %u32_id %565 %u32_id_6
        %591 = OpIAdd %u32_id %590 %buf1_dword_off
        %592 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %591
        %593 = OpLoad %u32_id %592
        %594 = OpIAdd %u32_id %565 %u32_id_7
        %595 = OpIAdd %u32_id %594 %buf1_dword_off
        %596 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %595
        %597 = OpLoad %u32_id %596
        %598 = OpIAdd %u32_id %565 %u32_id_8
        %599 = OpIAdd %u32_id %598 %buf1_dword_off
        %600 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %599
        %601 = OpLoad %u32_id %600
        %602 = OpIAdd %u32_id %565 %u32_id_9
        %603 = OpIAdd %u32_id %602 %buf1_dword_off
        %604 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %603
        %605 = OpLoad %u32_id %604
        %607 = OpIAdd %u32_id %565 %u32_id_10
        %608 = OpIAdd %u32_id %607 %buf1_dword_off
        %609 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %608
        %610 = OpLoad %u32_id %609
        %611 = OpIAdd %u32_id %565 %u32_id_11
        %612 = OpIAdd %u32_id %611 %buf1_dword_off
        %613 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %612
        %614 = OpLoad %u32_id %613
        %615 = OpIAdd %u32_id %565 %u32_id_12
        %616 = OpIAdd %u32_id %615 %buf1_dword_off
        %617 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %616
        %618 = OpLoad %u32_id %617
        %619 = OpIAdd %u32_id %565 %u32_id_13
        %620 = OpIAdd %u32_id %619 %buf1_dword_off
        %621 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %620
        %622 = OpLoad %u32_id %621
        %624 = OpIAdd %u32_id %565 %u32_id_14
        %625 = OpIAdd %u32_id %624 %buf1_dword_off
        %626 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %625
        %627 = OpLoad %u32_id %626
        %629 = OpIAdd %u32_id %565 %u32_id_15
        %630 = OpIAdd %u32_id %629 %buf1_dword_off
        %631 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %630
        %632 = OpLoad %u32_id %631
        %633 = OpBitcast %f32_id %580
        %634 = OpBitcast %f32_id %632
        %635 = OpFMul %f32_id %633 %261
        %636 = OpFAdd %f32_id %635 %634
        %637 = OpBitcast %f32_id %576
        %638 = OpBitcast %f32_id %627
        %639 = OpFMul %f32_id %637 %261
        %640 = OpFAdd %f32_id %639 %638
        %641 = OpBitcast %f32_id %597
        %642 = OpFMul %f32_id %641 %265
        %643 = OpFAdd %f32_id %642 %636
        %644 = OpBitcast %f32_id %593
        %645 = OpFMul %f32_id %644 %265
        %646 = OpFAdd %f32_id %645 %640
        %647 = OpBitcast %f32_id %614
        %648 = OpFMul %f32_id %647 %269
        %649 = OpFAdd %f32_id %648 %643
        %650 = OpBitcast %f32_id %610
        %651 = OpFMul %f32_id %650 %269
        %652 = OpFAdd %f32_id %651 %646
        %653 = OpFNegate %f32_id %649
        %654 = OpFOrdLessThan %bool_id %652 %653
        %655 = OpFOrdGreaterThan %bool_id %f32_id_0 %649
        %656 = OpLogicalOr %bool_id %655 %654
        %657 = OpLogicalNot %bool_id %656
        %658 = OpLogicalAnd %bool_id %561 %657
               OpSelectionMerge %95 None
               OpBranchConditional %658 %92 %95
         %92 = OpLabel
        %659 = OpBitcast %f32_id %524
        %660 = OpBitcast %f32_id %234
        %661 = OpFSub %f32_id %659 %660
        %662 = OpBitcast %f32_id %528
        %663 = OpBitcast %f32_id %238
        %664 = OpFSub %f32_id %662 %663
        %665 = OpBitcast %f32_id %535
        %666 = OpBitcast %f32_id %242
        %667 = OpFSub %f32_id %665 %666
        %668 = OpFMul %f32_id %661 %f32_id_2
        %669 = OpFMul %f32_id %664 %f32_id_2
        %670 = OpFMul %f32_id %667 %f32_id_2
        %671 = OpExtInst %f32_id %140 FAbs %661
        %672 = OpExtInst %f32_id %140 FAbs %664
        %673 = OpExtInst %f32_id %140 FAbs %667
        %674 = OpFOrdGreaterThanEqual %bool_id %673 %672
        %675 = OpFOrdGreaterThanEqual %bool_id %673 %671
        %676 = OpLogicalAnd %bool_id %675 %674
        %677 = OpFOrdGreaterThanEqual %bool_id %672 %671
        %678 = OpSelect %f32_id %677 %669 %668
        %679 = OpSelect %f32_id %676 %670 %678
        %680 = OpExtInst %f32_id %140 FAbs %679
        %681 = OpFDiv %f32_id %f32_id_1 %680
        %682 = OpFOrdLessThan %bool_id %661 %f32_id_0
        %683 = OpFOrdLessThan %bool_id %667 %f32_id_0
        %684 = OpFNegate %f32_id %667
        %685 = OpSelect %f32_id %682 %667 %684
        %686 = OpFNegate %f32_id %661
        %687 = OpSelect %f32_id %683 %686 %661
        %688 = OpExtInst %f32_id %140 FAbs %661
        %689 = OpExtInst %f32_id %140 FAbs %664
        %690 = OpExtInst %f32_id %140 FAbs %667
        %691 = OpFOrdGreaterThanEqual %bool_id %690 %689
        %692 = OpFOrdGreaterThanEqual %bool_id %690 %688
        %693 = OpLogicalAnd %bool_id %692 %691
        %694 = OpFOrdGreaterThanEqual %bool_id %689 %688
        %695 = OpSelect %f32_id %694 %661 %685
        %696 = OpSelect %f32_id %693 %687 %695
        %697 = OpFOrdLessThan %bool_id %664 %f32_id_0
        %698 = OpFNegate %f32_id %664
        %699 = OpFNegate %f32_id %667
        %700 = OpSelect %f32_id %697 %699 %667
        %701 = OpExtInst %f32_id %140 FAbs %661
        %702 = OpExtInst %f32_id %140 FAbs %664
        %703 = OpExtInst %f32_id %140 FAbs %667
        %704 = OpFOrdGreaterThanEqual %bool_id %703 %702
        %705 = OpFOrdGreaterThanEqual %bool_id %703 %701
        %706 = OpLogicalAnd %bool_id %705 %704
        %707 = OpFOrdGreaterThanEqual %bool_id %702 %701
        %708 = OpSelect %f32_id %707 %700 %698
        %709 = OpSelect %f32_id %706 %698 %708
        %710 = OpExtInst %f32_id %140 Fma %696 %681 %f32_id_1_5
        %711 = OpExtInst %f32_id %140 Fma %709 %681 %f32_id_1_5
        %712 = OpFOrdLessThan %bool_id %661 %f32_id_0
        %713 = OpFOrdLessThan %bool_id %664 %f32_id_0
        %714 = OpFOrdLessThan %bool_id %667 %f32_id_0
        %715 = OpSelect %f32_id %712 %f32_id_1 %f32_id_0
        %716 = OpSelect %f32_id %713 %f32_id_3 %f32_id_2
        %717 = OpSelect %f32_id %714 %f32_id_5 %f32_id_4
        %718 = OpExtInst %f32_id %140 FAbs %661
        %719 = OpExtInst %f32_id %140 FAbs %664
        %720 = OpExtInst %f32_id %140 FAbs %667
        %721 = OpFOrdGreaterThanEqual %bool_id %720 %719
        %722 = OpFOrdGreaterThanEqual %bool_id %720 %718
        %723 = OpLogicalAnd %bool_id %722 %721
        %724 = OpFOrdGreaterThanEqual %bool_id %719 %718
        %725 = OpSelect %f32_id %724 %716 %715
        %726 = OpSelect %f32_id %723 %717 %725
        %727 = OpFSub %f32_id %710 %f32_id_1
        %728 = OpFSub %f32_id %711 %f32_id_1
        %729 = OpFDiv %f32_id %726 %f32_id_8
        %730 = OpExtInst %f32_id %140 Floor %729
        %731 = OpExtInst %f32_id %140 Fma %730 %f32_id_n2 %726
        %732 = OpCompositeConstruct %f32vec3_id %727 %728 %731
        %733 = OpLoad %58 %cs_img32
        %734 = OpLoad %69 %cs_sampinline_0xfff00000000036_0x2500000
        %735 = OpSampledImage %61 %733 %734
        %736 = OpImageSampleExplicitLod %f32vec4_id %735 %732 Lod %f32_id_0
        %737 = OpCompositeExtract %f32_id %736 0
        %738 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %739 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_46
        %740 = OpLoad %u32_id %739
        %741 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_47
        %742 = OpLoad %u32_id %741
        %743 = OpExtInst %f32_id %140 FAbs %667
        %744 = OpExtInst %f32_id %140 FAbs %661
        %745 = OpExtInst %f32_id %140 FAbs %664
        %746 = OpExtInst %f32_id %140 FMax %744 %745
        %747 = OpExtInst %f32_id %140 FMax %743 %746
        %748 = OpFMul %f32_id %661 %661
        %749 = OpFMul %f32_id %664 %664
        %750 = OpFAdd %f32_id %749 %748
        %751 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %752 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_48
        %753 = OpLoad %u32_id %752
        %754 = OpFMul %f32_id %667 %667
        %755 = OpFAdd %f32_id %754 %750
        %756 = OpExtInst %f32_id %140 Sqrt %755
        %757 = OpBitcast %f32_id %740
        %758 = OpBitcast %f32_id %742
        %759 = OpFMul %f32_id %757 %737
        %760 = OpFAdd %f32_id %759 %758
        %761 = OpFMul %f32_id %760 %747
        %762 = OpFDiv %f32_id %f32_id_1 %761
        %763 = OpBitcast %f32_id %753
        %764 = OpFMul %f32_id %762 %756
        %765 = OpFAdd %f32_id %764 %763
        %766 = OpFOrdGreaterThanEqual %bool_id %756 %765
        %767 = OpLogicalNot %bool_id %766
               OpSelectionMerge %94 None
               OpBranchConditional %767 %93 %94
         %93 = OpLabel
        %768 = OpFNegate %f32_id %559
        %769 = OpFMul %f32_id %559 %768
        %770 = OpFAdd %f32_id %769 %f32_id_1
        %771 = OpExtInst %f32_id %140 FClamp %770 %f32_id_0 %f32_id_1
        %772 = OpShiftLeftLogical %u32_id %517 %u32_id_7
        %773 = OpBitcast %f32_id %572
        %774 = OpBitcast %f32_id %622
        %775 = OpFMul %f32_id %773 %261
        %776 = OpFAdd %f32_id %775 %774
        %777 = OpBitcast %f32_id %589
        %778 = OpFMul %f32_id %777 %265
        %779 = OpFAdd %f32_id %778 %776
        %780 = OpFDiv %f32_id %f32_id_1 %649
        %781 = OpFMul %f32_id %780 %f32_id_0_5
        %782 = OpBitcast %f32_id %605
        %783 = OpFMul %f32_id %782 %269
        %784 = OpFAdd %f32_id %783 %779
        %785 = OpCompositeConstruct %u32vec2_id %ud_2 %ud_3
        %786 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_58
        %787 = OpLoad %u32_id %786
        %788 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_59
        %789 = OpLoad %u32_id %788
        %790 = OpExtInst %f32_id %140 InverseSqrt %557
        %791 = OpFMul %f32_id %771 %771
        %792 = OpBitcast %f32_id %568
        %793 = OpBitcast %f32_id %618
        %794 = OpFMul %f32_id %792 %261
        %795 = OpFAdd %f32_id %794 %793
        %797 = OpIAdd %u32_id %772 %u32_id_60
        %798 = OpShiftRightLogical %u32_id %797 %u32_id_2
        %799 = OpIAdd %u32_id %798 %buf1_dword_off
        %800 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %799
        %801 = OpLoad %u32_id %800
        %802 = OpBitcast %f32_id %584
        %803 = OpFMul %f32_id %802 %265
        %804 = OpFAdd %f32_id %803 %795
        %805 = OpBitcast %f32_id %601
        %806 = OpFMul %f32_id %805 %269
        %807 = OpFAdd %f32_id %806 %804
        %808 = OpFMul %f32_id %807 %781
        %809 = OpFAdd %f32_id %808 %f32_id_0_5
        %810 = OpFMul %f32_id %784 %781
        %811 = OpFAdd %f32_id %810 %f32_id_0_5
        %812 = OpConvertSToF %f32_id %801
        %813 = OpCompositeConstruct %f32vec3_id %809 %811 %812
        %814 = OpLoad %58 %cs_img24
        %815 = OpLoad %69 %cs_sampinline_0xfff00000000036_0x2500000
        %816 = OpSampledImage %61 %814 %815
        %817 = OpImageSampleExplicitLod %f32vec4_id %816 %813 Lod %f32_id_0
        %818 = OpCompositeExtract %f32_id %817 0
        %819 = OpCompositeExtract %f32_id %817 1
        %820 = OpCompositeExtract %f32_id %817 2
        %821 = OpFMul %f32_id %790 %544
        %822 = OpIAdd %u32_id %772 %u32_id_48
        %823 = OpIAdd %u32_id %772 %u32_id_56
        %824 = OpShiftRightLogical %u32_id %822 %u32_id_2
        %825 = OpIAdd %u32_id %824 %buf1_dword_off
        %826 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %825
        %827 = OpLoad %u32_id %826
        %828 = OpIAdd %u32_id %824 %u32_id_1
        %829 = OpIAdd %u32_id %828 %buf1_dword_off
        %830 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %829
        %831 = OpLoad %u32_id %830
        %832 = OpShiftRightLogical %u32_id %823 %u32_id_2
        %833 = OpIAdd %u32_id %832 %buf1_dword_off
        %834 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %833
        %835 = OpLoad %u32_id %834
        %836 = OpFMul %f32_id %791 %821
        %837 = OpBitcast %f32_id %787
        %838 = OpBitcast %f32_id %789
        %839 = OpFMul %f32_id %837 %821
        %840 = OpFAdd %f32_id %839 %838
        %841 = OpFMul %f32_id %840 %840
        %842 = OpFMul %f32_id %841 %557
        %843 = OpFDiv %f32_id %f32_id_1 %842
        %844 = OpFMul %f32_id %836 %843
        %845 = OpBitcast %f32_id %827
        %846 = OpFMul %f32_id %845 %818
        %847 = OpBitcast %f32_id %831
        %848 = OpFMul %f32_id %847 %819
        %849 = OpBitcast %f32_id %835
        %850 = OpFMul %f32_id %849 %820
        %851 = OpBitcast %f32_id %514
        %852 = OpFMul %f32_id %844 %846
        %853 = OpFAdd %f32_id %852 %851
        %854 = OpBitcast %u32_id %853
        %855 = OpBitcast %f32_id %515
        %856 = OpFMul %f32_id %844 %850
        %857 = OpFAdd %f32_id %856 %855
        %858 = OpBitcast %u32_id %857
        %859 = OpBitcast %f32_id %516
        %860 = OpFMul %f32_id %844 %848
        %861 = OpFAdd %f32_id %860 %859
        %862 = OpBitcast %u32_id %861
               OpBranch %94
         %94 = OpLabel
        %863 = OpPhi %u32_id %854 %93 %514 %92
        %864 = OpPhi %u32_id %858 %93 %515 %92
        %865 = OpPhi %u32_id %862 %93 %516 %92
               OpBranch %95
         %95 = OpLabel
        %866 = OpPhi %u32_id %863 %94 %514 %91
        %867 = OpPhi %u32_id %864 %94 %515 %91
        %868 = OpPhi %u32_id %865 %94 %516 %91
               OpBranch %96
         %96 = OpLabel
        %869 = OpPhi %u32_id %866 %95 %514 %90
        %870 = OpPhi %u32_id %867 %95 %515 %90
        %871 = OpPhi %u32_id %868 %95 %516 %90
               OpBranch %97
         %97 = OpLabel
        %872 = OpPhi %u32_id %869 %96 %514 %89
        %873 = OpPhi %u32_id %870 %96 %515 %89
        %874 = OpPhi %u32_id %871 %96 %516 %89
        %875 = OpIAdd %u32_id %517 %u32_id_1
               OpBranch %98
         %98 = OpLabel
               OpBranchConditional %true %87 %99
         %99 = OpLabel
        %876 = OpPhi %u32_id %516 %88 %874 %98
        %877 = OpPhi %u32_id %515 %88 %873 %98
        %878 = OpPhi %u32_id %514 %88 %872 %98
        %879 = OpCompositeConstruct %u32vec2_id %ud_2 %ud_3
        %881 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_62
        %882 = OpLoad %u32_id %881
        %883 = OpCompositeConstruct %u32vec2_id %ud_2 %ud_3
        %884 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_60
        %885 = OpLoad %u32_id %884
        %886 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %889 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_49
        %890 = OpLoad %u32_id %889
        %891 = OpIMul %u32_id %882 %u32_id_6
        %892 = OpIAdd %u32_id %148 %891
        %893 = OpCompositeConstruct %u32vec3_id %133 %134 %892
        %894 = OpLoad %58 %cs_img50
        %895 = OpImageFetch %f32vec4_id %894 %893 Lod %885
        %896 = OpCompositeExtract %f32_id %895 0
        %897 = OpCompositeExtract %f32_id %895 1
        %898 = OpCompositeExtract %f32_id %895 2
        %899 = OpBitcast %f32_id %890
        %900 = OpBitcast %f32_id %878
        %901 = OpFMul %f32_id %899 %900
        %902 = OpFAdd %f32_id %901 %896
        %903 = OpBitcast %f32_id %890
        %904 = OpBitcast %f32_id %877
        %905 = OpFMul %f32_id %903 %904
        %906 = OpFAdd %f32_id %905 %898
        %907 = OpBitcast %f32_id %890
        %908 = OpBitcast %f32_id %876
        %909 = OpFMul %f32_id %907 %908
        %910 = OpFAdd %f32_id %909 %897
        %911 = OpCompositeConstruct %f32vec4_id %902 %910 %906 %f32_id_0
        %912 = OpCompositeConstruct %u32vec3_id %133 %134 %892
        %914 = OpVectorShuffle %f32vec4_id %913 %911 4 5 6 0
        %916 = OpAccessChain %_ptr_UniformConstant_64 %cs_img50_0 %885
        %917 = OpLoad %64 %916
               OpImageWrite %917 %912 %914 None
               OpBranch %100
        %100 = OpLabel
               OpBranch %101
        %101 = OpLabel
               OpReturn
               OpFunctionEnd
