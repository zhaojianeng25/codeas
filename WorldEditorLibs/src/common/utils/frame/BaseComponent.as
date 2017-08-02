package common.utils.frame
{
	import mx.containers.Canvas;
	
	public class BaseComponent extends Canvas
	{
		private var _category:String;
		
		public function get category():String
		{
			return _category;
		}

		public function set category(value:String):void
		{
			_category = value;
		}

		public var changFun:Function;
		public var getFun:Function;
		
		public var target:Object;
		public var FunKey:String;
		
		public var isDefault:Boolean = true;
		
		protected var baseWidth:int = 60;
		
		public function BaseComponent()
		{
			super();
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy = "off";
		}
		
		public function refreshViewValue():void{
			
		}
		
		public function setTarget(obj:Object):void{
			target = obj;
			refreshViewValue();
		}
	}
}