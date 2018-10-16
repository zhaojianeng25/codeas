package tempest.common.queue
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import tpe.tpe_internal;

	[Event(name = "start", type = "tempest.common.queue.QueneEvent")]
	[Event(name = "complete", type = "tempest.common.queue.QueneEvent")]
	public class Queue extends EventDispatcher implements IQueue
	{
		public var queues:Array = [];
		public var isRuning:Boolean = false;
		private var current:IQueue;
		tpe_internal var _parent:IQueue;
		use namespace tpe_internal;

		//
		public function get parent():IQueue
		{
			return _parent;
		}
		public var executeNow:Boolean;

		public function Queue()
		{
		}

		public function enqueue(queue:IQueue, executeNow:Boolean = true):void
		{
			queues.push(queue);
			if (executeNow && !isRuning)
			{
				start();
			}
		}

		public function start():void
		{
			if (!isRuning)
			{
				isRuning = true;
				this.executeNext();
			}
		}

		public function execute():void
		{
			this.dispatchEvent(new QueneEvent(QueneEvent.START));
		}

		protected function complete():void
		{
			this.dispatchEvent(new QueneEvent(QueneEvent.COMPLETE));
			this.dispose();
		}

		public function executeNext():void
		{
			if (queues.length != 0)
			{
				current = queues.shift();
				current.addEventListener(QueneEvent.COMPLETE, onCompleteHandler, false, 0, true);
				current.tpe_internal::_parent = this;
				current.execute();
			}
			else
				this.complete();
		}

		private function onCompleteHandler(e:Event):void
		{
			current.removeEventListener(QueneEvent.COMPLETE, onCompleteHandler);
			current = null;
			executeNext();
		}

		public function dispose():void
		{
			if (current)
			{
				current.dispose();
				current.removeEventListener(QueneEvent.COMPLETE, onCompleteHandler);
				current = null;
			}
			_parent = null;
			isRuning = false;
		}

		public function clearAll():void
		{
			isRuning = false;
			if (current)
			{
				current.dispose();
				current.removeEventListener(QueneEvent.COMPLETE, onCompleteHandler);
				current = null;
			}
			queues = [];
		}
	}
}
