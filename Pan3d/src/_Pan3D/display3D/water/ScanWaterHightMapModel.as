package _Pan3D.display3D.water
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.Program3D;
	import flash.display3D.textures.RectangleTexture;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import PanV2.TextureCreate;
	
	import _Pan3D.base.ObjData;
	import _Pan3D.display3D.Display3DSprite;
	import _Pan3D.display3D.ground.GroundDisplaySprite;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.scene.SceneContext;
	
	import _me.Scene_data;
	

	public class ScanWaterHightMapModel
	{
		private static var instance:ScanWaterHightMapModel;
		public function ScanWaterHightMapModel()
		{
		}
		public static function getInstance():ScanWaterHightMapModel{
			if(!instance){
				instance = new ScanWaterHightMapModel();
			}
			return instance;
		}
		
		private var _colorTexture:RectangleTexture
		private var _dephTexture:RectangleTexture
		public  function scanHightBitmap($pos:Vector3D,$rect:Rectangle,$textureSize:Number,$arr:Vector.<Display3DSprite>):BitmapData
		{
			var $context3D:Context3D=Scene_data.context3D
			
			var $bmpW:uint=Math.max(50,int($textureSize*$rect.width/100))
			var $bmpH:uint=Math.max(50,int($textureSize*$rect.height/100))
			$bmpW=$textureSize
			$bmpH=$textureSize
			var bmp:BitmapData=	new BitmapData($bmpW,$bmpH,false,Math.random()*0xffffff)
			
				
			if(_colorTexture){
				_colorTexture.dispose()
			}
			if(_dephTexture){
				_dephTexture.dispose()
			}
			_colorTexture=TextureCreate.getInstance().bitmapToRectangleTexture(new BitmapData($bmpW,$bmpH,true,0xffff0000*Math.random()))
			_dephTexture=TextureCreate.getInstance().bitmapToRectangleTexture(new BitmapData($bmpW,$bmpH,false,0xff006c00))
			
			
			if(false){
				return scaneGroundColor($arr,$rect,$pos,$textureSize)
			}
				
				
			$context3D.configureBackBuffer(bmp.width, bmp.height,0, true);
			$context3D.clear(1,1,1,1)

			Program3DManager.getInstance().registe(ScanWaterHightMapShader.SCAN_WATER_HIGHT_MAP_SHADER,ScanWaterHightMapShader)
			var program:Program3D=Program3DManager.getInstance().getProgram(ScanWaterHightMapShader.SCAN_WATER_HIGHT_MAP_SHADER)
			
			var viewMatrx3D:Matrix3D=new Matrix3D
			viewMatrx3D.appendScale(1/$rect.width,-1/$rect.height,1/$pos.w)
			
			$context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, viewMatrx3D, true);
			
			
			var cameraMatrix:Matrix3D=new Matrix3D
			cameraMatrix.prependTranslation(-$pos.x, -($pos.y),-$pos.z);
			cameraMatrix.appendRotation(-90, Vector3D.X_AXIS);
			
			
			$context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, cameraMatrix, true);
			$context3D.setDepthTest(true,Context3DCompareMode.LESS);
			$context3D.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ZERO);
			$context3D.setCulling(Context3DTriangleFace.NONE);
			
			
			$context3D.setProgram(program)
			for(var i:uint=0;i<$arr.length;i++)
			{
				if($arr[i] as GroundDisplaySprite ){
					upDisply(GroundDisplaySprite($arr[i]).baseGroundObjData,$arr[i].posMatrix)
				}else{
					upDisply($arr[i].objData,$arr[i].posMatrix)
				}
			}

			$context3D.drawToBitmapData(bmp)
			$context3D.configureBackBuffer(Scene_data.stage3DVO.width, Scene_data.stage3DVO.height,0, true);
			return bmp
		}
		
		private function scaneGroundColor($arr:Vector.<Display3DSprite>,$rect:Rectangle,$pos:Vector3D,$textureSize:Number):BitmapData
		{
			
			var $bmpW:uint=Math.max(50,int($textureSize*$rect.width/100))
			var $bmpH:uint=Math.max(50,int($textureSize*$rect.height/100))
				
			$bmpW=$textureSize
			$bmpH=$textureSize
			var $bmp:BitmapData=	new BitmapData($bmpW,$bmpH,true,Math.random()*0xffffff)
				
			var $context3D:Context3D=Scene_data.context3D
			$context3D.configureBackBuffer($bmp.width, $bmp.height,0, true);
			$context3D.setRenderToTexture(_colorTexture)
			$context3D.clear(0,0,0,0)
			var viewMatrx3D:Matrix3D=new Matrix3D
			viewMatrx3D.appendScale(1/$rect.width,-1/$rect.height,0.1/$pos.w)
			$context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, viewMatrx3D, true);
			
			var cameraMatrix:Matrix3D=new Matrix3D
			cameraMatrix.prependTranslation(-$pos.x, -($pos.y+50),-$pos.z);
			cameraMatrix.appendRotation(-90, Vector3D.X_AXIS);
			$context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, cameraMatrix, true);

			
			$context3D.setDepthTest(true,Context3DCompareMode.LESS);
			$context3D.setCulling(Context3DTriangleFace.NONE);
			$context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			
			SceneContext.sceneRender.groundlevel.updata();
			SceneContext.sceneRender.modelLevel.updata()
			//SceneContext.sceneRender.grassLevel.updata()
			$context3D.present()
				
				
				
				
			viewMatrx3D.identity()
			viewMatrx3D.appendScale(1/$rect.width,-1/$rect.height,1/$pos.w)
			$context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, viewMatrx3D, true);
			
			cameraMatrix.identity()
			cameraMatrix.prependTranslation(-$pos.x, -($pos.y),-$pos.z);
			cameraMatrix.appendRotation(-90, Vector3D.X_AXIS);
			$context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, cameraMatrix, true);
				
			Program3DManager.getInstance().registe(ScanWaterHightMapShader.SCAN_WATER_HIGHT_MAP_SHADER,ScanWaterHightMapShader)
			var program:Program3D=Program3DManager.getInstance().getProgram(ScanWaterHightMapShader.SCAN_WATER_HIGHT_MAP_SHADER)
			$context3D.setRenderToTexture(_dephTexture)
			$context3D.setProgram(program)
			$context3D.setDepthTest(true,Context3DCompareMode.LESS);
			$context3D.setCulling(Context3DTriangleFace.NONE);
			$context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			for(var i:uint=0;i<$arr.length;i++)
			{
				if($arr[i] as GroundDisplaySprite ){
					upDisply(GroundDisplaySprite($arr[i]).baseGroundObjData,$arr[i].posMatrix)
				}else{
					upDisply($arr[i].objData,$arr[i].posMatrix)
				}
			}
			$context3D.present()
			
			$bmp=WaterDephtAndColorModel.TextureAdd(_colorTexture,_dephTexture,$bmpW,$bmpH)
			

			$context3D.configureBackBuffer(Scene_data.stage3DVO.width, Scene_data.stage3DVO.height,0, true);
			return $bmp
		}
		private function upDisply($objData:ObjData,$posMatrix:Matrix3D):void
		{
			
			var _context:Context3D=Scene_data.context3D
				
				
			if($objData&&$objData.indexBuffer){
				setVc()
				setVa()
				resetVa()
			}
				
			function setVa() : void {
				_context.setVertexBufferAt(0, $objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context.drawTriangles($objData.indexBuffer, 0, -1);
				
			}
			
		   function resetVa() : void {
				_context.setVertexBufferAt(0, null);

			}
			
			function setVc() : void {
	
				_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, $posMatrix, true);
				
				_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([0.6,0.6,0.6,1])); //专门用来存树的通道的
			}
		}
	}
}