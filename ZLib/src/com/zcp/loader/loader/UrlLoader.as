package com.zcp.loader.loader
{
	import com.zcp.dispose.DisposeHelper;
	import com.zcp.loader.vo.LoadData;
	import com.zcp.loader.vo.LoadDataGroup;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	/**
	 * Url加载器
	 */	
	public class UrlLoader extends EventDispatcher
	{
		/**加载器*/
		private var _urlLoader:URLLoader;
		
		/**
		 * 是否锁定中(处于锁定中的加载器不能被重新启用)
		 */
		public var isLocked :Boolean;
		/**
		 * 是否正在加载中
		 */
		public var isLoading :Boolean;


		
		/**Binary加载数据*/
		public var loadDataGroup:LoadDataGroup;

		/**加载到的数据（类型与URLLoaderDataFormat对应）*/
		public var data:*;
		
		//当前尝试的加载次数
		private var _tryIndex:int;
		
		
		/**
		 * RslLoader
		 */		
		public function UrlLoader()
		{
			super();
			
			_urlLoader = new URLLoader()
		}
		
		/**
		 * 加载SWF
		 * @param $ldg 为null则认为是重加载
		 * @retrun
		 */		
		public function load($ldg:LoadDataGroup):void
		{
			if(isLoading)return;
			if(isLocked)
			{
				throw new Error("UrlLoader Locked!");
			}
			
			if($ldg==null)
			{
				//重试此时加1
				_tryIndex++;
			}
			else
			{
				//第一次计数为1
				_tryIndex=1;
				
				data = null;
				
				//改变标识
				loadDataGroup = $ldg;
				loadDataGroup.urlLoader = this;
				
				initUrlLoadEvent();
				
				_urlLoader.dataFormat = loadDataGroup.headLoadData.dataFormat || URLLoaderDataFormat.TEXT;
			}

			//标记拿出来  只要是下载  不管是第一次 还是后面累积的try  都需要此标记设置为true
			isLoading = true;

			//加载
			var ur:URLRequest = new URLRequest(loadDataGroup.url);
			ur.method = loadDataGroup.headLoadData.requestMethod;
			ur.data = loadDataGroup.headLoadData.requestData;
			ur.requestHeaders = loadDataGroup.headLoadData.requestHeaders;
			_urlLoader.load(ur);
			return;
		}
		/**
		 * 停止加载
		 */	
		public function stop($dispose:Boolean=true) : void
		{
			removeUrlLoadEvent();
			if($dispose)
			{
				try{
					_urlLoader.close();
				}catch(e:Error){};
			}
			//还原标识
			isLoading = false;
		}
		/**
		 * 清掉旧加载数据
		 */	
		public function clear() : void
		{
			//清楚标识!!!!
			if(loadDataGroup!=null)
			{
				loadDataGroup.urlLoader = null;
				loadDataGroup = null;
			}
			data = null;
			
			//还原标识
			isLoading = false;
			_tryIndex = 0;
		}
		
		/**
		 * @private
		 * 监听加载事件
		 */		
		private function initUrlLoadEvent() : void
		{
			_urlLoader.addEventListener(ProgressEvent.PROGRESS, onUrlProgress);
			_urlLoader.addEventListener(Event.COMPLETE, onUrlComplete);//注意这个
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onUrlError);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onUrlError);
		}
		/**
		 * @private
		 * 移除加载事件
		 */	
		private function removeUrlLoadEvent() : void
		{
			_urlLoader.removeEventListener(ProgressEvent.PROGRESS, onUrlProgress);
			_urlLoader.removeEventListener(Event.COMPLETE, onUrlComplete);//注意这个
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onUrlError);
			_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onUrlError);
		}
		/** 
		 * @private
		 * 加载完成事件 
		 */
		private function onUrlComplete(e : Event) : void
		{
//			//解密
//			var bytes:ByteArray = e.currentTarget.data;
//			if(rslLoadData.decode!=null)
//			{
//				bytes = rslLoadData.decode(bytes);
//			}
//			bytes.position = 0;
			//记录数据
			data = _urlLoader.data;
			
			stop(false);
			dispatchEvent(e);
		}
		/** 
		 * @private
		 * 加载进度事件 
		 */
		private function onUrlProgress(e : ProgressEvent) : void
		{
			dispatchEvent(e);
		}
		/** 
		 * @private
		 * 加载失败事件 
		 */
		private function onUrlError(e : Event) : void
		{
			//检测冲加载
			if(loadDataGroup.headLoadData.tryCount>1)
			{
				if(_tryIndex<loadDataGroup.headLoadData.tryCount)
				{
					isLoading = false;		//此标记必须设置, 否则在load函数中,不会对 tryIndex进行++,那就永远无法抛出加载错误的消息....		NICK
					//重加载
					load(null);
					return;
				}
			}
			
			//加载失败处理
			data = null;
			stop();
			dispatchEvent(e);
		}
	}
}