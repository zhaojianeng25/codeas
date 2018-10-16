package tempest.common.obj
{

	public interface ISyncEventRecorder
	{
		function get guid():String;
		function AddListen(index:int, callback:Function, isExecute:Boolean=false):void;
		function removeListene(index:int, callback:Function=null):void;
		function AddListenString(index:int, callback:Function, isExecute:Boolean=false):void;
		function removeListeneString(index:int, callback:Function=null):void;
	}
}
