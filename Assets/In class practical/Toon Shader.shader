Shader "Custom/Toon Shader"
{
    Properties
    {
        [MainTexture] _MainTex("Texture", 2D) = "white" {}
        _RampTex("Ramp Texture", 2D) = "white" {}
    }

    SubShader
    {
		Pass
		{
			HLSLPROGRAM

			#include "Packages\com.unity.render-pipelines.universal\ShaderLibrary\Core.hlsl"
			#include "Packages\com.unity.render-pipelines.universal\ShaderLibrary\Lighting.hlsl"

			#pragma fragment frag
			#pragma vertex vert

			TEXTURE2D(_MainTex);
			SAMPLER(sampler_MainTex);

			TEXTURE2D(_RampTex);
			SAMPLER(sampler_RampTex);

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

			float4 frag(Varyings IN) : SV_TARGET
			{
				float3 albedo = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv).rgb;

				Light mainLight = GetMainLight();

				// Half lambert for a more cartoonish effect
				float lambert = saturate(dot(mainLight.direction, IN.normalWS)) * 0.5 + 0.5;
				float rampLambert = SAMPLE_TEXTURE2D(_RampTex, sampler_RampTex, float2(lambert, 0)).r;

				float3 finalColor = albedo * (mainLight.color * rampLambert);

				return float4(finalColor, 1);
			}

			ENDHLSL
		}

		UsePass "Universal Render Pipeline/Simple Lit/SHADOWCASTER"
		UsePass "Universal Render Pipeline/Simple Lit/DEPTHONLY"
    }

	Fallback  "Hidden/Universal Render Pipeline/FallbackError"
}