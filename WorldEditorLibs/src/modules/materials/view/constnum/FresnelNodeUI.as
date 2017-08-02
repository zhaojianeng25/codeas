package modules.materials.view.constnum
{
	import modules.materials.treedata.NodeTree;
	import modules.materials.treedata.nodetype.NodeTreeFloat;
	import modules.materials.treedata.nodetype.NodeTreeFresnel;
	import modules.materials.treedata.nodetype.NodeTreeTime;
	import modules.materials.view.BaseMaterialNodeUI;
	import modules.materials.view.ItemMaterialUI;
	import modules.materials.view.MaterialItemType;
	
	public class FresnelNodeUI extends BaseMaterialNodeUI
	{
		private var inItem:ItemMaterialUI;
		private var inAItem:ItemMaterialUI;
		private var inBItem:ItemMaterialUI;
		private var outItem:ItemMaterialUI;
		
		public function FresnelNodeUI()
		{
			super();
			titleBitmap = new phys_marterialCls;
			addTitleImg();
			this.gap = 20;
			this.width = 162;
			this.height = 100;
			
			
			nodeTree = new NodeTreeFresnel;
			nodeTree.ui = this;
			nodeTree.type = NodeTree.FRESNEL;
			
			outItem = new ItemMaterialUI("out",MaterialItemType.FLOAT,false);
			addItems(outItem);
			
			inAItem = new ItemMaterialUI("scale",MaterialItemType.FLOAT,true);
			addItems(inAItem);
			
			inBItem = new ItemMaterialUI("add",MaterialItemType.FLOAT,true);
			addItems(inBItem);
			
			_titleLabel.text = "Fresnel";
			
		}

		
		
		override public function getData():Object{
			var obj:Object = super.getData();
			return obj;
		}
		
		override public function setData(obj:Object):void{
			super.setData(obj);
		}

	}
}