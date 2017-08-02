package _Pan3D.display3D.capture
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.textures.RectangleTexture;
	
	import PanV2.TextureCreate;
	
	import _Pan3D.display3D.model.Display3DModelSprite;
	import _Pan3D.program.Program3DManager;
	
	public class Display3DCaptureSprite extends Display3DModelSprite
	{
        private var _cubeTextureBmp:BitmapData
        private var _cubeTexture:RectangleTexture
		public function Display3DCaptureSprite(context:Context3D)
		{
			super(context);
			Program3DManager.getInstance().registe(Display3DCaptureShader.DISPLAY3D_CAPTURE_SHADER,Display3DCaptureShader)
			program=Program3DManager.getInstance().getProgram(Display3DCaptureShader.DISPLAY3D_CAPTURE_SHADER)
				
			cubeTextureBmp=new BitmapData(128,128,false,0x6c6c6c)
		}

		public function get cubeTextureBmp():BitmapData
		{
			return _cubeTextureBmp;
		}

		public function set cubeTextureBmp(value:BitmapData):void
		{
			_cubeTextureBmp = value;
			_cubeTexture=TextureCreate.getInstance().bitmapToRectangleTexture(_cubeTextureBmp)
		}
		
		override public function update() : void {
			
			if (_objData && _objData.indexBuffer&&cubeTextureBmp&&_visible) {
				_context.setProgram(this.program);
				setVc();
				setVa();
				resetVa();
			}
		}
		override protected function setVa() : void {
			_context.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(1, _objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			_context.setTextureAt(0,_cubeTexture)
			_context.drawTriangles(_objData.indexBuffer, 0, -1);
			
		}
		
		override  protected function resetVa() : void {
			_context.setVertexBufferAt(0, null);
			_context.setVertexBufferAt(1, null);
			_context.setTextureAt(0,null)
			
		}
		
		override  protected function setVc() : void {
			this.updateMatrix();
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, posMatrix, true);
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, Vector.<Number>([0.6,0.6,0.6,1])); //专门用来存树的通道的
		}

	}
}