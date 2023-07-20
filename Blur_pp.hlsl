
//--------------------------------------------------------------------------------------
// Blur effect Post-Processing Pixel Shader
//--------------------------------------------------------------------------------------
// Samples pixel in a 3x3 surrounding the current pixel adds all colour values and then divides by 9

#include "Common.hlsli"


//--------------------------------------------------------------------------------------
// Textures (texture maps)
//--------------------------------------------------------------------------------------

// The scene has been rendered to a texture, these variables allow access to that texture
Texture2D SceneTexture : register(t0);
SamplerState PointSample : register(s0);
                                      
//--------------------------------------------------------------------------------------
// Shader code
//--------------------------------------------------------------------------------------

// Post-processing shader that tints the scene texture to a given colour
float4 main(PostProcessingInput input) : SV_TARGET
{
    float3 Colour = SceneTexture.Sample(PointSample, input.sceneUV);
    
    for (int x = -1; x <= 1; x++)
        for (int y = -1; y <= 1; y++)
            Colour += SceneTexture.Sample(PointSample, input.sceneUV + float2(x, y) / float2(gViewportWidth, gViewportHeight));
    
    return float4(Colour /= 9.0f, 1.0f);
}