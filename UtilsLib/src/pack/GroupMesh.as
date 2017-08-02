package pack
{
	public class GroupMesh extends Prefab
	{
		private var  _ccav:Number
		private var _groupName:String
		private var _prefabItem:Array
		public function GroupMesh()
		{
			super();
		}





		public function get prefabItem():Array
		{
			return _prefabItem;
		}

		public function set prefabItem(value:Array):void
		{
			_prefabItem = value;
		}

		public function get groupName():String
		{
			return _groupName;
		}

		public function set groupName(value:String):void
		{
			_groupName = value;
		}

		public function get renderView():GroupMesh
		{
			return this;
		}
		[Editor(type="PrefabRenderWindow",Label="图",sort="1.3",changePath="1",Category="效果窗口",showType="1")]
		public function set renderView(value:GroupMesh):void
		{
			
			
		}
		override public function getName():String
		{
			return _groupName;
		}

	
		
	}
}