package PanV2
{
	import com.adobe.AGALMiniAssembler;
	
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
	
	import PanV2.xyzmove.MathUint;
	
	import _Pan3D.base.Camera3D;
	import _Pan3D.core.MathCore;
	import _Pan3D.display3D.Display3DSprite;
	
	import _me.Scene_data;
	


	public class SelectModelMath
	{
		public function SelectModelMath()
		{
		}
		private static var _program:Program3D;
		protected static function initProgram($context3D:Context3D):void
		{
			_program = $context3D.createProgram();
			var assembler:AGALMiniAssembler = new AGALMiniAssembler;
			_program.upload(
				assembler.assemble(Context3DProgramType.VERTEX,
	
					"m44 vt0, va0, vc8 \n"+
					"m44 vt0, vt0, vc4 \n"+
					"m44 vo, vt0, vc0 " 
					,2
				),
				assembler.assemble(Context3DProgramType.FRAGMENT,
					"mov fo, fc0"
					,2
				)
			);
			
		}
		protected static function resetVa() : void {
			var _context3D:Context3D=Scene_data.context3D
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);
			_context3D.setVertexBufferAt(2, null);
			_context3D.setVertexBufferAt(3, null);
			_context3D.setVertexBufferAt(4, null);
			_context3D.setVertexBufferAt(5, null);
			_context3D.setVertexBufferAt(6, null);
			
			_context3D.setTextureAt(0,null)
			_context3D.setTextureAt(1,null)
			_context3D.setTextureAt(2,null)
			_context3D.setTextureAt(3,null)
			_context3D.setTextureAt(4,null)
			_context3D.setTextureAt(5,null)
			_context3D.setTextureAt(6,null)
			
		}

		public static function  scanHitModel($arr:Vector.<Display3DSprite>,$mouse:Point):uint
		{
			resetVa();
			var $stageRct:Rectangle=new Rectangle(Scene_data.stage3DVO.x,Scene_data.stage3DVO.y,Scene_data.stage3DVO.width,Scene_data.stage3DVO.height);
			var $hitPos:Vector3D=MathUint.mathDisplay2Dto3DWorldPos($stageRct,new Point(Scene_data.stage.mouseX,Scene_data.stage.mouseY),500)
			var $hitMatr:Matrix3D=MathUint.lookAt($hitPos,Scene_data.cam3D.clone())
			if(Scene_data.topViewMatrx3D){
			
				 $hitMatr.identity()
				 var tx:Number=(Scene_data.stage.mouseX-$stageRct.x);
				 var tz:Number=(Scene_data.stage.mouseY-$stageRct.y);
				 tx= tx-($stageRct.width/2)
				 tz= tz-($stageRct.height/2)
				 var $scale:Number=1/Scene_data.cam3D.y*(Scene_data.sceneViewHW)
				 tx= tx/$scale
				 tz= tz/$scale
				 var $Pcam:Vector3D=new Vector3D(Scene_data.cam3D.x+tx,Scene_data.cam3D.y, Scene_data.cam3D.z-tz)
				 $hitMatr.identity();
				 $hitMatr.prependRotation(-90, Vector3D.X_AXIS);
				 $hitMatr.prependTranslation(-$Pcam.x, -$Pcam.y,-$Pcam.z);

			}	
			var $viewMatrx3D:Matrix3D=new Matrix3D
			$viewMatrx3D.appendScale(0.1,0.1,0.0001)
			var bmp:BitmapData=new BitmapData(50,50,false,0xff0000);
			var $context3D:Context3D=Scene_data.context3D
			initProgram($context3D)
			$context3D.configureBackBuffer(bmp.width, bmp.height,0, true);
			$context3D.clear(1,1,1,1);
			$context3D.setDepthTest(true,Context3DCompareMode.LESS);
			$context3D.setCulling(Context3DTriangleFace.NONE);
			$context3D.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ZERO);
			
			$context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, $viewMatrx3D, true);
			$context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, $hitMatr, true);
			$context3D.setProgram(_program)
			for(var i:uint=0;i<$arr.length;i++)
			{
				var color:Vector3D=new Vector3D(0,0,0,1);
				color.x=i%0xff
				color.y=int(i/0xff)%0xff
				color.scaleBy(1/0xff)
				if($arr[i].objData&&$arr[i].objData.indexBuffer&&$arr[i].visible){
					
					var $m:Matrix3D= $arr[i].posMatrix.clone()
					$m.appendScale(1,1,1)
					$context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, $m, true);
					$context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,Vector.<Number>( [color.x,color.y,0,1]));   
					$context3D.setVertexBufferAt(0, $arr[i].objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
					$context3D.drawTriangles($arr[i].objData.indexBuffer, 0, -1);
				}
			}
			$context3D.setVertexBufferAt(0, null);
			$context3D.drawToBitmapData(bmp);
			$context3D.configureBackBuffer(Scene_data.stage3DVO.width, Scene_data.stage3DVO.height,4, true);
			var tomouse:Point=new Point(bmp.width/2,bmp.height/2)
			var eeee:Vector3D=	MathCore.hexToArgb(bmp.getPixel32(tomouse.x,tomouse.y))
				
			if(ShowMc){
				ShowMc.setBitMapData(bmp)
			}
			
	        return eeee.x+eeee.y*0xff

		
		}
		
		
		public static var ShowMc:Object
		
	
	}
}