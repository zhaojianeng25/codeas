package common.utils.ui.curves
{
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import materials.DynamicTexItem;

	public class TextCurvesTexUI extends TextCurvesUI
	{
		private var bmp:BitmapData;
		private var _tex:DynamicTexItem;
		public function TextCurvesTexUI()
		{
			super();
		}
		
		override public function refreshViewValue():void{
			if(FunKey){
				if(target){
					_tex = target[FunKey];
					_curve = _tex.curve;
				}else{
					return;
				}
			}else{
				_tex = getFun();
			}
			
			drawSp();
		}
		
		override public function setCurveData():void{
			
			this.dispatchEvent(new Event(Event.CHANGE));
		}
	}
}