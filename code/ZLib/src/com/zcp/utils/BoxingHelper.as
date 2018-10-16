package com.zcp.utils
{
	import com.zcp.timer.TimerHelper;
	import com.zcp.vo.Rect;
	
	import flash.display.*;
	import flash.utils.getTimer;
	
	/**
	 * 装箱
	 * @author zcp
	 */
	public class BoxingHelper
	{
		public function BoxingHelper(){}
		
		/**
		 * 添加
		 * @param $rectList rect数组
		 * @param $boxType 装箱模式:0按面积依次装箱 1 按宽度依次装箱 2按高度依次装箱（推荐用2）
		 * @param $onUpdate 更新回调 格式:$onUpdate(rect)
		 * @param $onComplete 完成回调 格式:$onComplete(rectList)
		 */
		public function boxing(
			$rectList:Array,
			$boxType:int = 0,
			$onUpdate:Function=null, 
			$onComplete:Function=null
		):void
		{
			var boxList:Array = $rectList;
			var saveBoxList:Array = [];
			var freeBoxList:Array = [];
			
			
			//将箱子排序(从小向大排列,在按面积、按宽度、按高度3种排序方式测试后， 发现按高度排序效果最好)***********************************************************************
			if($boxType==0)
			{
				boxList.sortOn("area", Array.NUMERIC);
			}
			else if($boxType==1)
			{
				boxList.sortOn("width", Array.NUMERIC);
			}
			else if($boxType==2)
			{
				boxList.sortOn("height", Array.NUMERIC);
			}
			else
			{
				throw new Error("装箱模式错误");
			}
			
			
			
			
			//创建原始剩余矩形空间***********************************************************************
			//先优选一个大矩形的宽(不考虑最大宽度限制)， 同时给一个非常大的高
			var boxW:int;
			var boxH:int = 20000;
			//求出一个边长为X的正方形，使这个正方形的面积与“矩形集合中的所有矩形的面积和”相等， 则用这个X的1.5倍作为大矩形的宽
			var totalArea:Number = 0;
			var maxWidth:Number = 0;
			for each(var box:Rect in boxList)
			{
				totalArea += box.area;
				maxWidth = box.width>maxWidth?box.width:maxWidth;
			}
			boxW = Math.max(Math.sqrt(totalArea)*1.25, maxWidth);
			//则原始剩余矩形空间中只有这个最大的矩形， 
			freeBoxList.push(new Rect(0, 0, boxW, boxH));
			
			
			//队列依次装入每个箱子***********************************************************************
			var time:int = getTimer();
			htBox();
			function htBox():void
			{
				if(boxList.length==0)
				{
					//完成回调
					if($onComplete is Function)$onComplete(saveBoxList);
					return;
				}
				//从原始矩形数组中移除, 一定要先移除， 因为后面的doBoxing函数会用到boxList数组
				var box:Rect = boxList.pop();
				//添加到临时数组内记录下来
				saveBoxList.push(box);
				//执行装箱 
				doBoxing(box);
				
				//更新回调
				if($onUpdate is Function)$onUpdate(box);
				
				//延时执行下一步
				TimerHelper.addDelayCallBack(1, htBox);
			}
			
			
			//装箱函数
			function doBoxing($box:Rect):void
			{
				//从小y向大y, 从小x向大x, 依次测试是否容纳的下该矩形， ================
				//直到找到一个满足条件的空闲矩形，之后将该矩形放在空闲矩形的y最小,x最小处
				//同时，切割矩形,更新空闲矩形集合(整理矩形在完成此操作之后做)
				var inLen:int=freeBoxList.length;
				var canIncluded:Boolean = false;
				for(var inI:int=0; inI<inLen;inI++)
				{
					var inFreeBox:Rect = freeBoxList[inI];
					if(
						inFreeBox.width>=$box.width 
						&&
						inFreeBox.height>=$box.height 
					)
					{
						//更新该矩形坐标
						$box.x = inFreeBox.x;
						$box.y = inFreeBox.y;
						//改变标识
						canIncluded = true;
						break;//挑出
					}
				}
				if(!canIncluded)throw new Error("太小无法容纳");
				//将剩余矩形数组中每个空闲矩形都减掉此矩形占用的位置
				var inLen2:int=freeBoxList.length;
				var r:Rect = $box;
				for(var inI2:int=inLen2-1; inI2>=0; inI2--)
				{
					var R:Rect = freeBoxList[inI2];
					//判断相交性
					//如果不相交则继续下一循环
					if(!R.intersects(r))continue;
					//否则从空闲矩形数组中去掉该矩形
					freeBoxList.splice(inI2, 1);
					//添加新的矩形
					var rect1:Rect = new Rect(R.left, R.top, r.left-R.left, R.height);
					var rect2:Rect = new Rect(R.left, R.top, R.width, r.top-R.top);
					var rect3:Rect = new Rect(r.right, R.top, R.right-r.right, R.height);
					var rect4:Rect = new Rect(R.left, r.bottom, R.width, R.bottom-r.bottom);
					
					if(!rect1.isEmpty())
					{
						freeBoxList.push(rect1);
					}
					if(!rect2.isEmpty())
					{
						freeBoxList.push(rect2);
					}
					if(!rect3.isEmpty())
					{
						freeBoxList.push(rect3);
					}
					if(!rect4.isEmpty())
					{
						freeBoxList.push(rect4);
					}
					
				}
				
				
				//从空闲数组中移除 大小为0的空闲矩形 或  无法排下剩下的任何一个矩形的空闲矩形================
				function isTooSmallBox($checkFreeBox:Rect):Boolean 
				{
					function every(element:*, index:int, arr:Array):Boolean 
					{
						var testBox:Rect = element as Rect;
						return testBox.width>$checkFreeBox.width 
							|| 
							testBox.height>$checkFreeBox.height;
					}
					return boxList.every(every);
				}
				var inLen3:int=freeBoxList.length;
				for(var inI3:int=inLen3-1; inI3>=0;inI3--)
				{
					var inFreeBox3:Rect = freeBoxList[inI3];
					if(
						inFreeBox3.isEmpty()//矩形大小为0
						||
						isTooSmallBox(inFreeBox3)//无法排下剩下的任何一个矩形的空闲矩形
					)
					{
						freeBoxList.splice(inI3, 1);
					}
				}
				
				
				//从数组中去掉完全包含的数组中的小者================
				//按面积从大到小排序
				freeBoxList.sortOn("area", Array.NUMERIC | Array.DESCENDING);
				//开始检测
				function isNotBeIncludedBox($checkFreeBox:Rect):Boolean 
				{
					function every(element:*, index:int, arr:Array):Boolean 
					{
						var testFreeBox:Rect = element as Rect;
						
						return testFreeBox==$checkFreeBox
							||
							(
								testFreeBox.left>$checkFreeBox.left 
								||
								testFreeBox.right<$checkFreeBox.right 
								||
								testFreeBox.top>$checkFreeBox.top 
								||
								testFreeBox.bottom<$checkFreeBox.bottom
							)
							;
					}
					return freeBoxList.every(every);
				}
				var inLen4:int=freeBoxList.length;
				for(var inI4:int=inLen4-1; inI4>=0;inI4--)
				{
					var inFreeBox4:Rect = freeBoxList[inI4];
					if(!isNotBeIncludedBox(inFreeBox4))
					{
						freeBoxList.splice(inI4, 1);
					}
				}
				
				
				//重新排序空闲箱子， 规则：y由小到大， x由小到大, y优先级高于x================
				freeBoxList.sortOn(["y", "x"], [Array.NUMERIC, Array.NUMERIC]);
			}
		}
	}
}