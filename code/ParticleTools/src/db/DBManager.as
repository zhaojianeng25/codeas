package db
{
	import com.maclema.mysql.Connection;
	import com.maclema.mysql.ResultSet;
	import com.zcp.events.BaseEvent;
	
	import flash.events.EventDispatcher;

	public class DBManager  extends EventDispatcher
	{
		private var conn:Connection; 
		private var dbmanager:DatabaseManager;
		
		private var dbIP:String;
		private var dbPort:int;
		private var dbname:String;
		private var username:String;
		private var password:String;
		
		public static const ConnectEvent:String = "DB_CONNECT_EVENT";
		
		public static const QueryResultEvent:String = "Query_Result_Event";
		
		public var isConnected:Boolean = false;
		
		private static var _instance:DBManager;
		
		public function DBManager()
		{
			super();
		}
		
		public static function getInstance():DBManager{
			if(!_instance){
				_instance = new DBManager;
			}
			return _instance;
		}
		
		/**
		 * 连接数据库 
		 * 
		 */		
		public function connect(ip:String, port:int, db:String, user:String, pass:String) : void
		{
			dbIP = ip;
			dbPort = port;
			dbname = db;
			username = user;
			password = pass;
			
			conn= new Connection(ip, port, user, pass, db);
			dbmanager = new DatabaseManager(conn);
			dbmanager.connect(onConnectSuccess, onDisconnect, onConnectFailed);
		}
		/**
		 * 关闭数据库连接 
		 * 
		 */		
		public function disConnect():void{
			dbmanager.disConnect();
		}
		
		private function onConnectSuccess():void
		{
			trace("数据库已连接!");
			isConnected = true;
			this.dispatchEvent(new BaseEvent(ConnectEvent, "", 1));
		}
		
		private function onDisconnect():void
		{
			trace("数据库已断开连接!");
			isConnected = false;
			this.dispatchEvent(new BaseEvent(ConnectEvent, "", 2));
		}
		
		private function onConnectFailed():void
		{
			trace("数据库无法连接，请与管理员联系。");
			isConnected = false;
			this.dispatchEvent(new BaseEvent(ConnectEvent, "", 3));
		}
		
		public function query(sql:String):void{
			if(dbmanager == null)return;
			dbmanager.executeQuery(sql, onQuerySuccess, onQueryError);
		}
		//推荐使用
		public function executeQuery(sql:String, queryHandler:Function, errorHandler:Function):Boolean
		{
			if(dbmanager == null || !isConnected ) return false;
			dbmanager.executeQuery(sql, queryHandler, errorHandler);
			return true;
		}
		/**
		 * 数据查询成功 
		 * @param rs
		 * 
		 */		
		private function onQuerySuccess(rs:ResultSet):void
		{
			this.dispatchEvent(new BaseEvent(QueryResultEvent, "ok", rs));	
		}
		/**
		 * 数据查询失败
		 * @param err
		 * 
		 */		
		private function onQueryError(err:Error):void
		{
			var errMessage:String = "错误ID："+err.errorID+" , 错误消息："+err.message;
			this.dispatchEvent(new BaseEvent(QueryResultEvent, "err", null));
		}
		
		public function executeUpdate(sql:String, queryHandler:Function, errorHandler:Function):Boolean
		{
			if(dbmanager == null || !isConnected ) return false;
			dbmanager.executeUpdate(sql, queryHandler, errorHandler);
			return true;
		}
		
		
		
	}//end of class
}