// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Joker/Blend"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_SecondTex("Texture", 2D) = "white" {}
		_BlendTex("Blend",2D) = "white" {}
		_xxx("_xxx", Range(0,1)) = 0
		_yyy("_yyy", Range(0,1)) = 0
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
			#pragma multi_compile_fog
			#include "UnityCG.cginc"

			struct a2v
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv[3] : TEXCOORD0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _SecondTex;
			float4 _SecondTex_ST;
			sampler2D _BlendTex;
			float4 _BlendTex_ST;
			float _xxx;
			float _yyy;

			v2f vert (a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv[0] = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv[1] = TRANSFORM_TEX(v.uv, _SecondTex);
				o.uv[2] = TRANSFORM_TEX(v.uv, _BlendTex);
//				o.uv[2].x=_xxx;
//				o.uv[2].y=_yyy;
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 tex0 = tex2D(_MainTex, i.uv[0]);
				fixed4 tex1 = tex2D(_SecondTex, i.uv[1]);
				fixed4 blend = tex2D(_BlendTex, i.uv[2]);				

				fixed4 col = lerp(tex0,tex1, blend.a);

				return col;
			}
			ENDCG
		}
	}
}