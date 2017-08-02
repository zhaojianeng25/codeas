package light
{
	import interfaces.ITile;
	
	import pack.ModePropertyMesh;
	
	public class ParallelLightStaticMesh extends ModePropertyMesh implements ITile
	{
		
		private var _modelUrl:String

		
		private var _color:int
		private var _strong:Number;
		
		
		public function ParallelLightStaticMesh()
		{
			super();
		}
		public function readObject():Object
		{
			var $obj:Object=new Object
			$obj.modelUrl=_modelUrl
			$obj.color=_color
			$obj.strong=_strong
			return $obj
		}

		public function get color():int
		{
			return _color;
		}
		[Editor(type="ColorPick",Label="颜色",sort="10",Category="属性",Tip="范围")]
		public function set color(value:int):void
		{
			_color = value;
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
		
	

		public function get modelUrl():String
		{
			return _modelUrl;
		}

		public function set modelUrl(value:String):void
		{
			_modelUrl = value;
		}

	}
}