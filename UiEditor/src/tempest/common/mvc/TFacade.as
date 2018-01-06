package tempest.common.mvc
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.osflash.signals.IPrioritySignal;
	import org.osflash.signals.PrioritySignal;
	import tempest.common.mvc.api.ICommandMap;
	import tempest.common.mvc.api.IInjector;
	import tempest.common.mvc.api.IMediatorMap;
	import tempest.common.mvc.api.ITConfig;
	import tempest.common.mvc.api.ITExtension;
	import tempest.common.mvc.api.ITFacade;
	import tempest.common.mvc.api.ITLifecycle;
	import tempest.common.mvc.base.CommandMap;
	import tempest.common.mvc.base.MediatorMap;
	import tempest.common.mvc.base.TLifecycle;
	import tempest.common.mvc.base.TPInjector;

	public class TFacade implements ITFacade
	{
		private var _startupSignal:IPrioritySignal;
		private var _shutdownSignal:IPrioritySignal;
		private var _commandMap:ICommandMap;
		private var _mediatorMap:MediatorMap;
		private var _injector:IInjector;
		private var _eventDispatcher:IEventDispatcher;
		private var _logger:ILogger;

		public function get logger():ILogger
		{
			return _logger;
		}
		private var _lifecycle:ITLifecycle;
		private var _children:Array=[];
		private var _configs:Array=[];
		private var _extensions:Array=[];
		private var _inited:Boolean=false;
		private var _destroyed:Boolean=false;

		public function TFacade()
		{
			setup();
		}

		private function setup():void
		{
			//初始化
			_lifecycle=new TLifecycle();
			_injector=new TPInjector();
			_injector.map(IInjector).toValue(_injector);
			_injector.map(ITFacade).toValue(this);
			_logger=getLogger(this);
			_injector.map(ILogger).toValue(_logger);
			_eventDispatcher=new EventDispatcher();
			_injector.map(IEventDispatcher).toValue(_eventDispatcher);
			_commandMap=new CommandMap(this, _eventDispatcher);
			_injector.map(ICommandMap).toValue(_commandMap);
			_mediatorMap=new MediatorMap(this);
			_injector.map(IMediatorMap).toValue(_mediatorMap);
		}

		public final function get injector():IInjector
		{
			return _injector;
		}

		[Deprecated]
		public function get shutdownSignal():IPrioritySignal
		{
			return _shutdownSignal||=new PrioritySignal();
		}

//		[Deprecated]
		public function get startupSignal():IPrioritySignal
		{
			return _startupSignal||=new PrioritySignal();
		}

//		[Deprecated]
		protected function startup():void
		{
		}

//		[Deprecated]
		protected function showdown():void
		{
		}

		public final function get commandMap():ICommandMap
		{
			return _commandMap;
		}

		public final function get mediatorMap():MediatorMap
		{
			return _mediatorMap;
		}

		public final function get lifecycle():ITLifecycle
		{
			return _lifecycle;
		}

		public final function afterDestroying(handler:Function):ITFacade
		{
			_lifecycle.afterDestroying(handler);
			return this;
		}

		public final function afterInitializing(handler:Function):ITFacade
		{
			_lifecycle.afterInitializing(handler);
			return this;
		}

		public final function beforeDestroying(handler:Function):ITFacade
		{
			_lifecycle.beforeDestroying(handler);
			return this;
		}

		public final function beforeInitializing(handler:Function):ITFacade
		{
			_lifecycle.beforeInitializing(handler);
			return this;
		}

		public final function destroy():void
		{
			if (!_inited || _destroyed)
				return;
			//销毁之前
			_lifecycle.onBeforeDestroying.dispatch(this);
//			_logger.debug("destroying.");
			//TODO:兼容
			_shutdownSignal && _shutdownSignal.dispatch();
			showdown();
			//销毁子对象
			removeChildren();
			_commandMap && _commandMap.unmapAll();
			_mediatorMap && _mediatorMap.unmapAll();
			_injector && _injector.teardown();
//			_logger.debug("destroyed.");
			_lifecycle.onAfterDestroying.dispatch(this);
			//销毁事件
			_lifecycle.destroy();
			_lifecycle=null;
			_mediatorMap=null;
			_commandMap=null;
			_eventDispatcher=null;
			_injector=null;
			_logger=null;
			_inited=false;
			_destroyed=true;
		}

		public final function initialize(target:DisplayObject=null):ITFacade
		{
			if (_inited || _destroyed)
				return this;
			if (target)
			{
				var type:Class=target["constructor"];
				if (injector.hasMapping(type))
					throw new Error(type + " has been mapped!");
				injector.map(type).toValue(target);
				if (target.stage)
				{
					initialize();
					target.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage, false, 0, true);
				}
				else
				{
					target.addEventListener(Event.ADDED_TO_STAGE, onAddToStage, false, 0, true);
				}
			}
			else
			{
				//初始化之前
				_lifecycle.onBeforeInitializing.dispatch(this);
//				_logger.debug("initializing.");
				//
				//安装插件
				var extension:ITExtension;
				for each (var extensionCls:String in _extensions)
				{
//					_logger.debug(extensionCls + " installing");
					extension=new (getDefinitionByName(extensionCls) as Class)();
					extension.install(this);
//					_logger.debug(extensionCls + " installed");
				}
				//安装配置文件
				var config:ITConfig;
				for each (var configCls:String in _configs)
				{
//					_logger.debug(configCls + " configuring");
					config=new (getDefinitionByName(configCls) as Class)();
					_injector.injectInto(config);
					config.configure();
//					_logger.debug(configCls + " configured");
				}
				_inited=true;
				//TODO:兼容
				startup();
//				_logger.debug("initialized.");
				//初始化结束
				_lifecycle.onAfterInitializing.dispatch(this);
			}
			return this;
		}

		private function onAddToStage(e:Event):void
		{
//			e.currentTarget.removeEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			e.currentTarget.addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage, false, 0, true);
			initialize();
		}

		private function onRemoveFromStage(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
//			e.currentTarget.addEventListener(Event.ADDED_TO_STAGE, onAddToStage, false, 0, true);
			destroy();
		}

		public final function configure(... configs):ITFacade
		{
			if (_inited)
				throw new Error("facade has been inited!");
			var key:String;
			for each (var configCls:Class in configs)
			{
				key=getQualifiedClassName(configCls);
				if (_configs.indexOf(key) == -1)
				{
					_configs.push(key);
				}
			}
			return this;
		}

		public final function install(... extensions):ITFacade
		{
			if (_inited)
				throw new Error("facade has been inited!");
			var key:String;
			for each (var _extensionsCls:Class in extensions)
			{
				key=getQualifiedClassName(_extensionsCls);
				if (_extensions.indexOf(key) == -1)
				{
					_extensions.push(key);
				}
			}
			return this;
		}

		public final function addChild(child:ITFacade):ITFacade
		{
			if (_children.indexOf(child) == -1)
			{
//				_logger.info("Adding child context {0}", [child]);
//				if (!child.uninitialized) {
//					_logger.warn("Child context {0} must be uninitialized", [child]);
//				}
				if (child.injector.parent)
				{
//					_logger.warn("Child context {0} must not have a parent Injector", [child]);
				}
				_children.push(child);
				child.injector.parent=injector;
				child.lifecycle.afterDestroying(onChildDestroy);
//				child.addEventListener(LifecycleEvent.POST_DESTROY, onChildDestroy);
			}
			return this;
		}

		public final function removeChild(child:ITFacade):ITFacade
		{
			const childIndex:int=_children.indexOf(child);
			if (childIndex > -1)
			{
//				_logger.info("Removing child context {0}", [child]);
				_children.splice(childIndex, 1);
				child.injector.parent=null;
				child.lifecycle.onAfterDestroying.remove(onChildDestroy);
//				child.removeEventListener(LifecycleEvent.POST_DESTROY, onChildDestroy);
			}
			else
			{
//				_logger.warn("Child context {0} must be a child of {1}", [child, this]);
			}
			return this;
		}

		private final function onChildDestroy(child:ITFacade):void
		{
			removeChild(child);
		}

		private final function removeChildren():void
		{
			for each (var child:ITFacade in _children.concat())
			{
				removeChild(child);
			}
			_children.splice(0);
		}
	}
}
