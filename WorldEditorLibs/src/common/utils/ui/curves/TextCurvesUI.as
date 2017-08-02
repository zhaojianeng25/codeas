package common.utils.ui.curves
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;
	
	import spark.components.Label;
	
	import common.utils.frame.BaseComponent;
	
	import curves.Curve;
	
	public class TextCurvesUI extends BaseComponent
	{
		private var _labelTxt:Label;
		protected var _curve:Curve;
		private var _sp:UIComponent;
		public function TextCurvesUI()
		{
			super();
			
			_labelTxt = new Label;
			//_labelTxt.setStyle("top",0);
			//_labelTxt.setStyle("bottom",0);
			_labelTxt.setStyle("color",0x9f9f9f);
			_labelTxt.setStyle("paddingTop",4);
			_labelTxt.setStyle("textAlign","right");
			_labelTxt.width = baseWidth;
			this.addChild(_labelTxt);
			//_labelTxt.text = "12344123"
			
			_sp = new UIComponent;
			_sp.x = baseWidth + 5;
			_sp.y = 6;
			_sp.buttonMode = true;
			_sp.addEventListener(MouseEvent.CLICK,onClick);
			this.addChild(_sp);
			
			this.height = 20;
		}
		
		protected function onClick(event:MouseEvent):void
		{
			CurvesUI.getInstance().show(setCurveData,_curve);
		}
		
		public function setCurveData():void{
			//trace("curvedata changing")
			this.dispatchEvent(new Event(Event.CHANGE));
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
		
		override public function refreshViewValue():void{
			if(FunKey){
				if(target){
					_curve = target[FunKey];
				}else{
					return;
				}
			}else{
				_curve = getFun();
			}
			
			drawSp();
		}
		/**
		 * 绘制点颜色 
		 * 
		 */		
		public function drawSp():void{
			_sp.graphics.clear();
			_sp.graphics.lineStyle(1,0x9f9f9f);
			
			_sp.graphics.beginFill(0xff0000);//r
			_sp.graphics.drawRect(0,0,6,6);
			
			if(_curve.type == 2){
				_sp.graphics.beginFill(0x00ff00);//g
				_sp.graphics.drawRect(6,0,6,6);
			}else if(_curve.type == 3){
				_sp.graphics.beginFill(0x00ff00);//g
				_sp.graphics.drawRect(6,0,6,6);
				
				_sp.graphics.beginFill(0x0000ff);//b
				_sp.graphics.drawRect(12,0,6,6);
			}else if(_curve.type == 4){
				_sp.graphics.beginFill(0x00ff00);//g
				_sp.graphics.drawRect(6,0,6,6);
				
				_sp.graphics.beginFill(0x0000ff);//b
				_sp.graphics.drawRect(12,0,6,6);
				
				_sp.graphics.beginFill(0x999999);//a
				_sp.graphics.drawRect(18,0,6,6);
			}
			
			_sp.graphics.endFill();
			
		}

		public function get curve():Curve
		{
			return _curve;
		}

		public function set curve(value:Curve):void
		{
			_curve = value;
		}

		
	}
}