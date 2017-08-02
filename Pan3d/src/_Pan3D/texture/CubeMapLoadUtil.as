package _Pan3D.texture
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.CubeTexture;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	
	import _me.Scene_data;
	
	import materials.MaterialCubeMap;

	public class CubeMapLoadUtil
	{
		public function CubeMapLoadUtil()
		{
			
		}
		
		private var texturelist:Vector.<CubeTexture>;
		private var _loadNum:int;
		private var _callBackFun:Function;
		private var _info:Object;
		private var _url:String;
		
		public function loadCubeUrl(url:String,fun:Function,info:Object):void{
			if(url.indexOf("jpg") != -1){
				return;
			}
			_callBackFun = fun;
			_info = info;
			_url = url;
			
			var loaderinfo : LoadInfo = new LoadInfo(url, LoadInfo.BYTE, onByteLoad,0);
			LoadManager.getInstance().addSingleLoad(loaderinfo);
		}
		protected function onByteLoad(byte:ByteArray) : void {
			var obj:Object = byte.readObject();
			var cube:MaterialCubeMap = new MaterialCubeMap();
			cube.setObject(obj);
			loadMap(cube);
		}
		
		private function loadMap($cube:MaterialCubeMap):void{
			texturelist = new Vector.<CubeTexture>(6);
			_loadNum = 0;
			
			for(var i:int;i<6;i++){
				var loaderinfo : LoadInfo = new LoadInfo(Scene_data.fileRoot + $cube["textureName" + i], LoadInfo.BITMAP, onBmpLoad,0,{key:i});
				LoadManager.getInstance().addSingleLoad(loaderinfo);
			}
			
		}
		
		
		protected function onBmpLoad(bmp:Bitmap,info:Object) : void {
			//trace(info)
			var baseW:int = bmp.width/3;
			var ma:Matrix = new Matrix;
			
			var left:BitmapData = new BitmapData(baseW,baseW,true,0xffffffff);
			ma.identity();
			ma.rotate(-90/180 *Math.PI);
			ma.translate(0,bmp.width - baseW);
			left.draw(bmp,ma)
				
			var right:BitmapData = new BitmapData(baseW,baseW,true,0xffffffff);
			ma.identity();
			ma.rotate(-90/180 *Math.PI);
			ma.translate(0 - 2 * baseW ,bmp.width - baseW);
			right.draw(bmp,ma);
			
			var front:BitmapData = new BitmapData(baseW,baseW,true,0xffffffff);
			ma.identity();
			ma.rotate(-90/180 *Math.PI);
			ma.translate(0 - baseW ,bmp.width - baseW);
			front.draw(bmp,ma);
			
			var back:BitmapData = new BitmapData(baseW,baseW,true,0xffffffff);
			ma.identity();
			ma.rotate(-90/180 *Math.PI);
			ma.translate(0 - 3 * baseW ,bmp.width - baseW);
			back.draw(bmp,ma);
			
			var top:BitmapData = new BitmapData(baseW,baseW,true,0xffffffff);
			ma.identity();
			ma.rotate(-90/180 *Math.PI);
			ma.translate(0 - baseW ,bmp.width);
			top.draw(bmp,ma);
			
			var down:BitmapData = new BitmapData(baseW,baseW,true,0xffffffff);
			ma.identity();
			ma.rotate(-90/180 *Math.PI);
			ma.translate(0 - baseW ,bmp.width - 2 * baseW);
			down.draw(bmp,ma);
			
			var cubeTexture:CubeTexture = Scene_data.context3D.createCubeTexture(baseW,Context3DTextureFormat.BGRA,false);
			
			//if(info["key"] == 0){
			//	Scene_data.stage.addChild(new Bitmap(back));
			//}
			
			uploadBimapdataMipmap(cubeTexture,right,0);
			uploadBimapdataMipmap(cubeTexture,left,1);
			uploadBimapdataMipmap(cubeTexture,top,2);
			uploadBimapdataMipmap(cubeTexture,down,3);
			uploadBimapdataMipmap(cubeTexture,front,4);
			uploadBimapdataMipmap(cubeTexture,back,5);

			texturelist[info["key"]] = cubeTexture;
			
			_loadNum++;
			if(_loadNum == 6){
				var textureCubeMapVo:TextureCubeMapVo = new TextureCubeMapVo;
				textureCubeMapVo.texturelist = texturelist;
				textureCubeMapVo.url = _url;
				_callBackFun(textureCubeMapVo,_info);
			}
		}
		
		private function uploadBimapdataMipmap(texture:CubeTexture,bitmapdata:BitmapData,side:int):void{
			var ws:int = bitmapdata.width;
			var hs:int = bitmapdata.height;
			var level:int = 0; 
			var tmp:BitmapData;
			var transform:Matrix = new Matrix();
			tmp = new BitmapData(ws, hs, true, 0x00000000);
			while ( ws >= 1 && hs >= 1 ) {
				tmp.draw(bitmapdata, transform, null, null,null, true);
				texture.uploadFromBitmapData(tmp,side,level);
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