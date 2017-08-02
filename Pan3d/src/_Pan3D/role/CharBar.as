package _Pan3D.role
{
	import _Pan3D.gemo.GemoManager;
	import _Pan3D.gemo.Rectangle3D;

	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class CharBar
	{
		private var _x:int;
		private var _y:int;
		private var _width:int;
		private var _height:int;
		
		private var bgRec:Rectangle3D;
		private var topRec:Rectangle3D;
		
		public var offsetX:int;
		public var offsetY:int;
		
		private var _num:Number;
		
		public var visible:Boolean = true;
		
		public function CharBar($width:int, $height:int)
		{
			_width = $width;
			_height = $height;
			bgRec = new Rectangle3D(0,0,$width,$height,0x000000,0.5);
			topRec = new Rectangle3D(0,0,$width,$height,0xff0000,1);
		}
		/**
		 * 设置当前bar显示颜色
		 * @param $bgColor 背景色 ARGB值
		 * @param $topColor 前景色 ARGB值
		 */		
		public function setColor($bgColor32:uint, $topColor32:uint):void{
			bgRec.color32 = $bgColor32;
			topRec.color32 = $topColor32;
		}
		/**
		 * 设置当前bar显示数值 
		 * @param $barNow 当前值
		 * @param $barTotal 最大值
		 */		
		public function setBar($barNow:Number, $barTotal:Number):void{
			_num = $barNow/$barTotal;
			if(_num < 0){
				_num = 0;
			}else if(_num > 1){
				_num = 1;
			}
			apply();
		}
		
		private function apply():void{
			topRec.width = _num*_width;
			topRec.x = _x;
			topRec.y = _y;
			bgRec.x = _x + topRec.width;
			bgRec.width = (1-_num)*_width;
			bgRec.y = _y;
		}
		
		public function add():void{
			bgRec.add();
			topRec.add();
		}
		public function remove():void{
			bgRec.remove();
			topRec.remove();
		}

		public function get x():int
		{
			return _x;
		}

		public function set x(value:int):void
		{
			_x = value;
			apply();
		}

		public function get y():int
		{
			return _y;
		}

		public function set y(value:int):void
		{
			_y = value;
			apply();
		}
		/**
		 * 释放资源 
		 * 
		 */		
		public function dispose():void{
			bgRec.dispos();
			topRec.dispos();
		}

		public function get width():int
		{
			return _width;
		}

		public function get height():int
		{
			return _height;
		}


	}
}