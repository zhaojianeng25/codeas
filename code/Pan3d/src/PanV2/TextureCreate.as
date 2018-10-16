package PanV2
{
	import flash.display.BitmapData;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.RectangleTexture;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	
	import _me.Scene_data;

	public class TextureCreate
	{
		private static var instance:TextureCreate;
		public function TextureCreate()
		{
		}
		public static function getInstance():TextureCreate
		{
			
			if(!instance){
				instance=new TextureCreate()
			}
			return instance;
		}
		public function bitmapToRectangleTexture($bmp:BitmapData):RectangleTexture
		{
			
			var _groundInfoText:RectangleTexture=Scene_data.context3D.createRectangleTexture($bmp.width,$bmp.height, Context3DTextureFormat.RGBA_HALF_FLOAT,true);
			_groundInfoText.uploadFromBitmapData($bmp)
			return _groundInfoText;
			
		}
		public function bitmapToTexture($bmp:BitmapData):Texture
		{
			
			var tempText:Texture=Scene_data.context3D.createTexture($bmp.width,$bmp.height, Context3DTextureFormat.BGRA,false);
			tempText.uploadFromBitmapData($bmp)
			return tempText;
			
		}
		public function bitmapToMinTexture($bmp:BitmapData,$w:uint=0,$h:uint=0):Texture
		{
			var $temp:BitmapData
			if($w==0||$h==0){
				 $temp=$bmp.clone()
			}else{
				$temp=new BitmapData($w,$h,true,0x000000)
			
				var $m:Matrix=new Matrix;
				$m.scale($w/$bmp.width,$h/$bmp.height)
				$temp.draw($bmp,$m)
			}
			var _groundInfoText:Texture=Scene_data.context3D.createTexture($temp.width,$temp.height, Context3DTextureFormat.BGRA,false);
			uploadBimapdataMipmap(_groundInfoText,$temp)
			$temp.dispose()
			return _groundInfoText;
		}
		private function uploadBimapdataMipmap(texture:Texture,bitmapdata:BitmapData):void{

	
			var ws:int = bitmapdata.width;
			var hs:int = bitmapdata.height;
			var level:int = 0; 
			var tmp:BitmapData;
			var transform:Matrix = new Matrix();
			tmp = new BitmapData(ws, hs, true, 0x00000000);
			while ( ws >= 1 && hs >= 1 ) {
				tmp.draw(bitmapdata, transform, null, null,
					null, true);
				texture.uploadFromBitmapData(tmp, level);
				transform.scale(0.5, 0.5);
				level++; 
				ws >>= 1;
				hs >>= 1;
				if(hs!=ws && (hs==0||ws==0)){
					if(hs == 0){
						hs = 1;
					}
					if(ws == 0){
						ws = 1;
					}
				}
				if (hs && ws) {
					tmp.dispose();
					tmp = new BitmapData(ws, hs, true, 0x00000000);
				}
			}
			tmp.dispose();
		}

		
	}
}