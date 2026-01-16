/**
 * @file A Tree Sitter Grammar for Apple's Metal Shading Language.
 * @author Joseph D. Carpinelli <joey@loopy.codes>
 * @license MIT
 */

/// <reference types="tree-sitter-cli/dsl" />
// @ts-check

const CPP = require("tree-sitter-cpp/grammar");

module.exports = grammar(CPP, {
  name: "metal",

  // Metal is based on C++14 with restrictions and extensions
  // Key differences:
  // - Address space qualifiers (device, threadgroup, constant, thread)
  // - Metal Standard Library types (vectors, matrices, textures, samplers)
  // - Shader function attributes (vertex, fragment, kernel)
  // - Function argument attributes (stage_in, buffer, texture, etc.)

  rules: {
    // Extend type qualifiers to include Metal address space qualifiers
    type_qualifier: ($, original) =>
      choice(
        original,
        "device", // device memory address space
        "threadgroup", // threadgroup memory address space
        "constant", // constant memory address space (stricter than C const)
        "thread", // thread memory address space (explicit thread-local)
      ),

    // Metal attributes - extend the existing attribute rule to include Metal-specific ones
    attribute: ($, original) =>
      choice(
        original,
        // Shader entry point attributes
        "vertex",
        "fragment",
        "kernel",

        // Function argument attributes
        "stage_in",
        seq("buffer", "(", $.number_literal, ")"),
        seq("texture", "(", $.number_literal, ")"),
        seq("sampler", "(", $.number_literal, ")"),
        seq("threadgroup", "(", $.number_literal, ")"),
        seq("color", "(", $.number_literal, ")"),

        // Vertex output / fragment input attributes
        "position",
        "point_size",
        "clip_distance",
        "front_facing",
        "sample_id",
        "sample_mask",
        seq("depth", "(", choice("any", "greater", "less"), ")"),

        // Fragment function attributes
        "early_fragment_tests",

        // Interpolation attributes
        "flat",
        "center_perspective",
        "center_no_perspective",
        "centroid_perspective",
        "centroid_no_perspective",
        "sample_perspective",
        "sample_no_perspective",

        // Compute kernel attributes
        seq("max_total_threads_per_threadgroup", "(", $.number_literal, ")"),
      ),

    // Metal primitive types - vectors, matrices, textures, samplers
    primitive_type: ($, original) =>
      choice(
        original,
        // Half-precision floating point
        "half",

        // Vector types - half
        "half2",
        "half3",
        "half4",

        // Vector types - float
        "float2",
        "float3",
        "float4",

        // Vector types - int
        "int2",
        "int3",
        "int4",

        // Vector types - uint
        "uint2",
        "uint3",
        "uint4",

        // Vector types - short
        "short2",
        "short3",
        "short4",

        // Vector types - ushort
        "ushort2",
        "ushort3",
        "ushort4",

        // Vector types - char
        "char2",
        "char3",
        "char4",

        // Vector types - uchar
        "uchar2",
        "uchar3",
        "uchar4",

        // Vector types - bool
        "bool2",
        "bool3",
        "bool4",

        // Matrix types - half
        "half2x2",
        "half2x3",
        "half2x4",
        "half3x2",
        "half3x3",
        "half3x4",
        "half4x2",
        "half4x3",
        "half4x4",

        // Matrix types - float
        "float2x2",
        "float2x3",
        "float2x4",
        "float3x2",
        "float3x3",
        "float3x4",
        "float4x2",
        "float4x3",
        "float4x4",

        // Packed vector types - half
        "packed_half2",
        "packed_half3",
        "packed_half4",

        // Packed vector types - float
        "packed_float2",
        "packed_float3",
        "packed_float4",

        // Packed vector types - int
        "packed_int2",
        "packed_int3",
        "packed_int4",

        // Packed vector types - uint
        "packed_uint2",
        "packed_uint3",
        "packed_uint4",

        // Packed vector types - short
        "packed_short2",
        "packed_short3",
        "packed_short4",

        // Packed vector types - ushort
        "packed_ushort2",
        "packed_ushort3",
        "packed_ushort4",

        // Packed vector types - char
        "packed_char2",
        "packed_char3",
        "packed_char4",

        // Packed vector types - uchar
        "packed_uchar2",
        "packed_uchar3",
        "packed_uchar4",

        // 1D texture types
        "texture1d",
        "texture1d_array",

        // 2D texture types
        "texture2d",
        "texture2d_array",
        "texture2d_ms",
        "texture2d_ms_array",

        // 3D texture types
        "texture3d",

        // Cube texture types
        "texturecube",
        "texturecube_array",

        // Buffer texture types
        "texture_buffer",

        // Depth texture types
        "depth2d",
        "depth2d_array",
        "depth2d_ms",
        "depth2d_ms_array",
        "depthcube",
        "depthcube_array",

        // Sampler type
        "sampler",

        // Atomic types
        "atomic_int",
        "atomic_uint",

        // Ray tracing types (Metal 2.3+)
        "ray_data",
        "raytracing_acceleration_structure",
        "intersection_query",
        "intersector",
        "primitive_acceleration_structure",
        "instance_acceleration_structure",

        // Visible function table (Metal 2.3+)
        "visible_function_table",
        "intersection_function_table",
      ),
  },
});

/**
 * Creates a rule to optionally match one or more of the rules separated by a comma
 *
 * @param {Rule} rule
 *
 * @returns {ChoiceRule}
 */
function commaSep(rule) {
  return optional(commaSep1(rule));
}

/**
 * Creates a rule to match one or more of the rules separated by a comma
 *
 * @param {Rule} rule
 *
 * @returns {SeqRule}
 */
function commaSep1(rule) {
  return seq(rule, repeat(seq(",", rule)));
}
