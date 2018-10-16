package  PanV2.loadV2
{
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	import _me.Scene_data;
	
	public class LoadingMc extends Sprite
	{
		private static var instance:LoadingMc	;
		private var _fpsinfo:TextField;
		public function LoadingMc()
		{
			super();
			addTexts()
			Scene_data.stage.addChild(this)
		}
		public static function getInstance():LoadingMc
		{
			if(!instance)
			{
				instance = new LoadingMc();
			}
			return instance;
		}

		private function addTexts():void
		{
			_fpsinfo=new TextField()
			_fpsinfo.width=100
			_fpsinfo.height=18;
			addChild(_fpsinfo);
			_fpsinfo.mouseEnabled=false
		}
		public function setStr(_txt:String):void
		{

			_fpsinfo.htmlText="<font color='#ffffff' face='宋体'>"+_txt+" </font>"
			_fpsinfo.filters = [new GlowFilter(0x000000, 1, 2, 2, 17, 1, false, false)];
			
			this.x=Scene_data.stageWidth/2-100/2
			this.y=Scene_data.stageHeight/2-18/2
		}
		
	}
}