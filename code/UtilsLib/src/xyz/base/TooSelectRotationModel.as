package xyz.base
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Program3D;
	import flash.display3D.textures.Texture;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import xyz.draw.TooMathMoveUint;
	import xyz.draw.TooUtilDisplay;

	public class TooSelectRotationModel
	{
		public function TooSelectRotationModel()
		{
		}
		private static var _program:Program3D;
		protected static function initProgram($context3D:Context3D):void
		{
			_program = $context3D.createProgram();
			var assembler:TooAGALMiniAssembler = new TooAGALMiniAssembler;
			_program.upload(
				assembler.assemble(Context3DProgramType.VERTEX,
					
					"m44 vt0, va0, vc8 \n"+
					"m44 vt0, vt0, vc4 \n"+
					"m44 vo, vt0, vc0 " 
					,TooMathMoveUint.agalLevel
				),
				assembler.assemble(Context3DProgramType.FRAGMENT,
					"mov fo, fc0"
					,TooMathMoveUint.agalLevel
				)
			);
			
		}
		private static var _tempTexture:Texture
		public static function  scanHitModel($arr:Vector.<TooUtilDisplay>,$mouse:Point,$face:String):uint
		{
			var $context3D:Context3D=TooMathMoveUint.context3D
			
			if(TooMathMoveUint.agalLevel==1){   //因为两个的渲染镜头不一样，所以只能分开处理。
				return TooSelectModel.scanHitModel($arr,$mouse,$face)
			}
			if($mouse.x<TooMathMoveUint.stage3Drec.x||$mouse.y<TooMathMoveUint.stage3Drec.y){
				return 99999
			}
			if($mouse.x>(TooMathMoveUint.stage3Drec.x+TooMathMoveUint.stage3Drec.width)){
				return 99999
			}
			if($mouse.y>(TooMathMoveUint.stage3Drec.y+TooMathMoveUint.stage3Drec.height)){
				return 99999
			}
			var bmp:BitmapData=new BitmapData(TooMathMoveUint.stage3Drec.width,TooMathMoveUint.stage3Drec.height,false,0xff0000);
	
			initProgram($context3D)
			
			
			$context3D.setVertexBufferAt(0, null);
			$context3D.setVertexBufferAt(1, null);
			$context3D.setVertexBufferAt(2, null);
			$context3D.setTextureAt(0, null);
			$context3D.setTextureAt(1, null);
			$context3D.setTextureAt(2, null);
			
			$context3D.configureBackBuffer(TooMathMoveUint.stage3Drec.width, TooMathMoveUint.stage3Drec.height,0, true);
			$context3D.clear(1,1,1,1);
			$context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			$context3D.setDepthTest(true,Context3DCompareMode.LESS);
			$context3D.setCulling($face);
			$context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, TooMathMoveUint.viewMatrx3D, true);
			$context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, TooMathMoveUint.cameraMatrix, true);
			$context3D.setProgram(_program)
			for(var i:uint=0;i<$arr.length;i++)
			{
				var color:Vector3D=new Vector3D(0,0,0,1);
				color.x=i%0xff
				color.y=int(i/0xff)%0xff
				color.scaleBy(1/0xff)
				
				$context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, $arr[i].posMatrix, true);
				$context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,Vector.<Number>( [color.x,color.y,0,1]));   
				$context3D.setVertexBufferAt(0, $arr[i].objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				
				$context3D.drawTriangles($arr[i].objData.indexBuffer, 0, -1);
			}
			$context3D.setVertexBufferAt(0, null);
			$context3D.drawToBitmapData(bmp);
			$context3D.configureBackBuffer(TooMathMoveUint.stage3Drec.width, TooMathMoveUint.stage3Drec.height,4, true);

			
			var tomouse:Point=new Point($mouse.x-TooMathMoveUint.stage3Drec.x,$mouse.y-TooMathMoveUint.stage3Drec.y)
			var eeee:Vector3D=	hexToArgb(bmp.getPixel32(tomouse.x,tomouse.y))
				
			if(ShowMc){
				ShowMc.setBitMapData(bmp)
			}

			return eeee.x+eeee.y*0xff
			
		

		}
		

        public static var ShowMc:Object
		public static function hexToArgb(expColor:uint,is32:Boolean=true,color:Vector3D = null):Vector3D
		{
			if(!color)
			{
				color = new Vector3D();
			}
			color.w =is32? (expColor>>24) & 0xFF:0;
			color.x= (expColor>>16) & 0xFF;
			color.y = (expColor>>8) & 0xFF;
			color.z = (expColor) & 0xFF;
			return color;
		}
		
	}
}