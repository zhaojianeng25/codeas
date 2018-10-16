package view.component
{
	import mx.controls.treeClasses.TreeItemRenderer;
	
	public class RideTreeRender extends TreeItemRenderer
	{
		public function RideTreeRender()
		{
			super();
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			
			this.measuredHeight = 20;
		} 
		override protected function measure():void{
			super.measure();
			measuredHeight = 15;
		}
	}
}