package tempest.common.mvc.api
{
	import flash.events.IEventDispatcher;

	import org.osflash.signals.ISignal;

	import tempest.common.obj.ISyncEventRecorder;

	public interface ICommandMap
	{
		function get facade():ITFacade;
		function map(signals:Array, commandCls:Class, once:Boolean=false, priority:int=0):void;
		function mapEvent(type:String, eventCls:Class, eventDispatcher:IEventDispatcher=null):ICommandMapper
		function unmap(signal:ISignal):void;
		function unmapAll():void;
		function mapSignal(signalClass:Class, name:String=""):ICommandMapper;
//		function mapSyncEventListen(valueIndex:int, dispatcher:ISyncEventRecorder):ICommandMapper;
//		function mapSyncEventListenString(valueIndex:int, dispatcher:ISyncEventRecorder):ICommandMapper;
		function unmap_(signalClass:Class, name:String=""):void;
//		function unmapSyncEvent_(guid:String, valueIndex:int):void;
	}
}
