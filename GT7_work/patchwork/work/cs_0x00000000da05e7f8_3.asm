; SPIR-V
; Version: 1.6
; Generator: Khronos; 0
; Bound: 398
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
        %109 = OpExtInstImport "GLSL.std.450"
               OpMemoryModel Logical GLSL450
               OpEntryPoint GLCompute %69 "main" %push_data %gl_WorkGroupID %gl_LocalInvocationID %srt_flatbuf %cs_img16 %cs_img31 %cs_sampsgpr_24
               OpExecutionMode %69 LocalSize 8 8 1
               OpExecutionMode %69 SignedZeroInfNanPreserve 32
          %1 = OpString "0xda05e7f8"
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
               OpName %srt_flatbuf "srt_flatbuf"
               OpName %cs_img16 "cs_img16"
               OpName %cs_img31 "cs_img31"
               OpName %cs_sampsgpr_24 "cs_sampsgpr:24"
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
               OpDecorate %srt_flatbuf Binding 0
               OpDecorate %srt_flatbuf DescriptorSet 0
               OpDecorate %srt_flatbuf NonWritable
               OpDecorate %cs_img16 Binding 1
               OpDecorate %cs_img16 DescriptorSet 0
               OpDecorate %cs_img31 Binding 2
               OpDecorate %cs_img31 DescriptorSet 0
               OpDecorate %cs_sampsgpr_24 Binding 10
               OpDecorate %cs_sampsgpr_24 DescriptorSet 0
               OpDecorate %156 NoContraction
               OpDecorate %157 NoContraction
               OpDecorate %163 NoContraction
               OpDecorate %164 NoContraction
               OpDecorate %167 NoContraction
               OpDecorate %168 NoContraction
               OpDecorate %169 NoContraction
               OpDecorate %171 NoContraction
               OpDecorate %172 NoContraction
               OpDecorate %175 NoContraction
               OpDecorate %176 NoContraction
               OpDecorate %177 NoContraction
               OpDecorate %178 NoContraction
               OpDecorate %180 NoContraction
               OpDecorate %181 NoContraction
               OpDecorate %182 NoContraction
               OpDecorate %183 NoContraction
               OpDecorate %185 NoContraction
               OpDecorate %186 NoContraction
               OpDecorate %187 NoContraction
               OpDecorate %188 NoContraction
               OpDecorate %189 NoContraction
               OpDecorate %191 NoContraction
               OpDecorate %192 NoContraction
               OpDecorate %193 NoContraction
               OpDecorate %194 NoContraction
               OpDecorate %196 NoContraction
               OpDecorate %197 NoContraction
               OpDecorate %198 NoContraction
               OpDecorate %199 NoContraction
               OpDecorate %201 NoContraction
               OpDecorate %202 NoContraction
               OpDecorate %203 NoContraction
               OpDecorate %204 NoContraction
               OpDecorate %206 NoContraction
               OpDecorate %207 NoContraction
               OpDecorate %208 NoContraction
               OpDecorate %209 NoContraction
               OpDecorate %210 NoContraction
               OpDecorate %211 NoContraction
               OpDecorate %213 NoContraction
               OpDecorate %214 NoContraction
               OpDecorate %216 NoContraction
               OpDecorate %217 NoContraction
               OpDecorate %219 NoContraction
               OpDecorate %220 NoContraction
               OpDecorate %242 NoContraction
               OpDecorate %244 NoContraction
               OpDecorate %246 NoContraction
               OpDecorate %248 NoContraction
               OpDecorate %249 NoContraction
               OpDecorate %251 NoContraction
               OpDecorate %252 NoContraction
               OpDecorate %254 NoContraction
               OpDecorate %255 NoContraction
               OpDecorate %257 NoContraction
               OpDecorate %258 NoContraction
               OpDecorate %260 NoContraction
               OpDecorate %261 NoContraction
               OpDecorate %263 NoContraction
               OpDecorate %264 NoContraction
               OpDecorate %266 NoContraction
               OpDecorate %267 NoContraction
               OpDecorate %268 NoContraction
               OpDecorate %310 NoContraction
               OpDecorate %311 NoContraction
               OpDecorate %335 NoContraction
               OpDecorate %336 NoContraction
               OpDecorate %340 NoContraction
               OpDecorate %341 NoContraction
               OpDecorate %342 NoContraction
               OpDecorate %343 NoContraction
               OpDecorate %345 NoContraction
               OpDecorate %348 NoContraction
               OpDecorate %361 NoContraction
               OpDecorate %364 NoContraction
               OpDecorate %367 NoContraction
               OpDecorate %385 NoContraction
               OpDecorate %387 NoContraction
               OpDecorate %389 NoContraction
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
         %56 = OpTypeImage %f32_id 2D 0 1 0 1 Unknown
%_ptr_UniformConstant_56 = OpTypePointer UniformConstant %56
         %59 = OpTypeSampledImage %56
         %60 = OpTypeImage %f32_id 2D 0 1 0 2 Unknown
   %u32_id_8 = OpConstant %u32_id 8
%_arr_60_u32_id_8 = OpTypeArray %60 %u32_id_8
%_ptr_UniformConstant__arr_60_u32_id_8 = OpTypePointer UniformConstant %_arr_60_u32_id_8
         %65 = OpTypeSampler
%_ptr_UniformConstant_65 = OpTypePointer UniformConstant %65
         %68 = OpTypeFunction %void_id
   %u32_id_4 = OpConstant %u32_id 4
%_ptr_PushConstant_u32_id = OpTypePointer PushConstant %u32_id
   %u32_id_2 = OpConstant %u32_id 2
   %u32_id_3 = OpConstant %u32_id 3
 %u32_id_196 = OpConstant %u32_id 196
  %u32_id_30 = OpConstant %u32_id 30
  %u32_id_12 = OpConstant %u32_id 12
 %u32_id_144 = OpConstant %u32_id 144
  %u32_id_72 = OpConstant %u32_id 72
 %u32_id_152 = OpConstant %u32_id 152
  %u32_id_80 = OpConstant %u32_id 80
 %u32_id_216 = OpConstant %u32_id 216
   %f32_id_2 = OpConstant %f32_id 2
   %f32_id_1 = OpConstant %f32_id 1
 %f32_id_1_5 = OpConstant %f32_id 1.5
   %f32_id_3 = OpConstant %f32_id 3
   %f32_id_4 = OpConstant %f32_id 4
   %f32_id_5 = OpConstant %f32_id 5
%f32_id_n0_5 = OpConstant %f32_id -0.5
   %f32_id_8 = OpConstant %f32_id 8
  %f32_id_n2 = OpConstant %f32_id -2
  %u32_id_31 = OpConstant %u32_id 31
  %u32_id_39 = OpConstant %u32_id 39
 %u32_id_194 = OpConstant %u32_id 194
  %u32_id_28 = OpConstant %u32_id 28
 %u32_id_195 = OpConstant %u32_id 195
  %u32_id_29 = OpConstant %u32_id 29
   %u32_id_6 = OpConstant %u32_id 6
        %393 = OpConstantComposite %f32vec4_id %f32_id_0 %f32_id_1 %f32_id_0 %f32_id_0
%_ptr_UniformConstant_60 = OpTypePointer UniformConstant %60
  %push_data = OpVariable %_ptr_PushConstant_AuxData PushConstant
%gl_WorkGroupID = OpVariable %_ptr_Input_u32vec3_id Input
%gl_LocalInvocationID = OpVariable %_ptr_Input_u32vec3_id Input
%srt_flatbuf = OpVariable %_ptr_StorageBuffer__struct_52 StorageBuffer
   %cs_img16 = OpVariable %_ptr_UniformConstant_56 UniformConstant
   %cs_img31 = OpVariable %_ptr_UniformConstant__arr_60_u32_id_8 UniformConstant
%cs_sampsgpr_24 = OpVariable %_ptr_UniformConstant_65 UniformConstant
         %69 = OpFunction %void_id None %68
         %70 = OpLabel
         %80 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_0
       %ud_0 = OpLoad %u32_id %80
         %82 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_1
       %ud_1 = OpLoad %u32_id %82
         %85 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_2
       %ud_2 = OpLoad %u32_id %85
         %88 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_4 %u32_id_3
       %ud_3 = OpLoad %u32_id %88
         %90 = OpLoad %u32vec3_id %gl_LocalInvocationID
         %91 = OpCompositeExtract %u32_id %90 0
         %92 = OpLoad %u32vec3_id %gl_LocalInvocationID
         %93 = OpCompositeExtract %u32_id %92 1
         %94 = OpLoad %u32vec3_id %gl_WorkGroupID
         %95 = OpCompositeExtract %u32_id %94 0
         %96 = OpLoad %u32vec3_id %gl_WorkGroupID
         %97 = OpCompositeExtract %u32_id %96 1
         %98 = OpLoad %u32vec3_id %gl_WorkGroupID
         %99 = OpCompositeExtract %u32_id %98 2
        %100 = OpShiftLeftLogical %u32_id %95 %u32_id_3
        %101 = OpShiftLeftLogical %u32_id %97 %u32_id_3
        %102 = OpIAdd %u32_id %100 %91
        %103 = OpIAdd %u32_id %101 %93
        %104 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %107 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_30
        %108 = OpLoad %u32_id %107
        %110 = OpExtInst %u32_id %109 UMax %102 %103
        %111 = OpUGreaterThan %bool_id %108 %110
               OpSelectionMerge %76 None
               OpBranchConditional %111 %71 %76
         %71 = OpLabel
        %112 = OpConvertUToF %f32_id %102
        %114 = OpIMul %u32_id %99 %u32_id_12
        %116 = OpIAdd %u32_id %114 %u32_id_144
        %117 = OpShiftRightLogical %u32_id %116 %u32_id_2
        %118 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %119 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %120 = OpLoad %u32_id %119
        %121 = OpIAdd %u32_id %117 %u32_id_1
        %122 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %123 = OpLoad %u32_id %122
        %124 = OpShiftRightLogical %u32_id %114 %u32_id_2
        %125 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %126 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %127 = OpLoad %u32_id %126
        %128 = OpIAdd %u32_id %124 %u32_id_1
        %129 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %130 = OpLoad %u32_id %129
        %132 = OpIAdd %u32_id %114 %u32_id_72
        %134 = OpIAdd %u32_id %114 %u32_id_152
        %135 = OpShiftRightLogical %u32_id %132 %u32_id_2
        %136 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %137 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %138 = OpLoad %u32_id %137
        %139 = OpIAdd %u32_id %135 %u32_id_1
        %140 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %141 = OpLoad %u32_id %140
        %142 = OpShiftRightLogical %u32_id %134 %u32_id_2
        %143 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %144 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %145 = OpLoad %u32_id %144
        %146 = OpIAdd %u32_id %114 %u32_id_8
        %147 = OpConvertUToF %f32_id %103
        %148 = OpShiftRightLogical %u32_id %146 %u32_id_2
        %149 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %150 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %151 = OpLoad %u32_id %150
        %153 = OpIAdd %u32_id %114 %u32_id_80
        %154 = OpBitcast %f32_id %127
        %155 = OpBitcast %f32_id %120
        %156 = OpFMul %f32_id %154 %112
        %157 = OpFAdd %f32_id %156 %155
        %158 = OpShiftRightLogical %u32_id %153 %u32_id_2
        %159 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %160 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %161 = OpLoad %u32_id %160
        %162 = OpBitcast %f32_id %138
        %163 = OpFMul %f32_id %162 %147
        %164 = OpFAdd %f32_id %163 %157
        %165 = OpBitcast %f32_id %130
        %166 = OpBitcast %f32_id %123
        %167 = OpFMul %f32_id %165 %112
        %168 = OpFAdd %f32_id %167 %166
        %169 = OpFMul %f32_id %164 %164
        %170 = OpBitcast %f32_id %141
        %171 = OpFMul %f32_id %170 %147
        %172 = OpFAdd %f32_id %171 %168
        %173 = OpBitcast %f32_id %151
        %174 = OpBitcast %f32_id %145
        %175 = OpFMul %f32_id %173 %112
        %176 = OpFAdd %f32_id %175 %174
        %177 = OpFMul %f32_id %172 %172
        %178 = OpFAdd %f32_id %177 %169
        %179 = OpBitcast %f32_id %161
        %180 = OpFMul %f32_id %179 %147
        %181 = OpFAdd %f32_id %180 %176
        %182 = OpFMul %f32_id %181 %181
        %183 = OpFAdd %f32_id %182 %178
        %184 = OpExtInst %f32_id %109 InverseSqrt %183
        %185 = OpFMul %f32_id %184 %181
        %186 = OpFMul %f32_id %185 %185
        %187 = OpFMul %f32_id %184 %164
        %188 = OpFMul %f32_id %184 %172
        %189 = OpFMul %f32_id %187 %187
        %190 = OpFNegate %f32_id %187
        %191 = OpFMul %f32_id %188 %190
        %192 = OpFAdd %f32_id %191 %186
        %193 = OpFMul %f32_id %192 %192
        %194 = OpFMul %f32_id %188 %188
        %195 = OpFNegate %f32_id %188
        %196 = OpFMul %f32_id %185 %195
        %197 = OpFAdd %f32_id %196 %189
        %198 = OpFMul %f32_id %197 %197
        %199 = OpFAdd %f32_id %198 %193
        %200 = OpFNegate %f32_id %185
        %201 = OpFMul %f32_id %187 %200
        %202 = OpFAdd %f32_id %201 %194
        %203 = OpFMul %f32_id %202 %202
        %204 = OpFAdd %f32_id %203 %199
        %205 = OpExtInst %f32_id %109 InverseSqrt %204
        %206 = OpFMul %f32_id %205 %202
        %207 = OpFMul %f32_id %205 %197
        %208 = OpFMul %f32_id %205 %192
        %209 = OpFMul %f32_id %188 %206
        %210 = OpFMul %f32_id %185 %208
        %211 = OpFMul %f32_id %187 %207
        %212 = OpFNegate %f32_id %185
        %213 = OpFMul %f32_id %207 %212
        %214 = OpFAdd %f32_id %213 %209
        %215 = OpFNegate %f32_id %187
        %216 = OpFMul %f32_id %206 %215
        %217 = OpFAdd %f32_id %216 %210
        %218 = OpFNegate %f32_id %188
        %219 = OpFMul %f32_id %208 %218
        %220 = OpFAdd %f32_id %219 %211
               OpBranch %72
         %72 = OpLabel
        %221 = OpPhi %u32_id %u32_id_0 %71 %368 %74
        %222 = OpPhi %u32_id %u32_id_0 %71 %362 %74
        %223 = OpPhi %u32_id %u32_id_0 %71 %365 %74
        %224 = OpPhi %u32_id %u32_id_0 %71 %357 %74
               OpLoopMerge %75 %74 None
               OpBranch %73
         %73 = OpLabel
        %225 = OpShiftLeftLogical %u32_id %224 %u32_id_4
        %227 = OpIAdd %u32_id %225 %u32_id_216
        %228 = OpShiftRightLogical %u32_id %227 %u32_id_2
        %229 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %230 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %231 = OpLoad %u32_id %230
        %232 = OpIAdd %u32_id %228 %u32_id_1
        %233 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %234 = OpLoad %u32_id %233
        %235 = OpIAdd %u32_id %228 %u32_id_2
        %236 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %237 = OpLoad %u32_id %236
        %238 = OpIAdd %u32_id %228 %u32_id_3
        %239 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %240 = OpLoad %u32_id %239
        %241 = OpBitcast %f32_id %231
        %242 = OpFMul %f32_id %241 %206
        %243 = OpBitcast %f32_id %231
        %244 = OpFMul %f32_id %243 %207
        %245 = OpBitcast %f32_id %231
        %246 = OpFMul %f32_id %245 %208
        %247 = OpBitcast %f32_id %234
        %248 = OpFMul %f32_id %247 %217
        %249 = OpFAdd %f32_id %248 %244
        %250 = OpBitcast %f32_id %234
        %251 = OpFMul %f32_id %250 %214
        %252 = OpFAdd %f32_id %251 %246
        %253 = OpBitcast %f32_id %234
        %254 = OpFMul %f32_id %253 %220
        %255 = OpFAdd %f32_id %254 %242
        %256 = OpBitcast %f32_id %237
        %257 = OpFMul %f32_id %256 %185
        %258 = OpFAdd %f32_id %257 %255
        %259 = OpBitcast %f32_id %237
        %260 = OpFMul %f32_id %259 %188
        %261 = OpFAdd %f32_id %260 %249
        %262 = OpBitcast %f32_id %237
        %263 = OpFMul %f32_id %262 %187
        %264 = OpFAdd %f32_id %263 %252
        %266 = OpFMul %f32_id %264 %f32_id_2
        %267 = OpFMul %f32_id %261 %f32_id_2
        %268 = OpFMul %f32_id %258 %f32_id_2
        %269 = OpExtInst %f32_id %109 FAbs %264
        %270 = OpExtInst %f32_id %109 FAbs %261
        %271 = OpExtInst %f32_id %109 FAbs %258
        %272 = OpFOrdGreaterThanEqual %bool_id %271 %270
        %273 = OpFOrdGreaterThanEqual %bool_id %271 %269
        %274 = OpLogicalAnd %bool_id %273 %272
        %275 = OpFOrdGreaterThanEqual %bool_id %270 %269
        %276 = OpSelect %f32_id %275 %267 %266
        %277 = OpSelect %f32_id %274 %268 %276
        %278 = OpExtInst %f32_id %109 FAbs %277
        %280 = OpFDiv %f32_id %f32_id_1 %278
        %281 = OpFOrdLessThan %bool_id %264 %f32_id_0
        %282 = OpFOrdLessThan %bool_id %258 %f32_id_0
        %283 = OpFNegate %f32_id %258
        %284 = OpSelect %f32_id %281 %258 %283
        %285 = OpFNegate %f32_id %264
        %286 = OpSelect %f32_id %282 %285 %264
        %287 = OpExtInst %f32_id %109 FAbs %264
        %288 = OpExtInst %f32_id %109 FAbs %261
        %289 = OpExtInst %f32_id %109 FAbs %258
        %290 = OpFOrdGreaterThanEqual %bool_id %289 %288
        %291 = OpFOrdGreaterThanEqual %bool_id %289 %287
        %292 = OpLogicalAnd %bool_id %291 %290
        %293 = OpFOrdGreaterThanEqual %bool_id %288 %287
        %294 = OpSelect %f32_id %293 %264 %284
        %295 = OpSelect %f32_id %292 %286 %294
        %296 = OpFOrdLessThan %bool_id %261 %f32_id_0
        %297 = OpFNegate %f32_id %261
        %298 = OpFNegate %f32_id %258
        %299 = OpSelect %f32_id %296 %298 %258
        %300 = OpExtInst %f32_id %109 FAbs %264
        %301 = OpExtInst %f32_id %109 FAbs %261
        %302 = OpExtInst %f32_id %109 FAbs %258
        %303 = OpFOrdGreaterThanEqual %bool_id %302 %301
        %304 = OpFOrdGreaterThanEqual %bool_id %302 %300
        %305 = OpLogicalAnd %bool_id %304 %303
        %306 = OpFOrdGreaterThanEqual %bool_id %301 %300
        %307 = OpSelect %f32_id %306 %299 %297
        %308 = OpSelect %f32_id %305 %297 %307
        %310 = OpExtInst %f32_id %109 Fma %295 %280 %f32_id_1_5
        %311 = OpExtInst %f32_id %109 Fma %308 %280 %f32_id_1_5
        %312 = OpExtInst %f32_id %109 FAbs %258
        %313 = OpExtInst %f32_id %109 FAbs %264
        %314 = OpExtInst %f32_id %109 FAbs %261
        %315 = OpExtInst %f32_id %109 FMax %313 %314
        %316 = OpExtInst %f32_id %109 FMax %312 %315
        %317 = OpFOrdLessThan %bool_id %264 %f32_id_0
        %318 = OpFOrdLessThan %bool_id %261 %f32_id_0
        %319 = OpFOrdLessThan %bool_id %258 %f32_id_0
        %320 = OpSelect %f32_id %317 %f32_id_1 %f32_id_0
        %322 = OpSelect %f32_id %318 %f32_id_3 %f32_id_2
        %325 = OpSelect %f32_id %319 %f32_id_5 %f32_id_4
        %326 = OpExtInst %f32_id %109 FAbs %264
        %327 = OpExtInst %f32_id %109 FAbs %261
        %328 = OpExtInst %f32_id %109 FAbs %258
        %329 = OpFOrdGreaterThanEqual %bool_id %328 %327
        %330 = OpFOrdGreaterThanEqual %bool_id %328 %326
        %331 = OpLogicalAnd %bool_id %330 %329
        %332 = OpFOrdGreaterThanEqual %bool_id %327 %326
        %333 = OpSelect %f32_id %332 %322 %320
        %334 = OpSelect %f32_id %331 %325 %333
        %335 = OpFMul %f32_id %316 %316
        %336 = OpFMul %f32_id %335 %316
        %337 = OpExtInst %f32_id %109 Log2 %336
        %338 = OpBitcast %f32_id %240
        %340 = OpFMul %f32_id %f32_id_n0_5 %337
        %341 = OpFAdd %f32_id %340 %338
        %342 = OpFSub %f32_id %310 %f32_id_1
        %343 = OpFSub %f32_id %311 %f32_id_1
        %345 = OpFDiv %f32_id %334 %f32_id_8
        %346 = OpExtInst %f32_id %109 Floor %345
        %348 = OpExtInst %f32_id %109 Fma %346 %f32_id_n2 %334
        %349 = OpCompositeConstruct %f32vec3_id %342 %343 %348
        %350 = OpLoad %56 %cs_img16
        %351 = OpLoad %65 %cs_sampsgpr_24
        %352 = OpSampledImage %59 %350 %351
        %353 = OpImageSampleExplicitLod %f32vec4_id %352 %349 Lod %341
        %354 = OpCompositeExtract %f32_id %353 0
        %355 = OpCompositeExtract %f32_id %353 1
        %356 = OpCompositeExtract %f32_id %353 2
        %357 = OpIAdd %u32_id %224 %u32_id_1
        %359 = OpSLessThan %bool_id %224 %u32_id_31
        %360 = OpBitcast %f32_id %222
        %361 = OpFAdd %f32_id %356 %360
        %362 = OpBitcast %u32_id %361
        %363 = OpBitcast %f32_id %223
        %364 = OpFAdd %f32_id %355 %363
        %365 = OpBitcast %u32_id %364
        %366 = OpBitcast %f32_id %221
        %367 = OpFAdd %f32_id %354 %366
        %368 = OpBitcast %u32_id %367
               OpBranch %74
         %74 = OpLabel
               OpBranchConditional %359 %72 %75
         %75 = OpLabel
        %369 = OpCompositeConstruct %u32vec2_id %ud_2 %ud_3
        %371 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_39
        %372 = OpLoad %u32_id %371
        %373 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %376 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_28
        %377 = OpLoad %u32_id %376
        %380 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_29
        %381 = OpLoad %u32_id %380
        %383 = OpIMul %u32_id %372 %u32_id_6
        %384 = OpBitcast %f32_id %377
        %385 = OpFMul %f32_id %384 %367
        %386 = OpBitcast %f32_id %377
        %387 = OpFMul %f32_id %386 %361
        %388 = OpBitcast %f32_id %377
        %389 = OpFMul %f32_id %388 %364
        %390 = OpIAdd %u32_id %99 %383
        %391 = OpCompositeConstruct %f32vec4_id %385 %389 %387 %f32_id_0
        %392 = OpCompositeConstruct %u32vec3_id %102 %103 %390
        %394 = OpVectorShuffle %f32vec4_id %393 %391 4 5 6 0
        %396 = OpAccessChain %_ptr_UniformConstant_60 %cs_img31 %381
        %397 = OpLoad %60 %396
               OpImageWrite %397 %392 %394 None
               OpBranch %76
         %76 = OpLabel
               OpBranch %77
         %77 = OpLabel
               OpReturn
               OpFunctionEnd
