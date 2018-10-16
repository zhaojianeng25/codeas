package modules.materials.view.mathNode
{
	import modules.materials.view.BaseMaterialNodeUI;
	import modules.materials.view.ItemMaterialUI;
	import modules.materials.view.MaterialItemType;
	
	public class MathStaticNodeUI extends BaseMaterialNodeUI
	{
		private var intItem:ItemMaterialUI;
		private var outItem:ItemMaterialUI;
		public function MathStaticNodeUI()
		{
			super();
			titleBitmap = new phys_marterialCls3;
			addTitleImg();
			this.gap = 20;
			this.width = 162;
			this.height = 80;
		}
		
		protected function initItem():void{
			intItem = new ItemMaterialUI("in",MaterialItemType.FLOAT);
			outItem = new ItemMaterialUI("out",MaterialItemType.FLOAT,false);
			
			addItems(intItem);
			addItems(outItem);
		}
	}
}