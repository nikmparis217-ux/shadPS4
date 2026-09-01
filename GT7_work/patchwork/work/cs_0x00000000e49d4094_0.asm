; SPIR-V
; Version: 1.6
; Generator: Khronos; 0
; Bound: 575
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
               OpCapability GroupNonUniform
               OpCapability GroupNonUniformBallot
               OpCapability SignedZeroInfNanPreserve
               OpExtension "SPV_KHR_float_controls"
               OpMemoryModel Logical GLSL450
               OpEntryPoint GLCompute %63 "main" %push_data %SubgroupLocalInvocationId %gl_WorkGroupID %gl_LocalInvocationID %ssbo_1 %ssbo_2 %ssbo_3 %ssbo_4 %gds_buffer %srt_flatbuf
               OpExecutionMode %63 LocalSize 64 1 1
               OpExecutionMode %63 SignedZeroInfNanPreserve 32
          %1 = OpString "0xe49d4094"
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
               OpName %ssbo_3 "ssbo_3"
               OpName %ssbo_4 "ssbo_4"
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
               OpName %ud_0 "ud_0"
               OpName %ud_1 "ud_1"
               OpName %ud_2 "ud_2"
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
               OpDecorate %SubgroupLocalInvocationId BuiltIn SubgroupLocalInvocationId
               OpDecorate %SubgroupLocalInvocationId Flat
               OpDecorate %gl_WorkGroupID BuiltIn WorkgroupId
               OpDecorate %gl_LocalInvocationID BuiltIn LocalInvocationId
               OpDecorate %_runtimearr_u32_id ArrayStride 4
               OpDecorate %_struct_53 Block
               OpMemberDecorate %_struct_53 0 Offset 0
               OpDecorate %ssbo_1 Binding 0
               OpDecorate %ssbo_1 DescriptorSet 0
               OpDecorate %ssbo_1 NonWritable
               OpDecorate %ssbo_2 Binding 1
               OpDecorate %ssbo_2 DescriptorSet 0
               OpDecorate %ssbo_2 NonWritable
               OpDecorate %ssbo_3 Binding 2
               OpDecorate %ssbo_3 DescriptorSet 0
               OpDecorate %ssbo_4 Binding 3
               OpDecorate %ssbo_4 DescriptorSet 0
               OpDecorate %gds_buffer Binding 4
               OpDecorate %gds_buffer DescriptorSet 0
               OpDecorate %srt_flatbuf Binding 5
               OpDecorate %srt_flatbuf DescriptorSet 0
               OpDecorate %srt_flatbuf NonWritable
               OpDecorate %178 NoContraction
               OpDecorate %456 NoContraction
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
         %62 = OpTypeFunction %void_id
   %u32_id_8 = OpConstant %u32_id 8
%_ptr_PushConstant_u32_id = OpTypePointer PushConstant %u32_id
   %u32_id_2 = OpConstant %u32_id 2
  %u32_id_16 = OpConstant %u32_id 16
  %u32_id_24 = OpConstant %u32_id 24
   %u32_id_4 = OpConstant %u32_id 4
   %u32_id_3 = OpConstant %u32_id 3
%u32_id_65535 = OpConstant %u32_id 65535
  %u32_id_31 = OpConstant %u32_id 31
  %u32_id_64 = OpConstant %u32_id 64
   %f32_id_1 = OpConstant %f32_id 1
%f32_id_4_2949673e_09 = OpConstant %f32_id 4.2949673e+09
%u32_id_4294967295 = OpConstant %u32_id 4294967295
%f32_id_n0x1_fffffep_128 = OpConstant %f32_id -0x1.fffffep+128
  %u32_id_18 = OpConstant %u32_id 18
  %u32_id_34 = OpConstant %u32_id 34
  %u32_id_19 = OpConstant %u32_id 19
  %u32_id_35 = OpConstant %u32_id 35
   %u32_id_5 = OpConstant %u32_id 5
%f32_id_0x1pn141 = OpConstant %f32_id 0x1p-141
%f32_id_0x1pn149 = OpConstant %f32_id 0x1p-149
 %u32_id_255 = OpConstant %u32_id 255
  %u32_id_63 = OpConstant %u32_id 63
   %u32_id_9 = OpConstant %u32_id 9
  %u32_id_12 = OpConstant %u32_id 12
  %u32_id_28 = OpConstant %u32_id 28
  %u32_id_13 = OpConstant %u32_id 13
  %u32_id_29 = OpConstant %u32_id 29
  %u32_id_14 = OpConstant %u32_id 14
  %u32_id_30 = OpConstant %u32_id 30
  %u32_id_15 = OpConstant %u32_id 15
  %u32_id_17 = OpConstant %u32_id 17
  %u32_id_33 = OpConstant %u32_id 33
  %u32_id_25 = OpConstant %u32_id 25
  %u32_id_11 = OpConstant %u32_id 11
  %u32_id_27 = OpConstant %u32_id 27
  %u32_id_32 = OpConstant %u32_id 32
  %push_data = OpVariable %_ptr_PushConstant_AuxData PushConstant
%SubgroupLocalInvocationId = OpVariable %input_u32 Input
%gl_WorkGroupID = OpVariable %_ptr_Input_u32vec3_id Input
%gl_LocalInvocationID = OpVariable %_ptr_Input_u32vec3_id Input
     %ssbo_1 = OpVariable %_ptr_StorageBuffer__struct_53 StorageBuffer
     %ssbo_2 = OpVariable %_ptr_StorageBuffer__struct_53 StorageBuffer
     %ssbo_3 = OpVariable %_ptr_StorageBuffer__struct_53 StorageBuffer
     %ssbo_4 = OpVariable %_ptr_StorageBuffer__struct_53 StorageBuffer
 %gds_buffer = OpVariable %_ptr_StorageBuffer__struct_53 StorageBuffer
%srt_flatbuf = OpVariable %_ptr_StorageBuffer__struct_53 StorageBuffer
         %63 = OpFunction %void_id None %62
         %64 = OpLabel
         %95 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
         %96 = OpLoad %u32_id %95
   %buf0_off = OpBitFieldUExtract %u32_id %96 %u32_id_0 %u32_id_8
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
        %119 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_2
       %ud_2 = OpLoad %u32_id %119
        %121 = OpLoad %u32vec3_id %gl_LocalInvocationID
        %122 = OpCompositeExtract %u32_id %121 0
        %123 = OpLoad %u32vec3_id %gl_WorkGroupID
        %124 = OpCompositeExtract %u32_id %123 0
        %125 = OpShiftLeftLogical %u32_id %124 %u32_id_4
        %126 = OpShiftRightLogical %u32_id %125 %u32_id_2
        %127 = OpIAdd %u32_id %126 %buf0_dword_off
        %128 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %127
        %129 = OpLoad %u32_id %128
        %130 = OpIAdd %u32_id %126 %u32_id_1
        %131 = OpIAdd %u32_id %130 %buf0_dword_off
        %132 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %131
        %133 = OpLoad %u32_id %132
        %134 = OpIAdd %u32_id %126 %u32_id_2
        %135 = OpIAdd %u32_id %134 %buf0_dword_off
        %136 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %135
        %137 = OpLoad %u32_id %136
        %139 = OpIAdd %u32_id %126 %u32_id_3
        %140 = OpIAdd %u32_id %139 %buf0_dword_off
        %141 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %140
        %142 = OpLoad %u32_id %141
        %144 = OpBitwiseAnd %u32_id %129 %u32_id_65535
        %145 = OpShiftRightLogical %u32_id %129 %u32_id_16
        %146 = OpBitwiseAnd %u32_id %133 %u32_id_65535
        %147 = OpShiftRightLogical %u32_id %133 %u32_id_16
               OpBranch %65
         %65 = OpLabel
        %148 = OpPhi %u32_id %u32_id_0 %64 %160 %68
               OpLoopMerge %69 %68 None
               OpBranch %66
         %66 = OpLabel
        %150 = OpBitwiseAnd %u32_id %148 %u32_id_31
        %151 = OpShiftRightLogical %u32_id %146 %150
        %152 = OpBitwiseAnd %u32_id %148 %u32_id_31
        %153 = OpShiftRightLogical %u32_id %144 %152
        %154 = OpISub %u32_id %151 %153
        %155 = OpBitwiseAnd %u32_id %148 %u32_id_31
        %156 = OpShiftRightLogical %u32_id %147 %155
        %157 = OpBitwiseAnd %u32_id %148 %u32_id_31
        %158 = OpShiftRightLogical %u32_id %145 %157
        %159 = OpISub %u32_id %156 %158
        %160 = OpIAdd %u32_id %148 %u32_id_1
        %161 = OpIAdd %u32_id %159 %u32_id_1
        %162 = OpIMul %u32_id %154 %161
        %163 = OpIAdd %u32_id %161 %162
        %165 = OpUGreaterThan %bool_id %163 %u32_id_64
        %166 = OpLogicalNot %bool_id %165
               OpBranchConditional %166 %69 %67
         %67 = OpLabel
               OpBranch %68
         %68 = OpLabel
               OpBranchConditional %true %65 %69
         %69 = OpLabel
        %167 = OpPhi %u32_id %148 %66 %160 %68
        %168 = OpIAdd %u32_id %154 %u32_id_1
        %169 = OpIMul %u32_id %168 %159
        %170 = OpIAdd %u32_id %168 %169
        %171 = OpINotEqual %bool_id %u32_id_0 %167
        %172 = OpUGreaterThan %bool_id %170 %122
        %173 = OpLogicalNot %bool_id %171
               OpSelectionMerge %83 None
               OpBranchConditional %171 %70 %83
         %70 = OpLabel
               OpSelectionMerge %82 None
               OpBranchConditional %172 %71 %82
         %71 = OpLabel
        %174 = OpConvertUToF %f32_id %168
        %176 = OpFDiv %f32_id %f32_id_1 %174
        %178 = OpFMul %f32_id %f32_id_4_2949673e_09 %176
        %179 = OpConvertFToU %u32_id %178
        %180 = OpUConvert %u64_id %179
        %181 = OpUConvert %u64_id %168
        %182 = OpIMul %u64_id %181 %180
        %183 = OpIAdd %u64_id %182 %u64_id_0
        %184 = OpBitcast %u32vec2_id %183
        %185 = OpCompositeExtract %u32_id %184 0
        %186 = OpCompositeExtract %u32_id %184 1
        %187 = OpINotEqual %bool_id %u32_id_0 %186
        %188 = OpISub %u32_id %u32_id_0 %185
        %189 = OpBitcast %f32_id %188
        %190 = OpBitcast %f32_id %185
        %191 = OpSelect %f32_id %187 %190 %189
        %192 = OpBitcast %u32_id %191
        %193 = OpUMulExtended %full_result_u32x2 %192 %179
        %194 = OpCompositeExtract %u32_id %193 1
        %195 = OpISub %u32_id %179 %194
        %196 = OpIAdd %u32_id %179 %194
        %197 = OpBitcast %f32_id %196
        %198 = OpBitcast %f32_id %195
        %199 = OpSelect %f32_id %187 %198 %197
        %200 = OpBitcast %u32_id %199
        %201 = OpUMulExtended %full_result_u32x2 %200 %122
        %202 = OpCompositeExtract %u32_id %201 1
        %203 = OpIMul %u32_id %168 %202
        %204 = OpISub %u32_id %122 %203
        %205 = OpULessThanEqual %bool_id %168 %204
        %206 = OpUGreaterThanEqual %bool_id %122 %203
        %207 = OpLogicalAnd %bool_id %206 %205
        %208 = OpSelect %u32_id %207 %u32_id_1 %u32_id_0
        %209 = OpIAddCarry %full_result_u32x2 %u32_id_0 %202
        %210 = OpCompositeExtract %u32_id %209 0
        %211 = OpIAddCarry %full_result_u32x2 %210 %208
        %212 = OpCompositeExtract %u32_id %211 0
        %213 = OpSelect %u32_id %206 %u32_id_1 %u32_id_0
        %215 = OpIAddCarry %full_result_u32x2 %u32_id_4294967295 %212
        %216 = OpCompositeExtract %u32_id %215 0
        %217 = OpIAddCarry %full_result_u32x2 %216 %213
        %218 = OpCompositeExtract %u32_id %217 0
        %219 = OpINotEqual %bool_id %u32_id_4294967295 %154
        %220 = OpSelect %bool_id %219 %172 %false
        %221 = OpBitcast %f32_id %218
        %223 = OpSelect %f32_id %220 %221 %f32_id_n0x1_fffffep_128
        %224 = OpBitcast %u32_id %223
        %225 = OpIMul %u32_id %168 %224
        %226 = OpISub %u32_id %122 %225
        %227 = OpIAdd %u32_id %153 %226
        %228 = OpIAdd %u32_id %227 %u32_id_1
        %229 = OpBitwiseAnd %u32_id %167 %u32_id_31
        %230 = OpShiftLeftLogical %u32_id %228 %229
        %231 = OpIAdd %u32_id %230 %u32_id_4294967295
        %232 = OpBitwiseAnd %u32_id %167 %u32_id_31
        %233 = OpShiftLeftLogical %u32_id %227 %232
        %234 = OpIAdd %u32_id %158 %224
        %235 = OpULessThanEqual %bool_id %144 %233
        %236 = OpIAdd %u32_id %234 %u32_id_1
        %237 = OpBitwiseAnd %u32_id %167 %u32_id_31
        %238 = OpShiftLeftLogical %u32_id %236 %237
        %239 = OpIAdd %u32_id %238 %u32_id_4294967295
        %240 = OpUGreaterThanEqual %bool_id %147 %239
        %241 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %244 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_34
        %245 = OpLoad %u32_id %244
        %248 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_35
        %249 = OpLoad %u32_id %248
        %250 = OpUGreaterThanEqual %bool_id %146 %231
        %251 = OpBitwiseAnd %u32_id %167 %u32_id_31
        %252 = OpShiftLeftLogical %u32_id %234 %251
        %253 = OpULessThanEqual %bool_id %145 %252
        %254 = OpLogicalAnd %bool_id %235 %250
        %255 = OpLogicalAnd %bool_id %254 %253
        %257 = OpIMul %u32_id %245 %u32_id_5
        %258 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %259 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_18
        %260 = OpLoad %u32_id %259
        %261 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_19
        %262 = OpLoad %u32_id %261
        %263 = OpLogicalAnd %bool_id %255 %240
        %264 = OpShiftLeftLogical %u32_id %249 %u32_id_1
        %265 = OpIMul %u32_id %245 %264
        %266 = OpIAdd %u32_id %167 %245
        %267 = OpIAdd %u32_id %266 %265
        %268 = OpIAdd %u32_id %167 %257
        %269 = OpShiftLeftLogical %u32_id %267 %u32_id_2
        %270 = OpShiftLeftLogical %u32_id %268 %u32_id_2
        %271 = OpShiftRightLogical %u32_id %269 %u32_id_2
        %272 = OpAccessChain %_ptr_StorageBuffer_u32_id %gds_buffer %u32_id_0 %271
        %273 = OpLoad %u32_id %272
        %274 = OpShiftRightLogical %u32_id %270 %u32_id_2
        %275 = OpAccessChain %_ptr_StorageBuffer_u32_id %gds_buffer %u32_id_0 %274
        %276 = OpLoad %u32_id %275
        %277 = OpIAdd %u32_id %273 %227
        %278 = OpIMul %u32_id %276 %234
        %279 = OpIAdd %u32_id %277 %278
        %280 = OpIAdd %u32_id %279 %buf1_dword_off
        %281 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %280
        %282 = OpLoad %u32_id %281
        %283 = OpBitcast %f32_id %137
        %284 = OpBitcast %f32_id %282
        %285 = OpFOrdGreaterThan %bool_id %283 %284
        %286 = OpLogicalOr %bool_id %285 %263
        %287 = OpIAdd %u32_id %167 %265
        %288 = OpShiftLeftLogical %u32_id %287 %u32_id_2
        %289 = OpShiftRightLogical %u32_id %288 %u32_id_2
        %290 = OpAccessChain %_ptr_StorageBuffer_u32_id %gds_buffer %u32_id_0 %289
        %291 = OpLoad %u32_id %290
        %294 = OpSelect %f32_id %286 %f32_id_0x1pn149 %f32_id_0x1pn141
        %295 = OpIAdd %u32_id %291 %227
        %296 = OpIAdd %u32_id %295 %278
        %297 = OpIAdd %u32_id %296 %buf1_dword_off
        %298 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %297
        %299 = OpLoad %u32_id %298
        %300 = OpBitcast %f32_id %137
        %301 = OpBitcast %f32_id %299
        %302 = OpFOrdGreaterThan %bool_id %300 %301
        %303 = OpSelect %f32_id %302 %294 %f32_id_0
        %304 = OpSelect %f32_id %172 %303 %f32_id_0
        %305 = OpBitcast %u32_id %304
        %306 = OpLoad %u32_id %SubgroupLocalInvocationId
        %308 = OpBitwiseAnd %u32_id %306 %u32_id_255
        %309 = OpBitwiseOr %u32_id %308 %u32_id_0
        %310 = OpBitwiseXor %u32_id %309 %u32_id_16
        %311 = OpGroupNonUniformBroadcast %u32_id %u32_id_3 %305 %310
        %312 = OpIAdd %u32_id %305 %311
        %313 = OpLoad %u32_id %SubgroupLocalInvocationId
        %314 = OpBitwiseAnd %u32_id %313 %u32_id_255
        %315 = OpBitwiseOr %u32_id %314 %u32_id_0
        %316 = OpBitwiseXor %u32_id %315 %u32_id_8
        %317 = OpGroupNonUniformBroadcast %u32_id %u32_id_3 %312 %316
        %318 = OpIAdd %u32_id %312 %317
        %319 = OpLoad %u32_id %SubgroupLocalInvocationId
        %320 = OpBitwiseAnd %u32_id %319 %u32_id_255
        %321 = OpBitwiseOr %u32_id %320 %u32_id_0
        %322 = OpBitwiseXor %u32_id %321 %u32_id_4
        %323 = OpGroupNonUniformBroadcast %u32_id %u32_id_3 %318 %322
        %324 = OpIAdd %u32_id %318 %323
        %325 = OpLoad %u32_id %SubgroupLocalInvocationId
        %326 = OpBitwiseAnd %u32_id %325 %u32_id_255
        %327 = OpBitwiseOr %u32_id %326 %u32_id_0
        %328 = OpBitwiseXor %u32_id %327 %u32_id_2
        %329 = OpGroupNonUniformBroadcast %u32_id %u32_id_3 %324 %328
        %330 = OpIAdd %u32_id %324 %329
        %331 = OpLoad %u32_id %SubgroupLocalInvocationId
        %332 = OpBitwiseAnd %u32_id %331 %u32_id_255
        %333 = OpBitwiseOr %u32_id %332 %u32_id_0
        %334 = OpBitwiseXor %u32_id %333 %u32_id_1
        %335 = OpGroupNonUniformBroadcast %u32_id %u32_id_3 %330 %334
        %336 = OpIAdd %u32_id %330 %335
        %337 = OpGroupNonUniformBroadcast %u32_id %u32_id_3 %336 %u32_id_31
        %339 = OpGroupNonUniformBroadcast %u32_id %u32_id_3 %336 %u32_id_63
        %340 = OpIAdd %u32_id %337 %339
        %341 = OpIEqual %bool_id %u32_id_0 %122
        %342 = OpLogicalAnd %bool_id %172 %341
               OpSelectionMerge %81 None
               OpBranchConditional %342 %72 %81
         %72 = OpLabel
        %343 = OpULessThanEqual %bool_id %340 %u32_id_255
        %345 = OpSelect %u32_id %343 %u32_id_9 %u32_id_0
        %346 = OpBitwiseAnd %u32_id %340 %u32_id_255
        %347 = OpINotEqual %bool_id %346 %u32_id_0
        %348 = OpSelect %u32_id %347 %u32_id_2 %345
        %349 = OpINotEqual %bool_id %u32_id_0 %348
        %350 = OpLogicalNot %bool_id %349
               OpSelectionMerge %76 None
               OpBranchConditional %349 %73 %76
         %73 = OpLabel
        %351 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %354 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_28
        %355 = OpLoad %u32_id %354
        %358 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_29
        %359 = OpLoad %u32_id %358
        %362 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_30
        %363 = OpLoad %u32_id %362
        %365 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_31
        %366 = OpLoad %u32_id %365
        %367 = OpUGreaterThan %bool_id %363 %142
        %368 = OpLogicalAnd %bool_id %342 %367
               OpSelectionMerge %75 None
               OpBranchConditional %368 %74 %75
         %74 = OpLabel
        %369 = OpIAdd %u32_id %142 %buf2_dword_off
        %370 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %369
               OpStore %370 %348
               OpBranch %75
         %75 = OpLabel
               OpBranch %76
         %76 = OpLabel
        %371 = OpPhi %u32_id %348 %75 %122 %72
        %372 = OpPhi %u32_id %366 %75 %144 %72
        %373 = OpPhi %u32_id %363 %75 %ud_2 %72
        %374 = OpPhi %u32_id %359 %75 %ud_1 %72
        %375 = OpPhi %u32_id %355 %75 %ud_0 %72
        %376 = OpPhi %bool_id %368 %75 %342 %72
               OpSelectionMerge %80 None
               OpBranchConditional %350 %77 %80
         %77 = OpLabel
        %377 = OpLogicalAnd %bool_id %376 %342
               OpSelectionMerge %79 None
               OpBranchConditional %377 %78 %79
         %78 = OpLabel
        %378 = OpCompositeConstruct %u32vec2_id %375 %374
        %381 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_33
        %382 = OpLoad %u32_id %381
        %383 = OpCompositeConstruct %u32vec2_id %373 %372
        %384 = OpBitcast %u64_id %383
        %385 = OpBitcast %u32vec2_id %384
        %386 = OpCompositeExtract %u32_id %385 0
        %387 = OpCompositeExtract %u32_id %385 1
        %388 = OpBitCount %u32_id %386
        %389 = OpBitCount %u32_id %387
        %390 = OpIAdd %u32_id %388 %389
        %391 = OpShiftLeftLogical %u32_id %382 %u32_id_2
        %392 = OpIAdd %u32_id %391 %u32_id_24
        %393 = OpShiftRightLogical %u32_id %392 %u32_id_2
        %394 = OpAccessChain %_ptr_StorageBuffer_u32_id %gds_buffer %u32_id_0 %393
        %395 = OpAtomicIAdd %u32_id %394 %u32_id_1 %u32_id_0 %390
               OpBranch %79
         %79 = OpLabel
        %396 = OpPhi %u32_id %395 %78 %u32_id_0 %77
        %397 = OpGroupNonUniformBroadcastFirst %u32_id %u32_id_3 %396
        %398 = OpCompositeConstruct %u32vec2_id %375 %374
        %399 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_24
        %400 = OpLoad %u32_id %399
        %402 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_25
        %403 = OpLoad %u32_id %402
        %406 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_27
        %407 = OpLoad %u32_id %406
        %408 = OpCompositeConstruct %u32vec4_id %129 %133 %137 %142
        %409 = OpIMul %u32_id %397 %u32_id_4
        %410 = OpIAdd %u32_id %409 %buf3_dword_off
        %411 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_4 %u32_id_0 %410
        %412 = OpCompositeExtract %u32_id %408 0
               OpStore %411 %412
        %413 = OpIAdd %u32_id %410 %u32_id_1
        %414 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_4 %u32_id_0 %413
        %415 = OpCompositeExtract %u32_id %408 1
               OpStore %414 %415
        %416 = OpIAdd %u32_id %410 %u32_id_2
        %417 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_4 %u32_id_0 %416
        %418 = OpCompositeExtract %u32_id %408 2
               OpStore %417 %418
        %419 = OpIAdd %u32_id %410 %u32_id_3
        %420 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_4 %u32_id_0 %419
        %421 = OpCompositeExtract %u32_id %408 3
               OpStore %420 %421
               OpBranch %80
         %80 = OpLabel
        %422 = OpPhi %u32_id %403 %79 %374 %76
        %423 = OpPhi %u32_id %400 %79 %375 %76
        %424 = OpPhi %u32_id %129 %79 %371 %76
        %425 = OpPhi %u32_id %407 %79 %372 %76
               OpBranch %81
         %81 = OpLabel
        %426 = OpPhi %u32_id %422 %80 %ud_1 %71
        %427 = OpPhi %u32_id %423 %80 %ud_0 %71
        %428 = OpPhi %bool_id %376 %80 %342 %71
        %429 = OpPhi %u32_id %424 %80 %122 %71
        %430 = OpPhi %u32_id %425 %80 %144 %71
               OpBranch %82
         %82 = OpLabel
        %431 = OpPhi %u32_id %426 %81 %ud_1 %70
        %432 = OpPhi %u32_id %427 %81 %ud_0 %70
        %433 = OpPhi %bool_id %428 %81 %172 %70
        %434 = OpPhi %u32_id %429 %81 %122 %70
        %435 = OpPhi %u32_id %245 %81 %147 %70
        %436 = OpPhi %u32_id %262 %81 %146 %70
        %437 = OpPhi %u32_id %260 %81 %145 %70
        %438 = OpPhi %u32_id %430 %81 %144 %70
               OpBranch %83
         %83 = OpLabel
        %439 = OpPhi %u32_id %431 %82 %ud_1 %69
        %440 = OpPhi %u32_id %432 %82 %ud_0 %69
        %441 = OpPhi %bool_id %433 %82 %true %69
        %442 = OpPhi %u32_id %434 %82 %122 %69
        %443 = OpPhi %u32_id %435 %82 %147 %69
        %444 = OpPhi %u32_id %436 %82 %146 %69
        %445 = OpPhi %u32_id %437 %82 %145 %69
        %446 = OpPhi %u32_id %438 %82 %144 %69
               OpSelectionMerge %91 None
               OpBranchConditional %173 %84 %91
         %84 = OpLabel
        %447 = OpISub %u32_id %444 %446
        %448 = OpIAdd %u32_id %447 %u32_id_1
        %449 = OpISub %u32_id %443 %445
        %450 = OpIMul %u32_id %448 %449
        %451 = OpIAdd %u32_id %448 %450
        %452 = OpUGreaterThan %bool_id %451 %442
        %453 = OpLogicalAnd %bool_id %441 %452
               OpSelectionMerge %90 None
               OpBranchConditional %453 %85 %90
         %85 = OpLabel
        %454 = OpConvertUToF %f32_id %448
        %455 = OpFDiv %f32_id %f32_id_1 %454
        %456 = OpFMul %f32_id %f32_id_4_2949673e_09 %455
        %457 = OpConvertFToU %u32_id %456
        %458 = OpUConvert %u64_id %457
        %459 = OpUConvert %u64_id %448
        %460 = OpIMul %u64_id %459 %458
        %461 = OpIAdd %u64_id %460 %u64_id_0
        %462 = OpBitcast %u32vec2_id %461
        %463 = OpCompositeExtract %u32_id %462 0
        %464 = OpCompositeExtract %u32_id %462 1
        %465 = OpINotEqual %bool_id %u32_id_0 %464
        %466 = OpISub %u32_id %u32_id_0 %463
        %467 = OpBitcast %f32_id %466
        %468 = OpBitcast %f32_id %463
        %469 = OpSelect %f32_id %465 %468 %467
        %470 = OpBitcast %u32_id %469
        %471 = OpUMulExtended %full_result_u32x2 %470 %457
        %472 = OpCompositeExtract %u32_id %471 1
        %473 = OpISub %u32_id %457 %472
        %474 = OpIAdd %u32_id %457 %472
        %475 = OpBitcast %f32_id %474
        %476 = OpBitcast %f32_id %473
        %477 = OpSelect %f32_id %465 %476 %475
        %478 = OpBitcast %u32_id %477
        %479 = OpUMulExtended %full_result_u32x2 %478 %442
        %480 = OpCompositeExtract %u32_id %479 1
        %481 = OpIMul %u32_id %448 %480
        %482 = OpISub %u32_id %442 %481
        %483 = OpULessThanEqual %bool_id %448 %482
        %484 = OpUGreaterThanEqual %bool_id %442 %481
        %485 = OpLogicalAnd %bool_id %484 %483
        %486 = OpSelect %u32_id %485 %u32_id_1 %u32_id_0
        %487 = OpIAddCarry %full_result_u32x2 %u32_id_0 %480
        %488 = OpCompositeExtract %u32_id %487 0
        %489 = OpIAddCarry %full_result_u32x2 %488 %486
        %490 = OpCompositeExtract %u32_id %489 0
        %491 = OpSelect %u32_id %484 %u32_id_1 %u32_id_0
        %492 = OpIAddCarry %full_result_u32x2 %u32_id_4294967295 %490
        %493 = OpCompositeExtract %u32_id %492 0
        %494 = OpIAddCarry %full_result_u32x2 %493 %491
        %495 = OpCompositeExtract %u32_id %494 0
        %496 = OpCompositeConstruct %u32vec2_id %440 %439
        %497 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_34
        %498 = OpLoad %u32_id %497
        %499 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_35
        %500 = OpLoad %u32_id %499
        %501 = OpINotEqual %bool_id %u32_id_4294967295 %447
        %502 = OpSelect %bool_id %501 %453 %false
        %503 = OpBitcast %f32_id %495
        %504 = OpSelect %f32_id %502 %503 %f32_id_n0x1_fffffep_128
        %505 = OpBitcast %u32_id %504
        %506 = OpIMul %u32_id %498 %500
        %507 = OpIMul %u32_id %448 %505
        %508 = OpShiftLeftLogical %u32_id %506 %u32_id_3
        %509 = OpISub %u32_id %442 %507
        %510 = OpShiftRightLogical %u32_id %508 %u32_id_2
        %511 = OpAccessChain %_ptr_StorageBuffer_u32_id %gds_buffer %u32_id_0 %510
        %512 = OpLoad %u32_id %511
        %513 = OpIAdd %u32_id %446 %509
        %514 = OpIAdd %u32_id %445 %505
        %515 = OpIAdd %u32_id %513 %512
        %516 = OpCompositeConstruct %u32vec2_id %440 %439
        %518 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_32
        %519 = OpLoad %u32_id %518
        %520 = OpIMul %u32_id %519 %514
        %521 = OpIAdd %u32_id %515 %520
        %522 = OpIAdd %u32_id %521 %buf1_dword_off
        %523 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %522
        %524 = OpLoad %u32_id %523
        %525 = OpBitcast %f32_id %137
        %526 = OpBitcast %f32_id %524
        %527 = OpFOrdGreaterThan %bool_id %525 %526
        %528 = OpSelect %f32_id %527 %f32_id_0x1pn149 %f32_id_0
        %529 = OpSelect %f32_id %453 %528 %f32_id_0
        %530 = OpBitcast %u32_id %529
        %531 = OpLoad %u32_id %SubgroupLocalInvocationId
        %532 = OpBitwiseAnd %u32_id %531 %u32_id_255
        %533 = OpBitwiseOr %u32_id %532 %u32_id_0
        %534 = OpBitwiseXor %u32_id %533 %u32_id_16
        %535 = OpGroupNonUniformBroadcast %u32_id %u32_id_3 %530 %534
        %536 = OpIAdd %u32_id %530 %535
        %537 = OpLoad %u32_id %SubgroupLocalInvocationId
        %538 = OpBitwiseAnd %u32_id %537 %u32_id_255
        %539 = OpBitwiseOr %u32_id %538 %u32_id_0
        %540 = OpBitwiseXor %u32_id %539 %u32_id_8
        %541 = OpGroupNonUniformBroadcast %u32_id %u32_id_3 %536 %540
        %542 = OpIAdd %u32_id %536 %541
        %543 = OpLoad %u32_id %SubgroupLocalInvocationId
        %544 = OpBitwiseAnd %u32_id %543 %u32_id_255
        %545 = OpBitwiseOr %u32_id %544 %u32_id_0
        %546 = OpBitwiseXor %u32_id %545 %u32_id_4
        %547 = OpGroupNonUniformBroadcast %u32_id %u32_id_3 %542 %546
        %548 = OpIAdd %u32_id %542 %547
        %549 = OpLoad %u32_id %SubgroupLocalInvocationId
        %550 = OpBitwiseAnd %u32_id %549 %u32_id_255
        %551 = OpBitwiseOr %u32_id %550 %u32_id_0
        %552 = OpBitwiseXor %u32_id %551 %u32_id_2
        %553 = OpGroupNonUniformBroadcast %u32_id %u32_id_3 %548 %552
        %554 = OpIAdd %u32_id %548 %553
        %555 = OpLoad %u32_id %SubgroupLocalInvocationId
        %556 = OpBitwiseAnd %u32_id %555 %u32_id_255
        %557 = OpBitwiseOr %u32_id %556 %u32_id_0
        %558 = OpBitwiseXor %u32_id %557 %u32_id_1
        %559 = OpGroupNonUniformBroadcast %u32_id %u32_id_3 %554 %558
        %560 = OpIAdd %u32_id %554 %559
        %561 = OpGroupNonUniformBroadcast %u32_id %u32_id_3 %560 %u32_id_31
        %562 = OpGroupNonUniformBroadcast %u32_id %u32_id_3 %560 %u32_id_63
        %563 = OpIAdd %u32_id %561 %562
        %564 = OpIEqual %bool_id %u32_id_0 %442
        %565 = OpLogicalAnd %bool_id %453 %564
               OpSelectionMerge %89 None
               OpBranchConditional %565 %86 %89
         %86 = OpLabel
        %566 = OpSGreaterThan %bool_id %563 %u32_id_0
        %567 = OpSelect %u32_id %566 %u32_id_2 %u32_id_9
        %568 = OpCompositeConstruct %u32vec2_id %440 %439
        %569 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_30
        %570 = OpLoad %u32_id %569
        %571 = OpUGreaterThan %bool_id %570 %142
        %572 = OpLogicalAnd %bool_id %565 %571
               OpSelectionMerge %88 None
               OpBranchConditional %572 %87 %88
         %87 = OpLabel
        %573 = OpIAdd %u32_id %142 %buf2_dword_off
        %574 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %573
               OpStore %574 %567
               OpBranch %88
         %88 = OpLabel
               OpBranch %89
         %89 = OpLabel
               OpBranch %90
         %90 = OpLabel
               OpBranch %91
         %91 = OpLabel
               OpBranch %92
         %92 = OpLabel
               OpReturn
               OpFunctionEnd
