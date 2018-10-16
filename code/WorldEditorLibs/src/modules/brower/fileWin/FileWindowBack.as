package modules.brower.fileWin
{
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	
	import mx.core.UIComponent;
	
	import _Pan3D.core.MathCore;
	
	public class FileWindowBack extends  UIComponent
	{
		public function FileWindowBack()
		{
			super();
			init();
		}
		private var _backSprte:Sprite
		private function init():void
		{
			_backSprte=new Sprite
			this.addChild(_backSprte);
		    resetSize(100,100);	
		}
		
		public function resetSize($w:uint,$h:uint,$colorV:Vector3D=null):void
		{
			if(!$colorV){
				$colorV=new Vector3D(79,79,79)
			}
			
			_backSprte.graphics.clear()
			_backSprte.graphics.beginFill(MathCore.argbToHex16($colorV.x,$colorV.y,$colorV.z),1)
			_backSprte.graphics.drawRect(0,0,$w,$h)
		}
	}
}