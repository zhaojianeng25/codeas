package _Pan3D.load
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import _me.LogManager;
	
	/**
	 * 加载线程
	 * @author liuyanfei  QQ: 421537900
	 */
	public class LoaderThread extends EventDispatcher
	{
		
		private var _urlloader:URLLoader;
		private var _loader:Loader;
		private var _request:URLRequest;
		private var _loaderInfo:LoadInfo;
		private var _ioerrorTime:int;
		
		public var running:Boolean;
		
		/**
		 * 加载基本线程
		 * */
		public function LoaderThread()
		{
			init();
		}
		private function init():void{
			_urlloader = new URLLoader;
			_urlloader.addEventListener(Event.COMPLETE,onLoadComplete);
			_urlloader.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
			_urlloader.addEventListener(ProgressEvent.PROGRESS,onProgress);
		}
		/**
		 * 开始加载
		 * */
		public function load(loadInfo:LoadInfo):void{
			running = true;
			this._loaderInfo = loadInfo;
			_request = new URLRequest(loadInfo.url);

	
			

			if(loadInfo.type != LoadInfo.XML){
				_urlloader.dataFormat = URLLoaderDataFormat.BINARY;
			}else{
				_urlloader.dataFormat = URLLoaderDataFormat.TEXT;
			}
			_urlloader.load(_request);
		}
		private function onLoadComplete(event:Event):void{
			if(event.target.data is String){
				if(!_loaderInfo.cancel){
					if(this._loaderInfo.info){
						_loaderInfo.fun(event.target.data,this._loaderInfo.info);
					}else{
						_loaderInfo.fun(event.target.data);
					}
				}
				running = false;
				this.dispatchEvent(new Event(Event.COMPLETE));
			}else if(event.target.data is ByteArray){
				if(_loaderInfo.type == LoadInfo.BYTE){
					if(!_loaderInfo.cancel){
						if(this._loaderInfo.info){
							_loaderInfo.fun(event.target.data,this._loaderInfo.info);
						}else{
							_loaderInfo.fun(event.target.data);
						}
					}
					running = false;
					this.dispatchEvent(new Event(Event.COMPLETE));
				}else{
					if(_loader == null){
						_loader = new Loader;
						_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadDataComplete);
					}
					_loader.loadBytes(event.target.data);
				}
			}
		}
		private function onLoadDataComplete(event:Event):void{
			if(!_loaderInfo.cancel){
				if(this._loaderInfo.info != null){
					_loaderInfo.fun(event.target.content,this._loaderInfo.info);
				}else{
					_loaderInfo.fun(event.target.content);
				}
			}
			running = false;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		private function onIOError(event:IOErrorEvent):void{
			trace("加载错误" + decodeURI(String(_loaderInfo)));
			LogManager.getInstance().warn( "加载错误" + _loaderInfo );
			if(Boolean(_loaderInfo.errorFun)){
				if(this._loaderInfo.info)
					_loaderInfo.errorFun(this._loaderInfo.info);
				else
					_loaderInfo.errorFun();
			}
			running = false;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		private function onProgress(event:ProgressEvent):void{
			if(_loaderInfo.showProgress){
				
			}
		}
		
		
	}
}