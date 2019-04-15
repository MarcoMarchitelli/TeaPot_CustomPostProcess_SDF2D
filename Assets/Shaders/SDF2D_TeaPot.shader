// Upgrade NOTE: replaced 'mul(UNITY_MaTRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/Custom/SDF2D/Teapot"
{
	Properties{
		_MainTex ("Texture", 2D) = "white" {}

		_InsideColor ("Inside Color", Color) = (1,1,1,1)
		_OutsideColor ("Outside Color", Color) = (1,1,1,1)
		_ColorBlendStep ("Color Blend Step", range(0,0.2)) = 0

		_PotSize ("Pot Size", range(0,1)) = .2
		_PotSmoothness ("Pot Smoothness", range(0,.1)) = .01 

		_BeakPosition("Beak Position", Vector) = (0,0,0,0)
		_v0 ("v0", Vector) = (0,0,0,0)
		_v1 ("v1", Vector) = (0,0,0,0)
		_v2 ("v2", Vector) = (0,0,0,0)
		_BeakSize ("Beak Size", range(0,1)) = .2
		_BeakSmoothness ("Beak Smoothness", range(0,.1)) = .01 

		_LidPosition ("Lid Position", Vector) = (0,0,0,0)
		_LidSize ("Lid Size", range(0,1)) = .2
		_LidSmoothness ("Lid Smoothness", range(0,.1)) = .01 

		_HandlePosition ("Handle Position", Vector) = (0,0,0,0)
		_HandleSize ("Lid Size", range(0,1)) = .3
		_HandleSmoothness ("Handle Smoothness", range(0,.1)) = .01 
		_HandleThickness ("Handle Thickness", range(0,.1)) = .01 
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

			float sdBezier( in float2 pos, in float2 A, in float2 B, in float2 C )
			{    
			    float2 a = B - A;
			    float2 b = A - 2.0*B + C;
			    float2 c = a * 2.0;
			    float2 d = A - pos;
			
			    float kk = 1.0 / dot(b,b);
			    float kx = kk * dot(a,b);
			    float ky = kk * (2.0*dot(a,a)+dot(d,b)) / 3.0;
			    float kz = kk * dot(d,a);      
			
			    float res = 0.0;
			
			    float p = ky - kx*kx;
			    float p3 = p*p*p;
			    float q = kx*(2.0*kx*kx - 3.0*ky) + kz;
			    float h = q*q + 4.0*p3;
			
			    if(h >= 0.0) 
			    { 
			        h = sqrt(h);
			        float2 x = (float2(h, -h) - q) / 2.0;
			        float2 uv = sign(x)*pow(abs(x), float2(1.0/3.0,1.0/3.0));
			        float t = uv.x + uv.y - kx;
			        t = clamp( t, 0.0, 1.0 );
			
			        float2 qos = d + (c + b*t)*t;
			        res = dot(qos,qos);
			    }
			    else
			    {
			        float z = sqrt(-p);
			        float v = acos( q/(p*z*2.0) ) / 3.0;
			        float m = cos(v);
			        float n = sin(v)*1.732050808;
			        float3 t = float3(m + m, -n - m, n - m) * z - kx;
			        t = clamp( t, 0.0, 1.0 );
			
			        float2 qos = d + (c + b*t.x)*t.x;
			        res = dot(qos,qos);
			
			        qos = d + (c + b*t.y)*t.y;
			        res = min(res,dot(qos,qos));
			
			        qos = d + (c + b*t.z)*t.z;
			        res = min(res,dot(qos,qos));
			    }
			    
			    return sqrt( res );
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
			float _ColorBlendStep;

			float _PotSize;
			float _PotSmoothness;

			float _BeakSize;
			float _BeakSmoothness;

			float4 _LidPosition;
			float _LidSize;
			float _LidSmoothness;

			float _HandleSmoothness;
			float _HandleThickness;
			float4 _HandlePosition;
			float _HandleSize;
			float4 _v0;
			float4 _v1;
			float4 _v2;

            fixed4 frag (v2f i) : SV_Target
            {
				float2 center = i.uv - 0.5;
				
				float pot = Circle(center, _PotSize);
				float quad = Rectangle(center, float2(_PotSize * .5, _PotSize));
				quad = Round(quad, _PotSmoothness);

				float handle = Circle(center - _HandlePosition.xy, _PotSize * _HandleSize);
				handle = annular(handle, _HandleThickness);

				float lid = Circle(center - _LidPosition.xy, _PotSize * _LidSize);

				float beak = sdBezier(center, _v0.xy,_v1.xy,_v2.xy);
				beak -= _BeakSize;			

				float teapot = SmoothUnion(pot, quad, _PotSmoothness);
				teapot = SmoothUnion(teapot, handle, _HandleSmoothness);
				teapot = SmoothUnion(teapot, lid, _LidSmoothness);
				teapot = SmoothUnion(teapot, beak, _BeakSmoothness);

				fixed4 col = lerp(_InsideColor, _OutsideColor, step(_ColorBlendStep, teapot));

                return col;
            }
			
            ENDCG
        }
    }
}