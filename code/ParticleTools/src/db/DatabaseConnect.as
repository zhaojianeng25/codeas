package db
{
	import com.maclema.mysql.Connection;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 *	数据库连接操作 
	 * 
	 */	
	public class DatabaseConnect extends EventDispatcher
	{
		private var _conn:Connection ;
		private var _connectionHandler:Function;
		private var _onClose:Function;
		
		/**
		 * 
		 * @param conn							数据库连接connection
		 * 
		 */
		public function DatabaseConnect(conn:Connection)
		{
			_conn = conn;

		}
		
		
		/**
		 * 
		 * @param connectionHandler		数据库链接成功回调函数(conn:Connection)
		 * @param onFailure						数据库连接失败回调函数(失败原因:String)
		 * 
		 */		
		public function connect(connectionHandler:Function = null , onClose:Function = null):void
		{
			_connectionHandler = connectionHandler;
			_onClose = onClose;
			
			_conn.addEventListener(Event.CONNECT ,onConnection);
			_conn.addEventListener(Event.CLOSE , onDbClose);
			
			_conn.connect();
		}
		
		
		private function onConnection(e:Event):void{
			_connectionHandler(_conn);
		}
		
		private function onDbClose(e:Event):void{
			_onClose();
		}
		
	}
}