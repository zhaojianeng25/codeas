package com.zcp._special.higheffect.snow
{
	import com.zcp.pool.Pool;
	import com.zcp.utils.ZMath;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * 雪片系统
	 * @author zcp
	 */
	public class SnowBox extends Sprite
	{
		/**
		 * 雪片池
		 * 生成类型为:snow.SnowFace
		 */
		private static var snowFacePool:Pool = new Pool("snowFacePool",100);
		/**
		 * 生成一个snowFace
		 * @param $snowBD
		 */
		private static function createSnowFace($snowBD:BitmapData):SnowFace
		{
			return snowFacePool.createObj(SnowFace,$snowBD) as SnowFace;
		}
		/**
		 * 回收一个Avatar
		 * @param $avatar
		 */
		private static function recycleSnowFace($snowFace:SnowFace):void
		{
			snowFacePool.disposeObj($snowFace);
		}
		
		
		/**
		 *使用snowFacePool池的SnowBox实例数量
		 */
		private static var _snowBoxCount:int = 0;
		/**
		 *使用snowFacePool池的SnowBox实例数量
		 */
		public static function get snowBoxCount():int{
			return _snowBoxCount;
		}
		
		
		/**处于停止生成状态，并且所有雪花都已消失*/
		public static const SNOW_COMPLETE:String = "SNOW_COMPLETE";
		
		
		/**margin*/
		private static const MARGIN:Number = 50;
		/**最小单步X*/
		private static const MIN_X_STEP:Number = 0;
		/**最大单步X*/
		private static const MAX_X_STEP:Number =1;
		/**最小单步Y*/
		private static const MIN_Y_STEP:Number = 1;
		/**最大单步Y*/
		private static const MAX_Y_STEP:Number =5;
		/**雪片密度（单位宽度内，每帧添加的雪片数）*/
		private static const DENS:Number = 1/3000;
		
		
//		/**最小透明度*/
//		private static const MIN_ALPHA:Number = 0.5;
//		/**最大透明度*/
//		private static const MAX_ALPHA:Number =1;
//		/**最小尺寸比例*/
//		private static const MIN_SIZE:Number = 0.2;
//		/**最大尺寸比例*/
//		private static const MAX_SIZE:Number =1;

		/**显示区域*/
		private var _showArea:Rectangle;
		/**雪花的BD数组*/
		private var _snowBDArr:Array;
		/**每循环添加的雪片数量*/
		private var _eachSnowCount:Number = 1;
		/**等待添加的雪片数量*/
		private var _waitAddSnowCount : Number = 0;

		

		
		
		/**是否正在运行*/
		private var _isRunning : Boolean = false;
		/**
		 * 是否正在运行
		 */		
		public function get isRunning():Boolean
		{
			return _isRunning;
		}
		
		// 用于计算的快速参数
		private var _areaTop:Number;
		private var _areaLeft:Number;
		private var _areaWidth:Number;
		private var _areaHeight:Number;
		private var _areaBottom:Number;
		private var _areaRight:Number;

		
		
		/**
		 * 构造
		 * @parm $showArea 显示区域
		 * @parm $snowBD
		 * @parm $autoStart
		 */	
		public function SnowBox($showArea:Rectangle, $snowBDArr:Array = null, $autoStart:Boolean = true)
		{
			_snowBoxCount++;
			
			mouseEnabled = mouseChildren = false;
			
			setShowArea($showArea);
			
			_snowBDArr = $snowBDArr || [];
			
			if ($autoStart) start();
		}
		/**
		 * 设置显示区域
		 * @parm $showArea 显示区域
		 */		
		public function setShowArea($showArea:Rectangle):void
		{
			//更新值
			_showArea = $showArea.clone();//复制一个
			//用于计算的快速参数
			//			_areaTop = -MARGIN;
			//			_areaLeft = -MARGIN;
			//			_areaWidth = _showWidth + MARGIN * 2;
			//			_areaHeight = _showWidth + MARGIN * 2;
			//			_areaBottom = _areaTop + _areaHeight;
			//			_areaRight = _areaLeft + _areaWidth;
			_areaLeft = _showArea.x-MARGIN;
			_areaTop = _showArea.y-MARGIN;
			_areaWidth = _showArea.width + MARGIN;
			_areaHeight = _showArea.height + MARGIN;
			_areaRight = _showArea.right;
			_areaBottom = _showArea.bottom;
			//更新一个参数
			_eachSnowCount = _areaWidth * DENS;
			//更新已有的
			for (var i:int = numChildren-1; i >= 0; i--)
			{
				var snowFace:SnowFace = getChildAt(i) as SnowFace;
				snowFace.setScope(_areaLeft, _areaRight, _areaBottom);
			}
		}
		/**
		 * 开始
		 */		
		public function start($clear:Boolean = false):void
		{
			if ($clear) while (numChildren > 0) removeChildAt(0);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_isRunning = true;
		}
		/**
		 * 停止
		 */		
		public function stop($clear:Boolean = false, $clearPool:Boolean=false):void
		{
			if ($clear) while (numChildren > 0) removeChildAt(0);
			if ($clearPool) snowFacePool.removeAllObjs();
			if (numChildren == 0) stopEnterFrame();
			_isRunning = false;
		}
		/**
		 * 停止刷帧
		 */		
		private function stopEnterFrame():void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			//没有SnowBox实例了，清空池内所有SnowFace缓存
			_snowBoxCount--;
			if(_snowBoxCount==0)snowFacePool.removeAllObjs();
			
			//派发事件
			dispatchEvent(new Event(SNOW_COMPLETE));
		}
		/**刷帧*/
		private function onEnterFrame(e:Event):void
		{
			//创建新的
			if (_isRunning)
			{
				_waitAddSnowCount += _eachSnowCount;
				while (_waitAddSnowCount >= 1)
				{
					creatNewSnow();
					_waitAddSnowCount--;
				}
			}
			//更新并删除旧的
			for (var i:int = numChildren-1; i >= 0; i--)
			{
				var snowFace:SnowFace = getChildAt(i) as SnowFace;
				if (snowFace.update())
				{
					//从场景移除
					removeChild(snowFace);
					//回收
					recycleSnowFace(snowFace);
					if ((!_isRunning) && numChildren == 0) stopEnterFrame();
				}
			}
		}
		/**创建一个新的雪花*/
		private function creatNewSnow():void
		{
			//随机获得一个样式
			var snowBD:BitmapData;
			if(_snowBDArr.length>0)
			{
				snowBD = _snowBDArr[ZMath.randomInt(0, _snowBDArr.length-1)] as BitmapData;
			}
			//创建
			var snowFace:SnowFace = createSnowFace(snowBD);
			var random : Number = Math.random();
			snowFace.setXY(_areaLeft + Math.random() * _areaWidth, _areaTop);//注意这里不能用snowFace.setXY(_areaLeft + random * _areaWidth, _areaTop)
//			snowFace.setAlpha(MIN_ALPHA + (MAX_ALPHA - MIN_ALPHA) * random);
//			snowFace.setSize(MIN_SIZE + (MAX_SIZE - MIN_SIZE)* random);
			var x_step:Number = MIN_X_STEP + (MAX_X_STEP - MIN_X_STEP) * random;
			if (Math.random() > 0.5) x_step *= -1;
			var y_step:Number = MIN_Y_STEP + (MAX_Y_STEP - MIN_Y_STEP) * random;
			snowFace.setStep(x_step, y_step);
			snowFace.setScope(_areaLeft, _areaRight, _areaBottom);
			//添加进容器
			addChild(snowFace);
		}
	}
}

//雪片内部类************************************************************************************************************
	import com.zcp.pool.IPoolClass;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	internal class SnowFace extends Bitmap implements IPoolClass
	{
		/**X单步位移*/
		private var _x_step:Number;
		/**Y单步位移*/
		private var _y_step:Number;
		
		/**左*/
		private var _left:Number;
		/**右*/
		private var _right:Number;
		/**下*/
		private var _bottom:Number;

		public function SnowFace(
			bitmapData:BitmapData=null
		)
		{
			super(null, "auto", false);
			reSet([bitmapData]);
		}
		
		public function dispose():void
		{
			bitmapData = null;
		}
		
		public function reSet($parameters:Array):void
		{
			bitmapData = $parameters[0];
		}
		/**设置XY*/
		internal function setXY($x:Number, $y:Number):void
		{
			x = $x;
			y = $y;
		}
//		/**设置透明*/
//		internal function setAlpha($alpha:Number):void
//		{
//			alpha = $alpha;
//		}
//		/**设置尺寸比例*/
//		internal function setSize($size:Number):void
//		{
//			scaleY = scaleX = $size;
//		}
		/**设置单步位移*/
		internal function setStep($x_step:Number, $y_step:Number):void
		{
			_x_step = $x_step;
			_y_step = $y_step;
		}
		/**设置范围*/
		internal function setScope($left:Number, $right:Number, $bottom:Number):void
		{
			_left = $left;
			_right = $right;
			_bottom = $bottom;
		}
		/**更新*/
		internal function update():Boolean
		{
			x += _x_step;
			y += _y_step;
			if (x < _left || x > _right || y > _bottom) return true;
			return false;
		}
	}