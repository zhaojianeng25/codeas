package com.zcp.loader
{
	import com.zcp.loader.loader.UrlLoader;
	import com.zcp.loader.vo.LoadData;
	import com.zcp.loader.vo.LoadDataGroup;
	import com.zcp.log.ZLog;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.Dictionary;
	
	/**
	 * Binary队列加载管理器
	 * 此类功能：加载URLLoader可加载的数据
	 * 回调函数格式：
	 * function callBack(LoadData, Event);void{}
	 * 加载之后“不会”自动执行LoadData中的解压解密函数
	 * 并没有做同一加载地址的处理
	 * @author zcp
	 * 
	 */	
	public class UrlLoadManager
	{
		/**
		 * 等待加载的数据
		 * data: LoadDataGroup
		 * */
		private static var waitLoadList:Array = [];//:Vector.<LoadDataGroup> = new Vector.<LoadDataGroup>();
		/**
		 * 所有加载器的集合
		 * data: UrlLoader
		 * */
		private static var loaderList:Vector.<UrlLoader> = new Vector.<UrlLoader>();
		
		/**
		 * 并行加载的默认最大上限
		 */		
		private static const MAX_THREAD_NUM:int = 20;
		/**并行加载最大条数*/
		private static var _max_thread:int = MAX_THREAD_NUM;
		
		
		/** 是否启用  忽略曾经下载失败的文件的下载请求 */
		public static var ignoreErrorRequest:Boolean = false;
		/**
		 * 曾经下载失败的资源地址集合, 处于此列表中的url, 全都是 trycount次数已经达到指定值的文件
		 */		
		private static var _errorList:Dictionary = new Dictionary(); 
		
		
		public function UrlLoadManager()
		{
	        throw new Error("Can not New!");
		}

		
		//公有
		//==============================================================================
		/**
		 * 加载URL
		 * @param $loadData
		 * 回调函数格式：function callBack(LoadData, Event);void{}
		 * 
		 */		
		public static function load($ld:LoadData):void
		{
			if( !$ld )
				return;
			
			//如果此url处于下载错误的列表中, 并且此时是 "忽略曾经下载错误的文件请求" 时, 直接退出
			if(ignoreErrorRequest && _errorList[$ld.url]==true)
			{
				if($ld.onError!=null)
				{
					$ld.onError($ld, null);
				}
				return;
			}
			
			//如果是需要合并的加载，则合并进加载组
			var ldGroup:LoadDataGroup;
			if($ld.mergeSameURL)
			{
				//查找可合并的组
				for each(var ldg:LoadDataGroup in waitLoadList)
				{
					if(ldg.mergeSameURL && ldg.url==$ld.url)
					{
						ldGroup = ldg;
						break;
					}
				}
			}
			//如果加载组不存在则创建加载组，并添加进加载列表
			if(ldGroup==null)
			{
				ldGroup = new LoadDataGroup($ld.clone());//使用一个副本
				waitLoadList.push(ldGroup);
				waitLoadList.sortOn("priority", Array.DESCENDING | Array.NUMERIC);//排序
			}
			//将当前加载项目添加进加载组
			ldGroup.loadDataMap.push($ld);
			
			
			//如果当前加载组正在加载则返回
			if(ldGroup.urlLoader!=null)return;
			
			
			//取得一个空闲的加载器,如果加载器不为空,则开始执行加载
			var rslLoader:UrlLoader = getFreeLoader(ldGroup.priority);
			if(rslLoader!=null)
			{
				//开始执行加载
				loadNext(rslLoader);
			}
			
			return;
		}
		/**
		 * 懒惰加载URL
		 * @param $url	加载文件的URL
		 * @param $dataFormat	加载文件的格式(应该为LoadData中常量)
		 * @param $callBack  格式：function callBack(LoadData, Event);void{}
		 * @param $priority	加载优先级
		 * 
		 */		
		public static function lazyLoad($url:String,$dataFormat:String=null, $callBack:Function=null, $priority:int=0):void
		{
			//生成简单的LoadData
			var loadData:LoadData = new LoadData($url,$callBack,null,null,"","",$priority,$dataFormat);
			
			load(loadData);
			return;
		}
		/**
		 * 取消加载与 某地址 相关的项
		 * @param $url	加载地址
		 * 
		 */		
		public static function cancelLoadByUrl($url:String):void
		{
			//检测等待加载的列表
			var cancelSucc:Boolean;
			var len:int = waitLoadList.length;
			for(var i:int=len-1; i>=0; i--)
			{
				var ldg:LoadDataGroup = waitLoadList[i];
				if(ldg.url==$url)
				{
					//从加载列表中移除
					waitLoadList.splice(i, 1);
					//停止加载
					var dl:UrlLoader = ldg.urlLoader;
					if(dl!=null)
					{
						removeLoadEvent(dl);
						dl.stop();
						dl.clear();
					}
					//改变标识
					cancelSucc = true;
				}
			}
			
			//如果有加载被取消，则尝试利用被取消的加载器去执行新的加载
			if(cancelSucc)
			{
				loadNext();
			}

			return;
		}
		/**
		 * 取消加载与 某单独回调 相关的项
		 * @param $urlCallBack	某加载地址的单独回调
		 * 
		 */		
		public static function cancelLoadByUrlCallBack($urlCallBack:Function):void
		{
			//检测等待加载的
			var cancelSucc:Boolean;
			var len:int = waitLoadList.length;
			for(var i:int=len-1; i>=0; i--)
			{
				//遍历每个加载组,去掉回调匹配的加载项
				var ldg:LoadDataGroup = waitLoadList[i];
				for(var j:int=ldg.loadDataMap.length-1; j>=0;j--)
				{
					var ld:LoadData = ldg.loadDataMap[j];
					if(ld.onComplete==$urlCallBack)
					{
						ldg.loadDataMap.splice(j, 1);
					}
				}
				
				//如果加载组长度为0，则去掉该加载组
				if(ldg.loadDataMap.length==0)
				{
					//从加载列表中移除
					waitLoadList.splice(i, 1);
					//停止加载
					var dl:UrlLoader = ldg.urlLoader;
					if(dl!=null)
					{
						removeLoadEvent(dl);
						dl.stop();
						dl.clear();
					}
					//改变标识
					cancelSucc = true;
				}
			}
			
			//如果有加载被取消，则尝试利用被取消的加载器去执行新的加载
			if(cancelSucc)
			{
				loadNext();
			}
			
			return;
		}
		/**
		 * 取消加载与 某地址和某回调  的相关的项
		 * @param $url	加载地址
		 * @param $url	单独回调
		 */		
		public static function cancelLoadByUrlAndUrlCallBack($url:String, $urlCallBack:Function):void
		{
			//检测等待加载的
			var cancelSucc:Boolean;
			var len:int = waitLoadList.length;
			for(var i:int=len-1; i>=0; i--)
			{
				//遍历每个加载组,去掉回调匹配的加载项
				var ldg:LoadDataGroup = waitLoadList[i];
				if(ldg.url==$url)
				{
					for(var j:int=ldg.loadDataMap.length-1; j>=0;j--)
					{
						var ld:LoadData = ldg.loadDataMap[j];
						if(ld.onComplete==$urlCallBack)
						{
							ldg.loadDataMap.splice(j, 1);
						}
					}
					
					//如果加载组长度为0，则去掉该加载组
					if(ldg.loadDataMap.length==0)
					{
						//从加载列表中移除
						waitLoadList.splice(i, 1);
						//停止加载
						var dl:UrlLoader = ldg.urlLoader;
						if(dl!=null)
						{
							removeLoadEvent(dl);
							dl.stop();
							dl.clear();
						}
						//改变标识
						cancelSucc = true;
					}
				}
			}
			
			//如果有加载被取消，则尝试利用被取消的加载器去执行新的加载
			if(cancelSucc)
			{
				loadNext();
			}
			
			return;
		}
		/**并行加载最大条数*/
		public static function set maxThread($value:uint):void
		{
			var oldThread:uint = _max_thread;
			_max_thread = $value;
			
			if(_max_thread == oldThread)return;//新线程数和老线程数一样，直接返回
			
			if(_max_thread>oldThread)//新线程数比老的多，则检测新的加载
			{
				//加载下一个
				loadNext(null);//注意这里传null
			}
			else//否则暂停一些加载
			{
				//依次去掉优先级较低的加载
				//==========================================
				var len:int = loaderList.length;
				if(len>0)
				{
					//先弄一个按加载优先级排序的加载器数组
					var tempArr:Array = [];
					var tempArr2:Array = [];
					for(var i:int=0; i<len; i++)
					{
						var dl:UrlLoader = loaderList[i];
						var ldg:LoadDataGroup = dl.loadDataGroup;
						if(ldg!=null)
						{
							tempArr.push({priority:ldg.priority, loader:dl});
						}
						else
						{
							tempArr2.push({priority:-int.MAX_VALUE, loader:dl});
						}
					}
					tempArr.sortOn("priority", Array.DESCENDING | Array.NUMERIC);//排序
					tempArr = tempArr.concat(tempArr2);//合并
					
					//之后依次检测
					len = tempArr.length;
					while(loaderList.length > _max_thread)
					{
						len--;
						if(len==-1)break;
						
						dl = tempArr[len].loader;
						//停止加载
						if(dl.isLoading && !dl.isLocked)
						{
							removeLoadEvent(dl);
							dl.stop();
							dl.clear();
						}
						//从加载器数组中移除
						var index:int = loaderList.indexOf(dl);
						loaderList.splice(index, 1);
					}
				}
				//==========================================
				
			}
		}
		
		/**
		 * 还原最大上限 
		 */		
		public static function revertMaxThread():void
		{
			maxThread = MAX_THREAD_NUM;
		}
		//==============================================================================
		
		//私有
		//==============================================================================
		/**
		 * 获取空闲的加载器
		 * @param $priority 低于此优先级的
		 * 
		 */		
		private static function getFreeLoader($priority:int=0):UrlLoader
		{
			var rslLoader:UrlLoader;
			
			//先寻找空闲的
			for each(rslLoader in loaderList)
			{
				if(!rslLoader.isLocked && !rslLoader.isLoading)//如果未处于锁定状态， 且未处于运行状态
				{
					if(rslLoader.loadDataGroup==null)
					{
						return rslLoader;
					}
				}
			}
			
			
			//再看是否线程满了
			if(loaderList.length<_max_thread)
			{
				rslLoader = new UrlLoader();
				//添加进数组
				loaderList.push(rslLoader);
				return rslLoader;
			}
			
			
			//最后查找替换较低线程的
			var lowLoader:UrlLoader
			for each(rslLoader in loaderList)
			{
				if(
					!rslLoader.isLocked //如果未处于锁定状态
					&&
					(lowLoader==null || lowLoader.loadDataGroup.priority>rslLoader.loadDataGroup.priority))
				{
					lowLoader = rslLoader;
				}
			}
			if(lowLoader!=null && lowLoader.loadDataGroup.priority<$priority)
			{
				//暂停掉该加载器
				removeLoadEvent(lowLoader);
				lowLoader.stop();
				lowLoader.clear();
				
				return lowLoader;
			}
			return null;
		}
		/**
		 * 加载下一个
		 * @param $rslLoader 如果为null则自动获取一个
		 *  
		 */			
		private static function loadNext($rslLoader:UrlLoader=null):void
		{
			var rslLoader:UrlLoader = $rslLoader;
			//如果已经被移除，而不再加载器数组内则不启用该加载器
			var index:int = loaderList.indexOf(rslLoader);
			if(index==-1)
			{
				rslLoader = null;
			}
			//如果为null则自动获取一个
			if(rslLoader==null)
			{
				rslLoader = getFreeLoader(-int.MAX_VALUE);//给一个最低的优先级以保证不是替换
			}
			
			if(rslLoader==null)return;
			if(rslLoader.isLoading)return;
			
			for(var i:int=0; i<waitLoadList.length; i++)
			{
				var ldg:LoadDataGroup = waitLoadList[i];//取得最高优先级的一个未加载组
				if(ldg.urlLoader==null)
				{
					//加载
					initLoadEvent(rslLoader);
					rslLoader.load(ldg);	
					
					//争取下一个加载
					loadNext(null);//注意这里传null
					break;
				}
			}
			return;
		}
		
		private static function initLoadEvent($rslLoader:UrlLoader) : void
		{
			$rslLoader.addEventListener(Event.COMPLETE, rslLoaderHandler);
			$rslLoader.addEventListener(ProgressEvent.PROGRESS, rslLoaderHandler);
			$rslLoader.addEventListener(IOErrorEvent.IO_ERROR, rslLoaderHandler);
			$rslLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, rslLoaderHandler);
			return;
		}
		private static function removeLoadEvent($rslLoader:UrlLoader) : void
		{
			$rslLoader.removeEventListener(Event.COMPLETE, rslLoaderHandler);
			$rslLoader.removeEventListener(ProgressEvent.PROGRESS, rslLoaderHandler);
			$rslLoader.removeEventListener(IOErrorEvent.IO_ERROR, rslLoaderHandler);
			$rslLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, rslLoaderHandler);
			return;
		}
		private static function rslLoaderHandler(e:Event) : void
		{
			var rslLoader:UrlLoader = e.currentTarget as UrlLoader;
			
			var ld:LoadData;
			var index:int;
			var keyUrl:String;
			var tempVect:Vector.<LoadData>;
			switch(e.type)
			{
				case Event.COMPLETE:
					//错误url收集
					keyUrl = rslLoader.loadDataGroup.headLoadData.url;
					if(_errorList[keyUrl]==true)
					{
						delete _errorList[keyUrl];
					}
					
					//移除监听
					removeLoadEvent(rslLoader);
					//从加载列表中去掉
					index = waitLoadList.indexOf(rslLoader.loadDataGroup);
					if(index!=-1)
					{
						waitLoadList.splice(index,1);
					}
					//单个回调
					if(rslLoader.loadDataGroup!=null)
					{
						//锁定
						rslLoader.isLocked = true;
						//执行回调
						tempVect = rslLoader.loadDataGroup.loadDataMap.concat();
						for each(ld in tempVect)
						{
							if(ld.onComplete!=null)
							{
								ld.onComplete(ld, e);
							}
						}
						//解锁
						rslLoader.isLocked = false;
					}
					//清除数据
					rslLoader.clear();
					//加载下一个
					loadNext(rslLoader);
					break;
				case ProgressEvent.PROGRESS:
					//单个回调
					if(rslLoader.loadDataGroup!=null)
					{
						//锁定
						rslLoader.isLocked = true;
						//执行回调
						tempVect = rslLoader.loadDataGroup.loadDataMap.concat();
						for each(ld in tempVect)
						{
							if(ld.onUpdate!=null)
							{
								ld.onUpdate(ld, e);
							}
						}
						//解锁
						rslLoader.isLocked = false;
					}
					break;
				case IOErrorEvent.IO_ERROR:
				case SecurityErrorEvent.SECURITY_ERROR:
					ZLog.add("UrlLoaderManager: 尝试"+rslLoader.loadDataGroup.headLoadData.tryCount+"次后，加载"+rslLoader.loadDataGroup.url+"失败");
					
					//错误url收集
					keyUrl = rslLoader.loadDataGroup.headLoadData.url;
					_errorList[keyUrl] = true;
					
					//移除监听
					removeLoadEvent(rslLoader);
					//从加载列表中去掉
					index = waitLoadList.indexOf(rslLoader.loadDataGroup);
					if(index!=-1)
					{
						waitLoadList.splice(index,1);
					}
					//单个回调
					if(rslLoader.loadDataGroup!=null)
					{
						//锁定
						rslLoader.isLocked = true;
						//执行回调
						tempVect = rslLoader.loadDataGroup.loadDataMap.concat();
						for each(ld in tempVect)
						{
							if(ld.onError!=null)
							{
								ld.onError(ld, e);
							}
						}
						//解锁
						rslLoader.isLocked = false;
					}
					//清除数据
					rslLoader.clear();
					//加载下一个
					loadNext(rslLoader);
					break;				
			}
			return;
		}
		//==============================================================================
	}
}