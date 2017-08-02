package _Pan3D.text
{
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	import flash.text.TextField;

	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * 
	 */	
	public class Text3D
	{
		private var _id:uint;
		private var _x:int;
		private var _y:int;
		private var _width:int;
		private var _height:int;
		private var _aplha:Number = 1;
		
		public var offsetX:int;
		public var offsetY:int;
		/**
		 * 对应显示资源的id 
		 */		
		public var vcId:uint;
		
		/**
		 * 是否已经显示 
		 */		
		public var isShow:Boolean;
		
		/**
		 * 文本系统 
		 */		
		private var _manager:TextFieldManager;
		/**
		 * 对应的显示对象 
		 */		
		public var displayTaget:Display3DText;
		
		public var texture:Texture;
		
		public function Text3D($manager:TextFieldManager,$texture:Texture)
		{
			_manager = $manager;
			texture = $texture;
			_manager.requestStaticDisplay(this);
		}

		public function get x():int
		{
			return _x;
		}

		public function set x(value:int):void
		{
			if(_x == value){
				return;
			}
			_x = value;
			if(isShow){
				displayTaget.vcAry[vcId*8] = _x + offsetX;
			}
		}

		public function get y():int
		{
			return _y;
		}

		public function set y(value:int):void
		{
			if(_y == value){
				return;
			}
			_y = value;
			if(isShow){
				displayTaget.vcAry[vcId*8+1] = _y + offsetY;
			}
		}
		
		public function get width():int
		{
			return _width;
		}
		
		public function set width(value:int):void
		{
			if(_width == value){
				return;
			}
			_width = value;
			applyWH();
		}
		
		public function get height():int
		{
			return _height;
		}
		
		public function set height(value:int):void
		{
			if(_height == value){
				return;
			}
			_height = value;
			applyWH();
		}
		
		private function applyWH():void{
			var index1:int = vcId*8 + 2;
			var index2:int = vcId*8 + 3;
			displayTaget.vcAry[index1] = _width;
			displayTaget.vcAry[index2] = _height;
		}
		
		public function setUV($xpos:Number,$ypos:Number):void{
			displayTaget.vcAry[vcId*8 + 4] = $xpos;
			displayTaget.vcAry[vcId*8 + 5] = $ypos;
			//displayTaget.vcAry[vcId*8 + 6] = $widht;
			//displayTaget.vcAry[vcId*8 + 7] = $height;
		}
		
		/**
		 * 释放对应的控制资源 （若需彻底从系统中移除此文本需调用此方法）
		 * 
		 */
		public function dispose():void{
			displayTaget.idStatus[vcId] = true;
			displayTaget.idleNum++;
			remove();
		}
		
		/**
		 * 添加到显示列表中 
		 * 
		 */		
		public function add():void{
			isShow = true;
			
			displayTaget.vcAry[vcId*8] = _x + offsetX;
			displayTaget.vcAry[vcId*8+1] = _y + offsetY;
		}
		/**
		 * 从显示列表中移除 
		 * 
		 */		
		public function remove():void{
			isShow = false;
			//将对象放到可舞台外面
			
			displayTaget.vcAry[vcId*8+1] = -20000;
		}

		public function get aplha():Number
		{
			return _aplha;
		}

		public function set aplha(value:Number):void
		{
			_aplha = value;
			displayTaget.vcAry[vcId*8 + 6] = _aplha;
		}


	}
}