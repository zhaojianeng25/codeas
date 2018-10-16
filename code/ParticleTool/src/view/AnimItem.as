package view
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.CheckBox;

	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * </p>
	 * 运动条目
	 */	
	public class AnimItem extends CheckBox
	{
		public var sourceData:ArrayCollection;//源数据
		private var _resultData:Array;//最终编辑后的数据
		public var type:int;
		public function AnimItem()
		{
			super();
		}

		public function get resultData():Array
		{
			return _resultData;
		}
		/**
		 * 重新设置数据后，向外分发事件，刷新显示 
		 * @param value
		 * 
		 */		
		public function set resultData(value:Array):void
		{
			_resultData = value;
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		/**
		 * 获取所有数据 类型+数据
		 * @return 
		 * 
		 */		
		public function getAllData():Object{
			var obj:Object = new Object;
			obj.type = type;
			obj.data = _resultData;
			return obj;
		}
		
		public function setResultData(ary:Array):void{
			_resultData = ary;
		}

	}
}