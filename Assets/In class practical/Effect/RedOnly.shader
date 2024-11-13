Shader "Fullscreen/RedOnly"
{
    Properties
    {
    }
    SubShader
    {
		Pass
		{

			HLSLPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

			TEXTURE2D(_BlitTexture);
			SAMPLER(sampler_BlitTexture);

			struct Attributes
			{
				float3 position : POSITION;
			};

			float4 vert(Attributes v) : SV_POSITION
			{

			}

			float4 frag()
			{

			}

			ENDHLSL

		}
	}
}
