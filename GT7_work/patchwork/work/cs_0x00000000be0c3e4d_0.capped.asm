; SPIR-V
; Version: 1.6
; Generator: Khronos; 0
; Bound: 328
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
        %150 = OpExtInstImport "GLSL.std.450"
               OpMemoryModel Logical GLSL450
               OpEntryPoint GLCompute %61 "main" %push_data %gl_WorkGroupID %gl_LocalInvocationID %ssbo_1 %cs_img0 %cs_img16
               OpExecutionMode %61 LocalSize 64 1 1
               OpExecutionMode %61 SignedZeroInfNanPreserve 32
          %1 = OpString "0xbe0c3e4d"
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
               OpName %cs_img0 "cs_img0"
               OpName %cs_img16 "cs_img16"
               OpName %buf0_off "buf0_off"
               OpName %buf0_dword_off "buf0_dword_off"
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
               OpDecorate %cs_img0 Binding 1
               OpDecorate %cs_img0 DescriptorSet 0
               OpDecorate %cs_img16 Binding 2
               OpDecorate %cs_img16 DescriptorSet 0
               OpDecorate %123 NoContraction
               OpDecorate %124 NoContraction
               OpDecorate %126 NoContraction
               OpDecorate %128 NoContraction
               OpDecorate %131 NoContraction
               OpDecorate %132 NoContraction
               OpDecorate %137 NoContraction
               OpDecorate %146 NoContraction
               OpDecorate %149 NoContraction
               OpDecorate %154 NoContraction
               OpDecorate %158 NoContraction
               OpDecorate %160 NoContraction
               OpDecorate %164 NoContraction
               OpDecorate %165 NoContraction
               OpDecorate %166 NoContraction
               OpDecorate %172 NoContraction
               OpDecorate %173 NoContraction
               OpDecorate %174 NoContraction
               OpDecorate %178 NoContraction
               OpDecorate %179 NoContraction
               OpDecorate %181 NoContraction
               OpDecorate %183 NoContraction
               OpDecorate %185 NoContraction
               OpDecorate %187 NoContraction
               OpDecorate %188 NoContraction
               OpDecorate %189 NoContraction
               OpDecorate %190 NoContraction
               OpDecorate %192 NoContraction
               OpDecorate %193 NoContraction
               OpDecorate %200 NoContraction
               OpDecorate %203 NoContraction
               OpDecorate %207 NoContraction
               OpDecorate %209 NoContraction
               OpDecorate %210 NoContraction
               OpDecorate %213 NoContraction
               OpDecorate %215 NoContraction
               OpDecorate %224 NoContraction
               OpDecorate %228 NoContraction
               OpDecorate %231 NoContraction
               OpDecorate %234 NoContraction
               OpDecorate %235 NoContraction
               OpDecorate %239 NoContraction
               OpDecorate %241 NoContraction
               OpDecorate %248 NoContraction
               OpDecorate %256 NoContraction
               OpDecorate %267 NoContraction
               OpDecorate %269 NoContraction
               OpDecorate %270 NoContraction
               OpDecorate %272 NoContraction
               OpDecorate %273 NoContraction
               OpDecorate %274 NoContraction
               OpDecorate %275 NoContraction
               OpDecorate %276 NoContraction
               OpDecorate %283 NoContraction
               OpDecorate %285 NoContraction
               OpDecorate %287 NoContraction
               OpDecorate %289 NoContraction
               OpDecorate %290 NoContraction
               OpDecorate %291 NoContraction
               OpDecorate %292 NoContraction
               OpDecorate %297 NoContraction
               OpDecorate %298 NoContraction
               OpDecorate %299 NoContraction
               OpDecorate %300 NoContraction
               OpDecorate %301 NoContraction
               OpDecorate %302 NoContraction
               OpDecorate %303 NoContraction
               OpDecorate %306 NoContraction
               OpDecorate %307 NoContraction
               OpDecorate %308 NoContraction
               OpDecorate %309 NoContraction
               OpDecorate %321 NoContraction
               OpDecorate %322 NoContraction
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
         %56 = OpTypeImage %f32_id 2D 0 0 0 2 Unknown
%_ptr_UniformConstant_56 = OpTypePointer UniformConstant %56
         %60 = OpTypeFunction %void_id
   %u32_id_8 = OpConstant %u32_id 8
%_ptr_PushConstant_u32_id = OpTypePointer PushConstant %u32_id
   %u32_id_2 = OpConstant %u32_id 2
   %u32_id_4 = OpConstant %u32_id 4
   %u32_id_5 = OpConstant %u32_id 5
   %u32_id_9 = OpConstant %u32_id 9
  %u32_id_10 = OpConstant %u32_id 10
  %u32_id_11 = OpConstant %u32_id 11
  %u32_id_12 = OpConstant %u32_id 12
  %u32_id_15 = OpConstant %u32_id 15
   %u32_id_6 = OpConstant %u32_id 6
%u32_id_4294967295 = OpConstant %u32_id 4294967295
   %f32_id_1 = OpConstant %f32_id 1
%f32_id_n1_44269502 = OpConstant %f32_id -1.44269502
%f32_id_1_44269502 = OpConstant %f32_id 1.44269502
  %u32_id_16 = OpConstant %u32_id 16
  %u32_id_17 = OpConstant %u32_id 17
   %f32_id_3 = OpConstant %f32_id 3
  %f32_id_n2 = OpConstant %f32_id -2
  %f32_id_n1 = OpConstant %f32_id -1
 %f32_id_100 = OpConstant %f32_id 100
%f32_id_0_00999999978 = OpConstant %f32_id 0.00999999978
%f32_id_0_159301758 = OpConstant %f32_id 0.159301758
%f32_id_0_8359375 = OpConstant %f32_id 0.8359375
%f32_id_18_8515625 = OpConstant %f32_id 18.8515625
%f32_id_18_6875 = OpConstant %f32_id 18.6875
%f32_id_78_84375 = OpConstant %f32_id 78.84375
        %220 = OpConstantComposite %f32vec4_id %f32_id_0 %f32_id_1 %f32_id_0 %f32_id_0
%f32_id_0_0126833133 = OpConstant %f32_id 0.0126833133
%f32_id_n18_6875 = OpConstant %f32_id -18.6875
%f32_id_n0_8359375 = OpConstant %f32_id -0.8359375
%f32_id_6_27739477 = OpConstant %f32_id 6.27739477
   %f32_id_4 = OpConstant %f32_id 4
%f32_id_9_99999997en07 = OpConstant %f32_id 9.99999997e-07
 %f32_id_0_5 = OpConstant %f32_id 0.5
  %u32_id_30 = OpConstant %u32_id 30
  %push_data = OpVariable %_ptr_PushConstant_AuxData PushConstant
%gl_WorkGroupID = OpVariable %_ptr_Input_u32vec3_id Input
%gl_LocalInvocationID = OpVariable %_ptr_Input_u32vec3_id Input
     %ssbo_1 = OpVariable %_ptr_StorageBuffer__struct_52 StorageBuffer
    %cs_img0 = OpVariable %_ptr_UniformConstant_56 UniformConstant
   %cs_img16 = OpVariable %_ptr_UniformConstant_56 UniformConstant
         %61 = OpFunction %void_id None %60
         %62 = OpLabel
         %71 = OpAccessChain %_ptr_PushConstant_u32_id %push_data %u32_id_8 %u32_id_0
         %72 = OpLoad %u32_id %71
   %buf0_off = OpBitFieldUExtract %u32_id %72 %u32_id_0 %u32_id_8
%buf0_dword_off = OpShiftRightLogical %u32_id %buf0_off %u32_id_2
         %76 = OpLoad %u32vec3_id %gl_LocalInvocationID
         %77 = OpCompositeExtract %u32_id %76 0
         %78 = OpLoad %u32vec3_id %gl_WorkGroupID
         %79 = OpCompositeExtract %u32_id %78 0
         %80 = OpIAdd %u32_id %u32_id_0 %buf0_dword_off
         %81 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %80
         %82 = OpLoad %u32_id %81
         %84 = OpIAdd %u32_id %u32_id_4 %buf0_dword_off
         %85 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %84
         %86 = OpLoad %u32_id %85
         %88 = OpIAdd %u32_id %u32_id_5 %buf0_dword_off
         %89 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %88
         %90 = OpLoad %u32_id %89
         %91 = OpIAdd %u32_id %u32_id_8 %buf0_dword_off
         %92 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %91
         %93 = OpLoad %u32_id %92
         %95 = OpIAdd %u32_id %u32_id_9 %buf0_dword_off
         %96 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %95
         %97 = OpLoad %u32_id %96
         %99 = OpIAdd %u32_id %u32_id_10 %buf0_dword_off
        %100 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %99
        %101 = OpLoad %u32_id %100
        %103 = OpIAdd %u32_id %u32_id_11 %buf0_dword_off
        %104 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %103
        %105 = OpLoad %u32_id %104
        %107 = OpIAdd %u32_id %u32_id_12 %buf0_dword_off
        %108 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %107
        %109 = OpLoad %u32_id %108
        %111 = OpIAdd %u32_id %u32_id_15 %buf0_dword_off
        %112 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %111
        %113 = OpLoad %u32_id %112
        %115 = OpShiftLeftLogical %u32_id %79 %u32_id_6
        %116 = OpIAdd %u32_id %115 %77
        %118 = OpIAdd %u32_id %82 %u32_id_4294967295
        %119 = OpConvertUToF %f32_id %118
        %120 = OpConvertSToF %f32_id %116
        %122 = OpFDiv %f32_id %f32_id_1 %119
        %123 = OpFMul %f32_id %120 %122
        %124 = OpFMul %f32_id %123 %123
        %125 = OpBitcast %f32_id %86
        %126 = OpFMul %f32_id %125 %124
        %128 = OpFMul %f32_id %f32_id_n1_44269502 %126
        %129 = OpBitcast %f32_id %113
        %131 = OpFMul %f32_id %129 %f32_id_1_44269502
        %132 = OpFAdd %f32_id %131 %128
        %133 = OpBitcast %f32_id %101
        %134 = OpFDiv %f32_id %f32_id_1 %133
        %135 = OpBitcast %f32_id %93
        %136 = OpFDiv %f32_id %f32_id_1 %135
        %137 = OpFMul %f32_id %134 %126
        %139 = OpIAdd %u32_id %u32_id_16 %buf0_dword_off
        %140 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %139
        %141 = OpLoad %u32_id %140
        %143 = OpIAdd %u32_id %u32_id_17 %buf0_dword_off
        %144 = OpAccessChain %_ptr_StorageBuffer_u32_id %ssbo_1 %u32_id_0 %143
        %145 = OpLoad %u32_id %144
        %146 = OpFMul %f32_id %136 %132
        %147 = OpBitcast %f32_id %101
        %148 = OpBitcast %f32_id %105
        %149 = OpFAdd %f32_id %147 %148
        %151 = OpExtInst %f32_id %150 FMax %f32_id_0 %137
        %152 = OpExtInst %f32_id %150 FClamp %151 %f32_id_0 %f32_id_1
        %153 = OpBitcast %f32_id %145
        %154 = OpFMul %f32_id %153 %146
        %155 = OpFOrdLessThan %bool_id %126 %149
        %158 = OpExtInst %f32_id %150 Fma %f32_id_n2 %152 %f32_id_3
        %159 = OpFNegate %f32_id %152
        %160 = OpFMul %f32_id %159 %152
        %161 = OpExtInst %f32_id %150 Exp2 %154
        %162 = OpBitcast %f32_id %141
        %163 = OpBitcast %f32_id %93
        %164 = OpFSub %f32_id %162 %163
        %165 = OpFMul %f32_id %160 %158
        %166 = OpFAdd %f32_id %165 %f32_id_1
        %168 = OpSelect %f32_id %155 %f32_id_0 %f32_id_n1
        %169 = OpExtInst %f32_id %150 FAbs %137
        %170 = OpExtInst %f32_id %150 Log2 %169
        %171 = OpBitcast %f32_id %93
        %172 = OpFMul %f32_id %161 %164
        %173 = OpFAdd %f32_id %172 %171
        %174 = OpFSub %f32_id %168 %166
        %175 = OpBitcast %f32_id %86
        %176 = OpBitcast %f32_id %101
        %177 = OpFNegate %f32_id %176
        %178 = OpFMul %f32_id %175 %124
        %179 = OpFAdd %f32_id %178 %177
        %180 = OpBitcast %f32_id %109
        %181 = OpFMul %f32_id %180 %170
        %182 = OpSelect %f32_id %155 %f32_id_0 %173
        %183 = OpFAdd %f32_id %f32_id_1 %174
        %184 = OpBitcast %f32_id %97
        %185 = OpFMul %f32_id %184 %179
        %186 = OpExtInst %f32_id %150 Exp2 %181
        %187 = OpFMul %f32_id %183 %185
        %188 = OpFAdd %f32_id %187 %182
        %189 = OpFMul %f32_id %186 %166
        %190 = OpFAdd %f32_id %189 %183
        %191 = OpBitcast %f32_id %101
        %192 = OpFMul %f32_id %191 %190
        %193 = OpFAdd %f32_id %192 %188
        %195 = OpExtInst %f32_id %150 FMax %f32_id_100 %193
        %196 = OpExtInst %f32_id %150 FMin %195 %f32_id_0
        %197 = OpExtInst %f32_id %150 FMin %f32_id_100 %193
        %198 = OpExtInst %f32_id %150 FMax %197 %196
        %200 = OpFMul %f32_id %f32_id_0_00999999978 %198
        %201 = OpExtInst %f32_id %150 Log2 %200
        %203 = OpFMul %f32_id %f32_id_0_159301758 %201
        %204 = OpExtInst %f32_id %150 Exp2 %203
        %207 = OpExtInst %f32_id %150 Fma %f32_id_18_8515625 %204 %f32_id_0_8359375
        %209 = OpFMul %f32_id %f32_id_18_6875 %204
        %210 = OpFAdd %f32_id %209 %f32_id_1
        %211 = OpExtInst %f32_id %150 Log2 %207
        %212 = OpExtInst %f32_id %150 Log2 %210
        %213 = OpFSub %f32_id %211 %212
        %215 = OpFMul %f32_id %f32_id_78_84375 %213
        %216 = OpExtInst %f32_id %150 Exp2 %215
        %217 = OpExtInst %f32_id %150 FClamp %216 %f32_id_0 %f32_id_1
        %218 = OpCompositeConstruct %f32vec4_id %217 %f32_id_0 %f32_id_0 %f32_id_0
        %219 = OpCompositeConstruct %u32vec2_id %116 %u32_id_0
        %221 = OpVectorShuffle %f32vec4_id %220 %218 4 0 0 0
        %222 = OpLoad %56 %cs_img0
               OpImageWrite %222 %219 %221 None
        %223 = OpBitcast %f32_id %90
        %224 = OpFMul %f32_id %223 %124
        %225 = OpExtInst %f32_id %150 FAbs %224
        %226 = OpExtInst %f32_id %150 Log2 %225
        %228 = OpFMul %f32_id %f32_id_0_0126833133 %226
        %229 = OpExtInst %f32_id %150 Exp2 %228
        %231 = OpExtInst %f32_id %150 Fma %f32_id_n18_6875 %229 %f32_id_18_8515625
        %232 = OpFDiv %f32_id %f32_id_1 %231
        %234 = OpFAdd %f32_id %f32_id_n0_8359375 %229
        %235 = OpFMul %f32_id %232 %234
        %236 = OpExtInst %f32_id %150 FAbs %235
        %237 = OpExtInst %f32_id %150 Log2 %236
        %239 = OpFMul %f32_id %f32_id_6_27739477 %237
        %240 = OpExtInst %f32_id %150 Exp2 %239
        %241 = OpFMul %f32_id %f32_id_100 %240
        %242 = OpBitcast %f32_id %101
        %243 = OpFNegate %f32_id %242
        %244 = OpBitcast %f32_id %113
        %245 = OpFNegate %f32_id %244
        %246 = OpBitcast %f32_id %93
        %248 = OpFMul %f32_id %f32_id_4 %246
        %249 = OpBitcast %u32_id %248
               OpBranch %63
         %63 = OpLabel
        %250 = OpPhi %bool_id %true %62 %263 %66
        %251 = OpPhi %u32_id %u32_id_0 %62 %316 %66
        %252 = OpPhi %u32_id %249 %62 %313 %66
        %253 = OpPhi %u32_id %u32_id_30 %62 %261 %66
        %gtc327 = OpPhi %u32_id %u32_id_0 %62 %gtc328 %66
               OpLoopMerge %67 %66 None
               OpBranch %64
         %64 = OpLabel
        %254 = OpBitcast %f32_id %252
        %255 = OpBitcast %f32_id %251
        %256 = OpFSub %f32_id %254 %255
        %257 = OpINotEqual %bool_id %u32_id_1 %253
        %259 = OpFOrdLessThanEqual %bool_id %f32_id_9_99999997en07 %256
        %260 = OpSelect %bool_id %257 %250 %false
        %261 = OpIAdd %u32_id %253 %u32_id_4294967295
        %262 = OpLogicalAnd %bool_id %259 %260
        %263 = OpLogicalAnd %bool_id %250 %262
        %264 = OpLogicalNot %bool_id %263
        %gtc328 = OpIAdd %u32_id %gtc327 %u32_id_1
        %gtc329 = OpUGreaterThanEqual %bool_id %gtc327 %gtcap_1000
        %gtc330 = OpLogicalOr %bool_id %264 %gtc329
               OpBranchConditional %gtc330 %67 %65
         %65 = OpLabel
        %265 = OpBitcast %f32_id %252
        %266 = OpBitcast %f32_id %251
        %267 = OpFAdd %f32_id %265 %266
        %269 = OpFMul %f32_id %f32_id_0_5 %267
        %270 = OpFAdd %f32_id %269 %245
        %271 = OpBitcast %f32_id %145
        %272 = OpFMul %f32_id %271 %136
        %273 = OpFMul %f32_id %f32_id_0_5 %267
        %274 = OpFMul %f32_id %272 %270
        %275 = OpFMul %f32_id %134 %273
        %276 = OpFMul %f32_id %f32_id_n1_44269502 %274
        %277 = OpExtInst %f32_id %150 FMax %f32_id_0 %275
        %278 = OpExtInst %f32_id %150 FClamp %277 %f32_id_0 %f32_id_1
        %279 = OpExtInst %f32_id %150 FAbs %275
        %280 = OpExtInst %f32_id %150 Log2 %279
        %281 = OpExtInst %f32_id %150 Exp2 %276
        %282 = OpFOrdLessThan %bool_id %273 %149
        %283 = OpExtInst %f32_id %150 Fma %f32_id_n2 %278 %f32_id_3
        %284 = OpFNegate %f32_id %278
        %285 = OpFMul %f32_id %284 %278
        %286 = OpBitcast %f32_id %109
        %287 = OpFMul %f32_id %286 %280
        %288 = OpBitcast %f32_id %93
        %289 = OpFMul %f32_id %281 %164
        %290 = OpFAdd %f32_id %289 %288
        %291 = OpFMul %f32_id %285 %283
        %292 = OpFAdd %f32_id %291 %f32_id_1
        %293 = OpExtInst %f32_id %150 Exp2 %287
        %294 = OpSelect %f32_id %282 %f32_id_0 %f32_id_n1
        %295 = OpSelect %f32_id %282 %f32_id_0 %290
        %296 = OpBitcast %f32_id %101
        %297 = OpFMul %f32_id %296 %293
        %298 = OpFSub %f32_id %294 %292
        %299 = OpFMul %f32_id %f32_id_0_5 %267
        %300 = OpFAdd %f32_id %299 %243
        %301 = OpFAdd %f32_id %f32_id_1 %298
        %302 = OpFMul %f32_id %292 %297
        %303 = OpFAdd %f32_id %302 %295
        %304 = OpBitcast %f32_id %97
        %305 = OpBitcast %f32_id %101
        %306 = OpFMul %f32_id %304 %300
        %307 = OpFAdd %f32_id %306 %305
        %308 = OpFMul %f32_id %301 %307
        %309 = OpFAdd %f32_id %308 %303
        %310 = OpFOrdGreaterThan %bool_id %309 %241
        %311 = OpBitcast %f32_id %252
        %312 = OpSelect %f32_id %310 %273 %311
        %313 = OpBitcast %u32_id %312
        %314 = OpBitcast %f32_id %251
        %315 = OpSelect %f32_id %310 %314 %273
        %316 = OpBitcast %u32_id %315
               OpBranch %66
         %66 = OpLabel
               OpBranchConditional %true %63 %67
         %67 = OpLabel
        %317 = OpPhi %u32_id %251 %64 %316 %66
        %318 = OpPhi %u32_id %252 %64 %313 %66
        %319 = OpBitcast %f32_id %318
        %320 = OpBitcast %f32_id %317
        %321 = OpFAdd %f32_id %319 %320
        %322 = OpFMul %f32_id %321 %f32_id_0_5
        %323 = OpCompositeConstruct %f32vec4_id %322 %f32_id_0 %f32_id_0 %f32_id_0
        %324 = OpCompositeConstruct %u32vec2_id %116 %u32_id_0
        %325 = OpVectorShuffle %f32vec4_id %220 %323 4 0 0 0
        %326 = OpLoad %56 %cs_img16
               OpImageWrite %326 %324 %325 None
               OpBranch %68
         %68 = OpLabel
               OpReturn
               OpFunctionEnd
