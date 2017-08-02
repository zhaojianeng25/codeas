package common.utils.ui.cbox
{
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;
	
	import spark.components.Label;
	
	import common.utils.frame.BaseComponent;
	
	public class ComLabelBox extends BaseComponent
	{
		private var _labelTxt:Label;
		private var _txt:Label;
		
		private var sp:UIComponent;
		
		private var _menuFile:NativeMenu;
		
		private var _data:Array;
		
		//public var changFun:Function;
		
		private var _selectIndex:int;
		
		private var _isLabelData:Boolean;
		
		public function ComLabelBox()
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
			_labelTxt.text = "抗锯齿";
			
			sp = new UIComponent;
			//sp.setStyle("left",baseWidth + 5);
			//sp.setStyle("right",0);
			//sp.setStyle("top",0);
			//sp.setStyle("bottom",0);
			this.addChild(sp);
			
			_txt = new Label;
			//_txt.setStyle("left",baseWidth + 7);
			//_txt.setStyle("right",0);
			//_txt.setStyle("top",0);
			//_txt.setStyle("bottom",0);
			_txt.setStyle("color",0x9f9f9f);
			_txt.setStyle("paddingTop",4);
			_txt.mouseEnabled = false;
			_txt.mouseChildren = false;

			
			this.addChild(_txt);
			//_txt.text = "phong";
			
			_menuFile = new NativeMenu;
			
			this.addEventListener(Event.ADDED_TO_STAGE,drawSp);
			this.addEventListener(ResizeEvent.RESIZE,drawSp);
			
			sp.addEventListener(MouseEvent.CLICK,onClick); 
			sp.addEventListener(MouseEvent.MOUSE_OVER,onOver);
			sp.addEventListener(MouseEvent.MOUSE_OUT,onOut); 
			
			this.data = [{name:"None"},{name:"2×"},{name:"4×"},{name:"16×"}]
		}
		
		override public function refreshViewValue():void{
			var obj:Object;
			if(_isLabelData){
				if(FunKey && target){
					obj = getObj(target[FunKey]);
				}
				if(obj){
					text = obj.name;
				}else{
					text="  "
				}
			}else{
				obj = _data[getFun()];
				if(_txt.text == obj.name){
					return;
				}
				text = obj.name;
			}
			
		}
		
		public function getObj(s:*):Object{
			for(var i:int;i<_data.length;i++){
				if(_data[i].data == s){
					return _data[i];
				}
			}
			return null;
		}
		
		protected function onOut(event:MouseEvent):void
		{
			drawSp();
		}
		
		protected function onOver(event:MouseEvent):void
		{
			drawSp(null,1);
		}
		
		override public function set data(value:Object):void{
			this._data = value as Array;
			
			var items:Array = new Array;
			for(var i:int;i<_data.length;i++){
				var item:NativeMenuItem = new NativeMenuItem(_data[i].name);  
				item.data = _data[i];
				items.push(item);
				item.addEventListener(Event.SELECT,onMenuItem);
			}
			
			_menuFile.items = items;
			
			if(_data.length){
				text = _data[selectIndex].name;
			}

		}
		
		public function set labelData(value:Object):void{
			_isLabelData = true;
			this.data = value;
//			this._data = value as Array;
//			var items:Array = new Array;
//			for(var i:int;i<_data.length;i++){
//				var item:NativeMenuItem = new NativeMenuItem(_data[i]);  
//				item.data = _data[i];
//				items.push(item);
//				item.addEventListener(Event.SELECT,onMenuItem);
//			}
//			
//			_menuFile.items = items;
//			text = _data[0];
		}
		
		public function set tip(value:String):void{
			_labelTxt.toolTip = value;
		}
		
		protected function onMenuItem(event:Event):void
		{
			
			var obj:Object = event.target.data;
			
			var index:int = this._data.indexOf(obj);
			_selectIndex = index;
			
			if(_isLabelData){
				text = obj.name;
				if(FunKey && target){
					target[FunKey] = obj.data;
				}
			}else{
				text = obj.name;
				if(Boolean(changFun)){
					changFun(obj);
				}
			}
			
			
		}		
		
		private function drawSp(event:Event = null,alpha:Number = 0):void{
			sp.graphics.clear();
			sp.graphics.lineStyle(1,0x696969);
			sp.graphics.beginFill(0x303030,alpha);
			
			var w:int = _txt.measureText(_txt.text).width + 5;
			
			sp.graphics.drawRect(0,0,w,this.height);
			sp.graphics.endFill();
		}
		
		public function set text(value:String):void{
			_txt.text = value;
			drawSp();
		}
		
		override public function set label(value:String):void{
			_labelTxt.text = value;
			
			if(_labelTxt.measureText(value).width > baseWidth){
				_labelTxt.width = _labelTxt.measureText(value).width;
				sp.x = _labelTxt.measureText(value).width + 5;
				_txt.x = sp.x + 2;
			}else{
				sp.x = baseWidth+2;
				_txt.x = sp.x + 2;
			}
		}
		
		protected function onClick(event:MouseEvent):void
		{
			_menuFile.display(this.stage,stage.mouseX,stage.mouseY);
		}

		public function get selectIndex():int
		{
			return _selectIndex;
		}

		public function set selectIndex(value:int):void
		{
			_selectIndex = value;
			
			if(_data && _data.length > value){
				text = _data[value].name;
			}
			
		}
		
		public function get selectData():Object{
			return _data[_selectIndex];
		}
		
		public function set selectItem(value:String):void{
			for(var i:int;i<_data.length;i++){
				if(_data[i].name == value){
					selectIndex = i;
					break;
				}
			}
		}

	}
}