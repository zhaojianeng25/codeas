package common.utils.ui.color
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import mx.core.UIComponent;
	
	import spark.components.Label;
	
	import _Pan3D.core.MathCore;
	
	import common.GameUIInstance;
	import common.utils.frame.BaseComponent;
	
	public class ColorPickers extends BaseComponent
	{
		private var _labelTxt:Label;
		private var _sp:UIComponent;
		private var _shape:Shape;
		
		private var _color:uint = 0xffffffff;
		
		//public var changeFun:Function;
		
		[Embed(source="assets/icon/Background_color.png")]
		private var bgImgCls:Class;
		
		public function ColorPickers()
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
			
			//this.setStyle("horizontalScrollPolicy","off");
			//this.setStyle("verticalScrollPolicy","off");
			
			//this.width = 120;
			//this.height = 20;
			
			_sp = new UIComponent;
			this.addChild(_sp);
			_sp.addEventListener(MouseEvent.CLICK,onClick);
			_sp.x = baseWidth + 5;
			
			var bgImg:Bitmap = new bgImgCls();
			bgImg.width = 51;
			bgImg.height = 18;
			_sp.addChild(bgImg);
			
			_shape = new Shape;
			_sp.addChild(_shape);
			
			showSp();
		}
		
		override public function refreshViewValue():void{
			var newColor:int;
			
			if(FunKey){
				if(target){
					newColor = target[FunKey];
				}else{
					return;
				}
			}else{
				newColor = getFun();
			}
			
			
			if(newColor == _color){
				return;
			}
			_color = newColor;
			showSp();
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var point:Point = new Point(100,30);
			point = this.localToGlobal(point);
			point.x += GameUIInstance.application.x;
			point.y += GameUIInstance.application.y;
			ColorChooser.getInstance().show(setColor,point,color);
			this.setFocus();
		}
		
		private function setColor(value:int):void{
			color = value;
		}
		
		public function setColorValue(value:uint):void{
			_color = value;
			showSp();
		}
		
		override public function get label():String
		{
			return _labelTxt.text;
		}
		
		override public function set label(value:String):void
		{
			_labelTxt.text = value;
			
			if(_labelTxt.measureText(value).width > baseWidth){
				_labelTxt.width = _labelTxt.measureText(value).width;
				_sp.x = _labelTxt.measureText(value).width + 5;
			}
		}
		
		private function showSp():void{
			
			var _cv:Vector3D = MathCore.hexToArgb(_color);
			var _c3c:uint = MathCore.argbToHex16(_cv.x,_cv.y,_cv.z);
			
			_shape.graphics.clear();
			_shape.graphics.beginFill(_c3c,_cv.w/0xff);
			_shape.graphics.lineStyle(1,0x9f9f9f);
			_shape.graphics.drawRect(0,0,50,18);
			_shape.graphics.endFill();
		}

		public function get color():uint
		{
			return _color;
		}

		public function set color(value:uint):void
		{
			_color = value;
			showSp();
			
			if(Boolean(changFun)){
				changFun(value);
			}
			
			if(FunKey && target){
				target[FunKey] = _color;
			}
			
		}

	}
}