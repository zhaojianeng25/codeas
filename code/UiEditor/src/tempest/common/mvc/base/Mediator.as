package tempest.common.mvc.base
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import _as.fla.events.LEC;

	import org.osflash.signals.IPrioritySignal;
	import org.osflash.signals.ISignal;

	import tempest.common.events.SyncEventManager;
	import tempest.common.mvc.api.IMediatorMap;
	import tempest.common.obj.ISyncEventRecorder;

	public class Mediator
	{
		private var _listens:Dictionary=new Dictionary(true);
		private var _lec:LEC;
		private var _registered:Boolean=false;
		private var _syncEventManager:SyncEventManager;
		internal var $child:IMediatorMap;
		private var _inited:Boolean=false;

		[PostConstruct]
		public final function mediateChildren():void
		{
			var list:Array=this.children;
			if (list)
			{
				var i:int=list.length;
				while (i--)
				{
					mediateChild(list[i]);
				}
			}
		}

		public function Mediator()
		{
		}

		/**第一次执行onRegiter时执行***/
		public function initRegister():void
		{
		}

		public function addSignal(signal:ISignal, listener:Function, priority:int=0, once:Boolean=false):void
		{
			if (_listens[signal])
			{
				return;
			}
			if (priority != 0 && signal is IPrioritySignal)
			{
				if (once)
				{
					IPrioritySignal(signal).addOnceWithPriority(listener, priority);
				}
				else
				{
					IPrioritySignal(signal).addWithPriority(listener, priority);
				}
			}
			else
			{
				if (once)
				{
					signal.addOnce(listener);
				}
				else
				{
					signal.add(listener);
				}
			}
			_listens[signal]=listener;
		}

		protected function get children():Array
		{
			return null;
		}

		protected function mediateChild(child:Object):void
		{
			$child && $child.mediate(child);
		}

		protected function unmediateChild(child:Object):void
		{
			$child && $child.unmediate(child);
		}

		public function removeSignal(signal:ISignal):void
		{
			if (signal)
			{
				var listener:Function=_listens[signal];
				if (listener != null)
				{
					signal.remove(listener);
					_listens[signal]=null;
					delete _listens[signal];
				}
			}
		}

		public function hasSignal(signal:ISignal):Function
		{
			return _listens[signal];
		}

		internal function onPreRegister(over:Boolean=true):void
		{
			if (_registered && over)
			{
				onPreRemove();
			}
			if (!_registered)
			{
				_registered=true;
				if (_inited == false)
				{
					initRegister();
					_inited=true;
				}
				onRegister();
			}
		}

		internal function onPreRemove():void
		{
			if (_registered)
			{
				var obj:Object;
				for (obj in _listens)
				{
					removeSignal(ISignal(obj));
				}
				if (_lec)
				{
					_lec.removeClusterEvents(LEC.UNCLUSTERED);
				}
				removeAllSyncEventListen();
				_registered=false;
				onRemove();
			}
		}

		public function onRegister():void
		{
		}

		public function onRemove():void
		{
		}

		///////////////////////////////
		public function addEventListener(obj:IEventDispatcher, type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			if (_lec == null)
			{
				_lec=new LEC();
			}
			_lec.add(obj, type, listener, useCapture, priority, useWeakReference);
		}

		public function removeEventListener(_obj:*, type:String=null, listener:Function=null, useCapture:Boolean=false):void
		{
			if (_lec)
			{
				_lec.remove(_obj, type, listener, useCapture);
			}
		}

		///////////////////////////////
		private function get syncEventManager():SyncEventManager
		{
			return _syncEventManager||=new SyncEventManager();
		}

		public function addSyncEventListenLen(dispatcher:ISyncEventRecorder, startIndex:int, endIndex:int, callback:Function, isExecute:Boolean=false):void
		{
			syncEventManager.addListenLen(dispatcher, startIndex, endIndex, callback, isExecute);
		}

		public function addSyncEventListen(dispatcher:ISyncEventRecorder, index:int, callback:Function, isExecute:Boolean=false):void
		{
			syncEventManager.addListen(dispatcher, index, callback, isExecute);
		}

		public function addSyncEventListenStringLen(dispatcher:ISyncEventRecorder, startIndex:int, endIndex:int, callback:Function, isExecute:Boolean=false):void
		{
			syncEventManager.addListenStringLen(dispatcher, startIndex, endIndex, callback, isExecute);
		}

		public function addSyncEventListenString(dispatcher:ISyncEventRecorder, index:int, callback:Function, isExecute:Boolean=false):void
		{
			syncEventManager.addListenString(dispatcher, index, callback, isExecute);
		}

		public function removeSyncEventListenLen(dispatcher:ISyncEventRecorder, startIndex:int, endIndex:int, callback:Function):void
		{
			_syncEventManager && syncEventManager.removeListenLen(dispatcher, startIndex, endIndex, callback);
		}

		public function removeSyncEventListen(dispatcher:ISyncEventRecorder, index:int, callback:Function):void
		{
			if (_syncEventManager)
			{
				_syncEventManager.removeListen(dispatcher, index, callback);
			}
		}

		public function removeSyncEventListenStringLen(dispatcher:ISyncEventRecorder, startIndex:int, endIndex:int, callback:Function):void
		{
			if (_syncEventManager)
			{
				_syncEventManager.removeListenStringLen(dispatcher, startIndex, endIndex, callback);
			}
		}

		public function removeSyncEventListenString(dispatcher:ISyncEventRecorder, index:int, callback:Function):void
		{
			if (_syncEventManager)
			{
				_syncEventManager.removeListenString(dispatcher, index, callback);
			}
		}

		public function removeAllSyncEventListen():void
		{
			_syncEventManager && _syncEventManager.removeAll();
		}
	}
}
