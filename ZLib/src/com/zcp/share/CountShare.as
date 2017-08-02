package com.zcp.share
{
	import com.zcp.log.ZLog;
	import com.zcp.timer.Tick;
	
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 * 计数共享
	 * @author zcp
	 * 
	 */	
	public class CountShare
	{
		/**
		 * 存储数据字典
		 * key: 唯一的键值
		 * value: CountShareData
		 * 
		 */
		private var _shareDataDict:Dictionary;
		/**
		 * 等待延时卸载的数据字典
		 * key: 唯一的键值
		 * value: 最后一个该key对应的值被移除的时间
		 */
		private var _waitingDestroyShareDataDict:Dictionary;
		
		//延时销毁时间(计数为0的对象在此事件后会被销毁)，单位：毫秒
		private var _destroyDelay:int;
		
		//缓存的ShareData数量
		private var _count:int = 0;
		
		/**
		 * @param $destroyDelay 延时销毁时间(计数为0的对象在此事件后会被销毁)，单位：毫秒
		 * 
		 */		
		public function CountShare($destroyDelay:int)
		{
			_destroyDelay = $destroyDelay;
			_shareDataDict = new Dictionary();
			_waitingDestroyShareDataDict = new Dictionary();
			
			//添加进帧循环
			Tick.addCallback(checkUninstall);
		}
		
		/**
		 * 检查缓存中有没有指定数据
		 * @parm $key
		 * @return
		 */
		public function hasShareData($key:String):Boolean
		{
			return _shareDataDict[$key] != null;
		}
		/**
		 * 获取指定数据(注意只起到获取作用，不改变计数)
		 * @parm $key
		 * @return
		 */
		public function getShareData($key:String):CountShareData
		{
			return _shareDataDict[$key] as CountShareData;
		}
		/**
		 * 添加数据进缓存(注意只起到添加进缓存的作用，不改变计数)
		 * @parm $key
		 * @return
		 */
		public function addShareData($key:String, $csd:CountShareData):void
		{
			var csd:CountShareData = getShareData($key);
			if(csd==null)
			{
				_shareDataDict[$key] = $csd;
				//////////////////////////////////////////////////////////
				_count++;
//				trace("缓存数量增加 :　"　+ _count);
			}
			else
			{
				throw new Error("error:key为"+$key+"的数据已存在");
			}
		}
		/**
		 * 从缓存中移除数据（强制从缓存和计数管理中移除）
		 * @parm $key
		 * @return
		 */
		public function removeShareData($key:String):void
		{
			var csd:CountShareData = getShareData($key);
			if(csd!=null)
			{
				//调用释放
				csd.destroy();
				
				_shareDataDict[$key] = null;
				delete _shareDataDict[$key];
				
				_waitingDestroyShareDataDict[$key] = null;
				delete _waitingDestroyShareDataDict[$key];
				
				_count--;
			}
		}
		/**
		 * 装载对象（该对象计数会被加1）
		 * @parm $key
		 * @return
		 */
		public function installShareData($key:String):CountShareData
		{
			var csd:CountShareData = _shareDataDict[$key] as CountShareData;
			csd.count += 1;
			
			//从等待卸载缓存中移除
			if(_waitingDestroyShareDataDict[$key]!=null)
			{
				_waitingDestroyShareDataDict[$key] = null;
				delete _waitingDestroyShareDataDict[$key];
			}
			return csd;
		}
		/**
		 *  卸载对象（该对象计数会被减1）
		 * @parm $key
		 */
		public function uninstallShareData($key:String):void
		{
			var csd:CountShareData = _shareDataDict[$key] as CountShareData;
			if(csd) 
			{
				csd.count -= 1;
				if(csd.count==0)
				{
					//添加进准备卸载区域
					if(_waitingDestroyShareDataDict[$key]==null)
					{
						_waitingDestroyShareDataDict[$key] = getTimer();
					}
					else
					{
						throw new Error("error:不应该");
					}
				}
				else if(csd.count<0)
				{
					throw new Error("error:不应该");
				}
			}
		}
		
		/**
		 * 立即卸载所有对象
		 */
		public function uninstallAll():void
		{
			_waitingDestroyShareDataDict = new Dictionary();
			var key:String;
			for(key in _shareDataDict)
			{
				//从数据缓存中确实卸载
				var csd:CountShareData = _shareDataDict[key] as CountShareData;
				if(csd)
				{
					//调用释放
					csd.destroy();
					_shareDataDict[key] = null;
					delete _shareDataDict[key];
					
					_count--;
				}
			}
		}
		/**
		 * 立即卸载所有等待延时卸载的对象
		 */
		public function uninstallAllWait():void
		{
			var key:String;
			for(key in _waitingDestroyShareDataDict)
			{
				//从等待卸载记录中移除
				_waitingDestroyShareDataDict[key] = null;
				delete _waitingDestroyShareDataDict[key];
				
				//从数据缓存中确实卸载
				var csd:CountShareData = _shareDataDict[key] as CountShareData;
				if(csd)
				{
					if(csd.count == 0)
					{
						//调用释放
						csd.destroy();
						_shareDataDict[key] = null;
						delete _shareDataDict[key];
						
						_count--;
					}
					else
					{
						throw new Error("error:不应该");
					}
				}
			}
		}
		
		
		//延时卸载**********************************************************************************************************
		//检测延时卸载的频度控制辅助参数
		private var count:int = 0;
		/**
		 * @private
		 * 检测延时卸载项
		 */
		private function checkUninstall():void
		{
			//700帧检测一次
			if(++count<700 && !Tick.isSleepMode)//并且不在睡眠模式中
			{
				return;
			}
			count %= 700;
			
			//获取系统时间
			var nowTime:int = getTimer();
			var cnt:uint = 0;
			//检查卸载
			var key:String;
			var csd:CountShareData;
			for(key in _waitingDestroyShareDataDict)
			{
				cnt++;
				if(nowTime - _waitingDestroyShareDataDict[key] > _destroyDelay)
				{
					//从等待卸载记录中移除
					_waitingDestroyShareDataDict[key] = null;
					delete _waitingDestroyShareDataDict[key];
					
					//从数据缓存中确实卸载
					csd = _shareDataDict[key] as CountShareData;
					if(csd)
					{
						if(csd.count == 0)
						{
							//调用释放
							csd.destroy();
							_shareDataDict[key] = null;
							delete _shareDataDict[key];
							
							_count--;
						}
						else
						{
							throw new Error("error:不应该");
						}
					}
				}
			}
//			for(key in _shareDataDict)
//			{
//				csd = _shareDataDict[key] as CountShareData;
//				trace(key + " : " + csd.count);
//			}
//			trace("###等待移除缓存数量 :　"　+ cnt);
		}
		//**********************************************************************************************************
	}
}