package tempest.common.staticdata
{

	public class Access
	{
		public static const WRITE_ONLY:int = 1 << 0;
		public static const READ_WRITE:int = 1 << 1;
		public static const READ_ONLY:int = 1 << 2;
		public static const ALL:int = 7;
	}
}
