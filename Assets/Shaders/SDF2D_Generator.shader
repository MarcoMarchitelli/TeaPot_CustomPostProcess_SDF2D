// Upgrade NOTE: replaced 'mul(UNITY_MaTRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/Custom/SDF2D/Generator"
{
	Properties{
		_InsideColor ("Inside Color", Color) = (1,1,1,1)
		_OutsideColor ("Outside Color", Color) = (1,1,1,1)
	}
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest always

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

            v2f vert (appdata v)
            {
                v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

			float2 Translate(float2 pos, float2 translation){
				return pos;
			}
			
			float Circle(float2 pos, float rad){
				return length(pos) - rad;
			}
			
			float Rectangle(float2 samplePosition, float2 halfSize){
				float2 componentWiseEdgeDistance = abs(samplePosition) - halfSize;
				float outsideDistance = length(max(componentWiseEdgeDistance, 0));
				float insideDistance = min(max(componentWiseEdgeDistance.x, componentWiseEdgeDistance.y), 0);
				return outsideDistance + insideDistance;
			}

			float Union(float a, float b){
				return min(a,b);
			}

			float SmoothUnion( float d1, float d2, float k ) {
				float h = clamp( 0.5 + 0.5*(d2-d1)/k, 0.0, 1.0 );
				return lerp( d2, d1, h ) - k*h*(1.0-h); 
			}

			float annular(float a, float annularness){
				return abs(a) - annularness;
			}

			float Round(float a, float roundness){
				return a - roundness;
			}

			float4 _InsideColor;
			float4 _OutsideColor;

            fixed4 frag (v2f i) : SV_Target
            {
                return float4(i.uv.x, i.uv.y, 0, 1);
            }
			
            ENDCG
        }
    }
}