package textures
{
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	
	public class TextureBaseVo
	{
		/**
		 * bitmapdata 内存资源 
		 */		
		public var bitmapdata:BitmapData;
		/**
		 *  texture 显卡资源
		 */		
		public var texture:Texture;
		/**
		 * 使用次数 
		 */		
		public var useNum:int;
		/**
		 * 路径 
		 */		
		public var url:String;
		/**
		 * 闲置时间 
		 */		
		public var idleTime:int;
		
		public var mipmap:Boolean;
		
		public function TextureBaseVo()
		{
			
		}
		public function dispose():void{
			if(texture)
				texture.dispose();
			bitmapdata.dispose();
		}
	}
}