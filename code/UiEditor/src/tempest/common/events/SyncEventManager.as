package tempest.common.events
{
	import flash.utils.Dictionary;

	import tempest.common.obj.ISyncEventRecorder;
	import tempest.common.staticdata.SyncEventIndexValueType;

	public class SyncEventManager
	{
		private var _events:Dictionary=new Dictionary();
		private var _c:Array=[];

		public function SyncEventManager()
		{
		}

		public function addListenLen(dispatcher:ISyncEventRecorder, startIndex:int, endIndex:int, callback:Function, isExecute:Boolean=false):void
		{
			for (var index:int=startIndex; index <= endIndex; index++)
			{
				addListen(dispatcher, index, callback, isExecute);
			}
		}

		public function addListen(dispatcher:ISyncEventRecorder, index:int, callback:Function, isExecute:Boolean=false):Boolean
		{
			var obj:Object=getObj(dispatcher);
			if (!isEventSet(obj, index, callback))
			{
				obj.count++;
				obj[index][callback]=callback;
				dispatcher.AddListen(index, callback, isExecute);
				_c.push({obj: dispatcher, index: index, callback: callback, type: SyncEventIndexValueType.VALUE_TYPE_NUMBER});
				return true;
			}
			return false;
		}

		public function addListenStringLen(dispatcher:ISyncEventRecorder, startIndex:int, endIndex:int, callback:Function, isExecute:Boolean=false):void
		{
			for (var index:int=startIndex; index <= endIndex; index++)
			{
				addListenString(dispatcher, index, callback, isExecute);
			}
		}


		public function addListenString(dispatcher:ISyncEventRecorder, index:int, callback:Function, isExecute:Boolean=false):Boolean
		{
			var obj:Object=getObj(dispatcher);
			if (!isEventSet(obj, index, callback))
			{
				obj.count++;
				obj[index][callback]=callback;
				dispatcher.AddListenString(index, callback, isExecute);
				_c.push({obj: dispatcher, index: index, callback: callback, type: SyncEventIndexValueType.VALUE_TYPE_STRING});
				return true;
			}
			return false;
		}

		public function removeListenLen(dispatcher:ISyncEventRecorder, startIndex:int, endIndex:int, callback:Function):void
		{
			for (var index:int=startIndex; index <= endIndex; index++)
			{
				removeListen(dispatcher, index, callback);
			}
		}

		public function removeListen(dispatcher:ISyncEventRecorder, index:int, callback:Function):void
		{
			if (hasEventSet(dispatcher, index, callback))
			{
				dispatcher.removeListene(index, callback);
				remove(dispatcher, index, callback);
			}
		}

		public function removeListenStringLen(dispatcher:ISyncEventRecorder, startIndex:int, endIndex:int, callback:Function):void
		{
			for (var index:int=startIndex; index <= endIndex; index++)
			{
				removeListenString(dispatcher, index, callback);
			}
		}

		public function removeListenString(dispatcher:ISyncEventRecorder, index:int, callback:Function):void
		{
			if (hasEventSet(dispatcher, index, callback))
			{
				dispatcher.removeListeneString(index, callback);
				remove(dispatcher, index, callback);
			}
		}

		private function remove(dispatcher:ISyncEventRecorder, index:int, callback:Function):void
		{
			if (hasEventSet(dispatcher, index, callback))
			{
				var obj:Object=getObj(dispatcher);
				obj[index][callback]=null;
				delete obj[index][callback];
				obj.count--;
				if (obj.count <= 0)
				{
					_events[dispatcher]=null;
					delete _events[dispatcher];
				}
			}
		}

		public function removeAll():void
		{
			for each (var obj:Object in _c)
			{
				var dispatcher:ISyncEventRecorder=obj.obj as ISyncEventRecorder;
				switch (obj.type)
				{
					case SyncEventIndexValueType.VALUE_TYPE_NUMBER:
						dispatcher.removeListene(obj.index, obj.callback);
						break;
					case SyncEventIndexValueType.VALUE_TYPE_STRING:
						dispatcher.removeListeneString(obj.index, obj.callback);
						break;
				}
				remove(obj.obj, obj.index, obj.callback);
			}
			_c=[];
		}

		private function getObj(dispatcher:ISyncEventRecorder):Object
		{
			var obj:Object=_events[dispatcher];
			if (obj == null)
			{
				obj={};
				obj.count=0;
				_events[dispatcher]=obj;
			}
			return obj;
		}

		private function isEventSet(obj:Object, index:int, callBack:Function):Boolean
		{
			if (obj[index])
			{
				return Boolean(obj[index][callBack]);
			}
			else
			{
				obj[index]=new Dictionary();
			}
			return false;
		}

		private function hasEventSet(dispatcher:ISyncEventRecorder, index:int, callback:Function):Boolean
		{
			if (_events[dispatcher] == null)
			{
				return false;
			}
			if (_events[dispatcher][index] == null)
			{
				return false;
			}
			return Boolean(_events[dispatcher][index][callback]);
		}
	}
}
