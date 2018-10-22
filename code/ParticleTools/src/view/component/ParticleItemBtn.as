package view.component
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	
	import spark.components.Label;
	import spark.components.TextInput;
	
	
	public class ParticleItemBtn extends Canvas
	{
		private var _selected:Boolean;
		private var _show:Boolean = true;
		private var typeUI:UIComponent;
		private var _type:int;
		private var _labelTxt:Label;
		private var showUI:UIComponent;
		private var _txt:TextInput;
		public function ParticleItemBtn()
		{
			super();
			this.setStyle("backgroundColor",0xa8a8a8);
			this.setStyle("borderStyle","solid");
			this.setStyle("borderColor",0x333333);
			this.width = 130;
			this.height = 20;
			typeUI = new UIComponent;
			this.addChild(typeUI);
			
			_labelTxt = new Label;
			_labelTxt.width = 120;
			_labelTxt.height = 20;
			_labelTxt.x = 10;
			_labelTxt.setStyle("color",0xffffff);
			_labelTxt.setStyle("paddingTop",4);
			_labelTxt.filters = [new DropShadowFilter(2,45,0,0.5,1,1,2)]
			this.addChild(_labelTxt);
			initRenameTxt();
			
			showUI = new UIComponent;
			showUI.x = 115;
			showUI.y = 6;
			this.addChild(showUI);
			drawShowui();
			showUI.addEventListener(MouseEvent.CLICK,onShowClick)
			
			this.horizontalScrollPolicy = "off";
			this.verticalScrollPolicy = "off";
			
		}
		
		private function initRenameTxt():void{
			_txt = new TextInput;
			_txt.width = 120;
			_txt.height = 20;
			_txt.x = 10;
			_txt.setStyle("color",0xffffff);
			_txt.setStyle("paddingTop",4);
			_txt.filters = [new DropShadowFilter(2,45,0,0.5,1,1,2)]
			_txt.setStyle("contentBackgroundColor",0x404040);
			_txt.setStyle("borderVisible",false);
		}
		
		public function showRename():void{
			this.addChild(_txt);
			_labelTxt.visible = false;
			_txt.text = _labelTxt.text;
		}
		
		protected function onShowClick(event:MouseEvent):void
		{
			isShow = !_isShow;
			this.dispatchEvent(new Event(Event.CHANGE))
		}
		
		private function drawUI(color:uint):void{
			typeUI.graphics.clear();
			typeUI.graphics.beginFill(color,0.5);
			typeUI.graphics.drawRect(0,0,6,18);
			typeUI.graphics.endFill();
		}
		
		private function drawShowui():void{
			showUI.graphics.clear();
			showUI.graphics.lineStyle(1,0);
			if(_isShow){
				showUI.graphics.beginFill(0xffff00,1);
			}else{
				showUI.graphics.beginFill(0xffff00,0);
			}
			showUI.graphics.drawRect(0,0,8,8);
			showUI.graphics.endFill();
		}
		
		override public function set label(value:String):void{
			_labelTxt.text = value;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			_selected = value;
			if(_selected){
				this.setStyle("backgroundColor",0xbe9494);
			}else{
				this.setStyle("backgroundColor",0xa8a8a8);
			}
		}
		
		private var _isShow:Boolean = true;

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
			if(_type == 1){
				drawUI(0xff0000);
			}else if(_type == 3){
				drawUI(0x0000ff);
			}else if(_type == 18){
				drawUI(0x00ff00);
			}else if(_type == 14){
				drawUI(0xff00ff);
			}else if(_type == 4){
				drawUI(0xffff00);
			}else if(_type == 7){
				drawUI(0x00ffff);
			}else if(_type == 9){
				drawUI(0xFF8E00);
			}else if(_type == 13){
				drawUI(0xFF0098);
			}
		}

		public function get isShow():Boolean
		{
			return _isShow;
		}

		public function set isShow(value:Boolean):void
		{
			_isShow = value;
			drawShowui();
		}


	}
}