package utils
{
	public class FilterStringUtils
	{
		private static var baseChar:String = "abcdefghijklmnopqrstuvwxyz1234567890_-~#$%^&*()+./?";
		private var charCodeAry:Array = new Array;
		public function FilterStringUtils()
		{
			
		}
		
		public static function getErrorName(str:String):Boolean{
			for(var i:int;i<str.length;i++){
				var codeChar:String = str.charAt(i);
				var index:int = baseChar.search(codeChar);
				if(index == -1){
					return true;
				}
			}
			return false;
		}
	}
}