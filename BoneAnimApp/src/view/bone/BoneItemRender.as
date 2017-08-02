package view.bone
{
	import flash.events.MouseEvent;
	
	import mx.controls.treeClasses.TreeItemRenderer;
	
	public class BoneItemRender extends TreeItemRenderer
	{
		public function BoneItemRender()
		{
			super();
			this.addEventListener(MouseEvent.RIGHT_CLICK,onRightMouse);
		}
		
		protected function onRightMouse(event:MouseEvent):void
		{
			
			
		}
	}
}