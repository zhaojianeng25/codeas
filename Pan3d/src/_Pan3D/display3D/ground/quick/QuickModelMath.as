package _Pan3D.display3D.ground.quick
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import PanV2.ConfigV2;
	import PanV2.TextureCreate;
	
	import _Pan3D.base.ObjData;
	import _Pan3D.display3D.Display3DMaterialSprite;
	import _Pan3D.display3D.ground.GroundDisplaySprite;
	import _Pan3D.display3D.ground.GroundEditorSprite;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.texture.TextureManager;
	
	import _me.Scene_data;
	
	import materials.MaterialTree;
	
	import terrain.GroundData;
	
	public class QuickModelMath
	{
		private static var instance:QuickModelMath;
		private static var changeLodItem:Vector.<GroundDisplaySprite>;
		private  var quickSprite:Display3DMaterialSprite

		public function QuickModelMath()
		{
			this.quickSprite=new Display3DMaterialSprite(Scene_data.context3D);
			this.quickSprite.objData=new ObjData();
		}
		public function setmaterial(value:MaterialTree):void
		{
			Program3DManager.getInstance().regMaterial(value);
			this.quickSprite.material=value;
		}
		public function getmaterial():MaterialTree
		{
			return this.quickSprite.material;
		}
		public static function getInstance():QuickModelMath
		{
			if(!instance){
				instance=new QuickModelMath()
			}
			return instance;
		}
		public function changeLodUp(arr:*):void
		{
			
		}
		public  var brushSize:int = 10;//笔刷大小
		public  var brushPow:Number = 0.2;//笔刷力度
		public  var brushBluer:Number = 0.5;//笔刷力度
        public function upData($ground:GroundDisplaySprite):void
		{
			if(true){
				this.useMaterialQuick($ground)
			}else{
				var Area_Size:Number=GroundData.cellScale*GroundData.terrainMidu*4
				var _context3D:Context3D=Scene_data.context3D
				Program3DManager.getInstance().registe(QuickAndLightShader.QUICK_AND_LIGHT_SHADER,QuickAndLightShader)
				_context3D.setProgram(Program3DManager.getInstance().getProgram(QuickAndLightShader.QUICK_AND_LIGHT_SHADER))

				_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8,$ground.posMatrix, true);
				_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([Area_Size,Area_Size,0,0])); //法线
				

				_context3D.setVertexBufferAt(0, $ground.baseGroundObjData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context3D.setVertexBufferAt(1, $ground.baseGroundObjData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);

				if($ground.lightMapTexture){
					_context3D.setTextureAt(1,$ground.lightMapTexture);
				}else{
					_context3D.setTextureAt(1, TextureManager.getInstance().defaultLightTextVo.texture);
				}
				_context3D.setTextureAt(0,$ground.quickTexture);
				_context3D.drawTriangles($ground.baseGroundObjData.indexBuffer, 0, -1);
				_context3D.setVertexBufferAt(0, null);
				_context3D.setVertexBufferAt(1, null);
				_context3D.setTextureAt(0,null);
				_context3D.setTextureAt(1,null);

			}

		}
		private function useMaterialQuick($ground:GroundDisplaySprite):void
		{
			this.quickSprite.objData.vertexBuffer=$ground.baseGroundObjData.vertexBuffer;
			this.quickSprite.objData.uvBuffer=$ground.baseGroundObjData.uvBuffer;
			this.quickSprite.objData.lightUvsBuffer=$ground.baseGroundObjData.uvBuffer;
			this.quickSprite.objData.indexBuffer=$ground.baseGroundObjData.indexBuffer;
			this.quickSprite.lightMapTexture=$ground.lightMapTexture;
			this.quickSprite.x=$ground.x;
			this.quickSprite.y=$ground.y;
			this.quickSprite.z=$ground.z;
			for(var i:int;i<this.quickSprite.material.texList.length;i++){
				if(this.quickSprite.material.texList[i].isMain){
					this.quickSprite.material.texList[i].texture=$ground.quickTexture;
				}
			}
			this.quickSprite.update();
		}
		public function changeQuickTextureLod($ground:GroundDisplaySprite):void
		{
			if(!$ground.quickBitmapData){
				return 
			}
			if($ground.quickTexture){
				$ground.quickTexture.dispose();
			}
			
			var $camPos:Vector3D=new Vector3D();
			$camPos.x=Scene_data.cam3D.x;
			$camPos.y=Scene_data.cam3D.y;
			$camPos.z=Scene_data.cam3D.z;
			
		
			var $w:Number=GroundData.terrainMidu*GroundData.cellScale*4;
			var d:Number=(Vector3D.distance(new Vector3D($ground.x+$w/2,$ground.y,$ground.z+$w/2),$camPos));
				
			var kk:uint=10-Math.min(int(d/600),10);
			kk=Math.max(2,Math.min(kk,10));

			if(true){
				$ground.quickTexture=TextureCreate.getInstance().bitmapToMinTexture($ground.quickBitmapData,$ground.quickBitmapData.width,$ground.quickBitmapData.height)
			}else{
				$ground.quickTexture=TextureCreate.getInstance().bitmapToMinTexture($ground.quickBitmapData,Math.pow(2,kk),Math.pow(2,kk));
			}
			
		}
		public function scanQuickTexture($ground:GroundDisplaySprite):void
		{
			
			if(!$ground.quickBitmapData||$ground.quickBitmapData.width!=GroundData.quickScanSize){
				trace(GroundData.quickScanSize)
				$ground.quickBitmapData=new BitmapData(GroundData.quickScanSize,GroundData.quickScanSize,false,0xff0000);
			}
		
			var _context3D:Context3D=Scene_data.context3D
			_context3D.setCulling(Context3DTriangleFace.NONE);
			_context3D.configureBackBuffer($ground.quickBitmapData.width, $ground.quickBitmapData.height,0, true);
			_context3D.clear(1,0,0,1);
			_context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			drawToBmp($ground as GroundEditorSprite);
			_context3D.drawToBitmapData($ground.quickBitmapData);

			ConfigV2.getInstance().configAntiAlias(Scene_data.antiAlias,Scene_data.stage3DVO.width,Scene_data.stage3DVO.height)
			changeQuickTextureLod($ground)

		}
		private function drawToBmp($ground:GroundEditorSprite):void
		{
			var _context3D:Context3D=Scene_data.context3D

			var $cellAre:Number=GroundData.terrainMidu*GroundData.cellScale*4
			$cellAre=$cellAre/2
	
			var m0:Matrix3D=new Matrix3D
			m0.appendScale(1/$cellAre,1/$cellAre,1/1500)   //1%200
			var m2:Matrix3D=new Matrix3D
			m2.appendRotation(90,Vector3D.X_AXIS)

			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, m0, true);

			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, m2, true);
			
			var m8:Matrix3D=new Matrix3D
			m8.appendTranslation(-$cellAre,+500,-$cellAre)
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8,m8, true);
			
			
			$ground.quickScanToBmp()
			
			
			
		}
	}
}