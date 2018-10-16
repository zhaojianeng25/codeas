package tempest.common.net
{
	import tempest.common.net.vo.TPacketIn;
	import tempest.core.ISocket;

	public class PacketProcessor implements IPacketProcessor
	{
		private var _handles:Array = [];

		/**
		 * 批量注册处理函数
		 * @param handlers [[opcode,handle],...]
		 */
		public function mapHandles(handles:Array):void
		{
			handles.forEach(function(item:*, index:int, array:Array):void
			{
				mapHandle(item[0], item[1]);
			});
		}

		/**
		 * 批量注册操作码
		 * @param opcodes [opcode,opcode,...]
		 * @param handle
		 */
		public function mapOpcodes(opcodes:Array, handle:Function):void
		{
			opcodes.forEach(function(item:*, index:int, array:Array):void
			{
				mapHandle(item, handle);
			});
		}

		/**
		 * 批量注册处理类
		 * @param opcode
		 * @param handleCls
		 */
		public function mapHandleCls(opcode:int, handleCls:Class):void
		{
			var handle:IPacketHandler = new handleCls();
			if (handle)
			{
				mapHandle(opcode, handle.handPacket);
			}
		}

		/**
		 * 注册处理类
		 * @param handleClses
		 */
		public function mapHandleClses(handleClses:Array):void
		{
			handleClses.forEach(function(item:*, index:int, array:Array):void
			{
				mapHandleCls(item[0], item[1]);
			});
		}

		/**
		 * 注册处理函数
		 * @param opcode 操作码
		 * @param handle 处理函数
		 */
		public function mapHandle(opcode:int, handle:Function):void
		{
			if (_handles[opcode] != null)
			{
				trace("操作码覆盖:{0}", opcode);
			}
			_handles[opcode] = handle;
		}

		/**
		 * 批量取消操作码
		 * @param opcodes[opcode,opcode,...]
		 */
		public function unmapOpcodes(opcodes:Array):void
		{
			opcodes.forEach(function(item:*, index:int, array:Array):void
			{
				unmapHandle(int(item));
			});
		}

		/**
		 * 取消操作码
		 * @param opcode
		 */
		public function unmapHandle(opcode:int):void
		{
			_handles[opcode] = null;
		}

		/**
		 * 取消所有操作码
		 */
		public function unmapAllHandles():void
		{
			_handles = [];
		}

		public function process(socket:ISocket, pk:TPacketIn):void
		{
			//处理封包
			var handler:Function = _handles[pk.cmd];
			if (!(handler == null))
			{
				//处理封包
				handler(socket, pk);
			}
			else
			{
				trace("未处理操作码:{0}", pk.cmd);
			}
		}
	}
}
