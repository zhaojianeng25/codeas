package tempest.utils
{

	public final class RegexUtil
	{
		public static const Letter:String="a-zA-Z";
		public static const Number:String="0-9";
		public static const Chinese:String="\u4e00-\u9fa5";
		public static const Vietnamese:String="\u00C0-\u1EF9";
		public static const Japanese:String="\u0800-\u4e00";
		public static const Korean:String="\uAC00-\uD7A3";
		public static const Space:String="\\s";
		public static const NameReg:RegExp=/[^0-9a-zA-Z\u4e00-\u9fa5]+/;
		public static const StrPattern2:RegExp=/{.*?}/g;
		public static const EndLine:RegExp=/\\n/g;
	}
}
