package common.utils.ui.txt
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import spark.components.Label;
	
	import common.utils.frame.BaseComponent;
	
	public class TextVec2Input extends BaseComponent
	{
		
		private var _labelTxt:Label;
		
		private var _xLable:TextCtrlInput;
		private var _yLable:TextCtrlInput;
		
		private var _ve2Data:Point;
		
		
		//public var changFun:Function; 
	
		public function set step(value:Number):void
		{
			_xLable.step=value
			_yLable.step=value
		}
		public function TextVec2Input()
		{
			super();
			_ve2Data = new Point;
			
			_labelTxt = new Label;
			_labelTxt.width = baseWidth;
			_labelTxt.setStyle("height","100%");
			_labelTxt.setStyle("color",0x9f9f9f);
			_labelTxt.setStyle("paddingTop",4);
			//_labelTxt.text = "位置:";
			_labelTxt.setStyle("textAlign","right");
			this.addChild(_labelTxt);
			
			_xLable = new TextCtrlInput;
			_xLable.height = 18;
			_xLable.width = 50
			_xLable.label = "X:";
			_xLable.text = "0.0";
			_xLable.gap = 2;
			_xLable.changFun = changNum;
			_xLable.center = false;
			_xLable.x = baseWidth + 5;
			this.addChild(_xLable);
			
			_yLable = new TextCtrlInput;
			_yLable.height = 18;
			_yLable.width = 60
			_yLable.label = "Y:";
			_yLable.text = "0.0";
			_xLable.gap = 2;
			_yLable.changFun = changNum;
			_yLable.center = false;
			_yLable.x = baseWidth + 55;
			this.addChild(_yLable);
			
		}
		
	

		public function get ve2Data():Point
		{
			_ve2Data.setTo(Number(_xLable.text),Number(_yLable.text));
			return _ve2Data;
		}

		public function set ve2Data(value:Point):void
		{
			_ve2Data = value;
			_xLable.text = String(_ve2Data.x);
			_yLable.text = String(_ve2Data.y);
		}

		override public function refreshViewValue():void{
			var p:Point;
			
			if(FunKey){
				if(target){
					p = target[FunKey];
				}else{
					return;
				}
			}else{
				p = getFun();
			}
			
//			if(p.equals(_ve2Data)){
//				return;
//			}
			_ve2Data = p;
			
			_xLable.text = String(p.x);
			_yLable.text = String(p.y);
		}
		
		override public function set label(value:String):void{
			_labelTxt.text = value;
		}
		
		public function set maxNum(value:Number):void
		{
			_xLable.maxNum=value
			_yLable.maxNum=value
			
		}
		public function set minNum(value:Number):void
		{
			_xLable.minNum=value
			_yLable.minNum=value
		}
		
		
		public function changNum(value:Number = 0):void{
			
			_ve2Data.setTo(Number(_xLable.text),Number(_yLable.text));
			
			if(Boolean(changFun)){
				changFun(_ve2Data);
			}
			
			if(FunKey && target){
				target[FunKey] = _ve2Data;
			}
			
			this.dispatchEvent(new Event(Event.CHANGE));
			
		}

	}
}