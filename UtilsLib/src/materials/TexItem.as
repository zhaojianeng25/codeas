package materials
{
	import flash.display3D.textures.Texture;
	
	import textures.TextureBaseVo;

	public class TexItem
	{
		public var id:uint;
		public var url:String;
		public var texture:Texture;
		public var textureVo:TextureBaseVo;
		private var _isDynamic:Boolean;
		public var paramName:String;
		public var isParticleColor:Boolean;
		public var isMain:Boolean;
		public var wrap:int;
		public var filter:int;
		public var mipmap:int;
		public var permul:Boolean;
		//public var isLightMap:Boolean;
		/**
		 * 0 为默认 
		 * 1 lightmap 
		 * 2 lutmap
		 * 3 cubemap
		 * 4 heightMap;
		 */		
		public var type:int;
		
		public static const LIGHTMAP:int = 1;
		public static const LTUMAP:int = 2;
		public static const CUBEMAP:int = 3;
		public static const HEIGHTMAP:int = 4;
		public static const REFRACTIONMAP:int = 5;
		
		
		public function TexItem()
		{
			
		}

		public function get isDynamic():Boolean
		{
			return _isDynamic;
		}

		public function set isDynamic(value:Boolean):void
		{
			_isDynamic = value;
		}

	}
}