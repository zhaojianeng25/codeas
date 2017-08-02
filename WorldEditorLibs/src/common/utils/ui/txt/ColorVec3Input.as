package common.utils.ui.txt
{
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import mx.events.ResizeEvent;
	
	import _Pan3D.core.MathCore;
	
	import common.utils.frame.BaseComponent;
	import common.utils.ui.color.ColorPickers;
	
	public class ColorVec3Input extends BaseComponent
	{
		private var _txt:TextVec3Input;
		private var _color:ColorPickers;
		public function ColorVec3Input()
		{
			super();
			
			_txt = new TextVec3Input;
			_txt.changFun = changeTxt;
			_color = new ColorPickers;
			_color.changFun = changColor;
			this.isDefault = false;
			this.addChild(_txt);
			this.addChild(_color);
			_color.y = 20;
			_color.setColorValue(0);
			this.height = 40;
			
			_txt.showW();
			
			this.setStyle("left",0);
			this.setStyle("right",0);
			
			//this.addEventListener(ResizeEvent.RESIZE,onResize);
		}
		
		public function set step(value:Number):void{
			_txt.step = value;
		}
		
		public function changColor($c:int):void{
			var v3d:Vector3D = MathCore.hexToArgb($c);
			_txt.ve3Data = new Vector3D(v3d.x/0xff,v3d.y/0xff,v3d.z/0xff,v3d.w/0xff);
			change(_txt.ve3Data);
		}
		
		public function changeTxt($v3d:Vector3D):void{
			_color.setColorValue( MathCore.argbToHex(($v3d.w > 1 ? 1:$v3d.w) * 0xff,($v3d.x > 1 ? 1:$v3d.x) * 0xff,($v3d.y > 1 ? 1:$v3d.y) * 0xff,($v3d.z > 1 ? 1:$v3d.z) * 0xff) );
			change($v3d);
		}
		
		public function change($v3d:Vector3D):void{
			if(Boolean(changFun)){
				changFun($v3d);
			}
		}
		
		override public function refreshViewValue():void{
			var v3d:Vector3D = getFun();
			_txt.ve3Data = v3d;
			_color.setColorValue(MathCore.argbToHex(v3d.w * 0xff,v3d.x * 0xff,v3d.y * 0xff,v3d.z * 0xff));
		}
		
		override public function set label(value:String):void{
			_txt.label = value;
		}
	}
}