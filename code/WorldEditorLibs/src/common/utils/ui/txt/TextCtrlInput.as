package common.utils.ui.txt
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import spark.components.Label;
	import spark.components.TextInput;
	import spark.events.TextOperationEvent;
	
	import common.utils.frame.BaseComponent;
	
	
	
	public class TextCtrlInput extends BaseComponent
	{
		private var _txt:TextInput;
		private var _sp:UIComponent;
		private var _labelTxt:Label;
		
		
		private var _mousepx:Number;
		
		public var step:Number = 1;
		
		private var _maxNum:Number = int.MAX_VALUE;
		private var _minNum:Number = int.MIN_VALUE;
		
		public var getMaxFun:Function;
		public var getMinFun:Function;
		
		private var _center:Boolean;
		
		private var _gap:int = 5;
		
		public function TextCtrlInput()
		{
			super();
			
			_txt = new TextInput;
			_txt.setStyle("top",0);
			_txt.setStyle("bottom",0);
			_txt.setStyle("contentBackgroundColor",0x404040);
			_txt.setStyle("borderVisible",false);
			_txt.setStyle("color",0x9f9f9f);
			_txt.setStyle("textDecoration","underline");
			_txt.setStyle("paddingTop",4);
			//_txt.x = 100;
			this.addChild(_txt);
			_txt.addEventListener(FocusEvent.FOCUS_OUT,onTxtFocusOut);
			_txt.addEventListener(Event.CHANGE,onChange);
			_txt.addEventListener(TextEvent.TEXT_INPUT,onInput);
			_txt.addEventListener(FlexEvent.ENTER,onKey);
			_txt.restrict = "0-9.\\-"
			
			_sp = new UIComponent;
			_sp.mouseEnabled = true;
			_sp.mouseChildren = true;
			this.addChild(_sp);
			_sp.addEventListener(MouseEvent.CLICK,onSpClick);
			_sp.addEventListener(MouseEvent.MOUSE_OVER,onOver);
			_sp.addEventListener(MouseEvent.MOUSE_OUT,onOut);
			_sp.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			
			this.addEventListener(Event.ADDED_TO_STAGE,onSize);
			this.addEventListener(ResizeEvent.RESIZE,onSize);
			//this.addEventListener(KeyboardEvent.KEY_DOWN,onKey);
			
			_labelTxt = new Label;
			_labelTxt.setStyle("top",0);
			_labelTxt.setStyle("bottom",0);
			_labelTxt.setStyle("color",0x9f9f9f);
			_labelTxt.setStyle("paddingTop",4);
			//_labelTxt.addEventListener(MouseEvent.CLICK,onLabelClick);
			//_labelTxt.setStyle("textAlign","right");
			//_labelTxt.width = 95;
			
			this.setStyle("horizontalScrollPolicy","off");
			this.setStyle("verticalScrollPolicy","off");
		}

		override public function refreshViewValue():void{
			var newStr:String;
			if(FunKey){
				if(target){
					newStr = target[FunKey];
				}else{
					return;
				}
			}else{
				newStr = getFun();
			}
			if(this.text != newStr){
				this.text = newStr;
			}
			
			if(Boolean(getMaxFun)){
				this.maxNum = getMaxFun();
			}
			
			if(Boolean(getMinFun)){
				this.minNum = getMinFun();
			}
			
		}
		
		protected function onInput(event:TextEvent):void
		{
			_txt.width = _txt.measureText(_txt.text).width + 10;
		}
		
		protected function onChange(event:TextOperationEvent):void
		{
			this.dispatchEvent(new TextEvent(Event.CHANGE));
			if(FunKey && target){
				target[FunKey] = text;
			}
			if(Boolean(changFun)){
				changFun(text);
			}
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			_mousepx = stage.mouseX;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
		}
		
		protected function onStageMouseUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
		}
		
		protected function onStageMouseMove(event:MouseEvent):void
		{
			var num:Number = stage.mouseX - _mousepx;
			var rnum:Number = Number(text) + num * step;
			rnum = int(rnum * 100)/100
			this.text = String(rnum);
			_mousepx = stage.mouseX;
			this.dispatchEvent(new TextEvent(Event.CHANGE));
			if(FunKey && target){
				target[FunKey] = text;
			}
			if(Boolean(changFun)){
				changFun(text);
			}
			
			this.dispatchEvent(new TextEvent(Event.CHANGE));
		}
		
		protected function onOut(event:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.AUTO;
		}
		
		protected function onOver(event:MouseEvent):void
		{
			Mouse.cursor = "doubelArrow";
			//trace("doubelArrow")
		}
		
		protected function onKey(event:FlexEvent):void
		{
				//GameUIInstance.uiContainer.setFocus();
				//_labelTxt.dispatchEvent(new MouseEvent(MouseEvent.CLICK))
				//GameUIInstance.txt.setFocus();
				_labelTxt.setFocus();
				_txt.editable = false;
				onTxtFocusOut();
		}
		
		protected function onTxtFocusOut(event:FocusEvent = null):void
		{
			_sp.visible = true;
			
			_txt.setStyle("contentBackgroundColor",0x404040);
			_txt.setStyle("textDecoration","underline");
			_txt.setStyle("borderVisible",false);
			
		}
		
		protected function onSpClick(event:MouseEvent):void
		{
			_txt.editable = true;
			_txt.setFocus();
			_sp.visible = false;
			
			_txt.setStyle("contentBackgroundColor",0xffffff);
			_txt.setStyle("textDecoration","none");
			_txt.setStyle("borderVisible",true);
		}
		
		protected function onSize(event:Event):void
		{
			_sp.graphics.clear();
			_sp.graphics.beginFill(0xff0000,0.0);
			_sp.graphics.drawRect(0,0,this.width,this.height);
			_sp.graphics.endFill();
		}

		public function get text():String
		{
			return _txt.text;
		}

		public function set text(value:String):void
		{
			if(!(_maxNum == int.MAX_VALUE && _minNum == int.MIN_VALUE)){
				if(Number(value) > _maxNum){
					_txt.text = _maxNum.toString();
				}else if(Number(value) < _minNum){
					_txt.text = _minNum.toString();
				}else{
					_txt.text = value;
				}
			}else{
				_txt.text = value;
			}
			_txt.width = _txt.measureText(value).width + 10;
		}

		override public function get label():String
		{
			return _labelTxt.text;
		}

		override public function set label(value:String):void
		{
			_labelTxt.text = value;
			
			if(!_labelTxt.parent){
				this.addChild(_labelTxt);
			}
			//_labelTxt.setStyle("width","100%");
			//_txt.setStyle("left",_labelTxt.measureText(value).width + 10);
			//_txt.width = _labelTxt.measureText(value).width + 20;
			
			if(_center){
				if(_labelTxt.measureText(value).width > baseWidth){
					_labelTxt.width = _labelTxt.measureText(value).width;
					_txt.x = _labelTxt.measureText(value).width + 5;
				}
			}
		}
		
		public function set tip(value:String):void{
			_labelTxt.toolTip = value;
		}

		public function get maxNum():Number
		{
			return _maxNum;
		}

		public function set maxNum(value:Number):void
		{
			_maxNum = value;
		}

		public function get minNum():Number
		{
			return _minNum;
		}

		public function set minNum(value:Number):void
		{
			_minNum = value;
		}

		public function get center():Boolean
		{
			return _center;
		}

		public function set center(value:Boolean):void
		{
			_center = value;
			if(value){
				_labelTxt.width = baseWidth;
				_txt.x = baseWidth + _gap;
				_labelTxt.setStyle("textAlign","right");
			}else{
				_labelTxt.setStyle("left",0);
				//_labelTxt.setStyle("right",0);
				
				_txt.setStyle("left",_labelTxt.measureText(_labelTxt.text).width + _gap);
				//_txt.setStyle("right",0);	
				_labelTxt.setStyle("textAlign","left");
			}
		}

		public function get gap():int
		{
			return _gap;
		}

		public function set gap(value:int):void
		{
			_gap = value;
			
			if(_center){
				_labelTxt.width = baseWidth;
				_txt.x = baseWidth + _gap;
				_labelTxt.setStyle("textAlign","right");
			}else{
				_labelTxt.setStyle("left",0);
				
				_txt.setStyle("left",_labelTxt.measureText(_labelTxt.text).width + _gap);
				_labelTxt.setStyle("textAlign","left");
			}
		}
		
		
		
		
		
		
	}
}