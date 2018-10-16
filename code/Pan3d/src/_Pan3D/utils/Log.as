package _Pan3D.utils
{
	import com.zcp.log.ZLog;

	public class Log
	{
		public static var logTime:int = 50;
		public static var traceLog:Boolean = true;
		public static var level:int = 6;
		public function Log()
		{
		}
		public static function add(str:String,showLevel:int=10):void{
//			if(traceLog && showLevel > level){
//				trace(str);
//			}
		}
	}
} 