package common.utils.ui.tab
{
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.core.UIComponent;
	
	import common.utils.frame.BasePanel;

	
	public class TabButton extends Canvas
	{
		private var _label:Label;
		
		private var _selected:Boolean;
		
		private var _shape:UIComponent;
		
		public var _baseWidth:int = 60;
		private var _baseHeight:int = 20;
		
		public var panel:BasePanel;
		public function TabButton()
		{
			super();
			
			this.width = _baseWidth;
			this.height = _baseHeight;
			this.setStyle("backgroundColor",0x212121);
			
			_label = new Label();
			_label.width = _baseWidth;
			_label.height = _baseHeight;
			_label.setStyle("textAlign","center");
			_label.setStyle("verticalAlign","middle");
			_label.setStyle("color",0xb0b0b0);
			_label.text = "属性";
			this.addChild(_label);
			
			_shape = new UIComponent;
			this.addChild(_shape);
			
			this.addEventListener(MouseEvent.MOUSE_OVER,onOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,onOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
		}
		
		protected function onDown(event:MouseEvent):void
		{
			this.setFocus();
		}
		
		protected function onOut(event:MouseEvent):void
		{
			this.selected = _selected;
		}
		
		protected function onOver(event:MouseEvent):void
		{
			if(this.selected){
				return;
			}
			this.setStyle("backgroundColor",0x626262);
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		override public function set label(value:String):void{
			_label.text = value;
		}
		
		override public function get label():String{
			return _label.text;
		}

		public function set selected(value:Boolean):void
		{
			_selected = value;
			
			_shape.graphics.clear();
			_shape.graphics.lineStyle(1,0x151515);
			_shape.graphics.moveTo(0,0);
			_shape.graphics.lineTo(0,_baseHeight);
			
			_shape.graphics.moveTo(_baseWidth,0);
			_shape.graphics.lineTo(_baseWidth,_baseHeight);
			if(!value){
				_shape.graphics.moveTo(0,_baseHeight);
				_shape.graphics.lineTo(_baseWidth,_baseHeight);
				this.setStyle("backgroundColor",0x212121);
			}else{
				this.setStyle("backgroundColor",0x404040);
			}
			
			
		}

	}
}