; SPIR-V
; Version: 1.6
; Generator: Khronos; 0
; Bound: 386
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
               OpMemoryModel Logical GLSL450
               OpEntryPoint GLCompute %65 "main" %push_data %gl_WorkGroupID %gl_LocalInvocationID %shared_mem_u64 %ssbo_1 %ssbo_2 %ssbo_3 %srt_flatbuf
               OpExecutionMode %65 LocalSize 512 1 1
               OpExecutionMode %65 SignedZeroInfNanPreserve 32
          %1 = OpString "0xef4a0dc6"
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
               OpName %shared_mem_u64 "shared_mem_u64"
               OpMemberName %_struct_57 0 "data"
               OpName %ssbo_1 "ssbo_1"
               OpName %ssbo_2 "ssbo_2"
               OpName %ssbo_3 "ssbo_3"
               OpName %srt_flatbuf "srt_flatbuf"
               OpName %buf0_off "buf0_off"
               OpName %buf0_dword_off "buf0_dword_off"
               OpName %buf1_off "buf1_off"
               OpName %buf1_dword_off "buf1_dword_off"
               OpName %buf2_off "buf2_off"
               OpName %buf2_dword_off "buf2_dword_off"
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
               OpDecorate %ssbo_3 NonWritable
               OpDecorate %srt_flatbuf Binding 3
               OpDecorate %srt_flatbuf DescriptorSet 0
               OpDecorate %srt_flatbuf NonWritable
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
%u32_id_1024 = OpConstant %u32_id 1024
%_arr_u64_id_u32_id_1024 = OpTypeArray %u64_id %u32_id_1024
%_ptr_Workgroup__arr_u64_id_u32_id_1024 = OpTypePointer Workgroup %_arr_u64_id_u32_id_1024
%_ptr_Workgroup_u64_id = OpTypePointer Workgroup %u64_id
%u32_id_16368 = OpConstant %u32_id 16368
%_runtimearr_u32_id = OpTypeRuntimeArray %u32_id
 %_struct_57 = OpTypeStruct %_runtimearr_u32_id
%_ptr_StorageBuffer__struct_57 = OpTypePointer StorageBuffer %_struct_57
%_ptr_StorageBuffer_u32_id = OpTypePointer StorageBuffer %u32_id
         %64 = OpTypeFunction %void_id
   %u32_id_8 = OpConstant %u32_id 8
%_ptr_PushConstant_u32_id = OpTypePointer PushConstant %u32_id
   %u32_id_2 = OpConstant %u32_id 2
  %u32_id_16 = OpConstant %u32_id 16
   %u32_id_4 = OpConstant %u32_id 4
 %u32_id_512 = OpConstant %u32_id 512
  %u32_id_28 = OpConstant %u32_id 28
   %u32_id_5 = OpConstant %u32_id 5
  %u32_id_29 = OpConstant %u32_id 29
  %u32_id_40 = OpConstant %u32_id 40
  %u32_id_32 = OpConstant %u32_id 32
   %u32_id_3 = OpConstant %u32_id 3
   %u32_id_6 = OpConstant %u32_id 6
   %u32_id_7 = OpConstant %u32_id 7
  %u32_id_31 = OpConstant %u32_id 31
%u32_id_4096 = OpConstant %u32_id 4096
 %u32_id_264 = OpConstant %u32_id 264
%u32_id_2139095040 = OpConstant %u32_id 2139095040
  %push_data = OpVariable %_ptr_PushConstant_AuxData PushConstant
%gl_WorkGroupID = OpVariable %_ptr_Input_u32vec3_id Input
%gl_LocalInvocationID = OpVariable %_ptr_Input_u32vec3_id Input
%shared_mem_u64 = OpVariable %_ptr_Workgroup__arr_u64_id_u32_id_1024 Workgroup
     %ssbo_1 = OpVariable %_ptr_StorageBuffer__struct_57 StorageBuffer
     %ssbo_2 = OpVariable %_ptr_StorageBuffer__struct_57 StorageBuffer
     %ssbo_3 = OpVariable %_ptr_StorageBuffer__struct_57 StorageBuffer
%srt_flatbuf = OpVariable %_ptr_StorageBuffer__struct_57 StorageBuffer
         %65 = OpFunction %void_id None %64
         %66 = OpLabel
         %87 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
         %88 = OpLoad %u32_id %87
   %buf0_off = OpBitFieldUExtract %u32_id %88 %u32_id_0 %u32_id_8
%buf0_dword_off = OpShiftRightLogical %u32_id %buf0_off %u32_id_2
         %92 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
         %93 = OpLoad %u32_id %92
   %buf1_off = OpBitFieldUExtract %u32_id %93 %u32_id_8 %u32_id_8
%buf1_dword_off = OpShiftRightLogical %u32_id %buf1_off %u32_id_2
         %96 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
         %97 = OpLoad %u32_id %96
   %buf2_off = OpBitFieldUExtract %u32_id %97 %u32_id_16 %u32_id_8
%buf2_dword_off = OpShiftRightLogical %u32_id %buf2_off %u32_id_2
        %102 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_0
       %ud_2 = OpLoad %u32_id %102
        %104 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_1
       %ud_3 = OpLoad %u32_id %104
        %106 = OpLoad %u32vec3_id %gl_LocalInvocationID
        %107 = OpCompositeExtract %u32_id %106 0
        %108 = OpLoad %u32vec3_id %gl_WorkGroupID
        %109 = OpCompositeExtract %u32_id %108 0
        %111 = OpIAdd %u32_id %107 %u32_id_512
        %112 = OpCompositeConstruct %u32vec2_id %ud_2 %ud_3
        %114 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_28
        %115 = OpLoad %u32_id %114
        %118 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_29
        %119 = OpLoad %u32_id %118
        %121 = OpIMul %u32_id %115 %u32_id_40
        %123 = OpIAdd %u32_id %121 %u32_id_32
        %124 = OpShiftRightLogical %u32_id %123 %u32_id_2
        %125 = OpIAdd %u32_id %124 %buf0_dword_off
        %126 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %125
        %127 = OpLoad %u32_id %126
        %128 = OpIAdd %u32_id %124 %u32_id_1
        %129 = OpIAdd %u32_id %128 %buf0_dword_off
        %130 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %129
        %131 = OpLoad %u32_id %130
        %132 = OpShiftRightLogical %u32_id %121 %u32_id_2
        %133 = OpIAdd %u32_id %132 %buf0_dword_off
        %134 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %133
        %135 = OpLoad %u32_id %134
        %136 = OpIAdd %u32_id %132 %u32_id_1
        %137 = OpIAdd %u32_id %136 %buf0_dword_off
        %138 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %137
        %139 = OpLoad %u32_id %138
        %140 = OpIAdd %u32_id %132 %u32_id_2
        %141 = OpIAdd %u32_id %140 %buf0_dword_off
        %142 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %141
        %143 = OpLoad %u32_id %142
        %145 = OpIAdd %u32_id %132 %u32_id_3
        %146 = OpIAdd %u32_id %145 %buf0_dword_off
        %147 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %146
        %148 = OpLoad %u32_id %147
        %149 = OpIAdd %u32_id %132 %u32_id_4
        %150 = OpIAdd %u32_id %149 %buf0_dword_off
        %151 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %150
        %152 = OpLoad %u32_id %151
        %153 = OpIAdd %u32_id %132 %u32_id_5
        %154 = OpIAdd %u32_id %153 %buf0_dword_off
        %155 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %154
        %156 = OpLoad %u32_id %155
        %158 = OpIAdd %u32_id %132 %u32_id_6
        %159 = OpIAdd %u32_id %158 %buf0_dword_off
        %160 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %159
        %161 = OpLoad %u32_id %160
        %163 = OpIAdd %u32_id %132 %u32_id_7
        %164 = OpIAdd %u32_id %163 %buf0_dword_off
        %165 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %164
        %166 = OpLoad %u32_id %165
        %167 = OpIAdd %u32_id %127 %109
        %169 = OpBitwiseAnd %u32_id %135 %u32_id_31
        %170 = OpShiftLeftLogical %u32_id %167 %169
        %171 = OpBitwiseAnd %u32_id %139 %u32_id_31
        %172 = OpShiftLeftLogical %u32_id %u32_id_1 %171
        %173 = OpISub %u32_id %u32_id_0 %172
        %174 = OpBitwiseAnd %u32_id %170 %173
        %175 = OpBitFieldUExtract %u32_id %139 %u32_id_0 %u32_id_4
        %176 = OpShiftLeftLogical %u32_id %u32_id_1 %175
        %177 = OpISub %u32_id %176 %u32_id_1
        %178 = OpShiftLeftLogical %u32_id %177 %u32_id_0
        %179 = OpBitFieldUExtract %u32_id %135 %u32_id_0 %u32_id_4
        %180 = OpShiftLeftLogical %u32_id %u32_id_1 %179
        %181 = OpISub %u32_id %180 %u32_id_1
        %182 = OpShiftLeftLogical %u32_id %181 %u32_id_0
        %183 = OpBitwiseAnd %u32_id %148 %u32_id_31
        %184 = OpShiftLeftLogical %u32_id %174 %183
        %185 = OpBitwiseAnd %u32_id %135 %u32_id_31
        %186 = OpShiftLeftLogical %u32_id %u32_id_1 %185
        %187 = OpISub %u32_id %u32_id_0 %186
        %188 = OpBitwiseAnd %u32_id %187 %107
        %189 = OpBitwiseAnd %u32_id %170 %178
        %190 = OpBitwiseAnd %u32_id %143 %u32_id_31
        %191 = OpShiftLeftLogical %u32_id %188 %190
        %192 = OpBitwiseAnd %u32_id %182 %107
        %193 = OpBitwiseOr %u32_id %184 %189
        %194 = OpBitwiseOr %u32_id %191 %192
        %195 = OpIAdd %u32_id %193 %194
        %196 = OpBitwiseAnd %u32_id %187 %111
        %197 = OpBitwiseAnd %u32_id %166 %195
        %198 = OpBitwiseAnd %u32_id %143 %u32_id_31
        %199 = OpShiftLeftLogical %u32_id %196 %198
        %200 = OpBitwiseAnd %u32_id %182 %111
        %201 = OpINotEqual %bool_id %u32_id_0 %197
        %202 = OpBitwiseXor %u32_id %161 %195
        %203 = OpBitwiseOr %u32_id %199 %200
        %204 = OpBitcast %f32_id %195
        %205 = OpBitcast %f32_id %202
        %206 = OpSelect %f32_id %201 %205 %204
        %207 = OpBitcast %u32_id %206
        %208 = OpIAdd %u32_id %193 %203
        %209 = OpBitwiseAnd %u32_id %166 %208
        %210 = OpUGreaterThan %bool_id %119 %207
        %211 = OpINotEqual %bool_id %u32_id_0 %209
        %212 = OpBitwiseXor %u32_id %161 %208
        %213 = OpBitcast %f32_id %208
        %214 = OpBitcast %f32_id %212
        %215 = OpSelect %f32_id %211 %214 %213
        %216 = OpBitcast %u32_id %215
               OpSelectionMerge %68 None
               OpBranchConditional %210 %67 %68
         %67 = OpLabel
        %217 = OpISub %u32_id %207 %131
        %218 = OpIMul %u32_id %217 %u32_id_2
        %219 = OpIAdd %u32_id %218 %buf1_dword_off
        %220 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %219
        %221 = OpLoad %u32_id %220
        %222 = OpIAdd %u32_id %219 %u32_id_1
        %223 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %222
        %224 = OpLoad %u32_id %223
        %225 = OpCompositeConstruct %u32vec2_id %221 %224
        %226 = OpCompositeExtract %u32_id %225 0
        %227 = OpCompositeExtract %u32_id %225 1
               OpBranch %68
         %68 = OpLabel
        %228 = OpPhi %u32_id %227 %67 %u32_id_0 %66
        %229 = OpPhi %u32_id %226 %67 %u32_id_2139095040 %66
        %230 = OpUGreaterThan %bool_id %119 %216
               OpSelectionMerge %70 None
               OpBranchConditional %230 %69 %70
         %69 = OpLabel
        %231 = OpISub %u32_id %216 %131
        %232 = OpIMul %u32_id %231 %u32_id_2
        %233 = OpIAdd %u32_id %232 %buf1_dword_off
        %234 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %233
        %235 = OpLoad %u32_id %234
        %236 = OpIAdd %u32_id %233 %u32_id_1
        %237 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %236
        %238 = OpLoad %u32_id %237
        %239 = OpCompositeConstruct %u32vec2_id %235 %238
        %240 = OpCompositeExtract %u32_id %239 0
        %241 = OpCompositeExtract %u32_id %239 1
               OpBranch %70
         %70 = OpLabel
        %242 = OpPhi %u32_id %240 %69 %u32_id_2139095040 %68
        %243 = OpPhi %u32_id %241 %69 %u32_id_0 %68
        %244 = OpShiftLeftLogical %u32_id %107 %u32_id_3
        %245 = OpCompositeConstruct %u32vec2_id %229 %228
        %246 = OpBitcast %u64_id %245
        %247 = OpShiftRightLogical %u32_id %244 %u32_id_3
        %248 = OpAccessChain %_ptr_Workgroup_u64_id %shared_mem_u64 %247
               OpStore %248 %246
        %250 = OpIAdd %u32_id %244 %u32_id_4096
        %251 = OpCompositeConstruct %u32vec2_id %242 %243
        %252 = OpBitcast %u64_id %251
        %253 = OpShiftRightLogical %u32_id %250 %u32_id_3
        %254 = OpAccessChain %_ptr_Workgroup_u64_id %shared_mem_u64 %253
               OpStore %254 %252
               OpBranch %71
         %71 = OpLabel
        %255 = OpPhi %u32_id %243 %70 %321 %78
        %256 = OpPhi %u32_id %242 %70 %322 %78
        %257 = OpPhi %u32_id %228 %70 %303 %78
        %258 = OpPhi %u32_id %229 %70 %304 %78
        %259 = OpPhi %u32_id %152 %70 %323 %78
               OpLoopMerge %79 %78 None
               OpBranch %72
         %72 = OpLabel
        %260 = OpShiftLeftLogical %u32_id %259 %u32_id_3
        %261 = OpShiftRightLogical %u32_id %260 %u32_id_2
        %262 = OpIAdd %u32_id %261 %buf2_dword_off
        %263 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %262
        %264 = OpLoad %u32_id %263
        %265 = OpIAdd %u32_id %261 %u32_id_1
        %266 = OpIAdd %u32_id %265 %buf2_dword_off
        %267 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_3 %u32_id_0 %266
        %268 = OpLoad %u32_id %267
        %270 = OpBitwiseXor %u32_id %264 %107
        %271 = OpBitwiseXor %u32_id %264 %111
        %272 = OpShiftLeftLogical %u32_id %270 %u32_id_3
        %273 = OpShiftLeftLogical %u32_id %271 %u32_id_3
        %274 = OpShiftRightLogical %u32_id %272 %u32_id_3
        %275 = OpAccessChain %_ptr_Workgroup_u64_id %shared_mem_u64 %274
        %276 = OpLoad %u64_id %275
        %277 = OpBitcast %u32vec2_id %276
        %278 = OpCompositeExtract %u32_id %277 0
        %279 = OpCompositeExtract %u32_id %277 1
        %280 = OpShiftRightLogical %u32_id %273 %u32_id_3
        %281 = OpAccessChain %_ptr_Workgroup_u64_id %shared_mem_u64 %280
        %282 = OpLoad %u64_id %281
        %283 = OpBitcast %u32vec2_id %282
        %284 = OpCompositeExtract %u32_id %283 0
        %285 = OpCompositeExtract %u32_id %283 1
        %286 = OpINotEqual %bool_id %259 %156
        %287 = OpLogicalNot %bool_id %286
               OpBranchConditional %287 %79 %73
         %73 = OpLabel
        %288 = OpBitwiseAnd %u32_id %264 %107
        %289 = OpULessThan %bool_id %268 %288
        %290 = OpBitcast %f32_id %258
        %291 = OpBitcast %f32_id %278
        %292 = OpFOrdGreaterThan %bool_id %290 %291
        %293 = OpBitcast %f32_id %258
        %294 = OpBitcast %f32_id %278
        %295 = OpFOrdNotEqual %bool_id %293 %294
        %296 = OpLogicalNotEqual %bool_id %289 %292
        %297 = OpLogicalAnd %bool_id %296 %295
               OpSelectionMerge %75 None
               OpBranchConditional %297 %74 %75
         %74 = OpLabel
        %298 = OpShiftLeftLogical %u32_id %270 %u32_id_3
        %299 = OpCompositeConstruct %u32vec2_id %258 %257
        %300 = OpBitcast %u64_id %299
        %301 = OpShiftRightLogical %u32_id %298 %u32_id_3
        %302 = OpAccessChain %_ptr_Workgroup_u64_id %shared_mem_u64 %301
               OpStore %302 %300
               OpBranch %75
         %75 = OpLabel
        %303 = OpPhi %u32_id %279 %74 %257 %73
        %304 = OpPhi %u32_id %278 %74 %258 %73
        %305 = OpBitwiseAnd %u32_id %264 %111
        %306 = OpULessThan %bool_id %268 %305
        %307 = OpBitcast %f32_id %256
        %308 = OpBitcast %f32_id %284
        %309 = OpFOrdGreaterThan %bool_id %307 %308
        %310 = OpBitcast %f32_id %256
        %311 = OpBitcast %f32_id %284
        %312 = OpFOrdNotEqual %bool_id %310 %311
        %313 = OpLogicalNotEqual %bool_id %306 %309
        %314 = OpLogicalAnd %bool_id %313 %312
               OpSelectionMerge %77 None
               OpBranchConditional %314 %76 %77
         %76 = OpLabel
        %315 = OpShiftLeftLogical %u32_id %271 %u32_id_3
        %316 = OpCompositeConstruct %u32vec2_id %256 %255
        %317 = OpBitcast %u64_id %316
        %318 = OpShiftRightLogical %u32_id %315 %u32_id_3
        %319 = OpAccessChain %_ptr_Workgroup_u64_id %shared_mem_u64 %318
               OpStore %319 %317
               OpBranch %77
         %77 = OpLabel
        %320 = OpPhi %u32_id %315 %76 %305 %75
        %321 = OpPhi %u32_id %285 %76 %255 %75
        %322 = OpPhi %u32_id %284 %76 %256 %75
        %323 = OpIAdd %u32_id %259 %u32_id_1
               OpBranch %78
         %78 = OpLabel
               OpBranchConditional %true %71 %79
         %79 = OpLabel
        %324 = OpPhi %u32_id %255 %72 %321 %78
        %325 = OpPhi %u32_id %256 %72 %322 %78
        %326 = OpPhi %u32_id %278 %72 %320 %78
        %327 = OpPhi %u32_id %257 %72 %303 %78
        %328 = OpPhi %u32_id %258 %72 %304 %78
        %329 = OpUGreaterThan %bool_id %119 %207
               OpSelectionMerge %81 None
               OpBranchConditional %329 %80 %81
         %80 = OpLabel
        %330 = OpBitwiseAnd %u32_id %264 %107
        %331 = OpULessThan %bool_id %268 %330
        %332 = OpBitcast %f32_id %328
        %333 = OpBitcast %f32_id %326
        %334 = OpFOrdGreaterThan %bool_id %332 %333
        %335 = OpBitcast %f32_id %328
        %336 = OpBitcast %f32_id %326
        %337 = OpFOrdNotEqual %bool_id %335 %336
        %338 = OpISub %u32_id %207 %131
        %339 = OpLogicalNotEqual %bool_id %331 %334
        %340 = OpLogicalAnd %bool_id %339 %337
        %341 = OpBitcast %f32_id %328
        %342 = OpBitcast %f32_id %326
        %343 = OpSelect %f32_id %340 %342 %341
        %344 = OpBitcast %u32_id %343
        %345 = OpBitcast %f32_id %327
        %346 = OpBitcast %f32_id %279
        %347 = OpSelect %f32_id %340 %346 %345
        %348 = OpBitcast %u32_id %347
        %349 = OpCompositeConstruct %u32vec2_id %344 %348
        %350 = OpIMul %u32_id %338 %u32_id_2
        %351 = OpIAdd %u32_id %350 %buf1_dword_off
        %352 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %351
        %353 = OpCompositeExtract %u32_id %349 0
               OpStore %352 %353
        %354 = OpIAdd %u32_id %351 %u32_id_1
        %355 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %354
        %356 = OpCompositeExtract %u32_id %349 1
               OpStore %355 %356
               OpBranch %81
         %81 = OpLabel
        %357 = OpUGreaterThan %bool_id %119 %216
               OpSelectionMerge %83 None
               OpBranchConditional %357 %82 %83
         %82 = OpLabel
        %358 = OpBitwiseAnd %u32_id %264 %111
        %359 = OpULessThan %bool_id %268 %358
        %360 = OpBitcast %f32_id %325
        %361 = OpBitcast %f32_id %284
        %362 = OpFOrdGreaterThan %bool_id %360 %361
        %363 = OpBitcast %f32_id %325
        %364 = OpBitcast %f32_id %284
        %365 = OpFOrdNotEqual %bool_id %363 %364
        %366 = OpISub %u32_id %216 %131
        %367 = OpLogicalNotEqual %bool_id %359 %362
        %368 = OpLogicalAnd %bool_id %367 %365
        %369 = OpBitcast %f32_id %325
        %370 = OpBitcast %f32_id %284
        %371 = OpSelect %f32_id %368 %370 %369
        %372 = OpBitcast %u32_id %371
        %373 = OpBitcast %f32_id %324
        %374 = OpBitcast %f32_id %285
        %375 = OpSelect %f32_id %368 %374 %373
        %376 = OpBitcast %u32_id %375
        %377 = OpCompositeConstruct %u32vec2_id %372 %376
        %378 = OpIMul %u32_id %366 %u32_id_2
        %379 = OpIAdd %u32_id %378 %buf1_dword_off
        %380 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %379
        %381 = OpCompositeExtract %u32_id %377 0
               OpStore %380 %381
        %382 = OpIAdd %u32_id %379 %u32_id_1
        %383 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_2 %u32_id_0 %382
        %384 = OpCompositeExtract %u32_id %377 1
               OpStore %383 %384
               OpBranch %83
         %83 = OpLabel
               OpBranch %84
         %84 = OpLabel
               OpReturn
               OpFunctionEnd
