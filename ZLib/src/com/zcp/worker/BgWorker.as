package com.zcp.worker
{
	import com.zcp.worker.vo.WorkData;
	import com.zcp.worker.vo.WorkReturnData;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.registerClassAlias;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 背景线程SWF内背景线程处理类需要继承自此类
	 * 1.请复写BgWorker.work函数
	 * @author ZCP
	 * 
	 */	
	public class BgWorker extends Sprite
	{
		//通讯通道(main --> bg)
		private var _toBgChannel:MessageChannel;
		//通讯通道(bg --> main)
		private var _toMainChannel:MessageChannel;
		
		/**
		 * @param $key 线程唯一标识
		 * @param $registerClassList 需要注册别名的类的集合,至少包含继承自WorkData的传入数据类和继承自WorkReturnData的传出数据类
		 * @param $workReturnData 返回数据类
		 */	
		public function BgWorker($key:String,$registerClassList:Vector.<Class>)
		{
			//注册别名
			if($registerClassList!=null)
			{
				for each(var c:Class in $registerClassList)
				{
					registerClassAlias(getQualifiedClassName(c), c);
				}
			}
			
			//通讯通道
			_toBgChannel = Worker.current.getSharedProperty($key+"_toBg") as MessageChannel;
			_toMainChannel = Worker.current.getSharedProperty($key+"_toMain") as MessageChannel;
			//注册通道事件
			_toBgChannel.addEventListener(Event.CHANNEL_MESSAGE, toBgChannelHandler);
		}
		
		//背景线程收到数据
		private function toBgChannelHandler(event:Event):void
		{
			if (!_toBgChannel.messageAvailable)
				return;
			
			//反序列化得到数据
			var bytes:ByteArray = _toBgChannel.receive() as ByteArray;
			var wdClassName:String = bytes.readUTF();//类名
			var wdClass:Class = getDefinitionByName(wdClassName) as Class;//类
			var wd:WorkData = (new wdClass()) as WorkData;//实例
			wd.fromByteArray(bytes);//反序列化得到数据
			
			//处理数据
			var wrd:WorkReturnData = work(wd);
			
			//处理完毕返回数据
			_toMainChannel.send(wrd.toByteArray());
		}
		/**
		 * 数据处理函数(请复写此函数) 
		 * @param $d
		 * @return 
		 * 
		 */		
		protected function work($wd:WorkData):WorkReturnData
		{
			throw new Error("此函数必须被复写");
			return null;
		}
	}
}