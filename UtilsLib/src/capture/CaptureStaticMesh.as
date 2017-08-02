package capture
{
	import flash.display.BitmapData;
	
	import interfaces.ITile;
	
	import pack.ModePropertyMesh;
	
	import textures.TextureBaseVo;
	
	public class CaptureStaticMesh extends ModePropertyMesh implements ITile
	{
		private  var _url:String
		private  var _textureSize:uint
		private  var _cubeTextureBmp:BitmapData
		private  var _textureBaseVo:TextureBaseVo
		public function CaptureStaticMesh()
		{
			super();
		}

		public function get textureBaseVo():TextureBaseVo
		{
			return _textureBaseVo;
		}

		public function set textureBaseVo(value:TextureBaseVo):void
		{
			_textureBaseVo = value;
		}

		public function get cubeTextureBmp():BitmapData
		{
			return _cubeTextureBmp;
		}

		public function set cubeTextureBmp(value:BitmapData):void
		{
			_cubeTextureBmp = value;
		}

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}
		
		public function get textureSize():int
		{
			return _textureSize;
		}
		[Editor(type="ComboBox",Label="贴图尺寸",sort="3",Category="属性",Data="{name:32,data:32}{name:64,data:64}{name:128,data:128}{name:256,data:256}{name:512,data:512}{name:1024,data:1024}",Tip="2的幂")]
		public function set textureSize(value:int):void
		{
			_textureSize = value;
			change();
		}
		
		public function readObject():Object
		{
			var $obj:Object=new Object
			$obj.textureSize=_textureSize
			$obj.url=_url
			return $obj
		}

	}
}