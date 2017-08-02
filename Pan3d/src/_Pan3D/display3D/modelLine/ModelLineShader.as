package _Pan3D.display3D.modelLine
{
	import _Pan3D.program.Shader3D;
	
	public class ModelLineShader extends Shader3D
	{
		public static var MODEL_LINE_SHADER:String = "ModelLineShader";
		public function ModelLineShader()
		{
			version = 2;
			
			vertex = 
				
				"m44 vt0,va0,vc8 \n"+
				"m44 vt0,vt0,vc4 \n"+
				"mov vi0, va1 \n"+
				//"mov vi0, va0 \n"+
				"m44 vo, vt0,vc0"
			
			fragment =
				//fwidth abs( ddx( v ) ) + abs( ddy( v ) );
				"ddx ft0,vi0\n"                                //ft0 = ddx( v0)
				+"abs ft0,ft0\n"                        //ft0 = abs(ft0)
				+"ddy ft1,vi0\n"                                //ft1 = ddy(v0)
				+"abs ft1,ft1\n"                        //ft1 = abs(ft1)
				+"add ft0,ft0,ft1\n"                //ft0 = ft0 + ft1
				
				//smoothstep( float3(0), fwidth( iTP ), iTP );
				//http://en.wikipedia.org/wiki/Smoothstep
				// Scale, bias and saturate x to 0..1 range
				//x = sat((x - edge0)/(edge1 - edge0));
				// Evaluate polynomial
				//return x*x*(3 - 2*x);
				
				// edge0 = 0
				// x = sat(x/edge1);
				+"div ft0,v0,ft0\n"                        //ft0 = v0 / ft0
				+"sat ft0,ft0\n"                        //ft0 = sat(ft0)
				+"mul ft2,fc0.yyy,ft0\n"        //ft2 = 2*ft0               
				+"sub ft2,fc0.zzz,ft2\n"        //ft2 = 3 - ft2
				+"mul ft2,ft0,ft2\n"                //ft2 = ft0 * ft2
				+"mul ft0,ft0,ft2\n"                //ft0 = ft0 * ft2
				
				//float4( 1 - min(min(a3.x, a3.y), a3.z).xxx, 0 ) * 0.5;
				+"min ft0.x,ft0.x,ft0.y\n"
				+"min ft0.x,ft0.x,ft0.z\n"
				+"sub ft0.x,fc0.x,ft0.x\n"
				+"mul ft0.x,ft0.x,fc0.z\n"
				+"mov ft2,ft0.xxxx\n"
				+"sat ft2,ft2 \n"
				+"mul ft2,ft2,fc1 \n"
				+"mov oc,ft2"
		}
	}
}