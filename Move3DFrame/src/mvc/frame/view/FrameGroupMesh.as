package  mvc.frame.view
{
	import flash.events.Event;
	
	import pack.HierarchyGroupMesh;
	
	public class FrameGroupMesh extends HierarchyGroupMesh
	{
		private var _okBut:Boolean;

		public function FrameGroupMesh()
		{
			super();
		}
		
		public function get okBut():Boolean
		{
			return _okBut;
		}
		[Editor(type="Btn",Label="更新到场景中",sort="10",Category="对齐列表")]
		public function set okBut(value:Boolean):void
		{
			_okBut = value;
			
	
			this.dispatchEvent(new Event(Event.ACTIVATE));
		}

	}
}