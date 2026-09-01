; SPIR-V
; Version: 1.6
; Generator: Khronos; 0
; Bound: 913
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
               OpEntryPoint GLCompute %71 "main" %push_data %gl_WorkGroupID %gl_LocalInvocationID %ssbo_1 %ssbo_2 %srt_flatbuf %cs_img40 %cs_img24 %cs_img58 %cs_img32 %cs_sampinline_0xfff00000000036_0x2500000
               OpExecutionMode %71 LocalSize 8 8 1
               OpExecutionMode %71 SignedZeroInfNanPreserve 32
          %1 = OpString "0x18256c0"
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
               OpName %cs_img40 "cs_img40"
               OpName %cs_img24 "cs_img24"
               OpName %cs_img58 "cs_img58"
               OpName %cs_img32 "cs_img32"
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
               OpDecorate %cs_img40 Binding 3
               OpDecorate %cs_img40 DescriptorSet 0
               OpDecorate %cs_img24 Binding 4
               OpDecorate %cs_img24 DescriptorSet 0
               OpDecorate %cs_img58 Binding 5
               OpDecorate %cs_img58 DescriptorSet 0
               OpDecorate %cs_img32 Binding 6
               OpDecorate %cs_img32 DescriptorSet 0
               OpDecorate %cs_sampinline_0xfff00000000036_0x2500000 Binding 7
               OpDecorate %cs_sampinline_0xfff00000000036_0x2500000 DescriptorSet 0
               OpDecorate %158 NoContraction
               OpDecorate %172 NoContraction
               OpDecorate %173 NoContraction
               OpDecorate %191 NoContraction
               OpDecorate %199 NoContraction
               OpDecorate %200 NoContraction
               OpDecorate %202 NoContraction
               OpDecorate %203 NoContraction
               OpDecorate %205 NoContraction
               OpDecorate %211 NoContraction
               OpDecorate %212 NoContraction
               OpDecorate %213 NoContraction
               OpDecorate %215 NoContraction
               OpDecorate %216 NoContraction
               OpDecorate %218 NoContraction
               OpDecorate %219 NoContraction
               OpDecorate %221 NoContraction
               OpDecorate %222 NoContraction
               OpDecorate %223 NoContraction
               OpDecorate %224 NoContraction
               OpDecorate %242 NoContraction
               OpDecorate %243 NoContraction
               OpDecorate %245 NoContraction
               OpDecorate %246 NoContraction
               OpDecorate %247 NoContraction
               OpDecorate %255 NoContraction
               OpDecorate %256 NoContraction
               OpDecorate %259 NoContraction
               OpDecorate %260 NoContraction
               OpDecorate %263 NoContraction
               OpDecorate %264 NoContraction
               OpDecorate %283 NoContraction
               OpDecorate %288 NoContraction
               OpDecorate %290 NoContraction
               OpDecorate %292 NoContraction
               OpDecorate %294 NoContraction
               OpDecorate %295 NoContraction
               OpDecorate %296 NoContraction
               OpDecorate %297 NoContraction
               OpDecorate %300 NoContraction
               OpDecorate %307 NoContraction
               OpDecorate %308 NoContraction
               OpDecorate %309 NoContraction
               OpDecorate %310 NoContraction
               OpDecorate %312 NoContraction
               OpDecorate %317 NoContraction
               OpDecorate %320 NoContraction
               OpDecorate %323 NoContraction
               OpDecorate %325 NoContraction
               OpDecorate %326 NoContraction
               OpDecorate %327 NoContraction
               OpDecorate %368 NoContraction
               OpDecorate %369 NoContraction
               OpDecorate %388 NoContraction
               OpDecorate %389 NoContraction
               OpDecorate %391 NoContraction
               OpDecorate %394 NoContraction
               OpDecorate %410 NoContraction
               OpDecorate %416 NoContraction
               OpDecorate %417 NoContraction
               OpDecorate %423 NoContraction
               OpDecorate %424 NoContraction
               OpDecorate %428 NoContraction
               OpDecorate %429 NoContraction
               OpDecorate %431 NoContraction
               OpDecorate %434 NoContraction
               OpDecorate %435 NoContraction
               OpDecorate %439 NoContraction
               OpDecorate %440 NoContraction
               OpDecorate %443 NoContraction
               OpDecorate %446 NoContraction
               OpDecorate %450 NoContraction
               OpDecorate %463 NoContraction
               OpDecorate %466 NoContraction
               OpDecorate %467 NoContraction
               OpDecorate %471 NoContraction
               OpDecorate %472 NoContraction
               OpDecorate %476 NoContraction
               OpDecorate %477 NoContraction
               OpDecorate %518 NoContraction
               OpDecorate %523 NoContraction
               OpDecorate %525 NoContraction
               OpDecorate %527 NoContraction
               OpDecorate %529 NoContraction
               OpDecorate %530 NoContraction
               OpDecorate %531 NoContraction
               OpDecorate %532 NoContraction
               OpDecorate %535 NoContraction
               OpDecorate %542 NoContraction
               OpDecorate %543 NoContraction
               OpDecorate %544 NoContraction
               OpDecorate %545 NoContraction
               OpDecorate %547 NoContraction
               OpDecorate %625 NoContraction
               OpDecorate %626 NoContraction
               OpDecorate %629 NoContraction
               OpDecorate %630 NoContraction
               OpDecorate %633 NoContraction
               OpDecorate %634 NoContraction
               OpDecorate %636 NoContraction
               OpDecorate %637 NoContraction
               OpDecorate %639 NoContraction
               OpDecorate %640 NoContraction
               OpDecorate %642 NoContraction
               OpDecorate %643 NoContraction
               OpDecorate %652 NoContraction
               OpDecorate %655 NoContraction
               OpDecorate %658 NoContraction
               OpDecorate %659 NoContraction
               OpDecorate %660 NoContraction
               OpDecorate %661 NoContraction
               OpDecorate %701 NoContraction
               OpDecorate %702 NoContraction
               OpDecorate %718 NoContraction
               OpDecorate %719 NoContraction
               OpDecorate %720 NoContraction
               OpDecorate %722 NoContraction
               OpDecorate %734 NoContraction
               OpDecorate %740 NoContraction
               OpDecorate %741 NoContraction
               OpDecorate %745 NoContraction
               OpDecorate %746 NoContraction
               OpDecorate %750 NoContraction
               OpDecorate %751 NoContraction
               OpDecorate %753 NoContraction
               OpDecorate %756 NoContraction
               OpDecorate %757 NoContraction
               OpDecorate %761 NoContraction
               OpDecorate %762 NoContraction
               OpDecorate %767 NoContraction
               OpDecorate %768 NoContraction
               OpDecorate %770 NoContraction
               OpDecorate %771 NoContraction
               OpDecorate %773 NoContraction
               OpDecorate %775 NoContraction
               OpDecorate %776 NoContraction
               OpDecorate %777 NoContraction
               OpDecorate %780 NoContraction
               OpDecorate %781 NoContraction
               OpDecorate %789 NoContraction
               OpDecorate %790 NoContraction
               OpDecorate %792 NoContraction
               OpDecorate %793 NoContraction
               OpDecorate %794 NoContraction
               OpDecorate %795 NoContraction
               OpDecorate %796 NoContraction
               OpDecorate %797 NoContraction
               OpDecorate %818 NoContraction
               OpDecorate %824 NoContraction
               OpDecorate %825 NoContraction
               OpDecorate %827 NoContraction
               OpDecorate %829 NoContraction
               OpDecorate %832 NoContraction
               OpDecorate %834 NoContraction
               OpDecorate %835 NoContraction
               OpDecorate %838 NoContraction
               OpDecorate %839 NoContraction
               OpDecorate %842 NoContraction
               OpDecorate %843 NoContraction
               OpDecorate %886 NoContraction
               OpDecorate %889 NoContraction
               OpDecorate %892 NoContraction
               OpDecorate %895 NoContraction
               OpDecorate %896 NoContraction
               OpDecorate %899 NoContraction
               OpDecorate %900 NoContraction
               OpDecorate %903 NoContraction
               OpDecorate %904 NoContraction
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
         %63 = OpTypeImage %f32_id 2D 0 1 0 2 Unknown
%_ptr_UniformConstant_63 = OpTypePointer UniformConstant %63
         %67 = OpTypeSampler
%_ptr_UniformConstant_67 = OpTypePointer UniformConstant %67
         %70 = OpTypeFunction %void_id
   %u32_id_8 = OpConstant %u32_id 8
%_ptr_PushConstant_u32_id = OpTypePointer PushConstant %u32_id
   %u32_id_2 = OpConstant %u32_id 2
   %u32_id_4 = OpConstant %u32_id 4
   %u32_id_3 = OpConstant %u32_id 3
  %u32_id_13 = OpConstant %u32_id 13
  %u32_id_67 = OpConstant %u32_id 67
  %u32_id_12 = OpConstant %u32_id 12
 %u32_id_160 = OpConstant %u32_id 160
 %u32_id_232 = OpConstant %u32_id 232
 %f32_id_0_5 = OpConstant %f32_id 0.5
 %u32_id_304 = OpConstant %u32_id 304
 %u32_id_168 = OpConstant %u32_id 168
 %u32_id_240 = OpConstant %u32_id 240
   %f32_id_1 = OpConstant %f32_id 1
 %u32_id_312 = OpConstant %u32_id 312
  %u32_id_94 = OpConstant %u32_id 94
  %u32_id_48 = OpConstant %u32_id 48
  %u32_id_95 = OpConstant %u32_id 95
  %u32_id_49 = OpConstant %u32_id 49
  %u32_id_96 = OpConstant %u32_id 96
  %u32_id_50 = OpConstant %u32_id 50
  %u32_id_97 = OpConstant %u32_id 97
  %u32_id_51 = OpConstant %u32_id 51
  %u32_id_98 = OpConstant %u32_id 98
  %u32_id_52 = OpConstant %u32_id 52
   %u32_id_6 = OpConstant %u32_id 6
   %f32_id_2 = OpConstant %f32_id 2
 %f32_id_1_5 = OpConstant %f32_id 1.5
   %f32_id_3 = OpConstant %f32_id 3
   %f32_id_4 = OpConstant %f32_id 4
   %f32_id_5 = OpConstant %f32_id 5
   %f32_id_8 = OpConstant %f32_id 8
  %f32_id_n2 = OpConstant %f32_id -2
 %u32_id_100 = OpConstant %u32_id 100
  %u32_id_54 = OpConstant %u32_id 54
 %u32_id_101 = OpConstant %u32_id 101
  %u32_id_55 = OpConstant %u32_id 55
 %u32_id_102 = OpConstant %u32_id 102
  %u32_id_56 = OpConstant %u32_id 56
  %u32_id_99 = OpConstant %u32_id 99
  %u32_id_53 = OpConstant %u32_id 53
   %u32_id_7 = OpConstant %u32_id 7
  %u32_id_64 = OpConstant %u32_id 64
   %u32_id_5 = OpConstant %u32_id 5
   %u32_id_9 = OpConstant %u32_id 9
  %u32_id_10 = OpConstant %u32_id 10
  %u32_id_11 = OpConstant %u32_id 11
  %u32_id_14 = OpConstant %u32_id 14
  %u32_id_15 = OpConstant %u32_id 15
  %u32_id_60 = OpConstant %u32_id 60
  %u32_id_66 = OpConstant %u32_id 66
 %u32_id_103 = OpConstant %u32_id 103
  %u32_id_57 = OpConstant %u32_id 57
        %879 = OpConstantComposite %f32vec4_id %f32_id_0 %f32_id_1 %f32_id_0 %f32_id_0
  %push_data = OpVariable %_ptr_PushConstant_AuxData PushConstant
%gl_WorkGroupID = OpVariable %_ptr_Input_u32vec3_id Input
%gl_LocalInvocationID = OpVariable %_ptr_Input_u32vec3_id Input
     %ssbo_1 = OpVariable %_ptr_StorageBuffer__struct_52 StorageBuffer
     %ssbo_2 = OpVariable %_ptr_StorageBuffer__struct_52 StorageBuffer
%srt_flatbuf = OpVariable %_ptr_StorageBuffer__struct_52 StorageBuffer
   %cs_img40 = OpVariable %_ptr_UniformConstant_58 UniformConstant
   %cs_img24 = OpVariable %_ptr_UniformConstant_58 UniformConstant
   %cs_img58 = OpVariable %_ptr_UniformConstant_63 UniformConstant
   %cs_img32 = OpVariable %_ptr_UniformConstant_63 UniformConstant
%cs_sampinline_0xfff00000000036_0x2500000 = OpVariable %_ptr_UniformConstant_67 UniformConstant
         %71 = OpFunction %void_id None %70
         %72 = OpLabel
        %102 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
        %103 = OpLoad %u32_id %102
   %buf0_off = OpBitFieldUExtract %u32_id %103 %u32_id_0 %u32_id_8
%buf0_dword_off = OpShiftRightLogical %u32_id %buf0_off %u32_id_2
        %107 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
        %108 = OpLoad %u32_id %107
   %buf1_off = OpBitFieldUExtract %u32_id %108 %u32_id_8 %u32_id_8
%buf1_dword_off = OpShiftRightLogical %u32_id %buf1_off %u32_id_2
        %112 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_0
       %ud_0 = OpLoad %u32_id %112
        %114 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_1
       %ud_1 = OpLoad %u32_id %114
        %116 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_2
       %ud_2 = OpLoad %u32_id %116
        %119 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_3
       %ud_3 = OpLoad %u32_id %119
        %121 = OpLoad %u32vec3_id %gl_LocalInvocationID
        %122 = OpCompositeExtract %u32_id %121 0
        %123 = OpLoad %u32vec3_id %gl_LocalInvocationID
        %124 = OpCompositeExtract %u32_id %123 1
        %125 = OpLoad %u32vec3_id %gl_WorkGroupID
        %126 = OpCompositeExtract %u32_id %125 0
        %127 = OpLoad %u32vec3_id %gl_WorkGroupID
        %128 = OpCompositeExtract %u32_id %127 1
        %129 = OpLoad %u32vec3_id %gl_WorkGroupID
        %130 = OpCompositeExtract %u32_id %129 2
        %131 = OpShiftLeftLogical %u32_id %126 %u32_id_3
        %132 = OpShiftLeftLogical %u32_id %128 %u32_id_3
        %133 = OpIAdd %u32_id %131 %122
        %134 = OpIAdd %u32_id %132 %124
        %135 = OpCompositeConstruct %u32vec2_id %ud_2 %ud_3
        %138 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_67
        %139 = OpLoad %u32_id %138
        %141 = OpExtInst %u32_id %140 UMax %133 %134
        %142 = OpUGreaterThan %bool_id %139 %141
               OpSelectionMerge %98 None
               OpBranchConditional %142 %73 %98
         %73 = OpLabel
        %143 = OpConvertUToF %f32_id %133
        %145 = OpIMul %u32_id %130 %u32_id_12
        %147 = OpIAdd %u32_id %145 %u32_id_160
        %148 = OpShiftRightLogical %u32_id %147 %u32_id_2
        %149 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %150 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %151 = OpLoad %u32_id %150
        %152 = OpIAdd %u32_id %148 %u32_id_1
        %153 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %154 = OpLoad %u32_id %153
        %156 = OpIAdd %u32_id %145 %u32_id_232
        %158 = OpFAdd %f32_id %f32_id_0_5 %143
        %159 = OpConvertUToF %f32_id %134
        %160 = OpShiftRightLogical %u32_id %156 %u32_id_2
        %161 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %162 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %163 = OpLoad %u32_id %162
        %164 = OpIAdd %u32_id %160 %u32_id_1
        %165 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %166 = OpLoad %u32_id %165
        %168 = OpIAdd %u32_id %145 %u32_id_304
        %170 = OpIAdd %u32_id %145 %u32_id_168
        %171 = OpBitcast %f32_id %151
        %172 = OpFMul %f32_id %171 %158
        %173 = OpFAdd %f32_id %f32_id_0_5 %159
        %174 = OpConvertUToF %f32_id %139
        %175 = OpShiftRightLogical %u32_id %168 %u32_id_2
        %176 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %177 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %178 = OpLoad %u32_id %177
        %179 = OpIAdd %u32_id %175 %u32_id_1
        %180 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %181 = OpLoad %u32_id %180
        %182 = OpShiftRightLogical %u32_id %170 %u32_id_2
        %183 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %184 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %185 = OpLoad %u32_id %184
        %187 = OpIAdd %u32_id %145 %u32_id_240
        %189 = OpFDiv %f32_id %f32_id_1 %174
        %190 = OpBitcast %f32_id %154
        %191 = OpFMul %f32_id %190 %158
        %192 = OpShiftRightLogical %u32_id %187 %u32_id_2
        %193 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %194 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %195 = OpLoad %u32_id %194
        %197 = OpIAdd %u32_id %145 %u32_id_312
        %198 = OpBitcast %f32_id %163
        %199 = OpFMul %f32_id %198 %173
        %200 = OpFAdd %f32_id %199 %172
        %201 = OpBitcast %f32_id %178
        %202 = OpFMul %f32_id %189 %200
        %203 = OpFAdd %f32_id %202 %201
        %204 = OpBitcast %f32_id %185
        %205 = OpFMul %f32_id %204 %158
        %206 = OpShiftRightLogical %u32_id %197 %u32_id_2
        %207 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %208 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %209 = OpLoad %u32_id %208
        %210 = OpBitcast %f32_id %166
        %211 = OpFMul %f32_id %210 %173
        %212 = OpFAdd %f32_id %211 %191
        %213 = OpFMul %f32_id %203 %203
        %214 = OpBitcast %f32_id %181
        %215 = OpFMul %f32_id %189 %212
        %216 = OpFAdd %f32_id %215 %214
        %217 = OpBitcast %f32_id %195
        %218 = OpFMul %f32_id %217 %173
        %219 = OpFAdd %f32_id %218 %205
        %220 = OpBitcast %f32_id %209
        %221 = OpFMul %f32_id %189 %219
        %222 = OpFAdd %f32_id %221 %220
        %223 = OpFMul %f32_id %216 %216
        %224 = OpFAdd %f32_id %223 %213
        %225 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %228 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_48
        %229 = OpLoad %u32_id %228
        %232 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_49
        %233 = OpLoad %u32_id %232
        %236 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_50
        %237 = OpLoad %u32_id %236
        %240 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_51
        %241 = OpLoad %u32_id %240
        %242 = OpFMul %f32_id %222 %222
        %243 = OpFAdd %f32_id %242 %224
        %244 = OpExtInst %f32_id %140 InverseSqrt %243
        %245 = OpFMul %f32_id %244 %203
        %246 = OpFMul %f32_id %244 %216
        %247 = OpFMul %f32_id %244 %222
        %248 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %251 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_52
        %252 = OpLoad %u32_id %251
        %253 = OpBitcast %f32_id %241
        %254 = OpBitcast %f32_id %229
        %255 = OpFMul %f32_id %253 %245
        %256 = OpFAdd %f32_id %255 %254
        %257 = OpBitcast %f32_id %241
        %258 = OpBitcast %f32_id %233
        %259 = OpFMul %f32_id %257 %246
        %260 = OpFAdd %f32_id %259 %258
        %261 = OpBitcast %f32_id %241
        %262 = OpBitcast %f32_id %237
        %263 = OpFMul %f32_id %261 %247
        %264 = OpFAdd %f32_id %263 %262
               OpBranch %74
         %74 = OpLabel
        %265 = OpPhi %u32_id %u32_id_0 %73 %488 %83
        %266 = OpPhi %u32_id %u32_id_0 %73 %489 %83
        %267 = OpPhi %u32_id %u32_id_0 %73 %490 %83
        %268 = OpPhi %u32_id %u32_id_0 %73 %491 %83
               OpLoopMerge %84 %83 None
               OpBranch %75
         %75 = OpLabel
        %269 = OpSLessThan %bool_id %268 %252
        %270 = OpLogicalNot %bool_id %269
               OpBranchConditional %270 %84 %76
         %76 = OpLabel
        %272 = OpShiftLeftLogical %u32_id %268 %u32_id_6
        %273 = OpShiftRightLogical %u32_id %272 %u32_id_2
        %274 = OpIAdd %u32_id %273 %buf0_dword_off
        %275 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %274
        %276 = OpLoad %u32_id %275
        %277 = OpIAdd %u32_id %273 %u32_id_1
        %278 = OpIAdd %u32_id %277 %buf0_dword_off
        %279 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %278
        %280 = OpLoad %u32_id %279
        %281 = OpIAdd %u32_id %272 %u32_id_8
        %282 = OpBitcast %f32_id %276
        %283 = OpFSub %f32_id %282 %256
        %284 = OpShiftRightLogical %u32_id %281 %u32_id_2
        %285 = OpIAdd %u32_id %284 %buf0_dword_off
        %286 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %285
        %287 = OpLoad %u32_id %286
        %288 = OpFMul %f32_id %245 %283
        %289 = OpBitcast %f32_id %280
        %290 = OpFSub %f32_id %289 %260
        %291 = OpBitcast %f32_id %287
        %292 = OpFSub %f32_id %291 %264
        %293 = OpBitcast %u32_id %292
        %294 = OpFMul %f32_id %290 %246
        %295 = OpFAdd %f32_id %294 %288
        %296 = OpFMul %f32_id %292 %247
        %297 = OpFAdd %f32_id %296 %295
        %298 = OpFOrdGreaterThan %bool_id %297 %f32_id_0
        %299 = OpLogicalAnd %bool_id %142 %298
               OpSelectionMerge %82 None
               OpBranchConditional %299 %77 %82
         %77 = OpLabel
        %300 = OpFMul %f32_id %283 %283
        %301 = OpShiftLeftLogical %u32_id %268 %u32_id_6
        %302 = OpIAdd %u32_id %301 %u32_id_12
        %303 = OpShiftRightLogical %u32_id %302 %u32_id_2
        %304 = OpIAdd %u32_id %303 %buf0_dword_off
        %305 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %304
        %306 = OpLoad %u32_id %305
        %307 = OpFMul %f32_id %290 %290
        %308 = OpFAdd %f32_id %307 %300
        %309 = OpFMul %f32_id %292 %292
        %310 = OpFAdd %f32_id %309 %308
        %311 = OpBitcast %f32_id %306
        %312 = OpFMul %f32_id %311 %310
        %313 = OpFOrdLessThanEqual %bool_id %312 %f32_id_1
        %314 = OpLogicalAnd %bool_id %299 %313
               OpSelectionMerge %81 None
               OpBranchConditional %314 %78 %81
         %78 = OpLabel
        %315 = OpBitcast %f32_id %276
        %316 = OpBitcast %f32_id %229
        %317 = OpFSub %f32_id %315 %316
        %318 = OpBitcast %f32_id %280
        %319 = OpBitcast %f32_id %233
        %320 = OpFSub %f32_id %318 %319
        %321 = OpBitcast %f32_id %287
        %322 = OpBitcast %f32_id %237
        %323 = OpFSub %f32_id %321 %322
        %325 = OpFMul %f32_id %317 %f32_id_2
        %326 = OpFMul %f32_id %320 %f32_id_2
        %327 = OpFMul %f32_id %323 %f32_id_2
        %328 = OpExtInst %f32_id %140 FAbs %317
        %329 = OpExtInst %f32_id %140 FAbs %320
        %330 = OpExtInst %f32_id %140 FAbs %323
        %331 = OpFOrdGreaterThanEqual %bool_id %330 %329
        %332 = OpFOrdGreaterThanEqual %bool_id %330 %328
        %333 = OpLogicalAnd %bool_id %332 %331
        %334 = OpFOrdGreaterThanEqual %bool_id %329 %328
        %335 = OpSelect %f32_id %334 %326 %325
        %336 = OpSelect %f32_id %333 %327 %335
        %337 = OpExtInst %f32_id %140 FAbs %336
        %338 = OpFDiv %f32_id %f32_id_1 %337
        %339 = OpFOrdLessThan %bool_id %317 %f32_id_0
        %340 = OpFOrdLessThan %bool_id %323 %f32_id_0
        %341 = OpFNegate %f32_id %323
        %342 = OpSelect %f32_id %339 %323 %341
        %343 = OpFNegate %f32_id %317
        %344 = OpSelect %f32_id %340 %343 %317
        %345 = OpExtInst %f32_id %140 FAbs %317
        %346 = OpExtInst %f32_id %140 FAbs %320
        %347 = OpExtInst %f32_id %140 FAbs %323
        %348 = OpFOrdGreaterThanEqual %bool_id %347 %346
        %349 = OpFOrdGreaterThanEqual %bool_id %347 %345
        %350 = OpLogicalAnd %bool_id %349 %348
        %351 = OpFOrdGreaterThanEqual %bool_id %346 %345
        %352 = OpSelect %f32_id %351 %317 %342
        %353 = OpSelect %f32_id %350 %344 %352
        %354 = OpFOrdLessThan %bool_id %320 %f32_id_0
        %355 = OpFNegate %f32_id %320
        %356 = OpFNegate %f32_id %323
        %357 = OpSelect %f32_id %354 %356 %323
        %358 = OpExtInst %f32_id %140 FAbs %317
        %359 = OpExtInst %f32_id %140 FAbs %320
        %360 = OpExtInst %f32_id %140 FAbs %323
        %361 = OpFOrdGreaterThanEqual %bool_id %360 %359
        %362 = OpFOrdGreaterThanEqual %bool_id %360 %358
        %363 = OpLogicalAnd %bool_id %362 %361
        %364 = OpFOrdGreaterThanEqual %bool_id %359 %358
        %365 = OpSelect %f32_id %364 %357 %355
        %366 = OpSelect %f32_id %363 %355 %365
        %368 = OpExtInst %f32_id %140 Fma %353 %338 %f32_id_1_5
        %369 = OpExtInst %f32_id %140 Fma %366 %338 %f32_id_1_5
        %370 = OpFOrdLessThan %bool_id %317 %f32_id_0
        %371 = OpFOrdLessThan %bool_id %320 %f32_id_0
        %372 = OpFOrdLessThan %bool_id %323 %f32_id_0
        %373 = OpSelect %f32_id %370 %f32_id_1 %f32_id_0
        %375 = OpSelect %f32_id %371 %f32_id_3 %f32_id_2
        %378 = OpSelect %f32_id %372 %f32_id_5 %f32_id_4
        %379 = OpExtInst %f32_id %140 FAbs %317
        %380 = OpExtInst %f32_id %140 FAbs %320
        %381 = OpExtInst %f32_id %140 FAbs %323
        %382 = OpFOrdGreaterThanEqual %bool_id %381 %380
        %383 = OpFOrdGreaterThanEqual %bool_id %381 %379
        %384 = OpLogicalAnd %bool_id %383 %382
        %385 = OpFOrdGreaterThanEqual %bool_id %380 %379
        %386 = OpSelect %f32_id %385 %375 %373
        %387 = OpSelect %f32_id %384 %378 %386
        %388 = OpFSub %f32_id %368 %f32_id_1
        %389 = OpFSub %f32_id %369 %f32_id_1
        %391 = OpFDiv %f32_id %387 %f32_id_8
        %392 = OpExtInst %f32_id %140 Floor %391
        %394 = OpExtInst %f32_id %140 Fma %392 %f32_id_n2 %387
        %395 = OpCompositeConstruct %f32vec3_id %388 %389 %394
        %396 = OpLoad %58 %cs_img40
        %397 = OpLoad %67 %cs_sampinline_0xfff00000000036_0x2500000
        %398 = OpSampledImage %61 %396 %397
        %399 = OpImageSampleExplicitLod %f32vec4_id %398 %395 Lod %f32_id_0
        %400 = OpCompositeExtract %f32_id %399 0
        %401 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %404 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_54
        %405 = OpLoad %u32_id %404
        %408 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_55
        %409 = OpLoad %u32_id %408
        %410 = OpFMul %f32_id %317 %317
        %411 = OpExtInst %f32_id %140 FAbs %323
        %412 = OpExtInst %f32_id %140 FAbs %317
        %413 = OpExtInst %f32_id %140 FAbs %320
        %414 = OpExtInst %f32_id %140 FMax %412 %413
        %415 = OpExtInst %f32_id %140 FMax %411 %414
        %416 = OpFMul %f32_id %320 %320
        %417 = OpFAdd %f32_id %416 %410
        %418 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %421 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_56
        %422 = OpLoad %u32_id %421
        %423 = OpFMul %f32_id %323 %323
        %424 = OpFAdd %f32_id %423 %417
        %425 = OpExtInst %f32_id %140 Sqrt %424
        %426 = OpBitcast %f32_id %405
        %427 = OpBitcast %f32_id %409
        %428 = OpFMul %f32_id %426 %400
        %429 = OpFAdd %f32_id %428 %427
        %430 = OpBitcast %u32_id %429
        %431 = OpFMul %f32_id %429 %415
        %432 = OpFDiv %f32_id %f32_id_1 %431
        %433 = OpBitcast %f32_id %422
        %434 = OpFMul %f32_id %432 %425
        %435 = OpFAdd %f32_id %434 %433
        %436 = OpFOrdGreaterThanEqual %bool_id %425 %435
        %437 = OpLogicalNot %bool_id %436
               OpSelectionMerge %80 None
               OpBranchConditional %437 %79 %80
         %79 = OpLabel
        %438 = OpFNegate %f32_id %312
        %439 = OpFMul %f32_id %312 %438
        %440 = OpFAdd %f32_id %439 %f32_id_1
        %441 = OpExtInst %f32_id %140 FClamp %440 %f32_id_0 %f32_id_1
        %442 = OpShiftLeftLogical %u32_id %268 %u32_id_6
        %443 = OpFMul %f32_id %441 %441
        %444 = OpExtInst %f32_id %140 InverseSqrt %310
        %445 = OpIAdd %u32_id %442 %u32_id_48
        %446 = OpFMul %f32_id %443 %444
        %447 = OpFDiv %f32_id %f32_id_1 %310
        %448 = OpBitcast %u32_id %447
        %449 = OpIAdd %u32_id %442 %u32_id_56
        %450 = OpFMul %f32_id %446 %447
        %451 = OpShiftRightLogical %u32_id %445 %u32_id_2
        %452 = OpIAdd %u32_id %451 %buf0_dword_off
        %453 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %452
        %454 = OpLoad %u32_id %453
        %455 = OpIAdd %u32_id %451 %u32_id_1
        %456 = OpIAdd %u32_id %455 %buf0_dword_off
        %457 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %456
        %458 = OpLoad %u32_id %457
        %459 = OpShiftRightLogical %u32_id %449 %u32_id_2
        %460 = OpIAdd %u32_id %459 %buf0_dword_off
        %461 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %460
        %462 = OpLoad %u32_id %461
        %463 = OpFMul %f32_id %450 %297
        %464 = OpBitcast %f32_id %454
        %465 = OpBitcast %f32_id %265
        %466 = OpFMul %f32_id %464 %463
        %467 = OpFAdd %f32_id %466 %465
        %468 = OpBitcast %u32_id %467
        %469 = OpBitcast %f32_id %458
        %470 = OpBitcast %f32_id %267
        %471 = OpFMul %f32_id %469 %463
        %472 = OpFAdd %f32_id %471 %470
        %473 = OpBitcast %u32_id %472
        %474 = OpBitcast %f32_id %462
        %475 = OpBitcast %f32_id %266
        %476 = OpFMul %f32_id %474 %463
        %477 = OpFAdd %f32_id %476 %475
        %478 = OpBitcast %u32_id %477
               OpBranch %80
         %80 = OpLabel
        %479 = OpPhi %u32_id %448 %79 %430 %78
        %480 = OpPhi %u32_id %468 %79 %265 %78
        %481 = OpPhi %u32_id %478 %79 %266 %78
        %482 = OpPhi %u32_id %473 %79 %267 %78
               OpBranch %81
         %81 = OpLabel
        %483 = OpPhi %u32_id %479 %80 %293 %77
        %484 = OpPhi %u32_id %480 %80 %265 %77
        %485 = OpPhi %u32_id %481 %80 %266 %77
        %486 = OpPhi %u32_id %482 %80 %267 %77
               OpBranch %82
         %82 = OpLabel
        %487 = OpPhi %u32_id %483 %81 %293 %76
        %488 = OpPhi %u32_id %484 %81 %265 %76
        %489 = OpPhi %u32_id %485 %81 %266 %76
        %490 = OpPhi %u32_id %486 %81 %267 %76
        %491 = OpIAdd %u32_id %268 %u32_id_1
               OpBranch %83
         %83 = OpLabel
               OpBranchConditional %true %74 %84
         %84 = OpLabel
        %492 = OpPhi %u32_id %265 %75 %488 %83
        %493 = OpPhi %u32_id %266 %75 %489 %83
        %494 = OpPhi %u32_id %267 %75 %490 %83
        %495 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %498 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_53
        %499 = OpLoad %u32_id %498
               OpBranch %85
         %85 = OpLabel
        %500 = OpPhi %u32_id %492 %84 %858 %96
        %501 = OpPhi %u32_id %493 %84 %859 %96
        %502 = OpPhi %u32_id %494 %84 %860 %96
        %503 = OpPhi %u32_id %u32_id_0 %84 %861 %96
               OpLoopMerge %97 %96 None
               OpBranch %86
         %86 = OpLabel
        %504 = OpSLessThan %bool_id %503 %499
        %505 = OpLogicalNot %bool_id %504
               OpBranchConditional %505 %97 %87
         %87 = OpLabel
        %507 = OpShiftLeftLogical %u32_id %503 %u32_id_7
        %508 = OpShiftRightLogical %u32_id %507 %u32_id_2
        %509 = OpIAdd %u32_id %508 %buf1_dword_off
        %510 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %509
        %511 = OpLoad %u32_id %510
        %512 = OpIAdd %u32_id %508 %u32_id_1
        %513 = OpIAdd %u32_id %512 %buf1_dword_off
        %514 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %513
        %515 = OpLoad %u32_id %514
        %516 = OpIAdd %u32_id %507 %u32_id_8
        %517 = OpBitcast %f32_id %511
        %518 = OpFSub %f32_id %517 %256
        %519 = OpShiftRightLogical %u32_id %516 %u32_id_2
        %520 = OpIAdd %u32_id %519 %buf1_dword_off
        %521 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %520
        %522 = OpLoad %u32_id %521
        %523 = OpFMul %f32_id %245 %518
        %524 = OpBitcast %f32_id %515
        %525 = OpFSub %f32_id %524 %260
        %526 = OpBitcast %f32_id %522
        %527 = OpFSub %f32_id %526 %264
        %528 = OpBitcast %u32_id %527
        %529 = OpFMul %f32_id %525 %246
        %530 = OpFAdd %f32_id %529 %523
        %531 = OpFMul %f32_id %527 %247
        %532 = OpFAdd %f32_id %531 %530
        %533 = OpFOrdGreaterThan %bool_id %532 %f32_id_0
        %534 = OpLogicalAnd %bool_id %142 %533
               OpSelectionMerge %95 None
               OpBranchConditional %534 %88 %95
         %88 = OpLabel
        %535 = OpFMul %f32_id %518 %518
        %536 = OpShiftLeftLogical %u32_id %503 %u32_id_7
        %537 = OpIAdd %u32_id %536 %u32_id_12
        %538 = OpShiftRightLogical %u32_id %537 %u32_id_2
        %539 = OpIAdd %u32_id %538 %buf1_dword_off
        %540 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %539
        %541 = OpLoad %u32_id %540
        %542 = OpFMul %f32_id %525 %525
        %543 = OpFAdd %f32_id %542 %535
        %544 = OpFMul %f32_id %527 %527
        %545 = OpFAdd %f32_id %544 %543
        %546 = OpBitcast %f32_id %541
        %547 = OpFMul %f32_id %546 %545
        %548 = OpFOrdLessThanEqual %bool_id %547 %f32_id_1
        %549 = OpLogicalAnd %bool_id %534 %548
               OpSelectionMerge %94 None
               OpBranchConditional %549 %89 %94
         %89 = OpLabel
        %550 = OpShiftLeftLogical %u32_id %503 %u32_id_7
        %552 = OpIAdd %u32_id %550 %u32_id_64
        %553 = OpShiftRightLogical %u32_id %552 %u32_id_2
        %554 = OpIAdd %u32_id %553 %buf1_dword_off
        %555 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %554
        %556 = OpLoad %u32_id %555
        %557 = OpIAdd %u32_id %553 %u32_id_1
        %558 = OpIAdd %u32_id %557 %buf1_dword_off
        %559 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %558
        %560 = OpLoad %u32_id %559
        %561 = OpIAdd %u32_id %553 %u32_id_2
        %562 = OpIAdd %u32_id %561 %buf1_dword_off
        %563 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %562
        %564 = OpLoad %u32_id %563
        %565 = OpIAdd %u32_id %553 %u32_id_3
        %566 = OpIAdd %u32_id %565 %buf1_dword_off
        %567 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %566
        %568 = OpLoad %u32_id %567
        %569 = OpIAdd %u32_id %553 %u32_id_4
        %570 = OpIAdd %u32_id %569 %buf1_dword_off
        %571 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %570
        %572 = OpLoad %u32_id %571
        %574 = OpIAdd %u32_id %553 %u32_id_5
        %575 = OpIAdd %u32_id %574 %buf1_dword_off
        %576 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %575
        %577 = OpLoad %u32_id %576
        %578 = OpIAdd %u32_id %553 %u32_id_6
        %579 = OpIAdd %u32_id %578 %buf1_dword_off
        %580 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %579
        %581 = OpLoad %u32_id %580
        %582 = OpIAdd %u32_id %553 %u32_id_7
        %583 = OpIAdd %u32_id %582 %buf1_dword_off
        %584 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %583
        %585 = OpLoad %u32_id %584
        %586 = OpIAdd %u32_id %553 %u32_id_8
        %587 = OpIAdd %u32_id %586 %buf1_dword_off
        %588 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %587
        %589 = OpLoad %u32_id %588
        %591 = OpIAdd %u32_id %553 %u32_id_9
        %592 = OpIAdd %u32_id %591 %buf1_dword_off
        %593 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %592
        %594 = OpLoad %u32_id %593
        %596 = OpIAdd %u32_id %553 %u32_id_10
        %597 = OpIAdd %u32_id %596 %buf1_dword_off
        %598 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %597
        %599 = OpLoad %u32_id %598
        %601 = OpIAdd %u32_id %553 %u32_id_11
        %602 = OpIAdd %u32_id %601 %buf1_dword_off
        %603 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %602
        %604 = OpLoad %u32_id %603
        %605 = OpIAdd %u32_id %553 %u32_id_12
        %606 = OpIAdd %u32_id %605 %buf1_dword_off
        %607 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %606
        %608 = OpLoad %u32_id %607
        %609 = OpIAdd %u32_id %553 %u32_id_13
        %610 = OpIAdd %u32_id %609 %buf1_dword_off
        %611 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %610
        %612 = OpLoad %u32_id %611
        %614 = OpIAdd %u32_id %553 %u32_id_14
        %615 = OpIAdd %u32_id %614 %buf1_dword_off
        %616 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %615
        %617 = OpLoad %u32_id %616
        %619 = OpIAdd %u32_id %553 %u32_id_15
        %620 = OpIAdd %u32_id %619 %buf1_dword_off
        %621 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %620
        %622 = OpLoad %u32_id %621
        %623 = OpBitcast %f32_id %568
        %624 = OpBitcast %f32_id %622
        %625 = OpFMul %f32_id %623 %256
        %626 = OpFAdd %f32_id %625 %624
        %627 = OpBitcast %f32_id %564
        %628 = OpBitcast %f32_id %617
        %629 = OpFMul %f32_id %627 %256
        %630 = OpFAdd %f32_id %629 %628
        %631 = OpBitcast %u32_id %630
        %632 = OpBitcast %f32_id %585
        %633 = OpFMul %f32_id %632 %260
        %634 = OpFAdd %f32_id %633 %626
        %635 = OpBitcast %f32_id %581
        %636 = OpFMul %f32_id %635 %260
        %637 = OpFAdd %f32_id %636 %630
        %638 = OpBitcast %f32_id %604
        %639 = OpFMul %f32_id %638 %264
        %640 = OpFAdd %f32_id %639 %634
        %641 = OpBitcast %f32_id %599
        %642 = OpFMul %f32_id %641 %264
        %643 = OpFAdd %f32_id %642 %637
        %644 = OpFNegate %f32_id %640
        %645 = OpFOrdLessThan %bool_id %643 %644
        %646 = OpFOrdGreaterThan %bool_id %f32_id_0 %640
        %647 = OpLogicalOr %bool_id %646 %645
        %648 = OpLogicalNot %bool_id %647
        %649 = OpLogicalAnd %bool_id %549 %648
               OpSelectionMerge %93 None
               OpBranchConditional %649 %90 %93
         %90 = OpLabel
        %650 = OpBitcast %f32_id %511
        %651 = OpBitcast %f32_id %229
        %652 = OpFSub %f32_id %650 %651
        %653 = OpBitcast %f32_id %515
        %654 = OpBitcast %f32_id %233
        %655 = OpFSub %f32_id %653 %654
        %656 = OpBitcast %f32_id %522
        %657 = OpBitcast %f32_id %237
        %658 = OpFSub %f32_id %656 %657
        %659 = OpFMul %f32_id %652 %f32_id_2
        %660 = OpFMul %f32_id %655 %f32_id_2
        %661 = OpFMul %f32_id %658 %f32_id_2
        %662 = OpExtInst %f32_id %140 FAbs %652
        %663 = OpExtInst %f32_id %140 FAbs %655
        %664 = OpExtInst %f32_id %140 FAbs %658
        %665 = OpFOrdGreaterThanEqual %bool_id %664 %663
        %666 = OpFOrdGreaterThanEqual %bool_id %664 %662
        %667 = OpLogicalAnd %bool_id %666 %665
        %668 = OpFOrdGreaterThanEqual %bool_id %663 %662
        %669 = OpSelect %f32_id %668 %660 %659
        %670 = OpSelect %f32_id %667 %661 %669
        %671 = OpExtInst %f32_id %140 FAbs %670
        %672 = OpFDiv %f32_id %f32_id_1 %671
        %673 = OpFOrdLessThan %bool_id %652 %f32_id_0
        %674 = OpFOrdLessThan %bool_id %658 %f32_id_0
        %675 = OpFNegate %f32_id %658
        %676 = OpSelect %f32_id %673 %658 %675
        %677 = OpFNegate %f32_id %652
        %678 = OpSelect %f32_id %674 %677 %652
        %679 = OpExtInst %f32_id %140 FAbs %652
        %680 = OpExtInst %f32_id %140 FAbs %655
        %681 = OpExtInst %f32_id %140 FAbs %658
        %682 = OpFOrdGreaterThanEqual %bool_id %681 %680
        %683 = OpFOrdGreaterThanEqual %bool_id %681 %679
        %684 = OpLogicalAnd %bool_id %683 %682
        %685 = OpFOrdGreaterThanEqual %bool_id %680 %679
        %686 = OpSelect %f32_id %685 %652 %676
        %687 = OpSelect %f32_id %684 %678 %686
        %688 = OpFOrdLessThan %bool_id %655 %f32_id_0
        %689 = OpFNegate %f32_id %655
        %690 = OpFNegate %f32_id %658
        %691 = OpSelect %f32_id %688 %690 %658
        %692 = OpExtInst %f32_id %140 FAbs %652
        %693 = OpExtInst %f32_id %140 FAbs %655
        %694 = OpExtInst %f32_id %140 FAbs %658
        %695 = OpFOrdGreaterThanEqual %bool_id %694 %693
        %696 = OpFOrdGreaterThanEqual %bool_id %694 %692
        %697 = OpLogicalAnd %bool_id %696 %695
        %698 = OpFOrdGreaterThanEqual %bool_id %693 %692
        %699 = OpSelect %f32_id %698 %691 %689
        %700 = OpSelect %f32_id %697 %689 %699
        %701 = OpExtInst %f32_id %140 Fma %687 %672 %f32_id_1_5
        %702 = OpExtInst %f32_id %140 Fma %700 %672 %f32_id_1_5
        %703 = OpFOrdLessThan %bool_id %652 %f32_id_0
        %704 = OpFOrdLessThan %bool_id %655 %f32_id_0
        %705 = OpFOrdLessThan %bool_id %658 %f32_id_0
        %706 = OpSelect %f32_id %703 %f32_id_1 %f32_id_0
        %707 = OpSelect %f32_id %704 %f32_id_3 %f32_id_2
        %708 = OpSelect %f32_id %705 %f32_id_5 %f32_id_4
        %709 = OpExtInst %f32_id %140 FAbs %652
        %710 = OpExtInst %f32_id %140 FAbs %655
        %711 = OpExtInst %f32_id %140 FAbs %658
        %712 = OpFOrdGreaterThanEqual %bool_id %711 %710
        %713 = OpFOrdGreaterThanEqual %bool_id %711 %709
        %714 = OpLogicalAnd %bool_id %713 %712
        %715 = OpFOrdGreaterThanEqual %bool_id %710 %709
        %716 = OpSelect %f32_id %715 %707 %706
        %717 = OpSelect %f32_id %714 %708 %716
        %718 = OpFSub %f32_id %701 %f32_id_1
        %719 = OpFSub %f32_id %702 %f32_id_1
        %720 = OpFDiv %f32_id %717 %f32_id_8
        %721 = OpExtInst %f32_id %140 Floor %720
        %722 = OpExtInst %f32_id %140 Fma %721 %f32_id_n2 %717
        %723 = OpCompositeConstruct %f32vec3_id %718 %719 %722
        %724 = OpLoad %58 %cs_img40
        %725 = OpLoad %67 %cs_sampinline_0xfff00000000036_0x2500000
        %726 = OpSampledImage %61 %724 %725
        %727 = OpImageSampleExplicitLod %f32vec4_id %726 %723 Lod %f32_id_0
        %728 = OpCompositeExtract %f32_id %727 0
        %729 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %730 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_54
        %731 = OpLoad %u32_id %730
        %732 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_55
        %733 = OpLoad %u32_id %732
        %734 = OpFMul %f32_id %652 %652
        %735 = OpExtInst %f32_id %140 FAbs %658
        %736 = OpExtInst %f32_id %140 FAbs %652
        %737 = OpExtInst %f32_id %140 FAbs %655
        %738 = OpExtInst %f32_id %140 FMax %736 %737
        %739 = OpExtInst %f32_id %140 FMax %735 %738
        %740 = OpFMul %f32_id %655 %655
        %741 = OpFAdd %f32_id %740 %734
        %742 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %743 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_56
        %744 = OpLoad %u32_id %743
        %745 = OpFMul %f32_id %658 %658
        %746 = OpFAdd %f32_id %745 %741
        %747 = OpExtInst %f32_id %140 Sqrt %746
        %748 = OpBitcast %f32_id %731
        %749 = OpBitcast %f32_id %733
        %750 = OpFMul %f32_id %748 %728
        %751 = OpFAdd %f32_id %750 %749
        %752 = OpBitcast %u32_id %751
        %753 = OpFMul %f32_id %751 %739
        %754 = OpFDiv %f32_id %f32_id_1 %753
        %755 = OpBitcast %f32_id %744
        %756 = OpFMul %f32_id %754 %747
        %757 = OpFAdd %f32_id %756 %755
        %758 = OpFOrdGreaterThanEqual %bool_id %747 %757
        %759 = OpLogicalNot %bool_id %758
               OpSelectionMerge %92 None
               OpBranchConditional %759 %91 %92
         %91 = OpLabel
        %760 = OpFNegate %f32_id %547
        %761 = OpFMul %f32_id %547 %760
        %762 = OpFAdd %f32_id %761 %f32_id_1
        %763 = OpExtInst %f32_id %140 FClamp %762 %f32_id_0 %f32_id_1
        %764 = OpShiftLeftLogical %u32_id %503 %u32_id_7
        %765 = OpBitcast %f32_id %560
        %766 = OpBitcast %f32_id %612
        %767 = OpFMul %f32_id %765 %256
        %768 = OpFAdd %f32_id %767 %766
        %769 = OpBitcast %f32_id %577
        %770 = OpFMul %f32_id %769 %260
        %771 = OpFAdd %f32_id %770 %768
        %772 = OpFDiv %f32_id %f32_id_1 %640
        %773 = OpFMul %f32_id %772 %f32_id_0_5
        %774 = OpBitcast %f32_id %594
        %775 = OpFMul %f32_id %774 %264
        %776 = OpFAdd %f32_id %775 %771
        %777 = OpFMul %f32_id %763 %763
        %778 = OpBitcast %f32_id %556
        %779 = OpBitcast %f32_id %608
        %780 = OpFMul %f32_id %778 %256
        %781 = OpFAdd %f32_id %780 %779
        %783 = OpIAdd %u32_id %764 %u32_id_60
        %784 = OpShiftRightLogical %u32_id %783 %u32_id_2
        %785 = OpIAdd %u32_id %784 %buf1_dword_off
        %786 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %785
        %787 = OpLoad %u32_id %786
        %788 = OpBitcast %f32_id %572
        %789 = OpFMul %f32_id %788 %260
        %790 = OpFAdd %f32_id %789 %781
        %791 = OpBitcast %f32_id %589
        %792 = OpFMul %f32_id %791 %264
        %793 = OpFAdd %f32_id %792 %790
        %794 = OpFMul %f32_id %793 %773
        %795 = OpFAdd %f32_id %794 %f32_id_0_5
        %796 = OpFMul %f32_id %776 %773
        %797 = OpFAdd %f32_id %796 %f32_id_0_5
        %798 = OpConvertSToF %f32_id %787
        %799 = OpCompositeConstruct %f32vec3_id %795 %797 %798
        %800 = OpLoad %58 %cs_img24
        %801 = OpLoad %67 %cs_sampinline_0xfff00000000036_0x2500000
        %802 = OpSampledImage %61 %800 %801
        %803 = OpImageSampleExplicitLod %f32vec4_id %802 %799 Lod %f32_id_0
        %804 = OpCompositeExtract %f32_id %803 0
        %805 = OpCompositeExtract %f32_id %803 1
        %806 = OpCompositeExtract %f32_id %803 2
        %807 = OpIAdd %u32_id %764 %u32_id_48
        %808 = OpExtInst %f32_id %140 InverseSqrt %545
        %809 = OpIAdd %u32_id %764 %u32_id_56
        %810 = OpShiftRightLogical %u32_id %807 %u32_id_2
        %811 = OpIAdd %u32_id %810 %buf1_dword_off
        %812 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %811
        %813 = OpLoad %u32_id %812
        %814 = OpIAdd %u32_id %810 %u32_id_1
        %815 = OpIAdd %u32_id %814 %buf1_dword_off
        %816 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %815
        %817 = OpLoad %u32_id %816
        %818 = OpFMul %f32_id %777 %808
        %819 = OpFDiv %f32_id %f32_id_1 %545
        %820 = OpShiftRightLogical %u32_id %809 %u32_id_2
        %821 = OpIAdd %u32_id %820 %buf1_dword_off
        %822 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %821
        %823 = OpLoad %u32_id %822
        %824 = OpFMul %f32_id %818 %819
        %825 = OpFMul %f32_id %824 %532
        %826 = OpBitcast %f32_id %813
        %827 = OpFMul %f32_id %826 %804
        %828 = OpBitcast %f32_id %817
        %829 = OpFMul %f32_id %828 %805
        %830 = OpBitcast %u32_id %829
        %831 = OpBitcast %f32_id %823
        %832 = OpFMul %f32_id %831 %806
        %833 = OpBitcast %f32_id %500
        %834 = OpFMul %f32_id %825 %827
        %835 = OpFAdd %f32_id %834 %833
        %836 = OpBitcast %u32_id %835
        %837 = OpBitcast %f32_id %501
        %838 = OpFMul %f32_id %825 %832
        %839 = OpFAdd %f32_id %838 %837
        %840 = OpBitcast %u32_id %839
        %841 = OpBitcast %f32_id %502
        %842 = OpFMul %f32_id %825 %829
        %843 = OpFAdd %f32_id %842 %841
        %844 = OpBitcast %u32_id %843
               OpBranch %92
         %92 = OpLabel
        %845 = OpPhi %u32_id %830 %91 %752 %90
        %846 = OpPhi %u32_id %836 %91 %500 %90
        %847 = OpPhi %u32_id %840 %91 %501 %90
        %848 = OpPhi %u32_id %844 %91 %502 %90
               OpBranch %93
         %93 = OpLabel
        %849 = OpPhi %u32_id %845 %92 %631 %89
        %850 = OpPhi %u32_id %846 %92 %500 %89
        %851 = OpPhi %u32_id %847 %92 %501 %89
        %852 = OpPhi %u32_id %848 %92 %502 %89
               OpBranch %94
         %94 = OpLabel
        %853 = OpPhi %u32_id %849 %93 %528 %88
        %854 = OpPhi %u32_id %850 %93 %500 %88
        %855 = OpPhi %u32_id %851 %93 %501 %88
        %856 = OpPhi %u32_id %852 %93 %502 %88
               OpBranch %95
         %95 = OpLabel
        %857 = OpPhi %u32_id %853 %94 %528 %87
        %858 = OpPhi %u32_id %854 %94 %500 %87
        %859 = OpPhi %u32_id %855 %94 %501 %87
        %860 = OpPhi %u32_id %856 %94 %502 %87
        %861 = OpIAdd %u32_id %503 %u32_id_1
               OpBranch %96
         %96 = OpLabel
               OpBranchConditional %true %85 %97
         %97 = OpLabel
        %862 = OpPhi %u32_id %501 %86 %859 %96
        %863 = OpPhi %u32_id %502 %86 %860 %96
        %864 = OpPhi %u32_id %500 %86 %858 %96
        %865 = OpCompositeConstruct %u32vec2_id %ud_2 %ud_3
        %867 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_66
        %868 = OpLoad %u32_id %867
        %869 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %872 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_57
        %873 = OpLoad %u32_id %872
        %874 = OpIMul %u32_id %868 %u32_id_6
        %875 = OpIAdd %u32_id %130 %874
        %876 = OpCompositeConstruct %u32vec3_id %133 %134 %875
        %877 = OpLoad %63 %cs_img58
        %878 = OpImageRead %f32vec4_id %877 %876 None
        %880 = OpVectorShuffle %f32vec4_id %879 %878 4 5 6 1
        %881 = OpCompositeExtract %f32_id %880 0
        %882 = OpCompositeExtract %f32_id %880 1
        %883 = OpCompositeExtract %f32_id %880 2
        %884 = OpBitcast %f32_id %864
        %885 = OpBitcast %f32_id %873
        %886 = OpFMul %f32_id %885 %884
        %887 = OpBitcast %f32_id %863
        %888 = OpBitcast %f32_id %873
        %889 = OpFMul %f32_id %888 %887
        %890 = OpBitcast %f32_id %862
        %891 = OpBitcast %f32_id %873
        %892 = OpFMul %f32_id %891 %890
        %893 = OpBitcast %f32_id %873
        %894 = OpBitcast %f32_id %864
        %895 = OpFMul %f32_id %893 %894
        %896 = OpFAdd %f32_id %895 %881
        %897 = OpBitcast %f32_id %873
        %898 = OpBitcast %f32_id %862
        %899 = OpFMul %f32_id %897 %898
        %900 = OpFAdd %f32_id %899 %883
        %901 = OpBitcast %f32_id %873
        %902 = OpBitcast %f32_id %863
        %903 = OpFMul %f32_id %901 %902
        %904 = OpFAdd %f32_id %903 %882
        %905 = OpCompositeConstruct %f32vec4_id %896 %904 %900 %f32_id_0
        %906 = OpCompositeConstruct %u32vec3_id %133 %134 %875
        %907 = OpVectorShuffle %f32vec4_id %879 %905 4 5 6 0
        %908 = OpLoad %63 %cs_img58
               OpImageWrite %908 %906 %907 None
        %909 = OpCompositeConstruct %f32vec4_id %886 %889 %892 %f32_id_0
        %910 = OpCompositeConstruct %u32vec3_id %133 %134 %130
        %911 = OpVectorShuffle %f32vec4_id %879 %909 4 5 6 0
        %912 = OpLoad %63 %cs_img32
               OpImageWrite %912 %910 %911 None
               OpBranch %98
         %98 = OpLabel
               OpBranch %99
         %99 = OpLabel
               OpReturn
               OpFunctionEnd
