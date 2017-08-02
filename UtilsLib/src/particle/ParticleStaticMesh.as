package particle
{
	import flash.events.Event;
	
	import interfaces.ITile;
	
	import light.LightStaticMesh;
	
	import pack.ModePropertyMesh;
	
	public class ParticleStaticMesh extends ModePropertyMesh implements ITile
	{
		private var _url:String;
		private var _resetData:uint
		
		public function ParticleStaticMesh()
		{
			super();
		}
		public function clone():ParticleStaticMesh
		{
			var $particleMesh:ParticleStaticMesh=new ParticleStaticMesh
			$particleMesh.url=url
			return $particleMesh
		}

		public function get resetData():uint
		{
			return _resetData;
		}
		[Editor(type="Btn",Label="刷新数据",sort="50",Category="更新",Tip="范围")]
		public function set resetData(value:uint):void
		{
			_resetData = value;
			
			this.dispatchEvent(new Event(Event.COMPLETE));
			change()
		}


		public function readObject():Object
		{
			var $obj:Object=new Object
			$obj.url=_url
			return $obj
		}

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}

	}
}