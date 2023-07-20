#include "Common.hlsli"

//--------------------------------------------------------------------------------------
// Textures (texture maps)
//--------------------------------------------------------------------------------------

// The scene has been rendered to a texture, these variables allow access to that texture
Texture2D SceneTexture : register(t0);
SamplerState PointSample : register(s0);


float4 main(PostProcessingInput input) : SV_TARGET
{
	// Water is a combination of sine waves in x and y dimensions
    float SinX = sin(input.sceneUV.x * radians(300.0f) + gWaterTimer);
    float SinY = sin(input.sceneUV.y * radians(300.0f) + gWaterTimer);
	
	// Offset for scene texture UV based on water effect
    float2 waterOffset = float2(SinY, SinX) * 0.01f;
	
    float3 waterTint = float3(0.0f, 0.1f, 0.2f);
	
    float3 colour = SceneTexture.Sample(PointSample, input.sceneUV + waterOffset).rgb + waterTint;
	
    return float4(colour, 1.0f);
}