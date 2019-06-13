// Upgrade NOTE: replaced 'mul(UNITY_MaTRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/Custom/SDF2D/TEST"
{
	Properties{
		_MainTex("Texture", 2D) = "white" {}

		_InsideColor("Inside Color", Color) = (1,1,1,1)
		_OutsideColor("Outside Color", Color) = (1,1,1,1)
		_ColorBlendStep("Color Blend Step", range(0,0.2)) = 0

		_PointsRadius("Points Radius", range(0,0.2)) = 0
		_ArrayLenght("Array Lenght", int) = 15
	}
		SubShader
		{
			// No culling or depth
			Cull Off ZWrite Off ZTest always

			//Tags { "RenderType" = "Opaque" }
			//LOD 100

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

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = v.uv;
					return o;
				}

				float2 Translate(float2 pos, float2 translation) {
					return pos;
				}

				float2 Scale(float2 samplePosition, float scale) {
					return samplePosition / scale;
				}

				float Circle(float2 pos, float rad) {
					return length(pos) - rad;
				}

				float Rectangle(float2 samplePosition, float2 halfSize) {
					float2 componentWiseEdgeDistance = abs(samplePosition) - halfSize;
					float outsideDistance = length(max(componentWiseEdgeDistance, 0));
					float insideDistance = min(max(componentWiseEdgeDistance.x, componentWiseEdgeDistance.y), 0);
					return outsideDistance + insideDistance;
				}

				float sdLine(in float2 p, in float2 a, in float2 b)
				{
					float2 pa = p - a, ba = b - a;
					float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
					return length(pa - ba * h);
				}

				float2 myBezierPoint(float2 a, float2 b, float2 c, float t) {
					float2 d = lerp(a, c, t);
					float2 e = lerp(c, b, t);
					float2 f = lerp(d, e, t);

					return f;
				}

				float sdBezier(in float2 pos, in float2 A, in float2 B, in float2 C)
				{
					float2 a = B - A;
					float2 b = A - 2.0*B + C;
					float2 c = a * 2.0;
					float2 d = A - pos;

					float kk = 1.0 / dot(b,b);
					float kx = kk * dot(a,b);
					float ky = kk * (2.0*dot(a,a) + dot(d,b)) / 3.0;
					float kz = kk * dot(d,a);

					float res = 0.0;

					float p = ky - kx * kx;
					float p3 = p * p*p;
					float q = kx * (2.0*kx*kx - 3.0*ky) + kz;
					float h = q * q + 4.0*p3;

					if (h >= 0.0)
					{
						h = sqrt(h);
						float2 x = (float2(h, -h) - q) / 2.0;
						float2 uv = sign(x)*pow(abs(x), float2(1.0 / 3.0,1.0 / 3.0));
						float t = uv.x + uv.y - kx;
						t = clamp(t, 0.0, 1.0);

						float2 qos = d + (c + b * t)*t;
						res = dot(qos,qos);
					}
					else
					{
						float z = sqrt(-p);
						float v = acos(q / (p*z*2.0)) / 3.0;
						float m = cos(v);
						float n = sin(v)*1.732050808;
						float3 t = float3(m + m, -n - m, n - m) * z - kx;
						t = clamp(t, 0.0, 1.0);

						float2 qos = d + (c + b * t.x)*t.x;
						res = dot(qos,qos);

						qos = d + (c + b * t.y)*t.y;
						res = min(res,dot(qos,qos));

						qos = d + (c + b * t.z)*t.z;
						res = min(res,dot(qos,qos));
					}

					return sqrt(res);
				}

				float Union(float a, float b) {
					return min(a,b);
				}

				float SmoothUnion(float d1, float d2, float k) {
					float h = clamp(0.5 + 0.5*(d2 - d1) / k, 0.0, 1.0);
					return lerp(d2, d1, h) - k * h*(1.0 - h);
				}

				float annular(float a, float annularness) {
					return abs(a) - annularness;
				}

				float Round(float a, float roundness) {
					return a - roundness;
				}

				float4 _InsideColor;
				float4 _OutsideColor;
				float _ColorBlendStep;

				float _PointsRadius;

				int _ArrayLenght;
				float4 _PointsArray[50];

				fixed4 frag(v2f i) : SV_Target
				{
					float2 center = i.uv;

					float sdf;
					
					//for (int i = 0; i < _ArrayLenght; i++) {
					//	float p = Circle(center - _PointsArray[i], _PointsRadius);
					//	sdf += Union(sdf, p);
					//}

					for (int i = 0; i < _ArrayLenght; i+=3) {
						float curve = sdBezier(center , _PointsArray[i].xy , _PointsArray[i+1].xy, _PointsArray[i+2].xy);
						curve -= lerp(_PointsRadius, _PointsRadius +.02, sin(_Time.y) +1 - .5);
						sdf += Union(sdf, curve);
					}

					fixed4 col = lerp(_InsideColor, _OutsideColor, step(_ColorBlendStep, sdf));

					return col;
				}

				ENDCG
			}
		}
}