package _me
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.getTimer;

	// --------------MSN:lation_pan@live.cn  QQ: 3423526------------- //
	public class FpsView extends Sprite
	{
		private var _fpsinfo:TextField;
		private var _lastTime:int;
		private var _fNum:Number=0;
		public static var showFocus:Boolean=true
		public static var strNotice:String=""
		public function FpsView(_parentObj:*,xpos:int=0,ypos:int=0)
		{
			addTexts();
			_parentObj.addChild(this);
			this.mouseEnabled=false;
			this.mouseChildren=false;
			this.x = xpos;
			this.y = ypos;
		}
		private function addTexts():void
		{
			_fpsinfo=new TextField()
			_fpsinfo.width=500
			_fpsinfo.height=70;
			addChild(_fpsinfo);
			_fpsinfo.mouseEnabled=false
			this.addEventListener(Event.ENTER_FRAME,enterFrame)
		}
		private function enterFrame(evt:Event):void
		{
			var cc:int=getTimer()-_lastTime;
			_fNum++
			if(cc>=1000||strNotice){
				
			
				
				var $str:String=""
				 $str+="<font color='#ffffff' face='宋体'>"+int(System.totalMemoryNumber/1000000) + "/" + int(System.privateMemory/1000000) + "M  </font>";
				 $str+="<font color='#ffffff' face='宋体'>fps: " + _fNum ;
				 $str+="\ndrawNum: " + String(Scene_data.drawNum)
				 $str+="\ndrawTri:"+String(Scene_data.drawTriangle)
			     if(showFocus){
					 $str+="\nfocus3D:"+String(int(Scene_data.cam3D.x))+" "+String(int(Scene_data.cam3D.y))+" "+String(int(Scene_data.cam3D.z))+"</font>"
				 }
				 $str+= " </font>"
				_fpsinfo.htmlText=strNotice?"<font color='#ffffff' face='宋体'>"+strNotice+ "</font>":$str;

				_fpsinfo.filters = [new GlowFilter(0x000000, 1, 2, 2, 17, 1, false, false)];
				_lastTime=getTimer();
				_fNum=0;
			}
			
			
		}
	}
}