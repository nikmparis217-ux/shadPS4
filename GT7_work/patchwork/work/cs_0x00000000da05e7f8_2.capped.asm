; SPIR-V
; Version: 1.6
; Generator: Khronos; 0
; Bound: 399
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
               OpDecorate %cs_sampsgpr_24 Binding 9
               OpDecorate %cs_sampsgpr_24 DescriptorSet 0
               OpDecorate %157 NoContraction
               OpDecorate %158 NoContraction
               OpDecorate %164 NoContraction
               OpDecorate %165 NoContraction
               OpDecorate %168 NoContraction
               OpDecorate %169 NoContraction
               OpDecorate %170 NoContraction
               OpDecorate %172 NoContraction
               OpDecorate %173 NoContraction
               OpDecorate %176 NoContraction
               OpDecorate %177 NoContraction
               OpDecorate %178 NoContraction
               OpDecorate %179 NoContraction
               OpDecorate %181 NoContraction
               OpDecorate %182 NoContraction
               OpDecorate %183 NoContraction
               OpDecorate %184 NoContraction
               OpDecorate %186 NoContraction
               OpDecorate %187 NoContraction
               OpDecorate %188 NoContraction
               OpDecorate %189 NoContraction
               OpDecorate %190 NoContraction
               OpDecorate %192 NoContraction
               OpDecorate %193 NoContraction
               OpDecorate %194 NoContraction
               OpDecorate %195 NoContraction
               OpDecorate %197 NoContraction
               OpDecorate %198 NoContraction
               OpDecorate %199 NoContraction
               OpDecorate %200 NoContraction
               OpDecorate %202 NoContraction
               OpDecorate %203 NoContraction
               OpDecorate %204 NoContraction
               OpDecorate %205 NoContraction
               OpDecorate %207 NoContraction
               OpDecorate %208 NoContraction
               OpDecorate %209 NoContraction
               OpDecorate %210 NoContraction
               OpDecorate %211 NoContraction
               OpDecorate %212 NoContraction
               OpDecorate %214 NoContraction
               OpDecorate %215 NoContraction
               OpDecorate %217 NoContraction
               OpDecorate %218 NoContraction
               OpDecorate %220 NoContraction
               OpDecorate %221 NoContraction
               OpDecorate %243 NoContraction
               OpDecorate %245 NoContraction
               OpDecorate %247 NoContraction
               OpDecorate %249 NoContraction
               OpDecorate %250 NoContraction
               OpDecorate %252 NoContraction
               OpDecorate %253 NoContraction
               OpDecorate %255 NoContraction
               OpDecorate %256 NoContraction
               OpDecorate %258 NoContraction
               OpDecorate %259 NoContraction
               OpDecorate %261 NoContraction
               OpDecorate %262 NoContraction
               OpDecorate %264 NoContraction
               OpDecorate %265 NoContraction
               OpDecorate %267 NoContraction
               OpDecorate %268 NoContraction
               OpDecorate %269 NoContraction
               OpDecorate %311 NoContraction
               OpDecorate %312 NoContraction
               OpDecorate %336 NoContraction
               OpDecorate %337 NoContraction
               OpDecorate %341 NoContraction
               OpDecorate %342 NoContraction
               OpDecorate %343 NoContraction
               OpDecorate %344 NoContraction
               OpDecorate %346 NoContraction
               OpDecorate %349 NoContraction
               OpDecorate %362 NoContraction
               OpDecorate %365 NoContraction
               OpDecorate %368 NoContraction
               OpDecorate %386 NoContraction
               OpDecorate %388 NoContraction
               OpDecorate %390 NoContraction
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
         %56 = OpTypeImage %f32_id 2D 0 1 0 1 Unknown
%_ptr_UniformConstant_56 = OpTypePointer UniformConstant %56
         %59 = OpTypeSampledImage %56
         %60 = OpTypeImage %f32_id 2D 0 1 0 2 Unknown
   %u32_id_7 = OpConstant %u32_id 7
%_arr_60_u32_id_7 = OpTypeArray %60 %u32_id_7
%_ptr_UniformConstant__arr_60_u32_id_7 = OpTypePointer UniformConstant %_arr_60_u32_id_7
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
   %u32_id_8 = OpConstant %u32_id 8
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
        %394 = OpConstantComposite %f32vec4_id %f32_id_0 %f32_id_1 %f32_id_0 %f32_id_0
%_ptr_UniformConstant_60 = OpTypePointer UniformConstant %60
  %push_data = OpVariable %_ptr_PushConstant_AuxData PushConstant
%gl_WorkGroupID = OpVariable %_ptr_Input_u32vec3_id Input
%gl_LocalInvocationID = OpVariable %_ptr_Input_u32vec3_id Input
%srt_flatbuf = OpVariable %_ptr_StorageBuffer__struct_52 StorageBuffer
   %cs_img16 = OpVariable %_ptr_UniformConstant_56 UniformConstant
   %cs_img31 = OpVariable %_ptr_UniformConstant__arr_60_u32_id_7 UniformConstant
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
        %147 = OpIAdd %u32_id %114 %u32_id_8
        %148 = OpConvertUToF %f32_id %103
        %149 = OpShiftRightLogical %u32_id %147 %u32_id_2
        %150 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %151 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %152 = OpLoad %u32_id %151
        %154 = OpIAdd %u32_id %114 %u32_id_80
        %155 = OpBitcast %f32_id %127
        %156 = OpBitcast %f32_id %120
        %157 = OpFMul %f32_id %155 %112
        %158 = OpFAdd %f32_id %157 %156
        %159 = OpShiftRightLogical %u32_id %154 %u32_id_2
        %160 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %161 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %162 = OpLoad %u32_id %161
        %163 = OpBitcast %f32_id %138
        %164 = OpFMul %f32_id %163 %148
        %165 = OpFAdd %f32_id %164 %158
        %166 = OpBitcast %f32_id %130
        %167 = OpBitcast %f32_id %123
        %168 = OpFMul %f32_id %166 %112
        %169 = OpFAdd %f32_id %168 %167
        %170 = OpFMul %f32_id %165 %165
        %171 = OpBitcast %f32_id %141
        %172 = OpFMul %f32_id %171 %148
        %173 = OpFAdd %f32_id %172 %169
        %174 = OpBitcast %f32_id %152
        %175 = OpBitcast %f32_id %145
        %176 = OpFMul %f32_id %174 %112
        %177 = OpFAdd %f32_id %176 %175
        %178 = OpFMul %f32_id %173 %173
        %179 = OpFAdd %f32_id %178 %170
        %180 = OpBitcast %f32_id %162
        %181 = OpFMul %f32_id %180 %148
        %182 = OpFAdd %f32_id %181 %177
        %183 = OpFMul %f32_id %182 %182
        %184 = OpFAdd %f32_id %183 %179
        %185 = OpExtInst %f32_id %109 InverseSqrt %184
        %186 = OpFMul %f32_id %185 %182
        %187 = OpFMul %f32_id %186 %186
        %188 = OpFMul %f32_id %185 %165
        %189 = OpFMul %f32_id %185 %173
        %190 = OpFMul %f32_id %188 %188
        %191 = OpFNegate %f32_id %188
        %192 = OpFMul %f32_id %189 %191
        %193 = OpFAdd %f32_id %192 %187
        %194 = OpFMul %f32_id %193 %193
        %195 = OpFMul %f32_id %189 %189
        %196 = OpFNegate %f32_id %189
        %197 = OpFMul %f32_id %186 %196
        %198 = OpFAdd %f32_id %197 %190
        %199 = OpFMul %f32_id %198 %198
        %200 = OpFAdd %f32_id %199 %194
        %201 = OpFNegate %f32_id %186
        %202 = OpFMul %f32_id %188 %201
        %203 = OpFAdd %f32_id %202 %195
        %204 = OpFMul %f32_id %203 %203
        %205 = OpFAdd %f32_id %204 %200
        %206 = OpExtInst %f32_id %109 InverseSqrt %205
        %207 = OpFMul %f32_id %206 %203
        %208 = OpFMul %f32_id %206 %198
        %209 = OpFMul %f32_id %206 %193
        %210 = OpFMul %f32_id %189 %207
        %211 = OpFMul %f32_id %186 %209
        %212 = OpFMul %f32_id %188 %208
        %213 = OpFNegate %f32_id %186
        %214 = OpFMul %f32_id %208 %213
        %215 = OpFAdd %f32_id %214 %210
        %216 = OpFNegate %f32_id %188
        %217 = OpFMul %f32_id %207 %216
        %218 = OpFAdd %f32_id %217 %211
        %219 = OpFNegate %f32_id %189
        %220 = OpFMul %f32_id %209 %219
        %221 = OpFAdd %f32_id %220 %212
               OpBranch %72
         %72 = OpLabel
        %222 = OpPhi %u32_id %u32_id_0 %71 %369 %74
        %223 = OpPhi %u32_id %u32_id_0 %71 %363 %74
        %224 = OpPhi %u32_id %u32_id_0 %71 %366 %74
        %225 = OpPhi %u32_id %u32_id_0 %71 %358 %74
        %gtc399 = OpPhi %u32_id %u32_id_0 %71 %gtc400 %74
               OpLoopMerge %75 %74 None
               OpBranch %73
         %73 = OpLabel
        %226 = OpShiftLeftLogical %u32_id %225 %u32_id_4
        %228 = OpIAdd %u32_id %226 %u32_id_216
        %229 = OpShiftRightLogical %u32_id %228 %u32_id_2
        %230 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %231 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %232 = OpLoad %u32_id %231
        %233 = OpIAdd %u32_id %229 %u32_id_1
        %234 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %235 = OpLoad %u32_id %234
        %236 = OpIAdd %u32_id %229 %u32_id_2
        %237 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %238 = OpLoad %u32_id %237
        %239 = OpIAdd %u32_id %229 %u32_id_3
        %240 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_0
        %241 = OpLoad %u32_id %240
        %242 = OpBitcast %f32_id %232
        %243 = OpFMul %f32_id %242 %207
        %244 = OpBitcast %f32_id %232
        %245 = OpFMul %f32_id %244 %208
        %246 = OpBitcast %f32_id %232
        %247 = OpFMul %f32_id %246 %209
        %248 = OpBitcast %f32_id %235
        %249 = OpFMul %f32_id %248 %218
        %250 = OpFAdd %f32_id %249 %245
        %251 = OpBitcast %f32_id %235
        %252 = OpFMul %f32_id %251 %215
        %253 = OpFAdd %f32_id %252 %247
        %254 = OpBitcast %f32_id %235
        %255 = OpFMul %f32_id %254 %221
        %256 = OpFAdd %f32_id %255 %243
        %257 = OpBitcast %f32_id %238
        %258 = OpFMul %f32_id %257 %186
        %259 = OpFAdd %f32_id %258 %256
        %260 = OpBitcast %f32_id %238
        %261 = OpFMul %f32_id %260 %189
        %262 = OpFAdd %f32_id %261 %250
        %263 = OpBitcast %f32_id %238
        %264 = OpFMul %f32_id %263 %188
        %265 = OpFAdd %f32_id %264 %253
        %267 = OpFMul %f32_id %265 %f32_id_2
        %268 = OpFMul %f32_id %262 %f32_id_2
        %269 = OpFMul %f32_id %259 %f32_id_2
        %270 = OpExtInst %f32_id %109 FAbs %265
        %271 = OpExtInst %f32_id %109 FAbs %262
        %272 = OpExtInst %f32_id %109 FAbs %259
        %273 = OpFOrdGreaterThanEqual %bool_id %272 %271
        %274 = OpFOrdGreaterThanEqual %bool_id %272 %270
        %275 = OpLogicalAnd %bool_id %274 %273
        %276 = OpFOrdGreaterThanEqual %bool_id %271 %270
        %277 = OpSelect %f32_id %276 %268 %267
        %278 = OpSelect %f32_id %275 %269 %277
        %279 = OpExtInst %f32_id %109 FAbs %278
        %281 = OpFDiv %f32_id %f32_id_1 %279
        %282 = OpFOrdLessThan %bool_id %265 %f32_id_0
        %283 = OpFOrdLessThan %bool_id %259 %f32_id_0
        %284 = OpFNegate %f32_id %259
        %285 = OpSelect %f32_id %282 %259 %284
        %286 = OpFNegate %f32_id %265
        %287 = OpSelect %f32_id %283 %286 %265
        %288 = OpExtInst %f32_id %109 FAbs %265
        %289 = OpExtInst %f32_id %109 FAbs %262
        %290 = OpExtInst %f32_id %109 FAbs %259
        %291 = OpFOrdGreaterThanEqual %bool_id %290 %289
        %292 = OpFOrdGreaterThanEqual %bool_id %290 %288
        %293 = OpLogicalAnd %bool_id %292 %291
        %294 = OpFOrdGreaterThanEqual %bool_id %289 %288
        %295 = OpSelect %f32_id %294 %265 %285
        %296 = OpSelect %f32_id %293 %287 %295
        %297 = OpFOrdLessThan %bool_id %262 %f32_id_0
        %298 = OpFNegate %f32_id %262
        %299 = OpFNegate %f32_id %259
        %300 = OpSelect %f32_id %297 %299 %259
        %301 = OpExtInst %f32_id %109 FAbs %265
        %302 = OpExtInst %f32_id %109 FAbs %262
        %303 = OpExtInst %f32_id %109 FAbs %259
        %304 = OpFOrdGreaterThanEqual %bool_id %303 %302
        %305 = OpFOrdGreaterThanEqual %bool_id %303 %301
        %306 = OpLogicalAnd %bool_id %305 %304
        %307 = OpFOrdGreaterThanEqual %bool_id %302 %301
        %308 = OpSelect %f32_id %307 %300 %298
        %309 = OpSelect %f32_id %306 %298 %308
        %311 = OpExtInst %f32_id %109 Fma %296 %281 %f32_id_1_5
        %312 = OpExtInst %f32_id %109 Fma %309 %281 %f32_id_1_5
        %313 = OpExtInst %f32_id %109 FAbs %259
        %314 = OpExtInst %f32_id %109 FAbs %265
        %315 = OpExtInst %f32_id %109 FAbs %262
        %316 = OpExtInst %f32_id %109 FMax %314 %315
        %317 = OpExtInst %f32_id %109 FMax %313 %316
        %318 = OpFOrdLessThan %bool_id %265 %f32_id_0
        %319 = OpFOrdLessThan %bool_id %262 %f32_id_0
        %320 = OpFOrdLessThan %bool_id %259 %f32_id_0
        %321 = OpSelect %f32_id %318 %f32_id_1 %f32_id_0
        %323 = OpSelect %f32_id %319 %f32_id_3 %f32_id_2
        %326 = OpSelect %f32_id %320 %f32_id_5 %f32_id_4
        %327 = OpExtInst %f32_id %109 FAbs %265
        %328 = OpExtInst %f32_id %109 FAbs %262
        %329 = OpExtInst %f32_id %109 FAbs %259
        %330 = OpFOrdGreaterThanEqual %bool_id %329 %328
        %331 = OpFOrdGreaterThanEqual %bool_id %329 %327
        %332 = OpLogicalAnd %bool_id %331 %330
        %333 = OpFOrdGreaterThanEqual %bool_id %328 %327
        %334 = OpSelect %f32_id %333 %323 %321
        %335 = OpSelect %f32_id %332 %326 %334
        %336 = OpFMul %f32_id %317 %317
        %337 = OpFMul %f32_id %336 %317
        %338 = OpExtInst %f32_id %109 Log2 %337
        %339 = OpBitcast %f32_id %241
        %341 = OpFMul %f32_id %f32_id_n0_5 %338
        %342 = OpFAdd %f32_id %341 %339
        %343 = OpFSub %f32_id %311 %f32_id_1
        %344 = OpFSub %f32_id %312 %f32_id_1
        %346 = OpFDiv %f32_id %335 %f32_id_8
        %347 = OpExtInst %f32_id %109 Floor %346
        %349 = OpExtInst %f32_id %109 Fma %347 %f32_id_n2 %335
        %350 = OpCompositeConstruct %f32vec3_id %343 %344 %349
        %351 = OpLoad %56 %cs_img16
        %352 = OpLoad %65 %cs_sampsgpr_24
        %353 = OpSampledImage %59 %351 %352
        %354 = OpImageSampleExplicitLod %f32vec4_id %353 %350 Lod %342
        %355 = OpCompositeExtract %f32_id %354 0
        %356 = OpCompositeExtract %f32_id %354 1
        %357 = OpCompositeExtract %f32_id %354 2
        %358 = OpIAdd %u32_id %225 %u32_id_1
        %360 = OpSLessThan %bool_id %225 %u32_id_31
        %361 = OpBitcast %f32_id %223
        %362 = OpFAdd %f32_id %357 %361
        %363 = OpBitcast %u32_id %362
        %364 = OpBitcast %f32_id %224
        %365 = OpFAdd %f32_id %356 %364
        %366 = OpBitcast %u32_id %365
        %367 = OpBitcast %f32_id %222
        %368 = OpFAdd %f32_id %355 %367
        %369 = OpBitcast %u32_id %368
               OpBranch %74
         %74 = OpLabel
        %gtc400 = OpIAdd %u32_id %gtc399 %u32_id_1
        %gtc403 = OpULessThan %bool_id %gtc399 %gtcap_1000
        %gtc402 = OpLogicalAnd %bool_id %360 %gtc403
               OpBranchConditional %gtc402 %72 %75
         %75 = OpLabel
        %370 = OpCompositeConstruct %u32vec2_id %ud_2 %ud_3
        %372 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_39
        %373 = OpLoad %u32_id %372
        %374 = OpCompositeConstruct %u32vec2_id %ud_0 %ud_1
        %377 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_28
        %378 = OpLoad %u32_id %377
        %381 = OpAccessChain %_ptr_StorageBuffer_u32_id %srt_flatbuf %u32_id_0 %u32_id_29
        %382 = OpLoad %u32_id %381
        %384 = OpIMul %u32_id %373 %u32_id_6
        %385 = OpBitcast %f32_id %378
        %386 = OpFMul %f32_id %385 %368
        %387 = OpBitcast %f32_id %378
        %388 = OpFMul %f32_id %387 %362
        %389 = OpBitcast %f32_id %378
        %390 = OpFMul %f32_id %389 %365
        %391 = OpIAdd %u32_id %99 %384
        %392 = OpCompositeConstruct %f32vec4_id %386 %390 %388 %f32_id_0
        %393 = OpCompositeConstruct %u32vec3_id %102 %103 %391
        %395 = OpVectorShuffle %f32vec4_id %394 %392 4 5 6 0
        %397 = OpAccessChain %_ptr_UniformConstant_60 %cs_img31 %382
        %398 = OpLoad %60 %397
               OpImageWrite %398 %393 %395 None
               OpBranch %76
         %76 = OpLabel
               OpBranch %77
         %77 = OpLabel
               OpReturn
               OpFunctionEnd
