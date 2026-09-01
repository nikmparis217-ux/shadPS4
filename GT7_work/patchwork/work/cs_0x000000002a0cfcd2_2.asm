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
        %139 = OpExtInstImport "GLSL.std.450"
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
               OpDecorate %cs_sampinline_0xfff00000000036_0x2500000 Binding 14
               OpDecorate %cs_sampinline_0xfff00000000036_0x2500000 DescriptorSet 0
               OpDecorate %149 NoContraction
               OpDecorate %175 NoContraction
               OpDecorate %177 NoContraction
               OpDecorate %195 NoContraction
               OpDecorate %203 NoContraction
               OpDecorate %204 NoContraction
               OpDecorate %206 NoContraction
               OpDecorate %207 NoContraction
               OpDecorate %209 NoContraction
               OpDecorate %215 NoContraction
               OpDecorate %216 NoContraction
               OpDecorate %217 NoContraction
               OpDecorate %219 NoContraction
               OpDecorate %220 NoContraction
               OpDecorate %222 NoContraction
               OpDecorate %223 NoContraction
               OpDecorate %225 NoContraction
               OpDecorate %226 NoContraction
               OpDecorate %227 NoContraction
               OpDecorate %228 NoContraction
               OpDecorate %246 NoContraction
               OpDecorate %247 NoContraction
               OpDecorate %249 NoContraction
               OpDecorate %250 NoContraction
               OpDecorate %251 NoContraction
               OpDecorate %259 NoContraction
               OpDecorate %260 NoContraction
               OpDecorate %263 NoContraction
               OpDecorate %264 NoContraction
               OpDecorate %267 NoContraction
               OpDecorate %268 NoContraction
               OpDecorate %291 NoContraction
               OpDecorate %292 NoContraction
               OpDecorate %294 NoContraction
               OpDecorate %296 NoContraction
               OpDecorate %297 NoContraction
               OpDecorate %298 NoContraction
               OpDecorate %299 NoContraction
               OpDecorate %300 NoContraction
               OpDecorate %303 NoContraction
               OpDecorate %310 NoContraction
               OpDecorate %311 NoContraction
               OpDecorate %312 NoContraction
               OpDecorate %313 NoContraction
               OpDecorate %315 NoContraction
               OpDecorate %320 NoContraction
               OpDecorate %323 NoContraction
               OpDecorate %326 NoContraction
               OpDecorate %328 NoContraction
               OpDecorate %329 NoContraction
               OpDecorate %330 NoContraction
               OpDecorate %371 NoContraction
               OpDecorate %372 NoContraction
               OpDecorate %391 NoContraction
               OpDecorate %392 NoContraction
               OpDecorate %394 NoContraction
               OpDecorate %397 NoContraction
               OpDecorate %418 NoContraction
               OpDecorate %419 NoContraction
               OpDecorate %420 NoContraction
               OpDecorate %426 NoContraction
               OpDecorate %427 NoContraction
               OpDecorate %431 NoContraction
               OpDecorate %432 NoContraction
               OpDecorate %433 NoContraction
               OpDecorate %436 NoContraction
               OpDecorate %437 NoContraction
               OpDecorate %449 NoContraction
               OpDecorate %453 NoContraction
               OpDecorate %454 NoContraction
               OpDecorate %455 NoContraction
               OpDecorate %457 NoContraction
               OpDecorate %458 NoContraction
               OpDecorate %461 NoContraction
               OpDecorate %462 NoContraction
               OpDecorate %466 NoContraction
               OpDecorate %479 NoContraction
               OpDecorate %482 NoContraction
               OpDecorate %483 NoContraction
               OpDecorate %487 NoContraction
               OpDecorate %488 NoContraction
               OpDecorate %492 NoContraction
               OpDecorate %493 NoContraction
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
   %u32_id_8 = OpConstant %u32_id 8
%_arr_64_u32_id_8 = OpTypeArray %64 %u32_id_8
%_ptr_UniformConstant__arr_64_u32_id_8 = OpTypePointer UniformConstant %_arr_64_u32_id_8
         %69 = OpTypeSampler
%_ptr_UniformConstant_69 = OpTypePointer UniformConstant %69
         %72 = OpTypeFunction %void_id
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
   %u32_id_7 = OpConstant %u32_id 7
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
 %cs_img50_0 = OpVariable %_ptr_UniformConstant__arr_64_u32_id_8 UniformConstant
%cs_sampinline_0xfff00000000036_0x2500000 = OpVariable %_ptr_UniformConstant_69 UniformConstant
         %73 = OpFunction %void_id None %72
         %74 = OpLabel
        %103 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
        %104 = OpLoad %u32_id %103
   %buf0_off = OpBitFieldUExtract %u32_id %104 %u32_id_0 %u32_id_8
%buf0_dword_off = OpShiftRightLogical %u32_id %buf0_off %u32_id_2
        %108 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
        %109 = OpLoad %u32_id %108
   %buf1_off = OpBitFieldUExtract %u32_id %109 %u32_id_8 %u32_id_8
%buf1_dword_off = OpShiftRightLogical %u32_id %buf1_off %u32_id_2
        %113 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_0
       %ud_0 = OpLoad %u32_id %113
        %115 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_1
       %ud_1 = OpLoad %u32_id %115
        %117 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_2
       %ud_2 = OpLoad %u32_id %117
        %120 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_3
       %ud_3 = OpLoad %u32_id %120
        %122 = OpLoad %u32vec3_id %gl_LocalInvocationID
        %123 = OpCompositeExtract %u32_id %122 0
        %124 = OpLoad %u32vec3_id %gl_LocalInvocationID
        %125 = OpCompositeExtract %u32_id %124 1
        %126 = OpLoad %u32vec3_id %gl_WorkGroupID
        %127 = OpCompositeExtract %u32_id %126 0
        %128 = OpLoad %u32vec3_id %gl_WorkGroupID
        %129 = OpCompositeExtract %u32_id %128 1
        %130 = OpShiftLeftLogical %u32_id %127 %u32_id_3
        %131 = OpShiftLeftLogical %u32_id %129 %u32_id_3
        %132 = OpIAdd %u32_id %130 %123
        %133 = OpIAdd %u32_id %131 %125
        %134 = OpCompositeConstruct %u32vec2_id %ud_2 %ud_3
        %137 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_63
        %138 = OpLoad %u32_id %137
        %140 = OpExtInst %u32_id %139 UMax %132 %133
        %141 = OpUGreaterThan %bool_id %138 %140
               OpSelectionMerge %100 None
               OpBranchConditional %141 %75 %100
         %75 = OpLabel
        %142 = OpConvertUToF %f32_id %132
        %143 = OpCompositeConstruct %u32vec2_id %ud_2 %ud_3
        %146 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_61
        %147 = OpLoad %u32_id %146
        %149 = OpFAdd %f32_id %f32_id_0_5 %142
        %151 = OpIMul %u32_id %147 %u32_id_12
        %153 = OpIAdd %u32_id %151 %u32_id_160
        %154 = OpShiftRightLogical %u32_id %153 %u32_id_2
        %155 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %156 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %157 = OpLoad %u32_id %156
        %158 = OpIAdd %u32_id %154 %u32_id_1
        %159 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %160 = OpLoad %u32_id %159
        %162 = OpIAdd %u32_id %151 %u32_id_232
        %163 = OpConvertUToF %f32_id %133
        %164 = OpShiftRightLogical %u32_id %162 %u32_id_2
        %165 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %166 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %167 = OpLoad %u32_id %166
        %168 = OpIAdd %u32_id %164 %u32_id_1
        %169 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %170 = OpLoad %u32_id %169
        %172 = OpIAdd %u32_id %151 %u32_id_304
        %174 = OpIAdd %u32_id %151 %u32_id_168
        %175 = OpFAdd %f32_id %f32_id_0_5 %163
        %176 = OpBitcast %f32_id %157
        %177 = OpFMul %f32_id %176 %149
        %178 = OpConvertUToF %f32_id %138
        %179 = OpShiftRightLogical %u32_id %172 %u32_id_2
        %180 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %181 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %182 = OpLoad %u32_id %181
        %183 = OpIAdd %u32_id %179 %u32_id_1
        %184 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %185 = OpLoad %u32_id %184
        %186 = OpShiftRightLogical %u32_id %174 %u32_id_2
        %187 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %188 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %189 = OpLoad %u32_id %188
        %191 = OpIAdd %u32_id %151 %u32_id_240
        %193 = OpFDiv %f32_id %f32_id_1 %178
        %194 = OpBitcast %f32_id %160
        %195 = OpFMul %f32_id %194 %149
        %196 = OpShiftRightLogical %u32_id %191 %u32_id_2
        %197 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %198 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %199 = OpLoad %u32_id %198
        %201 = OpIAdd %u32_id %151 %u32_id_312
        %202 = OpBitcast %f32_id %167
        %203 = OpFMul %f32_id %202 %175
        %204 = OpFAdd %f32_id %203 %177
        %205 = OpBitcast %f32_id %182
        %206 = OpFMul %f32_id %193 %204
        %207 = OpFAdd %f32_id %206 %205
        %208 = OpBitcast %f32_id %189
        %209 = OpFMul %f32_id %208 %149
        %210 = OpShiftRightLogical %u32_id %201 %u32_id_2
        %211 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %212 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %213 = OpLoad %u32_id %212
        %214 = OpBitcast %f32_id %170
        %215 = OpFMul %f32_id %214 %175
        %216 = OpFAdd %f32_id %215 %195
        %217 = OpFMul %f32_id %207 %207
        %218 = OpBitcast %f32_id %185
        %219 = OpFMul %f32_id %193 %216
        %220 = OpFAdd %f32_id %219 %218
        %221 = OpBitcast %f32_id %199
        %222 = OpFMul %f32_id %221 %175
        %223 = OpFAdd %f32_id %222 %209
        %224 = OpBitcast %f32_id %213
        %225 = OpFMul %f32_id %193 %223
        %226 = OpFAdd %f32_id %225 %224
        %227 = OpFMul %f32_id %220 %220
        %228 = OpFAdd %f32_id %227 %217
        %229 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %232 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_40
        %233 = OpLoad %u32_id %232
        %236 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_41
        %237 = OpLoad %u32_id %236
        %240 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_42
        %241 = OpLoad %u32_id %240
        %244 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_43
        %245 = OpLoad %u32_id %244
        %246 = OpFMul %f32_id %226 %226
        %247 = OpFAdd %f32_id %246 %228
        %248 = OpExtInst %f32_id %139 InverseSqrt %247
        %249 = OpFMul %f32_id %248 %207
        %250 = OpFMul %f32_id %248 %220
        %251 = OpFMul %f32_id %248 %226
        %252 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %255 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_44
        %256 = OpLoad %u32_id %255
        %257 = OpBitcast %f32_id %245
        %258 = OpBitcast %f32_id %233
        %259 = OpFMul %f32_id %257 %249
        %260 = OpFAdd %f32_id %259 %258
        %261 = OpBitcast %f32_id %245
        %262 = OpBitcast %f32_id %237
        %263 = OpFMul %f32_id %261 %250
        %264 = OpFAdd %f32_id %263 %262
        %265 = OpBitcast %f32_id %245
        %266 = OpBitcast %f32_id %241
        %267 = OpFMul %f32_id %265 %251
        %268 = OpFAdd %f32_id %267 %266
               OpBranch %76
         %76 = OpLabel
        %269 = OpPhi %u32_id %u32_id_0 %75 %501 %85
        %270 = OpPhi %u32_id %u32_id_0 %75 %502 %85
        %271 = OpPhi %u32_id %u32_id_0 %75 %503 %85
        %272 = OpPhi %u32_id %u32_id_0 %75 %504 %85
               OpLoopMerge %86 %85 None
               OpBranch %77
         %77 = OpLabel
        %273 = OpSLessThan %bool_id %272 %256
        %274 = OpLogicalNot %bool_id %273
               OpBranchConditional %274 %86 %78
         %78 = OpLabel
        %276 = OpShiftLeftLogical %u32_id %272 %u32_id_6
        %277 = OpIAdd %u32_id %276 %u32_id_8
        %278 = OpShiftRightLogical %u32_id %276 %u32_id_2
        %279 = OpIAdd %u32_id %278 %buf0_dword_off
        %280 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %279
        %281 = OpLoad %u32_id %280
        %282 = OpIAdd %u32_id %278 %u32_id_1
        %283 = OpIAdd %u32_id %282 %buf0_dword_off
        %284 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %283
        %285 = OpLoad %u32_id %284
        %286 = OpShiftRightLogical %u32_id %277 %u32_id_2
        %287 = OpIAdd %u32_id %286 %buf0_dword_off
        %288 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %287
        %289 = OpLoad %u32_id %288
        %290 = OpBitcast %f32_id %281
        %291 = OpFSub %f32_id %290 %260
        %292 = OpFMul %f32_id %249 %291
        %293 = OpBitcast %f32_id %285
        %294 = OpFSub %f32_id %293 %264
        %295 = OpBitcast %f32_id %289
        %296 = OpFSub %f32_id %295 %268
        %297 = OpFMul %f32_id %294 %250
        %298 = OpFAdd %f32_id %297 %292
        %299 = OpFMul %f32_id %296 %251
        %300 = OpFAdd %f32_id %299 %298
        %301 = OpFOrdGreaterThan %bool_id %300 %f32_id_0
        %302 = OpLogicalAnd %bool_id %141 %301
               OpSelectionMerge %84 None
               OpBranchConditional %302 %79 %84
         %79 = OpLabel
        %303 = OpFMul %f32_id %291 %291
        %304 = OpShiftLeftLogical %u32_id %272 %u32_id_6
        %305 = OpIAdd %u32_id %304 %u32_id_12
        %306 = OpShiftRightLogical %u32_id %305 %u32_id_2
        %307 = OpIAdd %u32_id %306 %buf0_dword_off
        %308 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %307
        %309 = OpLoad %u32_id %308
        %310 = OpFMul %f32_id %294 %294
        %311 = OpFAdd %f32_id %310 %303
        %312 = OpFMul %f32_id %296 %296
        %313 = OpFAdd %f32_id %312 %311
        %314 = OpBitcast %f32_id %309
        %315 = OpFMul %f32_id %314 %313
        %316 = OpFOrdLessThanEqual %bool_id %315 %f32_id_1
        %317 = OpLogicalAnd %bool_id %302 %316
               OpSelectionMerge %83 None
               OpBranchConditional %317 %80 %83
         %80 = OpLabel
        %318 = OpBitcast %f32_id %281
        %319 = OpBitcast %f32_id %233
        %320 = OpFSub %f32_id %318 %319
        %321 = OpBitcast %f32_id %285
        %322 = OpBitcast %f32_id %237
        %323 = OpFSub %f32_id %321 %322
        %324 = OpBitcast %f32_id %289
        %325 = OpBitcast %f32_id %241
        %326 = OpFSub %f32_id %324 %325
        %328 = OpFMul %f32_id %320 %f32_id_2
        %329 = OpFMul %f32_id %323 %f32_id_2
        %330 = OpFMul %f32_id %326 %f32_id_2
        %331 = OpExtInst %f32_id %139 FAbs %320
        %332 = OpExtInst %f32_id %139 FAbs %323
        %333 = OpExtInst %f32_id %139 FAbs %326
        %334 = OpFOrdGreaterThanEqual %bool_id %333 %332
        %335 = OpFOrdGreaterThanEqual %bool_id %333 %331
        %336 = OpLogicalAnd %bool_id %335 %334
        %337 = OpFOrdGreaterThanEqual %bool_id %332 %331
        %338 = OpSelect %f32_id %337 %329 %328
        %339 = OpSelect %f32_id %336 %330 %338
        %340 = OpExtInst %f32_id %139 FAbs %339
        %341 = OpFDiv %f32_id %f32_id_1 %340
        %342 = OpFOrdLessThan %bool_id %320 %f32_id_0
        %343 = OpFOrdLessThan %bool_id %326 %f32_id_0
        %344 = OpFNegate %f32_id %326
        %345 = OpSelect %f32_id %342 %326 %344
        %346 = OpFNegate %f32_id %320
        %347 = OpSelect %f32_id %343 %346 %320
        %348 = OpExtInst %f32_id %139 FAbs %320
        %349 = OpExtInst %f32_id %139 FAbs %323
        %350 = OpExtInst %f32_id %139 FAbs %326
        %351 = OpFOrdGreaterThanEqual %bool_id %350 %349
        %352 = OpFOrdGreaterThanEqual %bool_id %350 %348
        %353 = OpLogicalAnd %bool_id %352 %351
        %354 = OpFOrdGreaterThanEqual %bool_id %349 %348
        %355 = OpSelect %f32_id %354 %320 %345
        %356 = OpSelect %f32_id %353 %347 %355
        %357 = OpFOrdLessThan %bool_id %323 %f32_id_0
        %358 = OpFNegate %f32_id %323
        %359 = OpFNegate %f32_id %326
        %360 = OpSelect %f32_id %357 %359 %326
        %361 = OpExtInst %f32_id %139 FAbs %320
        %362 = OpExtInst %f32_id %139 FAbs %323
        %363 = OpExtInst %f32_id %139 FAbs %326
        %364 = OpFOrdGreaterThanEqual %bool_id %363 %362
        %365 = OpFOrdGreaterThanEqual %bool_id %363 %361
        %366 = OpLogicalAnd %bool_id %365 %364
        %367 = OpFOrdGreaterThanEqual %bool_id %362 %361
        %368 = OpSelect %f32_id %367 %360 %358
        %369 = OpSelect %f32_id %366 %358 %368
        %371 = OpExtInst %f32_id %139 Fma %356 %341 %f32_id_1_5
        %372 = OpExtInst %f32_id %139 Fma %369 %341 %f32_id_1_5
        %373 = OpFOrdLessThan %bool_id %320 %f32_id_0
        %374 = OpFOrdLessThan %bool_id %323 %f32_id_0
        %375 = OpFOrdLessThan %bool_id %326 %f32_id_0
        %376 = OpSelect %f32_id %373 %f32_id_1 %f32_id_0
        %378 = OpSelect %f32_id %374 %f32_id_3 %f32_id_2
        %381 = OpSelect %f32_id %375 %f32_id_5 %f32_id_4
        %382 = OpExtInst %f32_id %139 FAbs %320
        %383 = OpExtInst %f32_id %139 FAbs %323
        %384 = OpExtInst %f32_id %139 FAbs %326
        %385 = OpFOrdGreaterThanEqual %bool_id %384 %383
        %386 = OpFOrdGreaterThanEqual %bool_id %384 %382
        %387 = OpLogicalAnd %bool_id %386 %385
        %388 = OpFOrdGreaterThanEqual %bool_id %383 %382
        %389 = OpSelect %f32_id %388 %378 %376
        %390 = OpSelect %f32_id %387 %381 %389
        %391 = OpFSub %f32_id %371 %f32_id_1
        %392 = OpFSub %f32_id %372 %f32_id_1
        %394 = OpFDiv %f32_id %390 %f32_id_8
        %395 = OpExtInst %f32_id %139 Floor %394
        %397 = OpExtInst %f32_id %139 Fma %395 %f32_id_n2 %390
        %398 = OpCompositeConstruct %f32vec3_id %391 %392 %397
        %399 = OpLoad %58 %cs_img32
        %400 = OpLoad %69 %cs_sampinline_0xfff00000000036_0x2500000
        %401 = OpSampledImage %61 %399 %400
        %402 = OpImageSampleExplicitLod %f32vec4_id %401 %398 Lod %f32_id_0
        %403 = OpCompositeExtract %f32_id %402 0
        %404 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %407 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_46
        %408 = OpLoad %u32_id %407
        %411 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_47
        %412 = OpLoad %u32_id %411
        %413 = OpExtInst %f32_id %139 FAbs %326
        %414 = OpExtInst %f32_id %139 FAbs %320
        %415 = OpExtInst %f32_id %139 FAbs %323
        %416 = OpExtInst %f32_id %139 FMax %414 %415
        %417 = OpExtInst %f32_id %139 FMax %413 %416
        %418 = OpFMul %f32_id %320 %320
        %419 = OpFMul %f32_id %323 %323
        %420 = OpFAdd %f32_id %419 %418
        %421 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %424 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_48
        %425 = OpLoad %u32_id %424
        %426 = OpFMul %f32_id %326 %326
        %427 = OpFAdd %f32_id %426 %420
        %428 = OpExtInst %f32_id %139 Sqrt %427
        %429 = OpBitcast %f32_id %408
        %430 = OpBitcast %f32_id %412
        %431 = OpFMul %f32_id %429 %403
        %432 = OpFAdd %f32_id %431 %430
        %433 = OpFMul %f32_id %432 %417
        %434 = OpFDiv %f32_id %f32_id_1 %433
        %435 = OpBitcast %f32_id %425
        %436 = OpFMul %f32_id %434 %428
        %437 = OpFAdd %f32_id %436 %435
        %438 = OpFOrdGreaterThanEqual %bool_id %428 %437
        %439 = OpLogicalNot %bool_id %438
               OpSelectionMerge %82 None
               OpBranchConditional %439 %81 %82
         %81 = OpLabel
        %440 = OpExtInst %f32_id %139 InverseSqrt %313
        %441 = OpCompositeConstruct %u32vec2_id %ud_2 %ud_3
        %443 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_58
        %444 = OpLoad %u32_id %443
        %447 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_59
        %448 = OpLoad %u32_id %447
        %449 = OpFMul %f32_id %440 %300
        %450 = OpShiftLeftLogical %u32_id %272 %u32_id_6
        %451 = OpBitcast %f32_id %444
        %452 = OpBitcast %f32_id %448
        %453 = OpFMul %f32_id %451 %449
        %454 = OpFAdd %f32_id %453 %452
        %455 = OpFMul %f32_id %454 %454
        %456 = OpFNegate %f32_id %315
        %457 = OpFMul %f32_id %315 %456
        %458 = OpFAdd %f32_id %457 %f32_id_1
        %459 = OpExtInst %f32_id %139 FClamp %458 %f32_id_0 %f32_id_1
        %460 = OpIAdd %u32_id %450 %u32_id_48
        %461 = OpFMul %f32_id %455 %313
        %462 = OpFMul %f32_id %459 %459
        %464 = OpIAdd %u32_id %450 %u32_id_56
        %465 = OpFDiv %f32_id %f32_id_1 %461
        %466 = OpFMul %f32_id %462 %449
        %467 = OpShiftRightLogical %u32_id %460 %u32_id_2
        %468 = OpIAdd %u32_id %467 %buf0_dword_off
        %469 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %468
        %470 = OpLoad %u32_id %469
        %471 = OpIAdd %u32_id %467 %u32_id_1
        %472 = OpIAdd %u32_id %471 %buf0_dword_off
        %473 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %472
        %474 = OpLoad %u32_id %473
        %475 = OpShiftRightLogical %u32_id %464 %u32_id_2
        %476 = OpIAdd %u32_id %475 %buf0_dword_off
        %477 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %476
        %478 = OpLoad %u32_id %477
        %479 = OpFMul %f32_id %466 %465
        %480 = OpBitcast %f32_id %470
        %481 = OpBitcast %f32_id %269
        %482 = OpFMul %f32_id %480 %479
        %483 = OpFAdd %f32_id %482 %481
        %484 = OpBitcast %u32_id %483
        %485 = OpBitcast %f32_id %474
        %486 = OpBitcast %f32_id %271
        %487 = OpFMul %f32_id %485 %479
        %488 = OpFAdd %f32_id %487 %486
        %489 = OpBitcast %u32_id %488
        %490 = OpBitcast %f32_id %478
        %491 = OpBitcast %f32_id %270
        %492 = OpFMul %f32_id %490 %479
        %493 = OpFAdd %f32_id %492 %491
        %494 = OpBitcast %u32_id %493
               OpBranch %82
         %82 = OpLabel
        %495 = OpPhi %u32_id %484 %81 %269 %80
        %496 = OpPhi %u32_id %494 %81 %270 %80
        %497 = OpPhi %u32_id %489 %81 %271 %80
               OpBranch %83
         %83 = OpLabel
        %498 = OpPhi %u32_id %495 %82 %269 %79
        %499 = OpPhi %u32_id %496 %82 %270 %79
        %500 = OpPhi %u32_id %497 %82 %271 %79
               OpBranch %84
         %84 = OpLabel
        %501 = OpPhi %u32_id %498 %83 %269 %78
        %502 = OpPhi %u32_id %499 %83 %270 %78
        %503 = OpPhi %u32_id %500 %83 %271 %78
        %504 = OpIAdd %u32_id %272 %u32_id_1
               OpBranch %85
         %85 = OpLabel
               OpBranchConditional %true %76 %86
         %86 = OpLabel
        %505 = OpPhi %u32_id %269 %77 %501 %85
        %506 = OpPhi %u32_id %270 %77 %502 %85
        %507 = OpPhi %u32_id %271 %77 %503 %85
        %508 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %511 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_45
        %512 = OpLoad %u32_id %511
               OpBranch %87
         %87 = OpLabel
        %513 = OpPhi %u32_id %505 %86 %872 %98
        %514 = OpPhi %u32_id %506 %86 %873 %98
        %515 = OpPhi %u32_id %507 %86 %874 %98
        %516 = OpPhi %u32_id %u32_id_0 %86 %875 %98
               OpLoopMerge %99 %98 None
               OpBranch %88
         %88 = OpLabel
        %517 = OpSLessThan %bool_id %516 %512
        %518 = OpLogicalNot %bool_id %517
               OpBranchConditional %518 %99 %89
         %89 = OpLabel
        %520 = OpShiftLeftLogical %u32_id %516 %u32_id_7
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
        %531 = OpFSub %f32_id %530 %260
        %532 = OpShiftRightLogical %u32_id %529 %u32_id_2
        %533 = OpIAdd %u32_id %532 %buf1_dword_off
        %534 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %533
        %535 = OpLoad %u32_id %534
        %536 = OpFMul %f32_id %249 %531
        %537 = OpBitcast %f32_id %528
        %538 = OpFSub %f32_id %537 %264
        %539 = OpBitcast %f32_id %535
        %540 = OpFSub %f32_id %539 %268
        %541 = OpFMul %f32_id %538 %250
        %542 = OpFAdd %f32_id %541 %536
        %543 = OpFMul %f32_id %540 %251
        %544 = OpFAdd %f32_id %543 %542
        %545 = OpFOrdGreaterThan %bool_id %544 %f32_id_0
        %546 = OpLogicalAnd %bool_id %141 %545
               OpSelectionMerge %97 None
               OpBranchConditional %546 %90 %97
         %90 = OpLabel
        %547 = OpFMul %f32_id %531 %531
        %548 = OpShiftLeftLogical %u32_id %516 %u32_id_7
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
        %562 = OpShiftLeftLogical %u32_id %516 %u32_id_7
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
        %635 = OpFMul %f32_id %633 %260
        %636 = OpFAdd %f32_id %635 %634
        %637 = OpBitcast %f32_id %576
        %638 = OpBitcast %f32_id %627
        %639 = OpFMul %f32_id %637 %260
        %640 = OpFAdd %f32_id %639 %638
        %641 = OpBitcast %f32_id %597
        %642 = OpFMul %f32_id %641 %264
        %643 = OpFAdd %f32_id %642 %636
        %644 = OpBitcast %f32_id %593
        %645 = OpFMul %f32_id %644 %264
        %646 = OpFAdd %f32_id %645 %640
        %647 = OpBitcast %f32_id %614
        %648 = OpFMul %f32_id %647 %268
        %649 = OpFAdd %f32_id %648 %643
        %650 = OpBitcast %f32_id %610
        %651 = OpFMul %f32_id %650 %268
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
        %660 = OpBitcast %f32_id %233
        %661 = OpFSub %f32_id %659 %660
        %662 = OpBitcast %f32_id %528
        %663 = OpBitcast %f32_id %237
        %664 = OpFSub %f32_id %662 %663
        %665 = OpBitcast %f32_id %535
        %666 = OpBitcast %f32_id %241
        %667 = OpFSub %f32_id %665 %666
        %668 = OpFMul %f32_id %661 %f32_id_2
        %669 = OpFMul %f32_id %664 %f32_id_2
        %670 = OpFMul %f32_id %667 %f32_id_2
        %671 = OpExtInst %f32_id %139 FAbs %661
        %672 = OpExtInst %f32_id %139 FAbs %664
        %673 = OpExtInst %f32_id %139 FAbs %667
        %674 = OpFOrdGreaterThanEqual %bool_id %673 %672
        %675 = OpFOrdGreaterThanEqual %bool_id %673 %671
        %676 = OpLogicalAnd %bool_id %675 %674
        %677 = OpFOrdGreaterThanEqual %bool_id %672 %671
        %678 = OpSelect %f32_id %677 %669 %668
        %679 = OpSelect %f32_id %676 %670 %678
        %680 = OpExtInst %f32_id %139 FAbs %679
        %681 = OpFDiv %f32_id %f32_id_1 %680
        %682 = OpFOrdLessThan %bool_id %661 %f32_id_0
        %683 = OpFOrdLessThan %bool_id %667 %f32_id_0
        %684 = OpFNegate %f32_id %667
        %685 = OpSelect %f32_id %682 %667 %684
        %686 = OpFNegate %f32_id %661
        %687 = OpSelect %f32_id %683 %686 %661
        %688 = OpExtInst %f32_id %139 FAbs %661
        %689 = OpExtInst %f32_id %139 FAbs %664
        %690 = OpExtInst %f32_id %139 FAbs %667
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
        %701 = OpExtInst %f32_id %139 FAbs %661
        %702 = OpExtInst %f32_id %139 FAbs %664
        %703 = OpExtInst %f32_id %139 FAbs %667
        %704 = OpFOrdGreaterThanEqual %bool_id %703 %702
        %705 = OpFOrdGreaterThanEqual %bool_id %703 %701
        %706 = OpLogicalAnd %bool_id %705 %704
        %707 = OpFOrdGreaterThanEqual %bool_id %702 %701
        %708 = OpSelect %f32_id %707 %700 %698
        %709 = OpSelect %f32_id %706 %698 %708
        %710 = OpExtInst %f32_id %139 Fma %696 %681 %f32_id_1_5
        %711 = OpExtInst %f32_id %139 Fma %709 %681 %f32_id_1_5
        %712 = OpFOrdLessThan %bool_id %661 %f32_id_0
        %713 = OpFOrdLessThan %bool_id %664 %f32_id_0
        %714 = OpFOrdLessThan %bool_id %667 %f32_id_0
        %715 = OpSelect %f32_id %712 %f32_id_1 %f32_id_0
        %716 = OpSelect %f32_id %713 %f32_id_3 %f32_id_2
        %717 = OpSelect %f32_id %714 %f32_id_5 %f32_id_4
        %718 = OpExtInst %f32_id %139 FAbs %661
        %719 = OpExtInst %f32_id %139 FAbs %664
        %720 = OpExtInst %f32_id %139 FAbs %667
        %721 = OpFOrdGreaterThanEqual %bool_id %720 %719
        %722 = OpFOrdGreaterThanEqual %bool_id %720 %718
        %723 = OpLogicalAnd %bool_id %722 %721
        %724 = OpFOrdGreaterThanEqual %bool_id %719 %718
        %725 = OpSelect %f32_id %724 %716 %715
        %726 = OpSelect %f32_id %723 %717 %725
        %727 = OpFSub %f32_id %710 %f32_id_1
        %728 = OpFSub %f32_id %711 %f32_id_1
        %729 = OpFDiv %f32_id %726 %f32_id_8
        %730 = OpExtInst %f32_id %139 Floor %729
        %731 = OpExtInst %f32_id %139 Fma %730 %f32_id_n2 %726
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
        %743 = OpExtInst %f32_id %139 FAbs %667
        %744 = OpExtInst %f32_id %139 FAbs %661
        %745 = OpExtInst %f32_id %139 FAbs %664
        %746 = OpExtInst %f32_id %139 FMax %744 %745
        %747 = OpExtInst %f32_id %139 FMax %743 %746
        %748 = OpFMul %f32_id %661 %661
        %749 = OpFMul %f32_id %664 %664
        %750 = OpFAdd %f32_id %749 %748
        %751 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %752 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_48
        %753 = OpLoad %u32_id %752
        %754 = OpFMul %f32_id %667 %667
        %755 = OpFAdd %f32_id %754 %750
        %756 = OpExtInst %f32_id %139 Sqrt %755
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
        %771 = OpExtInst %f32_id %139 FClamp %770 %f32_id_0 %f32_id_1
        %772 = OpShiftLeftLogical %u32_id %516 %u32_id_7
        %773 = OpBitcast %f32_id %572
        %774 = OpBitcast %f32_id %622
        %775 = OpFMul %f32_id %773 %260
        %776 = OpFAdd %f32_id %775 %774
        %777 = OpBitcast %f32_id %589
        %778 = OpFMul %f32_id %777 %264
        %779 = OpFAdd %f32_id %778 %776
        %780 = OpFDiv %f32_id %f32_id_1 %649
        %781 = OpFMul %f32_id %780 %f32_id_0_5
        %782 = OpBitcast %f32_id %605
        %783 = OpFMul %f32_id %782 %268
        %784 = OpFAdd %f32_id %783 %779
        %785 = OpCompositeConstruct %u32vec2_id %ud_2 %ud_3
        %786 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_58
        %787 = OpLoad %u32_id %786
        %788 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_59
        %789 = OpLoad %u32_id %788
        %790 = OpExtInst %f32_id %139 InverseSqrt %557
        %791 = OpFMul %f32_id %771 %771
        %792 = OpBitcast %f32_id %568
        %793 = OpBitcast %f32_id %618
        %794 = OpFMul %f32_id %792 %260
        %795 = OpFAdd %f32_id %794 %793
        %797 = OpIAdd %u32_id %772 %u32_id_60
        %798 = OpShiftRightLogical %u32_id %797 %u32_id_2
        %799 = OpIAdd %u32_id %798 %buf1_dword_off
        %800 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %799
        %801 = OpLoad %u32_id %800
        %802 = OpBitcast %f32_id %584
        %803 = OpFMul %f32_id %802 %264
        %804 = OpFAdd %f32_id %803 %795
        %805 = OpBitcast %f32_id %601
        %806 = OpFMul %f32_id %805 %268
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
        %851 = OpBitcast %f32_id %513
        %852 = OpFMul %f32_id %844 %846
        %853 = OpFAdd %f32_id %852 %851
        %854 = OpBitcast %u32_id %853
        %855 = OpBitcast %f32_id %514
        %856 = OpFMul %f32_id %844 %850
        %857 = OpFAdd %f32_id %856 %855
        %858 = OpBitcast %u32_id %857
        %859 = OpBitcast %f32_id %515
        %860 = OpFMul %f32_id %844 %848
        %861 = OpFAdd %f32_id %860 %859
        %862 = OpBitcast %u32_id %861
               OpBranch %94
         %94 = OpLabel
        %863 = OpPhi %u32_id %854 %93 %513 %92
        %864 = OpPhi %u32_id %858 %93 %514 %92
        %865 = OpPhi %u32_id %862 %93 %515 %92
               OpBranch %95
         %95 = OpLabel
        %866 = OpPhi %u32_id %863 %94 %513 %91
        %867 = OpPhi %u32_id %864 %94 %514 %91
        %868 = OpPhi %u32_id %865 %94 %515 %91
               OpBranch %96
         %96 = OpLabel
        %869 = OpPhi %u32_id %866 %95 %513 %90
        %870 = OpPhi %u32_id %867 %95 %514 %90
        %871 = OpPhi %u32_id %868 %95 %515 %90
               OpBranch %97
         %97 = OpLabel
        %872 = OpPhi %u32_id %869 %96 %513 %89
        %873 = OpPhi %u32_id %870 %96 %514 %89
        %874 = OpPhi %u32_id %871 %96 %515 %89
        %875 = OpIAdd %u32_id %516 %u32_id_1
               OpBranch %98
         %98 = OpLabel
               OpBranchConditional %true %87 %99
         %99 = OpLabel
        %876 = OpPhi %u32_id %515 %88 %874 %98
        %877 = OpPhi %u32_id %514 %88 %873 %98
        %878 = OpPhi %u32_id %513 %88 %872 %98
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
        %892 = OpIAdd %u32_id %147 %891
        %893 = OpCompositeConstruct %u32vec3_id %132 %133 %892
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
        %912 = OpCompositeConstruct %u32vec3_id %132 %133 %892
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
