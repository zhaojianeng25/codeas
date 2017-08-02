package com.zcp.loader.loader
{
	import com.zcp.dispose.DisposeHelper;
	import com.zcp.loader.vo.LoadData;
	import com.zcp.loader.vo.LoadDataGroup;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	/**
	 * RSL加载器
	 */	
	public class DobjLoader extends EventDispatcher
	{
		/**加载器*/
		private var _urlLoader:URLLoader;
		private var _loader:Loader;
		
		/**
		 * @private
		 * LoaderContext
		 */
		private var _context : LoaderContext;
		
		
		
		
		/**
		 * 是否锁定中(处于锁定中的加载器不能被重新启用)
		 */
		public var isLocked :Boolean;
		/**
		 * 是否正在加载中
		 */
		public var isLoading :Boolean;


		
		/**加载组*/
		public var loadDataGroup:LoadDataGroup;

		/**加载到的数据（为MovieClip或Bitmap）*/
		public var content:DisplayObject;
		
		
		//当前尝试的加载次数
		private var _tryIndex:int;
		
		
		/**
		 * RslLoader
		 */		
		public function DobjLoader()
		{
			super();
			
			
			_context = new LoaderContext();
			//设置安全域
//			if(Security.sandboxType==Security.REMOTE)
//			{
//				_context.securityDomain = SecurityDomain.currentDomain;
//			}
			try{
				_context['allowLoadBytesCodeExecution'] = true;
			}catch(e:Error){}
			try{
				_context["allowCodeImport"] = true;
			}catch(e:Error){}
			//设置应用程序域
			//_context.applicationDomain = ApplicationDomain.currentDomain;
			
			
			
			_urlLoader = new URLLoader()
			_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			
			
			_loader = new Loader();
			
		}
		
		/**
		 * 加载SWF
		 * @param $ldg  为null则认为是重加载
		 * @retrun
		 */		
		public function load($ldg:LoadDataGroup):void
		{
			if(isLoading)return;
			if(isLocked)
			{
				throw new Error("DobjLoader Locked!");
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
					
				content = null;
				
				//改变标识
				loadDataGroup = $ldg;
				loadDataGroup.dobjLoader = this;
				
				initUrlLoadEvent();
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
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			if($dispose)
			{
				try{
					_urlLoader.close();
				}catch(e:Error){};
				try{
					//_loader.unloadAndStop(false);//1111111111true参数可能会比较消耗性能
					_loader.close();//此句多余哦，而且必然引起错误111111111111111
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
				loadDataGroup.dobjLoader = null;
				loadDataGroup = null;
			}
			content = null;
			
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
			//解密
			var bytes:ByteArray = e.currentTarget.data;
			if(bytes.length==0)
			{
				onUrlError(e);
				return;
			}
			if(loadDataGroup.headLoadData.decode!=null)
			{
				bytes = loadDataGroup.headLoadData.decode(bytes);
			}
			bytes.position = 0;
			
			//将解密后的二进制数据加载到制定域
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			
//			//加载显示对象 (因为IOS下不支持多域加载，所以最好统一使用ApplicationDomain.currentDomain，而不指定为其他域或者null)
//			if(rslLoadData.dataFormat==LoadData.LOADER_DISPLAYOBJECT)
//			{
//				//设置应用程序域
//				_context.applicationDomain = null;
//			}
//			else//加载导出类
//			{
				//设置应用程序域
				_context.applicationDomain = loadDataGroup.headLoadData.applicationDomain!=null?loadDataGroup.headLoadData.applicationDomain:ApplicationDomain.currentDomain;
				_context.allowCodeImport = true;
//			}
			try{
				_context.imageDecodingPolicy = loadDataGroup.headLoadData.imageDecodingPolicy;
			}catch(e:Error){}
			_loader.loadBytes(bytes, _context);
			
//			//释放11111111111111111111111
//			if(bytes!=e.currentTarget.data)
//			{
//				DisposeHelper.add(e.currentTarget.data);
//				e.currentTarget.data = null;
//			}
//			DisposeHelper.add(bytes);
//			bytes = null;
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
			content = null;
			stop();
			dispatchEvent(e);
		}
		/** 
		 * @private
		 * 加载完成事件 
		 */
		private function onComplete(e : Event) : void
		{
			//记录
			content = _loader.content;

			//添加进容器!!!
			if(content!=null)
			{
				if(loadDataGroup.headLoadData.dataFormat==LoadData.LOADER_DISPLAYOBJECT && loadDataGroup.headLoadData.container!=null)
				{
					loadDataGroup.headLoadData.container.addChild(content);
				}
			}
			
			stop(false);
			dispatchEvent(e);
		}
		
		
		
		
		
		//常用
		//==============================================================================
		/**
		 * 获取类
		 * @param $className	类名称
		 * @param $applicationDomain	哪个域
		 * @return			获取的类定义，如果不存在返回null
		 * 
		 */		
		public static function getClass($className : String, $applicationDomain:ApplicationDomain=null) : Class
		{
			if($className==null||$className=="")return null;
			if($applicationDomain==null)
			{
				$applicationDomain = ApplicationDomain.currentDomain;
			}
			if ($applicationDomain.hasDefinition($className))
			{
				return $applicationDomain.getDefinition($className) as Class;
			}
			else
			{
				//ZLog.add("类“"+$className+"”不存在");
			}
			return null;
		}
		
		/**
		 * 获取指定类名的实例
		 * 
		 * @param $className	类名称，必须包含完整的命名空间
		 * @param $applicationDomain	哪个域
		 * @param str			参数集合
		 * @return				类的一个实例，如果不存在返回null
		 */	
		public static function getInstance($className:String, $applicationDomain:ApplicationDomain=null, ... str:*) : *
		{
			var Instance:Class = getClass($className, $applicationDomain);
			var instance:* = getInstanceByClass(Instance,str);
			return instance;
		}
		/**
		 * 获取指定类的实例
		 * 
		 * @param $class	类名称，必须包含完整的命名空间
		 * @param $params			参数的数组
		 * @return				类的一个实例，如果不存在返回null
		 * 说明：现在最多支持15个参数的类
		 */	
		public static function getInstanceByClass($class:Class, $params:Array=null) : *
		{
			if($class==null)return null;
			var instance:*;
			var len:int = $params ? $params.length : 0 ;
			switch(len)
			{
				case 0:
					instance = new $class();
					break;
				case 1:
					instance = new $class($params[0]);
					break;
				case 2:
					instance = new $class($params[0], $params[1]);
					break;
				case 3:
					instance = new $class($params[0], $params[1], $params[2]);
					break;
				case 4:
					instance = new $class($params[0], $params[1], $params[2], $params[3]);
					break;
				case 5:
					instance = new $class($params[0], $params[1], $params[2], $params[3], $params[4]);
					break;
				case 6:
					instance = new $class($params[0], $params[1], $params[2], $params[3], $params[4], $params[5]);
					break;
				case 7:
					instance = new $class($params[0], $params[1], $params[2], $params[3], $params[4], $params[5], $params[6]);
					break;
				case 8:
					instance = new $class($params[0], $params[1], $params[2], $params[3], $params[4], $params[5], $params[6], $params[7]);
					break;
				case 9:
					instance = new $class($params[0], $params[1], $params[2], $params[3], $params[4], $params[5], $params[6], $params[7], $params[8]);
					break;
				case 10:
					instance = new $class($params[0], $params[1], $params[2], $params[3], $params[4], $params[5], $params[6], $params[7], $params[8], $params[9]);
					break;
				case 11:
					instance = new $class($params[0], $params[1], $params[2], $params[3], $params[4], $params[5], $params[6], $params[7], $params[8], $params[9], $params[10]);
					break;
				case 12:
					instance = new $class($params[0], $params[1], $params[2], $params[3], $params[4], $params[5], $params[6], $params[7], $params[8], $params[9], $params[10], $params[11]);
					break;
				case 13:
					instance = new $class($params[0], $params[1], $params[2], $params[3], $params[4], $params[5], $params[6], $params[7], $params[8], $params[9], $params[10], $params[11], $params[12]);
					break;
				case 14:
					instance = new $class($params[0], $params[1], $params[2], $params[3], $params[4], $params[5], $params[6], $params[7], $params[8], $params[9], $params[10], $params[11], $params[12], $params[13]);
					break;
				case 15:
					instance = new $class($params[0], $params[1], $params[2], $params[3], $params[4], $params[5], $params[6], $params[7], $params[8], $params[9], $params[10], $params[11], $params[12], $params[13], $params[14]);
					break;
			}
			return instance;
		}
		//==============================================================================
		
	}
}