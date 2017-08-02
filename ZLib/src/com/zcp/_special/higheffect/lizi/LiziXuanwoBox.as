package com.zcp._special.higheffect.lizi
{
	import com.zcp.utils.Fun;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 粒子漩涡
	 * @author zcp
	 */
	public class LiziXuanwoBox extends Sprite
	{
		
		/**密度（单位宽度内，每帧添加的数量）*/
		private static const DENS:Number = 1/12000;
		
		//速度
		private static const step_r:Number = 0.997;//对数螺线的臂的距离以此几何级数递增
		private static const step_an:Number = -0.016;//角度每帧变化
		
		
		
		/**显示区域 */
		private var _showArea:Rectangle;
		/**漩涡中心点 */
		private var _xuanwoCenter:Point;
		/**漩涡宽度*/
		private var _xuanwoWidth:Number;
		/**漩涡高度*/
		private var _xuanwoHeight:Number;
		
		
		
		/**渐显半径*/
		private var max_r1:Number;
		/**最大半径*/
		private var max_r:Number;
		/**最小半径*/
		private var min_r:Number;
		/**消失半径*/
		private var min_r1:Number;
		
		
		/**y缩放 */
		private var y_scale:Number;
		
		
		
		//个数配置
		private var _shaArr:Array;//shape数组
		private var _eachSnowCount:Number = 1;//每循环添加的数量
		private var _waitAddSnowCount : Number;//等待添加的数量
		
		
		
		//效果配置
		//放大旧的位图用
		private var toBig_matrix:Matrix;;//放大Matrix
		private var toBig_ct:ColorTransform;//变淡ColorTransform
		//绘制新的shape用
		private var drawShape_matrix:Matrix;//绘制平移用
		private var drawShape_ct:ColorTransform;//绘制变淡用
		//模糊用
		private var bf:BlurFilter;
		
		
		//透明度用
		private var alpha_shape:Shape;
		private var alpha_matrix:Matrix;
		
		
		//主画布
		private var _drawBMP:Bitmap;
		//主位图
		private var _drawBD:BitmapData;
		
		
		/**是否正在运行*/
		private var _isRunning : Boolean = false;
		/**
		 * 是否正在运行
		 */		
		public function get isRunning():Boolean
		{
			return _isRunning;
		}
		
		/**
		 * @parm $disappearR 消失半径
		 * */
		public function LiziXuanwoBox(
			$showArea:Rectangle,
			$xuanwoCenter:Point,
			$xuanwoWidth:Number=1000, 
			$xuanwoHeight:Number=580, 
			$disappearR:Number=100, 
			$guoduR:Number=50, 
			$autoStart:Boolean = true)
		{
			//设置混合模式
			this.blendMode = BlendMode.LAYER;
			
			//设置透明效果
			alpha_shape = new Shape();
			alpha_shape.blendMode = BlendMode.ALPHA;
			this.addChild(alpha_shape);
			
			
			//设置显示区域	
			setShowArea($showArea);
			//设置绘制区域	
			setDrawArea($xuanwoCenter, $xuanwoWidth, $xuanwoHeight, $disappearR, $guoduR);
			
			//初始化参数
			_shaArr = [];//shape数组
			_waitAddSnowCount = 0;
			
			
			
			
			//			//参照系
			//			var sp:Sprite = new Sprite();
			//			sp.x = _xuanwoCenter.x;
			//			sp.y = _xuanwoCenter.y;
			//			var sp1W:Number = _xuanwoWidth;
			//			var sp1H:Number = _xuanwoHeight;
			//			if(y_scale<=1)
			//			{
			//				sp.scaleY = y_scale;
			//				sp1H /= y_scale;
			//			}
			//			else
			//			{
			//				sp.scaleX = 1/y_scale;
			//				sp1W *= y_scale;
			//			}
			//			sp.graphics.lineStyle(1,0xFF0000,1);
			//			sp.graphics.drawRect(-sp1W/2,-sp1H/2,sp1W,sp1H);
			//			sp.graphics.drawCircle(0, 0, max_r1);
			//			sp.graphics.drawCircle(0, 0, max_r);
			//			sp.graphics.drawCircle(0, 0, min_r);
			//			sp.graphics.drawCircle(0, 0, min_r1);
			//			addChildAt(sp, 0);
			
			
			
			//自动开始
			if ($autoStart) start();
		}
		/**
		 * 设置显示区域
		 * */
		public function setShowArea($showArea:Rectangle):void
		{
			//尺寸配置
			_showArea = $showArea.clone();
			this.graphics.clear();
			this.graphics.beginFill(0,1);
			this.graphics.drawRect(_showArea.x, _showArea.y, _showArea.width, _showArea.height);
			this.graphics.endFill();
		}
		/**
		 * 设置绘制区域
		 * */
		private function setDrawArea(
			$xuanwoCenter:Point,
			$xuanwoWidth:Number=1000, 
			$xuanwoHeight:Number=580, 
			$disappearR:Number=150, 
			$guoduR:Number=80
		):void
		{
			//尺寸配置
			_xuanwoWidth = $xuanwoWidth;
			_xuanwoHeight = $xuanwoHeight;
			min_r1 = $disappearR;
			_xuanwoCenter = $xuanwoCenter.clone();//new Point(_xuanwoWidth/2, _xuanwoHeight/2);//中心点
			y_scale = _xuanwoHeight/_xuanwoWidth;//Y比例
			max_r1 =  Math.max(_xuanwoWidth/2, _xuanwoHeight/2);//渐显半径
			max_r = max_r1 - $guoduR;//外半径
			min_r = min_r1 + $guoduR;//内半径
			if(min_r1+$guoduR*2>=max_r1)throw Error("最小半径 与 双过度 之和 应小于最大半径!");
			
			//更新密度个数
			_eachSnowCount = max_r1 * DENS;//每循环添加的数量
			
			//效果配置
			//放大旧的位图用
			toBig_matrix = new Matrix();;//放大Matrix
			var incX:int = _xuanwoWidth/10000;
			var incY:int = _xuanwoHeight/(10000*y_scale);
			toBig_matrix.a = (_xuanwoWidth + incX)/_xuanwoWidth;
			toBig_matrix.d = (_xuanwoHeight + incY)/_xuanwoHeight;
			toBig_matrix.tx = -incX/2;
			toBig_matrix.ty = -incY/2;
			toBig_ct = new ColorTransform(.999,.999,.999);//变淡ColorTransform
			//绘制新的shape用
			drawShape_matrix = new Matrix(1,0,0,1,_xuanwoWidth/2,_xuanwoHeight/2);//绘制平移用
			drawShape_ct = new ColorTransform(1,1,1,1);//绘制变淡用
			//模糊用
			bf = new BlurFilter(2,2,1);
			
			
			//这个元件将用来做渐变的透明效果
			var alpha_r:Number = min_r1;
			var alpha_mtx:Matrix = new Matrix();
			alpha_mtx.createGradientBox(alpha_r*2,alpha_r*2,0,-alpha_r,-alpha_r);
			alpha_shape.graphics.clear();
			alpha_shape.graphics.beginGradientFill(GradientType.RADIAL, [0,0], [0,1], [0,255],alpha_mtx,SpreadMethod.PAD, InterpolationMethod.RGB);
			alpha_shape.graphics.drawCircle(0, 0, alpha_r);
			alpha_shape.graphics.endFill();
			if(y_scale<=1)
			{
				alpha_shape.height *= y_scale;
				alpha_shape.x = _xuanwoCenter.x;
				alpha_shape.y = _xuanwoCenter.y;
			}
			else
			{
				alpha_shape.width /= y_scale;
				alpha_shape.x = _xuanwoCenter.x;
				alpha_shape.y = _xuanwoCenter.y;
			}
		}
		/**开始*/
		public function start():void
		{
			//主位图
			if(_drawBMP==null)
			{
				_drawBD = new BitmapData(_xuanwoWidth,_xuanwoHeight,false,0);
				_drawBMP = new Bitmap(_drawBD);
				_drawBMP.x = _xuanwoCenter.x - _xuanwoWidth/2;
				_drawBMP.y = _xuanwoCenter.y - _xuanwoHeight/2;
				addChildAt(_drawBMP, 0);
			}
			//帧监听
			addEventListener(Event.ENTER_FRAME,loop);
			_isRunning = true;
			return;
		}
		/**停止*/
		public function stop($clear:Boolean):void
		{
			//停止
			removeEventListener(Event.ENTER_FRAME,loop);
			//主位图
			if($clear)
			{
				Fun.clearChildren(this, true);
				_drawBD = null;
				_drawBMP = null;
			}
			_isRunning = false;
			
			//初始化参数
			_shaArr = [];//shape数组
			_waitAddSnowCount = 0;
			return;
		}
		/**对数螺线*/
		private function getELuojian($r:Number, $an:Number):Point
		{
			var p:Point = new Point();
			p.x = $r * Math.cos($an);
			p.y = $r * Math.sin($an);
			return p;
		}
		/**主循环*/
		private function loop(e:Event):void 
		{
			//创建新的
			_waitAddSnowCount += _eachSnowCount;
			while (_waitAddSnowCount >= 1)
			{
				var sha:Shape = new Shape();
				sha.graphics.beginFill(Math.random()*0xFFFFFF,1);//随机颜色
				sha.graphics.drawCircle(0,0,8*Math.max(Math.random(), 0.6));
				sha.graphics.endFill();
				_shaArr.push([sha, max_r1, 2*Math.PI*Math.random()]);
				
				_waitAddSnowCount--;
			}
			
			
			//放大旧的位图
			var dummy:BitmapData = _drawBD.clone();
			_drawBD.draw(dummy,toBig_matrix,toBig_ct,null,null,true);
			
			//重新计算所有圆的位置   绘制   移除
			var i:int;
			var len:int = _shaArr.length;
			for(i=len-1; i>=0; i--)
			{
				var arr:Array = _shaArr[i];
				var shape:Shape = arr[0];
				arr[1] *= step_r;//几何级数递减
				arr[2] += step_an;
				//计算对数螺线位置
				var anOffset:Number = -step_an*arr[1]/max_r1;//外慢内快补偿
				var p:Point = getELuojian(arr[1], arr[2]+anOffset);
				//判断距离
				var dis:Number = Point.distance(new Point(_xuanwoCenter.x+p.x,  _xuanwoCenter.y + p.y), _xuanwoCenter);//注意dis是用没有y缩放的值求
				if(dis>min_r1)
				{
					//求绘制新的位图
					if(y_scale<=1)
					{
						drawShape_matrix.tx = _xuanwoWidth/2 + p.x;
						drawShape_matrix.ty = _xuanwoHeight/2 + p.y*y_scale;//注意矩阵的y平移是用有y缩放的值求
					}
					else
					{
						drawShape_matrix.tx = _xuanwoWidth/2 + p.x*(1/y_scale);//注意矩阵的x平移是用有x缩放的值求
						drawShape_matrix.ty = _xuanwoHeight/2 + p.y;
					}
					//求透明度
					if(dis>max_r)
					{
						drawShape_ct.alphaMultiplier = (max_r1-dis)/(max_r1-max_r);
					}
					else if(dis>min_r)
					{
						drawShape_ct.alphaMultiplier = 1;
					}
					else
					{
						drawShape_ct.alphaMultiplier = 1-(min_r-dis)/(min_r-min_r1);
					}
					//绘制
					_drawBD.draw(shape,drawShape_matrix,drawShape_ct,null,null,true); 
				}
				else//达到小时临界点，则移除
				{
					//从数组中
					_shaArr.splice(i,1);
				}
			}
			
			//模糊位图
			_drawBD.applyFilter(_drawBD,_drawBD.rect,new Point(0,0),bf);
		}
	}
}