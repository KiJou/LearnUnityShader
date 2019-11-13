﻿Shader "lcl/003_Diffuse_fargment_half" {
	//在片元着色器计算漫反射
	//半兰伯特漫反射
	SubShader {
		Pass{
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM
			#include "Lighting.cginc"
			#pragma vertex vert
			#pragma fragment frag


			struct a2v {
				float4 vertex : POSITION;
				float3 normal: NORMAL;
			};

			struct v2f{
				float4 position:SV_POSITION;
				float3 worldNormalDir:COLOR0;
			};

			v2f vert(a2v v){
				v2f f;
				f.position = UnityObjectToClipPos(v.vertex);
				f.worldNormalDir = mul(v.normal,(float3x3) unity_WorldToObject);
				return f;
			};


			fixed4 frag(v2f f):SV_TARGET{
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;
				fixed3 normalDir = normalize(f.worldNormalDir);
				fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				//半兰伯特漫反射  值范围0-1
				fixed3 halfLambert = dot(normalDir,lightDir)*0.5+0.5;	
				fixed3 diffuse = _LightColor0.rgb * halfLambert;
				fixed3 resultColor = diffuse+ambient;

				return fixed4(resultColor,1);
			};
		
			ENDCG
		}
	}
	FallBack "VertexLit"
}