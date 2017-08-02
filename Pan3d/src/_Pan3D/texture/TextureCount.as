package _Pan3D.texture
{
	import _Pan3D.particle.ctrl.ParticleManager;
	import _Pan3D.utils.Log;
	import _Pan3D.utils.TickTime;
	import _Pan3D.vo.texture.TextureVo;
	
	import _me.Scene_data;

	public class TextureCount
	{
		private static var _instance:TextureCount;
		
		private var byteNum:Number = 384/65536;
		
		private var textManagerByte:int;
		private var textByte:int;
		private var mapByte:int;
		private var miniMapByte:int;
		
		private var particleNum:int;
		private var particleColorByte:int;
		
		public function TextureCount()
		{
			TickTime.addCallback(countAll);
		}
		public static function getInstance():TextureCount{
			if(!_instance){
				_instance = new TextureCount;
			}
			return _instance;
		}
		
		public function countTextureManager(_textureDic:Object):void{
			textManagerByte = 0;
			for each(var textureVo:TextureVo in _textureDic){
				textManagerByte += textureVo.bitmapdata.width * textureVo.bitmapdata.height * byteNum;
			}
		}
		
		public function countTextFiled(num:int):void{
			textByte = num * 512 * 512 * byteNum;
		}
		
		public function countMap(num:int):void{
			mapByte = num * 256 * 256 * byteNum;
		}
		
		public function countMip(w:int,h:int):void{
			miniMapByte = w * h * byteNum;
		}
		
		public function countParticleColor(num:int):void{
			particleNum += num;
			particleColorByte = particleNum * 6 / 1024;
		}
		private var flag:int;
		/**
		 * 总显存 
		 */ 		
		public var allByte:int;
		
		public function countAll():void{
			//阴影
			//var otherByte:int = 128 * 128 * 2 * byteNum;
			var otherByte:int = 0 *  2048 * 2048 * byteNum;
			var uiByte:int = 512 * 512 * 3 * byteNum;
			allByte = (textManagerByte +  textByte + mapByte + miniMapByte + otherByte + uiByte + particleColorByte)/1024;
			
			var allNeiByte:int = (textManagerByte +  textByte + mapByte + miniMapByte + uiByte)/1024/6*4;
			
			if(allByte > 128){
				//TextureManager.getInstance().enforceDispose();
			}
			
			flag++;
			if(flag == Log.logTime){
				flag = 0;
			}else{
				return;
			}
			
			Log.add("++++++++++++总显存" + allByte + "***粒子：" + toMb(textManagerByte) 
					+　"***粒子颜色：" + toMb(particleColorByte) + "***文本：" +　toMb(textByte)　+　"***地图：" +toMb(mapByte) +　"***其他：" +toMb(miniMapByte + otherByte) );
			
		}
		
		public function toMb(num:Number):Number{
			return int(num/1024*100)/100
		}
		
	}
}