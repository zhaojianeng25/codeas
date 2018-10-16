package tempest.common.rsl.vo
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.system.ApplicationDomain;
	import org.osflash.signals.natives.base.SignalLoader;
	import org.osflash.signals.natives.base.SignalURLLoader;
	import tempest.common.rsl.IRslElement;
	import tempest.common.rsl.RlsSignal;
	import tempest.common.rsl.TRslManager;
	import tempest.core.IDisposable;
	import tempest.utils.ClassUtil;

	public class TRslVO implements IDisposable
	{
		public var loaded:Boolean = false;
		public var ratioLoaded:Number = 0;
		public var content:* = null;
		public var tryNum:int = 3;
		public var key:String;
		public var url:String;
		public var decode:Function;
		public var loader:*;
		public var applicationDomain:ApplicationDomain;
		private var _signals:RlsSignal;
		public var type:String;

		/**
		 *
		 * @param key 名称
		 * @param url 地址
		 * @param moduleType
		 * @param onComplete
		 * @param onProgress
		 * @param onError
		 * @param decode
		 */
		public function TRslVO(key:String, url:String, moduleType:String, decode:Function)
		{
			this.key = key;
			this.url = url;
			this.type = moduleType;
			this.applicationDomain = TRslType.getApplicationDomain(moduleType);
			this.decode = decode;
		}

		public function get signals():RlsSignal
		{
			return _signals ||= new RlsSignal();
		}

		/**
		 * 销毁模块
		 */
		public function dispose():void
		{
			if (this.loader)
			{
				if (this.loader is SignalURLLoader)
				{
					this.loader.close();
				}
				else if (this.loader is SignalLoader)
				{
					this.loader.unloadAndStop(true);
				}
				this.loader.signals.removeAll();
				this.loader = null;
			}
			if (this.content)
			{
				if (this.content is IRslElement)
				{
					IRslElement(this.content).applicationDomain = null;
				}
				if (this.content is IDisposable)
				{
					this.content.dispose();
				}
				if (this.content.parent)
				{
					this.content.parent.removeChild(this.content);
				}
				this.content = null;
			}
			this.applicationDomain = null;
			this.decode = null;
			if (this._signals)
			{
				_signals.removeAll();
				_signals = null;
			}
		}

		/**
		 * 卸载模块
		 */
		public function unload():void
		{
			TRslManager.unload(this.key);
		}

		/**
		 * 获取定义
		 * @param name
		 * @return
		 */
		public function getDefinition(name:String):Object
		{
			if (!this.applicationDomain.hasDefinition(name))
			{
				throw new Error("getDefinition:定义不存在 className:" + name + " rslName:" + this.key);
			}
			return this.applicationDomain.getDefinition(name);
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

		public function toString():String
		{
			return this.key;
		}
	}
}
