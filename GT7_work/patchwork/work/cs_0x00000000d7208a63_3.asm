; SPIR-V
; Version: 1.6
; Generator: Khronos; 0
; Bound: 1040
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
        %359 = OpExtInstImport "GLSL.std.450"
               OpMemoryModel Logical GLSL450
               OpEntryPoint GLCompute %61 "main" %push_data %gl_WorkGroupID %gl_LocalInvocationID %ssbo_1 %ssbo_2 %ssbo_3 %ssbo_4 %srt_flatbuf
               OpExecutionMode %61 LocalSize 64 1 1
               OpExecutionMode %61 SignedZeroInfNanPreserve 32
          %1 = OpString "0xd7208a63"
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
               OpName %srt_flatbuf "srt_flatbuf"
               OpName %buf0_off "buf0_off"
               OpName %buf0_dword_off "buf0_dword_off"
               OpName %buf1_off "buf1_off"
               OpName %buf1_dword_off "buf1_dword_off"
               OpName %buf2_off "buf2_off"
               OpName %buf2_dword_off "buf2_dword_off"
               OpName %buf3_off "buf3_off"
               OpName %buf3_dword_off "buf3_dword_off"
               OpName %ud_0 "ud_0"
               OpName %ud_1 "ud_1"
               OpName %ud_2 "ud_2"
               OpName %ud_3 "ud_3"
               OpName %ud_10 "ud_10"
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
               OpDecorate %srt_flatbuf Binding 4
               OpDecorate %srt_flatbuf DescriptorSet 0
               OpDecorate %srt_flatbuf NonWritable
               OpDecorate %356 NoContraction
               OpDecorate %361 NoContraction
               OpDecorate %362 NoContraction
               OpDecorate %413 NoContraction
               OpDecorate %416 NoContraction
               OpDecorate %417 NoContraction
               OpDecorate %420 NoContraction
               OpDecorate %423 NoContraction
               OpDecorate %425 NoContraction
               OpDecorate %428 NoContraction
               OpDecorate %431 NoContraction
               OpDecorate %433 NoContraction
               OpDecorate %434 NoContraction
               OpDecorate %435 NoContraction
               OpDecorate %436 NoContraction
               OpDecorate %437 NoContraction
               OpDecorate %438 NoContraction
               OpDecorate %439 NoContraction
               OpDecorate %440 NoContraction
               OpDecorate %446 NoContraction
               OpDecorate %447 NoContraction
               OpDecorate %448 NoContraction
               OpDecorate %452 NoContraction
               OpDecorate %454 NoContraction
               OpDecorate %455 NoContraction
               OpDecorate %458 NoContraction
               OpDecorate %459 NoContraction
               OpDecorate %468 NoContraction
               OpDecorate %469 NoContraction
               OpDecorate %470 NoContraction
               OpDecorate %473 NoContraction
               OpDecorate %474 NoContraction
               OpDecorate %482 NoContraction
               OpDecorate %483 NoContraction
               OpDecorate %486 NoContraction
               OpDecorate %487 NoContraction
               OpDecorate %488 NoContraction
               OpDecorate %491 NoContraction
               OpDecorate %493 NoContraction
               OpDecorate %494 NoContraction
               OpDecorate %959 NoContraction
               OpDecorate %962 NoContraction
               OpDecorate %965 NoContraction
               OpDecorate %968 NoContraction
               OpDecorate %971 NoContraction
               OpDecorate %972 NoContraction
               OpDecorate %973 NoContraction
               OpDecorate %976 NoContraction
               OpDecorate %977 NoContraction
               OpDecorate %980 NoContraction
               OpDecorate %984 NoContraction
               OpDecorate %986 NoContraction
               OpDecorate %987 NoContraction
               OpDecorate %989 NoContraction
               OpDecorate %990 NoContraction
               OpDecorate %992 NoContraction
               OpDecorate %993 NoContraction
               OpDecorate %1000 NoContraction
               OpDecorate %1002 NoContraction
               OpDecorate %1004 NoContraction
               OpDecorate %1005 NoContraction
               OpDecorate %1011 NoContraction
               OpDecorate %1015 NoContraction
               OpDecorate %1023 NoContraction
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
         %60 = OpTypeFunction %void_id
   %u32_id_8 = OpConstant %u32_id 8
%_ptr_PushConstant_u32_id = OpTypePointer PushConstant %u32_id
   %u32_id_2 = OpConstant %u32_id 2
  %u32_id_16 = OpConstant %u32_id 16
  %u32_id_24 = OpConstant %u32_id 24
   %u32_id_4 = OpConstant %u32_id 4
   %u32_id_3 = OpConstant %u32_id 3
   %u32_id_5 = OpConstant %u32_id 5
   %u32_id_6 = OpConstant %u32_id 6
  %u32_id_15 = OpConstant %u32_id 15
   %u32_id_7 = OpConstant %u32_id 7
   %u32_id_9 = OpConstant %u32_id 9
  %u32_id_10 = OpConstant %u32_id 10
  %u32_id_11 = OpConstant %u32_id 11
  %u32_id_12 = OpConstant %u32_id 12
  %u32_id_13 = OpConstant %u32_id 13
  %u32_id_14 = OpConstant %u32_id 14
  %u32_id_17 = OpConstant %u32_id 17
  %u32_id_18 = OpConstant %u32_id 18
  %u32_id_19 = OpConstant %u32_id 19
  %u32_id_20 = OpConstant %u32_id 20
  %u32_id_21 = OpConstant %u32_id 21
  %u32_id_22 = OpConstant %u32_id 22
  %u32_id_23 = OpConstant %u32_id 23
  %u32_id_25 = OpConstant %u32_id 25
  %u32_id_26 = OpConstant %u32_id 26
  %u32_id_27 = OpConstant %u32_id 27
  %u32_id_28 = OpConstant %u32_id 28
  %u32_id_29 = OpConstant %u32_id 29
  %u32_id_30 = OpConstant %u32_id 30
  %u32_id_31 = OpConstant %u32_id 31
%f32_id_0x1pn149 = OpConstant %f32_id 0x1p-149
%f32_id_0x1pn148 = OpConstant %f32_id 0x1p-148
%u32_id_4294967295 = OpConstant %u32_id 4294967295
%u32_id_4294967292 = OpConstant %u32_id 4294967292
   %f32_id_1 = OpConstant %f32_id 1
%u32_id_1073741823 = OpConstant %u32_id 1073741823
%u32_id_65535 = OpConstant %u32_id 65535
%f32_id_3_14159203 = OpConstant %f32_id 3.14159203
%f32_id_6_28318405 = OpConstant %f32_id 6.28318405
   %f32_id_3 = OpConstant %f32_id 3
   %f32_id_7 = OpConstant %f32_id 7
%f32_id_0_159154937 = OpConstant %f32_id 0.159154937
 %f32_id_0_5 = OpConstant %f32_id 0.5
%u32_id_4294934530 = OpConstant %u32_id 4294934530
%u32_id_32767 = OpConstant %u32_id 32767
 %f32_id_256 = OpConstant %f32_id 256
 %u32_id_255 = OpConstant %u32_id 255
 %u32_id_256 = OpConstant %u32_id 256
%u32_id_1065353216 = OpConstant %u32_id 1065353216
  %push_data = OpVariable %_ptr_PushConstant_AuxData PushConstant
%gl_WorkGroupID = OpVariable %_ptr_Input_u32vec3_id Input
%gl_LocalInvocationID = OpVariable %_ptr_Input_u32vec3_id Input
     %ssbo_1 = OpVariable %_ptr_StorageBuffer__struct_52 StorageBuffer
     %ssbo_2 = OpVariable %_ptr_StorageBuffer__struct_52 StorageBuffer
     %ssbo_3 = OpVariable %_ptr_StorageBuffer__struct_52 StorageBuffer
     %ssbo_4 = OpVariable %_ptr_StorageBuffer__struct_52 StorageBuffer
%srt_flatbuf = OpVariable %_ptr_StorageBuffer__struct_52 StorageBuffer
         %61 = OpFunction %void_id None %60
         %62 = OpLabel
        %111 = OpUndef %u32_id
        %112 = OpUndef %u32_id
        %113 = OpUndef %u32_id
        %114 = OpUndef %u32_id
        %115 = OpUndef %u32_id
        %116 = OpUndef %u32_id
        %117 = OpUndef %u32_id
        %118 = OpUndef %u32_id
        %119 = OpUndef %u32_id
        %120 = OpUndef %u32_id
        %121 = OpUndef %u32_id
        %122 = OpUndef %u32_id
        %123 = OpUndef %u32_id
        %124 = OpUndef %u32_id
        %125 = OpUndef %u32_id
        %126 = OpUndef %u32_id
        %127 = OpUndef %u32_id
        %128 = OpUndef %u32_id
        %129 = OpUndef %u32_id
        %130 = OpUndef %u32_id
        %133 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
        %134 = OpLoad %u32_id %133
   %buf0_off = OpBitFieldUExtract %u32_id %134 %u32_id_0 %u32_id_8
%buf0_dword_off = OpShiftRightLogical %u32_id %buf0_off %u32_id_2
        %138 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
        %139 = OpLoad %u32_id %138
   %buf1_off = OpBitFieldUExtract %u32_id %139 %u32_id_8 %u32_id_8
%buf1_dword_off = OpShiftRightLogical %u32_id %buf1_off %u32_id_2
        %142 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
        %143 = OpLoad %u32_id %142
   %buf2_off = OpBitFieldUExtract %u32_id %143 %u32_id_16 %u32_id_8
%buf2_dword_off = OpShiftRightLogical %u32_id %buf2_off %u32_id_2
        %147 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
        %148 = OpLoad %u32_id %147
   %buf3_off = OpBitFieldUExtract %u32_id %148 %u32_id_24 %u32_id_8
%buf3_dword_off = OpShiftRightLogical %u32_id %buf3_off %u32_id_2
        %153 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_0
       %ud_0 = OpLoad %u32_id %153
        %155 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_1
       %ud_1 = OpLoad %u32_id %155
        %157 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_2
       %ud_2 = OpLoad %u32_id %157
        %160 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_3
       %ud_3 = OpLoad %u32_id %160
        %163 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_5 %u32_id_0
      %ud_10 = OpLoad %u32_id %163
        %165 = OpLoad %u32vec3_id %gl_LocalInvocationID
        %166 = OpCompositeExtract %u32_id %165 0
        %167 = OpLoad %u32vec3_id %gl_LocalInvocationID
        %168 = OpCompositeExtract %u32_id %167 1
        %169 = OpLoad %u32vec3_id %gl_LocalInvocationID
        %170 = OpCompositeExtract %u32_id %169 2
        %171 = OpLoad %u32vec3_id %gl_WorkGroupID
        %172 = OpCompositeExtract %u32_id %171 0
        %174 = OpShiftLeftLogical %u32_id %172 %u32_id_6
        %175 = OpIAdd %u32_id %174 %166
        %176 = OpUGreaterThan %bool_id %ud_0 %175
               OpSelectionMerge %109 None
               OpBranchConditional %176 %63 %109
         %63 = OpLabel
        %178 = OpIMul %u32_id %175 %u32_id_15
        %179 = OpIAdd %u32_id %178 %buf0_dword_off
        %180 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %179
        %181 = OpLoad %u32_id %180
        %182 = OpIAdd %u32_id %179 %u32_id_1
        %183 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %182
        %184 = OpLoad %u32_id %183
        %185 = OpIAdd %u32_id %179 %u32_id_2
        %186 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %185
        %187 = OpLoad %u32_id %186
        %188 = OpCompositeConstruct %u32vec3_id %181 %184 %187
        %189 = OpCompositeExtract %u32_id %188 0
        %190 = OpCompositeExtract %u32_id %188 1
        %191 = OpCompositeExtract %u32_id %188 2
               OpBranch %64
         %64 = OpLabel
        %192 = OpPhi %u32_id %111 %63 %908 %105
        %193 = OpPhi %u32_id %112 %63 %878 %105
        %194 = OpPhi %u32_id %113 %63 %879 %105
        %195 = OpPhi %u32_id %u32_id_1073741823 %63 %880 %105
        %196 = OpPhi %u32_id %u32_id_0 %63 %881 %105
        %197 = OpPhi %u32_id %u32_id_0 %63 %882 %105
        %198 = OpPhi %u32_id %175 %63 %883 %105
        %199 = OpPhi %u32_id %114 %63 %884 %105
        %200 = OpPhi %u32_id %115 %63 %885 %105
        %201 = OpPhi %u32_id %u32_id_1 %63 %886 %105
        %202 = OpPhi %u32_id %191 %63 %887 %105
        %203 = OpPhi %u32_id %190 %63 %888 %105
        %204 = OpPhi %u32_id %189 %63 %889 %105
        %205 = OpPhi %u32_id %116 %63 %890 %105
        %206 = OpPhi %u32_id %117 %63 %891 %105
        %207 = OpPhi %u32_id %118 %63 %892 %105
        %208 = OpPhi %u32_id %119 %63 %893 %105
        %209 = OpPhi %u32_id %120 %63 %894 %105
        %210 = OpPhi %u32_id %121 %63 %895 %105
        %211 = OpPhi %u32_id %122 %63 %896 %105
        %212 = OpPhi %u32_id %123 %63 %897 %105
        %213 = OpPhi %u32_id %124 %63 %898 %105
        %214 = OpPhi %u32_id %125 %63 %899 %105
        %215 = OpPhi %u32_id %126 %63 %900 %105
        %216 = OpPhi %u32_id %127 %63 %901 %105
        %217 = OpPhi %u32_id %128 %63 %902 %105
        %218 = OpPhi %u32_id %129 %63 %903 %105
        %219 = OpPhi %u32_id %130 %63 %904 %105
        %220 = OpPhi %u32_id %170 %63 %905 %105
        %221 = OpPhi %u32_id %168 %63 %906 %105
        %222 = OpPhi %u32_id %u32_id_0 %63 %907 %105
        %223 = OpPhi %bool_id %176 %63 %226 %105
        %224 = OpPhi %u32_id %u32_id_0 %63 %908 %105
               OpLoopMerge %106 %105 None
               OpBranch %65
         %65 = OpLabel
        %225 = OpSLessThanEqual %bool_id %u32_id_0 %224
        %226 = OpLogicalAnd %bool_id %223 %225
        %227 = OpLogicalNot %bool_id %226
               OpBranchConditional %227 %106 %66
         %66 = OpLabel
               OpBranch %67
         %67 = OpLabel
        %228 = OpPhi %u32_id %194 %66 %321 %71
        %229 = OpPhi %bool_id %226 %66 %235 %71
        %230 = OpPhi %bool_id %226 %66 %235 %71
               OpLoopMerge %72 %71 None
               OpBranch %68
         %68 = OpLabel
        %231 = OpGroupNonUniformBroadcastFirst %u32_id %u32_id_3 %224
        %232 = OpIEqual %bool_id %231 %224
        %233 = OpLogicalAnd %bool_id %229 %232
        %234 = OpLogicalNot %bool_id %233
        %235 = OpLogicalAnd %bool_id %230 %234
               OpSelectionMerge %70 None
               OpBranchConditional %233 %69 %70
         %69 = OpLabel
        %236 = OpIEqual %bool_id %231 %u32_id_0
        %237 = OpSelect %u32_id %236 %222 %222
        %238 = OpIEqual %bool_id %231 %u32_id_1
        %239 = OpSelect %u32_id %238 %221 %237
        %240 = OpIEqual %bool_id %231 %u32_id_2
        %241 = OpSelect %u32_id %240 %220 %239
        %242 = OpIEqual %bool_id %231 %u32_id_3
        %243 = OpSelect %u32_id %242 %219 %241
        %244 = OpIEqual %bool_id %231 %u32_id_4
        %245 = OpSelect %u32_id %244 %218 %243
        %246 = OpIEqual %bool_id %231 %u32_id_5
        %247 = OpSelect %u32_id %246 %217 %245
        %248 = OpIEqual %bool_id %231 %u32_id_6
        %249 = OpSelect %u32_id %248 %216 %247
        %251 = OpIEqual %bool_id %231 %u32_id_7
        %252 = OpSelect %u32_id %251 %215 %249
        %253 = OpIEqual %bool_id %231 %u32_id_8
        %254 = OpSelect %u32_id %253 %214 %252
        %256 = OpIEqual %bool_id %231 %u32_id_9
        %257 = OpSelect %u32_id %256 %213 %254
        %259 = OpIEqual %bool_id %231 %u32_id_10
        %260 = OpSelect %u32_id %259 %212 %257
        %262 = OpIEqual %bool_id %231 %u32_id_11
        %263 = OpSelect %u32_id %262 %211 %260
        %265 = OpIEqual %bool_id %231 %u32_id_12
        %266 = OpSelect %u32_id %265 %210 %263
        %268 = OpIEqual %bool_id %231 %u32_id_13
        %269 = OpSelect %u32_id %268 %209 %266
        %271 = OpIEqual %bool_id %231 %u32_id_14
        %272 = OpSelect %u32_id %271 %208 %269
        %273 = OpIEqual %bool_id %231 %u32_id_15
        %274 = OpSelect %u32_id %273 %207 %272
        %275 = OpIEqual %bool_id %231 %u32_id_16
        %276 = OpSelect %u32_id %275 %206 %274
        %278 = OpIEqual %bool_id %231 %u32_id_17
        %279 = OpSelect %u32_id %278 %205 %276
        %281 = OpIEqual %bool_id %231 %u32_id_18
        %282 = OpSelect %u32_id %281 %204 %279
        %284 = OpIEqual %bool_id %231 %u32_id_19
        %285 = OpSelect %u32_id %284 %203 %282
        %287 = OpIEqual %bool_id %231 %u32_id_20
        %288 = OpSelect %u32_id %287 %202 %285
        %290 = OpIEqual %bool_id %231 %u32_id_21
        %291 = OpSelect %u32_id %290 %201 %288
        %293 = OpIEqual %bool_id %231 %u32_id_22
        %294 = OpSelect %u32_id %293 %200 %291
        %296 = OpIEqual %bool_id %231 %u32_id_23
        %297 = OpSelect %u32_id %296 %199 %294
        %298 = OpIEqual %bool_id %231 %u32_id_24
        %299 = OpSelect %u32_id %298 %198 %297
        %301 = OpIEqual %bool_id %231 %u32_id_25
        %302 = OpSelect %u32_id %301 %197 %299
        %304 = OpIEqual %bool_id %231 %u32_id_26
        %305 = OpSelect %u32_id %304 %196 %302
        %307 = OpIEqual %bool_id %231 %u32_id_27
        %308 = OpSelect %u32_id %307 %195 %305
        %310 = OpIEqual %bool_id %231 %u32_id_28
        %311 = OpSelect %u32_id %310 %224 %308
        %313 = OpIEqual %bool_id %231 %u32_id_29
        %314 = OpSelect %u32_id %313 %228 %311
        %316 = OpIEqual %bool_id %231 %u32_id_30
        %317 = OpSelect %u32_id %316 %193 %314
        %319 = OpIEqual %bool_id %231 %u32_id_31
        %320 = OpSelect %u32_id %319 %192 %317
               OpBranch %70
         %70 = OpLabel
        %321 = OpPhi %u32_id %320 %69 %228 %68
               OpBranch %71
         %71 = OpLabel
               OpBranchConditional %235 %67 %72
         %72 = OpLabel
        %322 = OpShiftRightLogical %u32_id %321 %u32_id_16
        %323 = OpIMul %u32_id %322 %u32_id_4
        %324 = OpIAdd %u32_id %323 %buf1_dword_off
        %325 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %324
        %326 = OpLoad %u32_id %325
        %327 = OpIAdd %u32_id %324 %u32_id_1
        %328 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %327
        %329 = OpLoad %u32_id %328
        %330 = OpIAdd %u32_id %324 %u32_id_2
        %331 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %330
        %332 = OpLoad %u32_id %331
        %333 = OpIAdd %u32_id %324 %u32_id_3
        %334 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %333
        %335 = OpLoad %u32_id %334
        %336 = OpCompositeConstruct %u32vec4_id %326 %329 %332 %335
        %337 = OpCompositeExtract %u32_id %336 0
        %338 = OpCompositeExtract %u32_id %336 1
        %339 = OpCompositeExtract %u32_id %336 2
        %340 = OpCompositeExtract %u32_id %336 3
        %341 = OpINotEqual %bool_id %u32_id_0 %201
        %344 = OpSelect %f32_id %341 %f32_id_0x1pn148 %f32_id_0x1pn149
        %345 = OpBitcast %u32_id %344
        %347 = OpIAdd %u32_id %224 %u32_id_4294967295
        %348 = OpUGreaterThanEqual %bool_id %u32_id_1 %345
        %349 = OpLogicalAnd %bool_id %226 %348
               OpSelectionMerge %74 None
               OpBranchConditional %349 %73 %74
         %73 = OpLabel
        %350 = OpBitFieldUExtract %u32_id %337 %u32_id_1 %u32_id_1
        %351 = OpIEqual %bool_id %u32_id_0 %350
        %352 = OpBitcast %f32_id %202
        %353 = OpBitcast %f32_id %204
        %354 = OpSelect %f32_id %351 %353 %352
        %355 = OpBitcast %f32_id %339
        %356 = OpFSub %f32_id %355 %354
        %357 = OpBitcast %f32_id %340
        %358 = OpFNegate %f32_id %357
        %360 = OpExtInst %f32_id %359 FAbs %356
        %361 = OpFAdd %f32_id %358 %360
        %362 = OpFMul %f32_id %361 %361
        %363 = OpBitcast %u32_id %362
        %364 = OpExtInst %f32_id %359 FAbs %356
        %365 = OpBitcast %f32_id %340
        %366 = OpFOrdGreaterThan %bool_id %364 %365
        %367 = OpSelect %f32_id %366 %362 %f32_id_0
        %368 = OpBitcast %u32_id %367
        %369 = OpBitcast %f32_id %196
        %370 = OpFOrdGreaterThan %bool_id %367 %369
        %371 = OpLogicalNot %bool_id %370
        %372 = OpLogicalAnd %bool_id %226 %371
               OpBranch %74
         %74 = OpLabel
        %373 = OpPhi %u32_id %368 %73 %339 %72
        %374 = OpPhi %u32_id %363 %73 %199 %72
        %375 = OpPhi %bool_id %372 %73 %226 %72
        %376 = OpUGreaterThanEqual %bool_id %u32_id_2 %345
        %377 = OpLogicalAnd %bool_id %375 %376
               OpSelectionMerge %104 None
               OpBranchConditional %377 %75 %104
         %75 = OpLabel
        %379 = OpUGreaterThan %bool_id %u32_id_4294967292 %337
        %380 = OpLogicalAnd %bool_id %377 %379
               OpSelectionMerge %85 None
               OpBranchConditional %380 %76 %85
         %76 = OpLabel
        %381 = OpShiftRightLogical %u32_id %337 %u32_id_2
        %382 = OpIAdd %u32_id %381 %u32_id_1
        %383 = OpIMul %u32_id %382 %u32_id_4
        %384 = OpIAdd %u32_id %383 %buf2_dword_off
        %385 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %384
        %386 = OpLoad %u32_id %385
        %387 = OpIAdd %u32_id %384 %u32_id_1
        %388 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %387
        %389 = OpLoad %u32_id %388
        %390 = OpIAdd %u32_id %384 %u32_id_2
        %391 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %390
        %392 = OpLoad %u32_id %391
        %393 = OpCompositeConstruct %u32vec3_id %386 %389 %392
        %394 = OpCompositeExtract %u32_id %393 0
        %395 = OpCompositeExtract %u32_id %393 1
        %396 = OpCompositeExtract %u32_id %393 2
        %397 = OpIMul %u32_id %381 %u32_id_4
        %398 = OpIAdd %u32_id %397 %buf2_dword_off
        %399 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %398
        %400 = OpLoad %u32_id %399
        %401 = OpIAdd %u32_id %398 %u32_id_1
        %402 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %401
        %403 = OpLoad %u32_id %402
        %404 = OpIAdd %u32_id %398 %u32_id_2
        %405 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %404
        %406 = OpLoad %u32_id %405
        %407 = OpCompositeConstruct %u32vec3_id %400 %403 %406
        %408 = OpCompositeExtract %u32_id %407 0
        %409 = OpCompositeExtract %u32_id %407 1
        %410 = OpCompositeExtract %u32_id %407 2
        %411 = OpBitcast %f32_id %394
        %412 = OpBitcast %f32_id %408
        %413 = OpFSub %f32_id %411 %412
        %414 = OpBitcast %f32_id %204
        %415 = OpBitcast %f32_id %408
        %416 = OpFSub %f32_id %414 %415
        %417 = OpFMul %f32_id %413 %416
        %418 = OpBitcast %f32_id %395
        %419 = OpBitcast %f32_id %409
        %420 = OpFSub %f32_id %418 %419
        %421 = OpBitcast %f32_id %203
        %422 = OpBitcast %f32_id %409
        %423 = OpFSub %f32_id %421 %422
        %424 = OpBitcast %u32_id %423
        %425 = OpFMul %f32_id %413 %413
        %426 = OpBitcast %f32_id %396
        %427 = OpBitcast %f32_id %410
        %428 = OpFSub %f32_id %426 %427
        %429 = OpBitcast %f32_id %202
        %430 = OpBitcast %f32_id %410
        %431 = OpFSub %f32_id %429 %430
        %432 = OpBitcast %u32_id %431
        %433 = OpFMul %f32_id %423 %420
        %434 = OpFAdd %f32_id %433 %417
        %435 = OpFMul %f32_id %420 %420
        %436 = OpFAdd %f32_id %435 %425
        %437 = OpFMul %f32_id %431 %428
        %438 = OpFAdd %f32_id %437 %434
        %439 = OpFMul %f32_id %428 %428
        %440 = OpFAdd %f32_id %439 %436
        %441 = OpFOrdLessThan %bool_id %438 %440
        %442 = OpFOrdLessThan %bool_id %f32_id_0 %438
        %443 = OpFOrdGreaterThanEqual %bool_id %f32_id_0 %438
        %444 = OpLogicalAnd %bool_id %442 %441
        %445 = OpLogicalAnd %bool_id %380 %444
               OpSelectionMerge %78 None
               OpBranchConditional %445 %77 %78
         %77 = OpLabel
        %446 = OpFMul %f32_id %416 %416
        %447 = OpFMul %f32_id %423 %423
        %448 = OpFAdd %f32_id %447 %446
        %450 = OpFDiv %f32_id %f32_id_1 %440
        %451 = OpBitcast %u32_id %450
        %452 = OpFMul %f32_id %450 %438
        %453 = OpBitcast %u32_id %452
        %454 = OpFMul %f32_id %431 %431
        %455 = OpFAdd %f32_id %454 %448
        %456 = OpBitcast %u32_id %455
        %457 = OpFNegate %f32_id %438
        %458 = OpFMul %f32_id %457 %452
        %459 = OpFAdd %f32_id %458 %455
        %460 = OpBitcast %u32_id %459
               OpBranch %78
         %78 = OpLabel
        %461 = OpPhi %u32_id %456 %77 %396 %76
        %462 = OpPhi %u32_id %451 %77 %395 %76
        %463 = OpPhi %u32_id %453 %77 %394 %76
        %464 = OpPhi %u32_id %460 %77 %432 %76
        %465 = OpLogicalNot %bool_id %445
        %466 = OpLogicalAnd %bool_id %380 %465
               OpSelectionMerge %84 None
               OpBranchConditional %466 %79 %84
         %79 = OpLabel
        %467 = OpLogicalAnd %bool_id %466 %443
               OpSelectionMerge %81 None
               OpBranchConditional %467 %80 %81
         %80 = OpLabel
        %468 = OpFMul %f32_id %416 %416
        %469 = OpFMul %f32_id %423 %423
        %470 = OpFAdd %f32_id %469 %468
        %471 = OpBitcast %f32_id %464
        %472 = OpBitcast %f32_id %464
        %473 = OpFMul %f32_id %471 %472
        %474 = OpFAdd %f32_id %473 %470
        %475 = OpBitcast %u32_id %474
               OpBranch %81
         %81 = OpLabel
        %476 = OpPhi %u32_id %475 %80 %464 %79
        %477 = OpPhi %u32_id %u32_id_0 %80 %463 %79
        %478 = OpLogicalNot %bool_id %467
        %479 = OpLogicalAnd %bool_id %466 %478
               OpSelectionMerge %83 None
               OpBranchConditional %479 %82 %83
         %82 = OpLabel
        %480 = OpBitcast %f32_id %204
        %481 = OpBitcast %f32_id %477
        %482 = OpFSub %f32_id %480 %481
        %483 = OpFMul %f32_id %482 %482
        %484 = OpBitcast %f32_id %203
        %485 = OpBitcast %f32_id %462
        %486 = OpFSub %f32_id %484 %485
        %487 = OpFMul %f32_id %486 %486
        %488 = OpFAdd %f32_id %487 %483
        %489 = OpBitcast %f32_id %202
        %490 = OpBitcast %f32_id %461
        %491 = OpFSub %f32_id %489 %490
        %492 = OpBitcast %u32_id %491
        %493 = OpFMul %f32_id %491 %491
        %494 = OpFAdd %f32_id %493 %488
        %495 = OpBitcast %u32_id %494
               OpBranch %83
         %83 = OpLabel
        %496 = OpPhi %u32_id %492 %82 %462 %81
        %497 = OpPhi %u32_id %495 %82 %476 %81
        %498 = OpPhi %u32_id %u32_id_1065353216 %82 %477 %81
               OpBranch %84
         %84 = OpLabel
        %499 = OpPhi %u32_id %496 %83 %462 %78
        %500 = OpPhi %u32_id %498 %83 %463 %78
        %501 = OpPhi %u32_id %497 %83 %464 %78
        %502 = OpBitcast %f32_id %501
        %503 = OpBitcast %f32_id %196
        %504 = OpFOrdLessThan %bool_id %502 %503
        %506 = OpIEqual %bool_id %u32_id_1073741823 %195
        %507 = OpLogicalOr %bool_id %504 %506
        %508 = OpBitcast %f32_id %196
        %509 = OpBitcast %f32_id %501
        %510 = OpSelect %f32_id %507 %509 %508
        %511 = OpBitcast %u32_id %510
        %512 = OpBitcast %f32_id %195
        %513 = OpBitcast %f32_id %381
        %514 = OpSelect %f32_id %507 %513 %512
        %515 = OpBitcast %u32_id %514
        %516 = OpBitcast %f32_id %197
        %517 = OpBitcast %f32_id %500
        %518 = OpSelect %f32_id %507 %517 %516
        %519 = OpBitcast %u32_id %518
               OpBranch %85
         %85 = OpLabel
        %520 = OpPhi %u32_id %381 %84 %340 %75
        %521 = OpPhi %u32_id %461 %84 %373 %75
        %522 = OpPhi %u32_id %515 %84 %195 %75
        %523 = OpPhi %u32_id %511 %84 %196 %75
        %524 = OpPhi %u32_id %519 %84 %197 %75
        %525 = OpPhi %u32_id %501 %84 %374 %75
        %526 = OpPhi %u32_id %424 %84 %345 %75
        %527 = OpPhi %u32_id %u32_id_0 %84 %201 %75
        %528 = OpPhi %u32_id %499 %84 %338 %75
        %529 = OpPhi %u32_id %500 %84 %337 %75
        %530 = OpLogicalNot %bool_id %380
        %531 = OpLogicalAnd %bool_id %377 %530
               OpSelectionMerge %103 None
               OpBranchConditional %531 %86 %103
         %86 = OpLabel
        %532 = OpBitwiseAnd %u32_id %u32_id_1 %529
        %533 = OpIEqual %bool_id %u32_id_0 %532
        %534 = OpBitcast %f32_id %202
        %535 = OpBitcast %f32_id %204
        %536 = OpSelect %f32_id %533 %535 %534
        %537 = OpBitcast %f32_id %528
        %538 = OpFOrdLessThan %bool_id %536 %537
        %539 = OpIAdd %u32_id %322 %u32_id_1
        %540 = OpLogicalAnd %bool_id %531 %538
               OpSelectionMerge %88 None
               OpBranchConditional %540 %87 %88
         %87 = OpLabel
        %541 = OpCompositeConstruct %u32vec2_id %ud_2 %ud_3
        %542 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_24
        %543 = OpLoad %u32_id %542
        %544 = OpIAdd %u32_id %543 %u32_id_31
        %545 = OpISub %u32_id %544 %321
        %546 = OpBitFieldUExtract %u32_id %545 %u32_id_0 %u32_id_4
        %547 = OpShiftLeftLogical %u32_id %u32_id_1 %546
        %548 = OpISub %u32_id %547 %u32_id_1
        %549 = OpShiftLeftLogical %u32_id %548 %u32_id_0
        %550 = OpIAdd %u32_id %549 %539
               OpBranch %88
         %88 = OpLabel
        %551 = OpPhi %u32_id %550 %87 %539 %86
        %552 = OpIAdd %u32_id %321 %u32_id_1
        %553 = OpShiftLeftLogical %u32_id %551 %u32_id_16
        %554 = OpBitcast %f32_id %528
        %555 = OpFOrdGreaterThanEqual %bool_id %536 %554
        %557 = OpBitwiseAnd %u32_id %u32_id_65535 %552
        %558 = OpBitwiseOr %u32_id %557 %553
               OpBranch %89
         %89 = OpLabel
        %559 = OpPhi %u32_id %347 %88 %662 %93
        %560 = OpPhi %u32_id %322 %88 %663 %93
        %561 = OpPhi %u32_id %321 %88 %664 %93
        %562 = OpPhi %u32_id %522 %88 %666 %93
        %563 = OpPhi %u32_id %523 %88 %667 %93
        %564 = OpPhi %u32_id %524 %88 %668 %93
        %565 = OpPhi %u32_id %198 %88 %669 %93
        %566 = OpPhi %u32_id %525 %88 %670 %93
        %567 = OpPhi %u32_id %526 %88 %671 %93
        %568 = OpPhi %u32_id %527 %88 %672 %93
        %569 = OpPhi %u32_id %202 %88 %673 %93
        %570 = OpPhi %u32_id %203 %88 %674 %93
        %571 = OpPhi %u32_id %204 %88 %675 %93
        %572 = OpPhi %u32_id %552 %88 %676 %93
        %573 = OpPhi %u32_id %553 %88 %677 %93
        %574 = OpPhi %u32_id %528 %88 %678 %93
        %575 = OpPhi %u32_id %558 %88 %679 %93
        %576 = OpPhi %u32_id %209 %88 %680 %93
        %577 = OpPhi %u32_id %210 %88 %681 %93
        %578 = OpPhi %u32_id %211 %88 %682 %93
        %579 = OpPhi %u32_id %212 %88 %683 %93
        %580 = OpPhi %u32_id %213 %88 %684 %93
        %581 = OpPhi %u32_id %214 %88 %685 %93
        %582 = OpPhi %u32_id %215 %88 %686 %93
        %583 = OpPhi %u32_id %216 %88 %687 %93
        %584 = OpPhi %u32_id %217 %88 %688 %93
        %585 = OpPhi %u32_id %218 %88 %689 %93
        %586 = OpPhi %u32_id %219 %88 %690 %93
        %587 = OpPhi %u32_id %220 %88 %691 %93
        %588 = OpPhi %u32_id %221 %88 %692 %93
        %589 = OpPhi %u32_id %222 %88 %693 %93
        %590 = OpPhi %bool_id %531 %88 %597 %93
        %591 = OpPhi %bool_id %531 %88 %597 %93
        %592 = OpPhi %u32_id %224 %88 %665 %93
               OpLoopMerge %94 %93 None
               OpBranch %90
         %90 = OpLabel
        %593 = OpGroupNonUniformBroadcastFirst %u32_id %u32_id_3 %592
        %594 = OpIEqual %bool_id %593 %592
        %595 = OpLogicalAnd %bool_id %590 %594
        %596 = OpLogicalNot %bool_id %595
        %597 = OpLogicalAnd %bool_id %591 %596
               OpSelectionMerge %92 None
               OpBranchConditional %595 %91 %92
         %91 = OpLabel
        %598 = OpIEqual %bool_id %593 %u32_id_0
        %599 = OpSelect %u32_id %598 %575 %589
        %600 = OpIEqual %bool_id %593 %u32_id_1
        %601 = OpSelect %u32_id %600 %575 %588
        %602 = OpIEqual %bool_id %593 %u32_id_2
        %603 = OpSelect %u32_id %602 %575 %587
        %604 = OpIEqual %bool_id %593 %u32_id_3
        %605 = OpSelect %u32_id %604 %575 %586
        %606 = OpIEqual %bool_id %593 %u32_id_4
        %607 = OpSelect %u32_id %606 %575 %585
        %608 = OpIEqual %bool_id %593 %u32_id_5
        %609 = OpSelect %u32_id %608 %575 %584
        %610 = OpIEqual %bool_id %593 %u32_id_6
        %611 = OpSelect %u32_id %610 %575 %583
        %612 = OpIEqual %bool_id %593 %u32_id_7
        %613 = OpSelect %u32_id %612 %575 %582
        %614 = OpIEqual %bool_id %593 %u32_id_8
        %615 = OpSelect %u32_id %614 %575 %581
        %616 = OpIEqual %bool_id %593 %u32_id_9
        %617 = OpSelect %u32_id %616 %575 %580
        %618 = OpIEqual %bool_id %593 %u32_id_10
        %619 = OpSelect %u32_id %618 %575 %579
        %620 = OpIEqual %bool_id %593 %u32_id_11
        %621 = OpSelect %u32_id %620 %575 %578
        %622 = OpIEqual %bool_id %593 %u32_id_12
        %623 = OpSelect %u32_id %622 %575 %577
        %624 = OpIEqual %bool_id %593 %u32_id_13
        %625 = OpSelect %u32_id %624 %575 %576
        %626 = OpIEqual %bool_id %593 %u32_id_14
        %627 = OpSelect %u32_id %626 %575 %575
        %628 = OpIEqual %bool_id %593 %u32_id_15
        %629 = OpSelect %u32_id %628 %575 %574
        %630 = OpIEqual %bool_id %593 %u32_id_16
        %631 = OpSelect %u32_id %630 %575 %573
        %632 = OpIEqual %bool_id %593 %u32_id_17
        %633 = OpSelect %u32_id %632 %575 %572
        %634 = OpIEqual %bool_id %593 %u32_id_18
        %635 = OpSelect %u32_id %634 %575 %571
        %636 = OpIEqual %bool_id %593 %u32_id_19
        %637 = OpSelect %u32_id %636 %575 %570
        %638 = OpIEqual %bool_id %593 %u32_id_20
        %639 = OpSelect %u32_id %638 %575 %569
        %640 = OpIEqual %bool_id %593 %u32_id_21
        %641 = OpSelect %u32_id %640 %575 %568
        %642 = OpIEqual %bool_id %593 %u32_id_22
        %643 = OpSelect %u32_id %642 %575 %567
        %644 = OpIEqual %bool_id %593 %u32_id_23
        %645 = OpSelect %u32_id %644 %575 %566
        %646 = OpIEqual %bool_id %593 %u32_id_24
        %647 = OpSelect %u32_id %646 %575 %565
        %648 = OpIEqual %bool_id %593 %u32_id_25
        %649 = OpSelect %u32_id %648 %575 %564
        %650 = OpIEqual %bool_id %593 %u32_id_26
        %651 = OpSelect %u32_id %650 %575 %563
        %652 = OpIEqual %bool_id %593 %u32_id_27
        %653 = OpSelect %u32_id %652 %575 %562
        %654 = OpIEqual %bool_id %593 %u32_id_28
        %655 = OpSelect %u32_id %654 %575 %592
        %656 = OpIEqual %bool_id %593 %u32_id_29
        %657 = OpSelect %u32_id %656 %575 %561
        %658 = OpIEqual %bool_id %593 %u32_id_30
        %659 = OpSelect %u32_id %658 %575 %560
        %660 = OpIEqual %bool_id %593 %u32_id_31
        %661 = OpSelect %u32_id %660 %575 %559
               OpBranch %92
         %92 = OpLabel
        %662 = OpPhi %u32_id %661 %91 %559 %90
        %663 = OpPhi %u32_id %659 %91 %560 %90
        %664 = OpPhi %u32_id %657 %91 %561 %90
        %665 = OpPhi %u32_id %655 %91 %592 %90
        %666 = OpPhi %u32_id %653 %91 %562 %90
        %667 = OpPhi %u32_id %651 %91 %563 %90
        %668 = OpPhi %u32_id %649 %91 %564 %90
        %669 = OpPhi %u32_id %647 %91 %565 %90
        %670 = OpPhi %u32_id %645 %91 %566 %90
        %671 = OpPhi %u32_id %643 %91 %567 %90
        %672 = OpPhi %u32_id %641 %91 %568 %90
        %673 = OpPhi %u32_id %639 %91 %569 %90
        %674 = OpPhi %u32_id %637 %91 %570 %90
        %675 = OpPhi %u32_id %635 %91 %571 %90
        %676 = OpPhi %u32_id %633 %91 %572 %90
        %677 = OpPhi %u32_id %631 %91 %573 %90
        %678 = OpPhi %u32_id %629 %91 %574 %90
        %679 = OpPhi %u32_id %627 %91 %575 %90
        %680 = OpPhi %u32_id %625 %91 %576 %90
        %681 = OpPhi %u32_id %623 %91 %577 %90
        %682 = OpPhi %u32_id %621 %91 %578 %90
        %683 = OpPhi %u32_id %619 %91 %579 %90
        %684 = OpPhi %u32_id %617 %91 %580 %90
        %685 = OpPhi %u32_id %615 %91 %581 %90
        %686 = OpPhi %u32_id %613 %91 %582 %90
        %687 = OpPhi %u32_id %611 %91 %583 %90
        %688 = OpPhi %u32_id %609 %91 %584 %90
        %689 = OpPhi %u32_id %607 %91 %585 %90
        %690 = OpPhi %u32_id %605 %91 %586 %90
        %691 = OpPhi %u32_id %603 %91 %587 %90
        %692 = OpPhi %u32_id %601 %91 %588 %90
        %693 = OpPhi %u32_id %599 %91 %589 %90
               OpBranch %93
         %93 = OpLabel
               OpBranchConditional %597 %89 %94
         %94 = OpLabel
        %694 = OpIAdd %u32_id %663 %u32_id_1
        %695 = OpLogicalAnd %bool_id %531 %555
               OpSelectionMerge %96 None
               OpBranchConditional %695 %95 %96
         %95 = OpLabel
        %696 = OpCompositeConstruct %u32vec2_id %ud_2 %ud_3
        %697 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_24
        %698 = OpLoad %u32_id %697
        %699 = OpIAdd %u32_id %698 %u32_id_31
        %700 = OpISub %u32_id %699 %664
        %701 = OpBitFieldUExtract %u32_id %700 %u32_id_0 %u32_id_4
        %702 = OpShiftLeftLogical %u32_id %u32_id_1 %701
        %703 = OpISub %u32_id %702 %u32_id_1
        %704 = OpShiftLeftLogical %u32_id %703 %u32_id_0
        %705 = OpIAdd %u32_id %704 %694
               OpBranch %96
         %96 = OpLabel
        %706 = OpPhi %u32_id %705 %95 %694 %94
        %707 = OpIAdd %u32_id %664 %u32_id_1
        %708 = OpBitwiseAnd %u32_id %u32_id_65535 %707
        %709 = OpShiftLeftLogical %u32_id %706 %u32_id_16
        %710 = OpBitwiseOr %u32_id %708 %709
        %711 = OpIAdd %u32_id %665 %u32_id_1
               OpBranch %97
         %97 = OpLabel
        %712 = OpPhi %u32_id %663 %96 %816 %101
        %713 = OpPhi %u32_id %664 %96 %817 %101
        %714 = OpPhi %u32_id %665 %96 %818 %101
        %715 = OpPhi %u32_id %666 %96 %819 %101
        %716 = OpPhi %u32_id %667 %96 %820 %101
        %717 = OpPhi %u32_id %668 %96 %821 %101
        %718 = OpPhi %u32_id %669 %96 %822 %101
        %719 = OpPhi %u32_id %670 %96 %823 %101
        %720 = OpPhi %u32_id %671 %96 %824 %101
        %721 = OpPhi %u32_id %672 %96 %825 %101
        %722 = OpPhi %u32_id %673 %96 %826 %101
        %723 = OpPhi %u32_id %674 %96 %827 %101
        %724 = OpPhi %u32_id %675 %96 %828 %101
        %725 = OpPhi %u32_id %676 %96 %829 %101
        %726 = OpPhi %u32_id %677 %96 %830 %101
        %727 = OpPhi %u32_id %708 %96 %831 %101
        %728 = OpPhi %u32_id %710 %96 %832 %101
        %729 = OpPhi %u32_id %680 %96 %833 %101
        %730 = OpPhi %u32_id %681 %96 %834 %101
        %731 = OpPhi %u32_id %682 %96 %835 %101
        %732 = OpPhi %u32_id %683 %96 %836 %101
        %733 = OpPhi %u32_id %684 %96 %837 %101
        %734 = OpPhi %u32_id %685 %96 %838 %101
        %735 = OpPhi %u32_id %686 %96 %839 %101
        %736 = OpPhi %u32_id %687 %96 %840 %101
        %737 = OpPhi %u32_id %688 %96 %841 %101
        %738 = OpPhi %u32_id %689 %96 %842 %101
        %739 = OpPhi %u32_id %690 %96 %843 %101
        %740 = OpPhi %u32_id %691 %96 %844 %101
        %741 = OpPhi %u32_id %692 %96 %845 %101
        %742 = OpPhi %u32_id %693 %96 %846 %101
        %743 = OpPhi %bool_id %531 %96 %750 %101
        %744 = OpPhi %bool_id %531 %96 %750 %101
        %745 = OpPhi %u32_id %711 %96 %815 %101
               OpLoopMerge %102 %101 None
               OpBranch %98
         %98 = OpLabel
        %746 = OpGroupNonUniformBroadcastFirst %u32_id %u32_id_3 %745
        %747 = OpIEqual %bool_id %746 %745
        %748 = OpLogicalAnd %bool_id %743 %747
        %749 = OpLogicalNot %bool_id %748
        %750 = OpLogicalAnd %bool_id %744 %749
               OpSelectionMerge %100 None
               OpBranchConditional %748 %99 %100
         %99 = OpLabel
        %751 = OpIEqual %bool_id %746 %u32_id_0
        %752 = OpSelect %u32_id %751 %728 %742
        %753 = OpIEqual %bool_id %746 %u32_id_1
        %754 = OpSelect %u32_id %753 %728 %741
        %755 = OpIEqual %bool_id %746 %u32_id_2
        %756 = OpSelect %u32_id %755 %728 %740
        %757 = OpIEqual %bool_id %746 %u32_id_3
        %758 = OpSelect %u32_id %757 %728 %739
        %759 = OpIEqual %bool_id %746 %u32_id_4
        %760 = OpSelect %u32_id %759 %728 %738
        %761 = OpIEqual %bool_id %746 %u32_id_5
        %762 = OpSelect %u32_id %761 %728 %737
        %763 = OpIEqual %bool_id %746 %u32_id_6
        %764 = OpSelect %u32_id %763 %728 %736
        %765 = OpIEqual %bool_id %746 %u32_id_7
        %766 = OpSelect %u32_id %765 %728 %735
        %767 = OpIEqual %bool_id %746 %u32_id_8
        %768 = OpSelect %u32_id %767 %728 %734
        %769 = OpIEqual %bool_id %746 %u32_id_9
        %770 = OpSelect %u32_id %769 %728 %733
        %771 = OpIEqual %bool_id %746 %u32_id_10
        %772 = OpSelect %u32_id %771 %728 %732
        %773 = OpIEqual %bool_id %746 %u32_id_11
        %774 = OpSelect %u32_id %773 %728 %731
        %775 = OpIEqual %bool_id %746 %u32_id_12
        %776 = OpSelect %u32_id %775 %728 %730
        %777 = OpIEqual %bool_id %746 %u32_id_13
        %778 = OpSelect %u32_id %777 %728 %729
        %779 = OpIEqual %bool_id %746 %u32_id_14
        %780 = OpSelect %u32_id %779 %728 %728
        %781 = OpIEqual %bool_id %746 %u32_id_15
        %782 = OpSelect %u32_id %781 %728 %727
        %783 = OpIEqual %bool_id %746 %u32_id_16
        %784 = OpSelect %u32_id %783 %728 %726
        %785 = OpIEqual %bool_id %746 %u32_id_17
        %786 = OpSelect %u32_id %785 %728 %725
        %787 = OpIEqual %bool_id %746 %u32_id_18
        %788 = OpSelect %u32_id %787 %728 %724
        %789 = OpIEqual %bool_id %746 %u32_id_19
        %790 = OpSelect %u32_id %789 %728 %723
        %791 = OpIEqual %bool_id %746 %u32_id_20
        %792 = OpSelect %u32_id %791 %728 %722
        %793 = OpIEqual %bool_id %746 %u32_id_21
        %794 = OpSelect %u32_id %793 %728 %721
        %795 = OpIEqual %bool_id %746 %u32_id_22
        %796 = OpSelect %u32_id %795 %728 %720
        %797 = OpIEqual %bool_id %746 %u32_id_23
        %798 = OpSelect %u32_id %797 %728 %719
        %799 = OpIEqual %bool_id %746 %u32_id_24
        %800 = OpSelect %u32_id %799 %728 %718
        %801 = OpIEqual %bool_id %746 %u32_id_25
        %802 = OpSelect %u32_id %801 %728 %717
        %803 = OpIEqual %bool_id %746 %u32_id_26
        %804 = OpSelect %u32_id %803 %728 %716
        %805 = OpIEqual %bool_id %746 %u32_id_27
        %806 = OpSelect %u32_id %805 %728 %715
        %807 = OpIEqual %bool_id %746 %u32_id_28
        %808 = OpSelect %u32_id %807 %728 %714
        %809 = OpIEqual %bool_id %746 %u32_id_29
        %810 = OpSelect %u32_id %809 %728 %713
        %811 = OpIEqual %bool_id %746 %u32_id_30
        %812 = OpSelect %u32_id %811 %728 %712
        %813 = OpIEqual %bool_id %746 %u32_id_31
        %814 = OpSelect %u32_id %813 %728 %745
               OpBranch %100
        %100 = OpLabel
        %815 = OpPhi %u32_id %814 %99 %745 %98
        %816 = OpPhi %u32_id %812 %99 %712 %98
        %817 = OpPhi %u32_id %810 %99 %713 %98
        %818 = OpPhi %u32_id %808 %99 %714 %98
        %819 = OpPhi %u32_id %806 %99 %715 %98
        %820 = OpPhi %u32_id %804 %99 %716 %98
        %821 = OpPhi %u32_id %802 %99 %717 %98
        %822 = OpPhi %u32_id %800 %99 %718 %98
        %823 = OpPhi %u32_id %798 %99 %719 %98
        %824 = OpPhi %u32_id %796 %99 %720 %98
        %825 = OpPhi %u32_id %794 %99 %721 %98
        %826 = OpPhi %u32_id %792 %99 %722 %98
        %827 = OpPhi %u32_id %790 %99 %723 %98
        %828 = OpPhi %u32_id %788 %99 %724 %98
        %829 = OpPhi %u32_id %786 %99 %725 %98
        %830 = OpPhi %u32_id %784 %99 %726 %98
        %831 = OpPhi %u32_id %782 %99 %727 %98
        %832 = OpPhi %u32_id %780 %99 %728 %98
        %833 = OpPhi %u32_id %778 %99 %729 %98
        %834 = OpPhi %u32_id %776 %99 %730 %98
        %835 = OpPhi %u32_id %774 %99 %731 %98
        %836 = OpPhi %u32_id %772 %99 %732 %98
        %837 = OpPhi %u32_id %770 %99 %733 %98
        %838 = OpPhi %u32_id %768 %99 %734 %98
        %839 = OpPhi %u32_id %766 %99 %735 %98
        %840 = OpPhi %u32_id %764 %99 %736 %98
        %841 = OpPhi %u32_id %762 %99 %737 %98
        %842 = OpPhi %u32_id %760 %99 %738 %98
        %843 = OpPhi %u32_id %758 %99 %739 %98
        %844 = OpPhi %u32_id %756 %99 %740 %98
        %845 = OpPhi %u32_id %754 %99 %741 %98
        %846 = OpPhi %u32_id %752 %99 %742 %98
               OpBranch %101
        %101 = OpLabel
               OpBranchConditional %750 %97 %102
        %102 = OpLabel
               OpBranch %103
        %103 = OpLabel
        %847 = OpPhi %u32_id %816 %102 %322 %85
        %848 = OpPhi %u32_id %817 %102 %321 %85
        %849 = OpPhi %u32_id %819 %102 %522 %85
        %850 = OpPhi %u32_id %820 %102 %523 %85
        %851 = OpPhi %u32_id %821 %102 %524 %85
        %852 = OpPhi %u32_id %822 %102 %198 %85
        %853 = OpPhi %u32_id %823 %102 %525 %85
        %854 = OpPhi %u32_id %824 %102 %526 %85
        %855 = OpPhi %u32_id %u32_id_1 %102 %527 %85
        %856 = OpPhi %u32_id %826 %102 %202 %85
        %857 = OpPhi %u32_id %827 %102 %203 %85
        %858 = OpPhi %u32_id %828 %102 %204 %85
        %859 = OpPhi %u32_id %829 %102 %520 %85
        %860 = OpPhi %u32_id %830 %102 %521 %85
        %861 = OpPhi %u32_id %831 %102 %528 %85
        %862 = OpPhi %u32_id %832 %102 %529 %85
        %863 = OpPhi %u32_id %833 %102 %209 %85
        %864 = OpPhi %u32_id %834 %102 %210 %85
        %865 = OpPhi %u32_id %835 %102 %211 %85
        %866 = OpPhi %u32_id %836 %102 %212 %85
        %867 = OpPhi %u32_id %837 %102 %213 %85
        %868 = OpPhi %u32_id %838 %102 %214 %85
        %869 = OpPhi %u32_id %839 %102 %215 %85
        %870 = OpPhi %u32_id %840 %102 %216 %85
        %871 = OpPhi %u32_id %841 %102 %217 %85
        %872 = OpPhi %u32_id %842 %102 %218 %85
        %873 = OpPhi %u32_id %843 %102 %219 %85
        %874 = OpPhi %u32_id %844 %102 %220 %85
        %875 = OpPhi %u32_id %845 %102 %221 %85
        %876 = OpPhi %u32_id %846 %102 %222 %85
        %877 = OpPhi %u32_id %815 %102 %347 %85
               OpBranch %104
        %104 = OpLabel
        %878 = OpPhi %u32_id %847 %103 %322 %74
        %879 = OpPhi %u32_id %848 %103 %321 %74
        %880 = OpPhi %u32_id %849 %103 %195 %74
        %881 = OpPhi %u32_id %850 %103 %196 %74
        %882 = OpPhi %u32_id %851 %103 %197 %74
        %883 = OpPhi %u32_id %852 %103 %198 %74
        %884 = OpPhi %u32_id %853 %103 %374 %74
        %885 = OpPhi %u32_id %854 %103 %345 %74
        %886 = OpPhi %u32_id %855 %103 %201 %74
        %887 = OpPhi %u32_id %856 %103 %202 %74
        %888 = OpPhi %u32_id %857 %103 %203 %74
        %889 = OpPhi %u32_id %858 %103 %204 %74
        %890 = OpPhi %u32_id %859 %103 %340 %74
        %891 = OpPhi %u32_id %860 %103 %373 %74
        %892 = OpPhi %u32_id %861 %103 %338 %74
        %893 = OpPhi %u32_id %862 %103 %337 %74
        %894 = OpPhi %u32_id %863 %103 %209 %74
        %895 = OpPhi %u32_id %864 %103 %210 %74
        %896 = OpPhi %u32_id %865 %103 %211 %74
        %897 = OpPhi %u32_id %866 %103 %212 %74
        %898 = OpPhi %u32_id %867 %103 %213 %74
        %899 = OpPhi %u32_id %868 %103 %214 %74
        %900 = OpPhi %u32_id %869 %103 %215 %74
        %901 = OpPhi %u32_id %870 %103 %216 %74
        %902 = OpPhi %u32_id %871 %103 %217 %74
        %903 = OpPhi %u32_id %872 %103 %218 %74
        %904 = OpPhi %u32_id %873 %103 %219 %74
        %905 = OpPhi %u32_id %874 %103 %220 %74
        %906 = OpPhi %u32_id %875 %103 %221 %74
        %907 = OpPhi %u32_id %876 %103 %222 %74
        %908 = OpPhi %u32_id %877 %103 %347 %74
               OpBranch %105
        %105 = OpLabel
               OpBranchConditional %true %64 %106
        %106 = OpLabel
        %909 = OpPhi %u32_id %198 %65 %883 %105
        %910 = OpPhi %u32_id %197 %65 %882 %105
        %911 = OpPhi %u32_id %202 %65 %887 %105
        %912 = OpPhi %u32_id %204 %65 %889 %105
        %913 = OpPhi %u32_id %196 %65 %881 %105
        %914 = OpPhi %u32_id %195 %65 %880 %105
        %915 = OpIAdd %u32_id %914 %u32_id_1
        %916 = OpIMul %u32_id %915 %u32_id_4
        %917 = OpIAdd %u32_id %916 %buf2_dword_off
        %918 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %917
        %919 = OpLoad %u32_id %918
        %920 = OpIAdd %u32_id %917 %u32_id_1
        %921 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %920
        %922 = OpLoad %u32_id %921
        %923 = OpIAdd %u32_id %917 %u32_id_2
        %924 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %923
        %925 = OpLoad %u32_id %924
        %926 = OpIAdd %u32_id %917 %u32_id_3
        %927 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %926
        %928 = OpLoad %u32_id %927
        %929 = OpCompositeConstruct %u32vec4_id %919 %922 %925 %928
        %930 = OpCompositeExtract %u32_id %929 0
        %931 = OpCompositeExtract %u32_id %929 2
        %932 = OpCompositeExtract %u32_id %929 3
        %933 = OpIMul %u32_id %914 %u32_id_4
        %934 = OpIAdd %u32_id %933 %buf2_dword_off
        %935 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %934
        %936 = OpLoad %u32_id %935
        %937 = OpIAdd %u32_id %934 %u32_id_1
        %938 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %937
        %939 = OpLoad %u32_id %938
        %940 = OpIAdd %u32_id %934 %u32_id_2
        %941 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %940
        %942 = OpLoad %u32_id %941
        %943 = OpIAdd %u32_id %934 %u32_id_3
        %944 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %943
        %945 = OpLoad %u32_id %944
        %946 = OpCompositeConstruct %u32vec4_id %936 %939 %942 %945
        %947 = OpCompositeExtract %u32_id %946 0
        %948 = OpCompositeExtract %u32_id %946 2
        %949 = OpCompositeExtract %u32_id %946 3
        %950 = OpCompositeConstruct %u32vec2_id %ud_2 %ud_3
        %951 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_25
        %952 = OpLoad %u32_id %951
        %953 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_26
        %954 = OpLoad %u32_id %953
        %955 = OpBitcast %f32_id %913
        %956 = OpExtInst %f32_id %359 Sqrt %955
        %957 = OpBitcast %f32_id %931
        %958 = OpBitcast %f32_id %948
        %959 = OpFSub %f32_id %957 %958
        %960 = OpBitcast %f32_id %912
        %961 = OpBitcast %f32_id %947
        %962 = OpFSub %f32_id %960 %961
        %963 = OpBitcast %f32_id %930
        %964 = OpBitcast %f32_id %947
        %965 = OpFSub %f32_id %963 %964
        %966 = OpBitcast %f32_id %911
        %967 = OpBitcast %f32_id %948
        %968 = OpFSub %f32_id %966 %967
        %969 = OpBitcast %f32_id %932
        %970 = OpBitcast %f32_id %949
        %971 = OpFSub %f32_id %969 %970
        %972 = OpFMul %f32_id %962 %959
        %973 = OpFMul %f32_id %965 %968
        %974 = OpBitcast %f32_id %910
        %975 = OpBitcast %f32_id %949
        %976 = OpFMul %f32_id %974 %971
        %977 = OpFAdd %f32_id %976 %975
        %978 = OpFOrdLessThan %bool_id %973 %972
        %979 = OpBitcast %f32_id %954
        %980 = OpFMul %f32_id %979 %977
        %982 = OpSelect %f32_id %978 %f32_id_3_14159203 %f32_id_0
        %984 = OpFMul %f32_id %f32_id_6_28318405 %980
        %986 = OpFMul %f32_id %984 %f32_id_3
        %987 = OpFAdd %f32_id %986 %982
        %989 = OpFMul %f32_id %984 %f32_id_7
        %990 = OpFAdd %f32_id %989 %982
        %992 = OpFMul %f32_id %f32_id_0_159154937 %987
        %993 = OpFMul %f32_id %f32_id_0_159154937 %990
        %994 = OpExtInst %f32_id %359 Fract %992
        %995 = OpExtInst %f32_id %359 Fract %993
        %996 = OpFMul %f32_id %f32_id_6_28318548 %994
        %997 = OpExtInst %f32_id %359 Sin %996
        %998 = OpFMul %f32_id %f32_id_6_28318548 %995
        %999 = OpExtInst %f32_id %359 Sin %998
       %1000 = OpFAdd %f32_id %997 %999
       %1001 = OpBitcast %f32_id %952
       %1002 = OpFMul %f32_id %1001 %1000
       %1004 = OpFMul %f32_id %f32_id_0_5 %1002
       %1005 = OpFAdd %f32_id %1004 %956
       %1006 = OpExtInst %f32_id %359 FMax %f32_id_0 %1005
       %1007 = OpFNegate %f32_id %1006
       %1008 = OpSelect %f32_id %978 %1007 %1006
       %1009 = OpConvertFToU %u32_id %977
       %1010 = OpBitcast %f32_id %ud_1
       %1011 = OpFMul %f32_id %1010 %1008
       %1012 = OpBitFieldUExtract %u32_id %1009 %u32_id_0 %u32_id_8
       %1013 = OpConvertUToF %f32_id %1012
       %1014 = OpConvertFToS %u32_id %1011
       %1015 = OpFSub %f32_id %977 %1013
       %1018 = OpExtInst %u32_id %359 SMax %u32_id_32767 %1014
       %1019 = OpExtInst %u32_id %359 SMin %1018 %u32_id_4294934530
       %1020 = OpExtInst %u32_id %359 SMin %u32_id_32767 %1014
       %1021 = OpExtInst %u32_id %359 SMax %1020 %1019
       %1023 = OpFMul %f32_id %f32_id_256 %1015
       %1024 = OpShiftLeftLogical %u32_id %1021 %u32_id_16
       %1026 = OpBitwiseAnd %u32_id %u32_id_255 %1009
       %1027 = OpConvertFToU %u32_id %1023
       %1028 = OpBitwiseOr %u32_id %1024 %1026
       %1029 = OpBitwiseAnd %u32_id %u32_id_255 %1027
       %1030 = OpBitFieldUExtract %u32_id %1029 %u32_id_0 %u32_id_24
       %1032 = OpIMul %u32_id %1030 %u32_id_256
       %1033 = OpIAdd %u32_id %1032 %1028
       %1034 = OpUGreaterThan %bool_id %ud_10 %909
       %1035 = OpLogicalAnd %bool_id %176 %1034
               OpSelectionMerge %108 None
               OpBranchConditional %1035 %107 %108
        %107 = OpLabel
       %1036 = OpIMul %u32_id %909 %u32_id_15
       %1037 = OpIAdd %u32_id %1036 %buf3_dword_off
       %1038 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_4 %u32_id_0 %1037
               OpStore %1038 %1033
               OpBranch %108
        %108 = OpLabel
               OpBranch %109
        %109 = OpLabel
               OpBranch %110
        %110 = OpLabel
               OpReturn
               OpFunctionEnd
