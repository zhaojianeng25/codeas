package tempest.common.net
{
	import tempest.common.net.vo.TPacketIn;
	import tempest.core.ISocket;

	public interface IPacketProcessor
	{
		function mapHandles(handles:Array):void;
		function mapOpcodes(opcodes:Array, handle:Function):void;
		function mapHandleCls(opcode:int, handleCls:Class):void;
		function mapHandleClses(handleClses:Array):void;
		function mapHandle(opcode:int, handle:Function):void;
		function unmapOpcodes(opcodes:Array):void;
		function unmapHandle(opcode:int):void;
		function unmapAllHandles():void;
		function process(socket:ISocket, pk:TPacketIn):void;
	}
}
