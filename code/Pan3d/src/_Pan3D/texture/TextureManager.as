package _Pan3D.texture
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.CubeTexture;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	
	import _Pan3D.core.MathCore;
	import _Pan3D.load.LoadInfo;
	import _Pan3D.load.LoadManager;
	import _Pan3D.utils.Log;
	import _Pan3D.utils.TickTime;
	import _Pan3D.vo.texture.TextureVo;
	
	import _me.Scene_data;
	
	/**
	 * @author liuyanfei  QQ: 421537900
	 */
	public class TextureManager
	{
		private var _textureDic:Object;
		private var _loadFunDic:Object;
		private var _context:Context3D;
		
		private static var instance:TextureManager;
		
		public var defaultLightTextVo:TextureVo;
		
		public function TextureManager()
		{
			_textureDic = new Object;
			_loadFunDic = new Object;
			TickTime.addCallback(dispose);
		}
		public function getTextureByUrl($url:String):TextureVo
		{
			if(_textureDic.hasOwnProperty($url)){
				return _textureDic[$url]
			}else{
				return null
			}
				
	
			
		}
		private function initDefaultLight():void{
			var bitmapdata:BitmapData = new BitmapData(1,1,true,MathCore.argbToHex(0xff,0xff/2,0xff/2,0xff/2));
			defaultLightTextVo = new TextureVo;
			defaultLightTextVo.texture = bitmapToTexture(bitmapdata,true);
		}
		
		public static function getInstance():TextureManager{
			if(!instance){
				instance = new TextureManager;
			}
			return instance;
		}
		/**
		 * 图片转显卡资源 
		 * @param bmp
		 * @return 
		 */		
		public function bitmapToTexture(bmp:BitmapData, autoDispose:Boolean = false):Texture
		{
			try{
				var texture:Texture=_context.createTexture(bmp.width,bmp.height, Context3DTextureFormat.BGRA,false);
				uploadBimapdata(texture,bmp);
			} 
			catch(error:Error) {
				if(!Scene_data.disposed){
					throw error;
				}
			}
			if(autoDispose)
			{
				bmp.dispose();
			}
			return texture;
		}
		
		public function atfToTexture(byte:ByteArray):Texture
		{
			try{
				var texture:Texture=_context.createTexture(256,256, Context3DTextureFormat.COMPRESSED,true);
				texture.uploadCompressedTextureFromByteArray(byte,0);
			} 
			catch(error:Error) {
				if(!Scene_data.disposed){
					throw error;
				}
			}
			
			return texture;
		}
		
		public function init(context:Context3D):void{
			this._context = context;
			initDefaultLight();
		}
		
		public function addBitmapCubeTexture($ary:Vector.<BitmapData>,$textureVo:TextureCubeMapVo = null):TextureCubeMapVo{
			var texturelist:Vector.<CubeTexture> = new Vector.<CubeTexture>;
			for(var i:int;i<$ary.length;i++){
				texturelist.push(bmpToCubeTexture($ary[i]));
			}
			
			var textureCubeMapVo:TextureCubeMapVo;
			
			if($textureVo){
				textureCubeMapVo = $textureVo;
			}else{
				textureCubeMapVo = new TextureCubeMapVo;
			}
			
			textureCubeMapVo.texturelist = texturelist;
			return textureCubeMapVo;
		}
		
		private function bmpToCubeTexture(bmp:BitmapData):CubeTexture{
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
			
			uploadCubeBimapdataMipmap(cubeTexture,right,0);
			uploadCubeBimapdataMipmap(cubeTexture,left,1);
			uploadCubeBimapdataMipmap(cubeTexture,top,2);
			uploadCubeBimapdataMipmap(cubeTexture,down,3);
			uploadCubeBimapdataMipmap(cubeTexture,front,4);
			uploadCubeBimapdataMipmap(cubeTexture,back,5);
			
			return cubeTexture;
		}
		
		private function uploadCubeBimapdataMipmap(texture:CubeTexture,bitmapdata:BitmapData,side:int):void{
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
		
		public function addCubeTexture(url:String,fun:Function,info:Object):void{
			var cubeUtil:CubeMapLoadUtil = new CubeMapLoadUtil;
			cubeUtil.loadCubeUrl(url,fun,info);
		}
		
		public function addTexture(url:String,fun:Function,info:Object,$priority:int=0,$mipmap:Boolean=false):void{
			if(_textureDic.hasOwnProperty(url) && !Scene_data.isDevelop){
				var tvo:TextureVo = _textureDic[url];
				if(!tvo.mipmap && $mipmap){
					uploadBimapdataMipmap(tvo.texture,tvo.bitmapdata);
					tvo.mipmap = true;
				}
				fun(_textureDic[url],info);
			}else{
				if(!_loadFunDic.hasOwnProperty(url)){
					_loadFunDic[url] = new Array;
					var loaderinfo:LoadInfo = new LoadInfo(url,LoadInfo.BITMAP,onTextureLoad,$priority,{"url":url,"mipmap":$mipmap});
					LoadManager.getInstance().addSingleLoad(loaderinfo);
				}
				_loadFunDic[url].push({"fun":fun,"info":info});
			}
		}
		
		public function onTextureLoad(bitmap:Bitmap,info:Object):void{
			var url:String = info.url;
			var mipmap:Boolean = info.mipmap;
			var bitmapdata:BitmapData = bitmap.bitmapData;
			var texture:Texture;
			
			if(Scene_data.isOpenGL){
				var newBitmapdata:BitmapData = new BitmapData(bitmapdata.width, bitmapdata.height,true,0x01000000);
				newBitmapdata.draw(bitmap);
				bitmapdata.dispose();
				bitmapdata = newBitmapdata;
			}
			
			try{
				texture = this._context.createTexture(bitmapdata.width, bitmapdata.height, Context3DTextureFormat.BGRA, true);
				if(mipmap){
					uploadBimapdataMipmap(texture,bitmapdata);
				}else{
					uploadBimapdata(texture,bitmapdata);
				}
				
			} 
			catch(error:Error) {
				if(!Scene_data.disposed){
					throw error;
				}
			}
			
			var textureVo:TextureVo = new TextureVo;
			_textureDic[url] = textureVo;
			
			textureVo.bitmapdata = bitmapdata; 
			textureVo.texture = texture;
			textureVo.url = url;
			textureVo.mipmap = mipmap;
			
			var ary:Array = _loadFunDic[url];
			for each(var obj:Object in ary){
				obj.fun(textureVo,obj.info)
			}
			delete _loadFunDic[url];
		}
		private function uploadBimapdata(texture:Texture,bitmapdata:BitmapData):void{
			texture.uploadFromBitmapData(bitmapdata);
		}
		private function uploadBimapdataMipmap(texture:Texture,bitmapdata:BitmapData):void{
//			texture.uploadFromBitmapData(bitmapdata);
//			return;
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
		public function reload(context:Context3D):void{
			this._context = context;
			
			for each(var textureVo:TextureVo in _textureDic){
				textureVo.texture = this._context.createTexture(textureVo.bitmapdata.width, textureVo.bitmapdata.height, Context3DTextureFormat.BGRA, true);
				uploadBimapdata(textureVo.texture,textureVo.bitmapdata);
			}
			
			var bitmapdata:BitmapData = new BitmapData(1,1,true,0xff000000);
			defaultLightTextVo.texture = bitmapToTexture(bitmapdata,true);
			
		}
		
		public function reloadTexture(url:String):Texture{
			if(_textureDic.hasOwnProperty(url)){
				return _textureDic[url].texture;
			}
			trace("重载资源不存在"); 
			return null;
		}
		private var flag:int;
		public function dispose():void{
			if(Scene_data.isDevelop){
				return;
			}
			var num:int;
			for each(var textureVo:TextureVo in _textureDic){
				if(textureVo.useNum <= 0){
					textureVo.idleTime++;
					if(textureVo.idleTime >= Scene_data.cacheTime){
						delete _textureDic[textureVo.url];
						textureVo.dispose();
					}
				}else{
					textureVo.idleTime = 0;
					num++;
				}
			}
			
			flag++;
			if(flag == Log.logTime){
				flag = 0;
				var allNum:int;
				for each(textureVo in _textureDic){
					if(textureVo.useNum > 0){
						Log.add(textureVo.url + "*" + textureVo.useNum,5)
					}
						allNum++;
				}
				Log.add("******************************************texture分割线***********************************************使用数量" +　num +　" 总数：" + allNum + "空闲个数：" + (allNum-num));
			}
			TextureCount.getInstance().countTextureManager(_textureDic);
			//trace("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&内存线&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& " +　System.totalMemory);
		}
		/**
		 * 强制释放内存，如果内存较大的时候 强制释放 
		 * 
		 */		
		public function enforceDispose():void{
			for each(var textureVo:TextureVo in _textureDic){
				if(textureVo.useNum <= 0){
					if(textureVo.idleTime >= Scene_data.cacheTime/2){
						delete _textureDic[textureVo.url];
						textureVo.dispose();
					}
				}
			}
		}
		
		
	}
}