#include <metal_stdlib>
using namespace metal;

// Vertex shader input structure
struct VertexIn {
    float3 position [[attribute(0)]];
    float2 texCoord [[attribute(1)]];
    float3 normal [[attribute(2)]];
};

// Vertex shader output / fragment shader input
struct VertexOut {
    float4 position [[position]];
    float2 texCoord;
    float3 normal;
};

// Uniforms
struct Uniforms {
    float4x4 modelViewProjectionMatrix;
    float4x4 normalMatrix;
};

// Vertex shader
vertex VertexOut vertexShader(
    VertexIn in [[stage_in]],
    constant Uniforms& uniforms [[buffer(1)]]
) {
    VertexOut out;
    out.position = uniforms.modelViewProjectionMatrix * float4(in.position, 1.0);
    out.texCoord = in.texCoord;
    out.normal = (uniforms.normalMatrix * float4(in.normal, 0.0)).xyz;
    return out;
}

// Fragment shader
fragment float4 fragmentShader(
    VertexOut in [[stage_in]],
    texture2d<float> colorTexture [[texture(0)]],
    sampler textureSampler [[sampler(0)]]
) {
    float4 color = colorTexture.sample(textureSampler, in.texCoord);
    float3 normal = normalize(in.normal);
    float3 lightDir = normalize(float3(1.0, 1.0, 1.0));
    float diffuse = max(dot(normal, lightDir), 0.0);
    return color * diffuse;
}

// Compute kernel example
kernel void computeKernel(
    device float* input [[buffer(0)]],
    device float* output [[buffer(1)]],
    uint id [[thread_position_in_grid]]
) {
    output[id] = input[id] * 2.0;
}

// Example with address space qualifiers
kernel void addressSpaceExample(
    device float* deviceData [[buffer(0)]],
    threadgroup float* sharedData [[buffer(1)]],
    constant float& constantValue [[buffer(2)]],
    uint gid [[thread_position_in_grid]],
    uint lid [[thread_position_in_threadgroup]]
) {
    // Use different address spaces
    thread float localValue = deviceData[gid];
    sharedData[lid] = localValue * constantValue;
    threadgroup_barrier(mem_flags::mem_threadgroup);
    deviceData[gid] = sharedData[lid];
}
