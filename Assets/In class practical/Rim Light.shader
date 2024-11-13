Shader "Custom/Rim Light"
{
    Properties
    {
		_MainTex ("Main Tex", 2D) = "white" {}
		_RimPower ("Rim Power", Float) = 1
		_RimColor ("Rim Color", Color) = (1, 0, 0, 1)
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

			float3 _RimColor;
			float _RimPower;

			struct Attributes
			{
				float3 positionOS 	: POSITION;
				float2 uv			: TEXCOORD0;
				float3 normalOS		: NORMAL;
			};

			struct Varyings
			{
				float4 positionCS 	: SV_POSITION;
				float2 uv			: TEXCOORD0;
				float3 normalWS		: NORMAL;
				float3 viewDirWS	: TEXCOORD1;
			};

			Varyings vert(Attributes v)
			{
				Varyings o;

				o.positionCS = TransformObjectToHClip(v.positionOS);
				o.uv = v.uv;

				// Transform object space normal to world space
				o.normalWS = normalize(TransformObjectToWorldNormal(v.normalOS));

				// Calculate the view direction in world space (from the camera to the surface)
				float3 worldPosWS = TransformObjectToWorld(v.positionOS.xyz);
				o.viewDirWS = normalize(GetCameraPositionWS() - worldPosWS);

				return o;
			}

			float4 frag(Varyings v) : SV_TARGET
			{
				float3 albedo = _MainTex.Sample(sampler_MainTex, v.uv).rgb;

				// Normalize the world space normal and view direction
				half3 normalWS = normalize(v.normalWS);
				half3 viewDirWS = normalize(v.viewDirWS);

				// Rim lighting calculation (using dot product between normal and view direction)
				half rimFactor = 1.0 - saturate(dot(viewDirWS, normalWS));
				half rimLighting = pow(rimFactor, _RimPower);

				// Combine rim lighting color with the base color
				half3 finalColor = lerp(albedo.rgb, _RimColor.rgb, rimLighting);

				return float4(finalColor.rgb, 1);
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
