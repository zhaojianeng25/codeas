package render.atf
{
	import flash.display.Bitmap;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.textures.RectangleTexture;
	import flash.display3D.textures.Texture;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import PanV2.TextureCreate;
	import PanV2.loadV2.BmpLoad;
	
	import _Pan3D.base.MakeModelData;
	import _Pan3D.display3D.Display3DSprite;
	import _Pan3D.program.Program3DManager;
	
	import _me.Scene_data;
	
	import render.atf.shader.AftMinTextureShader;
	import render.atf.shader.AtfShaderMath;
	import render.atf.shader.AtfDisplay3DShader;
	
	public class AtfDisplay3DSprite extends Display3DSprite
	{
		private var _tureUrl:String;
		private var _baseTexture:RectangleTexture;
		private var _minTexture:Texture;
		public function AtfDisplay3DSprite(context:Context3D)
		{
			super(context);
			
			init()
		}
		


		public function get minTexture():Texture
		{
			return _minTexture;
		}

		public function get baseTexture():RectangleTexture
		{
			return _baseTexture;
		}

		public function get atfTexture():Texture
		{
			return _atfTexture;
		}

		private function init():void
		{
			Program3DManager.getInstance().registe(AtfDisplay3DShader.ATF_DISPLAY3D_SHADER,AtfDisplay3DShader)
			this.objData=MakeModelData.makeJuXinTampData(new Vector3D(-1000,0,-1000),new Vector3D(1000,0,1000))
			uplodToGpu();
			textureUrl="xsc_04.jpg"
				
			Scene_data.stage.addEventListener(MouseEvent.CLICK,onClik)
		}
		private var _clikNum:uint=0
		protected function onClik(event:MouseEvent):void
		{
			_clikNum++
			
		}
		public function set textureUrl(value:String):void
		{
			_tureUrl = value;
			BmpLoad.getInstance().addSingleLoad(_tureUrl,function ($bitmap:Bitmap,$obj:Object):void{
				_baseTexture=TextureCreate.getInstance().bitmapToRectangleTexture($bitmap.bitmapData)
				_minTexture=TextureCreate.getInstance().bitmapToMinTexture($bitmap.bitmapData)
			},{})
				
			AtfMenager.getInstance().init(Scene_data.context3D)
			AtfMenager.getInstance().addSingleLoad("xsc_04.atf",onAtfLoad);
			function onAtfLoad($obj:Object):void
			{
				_atfTextureFormat=$obj.data.format
				_atfTexture = $obj.atfTexture

			}
			
		}
		private var _atfTextureFormat:Number
		private var _atfTexture:Texture
		
		override public function update() : void {
			if (!this._visible) {
				return;
			}
			if (_objData&&_objData.indexBuffer ) {
				if(true)
				{
					AtfShaderMath.getInstance().updata(this,_clikNum%3)
				    return
				}

				setVc();
				setVa();
				resetVa();
			}
		}
		override  protected function setVa() : void {
			_context.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(1, _objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			_context.setTextureAt(0,_baseTexture)
			_context.drawTriangles(_objData.indexBuffer, 0, -1);
		}
		
		override  protected function resetVa() : void {
			_context.setVertexBufferAt(0, null);
			_context.setVertexBufferAt(1, null);
			_context.setVertexBufferAt(2, null);
			_context.setTextureAt(0,null);
		}
		
		override protected function setVc() : void {
			this.updateMatrix();
			_context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, posMatrix, true);
		}
	}
}