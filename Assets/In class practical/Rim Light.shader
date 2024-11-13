Shader "Custom/Rim Light"
{
    Properties
    {
		_MainTex ("Main Tex", 2D) = "white" {}
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
        LOD 300

        Pass
        {
            Name "ForwardLit"
            Tags
            {
                "LightMode" = "UniversalForward"
            }

			HLSLPROGRAM

			#include "Packages\com.unity.render-pipelines.universal\ShaderLibrary\Core.hlsl"
			#include "Packages\com.unity.render-pipelines.universal\ShaderLibrary\Lighting.hlsl"

			#pragma fragment frag
			#pragma vertex vert

			TEXTURE2D(_MainTex);
			SAMPLER(sampler_MainTex);

			struct Attributes
			{
				float3 positionOS 	: POSITION;
				float2 uv			: TEXCOORD0;
			};

			struct Varyings
			{
				float4 positionCS 	: SV_POSITION;
				float2 uv			: TEXCOORD0;
			};

			Varyings vert(Attributes v)
			{
				Varyings o;

				o.positionCS = TransformObjectToHClip(v.positionOS);
				o.uv = v.uv;

				return o;
			}

			float4 frag(Varyings v) : SV_TARGET
			{
				float3 albedo = _MainTex.Sample(sampler_MainTex, v.uv).rgb;

				// Normalize the world space normal and view direction
				half3 normalWS = normalize(IN.normalWS);
				half3 viewDirWS = normalize(IN.viewDirWS);

				// Rim lighting calculation (using dot product between normal and view direction)
				half rimFactor = 1.0 - saturate(dot(viewDirWS, normalWS));
				half rimLighting = pow(rimFactor, _RimPower);

				// Combine rim lighting color with the base color
				half3 finalColor = albedo.rgb + _RimColor.rgb * rimLighting;

				float rim = dot()

				return float4(albedo.rgb, 1);
			}
            
            ENDHLSL
        }

        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }

            // -------------------------------------
            // Render State Commands
            ZWrite On
            ZTest LEqual
            ColorMask 0
            Cull[_Cull]

            HLSLPROGRAM
            #pragma target 2.0

            // -------------------------------------
            // Shader Stages
            #pragma vertex ShadowPassVertex
            #pragma fragment ShadowPassFragment

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local _ALPHATEST_ON
            #pragma shader_feature_local_fragment _GLOSSINESS_FROM_BASE_ALPHA

            // -------------------------------------
            // Unity defined keywords
            #pragma multi_compile _ LOD_FADE_CROSSFADE

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"

            // This is used during shadow map generation to differentiate between directional and punctual light shadows, as they use different formulas to apply Normal Bias
            #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW

            // -------------------------------------
            // Includes
            #include "Packages/com.unity.render-pipelines.universal/Shaders/SimpleLitInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/ShadowCasterPass.hlsl"
            ENDHLSL
        }

        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }

            // -------------------------------------
            // Render State Commands
            ZWrite On
            ColorMask R
            Cull[_Cull]

            HLSLPROGRAM
            #pragma target 2.0

            // -------------------------------------
            // Shader Stages
            #pragma vertex DepthOnlyVertex
            #pragma fragment DepthOnlyFragment

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local _ALPHATEST_ON
            #pragma shader_feature_local_fragment _GLOSSINESS_FROM_BASE_ALPHA

            // -------------------------------------
            // Unity defined keywords
            #pragma multi_compile _ LOD_FADE_CROSSFADE

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"

            // -------------------------------------
            // Includes
            #include "Packages/com.unity.render-pipelines.universal/Shaders/SimpleLitInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/DepthOnlyPass.hlsl"
            ENDHLSL
        }
    }

    Fallback  "Hidden/Universal Render Pipeline/FallbackError"
}
