package mvc.top
{
	import mx.core.UIComponent;
	
	import common.utils.frame.BasePanel;
	
	public class TopPanel extends BasePanel
	{
		private var _bg:UIComponent;
		public function TopPanel()
		{
			super();
			//this.setStyle("backgroundColor",0x404040);
			this.setStyle("borderColor",0x151515);
			this.setStyle("borderStyle","solid");
			this.setStyle("borderVisible",true);
			this.horizontalScrollPolicy = "off";
			
			this.width=600;
			this.height=200;
			
			addBack()
			
		}
		
		private function addBack():void
		{
			_bg = new UIComponent;
			this.addChild(_bg);
			
			
		}
		private function drawback():void{
			
			
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x404040,1);
			_bg.graphics.drawRect(0,0,this.width,this.height);
			_bg.graphics.endFill();
			
			
		}
	}
}