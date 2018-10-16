package common.utils.ui.btn
{
	
	import flash.events.MouseEvent;
	
	import mx.controls.Button;
	
	import common.utils.frame.BaseComponent;
	
	public class LButton extends BaseComponent
	{
		private var _btn:Button;
		
		
		public function LButton()
		{
			super();
			
			_btn = new Button;
			//_btn.setStyle("top",0);
			//_btn.setStyle("bottom",0);
			_btn.setStyle("paddingTop",-2)
			_btn.height = 20;
			_btn.x = baseWidth + 5;
			_btn.setStyle("chromeColor",0x2d2d2d);
			_btn.setStyle("color",0x9f9f9f);
			_btn.addEventListener(MouseEvent.CLICK,onClick);
			this.addChild(_btn);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			if(Boolean(changFun)){
				changFun();
			}
			if(target&&FunKey){
				target[FunKey]=1
			}
		}
		
		override public function get label():String
		{
			return _btn.label;
		}

		override public function set label(value:String):void
		{
			_btn.label = value;
		}

	}
}