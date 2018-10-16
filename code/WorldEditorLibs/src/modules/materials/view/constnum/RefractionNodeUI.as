package modules.materials.view.constnum
{
	import modules.materials.treedata.NodeTree;
	import modules.materials.treedata.nodetype.NodeTreeFresnel;
	import modules.materials.treedata.nodetype.NodeTreeHeightInfo;
	import modules.materials.treedata.nodetype.NodeTreeRefraction;
	import modules.materials.view.BaseMaterialNodeUI;
	import modules.materials.view.ItemMaterialUI;
	import modules.materials.view.MaterialItemType;
	
	public class RefractionNodeUI extends BaseMaterialNodeUI
	{
		private var inItem:ItemMaterialUI;
		
		private var outItem:ItemMaterialUI;
		private var outRItem:ItemMaterialUI;
		private var outGItem:ItemMaterialUI;
		private var outBItem:ItemMaterialUI;
		private var outAItem:ItemMaterialUI;
		public function RefractionNodeUI()
		{
			super();
			titleBitmap = new phys_marterialCls;
			addTitleImg();
			this.gap = 20;
			this.width = 162;
			this.height = 60;
			
			
			nodeTree = new NodeTreeRefraction;
			nodeTree.ui = this;
			nodeTree.type = NodeTree.REFRACTION;
			
			outItem = new ItemMaterialUI("out",MaterialItemType.VEC3,false);
			addItems(outItem);
			
//			outRItem = new ItemMaterialUI("r",MaterialItemType.FLOAT,false);
//			addItems(outRItem);
//			
//			outGItem = new ItemMaterialUI("g",MaterialItemType.FLOAT,false);
//			addItems(outGItem);
//			
//			outBItem = new ItemMaterialUI("b",MaterialItemType.FLOAT,false);
//			addItems(outBItem);
			
			inItem = new ItemMaterialUI("xy",MaterialItemType.VEC2,true);
			addItems(inItem);
			
			_titleLabel.text = "折射";
			
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