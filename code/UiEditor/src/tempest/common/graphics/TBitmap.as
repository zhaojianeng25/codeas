package tempest.common.graphics
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import _as.fla.events.LEC;
	
	import tempest.common.events.TBitmapEvent;
	import tempest.core.IDisposable;

	/**
	 * 支持加载的位图
	 * @author wushangkun
	 */
	public class TBitmap extends Bitmap implements IDisposable, IEventDispatcher
	{
		public var id:String = "";
		public var tag:int = -1;
		public var priority:int = 0;
		private var _loader:Loader;
		private var _remainLoadCount:int;
		private var _url:String;
		private var _dispatcher:IEventDispatcher;
		private var _lec:LEC;

		public function TBitmap(url:String = null, autoLoad:Boolean = false)
		{
			super(null, "auto", false);
			_dispatcher = new EventDispatcher();
			_lec = new LEC();
			_url = url;
			if (autoLoad)
				load();
		}

		public function load(url:String = null):void
		{
			if (url != null)
				_url = url;
			if (_loader == null)
			{
				_remainLoadCount = 3;
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			}
			_loader.load(new URLRequest(_url));
		}

		public function dispose():void
		{
			removeAllListeners();
			_clearLoader();
			if (this.bitmapData)
			{
				this.bitmapData.dispose();
				this.bitmapData = null;
			}
		}

		private function _clearLoader():void
		{
			if (_loader != null)
			{
				_loader.unload();
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				_loader = null;
			}
		}

		private function completeHandler(event:Event):void
		{
			this.bitmapData = Bitmap(LoaderInfo(event.target).content).bitmapData;
			_clearLoader();
			if (_dispatcher.hasEventListener(TBitmapEvent.COMPLETE))
				_dispatcher.dispatchEvent(new TBitmapEvent(TBitmapEvent.COMPLETE, false, false, this));
		}

		private function ioErrorHandler(event:IOErrorEvent):void
		{
			if (_remainLoadCount > 0)
			{
				_remainLoadCount--;
				load();
				return;
			}
			_clearLoader();
			trace("TBitmap加载失败 url:" + _url);
			if (_dispatcher.hasEventListener(TBitmapEvent.ERROR))
				_dispatcher.dispatchEvent(new TBitmapEvent(TBitmapEvent.ERROR, false, false, this, 0, 0, event.text));
		}

		private function progressHandler(event:ProgressEvent):void
		{
			if (_dispatcher.hasEventListener(TBitmapEvent.PROGRESS))
				_dispatcher.dispatchEvent(new TBitmapEvent(TBitmapEvent.PROGRESS, false, false, this, event.bytesLoaded, event.bytesTotal));
		}

		public function removeAllListeners():void
		{
			_lec.removeClusterEvents(LEC.UNCLUSTERED);
		}

		/**
		 * @inheritDoc
		 */
		public override function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			_lec.add(_dispatcher, type, listener, useCapture, priority, useWeakReference);
		}

		/**
		 * @inheritDoc
		 */
		public override function dispatchEvent(event:Event):Boolean
		{
			return _dispatcher.dispatchEvent(event);
		}

		/**
		 * @inheritDoc
		 */
		public override function hasEventListener(type:String):Boolean
		{
			return _dispatcher.hasEventListener(type);
		}

		/**
		 * @inheritDoc
		 */
		public override function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			_lec.remove(_dispatcher, type, listener, useCapture);
		}

		/**
		 * @inheritDoc
		 */
		public override function willTrigger(type:String):Boolean
		{
			return _dispatcher.willTrigger(type);
		}
	}
}
