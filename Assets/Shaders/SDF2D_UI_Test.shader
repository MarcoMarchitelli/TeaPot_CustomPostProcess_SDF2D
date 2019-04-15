// Upgrade NOTE: replaced 'mul(UNITY_MaTRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/Custom/SDF2D/UI"
{
	Properties{
		_MainTex ("Texture", 2D) = "white" {}

		_Color ("Color", Color) = (1,1,1,1)
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
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 worldPos : TEXCOORD0;
            };

            v2f vert (appdata v)
            {
                v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
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

            fixed4 frag (v2f i) : SV_Target
            {
                return Circle(_ScreenParams.xy, 20);
            }
			
            ENDCG
        }
    }
}