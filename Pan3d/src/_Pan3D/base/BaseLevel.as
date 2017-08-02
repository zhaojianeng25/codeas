package _Pan3D.base
{
	import _Pan3D.display3D.Display3DContainer;
	
	import _me.Scene_data;
	
	import flash.display3D.Context3D;

	public class BaseLevel
	{
		public var _display3DContainer:Display3DContainer;
		protected var _context3D:Context3D;
		protected var _isShow:Boolean=true
		public function BaseLevel()
		{
			_display3DContainer=new Display3DContainer
			_context3D=Scene_data.context3D;
			
			addShaders();
			initData();
			
		}

		public function get isShow():Boolean
		{
			return _isShow;
		}

		public function set isShow(value:Boolean):void
		{
			_isShow = value;
		}

		public function resetStage():void
		{
			
		}
		
		protected function initData():void
		{
			//Auto Generated method stub
			
		}
		
		protected function addShaders():void
		{
			//Auto Generated method stub
			
		}
		public function upData():void
		{
			//Auto Generated method stub
			
			_display3DContainer.update();
		}
		/**
		 * 对显示对象进行排序 
		 * @param attribute 要对比的属性
		 * @param isDescending 是否为降序
		 * 
		 */		
		public function sort(attribute:String,isDescending:Boolean=false):void{
			_display3DContainer.sort(attribute,isDescending);
		}
		
	}
}