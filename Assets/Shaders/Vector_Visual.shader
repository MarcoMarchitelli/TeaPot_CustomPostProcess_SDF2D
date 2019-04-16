Shader "Unlit/Vector_Visual"
{
    Properties
    {
		_InsideColor("Inside Color", Color) = (1,1,1,1)
		_OutsideColor("Outside Color", Color) = (1,1,1,1)

		_v0_X ("v0 X", float) = 0
		_v0_Y("v0 Y", float) = 0
		_v1_X("v1 X", float) = 0
		_v1_Y("v1 Y", float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

			float sdLine(in float2 p, in float2 a, in float2 b)
			{
				float2 pa = p - a, ba = b - a;
				float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
				return length(pa - ba * h);
			}

			float Union(float a, float b) {
				return min(a, b);
			}

			float4 _InsideColor;
			float4 _OutsideColor;

			float _v0_X;
			float _v0_Y;
			float _v1_X;
			float _v1_Y;

            fixed4 frag (v2f i) : SV_Target
            {
				float2 origin = i.uv - 0.5;

				float2 v0 = float2(_v0_X, _v0_Y);
				float2 v1 = float2(_v1_X, _v1_Y);

				float line1 = sdLine(origin, 0, v0);
				float line2 = sdLine(origin, 0, v1);

				float sum = sdLine(origin, 0, v0 + v1);
				float sub = sdLine(origin, 0, v0 - v1);

				float scene = Union(line1, line2);
				scene = Union(scene, sum);
				scene = Union(scene, sub);

				fixed4 col = lerp(_InsideColor, _OutsideColor, step(0.01, scene));

                return col;
            }
            ENDCG
        }
    }
}