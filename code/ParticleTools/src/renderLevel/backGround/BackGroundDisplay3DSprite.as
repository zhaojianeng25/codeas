package renderLevel.backGround
{
	import _Pan3D.base.MakeModelData;
	import _Pan3D.display3D.Display3DSprite;
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	import _Pan3D.texture.TextureManager;
	
	import _me.Scene_data;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	public class BackGroundDisplay3DSprite extends Display3DSprite
	{
		private var _width:Number
		private var _height:Number
		public function BackGroundDisplay3DSprite(context:Context3D)
		{
			super(context);
		}
		public function setInfoData(zNum:Number,url:String):void
		{
			_objData=MakeModelData.makeJuXinTampData(new Vector3D(0,0,zNum),new Vector3D(2,-2,zNum));
			LoadManager.getInstance().addSingleLoad( new LoadInfo(url, LoadInfo.BITMAP, function onBitmapLoad(bitmap:Bitmap):void
			{
				_objData.texture=TextureManager.getInstance().bitmapToTexture(bitmap.bitmapData);
				_width=bitmap.bitmapData.width
				_height=bitmap.bitmapData.height
				uplodToGpu();
			}, 0));	
		}
		public function setBitmapdata(zNum:Number,bitmapdata:BitmapData):void{
			_objData=MakeModelData.makeJuXinTampData(new Vector3D(0,0,zNum),new Vector3D(2,-2,zNum));
			_objData.texture=TextureManager.getInstance().bitmapToTexture(bitmapdata);
			_width=bitmapdata.width
			_height=bitmapdata.height
			uplodToGpu();
		}
		override public function update() : void {
			if (!this._visible) {
				return;
			}
			if (_objData && _objData.texture) {
				_context.setProgram(this.program);
				setVc();
				setVa();
				resetVa();
			}
		}
		override protected function setVa() : void {
			_context.setVertexBufferAt(0, _objData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			_context.setVertexBufferAt(1, _objData.uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			_context.setTextureAt(0, _objData.texture);
			_context.drawTriangles(_objData.indexBuffer, 0, -1);
			Scene_data.drawNum++;
		}
		override protected function resetVa() : void {
			_context.setVertexBufferAt(0, null);
			_context.setVertexBufferAt(1, null);
			_context.setTextureAt(0,null);
		}
		override protected function setVc() : void {
			
			var sw:Number=_width/Scene_data.stageWidth;
			var sh:Number=_height/Scene_data.stageHeight;
			var tx:Number=-1+_absoluteX/Scene_data.stageWidth*2
			var ty:Number=1-_absoluteY/Scene_data.stageHeight*2

			_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,Vector.<Number>( [sw,sh,tx,ty]));   //等用
			
		}
		
		public function set texture(value:Texture):void{
			_objData.texture = value;
		}
	}
}