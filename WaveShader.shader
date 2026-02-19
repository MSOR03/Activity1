Shader "Custom/WaveShader"
{
    Properties
    {
        _ColorA ("Color Bajo", Color) = (0,0,1,1)
        _ColorB ("Color Alto", Color) = (1,0,0,1)
        _Amplitude ("Amplitud", Float) = 0.5
        _Frequency ("Frecuencia", Float) = 2.0
        _Speed ("Velocidad", Float) = 1.0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline"="UniversalRenderPipeline" }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            float4 _ColorA;
            float4 _ColorB;
            float _Amplitude;
            float _Frequency;
            float _Speed;

            struct Attributes
            {
                float4 positionOS : POSITION;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float height : TEXCOORD0;
            };

            Varyings vert(Attributes IN)
            {
                Varyings OUT;

                float wave = sin(IN.positionOS.x * _Frequency + _Time.y * _Speed) * _Amplitude;

                float3 newPos = IN.positionOS.xyz;
                newPos.y += wave;

                OUT.height = newPos.y;
                OUT.positionHCS = TransformObjectToHClip(newPos);

                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                float t = saturate(IN.height);
                return lerp(_ColorA, _ColorB, t);
            }

            ENDHLSL
        }
    }
}
