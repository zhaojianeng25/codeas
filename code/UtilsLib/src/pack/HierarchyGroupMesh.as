package pack
{
	import flash.events.Event;

	public class HierarchyGroupMesh extends ModePropertyMesh
	{
		private var _fouce:uint
		private var _item:Object
		private var _makeMaGroup:Object
		private var _groupMaterialId:int;
		private var _isHide:Boolean
		public function HierarchyGroupMesh()
		{
			super();
		}


		public function get isHide():Boolean
		{
			return _isHide;
		}

		public function set isHide(value:Boolean):void
		{
			_isHide = value;
		}

		public function get groupMaterialId():int
		{
			return _groupMaterialId;
		}
		//[Editor(type="Number",Label="材质Group",Step="1",sort="4",MinNum="-1",MaxNum="999",Category="属性",Tip="范围")]
		public function set groupMaterialId(value:int):void
		{
			_groupMaterialId = value;
		}

		public function get makeMaGroup():Object
		{
			return _makeMaGroup;
		}

		public function set makeMaGroup(value:Object):void
		{
			_makeMaGroup = value;
		}

		public function get item():Object
		{
			return _item;
		}
		[Editor(type="AlignPanelPic",Label="图",sort="10",Category="对齐列表",showType="1")]
		public function set item(value:Object):void
		{
			_item = value;
			
			
		}



	}
}