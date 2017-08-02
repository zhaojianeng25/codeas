package _Pan3D.gemo
{
	import _Pan3D.display3D.Display3DContainer;
	import _Pan3D.display3D.Display3DSprite;
	import _Pan3D.program.Program3DManager;
	
	import _me.Scene_data;

	public class GemoManager
	{
		private static var _instance:GemoManager;
		
		private var rectangleAry:Vector.<Display3DRectangle>;
		
		/**
		 * 深度值 
		 */		
		public var zbuff:Number = 0.2;
		/**
		 * 显示对象的容器 
		 */		
		private var _contaniner:Display3DContainer;
		public function GemoManager()
		{
			initDisplay();
		}
		public static function getInstance():GemoManager{
			if(!_instance){
				_instance = new GemoManager;
			}
			return _instance;
		}
		public function init($contaniner:Display3DContainer):void{
			_contaniner = $contaniner;
		}
		private function initDisplay():void{
			
			rectangleAry = new Vector.<Display3DRectangle>;
			
//			display3dAry = new Vector.<Display3DText>;
//			display3dynamicAry = new Vector.<Display3DynamicText>;
//			
			Program3DManager.getInstance().registe(Display3DRectangleShader.DISPLAY3DRECTANGLESHADER,Display3DRectangleShader);
//			Program3DManager.getInstance().registe(Display3DynamicTextShader.DISPLAY3DYNAMICTEXTSHADER,Display3DynamicTextShader);
		}
		
		public function requestRectangle(rec:Rectangle3D):void{
			for(var i:int;i<rectangleAry.length;i++){
				var tf:Boolean = rectangleAry[i].requestRectangle(rec);
				if(tf){
					return;
				}
			}
			var display3dRec:Display3DRectangle = addRectangle();
			display3dRec.initData(zbuff);
			display3dRec.requestRectangle(rec);
		}
		
		private function addRectangle():Display3DRectangle{
			var display3dText:Display3DRectangle = new Display3DRectangle(Scene_data.context3D);
			rectangleAry.push(display3dText);
			display3dText.setProgram3D(Program3DManager.getInstance().getProgram(Display3DRectangleShader.DISPLAY3DRECTANGLESHADER));
			_contaniner.addChild(display3dText);
			return display3dText;
		}
		
		public function addChild(display3d:Display3DSprite):void{
			_contaniner.addChild(display3d);
		}
										 
		public function reload():void{
			for(var i:int;i<rectangleAry.length;i++){
				rectangleAry[i].reload();
			}
		}
		
		
		
		
		
	}
}