package tempest.common.net.vo
{

	public class TPacket extends TByteArray
	{
		public var cmd:uint = 0;
		public var len:uint = 0;

		public function TPacket(endian:String = "littleEndian")
		{
			super(endian);
		}

		public function resolve():void
		{
		}

		public override function toString():String
		{
			return "(cmd:" + cmd + " len:" + len + ")\n" + super.toString();
		}
	}
}
