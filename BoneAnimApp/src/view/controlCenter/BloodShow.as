package view.controlCenter
{
	import com.greensock.TweenLite;
	
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	
	import _Pan3D.core.MathCore;

	public class BloodShow
	{
		private var _stage:Stage;
		private var _txt:TextField;
		
		public function BloodShow($stage:Stage)
		{
			this._stage = $stage;
			this.init();
		}
		
		public function show($pos:Object):void{
			var p:Point = MathCore.mathWorld3DPosto2DView(new Vector3D($pos.x,$pos.y,$pos.z));
			this._txt.x = p.x;
			this._txt.y = p.y;
			this._stage.addChild(this._txt);
			TweenLite.to(this._txt,1,{y:p.y - 200,onComplete:onComplete});
		}
		
		private function onComplete():void{
			if(this._txt.parent){
				this._txt.parent.removeChild(this._txt);
			}
		}
		
		private function init():void{
			this._txt = new TextField();
			this._txt.width = 100;
			this._txt.height = 30;
			this._txt.htmlText = "<font size='20' color='#ff0000'>-85126</font>";
			
		}
		
	}
}