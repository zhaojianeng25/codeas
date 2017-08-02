package com.zcp.timer
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import com.zcp.handle.HandleThread;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	/**
	 * TIME辅助器
	 * @author zcp
	 * 
	 */	
	public class TimerHelper
	{
		/**用于计时的Sprite*/
		private static var timeSprite:Sprite = new Sprite();
		
		/**延时回调池*/
		private static var delayCallBackList:Array = new Array();
		private static var delayCallBackDict:Dictionary = new Dictionary();//这个不能用delayCallBackList作为Object使用代替
		
		public function TimerHelper()
		{
			throw new Event("静态类");
		}
		/**
		 * 创建一个Timer 
		 * 说明：此方法优先保证次数，时间不够准确
		 * @param $delay 每次执行的延时  单位：毫秒
		 * @param $repeat 循环次数
		 * @param $timerHandler 回调
		 * @param $timerHandlerParameters 回调参数
		 * @param $timerCompleteHandler 完成回调
		 * @param $timerCompleteHandlerParameters 完成回调参数
		 * @param $autoStart 是否自动开始
		 * 
		 */		
		public static function createTimer($delay:Number, $repeat:int,$timerHandler:Function, $timerHandlerParameters:Array=null,$timerCompleteHandler:Function=null, $timerCompleteHandlerParameters:Array=null,$autoStart:Boolean=true):TimerData {
			var timer:Timer = new Timer($delay,$repeat);
			if($timerHandler!=null)
				timer.addEventListener(TimerEvent.TIMER, timerHandler);
			if($timerCompleteHandler!=null)
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			if($autoStart)
				timer.start();
			function timerHandler(e:TimerEvent):void
			{
				//执行回调函数
				HandleThread.execute($timerHandler,$timerHandlerParameters);
				return;
			}
			function timerCompleteHandler(e:TimerEvent):void
			{
				destroy();

				//执行结束回调函数
				HandleThread.execute($timerCompleteHandler,$timerCompleteHandlerParameters);
				return;
			}
			function destroy():void
			{
				if(timer)
				{
					timer.stop();
					timer.removeEventListener(TimerEvent.TIMER, timerHandler);
					timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
					timer = null;
				}
				return;
			}
			return new TimerData(timer,destroy);
		}
		/**
		 * 创建一个准确的Timer 
		 * 说明：此方法优先保证时间，其次保证次数（都很准确）
		 * @param $duration 时长 单位：毫秒
		 * @param $from 开始的参数
		 * @param $to 结束的参数
		 * @param $onUpdate 回调函数 格式为function onUpdate($per):void,$per为从$from到$to的过程中当前进行到的值
		 * @param $onComplete 回调函数 格式为function onComplete():void
		 * @param $updateStep 回调步伐(从$from到$to的过程中,每个多少回调一次)
		 * 
		 */		
		public static function createExactTimer($duration:int, $from:Number, $to:Number, $onUpdate:Function=null, $onComplete:Function=null, $updateStep:Number = 0):TimerData {
			
			var obj:Object = {i:$from};
			var onUpdate:Function = ($updateStep!=0) ? onUpdate1 : onUpdate2;
			TweenLite.to(obj, $duration/1000, {i:$to, onUpdate:onUpdate, onComplete:onComplete,ease:Linear.easeNone});

			var i:Number = $from;
			var absUpdateStep:Number = Math.abs($updateStep);
			function onUpdate1():void
			{
				if(Math.abs(obj.i-i) >= absUpdateStep)
				{
					i = obj.i;
					if($onUpdate!=null)
					{
						$onUpdate(obj.i);
					}
				}
			}
			function onUpdate2():void
			{
				if($onUpdate!=null)
				{
					$onUpdate(obj.i);
				}
			}
			function onComplete():void
			{
				if($onUpdate!=null)
				{
					$onUpdate(obj.i);
				}
				if($onComplete!=null)
				{
					$onComplete();
				}
			}
			function destroy():void
			{
				TweenLite.killTweensOf(obj);
				return;
			}
			return new TimerData(null,destroy);
		}
		
		//延时回调池
		//----------------------------------------------------------------------------------------------------------------
		/**
		 * 添加一个延时回调
		 * 注意： 如果是较长的delay，建议用createTimer代替此方法
		 * @param $delay 时长 单位：毫秒
		 * @param $callBack 回调函数
		 * 
		 */	
		public static function addDelayCallBack($delay:int, $callBack:Function):void {
			//如果callback 不是函数  直接报错
			if($callBack==null && !($callBack as Function))
			{
				throw new Error("Error! $callback必须是function!");
				return;
			}
			
			//如果延时小于等于0则直接执行回调
			if($delay<=0)
			{
				$callBack();
				return;
			}
			//添加进数组和字典
			var delayData:Array = [$delay, $callBack, getTimer()];
			delayCallBackList.unshift(delayData);//添加进数组(注意是插在最前面！！！！！)
			delayCallBackDict[$callBack] = delayData;//记录在哈希map内
			
			//保证计时器监听存在
			if(delayCallBackList.length==1)
			{
				timeSprite.addEventListener(Event.ENTER_FRAME, updateDelayCallBack);
			}
			return;
		}
		/**
		 * 移除一个延时回调
		 * @param $callBack 回调函数
		 * 
		 */	
		public static function removeDelayCallBack($callBack:Function):void {
			//从数组和字典中移除
			var delayData:Array =  delayCallBackDict[$callBack];
			if(delayData!=null)
			{
				//从字典中移除
				delayCallBackDict[$callBack] = null;
				delete delayCallBackDict[$callBack];
				//从数组中移除
				var index:int = delayCallBackList.indexOf(delayData);
				if(index!=-1)
				{
					delayCallBackList.splice(index,1);
				}
			}
			
			//保证计时器被移除
			if(delayCallBackList.length==0)
			{
				timeSprite.removeEventListener(Event.ENTER_FRAME, updateDelayCallBack);
			}
			return;
		}
		/**
		 * 延时回调周期更新
		 * 
		 */	
		private static function updateDelayCallBack(e:Event):void {
			//取得现在的时间
			var nowTime:int = getTimer();
			
			//遍历检测
			var len:int = delayCallBackList.length;
			for(var i:int=len-1; i>=0; i--)//保证先添加的被先检测,并且内部可执行callBack操作
			{
				var delayData:Array = delayCallBackList[i];
				var delay:int = delayData[0];
				var callBack:Function = delayData[1];
				var addTime:int = delayData[2];
				
				//如果已打到延时
				if(nowTime-addTime>=delay)
				{
					//从字典中移除
					delayCallBackDict[callBack] = null;
					delete delayCallBackDict[callBack];
					//从数组中移除
					delayCallBackList.splice(i,1);
					
					//保证计时器被移除（注意这个不能放在最后）
					if(delayCallBackList.length==0)
					{
						timeSprite.removeEventListener(Event.ENTER_FRAME, updateDelayCallBack);
					}
					
					//执行回调
					callBack();
				}
			}
			
			return;
		}
		//----------------------------------------------------------------------------------------------------------------
	}
}