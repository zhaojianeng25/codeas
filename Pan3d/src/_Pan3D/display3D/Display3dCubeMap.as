package _Pan3D.display3D
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	
	import _Pan3D.display3D.analysis.AnalysisServer;
	import _Pan3D.display3D.model.Display3DModelSprite;
	import _Pan3D.texture.TextureCubeMapVo;
	import _Pan3D.texture.TextureManager;
	
	import _me.Scene_data;
	
	public class Display3dCubeMap extends Display3DModelSprite
	{
		//private var cubeMapTex:CubeMapTexture;
		private var _cubeMapUrl:String;
		private var _cubeMapTextureVo:TextureCubeMapVo;
		
		public var showLevel:int;
		
		public function Display3dCubeMap(context:Context3D)
		{
			super(context);
		}

		override protected function setVa():void{
			
			_context.setCulling(Context3DTriangleFace.NONE);
			
			_context.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(1, _objData.normalsBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setTextureAt(1, _cubeMapTextureVo.texturelist[showLevel]);
			_context.drawTriangles(_objData.indexBuffer, 0, -1);
			Scene_data.drawNum++;
			Scene_data.drawTriangle += int(_objData.indexs.length/3);
		}
		
		override protected function setVc():void{
			//this.updateMatrix();
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, posMatrix, true);
		}
		
		public function get cubeMapUrl():String
		{
			return _cubeMapUrl;
		}
		
		public function set cubeMapUrl(value:String):void
		{
			_cubeMapUrl = value;
			TextureManager.getInstance().addCubeTexture(value,onCubeLoad,null);
		}
		
		private function onCubeLoad(textureVo:TextureCubeMapVo,info:Object):void{
			_cubeMapTextureVo = textureVo;
		}
		
		override protected function onObjLoad(str : String) : void {
			_objData = AnalysisServer.getInstance().analysisObj(str);
			uplodToGpu();
		}
			
		
		override public function update():void{
			if (!this._visible) {
				return;
			}
			if (_objData && _cubeMapTextureVo) {
				_context.setProgram(this.program);
				setVc();
				setVa();
				resetVa();
				
			}
		}
		override  protected function resetVa() : void {
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
		
		
		
		
		
	}
}