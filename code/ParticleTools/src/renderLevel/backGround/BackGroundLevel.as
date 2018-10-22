package renderLevel.backGround
{
	import _Pan3D.base.BaseLevel;
	import _Pan3D.program.Program3DManager;
	
	import flash.display3D.Program3D;
	
	public class BackGroundLevel extends BaseLevel
	{
		public var backGround:BackGroundDisplay3DSprite;
		//private var _backGround1:BackGroundDisplay3DSprite;
		public function BackGroundLevel()
		{
			//AppData.backGroundLevel=this;
			super();
		}
		override protected function addShaders():void
		{
			Program3DManager.getInstance().registe( BackGroundDisplay3DShader.BACK_GROUND_DISPLAY3D_SHADER,BackGroundDisplay3DShader)
		}
		override protected function initData():void
		{
			backGround=new BackGroundDisplay3DSprite(_context3D);
			backGround.x=0;
			backGround.y=0;
			backGround.setInfoData(0.999,"assets/bg.jpg")
			_display3DContainer.addChild(backGround);
			_display3DContainer.x = 0;
			_display3DContainer.y = 0;
			
			var tempProgram3d:Program3D=Program3DManager.getInstance().getProgram(BackGroundDisplay3DShader.BACK_GROUND_DISPLAY3D_SHADER)
			_display3DContainer.setProgram3D(tempProgram3d);
			
		}
		
		public function loadMap(url:String,wnum:int,hnum:int):void{
			_display3DContainer.removeAllChildren();
			for(var i:int;i<wnum;i++){
				for(var j:int=0;j<hnum;j++){
					var str:String = url + "/" + i + "_" + j + ".jpg";
					var display:BackGroundDisplay3DSprite = new BackGroundDisplay3DSprite(_context3D);
					display.setInfoData(0.999,str);
					display.x = 256*i;
					display.y = 256*j;
					_display3DContainer.addChild(display);
				}
			}
			
			var tempProgram3d:Program3D=Program3DManager.getInstance().getProgram(BackGroundDisplay3DShader.BACK_GROUND_DISPLAY3D_SHADER);
			_display3DContainer.setProgram3D(tempProgram3d);
		}
		
		public function addMap(ary:Array):void{
			_display3DContainer.removeAllChildren();
			for(var i:int;i<ary.length;i++){
				var ary2:Array = ary[i];
				for(var j:int=0;j<ary2.length;j++){
					//ary2[j]
					var display:BackGroundDisplay3DSprite = new BackGroundDisplay3DSprite(_context3D);
					display.setBitmapdata(0.999,ary2[j]);
					display.x = 1024*i;
					display.y = 1024*j;
					_display3DContainer.addChild(display);
				}
			}
			var tempProgram3d:Program3D=Program3DManager.getInstance().getProgram(BackGroundDisplay3DShader.BACK_GROUND_DISPLAY3D_SHADER);
			_display3DContainer.setProgram3D(tempProgram3d);
		}
		
		
		
		public function set x(value:int):void{
			_display3DContainer.x = value;
		}
		public function get x():int{
			return _display3DContainer.x;
		}
		
		public function set y(value:int):void{
			_display3DContainer.y = value;
		}
		public function get y():int{
			return _display3DContainer.y;
		}
		
		
		
		
		
		
		
		
	}
}