package modules.brower.fileTip
{
	import flash.events.MouseEvent;
	
	import mx.controls.Button;
	
	import common.utils.frame.BaseComponent;
	public class RadiostiyInfoEndBut extends BaseComponent
	{
		private var _btn:Button;
		
		public function RadiostiyInfoEndBut()
		{
			super();

			
			_btn = new Button;
			//_btn.setStyle("top",0);
			//_btn.setStyle("bottom",0);
			_btn.setStyle("paddingTop",0)
			_btn.width = 100;
			_btn.height = 30;
			_btn.setStyle("chromeColor",0xffffff);
			_btn.setStyle("color",0x000000);
			_btn.addEventListener(MouseEvent.CLICK,onClick);
			this.addChild(_btn);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			if(Boolean(changFun)){
				changFun();
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


