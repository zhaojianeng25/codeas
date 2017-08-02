package common.utils.ui.check
{
	import flash.events.MouseEvent;
	
	import spark.components.CheckBox;
	import spark.components.Label;
	
	import common.utils.frame.BaseComponent;
	
	public class CheckLabelBox extends BaseComponent
	{
		private var _labelTxt:Label;
		
		private var _check:CheckBox;
		
		//public var changFun:Function;
		public function CheckLabelBox()
		{
			super();
			
			_labelTxt = new Label;
			//_labelTxt.setStyle("left",0);
			_labelTxt.setStyle("top",0);
			_labelTxt.setStyle("bottom",0);
			//_labelTxt.setStyle("right",0);
			//_labelTxt.setStyle("height","100%");
			//_labelTxt.setStyle("width","100%");
			_labelTxt.setStyle("color",0x9f9f9f);
			_labelTxt.setStyle("paddingTop",4);
			_labelTxt.setStyle("textAlign","right");
			_labelTxt.width = baseWidth;
			this.addChild(_labelTxt);
			//this.width = 150;
			//this.height = 18;
			//_labelTxt.text = "显示：";
			
			_check = new CheckBox;
			this.addChild(_check);
			_check.x = baseWidth + 5;
			
			_check.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		override public function refreshViewValue():void{
			_check.selected = getFun();
		}
		
		protected function onClick(event:MouseEvent):void
		{
			if(Boolean(changFun)){
				changFun(_check.selected);
			}
		}	
		
		override public function set label(value:String):void{
			_labelTxt.text = value;
			
			if(_labelTxt.measureText(value).width > baseWidth){
				_labelTxt.width = _labelTxt.measureText(value).width;
				_check.x = _labelTxt.measureText(value).width + 5;
			}
		}
		
		
	}
}