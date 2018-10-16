package light
{
	import interfaces.ITile;
	
	import pack.ModePropertyMesh;
	
	public class ReflectionStaticMesh extends ModePropertyMesh implements ITile
	{
		private var _url:String
		private var _reFlectionMapSize:int
		private var _needSkyBox:Boolean
		public function ReflectionStaticMesh()
		{
			super();
		}

		public function get needSkyBox():Boolean
		{
			return _needSkyBox;
		}
		[Editor(type="ComboBox",Label="扫描天空",sort="10",Category="属性",Data="{name:false,data:false}{name:true,data:true}",Tip="是否当地形用来扫描高度")]
		public function set needSkyBox(value:Boolean):void
		{
			_needSkyBox = value;
		}

		public function get reFlectionMapSize():int
		{
			return _reFlectionMapSize;
		}
		[Editor(type="ComboBox",Label="贴图尺寸",sort="11",Category="属性",Data="{name:32,data:32}{name:64,data:64}{name:128,data:128}{name:256,data:256}{name:512,data:512}{name:1024,data:1024}",Tip="2的幂")]

		public function set reFlectionMapSize(value:int):void
		{
			_reFlectionMapSize = value;
			change()
		}

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}
		public function readObject():Object
		{
			var $obj:Object=new Object
			$obj.url=_url
			$obj.reFlectionMapSize=_reFlectionMapSize
			$obj.needSkyBox=_needSkyBox
			return $obj
		}

	}
}