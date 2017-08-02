package _Pan3D.gemo
{
	import _Pan3D.core.MathCore;
	
	import flash.geom.Vector3D;

	/**
	 * 矩形
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class Rectangle3D
	{
		private var _x:int;
		private var _y:int;
		private var _height:int;
		private var _width:int;
		private var _color:uint;
		private var _alpha:Number;
		private var _color32:uint;
		public var vcId:int;
		private var _displayTaget:Display3DRectangle;
		private var _isShow:Boolean;
		/**
		 * 矩形参数
		 * @param $x x位置
		 * @param $y y位置
		 * @param $width 宽度
		 * @param $height 高度
		 * @param $color 颜色
		 * @param $alpha 透明度
		 * 
		 */		
		public function Rectangle3D($x:int,$y:int,$width:int,$height:int,$color:uint=0,$alpha:Number=1)
		{
			GemoManager.getInstance().requestRectangle(this);
			
			x = $x;
			y = $y;
			height = $height;
			width = $width;
			_color = $color;
			_alpha = $alpha;
			chgColor();
		}
		
		public function get x():int
		{
			return _x;
		}

		public function set x(value:int):void
		{
			_x = value;
			if(_displayTaget && _isShow)
				_displayTaget.vcAry[vcId*4+2] = value;
		}

		public function get y():int
		{
			return _y;
		}

		public function set y(value:int):void
		{
			_y = value;
			if(_displayTaget && _isShow)
				_displayTaget.vcAry[vcId*4+3] = value;
		}

		public function get height():int
		{
			return _height;
		}

		public function set height(value:int):void
		{
			_height = value;
			if(_displayTaget)
				_displayTaget.vcAry[vcId*4+1] = value;
		}

		public function get width():int
		{
			return _width;
		}

		public function set width(value:int):void
		{
			_width = value;
			if(_displayTaget)
				_displayTaget.vcAry[vcId*4] = value;
		}

		public function get color():uint
		{
			return _color;
		}

		public function set color(value:uint):void
		{
			_color = value;
			chgColor();
		}

		public function get alpha():Number
		{
			return _alpha;
		}

		public function set alpha(value:Number):void
		{
			_alpha = value;
			chgColor();
		}
		
		private function chgColor():void{
			var v3d:Vector3D = MathCore.hexToArgb(_color,false);
			color32 = MathCore.argbToHex(_alpha*255,v3d.x,v3d.y,v3d.z);
		}

		public function get color32():uint
		{
			return _color32;
		}

		public function set color32(value:uint):void
		{
			_color32 = value;
			_displayTaget.reUploadTexture(vcId,_color32);
		}

		public function get displayTaget():Display3DRectangle
		{
			return _displayTaget;
		}

		public function set displayTaget(value:Display3DRectangle):void
		{
			_displayTaget = value;
		}
		
		private function apply():void{
			_displayTaget.vcAry[vcId*4+2] = _x;
			_displayTaget.vcAry[vcId*4+3] = _y;
		}
		/**
		 * 添加到显示列表中 
		 * 
		 */		
		public function add():void{
			_isShow = true;
			_displayTaget.vcAry[vcId*4+2] = _x;
			_displayTaget.vcAry[vcId*4+3] = _y;
		}
		
		
		/**
		 * 从显示列表中移除 
		 * 
		 */		
		public function remove():void{
			_isShow = false;
			//将对象放到可舞台外面
			_displayTaget.vcAry[vcId*4+3] = -2000;
		}
		private var _hasDispose:Boolean;
		public function dispos():void{
			if(_hasDispose){
				return;
			}
			_displayTaget.vcAry[vcId*4+3] = -2000;
			displayTaget.idStatus[vcId] = true;
			displayTaget.idleNum ++;
			_hasDispose = true;
		}


	}
}