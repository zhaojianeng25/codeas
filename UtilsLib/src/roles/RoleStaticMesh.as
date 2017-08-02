package roles
{
	import interfaces.ITile;
	
	import pack.ModePropertyMesh;
	
	public class RoleStaticMesh extends ModePropertyMesh implements ITile
	{
		private var _url:String
		public function RoleStaticMesh()
		{
			super();
		}

		public function get url():String
		{
			return _url;
		}
		public function readObject():Object
		{
			var $obj:Object=new Object
			$obj.url=_url
			return $obj
		}

		public function set url(value:String):void
		{
			_url = value;
		}

	}
}