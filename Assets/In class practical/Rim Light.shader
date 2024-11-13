Shader "Custom/Rim Light"
{
    Properties
    {
		[MainTexture] _MainTex ("Main Tex", 2D) = "white" {}
		_RimColor ("Rim Color", Color) = (1, 1, 1, 1)
		_RimIntensity ("Rim Intensity", Float) = 2
		_RimPower ("Rim Power", Float) = 2
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "RenderPipeline" = "UniversalPipeline"
            "UniversalMaterialType" = "SimpleLit"
            "IgnoreProjector" = "True"
        }

        Pass
        {
            Name "ForwardLit"
            Tags
            {
                "LightMode" = "UniversalForward"
            }

			HLSLPROGRAM

			#define SHADEROPTIONS_CAMERA_RELATIVE_RENDERING (1)

			#include "Packages\com.unity.render-pipelines.universal\ShaderLibrary\Core.hlsl"
			#include "Packages\com.unity.render-pipelines.universal\ShaderLibrary\Lighting.hlsl"

			#pragma fragment frag
			#pragma vertex vert

			TEXTURE2D(_MainTex);
			SAMPLER(sampler_MainTex);

			float3 _RimColor;
			float _RimPower;
			float _RimIntensity;

			struct Attributes
			{
				float3 positionOS 	: POSITION;
				float2 uv			: TEXCOORD0;
				float3 normalOS 	: NORMAL;
			};

			struct Varyings
			{
				float4 positionCS 	: SV_POSITION;
				float3 positionWS 	: POSITIONT;
				float3 normalWS		: NORMAL;
				float2 uv			: TEXCOORD0;
			};

			Varyings vert(Attributes v)
			{
				Varyings o;

				o.positionWS = TransformObjectToWorld(v.positionOS);
				o.positionCS = TransformWorldToHClip(o.positionWS);
				o.normalWS = TransformObjectToWorldDir(v.normalOS);
				o.uv = v.uv;

				return o;
			}

			float4 frag(Varyings v) : SV_TARGET
			{
				float3 albedo = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, v.uv).rgb;

				float3 camPos = GetCurrentViewPosition();
				float3 dirToCamWS = normalize(camPos - v.positionWS);

				float rim = pow(saturate(1 - dot(v.normalWS, dirToCamWS)), _RimPower);
				
				float3 finalColor = lerp(albedo, _RimColor * _RimIntensity, rim);

				return float4(finalColor, 1);
			}
            
            ENDHLSL
        }

		UsePass "Universal Render Pipeline/Simple Lit/SHADOWCASTER"
		UsePass "Universal Render Pipeline/Simple Lit/DEPTHONLY"
    }

    Fallback  "Hidden/Universal Render Pipeline/FallbackError"
}
