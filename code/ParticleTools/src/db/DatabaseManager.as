package db
{
	import com.maclema.mysql.Connection;
	import com.maclema.mysql.events.MySqlErrorEvent;
	import com.maclema.mysql.events.MySqlEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SQLErrorEvent;
	
	/**
	 *	数据库管理 
	 * @author gaojiren
	 * 
	 */	
	public class DatabaseManager extends EventDispatcher
	{
		private var _conn:Connection ;
		private var _connectionHandler:Function;
		private var _onClose:Function;
		
		private var dbutils:DatabaseUtils;
		
		/**
		 * 构造方法
		 * @param conn		数据库连接connection
		 */
		public function DatabaseManager(conn:Connection)
		{
			_conn = conn;
		}
		
		
		/**
		 * 
		 * @param connectionHandler		数据库链接成功回调函数()
		 * @param onClose						数据库连接关闭()
		 * @param connectFailure			数据库连接失败(e:Error)
		 */		
		public function connect(connectionHandler:Function = null , onClose:Function = null ,connectFailure:Function=null):void
		{
			_connectionHandler = connectionHandler;
			_onClose = onClose;
			
			_conn.addEventListener(Event.CONNECT ,onConnection);
			_conn.addEventListener(Event.CLOSE , onDbClose);
			_conn.addEventListener(MySqlErrorEvent.SQL_ERROR,function(e:Event):void{
				if(connectFailure != null)
					connectFailure();
			});
			_conn.connect();
		}
		
		
		/**
		 *	关闭数据库连接 
		 */		
		public function disConnect():void{
			_conn.disconnect();
		}
		
		
		
		/**
		 *	数据库表的查询， 成功则返回结果集，失败返回error
		 * @param sql  需执行的SQL语句
		 * @param queryHandler  回调方法(rs:ResultSet)
		 * @param errorHandler	失败回调(err:String)
		 */		
		public function executeQuery(sql:String , queryHandler:Function , errorHandler:Function = null):void
		{
			//dbutils.execute(sql,true,queryHandler,errorHandler);
			var dbut:DatabaseUtils = new DatabaseUtils(_conn);
			dbut.execute(sql,true,queryHandler,errorHandler);
		}
		
		
		/**
		 * 数据库 增 、删 、改的操作
		 * @param sql	需执行的SQL语句
		 * @param updateHandler	回调方法()
		 * @param errerHandler	失败回调(e:error)
		 * 
		 */
		public function executeUpdate(sql:String , updateHandler:Function , errerHandler:Function=null):void
		{
			var dbut:DatabaseUtils = new DatabaseUtils(_conn);
			dbut.execute(sql,false,updateHandler,errerHandler);
		}
		
		
/************↑公共方法方法↑********************************************************************/
		private function onConnection(e:Event):void{
			_connectionHandler();
			dbutils = new DatabaseUtils(_conn);
		}
		
		private function onDbClose(e:Event):void{
			_onClose();
		}
	}
}