
#include "Common.hlsli"


//--------------------------------------------------------------------------------------
// Textures (texture maps)
//--------------------------------------------------------------------------------------

// The scene has been rendered to a texture, these variables allow access to that texture
Texture2D SceneTexture : register(t0);
SamplerState PointSample : register(s0); // We don't usually want to filter (bilinear, trilinear etc.) the scene texture when
                                          // post-processing so this sampler will use "point sampling" - no filtering


//--------------------------------------------------------------------------------------
// Shader code
//--------------------------------------------------------------------------------------

static const float weights[21] =
{
    0.421273256292181e-7,
    0.000009677359081674635,
    0.0000777489201475167,
    0.0004886419989245074,
    0.0024027325605485827,
    0.009244616587506386,
    0.027834685329492057,
    0.06559073722230267,
    0.12097746070390959,
    0.17466647146354097,
    0.19741257145444083,
    0.17466647146354097,
    0.12097746070390959,
    0.06559073722230267,
    0.027834685329492057,
    0.009244616587506386,
    0.0024027325605485827,
    0.0004886419989245074,
    0.0000777489201475167,
    0.000009677359081674635,
    9.421273256292181e-7
};

// Post-processing shader that tints the scene texture to a given colour
float4 main(PostProcessingInput input): SV_Target
{
    float3 Colour = { 0, 0, 0 };
    
    for (int i = -10; i < 10; i++)
    {
        Colour += weights[i + 10] * SceneTexture.Sample(PointSample, input.sceneUV + float2(0.0f, i / gViewportHeight));
    }

    return float4(Colour, 1.0f);
}