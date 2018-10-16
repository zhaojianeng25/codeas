package tempest.common.rsl
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import org.osflash.signals.natives.base.SignalLoader;
	import org.osflash.signals.natives.base.SignalURLLoader;
	
	import tempest.common.rsl.vo.TRslType;
	import tempest.common.rsl.vo.TRslVO;
	import tempest.utils.ClassUtil;

	public class TRslManager
	{
		private static var _modules:Object={};

		/**
		 * 加载模块
		 * @param key 名称
		 * @param url 地址
		 * @param moduleType 模块类型
		 * 					TModuleType.LIB
		   TModuleType.MODULE
		   TModuleType.RES
		 * @param onComplete 加载完成回调
		 * @param onProgress 加载进度
		 * @param onError 加载发生错误
		 * @param decode 解压函数 function decode(source:ByteArray):ByteArray
		 * @return
		 */
		public static function load(key:String, url:String, onComplete:Function=null, onProgress:Function=null, onError:Function=null, decode:Function=null, moduleType:String="module"):TRslVO
		{
			var module:TRslVO=_modules[key];
			if (module == null)
			{
				module=new TRslVO(key, url, moduleType, decode);
				_modules[key]=module;
				addEvents(module, onComplete, onProgress, onError);
				loadModule(0, module);
			}
			else
			{
				if (module.key == key && module.url != url)
				{
					throw new Error("模块名重复");
				}
				if (module.loaded)
				{
					if (!(onComplete == null))
					{
						onComplete(module);
					}
				}
				else
				{
					addEvents(module, onComplete, onProgress, onError);
				}
			}
			return module;
		}

		private static function addEvents(module:TRslVO, onComplete:Function=null, onProgress:Function=null, onError:Function=null):void
		{
			if (!(onComplete == null))
			{
				module.signals.complete.addOnce(onComplete);
			}
			if (!(onProgress == null))
			{
				module.signals.progress.add(onProgress);
			}
			if (!(onError == null))
			{
				module.signals.error.addOnce(onError);
			}
		}

		/**
		 *
		 * @param currentNum
		 * @param module
		 */
		private static function loadModule(currentNum:int, module:TRslVO):void
		{
			var $currentNum:int=currentNum;
			var $module:TRslVO=module;
			var onComplete:Function=function(e:Event):void
			{
				var data:ByteArray=e.target.data;
				if (data == null)
				{
					trace("模块数据错误:" + $module.key);
					unload($module.key);
					$module.signals.error.dispatch($module);
					return;
				}
				if ($module.decode != null)
				{
					data=$module.decode(data);
				}
				var $onComplete:Function=function(e:Event):void
				{
					$module.content=e.target.content;
//					Loader($module.loader).unload();
//					$module.loader = null;
					if (!$module.content)
					{
						trace("模块解析失败:" + $module.key);
						unload($module.key);
						$module.signals.error.dispatch($module);
					}
					else
					{
						if ($module.content is IRslElement)
						{
							IRslElement($module.content).applicationDomain=$module.applicationDomain;
						}
						$module.loaded=true;
						$module.signals.complete.dispatch($module);
					}
				}
				var $onError:Function=function(e:Event):void
				{
					trace("模块解析失败:" + $module.key);
					unload($module.key);
					$module.signals.error.dispatch($module);
				}
				var loader:SignalLoader=new SignalLoader();
				var lc:LoaderContext=new LoaderContext(false, $module.applicationDomain, null);
				//AIR特性支持
				if (Capabilities.playerType == "Desktop")
				{
					//AIR禁止跨域
					if ($module.type == TRslType.RES)
					{
						lc.applicationDomain=$module.applicationDomain=new ApplicationDomain(ApplicationDomain.currentDomain);
					}
					if (lc.hasOwnProperty("allowCodeImport"))
					{
						lc["allowCodeImport"]=true;
					}
					if (lc.hasOwnProperty("allowLoadBytesCodeExecution"))
					{
						lc["allowLoadBytesCodeExecution"]=true;
					}
				}
				loader.signals.complete.addOnce($onComplete);
				loader.signals.ioError.addOnce($onError);
				loader.loadBytes(data, lc);
				$module.loader=loader;
			}
			var onProgress:Function=function(e:ProgressEvent):void
			{
				$module.ratioLoaded=e.bytesLoaded / e.bytesTotal;
				$module.signals.progress.dispatch($module);
			}
			var onError:Function=function(e:Event):void
			{
				if ($currentNum > $module.tryNum)
				{
					trace("模块加载失败:" + $module.key);
					unload($module.key);
					$module.signals.error.dispatch($module);
					return;
				}
				loadModule($currentNum, $module);
			}
			$currentNum++;
			var urlLoader:SignalURLLoader=new SignalURLLoader();
			urlLoader.dataFormat=URLLoaderDataFormat.BINARY;
			urlLoader.signals.complete.addOnce(onComplete);
			urlLoader.signals.progress.add(onProgress);
			urlLoader.signals.ioError.addOnce(onError);
			urlLoader.signals.securityError.addOnce(onError);
			urlLoader.load(new URLRequest($module.url));
			$module.loader=urlLoader;
		}

		/**
		 * 加载模块
		 * @param key 名称
		 * @param url 地址
		 * @param moduleType 模块类型
		 * 					TModuleType.LIB
		 TModuleType.MODULE
		 TModuleType.RES
		 * @param onComplete 加载完成回调
		 * @param onProgress 加载进度
		 * @param onError 加载发生错误
		 * @param decode 解压函数 function decode(source:ByteArray):ByteArray
		 * @return
		 */
		public static function loadBytes(key:String, data:ByteArray, onComplete:Function=null, onProgress:Function=null, onError:Function=null, decode:Function=null, moduleType:String="module"):TRslVO
		{
			var module:TRslVO=_modules[key];
			if (module == null)
			{
				module=new TRslVO(key, null, moduleType, decode);
				_modules[key]=module;
				addEvents(module, onComplete, onProgress, onError);
				///
				if (data == null)
				{
					trace("模块数据错误:" + module.key);
					unload(module.key);
					module.signals.error.dispatch(module);
				}
				else
				{
					if (module.decode != null)
					{
						data=module.decode(data);
					}
					var $onComplete:Function=function(e:Event):void
					{
						module.content=e.target.content;
						Loader(module.loader).unload();
						module.loader=null;
						if (!module.content)
						{
							trace("模块解析失败:" + module.key);
							unload(module.key);
							module.signals.error.dispatch(module);
						}
						else
						{
							if (module.content is IRslElement)
							{
								IRslElement(module.content).applicationDomain=module.applicationDomain;
							}
							module.loaded=true;
							module.signals.complete.dispatch(module);
						}
					}
					var $onError:Function=function(e:Event):void
					{
						trace("模块解析失败:" + module.key);
						unload(module.key);
						module.signals.error.dispatch(module);
					}
					var loader:SignalLoader=new SignalLoader();
					var lc:LoaderContext=new LoaderContext(false, module.applicationDomain, null);
					if (Capabilities.playerType == "Desktop")
					{
						if (lc.hasOwnProperty("allowCodeImport"))
						{
							lc["allowCodeImport"]=true;
						}
						if (lc.hasOwnProperty("allowLoadBytesCodeExecution"))
						{
							lc["allowLoadBytesCodeExecution"]=true;
						}
					}
					loader.signals.complete.addOnce($onComplete);
					loader.signals.ioError.addOnce($onError);
					loader.loadBytes(data, lc);
					module.loader=loader;
				}
			}
			else
			{
				if (module.key == key && module.url != null)
				{
					throw new Error("模块名重复");
				}
				if (module.loaded)
				{
					if (!(onComplete == null))
					{
						onComplete(module);
					}
				}
				else
				{
					addEvents(module, onComplete, onProgress, onError);
				}
			}
			return module;
		}

		/**
		 * 卸载指定模块
		 * @param key
		 */
		public static function unload(key:String):void
		{
			var module:TRslVO=_modules[key];
			if (module != null)
			{
				module.dispose();
				_modules[key] == null
				delete _modules[key];
			}
		}

		/**
		 * 卸载所有模块
		 */
		public static function unloadAll():void
		{
			var module:TRslVO;
			for each (module in _modules)
			{
				unload(module.key);
			}
			_modules={};
		}

		/**
		 * 是否存在模块
		 * @param key
		 * @return
		 */
		public static function hasModule(key:String):Boolean
		{
			return !(_modules[key] == null);
		}

		/**
		 * 获取模块
		 * @param key
		 * @return
		 */
		public static function getModule(key:String):TRslVO
		{
			return _modules[key];
		}

		/**
		 * 从指定的应用程序域获取一个公共定义
		 * @param className 类名
		 * @param rslName 模块名
		 * @return
		 */
		public static function getDefinition(className:String, moduleName:String=""):Object
		{
			if (moduleName != "")
			{
				if (!hasModule(moduleName))
				{
					trace("getDefinition:rsl模块不存在 className:" + className + " rslName:" + moduleName);
					return null;
				}
				return getModule(moduleName).getDefinition(className);
			}
			if (!ApplicationDomain.currentDomain.hasDefinition(className))
			{
				throw new Error("getDefinition:定义不存在 className:" + className + " rslName:" + moduleName);
			}
			return ApplicationDomain.currentDomain.getDefinition(className);
		}

		/**
		 * 从指定的应用程序域获取一个公共定义的实例
		 * @param className 类名
		 * @param moduleName 模块名
		 * @param args 构造函数参数
		 * @return
		 */
		public static function getInstance(className:String, moduleName:String="", ... args):*
		{
			return ClassUtil.getInstanceByClass(getDefinition(className, moduleName) as Class, args);
		}
	}
}
