package xyz.base
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Program3D;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import xyz.draw.TooMathMoveUint;
	import xyz.draw.TooUtilDisplay;

	public class TooSelectModel
	{
		public function TooSelectModel()
		{
		}
		private static var _program:Program3D;
		protected static function initProgram($context3D:Context3D):void
		{
			if(_program){
				return 
			}
			
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
		
		/**
		 * 2D坐标转换成3D坐标，当然要给一个相离镜头的深度
		 * @param $stage3DVO 为stage3d的坐标信息
		 * @param $point  2d位置是场景的坐标，
		 * @param $depht  默认深度为500,
		 * @return  3D的坐标
		 * 
		 */
		public static function mathDisplay2Dto3DWorldPos($stage3DVO:Rectangle,$point:Point,$depht:Number=500):Vector3D
		{
			
			var cameraMatrixInvert:Matrix3D=TooMathMoveUint.cameraMatrix.clone()
			var viewMatrx3DInvert:Matrix3D=TooMathMoveUint.viewMatrx3D.clone()
			cameraMatrixInvert.invert();
			viewMatrx3DInvert.invert();
			var a:Vector3D=new Vector3D()	
			a.x=$point.x-$stage3DVO.x
			a.y=$point.y-$stage3DVO.y
			
			a.x=a.x*2/$stage3DVO.width-1
			a.y=1-a.y*2/$stage3DVO.height
			a.w=$depht
			a.x = a.x*a.w
			a.y = a.y*a.w
			a=viewMatrx3DInvert.transformVector(a)
			a.z=$depht
			a=cameraMatrixInvert.transformVector(a)
			
			return a;
			
		}
		public static function lookAt(a:Vector3D,b:Vector3D):Matrix3D
		{
			var m:Matrix3D=new Matrix3D;
			var ma:Matrix3D=new Matrix3D
			var mb:Matrix3D=new Matrix3D
			ma.pointAt(a.subtract(b),Vector3D.X_AXIS,Vector3D.Y_AXIS);
			mb.pointAt(new Vector3D(0,0,1),Vector3D.X_AXIS,Vector3D.Y_AXIS);
			ma.invert()
			ma.append(mb)
			ma.invert()
			m.append(ma)
			m.appendTranslation(b.x,b.y,b.z)
			m.invert()
			return m;
			
		}
		public static function  scanHitModel($arr:Vector.<TooUtilDisplay>,$mouse:Point,$face:String):uint
		{

			var stage3DVO:Rectangle=TooMathMoveUint.stage3Drec
			
			var $stageRct:Rectangle=new Rectangle(stage3DVO.x,stage3DVO.y,stage3DVO.width,stage3DVO.height);
			var $hitPos:Vector3D=mathDisplay2Dto3DWorldPos($stageRct,$mouse,500)
			var $hitMatr:Matrix3D=lookAt($hitPos,TooMathMoveUint.camPositon.clone())
			var $viewMatrx3D:Matrix3D=new Matrix3D
			$viewMatrx3D.appendScale(0.1,0.1,0.0001)
			var bmp:BitmapData=new BitmapData(50,50,false,0xff0000);
			var $context3D:Context3D=TooMathMoveUint.context3D
			initProgram($context3D)
			$context3D.configureBackBuffer(bmp.width, bmp.height,0, true);
			$context3D.clear(1,1,1,1);
			$context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			$context3D.setDepthTest(true,Context3DCompareMode.LESS);
			$context3D.setCulling($face);
			$context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, $viewMatrx3D, true);
			$context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, $hitMatr, true);
			$context3D.setProgram(_program)
			for(var i:uint=0;i<$arr.length;i++)
			{
				var color:Vector3D=new Vector3D(0,0,0,1);
				color.x=i%0xff
				color.y=int(i/0xff)%0xff
				color.scaleBy(1/0xff)

				if($arr[i].objData&&$arr[i].objData.indexBuffer){
					$context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, $arr[i].posMatrix, true);
					$context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,Vector.<Number>( [color.x,color.y,0,1]));   
					$context3D.setVertexBufferAt(0, $arr[i].objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
					$context3D.drawTriangles($arr[i].objData.indexBuffer, 0, -1);
				}
			}
			$context3D.setVertexBufferAt(0, null);
			$context3D.drawToBitmapData(bmp);
			$context3D.configureBackBuffer(stage3DVO.width, stage3DVO.height,4, true);
			var tomouse:Point=new Point(bmp.width/2,bmp.height/2)
			var eeee:Vector3D=	hexToArgb(bmp.getPixel32(tomouse.x,tomouse.y))
			
			if(ShowMc){
				ShowMc.setBitMapData(bmp)
			}
			
			return eeee.x+eeee.y*0xff
			
			
		}
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
		
		public static var ShowMc:Object
		
		
	}
}


