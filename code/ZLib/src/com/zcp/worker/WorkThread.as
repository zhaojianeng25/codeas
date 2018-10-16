package com.zcp.worker
{
	import com.zcp.worker.vo.WorkData;
	import com.zcp.worker.vo.WorkReturnData;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.registerClassAlias;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.system.WorkerState;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * 多线程类
	 * 1.此类只提供背景线程和主线程的通信，如果希望实现多个背景线程之间通信，请自行编写实现
	 * 2.此类只提供主线程向背景线程发送原始数据，背景线程处理数据并异步返回处理结果，其他实现请自行编写
	 * 3.当前BgWorker类只支持同步处理（背景线程中的运算目前没做异步处理支持）
	 * 4.请监听WorkThreadEvent事件
	 * 5.建议使用不要超过1个后台线程
	 * 
	 * 技巧：
	 * 1.work()方法的传入数据可以为自定义的复杂数据类型，可以将需要做不同处理的数据设置给不同的属性
	 * 2.异步返回的数据采用与work()方法的传入数据一一对应的策略
	 * 3.
	 * 
	 * Worker API解读：
	 * 无论是使用“worker.setSharedProperty()和worker.getSharedProperty()”
	 * 还是使用“MessageChannel.send()和MessageChannel.receive()”
	 * 来传输数据，只会有下面5个对象使用同一块内存地址，其他的均会被创建副本
•Worker
•MessageChannel
•可共享 ByteArray（其 shareable 属性设为 true 的 ByteArray 对象）
•Mutex
•Condition
	 * 其中，只有MessageChannel使用同一引用，其他四个均创建新的引用，但扔是指向同一内存地址
	 * @author ZCP
	 * 
	 */	
	public class WorkThread extends EventDispatcher
	{
		//是否启动完毕
		private var _ready:Boolean;
		//背景线程
		private var _bgWorker:Worker;
		//通讯通道(main --> bg)
		private var _toBgChannel:MessageChannel;
		//通讯通道(bg --> main)
		private var _toMainChannel:MessageChannel;
		/**
		 * @param $workerBytes 新线程的SWF的二进制数据
		 * @param $key 线程唯一标识(此key应与BgWorker构造中传入的参数相同)
		 * @param $registerClassList 需要注册别名的类的集合,至少包含继承自WorkData的传入数据类和继承自WorkReturnData的传出数据类
		 * @param $workReturnData 返回数据类
		 * 
		 */		
		public function WorkThread($workerBytes:ByteArray, $key:String, $registerClassList:Vector.<Class>)
		{
			//不支持
			if(!Worker.isSupported)
			{
				throw new Error("当前平台不支持多线程");
			}
			
			//注册别名
			if($registerClassList!=null)
			{
				for each(var c:Class in $registerClassList)
				{
					registerClassAlias(getQualifiedClassName(c), c);
				}
			}
			
			//创建背景线程
			_bgWorker = WorkerDomain.current.createWorker($workerBytes, true);
			_bgWorker.addEventListener(Event.WORKER_STATE, workerStateHandler);
			//通讯通道
			_toBgChannel = Worker.current.createMessageChannel(_bgWorker);
			_toMainChannel = _bgWorker.createMessageChannel(Worker.current);
			//注册通道事件
			_toMainChannel.addEventListener(Event.CHANNEL_MESSAGE, toMainChannelMessageHandler);
			//共享通道
			_bgWorker.setSharedProperty($key+"_toBg", _toBgChannel);
			_bgWorker.setSharedProperty($key+"_toMain", _toMainChannel);
			//启动
			_bgWorker.start();
		}
		//背景线程状态变化
		private function workerStateHandler(event:Event):void
		{
			//背景线程已经启动完毕
			if (_bgWorker.state == WorkerState.RUNNING) 
			{
				//线程数
				trace("######当前启用线程数:"+WorkerDomain.current.listWorkers().length);
				
				//准备完毕
				_ready = true;
				
				//发送准备完毕事件
				var wEvt:WorkThreadEvent = new WorkThreadEvent(WorkThreadEvent.WT_READY);
				dispatchEvent(wEvt);
			}
		}
		//接受消息通道收到数据
		private function toMainChannelMessageHandler(event:Event):void
		{
			if (!_toMainChannel.messageAvailable)
				return;
			
			
			//反序列化得到数据
			var bytes:ByteArray = _toMainChannel.receive() as ByteArray;
			var wrdClassName:String = bytes.readUTF();//类名
			var wrdClass:Class = getDefinitionByName(wrdClassName) as Class;//类
			var wrd:WorkReturnData = (new wrdClass()) as WorkReturnData;//实例
			wrd.fromByteArray(bytes);//反序列化得到数据
			
			//发送处理完毕返回数据事件
			var wEvt:WorkThreadEvent = new WorkThreadEvent(WorkThreadEvent.WT_DATA, wrd);
			dispatchEvent(wEvt);
		}

		
		/**
		 * 使用背景线程处理数据 
		 * @param $originalData 原始数据
		 * @return 
		 * 
		 */		
		public function work($wd:WorkData):void
		{
			if(!_ready)
			{
				throw new Error("WorkThread尚未准备完毕");
			}
			
			//发送序列化数据
			_toBgChannel.send($wd.toByteArray());
		}
		

	}
}