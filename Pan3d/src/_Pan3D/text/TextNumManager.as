package _Pan3D.text
{
	import _Pan3D.texture.TextureManager;
	
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import mx.styles.StyleManager;

	/**
	 * 数字文本管理器 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class TextNumManager
	{

		public var texture:Texture;
		
		public var textureInfo:Object;
		
		private static var _instance:TextNumManager;
		
		public function TextNumManager()
		{
			
		}
		
		public static function getInstance():TextNumManager{
			if(!_instance){
				_instance = new TextNumManager;
			}
			return _instance;
		}
		/**
		 * 初始化 
		 * @param dic
		 * 
		 */		
		public function init(dic:Dictionary):void{
			textureInfo = new Object;
			
			var ary:Array = new Array;
			
			var newDic:Dictionary = new Dictionary;
			
			for(var key:String in dic){
				ary.push(dic[key]);
				newDic[dic[key]] = key;
			}
			
			ary.sortOn("height",Array.NUMERIC);
			
			var bmp:BitmapData = new BitmapData(512,256,true,0xff000000);
			
			var flag:int;
			var ypos:int = 2;
			var rec:Rectangle = new Rectangle;
			var p:Point = new Point;
			
			for(var i:int;i<ary.length;i++){
				rec.width = ary[i].width;
				rec.height = ary[i].height;
				p.x = flag;
				p.y = ypos;
				bmp.copyPixels(ary[i],rec,p);
				
				flag += ary[i].width;
				if((flag + ((i==ary.length-1) ? 0 : ary[i+1].width)) >= 512){
					flag = 2;
					ypos += 30;
				}
				
				var info:Object = new Object;
				info.uvX = p.x/bmp.width;
				info.uvY = p.y/bmp.height;
//				info.uvWidth = ary[i].width/bmp.width;
//				info.uvHeight = ary[i].height/bmp.height;
				info.width = ary[i].width;
				info.height = ary[i].height;
				textureInfo[newDic[ary[i]]] = info;
			}
			
			texture = TextureManager.getInstance().bitmapToTexture(bmp);
		}
		/**
		 * 系统是否准备完成 
		 * @return 
		 * 
		 */		
		public function getReady():Boolean{
			return Boolean(textureInfo);
		}
		/**
		 * 获取一个3D显示对象 
		 * @param strVec 关键字的数组
		 * @return 
		 * 
		 */		
		public function getTextAryDisplay3d(strVec:Vector.<String>):TextAryDisplay3D{
			
			if(!textureInfo){
				return null;
			}
			
			var txtDisplay3D:TextAryDisplay3D = new TextAryDisplay3D;
			
			var flag:int;
			var maxHeight:int;
			for(var i:int;i<strVec.length;i++){
				var txt:Text3D = TextFieldManager.getInstance().getText3D(texture);
				var info:Object = textureInfo[strVec[i]];
				txt.setUV(info.uvX,info.uvY);
				txt.width = info.width;
				txt.height = info.height;
				txt.offsetX = flag;
				flag += info.width;
				if(txt.height > maxHeight){
					maxHeight = txt.height;
				}
				txtDisplay3D.addText(txt);
			}
			
			txtDisplay3D.correctOffestY(maxHeight);
			
			return txtDisplay3D;
		}
		
		
		
		
		
	}
}