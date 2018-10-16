package modules.materials.view.mathNode
{
	import flash.geom.Point;
	
	import modules.materials.treedata.NodeTree;
	import modules.materials.treedata.nodetype.NodeTreeMin;
	import modules.materials.treedata.nodetype.NodeTreePanner;
	import modules.materials.view.BaseMaterialNodeUI;
	import modules.materials.view.ItemMaterialUI;
	import modules.materials.view.MaterialItemType;
	
	public class MathMinNodeUI extends BaseMaterialNodeUI
	{
		
		
		private var inItem:ItemMaterialUI;
		
		private var outItem:ItemMaterialUI;
		
		private var _value:Number;
		public function MathMinNodeUI()
		{
			super();
			titleBitmap = new phys_marterialCls;
			addTitleImg();
			this.gap = 20;
			this.width = 162;
			this.height = 85;
			
			
			_value = 0;
			
			nodeTree = new NodeTreeMin;
			nodeTree.ui = this;
			nodeTree.type = NodeTree.MIN;
			
			outItem = new ItemMaterialUI("out",MaterialItemType.FLOAT,false);
			addItems(outItem);
			
			inItem = new ItemMaterialUI("in",MaterialItemType.FLOAT,true);
			addItems(inItem);
			
			
			_titleLabel.text = "min";
			
		}
		
		override public function getData():Object{
			var obj:Object = super.getData();
			obj.value = _value;
			return obj;
		}
		
		override public function setData(obj:Object):void{
			super.setData(obj);
			this.value = obj.value;
		}

		public function get value():Number
		{
			return _value;
		}

		public function set value(value:Number):void
		{
			_value = value;
			NodeTreeMin(nodeTree).value = value;
		}

		
	}
}