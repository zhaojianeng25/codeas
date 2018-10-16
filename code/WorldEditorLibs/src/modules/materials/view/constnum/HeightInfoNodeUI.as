package modules.materials.view.constnum
{
	import modules.materials.treedata.NodeTree;
	import modules.materials.treedata.nodetype.NodeTreeFloat;
	import modules.materials.treedata.nodetype.NodeTreeHeightInfo;
	import modules.materials.treedata.nodetype.NodeTreeTime;
	import modules.materials.view.BaseMaterialNodeUI;
	import modules.materials.view.ItemMaterialUI;
	import modules.materials.view.MaterialItemType;
	
	public class HeightInfoNodeUI extends BaseMaterialNodeUI
	{
		private var inItem:ItemMaterialUI;
		
		private var outItem:ItemMaterialUI;
		private var outRItem:ItemMaterialUI;
		private var outGItem:ItemMaterialUI;
		private var outBItem:ItemMaterialUI;
		private var outAItem:ItemMaterialUI;
		public function HeightInfoNodeUI()
		{
			super();
			titleBitmap = new phys_marterialCls;
			addTitleImg();
			this.gap = 20;
			this.width = 162;
			this.height = 150;
			
			
			nodeTree = new NodeTreeHeightInfo;
			nodeTree.ui = this;
			nodeTree.type = NodeTree.HEIGHTINFO;
			
			outItem = new ItemMaterialUI("out",MaterialItemType.VEC3,false);
			addItems(outItem);
			
			outRItem = new ItemMaterialUI("r",MaterialItemType.FLOAT,false);
			addItems(outRItem);
			
			outGItem = new ItemMaterialUI("g",MaterialItemType.FLOAT,false);
			addItems(outGItem);
			
			outBItem = new ItemMaterialUI("b",MaterialItemType.FLOAT,false);
			addItems(outBItem);
			
			outAItem = new ItemMaterialUI("a",MaterialItemType.FLOAT,false);
			addItems(outAItem);
			
			inItem = new ItemMaterialUI("xy",MaterialItemType.VEC2,true);
			addItems(inItem);
			
			_titleLabel.text = "高度";
			
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