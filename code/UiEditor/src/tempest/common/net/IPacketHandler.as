package tempest.common.net
{
	import tempest.common.net.vo.TPacketIn;
	import tempest.core.ISocket;

	/**
	 * 封包处理类接口
	 * @author wushangkun
	 */
	public interface IPacketHandler
	{
		function handPacket(socket:ISocket, packet:TPacketIn):void;
	}
}
