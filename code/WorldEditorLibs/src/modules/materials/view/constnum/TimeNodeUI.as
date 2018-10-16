package modules.materials.view.constnum
{
	import modules.materials.treedata.NodeTree;
	import modules.materials.treedata.nodetype.NodeTreeFloat;
	import modules.materials.treedata.nodetype.NodeTreeTime;
	import modules.materials.view.BaseMaterialNodeUI;
	import modules.materials.view.ItemMaterialUI;
	import modules.materials.view.MaterialItemType;
	
	public class TimeNodeUI extends BaseMaterialNodeUI
	{
		private var outItem:ItemMaterialUI;
		
		private var _speed:Number = 1;
		
		public function TimeNodeUI()
		{
			super();
			titleBitmap = new phys_marterialCls;
			addTitleImg();
			this.gap = 20;
			this.width = 162;
			this.height = 65;
			
			
			nodeTree = new NodeTreeTime;
			nodeTree.ui = this;
			nodeTree.type = NodeTree.TIME;
			
			outItem = new ItemMaterialUI("out",MaterialItemType.FLOAT,false);
			addItems(outItem);
			
			_titleLabel.text = "Time";
			
		}

		public function get speed():Number
		{
			return _speed;
		}

		public function set speed(value:Number):void
		{
			_speed = value;
			NodeTreeTime(nodeTree).speed = value;
		}
		
		override public function getData():Object{
			var obj:Object = super.getData();
			obj.speed = _speed;
			return obj;
		}
		
		override public function setData(obj:Object):void{
			super.setData(obj);
			this.speed = obj.speed;
			NodeTreeTime(nodeTree).speed = speed;
		}

	}
}