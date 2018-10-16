package com.zcp.handle
{
	import com.greensock.TweenLite;
	import com.zcp.timer.TimerHelper;
	
	/**
	 * 函数执行伪线程
	 * @author zcp
	 * 
	 */	
	public class HandleThread
	{
		/**原始等待执行函数数组(HandlerData数组)*/
		private var _handleDataArr:Vector.<HandleData>;
		/**进Timer的等待执行函数数组(HandlerData数组)(从_handleDataArr中移除后，添加到time中等待执行但还未被执行时)*/
		private var _handleDataReadyArr:Vector.<HandleData>;
		
		
		private var _isRunning:Boolean ;//是否正在运行
		
		private var _canRun:Boolean ;//强制开始或停止
		
		private var _isQueue:Boolean ;//是否是以队列queue形式（先进先出）执行（否则以栈stack的形式执行）
		
		private var _next:HandleData;
		/**
		 * HandleThread
		 * @param $handlerArr	数据类型：HandlerData数组
		 * @param $isQueue	是否是以队列queue形式（先进先出）执行（否则以栈stack的形式执行）
		 * 
		 */	
		public function HandleThread($handlerArr:Vector.<HandleData>=null,$isQueue:Boolean=true)
		{
			_handleDataArr = $handlerArr || new Vector.<HandleData>;
			_handleDataReadyArr = new Vector.<HandleData>;
			_isQueue = $isQueue;
			_isRunning = false;
			_canRun = true;
			_next = null;
		}
		
		
		/**
		 * 立即执行某函数
		 * 
		 */			
		public static function execute($handler:Function, $parameters:Array=null):*
		{
			if($handler==null)return null;
			return $handler.apply(null,$parameters);
		}
		
		
		/**
		 * 线程是否正在运行
		 */
		public function get isRunning():Boolean
		{
			return _isRunning;
		}
		/**
		 * 获取等待执行的函数数量(只返回_handleDataArr内的，不包括_handleDataReadyArr内的)
		 */			
		public function getHandlersNum():int
		{
			return _handleDataArr.length;
		}		
		
		/**
		 * 添加函数到执行队列(执行完一个执行另一个，可设置每个函数的延时延时)（强烈建议保持传进的每个函数唯一,如果不唯一请嵌套一层函数使之唯一）
		 * 此方法不能获取函数返回值
		 * @param $handler 函数
		 * @param $parameters 参数数组
		 * @param $delay 延时（单位：毫秒）
		 * @param $doNext 执行完毕是否自动执行下一个
		 * @param $autoStart 是否自动开始]
		 * @param $priority 是否优先执行
		 */		
		public function push($handler:Function, $parameters:Array=null,$delay:Number=0,$doNext:Boolean=true,$autoStart:Boolean=true,$priority:Boolean=false):void
		{
			//添加进数组
			var handleData:HandleData = new HandleData($handler,$parameters,$delay,$doNext);
			if($priority)
			{
				_handleDataArr.unshift(handleData);
			}
			else
			{
				_handleDataArr.push(handleData);
			}
			//如果处在休息状态，则执行下一个命令
			if(_canRun && $autoStart && !_isRunning)
			{
				executeNext();
			}
			return;
		}
		/**
		 * 取消所有未执行函数的执行
		 * 
		 */			
		public function removeAllHandlers():void
		{
			//清空_handleDataArr
			_handleDataArr.length=0;
			//清空_handleDataReadyArr
			_handleDataReadyArr.length=0;
			//改变标志位
			_isRunning = false;
			return;
		}
		/**
		 * 取消某个未执行函数的执行(将移除与此参数给定的函数有关的所有HandlerData)
		 * @param $handler
		 */			
		public function removeHandler($handler:Function):void
		{
			if($handler==null)return;			
			//从_handleDataArr中移除
			var hData:HandleData;
			var len:int = _handleDataArr.length;
			while(len-->0)
			{
				hData = _handleDataArr[len];
				if(hData.handler==$handler)
				{
					_handleDataArr.splice(len,1);
					//break;//这里不用break
				}
			}
			//从_handleDataReadyArr中移除
			len = _handleDataReadyArr.length;
			while(len-->0)
			{
				hData = _handleDataReadyArr[len];
				if(hData.handler==$handler)
				{
					_handleDataReadyArr.splice(len,1);
					//break;//这里不用break
				}
			}
			//改变标志位
			if(_handleDataArr.length==0 && _handleDataReadyArr.length==0)
			{
				_isRunning = false;
			}
			return;
		}
		/**
		 * 是否存在指定的等待执行的函数
		 * @param $handler
		 */			
		public function hasHandler($handler:Function):Boolean
		{
			var hData:HandleData;
			//检测_handleDataArr内
			for each(hData in _handleDataArr)
			{
				if(hData.handler==$handler)
				{
					return true;
				}
			}
			//检测_handleDataReadyArr内
			for each(hData in _handleDataReadyArr)
			{
				if(hData.handler==$handler)
				{
					return true;
				}
			}
			return false;
		}
		/**
		 * 开始执行
		 * 
		 */			
		public function start():void
		{
			_canRun = true;
			if(!_isRunning)
			{
				executeNext();
			}
		}
		/**
		 * 停止执行
		 * 
		 */			
		public function stop():void
		{
			_canRun = false;
			return;
		}
		/**
		 * @private
		 * 设置运行状态为未运行
		 * 
		 */			
		private function setNotRunning():void
		{
			_isRunning = false;
			return;
		}
		//=======================================================================================================
		
		//对内方法
		//=======================================================================================================
		/**
		 * @private
		 * 执行下一条命令
		 * 
		 */			
		private function executeNext():void
		{
			//是否允许运行
			if(!_canRun)
			{
				_isRunning = false;
				return;
			}
			
			//判断是否到达尾部
			if(_handleDataArr.length==0)
			{
				_isRunning = false;	
				return;
			}
			
			//改变状态标识
			_isRunning = true;
			
			//获取最下一个等待执行的事件
			_next = (_isQueue ? _handleDataArr.shift() : _handleDataArr.pop()) as HandleData;
			
			//执行
			//如果是延时函数，则执行延时处理
			if(_next.delay>0)
			{
				//添加进等待执行字典
				addReadyHD(_next);
				//创建延时TimerData
//				TimerHelper.createTimer(
//					_next.delay,
//					1,//注意这里只给一次
//					newHandler,
//					null,
//					null,
//					null,
//					true
//				);
				TweenLite.delayedCall(_next.delay*0.001,newHandler);
//				//创建延时TimerData
//				TimerManager.addDelayCallBack(
//					_next.delay,
//					newHandler
//				);
			}
				//否则直接运行
			else
			{
				execute(_next.handler,_next.parameters);
				//如果需要执行下一个则执行下一个
				_next.doNext?executeNext():setNotRunning();
			}
		}
		
		private function newHandler():void
		{
			//新的执行函数
			//从等待字典移除，同时验证存在性
			if(removeReadyHD(_next))
			{
				//执行函数
				execute(_next.handler,_next.parameters);
			}
			//如果需要执行下一个则执行下一个
			_next.doNext?executeNext():setNotRunning();
		}
		
		/**
		 * @private
		 * 向_handleDataReadyArr中添加
		 *  @parm $hd
		 */	
		private function addReadyHD($hd:HandleData):void
		{
			if(_handleDataReadyArr.indexOf($hd)!=-1)return;
			_handleDataReadyArr.push($hd);
		}
		/**
		 * @private
		 * 从_handleDataReadyArr中移除
		 *  @parm $fun 执行函数
		 *  @return 移除成功返回true, 移除失败或不存在返回false
		 */	
		private function removeReadyHD($hd:HandleData):Boolean
		{
			var index:int = _handleDataReadyArr.indexOf($hd);
			if(index!=-1)
			{
				//从数组中移除
				_handleDataReadyArr.splice(index,1);
				return true;
			}
			return false;
		}
		//=======================================================================================================				
	}
}