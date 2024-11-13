Shader "Custom/Toon URP Shader"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _RampTex("Ramp Texture", 2D) = "white" {}
    }

        SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        Pass
        {
            Name "ToonPass"
            Tags { "LightMode" = "UniversalForward" }

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"
            #include "Lighting.hlsl"
            #include "UnityPBSLighting.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 normalWS : TEXCOORD1;
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD2;
            };

            sampler2D _RampTex;
            float4 _Color;

            Varyings vert(Attributes v)
            {
                Varyings o;
                o.positionCS = UnityObjectToClipPos(v.positionOS);
                o.normalWS = UnityObjectToWorldNormal(v.normalOS);
                o.uv = v.uv;
                o.worldPos = mul(unity_ObjectToWorld, v.positionOS).xyz;
                return o;
            }

            float4 frag(Varyings IN) : SV_Target
            {
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float diff = dot(IN.normalWS, lightDir);

                float h = saturate(diff * 0.5 + 0.5);

                float3 rampColor = tex2D(_RampTex, float2(h, 0.5)).rgb;

                float3 color = _Color.rgb * _LightColor0.rgb * rampColor;

                return float4(color, 1.0);
            }
            ENDHLSL
        }
    }
        FallBack "Diffuse"
}
