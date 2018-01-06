package tempest.common.net.vo
{

	public class TPacketOut extends TPacket
	{
		/**
		 * 覆盖相同包
		 */
		public var overlay:Boolean;
		/**
		 * 直接发送
		 */
		public var direct:Boolean;

		public function TPacketOut(cmd:uint = 0, overlay:Boolean = true, direct:Boolean = true, endian:String = "littleEndian")
		{
			super(endian);
			this.overlay = overlay;
			this.direct = direct;
			this.cmd = cmd;
			this.writeShort(0x00); //长度
			this.writeShort(0x00); //代码
		}

		public override function resolve():void
		{
			this.len = this.length;
			this.position = 0;
			this.writeShort(this.len);
			this.writeShort(this.cmd);
			this.position = 0;
		}

		public override function toString():String
		{
			return "TPacketOut" + super.toString();
		}
	}
}
