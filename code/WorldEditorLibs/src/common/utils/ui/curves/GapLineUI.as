package common.utils.ui.curves
{
	import mx.core.UIComponent;
	
	import spark.components.Label;
	
	import common.utils.frame.BaseComponent;
	
	public class GapLineUI extends BaseComponent
	{
		private var spLine:UIComponent;
		
		private var labels:Label;
		
		public function GapLineUI()
		{
			super();
			
			this.isDefault = false;
			
			spLine = new UIComponent;
			this.addChild(spLine);
			
			spLine.graphics.clear();
			//spLine.graphics.beginFill(0xff0000);
			//spLine.graphics.drawRect(0,0,100,10);
			
			spLine.graphics.lineStyle(1,0x666666);
			spLine.graphics.moveTo(10,4);
			spLine.graphics.lineTo(150,4);
			spLine.graphics.lineStyle(1,0x333333);
			spLine.graphics.moveTo(10,5);
			spLine.graphics.lineTo(150,5);
			
			
		}
		
		public function set lineWidth(value:int):void{
			spLine.graphics.clear();
			
			spLine.graphics.lineStyle(1,0x666666);
			spLine.graphics.moveTo(10,4);
			spLine.graphics.lineTo(value,4);
			spLine.graphics.lineStyle(1,0x333333);
			spLine.graphics.moveTo(10,5);
			spLine.graphics.lineTo(value,5);
		}
		
		private function initLable():void{
			labels = new Label;
			
		}
		
		
		
	}
}