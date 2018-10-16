package light
{
	import interfaces.ITile;
	
	import pack.ModePropertyMesh;
	
	public class LightStaticMesh extends ModePropertyMesh implements ITile
	{
		private var _distance:Number;
		private var _strong:Number;
		private var _color:int
        private var _cutoff:Number;
	
		
		public function LightStaticMesh()
		{
			super();
		}

		public function clone():LightStaticMesh
		{
			var $buildMesh:LightStaticMesh=new LightStaticMesh
			$buildMesh.distance=_distance
			$buildMesh.strong=_strong
			$buildMesh.color=_color
			$buildMesh.cutoff=_cutoff
			return $buildMesh
		}
		


		public function get color():int
		{
			return _color;
		}
		[Editor(type="ColorPick",Label="颜色",sort="9",Category="属性",Tip="范围")]
		public function set color(value:int):void
		{
			_color = value;
			change()
		}

		public function get distance():Number
		{
			return _distance;
		}
		[Editor(type="Number",Label="范围",Step="1",sort="10",MinNum="0",MaxNum="1000",Category="属性",Tip="范围")]
		public function set distance(value:Number):void
		{
			_distance = value;
			change()
		}
		public function get strong():Number
		{
			return _strong;
		}
		[Editor(type="Number",Label="强度",Step="0.01",sort="11",MinNum="0",MaxNum="15",Category="属性",Tip="范围")]
		public function set strong(value:Number):void
		{
			_strong = value;
		}
		public function get cutoff():Number
		{
			return _cutoff;
		}
		[Editor(type="Number",Label="衰减",Step="0.01",sort="11",MinNum="0",MaxNum="1",Category="属性",Tip="范围")]
		public function set cutoff(value:Number):void
		{
			_cutoff = value;
		}

		public function readObject():Object
		{
			var $obj:Object=new Object
			$obj.color=_color
			$obj.distance=_distance
			$obj.cutoff=_cutoff
			$obj.strong=_strong
			return $obj
		}
		

	}
}