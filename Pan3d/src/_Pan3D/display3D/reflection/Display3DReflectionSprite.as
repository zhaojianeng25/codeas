package _Pan3D.display3D.reflection
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DStencilAction;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import PanV2.xyzmove.MathUint;
	
	import _Pan3D.base.Camera3D;
	import _Pan3D.base.ObjData;
	import _Pan3D.display3D.Display3DMaterialSprite;
	import _Pan3D.display3D.ground.GroundEditorSprite;
	import _Pan3D.display3D.ground.ModelHasDepthSprite;
	import _Pan3D.display3D.model.Display3DModelSprite;
	import _Pan3D.display3D.modelLine.ModelBoxSprite;
	import _Pan3D.program.Program3DManager;
	import _Pan3D.scene.SceneContext;
	import _Pan3D.texture.TextureManager;
	import _Pan3D.vo.texture.TextureVo;
	
	import _me.Scene_data;
	
	import light.ReflectionTextureVo;
	
	public class Display3DReflectionSprite extends Display3DModelSprite
	{

		private var _reflectionTextureVo:ReflectionTextureVo

		public function Display3DReflectionSprite(context:Context3D)
		{
			super(context);
			Program3DManager.getInstance().registe(Display3DReflectionShader.DISPLAY3D_REFLECTION_SHADER,Display3DReflectionShader)
			program=Program3DManager.getInstance().getProgram(Display3DReflectionShader.DISPLAY3D_REFLECTION_SHADER)
				
				
			Program3DManager.getInstance().registe(ZeflectionFeShader.REFLECTIONFE_SHADER,ZeflectionFeShader)
			Program3DManager.getInstance().registe(ZeflectionFeKillShader.REFLECTIONFE_KILL_SHADER,ZeflectionFeKillShader)
			Program3DManager.getInstance().registe(FaflectionFeKillShader.FA_FLECTIONFE_KILL_SHADER,FaflectionFeKillShader)
				

			addLineRound()
	
		}

		public function get reflectionTextureVo():ReflectionTextureVo
		{
			return _reflectionTextureVo;
		}

		public function set reflectionTextureVo(value:ReflectionTextureVo):void
		{
			_reflectionTextureVo = value;
		}

		override public function updatePosMatrix():void{
			posMatrix.identity();
			posMatrix.prependTranslation(this._absoluteX, this._absoluteY, this._absoluteZ);
			if(_modelBoxSprite){
				_modelBoxSprite.posMatrix.identity()
				_modelBoxSprite.posMatrix.prependTranslation(this._absoluteX, this._absoluteY, this._absoluteZ);
				_modelBoxSprite.posMatrix.prependScale(_scale_x,_scale_y,_scale_z);
			}

		}
		
		private var _modelBoxSprite:ModelBoxSprite
		private function addLineRound():void
		{
			_modelBoxSprite=new ModelBoxSprite(this._context3D)
			_modelBoxSprite.clear()
			_modelBoxSprite.makeBoxLineObjData(new Vector3D(-10,-10,-10),new Vector3D(10,10,10))
			
		}
		
		
		

		override public function update() : void {
			
			if(!_visible||!ModelHasDepthSprite.editSee){
				return 
			}
				
			if (_objData && _objData.indexBuffer&&_visible) {
				_context.setProgram(this.program);
				setVc();
				setVa();
				resetVa();
			}
			if(_modelBoxSprite&&_select){
				_modelBoxSprite.update()
			}
		}
		override protected function setVa() : void {
			_context.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(1, _objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			_context.drawTriangles(_objData.indexBuffer, 0, -1);
		}
		
		override  protected function resetVa() : void {
			_context3D.setVertexBufferAt(0, null);
			_context3D.setVertexBufferAt(1, null);
			_context3D.setVertexBufferAt(2, null);
			_context3D.setTextureAt(0, null);
			_context3D.setTextureAt(1, null);
			
		}
		
		override  protected function setVc() : void {
			this.updateMatrix();
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, posMatrix, true);
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([1,0,0,1])); //专门用来存树的通道的
		}
		public function scanReflection():void
		{
			if(_reflectionTextureVo){
				scanZeReflection()
				scanFaReflection();
			}
		}
         //折射
		private function scanZeReflection():void
		{

			_context3D.setRenderToTexture(_reflectionTextureVo.ZeTexture,true,0)
			_context3D.setDepthTest(true,Context3DCompareMode.LESS);
			_context3D.setCulling(Context3DTriangleFace.NONE);
			_context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			_context3D.clear(0,0,0,1,1,0)
				
				
			_context3D.setStencilReferenceValue(1);
			_context3D.setStencilActions( Context3DTriangleFace.FRONT_AND_BACK, Context3DCompareMode.ALWAYS, Context3DStencilAction.SET );
			_context3D.setCulling(Context3DTriangleFace.NONE);
			_context3D.setDepthTest(false,Context3DCompareMode.ALWAYS);
			SceneContext.sceneRender.waterLevel.upDataScanFa()
				
	
			_context3D.setStencilActions( Context3DTriangleFace.FRONT_AND_BACK, Context3DCompareMode.EQUAL, Context3DStencilAction.KEEP );
				
			_context3D.setCulling(Context3DTriangleFace.NONE);
			_context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			_context3D.setProgram(Program3DManager.getInstance().getProgram(ZeflectionFeShader.REFLECTIONFE_SHADER))
			for each(var $groundEditorSprite:GroundEditorSprite in SceneContext.sceneRender.groundlevel.groundItem)
			{
				if($groundEditorSprite.quickTexture){
					upDisply($groundEditorSprite.baseGroundObjData,$groundEditorSprite.posMatrix,$groundEditorSprite.quickTexture,$groundEditorSprite.lightMapTexture)
				}
			}
			_context3D.setProgram(Program3DManager.getInstance().getProgram(ZeflectionFeKillShader.REFLECTIONFE_KILL_SHADER))
			_context3D.setCulling(Context3DTriangleFace.BACK);

			for each(var $display3DModelSprite:Display3DModelSprite in SceneContext.sceneRender.modelLevel.modelItem)
			{
				if($display3DModelSprite as Display3DMaterialSprite){
					var $display3DMaterialSprite:Display3DMaterialSprite=Display3DMaterialSprite($display3DModelSprite)
			        if($display3DMaterialSprite.material&&$display3DMaterialSprite.lightMapTexture){
						var $fileUrl:String=$display3DMaterialSprite.material.getMainTexUrl()
						var display3dTextureVo:TextureVo=TextureManager.getInstance().getTextureByUrl(Scene_data.fileRoot+$fileUrl)
						if(display3dTextureVo){
							upDisply($display3DMaterialSprite.objData,$display3DMaterialSprite.posMatrix,display3dTextureVo.texture,$display3DMaterialSprite.lightMapTexture)
						}
					}
					
				}
			}
			resetVa()
			_context3D.setRenderToBackBuffer()

			_context3D.setStencilReferenceValue(0);
			_context3D.setStencilActions( Context3DTriangleFace.FRONT_AND_BACK, Context3DCompareMode.ALWAYS, Context3DStencilAction.KEEP );
			if(ShowMc){
				//ShowMc.setBitMapData(TextureToBmp.TextureToBitMapData(_reflectionTextureVo.ZeTexture,null,256,256))
			}
		

		}
		public static var ShowMc:Object
		private function upDisply($objData:ObjData,$posMatrix:Matrix3D,$texture:Texture,$lightTexture:Texture,$killNum:Number=0):void
		{
			if($objData&&$objData.indexBuffer&&$texture&&$lightTexture){
				_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, $posMatrix, true);
				_context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 12, Vector.<Number>([_x,_y,_z,1]));
				_context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 9, Vector.<Number>([5,5,5,$killNum]));
			
				_context3D.setVertexBufferAt(0, $objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				_context3D.setVertexBufferAt(1, $objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
				if($objData.lightUvsBuffer){
					_context3D.setVertexBufferAt(2, $objData.lightUvsBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
				}else{
					_context3D.setVertexBufferAt(2, $objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
				}
				
				_context3D.setTextureAt(0,$texture)
				_context3D.setTextureAt(1,$lightTexture)
				_context3D.drawTriangles($objData.indexBuffer, 0, -1);
				
			}
			
		}

		//反射
		private function scanFaReflection():void
		{
			if(!_reflectionTextureVo.camMatrix3D){
				_reflectionTextureVo.camMatrix3D=new Matrix3D
			}

			
			
			var $cam3d:Camera3D=new Camera3D;
			$cam3d.cameraMatrix=new Matrix3D;
			$cam3d.camera3dMatrix=new Matrix3D;
			$cam3d.x=Scene_data.cam3D.x
			$cam3d.y=this.y*2-Scene_data.cam3D.y
			$cam3d.z=Scene_data.cam3D.z

			$cam3d.rotationX=-Scene_data.cam3D.rotationX
			$cam3d.rotationY=Scene_data.cam3D.rotationY
			MathUint.MathCam($cam3d)

			_reflectionTextureVo.camMatrix3D=$cam3d.cameraMatrix.clone()
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, _reflectionTextureVo.camMatrix3D, true);
				
			_context3D.setRenderToTexture(_reflectionTextureVo.texture,true,0)
			_context3D.clear(0,0,0,1,1,0)
			_context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			
			
			_context3D.setStencilReferenceValue(1);
			_context3D.setStencilActions( Context3DTriangleFace.FRONT_AND_BACK, Context3DCompareMode.ALWAYS, Context3DStencilAction.SET );
			_context3D.setCulling(Context3DTriangleFace.NONE);
			_context3D.setDepthTest(false,Context3DCompareMode.ALWAYS);
			SceneContext.sceneRender.waterLevel.upDataScanFa()
			
			
			_context3D.setStencilActions( Context3DTriangleFace.FRONT_AND_BACK, Context3DCompareMode.EQUAL, Context3DStencilAction.KEEP );
			
			_context3D.setProgram(Program3DManager.getInstance().getProgram(FaflectionFeKillShader.FA_FLECTIONFE_KILL_SHADER))
			_context3D.setCulling(Context3DTriangleFace.NONE);
			_context3D.setDepthTest(true,Context3DCompareMode.LESS);
		
			for each(var $display3DModelSprite:Display3DModelSprite in SceneContext.sceneRender.modelLevel.modelItem)
			{
				if($display3DModelSprite as Display3DMaterialSprite){
					var $display3DMaterialSprite:Display3DMaterialSprite=Display3DMaterialSprite($display3DModelSprite)
					if($display3DMaterialSprite.material&&$display3DMaterialSprite.lightMapTexture){
						var $fileUrl:String=$display3DMaterialSprite.material.getMainTexUrl()
						var display3dTextureVo:TextureVo=TextureManager.getInstance().getTextureByUrl(Scene_data.fileRoot+$fileUrl)
						if(display3dTextureVo){
							
							var $killNum:Number
							if($display3DMaterialSprite.material.killNum){
								$killNum=$display3DMaterialSprite.material.killNum
							}else{
								$killNum=0
							}
							
							upDisply($display3DMaterialSprite.objData,$display3DMaterialSprite.posMatrix,display3dTextureVo.texture,$display3DMaterialSprite.lightMapTexture,$killNum)
						}
					}
					
				}
			}
			resetVa()
			_context3D.setCulling(Context3DTriangleFace.BACK);
			SceneContext.sceneRender.groundlevel.updata();
			_context3D.setCulling(Context3DTriangleFace.FRONT);
			SceneContext.sceneRender.skyLevel.updata()

			_context3D.setRenderToBackBuffer()
			
			_context3D.setStencilReferenceValue(0);
			_context3D.setStencilActions( Context3DTriangleFace.FRONT_AND_BACK, Context3DCompareMode.ALWAYS, Context3DStencilAction.KEEP );
			
			if(ShowMc){
				//ShowMc.setBitMapData(TextureToBmp.TextureToBitMapData(_reflectionTextureVo.texture,null,256,256))
			}
		}
		
	}
}


