Shader "Custom/WaterWaveShader"
{
	Properties
	{
			_Color("Color", Color) = (1,1,1,1)
			_MainTex("Albedo (RGB)", 2D) = "white" {}
			_Glossiness("Smoothness", Range(0,1)) = 0.5
			_Metallic("Metallic", Range(0,1)) = 0.0
			_DisplacementMap("Displacement Map", 2D) = "black" {}
			_DisplacementStrength("Displancement Strength", Range(0,10)) = 0.5
			_TimeShift("time shift affect", Range(0,1000)) = 0
			_RotationSpeed("rotation speed", Range(0,360)) = 0
			_v("v", Range(-10,10)) = 1
			_m("m", Range(-10,10)) = 1
			_z("z", Range(-10,10)) = 1
			_xOffset("x Offset", Range(-10,10)) = 1
			_yOffset("y Offset", Range(-10,10)) = 1
			_zOffset("z Offset", Range(-10,10)) = 1
			_RampTex("Ramp Texture", 2D) = "white" {}

	}
		SubShader
			{
					Pass
					{

					CGPROGRAM
					#pragma vertex vert
					#pragma fragment frag
					#pragma multi_compile_fog
					#include "UnityCG.cginc"
					// Physically based Standard lighting model, and enable shadows on all light types
				//#pragma surface surf Standard fullforwardshadows

				struct Input
				{
						float2 uv_MainTex;
				};
				struct appdata {
						float4 vertex : POSITION;
						float2 uv : TEXCOORD0;
						float3 normal : NORMAL;
				};
				struct v2f
				{
						float2 uv :TEXCOORD0;
						UNITY_FOG_COORDS(1)
						float4 vertex : SV_POSITION;
				};
				half _Glossiness;
				half _Metallic;
				half _DisplacementStrength;
				half _TimeShift;
				half _RotationSpeed;
				fixed4 _Color;
				sampler2D _MainTex;
				sampler2D _DisplacementMap;
				float4 _MainTex_ST;
				half _v;
				half _m;
				half _z;
				half _xOffset;
				half _yOffset;
				half _zOffset;

				// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
					// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
					// #pragma instancing_options assumeuniformscaling
					UNITY_INSTANCING_BUFFER_START(Props)
						// put more per-instance properties here
						UNITY_INSTANCING_BUFFER_END(Props)
						v2f vert(appdata v) {
								v2f o;

								//v.uv.xy -= 0.5;
								//float s = sin(_RotationSpeed * _TimeShift);
								//float c = cos(_RotationSpeed * _TimeShift);
								//float2x2 rotationMatrix = float2x2(c, -s, s, c);
								//rotationMatrix *= 0.5;
								//rotationMatrix += 0.5;
								//rotationMatrix = rotationMatrix * 2 - 1;
								//v.uv.xy = mul(v.uv.xy, rotationMatrix);
								//v.uv.xy += 0.5;

								o.uv = TRANSFORM_TEX(v.uv, _MainTex); 
								float displacement = (sqrt(pow(v.vertex.x + _xOffset, 2) + pow(v.vertex.y + _yOffset, 2) + pow(v.vertex.z + _zOffset, 2)) * _v + _m + _TimeShift * 180) % 2;
								if (displacement < 1) {
									displacement = 0;
								} else {
									displacement = 1;
								}
								//float displacement = sin(v.vertex.z * _v + _m) *_z;
								//float displacement = 0;
								float4 temp = float4(v.vertex.x, v.vertex.y, v.vertex.z, 1.0);
								temp.xyz += displacement * v.normal * _DisplacementStrength;
								o.vertex = UnityObjectToClipPos(temp);

								UNITY_TRANSFER_FOG(o, o.vertex);
								return o;
						}
						fixed4 frag(v2f i) : SV_Target{
								fixed4 col = tex2D(_MainTex, i.uv);
								UNITY_APPLY_FOG(i.fogCoord, col)
								return col;

						}
						ENDCG

						}
			}
}