// Upgrade NOTE: upgraded instancing buffer 'Props' to new syntax.

Shader "CookbookShaders/Chapter02/PhotoshopLevels" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}  
      
	    //Add the Input Levels Values  
	    _inBlack ("Input Black", Range(0, 255)) = 0  
	    _inGamma ("Input Gamma", Range(0, 2)) = 1.61  
	    _inWhite ("Input White", Range(0, 255)) = 255  
	      
	    //Add the Output Levels  
	    _outWhite ("Output White", Range(0, 255)) = 255  
	    _outBlack ("Output Black", Range(0, 255)) = 0  
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		float _inBlack;
		float _inGamma;
		float _inWhite;
		float _outWhite;
		float _outBlack;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		float GetPixelLevel(float pixelColor)  
		{  
		    float pixelResult;  
		    pixelResult = (pixelColor * 255.0);  
		    pixelResult = max(0, pixelResult - _inBlack);  
		    pixelResult = saturate(pow(pixelResult / (_inWhite - _inBlack), _inGamma));  
		    pixelResult = (pixelResult * (_outWhite - _outBlack) + _outBlack)/255.0;      
		    return pixelResult;  
		}  

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);

			float outRPixel  = GetPixelLevel(c.r);  			  
			float outGPixel = GetPixelLevel(c.g);  			  
			float outBPixel = GetPixelLevel(c.b);  
			o.Albedo = float3(outRPixel,outGPixel,outBPixel); 
//			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
