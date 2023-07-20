//--------------------------------------------------------------------------------------
// Vertical Gradient Colour Tint Post-Processing Pixel Shader
//--------------------------------------------------------------------------------------
// Applies two tints to a pixel and lerps between the colours based on the pixels y value

#include "Common.hlsli"

//--------------------------------------------------------------------------------------
// Textures (texture maps)
//--------------------------------------------------------------------------------------

// The scene has been rendered to a texture, these variables allow access to that texture
Texture2D    SceneTexture : register(t0);
SamplerState PointSample  : register(s0);


//--------------------------------------------------------------------------------------
// Shader Functions
//--------------------------------------------------------------------------------------

float3 RGBToHSL(float3 rgb)
{
    float r = rgb.r;
    float g = rgb.g;
    float b = rgb.b;
    
    float cmax = max(max(r, g), b);
    float cmin = min(min(r, g), b);
    float delta = cmax - cmin;
    
    float h = 0.0;
    if (delta == 0.0)
    {
        h = 0.0;
    }
    else if (cmax == r)
    {
        h = fmod((g - b) / delta, 6.0);
    }
    else if (cmax == g)
    {
        h = (b - r) / delta + 2.0;
    }
    else if (cmax == b)
    {
        h = (r - g) / delta + 4.0;
    }
    h *= 60.0;
    
    float l = (cmax + cmin) / 2.0;
    
    float s = 0.0;
    if (delta == 0.0)
    {
        s = 0.0;
    }
    else
    {
        s = delta / (1.0 - abs(2.0 * l - 1.0));
    }
    
    return float3(h, s, l);
}

float3 HSLtoRGB(float3 hsl)
{
    float h = hsl.r;
    float s = hsl.g;
    float l = hsl.b;
    
    float c = (1.0 - abs(2.0 * l - 1.0)) * s;
    float x = c * (1.0 - abs(fmod(h / 60.0, 2.0) - 1.0));
    float m = l - c / 2.0;
    
    float r, g, b;
    if (h < 60.0)
    {
        r = c;
        g = x;
        b = 0.0;
    }
    else if (h < 120.0)
    {
        r = x;
        g = c;
        b = 0.0;
    }
    else if (h < 180.0)
    {
        r = 0.0;
        g = c;
        b = x;
    }
    else if (h < 240.0)
    {
        r = 0.0;
        g = x;
        b = c;
    }
    else if (h < 300.0)
    {
        r = x;
        g = 0.0;
        b = c;
    }
    else
    {
        r = c;
        g = 0.0;
        b = x;
    }
    
    return float3(r + m, g + m, b + m);
}


//--------------------------------------------------------------------------------------
// Shader code
//--------------------------------------------------------------------------------------

// Post-processing shader that tints the scene texture to a given colour
float4 main(PostProcessingInput input) : SV_Target
{
    float3 Colour1, Colour2, HSL1, HSL2, HSL3, RGB;
    
    Colour1 = SceneTexture.Sample(PointSample, input.sceneUV).rgb * gGradientColour1;
    Colour2 = SceneTexture.Sample(PointSample, input.sceneUV).rgb * gGradientColour2;
    
    HSL1 = RGBToHSL(Colour1);
    HSL1.x += gHueTimer * 5.0f;
    
    HSL2 = RGBToHSL(Colour2);
    HSL2.x += gHueTimer * 5.0f;
   
    return float4(lerp(HSLtoRGB(HSL1), HSLtoRGB(HSL2), input.sceneUV.y), 0.0f);
}

