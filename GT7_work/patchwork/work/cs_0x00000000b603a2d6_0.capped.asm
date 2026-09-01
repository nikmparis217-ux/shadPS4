; SPIR-V
; Version: 1.6
; Generator: Khronos; 0
; Bound: 1359
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
        %369 = OpExtInstImport "GLSL.std.450"
               OpMemoryModel Logical GLSL450
               OpEntryPoint GLCompute %71 "main" %push_data %gl_WorkGroupID %gl_LocalInvocationID %shared_mem_u32 %ssbo_1 %ssbo_2 %ssbo_3 %ssbo_4 %ssbo_5 %ssbo_6 %ssbo_7 %ssbo_8 %gds_buffer %srt_flatbuf
               OpExecutionMode %71 LocalSize 32 1 1
               OpExecutionMode %71 SignedZeroInfNanPreserve 32
          %1 = OpString "0xb603a2d6"
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
               OpName %shared_mem_u32 "shared_mem_u32"
               OpMemberName %_struct_57 0 "data"
               OpName %ssbo_1 "ssbo_1"
               OpName %ssbo_2 "ssbo_2"
               OpName %ssbo_3 "ssbo_3"
               OpName %ssbo_4 "ssbo_4"
               OpName %ssbo_5 "ssbo_5"
               OpName %ssbo_6 "ssbo_6"
               OpName %ssbo_7 "ssbo_7"
               OpName %ssbo_8 "ssbo_8"
               OpName %gds_buffer "gds_buffer"
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
               OpName %buf7_off "buf7_off"
               OpName %buf7_dword_off "buf7_dword_off"
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
               OpDecorate %_struct_57 Block
               OpMemberDecorate %_struct_57 0 Offset 0
               OpDecorate %ssbo_1 Binding 0
               OpDecorate %ssbo_1 DescriptorSet 0
               OpDecorate %ssbo_1 NonWritable
               OpDecorate %ssbo_2 Binding 1
               OpDecorate %ssbo_2 DescriptorSet 0
               OpDecorate %ssbo_3 Binding 2
               OpDecorate %ssbo_3 DescriptorSet 0
               OpDecorate %ssbo_4 Binding 3
               OpDecorate %ssbo_4 DescriptorSet 0
               OpDecorate %ssbo_5 Binding 4
               OpDecorate %ssbo_5 DescriptorSet 0
               OpDecorate %ssbo_6 Binding 5
               OpDecorate %ssbo_6 DescriptorSet 0
               OpDecorate %ssbo_7 Binding 6
               OpDecorate %ssbo_7 DescriptorSet 0
               OpDecorate %ssbo_8 Binding 7
               OpDecorate %ssbo_8 DescriptorSet 0
               OpDecorate %gds_buffer Binding 8
               OpDecorate %gds_buffer DescriptorSet 0
               OpDecorate %srt_flatbuf Binding 9
               OpDecorate %srt_flatbuf DescriptorSet 0
               OpDecorate %srt_flatbuf NonWritable
               OpDecorate %326 NoContraction
               OpDecorate %328 NoContraction
               OpDecorate %329 NoContraction
               OpDecorate %331 NoContraction
               OpDecorate %380 NoContraction
               OpDecorate %389 NoContraction
               OpDecorate %438 NoContraction
               OpDecorate %445 NoContraction
               OpDecorate %495 NoContraction
               OpDecorate %496 NoContraction
               OpDecorate %506 NoContraction
               OpDecorate %510 NoContraction
               OpDecorate %512 NoContraction
               OpDecorate %525 NoContraction
               OpDecorate %539 NoContraction
               OpDecorate %542 NoContraction
               OpDecorate %545 NoContraction
               OpDecorate %547 NoContraction
               OpDecorate %548 NoContraction
               OpDecorate %549 NoContraction
               OpDecorate %550 NoContraction
               OpDecorate %556 NoContraction
               OpDecorate %559 NoContraction
               OpDecorate %560 NoContraction
               OpDecorate %561 NoContraction
               OpDecorate %563 NoContraction
               OpDecorate %564 NoContraction
               OpDecorate %565 NoContraction
               OpDecorate %568 NoContraction
               OpDecorate %571 NoContraction
               OpDecorate %572 NoContraction
               OpDecorate %576 NoContraction
               OpDecorate %577 NoContraction
               OpDecorate %580 NoContraction
               OpDecorate %583 NoContraction
               OpDecorate %584 NoContraction
               OpDecorate %586 NoContraction
               OpDecorate %590 NoContraction
               OpDecorate %591 NoContraction
               OpDecorate %594 NoContraction
               OpDecorate %596 NoContraction
               OpDecorate %597 NoContraction
               OpDecorate %600 NoContraction
               OpDecorate %601 NoContraction
               OpDecorate %1258 NoContraction
               OpDecorate %1260 NoContraction
               OpDecorate %1263 NoContraction
               OpDecorate %1267 NoContraction
               OpDecorate %1269 NoContraction
               OpDecorate %1280 NoContraction
               OpDecorate %1282 NoContraction
               OpDecorate %1285 NoContraction
               OpDecorate %1289 NoContraction
               OpDecorate %1291 NoContraction
               OpDecorate %1300 NoContraction
               OpDecorate %1302 NoContraction
               OpDecorate %1304 NoContraction
               OpDecorate %1306 NoContraction
               OpDecorate %1325 NoContraction
               OpDecorate %1330 NoContraction
               OpDecorate %1331 NoContraction
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
 %u32_id_128 = OpConstant %u32_id 128
%_arr_u32_id_u32_id_128 = OpTypeArray %u32_id %u32_id_128
%_ptr_Workgroup__arr_u32_id_u32_id_128 = OpTypePointer Workgroup %_arr_u32_id_u32_id_128
%_ptr_Workgroup_u32_id = OpTypePointer Workgroup %u32_id
%u32_id_16368 = OpConstant %u32_id 16368
%_runtimearr_u32_id = OpTypeRuntimeArray %u32_id
 %_struct_57 = OpTypeStruct %_runtimearr_u32_id
%_ptr_StorageBuffer__struct_57 = OpTypePointer StorageBuffer %_struct_57
%_ptr_StorageBuffer_u32_id = OpTypePointer StorageBuffer %u32_id
         %70 = OpTypeFunction %void_id
   %u32_id_8 = OpConstant %u32_id 8
%_ptr_PushConstant_u32_id = OpTypePointer PushConstant %u32_id
   %u32_id_2 = OpConstant %u32_id 2
  %u32_id_16 = OpConstant %u32_id 16
  %u32_id_24 = OpConstant %u32_id 24
   %u32_id_4 = OpConstant %u32_id 4
   %u32_id_3 = OpConstant %u32_id 3
 %u32_id_300 = OpConstant %u32_id 300
  %u32_id_12 = OpConstant %u32_id 12
  %u32_id_48 = OpConstant %u32_id 48
  %u32_id_49 = OpConstant %u32_id 49
  %u32_id_50 = OpConstant %u32_id 50
  %u32_id_51 = OpConstant %u32_id 51
  %u32_id_28 = OpConstant %u32_id 28
   %u32_id_5 = OpConstant %u32_id 5
   %f32_id_1 = OpConstant %f32_id 1
  %u32_id_29 = OpConstant %u32_id 29
  %u32_id_45 = OpConstant %u32_id 45
  %u32_id_44 = OpConstant %u32_id 44
 %f32_id_0_5 = OpConstant %f32_id 0.5
%f32_id_0x1pn148 = OpConstant %f32_id 0x1p-148
%f32_id_0x1pn149 = OpConstant %f32_id 0x1p-149
 %f32_id_1_5 = OpConstant %f32_id 1.5
%f32_id_0x1_8pn148 = OpConstant %f32_id 0x1.8p-148
  %u64_id_63 = OpConstant %u64_id 63
  %u32_id_31 = OpConstant %u32_id 31
  %u32_id_47 = OpConstant %u32_id 47
%u32_id_10000 = OpConstant %u32_id 10000
%f32_id_0_125 = OpConstant %f32_id 0.125
  %u32_id_17 = OpConstant %u32_id 17
  %u32_id_18 = OpConstant %u32_id 18
  %u32_id_19 = OpConstant %u32_id 19
  %u32_id_40 = OpConstant %u32_id 40
  %u32_id_25 = OpConstant %u32_id 25
  %u32_id_41 = OpConstant %u32_id 41
  %u32_id_26 = OpConstant %u32_id 26
  %u32_id_42 = OpConstant %u32_id 42
  %u32_id_27 = OpConstant %u32_id 27
  %u32_id_43 = OpConstant %u32_id 43
%u32_id_40000 = OpConstant %u32_id 40000
 %u32_id_255 = OpConstant %u32_id 255
 %u32_id_256 = OpConstant %u32_id 256
  %u32_id_13 = OpConstant %u32_id 13
  %u32_id_14 = OpConstant %u32_id 14
  %u32_id_30 = OpConstant %u32_id 30
  %u32_id_15 = OpConstant %u32_id 15
  %u32_id_20 = OpConstant %u32_id 20
  %u32_id_36 = OpConstant %u32_id 36
  %u32_id_21 = OpConstant %u32_id 21
  %u32_id_37 = OpConstant %u32_id 37
  %u32_id_22 = OpConstant %u32_id 22
  %u32_id_38 = OpConstant %u32_id 38
  %u32_id_23 = OpConstant %u32_id 23
  %u32_id_39 = OpConstant %u32_id 39
   %u32_id_9 = OpConstant %u32_id 9
  %u32_id_10 = OpConstant %u32_id 10
  %u32_id_11 = OpConstant %u32_id 11
%f32_id_0x1_4pn147 = OpConstant %f32_id 0x1.4p-147
  %u32_id_32 = OpConstant %u32_id 32
  %u32_id_33 = OpConstant %u32_id 33
  %u32_id_34 = OpConstant %u32_id 34
  %u32_id_35 = OpConstant %u32_id 35
%u32_id_1000 = OpConstant %u32_id 1000
   %u32_id_6 = OpConstant %u32_id 6
   %u32_id_7 = OpConstant %u32_id 7
  %u32_id_64 = OpConstant %u32_id 64
%u32_id_4294967295 = OpConstant %u32_id 4294967295
  %u32_id_46 = OpConstant %u32_id 46
 %u32_id_352 = OpConstant %u32_id 352
  %push_data = OpVariable %_ptr_PushConstant_AuxData PushConstant
%gl_WorkGroupID = OpVariable %_ptr_Input_u32vec3_id Input
%gl_LocalInvocationID = OpVariable %_ptr_Input_u32vec3_id Input
%shared_mem_u32 = OpVariable %_ptr_Workgroup__arr_u32_id_u32_id_128 Workgroup
     %ssbo_1 = OpVariable %_ptr_StorageBuffer__struct_57 StorageBuffer
     %ssbo_2 = OpVariable %_ptr_StorageBuffer__struct_57 StorageBuffer
     %ssbo_3 = OpVariable %_ptr_StorageBuffer__struct_57 StorageBuffer
     %ssbo_4 = OpVariable %_ptr_StorageBuffer__struct_57 StorageBuffer
     %ssbo_5 = OpVariable %_ptr_StorageBuffer__struct_57 StorageBuffer
     %ssbo_6 = OpVariable %_ptr_StorageBuffer__struct_57 StorageBuffer
     %ssbo_7 = OpVariable %_ptr_StorageBuffer__struct_57 StorageBuffer
     %ssbo_8 = OpVariable %_ptr_StorageBuffer__struct_57 StorageBuffer
 %gds_buffer = OpVariable %_ptr_StorageBuffer__struct_57 StorageBuffer
%srt_flatbuf = OpVariable %_ptr_StorageBuffer__struct_57 StorageBuffer
         %71 = OpFunction %void_id None %70
         %72 = OpLabel
        %168 = OpUndef %u32_id
        %169 = OpUndef %u32_id
        %170 = OpUndef %u32_id
        %171 = OpUndef %u32_id
        %172 = OpUndef %u32_id
        %175 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
        %176 = OpLoad %u32_id %175
   %buf0_off = OpBitFieldUExtract %u32_id %176 %u32_id_0 %u32_id_8
%buf0_dword_off = OpShiftRightLogical %u32_id %buf0_off %u32_id_2
        %180 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
        %181 = OpLoad %u32_id %180
   %buf1_off = OpBitFieldUExtract %u32_id %181 %u32_id_8 %u32_id_8
%buf1_dword_off = OpShiftRightLogical %u32_id %buf1_off %u32_id_2
        %184 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
        %185 = OpLoad %u32_id %184
   %buf2_off = OpBitFieldUExtract %u32_id %185 %u32_id_16 %u32_id_8
%buf2_dword_off = OpShiftRightLogical %u32_id %buf2_off %u32_id_2
        %189 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
        %190 = OpLoad %u32_id %189
   %buf3_off = OpBitFieldUExtract %u32_id %190 %u32_id_24 %u32_id_8
%buf3_dword_off = OpShiftRightLogical %u32_id %buf3_off %u32_id_2
        %194 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_1
        %195 = OpLoad %u32_id %194
   %buf4_off = OpBitFieldUExtract %u32_id %195 %u32_id_0 %u32_id_8
%buf4_dword_off = OpShiftRightLogical %u32_id %buf4_off %u32_id_2
        %198 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_1
        %199 = OpLoad %u32_id %198
   %buf5_off = OpBitFieldUExtract %u32_id %199 %u32_id_8 %u32_id_8
%buf5_dword_off = OpShiftRightLogical %u32_id %buf5_off %u32_id_2
        %202 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_1
        %203 = OpLoad %u32_id %202
   %buf6_off = OpBitFieldUExtract %u32_id %203 %u32_id_16 %u32_id_8
%buf6_dword_off = OpShiftRightLogical %u32_id %buf6_off %u32_id_2
        %206 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_1
        %207 = OpLoad %u32_id %206
   %buf7_off = OpBitFieldUExtract %u32_id %207 %u32_id_24 %u32_id_8
%buf7_dword_off = OpShiftRightLogical %u32_id %buf7_off %u32_id_2
        %211 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_0
       %ud_0 = OpLoad %u32_id %211
        %213 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_1
       %ud_1 = OpLoad %u32_id %213
        %215 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_2
       %ud_2 = OpLoad %u32_id %215
        %218 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_3
       %ud_3 = OpLoad %u32_id %218
        %220 = OpLoad %u32vec3_id %gl_LocalInvocationID
        %221 = OpCompositeExtract %u32_id %220 0
        %222 = OpLoad %u32vec3_id %gl_WorkGroupID
        %223 = OpCompositeExtract %u32_id %222 0
        %225 = OpUGreaterThanEqual %bool_id %223 %u32_id_300
        %226 = OpLogicalNot %bool_id %225
               OpSelectionMerge %166 None
               OpBranchConditional %226 %73 %166
         %73 = OpLabel
        %228 = OpUGreaterThan %bool_id %u32_id_12 %221
               OpSelectionMerge %75 None
               OpBranchConditional %228 %74 %75
         %74 = OpLabel
        %229 = OpShiftLeftLogical %u32_id %221 %u32_id_2
        %230 = OpIMul %u32_id %223 %u32_id_12
        %231 = OpCompositeConstruct %u32vec2_id %ud_2 %ud_3
        %233 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_48
        %234 = OpLoad %u32_id %233
        %236 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_49
        %237 = OpLoad %u32_id %236
        %239 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_50
        %240 = OpLoad %u32_id %239
        %242 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_51
        %243 = OpLoad %u32_id %242
        %244 = OpIAdd %u32_id %230 %221
        %245 = OpIAdd %u32_id %244 %buf0_dword_off
        %246 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %245
        %247 = OpLoad %u32_id %246
        %248 = OpShiftRightLogical %u32_id %229 %u32_id_2
        %249 = OpAccessChain %_ptr_Workgroup_u32_id %shared_mem_u32 %248
               OpStore %249 %247
               OpBranch %75
         %75 = OpLabel
        %250 = OpPhi %u32_id %243 %74 %168 %73
        %251 = OpPhi %u32_id %240 %74 %169 %73
        %252 = OpPhi %u32_id %234 %74 %170 %73
        %253 = OpPhi %u32_id %237 %74 %172 %73
        %254 = OpShiftRightLogical %u32_id %221 %u32_id_2
        %255 = OpBitwiseAnd %u32_id %u32_id_3 %221
        %256 = OpIAdd %u32_id %254 %u32_id_1
        %257 = OpIEqual %bool_id %u32_id_3 %255
        %259 = OpBitwiseAnd %u32_id %u32_id_28 %221
               OpBranch %76
         %76 = OpLabel
        %260 = OpPhi %u32_id %255 %75 %1117 %164
        %261 = OpPhi %bool_id %257 %75 %1118 %164
        %262 = OpPhi %u32_id %250 %75 %1354 %164
        %263 = OpPhi %u32_id %251 %75 %1355 %164
        %264 = OpPhi %u32_id %252 %75 %1211 %164
        %265 = OpPhi %u32_id %259 %75 %1123 %164
        %266 = OpPhi %u32_id %256 %75 %1126 %164
        %267 = OpPhi %u32_id %254 %75 %1127 %164
        %268 = OpPhi %u32_id %253 %75 %1121 %164
        %269 = OpPhi %u32_id %u32_id_352 %75 %1130 %164
        %270 = OpPhi %u32_id %u32_id_32 %75 %1356 %164
        %271 = OpPhi %u32_id %ud_0 %75 %1124 %164
        %272 = OpPhi %u32_id %u32_id_0 %75 %1353 %164
        %273 = OpPhi %bool_id %true %75 %1125 %164
        %274 = OpPhi %u32_id %221 %75 %1128 %164
        %275 = OpPhi %u32_id %u32_id_3 %75 %1230 %164
        %276 = OpPhi %u32_id %u32_id_0 %75 %1357 %164
       %gtc1358 = OpPhi %u32_id %u32_id_0 %75 %gtc1359 %164
               OpLoopMerge %165 %164 None
               OpBranch %77
         %77 = OpLabel
        %278 = OpULessThan %bool_id %276 %u32_id_5
        %279 = OpLogicalNot %bool_id %278
               OpSelectionMerge %144 None
               OpBranchConditional %279 %78 %144
         %78 = OpLabel
        %280 = OpShiftLeftLogical %u32_id %275 %u32_id_2
        %281 = OpUGreaterThan %bool_id %280 %274
        %282 = OpLogicalAnd %bool_id %273 %281
               OpSelectionMerge %88 None
               OpBranchConditional %282 %79 %88
         %79 = OpLabel
        %283 = OpBitwiseOr %u32_id %u32_id_3 %274
        %284 = OpIAdd %u32_id %272 %283
        %285 = OpShiftLeftLogical %u32_id %284 %u32_id_2
        %286 = OpIAdd %u32_id %272 %274
        %287 = OpShiftRightLogical %u32_id %285 %u32_id_2
        %288 = OpAccessChain %_ptr_Workgroup_u32_id %shared_mem_u32 %287
        %289 = OpLoad %u32_id %288
        %290 = OpShiftLeftLogical %u32_id %286 %u32_id_2
        %291 = OpBitwiseAnd %u32_id %u32_id_2 %274
        %292 = OpShiftRightLogical %u32_id %290 %u32_id_2
        %293 = OpAccessChain %_ptr_Workgroup_u32_id %shared_mem_u32 %292
        %294 = OpLoad %u32_id %293
        %295 = OpBitwiseAnd %u32_id %u32_id_1 %274
        %296 = OpINotEqual %bool_id %u32_id_0 %291
        %297 = OpBitcast %f32_id %289
        %299 = OpFDiv %f32_id %f32_id_1 %297
        %300 = OpINotEqual %bool_id %u32_id_0 %295
        %301 = OpLogicalAnd %bool_id %282 %296
               OpSelectionMerge %81 None
               OpBranchConditional %301 %80 %81
         %80 = OpLabel
        %302 = OpIEqual %bool_id %u32_id_0 %295
        %303 = OpBitcast %f32_id %294
        %304 = OpSelect %f32_id %302 %299 %303
        %305 = OpBitcast %u32_id %304
               OpBranch %81
         %81 = OpLabel
        %306 = OpPhi %u32_id %305 %80 %294 %79
        %307 = OpLogicalNot %bool_id %301
        %308 = OpLogicalAnd %bool_id %282 %307
               OpSelectionMerge %87 None
               OpBranchConditional %308 %82 %87
         %82 = OpLabel
        %309 = OpLogicalAnd %bool_id %308 %300
               OpSelectionMerge %84 None
               OpBranchConditional %309 %83 %84
         %83 = OpLabel
        %310 = OpCompositeConstruct %u32vec2_id %271 %ud_1
        %313 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_45
        %314 = OpLoad %u32_id %313
               OpBranch %84
         %84 = OpLabel
        %315 = OpPhi %u32_id %314 %83 %264 %82
        %316 = OpPhi %u32_id %314 %83 %289 %82
        %317 = OpLogicalNot %bool_id %309
        %318 = OpLogicalAnd %bool_id %308 %317
               OpSelectionMerge %86 None
               OpBranchConditional %318 %85 %86
         %85 = OpLabel
        %319 = OpCompositeConstruct %u32vec2_id %271 %ud_1
        %321 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_44
        %322 = OpLoad %u32_id %321
               OpBranch %86
         %86 = OpLabel
        %323 = OpPhi %u32_id %322 %85 %315 %84
        %324 = OpPhi %u32_id %322 %85 %316 %84
        %326 = OpFMul %f32_id %f32_id_0_5 %299
        %327 = OpBitcast %f32_id %306
        %328 = OpFMul %f32_id %326 %327
        %329 = OpFAdd %f32_id %328 %f32_id_0_5
        %330 = OpConvertSToF %f32_id %324
        %331 = OpFMul %f32_id %330 %329
        %332 = OpBitcast %u32_id %331
               OpBranch %87
         %87 = OpLabel
        %333 = OpPhi %u32_id %323 %86 %264 %81
        %334 = OpPhi %u32_id %332 %86 %306 %81
        %335 = OpIAdd %u32_id %270 %274
        %336 = OpShiftLeftLogical %u32_id %335 %u32_id_2
        %337 = OpShiftRightLogical %u32_id %336 %u32_id_2
        %338 = OpAccessChain %_ptr_Workgroup_u32_id %shared_mem_u32 %337
               OpStore %338 %334
               OpBranch %88
         %88 = OpLabel
        %339 = OpPhi %u32_id %333 %87 %264 %78
        %340 = OpPhi %u32_id %295 %87 %267 %78
        %341 = OpIAdd %u32_id %274 %u32_id_2
        %342 = OpUGreaterThan %bool_id %275 %341
        %343 = OpLogicalAnd %bool_id %273 %342
               OpSelectionMerge %142 None
               OpBranchConditional %343 %89 %142
         %89 = OpLabel
        %344 = OpIAdd %u32_id %274 %u32_id_1
        %345 = OpBitFieldUExtract %u32_id %344 %u32_id_0 %u32_id_24
        %346 = OpIMul %u32_id %345 %u32_id_4
        %347 = OpIAdd %u32_id %346 %270
        %348 = OpBitFieldUExtract %u32_id %341 %u32_id_0 %u32_id_24
        %349 = OpIMul %u32_id %348 %u32_id_4
        %350 = OpIAdd %u32_id %349 %270
        %351 = OpShiftLeftLogical %u32_id %347 %u32_id_2
        %352 = OpShiftLeftLogical %u32_id %350 %u32_id_2
        %353 = OpShiftLeftLogical %u32_id %270 %u32_id_2
        %354 = OpShiftRightLogical %u32_id %351 %u32_id_2
        %355 = OpAccessChain %_ptr_Workgroup_u32_id %shared_mem_u32 %354
        %356 = OpLoad %u32_id %355
        %357 = OpShiftRightLogical %u32_id %352 %u32_id_2
        %358 = OpAccessChain %_ptr_Workgroup_u32_id %shared_mem_u32 %357
        %359 = OpLoad %u32_id %358
        %360 = OpShiftRightLogical %u32_id %353 %u32_id_2
        %361 = OpAccessChain %_ptr_Workgroup_u32_id %shared_mem_u32 %360
        %362 = OpLoad %u32_id %361
        %363 = OpCompositeConstruct %u32vec2_id %271 %ud_1
        %364 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_44
        %365 = OpLoad %u32_id %364
        %366 = OpBitcast %f32_id %359
        %367 = OpBitcast %f32_id %362
        %368 = OpBitcast %f32_id %356
        %370 = OpExtInst %f32_id %369 FMin %367 %368
        %371 = OpExtInst %f32_id %369 FMin %366 %370
        %372 = OpBitcast %f32_id %359
        %373 = OpBitcast %f32_id %362
        %374 = OpBitcast %f32_id %356
        %375 = OpExtInst %f32_id %369 FMax %373 %374
        %376 = OpExtInst %f32_id %369 FMax %372 %375
        %377 = OpConvertSToF %f32_id %365
        %378 = OpExtInst %f32_id %369 FMax %f32_id_0 %371
        %379 = OpExtInst %f32_id %369 FMin %377 %376
        %380 = OpFSub %f32_id %379 %378
        %381 = OpFOrdGreaterThan %bool_id %f32_id_1 %380
        %384 = OpSelect %f32_id %381 %f32_id_0x1pn149 %f32_id_0x1pn148
        %385 = OpBitcast %u32_id %384
        %386 = OpUGreaterThanEqual %bool_id %u32_id_1 %385
        %387 = OpLogicalAnd %bool_id %343 %386
               OpSelectionMerge %91 None
               OpBranchConditional %387 %90 %91
         %90 = OpLabel
        %388 = OpExtInst %f32_id %369 Floor %378
        %389 = OpFSub %f32_id %379 %388
        %390 = OpBitcast %u32_id %389
        %391 = OpExtInst %f32_id %369 Fract %378
        %392 = OpBitcast %u32_id %391
        %394 = OpFOrdGreaterThan %bool_id %f32_id_1_5 %389
        %395 = OpFOrdLessThan %bool_id %f32_id_0_5 %391
        %396 = OpFOrdGreaterThan %bool_id %f32_id_0_5 %389
        %397 = OpLogicalAnd %bool_id %395 %394
        %398 = OpLogicalOr %bool_id %396 %397
        %400 = OpSelect %f32_id %398 %f32_id_0x1_8pn148 %f32_id_0x1pn148
        %401 = OpBitcast %u32_id %400
               OpBranch %91
         %91 = OpLabel
        %402 = OpPhi %u32_id %392 %90 %340 %89
        %403 = OpPhi %u32_id %390 %90 %274 %89
        %404 = OpPhi %u32_id %401 %90 %385 %89
        %405 = OpUGreaterThanEqual %bool_id %u32_id_2 %404
        %406 = OpLogicalAnd %bool_id %343 %405
               OpSelectionMerge %137 None
               OpBranchConditional %406 %92 %137
         %92 = OpLabel
        %407 = OpShiftLeftLogical %u32_id %270 %u32_id_2
        %408 = OpShiftLeftLogical %u32_id %347 %u32_id_2
        %409 = OpShiftLeftLogical %u32_id %350 %u32_id_2
        %410 = OpIAdd %u32_id %407 %u32_id_4
        %411 = OpShiftRightLogical %u32_id %410 %u32_id_2
        %412 = OpAccessChain %_ptr_Workgroup_u32_id %shared_mem_u32 %411
        %413 = OpLoad %u32_id %412
        %414 = OpIAdd %u32_id %408 %u32_id_4
        %415 = OpShiftRightLogical %u32_id %414 %u32_id_2
        %416 = OpAccessChain %_ptr_Workgroup_u32_id %shared_mem_u32 %415
        %417 = OpLoad %u32_id %416
        %418 = OpIAdd %u32_id %409 %u32_id_4
        %419 = OpShiftRightLogical %u32_id %418 %u32_id_2
        %420 = OpAccessChain %_ptr_Workgroup_u32_id %shared_mem_u32 %419
        %421 = OpLoad %u32_id %420
        %422 = OpCompositeConstruct %u32vec2_id %271 %ud_1
        %423 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_45
        %424 = OpLoad %u32_id %423
        %425 = OpBitcast %f32_id %421
        %426 = OpBitcast %f32_id %413
        %427 = OpBitcast %f32_id %417
        %428 = OpExtInst %f32_id %369 FMin %426 %427
        %429 = OpExtInst %f32_id %369 FMin %425 %428
        %430 = OpBitcast %f32_id %421
        %431 = OpBitcast %f32_id %413
        %432 = OpBitcast %f32_id %417
        %433 = OpExtInst %f32_id %369 FMax %431 %432
        %434 = OpExtInst %f32_id %369 FMax %430 %433
        %435 = OpConvertSToF %f32_id %424
        %436 = OpExtInst %f32_id %369 FMax %f32_id_0 %429
        %437 = OpExtInst %f32_id %369 FMin %435 %434
        %438 = OpFSub %f32_id %437 %436
        %439 = OpFOrdGreaterThan %bool_id %f32_id_1 %438
        %440 = OpSelect %f32_id %439 %f32_id_0x1pn149 %f32_id_0x1pn148
        %441 = OpBitcast %u32_id %440
        %442 = OpUGreaterThanEqual %bool_id %u32_id_1 %441
        %443 = OpLogicalAnd %bool_id %406 %442
               OpSelectionMerge %94 None
               OpBranchConditional %443 %93 %94
         %93 = OpLabel
        %444 = OpExtInst %f32_id %369 Floor %436
        %445 = OpFSub %f32_id %437 %444
        %446 = OpBitcast %u32_id %445
        %447 = OpExtInst %f32_id %369 Fract %436
        %448 = OpBitcast %u32_id %447
        %449 = OpFOrdGreaterThan %bool_id %f32_id_1_5 %445
        %450 = OpFOrdLessThan %bool_id %f32_id_0_5 %447
        %451 = OpFOrdGreaterThan %bool_id %f32_id_0_5 %445
        %452 = OpLogicalAnd %bool_id %450 %449
        %453 = OpLogicalOr %bool_id %451 %452
        %454 = OpSelect %f32_id %453 %f32_id_0x1_8pn148 %f32_id_0x1pn148
        %455 = OpBitcast %u32_id %454
               OpBranch %94
         %94 = OpLabel
        %456 = OpPhi %u32_id %448 %93 %402 %92
        %457 = OpPhi %u32_id %446 %93 %403 %92
        %458 = OpPhi %u32_id %455 %93 %441 %92
        %459 = OpUGreaterThanEqual %bool_id %u32_id_2 %458
        %460 = OpLogicalAnd %bool_id %406 %459
               OpSelectionMerge %132 None
               OpBranchConditional %460 %95 %132
         %95 = OpLabel
        %461 = OpGroupNonUniformBallot %u32vec4_id %u32_id_3 %460
        %462 = OpGroupNonUniformBallotFindLSB %u32_id %u32_id_3 %461
        %463 = OpCompositeConstruct %u32vec2_id %462 %269
        %464 = OpBitcast %u64_id %463
        %466 = OpBitwiseAnd %u64_id %464 %u64_id_63
        %467 = OpShiftLeftLogical %u64_id %u64_id_1 %466
        %468 = OpBitcast %u32vec2_id %467
        %469 = OpCompositeExtract %u32_id %468 1
        %470 = OpCompositeConstruct %u32vec2_id %271 %ud_1
        %473 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_47
        %474 = OpLoad %u32_id %473
        %475 = OpLogicalAnd %bool_id %460 %460
               OpSelectionMerge %97 None
               OpBranchConditional %475 %96 %97
         %96 = OpLabel
        %476 = OpShiftLeftLogical %u32_id %474 %u32_id_2
        %477 = OpCompositeConstruct %u32vec2_id %424 %268
        %478 = OpBitcast %u64_id %477
        %479 = OpBitcast %u32vec2_id %478
        %480 = OpCompositeExtract %u32_id %479 0
        %481 = OpCompositeExtract %u32_id %479 1
        %482 = OpBitCount %u32_id %480
        %483 = OpBitCount %u32_id %481
        %484 = OpIAdd %u32_id %482 %483
        %485 = OpShiftRightLogical %u32_id %476 %u32_id_2
        %486 = OpAccessChain %_ptr_StorageBuffer_u32_id %gds_buffer %u32_id_0 %485
        %487 = OpAtomicIAdd %u32_id %486 %u32_id_1 %u32_id_0 %484
               OpBranch %97
         %97 = OpLabel
        %488 = OpPhi %u32_id %484 %96 %263 %95
        %489 = OpPhi %u32_id %487 %96 %u32_id_0 %95
        %490 = OpGroupNonUniformBroadcastFirst %u32_id %u32_id_3 %489
        %492 = OpUGreaterThan %bool_id %u32_id_10000 %490
        %493 = OpLogicalAnd %bool_id %460 %492
               OpSelectionMerge %131 None
               OpBranchConditional %493 %98 %131
         %98 = OpLabel
        %495 = OpFMul %f32_id %f32_id_0_125 %379
        %496 = OpFMul %f32_id %f32_id_0_125 %437
        %497 = OpExtInst %f32_id %369 Ceil %496
        %498 = OpExtInst %f32_id %369 Ceil %495
        %499 = OpShiftLeftLogical %u32_id %347 %u32_id_2
        %500 = OpIAdd %u32_id %499 %u32_id_8
        %501 = OpShiftRightLogical %u32_id %500 %u32_id_2
        %502 = OpAccessChain %_ptr_Workgroup_u32_id %shared_mem_u32 %501
        %503 = OpLoad %u32_id %502
        %504 = OpBitcast %f32_id %362
        %505 = OpBitcast %f32_id %356
        %506 = OpFSub %f32_id %504 %505
        %507 = OpConvertFToS %u32_id %498
        %508 = OpBitcast %f32_id %359
        %509 = OpBitcast %f32_id %362
        %510 = OpFSub %f32_id %508 %509
        %511 = OpBitcast %f32_id %413
        %512 = OpFMul %f32_id %511 %506
        %513 = OpCompositeConstruct %u32vec2_id %271 %ud_1
        %514 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_16
        %515 = OpLoad %u32_id %514
        %517 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_17
        %518 = OpLoad %u32_id %517
        %520 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_18
        %521 = OpLoad %u32_id %520
        %523 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_19
        %524 = OpLoad %u32_id %523
        %525 = OpFMul %f32_id %f32_id_0_125 %378
        %526 = OpConvertFToS %u32_id %497
        %527 = OpShiftLeftLogical %u32_id %350 %u32_id_2
        %528 = OpShiftLeftLogical %u32_id %270 %u32_id_2
        %529 = OpIAdd %u32_id %528 %u32_id_8
        %530 = OpShiftRightLogical %u32_id %529 %u32_id_2
        %531 = OpAccessChain %_ptr_Workgroup_u32_id %shared_mem_u32 %530
        %532 = OpLoad %u32_id %531
        %533 = OpIAdd %u32_id %527 %u32_id_8
        %534 = OpShiftRightLogical %u32_id %533 %u32_id_2
        %535 = OpAccessChain %_ptr_Workgroup_u32_id %shared_mem_u32 %534
        %536 = OpLoad %u32_id %535
        %537 = OpBitcast %f32_id %532
        %538 = OpBitcast %f32_id %503
        %539 = OpFSub %f32_id %537 %538
        %540 = OpBitcast %f32_id %421
        %541 = OpBitcast %f32_id %413
        %542 = OpFSub %f32_id %540 %541
        %543 = OpBitcast %f32_id %536
        %544 = OpBitcast %f32_id %532
        %545 = OpFSub %f32_id %543 %544
        %546 = OpFNegate %f32_id %539
        %547 = OpFMul %f32_id %546 %510
        %548 = OpFMul %f32_id %545 %506
        %549 = OpFAdd %f32_id %548 %547
        %550 = OpFMul %f32_id %f32_id_0_125 %436
        %551 = OpConvertFToS %u32_id %525
        %552 = OpConvertFToS %u32_id %550
        %553 = OpISub %u32_id %507 %551
        %554 = OpBitcast %f32_id %413
        %555 = OpBitcast %f32_id %417
        %556 = OpFSub %f32_id %554 %555
        %557 = OpISub %u32_id %526 %552
        %558 = OpFNegate %f32_id %556
        %559 = OpFMul %f32_id %558 %545
        %560 = OpFMul %f32_id %542 %539
        %561 = OpFAdd %f32_id %560 %559
        %562 = OpFNegate %f32_id %506
        %563 = OpFMul %f32_id %562 %542
        %564 = OpFMul %f32_id %510 %556
        %565 = OpFAdd %f32_id %564 %563
        %566 = OpFDiv %f32_id %f32_id_1 %565
        %567 = OpBitcast %f32_id %421
        %568 = OpFMul %f32_id %567 %510
        %569 = OpBitcast %f32_id %356
        %570 = OpBitcast %f32_id %359
        %571 = OpFSub %f32_id %569 %570
        %572 = OpFMul %f32_id %566 %549
        %573 = OpBitcast %u32_id %572
        %574 = OpBitcast %f32_id %362
        %575 = OpFNegate %f32_id %556
        %576 = OpFMul %f32_id %574 %575
        %577 = OpFAdd %f32_id %576 %512
        %578 = OpBitcast %u32_id %577
        %579 = OpBitcast %f32_id %417
        %580 = OpFMul %f32_id %579 %571
        %581 = OpBitcast %f32_id %359
        %582 = OpFNegate %f32_id %542
        %583 = OpFMul %f32_id %581 %582
        %584 = OpFAdd %f32_id %583 %568
        %585 = OpBitcast %u32_id %584
        %586 = OpFMul %f32_id %566 %561
        %587 = OpBitcast %u32_id %586
        %588 = OpBitcast %f32_id %362
        %589 = OpBitcast %f32_id %532
        %590 = OpFMul %f32_id %588 %586
        %591 = OpFAdd %f32_id %590 %589
        %592 = OpBitcast %f32_id %421
        %593 = OpBitcast %f32_id %417
        %594 = OpFSub %f32_id %592 %593
        %595 = OpBitcast %f32_id %356
        %596 = OpFMul %f32_id %595 %594
        %597 = OpFAdd %f32_id %596 %580
        %598 = OpBitcast %u32_id %597
        %599 = OpBitcast %f32_id %413
        %600 = OpFMul %f32_id %572 %599
        %601 = OpFAdd %f32_id %600 %591
        %602 = OpBitcast %u32_id %601
        %603 = OpCompositeConstruct %u32vec4_id %578 %598 %585 %602
        %604 = OpIMul %u32_id %490 %u32_id_12
        %605 = OpIAdd %u32_id %604 %u32_id_8
        %606 = OpIAdd %u32_id %605 %buf1_dword_off
        %607 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %606
        %608 = OpCompositeExtract %u32_id %603 0
               OpStore %607 %608
        %609 = OpIAdd %u32_id %606 %u32_id_1
        %610 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %609
        %611 = OpCompositeExtract %u32_id %603 1
               OpStore %610 %611
        %612 = OpIAdd %u32_id %606 %u32_id_2
        %613 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %612
        %614 = OpCompositeExtract %u32_id %603 2
               OpStore %613 %614
        %615 = OpIAdd %u32_id %606 %u32_id_3
        %616 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %615
        %617 = OpCompositeExtract %u32_id %603 3
               OpStore %616 %617
        %618 = OpCompositeConstruct %u32vec4_id %362 %356 %359 %587
        %619 = OpIMul %u32_id %490 %u32_id_12
        %620 = OpIAdd %u32_id %619 %buf1_dword_off
        %621 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %620
        %622 = OpCompositeExtract %u32_id %618 0
               OpStore %621 %622
        %623 = OpIAdd %u32_id %620 %u32_id_1
        %624 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %623
        %625 = OpCompositeExtract %u32_id %618 1
               OpStore %624 %625
        %626 = OpIAdd %u32_id %620 %u32_id_2
        %627 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %626
        %628 = OpCompositeExtract %u32_id %618 2
               OpStore %627 %628
        %629 = OpIAdd %u32_id %620 %u32_id_3
        %630 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %629
        %631 = OpCompositeExtract %u32_id %618 3
               OpStore %630 %631
        %632 = OpCompositeConstruct %u32vec4_id %413 %417 %421 %573
        %633 = OpIMul %u32_id %490 %u32_id_12
        %634 = OpIAdd %u32_id %633 %u32_id_4
        %635 = OpIAdd %u32_id %634 %buf1_dword_off
        %636 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %635
        %637 = OpCompositeExtract %u32_id %632 0
               OpStore %636 %637
        %638 = OpIAdd %u32_id %635 %u32_id_1
        %639 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %638
        %640 = OpCompositeExtract %u32_id %632 1
               OpStore %639 %640
        %641 = OpIAdd %u32_id %635 %u32_id_2
        %642 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %641
        %643 = OpCompositeExtract %u32_id %632 2
               OpStore %642 %643
        %644 = OpIAdd %u32_id %635 %u32_id_3
        %645 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %644
        %646 = OpCompositeExtract %u32_id %632 3
               OpStore %645 %646
        %647 = OpIEqual %bool_id %u32_id_1 %557
        %648 = OpIEqual %bool_id %u32_id_1 %553
        %649 = OpExtInst %u32_id %369 SMax %553 %557
        %650 = OpSGreaterThanEqual %bool_id %u32_id_8 %649
        %651 = OpBitcast %f32_id %536
        %652 = OpBitcast %f32_id %532
        %653 = OpBitcast %f32_id %503
        %654 = OpExtInst %f32_id %369 FMax %652 %653
        %655 = OpExtInst %f32_id %369 FMax %651 %654
        %656 = OpBitcast %u32_id %655
        %657 = OpBitcast %f32_id %536
        %658 = OpBitcast %f32_id %532
        %659 = OpBitcast %f32_id %503
        %660 = OpExtInst %f32_id %369 FMin %658 %659
        %661 = OpExtInst %f32_id %369 FMin %657 %660
        %662 = OpBitcast %u32_id %661
        %663 = OpLogicalAnd %bool_id %648 %647
        %664 = OpLogicalAnd %bool_id %493 %663
               OpSelectionMerge %104 None
               OpBranchConditional %664 %99 %104
         %99 = OpLabel
        %665 = OpGroupNonUniformBallot %u32vec4_id %u32_id_3 %664
        %666 = OpGroupNonUniformBallotFindLSB %u32_id %u32_id_3 %665
        %667 = OpCompositeConstruct %u32vec2_id %666 %469
        %668 = OpBitcast %u64_id %667
        %669 = OpBitwiseAnd %u64_id %668 %u64_id_63
        %670 = OpShiftLeftLogical %u64_id %u64_id_1 %669
        %671 = OpBitcast %u32vec2_id %670
        %672 = OpCompositeExtract %u32_id %671 1
        %673 = OpLogicalAnd %bool_id %664 %663
               OpSelectionMerge %101 None
               OpBranchConditional %673 %100 %101
        %100 = OpLabel
        %674 = OpShiftLeftLogical %u32_id %474 %u32_id_2
        %675 = OpCompositeConstruct %u32vec2_id %275 %171
        %676 = OpBitcast %u64_id %675
        %677 = OpBitcast %u32vec2_id %676
        %678 = OpCompositeExtract %u32_id %677 0
        %679 = OpCompositeExtract %u32_id %677 1
        %680 = OpBitCount %u32_id %678
        %681 = OpBitCount %u32_id %679
        %682 = OpIAdd %u32_id %680 %681
        %683 = OpCompositeConstruct %u32vec2_id %271 %ud_1
        %685 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_40
        %686 = OpLoad %u32_id %685
        %689 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_41
        %690 = OpLoad %u32_id %689
        %693 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_42
        %694 = OpLoad %u32_id %693
        %697 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_43
        %698 = OpLoad %u32_id %697
        %699 = OpIAdd %u32_id %u32_id_0 %buf2_dword_off
        %700 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %699
        %701 = OpAtomicIAdd %u32_id %700 %u32_id_1 %u32_id_0 %682
        %702 = OpIAdd %u32_id %674 %u32_id_16
        %703 = OpShiftRightLogical %u32_id %702 %u32_id_2
        %704 = OpAccessChain %_ptr_StorageBuffer_u32_id %gds_buffer %u32_id_0 %703
        %705 = OpAtomicIAdd %u32_id %704 %u32_id_1 %u32_id_0 %682
               OpBranch %101
        %101 = OpLabel
        %706 = OpPhi %u32_id %682 %100 %270 %99
        %707 = OpPhi %u32_id %698 %100 %524 %99
        %708 = OpPhi %u32_id %694 %100 %521 %99
        %709 = OpPhi %u32_id %690 %100 %518 %99
        %710 = OpPhi %u32_id %686 %100 %515 %99
        %711 = OpPhi %u32_id %705 %100 %u32_id_0 %99
        %712 = OpGroupNonUniformBroadcastFirst %u32_id %u32_id_3 %711
        %714 = OpUGreaterThan %bool_id %u32_id_40000 %712
        %715 = OpLogicalAnd %bool_id %664 %714
               OpSelectionMerge %103 None
               OpBranchConditional %715 %102 %103
        %102 = OpLabel
        %717 = OpBitwiseAnd %u32_id %u32_id_255 %551
        %718 = OpBitwiseAnd %u32_id %u32_id_255 %552
        %719 = OpBitFieldUExtract %u32_id %718 %u32_id_0 %u32_id_24
        %721 = OpIMul %u32_id %719 %u32_id_256
        %722 = OpIAdd %u32_id %721 %717
        %723 = OpShiftLeftLogical %u32_id %490 %u32_id_16
        %724 = OpCompositeConstruct %u32vec2_id %271 %ud_1
        %725 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_28
        %726 = OpLoad %u32_id %725
        %728 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_29
        %729 = OpLoad %u32_id %728
        %732 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_30
        %733 = OpLoad %u32_id %732
        %735 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_31
        %736 = OpLoad %u32_id %735
        %737 = OpBitwiseOr %u32_id %722 %723
        %738 = OpCompositeConstruct %u32vec4_id %656 %662 %737 %u32_id_0
        %739 = OpIMul %u32_id %712 %u32_id_4
        %740 = OpIAdd %u32_id %739 %buf3_dword_off
        %741 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_4 %u32_id_0 %740
        %742 = OpCompositeExtract %u32_id %738 0
               OpStore %741 %742
        %743 = OpIAdd %u32_id %740 %u32_id_1
        %744 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_4 %u32_id_0 %743
        %745 = OpCompositeExtract %u32_id %738 1
               OpStore %744 %745
        %746 = OpIAdd %u32_id %740 %u32_id_2
        %747 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_4 %u32_id_0 %746
        %748 = OpCompositeExtract %u32_id %738 2
               OpStore %747 %748
        %749 = OpIAdd %u32_id %740 %u32_id_3
        %750 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_4 %u32_id_0 %749
        %751 = OpCompositeExtract %u32_id %738 3
               OpStore %750 %751
               OpBranch %103
        %103 = OpLabel
        %752 = OpPhi %u32_id %u32_id_256 %102 %706 %101
        %753 = OpPhi %u32_id %736 %102 %707 %101
        %754 = OpPhi %u32_id %733 %102 %708 %101
        %755 = OpPhi %u32_id %729 %102 %709 %101
        %756 = OpPhi %u32_id %726 %102 %710 %101
               OpBranch %104
        %104 = OpLabel
        %757 = OpPhi %u32_id %752 %103 %270 %98
        %758 = OpPhi %u32_id %753 %103 %524 %98
        %759 = OpPhi %u32_id %754 %103 %521 %98
        %760 = OpPhi %u32_id %712 %103 %587 %98
        %761 = OpPhi %u32_id %711 %103 %503 %98
        %762 = OpPhi %u32_id %755 %103 %518 %98
        %763 = OpPhi %u32_id %756 %103 %515 %98
        %764 = OpPhi %u32_id %672 %103 %469 %98
        %765 = OpPhi %bool_id %664 %103 %663 %98
        %766 = OpLogicalNot %bool_id %664
        %767 = OpLogicalAnd %bool_id %493 %766
               OpSelectionMerge %130 None
               OpBranchConditional %767 %105 %130
        %105 = OpLabel
        %768 = OpLogicalAnd %bool_id %767 %650
               OpSelectionMerge %111 None
               OpBranchConditional %768 %106 %111
        %106 = OpLabel
        %769 = OpGroupNonUniformBallot %u32vec4_id %u32_id_3 %768
        %770 = OpGroupNonUniformBallotFindLSB %u32_id %u32_id_3 %769
        %771 = OpCompositeConstruct %u32vec2_id %770 %764
        %772 = OpBitcast %u64_id %771
        %773 = OpBitwiseAnd %u64_id %772 %u64_id_63
        %774 = OpShiftLeftLogical %u64_id %u64_id_1 %773
        %775 = OpBitcast %u32vec2_id %774
        %776 = OpCompositeExtract %u32_id %775 1
        %777 = OpLogicalAnd %bool_id %768 %765
               OpSelectionMerge %108 None
               OpBranchConditional %777 %107 %108
        %107 = OpLabel
        %778 = OpShiftLeftLogical %u32_id %474 %u32_id_2
        %779 = OpCompositeConstruct %u32vec2_id %272 %276
        %780 = OpBitcast %u64_id %779
        %781 = OpBitcast %u32vec2_id %780
        %782 = OpCompositeExtract %u32_id %781 0
        %783 = OpCompositeExtract %u32_id %781 1
        %784 = OpBitCount %u32_id %782
        %785 = OpBitCount %u32_id %783
        %786 = OpIAdd %u32_id %784 %785
        %787 = OpCompositeConstruct %u32vec2_id %271 %ud_1
        %790 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_36
        %791 = OpLoad %u32_id %790
        %794 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_37
        %795 = OpLoad %u32_id %794
        %798 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_38
        %799 = OpLoad %u32_id %798
        %802 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_39
        %803 = OpLoad %u32_id %802
        %804 = OpIAdd %u32_id %u32_id_0 %buf4_dword_off
        %805 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_5 %u32_id_0 %804
        %806 = OpAtomicIAdd %u32_id %805 %u32_id_1 %u32_id_0 %786
        %807 = OpIAdd %u32_id %778 %u32_id_12
        %808 = OpShiftRightLogical %u32_id %807 %u32_id_2
        %809 = OpAccessChain %_ptr_StorageBuffer_u32_id %gds_buffer %u32_id_0 %808
        %810 = OpAtomicIAdd %u32_id %809 %u32_id_1 %u32_id_0 %786
               OpBranch %108
        %108 = OpLabel
        %811 = OpPhi %u32_id %786 %107 %757 %106
        %812 = OpPhi %u32_id %803 %107 %758 %106
        %813 = OpPhi %u32_id %799 %107 %759 %106
        %814 = OpPhi %u32_id %795 %107 %762 %106
        %815 = OpPhi %u32_id %791 %107 %763 %106
        %816 = OpPhi %u32_id %810 %107 %u32_id_0 %106
        %817 = OpGroupNonUniformBroadcastFirst %u32_id %u32_id_3 %816
        %818 = OpUGreaterThan %bool_id %u32_id_10000 %817
        %819 = OpLogicalAnd %bool_id %768 %818
               OpSelectionMerge %110 None
               OpBranchConditional %819 %109 %110
        %109 = OpLabel
        %820 = OpBitwiseAnd %u32_id %u32_id_255 %551
        %821 = OpBitwiseAnd %u32_id %u32_id_255 %552
        %822 = OpBitFieldUExtract %u32_id %821 %u32_id_0 %u32_id_24
        %823 = OpIMul %u32_id %822 %u32_id_256
        %824 = OpIAdd %u32_id %823 %820
        %825 = OpShiftLeftLogical %u32_id %490 %u32_id_16
        %826 = OpCompositeConstruct %u32vec2_id %271 %ud_1
        %827 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_24
        %828 = OpLoad %u32_id %827
        %830 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_25
        %831 = OpLoad %u32_id %830
        %833 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_26
        %834 = OpLoad %u32_id %833
        %836 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_27
        %837 = OpLoad %u32_id %836
        %838 = OpBitwiseOr %u32_id %824 %825
        %839 = OpCompositeConstruct %u32vec4_id %656 %662 %838 %u32_id_0
        %840 = OpIMul %u32_id %817 %u32_id_4
        %841 = OpIAdd %u32_id %840 %buf5_dword_off
        %842 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_6 %u32_id_0 %841
        %843 = OpCompositeExtract %u32_id %839 0
               OpStore %842 %843
        %844 = OpIAdd %u32_id %841 %u32_id_1
        %845 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_6 %u32_id_0 %844
        %846 = OpCompositeExtract %u32_id %839 1
               OpStore %845 %846
        %847 = OpIAdd %u32_id %841 %u32_id_2
        %848 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_6 %u32_id_0 %847
        %849 = OpCompositeExtract %u32_id %839 2
               OpStore %848 %849
        %850 = OpIAdd %u32_id %841 %u32_id_3
        %851 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_6 %u32_id_0 %850
        %852 = OpCompositeExtract %u32_id %839 3
               OpStore %851 %852
               OpBranch %110
        %110 = OpLabel
        %853 = OpPhi %u32_id %u32_id_256 %109 %811 %108
        %854 = OpPhi %u32_id %837 %109 %812 %108
        %855 = OpPhi %u32_id %834 %109 %813 %108
        %856 = OpPhi %u32_id %831 %109 %814 %108
        %857 = OpPhi %u32_id %828 %109 %815 %108
               OpBranch %111
        %111 = OpLabel
        %858 = OpPhi %u32_id %853 %110 %757 %105
        %859 = OpPhi %u32_id %854 %110 %758 %105
        %860 = OpPhi %u32_id %855 %110 %759 %105
        %861 = OpPhi %u32_id %817 %110 %760 %105
        %862 = OpPhi %u32_id %816 %110 %761 %105
        %863 = OpPhi %u32_id %856 %110 %762 %105
        %864 = OpPhi %u32_id %857 %110 %763 %105
        %865 = OpPhi %u32_id %776 %110 %764 %105
        %866 = OpLogicalNot %bool_id %768
        %867 = OpLogicalAnd %bool_id %767 %866
               OpSelectionMerge %129 None
               OpBranchConditional %867 %112 %129
        %112 = OpLabel
        %868 = OpShiftLeftLogical %u32_id %490 %u32_id_16
               OpBranch %113
        %113 = OpLabel
        %869 = OpPhi %u32_id %859 %112 %991 %127
        %870 = OpPhi %u32_id %860 %112 %992 %127
        %871 = OpPhi %u32_id %862 %112 %993 %127
        %872 = OpPhi %u32_id %863 %112 %994 %127
        %873 = OpPhi %u32_id %864 %112 %995 %127
        %874 = OpPhi %u32_id %865 %112 %996 %127
        %875 = OpPhi %u32_id %u32_id_0 %112 %1002 %127
        %876 = OpPhi %bool_id %867 %112 %998 %127
        %877 = OpPhi %u32_id %u32_id_0 %112 %u32_id_0 %127
       %gtc1362 = OpPhi %u32_id %u32_id_0 %112 %gtc1363 %127
               OpLoopMerge %128 %127 None
               OpBranch %114
        %114 = OpLabel
        %878 = OpUGreaterThanEqual %bool_id %u32_id_0 %877
        %879 = OpLogicalAnd %bool_id %876 %878
        %880 = OpLogicalNot %bool_id %879
       %gtc1363 = OpIAdd %u32_id %gtc1362 %u32_id_1
       %gtc1364 = OpUGreaterThanEqual %bool_id %gtc1362 %gtcap_1000
       %gtc1365 = OpLogicalOr %bool_id %880 %gtc1364
               OpBranchConditional %gtc1365 %128 %115
        %115 = OpLabel
        %881 = OpIAdd %u32_id %875 %552
        %882 = OpSLessThan %bool_id %875 %557
        %883 = OpBitwiseAnd %u32_id %u32_id_255 %881
        %884 = OpShiftLeftLogical %u32_id %883 %u32_id_8
        %885 = OpLogicalNot %bool_id %879
        %886 = OpLogicalOr %bool_id %882 %885
        %887 = OpLogicalAnd %bool_id %876 %886
        %888 = OpLogicalAnd %bool_id %879 %886
        %889 = OpLogicalNot %bool_id %888
               OpBranchConditional %889 %128 %116
        %116 = OpLabel
               OpBranch %117
        %117 = OpLabel
        %890 = OpPhi %u32_id %869 %116 %973 %124
        %891 = OpPhi %u32_id %870 %116 %970 %124
        %892 = OpPhi %u32_id %871 %116 %951 %124
        %893 = OpPhi %u32_id %872 %116 %967 %124
        %894 = OpPhi %u32_id %873 %116 %965 %124
        %895 = OpPhi %u32_id %874 %116 %916 %124
        %896 = OpPhi %u32_id %u32_id_0 %116 %990 %124
        %897 = OpPhi %bool_id %887 %116 %956 %124
        %898 = OpPhi %u32_id %877 %116 %u32_id_2 %124
       %gtc1366 = OpPhi %u32_id %u32_id_0 %116 %gtc1367 %124
               OpLoopMerge %125 %124 None
               OpBranch %118
        %118 = OpLabel
        %899 = OpUGreaterThanEqual %bool_id %u32_id_2 %898
        %900 = OpLogicalAnd %bool_id %897 %899
        %901 = OpLogicalNot %bool_id %900
       %gtc1367 = OpIAdd %u32_id %gtc1366 %u32_id_1
       %gtc1368 = OpUGreaterThanEqual %bool_id %gtc1366 %gtcap_1000
       %gtc1369 = OpLogicalOr %bool_id %901 %gtc1368
               OpBranchConditional %gtc1369 %125 %119
        %119 = OpLabel
        %902 = OpSLessThan %bool_id %896 %553
        %904 = OpSelect %f32_id %902 %f32_id_0x1_8pn148 %f32_id_0x1_4pn147
        %905 = OpBitcast %u32_id %904
        %906 = OpUGreaterThanEqual %bool_id %u32_id_3 %905
        %907 = OpLogicalAnd %bool_id %897 %906
        %908 = OpLogicalNot %bool_id %907
               OpBranchConditional %908 %125 %120
        %120 = OpLabel
        %909 = OpGroupNonUniformBallot %u32vec4_id %u32_id_3 %907
        %910 = OpGroupNonUniformBallotFindLSB %u32_id %u32_id_3 %909
        %911 = OpCompositeConstruct %u32vec2_id %910 %895
        %912 = OpBitcast %u64_id %911
        %913 = OpBitwiseAnd %u64_id %912 %u64_id_63
        %914 = OpShiftLeftLogical %u64_id %u64_id_1 %913
        %915 = OpBitcast %u32vec2_id %914
        %916 = OpCompositeExtract %u32_id %915 1
        %917 = OpLogicalAnd %bool_id %907 %907
               OpSelectionMerge %122 None
               OpBranchConditional %917 %121 %122
        %121 = OpLabel
        %918 = OpShiftLeftLogical %u32_id %474 %u32_id_2
        %919 = OpCompositeConstruct %u32vec2_id %272 %276
        %920 = OpBitcast %u64_id %919
        %921 = OpBitcast %u32vec2_id %920
        %922 = OpCompositeExtract %u32_id %921 0
        %923 = OpCompositeExtract %u32_id %921 1
        %924 = OpBitCount %u32_id %922
        %925 = OpBitCount %u32_id %923
        %926 = OpIAdd %u32_id %924 %925
        %927 = OpCompositeConstruct %u32vec2_id %271 %ud_1
        %929 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_32
        %930 = OpLoad %u32_id %929
        %932 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_33
        %933 = OpLoad %u32_id %932
        %935 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_34
        %936 = OpLoad %u32_id %935
        %938 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_35
        %939 = OpLoad %u32_id %938
        %940 = OpIAdd %u32_id %u32_id_0 %buf6_dword_off
        %941 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_7 %u32_id_0 %940
        %942 = OpAtomicIAdd %u32_id %941 %u32_id_1 %u32_id_0 %926
        %943 = OpIAdd %u32_id %918 %u32_id_8
        %944 = OpShiftRightLogical %u32_id %943 %u32_id_2
        %945 = OpAccessChain %_ptr_StorageBuffer_u32_id %gds_buffer %u32_id_0 %944
        %946 = OpAtomicIAdd %u32_id %945 %u32_id_1 %u32_id_0 %926
               OpBranch %122
        %122 = OpLabel
        %947 = OpPhi %u32_id %939 %121 %890 %120
        %948 = OpPhi %u32_id %936 %121 %891 %120
        %949 = OpPhi %u32_id %933 %121 %893 %120
        %950 = OpPhi %u32_id %930 %121 %894 %120
        %951 = OpPhi %u32_id %946 %121 %u32_id_0 %120
        %952 = OpGroupNonUniformBroadcastFirst %u32_id %u32_id_3 %951
        %954 = OpULessThanEqual %bool_id %u32_id_1000 %952
        %955 = OpLogicalNot %bool_id %954
        %956 = OpLogicalAnd %bool_id %897 %955
        %957 = OpLogicalNot %bool_id %954
        %958 = OpLogicalAnd %bool_id %907 %957
        %959 = OpLogicalNot %bool_id %958
               OpBranchConditional %959 %125 %123
        %123 = OpLabel
        %960 = OpIAdd %u32_id %896 %551
        %961 = OpBitwiseAnd %u32_id %u32_id_255 %960
        %962 = OpBitwiseOr %u32_id %868 %884
        %963 = OpCompositeConstruct %u32vec2_id %271 %ud_1
        %964 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_20
        %965 = OpLoad %u32_id %964
        %966 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_21
        %967 = OpLoad %u32_id %966
        %969 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_22
        %970 = OpLoad %u32_id %969
        %972 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_23
        %973 = OpLoad %u32_id %972
        %974 = OpBitwiseOr %u32_id %962 %961
        %975 = OpCompositeConstruct %u32vec4_id %656 %662 %974 %u32_id_0
        %976 = OpIMul %u32_id %952 %u32_id_4
        %977 = OpIAdd %u32_id %976 %buf7_dword_off
        %978 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_8 %u32_id_0 %977
        %979 = OpCompositeExtract %u32_id %975 0
               OpStore %978 %979
        %980 = OpIAdd %u32_id %977 %u32_id_1
        %981 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_8 %u32_id_0 %980
        %982 = OpCompositeExtract %u32_id %975 1
               OpStore %981 %982
        %983 = OpIAdd %u32_id %977 %u32_id_2
        %984 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_8 %u32_id_0 %983
        %985 = OpCompositeExtract %u32_id %975 2
               OpStore %984 %985
        %986 = OpIAdd %u32_id %977 %u32_id_3
        %987 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_8 %u32_id_0 %986
        %988 = OpCompositeExtract %u32_id %975 3
               OpStore %987 %988
        %990 = OpIAdd %u32_id %896 %u32_id_64
               OpBranch %124
        %124 = OpLabel
               OpBranchConditional %true %117 %125
        %125 = OpLabel
        %991 = OpPhi %u32_id %890 %118 %890 %119 %947 %122 %973 %124
        %992 = OpPhi %u32_id %891 %118 %891 %119 %948 %122 %970 %124
        %993 = OpPhi %u32_id %892 %118 %892 %119 %951 %122 %951 %124
        %994 = OpPhi %u32_id %893 %118 %893 %119 %949 %122 %967 %124
        %995 = OpPhi %u32_id %894 %118 %894 %119 %950 %122 %965 %124
        %996 = OpPhi %u32_id %895 %118 %895 %119 %916 %122 %916 %124
        %997 = OpPhi %u32_id %898 %118 %905 %119 %905 %122 %u32_id_2 %124
        %998 = OpPhi %bool_id %897 %118 %897 %119 %956 %122 %956 %124
        %999 = OpUGreaterThanEqual %bool_id %u32_id_5 %997
       %1000 = OpLogicalAnd %bool_id %998 %999
       %1001 = OpLogicalNot %bool_id %1000
               OpBranchConditional %1001 %128 %126
        %126 = OpLabel
       %1002 = OpIAdd %u32_id %875 %u32_id_64
               OpBranch %127
        %127 = OpLabel
               OpBranchConditional %true %113 %128
        %128 = OpLabel
       %1003 = OpPhi %u32_id %875 %114 %875 %115 %875 %125 %1002 %127
       %1004 = OpPhi %u32_id %869 %114 %869 %115 %991 %125 %991 %127
       %1005 = OpPhi %u32_id %870 %114 %870 %115 %992 %125 %992 %127
       %1006 = OpPhi %u32_id %871 %114 %871 %115 %993 %125 %993 %127
       %1007 = OpPhi %u32_id %872 %114 %872 %115 %994 %125 %994 %127
       %1008 = OpPhi %u32_id %873 %114 %873 %115 %995 %125 %995 %127
               OpBranch %129
        %129 = OpLabel
       %1009 = OpPhi %u32_id %1003 %128 %858 %111
       %1010 = OpPhi %u32_id %1004 %128 %859 %111
       %1011 = OpPhi %u32_id %1005 %128 %860 %111
       %1012 = OpPhi %u32_id %868 %128 %861 %111
       %1013 = OpPhi %u32_id %1006 %128 %862 %111
       %1014 = OpPhi %u32_id %1007 %128 %863 %111
       %1015 = OpPhi %u32_id %1008 %128 %864 %111
               OpBranch %130
        %130 = OpLabel
       %1016 = OpPhi %u32_id %1009 %129 %757 %104
       %1017 = OpPhi %u32_id %1010 %129 %758 %104
       %1018 = OpPhi %u32_id %1011 %129 %759 %104
       %1019 = OpPhi %u32_id %1012 %129 %760 %104
       %1020 = OpPhi %u32_id %1013 %129 %761 %104
       %1021 = OpPhi %u32_id %1014 %129 %762 %104
       %1022 = OpPhi %u32_id %1015 %129 %763 %104
               OpBranch %131
        %131 = OpLabel
       %1023 = OpPhi %u32_id %1016 %130 %270 %97
       %1024 = OpPhi %u32_id %573 %130 %260 %97
       %1025 = OpPhi %u32_id %1017 %130 %262 %97
       %1026 = OpPhi %u32_id %1018 %130 %488 %97
       %1027 = OpPhi %u32_id %598 %130 %265 %97
       %1028 = OpPhi %u32_id %649 %130 %266 %97
       %1029 = OpPhi %u32_id %1019 %130 %u32_id_0 %97
       %1030 = OpPhi %u32_id %1020 %130 %489 %97
       %1031 = OpPhi %u32_id %1021 %130 %268 %97
       %1032 = OpPhi %u32_id %1022 %130 %424 %97
               OpBranch %132
        %132 = OpLabel
       %1033 = OpPhi %u32_id %1023 %131 %270 %94
       %1034 = OpPhi %u32_id %1024 %131 %260 %94
       %1035 = OpPhi %u32_id %1025 %131 %262 %94
       %1036 = OpPhi %u32_id %1026 %131 %263 %94
       %1037 = OpPhi %u32_id %1027 %131 %265 %94
       %1038 = OpPhi %u32_id %1028 %131 %266 %94
       %1039 = OpPhi %u32_id %1029 %131 %456 %94
       %1040 = OpPhi %u32_id %1030 %131 %457 %94
       %1041 = OpPhi %u32_id %1031 %131 %268 %94
       %1042 = OpPhi %u32_id %1032 %131 %424 %94
       %1043 = OpPhi %u32_id %u32_id_4 %131 %458 %94
       %1044 = OpUGreaterThanEqual %bool_id %u32_id_3 %1043
       %1045 = OpLogicalAnd %bool_id %406 %1044
               OpSelectionMerge %136 None
               OpBranchConditional %1045 %133 %136
        %133 = OpLabel
       %1046 = OpLogicalAnd %bool_id %1045 %1045
               OpSelectionMerge %135 None
               OpBranchConditional %1046 %134 %135
        %134 = OpLabel
       %1047 = OpCompositeConstruct %u32vec2_id %271 %ud_1
       %1048 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_47
       %1049 = OpLoad %u32_id %1048
       %1050 = OpCompositeConstruct %u32vec2_id %1042 %1041
       %1051 = OpBitcast %u64_id %1050
       %1052 = OpBitcast %u32vec2_id %1051
       %1053 = OpCompositeExtract %u32_id %1052 0
       %1054 = OpCompositeExtract %u32_id %1052 1
       %1055 = OpBitCount %u32_id %1053
       %1056 = OpBitCount %u32_id %1054
       %1057 = OpIAdd %u32_id %1055 %1056
       %1058 = OpShiftLeftLogical %u32_id %1049 %u32_id_2
       %1059 = OpIAdd %u32_id %1058 %u32_id_48
       %1060 = OpShiftRightLogical %u32_id %1059 %u32_id_2
       %1061 = OpAccessChain %_ptr_StorageBuffer_u32_id %gds_buffer %u32_id_0 %1060
       %1062 = OpAtomicIAdd %u32_id %1061 %u32_id_1 %u32_id_0 %1057
               OpBranch %135
        %135 = OpLabel
       %1063 = OpPhi %u32_id %1049 %134 %1033 %133
       %1064 = OpPhi %u32_id %1058 %134 %1040 %133
               OpBranch %136
        %136 = OpLabel
       %1065 = OpPhi %u32_id %1063 %135 %1033 %132
       %1066 = OpPhi %u32_id %1064 %135 %1040 %132
               OpBranch %137
        %137 = OpLabel
       %1067 = OpPhi %u32_id %1065 %136 %270 %91
       %1068 = OpPhi %u32_id %1034 %136 %260 %91
       %1069 = OpPhi %u32_id %1035 %136 %262 %91
       %1070 = OpPhi %u32_id %1036 %136 %263 %91
       %1071 = OpPhi %u32_id %1041 %136 %268 %91
       %1072 = OpPhi %u32_id %1042 %136 %339 %91
       %1073 = OpPhi %u32_id %1037 %136 %265 %91
       %1074 = OpPhi %u32_id %1038 %136 %266 %91
       %1075 = OpPhi %u32_id %1039 %136 %402 %91
       %1076 = OpPhi %u32_id %1066 %136 %403 %91
       %1077 = OpPhi %u32_id %u32_id_4 %136 %404 %91
       %1078 = OpUGreaterThanEqual %bool_id %u32_id_3 %1077
       %1079 = OpLogicalAnd %bool_id %343 %1078
               OpSelectionMerge %141 None
               OpBranchConditional %1079 %138 %141
        %138 = OpLabel
       %1080 = OpLogicalAnd %bool_id %1079 %1079
               OpSelectionMerge %140 None
               OpBranchConditional %1080 %139 %140
        %139 = OpLabel
       %1081 = OpCompositeConstruct %u32vec2_id %271 %ud_1
       %1082 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_47
       %1083 = OpLoad %u32_id %1082
       %1084 = OpCompositeConstruct %u32vec2_id %ud_2 %ud_3
       %1085 = OpBitcast %u64_id %1084
       %1086 = OpBitcast %u32vec2_id %1085
       %1087 = OpCompositeExtract %u32_id %1086 0
       %1088 = OpCompositeExtract %u32_id %1086 1
       %1089 = OpBitCount %u32_id %1087
       %1090 = OpBitCount %u32_id %1088
       %1091 = OpIAdd %u32_id %1089 %1090
       %1092 = OpShiftLeftLogical %u32_id %1083 %u32_id_2
       %1093 = OpIAdd %u32_id %1092 %u32_id_48
       %1094 = OpShiftRightLogical %u32_id %1093 %u32_id_2
       %1095 = OpAccessChain %_ptr_StorageBuffer_u32_id %gds_buffer %u32_id_0 %1094
       %1096 = OpAtomicIAdd %u32_id %1095 %u32_id_1 %u32_id_0 %1091
               OpBranch %140
        %140 = OpLabel
       %1097 = OpPhi %u32_id %1083 %139 %271 %138
       %1098 = OpPhi %u32_id %1092 %139 %1076 %138
               OpBranch %141
        %141 = OpLabel
       %1099 = OpPhi %bool_id %1079 %140 %343 %137
       %1100 = OpPhi %u32_id %1097 %140 %271 %137
       %1101 = OpPhi %bool_id %1080 %140 %1079 %137
       %1102 = OpPhi %u32_id %1098 %140 %1076 %137
               OpBranch %142
        %142 = OpLabel
       %1103 = OpPhi %u32_id %1067 %141 %270 %88
       %1104 = OpPhi %u32_id %1068 %141 %260 %88
       %1105 = OpPhi %bool_id %1099 %141 %273 %88
       %1106 = OpPhi %u32_id %1069 %141 %262 %88
       %1107 = OpPhi %u32_id %1070 %141 %263 %88
       %1108 = OpPhi %u32_id %1071 %141 %268 %88
       %1109 = OpPhi %u32_id %1072 %141 %339 %88
       %1110 = OpPhi %u32_id %1073 %141 %265 %88
       %1111 = OpPhi %u32_id %1100 %141 %271 %88
       %1112 = OpPhi %bool_id %1101 %141 %343 %88
       %1113 = OpPhi %u32_id %1074 %141 %266 %88
       %1114 = OpPhi %u32_id %1075 %141 %340 %88
       %1115 = OpPhi %u32_id %1102 %141 %274 %88
       %gtc1359 = OpIAdd %u32_id %gtc1358 %u32_id_1
       %gtc1360 = OpUGreaterThanEqual %bool_id %gtc1358 %gtcap_1000
       %gtc1361 = OpLogicalOr %bool_id %true %gtc1360
               OpBranchConditional %gtc1361 %165 %143
        %143 = OpLabel
               OpBranch %144
        %144 = OpLabel
       %1116 = OpPhi %u32_id %1103 %143 %270 %77
       %1117 = OpPhi %u32_id %1104 %143 %260 %77
       %1118 = OpPhi %bool_id %1105 %143 %261 %77
       %1119 = OpPhi %u32_id %1106 %143 %262 %77
       %1120 = OpPhi %u32_id %1107 %143 %263 %77
       %1121 = OpPhi %u32_id %1108 %143 %268 %77
       %1122 = OpPhi %u32_id %1109 %143 %264 %77
       %1123 = OpPhi %u32_id %1110 %143 %265 %77
       %1124 = OpPhi %u32_id %1111 %143 %271 %77
       %1125 = OpPhi %bool_id %1112 %143 %273 %77
       %1126 = OpPhi %u32_id %1113 %143 %266 %77
       %1127 = OpPhi %u32_id %1114 %143 %267 %77
       %1128 = OpPhi %u32_id %1115 %143 %274 %77
       %1130 = OpIAdd %u32_id %275 %u32_id_4294967295
       %1131 = OpShiftLeftLogical %u32_id %275 %u32_id_2
       %1132 = OpUGreaterThan %bool_id %1131 %1128
       %1133 = OpIEqual %bool_id %1130 %1127
       %1134 = OpBitcast %f32_id %1126
       %1135 = OpSelect %f32_id %1133 %f32_id_0 %1134
       %1136 = OpBitcast %u32_id %1135
       %1137 = OpLogicalAnd %bool_id %1125 %1132
               OpSelectionMerge %148 None
               OpBranchConditional %1137 %145 %148
        %145 = OpLabel
       %1138 = OpShiftLeftLogical %u32_id %1136 %u32_id_2
       %1139 = OpIAdd %u32_id %272 %1138
       %1140 = OpShiftRightLogical %u32_id %276 %u32_id_1
       %1141 = OpIAdd %u32_id %272 %1123
       %1142 = OpIAdd %u32_id %1140 %1139
       %1143 = OpIAdd %u32_id %1140 %1141
       %1144 = OpCompositeConstruct %u32vec2_id %1124 %ud_1
       %1146 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_46
       %1147 = OpLoad %u32_id %1146
       %1148 = OpShiftLeftLogical %u32_id %1142 %u32_id_2
       %1149 = OpShiftLeftLogical %u32_id %1139 %u32_id_2
       %1150 = OpShiftLeftLogical %u32_id %1143 %u32_id_2
       %1151 = OpShiftLeftLogical %u32_id %1141 %u32_id_2
       %1152 = OpShiftRightLogical %u32_id %1148 %u32_id_2
       %1153 = OpAccessChain %_ptr_Workgroup_u32_id %shared_mem_u32 %1152
       %1154 = OpLoad %u32_id %1153
       %1155 = OpIAdd %u32_id %1149 %u32_id_12
       %1156 = OpShiftRightLogical %u32_id %1155 %u32_id_2
       %1157 = OpAccessChain %_ptr_Workgroup_u32_id %shared_mem_u32 %1156
       %1158 = OpLoad %u32_id %1157
       %1159 = OpShiftRightLogical %u32_id %1150 %u32_id_2
       %1160 = OpAccessChain %_ptr_Workgroup_u32_id %shared_mem_u32 %1159
       %1161 = OpLoad %u32_id %1160
       %1162 = OpIAdd %u32_id %1151 %u32_id_12
       %1163 = OpShiftRightLogical %u32_id %1162 %u32_id_2
       %1164 = OpAccessChain %_ptr_Workgroup_u32_id %shared_mem_u32 %1163
       %1165 = OpLoad %u32_id %1164
       %1166 = OpINotEqual %bool_id %u32_id_0 %1147
       %1167 = OpSelect %bool_id %1166 %1137 %false
       %1168 = OpIEqual %bool_id %u32_id_4 %276
       %1169 = OpSelect %bool_id %1168 %1137 %false
       %1170 = OpBitcast %f32_id %1154
       %1171 = OpBitcast %f32_id %1158
       %1172 = OpFOrdLessThanEqual %bool_id %1170 %1171
       %1173 = OpBitcast %f32_id %1161
       %1174 = OpBitcast %f32_id %1165
       %1175 = OpFOrdLessThanEqual %bool_id %1173 %1174
       %1176 = OpSelect %f32_id %1172 %f32_id_0x1pn149 %f32_id_0
       %1177 = OpBitcast %u32_id %1176
       %1178 = OpSelect %f32_id %1175 %f32_id_0x1pn149 %f32_id_0
       %1179 = OpBitcast %u32_id %1178
       %1180 = OpLogicalAnd %bool_id %1169 %1167
       %1181 = OpLogicalNot %bool_id %1180
               OpSelectionMerge %147 None
               OpBranchConditional %1181 %146 %147
        %146 = OpLabel
       %1182 = OpBitcast %f32_id %1165
       %1183 = OpFNegate %f32_id %1182
       %1184 = OpBitcast %f32_id %1161
       %1185 = OpFOrdLessThanEqual %bool_id %1183 %1184
       %1186 = OpBitwiseAnd %u32_id %276 %u32_id_1
       %1187 = OpIEqual %bool_id %u32_id_0 %1186
       %1188 = OpBitcast %f32_id %1158
       %1189 = OpFNegate %f32_id %1188
       %1190 = OpBitcast %f32_id %1154
       %1191 = OpFOrdLessThanEqual %bool_id %1189 %1190
       %1192 = OpSelect %bool_id %1187 %1137 %false
       %1193 = OpLogicalAnd %bool_id %1191 %1192
       %1194 = OpLogicalNot %bool_id %1192
       %1195 = OpLogicalAnd %bool_id %1172 %1194
       %1196 = OpLogicalOr %bool_id %1195 %1193
       %1197 = OpLogicalAnd %bool_id %1185 %1192
       %1198 = OpLogicalNot %bool_id %1192
       %1199 = OpLogicalAnd %bool_id %1175 %1198
       %1200 = OpLogicalOr %bool_id %1199 %1197
       %1201 = OpSelect %f32_id %1196 %f32_id_0x1pn149 %f32_id_0
       %1202 = OpBitcast %u32_id %1201
       %1203 = OpSelect %f32_id %1200 %f32_id_0x1pn149 %f32_id_0
       %1204 = OpBitcast %u32_id %1203
               OpBranch %147
        %147 = OpLabel
       %1205 = OpPhi %u32_id %1204 %146 %1179 %145
       %1206 = OpPhi %u32_id %1202 %146 %1177 %145
               OpBranch %148
        %148 = OpLabel
       %1207 = OpPhi %u32_id %1158 %147 %u32_id_0 %144
       %1208 = OpPhi %u32_id %1165 %147 %u32_id_0 %144
       %1209 = OpPhi %u32_id %1161 %147 %u32_id_0 %144
       %1210 = OpPhi %u32_id %1154 %147 %u32_id_0 %144
       %1211 = OpPhi %u32_id %1147 %147 %1122 %144
       %1212 = OpPhi %u32_id %1205 %147 %u32_id_0 %144
       %1213 = OpPhi %u32_id %1206 %147 %u32_id_0 %144
       %1214 = OpCompositeConstruct %u32vec2_id %1211 %1121
       %1215 = OpBitcast %u64_id %1214
       %1216 = OpBitcast %u32vec2_id %1215
       %1217 = OpCompositeExtract %u32_id %1216 0
       %1218 = OpCompositeExtract %u32_id %1216 1
       %1219 = OpBitCount %u32_id %1217
       %1220 = OpBitCount %u32_id %1218
       %1221 = OpIAdd %u32_id %1219 %1220
       %1222 = OpCompositeConstruct %u32vec2_id %1120 %1119
       %1223 = OpBitcast %u64_id %1222
       %1224 = OpBitcast %u32vec2_id %1223
       %1225 = OpCompositeExtract %u32_id %1224 0
       %1226 = OpCompositeExtract %u32_id %1224 1
       %1227 = OpBitCount %u32_id %1225
       %1228 = OpBitCount %u32_id %1226
       %1229 = OpIAdd %u32_id %1227 %1228
       %1230 = OpIAdd %u32_id %1229 %1221
       %1231 = OpIEqual %bool_id %275 %1230
       %1232 = OpSelect %bool_id %1231 %1125 %false
       %1233 = OpIEqual %bool_id %u32_id_0 %1229
       %1234 = OpSelect %bool_id %1233 %1125 %false
       %1235 = OpLogicalAnd %bool_id %1232 %1234
       %1236 = OpINotEqual %bool_id %u32_id_0 %1230
       %1237 = OpLogicalNot %bool_id %1236
               OpBranchConditional %1237 %165 %149
        %149 = OpLabel
       %1238 = OpLogicalAnd %bool_id %1125 %1235
       %1239 = OpLogicalNot %bool_id %1238
               OpSelectionMerge %163 None
               OpBranchConditional %1239 %150 %163
        %150 = OpLabel
       %1240 = OpINotEqual %bool_id %1212 %1213
       %1241 = OpLogicalAnd %bool_id %1125 %1240
               OpSelectionMerge %160 None
               OpBranchConditional %1241 %151 %160
        %151 = OpLabel
       %1242 = OpCompositeConstruct %u32vec2_id %1124 %ud_1
       %1243 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_46
       %1244 = OpLoad %u32_id %1243
       %1245 = OpIEqual %bool_id %u32_id_4 %276
       %1246 = OpSelect %bool_id %1245 %1241 %false
       %1247 = OpINotEqual %bool_id %u32_id_0 %1244
       %1248 = OpSelect %bool_id %1247 %1241 %false
       %1249 = OpBitwiseAnd %u32_id %276 %u32_id_1
       %1250 = OpLogicalAnd %bool_id %1246 %1248
       %1251 = OpINotEqual %bool_id %u32_id_0 %1249
       %1252 = OpSelect %bool_id %1251 %1241 %false
       %1253 = OpLogicalNot %bool_id %1250
               OpSelectionMerge %153 None
               OpBranchConditional %1250 %152 %153
        %152 = OpLabel
       %1254 = OpBitcast %f32_id %1209
       %1255 = OpFNegate %f32_id %1254
       %1256 = OpBitcast %f32_id %1208
       %1257 = OpFNegate %f32_id %1256
       %1258 = OpFAdd %f32_id %1255 %1257
       %1259 = OpBitcast %f32_id %1207
       %1260 = OpFAdd %f32_id %1258 %1259
       %1261 = OpBitcast %u32_id %1260
       %1262 = OpBitcast %f32_id %1210
       %1263 = OpFAdd %f32_id %1260 %1262
       %1264 = OpFDiv %f32_id %f32_id_1 %1263
       %1265 = OpBitcast %f32_id %1208
       %1266 = OpBitcast %f32_id %1209
       %1267 = OpFSub %f32_id %1265 %1266
       %1268 = OpBitcast %u32_id %1267
       %1269 = OpFMul %f32_id %1264 %1267
       %1270 = OpBitcast %u32_id %1269
               OpBranch %153
        %153 = OpLabel
       %1271 = OpPhi %u32_id %1261 %152 %1207 %151
       %1272 = OpPhi %u32_id %1268 %152 %1209 %151
       %1273 = OpPhi %u32_id %1270 %152 %1210 %151
               OpSelectionMerge %159 None
               OpBranchConditional %1253 %154 %159
        %154 = OpLabel
       %1274 = OpLogicalAnd %bool_id %1241 %1252
       %1275 = OpLogicalNot %bool_id %1274
               OpSelectionMerge %156 None
               OpBranchConditional %1274 %155 %156
        %155 = OpLabel
       %1276 = OpBitcast %f32_id %1272
       %1277 = OpFNegate %f32_id %1276
       %1278 = OpBitcast %f32_id %1271
       %1279 = OpFNegate %f32_id %1278
       %1280 = OpFAdd %f32_id %1277 %1279
       %1281 = OpBitcast %f32_id %1208
       %1282 = OpFAdd %f32_id %1280 %1281
       %1283 = OpBitcast %u32_id %1282
       %1284 = OpBitcast %f32_id %1273
       %1285 = OpFAdd %f32_id %1282 %1284
       %1286 = OpFDiv %f32_id %f32_id_1 %1285
       %1287 = OpBitcast %f32_id %1208
       %1288 = OpBitcast %f32_id %1272
       %1289 = OpFSub %f32_id %1287 %1288
       %1290 = OpBitcast %u32_id %1289
       %1291 = OpFMul %f32_id %1286 %1289
       %1292 = OpBitcast %u32_id %1291
               OpBranch %156
        %156 = OpLabel
       %1293 = OpPhi %u32_id %1283 %155 %1271 %154
       %1294 = OpPhi %u32_id %1290 %155 %1272 %154
       %1295 = OpPhi %u32_id %1292 %155 %1273 %154
               OpSelectionMerge %158 None
               OpBranchConditional %1275 %157 %158
        %157 = OpLabel
       %1296 = OpBitcast %f32_id %1208
       %1297 = OpFNegate %f32_id %1296
       %1298 = OpBitcast %f32_id %1294
       %1299 = OpFNegate %f32_id %1298
       %1300 = OpFAdd %f32_id %1297 %1299
       %1301 = OpBitcast %f32_id %1293
       %1302 = OpFAdd %f32_id %1300 %1301
       %1303 = OpBitcast %f32_id %1295
       %1304 = OpFAdd %f32_id %1302 %1303
       %1305 = OpFDiv %f32_id %f32_id_1 %1304
       %1306 = OpFMul %f32_id %1305 %1300
       %1307 = OpBitcast %u32_id %1306
               OpBranch %158
        %158 = OpLabel
       %1308 = OpPhi %u32_id %1307 %157 %1295 %156
               OpBranch %159
        %159 = OpLabel
       %1309 = OpPhi %u32_id %1308 %158 %1273 %153
       %1310 = OpIAdd %u32_id %272 %1117
       %1311 = OpShiftLeftLogical %u32_id %1136 %u32_id_2
       %1312 = OpIAdd %u32_id %1310 %1123
       %1313 = OpIAdd %u32_id %1310 %1311
       %1314 = OpShiftLeftLogical %u32_id %1312 %u32_id_2
       %1315 = OpShiftLeftLogical %u32_id %1313 %u32_id_2
       %1316 = OpShiftRightLogical %u32_id %1314 %u32_id_2
       %1317 = OpAccessChain %_ptr_Workgroup_u32_id %shared_mem_u32 %1316
       %1318 = OpLoad %u32_id %1317
       %1319 = OpShiftRightLogical %u32_id %1315 %u32_id_2
       %1320 = OpAccessChain %_ptr_Workgroup_u32_id %shared_mem_u32 %1319
       %1321 = OpLoad %u32_id %1320
       %1322 = OpIAdd %u32_id %1117 %u32_id_4
       %1323 = OpBitcast %f32_id %1321
       %1324 = OpBitcast %f32_id %1318
       %1325 = OpFSub %f32_id %1323 %1324
       %1326 = OpIAdd %u32_id %1116 %1117
       %1327 = OpShiftLeftLogical %u32_id %1326 %u32_id_2
       %1328 = OpBitcast %f32_id %1309
       %1329 = OpBitcast %f32_id %1318
       %1330 = OpFMul %f32_id %1325 %1328
       %1331 = OpFAdd %f32_id %1330 %1329
       %1332 = OpBitcast %u32_id %1331
       %1333 = OpShiftRightLogical %u32_id %1327 %u32_id_2
       %1334 = OpAccessChain %_ptr_Workgroup_u32_id %shared_mem_u32 %1333
               OpStore %1334 %1332
               OpBranch %160
        %160 = OpLabel
       %1335 = OpPhi %u32_id %1249 %159 %1119 %150
       %1336 = OpPhi %u32_id %1244 %159 %1120 %150
       %1337 = OpPhi %u32_id %1322 %159 %1117 %150
       %1338 = OpINotEqual %bool_id %u32_id_0 %1213
       %1339 = OpLogicalAnd %bool_id %1125 %1338
               OpSelectionMerge %162 None
               OpBranchConditional %1339 %161 %162
        %161 = OpLabel
       %1340 = OpShiftLeftLogical %u32_id %1136 %u32_id_2
       %1341 = OpIAdd %u32_id %272 %1117
       %1342 = OpIAdd %u32_id %1116 %1337
       %1343 = OpIAdd %u32_id %1341 %1340
       %1344 = OpShiftLeftLogical %u32_id %1343 %u32_id_2
       %1345 = OpShiftRightLogical %u32_id %1344 %u32_id_2
       %1346 = OpAccessChain %_ptr_Workgroup_u32_id %shared_mem_u32 %1345
       %1347 = OpLoad %u32_id %1346
       %1348 = OpShiftLeftLogical %u32_id %1342 %u32_id_2
       %1349 = OpShiftRightLogical %u32_id %1348 %u32_id_2
       %1350 = OpAccessChain %_ptr_Workgroup_u32_id %shared_mem_u32 %1349
               OpStore %1350 %1347
               OpBranch %162
        %162 = OpLabel
       %1351 = OpBitwiseXor %u32_id %1116 %u32_id_32
       %1352 = OpBitwiseXor %u32_id %272 %u32_id_32
               OpBranch %163
        %163 = OpLabel
       %1353 = OpPhi %u32_id %1352 %162 %272 %149
       %1354 = OpPhi %u32_id %1335 %162 %1119 %149
       %1355 = OpPhi %u32_id %1336 %162 %1120 %149
       %1356 = OpPhi %u32_id %1351 %162 %1116 %149
       %1357 = OpIAdd %u32_id %276 %u32_id_1
               OpBranch %164
        %164 = OpLabel
               OpBranchConditional %true %76 %165
        %165 = OpLabel
               OpBranch %166
        %166 = OpLabel
               OpBranch %167
        %167 = OpLabel
               OpReturn
               OpFunctionEnd
