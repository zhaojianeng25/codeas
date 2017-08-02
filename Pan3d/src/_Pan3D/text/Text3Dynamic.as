package _Pan3D.text
{
	import _Pan3D.display3D.Display3D;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.text.TextField;

	/**
	 * 
	 * @author liuyanfei QQ:421537900
	 * 
	 */
	public class Text3Dynamic extends EventDispatcher
	{
		public var id:int;
		private var _x:int;
		private var _y:int;
		/**
		 * 对应显示资源的id 
		 */		
		public var vcId:uint;
		private var _bitmapdata:BitmapData;
		
		public var width:int;
		public var height:int;
		public var zbuff:Number;
		
		private var _offsetX:int;
		private var _offsetY:int;
		
		private var _relativeoffsetY:Number = 0;
		
		private var _visible:Boolean = true;
		
		public var target:Display3D;
		
		/**
		 * 文本系统 
		 */		
		private var _manager:TextFieldManager;
		
		public var displayTaget:Display3DynamicText;
		
		/**
		 * 是否已经显示 
		 */		
		public var isShow:Boolean;
		
		public function Text3Dynamic($manager:TextFieldManager,$width:int,$height:int,$zbuff:Number)
		{
			width = $width;
			height = $height;
			zbuff = $zbuff;
			_manager = $manager;
			$manager.requestDisplay(this);
		}
		public function get bitmapdata():BitmapData
		{
			return _bitmapdata;
		}
		/**
		 * 图片的bitmapdata
		 * @param value
		 * 
		 */		
		public function set bitmapdata(value:BitmapData):void
		{
			if(value.width != width || value.height != height){
				throw new Error("传入图片的宽高不是设定的宽和高");
			}
			_bitmapdata = value;
			displayTaget.reUploadTexture(_bitmapdata,vcId);
		}
		/**
		 * 应用变化 
		 * 
		 */		
		public function apply():void{
//			if(!isShow){
//				return;
//			}
			var index1:int = vcId*2;
			var index2:int = index1+1;
			displayTaget.vcAry[index1] = _x;
			displayTaget.vcAry[index2] = _y;
		}
		
		public function get y():int
		{
			return _y;
		}
		/**
		 * 设置文本的y 
		 * @param value
		 * 
		 */		
		public function set y(value:int):void
		{
			_y = value;
			if(isShow)
				apply();
		}
		
		public function get x():int
		{
			return _x;
		}
		/**
		 * 设置文本的x 
		 * @param value
		 * 
		 */		
		public function set x(value:int):void
		{
			_x = value;
			if(isShow)
				apply();
		}
		/**
		 * 同时设置文本的xy值
		 * 如需要同时设置xy的值用词方法效率比单独这只xy高
		 * @param $xpos x数值
		 * @param $ypos y数值
		 * 
		 */		
		public function setXY($xpos:int,$ypos:int):void{
			_x = $xpos;
			_y = $ypos;
			apply();
		}
		
		/**
		 * 添加到显示列表中 
		 * 
		 */		
		public function add():void{
			isShow = true;
			apply();
		}
		
		/**
		 * 从显示列表中移除 
		 * 
		 */		
		public function remove():void{
			isShow = false;
			//将对象放到可舞台外面
			var index1:int = vcId*2;
			var index2:int = index1+1;
			displayTaget.vcAry[index1] = 0;
			displayTaget.vcAry[index2] = -2000;
		}
		/**
		 * 释放资源
		 * 如果需要彻底清理该资源则必须调用此方法
		 */		
		public function dispose():void{
			displayTaget.idStatus[vcId] = true;
			displayTaget.idleNum ++;
			var index1:int = vcId*2;
			var index2:int = index1+1;
			displayTaget.vcAry[index1] = 0;
			displayTaget.vcAry[index2] = -2000;
			target = null;
		}
		
		public function get offsetX():int
		{
			return _offsetX;
		}
		
		public function set offsetX(value:int):void
		{
			_offsetX = value;
			if(target)		//加上空指针校验
			{
				target.updataPos();
			}
		}

		public function get offsetY():int
		{
			return _offsetY;
		}

		public function set offsetY(value:int):void
		{
			_offsetY = value;
			if(target)
			{
				target.updataPos();
			}
		}
		
		
		

		public function get visible():Boolean
		{
			return _visible;
		}

		public function set visible(value:Boolean):void
		{
			_visible = value;
			if(value){
				add();
			}else{
				remove();
			}
		}

		public function get relativeoffsetY():Number
		{
			return _relativeoffsetY;
		}
		/**
		 * 相对偏移 
		 * @param value 比例
		 * 
		 */		
		public function set relativeoffsetY(value:Number):void
		{
			_relativeoffsetY = value;
		}
		
		

	}
}