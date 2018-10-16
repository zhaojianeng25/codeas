package _Pan3D.load
{

	/**
	 * 加载信息
	 * @author liuyanfei  QQ: 421537900
	 */
	public class LoadInfo
	{
		public static const XML:String = 'xml';
		public static const BITMAP:String = 'bitmap';
		public static const MOVIE:String = 'movie';
		public static const BYTE:String = 'byte';
		
		/**
		 * 路径 
		 */		
		public var url:String;
		/**
		 * 类型 
		 */		
		public var type:String;
		/**
		 * 回调函数 
		 */		
		public var fun:Function;
		/**
		 * 加载失败回调 
		 */		
		public var errorFun:Function;
		public var showProgress:Boolean;
		/**
		 * 回调信息 
		 */		
		public var info:Object;
		/**
		 * 优先级 
		 */		
		public var priority:int;
		/**
		 * 取消加载标记 
		 */		
		public var cancel:Boolean;
		
		public function LoadInfo(url:String,type:String,fun:Function,$priority:int,info:Object=null,$errorFun:Function=null)
		{
			this.url  = url;
			this.type = type;
			this.fun  = fun;
			//this.showProgress = showProgress;
			this.info = info;
			this.errorFun = $errorFun;
			this.priority = $priority;
		}
		public function toString():String{
			return url + "," + type;
		}
	}
}