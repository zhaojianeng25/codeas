package common.utils.ui.txt
{
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import spark.components.Label;
	
	import common.utils.frame.BaseComponent;
	
	public class TextVec3Input extends BaseComponent
	{
		
		private var _labelTxt:Label;
		
		private var _xLable:TextCtrlInput;
		private var _yLable:TextCtrlInput;
		private var _zLable:TextCtrlInput;
		private var _wLable:TextCtrlInput;
		
		private var _ve3Data:Vector3D;
		
		private  var _step:Number = 1;
		//public var changFun:Function;
		
		public function TextVec3Input()
		{
			super();
			_ve3Data = new Vector3D;
			
			_labelTxt = new Label;
			_labelTxt.width = baseWidth;
			_labelTxt.setStyle("height","100%");
			_labelTxt.setStyle("color",0x9f9f9f);
			_labelTxt.setStyle("paddingTop",4);
			_labelTxt.setStyle("textAlign","right");
			this.addChild(_labelTxt);
			
			_xLable = new TextCtrlInput;
			_xLable.height = 18;
			_xLable.width = 36;
			_xLable.label = "X:";
			_xLable.gap = 2;
			_xLable.text = "0.0";
			_xLable.changFun = changNum;
			_xLable.center = false;
			_xLable.x = baseWidth + 5;//100;
			this.addChild(_xLable);
			
			_yLable = new TextCtrlInput;
			_yLable.height = 18;
			_yLable.width = 36
			_yLable.label = "Y:";
			_yLable.gap = 2;
			_yLable.text = "0.0";
			_yLable.changFun = changNum;
			_yLable.center = false;
			_yLable.x = baseWidth + 45//160;
			this.addChild(_yLable);
			
			_zLable = new TextCtrlInput;
			_zLable.height = 18;
			_zLable.width = 36
			_zLable.label = "Z:";
			_zLable.gap = 2;
			_zLable.text = "0.0";
			_zLable.changFun = changNum;
			_zLable.center = false;
			_zLable.x = baseWidth + 85//220;
			this.addChild(_zLable);
			
			_wLable = new TextCtrlInput;
			_wLable.height = 18;
			_wLable.width = 36
			_wLable.label = "W:";
			_wLable.gap = 2;
			_wLable.text = "0.0";
			_wLable.changFun = changNum;
			_wLable.center = false;
			_wLable.x = baseWidth + 125//220;
			_wLable.visible = false;
			this.addChild(_wLable);
			
		}
		
		public function showW():void{
			_wLable.visible = true;
		}
		
		public function set step(value:Number):void
		{
			_step = value;
			
			_xLable.step=_step
			_yLable.step=_step
			_zLable.step=_step
			_wLable.step=_step
		}

		override public function refreshViewValue():void{
			
			var v3d:Vector3D
			if(FunKey){
				if(target){
					v3d = target[FunKey];
				}else{
					return;
				}
			}else{
				v3d = getFun();
			}
			
			_ve3Data = v3d;
			_xLable.text = String(v3d.x);
			_yLable.text = String(v3d.y);
			_zLable.text = String(v3d.z);
			_wLable.text = String(v3d.w);
		}
		
		override public function set label(value:String):void{
			_labelTxt.text = value;
		}
		
		
		public function get ve3Data():Vector3D
		{
			return _ve3Data;
		}

		public function set ve3Data(value:Vector3D):void
		{
			_ve3Data = value
			_xLable.text = String(_ve3Data.x);
			_yLable.text = String(_ve3Data.y);
			_zLable.text = String(_ve3Data.z);
			_wLable.text = String(_ve3Data.w);
		}
		
		public function changNum(value:Number = 0):void{
			
			var $v:Vector3D=_ve3Data.clone()
			$v.setTo(Number(_xLable.text),Number(_yLable.text),Number(_zLable.text));
			$v.w = Number(_wLable.text);
			
			_ve3Data.setTo($v.x,$v.y,$v.z);
			_ve3Data.w = $v.w;
			
			if(Boolean(changFun)){
				changFun($v);
			}
			if(FunKey && target){
				target[FunKey] = $v;
			}
			
			this.dispatchEvent(new Event(Event.CHANGE));
			
		}

	}
}