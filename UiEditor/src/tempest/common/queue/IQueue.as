package tempest.common.queue
{
	import flash.events.IEventDispatcher;
	import tempest.core.IDisposable;

	public interface IQueue extends IEventDispatcher, IDisposable
	{
		function start():void
		function enqueue(queue:IQueue, executeNow:Boolean = true):void;
		function execute():void;
		function executeNext():void;
	}
}
