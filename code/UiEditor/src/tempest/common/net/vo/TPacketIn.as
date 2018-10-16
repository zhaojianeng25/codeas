package tempest.common.net.vo
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class TPacketIn extends TPacket
	{
		public function TPacketIn(endian:String = "littleEndian")
		{
			super(endian);
		}

		public override function resolve():void
		{
			this.len = this.readUnsignedByte() << 8 | this.readUnsignedByte();
			this.cmd = this.readUnsignedByte() << 8 | this.readUnsignedByte();
		}

		public override function toString():String
		{
			return "TPacketIn" + super.toString();
		}
	}
}
