package tempest.common.mvc.base
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.events.IEventDispatcher;

	import org.as3commons.logging.api.ILogger;

	import tempest.common.mvc.api.IInjector;
	import tempest.common.mvc.api.IMediatorMap;
	import tempest.common.mvc.api.IMediatorMapper;
	import tempest.common.mvc.api.ITFacade;

	public class MediatorMapper implements IMediatorMapper
	{
		private var _injector:IInjector;
		private var _logger:ILogger;
		private var _objCls:Class;
		private var _mediatorCls:Class;
		private var _autoType:int=0;
		private var _over:Boolean=true;
		private var _mediator:Mediator;
		private var _facade:ITFacade;
		private var _child:IMediatorMap;

		public function get mediator():Mediator
		{
			return _mediator;
		}
		private var _obj:Object=null;

		public function MediatorMapper(objCls:Class, injector:IInjector, logger:ILogger, facade:ITFacade)
		{
			_objCls=objCls;
			_injector=injector.createChild();
			_logger=logger;
			_facade=facade;
		}

		public function destroy():void
		{
			if (_child)
			{
				_child["destroy"]();
				_child=null;
			}
			destroyMediator();
			_logger=null;
			_objCls=null;
			_mediatorCls=null;
			_injector.parent=null;
			_injector=null;
			_facade=null;
		}

		public function toMediator(mediatorCls:Class, autoType:int=AutoType.ADD_REMOVE, over:Boolean=false):MediatorMapper
		{
			if (_mediatorCls && _mediatorCls != mediatorCls)
			{
				destroyMediator();
				_mediatorCls=null;
			}
			if (!_mediatorCls)
			{
				_mediatorCls=mediatorCls;
				_autoType=autoType;
				_over=over;
			}
			return this;
		}

		public function withChild(obj:Class, mediatorCls:Class, autoType:int=3, over:Boolean=false):MediatorMapper
		{
			_child||=new MediatorMap(_facade);
			_child.map_(obj).toMediator(mediatorCls, autoType, over);
			return this;
		}

		public function createMediator(obj:Object):MediatorMapper
		{
			//如果实例改变  销毁原来的实例
			if (_mediator && obj != _obj)
			{
				destroyMediator();
			}
			if (!_mediator)
			{
				_obj=obj;
				var hasInject:Boolean=false;
				if (!_injector.hasMapping(_objCls))
				{
					_injector.map(_objCls).toValue(obj);
					hasInject=true;
				}
				_mediator=_injector.getOrCreateNewInstance(_mediatorCls);
				_mediator.$child=_child;
				hasInject && _injector.unmap(_objCls);
				if (_obj is DisplayObject)
				{
					IEventDispatcher(_obj).addEventListener("__refresh", onRefresh);
					if (_autoType & AutoType.SHOW_HIDE)
					{
						IEventDispatcher(_obj).addEventListener("show", onShow);
						IEventDispatcher(_obj).addEventListener("hide", onHide);
					}
					if (_autoType & AutoType.ADD_REMOVE)
					{
						IEventDispatcher(_obj).addEventListener(Event.ADDED_TO_STAGE, onShow);
						IEventDispatcher(_obj).addEventListener(Event.REMOVED_FROM_STAGE, onHide);
					}
					onShow(null);
					if (_child)
					{
						IEventDispatcher(_obj).addEventListener(Event.ADDED, childAdded);
						IEventDispatcher(_obj).addEventListener(Event.REMOVED, childRemoved);
						//对子组件处理一次
						processChild(_obj as DisplayObjectContainer);
					}
				}
			}
			return this;
		}

		private function processChild(displayObjectContainer:DisplayObjectContainer):void
		{
			if (displayObjectContainer && displayObjectContainer.numChildren)
			{
				var n:int=displayObjectContainer.numChildren;
				var displayObject:DisplayObject;
				for (var i:int=0; i != n; i++)
				{
					displayObject=displayObjectContainer.getChildAt(i);
					_child.proccess(displayObject);
					processChild(displayObject as DisplayObjectContainer);
				}
			}
		}

		private function childAdded(e:Event):void
		{
			if (e.target != _obj)
			{
				_child.mediate(e.target);
			}
		}

		private function childRemoved(e:Event):void
		{
			if (e.target != _obj)
			{
				_child.unmediate(e.target);
			}
		}

		public function destroyMediator():void
		{
			if (_mediator)
			{
				if (_obj is DisplayObject)
				{
					IEventDispatcher(_obj).removeEventListener("__refresh", onRefresh);
					if (_autoType & AutoType.ADD_REMOVE)
					{
						IEventDispatcher(_obj).removeEventListener(Event.ADDED_TO_STAGE, onShow);
						IEventDispatcher(_obj).removeEventListener(Event.REMOVED_FROM_STAGE, onHide);
					}
					if (_autoType & AutoType.SHOW_HIDE)
					{
						IEventDispatcher(_obj).removeEventListener("show", onShow);
						IEventDispatcher(_obj).removeEventListener("hide", onHide);
					}
					if (_child)
					{
						IEventDispatcher(_obj).removeEventListener(Event.ADDED, childAdded);
						IEventDispatcher(_obj).removeEventListener(Event.REMOVED, childRemoved);
					}
					_obj=null;
				}
				onHide(null);
				_injector.destroyInstance(_mediator);
				_mediator.$child=null;
				_mediator=null;
			}
		}

		private function onRefresh(e:Event):void
		{
			onShow(null, true);
		}

		internal function onShow(e:Event=null, __over:Boolean=false):void
		{
			if (_mediator)
			{
				if (_autoType != AutoType.NONE)
				{
					if (!_obj.stage)
					{
						return;
					}
					if ((_autoType & AutoType.SHOW_HIDE) && !_obj["visible"])
					{
						return;
					}
				}
				_mediator.onPreRegister(_over || __over);
			}
		}

		internal function onHide(e:Event=null):void
		{
			_mediator && _mediator.onPreRemove();
		}
	}
}
