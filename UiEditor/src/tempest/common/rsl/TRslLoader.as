package tempest.common.rsl
{
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import tempest.common.rsl.vo.TRslType;
	import tempest.core.IDisposable;
	import tempest.utils.ClassUtil;

	public class TRslLoader extends EventDispatcher implements IDisposable
	{
		public var id:String = "";
		public var priority:int = 0;
		private var _urlLoader:URLLoader;
		private var _loader:Loader
		private var _remainLoadCount:int;
		private var _url:String = "";
		private var _type:String;
		private var _decode:Function;
		private var _applicationDomain:ApplicationDomain;
		private var _content:*;

		public function get content():*
		{
			return _content;
		}

		public function TRslLoader(url:String = null, type:String = "res", decode:Function = null)
		{
			_url = url;
			_type = type;
			_applicationDomain = TRslType.getApplicationDomain(type);
			_decode = decode;
		}

		public function load():void
		{
			if (_urlLoader == null)
			{
				_remainLoadCount = 3;
				_urlLoader = new URLLoader();
				_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				_urlLoader.addEventListener(Event.COMPLETE, completeHandler);
				_urlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, ErrorHandler);
				_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ErrorHandler);
			}
			_urlLoader.load(new URLRequest(_url));
		}

		private function progressHandler(event:ProgressEvent):void
		{
			if (hasEventListener(ProgressEvent.PROGRESS))
				dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, event.bytesLoaded, event.bytesTotal));
		}

		private function ErrorHandler(event:ErrorEvent):void
		{
			if (_remainLoadCount > 0)
			{
				_remainLoadCount--;
				load();
				return;
			}
			_clearUrlLoader();
			trace("TRslLoader UrlLoadError url:{0}", _url);
			_createErrorEvent(event.text);
		}

		private function _createErrorEvent(msg:String = ""):void
		{
			if (hasEventListener(ErrorEvent.ERROR))
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, msg));
		}

		private function completeHandler(event:Event):void
		{
			var data:ByteArray = event.target.data;
			_clearUrlLoader();
			if (data == null)
			{
				trace("Urlloader data Error.url:{0}", _url);
				_createErrorEvent("data error");
				return;
			}
			loadBytes(data);
		}

		private function _clearUrlLoader():void
		{
			if (_urlLoader != null)
			{
				_urlLoader.close();
				_urlLoader.removeEventListener(Event.COMPLETE, completeHandler);
				_urlLoader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, ErrorHandler);
				_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ErrorHandler);
				_urlLoader = null;
			}
		}

		public function loadBytes(bytes:ByteArray):void
		{
			if (_decode != null)
			{
				bytes = _decode(bytes);
			}
			var lc:LoaderContext = new LoaderContext(false, _applicationDomain, null);
			//AIR特性支持
			if (Capabilities.playerType == "Desktop")
			{
				//AIR禁止跨域
				if (_type == TRslType.RES)
				{
					lc.applicationDomain = _applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
				}
				if (lc.hasOwnProperty("allowCodeImport"))
				{
					lc["allowCodeImport"] = true;
				}
				if (lc.hasOwnProperty("allowLoadBytesCodeExecution"))
				{
					lc["allowLoadBytesCodeExecution"] = true;
				}
			}
			if (_loader == null)
			{
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler2);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler2);
			}
			_loader.loadBytes(bytes, lc);
		}

		private function completeHandler2(event:Event):void
		{
			_content = event.target.content;
			if (!_content)
			{
				trace("data is empty.url:{0}" + _url);
				dispose();
				_createErrorEvent("data is empty");
			}
			else
			{
				if (_content is IRslElement)
				{
					IRslElement(_content).applicationDomain = _applicationDomain;
				}
				if (hasEventListener(Event.COMPLETE))
					dispatchEvent(new Event(Event.COMPLETE));
			}
		}

		private function ioErrorHandler2(event:IOErrorEvent):void
		{
			_createErrorEvent(event.text);
		}

		private function _clearLoader():void
		{
			if (_urlLoader != null)
			{
				if (_loader != null)
				{
					_loader.unloadAndStop();
					_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler2);
					_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler2);
					_loader = null;
				}
			}
		}

		/**
		 * 获取定义
		 * @param name
		 * @return
		 */
		public function getDefinition(name:String):Object
		{
			if (!_applicationDomain.hasDefinition(name))
			{
				throw new Error("getDefinition Error className:" + name + " url:" + this._url);
			}
			return _applicationDomain.getDefinition(name);
		}

		/**
		 * 从指定的应用程序域获取一个公共定义的实例
		 * @param className 类名
		 * @param args 构造函数参数
		 * @return
		 */
		public function getInstance(className:String, ... args):*
		{
			return ClassUtil.getInstanceByClass(getDefinition(className) as Class, args);
		}

		public function dispose():void
		{
			_clearUrlLoader();
			_clearLoader();
			_applicationDomain = null;
			if (_content)
			{
				if (_content is IRslElement)
				{
					IRslElement(_content).applicationDomain = null;
				}
				if (_content is IDisposable)
				{
					_content.dispose();
				}
				if (_content.parent)
				{
					_content.parent.removeChild(_content);
				}
				_content = null;
			}
		}
	}
}
