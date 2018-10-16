package common.utils.ui.txt
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.geom.Vector3D;
	
	import spark.components.Label;
	import spark.components.TextInput;
	import spark.events.TextOperationEvent;
	
	import common.GameUIInstance;
	import common.utils.frame.BaseComponent;
	
	
	
	public class TextLabelInput extends BaseComponent
	{
		protected var _txt:TextInput;
		protected var _labelTxt:Label;
		
		public var changImmediately:Boolean;
		
		public function TextLabelInput()	
		{
			super();
			_txt = new TextInput;
			_txt.setStyle("left",0);
			_txt.setStyle("right",0);
			_txt.setStyle("top",0);
			_txt.setStyle("bottom",0);
			_txt.setStyle("contentBackgroundColor",0x404040);
			_txt.setStyle("borderVisible",true);
			_txt.setStyle("color",0x9f9f9f);
			_txt.setStyle("width","100%");
			_txt.setStyle("height","100%");
			//_txt.setStyle("textDecoration","underline");
			_txt.setStyle("paddingTop",4);
			_txt.addEventListener(Event.CHANGE,onChange);
			_txt.addEventListener(FocusEvent.FOCUS_OUT,onFocusOut);
			
			this.addChild(_txt);
			
			

			this.addEventListener(KeyboardEvent.KEY_DOWN,onKey);
			
			_labelTxt = new Label;
			_labelTxt.setStyle("left",0);
			_labelTxt.setStyle("top",0);
			_labelTxt.setStyle("bottom",0);
			_labelTxt.setStyle("height","100%");
			_labelTxt.setStyle("color",0x9f9f9f);
			_labelTxt.setStyle("paddingTop",4);
			//this.addChild(_labelTxt);
			
			this.setStyle("horizontalScrollPolicy","off");
			this.setStyle("verticalScrollPolicy","off");
		}
		
		protected function onFocusOut(event:FocusEvent):void
		{
			applyChange();
		}
		
		protected function onChange(event:TextOperationEvent):void
		{
			if(changImmediately){
				applyChange();
			}
		}		
		
		protected function onKey(event:KeyboardEvent):void
		{
			if(event.keyCode == 13){
				//_txt.focusManager.hideFocus();
				//_txt.focusManager.deactivate();
				//_txt.focusManager.
				GameUIInstance.application.setFocus();
				applyChange();
			}
		}
		
		public function applyChange():void{
			if(Boolean(changFun)){
				changFun(_txt.text);
			}
			if(FunKey && target){
				target[FunKey] = _txt.text;
			}
			this.dispatchEvent(new TextEvent(Event.CHANGE));
		}
		
		override public function refreshViewValue():void{
			
			var str:String
			if(FunKey){
				if(target){
					str = target[FunKey];
				}else{
					return;
				}
			}else{
				str = getFun();
			}
			
			
			_txt.text = str;
			
		}
		
		
		
		
		public function get text():String
		{
			return _txt.text;
		}

		public function set text(value:String):void
		{
			
			_txt.text = value;

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
			
			_txt.setStyle("left",_labelTxt.measureText(value).width + 10);
			
		}

		
		
	}
}